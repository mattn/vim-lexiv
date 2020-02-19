let s:pair = {
\  '"':  '"',
\  '''':  '''',
\  '`':  '`',
\  '{':  '}',
\  '[':  ']',
\  '(':  ')',
\}
let s:stop = ",=:})] \t"
let s:backquote_open_whitelist = ['markdown']
let s:quote_open_blacklist = {'vim': '"'}

function! lexiv#backquote_open() abort
  if index(s:backquote_open_whitelist, &filetype) != -1 && getline('.') == '``'
	  return "\<c-g>U\<esc>A`\<cr>\<cr>```\<up>"
  endif
  return lexiv#quote_open('`')
endfunction

function! lexiv#quote_open(lhs) abort
  if has_key(b:, 'asyncomplete_refresh_pattern') && a:lhs =~ b:asyncomplete_refresh_pattern
    return a:lhs
  endif
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:pos ># 1 && l:line[l:pos - 2] ==# a:lhs && l:line[l:pos - 1] !=# a:lhs
    return a:lhs
  elseif !has_key(s:quote_open_blacklist, &filetype) && (l:line[l:pos - 1] =~# '^[,)}]' || l:line[l:pos - 1] == '')
    return a:lhs . a:lhs . "\<c-g>U\<left>"
  elseif has_key(s:quote_open_blacklist, &filetype) && a:lhs ==# s:quote_open_blacklist[&filetype] && l:pos ># 1 && stridx(" \t",  l:line[l:pos - 2]) == -1
    return a:lhs . a:lhs . "\<c-g>U\<left>"
  elseif l:line[l:pos - 1] ==# a:lhs && l:pos <= len(l:line) && l:line[l:pos] !=# a:lhs
    return "\<c-g>U\<right>"
  endif
  let l:lhs = l:line[l:pos-2]
  let l:rhs = l:line[l:pos-1]
  if has_key(s:pair, l:lhs) && s:pair[l:lhs] ==# l:rhs
    return a:lhs . a:lhs . "\<c-g>U\<left>"
  endif
  return a:lhs
endfunction

function! lexiv#paren_close(rhs) abort
  let l:pos = getpos('.')[2]
  let l:line = getline('.')
  if l:pos ==# 1
    if reg_executing() !=# ''
      return a:rhs . "\n"
    endif
    return a:rhs
  elseif l:line[l:pos - 1] !=# a:rhs
    if reg_executing() !=# ''
      return a:rhs . "\n"
    endif
    return a:rhs
  endif
  return "\<c-g>U\<right>"
endfunction

function! lexiv#paren_open(lhs) abort
  if has_key(b:, 'asyncomplete_refresh_pattern') && a:lhs =~ b:asyncomplete_refresh_pattern
    return a:lhs
  endif
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
