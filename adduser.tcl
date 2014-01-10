####################### Breve explicao sobre o funcionamento desta TCL ##########################
#+flag <nick> <flag> --> Adiciona a flag que pretenderes ao user q pertenderes                    #
#-flag <nick> <flag> --> Remove a flag que pretenderes ao user q pertenderes                      #
#!adduser <nick> --> Adiciona um user com uma flag pre-determinada  lista de accesso do eggdrop  #
#!deluser <nick> --> Elimina o user da lista de accesso do eggdrop                                #
#!add-voice <nick> --> adiciona um user q ter voice automatico pelo eggdrop                      #
#!del-voice <nick> --> Retira um user do voice automtico                                         #
#!add-op <nick> --> Adiciona um user com op automatico pelo eggdrop                               #
#!del-op <nick> --> Remove um user da lista de auto op pelo eggdrop                               #
#!add-version --> Diz no canal qual  a versao desta tcl, para confirmares se  a mais recente    #
#!add-check -->  Confirma se tens acesso ou nao  adduser                                         #
#!add-help --> O eggdrop envia uma msg para pvt com os comandos e breve explicao como os usar   #
#!host <nick_com_handle> <nick_sem_handle> --> D acesso ao egg a nicks maiores que o handle      #
###################################################################################################

###################################################################################################
#.chanset #canal aop-delay 0:0 <-- Para o bot dar auto-op e auto voice                            #
#assim k o user entra no canal e nao 30segundos depois                                            #
###################################################################################################

########################################## Novidades ##############################################
# 1.5v                                                                                            #
#voltei  flag "o" como padro devido a muitas duvidas que surgiram por causa disso               #
#Os comandos podem ser efectuados em PVT                                                          #
#NOVO COMANDO: !host nick_com_handlen NICk_completo                                               #
#o add  substituido por + e o del por -, isto toda a tcl mto mais pratica de se usar             #
# O codico foi optimizado                                                                         #
#  1.25v                                                                                          #
# Problema na atribuio de flags corrigido, novo sistema de confirmaes de flags                #
# Novo comando !add-version k diz no canal a verso desta tcl                                     #
# Novo comando !add-help que  o menu de ajuda                                                    #
# Novo comando !add-check que confirma se o user tem ou nao accesso ao comando                    #
# Para usar esta TCL  necesria a Flag L, .chattr Nick +L                                        #
###################################################################################################



############ CONFIGURAES #####################################

# Flag para ter accesso aos comandos !addflag !add-op !add-op !add-voice (..)
set add_nivel "m"

# Flag que o !adduser vai dar, meta aki a flag q o seu bot normalmente pede  ( kando pede ) para ter acesso aos seus comandos, normalmente  a flag o
set normal_flags "o"


############### FIM DE CONFIGURAES ######### no alterar nada daki para baixo excepto se souberes ou k ts a fazer ##############



bind pub $add_nivel !add-flag pub:addflag 
bind pub $add_nivel !del-flag pub:delflag
bind pub $add_nivel !add-user pub:adduser   
bind pub $add_nivel !del-user pub:deluser   
bind pub $add_nivel !add-voice pub:add-voice
bind pub $add_nivel !del-voice pub:del-voice
bind pub $add_nivel !add-op pub:add-op
bind pub $add_nivel !del-op pub:del-op
bind pub - !add-version pub:add-version
bind pub - !add-help pub:add-help
bind pub - !add-info pub:add-help
bind pub - !add-check pub:add-check    
bind pub $add_nivel !host pub:host
bind msg $add_nivel !add-flag msg:addflag
bind msg $add_nivel !del-flag msg:delflag
bind msg $add_nivel !add-user msg:adduser
bind msg $add_nivel !del-user msg:deluser
bind msg $add_nivel !add-voice msg:add-voice
bind msg $add_nivel !del-voice msg:del-voice
bind msg $add_nivel !add-op msg:add-op
bind msg $add_nivel !del-op msg:del-op
bind msg $add_nivel !host msg:host
bind msg - !add-version msg:add-version
bind msg - !add-help msg:addhelp
bind msg - !add-info msg:addhelp
bind msg - !add-check msg:add-check



