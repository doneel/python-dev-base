" Start the list of vim plugins
call plug#begin("~/.config/nvim/plugged")
Plug 'easymotion/vim-easymotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'vim-test/vim-test'
call plug#end()

filetype plugin indent on


" =============== Colorscheme Auto Install ==========
if !filereadable($HOME."/.config/nvim/colors/molokai.vim")
    echo "Downloading molokai colorscheme..."
    echo ""
    silent !mkdir -p $HOME/.config/nvim/colors
    silent !curl https://raw.githubusercontent.com/doneel/Config-Files/master/.vim/colors/molokai.vim > $HOME/.config/nvim/colors/molokai.vim
endif
" ================= Leader Macros ====================
set timeout  timeoutlen=400 ttimeoutlen=100   " 1/5 second to double tap
" 1/10 for leader shortcuts
let mapleader =" "
"nmap <leader>w :w<CR>
"nmap <leader>wq :wq<CR>
nmap <leader>rg :%s//g<left><left>
vmap <leader>rg y:%s/<C-R>"//g<left><left>
" y/<C-R>"<CR>
nmap <leader>rn :%s//gc<left><left><left>


" ================= Easy Motion ======================
" let g:EasyMotion_leader_key = '<Leader>'
"let g:EasyMotion_smartcase = 1
"let g:EasyMotion_use_smartsign_us = 1 " US layout
map s <Plug>(easymotion-bd-w)
nmap s <Plug>(easymotion-overwin-w)


" ================ Autoreload .vimrc =================
autocmd! BufWritePost $MYVIMRC source $MYVIMRC | echom "Reloaded $NVIMRC"


" ================ General Config ====================
set number                      "Line numbers are good
set ruler                       "Always show location
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
"set visualbell                  "No sounds (creating glitchy flashing)
set autoread                    "Reload files changed outside vim
set lazyredraw                  "Don't redraw while macro-ing
set magic                       "For reg ex, turn magic on
set showmatch                   "Hilight matching brackets
"set encoding=utf8               "standard encoding and en_US as lang
set ffs=unix,dos,mac            " Use Unix as the standard file type
" set autochdir                   "Set vim's directory to be the file's this
" messes up search!
set ttyfast                        "My terminals are fast
set formatoptions=tcql         " t - autowrap to textwidth
" c - autowrap comments to textwidth
" r - autoinsert comment leader with <Enter>
" q - allow formatting of comments with :gq
" l - don't format already long lines
set autoread                    "Automatically reload file if it's been changed elsewhere

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden


" ================ Search Settings  =================
" set incsearch        "Find the next match as we type the search (I don't actually like it"
set ignorecase       "Ignore case when searching
set smartcase        "Try to be smart about cases?
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks
cnoremap <c-n> <CR>n/<c-p>

" Double tap search to search for currently selected text
vnoremap // y/<C-R>"<CR> 
let g:fzf_layout = { 'down' : '50%' }
let g:fzf_preview_window = ['up:50%', 'ctrl-/']
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --glob "!.git/*" --glob "!*.vim_backups/*"-- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nmap <leader>F :RG<Cr>
nmap <leader>f :Files<Cr>
" ================ Turn Off Swap Files ==============
set noswapfile


" ================ Backup Files =====================
set backup
set backupdir=~/.vim_backups


" ================ Persistent Cursor Position =======
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

" set viminfo^=%          "Remember info about open buffers WARNING: This
" means a lot of garbage files. I'm turning this off


" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.

silent !mkdir ~/.vim_backups > /dev/null 2>&1
set undodir=~/.vim_backups
set undofile


" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set expandtab            "Use spaces instead of tabs
"set wrap                 "Wrap lines don't go onto th enext line please

" Display tabs and trailing spaces visually
"set list listchars=tab:\ \ ,trail:?

"set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

vnoremap < <gv
"Block indent / outdent"
vnoremap > >gv


" ================ Delete Trailing Whitespace ======
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()         "enabled in python
autocmd BufWrite *.coffee :call DeleteTrailingWS()     "...and coffeescript


" ================ Completion =======================
set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~,*.pyc "stuff to ignore when tab completing
set wildignore+=*vim_backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*


" ================ Scrolling ========================
set scrolloff=5         "Start scrolling when we're 5 lines away from margins
set sidescrolloff=15
set sidescroll=1


" ================= Navigation =======================
nnoremap j gj
nnoremap k gk
nnoremap J <c-d>
nnoremap K <c-u>


" ================= Key Shortcuts ====================
inoremap fd <Esc>
cnoremap fd <Esc>
vnoremap fd <Esc>
if has('nvim')
    tnoremap fd <C-\><C-n>
end
nnoremap ; :

"Home-row keys to go to end/start of line
noremap L $
noremap H 0

noremap L $
noremap H 0
xmap p ]p


" ================= Copy / Pate ======================
"set pastetoggle=<leader>p
noremap <leader>p "+p
noremap <leader>y "+y

nnoremap d "dd
vnoremap d "dd
nnoremap x "dx
vnoremap x "dx
"set mouse=a
nnoremap c "dc
vnoremap x "dc
"vnoremap "+y <leader>y
"inoremap "+y <leader>y
set clipboard+=unnamed

" ================= Appearance =======================
set  t_Co=256
"let g:molokai_original = 1
"let g:rehash256 = 1
"set background=dark
" colorscheme molokai
syntax on
silent! colorscheme molokai
set cursorline


" ================= Buffer Switching =================
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


" ================= Semshi Python editing =================
nmap <silent> <leader>e :Semshi goto error<CR>:Semshi error<CR>
let g:semshi#error_sign_delay = 3


" ================= Deoplete Completion =================
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('auto_complete_delay', 200)
let g:jedi#completions_enabled = 0


" ================= Tests =================
let test#strategy = "neovim"
let test#neovim#term_position = "bot 30"
nmap <silent> <C-t>n :TestNearest<CR>
nmap <silent> <C-t>f :TestFile<CR>
nmap <silent> <C-t>a :TestSuite<CR>
nmap <silent> <C-t>t :TestLast<CR>
nmap <silent> <C-t>v :TestVisit<CR>


" ================= CTags =================
set tags=.tags
autocmd BufWritePost *.py silent! !ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./.tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))") ./ &
