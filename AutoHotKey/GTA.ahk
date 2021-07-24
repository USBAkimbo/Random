; Don't change these
#MaxThreadsPerHotkey 2
#NoEnv
SetWorkingDir A_ScriptDir

; Disables hotkeys when alt-tabbed or GTA is closed
#IfWinActive ahk_class grcWindow

; Key bindings
AutoHealthKey   := "Numpad1" ; Eat 2 snacks
AutoArmorKey    := "Numpad2" ; Equip 2 armour
RetrieveCarKey  := "Numpad3" ; Request personal car
CEOBuzzardKey   := "Numpad4" ; Spawn CEO buzzard

; Interaction menu key
IGB_Interaction := "m"

; Hotkey/Function mapping
Hotkey, %AutoHealthKey%, AutoHealth
Hotkey, %AutoArmorKey%, AutoArmor
Hotkey, %RetrieveCarKey%, RetrieveCar
Hotkey, %CEOBuzzardKey%, CEOBuzzard

Return

AutoHealth:
  Send {%IGB_Interaction%}{Down 3}{Enter}{Down 4}{Enter 3}{%IGB_Interaction%}
  return

AutoArmor:
  Send {%IGB_Interaction%}{Down 3}{Enter}{Down 3}{Enter 3}{Down}{Enter 2}{Down}{Enter 2}{Down}{Enter 2}{Down}{Enter 2}{%IGB_Interaction%}
  return

RetrieveCar:
  Send {%IGB_Interaction%}{Down 5}{Enter 2}{%IGB_Interaction%}
  return

CEOBuzzard:
  Send {%IGB_Interaction%}{Enter}{Down 5}{Enter}{Down 4}{Enter}{%IGB_Interaction%}
  return