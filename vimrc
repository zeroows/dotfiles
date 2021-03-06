set nocompatible

" Load plugins
source $HOME/.vim/plugins.vim

" File type settings (file type-specific settings in vim/ftplugin/)
autocmd BufRead,BufNewFile *.txt setfiletype text
autocmd BufRead,BufNewFile sys.config,*.app.src,*.app,*.erl,*.es,*.hrl,*.yaws,*.xrl setfiletype erlang
autocmd BufRead,BufNewFile Gemfile setfiletype ruby
autocmd BufRead,BufNewFile Vagrantfile setfiletype ruby
autocmd BufRead,BufNewFile Dockerfile setfiletype bash

" TODO: Turn on showcmd when in visual mode
"autocmd VisualEnter * silent execute "set showcmd!"
"autocmd VisualLeave * silent execute "set showcmd!"

" General settings
syntax on
set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set guifont=Monaco:h12
set background=dark
set showmatch
set hlsearch
set colorcolumn=80

" Allow backspace to delete end of line, indent and start of line characters
set backspace=indent,eol,start

" Show pastetoggle status
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Toggle Tagbar
nmap <F9> :TagbarToggle<CR>

" Turn on cursor column highlighting
set cursorcolumn

" set the color scheme
colorscheme solarized
" TODO: Pull colors for env variables
"execute "set background=".$BACKGROUND
"execute "colorscheme ".$THEME

" Make background transparent since we are using solarized in the terminal
let g:solarized_termtrans = 1
set t_Co=16

" Ignored files
set wildignore+=/tmp/,*.so,*.swp,*.swo,*.zip,*.meta,*.prefab,*.png,*.jpg,*.beam

" Allow hidden buffers
set hidden

set runtimepath^=$HOME/.vim/bundle/ctrlp.vim

" Shortcuts ============================
let mapleader = ","
map ; :
map  <Esc> :w
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
map <Leader>s <esc>:w<CR>
map <Leader>m :Rmodel
imap <esc>:tabn <F7>
map gT <F8>
map gt <F7>
map :tabn <F8>
map :tabp <F7>
map <Leader>cr <F5>

if has("gui_running")
  set guioption=-t
endif

" Disable arrow keys
nnoremap <Left> :echoe "Use h"<cr>
nnoremap <Right> :echoe "Use l"<cr>
nnoremap <Up> :echoe "Use k"<cr>
nnoremap <Down> :echoe "Use j"<cr>
inoremap <Left> <esc> :echoe "Use h"<cr>
inoremap <Right> <esc> :echoe "Use l"<cr>
inoremap <Up> <esc> :echoe "Use k"<cr>
inoremap <Down> <esc> :echoe "Use j"<cr>

" Allow replacing of searched text by using `cs` on the first result and `n.`
" on all consecutive results
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
            \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" Vim pencil settings
let g:pencil#wrapModeDefault = 'soft'

augroup pencil
    autocmd!
    autocmd FileType mkd.markdown,markdown,mkd call pencil#init()
    autocmd FileType text         call pencil#init()
augroup END

" NERDTree settings
nmap <silent> <F3> :NERDTreeToggle<CR>
set guioptions-=T
let NERDTreeShowHidden=1

" CtrlP directory mode
let g:ctrlp_working_path_mode = 0

"open CtrlP in buffer mode
nnoremap <leader>b :CtrlPBuffer<CR>

" custom CtrlP ignores toggle
function! ToggleCtrlPIgnores()
    if exists("g:ctrlp_user_command")
        " unset the ignores
        let g:ctrlp_custom_ignore = {}
        unlet g:ctrlp_user_command
    else
        " always ignore these patterns
        let g:ctrlp_custom_ignore = {
                    \'dir': 'ebin\|DS_Store\|git$\|bower_components\|node_modules\|logs',
                    \'file': '\v\.(beam|pyc|swo)$',
                    \}
        " also ignore files listed in the .gitignore
        let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
    end
endfunction

call ToggleCtrlPIgnores()
:nnoremap <F6> call ToggleCtrlPIgnores()<CR>

" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Toggle everything that occupies space on the left side of the editor
function! ToggleLeftGuides()
    if (g:left_guides_enabled == 1)
        call HideLeftGuids()
        let g:left_guides_enabled = 0
    else
        call ShowLeftGuids()
        let g:left_guides_enabled = 1
    endif
endfunction

" By default everything on the left side is enabled
let g:left_guides_enabled = 1

" Hide everything that occupies space on the left side of the file, so we can
" copy the file contents with ease
function! HideLeftGuids()
    " Hide line numbers
    set nonumber

    " Hide GitGutter
    GitGutterDisable

    " Reset Syntastic, then set it to passive mode, this effectively hides the
    " hints in the left side columns
    SyntasticToggle
    SyntasticReset
endfunction

" Show everything that occupies space on the left side of the file
function! ShowLeftGuids()
    " Show line numbers
    set number

    " Show GitGutter
    GitGutterEnable

    " Run the Syntastic check
    SyntasticCheck
endfunction

:nnoremap <F4>  :call ToggleLeftGuides()<CR>

" Custom status bar
set statusline=\ Filename:%-8t                               " Filename
set statusline+=\ Encoding:\%-8{strlen(&fenc)?&fenc:'none'}   " File encoding
set statusline+=\ Line\ Endings:%-6{&ff}                      " Line Endings
set statusline+=\ File\ Type:%-12y                            " File Type
set statusline+=%=%h%m%r%c,%l/%L\ %P        " Cursor location and file status
set laststatus=2
" Color status bar
highlight statusline ctermfg=cyan ctermbg=black guifg=cyan guibg=black

" allow yanking to OSX clipboard
" http://stackoverflow.com/questions/11404800/fix-vim-tmux-yank-paste-on-unnamed-register
if $TMUX == ''
    set clipboard+=unnamed
endif

" Start CtrlP on startup
autocmd VimEnter * CtrlP

" Automatically reload .vimrc
autocmd! BufWritePost .vimrc,*vimrc source %

" Vim-Erlang Skeleton settings
let g:erl_replace_buffer=0
" TODO: Figure out how to copy default erlang templates into our custom dir
" let g:erl_tpl_dir="~/.erlang_templates"

" Load in custom config if it exists
let custom_vimrc='~/dotfiles/mixins/vimrc.custom'
if filereadable(custom_vimrc)
    source custom_vimrc
end

" Toggle visibility of whitespace characters
nmap <leader>l :set list!<CR>

" Use special chars in place of tab and eol
set listchars=eol:¬,tab:→\ ,extends:>,precedes:<,trail:·,space:·

" Load trailing whitespace functions
source $HOME/.vim/whitespace.vim

highlight SpecialKey ctermfg=darkgreen guifg=darkgreen
