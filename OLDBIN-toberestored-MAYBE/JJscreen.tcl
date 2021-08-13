#!/usr/bin/expect

set SCREEN_EXEC /usr/bin/screen
set SCREEN_BASENAME [file tail $SCREEN_EXEC]

if { ! [file executable $SCREEN_EXEC]} {
  puts "\t$SCREEN_BASENAME not installed?"
  exit
}

set SKIP_rawScreensDisplay 1

log_user 0

#   +----------------+
#---| my_custom_sort |---
#   +----------------+

proc my_custom_sort {a b} {

  if {![regexp {^(\d+)\.pts} $a junk aa]} { set aa 0 }
  if {![regexp {^(\d+)\.pts} $b junk bb]} { set bb 0 }

  if {$aa < $bb} {
    return 0
  } else {
    return 1
  }

}

#   +------+
#---| MAIN |---
#   +------+

    if { ! $SKIP_rawScreensDisplay} {
      puts ""
    }

#-- Do an initial '$SCREEN_EXEC -list'

  if {[catch {spawn $SCREEN_EXEC -list} msg]} {
    puts stderr "Error spawning '$SCREEN_EXEC -list': $msg"
    exit
  }

  expect {
    eof {
      foreach line [split $expect_out(buffer) \r\n] {
        set linetrimmed [string trim $line]

        if {[regexp {There are screens on:} $linetrimmed]} {
          if { ! $SKIP_rawScreensDisplay} {
            puts $linetrimmed
          }

        } elseif {[regexp {There is a screen on:} $linetrimmed]} {
          if { ! $SKIP_rawScreensDisplay} {
            puts $linetrimmed
          }

        } elseif {[regexp {\d+ Socket(?:|s) in } $linetrimmed]} {
          continue

        } elseif {[regexp {No Sockets found in } $linetrimmed]} {
          continue

        } elseif {[string length $linetrimmed] > 0 } {

          if {[regexp {.*_\d\d\d\d\d\d_\d\d\d(____.*)} $linetrimmed junk XXX]} {
            set buf0 "$XXX $linetrimmed"
          } elseif {[regexp {(.*____)\d\d\d\d\d\d_\d\d\d\d\d\d_\d\d\d} $linetrimmed junk XXX]} {
            set buf0 "$linetrimmed $XXX"
          } else {
            set buf0 "WTF '$linetrimmed'"
          }

          lappend buf0buf $buf0
        }

        if {[regexp {\s+(\d+\.[^\(]+)\(.*\).*\(((?:Detached|Attached))\)} $line junk session_name status]} {
          lappend session_list [format %s::%s $session_name $status]
        }
      }
    }
  }

#-- Display the screens we found

    if {[info exists buf0buf]} {
      foreach buf0a [lsort $buf0buf] {
        if { ! [regexp {^____\S+\s+(.*)} $buf0a junk buf0bufffff]} {
           if { ! [regexp {^(\S+\s+\(.*\))} $buf0a junk buf0bufffff]} {
              puts "NOT PARSED buf0a: '$buf0a'"
              set buf0bufffff BOGO
           }
        }
        if { ! $SKIP_rawScreensDisplay} {
          puts "\t$buf0bufffff"
        }
      }
    } else {
      puts "\n\t\tnothing!\n"
      exit
    }

#-- Now transform each line of output to a valid screen command

  puts ""

  if {[info exists session_list]} {
    set session_list [lsort -command my_custom_sort $session_list]
  }

  if {[info exists session_list]} {

    foreach session_name $session_list {

      switch -- [regexp {Attached} $session_name] {
        1 {
          set SCREEN_OPTS "x "
        }
        default {
          set SCREEN_OPTS "Ar"
        }
      }

      if { ! [regexp {(\d+\..*)\s+::} $session_name junk session_name_v2]} {
        set session_name_v2 JUNK_v2
      }

      if { ! [regexp {.*_\d\d\d\d\d\d_\d\d\d(____.*)} $session_name_v2 junk session_name_XX]} {
         if { ! [regexp {^[^\.]+\.(\S+)} $session_name_v2 junk session_name_XX]} {
            set session_name_XX JUNK_XX
         }
      }

      set buf "$session_name_XX $SCREEN_BASENAME -$SCREEN_OPTS \"$session_name_v2\""

      if {[info exists bufbuf]} {
        lappend bufbuf $buf
      } else {
        set bufbuf [list $buf]
      }

    }
  }

#-- Now display the screen commands

  foreach buf [lsort $bufbuf] {
    if {[regexp {^\S*____\S+\s+(.*)} $buf junk newbuf]} {
      puts "\t$newbuf"
    } else {
      puts "WTF - Unabled to parse buf '$buf'"
    }
  }
  puts ""

#-- Expect is done for now

  catch {close -i $spawn_id}
  catch {wait -i $spawn_id}


#-- Is user asking to attach to a session?

  if {$argc > 0 && [lindex $argv 0] != "-list"} {

    #-- Find first session that matches your regexp
      set found 0
      set your_regexp [lindex $argv 0]
      if {[info exists session_list]} {
        foreach session_name $session_list {
          if {[regexp "$your_regexp" $session_name]} {

            switch -- [regexp {Attached} $session_name] {
              1 {
                set SCREEN_OPTS "x"
              }
              default {
                set SCREEN_OPTS "Ar"
              }
            }
            regexp {(\d+\..*)\s+::} $session_name junk session_name_v2
            puts "\nReady to attach to $session_name_v2"
            set found 1
            break
          }
        }
      }
      if { ! $found } {
        puts stderr "No session matched '$your_regexp'"
        exit 255
      }

    #-- Update screen title
      # if {[regexp {\d+.vim:\s*(.*)\s*::} $session_name junk session_name_brief]} {
      #   puts "\033\]0;vim $session_name_brief\007\003"
      # } else {
      #   puts "\033\]0;vim $session_name_brief\007\003"
      # }

    #-- Attempt to attach to the matched session

      regexp {(\d+)\.\S+} $session_name_v2 junk session_name_v3

      if {[catch {spawn $SCREEN_EXEC -$SCREEN_OPTS $session_name_v3} msg]} {
        puts stderr "Error spawning '$SCREEN_EXEC -$SCREEN_OPTS $session_name_v3': $msg"
        exit 255
      } else {
        puts "Spawned '$SCREEN_EXEC -$SCREEN_OPTS $session_name_v3' on pid $msg using spawn_id $spawn_id"
      }

    #-- Give control back to user
      interact

  }

