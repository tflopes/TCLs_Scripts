## C O N F I G :

#should the script work on all channels? 1:on, 0:off
set sl(all) 0

#or be channel-spesific? (separate channels with a space)
set sl(chans) ""

#the number to increase to the limit, when triggered
set sl(limit) 3

#lowest diff between [limit - users] before increasing/decreasing the limit with $sl(limit)
set sl(offset_min) 2

#highest diff between [limit - users] before increasing/decreasing the limit with $sl(limit)
set sl(offset_max) 4

#time between each check, in minutes
set sl(timer) 1

#should we check the limit on join, quit, part & kick (can act weird during netsplits..)? 1:on, 0:off 
set sl(misc) 1


## S C R I P T :

#binds
bind join - * do:join
bind sign - * do:quit
bind part - * do:part
bind kick - * do:kick

#redefine som varibles
set sl(chans) [string tolower $sl(chans)]

#do:limit - check the channellimit, and set it if the offset is invalid
proc do:limit {chan} {

   #load some global variables
   global sl

   #set some variables
   set chan [string tolower $chan]
   set enabled [lsearch -exact $sl(chans) $chan]

   #check if the channel is enabled, else - return
   if {!$sl(all) && $enabled == -1} {return 0}

   #set some more variables
   set users [llength [chanlist $chan]]
   set mode [getchanmode $chan]
   
   #check if the chan has a limit, if not set it
   if {[string match *l* $mode]} {
      set limit [lindex [split $mode] end]
   } else {
      putserv "mode $chan +l [expr $users + $sl(limit)]"
      return 0
   }
   
   #check the current offset
   set offset [expr $limit - $users]
   
   #if the offset was too high/low, set the limit
   if {($offset <= $sl(offset_min)) || ($offset >= $sl(offset_max))} {
      set limit [expr $users + $sl(limit)]
      putserv "mode $chan +l $limit"
   } else {
      return 0
   }


} ;#end proc


#do:part - redirect to do:limit
proc do:part {nick host handle chan reason} {

   #load globals
   global sl
   
   #some checking
   if {$sl(misc)} {
      do:limit $chan
   }
}

#do:quit - redirect to do:limit
proc do:quit {nick host handle chan reason} {
   
   #load globals
   global sl
   
   #some checking
   if {$sl(misc)} {
      do:limit $chan
   }
}

#do:kick - redirect to do:limit
proc do:kick {nick host handle chan target reason} {
   
   #load globals
   global sl
   
   #some checking
   if {$sl(misc)} {
      do:limit $chan
   }
}

#do:join - redirect to do:limit
proc do:join {nick host handle chan} {
   
   #load globals
   global sl
   
   #some checking
   if {$sl(misc)} {
      do:limit $chan
   }
}

#limit:timer - check the limit every n minutes
proc limit:timer {} {
   
   #load some global variables
   global sl
   
   #check what we were told todo
   if {$sl(all)} {
   
      #loop through all the channels the bot is on
      foreach chan [split channels] {
         do:limit $chan
      }
   
   } else {
   
      #loop through the chans and call do:join
      foreach chan [split $sl(chans)] {
         do:limit $chan
      }

   }

   #set the timer for the next check
   timer $sl(timer) "limit:timer"

} ;#end proc


#halt 1min before starting the timer
timer 1 "limit:timer"

#gives me some credits
putlog "smartlimit loaded"
