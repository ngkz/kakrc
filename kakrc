colorscheme tomorrow-night

set-option global scrolloff            1,5
# hide clippy
set-option global ui_options           ncurses_assistant=none
set-option global tabstop              4
set-option global indentwidth          4
set-option global aligntab             false
set-option global startup_info_version 20180904
set-option global autoreload           yes

add-highlighter global/ show-whitespaces -spc ' ' -lf ↲ -nbsp ␣ -tab » -tabpad -
add-highlighter global/ wrap             -marker '↪ '
# highlight trailing spaces
add-highlighter global/ regex            '[^\S\n]+$' 0:Error
add-highlighter global/ show-matching

# use spaces instead of tab as a indent
hook global InsertChar \t %{
    exec -draft h@
}
hook global InsertDelete ' ' %{ try %{
    execute-keys -draft 'h<a-h><a-k>\A\h+\z<ret>i<space><esc><lt>'
}}

# System clipboard handling

map global user p ': execute-keys "<lt>a-!>xsel --output --clipboard<lt>ret>"<ret>' \
    -docstring 'paste (after) from clipboard'
map global user P ': execute-keys "!xsel --output --clipboard<lt>ret>"<ret>' \
    -docstring 'paste (before) from clipboard'
map global user R ': execute-keys "|xsel --output --clipboard<lt>ret>"<ret>' \
    -docstring 'replace from clipboard'

map global user y %{ : execute-keys '<lt>a-|>xsel --input --clipboard<lt>ret>y: echo -markup %{{Information}yanked selection to X11 clipboard and register '}<lt>ret>"<ret> } \
    -docstring 'yank to clipboard'
map global user d ': execute-keys "<lt>a-|>xsel --input --clipboard<lt>ret>d"<ret>' \
    -docstring 'yank to clipboard and delete'
map global user c ': execute-keys "<lt>a-|>xsel --input --clipboard<lt>ret>c"<ret>' \
    -docstring 'yank to clipboard and delete and enter insert mode'

map global normal '#' ': comment-line<ret>'      -docstring 'toggle line comment'
map global normal '<a-#>' ': comment-block<ret>' -docstring 'toggle block comment'

# make x select lines downward and X select lines upward
define-command -hidden -params 1 extend-line-down %{
    execute-keys "<a-:>%arg{1}X"
}

define-command -hidden -params 1 extend-line-up %{
    execute-keys "<a-:><a-;>%arg{1}K<a-;>"
    try %{
        execute-keys -draft ';<a-K>\n<ret>'
        execute-keys X
    }
    execute-keys '<a-;><a-X>'
}

map global normal x ': extend-line-down %val{count}<ret>'
map global normal X ': extend-line-up %val{count}<ret>'

# Enable <tab>/<s-tab> for insert completion selection
hook global InsertCompletionShow .* %{
    map window insert <tab>   <c-n>
    map window insert <s-tab> <c-p>
}
hook global InsertCompletionHide .* %{
    unmap window insert <tab>   <c-n>
    unmap window insert <s-tab> <c-p>
}

# highlight search matches
hook global WinCreate .* search-highlighting-enable

set-face global Search                  rgb:272727,rgb:f0c674
set-face global PrimarySelectionDefault default,rgb:373b41

map global normal '<esc>' ' ;<esc>' \
    -docstring 'remove all selection except main, reduce selection to cursor, and stop highlighting search matches'

map global user f :format<ret> -docstring 'format buffer'

# kakoune-phantom-selection
map global normal <minus>   ": phantom-sel-add-selection<ret>"
map global normal =         ": phantom-sel-select-all; phantom-sel-clear<ret>"
map global normal <a-minus> ": phantom-sel-iterate-next<ret>"
map global normal <a-=>     ": phantom-sel-iterate-prev<ret>"

map global insert <a-minus> "<esc>: phantom-sel-iterate-next<ret>i"
map global insert <a-=>     "<esc>: phantom-sel-iterate-prev<ret>i"

# highlight TODO, FIXME, etc.
add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE|BUG|DEBUG|TBD|HACK)\b 0:default+rb

# kakoune-cd
alias global cdd change-directory-current-buffer
alias global cdr change-directory-project-root
alias global pwd print-working-directory
alias global ecd edit-current-buffer-directory
