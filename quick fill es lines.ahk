/*
=========================================================
Quick fill values for entry summary screen in Alliance
Author: Jeffrey Decker

This script works good for items that require FDA and
prior notice and doesn't change consignees too often

At the bottom there is a script for RLF AII desc
=========================================================
*/

#NoEnv
#SingleInstance, force
SendMode, Input
SetWorkingDir, %A_ScriptDir%

^+l:: ; Ctrl + Shift + L



/*
-----------------------------------------
Set these variables for what is needed
True or false
-----------------------------------------
*/

is_cad := 0
convert_to_kg := 1
is_usgoods := 0
is_fee := 1
is_multi_irs := 1
is_multi_name := 0
is_related := 0
is_fda := 1



/*
-----------------------------------------------
Presets for certain entries to overwrite above
Only uncomment one of them to use
Only works if use_preset is true
-----------------------------------------------
*/

; if use_preset is false it will pull from variables above
use_preset := true

; preset := "ww" ; for rlf
 preset := "champs" ; also works for avina and farmers
; preset := "fp" ; for related
; preset := "clkns"
; preset := "qi" ; for name and address consignee
; preset := "ptcrn"
; preset := "bchh" ; bc hot house



/*
--------------------------------------------------------
Below this point are variables for certain situations
--------------------------------------------------------
*/

; Set to a string with " around text or use Clipboard variable
; to pull text that is on the clipboard
fei_id := Clipboard

; If fei_id is valid, then use it. This can force it to always
; make fei_id_ok false if this is set to false which brings you
; to the FEI screen each time
use_fei_id := true

; The amount of time in milliseconds between sends. This must
; be set to a number. Value of 250 definitely works.
; Experimenting with 50 on the VDI box.
; 75 ms seems to work best
; SetKeyDelay, 75

; Force col 2 between the SP and NC indicators in Alliance when
; FDA is not turned on.
is_fda_col2 := false

; Turn off the enter for the NC column. Good for trans shipped
; US goods with FDA. Default to true with NAFTA.
is_nc := true

