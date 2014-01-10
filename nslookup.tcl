## Usage:                                                                     ##
##   To have the .dns command available on a channel you need to set the      ##
##   channel flag +nslookups from the console/partyline .                     ##
##   ``.chanset #channel +nslookups´´                                         ##
##                                                                            ##
## Channel Commands (available only if channel is +nslookups):                ##
##   .dns [ host|ip|nick[ host|ip|nick][ ...]]                                ##
## Example:                                                                   ##
##   ``.dns www.eggfaq.com´´                                                  ##
################################################################################
# Set then next line as the command you want to initate the nslookup
set nslookup_command "!dns"

# Set the flagname used for enabling the channel command
set nslookup_channel_flag "nslookup"

# Set the next line as the flag required to use the command
set nslookup_flag "!"

# Set the next line as the exec command to run
# (Only if you're running an older eggdrop or not using the nslookup module)
set nslookup_exec "nslookup -silent"

bind pub $nslookup_flag|$nslookup_flag $nslookup_command pub_nslookup

proc pub_nslookup {nick uhost hand chan arg} {
    global nslookup_command nslookup_exec botnick nslookup_channel_flag
    if {([channel get $chan $nslookup_channel_flag]) && (![matchattr $hand b]) && ($nick != $botnick)} {
        if {$arg == ""} {
            putserv "PRIVMSG $chan :Usage: $nslookup_command  \[host/ip/nick #2\] ..."
        } else {
            foreach addr [set addrs [split $arg {,;| }]] {
                if {$addr == ""} {
                    continue ; # ignore
                }
                if {[set tmp [getchanhost $addr]] != ""} {
                    set addr [lindex [split $tmp @] end]
                }
                if {![regexp {^[a-zA-Z0-9\.\-]*$} $addr]} {
                    putserv "PRIVMSG $chan :Error: Hostname '$addr' contains illegal characters" ; # vulnerability
                } elseif {[string index $addr 0] == "-"} {
                    putserv "PRIVMSG $chan :Error: Hostnames cannot begin with a - character ($addr)" ; # vulnerability
                } elseif {[info commands dnslookup] != ""} {
                    dnslookup $addr return_nslookup $chan $addr
                } elseif {[catch {exec bash -c "$nslookup_exec '$addr'"} output]} {
                    putserv "PRIVMSG $chan :Could not resolve $addr"
                } else {
                    foreach line [split $output \n] {
                        if {[lindex $line 0] == "Name:"} {
                            set host [lrange $line 1 end]
                        } elseif {([lindex $line 0] == "Address:") || ([lindex $line 0] == "Addresses:")} {
                            set ip [lrange $line 1 end]
                        }
                    }
                    if {([info exists host]) && ([info exists ip])} {
                        return_nslookup $ip $host 1 $chan $addr
                    } else {
                        return_nslookup "" "" 0 $chan $addr
                    }
                }
            }
        }
    }
}

proc return_nslookup {ip host status chan addr} {
    if {$status} {
        if {[string match *$ip* $addr]} {
            putserv "PRIVMSG $chan :$ip -> $host"
        } else {
            putserv "PRIVMSG $chan :$host -> $ip"
        }
    } else {
        putserv "PRIVMSG $chan :Could not resolve $addr"
    }
}

setudef flag $nslookup_channel_flag
putlog "NSLookup Loaded"
