##############################################################################################
##  ## To use this script you must set channel flag +google (ie .chanset #chan +google) ##  ##
##############################################################################################
##############################################################################################
##  ##                             Start Setup.                                         ##  ##
##############################################################################################
## Change the character between the "" below to change the command character/trigger.       ##
set googlecmdchar "!"
proc google {nick host hand chan type search} {
  if {[lsearch -exact [channel info $chan] +google] != -1} {
## Change the country code between the "" below to change the language of your results.     ##
    set googlectry "pt"
## Change the number between the "" below to change the number of results returned.         ##
    set googlemax "3"
## Change the characters between the "" below to change the logo shown with each result.    ##
    set googlelogo ""
## Change the format codes between the "" below to change the color/state of the text.      ##
    set textf "\0034"
## Change the format codes between the "" below to change the color/state of the links.     ##
    set linkf "\003\037"
##############################################################################################
##  ##                           End Setup.                                              ## ##
##############################################################################################
    set googlesite ajax.googleapis.com
    set googleurl /ajax/services/search/${type}?v=1.0&rsz=large&q=${search}&ql=${googlectry}&lr=lang_${googlectry}
    if {[catch {set googlesock [socket -async $googlesite 80]} sockerr]} {
      putlog "$googlesite $googleurl $sockerr error"
      return 0
      } else {
      puts $googlesock "GET $googleurl HTTP/1.0"
      puts $googlesock "Host: $googlesite"
      puts $googlesock "User-Agent: Opera 9.6"
      puts $googlesock ""
      flush $googlesock
      while {![eof $googlesock]} {
        set googlevar " [gets $googlesock] "
        set googlelink [regexp -all -nocase -inline {\"url\":\"([^\"]*)\"} $googlevar]
        set googledesc [regexp -all -nocase -inline {\"title\":\"([^\"]*)\"} $googlevar]
        if {$googledesc != "" && $googlelink != ""} {
          for {set x 1} {$x <= [expr 2 * $googlemax]} {incr x 2} {
            putserv "PRIVMSG $chan :$googlelogo results: $textf[dehex [lindex $x]] $linkf[dehex [lindex $googlelink $x]]" 
          }
        }
      }
      close $googlesock
      return 0 
    }
  }
}
proc asc {chr} {
  scan $chr %c asc
  return $asc
}
proc chr {asc} { return [format %c $asc] }
proc hex {decimal} { return [format %x $decimal] }
proc decimal {hex} { return [expr 0x$hex] }
proc dehex {string} {
  regsub -all {^\{|\}$} $string "" string
  set string [subst [regsub -nocase -all {\\u([a-f0-9]{4})} $string {[format %c [decimal \1]]}]]
  set string [subst [regsub -nocase -all {\%([a-f0-9]{2})} $string {[format %c [decimal \1]]}]]
  set string [subst [regsub -nocase -all {\&#([0-9]{2});} $string {[format %c \1]}]]
  set string [string map {&quot; \" &middot; ? &amp; & <b> \002 </b> \002} $string]
  return $string
}
proc urlencode {string} {
  regsub -all {^\{|\}$} $string "" string
  return [subst [regsub -nocase -all {([^a-z0-9])} $string {%[format %x [scan "\\&" %c]]}]]
}
proc googleweb {nick host hand chan args} { google $nick $host $hand $chan "web" [urlencode $args] }
proc googlelocal {nick host hand chan args} { google $nick $host $hand $chan "local" [urlencode $args] }
proc googlevideo {nick host hand chan args} { google $nick $host $hand $chan "video" [urlencode $args] }
proc googlenews {nick host hand chan args} { google $nick $host $hand $chan "news" [urlencode $args] }
proc googlebook {nick host hand chan args} { google $nick $host $hand $chan "books" [urlencode $args] }
proc googleimage {nick host hand chan args} { google $nick $host $hand $chan "images" [urlencode $args] }
proc googlepatent {nick host hand chan args} { google $nick $host $hand $chan "patent" [urlencode $args] }
bind pub - ${googlecmdchar}find googleweb
bind pub - ${googlecmdchar}glocal googlelocal
bind pub - ${googlecmdchar}gvideo googlevideo
bind pub - ${googlecmdchar}gnews googlenews
bind pub - ${googlecmdchar}gbook googlebook
bind pub - ${googlecmdchar}gimage googleimage
bind pub - ${googlecmdchar}gpatent googlepatent
setudef flag google

