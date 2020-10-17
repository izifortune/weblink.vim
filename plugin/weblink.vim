" Vim global plugin for copying to clipboard the current link to share with teammates
" Last Change:	2020-10-03
" Maintainer:	Fabrizio Fortunato <fortune@cortesconta.net>
" License:	This file is placed in the public domain.

if exists("g:loaded_weblink")
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let s:host_type = get(g:, 'weblink_host_type')
let s:host_url = get(g:, 'weblink_host_url')
let s:host_url_prefix = get(g:, 'weblink_host_url_prefix', '/projects/')


function! s:generateUrl(project, repo, filepath, ...) abort
  let l:filename = expand('%:t')
  let l:url = s:host_url . s:host_url_prefix . a:project .  "/repos/" . a:repo . "/browse" . a:filepath . "/" . l:filename

  if a:0 
    let l:url .=  "?at=" . a:0
  endif

  return l:url
endfunction

function! s:copyToClipboard(url, addLineNumber) abort
  if a:addLineNumber
    let @+ = a:url . '#'. getcurpos()[1]
  else
    let @+ = a:url
  endif
endfunction


" Get a weblink of the current file in our company stash
" Useful for sharing snippets and code with collegues
" Passing an argument will also append the current line in the url
function! s:WebLink(...) abort
  let l:urlList = split(system("git config --get remote.origin.url"), '/')
  let l:project = l:urlList[-2]
  let l:repo = substitute(l:urlList[-1], '\.git.*', '', '')
  let l:filepath = split(expand('%:p:h'), l:repo)
  if len(l:filepath) == 1
    let l:filepath = ''
  else
    let l:filepath = l:filepath[1]
  endif

  let l:url = s:generateUrl(l:project, l:repo, l:filepath)
  call s:copyToClipboard(l:url, a:0)
endfunction

" Get a weblink of the current file in our company stash with current branch
" selected
function! s:WebLinkBranch(...) abort
  let l:urlList = split(system("git config --get remote.origin.url"), '/')
  let l:branch = system("git branch --show-current")
  let l:project = l:urlList[-2]
  let l:repo = substitute(l:urlList[-1], '\.git.*', '', '')
  let l:filepath = split(expand('%:p:h'), l:repo)
  if len(l:filepath) == 1
    let l:filepath = ''
  else
    let l:filepath = l:filepath[1]
  endif

  let l:url = s:generateUrl(l:project, l:repo, l:filepath, l:branch)

  call s:copyToClipboard(l:url, a:0)
endfunction

command! -nargs=? WebLink call s:WebLink(<f-args>)
command! -nargs=? WebLinkBranch call s:WebLinkBranch(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_weblink = 1
