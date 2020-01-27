let s:pair = {
\  '"':  '"',
\  '''':  '''',
\  '{':  '}',
\  '[':  ']',
\  '(':  ')',
\}

function! s:string_open(lhs) abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:line[l:pos - 1] =~ '^[,)}]'
    return a:lhs . a:lhs . "\<left>"
  elseif l:line[l:pos - 1] =~ a:lhs
    return "\<right>"
  endif
  return a:lhs
endfunction

function! s:paren_close(rhs) abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:pos == 1
    return a:rhs
  elseif l:line[l:pos - 1] != a:rhs
    return a:rhs
  endif
  return "\<right>"
endfunction

function! s:paren_open(lhs) abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  let [l:lhs, l:rhs] = [a:lhs, s:pair[a:lhs]]
  if l:line[l:pos] == l:rhs || len(l:line) != l:pos - 1
    return a:lhs
  endif
  return l:lhs . l:rhs . "\<left>"
endfunction

function! s:paren_expand() abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:pos < 2
    return "\<cr>"
  endif
  let l:lhs = l:line[l:pos-2]
  let l:rhs = l:line[l:pos-1]
  if has_key(s:pair, l:lhs) && s:pair[l:lhs] == l:rhs
    return "\<cr>\<esc>O"
  endif
  return "\<cr>"
endfunction

inoremap <expr> " <SID>string_open('"')
inoremap <expr> ' <SID>string_open("'")
inoremap <expr> { <SID>paren_open('{')
inoremap <expr> ( <SID>paren_open('(')
inoremap <expr> [ <SID>paren_open('[')
inoremap <expr> } <SID>paren_close('}')
inoremap <expr> ) <SID>paren_close(')')
inoremap <expr> ] <SID>paren_close(']')
inoremap <expr> <cr> <SID>paren_expand()
