#!/usr/bin/tclsh
puts abc!

  global sizeHash
  global todoList
  global FLAG_DEBUG
  global SKIP_STEP1
  global SKIP_STEP2
  global FNAME_HASHTBL

  set SKIP_STEP1 0
  set SKIP_STEP2 1
  set FLAG_DEBUG 1
  set TARGET /home/bbyers/bbdupes
  set FNAME_HASHTBL sizeHash.txt

#   +-----+
#---| NOW |---------------------------------------------------------------------
#   +-----+
#
# Returns the current date and time in various formats as follows:
#
# -----     ------------   ---------------
# Param     Set to         Format returned
# -----     ------------   ---------------
#
#   fmt     (default)      H:M:S
#           HMS            H:M:S
#           ymd            Y-M-D
#           ymdhms         Y-M-D_H:M:S
#           (all others)   H:M:S
#
# -----     ------------   -------
# Param     Set to         Meaning
# -----     ------------   -------
#
#   nc      1, nc or NC    Supresses any '-', '_' or ':' character.
#           (default)      Disables the supression
#           (all others)   Disables the supression
#
#-------------------------------------------------------------------------------

proc NOW {{fmt {HMS}} {nc {0}}} {

  set fmt [string tolower $fmt]
  regsub -all {[-_]} $fmt {} fmt

  switch -- [string tolower $nc] {
    1 -
    nc {
      set nc 1
    }
    default {
      set nc 0
    }
  }

  switch -- $fmt {
    ymd {
      if {$nc} {
        set fmtString "%y%m%d"
      } else {
        set fmtString "%y-%m-%d"
      }
    }
    ymdhms {
      if {$nc} {
        set fmtString "%y%m%d_%H%M%S"
      } else {
        set fmtString "%y-%m-%d_%H:%M:%S"
      }
    }
    hms -
    default {
      if {$nc} {
        set fmtString "%H%M%S"
      } else {
        set fmtString "%H:%M:%S"
      }
    }
  }

  return [clock format [clock seconds] -format $fmtString]
}

#   +-------+
#---| DEBUG |-------------------------------------------------------------------
#   +-------+

proc DEBUG {msg} {
  global FLAG_DEBUG
  if {[info exists FLAG_DEBUG] && $FLAG_DEBUG} {
    if {$msg == ""} {
      puts ""
    } else {
      puts "\[DBG  [NOW]\] $msg"
    }
  }
}

#   +------+
#---| INFO |--------------------------------------------------------------------
#   +------+

proc INFO {msg} {
  puts "\[INFO [NOW]\] $msg"
}

#   +--------------+
#---| do_directory |------------------------------------------------------------
#   +--------------+
#
#----------------------------------
#
#   FLAG_listing:
#
#     F    list files only
#     D    list directories only
#     FD   list files and directories
#     DF   list files and directories
#
#----------------------------------

proc do_directory {FLAG_listing {dir {.}}} {

global sizeHash
global FNAME_HASHTBL

DEBUG ""
DEBUG ""
DEBUG ""
DEBUG "==== ENTER do_directory $dir ===="
DEBUG "     currdir: [pwd]"
DEBUG "     processing '$dir'"

#   +--------------------+
#---| Check list options |---
#   +--------------------+

    DEBUG "     checking FLAG_listing '$FLAG_listing'.."

    if {[regexp -nocase F $FLAG_listing]} {
      DEBUG "         files will be displayed"
      set SHOW_files 1
    } else {
      DEBUG "         files will not be displayed"
      set SHOW_files 0
    }

    if {[regexp -nocase D $FLAG_listing]} {
      DEBUG "         directories will be displayed"
      set SHOW_dirs 1
    } else {
      DEBUG "         directories will not be displayed"
      set SHOW_dirs 0
    }

    if { ! [file isdirectory $dir]} {
       puts stderr "WTF you passed something ('$dir') to proc do_directory that is NOT a directory"
       return
    }

  #   +-----------------------------+
  #---| cd to the initial directory |---
  #   +-----------------------------+

    if { [regexp {^\.$} $dir]} {
       DEBUG "   '$dir' is myself"
    } else {
       DEBUG "     The item passed in, '$dir', is a directory"
       DEBUG "     Now changing into '$dir'.."
       DEBUG "         pwd before: \[[file tail [pwd]]\]"
       cd $dir
       set CURR_DIR [pwd]
       DEBUG "         pwd after:  \[[file tail [pwd]]\]"
       DEBUG "       fullpath pwd: \[$CURR_DIR\]"
    }

  #   +-------------------------+
  #---| Get a directory listing |---
  #   +-------------------------+

    set listing [glob -nocomplain *]

    if {[info exists listing]} {
       DEBUG "     Directory listing for this directory.."
       foreach thing $listing {
          DEBUG "         $thing"
       }
    } else {
       DEBUG ""
       DEBUG "   No listing was produced for '$dir':"
    }

  #   +-----------------------------------+
  #---| Process each thing in the listing |---
  #   +-----------------------------------+

    DEBUG ""
    foreach thing $listing {
       DEBUG "   thing: $thing"

    #   +-------------------+
    #---| Skip myself ('.') |---
    #   +-------------------+

       if { [regexp {^\.$} $thing]} {
          continue
       }

       if {[file isdirectory $thing]} {

          DEBUG "   $thing is a directory"

       #   +--------------------------+
       #---| Display a directory name |---
       #   +--------------------------+

          if {$SHOW_dirs} {
             INFO "   d $thing"
          }

       #   +----------------------------------------------+
       #---| Recurse into any directory other than myself |---
       #   +----------------------------------------------+

          if { ! [regexp {^\.$} $thing]} {
             DEBUG "   Now recursing into $thing"


                #oO0======== RECURSE ========0Oo#
                #                               #
                    do_directory FD $thing
                #                               #
                #oO0=========================0Oo#


             DEBUG "   (just returned from do_directory $dir)"
             DEBUG "   [pwd] before"
             cd ..
             DEBUG "   [pwd] after"
          }

       #   +---------------------+
       #---| Display a file name |---
       #   +---------------------+

       } elseif {[file isfile $thing]} {

          set size [file size $thing]

          if {$size >= 1 && $size < 500000000000} {

                   set normalName [file normalize $thing]

                   DEBUG "   Found a file: \[$thing\] (size $size)"
                   DEBUG "   normalName:   \[$normalName\]"

                   if {[info exists sizeHash($size)]} {
                     lappend sizeHash($size) $normalName
                   } else {
                     set sizeHash($size) [list $normalName]
                   }
                   DEBUG "   sizeHash($size): $sizeHash($size)"

                   if {$SHOW_files} {
                       INFO "   f [file normalize $thing] ($size)"
                   }

                } else {
                   DEBUG "   skip this file. size ($size) is larger than 500000000000"
                }
       }
    }

}