proc pub:host {nick host hand chan text} {
    set addnick [lindex $text 0] 
    set addhost [lindex $text 1]
    set resto [lrange $text 2 end]
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !host <nick_com_handle> <nick_completo> APENAS E S"
        return 0} 
	if {![validuser $addnick]} {
	putserv "notice $nick : ERRO: nick ( $addnick ) nao encontado." 
	return 0} 
    addhost $addnick $addhost!*@*
    putserv "notice $nick :Acabas-te de adicionar ao $addnick o acesso com o nick $addhost!"
return 0}



proc msg:host {nick uhost hand text} {
    set addnick [lindex $text 0] 
    set addhost [lindex $text 1]
    set resto [lrange $text 2 end]
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !host <nick_com_handle> <nick_completo> APENAS E S"
        return 0}
	if {![validuser $addnick]} {
	putserv "notice $nick : ERRO: nick ( $addnick ) nao encontado." 
	 return 0} else {
    addhost $addnick $addhost!*@*
    putserv "notice $nick :Acabas-te de adicionar ao $addnick o acesso com o nick $addhost!"
}
}







proc pub:add-help {nick uhost hand chan text} {
    global add_nivel  
    if { ![matchattr $hand $add_nivel $chan] } {
        putserv "Notice $nick : Very funny, nem acesso  tcl tens kanto mais ao menu de ajuda"
    } else {
        putserv "PRIVMSG $nick : .:. $nick .:. .:. Adduser private help .:."
        putserv "PRIVMSG $nick :!add-flag <nick> <flag> --> Adiciona a flag que pretenderes ao user q pertenderes"
        putserv "PRIVMSG $nick :!del-flag <nick> <flag> --> Remove a flag que pretenderes ao user q pertenderes"
        putserv "PRIVMSG $nick :!add-user <nick> --> Adiciona um user com uma flag pre-determinada  lista de accesso do eggdrop"
        putserv "PRIVMSG $nick :!del-user <nick> --> Elimina o user da lista de accesso do eggdrop"
        putserv "PRIVMSG $nick :!add-voice <nick> --> adiciona um user q ter voice automatico pelo eggdrop"
        putserv "PRIVMSG $nick :!del-voice <nick> --> Retira um user do voice automtico"
        putserv "PRIVMSG $nick :!add-op <nick> --> Adiciona um user com op automatico pelo eggdrop"
        putserv "PRIVMSG $nick :!del-op <nick> --> Remove um user da lista de auto op pelo eggdrop "
        putserv "PRIVMSG $nick :!add-version --> Diz no canal qual  a versao desta tcl, para confirmares se  a mais recente"
        putserv "PRIVMSG $nick :!add-check -->  Confirma se tens acesso ou nao  adduser ( se ests a ler isto  porque tns acesso )"
        putserv "PRIVMSG $nick :!host <nick_com_handlen> <nick_completo>  --> caso o nick seja maior que o handlen d acesso ao nick na lista de acesso do egg"
        putserv "PRIVMSG $nick : .:. FIM .:."
        return 0}
}



