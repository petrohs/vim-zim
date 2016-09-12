" Zim Utilities Plugin
" Author: Jack Mudge <jakykong@theanythingbox.com>
" * I declare this file to be in the public domain.
"
" Changelog:
" 2016-09-12 - Jack Mudge - v0.1
"   * Initial creation.
"
" Provides shortcuts and helpful mappings to work with Zim wiki formatting.
" This is primarily intended for using the 'Edit Source' functionality in
" Zim, but may be useful to create new files in a Zim folder.
"
" Known Bugs:
" * Does not currently support Linux strftime()
" * Zim issue: New files aren't shown in Zim index until restart of zim.
"
"


" Create Zim header in a buffer, i.e., for a new file
" If files are created within Zim, this is already completed
function! CreateZimHeader()
    execute "normal! gg"
    call append(0,["Content-Type: text/x-zim-wiki", "Wiki-Format: zim 0.4", "Creation-Date:"])
    execute "normal! 3G"
    if has("win32")
        let l:timest1 = strftime("%Y-%m-%dT%H:%M:%S")

        " Microsoft screwed with strftime() sot that %z returns a description of the time zone. BOOOO Microsoft.
        " This calculation converts that to the appropriate numeric representation. (Only for PST/PDT.)
        if strftime("%z") == "Pacific Standard Time"
            let l:timest2 = "-08:00"
        elseif strftime("%z") == "Pacific Daylight Time"
            let l:timest2 = "-07:00"
        else
            throw "Unknown Time Zone: " . strftime("%z")
        endif

        let l:timestamp = l:timest1 . l:timest2
        call append(line("."),[ l:timestamp ])
    else
        " TODO: Implement this in Linux w/ strftime() that works correctly
        throw "Not yet implemented in Linux"
    endif
    execute "normal! Jo\<ESC>"
endfunction


"Wiki formatting commands
"Bold a range
vmap <Leader>wb :s/\%V.*\%V[^\s]/**\0**/g<CR>:nohl<CR>
nmap <Leader>wb :s/.*[^\s]/**\0**/<CR>:nohl<CR>
"Italicize a range
vmap <Leader>wi :s/\%V.*\%V[^\s]/\/\/\0\/\//g<CR>:nohl<CR>
nmap <Leader>wi :s/.*[^\s]/'''\0'''/<CR>:nohl<CR>
"Highlight a range
vmap <Leader>wh :s/\%V.*\%V[^\s]/__\0__/g<CR>:nohl<CR>
nmap <Leader>wh :s/.*[^\s]/__\0__/<CR>:nohl<CR>
"Strike a range
vmap <Leader>ws :s/\%V.*\%V[^\s]/~~\0~~/g<CR>:nohl<CR>
nmap <Leader>ws :s/.*[^\s]/~~\0~~/<CR>:nohl<CR>
"<num>Header 1 to 5 (1=largest)
nnoremap <Leader>wh :<C-U>let c=v:count1<CR>I======= <ESC>0:execute "normal! ".c."x"<CR>0ve"zy$a <ESC>"zp0:nohl<CR>
" Change [ ] to *
map <F8> :%s/\[ \]/*/g<cr>:wq<cr>
" Create Zim header on a buffer
nnoremap <Leader>wH :call CreateZimHeader()<CR>


