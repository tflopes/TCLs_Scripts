Enter file contents herepackage require http 2.4
bind pubm - * mu
proc mu {nick uhost hand chan text} {
    set web(page) http://www.youtube.com/
    set watch [regexp -nocase -- {\/watch\?v\=([^\s]{11})} $text youtubeid]
    set logoo "\002\00301,00You\00300,04Tube\002\017"
 
    if {$watch && $youtubeid != ""} {
        set agent "Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1"     
        set t [::http::config -useragent $agent]
        set t [::http::geturl "$web(page)$youtubeid" -timeout 30000]
        set data [::http::data $t]
        ::http::cleanup $t
 
        set l [regexp -all -inline -- {<meta name="title" content="(.*?)">.*?<span class="watch-view-count">.*?<strong>(.*?)</strong>} $data]
 
        regexp {"length_seconds": (\d+),} $data "" length
 
        foreach {black a b c d e} $l {
 
            set a [string map -nocase {\&\#39; \x27 &amp; \x26 &quot; \x22} $a]
            set b [string map [list \n ""] $b]
            set c [string map [list \n ""] $c]
            set d [string map [list \n ""] $d]
            set e [string map -nocase {\&\#39; \x27 &amp; \x26 &quot; \x22} $e]
 
            regsub -all {<.*?>} $a {} a
            regsub -all {<.*?>} $b {} b
            regsub -all {<.*?>} $c {} c
            regsub -all {<.*?>} $d {} d
            regsub -all {<.*?>} $e {} e            
 
            putserv "PRIVMSG $chan :0,4YouTube $a"
 
                proc duration {s} {
                variable etube
                set hours [expr {$s / 3600}]
                set minutes [expr {($s / 60) % 60}]
                set seconds [expr {$s % 60}]
                set res ""
 
                if {$hours != 0} {append res "$hours hours"}                
                if {$minutes != 0} {append res " $minutes minutes"}
                if {$seconds != 0} {append res " $seconds seconds"}
                return $res
            }    
        }
    }
}
 
putlog "youtitle.tcl loaded..."
