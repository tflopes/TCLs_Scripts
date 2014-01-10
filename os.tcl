#a simple script to check the operation system and serverversion from webservices
#simple ".os domain.com"


bind pub o !os oscheck
proc oscheck {nick host handle chan text} {
	set server [lindex $text 0]
	set port 80
	set x 1
	set sock [socket $server $port]
	puts $sock "GET / HTTP/1.0"
	puts $sock "User.Agent:Mozilla"
	puts $sock "Host: $server"
	puts $sock ""
	flush $sock
	while {$x < 10} {
	gets $sock line
		if {[string match "*erver: *" $line]} {
			putserv "PRIVMSG $chan :$line"
		}
		if {[string match "*ate: *" $line]} {
			putserv "PRIVMSG $chan :$line"
		}
		incr x
	}
	close $sock
}

putlog "OS Domain Check Loaded"
