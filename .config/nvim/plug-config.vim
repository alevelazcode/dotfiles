let g:vim_vue_plugin_config = { 
      \'syntax': {
      \   'template': ['html', 'pug'],
      \   'script': ['javascript', 'typescript', 'coffee'],
      \   'style': ['css', 'scss', 'sass', 'less', 'stylus'],
      \   'i18n': ['json', 'yaml'],
      \   'route': 'json',
      \},
      \'full_syntax': ['json'],
      \'initial_indent': ['i18n', 'i18n.json', 'yaml'],
      \'attribute': 1,
      \'keyword': 1,
      \'debug': 0,
      \}

function! LightlineWebDevIcons(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  return WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
endfunction
   
function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction
  
function! MyFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endfunction
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction


"highlight Pmenu ctermbg=gray guibg=gray
"autocmd! FileType fzf set laststatus=0 noshowmode noruler
"      \|autocmd BufLeave <buffer> set laststatus=2 showmode ruler
"""let g:fzf_layout = {'left': '20%'}
let g:fzf_action = {
      \'enter': 'tab split',
      \'ctrl-v': 'vsplit',
      \'ctrl-h':'split'}

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


au! BufRead,BufNewFile *.rsh setfiletype javascript

let g:closetag_filetypes= 'html,jsx,javascriptreact,javascript,typescript, typescriptreact, tsx'  
"let g:node_client_debug= 1
"
