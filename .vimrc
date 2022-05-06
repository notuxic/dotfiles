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
Plug 'mhinz/vim-grepper'
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
"" latex
Plug 'lervag/vimtex'
"" linting, fixing, ...
Plug 'dense-analysis/ale'
"" lsp client
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

if has('nvim')
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	"" dap client
	Plug 'mfussenegger/nvim-dap'
	Plug 'theHamsta/nvim-dap-virtual-text'
elseif has('python3')
	"" dap client
	Plug 'puremourning/vimspector'
endif

"""" Dependencies

"" xolox/vim-session
Plug 'xolox/vim-misc'
"" glts/vim-radical
Plug 'glts/vim-magnum'
"" tpope/vim-surround tpope/vim-speeddating glts/vim-radical
Plug 'tpope/vim-repeat'
if has('nvim')
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

"" grepper
runtime plugin/grepper.vim
let g:grepper.quickfix = 0
let g:grepper.jump = 0
let g:grepper.prompt = 1
let g:grepper.prompt_text = 'grep: '
let g:grepper.prompt_quote = 1
let g:grepper.prompt_mapping_tool = '<C-S-T>'
let g:grepper.prompt_mapping_dir = '<C-S-D>'
let g:grepper.prompt_mapping_side = '<C-S-S>'
let g:grepper.dir = 'cwd'
let g:grepper.side = 0
let g:grepper.tools = ['rg', 'grep']


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
let g:ale_disable_lsp = 1
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
let g:lsp_document_code_action_signs_enabled = 0
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
	local dap = require('dap')

	-- nvim-dap
	vim.fn.sign_define('DapBreakpoint', {text='●', texthl='Error', linehl='', numhl=''})
	vim.fn.sign_define('DapBreakpointCondition', {text='◉', texthl='Error', linehl='', numhl=''})
	vim.fn.sign_define('DapLogPoint', {text='◆', texthl='Constant', linehl='', numhl=''})
	vim.fn.sign_define('DapBreakpointRejected', {text='◌', texthl='Error', linehl='', numhl=''})
	vim.fn.sign_define('DapStopped', {text='', texthl='Constant', linehl='CursorLine', numhl=''})

	-- nvim-dap-virtual-text
	require('nvim-dap-virtual-text').setup {
		enabled = true,
		enabled_commands = true,
		highlight_changed_variables = true,
		highlight_new_as_changed = true,
		show_stop_reason = true,
		commented = true
	}

	-- adapter: lldb-vscode: c/c++/rust
	dap.adapters.lldb = {
		type = 'executable',
		command = 'lldb-vscode',
		name = 'lldb'
	}
	dap.adapters.c = dap.adapters.lldb
	dap.adapters.cpp = dap.adapters.lldb
	dap.adapters.rust = dap.adapters.lldb

	-- adapter: debugpy: python
	dap.adapters.python = {
		type = 'executable',
		command = 'python3',
		args = {'-m', 'debugpy.adapter'}
	}
EOF

"" vimspector
elseif has('python3')
	sign define vimspectorBP text=● texthl=Error
	sign define vimspectorBPCond text=◉ texthl=Error
	sign define vimspectorBPLog text=◆ texthl=Constant
	sign define vimspectorBPDisabled text=◌ texthl=Error
	sign define vimspectorPC text= texthl=Constant linehl=CursorLine
	sign define vimspectorPCBP text= texthl=Error linehl=CursorLine

	let g:vimspector_adapters = {
\		'lldb-vscode' : {
\			'name': 'lldb-vscode',
\			'command': 'lldb-vscode'
\		},
\		'debugpy': {
\			'name': 'debugpy',
\			'command': ['python3', '-m', 'debugpy.adapter'],
\			'configuration': {
\				'python': 'python3',
\				'subProcess': v:false
\			}
\		}
\	}
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
augroup colorNeoSolarized
	autocmd!
	autocmd ColorScheme NeoSolarized highlight clear MatchParen
	autocmd ColorScheme NeoSolarized highlight MatchParen term=reverse cterm=bold ctermbg=10 gui=bold guibg=#1f4a54
	autocmd ColorScheme NeoSolarized highlight ToolbarLine ctermbg=10 guibg=#586e75
augroup END
colorscheme NeoSolarized

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

"" grepper
nnoremap <Leader>g :Grepper<CR>
nnoremap <Leader>G :Grepper -dir repo<CR>

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

if has('nvim')
	"" nvim-dap
	nnoremap <silent> <F2> :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('message: '))<CR>
	nnoremap <silent> <F3> :lua require'dap'.set_breakpoint(vim.fn.input('condition: '))<CR>
	nnoremap <silent> <F4> :lua require'dap'.toggle_breakpoint()<CR>
	nnoremap <silent> <F5> :lua require'dap'.run_to_cursor()<CR>
	nnoremap <silent> <F6> :lua require'dap'.step_out()<CR>
	nnoremap <silent> <F7> :lua require'dap'.step_into()<CR>
	nnoremap <silent> <F8> :lua require'dap'.step_over()<CR>
	nnoremap <silent> <F9> :lua require'dap'.configurations={}<CR>:lua require'dap.ext.vscode'.load_launchjs()<CR>:lua require'dap'.continue()<CR>
	nnoremap <silent> <F10> :lua require'dap'.disconnect()<CR>:lua require'dap'.close()<CR>:lua vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)<CR>
	nnoremap <silent> <F11> :lua require'dap'.list_breakpoints()<CR>:copen<CR>
	nnoremap <silent> <F12> :lua require'dap.ui.widgets'.centered_float(require'dap.ui.widgets'.scopes)<CR>
elseif has('python3')
	"" vimspector
	nnoremap <silent> <F2> :call vimspector#ToggleBreakpoint({'logMessage': input('message: ')})<CR>
	nnoremap <silent> <F3> :call vimspector#ToggleBreakpoint({'condition': input('condition: ')})<CR>
	nnoremap <silent> <F4> <Plug>VimspectorToggleBreakpoint
	nnoremap <silent> <F5> <Plug>VimspectorRunToCursor
	nnoremap <silent> <Leader><F5> <Plug>VimspectorGoToCurrentLine
	nnoremap <silent> <F6> <Plug>VimspectorStepOut
	nnoremap <silent> <F7> <Plug>VimspectorStepInto
	nnoremap <silent> <F8> <Plug>VimspectorStepOver
	nnoremap <silent> <F9> <Plug>VimspectorContinue
	nnoremap <silent> <F10> :call vimspector#Reset({'interactive': v:false})<CR>
	nnoremap <silent> <F11> :call setqflist(vimspector#GetBreakpointsAsQuickFix()) <Bar> copen<CR>
	nnoremap <Leader><F11> :VimspectorEval<Space>
	vnoremap <silent> <Leader><F11> <Plug>VimspectorBalloonEval
	nnoremap <silent> <F12> :VimspectorWatch <C-R><C-W><CR>
	nnoremap <Leader><F12> :VimspectorWatch<Space>
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

