"  Preamble
""""""""""""""

"" set language
language messages C


"" set leader
let mapleader = '\'
let maplocalleader = "\<C-\>"


"" set shell
if has('unix')
	set shell=/bin/sh
endif


"" implement `stdpath` shim
function StdpathShim(what)
	if exists('*stdpath')
		return stdpath(a:what)
	endif

	if a:what ==# 'cache'
		if has('win32')
			return $TEMP . '\vim'
		endif
		return $HOME . '/.cache/vim'
	elseif a:what ==# 'config'
		if has('win32')
			return $LOCALAPPDATA . '\vim'
		endif
		return $HOME . '/.vim'
	elseif a:what ==# 'data'
		if has('win32')
			return $LOCALAPPDATA . '\vim-data'
		endif
		return $HOME . '/.local/share/vim'
	endif
endfunc


"" auto-install plugin-manager and plugins
if empty(glob(StdpathShim('config') . '/autoload/plug.vim'))
	:call execute('!curl --create-dirs --silent --show-error --fail --location --output "' . StdpathShim('config') . '/autoload/plug.vim" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"', 'silent')
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


"""" early plugin config

"" ale
let g:ale_enabled = 1
let g:ale_completion_enabled = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_cursor_detail = 1
let g:ale_close_preview_on_insert = 1
let g:ale_echo_cursor = 0
let g:ale_echo_delay = 100
let g:ale_hover_cursor = 0
let g:ale_hover_to_preview = 0



"  Plugins
"""""""""""""

call plug#begin(StdpathShim('data') . '/plugged')

"""" Aesthetics

"" color scheme
Plug 'iCyMind/NeoSolarized'
"" powerline theme
Plug 'vim-airline/vim-airline'
"" color schemes for airline theme
Plug 'vim-airline/vim-airline-themes'
"" airline for tmux
Plug 'edkolev/tmuxline.vim'
"" airline for shell
Plug 'edkolev/promptline.vim'
"" devicons
Plug 'ryanoasis/vim-devicons'
"" auto-disable search highlighting
Plug 'romainl/vim-cool'

"""" Quality of Life

"" better defaults
Plug 'tpope/vim-sensible'
"" complementary paired mappings
Plug 'tpope/vim-unimpaired'
"" improved lang packs
Plug 'sheerun/vim-polyglot'
"" exchange operations
Plug 'tommcdo/vim-exchange'
"" misc motions
Plug 'wellle/targets.vim'
"" word motions
Plug 'chaoren/vim-wordmotion'
"" surround operations
Plug 'tpope/vim-surround'
"" regex-replace word variations and case coersion
Plug 'tpope/vim-abolish'
"" number base/representation converting
Plug 'glts/vim-radical'
"" advanced increment/decrement
Plug 'tpope/vim-speeddating'
"" improved character info
Plug 'tpope/vim-characterize'
"" code (un)commenting
Plug 'tpope/vim-commentary'
"" padding with empty lines
Plug 'notuxic/vim-padline'
"" move text
Plug 'matze/vim-move'
"" session management
Plug 'xolox/vim-session'
"" vcs diff hints
Plug 'mhinz/vim-signify'
"" smart tab completion
Plug 'ajh17/VimCompletesMe'
"" .editorconfig support
Plug 'editorconfig/editorconfig-vim'
"" .env support
Plug 'tpope/vim-dotenv'
"" directory-local config
Plug 'embear/vim-localvimrc'
"" detect and set indent options
Plug 'tpope/vim-sleuth'
"" auto-close HTML/XML tags
Plug 'alvan/vim-closetag'
"" auto-close pairs
Plug 'cohama/lexima.vim'

"""" Tools

