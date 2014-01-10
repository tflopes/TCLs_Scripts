### OP CMD by ArraY ###

### Public Bindings ###
bind pub o|o +b pub:proc_banBOT
bind pub o|o -b pub:proc_unbanBOT
bind pub o|o !lock pub:proc_lc
bind pub o|o !unlock pub:proc_uc
bind pub o|o !ban pub:proc_ban
bind pub o|o !unban pub:proc_unban
bind pub o|o !op pub:proc_op
bind pub o|o !deop pub:proc_deop
bind pub o|o !kick pub:proc_kick
bind pub o|o !voice pub:proc_voice
bind pub o|o !devoice pub:proc_devoice
bind pub m|m !adduser pub:proc_adduser
bind pub m|m !deluser pub:proc_deluser
bind pub o|m !addvoice pub:proc_addvoice
bind pub m|m !delvoice pub:proc_delvoice
bind pub o|o !topic pub:proc_topic
bind pub m|m !invite pub:proc_invite
bind pub o|o +m pub:proc_m
bind pub o|o -m pub:proc_unm
bind pub m|m +confirmednicks pub:proc_cnick
bind pub m|m -confirmednicks pub:proc_uncnick
bind pub m|m +adult pub:proc_anick
bind pub m|m -adult pub:proc_unanick
bind pub m|m +autovoice pub:proc_autovoice
bind pub m|m -autovoice pub:proc_unautovoice
bind pub m|m !identify pub:proc_identify
bind pub m|m +akick pub:proc_akick
bind pub m|m -akick pub:proc_unakick
bind pub m|m +invite pub:proc_invite
bind pub m|m +restricted pub:proc_restricted
bind pub m|m -restricted pub:proc_unrestricted
bind pub m|m -invite pub:proc_uninvite
bind pub m|m !founder pub:proc_founder
bind pub -|- !url pub:proc_site
bind pub m|m +v pub:proc_v


# Process Restricted Channel
proc pub:proc_restricted { nick uhost hand chan text } {
putserv "chanserv set $chan restricted on"
}

# Process UnRestricted Channel
proc pub:proc_unrestricted { nick uhost hand chan text } {
putserv "chanserv set $chan restricted off"
}


# Process UnInvite

proc pub:proc_uninvite { nick uhost hand chan args } {
  putquick "MODE $chan -i"
}

# Process Invite

proc pub:proc_invite { nick uhost hand chan args } {
  putquick "MODE $chan +i"
}

# Process ADD Akick
proc pub:proc_akick { nick uhost hand chan text } {
putserv "chanserv akick $chan add $text"
}

# Process Del Akick
proc pub:proc_unakick { nick uhost hand chan text } {
putserv "chanserv akick $chan del $text"
}

# Process Autoive Channel
proc pub:proc_autovoice { nick uhost hand chan text } {
putserv "chanserv levels $chan set autovoice -1"
}

# Process UnAutoive Channel
proc pub:proc_unautovoice { nick uhost hand chan text } {
putserv "chanserv levels $chan set autovoice 3"
}

# Process Founder Channel
proc pub:proc_founder { nick uhost hand chan text } {
putserv "chanserv set $chan founder $text"
}

# Process Identify Channel
proc pub:proc_identify { nick uhost hand chan text } {
putserv "chanserv identify $chan PASSWORD"
}

# Process UnAdult Nicks On Channel
proc pub:proc_unanick { nick uhost hand chan text } {
putserv "chanserv set $chan adult off"
}

# Process Adult Nicks On Channel
proc pub:proc_unanick { nick uhost hand chan text } {
putserv "chanserv set $chan adult on"
}

# Process UnConfirmed Nicks On Channel
proc pub:proc_uncnick { nick uhost hand chan text } {
putserv "chanserv set $chan confirmednicks off"
}

# Process Confirmed Nicks On Channel
proc pub:proc_cnick { nick uhost hand chan text } {
putserv "chanserv set $chan confirmednicks on"
}

# Process Moderated

proc pub:proc_m { nick uhost hand chan args } {
  putquick "MODE $chan +m"
}

# Process Unmoderated

