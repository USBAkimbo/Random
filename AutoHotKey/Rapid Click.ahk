#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Rapid click
; Press \ to toggle on/off
; Script starts suspended

Suspend, on
\::Suspend

; Whilst left mouse button is pressed, left click every 100 ms
LButton::
	While, GetKeyState("LButton","P")
	{
		Click
		Sleep 100
	}
Return