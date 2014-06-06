" HiCurLine : an attempt to highlight matching brackets as one moves
"  Author:  Charles E. Campbell, Jr.
"  Date:    Mar 01, 2006
"  Version: 7k	ASTRO-ONLY
"
" A Vim v6.0 plugin with menus for gvim
"
" GetLatestVimScripts: 555 1 :AutoInstall: HiCurLine.vim
" GetLatestVimScripts: 1066 1 cecutil.vim
" Usage: {{{1
"   \hcli : initialize highlighting of matching bracket
"   \hcls : stop       highlighting of matching bracket
"
"   Actually <Leader> is used, so you may set mapleader to change
"   the leading backslash to whatever you want in your <.vimrc>
"
" Method: {{{1
"	This script attempts to intercept most motion commands
"   and to to use the "match" command to highlight the current
"   line.  The HL_HiCurLine variable may be set by the user
"   to any highlighting group.  If no such variable is set,
"   then the Search highlighting group will be used.  Any
"   maps already assigned to the motion command keys will be
"   saved by \hcli and restored by \hcls.
"
"     Example: (of something that could be put into a <.vimrc>)
"       hi HL_HiCurLine ctermfg=blue ctermbg=cyan guifg=blue guibg=cyan
"		let HL_HiCurLine= "HL_HiCurLine"

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_HiCurLine")
 finish
endif
let s:keepcpo= &cpo
set cpo&vim
let g:loaded_HiCurLine= "v7k"
if exists("g:himtchbrkt_ut") && !exists("g:hicurline_ut")
 let g:hicurline_ut= g:himtchbrkt_ut
endif
if v:version >= 700 && exists("##CursorMoved")
 let g:loaded_matchparen= 1
endif

" ---------------------------------------------------------------------
" Public Interface: {{{1
if !hasmapto('<Plug>HCLStart')
 map <unique> <Leader>hcli	<Plug>HCLStart
endif
if !hasmapto('<Plug>HCLStop')
 map <unique> <Leader>hcls	<Plug>HCLStop
endif
if !hasmapto('<Plug>HCLToggle')
 map <unique> <Leader>hclt	<Plug>HCLToggle
endif
com! HCLstart   set lz|call <SID>HCLStart()|set nolz
com! HCLstop    set lz|call <SID>HCLStop()|set nolz
com! HCL        set lz|call <SID>HCLToggle()|set nolz

" ---------------------------------------------------------------------
" Global Maps: {{{2
nmap <silent> <unique> <script> <Plug>HCLStart  :set lz<CR>:call <SID>HCLStart()<CR>:set nolz<CR>
nmap <silent> <unique> <script> <Plug>HCLStop   :set lz<CR>:call <SID>HCLStop()<CR>:set nolz<CR>
nmap <silent> <unique> <script> <Plug>HCLToggle :set lz<bar>if exists("b:dohicurline")<bar>call <SID>HCLStop()<bar>else<bar>call <SID>HCLStart()<bar>endif<bar>set nolz<CR>

" ---------------------------------------------------------------------
" DrChip Menu Support: {{{2
if has("menu") && has("gui_running") && &go =~ 'm'
 if !exists("g:DrChipTopLvlMenu")
  let g:DrChipTopLvlMenu= "DrChip."
 endif
 exe 'menu '.g:DrChipTopLvlMenu.'HiCurLine.Start<tab>\\hcli	<Leader>hcli'
endif

" =====================================================================
" Functions: {{{1

" HCLStart: {{{2
fun! <SID>HCLStart()
"  call Dfunc("HCLStart()")
  if exists("b:dohicurline")
"   call Dret("HCLStart : b:dohicurline already exists!")
   return
  endif

  " set up highlighting group for current line
  call s:HCLHighlight()
  augroup HCL_AUGROUP
    au!
    au FocusGained	*	silent call <SID>HCLHighlight()
  augroup END

  if !exists("g:hicurline_nocursorhold") && (!exists("g:hicurline_ut") || g:hicurline_ut != 0)
"   call Decho("set up HCL_AUGROUP (CursorHold,FocusGained) events")
   augroup HCLTimer
    au!
    au CursorHold *	silent call s:HCLHighlight()
    au CursorHold * silent call s:HiCurLine()
   augroup END
  endif

  if exists("b:dohicurline") && b:dohicurline == 1
    " already in HiCurLine mode
    echo "[HiCurLine]"
