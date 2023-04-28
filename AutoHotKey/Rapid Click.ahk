; Rapid click
; Press "`" to toggle on/off
; Script starts suspended

Suspend, on
CoordMode, ToolTip, Screen

`::
    Suspend
    if (A_IsSuspended) {
        ToolTip, Rapid click off, 0, 0
    } else {
        ToolTip, Rapid click on, 0, 0
    }
    SetTimer, RemoveToolTip, 1000
return

LButton::
    Loop {
        SetMouseDelay 30
        Click
        If (GetKeyState("LButton","P")=0)
            Break
    }
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return