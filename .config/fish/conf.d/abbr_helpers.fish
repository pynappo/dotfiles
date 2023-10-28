### Abbrevation definition helpers from
### https://github.com/lgarron/dotfiles/blob/main/dotfiles/fish/.config/fish/abbr.fish

# Quick examples:
#
#     abbr_anyarg make b build
#     abbr_anyarg make c clean
#
#     abbr_subcommand git p push
#     abbr_subcommand git m merge
#
#     abbr_subcommand_arg git m "--message" commit
#     abbr_subcommand_arg git p "--patch" add
#     abbr_subcommand_arg git c --continue rebase merge cherry-pick
#
#     abbr_subcommand_firstarg git m "--move" branch
#
#     abbr_exceptsubcommand_arg git m main commit
#
# See below for more details
#
function abbr_anyarg
  _curry_abbr _abbr_expand_anyarg $argv
end
function _abbr_expand_anyarg
  set -l main_command $argv[1]
  # set -l command_abbreviation $argv[2] # unused
  set -l expansion $argv[3]
  set -l cmd (commandline -op)
  if test "$cmd[1]" = $main_command
    echo $expansion
    return 0
  end
  return 1
end

function abbr_subcommand
  _curry_abbr _abbr_expand_subcommand $argv
end

function _abbr_expand_subcommand
  set -l main_command $argv[1]
  set -l sub_command_abbreviation $argv[2]
  set -l expansion $argv[3]
  set -l cmd (commandline -op)
  if string match -e -- "$cmd[1]" "$main_command" > /dev/null
    if test (count $cmd) -eq 2
      if string match -e -- "$cmd[2]" "$sub_command_abbreviation" > /dev/null
        echo $expansion
        return 0
      end
    end
  end
  return 1
end

function abbr_subcommand_arg
  _curry_abbr _abbr_expand_subcommand_arg $argv
end

function _abbr_expand_subcommand_arg
  set -l main_command $argv[1]
  # set -l arg_abbreviation $argv[2] # unused
  set -l arg_expansion $argv[3]
  set -l sub_commands $argv[4..-1]
  set -l cmd (commandline -op)
  if string match -e -- "$cmd[1]" "$main_command" > /dev/null
    if contains -- "$cmd[2]" $sub_commands
      echo $arg_expansion
      return 0
    end
  end
  return 1
end

function abbr_subcommand_firstarg
  _curry_abbr _abbr_expand_subcommand_firstarg $argv
end

function _abbr_expand_subcommand_firstarg
  set -l main_command $argv[1]
  set -l arg_abbreviation $argv[2]
  set -l arg_expansion $argv[3]
  set -l sub_commands $argv[4..-1]
  set -l cmd (commandline -op)
  if string match -e -- "$cmd[1]" "$main_command" > /dev/null
    if test (count $cmd) = 3
      if string match -e -- "$cmd[3]" "$arg_abbreviation" > /dev/null
        if contains -- "$cmd[2]" $sub_commands
          echo $arg_expansion
          return 0
        end
      end
    end
  end
  return 1
end

function abbr_exceptsubcommand_arg
  _curry_abbr _abbr_expand_exceptsubcommand_arg $argv
end

# Convenience
function abbr_anysubcommand_arg
  if test (count $argv) -gt 3
    echo "ERROR: abbr_anysubcommand_arg does not take denylist arguments"
    return 1
  end
  _curry_abbr _abbr_expand_exceptsubcommand_arg $argv[1..3]
end

function _abbr_expand_exceptsubcommand_arg
  set -l main_command $argv[1]
  # set -l arg_abbreviation $argv[2] # unused
  set -l arg_expansion $argv[3]
  set -l excluded_sub_commands $argv[4..-1]
  set -l cmd (commandline -op)
  if string match -e -- "$cmd[1]" "$main_command" > /dev/null
    if test (count $cmd) -gt 2
      if not contains -- "$cmd[2]" $excluded_sub_commands
        echo $arg_expansion
        return 0
      end
    end
  end
  return 1
end

# 🪄 Currying ✨

set _CURRY_COUNTER 1
function _curry
  set -l CURRIED_FN "_curried_fn_$_CURRY_COUNTER"
  set _CURRY_COUNTER (math $_CURRY_COUNTER + 1)

  set -l INHERITED_ARGS $argv
  function "$CURRIED_FN" --inherit-variable INHERITED_ARGS
    $INHERITED_ARGS $argv
  end
  echo $CURRIED_FN
end

function _curry_abbr
  set -l abbreviation $argv[3]
  set -l CURRIED_FN (_curry $argv)
  abbr -a "$CURRIED_FN"_abbr --regex $abbreviation --position anywhere --function "$CURRIED_FN"
end
