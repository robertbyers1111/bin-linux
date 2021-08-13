#!/bin/bash

if [ -f /usr/local/bin/printf ]; then
  PRINTF=/usr/local/bin/printf
elif [ -f /usr/bin/printf ]; then
  PRINTF=/usr/bin/printf
else
  PRINTF=printf
fi

if [ $# -ge 1 ]; then
  export PROMPT_COMMAND="$PRINTF \"\033]0;$*\007\003\""
else
  ###### PROMPT_COMMAND="$PRINTF \"\033]0;/// ${LOGNAME}@${HOSTNAME%%.*}:${PWD/#$HOME/~} ///\007\003\""
  export PROMPT_COMMAND="$PRINTF \"\033]0;${LOGNAME}@${HOSTNAME%%.*}\007\003\""
fi

eval $PROMPT_COMMAND

