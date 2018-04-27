" Omni completion for latex documents
" Author: Hans Hohenfeld <hans.hohenfeld@posteo.de>
" License: GPLv3
" URL: https://github.com/d3rhans/vim-lxfun

let s:save_cpo = &cpoptions
set cpoptions&vim

if exists('g:loaded_lxfun')
  finish                                           
endif

let g:loaded_lxfun = 1

let g:lxfun_db_dir = $HOME . '/.vim/lxfun/'
let g:lxfun_env_db = 'envs.txt'

" Environments for completion
let g:lxfun_envs = { 'changed': 0, 'db': [] }

try
    let g:lxfun_envs.db = readfile(g:lxfun_db_dir . g:lxfun_env_db)
catch
endtry

augroup lxfun
autocmd FileType tex set omnifunc=lxfun#complete
augroup END

let &cpoptions = s:save_cpo
unlet s:save_cpo
