bind pub - !hex hexIdent 
bind join - * hexIdentJoin 

setudef flag hex 
setudef flag hexjoin 

proc hexIdentJoin {nick uhost hand chan} { 
   if {![channel get $chan hexjoin]} { return } 
   hexIdent $nick $uhost $hand $chan $nick 1 
} 

proc hexIdent {nick uhost hand chan text {join 0}} { 
   if {![channel get $chan hex]} { return } 
   set wnick [lindex [split [getchanhost [lindex [split $text] 0] $chan] @] 0] 
   if {[string length $wnick]} { set text $wnick } { set wnick $text } 
   set a $text 
   if {[string length $a] == 8} { 
      while {[string length $a]} { 
         set piece [string range $a 0 1] 
         set a [string range $a 2 end] 
         if {[regexp {^[a-fA-F0-9]+$} $piece]} { 
            lappend ip [scan $piece %x] 
         } else { 
            set flag 1 ; break 
         } 
      } 
      if {![info exists flag]} { 
         set ip [join $ip "."] 
         putserv "privmsg # : Entrou no canal $chan o nick $nick com o ident = $text -> $ip" 
      } else { 
         if {$join < 1} { 
            putserv "privmsg # : $nick $text não tem um IP hexadecimal" 
         } 
      } 
   } else { 
      if {$join < 1} { 
         putserv "privmsg #palmela-bots : $wnick não tem um IP hexadecimal" 
      } 
   } 
}

putlog "IP Hex Loaded"
