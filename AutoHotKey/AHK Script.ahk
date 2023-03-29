#NoEnv				; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input		; Recommended for new scripts due to its superior speed and reliability.
#NoTrayIcon			; Hide the tray icon

; Email auto type
; CTRL+SHIFT+0
^+0::send email@gmail.com

; Type clipboard text
; CTRL+SHIFT+V
; ^+v::Send {Raw}%Clipboard%