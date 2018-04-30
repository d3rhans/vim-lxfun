" lxfun completion functionality

function! lxfun#compl#envname_complete(base)
    return g:lxfun_envs.db
endfunction

function! lxfun#compl#filename_complete(base)
    let l:glob_pattern = a:base . '*' 

    let l:files_pre = globpath('.', l:glob_pattern, 0, 1)
    let l:files_post = []

    for l:file in l:files_pre
         call add(l:files_post, substitute(l:file, '^\./', '', ''))
    endfor

    return l:files_post
endfunction

function! lxfun#compl#citation_complete(base)
    let l:tags = taglist('.*') 
    let l:result = []

    for l:tag in l:tags
        if l:tag['kind'] ==# g:lxfun_ctags_bib_type
            call add(l:result, l:tag['name'])
        endif 
    endfor

    return l:result
endfunction

function! lxfun#compl#complete(findstart, base)
    if a:findstart
        " locate the start of the base
        let l:line = getline('.')
        let l:start = col('.') - 1
        while l:start > 0 && l:line[l:start - 1] =~? '\a'
            let l:start -= 1
        endwhile
        return l:start
    else
        if lxfun#context#envname_required()
            return lxfun#compl#envname_complete(a:base)
        endif

        if lxfun#context#filename_required()
            return lxfun#compl#filename_complete(a:base)
        endif

        if lxfun#context#citation_required()
            return lxfun#compl#citation_complete(a:base)
        endif

        " Debug...
        return ['foo']
    endif
endfunction
