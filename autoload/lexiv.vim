let s:pair = {
\  '"':  '"',
\  '''':  '''',
\  '{':  '}',
\  '[':  ']',
\  '(':  ')',
\}
let s:stop = ",=:})] \t"

function! lexiv#string_open(lhs) abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:line[l:pos - 1] =~# '^[,)}]'
    return a:lhs . a:lhs . "\<c-g>U\<left>"
  elseif l:line[l:pos - 1] =~# a:lhs
    return "\<c-g>U\<right>"
  endif
  return a:lhs
endfunction

function! lexiv#paren_close(rhs) abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:pos ==# 1
    return a:rhs
  elseif l:line[l:pos - 1] !=# a:rhs
    return a:rhs
  endif
  return "\<c-g>U\<right>"
endfunction

function! lexiv#paren_open(lhs) abort
  let l:pos = getpos('.')[2]	
  let l:line = getline('.')
  if l:pos >=# 1
    let [l:lhs, l:rhs] = [a:lhs, s:pair[a:lhs]]
    if stridx(s:stop, l:line[l:pos - 1]) ==# -1 && len(l:line) !=# l:pos - 1
      return a:lhs	
    endif
  endif
  return l:lhs . l:rhs . "\<c-g>U\<left>"
endfunction

function! lexiv#paren_expand() abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:pos <# 2
    return "\<cr>"
  endif
  let l:lhs = l:line[l:pos-2]
  let l:rhs = l:line[l:pos-1]
  if has_key(s:pair, l:lhs) && s:pair[l:lhs] ==# l:rhs
    return "\<cr>\<c-\>\<c-o>O"
  endif
  return "\<cr>"
endfunction

function! lexiv#paren_delete() abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:pos <# 2
    return "\<bs>"
  endif
  let l:lhs = l:line[l:pos-2]
  let l:rhs = l:line[l:pos-1]
  if has_key(s:pair, l:lhs) && s:pair[l:lhs] ==# l:rhs
    return "\<c-g>U\<right>\<bs>\<bs>"
  endif
  return "\<bs>"
endfunction
