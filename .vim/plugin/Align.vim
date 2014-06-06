" Align: tool to align multiple fields based on one or more separators
"   Author:		Charles E. Campbell, Jr.
"   Date:		May 31, 2002
"   Version:	7
"
"   Functions:
"   AlignCtrl(style,..list..)
"
"         Separators
"              "=" : all alignment demarcation patterns are equivalent
"                    and simultaneously active.  The list is of such
"                    patterns (regular expressions, actually).
"              "C" : cycle through alignment demarcation patterns
"
"         Justification
"              "l" : left justify  (no list needed)
"              "r" : right justify (no list needed)
"              "c" : center        (no list needed)
"                    Justification styles are cylic: ie. "lcr" would
"                    mean first field is left-justifed,
"                        second field is centered,
"                        third  field is right-justified,
"                        fourth field is left-justified, etc.
"
"         Map Support
"              "m" : next call to Align will AlignPop at end.
"                    AlignCtrl will AlignPush first.
"
"         Padding
"              "p" : current argument supplies pre-field-padding parameter;
"                    ie. that many blanks will be applied before
"                    the field separator. ex. call AlignCtrl("p2")
"              "P" : current argument supplies post-field-padding parameter;
"                    ie. that many blanks will be applied after
"                    the field separator. ex. call AlignCtrl("P3")
"
"         Initial White Space
"              "I" : preserve first line's leading whitespace and re-use
"                    subsequently
"              "W" : preserve leading whitespace on every line
"              "w" : don't preserve leading whitespace
"
"         Selection Patterns
"              "g" : restrict alignment to pattern
"              "v" : restrict alignment to not-pattern
"
"              If no arguments are supplied, AlignCtrl() will list
"              current settings.
"
"   [range]Align(..list..)
"              Takes a range and performs the specified alignment on the
"              text.  The range may be :line1,line2 etc, or visually selected.
"              The list is a list of patterns; the current s:AlignCtrl
"              will be used ('=' or 'C').
"
"   Commands:
"   AlignCtrl                : lists current alignment settings
"   AlignCtrl style ..list.. : set alignment parameters
"   [range]Align             : applies Align() to the specified range
"                              The range may be specified via
"                              visual-selection as well as the usual
"                              [range] specification.
" ---------------------------------------------------------------------

" Prevent duplicate loading
if exists("g:loaded_align") || &cp
 finish
endif
let g:loaded_align= 1

" Public Interface:
com! -range -nargs=* Align <line1>,<line2>call Align(<f-args>)
com!        -nargs=* AlignCtrl call AlignCtrl(<f-args>)
com!        -nargs=0 AlignPush call AlignPush()
com!        -nargs=0 AlignPop  call AlignPop()

" ---------------------------------------------------------------------

" AlignCtrl: enter alignment patterns here
"   Styles  "=" all alignment-break patterns are equivalent
"           "C" cycle through alignment-break pattern(s)
"           "l" left-justified alignment
"           "r" right-justified alignment
"           "c" center alignment
"   Builds   =  s:AlignPat  s:AlignCtrl  s:AlignPatQty
"            C  s:AlignPat  s:AlignCtrl  s:AlignPatQty
"            p  s:AlignPrePad
"            P  s:AlignPostPad
"            L  s:AlignLeadKeep
"            l  s:AlignStyle
"            r  s:AlignStyle
"            c  s:AlignStyle
"            g  s:AlignGPat
"            v  s:AlignVPat
fu! AlignCtrl(...)
"  call Decho("AlignCtrl() a:0=".a:0)
  if !exists("s:AlignStyle")
   let s:AlignStyle= "l"
  endif
  if !exists("s:AlignPrePad")
   let s:AlignPrePad= 0
  endif
  if !exists("s:AlignPostPad")
   let s:AlignPostPad= 0
  endif
  if !exists("s:AlignLeadKeep")
   let s:AlignLeadKeep= 'w'
  endif

  if a:0 == 0
   " ----------------------
   " List current selection
   " ----------------------
   echo "AlignCtrl<".s:AlignCtrl."> qty=".s:AlignPatQty." AlignStyle<".s:AlignStyle."> Padding<".s:AlignPrePad."|".s:AlignPostPad."> LeadingWS=".s:AlignLeadKeep
