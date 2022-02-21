CURRENT_BG='NONE'
SEGMENT_SEPARATOR_RIGHT='\ue0b2'
SEGMENT_SEPARATOR_LEFT='\ue0b0'

ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
ZSH_THEME_GIT_PROMPT_DIRTY=''
ZSH_THEME_GIT_PROMPT_STASHED=' ⚑'
ZSH_THEME_GIT_PROMPT_DIVERGED=' ⚡'
ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
ZSH_THEME_GIT_PROMPT_AHEAD=' ⬆'
ZSH_THEME_GIT_PROMPT_BEHIND=' ⬇'
ZSH_THEME_GIT_PROMPT_DIRTY=' ±'

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_LEFT%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_segment_right() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    echo -n "%K{$CURRENT_BG}%F{$1}$SEGMENT_SEPARATOR_RIGHT%{$bg%}%{$fg%} "
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_LEFT"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

prompt_user_hostname() {
  local user=`whoami`

  if [ -n "$SSH_CLIENT" ]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$user@%m"
  fi
}

prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ -n $dirty ]]; then
      prompt_segment magenta black
    else
      prompt_segment "35" black
    fi
    if [ "$ZSH_2022_DISABLE_GIT_STATUS" != "true" ];then
      echo -n "\ue0a0 ${ref/refs\/heads\//} "$(git_prompt_status)
    else
      echo -n "\ue0a0 ${ref/refs\/heads\//} "
    fi
  fi
}

prompt_dir() {
  prompt_segment "75" black '%~'
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{yellow}%}✖"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

prompt_time() {
  prompt_segment_right "105" black '%D{%H:%M:%S} '
}

# prompt_rvm() {
#   local rvm_prompt
#   rvm_prompt=`rvm-prompt`
#   if [ "$rvm_prompt" != "" ]; then
#     prompt_segment_right "240" white "$rvm_prompt "
#   fi
# }

# Segment to display rbenv information
# https://github.com/rbenv/rbenv#choosing-the-ruby-version
prompt_rbenv() {
  if [ $commands[rbenv] ]; then
    find_and_set_rbenv_verion
  fi
}

  # This function is kind of a mess. Unlike rvm, rbenv doesn't have
  # a cute little rvm-prompt message that displays the ruby version correctly
  # for rbenv, you have to run `rbenv version-name` to see what version
  # of ruby is being used.

  # BUT if you do not have the local ruby version (stored in .ruby-version)
  # installed, `rbenv version-name` raises an error and does not return
  # the version number you need to install.

  # Additionally, if you're in a directory that doesn't use ruby,
  # `rbenv version-name` will return the global ruby version.
  # I think that's misleading. If the directory isn't defining a
  # ruby version, I don't want to just have the global one displayed.

  # So here's what this function does.


  # if ruby version is not installed        --> display local version _in red_
  # if ruby version != global version &&
  #    ruby version == local version        --> display local version
  # if ruby version == global version &&
  #    there is a local .ruby-version file  --> display global version
  # if ruby version == global version &&
  #    there is no local .ruby-version      --> don't display anything

find_and_set_rbenv_verion() {
  local ruby_global_version="$(rbenv global)"

  # set ruby_local_version_from_file
  if [ -f ".ruby-version" ]; then                        # use .ruby-version if it exists
    local ruby_local_version_from_file=$(<.ruby-version)
  fi

  # set ruby_local_version_from_command
  if result=$(rbenv version-name 2>&1); then
    local ruby_local_version_from_command=$result
  else
    local ruby_not_installed_error=$result
  fi

  # set ruby_local_version
  #
  # prefer getting version from .ruby-version
  # over rbenv version-name
  #
  if [ $ruby_local_version_from_file ]; then
    local ruby_local_version=$ruby_local_version_from_file
  elif [ $ruby_local_version_from_command ]; then
    local ruby_local_version=$ruby_local_version_from_command
  else
    return  # don't display anything if can't find local ruby version
  fi

  if [ $ruby_not_installed_error ]; then
    prompt_segment_right "124" black "$ruby_local_version "
  elif [ $ruby_global_version != $ruby_local_version ]; then
    prompt_segment_right "035" black "$ruby_local_version "
  elif [ $ruby_local_version_from_file ]; then
    prompt_segment_right "035" black "$ruby_local_version "
  fi
}

build_prompt() {
  if [ "$ZSH_2022_DISABLE_STATUS" != 'true' ];then
    RETVAL=$?
    prompt_status
  fi
  prompt_user_hostname
  prompt_dir
  prompt_git
  prompt_end
}

ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

#Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "($COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%})"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "($COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%})"
            else
                echo "($COLOR${MINUTES}m%{$reset_color%})"
            fi
        fi
    fi
}

build_rprompt() {
  if [ "$ZSH_2022_DISABLE_RVM" != 'true' ];then
    prompt_rbenv
  fi
  prompt_time
}


PROMPT='%{%f%b%k%}$(build_prompt) '
if [ "$ZSH_2022_DISABLE_RIGHT_PROMPT" != 'true' ];then
  # RPROMPT='%{%f%b%k%}$(git_time_since_commit)$(build_rprompt)'
  RPROMPT='%{%f%b%k%}$(build_rprompt)'
fi


