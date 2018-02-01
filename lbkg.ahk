/*
Simple pounds to kilograms converter

Changelog 20151015
* Added commas after functions per AHK parameters
* Added #NoEnv and SetWorkingDir to speed up the script
* Removed unnecessary punctuation
* Added function to remove commas from input
* Make input box pop up again if invalid input is entered (like a letter in the input)
* Changed variable names for clarity
*/

#NoEnv
#SingleInstance, force
SendMode, Input
SetWorkingDir, %A_ScriptDir%

+NumpadSub:: ; Shift + numberpad minus
^+NumpadSub:: ; Ctrl + shift + numberpad minus
^+-:: ; Ctrl + shift + keyboard minus

; Input box to enter pounds
InputBox, lbs, Pounds to kilograms converter, Enter pounds (Hit esc or the cancel button to exit)
if ErrorLevel
	return

; Remove commas from input
StringReplace, lbs, lbs, `,, , All

; Check to make sure only a number is entered. Pop up a new input box if it is not
Loop
{
	if lbs is number
		break
	else
	{
		if StrLen(lbs) > 20
			bad_input := SubStr(lbs, 1, 20) " ..."
		else
			bad_input := lbs
		InputBox, lbs, Pounds to kilograms converter, Pounds MUST only be numbers. (Hit esc or the cancel button to exit)`n`nInvalid number: %bad_input%
		if ErrorLevel
			return
		continue
	}
}

; If a negative number is entered convert it to the same number but positive
if (lbs < 0)
	lbs := lbs * -1

; Convert lbs to kg and then round
lbs_in_kg := 2.20462262
kg := Round(lbs/lbs_in_kg, 0)

; If rounds to zero then output one instead
if (kg = 0)
	kg := 1

; Sending output
Sleep, 200
Send, %kg%
return