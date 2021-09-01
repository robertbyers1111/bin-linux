#!/bin/bash

MYHOME=~
EXCLUDE_FROM="--exclude-from=$MYHOME/etc/`hostname`-mybkup-tar-exclusions.dat"

# Back up several key files.

NOW=`date +%Y-%m%d-%H%M%S`
BKUP_DIR=$MYHOME/.bkups
BKUP_TGZ=$BKUP_DIR/`hostname`-MyDotFiles-$NOW.tgz

[ ! -d $BKUP_DIR ] && { echo ERROR $BKUP_DIR NOT EXIST; exit; }

echo
echo "   Creating: `basename $BKUP_TGZ`"
echo "  Directory: $MYHOME/`basename $BKUP_DIR`"

cd $MYHOME

case `hostname` in

    RmbInspiro2018)
        tar chzf $BKUP_TGZ $EXCLUDE_FROM \
         .bash_aliases \
         .bash_logout \
         .bash_profile \
         .bashrc \
         .bashrc_rmbjr60 \
         .dmrc \
         .gitconfig \
         .gvimrc \
         .inputrc \
         .profile \
         .promptrc \
         .screenrc \
         .toprc \
         .vimrc \
         .vimrc_rbyers \
         .config/cherrytree \
         bin \
         etc
        ;;

    RB-EL*)
        tar chzf $BKUP_TGZ $EXCLUDE_FROM \
         .bash_aliases \
         .bash_logout \
         .bash_profile \
         .bashrc \
         .bashrc_rmbjr60 \
         .gitconfig \
         .gvimrc \
         .inputrc \
         .login \
         .login.user \
         .promptrc \
         .screenrc \
         .toprc \
         .vimrc \
         .vimrc_rbyers \
         .ssh \
         bin \
         etc \
         var
        ;;

    IRBT-8758l)
        tar czf $BKUP_TGZ $EXCLUDE_FROM \
         .bash_aliases \
         .bash_logout \
         .bash_profile \
         .bashrc \
         .bashrc_rmbjr60 \
         .gitconfig \
         .gvimrc \
         .ideavimrc \
         .inputrc \
         .profile \
         .promptrc \
         .toprc \
         .vimrc \
         .vimrc_rbyers \
         .config \
         bin \
         etc
        ;;

    *) echo Hostname `hostname` not supported
       exit
       ;;
esac

[ -f $BKUP_TGZ ] && {
    echo "       NOTE:" `tar tvf $BKUP_TGZ | wc -l` files were backed up
    gzip -l $BKUP_TGZ | sed 's/^        //' | sed 's/pressed/pressed:/g' | sed 's/ uncomp/uncomp/' | sed 's/ ratio/ratio/' | sed 's/:_name/_name/'
    echo
} || {
    echo ERROR: $BKUP_TGZ NOT EXIST
}

