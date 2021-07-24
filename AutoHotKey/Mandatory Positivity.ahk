#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetKeyDelay, 50

Messages := ["we can do this guys{!}", "let's be positive :)", "we outscale", "we got this", "im lagging lol", "we're doing great", "if we get next drake we have this in the bag", "believe in yourselves", "we should do baron", "why doesn't my father love me?", "i am such a bed shitter"]

#IfWinActive ahk_exe League of Legends.exe
Enter::

Random, Rand, 1, Messages.MaxIndex()
Msg := Messages[Rand]
While Msg == PrevMsg
{	
	Random, Rand, 1, Messages.MaxIndex()
	Msg := Messages[Rand]
}

PrevMsg := Msg

Send {Enter}
Sleep, 50
Send %Msg%{Enter}