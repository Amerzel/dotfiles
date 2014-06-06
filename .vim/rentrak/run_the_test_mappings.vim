
map  ,tc      :call RTK_Test("-c")<cr>
map! ,tc <ESC>:call RTK_Test("-c")<cr>

map  ,ts      :call RTK_Test("-s")<cr>
map! ,ts <ESC>:call RTK_Test("-s")<cr>

map  ,t       :call RTK_Test("")<cr>
map! ,t  <ESC>:call RTK_Test("")<cr>

map  ,TC       :call RTK_All_Tests("-c")<cr>
map! ,TC  <ESC>:call RTK_All_Tests("-c")<cr>
map  ,Tc       :call RTK_All_Tests("-c")<cr>
map! ,Tc  <ESC>:call RTK_All_Tests("-c")<cr>

map  ,TS       :call RTK_All_Tests("-s")<cr>
map! ,TS  <ESC>:call RTK_All_Tests("-s")<cr>
map  ,Ts       :call RTK_All_Tests("-s")<cr>
map! ,Ts  <ESC>:call RTK_All_Tests("-s")<cr>

map  ,T       :call RTK_All_Tests("")<cr>
map! ,T  <ESC>:call RTK_All_Tests("")<cr>

"map  <C-C>       :write!<cr>:call GoToTheTest()<cr>:! rtk_test -thc %<cr>
"map! <C-C>  <ESC>:write!<cr>:call GoToTheTest()<cr>:! rtk_test -thc %<cr>