"   call Decho("AlignCtrl<".s:AlignCtrl."> qty=".s:AlignPatQty." AlignStyle<".s:AlignStyle."> Padding<".s:AlignPrePad."|".s:AlignPostPad."> LeadingWS=".s:AlignLeadKeep)
   if      exists("s:AlignGPat") && !exists("s:AlignVPat")
	echo "AlignGPat<".s:AlignGPat.">"
   elseif !exists("s:AlignGPat") &&  exists("s:AlignVPat")
	echo "AlignVPat<".s:AlignVPat.">"
   elseif exists("s:AlignGPat") &&  exists("s:AlignVPat")
	echo "AlignGPat<".s:AlignGPat."> AlignVPat<".s:AlignVPat.">"
   endif
   let ipat= 1
   while ipat <= s:AlignPatQty
	echo "Pat".ipat."<".s:AlignPat_{ipat}.">"
"	call Decho("Pat".ipat."<".s:AlignPat_{ipat}.">")
	let ipat= ipat + 1
   endwhile

  else
   " ----------------------------------
   " Process alignment control settings
   " ----------------------------------
   let style= a:1
"   call Decho("style<".style.">")

   if style =~ 'm'
	" map support: Do an AlignPush now and the next call to Align()
	"              will do an AlignPop at exit
	call AlignPush()
	let s:DoAlignPop= 1
   endif

   " = : record a list of alignment patterns that are equivalent
   if style =~ "="
"    call Decho("AlignCtrl: record list of alignment patterns")
    let s:AlignCtrl  = '='
	if a:0 >= 2
     let s:AlignPatQty= 1
     let s:AlignPat_1 = a:2
     let ipat         = 3
     while ipat <= a:0
      let s:AlignPat_1 = s:AlignPat_1.'\|'.a:{ipat}
      let ipat         = ipat + 1
     endwhile
     let s:AlignPat_1= '\('.s:AlignPat_1.'\)'
"     call Decho("AlignCtrl<".s:AlignCtrl."> AlignPat<".s:AlignPat_1.">")
	endif

    "c : cycle through alignment pattern(s)
   elseif style =~ 'C'
"    call Decho("AlignCtrl: cycle through alignment pattern(s)")
    let s:AlignCtrl  = 'C'
	if a:0 >= 2
     let s:AlignPatQty= a:0 - 1
     let ipat         = 1
     while ipat < a:0
      let s:AlignPat_{ipat}= a:{ipat+1}
"     call Decho("AlignCtrl<".s:AlignCtrl."> AlignQty=".s:AlignPatQty." AlignPat_".ipat."<".s:AlignPat_{ipat}.">")
      let ipat= ipat + 1
     endwhile
	endif
   endif

   if style =~ 'p'
    let s:AlignPrePad= substitute(style,'^.*p\(\d\+\).*$','\1','')
    if s:AlignPrePad == ""
     echoerr "AlignCtrl: 'p' needs to be followed by a numeric argument'
     return
	endif
   endif

   if style =~ 'P'
    let s:AlignPostPad= substitute(style,'^.*P\(\d\+\).*$','\1','')
    if s:AlignPostPad == ""
     echoerr "AlignCtrl: 'P' needs to be followed by a numeric argument'
     return
	endif
   endif

   if     style =~ 'w'
	let s:AlignLeadKeep= 'w'
   elseif style =~ 'W'
	let s:AlignLeadKeep= 'W'
   elseif style =~ 'I'
	let s:AlignLeadKeep= 'I'
   endif

   if style =~ 'g'
	" first list item is a "g" selector pattern
	if a:0 < 2
	 if exists("s:AlignGPat")
	  unlet s:AlignGPat
"	  call Decho("unlet s:AlignGPat")
	 endif
	else
	 let s:AlignGPat= a:2
"	 call Decho("s:AlignGPat<".s:AlignGPat.">")
	endif
   elseif style =~ 'v'
	" first list item is a "v" selector pattern
	if a:0 < 2
	 if exists("s:AlignVPat")
	  unlet s:AlignVPat
"	  call Decho("unlet s:AlignVPat")
	 endif
	else
	 let s:AlignVPat= a:2
"	 call Decho("s:AlignVPat<".s:AlignVPat.">")
	endif
   endif

    "a : set up s:AlignStyle
   if style =~ '[lrc]'
    let s:AlignStyle= substitute(style,'[^lrc]','','g')
"   call Decho("AlignStyle<".s:AlignStyle.">")
   endif
  endif
  return s:AlignCtrl.'p'.s:AlignPrePad.'P'.s:AlignPostPad.s:AlignLeadKeep.s:AlignStyle
endfunction

" ---------------------------------------------------------------------

