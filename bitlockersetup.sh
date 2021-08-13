#!/bin/bash
sudo dislocker /dev/sde3 -p563981-457468-698379-579645-202719-155111-220011-581570 -- /media/bitlocker
sudo mount -o loop /media/bitlocker/dislocker-file /media/bitlockermount
