bind time - "00 0 * * *" zero
bind time - "00 1 * * *" uma
bind time - "00 2 * * *" duas
bind time - "00 3 * * *" tres
bind time - "00 4 * * *" quatro
bind time - "00 5 * * *" cinco
bind time - "00 6 * * *" seis
bind time - "00 7 * * *" sete
bind time - "00 8 * * *" oito
bind time - "00 9 * * *" nove
bind time - "00 10 * * *" dez
bind time - "00 11 * * *" onze
bind time - "00 12 * * *" doze
bind time - "00 13 * * *" treze
bind time - "00 14 * * *" katorze
bind time - "00 15 * * *" kinze
bind time - "00 16 * * *" dezasseis
bind time - "00 17 * * *" dezassete
bind time - "00 18 * * *" dezoito
bind time - "00 19 * * *" dezanove
bind time - "00 20 * * *" vinte
bind time - "00 21 * * *" vinteuma
bind time - "00 22 * * *" vinteduas
bind time - "00 23 * * *" vintetres


proc zero {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 0:00 - Eh neste preciso momento meia noite"
  }
}

proc uma {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 01:00 - Sao neste preciso momento uma da manha"
  }
}

proc duas {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 02:00 - Sao neste preciso momento duas da manha"
  }
}

proc tres {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 03:00 - Sao neste preciso momento tres da manha"
  }
}

proc quatro {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 04:00 - Sao neste preciso momento quatro da manha"
  }
}

proc cinco {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 05:00 - Sao neste preciso momento cinco da manha "
  }
}

proc seis {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 06:00 - Sao neste preciso momento seis da manha"
  }
}

proc sete {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Bom dia - 07:00 - Sao neste preciso momento sete da manha"
  }
}

proc oito {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Bom dia - 08:00 - Sao neste preciso momento oito da manha"
  }
}

proc nove {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Bom dia - 09:00 - Sao neste preciso momento nove da manha"
  }
}

proc dez {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Bom dia - 10:00 - Sao neste preciso momento dez da manha"
  }
}

proc onze {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Bom dia - 11:00 - Sao neste preciso momento onze da manha"
  }
}

proc doze {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa tarde - 12:00 - Sao neste preciso momento meio dia"
  }
}

proc treze {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa tarde - 13:00 - Sao neste preciso momento uma da tarde"
  }
}

proc katorze {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa tarde - 14:00 - Sao neste preciso momento duas da tarde"
  }
}

proc kinze {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa tarde - 15:00 - Sao neste preciso momento tres da tarde"
  }
}

proc dezasseis {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa tarde - 16:00 - Sao neste preciso momento quatro da tarde"
  }
}

proc dezassete {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa tarde - 17:00 - Sao neste preciso momento cinco da tarde"
  }
}

proc dezoito {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa tarde - 18:00 - Sao neste preciso momento seis da tarde"
  }
}

proc dezanove {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 19:00 - Sao neste preciso momento sete da tarde"
  }
}

proc vinte {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 20:00 - Sao neste preciso momento oito da noite"
  }
}

proc vinteuma {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 21:00 - Sao neste preciso momento nove da noite"
  }
}

proc vinteduas {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 22:00 - Sao neste preciso momento dez da noite"
  }
}

proc vintetres {min hour day month year} {
  foreach chan [channels] {
    putserv "PRIVMSG #palmela :Boa noite - 23:00 - Sao neste preciso momento onze da noite"
  }
}

putlog "Horas TCL Loaded"