" MakeSpace: returns a string with spacecnt blanks
fu! <SID>MakeSpace(spacecnt)
  let str      = ""
  let spacecnt = a:spacecnt
  while spacecnt > 0
   let str      = str . " "
   let spacecnt = spacecnt - 1
  endwhile
  return str
endfunction

" ---------------------------------------------------------------------

" Align: align selected text based on alignment pattern(s)
fu! Align(...) range

  " Align will accept a list of separator regexps
  if a:0 > 0
   if s:AlignCtrl =~ "="
"   call Decho("AlignCtrl: record list of alignment patterns")
    let s:AlignCtrl  = '='
    let s:AlignPat_1 = a:1
    let s:AlignPatQty= 1
    let ipat         = 2
    while ipat <= a:0
     let s:AlignPat_1 = s:AlignPat_1.'\|'.a:{ipat}
     let ipat         = ipat + 1
    endwhile
    let s:AlignPat_1= '\('.s:AlignPat_1.'\)'
"    call Decho("AlignCtrl<".s:AlignCtrl."> AlignPat<".s:AlignPat_1.">")

    "c : cycle through alignment pattern(s)
   elseif s:AlignCtrl =~ 'C'
"    call Decho("AlignCtrl: cycle through alignment pattern(s)")
    let s:AlignCtrl  = 'C'
    let s:AlignPatQty= a:0
    let ipat         = 1
    while ipat <= a:0
     let s:AlignPat_{ipat}= a:{ipat}
"     call Decho("AlignCtrl<".s:AlignCtrl."> AlignQty=".s:AlignPatQty." AlignPat_".ipat."<".s:AlignPat_{ipat}.">")
     let ipat= ipat + 1
    endwhile
   endif
  endif

  " initialize so that begline<endline  if c-v and !ragged, begcol<endcol
  let begcol   = virtcol("'<")-1
  let endcol   = virtcol("'>")-1
  if begcol > endcol
   let begcol  = virtcol("'>")-1
   let endcol  = virtcol("'<")-1
  endif
  let begline  = a:firstline
  let endline  = a:lastline
  if begline > endline
   let begline = a:lastline
   let endline = a:firstline
  endif
  let fieldcnt = 0
  if (begline == line("'>") && endline == line("'<")) || (begline == line("'<") && endline == line("'>"))
   let ragged   = ( col("'>") > strlen(getline("'>")) || col("'<") > strlen(getline("'<")) )
  else
   let ragged= 1
  endif
  if ragged
   let begcol= 0
   endif
"  call Decho("Align() lines[".begline.",".endline."] col[".begcol.",".endcol."] ragged=".ragged." AlignCtrl<".s:AlignCtrl.">")

  " Keep user options
  let etkeep   = &et
  let pastekeep= &paste
  set et paste

  " convert selected range of lines to use spaces instead of tabs
  exe begline.",".endline."ret"

  " Execute two passes
  " First  pass: collect alignment data (max field sizes)
  " Second pass: perform alignment
  let pass= 1
  while pass <= 2
"   call Decho(" ")
"   call Decho("---- Pass ".pass.": ----")

   let line= begline
   while line <= endline
    " Process each line
    let txt = getline(line)
"    call Decho(" ")
"    call Decho("Line ".line." <".txt.">")

    " AlignGPat support: allows a selector pattern (akin to g/selector/cmd )
    if exists("s:AlignGPat")
"	 call Decho("AlignGPat<".s:AlignGPat.">")
	 if match(txt,s:AlignGPat) == -1
"	  call Decho("skipping")
	  let line= line + 1
	  continue
	 endif
    endif

    " AlignVPat support: allows a selector pattern (akin to v/selector/cmd )
    if exists("s:AlignVPat")
"	 call Decho("AlignGPat<".s:AlignGPat.">")
	 if match(txt,s:AlignVPat) != -1
"	  call Decho("skipping")
	  let line= line + 1
	  continue
	 endif
    endif

    " Extract visual-block selected text (init bgntxt, endtxt)
    let txtlen= strlen(txt)
    if begcol > 0
	 " Record text to left of selected area
     let bgntxt= strpart(txt,0,begcol)
"	  call Decho("record text to left: bgntxt<".bgntxt.">")
    elseif s:AlignLeadKeep == 'I'
	 if !exists("bgntxt")
	  " retain first leading whitespace for all subsequent lines
	  let bgntxt= substitute(txt,'^\(\s*\).\{-}$','\1','')