proc msg:addhelp {nick uhost hand args} {
    global add_nivel
    if { ![matchattr $nick $add_nivel] } {
        putserv "Notice $nick : Very funny, nem acesso ao add tens kanto mais ao menu de ajuda"
    } else {
       putserv "PRIVMSG $nick : .:. $nick .:. .:. Adduser private help .:."
        putserv "PRIVMSG $nick :!add-flag <nick> <flag> --> Adiciona a flag que pretenderes ao user q pertenderes"
        putserv "PRIVMSG $nick :!del-flag <nick> <flag> --> Remove a flag que pretenderes ao user q pertenderes"
        putserv "PRIVMSG $nick :!add-user <nick> --> Adiciona um user com uma flag pre-determinada  lista de accesso do eggdrop"
        putserv "PRIVMSG $nick :!del-user <nick> --> Elimina o user da lista de accesso do eggdrop"
        putserv "PRIVMSG $nick :!add-voice <nick> --> adiciona um user q ter voice automatico pelo eggdrop"
        putserv "PRIVMSG $nick :!del-voice <nick> --> Retira um user do voice automtico"
        putserv "PRIVMSG $nick :!add-op <nick> --> Adiciona um user com op automatico pelo eggdrop"
        putserv "PRIVMSG $nick :!del-op <nick> --> Remove um user da lista de auto op pelo eggdrop "
        putserv "PRIVMSG $nick :!add-version --> Diz no canal qual  a versao desta tcl, para confirmares se  a mais recente"
        putserv "PRIVMSG $nick :!add-check -->  Confirma se tens acesso ou nao  adduser ( se ests a ler isto  porque tns acesso )"
        putserv "PRIVMSG $nick :!host <nick_com_handlen> <nick_completo>  --> caso o nick seja maior que o handlen d acesso ao nick na lista de acesso do egg"
        putserv "PRIVMSG $nick : .:. FIM .:."
        return 0}
}


                
proc pub:adduser {nick host hand chan text} {
    global normal_flags
    set addnick [lindex $text 0] 
    set resto [lrange $text 1 end]  
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !add-user <nick> | Duvidas? faz !add-help"
        return 0}
    if { [matchattr $addnick $normal_flags $chan] } {
        putserv "Notice $nick : Nick ja se encontra na minha base de dados "
        return 0}
    adduser $addnick $addnick!*@*
    chattr $addnick $normal_flags
    putserv "notice $nick :Acabas-te de adicionar $addnick na minha lista de acesso! para o remover !del-user $addnick"
}


                
proc msg:adduser {nick uhost hand text} {
    global normal_flags
    set addnick [lindex $text 0] 
    set resto [lrange $text 1 end]
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !add-user <nick> | Duvidas? faz !add-help"
        return 0}
    if { [matchattr $addnick $normal_flags] } {
        putserv "Notice $nick : Nick j se encontra na minha base de dados"
        return 0}
    adduser $addnick $addnick!*@*
    chattr $addnick $normal_flags
    putserv "notice $nick :Acabas-te de adicionar $addnick com accesso $normal_flags! para o remover !del-user $addnick"
}



proc pub:deluser {nick host hand chan text} {
    set addnick [lindex $text 0] 
    set resto [lrange $text 1 end]
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !del-user <nick>"
        return 0}
	if {![validuser $addnick]} {
        putserv "Notice $nick : ERRO: Esse nick ( $addnick ) nao se encontra na minha base de dados"
        return 0}
    deluser $addnick
    putserv "notice $nick :Retiras-te $addnick da minha lista de user's"
}




proc msg:deluser {nick host hand  text} {
    set addnick [lindex $text 0] 
    set user_flag "h"
    set resto [lrange $text 1 end]
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !del-user <nick>"
        return 0}
	if {![validuser $addnick]} {
        putserv "Notice $nick : ERRO: Esse nick ( $addnick ) nao se encontra na minha base de dados"
        return 0}
    deluser $addnick
    putserv "notice $nick :Retiras-te $addnick da minha lista de user's"
}



proc pub:add-voice {nick host hand chan text} {
    set addnick [lindex $text 0] 
    set flag_voice "gv"
    set resto [lrange $text 1 end]
    if { [matchattr $addnick $flag_voice $chan] } {
        putserv "Notice $nick :ERRO: Nick j se encontra na minha lista de auto voice"
        return 0}
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !add-voice <nick>"
        return 0}
    adduser $addnick $addnick!*@*
    chattr $addnick $flag_voice $chan
    putserv "notice $nick :Acabas-te de adicionar $addnick como auto voice, para o remover faz !del-voice $addnick"
}



