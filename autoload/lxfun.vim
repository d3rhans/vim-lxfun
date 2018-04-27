" Functions for lxfun

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

function! s:envname_required()
    let l:pattern = '\\begin{[^}]*$' 

    let [ l:context_left, l:context_right ] = s:get_line_context()

    return (match(l:context_left, l:pattern) != -1)
endfunction

function! s:filename_required()
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

function! s:citation_required()
    let l:cite_pattern = '\\\(\a*cite\a*\)\(\[[^\[\]]\+\]\)*{\([^{}]*\)$'

    let [ l:context_left, l:context_right ] = s:get_line_context()

    return (match(l:context_left, l:cite_pattern) != -1)
endfunction

function! s:envname_complete(base)
    return g:lxfun_envs.db
endfunction

function! s:filename_complete(base)
    let l:glob_pattern = a:base . '*' 

    let l:files_pre = globpath('.', l:glob_pattern, 0, 1)
    let l:files_post = []

    for l:file in l:files_pre
         call add(l:files_post, substitute(l:file, '^\./', '', ''))
    endfor

    return l:files_post
endfunction

" Outside world API

function! lxfun#complete(findstart, base)
    if a:findstart
        " locate the start of the base
        let l:line = getline('.')
        let l:start = col('.') - 1
        while l:start > 0 && l:line[l:start - 1] =~? '\a'
            let l:start -= 1
        endwhile
        return l:start
    else
        if s:envname_required()
            return s:envname_complete(a:base)
        endif

        if s:filename_required()
            return s:filename_complete(a:base)
        endif

        " Debug...
        return ['foo']
    endif
endfunction