"	  call Decho("retaining 1st leading ws: bgntxt<".bgntxt.">")
	 endif
    elseif s:AlignLeadKeep == 'W'
	 let bgntxt= substitute(txt,'^\(\s*\).\{-}$','\1','')
"	  call Decho("retaining all leading ws: bgntxt<".bgntxt.">")
    else
	 " No beginning text
	 let bgntxt= ""
"	  call Decho("no beginning text")
    endif
    if ragged
	 let endtxt= ""
    else
     " Elide any text lying outside selected columnar region
     let endtxt= strpart(txt,endcol+1,txtlen-endcol)
     let txt   = strpart(txt,begcol,endcol-begcol+1)
    endif
"    call Decho(" ")
"    call Decho("bgntxt<".bgntxt.">")
"    call Decho("   txt<". txt  .">")
"    call Decho("endtxt<".endtxt.">")

    " Initialize
    let seppat      = s:AlignPat_{1}
    let ifield      = 1
    let ipat        = 1
    let bgnfield    = 0
    let endfield    = 0
    let alignstyle  = s:AlignStyle
    let doend       = 1
	let newtxt      = ""
    let alignprepad = s:AlignPrePad
    let alignpostpad= s:AlignPostPad

    " Process each field on the line
    while doend > 0

	  " C-style: cycle through pattern(s)
     if s:AlignCtrl == 'C' && doend == 1
	  let seppat   = s:AlignPat_{ipat}
"	  call Decho("AlignCtrl=".s:AlignCtrl." ipat=".ipat." seppat<".seppat.">")
	  let ipat     = ipat + 1
	  if ipat > s:AlignPatQty
	   let ipat = 1
	  endif
     endif

     let endfield= match(txt,seppat,bgnfield)
	 let sepfield= matchend(txt,seppat,bgnfield)
"	 call Decho("endfield=match(txt<".txt.">,seppat<".seppat.">,bgnfield=".bgnfield.")=".endfield)

	 if endfield != -1
	  if pass == 1
	   " ---------------------------------------------------------------------
	   " Pass 1: Update FieldSize to max
"	   call Decho("before lead/trail remove: field<".strpart(txt,bgnfield,endfield-bgnfield).">")
	   let field      = substitute(strpart(txt,bgnfield,endfield-bgnfield),'^\s*\(.\{-}\)\s*$','\1','')
       if s:AlignLeadKeep == 'W'
	    let field = bgntxt.field
	    let bgntxt= ""
	   endif
	   let fieldlen   = strlen(field)
	   let sFieldSize = "FieldSize_".ifield
	   if !exists(sFieldSize)
	    let FieldSize_{ifield}= fieldlen
"	    call Decho(" set FieldSize_{".ifield."}=".FieldSize_{ifield}." <".field.">")
	   elseif fieldlen > FieldSize_{ifield}
	    let FieldSize_{ifield}= fieldlen
"	    call Decho("oset FieldSize_{".ifield."}=".FieldSize_{ifield}." <".field.">")
	   endif

	  else
	   " ---------------------------------------------------------------------
	   " Pass 2: Perform Alignment
	   let alignop    = strpart(alignstyle,0,1)
	   let alignstyle = strpart(alignstyle,1).strpart(alignstyle,0,1)
	   let field      = substitute(strpart(txt,bgnfield,endfield-bgnfield),'^\s*\(.\{-}\)\s*$','\1','')
       if s:AlignLeadKeep == 'W'
	    let field = bgntxt.field
	    let bgntxt= ""
	   endif
	   if doend == 2
		let alignprepad = 0
		let alignpostpad= 0
	   endif
	   let fieldlen   = strlen(field)
	   let sep        = s:MakeSpace(alignprepad).strpart(txt,endfield,sepfield-endfield).s:MakeSpace(alignpostpad)
	   let spaces     = FieldSize_{ifield} - fieldlen
"	   call Decho(alignop.": Field #".ifield."<".field."> spaces=".spaces." be[".bgnfield.",".endfield."] pad=".alignprepad.','.alignpostpad." FS_".ifield."<".FieldSize_{ifield}."> sep<".sep.">")

	    " Perform alignment according to alignment style justification
	   if spaces > 0
	    if     alignop == 'c'
		 " center the field
	     let spaceleft = spaces/2
	     let spaceright= FieldSize_{ifield} - spaceleft - fieldlen
	     let newtxt    = newtxt.s:MakeSpace(spaceleft).field.s:MakeSpace(spaceright).sep
	    elseif alignop == 'r'
		 " right justify the field
	     let newtxt= newtxt.s:MakeSpace(spaces).field.sep
	    elseif ragged && doend == 2
		 " left justify rightmost field (no trailing blanks needed)
	     let newtxt= newtxt.field
		else
		 " left justfiy the field
	     let newtxt= newtxt.field.s:MakeSpace(spaces).sep
	    endif
	   else
		" field is at maximum field size already
	    let newtxt= newtxt.field.sep
	   endif
