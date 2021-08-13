#!/bin/bash
#
# This script aims to find all unique words used in Rabbit .py and .json files
#
# Results are stored to a file (see $OUTFILE)
#

NOW=`date +%Y-%m%d-%H%M%S`
TMPF1=/tmp/allUniqueRabbitWords-tmp-${NOW}.tmp
OUTFILE=allUniqueRabbitWords-${NOW}.txt

dropFilenames() { cut -d: -f2-;}
removeQuotes() { tr "'" ' ' | tr '"' ' ';}
squeezeSpaces() { sed 's/[       ][      ]*/ /g';}
space2newline() { tr ' ' '\n';}
skipNonWords() { grep -v "^[ 0-9\.,><=:%~;)(_+-][ 0-9\.,><=:%~;)(_+-]*$";}
removeLeadingJunk() { sed 's/^ *[\.,><=:%~;)(_+-][\.,><=:%~;)(_+-]*//';}
removeTrailingJunk() { sed 's/[\.,><=:%~;)(_+-][\.,><=:%~;)(_+-]* *$//';}
sortUnique() { sort -Vu;}
ignoreHHMMSS() { grep -iv "^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$";}
ignoreSeconds() { grep -iv "^[0-9][0-9]*s$";}
ignoreGitCommits() { grep -iv "^[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]$";}
ignoreHexNumbers() { grep -iv "^0x[0-9a-f][0-9a-f]*$";}
ignoreJiraTickets() { grep -iv "^RABBIT-[0-9][0-9]*$" | grep -iv "^SRTF-[0-9][0-9]*$";}
ignoreTestcaseIDs() { grep -iv "TC-[0-9][0-9]*$";}
ignoreRealWords() { ispell -l -p rabbitIspellDict.txt ;}

# I am placing everything into functions so the purpose of each step in the long command is clear

~rbyers/bin/.findgrepRabbit.sh . |\
 dropFilenames |\
 removeQuotes |\
 squeezeSpaces |\
 space2newline |\
 skipNonWords |\
 removeLeadingJunk |\
 removeTrailingJunk |\
 ignoreHexNumbers |\
 ignoreSeconds |\
 ignoreGitCommits |\
 ignoreHexNumbers |\
 ignoreJiraTickets |\
 ignoreTestcaseIDs |\
 ignoreRealWords |\
 sortUnique \
 grep .. > junk

 #> $TMPF1

# wcl ~/tmp/allcode.txt 
# cat ~/tmp/allcode.txt |head
# cat ~/tmp/allcode.txt |head |tr ' ' '\n'
# cat ~/tmp/allcode.txt |cut -d: -f2- |head |tr ' ' '\n'
# cat ~/tmp/allcode.txt |cut -d: -f2- |tr ' ' '\n' > ~/tmp/allwords.txt
# wcl ~/tmp/allwords.txt 
# cat ~/tmp/allwords.txt |sort -Vu > ~/tmp/alluniquewords.txt
# wcl ~/tmp/alluniquewords.txt 
# gvim ~/tmp/alluniquewords.txt 
# gvim ~/tmp/alluniquewords.txt 
# rm ~/tmp/.alluniquewords.txt.swp 
# grep -i "[a-z]" ~/tmp/alluniquewords.txt > ~/tmp/junk
# wcl junk alluniquewords.txt 
# mv junk alluniquewords.txt 
# gvim alluniquewords.txt 

