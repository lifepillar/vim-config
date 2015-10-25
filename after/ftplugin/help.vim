  fun! BuildHelpStatusLine(nr)
    return '%{SetupStl('.a:nr.')}
          \%#CurrMode#%{w:["lf_active"] ? "  HELP " : ""}
          \%#SepMode#%{w:["lf_active"] ? g:left_sep_sym : ""}%*
          \%{w:["lf_active"] ? "" : "  HELP"}
          \ %<%f
          \ %=
          \ %#SepMode#%{w:["lf_active"] && w:["lf_winwd"] >= 60 ? g:right_sep_sym : ""}
          \%#CurrMode#%{w:["lf_active"] && w:["lf_winwd"] >= 60 ? g:pad . printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$")) : ""}%*'
  endf

setlocal statusline=%!BuildHelpStatusLine(winnr())

nnoremap <silent> <buffer> <tab> <c-w><c-w>
nnoremap <silent> <buffer> q <c-w>c