proc pub:proc_unm { nick uhost hand chan args } {
  putquick "MODE $chan -m"
}

# Ban on Bot Process

proc pub:proc_banBOT {nick uhost hand chan text} {
  set host [lindex $text 0]
  set reason [lrange $text 1 end]
  set creator $nick
  if {$reason == ""} { set reason "*sHiTLiSTED*" }
  if {$host != ""} then {
    newchanban $chan $host $creator $reason
  }
}

# Unban on Bot Process

proc pub:proc_unbanBOT {nick uhost hand chan text} {
  set host [lindex $text 0]
  if {[isban $host $chan]} {
    killchanban $chan $host
  }
}

# Voice By Regular User Process

proc pub:proc_v { nick uhost hand chan text } {
  putquick "MODE $chan +v $nick"
}

# Process Site

proc pub:proc_site {nick uhost hand chan text} {
putserv "PRIVMSG $chan :Visita @ http://site"
}

# Process Invite

proc pub:proc_invite {nick uhost hand chan text} {
putserv "privmsg $text :Ganhaste um convite para o #Canal"
}


# Process topic 

proc pub:proc_topic {nick uhost hand chan text} {
putserv "TOPIC $chan :$text"
}

# Process ADD Voice
proc pub:proc_addvoice { nick uhost hand chan text } {
putserv "chanserv access $chan add $text 4"
}

# Process DELL Voice
proc pub:proc_delvoice { nick uhost hand chan text } {
putserv "chanserv access $chan add $text"
}

# Process ADD User
proc pub:proc_adduser { nick uhost hand chan text } {
putserv "chanserv access $chan add $text 5"
}

# Process DEL User
proc pub:proc_deluser { nick uhost hand chan text } {
putquick "chanserv access $chan del $text"
}

# Process lock

proc pub:proc_lc { nick uhost hand chan args } {
  putquick "MODE $chan +im"
}

# Process unlock

proc pub:proc_uc { nick uhost hand chan args } {
  putquick "MODE $chan -im"
}

# Op Process

proc pub:proc_op { nick uhost hand chan text } {
  putserv "MODE $chan +o $text"
}

# DeOp Process

proc pub:proc_deop { nick uhost hand chan text } {
  global botnick
  if {$text == $botnick} {
    putserv "NOTICE $nick :Not Allowed"
    return 0
  }
putserv "MODE $chan -o $text"
}

# Ban Process

proc pub:proc_ban { nick uhost hand chan text } {
  global botnick
  if {[onchan $text]} {
    if {$text == $botnick} { 
     putserv "NOTICE $nick :Ban Not Allowed"
     return 0 }
    set banmask [getchanhost $text $chan]
    putquick "MODE $chan +b $banmask"
    putquick "kick $chan $text :$nick :Utilizador banido do Canal"
  } else { putserv "NOTICE $nick :Invalid Nick" }
}

# Unban Process

proc pub:proc_unban { nick uhost hand chan text } {
  if {[ischanban $text $chan]} {
    pushmode $chan -b $text
  } else { putserv "NOTICE $nick :Ban List Invalid" }
}

# Process Kick

proc pub:proc_kick {nick uhost hand chan text} {
  global botnick
  set whom [lindex $text 0]
  if {$text == $botnick} { 
     putserv "NOTICE $nick :Kick Not Allowed"
     return 0 }
  if {[onchan $whom $chan] != 1} {return 0}
  set reason [lrange $text 1 end]
  if {$reason == ""} { set reason "Porta-te Bem!" }
  if {$whom != ""} then {
    puthelp "KICK $chan $whom :$reason"
  }
}


# Voice Process

proc pub:proc_voice { nick uhost hand chan text } {
  putquick "MODE $chan +v $text"
}

# Devoice Process

proc pub:proc_devoice { nick uhost hand chan text } {
  putquick "MODE $chan -v $text"
}

#  Down According To Flags In This Order
#  Basic - People No Op/Master Flags
#  Have To Edit The Flags In Both This Process And The Above Process If You 
#  Use A Different Flag.
#  Master - People Who Have Master Flag. Again I Used Default m Flag.

putlog "Op Channel Commands Loaded"


