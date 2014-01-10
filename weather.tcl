## SETTINGS SCRIPT 
##################################################################################################################

## Weather trigger 
## Too see everything; current weather + forecast conditions

set weather_trigger_all "!weather"

## Current weather trigger
## Too only see the current weatherconditions

set weather_trigger_current "!conditions"

## Forecast weather trigger
## Too only see the forecast conditions

set weather_trigger_forecast "!forecast"

## the type of messaging the bot uses when trigger is used.
## choices 	: channel / user
## channel 	: bot will post the information in the channel where the trigger is used
## user	: bot will make a private message too the user who used the trigger

set weather_message "user"

## Trigger flags
## Which users may use the trigger ?
## channeluser|globaluser 
## n = owner
## m = master
## f = friend (known user)
## o = operator
## v = voice
## - = everybody
## Example 	: mnfo|mnfo 
## Standard : -|-

set weather_flags "-|-"

##################################################################################################################
## Beginning of the script					 
## Dont change anything below here, unless you know something about TCL/Eggdrop commands and scripting           
###################################################################################################################

bind PUB $weather_flags $weather_trigger_all user:weather
bind PUB $weather_flags $weather_trigger_current user:current
bind PUB $weather_flags $weather_trigger_forecast user:forecast
bind EVNT * init-server make:weatherfile

if {[catch { package require eggdrop 1.6 } err]} {
 	die "\002Weather script\002 - This script needs eggdrop version 1.6 too work proberly. Error : $err"
}


if {[catch { package require Tcl 8.3 } err]} {
	die "\002Weather script\002 - This script needs TCL version 8.3 (minimum) too work proberly. Error : $err"
}

set httpfound 0
if {[catch { package require http } err]} {
  putlog "\002Weather script\002 - This script needs \002http\002 package too work proberly. Error : $err"
} else { 
set httpfound 1
}

if {[string match -nocase $weather_message "channel"]} {
	set weather_message_type "1"
} elseif {[string match -nocase $weather_message "user"]} {
	set weather_message_type "2"
} else {
	set weather_message_type "1"
}


set weatherfile "scripts/weatherfile.db"

proc make:weatherfile {event} {
global weatherfile 
	if {![file exists $weatherfile]} {
		putlog "\002Weather script\002 - Creating weather database $weatherfile"
		set file [open $weatherfile "w"]
		close $file
	}
}

set weatherflood 0

