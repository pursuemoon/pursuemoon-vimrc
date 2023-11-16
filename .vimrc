set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'
Plug 'ryanoasis/vim-devicons'

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install()  }, 'for': ['markdown', 'vim-plug'] }

Plug 'godlygeek/tabular'
Plug 'frazrepo/vim-rainbow'
Plug 'Chiel92/vim-autoformat'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

filetype plugin indent on
syntax on

let mapleader = ";"

let g:platform_is_windows = has('win64') || has('win32')
let g:editor_is_neovim = has('nvim')

if g:platform_is_windows
    set mouse=a
    set helplang=ch
    set langmenu=zh_CN.UTF-8
    if g:editor_is_neovim
        set t_Co=256
        colorscheme gruvbox
    endif
else
    set mouse=c
    set helplang=en
    set langmenu=en_US.UTF-8
    set t_Co=256
    colorscheme gruvbox
endif

set backspace=indent,eol,start
set vb t_vb=""
set number
set nowrap
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set encoding=UTF-8
set hlsearch
set relativenumber
set nobackup
set nowritebackup
set splitright

autocmd FileType markdown setlocal wrap

function! GetBufferSize()
    let w:buffer_size = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    return w:buffer_size
endfunction

function! ExitCurrentBuffer()
    call GetBufferSize() | let current_nr = bufnr('%')
    if w:buffer_size > 1 | bn | execute 'bdelete ' current_nr | else | q | endif
endfunction

nnoremap fw :w<cr>
nnoremap fq :call ExitCurrentBuffer()<cr>
nnoremap fwq :w \| call ExitCurrentBuffer()<cr>

function! TagCurrentWord()
    let word = expand('<cword>') | execute 'tag ' word
endfunction

nnoremap <leader>t :call TagCurrentWord()<cr>

nnoremap J :bp<cr>
nnoremap K :bn<cr>
nnoremap <leader>1 :b 1<cr>
nnoremap <leader>2 :b 2<cr>
nnoremap <leader>3 :b 3<cr>
nnoremap <leader>4 :b 4<cr>
nnoremap <leader>5 :b 5<cr>
nnoremap <leader>6 :b 6<cr>
nnoremap <leader>7 :b 7<cr>
nnoremap <leader>8 :b 8<cr>
nnoremap <leader>9 :b 9<cr>

nnoremap SS :split<cr><c-w>w
nnoremap VS :vsplit<cr><c-w>w
nnoremap <leader>w <c-w>w
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>h <c-w>h
nnoremap <leader>l <c-w>l
nnoremap <leader>v <c-v>

nnoremap yw viw"+y
nnoremap y "+y
vnoremap <c-c> "+y

nnoremap <c-u> viwU
vnoremap <c-u> iwUv
inoremap <c-u> <esc>viwUi
nnoremap <c-l> viwu
vnoremap <c-l> iwuv
inoremap <c-l> <esc>viwui

nnoremap <leader>< i&lt;<esc>
nnoremap <leader>> i&gt;<esc>
inoremap <leader>< &lt;
inoremap <leader>> &gt;

vnoremap <leader>J :'<,'>!python3 -m json.tool<cr>

function! CompileAndRun()
    execute "w"
    let time_cmd = g:platform_is_windows ? "timecmd" : "time"
    if &filetype == 'c'
        execute "!clang % -o %<"
        execute "!time ./%<"
    elseif &filetype == 'cpp'
        execute "!clang++ % -g -fsanitize=address -fno-omit-frame-pointer -fdiagnostics-color=always -o %<"
        execute "!" time_cmd " %<"
    elseif &filetype == 'sh'
        execute "!time zsh %"
    elseif &filetype == 'python'
        execute "!time python3 %"
    endif
endfunction

nnoremap <f5> :call CompileAndRun()<cr>

function! SyncVimConfig()
    let vim_config_path = $MY_VIM_CONFIG_PATH
    let neovim_config_path = $MY_NEOVIM_CONFIG_PATH
    if strlen(vim_config_path) == 0
        echoerr "$MY_VIM_CONFIG_PATH is required but not set."
    elseif strlen(neovim_config_path) == 0
        echoerr "$MY_NEOVIM_CONFIG_PATH is required but not set."
    else
        execute "!cp" vim_config_path neovim_config_path
        echo "Vim configure is synchronized."
    endif
endfunction


" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '


" vim-airline-themes
let g:airline_theme = 'understated'


" nerdtree
nnoremap <f3> :NERDTreeToggle<cr>
nnoremap <f4> :NERDTreeFind<cr>
let g:NERDTreeWinPos = 'left'
let g:NERDTreeWinSize = 46
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeHidden = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
autocmd VimEnter * NERDTree | wincmd p
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" nerdcommenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1


" markdown-preview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_auto_open = 1
let g:mkdp_theme = 'light'
let g:mkdp_page_title = '${name}'
let g:mkdp_refresh_slow = 1
let g:mkdp_brower = ''
let g:mkdp_browserfunc = ''
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \}
nnoremap <f9> :MarkdownPreviewToggle<cr>


" tabular
nnoremap <leader>\| :Tab /\|<cr>
vnoremap <leader>\| :Tab /\|<cr>
nnoremap <leader>= :Tab /=<cr>
vnoremap <leader>= :Tab /=<cr>
nnoremap <leader>\ :Tab /\<cr>
vnoremap <leader>\ :Tab /\<cr>


" vim-rainbow
let g:rainbow_active = 1

let g:rainbow_load_separately = [
    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
    \ ]

let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']


" vim-autoformat
let g:autoformat_verbosemode = 1


" coc.nvim
set updatetime=300
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> <leader>k :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('<leader>k', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