proc msg:add-voice {nick host hand text} {
    set addnick [lindex $text 0] 
    set flag_voice "gv"
    set resto [lrange $text 1 end]
    if { [matchattr $addnick $flag_voice] } {
        putserv "Notice $nick : Nick j se encontra na minha lista de auto voice"
        return 0}
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !add-voice <nick>"
        return 0}
    adduser $addnick $addnick!*@*
    chattr $addnick $flag_voice
    putserv "notice $nick :Acabas-te de adicionar $addnick como auto voice, para o remover faz !del-voice $addnick"
}




proc pub:del-voice {nick host hand chan text} {
    set addnick [lindex $text 0] 
    set flag_voice "gv"
    set resto [lrange $text 1 end]
    if { ![matchattr $addnick $flag_voice $chan] } {
        putserv "notice $nick :Esse nick ( $addnick ) no est na minha lista de auto-voice "
        return 0}
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta:!del-voice <nick> | Duvidas? faz !add-help"
        return 0}
    chattr $addnick -$flag_voice $chan
    putserv "notice $nick :Retiras-te $addnick da lista de auto-voice do bot"
}


proc msg:del-voice {nick host hand text} {
    set addnick [lindex $text 0] 
    set flag_voice "gv"
    set resto [lrange $text 1 end]
    if { ![matchattr $addnick $flag_voice ] } {
        putserv "notice $nick :Esse nick ( $addnick ) no est na minha lista de auto-voice "
        return 0}
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !del-voice <nick> | Duvidas? faz !add-help"
        return 0}
    chattr $addnick -$flag_voice
    putserv "notice $nick :Retiras-te $addnick da lista de auto-voice do bot"
}



proc pub:add-op {nick host hand chan text} {
    set flag_op "ao"
    set addnick [lindex $text 0] 
    set resto [lrange $text 1 end]
    if { [matchattr $addnick $flag_op $chan] } {
        putserv "notice $nick :ERRO:Esse nick ( $addnick ) j se encontra na minha lista de auto op"
        return 0}
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !add-op <nick> | Duvidas? faz !add-help"
        return 0}
    adduser $addnick $addnick!*@*
    chattr $addnick $flag_op $chan
    putserv "notice $nick :Acabas-te de adicionar $addnick com auto op ! para o remover !del-op $addnick"
}


proc msg:add-op {nick uhost hand text} {
    set flag_op "ao"
    set addnick [lindex $text 0] 
    set resto [lrange $text 2 end]
    if { [matchattr $addnick $flag_op] } {
        putserv "notice $nick :ERRO:Esse nick ( $addnick ) j se encontra na minha lista de auto op"
        return 0}
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !add-op <nick>"
        return 0}
    adduser $addnick $addnick!*@*
    chattr $addnick $flag_op
    putserv "notice $nick :Acabas-te de adicionar $addnick com auto op ! para o remover !del-op $addnick"
}




proc pub:del-op {nick host hand chan text} {
    set addnick [lindex $text 0] 
    set resto [lrange $text 1 end]
    set flag_op "ao"
    if { ![matchattr $addnick $flag_op] } {
        putserv "notice $nick : ERRO: Esse nick ( $addnick ) no se encontra na minha lista de auto op"
        return 0}
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !del-op <nick>"
        return 0}
    chattr $addnick -$flag_op $chan
    putserv "notice $nick :Retiras-te $addnick da lista de auto-ops do bot"
}


proc msg:del-op {nick uhost hand text} {
    set addnick [lindex $text 0] 
    set resto [lrange $text 1 end]
    set flag_op "ao"
    if { ![matchattr $addnick $flag_op] } {
        putserv "notice $nick : ERRO: Esse nick ( $addnick ) no se encontra na minha lista de auto op"
        return 0}
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: del-op <nick>"
        return 0}
    chattr $addnick -$flag_op
    putserv "notice $nick :Retiras-te $addnick da lista de auto-ops do bot"
}



