#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PracticePython v0.4
#
# DO NOT RUN THI SCRIPT. SOURCE IT DURING LOGIN (e.g., add it to your .bashrc)
#
# This script sets up a bash function and alias to assist in starting a new Python practice session

practice_python_via_github()
{
    PYHELP_DIR=~/public_html/python
    PRACTICE_BASEDIR=PracticePython
    PRACTICE_FULLPATH=$PYHELP_DIR/$PRACTICE_BASEDIR

    [ ! -d $PYHELP_DIR ] && {
        echo "Python help directory not found ($PYHELP_DIR)"

    } || {

        cd $PYHELP_DIR
        #cho "       PWD: `pwd | sed 's@/home/[^/][^/]*/@~/@'`"

        [ ! -d $PRACTICE_FULLPATH ] && {
            echo
            echo Creating $PRACTICE_FULLPATH
            mkdir -p $PRACTICE_FULLPATH
            cd $PRACTICE_FULLPATH/..
            git clone git@github.com:robertbyers1111/PracticePython.git
            echo
        }

        pushd $PRACTICE_FULLPATH > /dev/null
        echo "       PWD: `pwd | sed 's@/home/[^/][^/]*/@~/@'`"

        echo -n "REPOSITORY: "
        basename `git rev-parse --show-toplevel`

        echo -n "    BRANCH: "
        git status | grep -Ev "^[      ]*$" | sed 's/^Your/    STATUS: Your/' | sed 's/^nothing to commit/            nothing to commit/'

        echo "     FILES:"
        git ls-files | sed 's/^/            /'

    }
}

alias .practice_python=practice_python_via_github

