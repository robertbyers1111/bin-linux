#!/bin/bash
sudo find /bin /etc /home /lib* /opt /root /sbin /srv /usr /var -xdev $*
