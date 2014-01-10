#**********#
# SETTINGS #
#**********#

# the onjoin flood settings.
set flood-join 3:50

# what channels the onjoin greet shall work on.
set onjoinchan ""

# want the greet to come out in notice (0) or privmsg (1)?
set howtell 0

#************************#
# DO NOT EDIT UNDERNEATH #
#************************#

bind join - * holm-join_greet
proc holm-join_greet {nick uhost hand channel args} {
global onjoinchan greet howtell
        if {(([lsearch -exact [string tolower $onjoinchan] [string tolower $channel]] != -1) || ($onjoinchan == "*"))} {
		if {$howtell} {
			putserv "privmsg $channel : Ola $nick, Bem Vindo ao $channel ! Visita o nosso site em http://irc-palmela.pt.vu, have fun :)"
		} else {
			putserv "notice $nick : Ola $nick, Bem Vindo ao $channel ! Visita o nosso site em http://irc-palmela.pt.vu, have fun :)"
		}
	}
}

putlog "Greeting Loaded"
