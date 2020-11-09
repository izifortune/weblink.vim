" Vim global plugin for copying to clipboard the current link to share with teammates
" Last Change:	2020-10-03
" Maintainer:	Fabrizio Fortunato <fortune@cortesconta.net>
" License:	This file is placed in the public domain.

" if exists('g:loaded_weblink')
"   finish
" endif

let s:save_cpo = &cpo
set cpo&vim

function! s:getRepoInfo() abort
  let l:urlList = split(split(system('git config --get remote.origin.url'), '@')[1], '/')
  let l:branch = system('git branch --show-current')

  let l:hostinfo = split(l:urlList[0], ':')

  if l:hostinfo[0] ==# 'github.com'
    let l:project = ''
    let l:repo = substitute(l:urlList[-1], '\.git.*', '', '')
    let l:username = l:hostinfo[1]
    let l:type = 'github'
  elseif l:hostinfo[0] =~ 'stash.*'
    let l:project = l:urlList[-2]
    let l:repo = substitute(l:urlList[-1], '\.git.*', '', '')
    let l:type = 'stash'
    let l:username = ''
  endif

  let l:res = {
        \'project': l:project,
        \'repo': l:repo,
        \'type': l:type, 
        \'username': l:username,
        \'branch': l:branch, 
        \'host': l:hostinfo[0]}
  return l:res
endfunction


function! s:generateUrl(repoInfo, filepath, includeLine) abort
  let l:filename = expand('%:t')
  if a:repoInfo.type ==# 'github'
    let l:url = join(['https://github.com', a:repoInfo.username, a:repoInfo.repo, 
          \ 'blob', a:repoInfo.branch, a:filepath, l:filename], '/')
    if a:includeLine
      let l:url .= '#L'. getcurpos()[1]
    endif
  elseif a:repoInfo.type ==# 'stash'
    if len(a:filepath)
      let l:path = a:filepath . '/' . l:filename
    else
      let l:path = l:filename
    endif
    let l:url = join(['https://', a:repoInfo.host, 'projects', a:repoInfo.project,
          \ 'repos', a:repoInfo.repo, 'browse', l:path], '/')
    if a:includeLine
      let l:url .= '#'. getcurpos()[1]
    endif
    if empty(a:repoInfo.branch) == 0
      let l:url .=  '?at=' . a:repoInfo.branch
    endif
  endif


  return l:url
endfunction

function! s:copyToClipboard(url) abort
  let @+ = a:url
endfunction


" Get a weblink of the current file.
" Useful for sharing snippets and code with collegues
" Passing an argument will also append the current line in the url
function! s:WebLink(...) abort
  let l:res = s:getRepoInfo()
  let l:filepath = split(expand('%:p:h'), l:res['repo'] . '/')

  if len(l:filepath) == 1
    let l:filepath = ''
  else
    let l:filepath = l:filepath[1]
  endif

  " We are looking to stay always in the default branch
  if l:res.type ==# 'github'
    let l:res.branch = 'main'
  elseif l:res.type ==# 'stash'
    let l:res.branch = ''
  endif

  let l:url = s:generateUrl(l:res, l:filepath, a:0)
  call s:copyToClipboard(l:url)
endfunction

" Get a weblink of the current file in the current branch
function! s:WebLinkBranch(...) abort
  let l:res = s:getRepoInfo()
  let l:filepath = split(expand('%:p:h'), l:res['repo'] . '/')

  if len(l:filepath) == 1
    let l:filepath = ''
  else
    let l:filepath = l:filepath[1]
  endif

  let l:url = s:generateUrl(l:res, l:filepath, a:0)
  call s:copyToClipboard(l:url)
endfunction

command! -nargs=? WebLink call s:WebLink(<f-args>)
command! -nargs=? WebLinkBranch call s:WebLinkBranch(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_weblink = 1