proc user:weather {nickname host handle channel text} {
global weatherfile weatherflood httpfound 
set city ""; set degrees ""; set humidity ""; set windspeed ""; set weather ""; set time "" ; set forecast ""; set mintemp ""; set maxtemp ""
	if {$httpfound != 1} {return}
	if {[llength $text] == 0 } {putserv "NOTICE $nickname : Please fill in a city, example : .weather Amsterdam"; return}
	if {$weatherflood > 0 } {
		if {($weatherflood + 60) > [expr [clock seconds]]} {putserv "NOTICE $nickname : Weather search just has been used, please wait for [expr ([expr ($weatherflood + 60)] - [clock seconds])] seconds"; return}
	}
	set weatherflood [clock seconds] 
	set area [string map {"" "+"} $text]; set webstring "http://www.google.com/ig/api?weather=$area"
	catch {exec wget -O $weatherfile $webstring} err
	set fp [open $weatherfile r]; set data [read $fp]; close $fp
	regexp {city data=\"(.*?)\"/>} $data -> city; regexp {temp_c data=\"(.*?)\"/>} $data -> degrees
	regexp {humidity data=\"(.*?)\"/>} $data -> humidity; regexp {wind_condition data=\"(.*?)\"/>} $data -> windspeed
	regexp {condition data=\"(.*?)\"/>} $data -> weather; regexp {current_date_time data=\"(.*?)\"/>} $data -> time
	regexp {low data=\"(.*?)\"/>} $data -> mintemp; regexp {high data=\"(.*?)\"/>} $data -> maxtemp
	if {$city != ""} {		
		set direction [lindex $windspeed 1];  set winddirection [user:convert:wind $direction] 
		set speed [lindex $windspeed 3];  set windspeed [expr {$speed / round(0.621371192237)}] 
		set msgtext "Weather conditions for : $city «-» Current temperature : $degrees °C «-» Max/Min temperature : [F:C:conversion $maxtemp]/[F:C:conversion $mintemp] °C «-» Windspeed : direction $winddirection with a speed off $windspeed km/h «-» $humidity «-» Weather condition : \002$weather\002 «-» Time measured : [lindex $time 0] - [lindex $time 1]"
		user:message $channel $nickname $msgtext
		set newdata [string map {" " "+"} $data]
		set newdata [string map {"<forecast_conditions>" " <forecast_conditions>"} $newdata]; set newdata [string map {"</forecast_conditions>" "</forecast_conditions> "} $newdata]
		set fp [open $weatherfile w]; puts $fp $newdata; close $fp; set fp [open $weatherfile r]; set data [read $fp]; close $fp; set counter 0
		foreach list $data {
			if {($counter >= 2) && ($counter < 5)} {
				set day ""; set mintemp ""; set maxtemp ""; set condition ""
				set listdata [lindex $data $counter]; set listdata [string map {"+" " "} $listdata]
				regexp {day_of_week data=\"(.*?)\"/>} $listdata -> day; regexp {low data=\"(.*?)\"/>} $listdata -> mintemp
				regexp {high data=\"(.*?)\"/>} $listdata -> maxtemp; regexp {condition data=\"(.*?)\"/>} $listdata -> condition; set cvday [user:convert:day $day]
				set msgtext "Forecast conditions for : \002$cvday\002 «-» Max temperature : [F:C:conversion $maxtemp] °C «-» Min temperature : [F:C:conversion $mintemp] °C «-» Weather condition : \002$condition\002"
				user:message $channel $nickname $msgtext
				incr counter 
			} else {
			incr counter
			}
		}	
	} else {
		set msgtext "Weather conditions arent available for \002$area\002. Make sure you spell the name right"
		$channel $nickname $msgtext
	} 
}

proc user:current {nickname host handle channel text} {
global weatherfile weatherflood httpfound 
set city ""; set degrees ""; set humidity ""; set windspeed ""; set weather ""; set time "" ; set forecast ""; set mintemp ""; set maxtemp ""
	if {$httpfound != 1} {return}
	if {[llength $text] == 0 } {putserv "NOTICE $nickname : Please fill in a city, example : .weather Amsterdam"; return}
	if {$weatherflood > 0 } {
		if {($weatherflood + 60) > [expr [clock seconds]]} {putserv "NOTICE $nickname : Weather search just has been used, please wait for [expr ([expr ($weatherflood + 60)] - [clock seconds])] seconds"; return}
	}
	set weatherflood [clock seconds] 
	set area [string map {"" "+"} $text]; set webstring "http://www.google.com/ig/api?weather=$area"
	catch {exec wget -O $weatherfile $webstring} err
	set fp [open $weatherfile r]; set data [read $fp]; close $fp
	regexp {city data=\"(.*?)\"/>} $data -> city; regexp {temp_c data=\"(.*?)\"/>} $data -> degrees
	regexp {humidity data=\"(.*?)\"/>} $data -> humidity; regexp {wind_condition data=\"(.*?)\"/>} $data -> windspeed
	regexp {condition data=\"(.*?)\"/>} $data -> weather; regexp {current_date_time data=\"(.*?)\"/>} $data -> time
	regexp {low data=\"(.*?)\"/>} $data -> mintemp; regexp {high data=\"(.*?)\"/>} $data -> maxtemp
	if {$city != ""} {		
		set direction [lindex $windspeed 1];  set winddirection [user:convert:wind $direction] 
		set speed [lindex $windspeed 3];  set windspeed [expr {$speed / round(0.621371192237)}] 
		set msgtext "Weather conditions for : $city «-» Current temperature : $degrees °C «-» Max/Min temperature : [F:C:conversion $maxtemp]/[F:C:conversion $mintemp] °C «-» Windspeed : direction $winddirection with a speed off $windspeed km/h «-» $humidity «-» Weather condition : \002$weather\002 «-» Time measured : [lindex $time 0] - [lindex $time 1]"
		user:message $channel $nickname $msgtext	
	} else {
		set msgtext "Weather conditions arent available for \002$area\002. Make sure you spell the name right"
		user:message $channel $nickname $msgtext
	} 
}

proc user:forecast {nickname host handle channel text} {
global weatherfile weatherflood httpfound 
set city ""; set degrees ""; set humidity ""; set windspeed ""; set weather ""; set time "" ; set forecast ""; set mintemp ""; set maxtemp ""
	if {$httpfound != 1} {return}
	if {[llength $text] == 0 } {putserv "NOTICE $nickname : Please fill in a city, example : .weather Amsterdam"; return}
	if {$weatherflood > 0 } {
		if {($weatherflood + 60) > [expr [clock seconds]]} {putserv "NOTICE $nickname : Weather search just has been used, please wait for [expr ([expr ($weatherflood + 60)] - [clock seconds])] seconds"; return}
	}
	set weatherflood [clock seconds] 
	set area [string map {"" "+"} $text]; set webstring "http://www.google.com/ig/api?weather=$area"
	catch {exec wget -O $weatherfile $webstring} err
	set fp [open $weatherfile r]; set data [read $fp]; close $fp
	regexp {city data=\"(.*?)\"/>} $data -> city
	if {$city != ""} {		
		set newdata [string map {" " "+"} $data]
		set newdata [string map {"<forecast_conditions>" " <forecast_conditions>"} $newdata]; set newdata [string map {"</forecast_conditions>" "</forecast_conditions> "} $newdata]
		set fp [open $weatherfile w]; puts $fp $newdata; close $fp; set fp [open $weatherfile r]; set data [read $fp]; close $fp; set counter 0
		set msgtext "Conditions for \002$city\002"
		user:message $channel $nickname $msgtext
		foreach list $data {
			if {($counter >= 2) && ($counter < 5)} {
				set day ""; set mintemp ""; set maxtemp ""; set condition ""
				set listdata [lindex $data $counter]; set listdata [string map {"+" " "} $listdata]
				regexp {day_of_week data=\"(.*?)\"/>} $listdata -> day; regexp {low data=\"(.*?)\"/>} $listdata -> mintemp
				regexp {high data=\"(.*?)\"/>} $listdata -> maxtemp; regexp {condition data=\"(.*?)\"/>} $listdata -> condition; set cvday [user:convert:day $day]
				set msgtext "Forecast conditions for : \002$cvday\002 «-» Max temperature : [F:C:conversion $maxtemp] °C «-» Min temperature : [F:C:conversion $mintemp] °C «-» Weather condition : \002$condition\002"
				user:message $channel $nickname $msgtext
				incr counter 
			} else {
			incr counter
			}
		}	
	} else {
		set msgtext "Weather conditions arent available for \002$area\002. Make sure you spell the name right"
		user:message $channel $nickname $msgtext
	} 
}

proc F:C:conversion {amount} { 
set result [expr {[expr {$amount - 32}] / 1.8}]
set result [expr round($result)]
return $result
}

## converting winddirection

proc user:convert:wind {wind} {
	switch $wind {
		N {
		return "North"
		}
		NW {
		return "Northwest"
		}
		NO {
		return "Northeast"
		}	
		W {
		return "West"
		}
		O {
		return "East"
		}	
		S {
		return "South"
		}
		SW {
		return "Southwest"
		}
		SO {
		return "Southeast"
		}
	}
}

## converting day

proc user:convert:day { x } {
	switch $x {
		Mon {
		return "Monday"
		}
		Tue {
		return "Tuesday"
		}
		Wed {
		return "Wednesday"
		}	
		Thu {
		return "Thursday"
		}
		Fri {
		return "Friday"
		}	
		Sat {
		return "Saterday"
		}
		Sun {
		return "Sunday"
		}
	}
}

proc user:message {channel nickname text} {
global weather_message_type
	if {$weather_message_type == 1} {
		puthelp "PRIVMSG $channel : $text"
	} elseif {$weather_message_type == 2} {
		puthelp "PRIVMSG $nickname : $text"
	} else {
 		puthelp "PRIVMSG $channel : $text"
	}
}
 


putlog "Weatherscript loaded"
