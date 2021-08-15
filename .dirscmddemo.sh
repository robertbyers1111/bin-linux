#!/bin/bash
cat <<EOT

% dirs
        /var/log /jenkins ~/today ~/today/junk wtf ~/today

% dirs -l
        /var/log /jenkins /home/rbyers/today /home/rbyers/today/junk wtf /home/rbyers/today

% dirs -p
        /var/log
        /jenkins
        ~/today
        ~/today/junk wtf
        ~/today

% dirs -v
         0  /var/log
         1  /jenkins
         2  ~/today
         3  ~/today/junk wtf
         4  ~/today

% dirs -c (clears)

EOT

