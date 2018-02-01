/*
=============================================
Name query and FDA establishment ID add
Author: Jeffrey Decker

Usually use this for QI since it has lots of
name and address adds and is FDA
=============================================
*/

#NoEnv
#SingleInstance, force
SendMode, Input
SetWorkingDir, %A_ScriptDir%

; hotkey: ctrl + shift + i

^+i::



/*
------------------------------------
Variables that can be set if needed
------------------------------------
*/

; number options for consignee and fda establishment id fields
; these can be different for different user classes
opt_cna := "21"
opt_fei := "32"

; Sleep time in milliseconds
sleeptime := 150

; getting input info
InputBox, name, QI name, Name line.
if (ErrorLevel) {
	return
}

InputBox, address, QI address, Address line.
if (ErrorLevel) {
	return
}

Inputbox, city, QI city, City line.
if (ErrorLevel) {
	return
}

Inputbox, state, QI state, State abbreviation line. Enter 2 letters.
if (ErrorLevel) {
	return
}

; Changing inputs to upper case
StringUpper, name, name
StringUpper, address, address
StringUpper, city, city
StringUpper, state, state
StringUpper, zip, zip

; Validating state code is 2 letters
if state is not alpha
{
	MsgBox, State code must only be letters
	return
} else if (StrLen(state) <> 2) {
	MsgBox, State code must be 2 characters
	return
}


Inputbox, zip, QI zip, Zip code line. Enter only 5 digits.
if (ErrorLevel) {
	return
}

; Removing any possible spaces or dashes from zip
StringReplace, zip, zip, %A_Space%, , All
StringReplace, zip, zip, -, , All

; Check if zip is 5 digits
if zip is not integer
{
	MsgBox, Zip code must only be numbers
	return
} else if (StrLen(zip) <> 5) {
	MsgBox, Zip code must be 5 numbers
	return
}

; formatting for consignee fields
con_name := SubStr(name, 1, 31)
con_address := SubStr(address, 1, 31)
con_city := SubStr(city, 1, 20)
con_state := SubStr(state, 1, 2)
con_zip := SubStr(zip, 1, 5)

; formatting for fei fields
fei_name := SubStr(name, 1, 36)
fei_address := SubStr(address, 1, 36)
fei_city := SubStr(city, 1, 20)
fei_state := SubStr(state, 1, 2)
fei_zip := SubStr(zip, 1, 5)



/*
----------------------------------
Sending text to the active window
----------------------------------
*/

Sleep, %sleeptime%
Send, %con_name%{ENTER}%con_address%{ENTER 2}%con_city%{ENTER}%con_state%{ENTER}%con_zip%{ENTER}UR{ENTER}

Sleep, %sleeptime%
Sleep, %sleeptime%
Send, %opt_fei%{ENTER}

Sleep, %sleeptime%
Send, {ENTER 3}YQ

Sleep, %sleeptime%
Send, %fei_name%{ENTER 2}%fei_address%{ENTER 2}%fei_city%{ENTER}%fei_state%%fei_zip%{ENTER}UR{ENTER}

Sleep, %sleeptime%
Sleep, %sleeptime%
Send, {F4}%opt_cna%{ENTER 2}

return