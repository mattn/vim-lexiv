inoremap <expr> " lexiv#string_open('"')
inoremap <expr> ' lexiv#string_open("'")
inoremap <expr> { lexiv#paren_open('{')
inoremap <expr> ( lexiv#paren_open('(')
inoremap <expr> [ lexiv#paren_open('[')
inoremap <expr> } lexiv#paren_close('}')
inoremap <expr> ) lexiv#paren_close(')')
inoremap <expr> ] lexiv#paren_close(']')
inoremap <expr> <cr> lexiv#paren_expand()
inoremap <expr> <bs> lexiv#paren_delete()
