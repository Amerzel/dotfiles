#!/usr/local/bin/linear_perl

use strict;
use AppropriateLibrary 'linear';
use RTK::Util::ReasonableParams;
use Try::Tiny;

use RTK::Util::Misc qw/
    is_one_of
    unique
    any_match
    set_difference
/;

use RTK::Util::Text qw/ trim /;

my @file_blacklist;

my $package_blacklist = [qw/
    RTK::Util::DBI::TEST::PgDBITestUtil
/];

my $exclusions = join('|', qw/
    strict; use base
    base
    vars
    .*?MethodMaker
    constant
    .*Mixin
    POSIX
    RTK::Util::ReasonableParams
    Regexp::Common
/);

my @blocks_to_leave_as_multiline_even_with_one_item = qw/
    Aliases
    FieldTemplates
/;

my $single_line_regex = qr{(^\s*use\s+(?!$exclusions).*\s+qw/)(.*?\s?)(\s*/;.*)};
my $start_regex = qr{^\s*use\s+(?!$exclusions).*\s*qw/\s*$};

my @files = @ARGV;
my $in_mixin_file;

if (@files) {
    for my $file (@files) {
        $in_mixin_file = ($file =~ m/.*\QMixin.pm\E/);
        if (any_match { $_ =~ m/.*\Q$file\E/ } @file_blacklist) {
            warn "file '$file' is blacklisted, and will not be processed";
            next;
        }
        open my $fh, "<", $file;
        my @lines = <$fh>;
        close $fh;
        my $backup_file = "$file.bak";
        `cp $file $backup_file`;
        try {
            open $fh, ">", $file;
            select $fh;
            my $failure = process_and_print_lines(@lines);
            close $fh;
            if ($failure) {
                `rm $file`;
                `mv $backup_file $file`;
            } else {
                `rm $backup_file`;
            }
        } catch {
            `mv $backup_file $file`;
            die "Could not process $file: ".$_;
        }
    }
} else {
    my @lines = <STDIN>;
    process_and_print_lines(@lines);
}

sub process_and_print_lines(@lines)
{
    my @alias_lines;
    my $start_line;

    my $skip_file;

    while (@lines) {
        my $line = shift(@lines);

        if ($line =~ m/^package (.*);/ && is_one_of($1, $package_blacklist)) {
            select;
            warn "Package '$1' is blacklisted, and will not be processed";
            return 1;
        }

        if ($line =~ m{$start_regex}..$line =~ m{/[;,]}) {
            if ($line =~ m{$start_regex}) {
                    $start_line = $line;
            } elsif ($line =~ m{/;}) {
                @alias_lines = sort(unique(grep {trim($_)} @alias_lines));

                my $force_multiline = any_match { $start_line =~ m/$_/ }
                        @blocks_to_leave_as_multiline_even_with_one_item
                ;
                if (@alias_lines > 1 || $force_multiline) {
                    print join ("",
                        $start_line,
                        @alias_lines,
                        $line
                    );
                } elsif (@alias_lines == 1) {
                    my $token = trim($alias_lines[0]);
                    chomp($start_line);
                    print "$start_line $token $line";
                }

                @alias_lines = ();
                $start_line = '';
            } else {
                push @alias_lines, $line
                    if _token_exists_in_rest_of_lines(
                        _cleanup_token(trim($line)),
                        @lines
                    )
                ;
            }
        } elsif ($line =~ m{$single_line_regex}) {
            my $use = $1;
            my @tokens = map { trim($_) } split(' ', trim($2));
            my $end = $3;

            my @original_tokens = @tokens;
            my @tokens = grep {
                _token_exists_in_rest_of_lines(
                    _cleanup_token(trim($_)),
                    @lines
                );
            } grep {trim($_)} @tokens;

            my @unused_tokens = set_difference(\@original_tokens, \@tokens);

            if (scalar(@tokens) > 1) {
                print "$use\n";
                for (sort(unique(@tokens))) {
                    print "    @{[trim($_)]}\n";
                }
                my $end = trim($end);
                print "$end\n";
            } elsif (scalar(@tokens) == 1) {
                my $extra_space = '';

                $extra_space .= ' ' x scalar(@unused_tokens);
                $extra_space .= ' ' x length($_)
                    for @unused_tokens;

                print "$use @tokens$extra_space $end\n";
            }
        } else {
            print $line;
        }
    }
}


sub _cleanup_token($token)
{
    $token =~ s/.*:://;
    $token =~ s/^[\$%@]//;
    return $token;
}

sub _token_exists_in_rest_of_lines($token, @lines)
{
    return 1 if $in_mixin_file;
    any_match {
        $token =~ m/^:.*/ || $_ =~ m/\b\Q$token\E\b/
    } @lines
}