proc msg:addflag {nick uhost hand text} {
    set addnick [lindex $text 0] 
    set bandeiras [lindex $text 1]
    set resto [lrange $text 2 end]
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !add-flag <nick> <flag> APENAS E S"
        return 0}
	if { [matchattr $addnick $bandeiras] } {
        putserv "notice $nick :ERRO: O nick $addnick ja possui algumas ( ou todas ) a(s) flag(s)   $bandeiras"
	return 0}
    adduser $addnick $addnick!*@*
    chattr $addnick $bandeiras
    putserv "notice $nick :Acabas-te de adicionar ao $addnick as flags $bandeiras ! para o remover !del-flag $addnick $bandeiras"
}



proc pub:delflag {nick host hand chan text} {
    set addnick [lindex $text 0] 
    set flags [lindex $text 1]
    set resto [lrange $text 2 end]
    if {$addnick == "" || $resto != ""} { 
        	putserv "Notice $nick :Sintexe correcta: !del-flag <nick> <flag> APENAS E S"
        	return 0} 
	if { ![matchattr $addnick $flags $chan] } {
        	putserv "notice $nick :ERRO: O nick $addnick no possui a(s) flag(s) $flags"
		return 0}
    chattr $addnick -$flags
    putserv "notice $nick :Acabas-te de remover do $addnick as flags $flags !"
}


proc pub:addflag {nick host hand chan text} {
    set addnick [lindex $text 0] 
    set bandeiras [lindex $text 1]
    set resto [lrange $text 2 end]
    if {$addnick == "" || $resto != ""} { 
        putserv "Notice $nick :Sintexe correcta: !add-flag <nick> <flag> APENAS E S"
        return 0}
	if { [matchattr $addnick $bandeiras $chan] } {
        putserv "notice $nick :ERRO: O nick $addnick j possui a(s) flag(s)  $bandeiras"
	return 0}
    adduser $addnick $addnick!*@*
    chattr $addnick $bandeiras
    putserv "notice $nick :Acabas-te de adicionar ao $addnick as flags $bandeiras ! para o remover !del-flag $addnick $bandeiras"
}



proc msg:delflag {nick uhost hand text} {
    set addnick [lindex $text 0] 
    set flags [lindex $text 1]
    set resto [lrange $text 2 end]
    if {$addnick == "" || $resto != ""} { 
        	putserv "Notice $nick :Sintexe correcta: !del-flag <nick> <flag> APENAS E S"
        	return 0} 
	if { ![matchattr $addnick $flags] } {
        	putserv "notice $nick :ERRO: O nick $addnick no possui  a(s) flag(s) $flags"
		return 0}
    chattr $addnick -$flags
    putserv "notice $nick :Acabas-te de remover do $addnick as flags $flags !"
}




proc pub:add-version {nick uhost hand chan text} {
    global add_version 
    puthelp "PRIVMSG $chan : $add_version "
}

proc msg:add-version {nick uhost hand text} {
    global add_version 
    puthelp "PRIVMSG $nick : $add_version "
}




proc pub:add-check  {nick uhost hand chan text} {
    global add_nivel
    if { [matchattr $hand $add_nivel] } {
        putserv "notice $nick : Tns acesso aos comandos da adduser.tcl, para info faz !add-help"
    } else {
        putserv "notice $nick :No tns acesso aos comandos da adduser.tcl, caso se trate de um erro contacte o egg-master"
    }
}




proc msg:add-check  {nick uhost hand args} {
    global add_nivel
    if { [matchattr $hand $add_nivel] } {
        putserv "notice $nick : Tens acesso aos comandos da adduser.tcl. para saberes os comandos faz !add-help"
    } else {
        putserv "notice $nick : Nao tens acesso aos comandos da adduser.tcl, caso se trate de um erro contacte o egg-master"
    }
}









# Verso da tcl
set add_version "Adduser versao 2.0 finalizada em 4 de Agosto de 2004 "

putlog "Adduser BOT LOADED "
