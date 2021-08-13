#!/usr/bin/expect

set MINSIZE 10

set ignorelist {"/automation/" "/.svn/" "svn-base" "/Training/"}

set TMPF0 /tmp/.$env(USER).A.[clock format [clock seconds] -format %H:%M:%S]
set TMPF1 /tmp/.$env(USER).B.[clock format [clock seconds] -format %H:%M:%S]
set PROMPTS [format "\\$ \$\|> \$\|# \$\|Password: \$"]
global PROMPTS
log_user 0

#   +--------+
#---| MYPUTS |------------------------------------------------------------------
#   +--------+

proc MYPUTS {dest severity msg} {
  set NOW [clock format [clock seconds] -format %H:%M:%S]
  set LABEL [format "\[%-5s %s\]" $severity $NOW]
  foreach line [split $msg \r\n] {
    puts $dest "$LABEL $line"
  }
}

#   +------------+
#---| INFOENABLE |--------------------------------------------------------------
#   +------------+

proc INFOENABLE {} {
  global _NOINFO
  catch {unset _NOINFO}
}

#   +--------+
#---| NOINFO |------------------------------------------------------------------
#   +--------+

proc NOINFO {} {
  global _NOINFO
  set _NOINFO 1
}

#   +------+
#---| INFO |--------------------------------------------------------------------
#   +------+

proc INFO {msg} {
  global _NOINFO
  if {[info exists _NOINFO] && $_NOINFO != 0} {
    return
  }
  MYPUTS stdout INFO $msg
}

#   +------+
#---| WARN |--------------------------------------------------------------------
#   +------+

proc WARN {msg} {
  MYPUTS stdout WARN $msg
}

#   +-------+
#---| ERROR |-------------------------------------------------------------------
#   +-------+

proc ERROR {msg} {
  MYPUTS stderr ERROR $msg
}

#   +---------------------+
#---| START_shell_session |-----------------------------------------------------
#   +---------------------+

proc START_shell_session {} {

  global spawn_id
  global PROMPTS
  global expect_out
  set timeout 2

  if {[catch {spawn /bin/bash} msg]} {
    ERROR $msg
    exit
  } else {
    INFO "Spawned /bin/bash using pid $msg and spawn_id $spawn_id"
  }

  expect {
    -re $PROMPTS {
      INFO "Got initial /bin/bash prompt '$expect_out(0,string)'"
    }
    timeout {
      ERROR "Timeout waiting for initial bash prompt"
      exit
    }
  }

  SEND_cmd "export 'PS1=You are still in a spawned shell, press Ctrl-D to exit# '"

}

#   +----------+
#---| SEND_cmd |----------------------------------------------------------------
#   +----------+

proc SEND_cmd {cmd} {
  global spawn_id
  global PROMPTS
  global expect_out

  INFO "Send command '$cmd' to spawn_id $spawn_id"
  send $cmd\r

  set timeout 2
  set NUM_TRIES 0
  set MAX_TRIES 90
  set STILL_LOOKING 1

  set t0 [clock seconds]

  #-- This allows enough time for output to acutally start
  after 333

  while {$STILL_LOOKING} {
    incr NUM_TRIES

    expect {
      -re $PROMPTS {
        INFO "GOT prompt '$expect_out(0,string)'"
        set STILL_LOOKING 0
        break
      }
    }

    if {$NUM_TRIES >= $MAX_TRIES} {
      ERROR "Giving up after $NUM_TRIES"
      exit
    }

    #after 1000
    set t1 [clock seconds]
    set elapsed [expr $t1 - $t0]
    INFO "Still looking after $elapsed seconds and $NUM_TRIES attempts"
  }
}

#   +------+
#---| MAIN |--------------------------------------------------------------------
#   +------+
#
# Earlier attempts...
#  SEND_cmd "find . -type f -ls | sed 's/^  *//g' | sed 's/  */ /g' | cut -d\\  -f7- | sort -n > $TMPF0"
#  SEND_cmd "find . -type f -exec ls -l --full-time {} \\; |cut -d\\  -f5,9- | sort -n > $TMPF0"
#  SEND_cmd "\ls -lR --full-time | egrep ^- | sed 's/  */ /g'"
#
#-------------------------------------------------------------------------------

  set prevsize -1
  set prevpath ""

  START_shell_session

  SEND_cmd "find . -type f -ls | sed 's/^  *//g' | sed 's/  */ /g' | cut -d\\  -f7- | sort -n > $TMPF0"

  if {[catch {open $TMPF0 r} fid]} {
    ERROR $fid
    exit
  } else {
    INFO "Opened $TMPF0 using channel id '$fid'"
  }

  set N 0
  set N0 0

  while {![eof $fid]} {

    gets $fid line

    if {[regexp {(\d+)\s+(\S+\s+\S+\s+\S+)\s+(.*)} $line junk size modtime currpath]} {

      if {$size < $MINSIZE} {continue}

      set SKIP 0
      foreach skipcheck $ignorelist {
        if {[regexp $skipcheck $line]} {
          set SKIP 1
          break
        }
      }

      if {$SKIP} {continue}

      incr N

      if {$size == $prevsize} {

        set prevbasename [file tail $prevpath]
        set currbasename [file tail $currpath]

        if {$currbasename == $prevbasename} {
          INFO "\nMATCH on size ($size) and name:\n\t$prevpath\n\t$currpath"

        } else {

          NOINFO
          incr N0
          SEND_cmd "sum $prevpath"
          INFOENABLE
          if {[regexp {[\r\n]+(\d+)\s+(\d+)[\r\n]+} $expect_out(buffer) junk junk0 junk1]} {
            set prevsum0 $junk0
            set prevsum1 $junk1
          } else {
            WARN "UNABLE TO PARSE CHECKSUM OUPTUT\n$expect_out(buffer)"
            continue
          }

          NOINFO
          SEND_cmd "sum $currpath"
          INFOENABLE
          if {[regexp {[\r\n]+(\d+)\s+(\d+)[\r\n]+} $expect_out(buffer) junk junk0 junk1]} {
            set currsum0 $junk0
            set currsum1 $junk1
          } else {
            WARN "UNABLE TO PARSE CHECKSUM OUPTUT\n$expect_out(buffer)"
            continue
          }

          if {$currsum0 == $prevsum0 && $currsum1 == $prevsum1} {
            INFO "\nMATCH on size ($size) and checksum ($currsum0 $currsum1):\n\t$prevpath\n\t$currpath"
          }
        }
      }

    } else {
      continue
    }

    set prevsize $size
    set prevpath $currpath

    if {[expr $N % 25] == 0} {
      INFO "\n\tProcessed $N files, $N0 checksums computed"
    }

  }

  close $fid

