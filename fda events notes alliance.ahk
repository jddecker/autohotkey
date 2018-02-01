/*
===================
Event message adds
===================
*/

#NoEnv
#SingleInstance, force
SendMode, Input
SetWorkingDir, %A_ScriptDir%

sleeptime = 75

; For may proceed message
; ctrl + shift + j
^+j::
fda_text := "*** may proceed events"

; sleep %sleeptime%
Send, %clipboard%{ENTER}

; sleep %sleeptime%
Send, {TAB}9{ENTER}

; sleep %sleeptime%
Send, A{ENTER}%fda_text%{ENTER}Y{F3}UR{ENTER}

; sleep %sleeptime%
Send, {F4}{F4}
return

; For review message
; ctrl + shift + k
^+k::
fda_text := "*** review events"

; sleep %sleeptime%
Send, %clipboard%{ENTER}

; sleep %sleeptime%
Send, {TAB}9{ENTER}

; sleep %sleeptime%
Send, A{ENTER}%fda_text%{ENTER}Y{F3}UR{ENTER}

; sleep %sleeptime%
Send, {F4}{F4}
return

; For exam message
; ctrl + shift + h
; ^+h::
; fda_text := "*** exam events"

; Comment out this section since have to verify if it's still on exam
; /* 
; ; sleep %sleeptime%
; Send %clipboard%{ENTER}

; ; sleep %sleeptime%
; Send {TAB}9{ENTER}
; */

; ; sleep %sleeptime%
; Send A{ENTER}%fda_text%{ENTER}Y{F3}UR{ENTER}

; ; sleep %sleeptime%
; Send {F4}{F4}
; return