#!/bin/bash

doit()
{
    echo
    echo ================================================================
    echo $1
    timeout 12 ssh root@$2 version
}

doit SOHO iRobot-1CBEBB6F15A2464A983B12C23A38BCD2
doit LEWIS iRobot-1DE608CBB1454966AABEA66598F1FE88
doit SM iRobot-91945FB9B33344F7966F30178942DFB4
doit SAPPHIRE irobot-ECD6C081B4DE4C4796B6080A713F28B8
doit DAREDEVIL iRobot-4F1B6A5492854FB1ACC5E3AEFE001589 

