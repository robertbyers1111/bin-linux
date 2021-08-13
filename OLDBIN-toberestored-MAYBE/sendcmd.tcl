#!/usr/bin/expect

source $HOME/lib/rbyerslib.tcl
source $HOME/lib/rbyerslib_2.tcl

#   +-------------------------+
#---| The commands to execute |---
#   +-------------------------+

    global LIST_CMDS
    set LIST_CMDS {"history"}

#   +--------------------------------------------+
#---| The hosts on which to execute the commands |---
#   +--------------------------------------------+

    set LIST_remhosts [list \
      "172.25.96.226" \
      "172.25.96.227" \
      "172.25.96.228" \
      "172.25.96.229" \
      "172.25.96.230" \
      "172.25.96.231" \
      "172.25.96.232" \
      "172.25.96.233" \
      "172.25.96.234" \
      "172.25.96.235" \
      "172.25.96.236" \
      "172.25.96.237" \
      "172.25.96.238" \
      "172.25.96.239" \
    ]

#   +--------------+
#---| The username |---
#   +--------------+

    set remuser "root"

#   +-----------------+
#---| SHOW_exp_buffer |--------------------------------------------------------
#   +-----------------+

proc SHOW_exp_buffer {} {
  global expect_out

  foreach line [split $expect_out(buffer) \r\n] {
    set line [string trim $line]
    if {$line == ""} {
      continue
    }
    logMsg INFO $line
  }

  puts ""
  puts ""
}

#   +------+
#---| doit |-------------------------------------------------------------------
#   +------+

proc doit {remhost remuser} {

  global expect_out
  global unxObject
  global LIST_CMDS
  upvar unxObjectID unxObjectID

  CREATE_unxObject unxObjectID $remhost
  LOGIN_unxRemote $unxObjectID $remhost $remuser

  foreach CMD $LIST_CMDS {
    SEND_unxCmd $unxObjectID "$CMD"
    SHOW_exp_buffer
  }

}

#   +------+
#---| MAIN |-------------------------------------------------------------------
#   +------+

#exp_internal -f .x 1
    foreach remhost $LIST_remhosts {
      doit $remhost $remuser
    }

