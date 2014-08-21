# ------------------------------------------------------------------------
# Steven Fusco Spiral oh-my-zsh theme
# ------------------------------------------------------------------------

# Color shortcuts
RED=$fg[red]
MAGENTA=$fg[magenta]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
RED_BOLD=$fg_bold[red]
MAGENTA_BOLD=$fg_bold[magenta]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color

# icons
PROMPT_CHARACTER="»"
ERRORICON="\xe2\x9d\x8c\x0a"
GITICON="%{$WHITE_BOLD%}깉%{$RESET_COLOR%}"
HGICON="%{$WHITE_BOLD%}☿%{$RESET_COLOR%}"
SVNICON="%{$WHITE_BOLD%}㏜%{$RESET_COLOR%}"

function testok {
  RETVAL=$?
  if [[ $RETVAL -ne 0 ]]; then
    echo -e "${ERRORICON} %{$RED_BOLD%} $RETVAL %{$RESET_COLOR%} "
  fi
}

function currenttime {
  echo -e "`date +"%X"`"
}

precmd () {
   (( _start >= 0 )) && set -A _elapsed $_elapsed $(( SECONDS-_start ))
   _start=-1
}

preexec () {
   (( $#_elapsed > 10 )) && set -A _elapsed $_elapsed[-10,-1]
   typeset -ig _start=SECONDS
}

function gitprompt() {
  branch=`git branch -v 2>/dev/null | grep -o "^\*.*" | cut -d ' ' -f 2`
  if [[ -n "${branch}" ]]; then
    numchanges=`git status -s | wc -l | sed 's/\ *//'`
    echo -en "${GITICON} %{$GREEN_BOLD%}${branch}%{$RESET_COLOR%} "
    if [[ 0 -eq ${numchanges} ]]; then
      echo -en "%{$GREEN_BOLD%}${numchanges}%{$RESET_COLOR%} "
    else
      echo -en "%{$YELLOW%}${numchanges}%{$RESET_COLOR%} "
    fi
  fi
}

function hgprompt() {
  branch=`hg branch 2>/dev/null`
  if [[ -n "${branch}" ]]; then
    numchanges=`hg status | wc -l | grep -o '\d'`
    echo -en "${HGICON} %{$GREEN_BOLD%}${branch}%{$RESET_COLOR%} "
    if [[ 0 -eq ${numchanges} ]]; then
      echo -en "%{$GREEN_BOLD%}${numchanges}%{$RESET_COLOR%} "
    else
      echo -en "%{$YELLOW%}${numchanges}%{$RESET_COLOR%} "
    fi
  fi
}

function svnprompt() {
  branch=`svn info 2>/dev/null | egrep '(^Relative URL|^Revision|^Last Changed Rev)' | sed -e 's/Relative URL: .*\///' -e 's/Revision: / @/' -e 's/Last Changed Rev: / ∆/' | tr -d '\n'`
  if [[ -n "${branch}" ]]; then
    numchanges=`svn status | wc -l | sed 's/\ *//'`
    echo -en "${SVNICON} %{$MAGENTA_BOLD%}${branch}%{$RESET_COLOR%} "
    if [[ 0 -eq ${numchanges} ]]; then
      echo -en "%{$GREEN_BOLD%}${numchanges}%{$RESET_COLOR%} "
    else
      echo -en "%{$YELLOW%}${numchanges}%{$RESET_COLOR%} "
    fi
  fi
}


# Prompt format

PROMPT='$(testok)$(currenttime) ${_elapsed[-1]}s
%{$GREEN_BOLD%}%{$WHITE%}%{$YELLOW%}${PWD/#$HOME/~}%u%{$RESET_COLOR%}
%{$BLUE%}${PROMPT_CHARACTER}%{$RESET_COLOR%} '

RPROMPT='%{$GREEN_BOLD%}$(svnprompt)$(gitprompt)$(hgprompt)%{$RESET_COLOR%}'
