#!/bin/bash

doit()
{
    echo -n `vncconfig -desc $1` | sed 's/\(\.\|\) *$/: /'
    vncconfig -get $1 | sed 's/^1$/Enabled/' | sed 's/^0$/Disabled/'
}

doit AcceptCutText
doit SendCutText
doit MaxCutText

