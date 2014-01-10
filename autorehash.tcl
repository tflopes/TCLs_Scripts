################################################################# 
## This script automatically rehashes the bot every X minutes. ## 
################################################################# 
 
########################################################## 
## Just load the script, edit the settings, and rehash. ## 
########################################################## 
 
#################################################### 
# Set the number of minutes between rehashes here. # 
#################################################### 
 
set timerehash_setting(timer) "30" 
 
#################### 
# Code begins here # 
#################### 
 
if {![string match 1.6.* $version]} { putlog "\002TIMEREHASH:\002 \002WARNING:\002 This script is intended to run on eggdrop 1.6.x or later." } 
if {[info tclversion] < 8.2} { putlog "\002TIMEREHASH:\002 \002WARNING:\002 This script is intended to run on Tcl Version 8.2 or later." } 
 
if {$timerehash_setting(timer) > 0 && [lsearch -glob [timers] "* timerehash_rehash *"] == -1} { timer $timerehash_setting(timer) timerehash_rehash } 
 
proc timerehash_rehash {} { 
   global timerehash_setting 
   rehash 
   rehash 
   if {[lsearch -glob [timers] "* timerehash_rehash *"] == -1} { timer $timerehash_setting(timer) timerehash_rehash } 
} 
 
putlog "Auto Rehash TCL Loaded"