#   +------+
#---| MAIN |---
#   +------+

#-- This proc traverses the directory tree and creates a hash table indexed by file sizes

  if { ! $SKIP_STEP1} {

      puts stderr "[NOW] traversing the current directory"

      do_directory FD

      INFO "Dumping entire hash table to disk.."
      puts stderr "[NOW] Dumping entire hash table to disk.."

      if {[catch {open $FNAME_HASHTBL w} fid]} {
        puts stderr "ERROR: $fid"
        exit
      } else {
        puts "Opened $FNAME_HASHTBL using channel id '$fid'"
      }

      set n 0
      foreach size [lsort -decreasing -integer [array names sizeHash]] {
        puts $fid "$size $sizeHash($size)"
        incr n
      }

      catch {close $fid}

      INFO "Finished dumping $n records from hash table to disk"
      puts stderr "[NOW] Finished dumping $n records from hash table to disk"

  } else {

      INFO "Skipping STEP 1, reading hash table from disk.."
      puts stderr "[NOW] Skipping STEP 1, reading hash table from disk.."

      if {[catch {open $FNAME_HASHTBL r} fid]} {
        puts stderr "ERROR: $fid"
        exit
      } else {
        puts "Opened $FNAME_HASHTBL using channel id '$fid'"
      }

      while {![eof $fid]} {

        gets $fid line

        set line [string trim $line]
        regexp {(\d+)\s+(.*)} $line junk size theFiles

        set sizeHash($size) $theFiles

        DEBUG "   sizeHash($size): $sizeHash($size)"

      }

      close $fid

  }

#-- Search the hash table for multiple files of same size; create a to do list

  if { $SKIP_STEP2} {
    INFO "Skipping step2 and beyond.."
    puts stderr "[NOW] Skipping step2 and beyond.."
    exit
  }

  puts stderr "[NOW] Searching hash table for files of the same size"

  DEBUG ""
  INFO "Now inspect the file size hash table"
  foreach dx [lsort -decreasing -integer [array names sizeHash]] {
    set numfiles [llength $sizeHash($dx)]
    set msg0 "There are $numfiles files of size $dx"
    if {$numfiles > 1} {
      DEBUG "$msg0 - will need to compute checksums! Yay!"
      if {[info exists todoList]} {
        lappend todoList $dx
      } else {
        set todoList [list $dx]
      }
    } else {
      DEBUG "$msg0 - no need to compute checksums"
    }
  }