"	   call Decho("newtxt<".newtxt.">")
	  endif	" pass 1/2

	  " bgnfield indexes to end of separator at right of current field
	  " Update field counter
	  let bgnfield= matchend(txt,seppat,bgnfield)
      let ifield  = ifield + 1
	  if doend == 2
	   let doend= 0
	  endif
	   " handle end-of-text as end-of-field
	 elseif doend == 1
	  let seppat  = '$'
	  let doend   = 2
	 else
	  let doend   = 0
	 endif		" endfield != -1
    endwhile	" doend loop (as well as regularly separated fields)

	if pass == 2
	 " Write altered line to buffer
"     call Decho("bgntxt<".bgntxt."> line=".line)
"     call Decho("newtxt<".newtxt.">")
"     call Decho("endtxt<".endtxt.">")
     let junk = cursor(line,1)
	 exe "norm! 0DA".bgntxt.newtxt.endtxt."\<Esc>"
	endif

    let line = line + 1
   endwhile	" line loop

   let pass= pass + 1
  endwhile	" pass loop

  " Restore user options
  let &et    = etkeep
  let &paste = pastekeep

  if exists("s:DoAlignPop")
   " AlignCtrl Map support
   call AlignPop()
   unlet s:DoAlignPop
  endif
  return
endfunction

" ---------------------------------------------------------------------

" AlignPush: this command/function pushes an alignment control string onto a stack
fu! AlignPush()
  " initialize the stack
  if !exists("s:AlignCtrlStackQty")
   let s:AlignCtrlStackQty= 1
  else
   let s:AlignCtrlStackQty= s:AlignCtrlStackQty + 1
  endif
  " construct an AlignCtrlStack entry
  let s:AlignCtrlStack_{s:AlignCtrlStackQty}= s:AlignCtrl.'p'.s:AlignPrePad.'P'.s:AlignPostPad.s:AlignLeadKeep.s:AlignStyle
"  call Decho("AlignPush: AlignCtrlStack_".s:AlignCtrlStackQty."<".s:AlignCtrlStack_{s:AlignCtrlStackQty}.">")
  if exists("s:AlignGPat")
   let s:AlignGPat_{s:AlignCtrlStackQty}= s:AlignGPat
  else
   let s:AlignGPat_{s:AlignCtrlStackQty}=  ""
  endif
  if exists("s:AlignVPat")
   let s:AlignVPat_{s:AlignCtrlStackQty}= s:AlignVPat
  else
   let s:AlignVPat_{s:AlignCtrlStackQty}=  ""
  endif
endf

" ---------------------------------------------------------------------

" AlignPop: this command/function pops an alignment pattern from a stack
"           and into the AlignCtrl variables.
fu! AlignPop()
  " sanity check
  if !exists("s:AlignCtrlStackQty")
   echoerr "AlignPush needs to be used prior to AlignPop"
   return ""
  endif
  if s:AlignCtrlStackQty <= 0
   echoerr "AlignPush needs to be used prior to AlignPop"
   return ""
  endif
  call AlignCtrl(s:AlignCtrlStack_{s:AlignCtrlStackQty})
  if s:AlignGPat_{s:AlignCtrlStackQty} != ""
   call AlignCtrl('g',s:AlignGPat_{s:AlignCtrlStackQty})
  endif
  if s:AlignVPat_{s:AlignCtrlStackQty} != ""
   call AlignCtrl('g',s:AlignVPat_{s:AlignCtrlStackQty})
  endif
  let s:AlignCtrlStackQty= s:AlignCtrlStackQty - 1
"  call Decho("AlignPop: AlignCtrlStack_".s:AlignCtrlStackQty+1."<".s:AlignCtrlStack_{s:AlignCtrlStackQty + 1}.">")
  return s:AlignCtrlStack_{s:AlignCtrlStackQty + 1}
endf

" ---------------------------------------------------------------------
" Default:  preserve initial leading whitespace, left-justified,
"           alignment on '=', one space padding on both sides
call AlignCtrl("Ilp1P1=",'=')