"" fast grepping
Plug 'mileszs/ack.vim'
"" CMake support
Plug 'ilyachur/cmake4vim'
"" git commands
Plug 'tpope/vim-fugitive'
"" git commit browser
Plug 'junegunn/gv.vim'
"" shell commands
Plug 'tpope/vim-eunuch'
"" tmux commands
Plug 'tpope/vim-tbone'
"" snippets
Plug 'Jorengarenar/miniSnip'
"" REST console
Plug 'diepm/vim-rest-console'
"" file tree viewer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-devicons.vim'
Plug 'lambdalisue/fern-git-status.vim'
"" tag viewer
Plug 'liuchengxu/vista.vim'
"" latex
Plug 'lervag/vimtex'
"" linting, fixing, ...
Plug 'dense-analysis/ale'
"" lsp client
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

if has("nvim")
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	"" dap client
	Plug 'mfussenegger/nvim-dap'
	Plug 'theHamsta/nvim-dap-virtual-text'
endif

"""" Dependencies

"" xolox/vim-session
Plug 'xolox/vim-misc'
"" glts/vim-radical
Plug 'glts/vim-magnum'
"" tpope/vim-surround tpope/vim-speeddating glts/vim-radical
Plug 'tpope/vim-repeat'
if has("nvim")
	"" lambdalisue/fern.vim
	Plug 'antoinemadec/FixCursorHold.nvim'
endif

call plug#end()



"  Plugin-Config
"""""""""""""""""""

"" airline
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#fern#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#gutentags#enabled = 1
let g:airline#extensions#obession#enabled = 1
let g:airline#extensions#term#enabled = 1
let g:airline#extensions#vista#enabled = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s  '

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = ''
let g:airline#extensions#ale#warning_symbol = ''
let g:airline#extensions#ale#show_line_numbers = 1

let g:airline#extensions#lsp#enabled = 1
let g:airline#extensions#lsp#error_symbol = ''
let g:airline#extensions#lsp#warning_symbol = ''
let g:airline#extensions#lsp#show_line_numbers = 1
"
let g:airline#extensions#branch#enabled = 1
"let g:airline#extensions#branch#displayed_head_limit = 10
"let g:airline_symbols.dirty = ''
"let g:airline_symbols.notexists = ''

let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']

let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

"" tmuxline
let g:tmuxline_theme = 'airline'
let g:tmuxline_preset = 'powerline'

"" promptline
let g:promptline_theme = 'airline'

"" wordmotion
let g:wordmotion_prefix = '<Space>'

"" move
let g:move_map_keys = 0
let g:move_past_end_of_line = 0

"" session
let g:session_directory = StdpathShim('data') . '/sessions'
let g:session_default_name = 'default'
let g:session_default_overwrite = 1
let g:session_autoload = 'no'
let g:session_autosave = 'yes'
let g:session_command_aliases = 1

"" signify
"let g:signify_priority = 10
let g:signify_line_highlight = 0
let g:signify_sign_show_count = 1
let g:signify_sign_add = '+'
let g:signify_sign_change = '~'
let g:signify_sign_delete = '-'
let g:signify_sign_delete_first_line = ''

" vimcompletesme
let g:vcm_direction = 'p'
"imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Plug>vim_completes_me_forward"
"imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Plug>vim_completes_me_backward"

"" editorconfig
let g:EditorConfig_core_mode = 'vim_core'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"" dispatch
let g:dispatch_no_maps = 1

"" localvimrc
let g:localvimrc_enable = 1
let g:localvimrc_name = ['.lvimrc', '.lvim/lvimrc']
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 1
let g:localvimrc_persistent = 1
let g:localvimrc_persistence_file = StdpathShim('data') . '/lvimrc.persistent'
let g:localvimrc_python2_enable = 0
let g:localvimrc_python3_enable = 0

"" closetag
let g:closetag_filetypes = 'html,xhtml,html.mustache'

"" lexima
call lexima#add_rule({'filetype':'scheme', 'char':"'", 'input_after':''})
call lexima#add_rule({'filetype':'tex', 'char':'$', 'input_after':'$'})
call lexima#add_rule({'filetype':'tex', 'char':'$', 'at':'\%#\$', 'leave':1})
call lexima#add_rule({'filetype':'tex', 'char':'<BS>',  'at':'\$\%#\$', 'input':'<BS>', 'delete':1})
call lexima#add_rule({
\ 'filetype': 'tex',
\ 'char': '<CR>',
\ 'input': '<CR>',
\ 'input_after_with': '<CR>\\end{\1}',
\ 'at': '^.*\\begin{\([^}]*\)}\(\[.*\]\)*\%#$'
\ })

"" ack.vim
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
let g:ack_apply_qmappings = 0
let g:ack_apply_lmappings = 0
let g:ackhighlight = 0
let g:ack_autoclose = 0
let g:ack_use_dispatch = 0
let g:ack_use_cword_for_empty_search = 1

"" gutentags
let g:gutentags_modules = ['ctags']
let g:gutentags_project_root = ['.git', '.lvim', '.lvimrc']
let g:gutentags_exclude_filetypes = []
let g:gutentags_background_update = 1
let g:gutentags_cache_dir = StdpathShim('data') . '/tags'
let g:gutentags_ctags_executable = 'ctags'
"let g:gutentags_ctags_tagfile = 'tags'

"" cmake4vim
let g:cmake_compile_commands = 1
let g:cmake_reload_after_save = 1
let g:make_arguments = '-j'

"" miniSnip
let g:miniSnip_dirs = [StdpathShim('config') . '/snippets']
let g:miniSnip_local = '.lvim/snippets'
let g:miniSnip_trigger = '<C-Space>'
let g:miniSnip_extends = {
\	'cpp': ['c'],
\   'html': ['xhtml'],
\   'html.mustache': ['xhtml'],
\   'plaintex': ['tex'],
\   'latex': ['tex']
\ }

"" fern
let g:fern#renderer = 'devicons'
augroup fernCustomAutocmds
	autocmd!
	autocmd FileType fern setlocal nonumber norelativenumber numberwidth=1
augroup END

"" vista
"let g:vista_ctags_executable = 'ctags'
let g:vista_default_executive = 'ctags'
let g:vista_executive_for = {
\ 'c'        : 'vim_lsp',
\ 'cpp'      : 'vim_lsp',
\ 'markdown' : 'toc',
\ 'pandoc'   : 'markdown',
\ 'python'   : 'vim_lsp',
\ 'rust'     : 'ctags',
\ }
let g:vista_finder_alternative_executives = ['ctags']
"let g:vista_ctags_cmd = {}
let g:vista_highlight_whole_line = 1
let g:vista_fold_toggle_icons = ['▼', '▶']
let g:vista_icon_indent = ['└→', '├→']
let g:vista_sidebar_width = 50
let g:vista_echo_cursor = 0
let g:vista_echo_cursor_strategy = 'floating_win'

"" vimtex
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_complete_enabled = 0
let g:vimtex_view_method = 'zathura'
let g:vimtex_format_enabled = 0
let g:vimtex_quickfix_autojump = 0
let g:vimtex_quickfix_mode = 2
let g:vimtex_syntax_conceal_disable = 1
let g:vimtex_toc_enabled = 0
let g:vimtex_root_markers = ['.latexmkrc', '.git/']
augroup vimtexMisc
	autocmd!
	autocmd FileType tex let b:surround_{char2nr('e')} = "\\begin{\1\\begin{\1\n\t\r\n\\end{\1\r}.*\r\1}"
	autocmd FileType tex let b:vcm_omni_pattern = '\(\\\k*\|{\k*\)\k*$'
augroup END
augroup vimtexClientServer
	autocmd!
	autocmd FileType tex if empty(v:servername) && exists('*remote_startserver') | call remote_startserver('tex/' . lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), g:vimtex_root_markers)) | endif
augroup END

"" ale
"set omnifunc=ale#completion#OmniFunc
let g:ale_disable_lsp = 0
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_linters = {
\ 'dart'   : ['analysis_server'],
\ 'go'     : ['gofmt', 'golint', 'govet', 'gopls'],
\ 'java'   : ['javalsp'],
\ 'python' : ['pylint', 'pyright'],
\ 'tex'    : ['texlab', 'chktex', 'lacheck'],
\ 'rust'   : ['cargo', 'analyzer'],
\ }
let g:ale_completion_symbols = g:vista#renderer#icons
" use ALE autocompletion for certain filetypes
augroup ALEComplete
	autocmd!
	" autocmd FileType tex setlocal omnifunc=ale#completion#OmniFunc
augroup END

"" lsp
let g:lsp_diagnostics_enabled = 0
let g:lsp_signs_enabled = 0
let g:lsp_fold_enabled = 0
let g:lsp_semantic_enabled = 0
set omnifunc=lsp#complete
"set tagfunc=lsp#tagfunc
let g:lsp_settings = {
\ 'clangd': {'cmd': ['clangd', '--background-index', '--cross-file-rename', '--header-insertion=never']},
\ 'efm-langserver': {'disabled': v:false}
\ }
let g:lsp_settings_enable_suggestions = 0

"" nvim-dap/nvim-dap-virtual-text
if has("nvim")
lua << EOF
	require('dap')
	require('dap-adapters')

	-- nvim-dap
	vim.fn.sign_define('DapBreakpoint', {text='●', texthl='Error', linehl='', numhl=''})
	vim.fn.sign_define('DapLogPoint', {text='◆', texthl='Constant', linehl='', numhl=''})
	vim.fn.sign_define('DapStopped', {text='', texthl='Constant', linehl='CursorLine', numhl=''})
	vim.fn.sign_define('DapBreakpointRejected', {text='◌', texthl='Error', linehl='', numhl=''})

	-- nvim-dap-virtual-text
	require('nvim-dap-virtual-text').setup {
		enabled = true,
		enabled_commands = true,
		highlight_changed_variables = true,
		highlight_new_as_changed = true,
		show_stop_reason = true,
		commented = true
	}
EOF
endif



"  Config
""""""""""""

"""" Visuals

