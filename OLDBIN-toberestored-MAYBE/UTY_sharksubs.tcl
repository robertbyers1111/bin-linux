#!/usr/bin/tclsh

   source $HOME/lib/sharksubslib.tcl

   if {$argc != 2} {
     puts stderr "USAGE: [file tail [info script]] IPlow IPhigh"
     exit
   }

   set ip0_dottedDecimal [lindex $argv 0]
   set ip1_dottedDecimal [lindex $argv 1]

   sharkfilter $ip0_dottedDecimal $ip1_dottedDecimal result

   set first 1

   foreach x $result {
     if {$first} {
       puts -nonewline $x
       set first 0
     } else {
       puts -nonewline " or $x"
     }
   }
   puts ""