; Line 13 always has an extra field to enter through.
; Usually easier to not run the script for that line.
; Variable just in case. (This currently doesn't seem to be working)
is_line_13 := false

; If the fee is set and you want to make sure it
; is blank. Change this to false if you are carrying the
; previous fee value to the next line. Haven't found a use
; to change this to false yet.
is_fee_space := true

; The time to put in the prior notice screen. Needs to be
; set to 4 digits on a 24 hour clock with no ":" character.
; Put quotes around the setting to make sure this is a string.
; If input incorrectly it defaults back to 2300
pn_time := "2300"

; Manually input FDA manufacturer and shipper registrations
; fda_manufacturer_reg must be 11 digits. If not then will pop
; up a box stopping the script
fda_manufacturer_reg_manual := false
fda_manufacturer_reg := ""
fda_shipper_reg_manual := false
fda_shipper_reg := ""

; For NAFTA on things that don't have NAFTA
force_nafta := true



/*
-------------------------------------------
Area for setting variables for the presets
-------------------------------------------
*/

if (use_preset) {
	if (preset = "ww") {
		is_cad := true
		convert_to_kg := true
		is_usgoods := false
		is_fee := false
		is_multi_irs := false
		is_multi_name := false
		is_related := true
		is_fda := true
	} else if (preset = "champs") {
		is_cad := false
		convert_to_kg := false
		is_usgoods := false
		is_fee := true
		is_multi_irs := true
		is_multi_name := false
		is_related := false
		is_fda := true
	} else if (preset = "fp") {
		is_cad := false
		convert_to_kg := true
		is_usgoods := false
		is_fee := false
		is_multi_irs := false
		is_multi_name := false
		is_related := true
		is_fda := true
	} else if (preset = "clkns") {
		is_cad := false
		convert_to_kg := true
		is_usgoods := false
		is_fee := false
		is_multi_irs := true
		is_multi_name := false
		is_related := false
		is_fda := true
	} else if (preset = "qi") {
		is_cad := false
		convert_to_kg := false
		is_usgoods := false
		is_fee := false
		is_multi_irs := false
		is_multi_name := true
		is_related := false
		is_fda := true
	} else if (preset = "ptcrn") {
		is_cad := false
		convert_to_kg := true
		is_usgoods := false
		is_fee := false
		is_multi_irs := false
		is_multi_name := false
		is_related := false
		is_fda := true
	} else if (preset = "bchh") {
		is_cad := false
		convert_to_kg := false
		is_usgoods := false
		is_fee := false
		is_multi_irs := false
		is_multi_name := false
		is_related := false
		is_fda := true
	}
}



/*
---------------------------
Input boxes and validation
---------------------------
*/

; If is_fda is set then make sure fei_id is 12 digits
; Can help if accidentally copied something else in the
; middle of an entry.
; Will set variable if not okay and end script on the
; FEI field

; Also validates pn_time debug variable to 4 digits.
if (is_fda) {
	; This part is for the fei_id field

	; Remove extra spaces and dashes
	StringReplace, fei_id, fei_id, %A_Space%, , All
	StringReplace, fei_id, fei_id, -, , All

	; Make sure just numbers are left
	if fei_id is not integer
	{
		fei_id_ok := false
	} else if (StrLen(fei_id) <> 12) { ; Must be exactly 12 digits
		fei_id_ok := false
	} else if (use_fei_id = false) { ; If use_fei_id is false then force fei_id_ok to false
		fei_id_ok := false
	} else { ; If valid fei_id then set fei_id_ok to true
		fei_id_ok := true
	}

	; This part is for the PN time field. Sets to 2300 by
	; default unless something valid is put in the variable

	; Remove extra spaces and dashes and colon characters
	StringReplace, pn_time, pn_time, %A_Space%, , All
	StringReplace, pn_time, pn_time, -, , All
	StringReplace, pn_time, pn_time, :, , All

	; Make sure just numbers are left
	if pn_time is not integer
	{
		pn_time := "2300"
	} else if (StrLen(pn_time) <> 4) { ; Must be exactly 4 digits
		pn_time :="2300"
	}
}

; This is for information text on the input boxes It'll tell you if FDA is not turned on or if the FEI is valid or not.
if (is_fda = false) {
	fei_inputbox_text := "FDA is not turned on."
} else if (fei_id_ok) {
	fei_inputbox_text := "FEI is set to: " . fei_id
} else {
	fei_inputbox_text := "FEI is NOT valid."
}

; Validation for fda manufacturer reg manual input
if (is_fda) and (fda_manufacturer_reg_manual) {
	if fda_manufacturer_reg is not integer
	{
		MsgBox, fda_manufacturer_reg must be only digits
		return
	} else if (StrLen(fda_manufacturer_reg) <> 11) {
		MsgBox, fda_manufacturer_reg must be 11 digits
		return
	}
}

; Validation for fda shipper reg manual input
if (is_fda) and (fda_shipper_reg_manual) {
	if fda_shipper_reg is not integer
	{
		MsgBox, fda_shipper_reg must be only digits
		return
	} else if (StrLen(fda_shipper_reg) <> 11) {
		MsgBox, fda_shipper_reg must be 11 digits
		return
	}
}

; Adding preset text
if (use_preset) and (preset) {
	preset_inputbox_text := "Preset: " . preset
} else {
	preset_inputbox_text := "Preset: none"
}

; If is_multi_irs and is_multi_name both set to true then stop the script from running
if (is_multi_irs) and (is_multi_name) {
	MsgBox, Both is_multi_irs and is_multi_name cannot be set to true
	return
}

if (is_cad) {
	value_text := "Canadian dollars"
} else {
	value_text := "US dollars"
}

; Inputs for dollars and weight
InputBox, dollars, Line fill script value input, Enter %value_text%`n`n%fei_inputbox_text%`n%preset_inputbox_text%
if (ErrorLevel) {
	return
}

; Check if dollars is a number
if dollars is not number
{
	MsgBox, Dollars needs to be a number
	return
}

; Text for weight input box
if (convert_to_kg) {
	weight_text := "pounds"
} else {
	weight_text := "kilograms"
}

InputBox, weight, Line fill script weight input, Enter %weight_text%`n`n%fei_inputbox_text%`n%preset_inputbox_text%
if (ErrorLevel) {
	return
}

; Check if weight is a number
if weight is not number
{
	MsgBox, Weight needs to be number
	return
}

; Round dollars to two decimals
dollars := Round(dollars, 2)

; If weight is negative, change to a positive number
if ( weight < 0 ) {
	weight := weight - weight * 2
}

; Round lbs to kg or just round if input is already in kg
if (convert_to_kg) {
	weight := Round(weight/2.2046, 0)
} else {
	weight := Round(weight, 0)
}

; If weight rounded to zero then round to one
if (weight = 0) {
	weight = 1
}



/*
---------------------
Sending output below
---------------------
*/

Send, %dollars%{ENTER}

; Putting CA in NAFTA field if set
if (force_nafta) {
	Send, CA
} else {
	Send, {ENTER}
}

; Extra enter here for fda
if (is_fda) or (is_fda_col2) {
	Send, {ENTER}
}

; In 2013 started to notice the NC column doesn't always show up.
if (is_nc) {
	Send, {ENTER}
}

; US goods has no reporting quantity
if (is_usgoods = false) {
	Send, %weight%{ENTER 2}
}

; Fee field for mushrooms, potatoes, etc
; If US tariff is used there is no fee field
if (is_fee) and (is_usgoods = false) {
	if (is_fee_space) { ; Add space to remove fee data
		Send, {Space}{ENTER}
	} else { ; Enter here will copy fee data from previous line
		Send, {ENTER}
	}
}

; Extra enter if on line 13 right before gross weight field
if (is_line_13) {
	Send, {ENTER}
}

Send, %weight%{ENTER 2}

; To get past multi consignee fields. Going to copy IRS from previous line
if (is_multi_irs) {
	Send, {ENTER}UR{ENTER}
}

; For multi name and address (good for QI Tea entries)
if (is_multi_name) {
	Send, {ENTER 7}UR{ENTER}
}

; For related parties
if (is_related) {
	Send, Y
} else {
	Send, N
}

; For FDA screens if variable is set
if (is_fda) {
	; Put Y in OGA field
	Send, Y

	; FDA screens
	Send, UR{ENTER}7{ENTER}%weight%{ENTER}KG{ENTER}13{ENTER 2}

	if (is_cad) { ; Extra enter because of extra field for CAD
		Send, {ENTER}
	}

	if (fei_id_ok) { ; If fei_id field is okay then input the data
		Send, 15{ENTER}%fei_id%
	}

	; Field to enter the PN screen
	Send, 22{ENTER}Y

	; Manually put in manufacturer FDA registration number
	if (fda_manufacturer_reg_manual) {
		Send, 31{ENTER}
		Send, %fda_manufacturer_reg%
	}

	; Manually input shipper reg
	if (fda_shipper_reg_manual) {
		Send, 32{ENTER}
		Send, %fda_shipper_reg%
	}
	
	; Putting in PN time and putting a Y in all IDs
	Send, 20{ENTER}%pn_time%33{ENTER}YUR{ENTER}

	if (fei_id_ok) { ; If fei_id validates then save FDA data
		Send, UR{ENTER}
	} else { ; If not then go to the FEI search and end the script
		Send, 15{ENTER}?{ENTER}
		Send, S
		return
	}
} else {
	; Put N in OGA field
	Send, N
}

; Last enter to put Alliance on the next line
Send, {ENTER}
return



/*
=================
For RLF AII desc
=================
*/

^+d:: ; Ctrl + Shift + D
Inputbox, desc_line, Enter AII field number, Enter AII field number
if (ErrorLevel) {
	return
}

if desc_line is not integer
{
	return
} else if (desc_line < 0 OR desc_line > 4) {
	return
}

Send, {BACKSPACE 6}
Send, DESC-%desc_line%{ENTER}Y
Send, 1{ENTER}
return



/*
=======================
For checking CAT codes
=======================
*/

^+m:: ; Ctrl + Shift + M
Send, D
Send, 26{ENTER}
Send, OG-1{ENTER}
Send, 1{ENTER}YUR{ENTER}
return