"    call Dret("HCLStart : already in HiCurLine mode")
    return
  endif
  let b:dohicurline= 1
 
  " Save Maps (if any)
  call SaveUserMaps("n","","<c-b>","HiCurLine")
  call SaveUserMaps("n","","<c-d>","HiCurLine")
  call SaveUserMaps("n","","<c-f>","HiCurLine")
  call SaveUserMaps("n","","<c-u>","HiCurLine")
  call SaveUserMaps("n","","<down>","HiCurLine")
  call SaveUserMaps("n","","<end>","HiCurLine")
  call SaveUserMaps("n","","<home>","HiCurLine")
  call SaveUserMaps("n","","<left>","HiCurLine")
  call SaveUserMaps("n","","<right>","HiCurLine")
  call SaveUserMaps("n","","<up>","HiCurLine")
  call SaveUserMaps("n","","webHMLEBjklh-+G","HiCurLine")
  call SaveUserMaps("i","","<down>","HiCurLine")
  call SaveUserMaps("i","","<end>","HiCurLine")
  call SaveUserMaps("i","","<home>","HiCurLine")
  call SaveUserMaps("i","","<left>","HiCurLine")
  call SaveUserMaps("i","","<right>","HiCurLine")
  call SaveUserMaps("i","","<up>","HiCurLine")
  if has("gui_running") && has("menu")
   call SaveUserMaps("n","","<leftmouse>","HiCurLine")
   call SaveUserMaps("i","","<leftmouse>","HiCurLine")
   call SaveUserMaps("i","","<CR>","HiCurLine")
  endif
 
  " keep and set options
  let b:hicurline_vbkeep      = &vb
  let b:hicurline_t_vbkeep    = &t_vb
  let b:hicurline_utkeep      = &ut
  set vb t_vb=
  if exists ("g:hicurline_ut")
   let &ut= g:hicurline_ut
  else
   " I'd like to set ut even faster, but unfortunately that clears
   " status-line messages before people have a chance to read them
   set ut=2000
  endif
 
  " indicate in HiCurLine mode
  echo "[HiCurLine]"
 
  " Install HiCurLine maps
  if has("gui_running")
   call HCLMapper("<down>" , "<down>" , "<down>")
   call HCLMapper("<up>"   , "<up>"   , "<up>")
   call HCLMapper("<right>", "<right>", "<right>")
   call HCLMapper("<left>" , "<left>" , "<left>")
   call HCLMapper("<home>" , "<home>" , "<home>")
   call HCLMapper("<end>"  , "<end>"  , "<end>")
   call HCLMapper("<space>", "<space>", "")
   call HCLMapper("<cr>"   , "<cr>"   , "<cr>")
  else
   call HCLMapper("<down>"    , "j"    , "<c-o>j"    )
   call HCLMapper("<up>"      , "k"    , "<c-o>k"    )
   call HCLMapper("<right>"   , "l"    , "<c-o>l"    )
   call HCLMapper("<left>"    , "h"    , "<c-o>h"    )
   call HCLMapper("<home>"    , "0"    , "<c-o>0"    )
   call HCLMapper("<end>"     , "$"    , "<c-o>$"    )
   call HCLMapper("<space>"   , "l"    , ""          )
   call HCLMapper("<PageUp>"  , "<c-b>", "<c-o><c-b>")
   call HCLMapper("<PageDown>", "<c-f>", "<c-o><c-f>")
  endif
  if has("gui_running") && has ("mouse")
   call HCLMapper("<leftmouse>","<leftmouse>","<leftmouse>")
  endif
  call HCLMapper("gg", "gg", "")
  call HCLMapper("G" , "G" , "")
  call HCLMapper("w","w","")
  call HCLMapper("b","b","")
  call HCLMapper("B","B","")
  call HCLMapper("e","e","")
  call HCLMapper("E","E","")
  call HCLMapper("H","H","")
  call HCLMapper("M","M","")
  call HCLMapper("L","L","")
  call HCLMapper("j","j","")
  call HCLMapper("k","k","")
  call HCLMapper("l","l","")
  call HCLMapper("h","h","")
  call HCLMapper("%","%","")
  call HCLMapper("-","-","")
  call HCLMapper("+","+","")
  call HCLMapper("<c-f>","<c-f>","")
  call HCLMapper("<c-b>","<c-b>","")
  call HCLMapper("<c-d>","<c-d>","")
  call HCLMapper("<c-u>","<c-u>","")
 
  " Insert stop  HiCurLine into menu
  " Delete start HiCurLine from menu
  if has("gui_running") && has("menu")
   exe 'unmenu '.g:DrChipTopLvlMenu.'HiCurLine.Start'
   exe 'menu '.g:DrChipTopLvlMenu.'HiCurLine.Stop<tab>\\hcls	<Leader>hcls'
  endif
 
  " highlight the current line
  silent call s:HiCurLine()

"  call Dret("HCLStart")
endfun

" ---------------------------------------------------------------------
" HCLStop: {{{2
fun! <SID>HCLStop()
"  call Dfunc("HCLStop()")

  if !exists("b:dohicurline")
"   call Dret("HCLStop : b:dohicurline doesn't exist")
   return
  endif


  " delete the dohicurline variable
  " remove any match
  " remove CursorHold autocmd event
  match none
  augroup HCLTimer
   au!
  augroup END
  silent! augroup! HCLTimer
  augroup HCL_AUGROUP
    au!
  augroup END
  silent! augroup! HCL_AUGROUP

  if !exists("b:dohicurline")
   echo "[HiCurLine off]"
