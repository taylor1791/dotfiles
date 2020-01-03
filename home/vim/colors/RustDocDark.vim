" To view the current colors use:
"  > :so $VIMRUNTIME/syntax/hitest.vim

let s:alert1 = "#aa1111"
let s:alert2 = "#aaaa11"
let s:alert3 = "#aa6611"
let s:color1 = "#ab8ac1"
let s:color2 = "#769acb"
let s:color3 = "#83a300"
let s:color4 = "#ee6868"
let s:color5 = "#3E999F"
let s:color6 = "#d97f26"
let s:shade1 = "#2a2a2a"
let s:shade2 = "#353535"
let s:shade3 = "#505050"
let s:shade4 = "#8d8d8b"
let s:shade5 = "#dddddd"

" pre.compile_fail { "     border-left: 2px solid rgba(255,0,0,.6); " #a91111}
" pre.ignore { "     border-left: 2px solid rgba(255,142,0,.6); " }
" 1 pre.rust .kw { color: #ab8ac1; }
" 2* pre.rust .kw-2,pre.rust .prelude-ty { color: #769acb; }
" 3 pre.rust .number,pre.rust .string { color: #83a300; }
" 4* pre.rust .self,pre.rust .bool-val,pre.rust .prelude-val,pre.rust .attribute,pre.rust .attribute .ident { color: #ee6868; }
" 5 pre.rust .macro,pre.rust .macro-nonterminal { color: #3E999F; }
" 6 pre.rust .lifetime { color: #d97f26; }
" 7 pre.rust .question-mark { color: #ff9011; }

"""""""""""""""''rust doc comment #8ca375;

highlight clear
syntax reset
let g:colors_name = "RustDocDark"

""""""""""
" Normal "
""""""""""
exec "hi Normal guibg=".s:shade1." guifg=".s:shade5


"""""""""""""""""""""""
" Highlighting Groups "
"""""""""""""""""""""""

"""""""""""""""""
" Syntax groups "
"""""""""""""""""
exec "hi MatchParen guibg=".s:color5." guifg=".s:shade5
exec "hi ToolbarLine guibg=".s:shade5." guifg=".s:shade1
exec "hi ToolbarButton guibg=".s:shade5." guifg=".s:shade1
exec "hi Comment guifg=".s:shade4
exec "hi Constant guifg=".s:color3
exec "hi Special guifg=".s:color6
exec "hi Identifier guifg=".s:shade5
exec "hi Statement guifg=".s:color1
exec "hi PreProc guifg=".s:color5
exec "hi Type guifg=".s:shade5
exec "hi Underlined guifg=".s:alert2
exec "hi Error guibg=".s:alert1." guifg=".s:shade5
exec "hi TODO guibg=".s:alert3." guifg=".s:shade5
exec "hi Underline guifg=".s:alert2
exec "hi TrailingSpace guibg=".s:alert1." guifg=".s:shade5

""""""""""""
" Clean up "
""""""""""""
unlet s:alert1 s:alert2 s:alert3
unlet s:shade1 s:shade2 s:shade3 s:shade4 s:shade5
unlet s:color1 s:color2 s:color3 s:color4 s:color5 s:color6
