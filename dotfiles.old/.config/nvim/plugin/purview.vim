" An in-development vim plugin to serve my note taking needs. What does that
" mean? I don't know yet.

" Configuration. This will never be in the plugin.
let g:purview_config_note_dir = $HOME . "/zettles"

" Code. If successful, this will eventually be moved into it own repo.
function purview#main()
  if exists('g:purview_config_note_dir') == 0
    let g:purview_config_note_dir = $HOME . '/purview'
  endif
endfunction

function purview#init(...)
  let note_dir = g:purview_config_note_dir

  if isdirectory(note_dir) == 0
    call mkdir(note_dir, 'p')
    call purview#git('init --quiet')

    if a:0 != v:null
      call purview#git('remote add origin ' . a:remote)
      call purview#git('pull origin')
    endif
  endif
endfunction

function purview#git(cmd)
  return system('git -C ' . g:purview_config_note_dir . ' ' . a:cmd)
endfunction

call purview#main()
"""""""""""" Not real yet
""1. Data description and patterns.
""2. Interpretation of descriptions and patterns.
""3. Synthesis of patterns, descriptions and interpretation.
"
"function purview#create()
"  echo purview#get_var("notes_dir")
"
"  call setline(1, [
"      \ '---',
"      \ 'title: ',
"      \ 'tags: ',
"      \ '---',
"      \ '',
"    \ ])
"endfunction
