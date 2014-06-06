map  ,it      :!table-ize.pl<cr>
map! ,it <esc>:!table-ize.pl<cr>i

map  ,a      :call Auto_Tableize()<cr>
map! ,a <esc>:call Auto_Tableize()<cr>i

map  ,wt      :perldo s/\s+$//<cr>
map! ,wt <esc>:perldo s/\s+$//<cr>i

map  ,ial      :w<cr>:r!egrep '\bassert' % \| perl -pe 's/.*\b(assert\w*).*/    $1/' \| sort -u<cr>
map! ,ial <esc>:w<cr>:r!egrep '\bassert' % \| perl -pe 's/.*\b(assert\w*).*/    $1/' \| sort -u<cr>i

vmap ,qwa :Align qw/<cr>gv:Align /;<cr>gv::perldo s/\s+$//<cr>gv::!sort<cr>

vmap ,aas :perldo s/^(\s*)(\w+\.)?(\w+),/$1$2$3 as $3,/<cr>gv:s/ as / ~ /g<cr>gv:Align ~<cr>gv:s/ ~ / as /g<cr>

map ,wp  :perldo s/^(\s*)(\w+)\s*$/$1-$2 => \\my \$$2,/<cr>gv:Align =><cr>
map ,wm  :perldo s/^(\s*)(\w+)\s*$/$1->$2(\$$2)/<cr>gv:Align ( )<cr>gv:perldo s/ +$//<cr>gv:perldo s/( *)\(/($1/<cr>

vmap ,lc          :perldo s/(.*)/lc $1/e<cr>
 map ,lc       viw:perldo s/(.*)/lc $1/e<cr>
map! ,lc  <esc>viw:perldo s/(.*)/lc $1/e<cr>
vmap ,uc          :perldo s/(.*)/uc $1/e<cr>
 map ,uc       viw:perldo s/(.*)/uc $1/e<cr>
map! ,uc  <esc>viw:perldo s/(.*)/uc $1/e<cr>
vmap ,com       :perldo s/^(\s*)(..?)/$1 . $2 eq '# ' ? '' : "# $2"/e<cr>
map  ,com      V:perldo s/^(\s*)(..?)/$1 . $2 eq '# ' ? '' : "# $2"/e<cr>
map! ,com <esc>V:perldo s/^(\s*)(..?)/$1 . $2 eq '# ' ? '' : "# $2"/e<cr>
vmap ,das       :perldo s/^(\s*)(..?.?)/$1 . $2 eq '-- ' ? '' : "-- $2"/e<cr>
map  ,das      V:perldo s/^(\s*)(..?.?)/$1 . $2 eq '-- ' ? '' : "-- $2"/e<cr>
map! ,das <esc>V:perldo s/^(\s*)(..?.?)/$1 . $2 eq '-- ' ? '' : "-- $2"/e<cr>

map ,~w viw~
map ,~l v~

map  ,dt      :perldo s/^(\t+)/'    ' x length $1/e<cr>
map! ,dt <esc>:perldo s/^(\t+)/'    ' x length $1/e<cr>i

map ,tn          VgUVV:s/ /_/g<cr>_4ssub <esc>:s/'//g<cr>
map!,tn     <esc>VgUVV:s/ /_/g<cr>_4ssub <esc>:s/'//g<cr>i