"   call Dfunc("HCLStop : already off")
   return
  else
  unlet b:dohicurline
  endif

  echo "[HiCurLine off]"

  " restore user map(s), if any
  call RestoreUserMaps("HiCurLine")

  " restore user options
  let &vb   = b:hicurline_vbkeep
  let &t_vb = b:hicurline_t_vbkeep
  let &ut   = b:hicurline_utkeep
  unlet b:hicurline_vbkeep
  unlet b:hicurline_t_vbkeep
  unlet b:hicurline_utkeep

  " Insert start HiCurLine into menu
  " Delete stop  HiCurLine from menu
  if has("gui_running") && has("menu")
   exe 'unmenu '.g:DrChipTopLvlMenu.'HiCurLine.Stop'
   exe 'menu '.g:DrChipTopLvlMenu.'HiCurLine.Start<tab>\\hcli	<Leader>hcli'
  endif
"  call Dfunc("HCLStop")
endfun

" ---------------------------------------------------------------------
" HCLMapper: handles mapping the left-hand-side string to {{{2
"  the normal-mode right-hand-side (nrhs) and
"  the insert-mode right-hand-side (irhs).
"  Retains any previously existing maps to these sequences.
fun! HCLMapper(lhs,nrhs,irhs)
"  call Dfunc("HCLMapper(.lhs<".a:lhs."> nrhs<".a:nrhs."> irhs<".a:irhs.">)")

  " overload normal mode mapping
  let rhs= maparg(a:lhs,"n")
"  call Decho("rhs<".rhs.">")
  if rhs == "" | let rhs= a:nrhs | endif
  exe "nno <silent> ".a:lhs." ".rhs.":silent call <SID>HiCurLine()<CR>"
"  call Decho("exe nno <silent> ".a:lhs." ".rhs.":silent call <SID>HiCurLine()<CR>")

  if a:irhs != ""
  " overload insert mode mapping
   let rhs= maparg(a:lhs,"i")
"   call Decho("rhs<".rhs.">")
   if rhs == "" | let rhs= a:irhs | endif
   exe "ino <silent> ".a:lhs." ".rhs."<c-o>:silent call <SID>HiCurLine()<CR>"
"   call Decho("exe ino <silent> ".a:lhs." ".rhs."<c-o>:silent call <SID>HiCurLine()<CR>")
  endif
"  call Dret("HCLMapper")
endfun

" ---------------------------------------------------------------------
" HiCurLine: {{{2
fun! <SID>HiCurLine()
  if exists("b:dohicurline")
   " just making sure that a match isn't activated by a CursorHold
   " after HiCurLine has been "turned off"
   let curline   = line('.')
"   call Dfunc("HiCurLine() curline#".curline)
   exe 'match '.g:HL_HiCurLine.' /\%'.curline.'l/'
"   call Dret("HiCurLine")
  endif
endfun

" ---------------------------------------------------------------------
" HCLHighlight: sets up HL_HiCurLine highlighting {{{2
fun! s:HCLHighlight()
"  call Dfunc("HCLHighlight()")

  if !exists("g:HL_HiCurLine")
   let g:HL_HiCurLine= "HL_HiCurLine"
  endif
  if g:HL_HiCurLine == "HL_HiCurLine" && !s:HLTest("HL_HiCurLine")
   if &bg == "dark"
    hi HL_HiCurLine ctermfg=blue ctermbg=cyan guifg=cyan guibg=blue
   else
    hi HL_HiCurLine ctermbg=blue ctermfg=cyan guibg=cyan guifg=blue
   endif
  endif

"  call Dret("HCLHighlight : g:HL_HiCurLine<".g:HL_HiCurLine.">")
endfun

" ---------------------------------------------------------------------
" HLTest: tests if a highlighting group has been set up {{{2
fun! s:HLTest(hlname)
"  call Dfunc("HLTest(hlname<".a:hlname.">)")

  let id_hlname= hlID(a:hlname)
"  call Decho("hlID(".a:hlname.")=".id_hlname)
  if id_hlname == 0
"   call Dret("HLTest 0")
   return 0
  endif

  let id_trans = synIDtrans(id_hlname)
"  call Decho("id_trans=".id_trans)
  if id_trans == 0
"   call Dret("HLTest 0")
   return 0
  endif

  let fg_hlname= synIDattr(id_trans,"fg")
  let bg_hlname= synIDattr(id_trans,"bg")
"  call Decho("fg_hlname<".fg_hlname."> bg_hlname<".bg_hlname.">")

  if fg_hlname == "" && bg_hlname == ""
"   call Dret("HLTest 0")
   return 0
  endif
"  call Dret("HLTest 1")
  return 1
endfun

" ---------------------------------------------------------------------
"  Auto Startup With HiCurLineOn: {{{1
if exists("g:HiCurLineOn") && g:HiCurLineOn != 0
 if !exists("*SaveUserMaps")
  " due to loading order, <plugin/cecutil.vim> may not have loaded yet.
  " attempt to force a load now.  Ditto for matchit!
  silent! runtime plugin/cecutil.vim
 endif
 silent! runtime plugin/matchit.vim
 silent HCLstart
endif

let &cpo= s:keepcpo
" ---------------------------------------------------------------------
"  vim: fdm=marker