#-- Process the to do list

  set TotalGroupsFound 0

  DEBUG "Now process the to do list"

  foreach dx [lsort -decreasing -integer $todoList] {

    #-- Skip Zero Length Files

        if {$dx == 0} {
          set numfiles [llength $sizeHash($dx)]
          DEBUG ""
          DEBUG "(ignoring $numfiles files of size ZERO)"
          continue
        }

    #-- Display an informative message on stderr

        puts stderr "[NOW] Checking files of size $dx"

    #-- Sort the filenames for this hash value

        set sizeHash($dx) [lsort $sizeHash($dx)]

    #-- Display some debug info

        set msg [format %s... [string range "hash($dx): $sizeHash($dx)" 0 174]]
        set numfiles [llength $sizeHash($dx)]
        DEBUG ""
        DEBUG "=========================================================================="
        DEBUG "size:$dx"
        DEBUG $msg
        DEBUG "Processing $numfiles files of size $dx..."
        DEBUG ""
        foreach filename [lsort $sizeHash($dx)] {
           DEBUG "      $filename"
        }

    #-- Compute checksums

        DEBUG ""
        DEBUG "      Computing checksums..."
        foreach filename [lsort $sizeHash($dx)] {
               ##convert to DOS path if needed
               #if {[regexp : $filename]} {
               #  regsub -all / $filename \\\\ filename
               #}
           if {[catch {exec /usr/bin/sum -r $filename} sum0]} {
             DEBUG "WTF: $sum0"
             set sum0 "-1 -1"
           }
           if {[catch {exec /usr/bin/sum -s $filename | cut -d\   -f1-2} sum1]} {
             DEBUG "WTF: $sum1"
             set sum1 "-1 -1"
           }
           DEBUG "      $filename"
           DEBUG "            sum0: $sum0"
           DEBUG "            sum1: $sum1"
           set arySum0($filename) $sum0
           set arySum1($filename) $sum1
        }

    #-- Examine checksums, looking for duplicates

        set numDupeGroup 0

        set completeSortedFileList [lsort [array names arySum0]]
        set levelsToCompare [llength $completeSortedFileList]

        DEBUG ""
        DEBUG "     Comparing $levelsToCompare levels"

        #-- Compare all files to each other

        for {set start 0} {$start < [expr [llength $completeSortedFileList] - 1]} {incr start} {

            DEBUG ""
            DEBUG "   ----------------- LEVEL [expr $start + 1] -----------------"
            set firstNotFoundYet 1

            if {$numDupeGroup > 0 && [info exists aryMatch($numDupeGroup)]} {

              set newHeadOfList [lindex $completeSortedFileList $start]
              set alreadyProcessed [lsearch $aryMatch($numDupeGroup) $newHeadOfList]

              DEBUG ""
              DEBUG "     newHeadOfList: $newHeadOfList"
              DEBUG "     alreadyProcessed: $alreadyProcessed"

              if {$alreadyProcessed >= 0} {
                DEBUG "     This file has already been matched. No need to test it again"
                continue
              }
            }

            set isFirst 1
            set thisSortedFileList [lrange $completeSortedFileList $start end]

            foreach filename $thisSortedFileList {

              if {$isFirst} {

                set isFirst 0
                set firstName $filename
                set firstSum0 $arySum0($firstName)
                set firstSum1 $arySum1($firstName)

              } else {

                set fileSum0 $arySum0($filename)
                set fileSum1 $arySum1($filename)

                if {$fileSum0 == $firstSum0 \
                 && $fileSum1 == $firstSum1} {

                    DEBUG ""
                    DEBUG "     FOUND A MATCH!"
                    DEBUG "        first sum: $firstSum0 $firstSum1 $firstName"
                    DEBUG "        file  sum: $fileSum0 $fileSum1 $filename"

                    if {$firstNotFoundYet} {
                      incr numDupeGroup
                      incr TotalGroupsFound
                      set aryMatch($numDupeGroup) [list $firstName $filename]

                      DEBUG ""
                      DEBUG "      Incremented Duplicate Group Count: $numDupeGroup, total groups found so far: $TotalGroupsFound"
                      DEBUG "      Created aryMatch($numDupeGroup)"

                      foreach junk $aryMatch($numDupeGroup) {
                        DEBUG "               $junk"
                      }
                      set firstNotFoundYet 0

                    } else {

                      lappend aryMatch($numDupeGroup) $filename

                      DEBUG ""
                      DEBUG "      Updated aryMatch($numDupeGroup)"
                      foreach junk $aryMatch($numDupeGroup) {
                        DEBUG "               $junk"
                      }
                    }

                } else {
                  DEBUG ""
                  DEBUG "     no match found..."
                  DEBUG "        first sum: $firstSum0 $firstSum1 $firstName"
                  DEBUG "        file  sum: $fileSum0 $fileSum1 $filename"
                }
              }
            }

            DEBUG ""
            if {[info exists aryMatch($numDupeGroup)]} {
              set jfirst 1
              foreach junk $aryMatch($numDupeGroup) {
                if {$jfirst} {
                  DEBUG "DUPEGROUP:    $junk"
                  set jfirst 0
                } else {
                  set TARGETFULL [format %s%s $TARGET $junk]
                  set TARGETDIR [file dirname $TARGETFULL]
                  DEBUG "DUPEGROUP: mkdir -p $TARGETDIR"
                  DEBUG "DUPEGROUP: mv $junk $TARGETFULL"
                }
              }
            }

        }

    #-- Clear stuff so next iteration works OK

        foreach dx [lsort [array names arySum0]] {
          unset arySum0($dx)
        }

        foreach dx [lsort [array names arySum1]] {
          unset arySum1($dx)
        }

        foreach dx [lsort [array names aryMatch]] {
          unset aryMatch($dx)
        }

  }

