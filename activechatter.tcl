# $Id: activechatter.tcl, v3.80.b eggdrop-1.6.18 23/02/2009 10:11:56 Exp $

#########################################################################
#                                                                       #
# ############                                                          #
# INSTALLATION                                                          #
# ############                                                          #
#                                                                       #
#  This quick installation tutorial consists of 4 steps. Please follow  #
#  all steps correctly in order to setup your script.                   #
#                                                                       #
# (1) Upload the file activechatter.tcl in your eggdrop '/scripts'      #
#     folder along with your other scripts.                             #
#                                                                       #
# (2) OPEN your eggdrops configuration (.conf) file and add a link at   #
#     the bottom of the configuration file to the path of drone nick    #
#     remover script, it would be:                                      #
#                                                                       #
#               source scripts/activechatter.tcl                        #
#                                                                       #
#                                                                       #
# (3) SAVE your bots configuration file.                                #
#                                                                       #
# (4) REHASH and RESTART your bot.                                      #
#                                                                       #
#########################################################################


##############################################
### Start configuring variables from here! ###
##############################################

#Set the channels you would like this script to work on.
#USAGE: [1/2] (1=User defined channels, 2=All channels the bot is on)
set autovoice(chantype) "1"


### SET THIS ONLY IF YOU HAVE SET THE PREVIOUS SETTING TO '1' ###
#Set the channels below on which this script should work. Each channel
#must separated by a space in between to create a list-like structure.
#USAGE: set autovoice(channels) "#channel1 #channel2 #mychannel"
set autovoice(chans) ""


#Set the 'number of lines' here after which a user will be voiced for being
#an ACTIVE CHATTER. Only channel messages will be counted for activity.
set autovoice(lines) "3"


#Set the time here in 'minutes' after which you would like to devoice idlers (UNACTIVE
#CHATTERs). Users idling for more than this number of minute(s) will be devoiced.
######################################################################################
#If you wish yo disable this setting, set it to: "0"
#USAGE: Any numerical integer value.
set autovoice(dvtime) "60"


### SET THIS ONLY IF YOU HAVE ENABLED (UNACTIVE CHATTER) DEVOICING FOR IDLERS ###
#Set the time here in 'minutes' after which you would continuously like to check
#channel voices for idling. It is better to set this value low for good accuracy.
#USAGE: Any numerical integer value.
set autovoice(dvcheck) "2"


### ACTIVE-CHATTER (VOICE) EXEMPT NICKS ###
#Set the list of nicks here which you would like to be exempted from being
#autovoiced by the script. Place separate each entry by placing it in a new line.
##################################################################################
#If you do not have any nick to exempt, then: set autovoice(avexempt) {}
set autovoice(avexempt) {
example:#canal
example1:#canal
}


### UNACTIVE-CHATTER (DEVOICE) EXEMPT NICKS ###
#Set the list of nicks here which you would like to be exempted from being
#devoiced by the script. Place separate each entry by placing it in a new line.
################################################################################
#If you do not have any nick to exempt, then: set autovoice(dvexempt) {}
set autovoice(dvexempt) {
}


### SET THE TEXT TO DISPLAY IN THE +V (VOICING) MODE ###
#Set the text to display while voicing the active chatters. This text will be
#displayed when removing the channel key (mode: -k). Control codes such as
#color/bold/underline/reverses can also be used in the string.
#Please see: http://tclhelp.net/#faqcolor for more information on control codes.
################################################################################
set autovoice(voicemode) ":)"


### SET THE TEXT TO DISPLAY IN THE -V (DE-VOICING) MODE ###
#Set the text to display while devoicing the idle chatters. This text will be
#displayed when removing the channel key (mode: -k). Control codes such as
#color/bold/underline/reverses can also be used in the string.
#Please see: http://tclhelp.net/#faqcolor for more information on control codes.
################################################################################
set autovoice(devoicemode) ":("



#############################################################
### Congratulations! Script configuration is now complete ###
#############################################################


##############################################################################
### Don't edit anything else from this point onwards even if you know tcl! ###
##############################################################################

set autovoice(auth) "\x61\x77\x79\x65\x61\x68"
set autovoice(ver) "v3.80.b"

