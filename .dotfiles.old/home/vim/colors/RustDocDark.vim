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

"""""""""""""""""
" Unused Groups "
"""""""""""""""""
"exec "hi ColorColumn guibg=".s:shade1
"exec "hi Conceal guifg=".s:shade2
"exec "hi Cursor guifg=".s:shade0
"exec "hi CursorColumn guibg=".s:shade1
"exec "hi CursorLine guibg=".s:shade1." cterm=none"
"exec "hi Directory guifg=".s:accent5
"exec "hi DiffAdd guifg=".s:accent3." guibg=".s:shade1
"exec "hi DiffChange guifg=".s:accent2." guibg=".s:shade1
"exec "hi DiffDelete guifg=".s:accent0." guibg=".s:shade1
"exec "hi DiffText guifg=".s:accent2." guibg=".s:shade2
"exec "hi ErrorMsg guifg=".s:shade7." guibg=".s:accent0
"exec "hi VertSplit guifg=".s:shade0." guibg=".s:shade3
"exec "hi Folded guifg=".s:shade4." guibg=".s:shade1
"exec "hi FoldColumn guifg=".s:shade4." guibg=".s:shade1
"exec "hi SignColumn guibg=".s:shade0
"exec "hi IncSearch guifg=".s:shade0." guibg=".s:accent2
"exec "hi LineNr guifg=".s:shade2." guibg=".s:shade0
"exec "hi CursorLineNr guifg=".s:shade3." guibg=".s:shade1
"exec "hi MatchParen guibg=".s:shade2
"exec "hi MoreMsg guifg=".s:shade0." guibg=".s:accent4
"exec "hi NonText guifg=".s:shade2." guibg=".s:shade0
"exec "hi Pmenu guifg=".s:shade6." guibg=".s:shade1
"exec "hi PmenuSel guifg=".s:accent4." guibg=".s:shade1
"exec "hi PmenuSbar guifg=".s:accent3." guibg=".s:shade1
"exec "hi PmenuThumb guifg=".s:accent0." guibg=".s:shade2
"exec "hi Question guifg=".s:shade7." guibg=".s:shade1
"exec "hi Search guifg=".s:shade0." guibg=".s:accent2
"exec "hi SpecialKey guifg=".s:accent7." guibg=".s:shade0
"exec "hi SpellBad guifg=".s:accent0
"exec "hi SpellCap guifg=".s:accent2
"exec "hi SpellLocal guifg=".s:accent4
"exec "hi SpellRare guifg=".s:accent1
"exec "hi StatusLine guifg=".s:shade4." guibg=".s:shade1." gui=none cterm=none"
"exec "hi TabLine guifg=".s:shade5." guibg=".s:shade1
"exec "hi TabLineFill guibg=".s:shade1
"exec "hi TabLineSel guifg=".s:shade6." guibg=".s:shade0
"exec "hi Title guifg=".s:accent5
"exec "hi Visual guibg=".s:shade1
"exec "hi VisualNOS guifg=".s:accent0." guibg=".s:shade1
"exec "hi WarningMsg guifg=".s:accent0
"exec "hi WildMenu guifg=".s:accent4." guibg=".s:shade1

""""""""""""
" Clean up "
""""""""""""
unlet s:alert1 s:alert2 s:alert3
unlet s:shade1 s:shade2 s:shade3 s:shade4 s:shade5
unlet s:color1 s:color2 s:color3 s:color4 s:color5 s:color6
