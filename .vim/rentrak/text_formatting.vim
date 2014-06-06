
function! Auto_Tableize()
perl << CTRLD
        sub _is_part_of_table {
            return $_[0] =~ /^\s*[[({].*\S/
                    || ($_[0] =~ /=>/ && $_[0] !~ /{\s*$/)
                    || $_[0] =~ /^\s*$/;
        }

        sub _first_line_in_table {
            my $first_line = ($curwin->Cursor())[0];
            while ($first_line > 0 && _is_part_of_table($curbuf->Get($first_line))) {
                $first_line--;
            }
            return $first_line + 1;
        }

        sub _last_line_in_table {
            my $last_line = ($curwin->Cursor())[0];
            while ($last_line <= $curbuf->Count() && _is_part_of_table($curbuf->Get($last_line))) {
                $last_line++;
            }
            return $last_line - 1;
        }


        use IPC::Open2;
        local(*INPUT, *OUTPUT);
        open2(\*INPUT, \*OUTPUT,
            'table-ize.pl');
        print OUTPUT join("\n", $curbuf->Get(_first_line_in_table() .. _last_line_in_table())), "\n";
        close OUTPUT;

        chomp(my @formatted = <INPUT>);
        close INPUT;

        $curbuf->Set(_first_line_in_table(), @formatted);
CTRLD
endfunction

call RTKSource('text_formatting_mappings.vim')
