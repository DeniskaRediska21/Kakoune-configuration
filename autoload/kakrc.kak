add-highlighter global/ show-whitespaces -tab '│' -tabpad '╌' -lf " " -nbsp "⋅" -spc " "

hook global RegisterModified '"' %{ nop %sh{
          printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

map global user P '!xsel --output --clipboard<ret>'
map global user p '<a-!>xsel --output --clipboard<ret>'
map global user R '|xsel --output --clipboard<ret>'

# Move lines up/down -- works with single selection.
map global normal '<a-k>' 'x"aZy<a-;>kPZ"azdzk'
map global normal '<a-j>' 'xdpj'

source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload
plug "andreyorst/smarttab.kak"
plug 'delapouite/kakoune-livedown'

hook global ModuleLoaded smarttab %{
    set-option global softtabstop 4
    # you can configure text that is being used to represent curent active mode
    set-option global smarttab_expandtab_mode_name 'exp'
    set-option global smarttab_noexpandtab_mode_name 'noexp'
    set-option global smarttab_smarttab_mode_name 'smart'
}

hook global BufOpenFile .* expandtab
hook global BufNewFile  .* expandtab


plug "listentolist/kakoune-table" domain "gitlab.com" config %{
    # suggested mappings

    map global user t ": evaluate-commands -draft table-align<ret>" -docstring "align table"
    map global user a ": evaluate-commands -draft table-add-row-below<ret>" -docstring "add tanle add row bellow"
    
    # map global user t ": table-enable<ret>" -docstring "enable table mode"
    # map global user T ": table-disable<ret>" -docstring "disable table mode"
    
    # map global user t ": table-toggle<ret>" -docstring "toggle table mode"
    
    # map global user t ": enter-user-mode table<ret>" -docstring "table"
    # map global user T ": enter-user-mode -lock table<ret>" -docstring "table (lock)"
}

plug "kakoune-lsp/kakoune-lsp" do %{
    cargo install --locked --force --path .
}

hook global InsertCompletionShow .* %{
    try %{
        # this command temporarily removes cursors preceded by whitespace;
        # if there are no cursors left, it raises an error, does not
        # continue to execute the mapping commands, and the error is eaten
        # by the `try` command so no warning appears.
        execute-keys -draft 'h<a-K>\h<ret>'
        map window insert <tab> <c-n>
        map window insert <s-tab> <c-p>
        hook -once -always window InsertCompletionHide .* %{
            unmap window insert <tab> <c-n>
            unmap window insert <s-tab> <c-p>
        }
    }
}

add-highlighter global/ number-lines 
