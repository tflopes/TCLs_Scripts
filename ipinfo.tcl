##############################################################################################
##   To use this script you must set channel flag +ipinfo (ie .chanset #chan +ipinfo)     ##
##############################################################################################
##############################################################################################
##  ##                             Start Setup.                                         ##  ##
##############################################################################################
## Change the character between the "" below to change the command character/trigger.       ##
set Ipinfocmdchar "!"
proc Ipinfo {nick host hand chan search} {
  if {[lsearch -exact [channel info $chan] +ipinfo] != -1} {
## Change the format codes between the "" below to change the color/state of the text.      ##
    set titlef ""
    set textf ""
##############################################################################################
##  ##                           End Setup.                                              ## ##
##############################################################################################
    set Ipinfosite "www.melissadata.com"
    if {$search == ""} { 
    putserv "PRIVMSG $chan :${textf}You must provide an ip address to check!"
    } else {
         set Ipinfourl "/lookups/iplocation.asp?ipaddress=${search}"
         if {[catch {set Ipinfosock [socket -async $Ipinfosite 80]} sockerr]} {
           putlog "$Ipinfosite $Ipinfourl $sockerr error"
           return 0
         } else {
             puts $Ipinfosock "GET $Ipinfourl HTTP/1.0"
             puts $Ipinfosock "Host: $Ipinfosite"
             puts $Ipinfosock "User-Agent: Opera 9.6"
             puts $Ipinfosock ""
             flush $Ipinfosock
             while {![eof $Ipinfosock]} {
               set Ipinfovar " [gets $Ipinfosock] "
	  if {[regexp {<div align='center' class='Lookupserror'>([^<]*)<b>([^<]*)<\/b>([^<]*)([^<]*)<\/div>} $Ipinfovar]} {
	    putserv "PRIVMSG $chan : ${titlef}Syntax error: ${textf}Ip must be in the form of 1.2.3.4"
	    close $Ipinfosock
                  return 0 
	   } elseif {[regexp {<td class='columresult'>([^<]*)<\/td><td align='left'><b>([^<]*)<\/b><\/td><\/tr>} $Ipinfovar]} {
	       set IPResult [regexp -all -inline {<td class='columresult'>([^<]*)<\/td><td align='left'><b>([^<]*)<\/b><\/td><\/tr>} $Ipinfovar]
	       set IPResults "${titlef}[lindex $IPResult {1}]: ${textf}[lindex $IPResult {2}] [lindex $IPResult {3}]"
	       putserv "PRIVMSG $chan : [ipinforecode $IPResults]"
	   }
          }
          close $Ipinfosock
          return 0 
      }
    }
  }
}
proc ipinforecode { textin } {
  return [string map {&quot; \" &middot; "" &amp; & &nbsp; ""} [subst [regsub -nocase -all {&#([0-9]{1,5});} $textin {\u\1}]]]
}
bind pub - ${Ipinfocmdchar}ipinfo Ipinfo
setudef flag ipinfo
putlog "Ipinfo Loaded"
