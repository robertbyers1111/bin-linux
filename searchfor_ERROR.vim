:echo "IMPORTANT"
:echo "IMPORTANT when editing this file in vim, do ':set binary' and ':set noeol' prior to saving (otherwise a final newline gets inserted at end of file)"
:echo "IMPORTANT"
:echo "IMPORTANT PUT NO UPPERCASE IN THE SEARCH STRING!!!! THIS CAUSES set ignorecase TO BE IGNORED!!!!"
:echo "IMPORTANT"
:set ignorecase
gg0/\<error\>\|\<errors\>\|\<failed\>\|\<failure\>\|\<failures\>\|an exception\|enoexist\|no such file\|unable\|cannot\|\<fatal\>\|configure: warning: babletrace support disabled
zz