"" enable truecolor support
if &t_Co > 256 || $COLORTERM =~ '\(truecolor\|24bit\)'
	set termguicolors

	"" properly support colors inside TMUX
	if !has('nvim') && !empty($TMUX) && empty(&t_8f)
		let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
		let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
	endif
endif

"" set colorscheme
set background=dark
let g:neosolarized_vertSplitBgTrans = 0
let g:airline_solarized_bg = 'dark'
let g:airline_theme = 'solarized'
colorscheme NeoSolarized
augroup colorNeoSolarized
	autocmd!
	autocmd ColorScheme NeoSolarized highlight clear MatchParen
	autocmd ColorScheme NeoSolarized highlight MatchParen term=reverse cterm=bold ctermbg=10 gui=bold guibg=#1f4a54
augroup END

"" set cursor shape based on mode
if !has('nvim')
	let &t_SI = "\e[6 q"
	let &t_SR = "\e[4 q"
	let &t_EI = "\e[2 q"
	augroup resetCursor
		autocmd!
		autocmd VimEnter * silent !echo -ne "\e[2 q"
	augroup END
endif


"""" Misc

"filetype on
"filetype plugin on
"syntax enable
set encoding=utf8

"" filetype dialect defaults
" &ft=sh, flavor 'posix shell'
let g:is_sh = 1
" &ft=sql, flavor 'PostgreSQL'
let g:sql_type_default = 'pgsql'
" &ft=scheme, flavor 'CHICKEN'
let g:is_chicken = 1
" &ft=tex, flavor 'LaTeX'
let g:tex_flavor = 'latex'

"" auto-formatting
set autoindent smartindent
set noexpandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set fileformats=unix,dos
set nowrap nolist
set fixeol

"" smart searching
set incsearch
set ignorecase smartcase
set tagcase=followscs

"" other
set hidden
set noautoread noautowrite
set lazyredraw
set showcmd
set updatetime=100
set mouse=a
set number relativenumber
set showmatch
set errorbells
set foldmethod=manual
set sessionoptions+=localoptions
set scrolloff=1
set splitright splitbelow



"  Plugin-Keymaps
""""""""""""""""""""

"" move
nmap <C-Up> <Plug>MoveLineUp
vmap <C-Up> <Plug>MoveBlockUp
nmap <C-Down> <Plug>MoveLineDown
vmap <C-Down> <Plug>MoveBlockDown
nmap <C-Right> <Plug>MoveCharRight
vmap <C-Right> <Plug>MoveBlockRight
nmap <C-Left> <Plug>MoveCharLeft
vmap <C-Left> <Plug>MoveBlockLeft

"" grep
nnoremap <Leader>g :Ack!<Space>
"nnoremap <Leader>G :AckFile<Space>
nnoremap <Leader>G :CustomAckFile<Space>
nnoremap <Leader>/ :AckWindow!<Space>

"" fern
nnoremap <silent> <Leader>t :Fern . -drawer -reveal=% -stay -toggle<CR>

"" vista
nnoremap <silent> <Leader>v :Vista!!<CR>

"" ale
nnoremap <silent> <Leader>ad :ALEGoToDefinition<CR>
nnoremap <silent> <Leader>aD :ALEGoToTypeDefinition<CR>
nnoremap <silent> <Leader>ah :ALEHover<CR>
nnoremap <silent> <Leader>au :ALEFindReferences<CR>
nnoremap <silent> <Leader>ar :ALERename<CR>
nnoremap <silent> <Leader>[ :ALEPreviousWrap<CR>
nnoremap <silent> <Leader>] :ALENextWrap<CR>
nnoremap <Leader>as :ALESymbolSearch<Space>

"" lsp
nnoremap <silent> <Leader>ld :LspDefinition<CR>
nnoremap <silent> <Leader>lD :LspTypeDefinition<CR>
nnoremap <silent> <Leader>lh :LspHover<CR>
nnoremap <silent> <Leader>li :LspImplementation<CR>
nnoremap <silent> <Leader>lu :LspReferences<CR>
nnoremap <silent> <Leader>lr :LspRename<CR>
nnoremap <silent> <Leader>la :LspDocumentSwitchSourceHeader<CR>
nnoremap <silent> <Leader>= :LspNextReference<CR>
nnoremap <silent> <Leader>- :LspPreviousReference<CR>
nnoremap <Leader>ls :LspWorkspaceSymbol<Space>

"" padline
imap <LocalLeader>; <Plug>PadLineAbove
imap <LocalLeader>' <Plug>PadLineBelow
imap <LocalLeader><CR> <Plug>PadLineAround
nmap <LocalLeader>; <Plug>PadLineAbove
nmap <LocalLeader>' <Plug>PadLineBelow
nmap <LocalLeader><CR> <Plug>PadLineAround
vmap <LocalLeader>; <Plug>PadBlockAbove
vmap <LocalLeader>' <Plug>PadBlockBelow
vmap <LocalLeader><CR> <Plug>PadBlockAround
imap <LocalLeader>: <Plug>UnpadLineAbove
imap <LocalLeader>" <Plug>UnpadLineBelow
imap <LocalLeader><BS> <Plug>UnpadLineAround
nmap <LocalLeader>: <Plug>UnpadLineAbove
nmap <LocalLeader>" <Plug>UnpadLineBelow
nmap <LocalLeader><BS> <Plug>UnpadLineAround
vmap <LocalLeader>: <Plug>UnpadBlockAbove
vmap <LocalLeader>" <Plug>UnpadBlockBelow
vmap <LocalLeader><BS> <Plug>UnpadBlockAround

"" nvim-dap
if has("nvim")
	nnoremap <silent> <F2> :lua require'dap.ui.widgets'.centered_float(require'dap.ui.widgets'.scopes)<CR>
	nnoremap <silent> <F3> :lua require'dap'.set_breakpoint(vim.fn.input('condition: '))<CR>
	nnoremap <silent> <F4> :lua require'dap'.toggle_breakpoint()<CR>
	nnoremap <silent> <F5> :lua require'dap'.run_to_cursor()<CR>
	nnoremap <silent> <F6> :lua require'dap'.step_out()<CR>
	nnoremap <silent> <F7> :lua require'dap'.step_into()<CR>
	nnoremap <silent> <F8> :lua require'dap'.step_over()<CR>
	nnoremap <silent> <F9> :lua require'dap'.configurations={}<CR>:lua require'dap.ext.vscode'.load_launchjs()<CR>:lua require'dap'.continue()<CR>
	nnoremap <silent> <F10> :lua require'dap'.disconnect()<CR>:lua require'dap'.close()<CR>:lua vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)<CR>
	nnoremap <silent> <F12> :lua require'dap'.repl.toggle()<CR>
endif



"  Keymaps
"""""""""""""

nnoremap Q @q
vnoremap <silent> Q :norm @q<CR>

"" support various CTRL maps in terminal
map  <C-@> <C-Space>
map! <C-@> <C-Space>
map  [1;5A <C-Up>
map! [1;5A <C-Up>
map  [1;5B <C-Down>
map! [1;5B <C-Down>
map  [1;5C <C-Right>
map! [1;5C <C-Right>
map  [1;5D <C-Left>
map! [1;5D <C-Left>

"" select last change
nnoremap gV `[v`]

"" don't start a new change on <Left> and <Right>
inoremap <Right> <C-G>U<Right>
inoremap <Left> <C-G>U<Left>

"" adjust `Y` to work like `C` and `D`
nnoremap Y y$

"" open/close quickfix-/location-/preview-window
nnoremap <silent> =q :cclose<CR>
nnoremap <silent> =Q :copen<CR>
nnoremap <silent> =l :lclose<CR>
nnoremap <silent> =L :lopen<CR>
nnoremap <silent> =w :pclose<CR>

nnoremap <Leader><Space> :buffer<Space>
"" alternate buffers
nnoremap <Leader><Tab> <C-^>
inoremap <LocalLeader><Tab> <C-\><C-O><C-^>
"" alternate windows
nnoremap <Leader>` <C-W><C-P>
inoremap <LocalLeader>` <C-\><C-O><C-W><C-P>
"" open alternate buffer, with vertical split
nnoremap <silent> <Leader><S-Tab> :vertical wincmd ^<CR>
inoremap <silent> <LocalLeader><S-Tab> <C-\><C-O>:vertical wincmd ^<CR>
"" open alternate buffer, with horizontal split
nnoremap <Leader>~ <C-W><C-^>
inoremap <LocalLeader>~ <C-\><C-O><C-W><C-^>

"" open a buffer with vertical split
cnoreabbrev vsb vertical sbuffer

"" save changes of current buffer to disk
nnoremap <silent> ZX :update<CR>
"" save all changed buffers to disk
nnoremap <silent> ZA :wall<CR>



"  Custom VimScript
""""""""""""""""""""""

