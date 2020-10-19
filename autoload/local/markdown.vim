" Partially inspired by https://vimways.org/2019/personal-notetaking-in-vim/

fun! local#markdown#set_arglist(result)
  execute "args" join(map(a:result, 'fnameescape(v:val) .. ".md"'))
endf

fun! local#markdown#notes(base)
  return map(glob(printf('**/%s*.md', a:base), 1, 1, 0), 'fnamemodify(v:val, ":r")')
endf

" Search for #tags matching base in the Markdown files inside the current directory.
" NOTE: ctags doesn't cut it here, because it would return at most one tag per line.
fun! local#markdown#tags(base)
  let l:grep = executable('rg') ? 'rg': 'grep'
  return systemlist("rg -o --no-line-number --no-heading --trim -I ' " .. (a:base == '#' ? '#[a-z]' : a:base) .. "[a-z0-9]*' **/*.md | sort | uniq")
endf

" Suggest notes (i.e., Markdown files) in the current directory after [[ or tags after #.
fun! local#markdown#complete(findstart, base)
  if a:findstart
    let l:col = match(getline('.'), '\%(#[a-z]*\|[[\zs\S*\)\%' .. col('.') .. 'c')
    return l:col == -1 ? -3 : l:col
  else
    if a:base =~# '^#'
      return local#markdown#tags(a:base)
    else
      let s:matches = local#markdown#notes(a:base)
      return map(s:matches, '{"word": fnamemodify(v:val, ":t"), "abbr": v:val}')
    endif
  endif
endf

fun! local#markdown#fold(lnum)
  return getline(a:lnum) =~# '\m^ \{,3}#\+ \+'
        \ ? '>' .. (1 + indent(a:lnum) / shiftwidth())
        \ : '='
endf

fun! local#markdown#foldtext()
  return getline(v:foldstart)
endf

