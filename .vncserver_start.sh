#!/bin/bash
echo Starting vncserver..
vncserver :99 -geometry 3820x1150 -depth 24
vncserver -list
