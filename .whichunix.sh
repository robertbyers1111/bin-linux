#!/bin/bash
doit()
{
    [ -f $1 ] && grep ^ $1 /dev/null | sed 's/:/:       /'
}

doit /etc/lsb-release
doit /etc/system-release-cpe
doit /etc/centos-release
doit /etc/os-release
doit /etc/redhat-release
doit /etc/system-release
#oit /etc/issue
