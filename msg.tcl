Enter file contents here# Basic anti-idle script, sends random msg's to the specified channel at
# random time intervals.
#
# v1.0 - Initial release
# v1.1 - Stremlined startup timer check, added +1 to utimer

# Channel to send anti-idle messages to
set ai_chan ""

# Maximum time interval between messages (in minutes)
set ai_time 60

# Messages to send
set ai_msgs {
   "Tá acordar!"
   "Oi"
   ":)"
   "Visita-nos"
   ":+)"
   "Para veres algumas das noticias"
   ":P"
   "Procuras algum nick ? digita !seen nick"
   ":)"
   ":*)"
   "Para pesquisares no google digita !find texto"
   ":-)"
   ":)~" 
   ":-P"
   ":-)"
   ":-P"
   "Para saberes a info de um video/musica do YouTube, coloca aqui o link que eu digo-te"
   ":o)"
   "Boas"
   ";)"
   "Que contam ?"
   "Que se passa ?"
}


# Don't edit anything below unless you know what you're doing

proc ai_start {} {
  global ai_time
  if {[string match *ai_sendmsg* [timers]]} {return 0}
  timer [expr [rand $ai_time] + 1] ai_sendmsg
}

proc ai_sendmsg {} {
  global botnick ai_chan ai_msgs ai_time
  if {[validchan $ai_chan] && [onchan $botnick $ai_chan]} {
    puthelp "PRIVMSG $ai_chan :[lindex $ai_msgs [rand [llength $ai_msgs]]]"
  }
  timer [expr [rand $ai_time] + 1] ai_sendmsg
}

set ai_chan [string tolower $ai_chan]

ai_start

putlog "MSG TCL Loaded"



