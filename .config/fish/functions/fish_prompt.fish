function fish_prompt
    set -l last_status $status

    set -l normal (set_color normal)
    set -l usercolor (set_color $fish_color_user)

    set -l delim \U25BA
    # If we don't have unicode use a simpler delimiter
    string match -qi "*.utf-8" -- $LANG $LC_CTYPE $LC_ALL; or set delim ">"

    fish_is_root_user; and set delim "#"

    set -l cwd (set_color $fish_color_cwd)
    if command -sq sha256sum
        # randomized cwd color
        set -l shas (pwd -P | sha256sum | string sub -l 6 | string match -ra ..)
        # Increase color a bit so we don't get super dark colors.
        # Really we want some contrast to the background (assuming black).
        set -l col (for f in $shas; math --base=hex "min(255, 0x$f + 0x30)"; end | string replace 0x '' | string pad -c 0 -w 2 | string join "")

        set cwd (set_color $col)
    end

    # Prompt status only if it's not 0
    set -l prompt_status
    test $last_status -ne 0; and set prompt_status (set_color $fish_color_error)"[$last_status]$normal"

    # Only show host if in SSH or container
    # Store this in a global variable because it's slow and unchanging
    if not set -q prompt_host
        set -g prompt_host ""
        if set -q SSH_TTY
            or begin
                command -sq systemd-detect-virt
                and systemd-detect-virt -q
            end
            set -l host (hostname)
            set prompt_host $usercolor$USER$normal@(set_color $fish_color_host)$host$normal":"
        end
    end

    # Shorten pwd if prompt is too long
    set -l pwd (prompt_pwd)

    echo -n -s $prompt_host $cwd $pwd $normal $prompt_status $delim
end
