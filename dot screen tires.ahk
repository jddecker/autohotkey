/*
==============================================
DOT script for doing lots of tire DOT screens
Author: Jeffrey Decker
==============================================
*/

#NoEnv
#SingleInstance, force
SendMode, Input
SetWorkingDir, %A_ScriptDir%

; hotkey: ctrl+shift+u
^+u::



/*
--------------
Set variables
--------------
*/

; Set dot declaration. Must be two characters.
dotdec := "2A"

; Prefix something before tirecode (T or P)
; Empty quotes for nothing in front of the tirecode
tirecodeprefix := "P"

; Sequence field starting position.
seq := 1

; Milliseconds between loops
sleeptime := 75

; A quick check that dotdec is 2 characters to stop the
; script if it is not
if (StrLen(dotdec) <> 2) {
	MsgBox, dotdec variable must be set to 2 characters
	return
}

; If tirecode is blank set text to NONE
if (tirecodeprefix = "") {
	tirecodeprefix_text := "(none)"
} else {
	tirecodeprefix_text := tirecodeprefix
}

; This will keep looping until esc or the cancel button
; is clicked
Loop {
	; Set variables for previous input. Skip if first sequence.
	if (seq <> "1") {
		prev_tirecode := tirecode
		prev_brand := brand
	}

	; Getting inputs. Tells you what DOT screen number you are on.
	InputBox, tirecode, DOT tirecode, Enter DOT tire code (Hit esc or cancel to stop)`nSeq #: %seq%`nHS-7 Box: %dotdec%`nTirecode prefix: %tirecodeprefix_text%`nPrev: %prev_tirecode% | %prev_brand%
	if (ErrorLevel) {
		return
	}

	; Add something before tire code then limit total string to 3 characters
	; Added three 0s to always make sure tirecode is 3 digits
	tirecode := tirecodeprefix . tirecode . "000"
	tirecode := SubStr(tirecode, 1, 3)

	; Convert to uppercase
	StringUpper, tirecode, tirecode

	Inputbox, brand, DOT brand, Enter tire brand name (Hit esc or cancel to stop)`nSeq #: %seq%`nHS-7 Box: %dotdec%`nDOT tire code: %tirecode%
	if (ErrorLevel) {
		return
	}

	; Remove dash character and replace with space since it causes DOT reject
	; Remove . from the brand name because it causes rejects
	StringReplace, brand, brand, -, %A_SPACE%, All
	StringReplace, brand, brand, ., , All

	; Field is 20 characters long. Limit to 19
	brand := SubStr(brand, 1, 19)

	; Convert to upper case letters
	StringUpper, brand, brand



	/*
	----------------------
	Send output to screen
	----------------------
	*/

	; sleep %sleeptime%
	Send, %seq%{ENTER}%dotdec%EY{ENTER}T%tirecode%%brand%{ENTER}U{ENTER}

	; Sequence number increases by 1 every time
	seq := seq + 1
}
return