bind pubm - "*" autovoice:users
bind join - "*" autovoice:erase:record
if {$autovoice(dvtime) > 0} {bind time - "*" autovoice:devoice:idlers}

proc autovoice:users {nick uhost hand chan text} {
 global autovoice voice
 if {($autovoice(chantype) == 1) && ([lsearch -exact [split [string tolower $autovoice(chans)]] [string tolower $chan]] == -1)} { return 0 }
 if {[isbotnick $nick] || [isop $nick $chan] || [isvoice $nick $chan]} { return 0 }
 set exemptlist [list]
 foreach nickchan $autovoice(avexempt) {
  lappend exemptlist $nickchan
 }
 if {[llength $exemptlist] > 0} {
  foreach nickchan $exemptlist {
   if {[string equal -nocase $nickchan $nick] || ([string equal -nocase [lindex [split $nickchan :] 0] $nick] && [string equal -nocase [lindex [split $nickchan :] 1] $chan])} {
     return 0
     }
   }
 }
 set user [split [string tolower $nick:$chan]]
 if {![info exists voice($user)] && ![isvoice $nick $chan] && ![isop $nick $chan]} {
   set voice($user) 0
 } elseif {[info exists voice($user)] && ([expr $voice($user) + 1] >= $autovoice(lines)) && ![isop $nick $chan] && ![isvoice $nick $chan]} {
   utimer 3 [list autovoice:delay $nick $chan]
   unset voice($user)
 } elseif {[info exists voice($user)]} {
   incr voice($user)
  }
}

proc autovoice:delay {nick chan} {
 global autovoice voice
 set user [split [string tolower $nick:$chan]]
 if {[botisop $chan] && [onchan $nick $chan] && ![isop $nick $chan] && ![isvoice $nick $chan]} {
  pushmode $chan +v $nick
  set voiced($user) 1
 }
 if {[info exists voiced($user)]} {
  pushmode $chan -k $autovoice(voicemode)
  flushmode $chan
  }
}

proc autovoice:erase:record {nick uhost hand chan} {
 global autovoice voice
 if {($autovoice(chantype) == 1) && ([lsearch -exact [split [string tolower $autovoice(chans)]] [string tolower $chan]] == -1)} { return 0 }
 if {[isbotnick $nick]} { return 0 }
 set user [split [string tolower $nick:$chan]]
 if {[info exists voice($user)]} { unset voice($user) }
}

proc autovoice:devoice:idlers {m h d mo y} {
 global autovoice voice
 if {([scan $m %d]+([scan $h %d]*60)) % $autovoice(dvcheck) == 0} {
 switch -exact $autovoice(chantype) {
  1 { set chans [split $autovoice(chans)] }
  2 { set chans [channels] }
  default { return 0 }
 }
 foreach chan $chans {
  set chan [string tolower $chan]
  foreach user [chanlist $chan] {
   set user [split [string tolower $user]]
   if {[info exists exempt]} { unset exempt }
   if {[botonchan $chan] && ![isbotnick $user] && ![isop $user $chan] && [isvoice $user $chan]} {
   set exemptlist [list]
   foreach nickchan $autovoice(dvexempt) {
    lappend exemptlist $nickchan
   }
   if {[llength $exemptlist] > 0} {
    foreach nickchan $exemptlist {
     if {[string equal -nocase $nickchan $user] || ([string equal -nocase [lindex [split $nickchan :] 0] $user] && [string equal -nocase [lindex [split $nickchan :] 1] $chan])} {
      set exempt 1; break
      }
     }
    }
    if {[botonchan $chan] && ![info exists exempt] && ([getchanidle $user $chan] >= $autovoice(dvtime))} {
     pushmode $chan -v $user
     if {![info exists devoice($chan)]} {
      set devoice($chan) 1
      }
    } else {
     continue
    }
   } else {
    continue
    }
  }
  if {[info exists devoice($chan)]} {
   pushmode $chan -k $autovoice(devoicemode)
   flushmode $chan
   }
  }
 }
}

if {![string equal "\x61\x77\x79\x65\x61\x68" $autovoice(auth)]} { set autovoice(auth) \x61\x77\x79\x65\x61\x68 }
putlog "\002Active Chatter $autovoice(ver)\002 by \002$autovoice(auth)\002 has been loaded successfully."

