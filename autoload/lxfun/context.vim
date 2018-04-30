" Context determination
"
function! s:get_line_context()
    " TODO: Assumption is, that a command does not span multiple lines,
    " this needs to be extended to increase the search space (without parsing the
    " full file)
    let l:line = getline('.')
    let l:pos = getpos('.')[2]
    let l:context_left = strcharpart(l:line, 0, l:pos-1)
    let l:context_right = strcharpart(l:line, l:pos-1)

    return [ l:context_left, l:context_right ]
endfunction

function! lxfun#context#envname_required()
    let l:pattern = '\\begin{[^}]*$' 

    let [ l:context_left, l:context_right ] = s:get_line_context()

    return (match(l:context_left, l:pattern) != -1)
endfunction

function! lxfun#context#filename_required()
    let [ l:context_left, l:context_right ] = s:get_line_context()
    let l:patterns = [ 
                \ '\\\(includegraphics\)\(\[[^\[\]]\+\]\)\{,1}{[^{}]*$',
                \ '\\\(includeonly\){[^{}]*$',
                \ '\\\(input\){[^{}]*$',
                \ '\\\(include\){[^{}]*$' ]

    let l:match = 0

    for l:pattern in l:patterns
        if match(l:context_left, l:pattern) != -1
            let l:match = 1
            break
        endif
    endfor

    return l:match
endfunction

function! lxfun#context#citation_required()
    let l:cite_pattern = '\\\(\a*cite\a*\)\(\[[^\[\]]\+\]\)*{\([^{}]*\)$'

    let [ l:context_left, l:context_right ] = s:get_line_context()

    return (match(l:context_left, l:cite_pattern) != -1)
endfunction
