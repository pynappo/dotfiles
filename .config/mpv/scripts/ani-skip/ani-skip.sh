#!/bin/sh


version_number="1.0.1"

agent="Mozilla/5.0 (Windows NT 6.1; Win64; rv:109.0) Gecko/20100101 Firefox/109.0"

chapter_format="\n[CHAPTER]\nTIMEBASE=1/1000\nSTART=%s\nEND=%s\nTITLE=%s\n"
option_format="skip-%s_start=%s,skip-%s_end=%s"

die() {
    printf "\33[2K\r\033[1;31m%s\033[0m\n" "$*" >&2
    exit 1
}

help_info() {
    printf "
    Usage:
    %s [OPTIONS]

    Options:
      -q, --query
        Anime Title or MyAnimeList ID
      -e, --episode
        Specify the episode number
      -V, --version
        Show the version of the script
      -h, --help
        Show this help message and exit
      -U, --update
        Update the script
    Some example usages:
      %s -q \"Solo Leveling\" # Returns MyAnimeList ID
      %s -q \"Solo Leveling\" -e 3 # Returns MPV skip flag
      %s -q 52299 -e 5 # Returns MPV skip flag
    \n" "${0##*/}" "${0##*/}" "${0##*/}" "${0##*/}"
    exit 0
}

update_script() {
    update="$(curl -s -A "$agent" "https://raw.githubusercontent.com/synacktraa/ani-skip/master/ani-skip")" || die "Connection error"
    update="$(printf '%s\n' "$update" | diff -u "$0" -)"
    if [ -z "$update" ]; then
        printf "Script is up to date :)\n"
    else
        if printf '%s\n' "$update" | patch "$0" -; then
            printf "Script has been updated\n"
        else
            die "Can't update for some reason!"
        fi
    fi
    exit 0
}

fetch_mal_id() {
    #shellcheck disable=SC2016
    : '
    `fetch_mal_id` fetches MyAnimeList Identifier of particular anime
    :param $1: title of the anime
    '
    name=$(printf "%s" "$*" | sed 's| (\([0-9]*\) episodes)||')
    keyword=$(printf "%s" "$name" | tr -c '[:alnum:]' ' ' | sed -E 's| |%20|g')
    mal_metadata=$(curl -sL -A "$agent" "https://myanimelist.net/search/prefix.json?type=anime&keyword=$keyword" | tr -d "\\" 2>/dev/null)
    name=$(printf "%s\n" "$name" | tr -cs '[:print:]' ' ' | tr -c '[:alnum:]' ' ')
    fzf_nth=$(printf "%s," $(seq 1 "$(printf "%s" "$name" | wc -w)") | sed 's|,$||')
    results=$(printf "%s" "$mal_metadata" | sed 's|},{|\n|g' | sed 's|.*,"name":"||g ; s|","url":".*||g')
    relevant_name=$(printf "%s" "$results" | fzf -i --filter="$name" --nth="$fzf_nth" | head -n1)
    [ -z "$relevant_name" ] && relevant_name=$(printf "%s" "$results" | fzf -i --filter="$name" | head -n1)
    [ -z "$relevant_name" ] && relevant_name=$(printf "%s" "$results" | head -n1)
    printf "%s" "$mal_metadata" | sed 's|},{|\n|g' | grep 'name":"'"$relevant_name"'","url":' | sed -nE 's|.*"id":([0-9]{1,9}),.*|\1|p'
}

ftoi() {
    printf "%.3f" "$1" | tr -d '.'
}

build_options() {
    #shellcheck disable=SC2016
    : '
    `build_options` builds options for `--script-opts` flag
    :param $1: AniSkip metadata
    '
    st_time_re='"start_time":([0-9.]+)'
    ed_time_re='"end_time":([0-9.]+)'
    op_end=""
    ed_start=""
    options=""

    for skip_type in "op" "ed"
    do
        sk_type_re='"skip_type":"('$skip_type')"'
        unformatted=$(printf "%s" "$1" | grep -Eo "$st_time_re,$ed_time_re},$sk_type_re")
        if [ -n "$unformatted" ]; then
            st_time=$(printf "%s" "$unformatted" | grep -Eo "$st_time_re" | sed -E 's@'"$st_time_re"'@\1@')
            ed_time=$(printf "%s" "$unformatted" | grep -Eo "$ed_time_re" | sed -E 's@'"$ed_time_re"'@\1@')

            [ "$skip_type" = "op" ] && op_end=$ed_time && ch_name="Opening"
            [ "$skip_type" = "ed" ] && ed_start=$st_time && ch_name="Ending"
            [ -n "$options" ] && options="$options,"

            printf "$chapter_format" "$(ftoi $st_time)" "$(ftoi $ed_time)" "$ch_name" >> $chapters_file
            options=$(printf "%s%s" "$options" $(printf "$option_format" "$skip_type" "$st_time" "$skip_type" "$ed_time"))

        fi
    done

    if [ -n "$op_end" ]; then
        [ -n "$ed_start" ] && ep_ed=$ed_start || ep_ed=$op_end
        printf "$chapter_format" "$(ftoi $op_end)" "$(ftoi $ep_ed)" "Episode" >> $chapters_file
    fi

    printf "%s" "$options"
}

build_flags() {
    #shellcheck disable=SC2016
    : '
    `build_flags` builds `--script-opts` and `--chapters-file` flags for MPV player
    :param $1: MyAnimeList Identifier
    :param $2: Episode number
    '
    aniskip_api="https://api.aniskip.com/v1/skip-times/$1/$2?types=op&types=ed"
    metadata=$(curl -s --connect-timeout 5 -A "$agent" "$aniskip_api")

    found_status=$(printf "%s" "$metadata" | sed -n 's/.*"found":\([^,]*\).*/\1/p')
    [ "$found_status" != "true" ] && die "Skip times not found!"

    printf "%s" ";FFMETADATA1" > "$chapters_file"
    options=$(build_options "$metadata")
    [ -n "$options" ] && printf -- "--chapters-file=%s --script-opts=%s" "$chapters_file" "$options"
}


[ $# -eq 0 ] && help_info
while [ $# -gt 0 ]; do
    [ "$OSTYPE" = msys* ] && flag=${1//[![:print:]]/} || flag="$1"
    case "$flag" in
        -U | --update) update_script ;;
        -V | --version) printf "%s\n" "$version_number" && exit 0 ;;
        -h | --help) help_info ;;
        -q | --query)
            [ $# -lt 2 ] && die "missing anime title/MyAnimeList ID!"
            case $2 in
                ''|*[!0-9]*) mal_id=$(fetch_mal_id $2) ;;
                *) mal_id=$2 ;;
            esac
            shift
            ;;
        -e | --episode)
            [ $# -lt 2 ] && die "missing episode number!"
            case $2 in
                ''|*[!0-9]*) die "value must be a number!" ;;
                *) episode=$2 ;;
            esac
    esac
    shift
done

[ -z "$mal_id" ] && die "-q/--query is required!"
if [ -z "$episode" ]; then
    printf "%s" "$mal_id"
else
    chapters_file=$(mktemp)
    build_flags $mal_id $episode
fi