"""" 3rd Party

"" autocmd-based
augroup customThirdPartyVimScript
	autocmd!

	"" add current file extension to `gf` file lookup
	"" (https://stackoverflow.com/questions/33093491/vim-gf-with-file-extension-based-on-current-filetype#comment89565052_33093491)
	autocmd BufRead * execute 'setlocal suffixesadd+=.' . expand('%:e')
augroup END

"" enable persistent undo
"" (https://stackoverflow.com/a/22676189)
let undodirectory = expand(StdpathShim('data') . '/undo')
if has('persistent_undo')
	:call mkdir(undodirectory, "p")
	let &undodir = undodirectory
	set undofile
endif

"" save/restore view on buffer switching
"" (https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers)
function! AutoSaveWinView()
	if !exists("w:SavedBufView")
		let w:SavedBufView = {}
	endif
	let w:SavedBufView[expand("%:p")] = winsaveview()
endfunction
function! AutoRestoreWinView()
	let buf = expand("%:p")
	if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
		let v = winsaveview()
		let atStartOfFile = v.lnum == 1 && v.col == 0
		if atStartOfFile && !&diff
			call winrestview(w:SavedBufView[buf])
		endif
		unlet w:SavedBufView[buf]
	endif
endfunction
augroup saveRestoreWinBufView
	autocmd BufLeave * call AutoSaveWinView()
	autocmd BufEnter * call AutoRestoreWinView()
augroup END

"""" 1st Party

"" custom :AckFile that works with the ripgrep backend
:command! -nargs=1 CustomAckFile :Ack! --files -g *<args>*

