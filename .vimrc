" James Whiteneck .vimrc file

" ==============================================================================
" clear all inherited settings
" ==============================================================================
    set all&
    set nocompatible                " Use Vim settings rather than Vi settings

" ==============================================================================
" Pathogen
" ==============================================================================
    runtime bundle/vim-pathogen/autoload/pathogen.vim
    if exists("g:loaded_pathogen")
        execute pathogen#infect()
        execute pathogen#helptags()
    endif

" ==============================================================================
" General
" ==============================================================================
    set encoding=utf-8              " Use UTF-8 encoding
    set number                      " Show line numbers

" ==============================================================================
" Visual
" ==============================================================================
    syntax enable                       " Enable syntax highlighting
    set t_Co=256                        " Use all avaliable colors
    set background=dark                 " Use dark background
    colorscheme molokai                 " Use a colorscheme
    set nospell                         " Disable spell check

    " Highlight cursor line but disable column highlighting for now
    augroup CursorLine
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        "au VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
        au WinLeave * setlocal nocursorline
        "au WinLeave * setlocal nocursorcolumn
    augroup END

    " Make trailing whitespace annoyingly highlighted red.
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

" ==============================================================================
" Formatting
" ==============================================================================
    " Convert tabs to 4 spaces
    set smarttab
    set expandtab
    set tabstop=4
    set shiftwidth=4

    set autoindent                  " Autoindent
    set backspace=2                 " Allow backspacing over everything in insert mode
    set hidden                      " Enable unsaved buffers
    set history=300                 " Keep 300 lines of command line history
    set hlsearch                    " Highlight search matches
    set ignorecase                  " Ignore case when searching...
    set incsearch                   " Search as you type
    set laststatus=2                " Always show the status line
    set nobk                        " Get rid of the annoying backup files
    set nofoldenable                " Don't auto fold
    set nocompatible                " Use Vim settings rather than vi settings
"    set paste                       " Enable paste formatting by default
    set pastetoggle=<F11>           " Paste toggling on keeps automatic indentation when pasting
    set ruler                       " Show the cursor position all the time
    set showcmd                     " Display incomplete commands
    set showmatch                   " Highlight matching brace, bracket, paren when cursor over one
    set showmode                    " Show editing mode
    set smartcase                   " ...unless uppercase letters are used
    set tags=tags;/                 " Vim will search for 'tags' file in tags directory
    set wildmenu                    " Show autocomplete menus
    set wildmode=longest,list       " Allow tabbing through autocomplete filenames
    set wrap                        " Line wrapping is okay

" ==============================================================================
" Mouse
" ==============================================================================
    set mouse=a
    set ttymouse=xterm

" ==============================================================================
" Keyboard
" ==============================================================================
    " hit enter to clear search buffer
    nnoremap <CR> :noh<CR><CR>

    " use Alt-j to move back one filetab
    noremap <A-j> gT

    " use Alt-k to move forward one filetab
    noremap <A-k> gt

    " Clear search buffer with <Enter>
    noremap <CR> :noh<CR><CR>

    " Scrolling
    map <C-j> :join<ESC>
    map <S-j> 4j
    map <S-k> 4k
    map <S-l> 4l
    map <S-h> 4h

" ==============================================================================
" Lightline
" ==============================================================================
    let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component': {
      \   'readonly': '%{&readonly?".":""}',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

" ==============================================================================
" Autocmd
" ==============================================================================
    " Automatically remove trailing whitespace when saving file
    autocmd BufWritePre * :call <SID>StripWhite()
    fun! <SID>StripWhite()
        let l = line(".")
        let c = col(".")
        %s/[ \t]\+$//ge
        %s!^\( \+\)\t!\=StrRepeat("\t", 1 + strlen(submatch(1)) / 8)!ge
        call cursor(l,c)
    endfun

" ==============================================================================
" Rentrak
" ==============================================================================
    if filereadable('/usr/local/etc/vimrc_files/reasonably_stable_mappings.vim')
        source /usr/local/etc/vimrc_files/reasonably_stable_mappings.vim
    endif

    map ,x :!transpose.pl \| !table-ize.pl<cr>

" ==============================================================================
" Unite
" ==============================================================================
    " File searching
    nnoremap <space>p :Unite file_rec/async<cr>

    " Content searching
    nnoremap <space>/ :Unite grep:.<cr>

    " Yank searching
    let g:unite_source_history_yank_enable = 1
    nnoremap <space>y :Unite history/yank<cr>

    " Buffer searching
    nnoremap <space>s :Unite -quick-match buffer<cr>

" ==============================================================================
" BufExplorer
" ==============================================================================
    " BufExplorer
    map ,b :BufExplorer<cr>
