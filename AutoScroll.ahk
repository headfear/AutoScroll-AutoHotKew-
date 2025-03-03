#NoEnv  
#SingleInstance, Force
SendMode Input  
#KeyHistory 0
ListLines Off
SetMouseDelay, -1


SavedPositions := []  ; Массив для хранения позиций


WheelTurns := 5

#WheelUp:: ScrollPoint("WheelUp", WheelTurns, SavedPositions)
Return
#WheelDown:: ScrollPoint("WheelDown", WheelTurns, SavedPositions)
Return
!#WheelUp:: ScrollPoint("WheelUp", WheelTurns, SavedPositions, SavedX, SavedY)
Return
!#WheelDown:: ScrollPoint("WheelDown", WheelTurns, SavedPositions, SavedX, SavedY)
Return

; Сохранить позицию курсора на Win+Alt+клик и добавить в массив
#!LButton::
{
    CoordMode, Mouse, Screen
    MouseGetPos, SavedX, SavedY
    SavedPositions.Push([SavedX, SavedY]) 


    SavedPositionsCount := SavedPositions.MaxIndex()

   
    ToolTip, Сохранена точка для прокрутки: %SavedX% x %SavedY%`nСохранено %SavedPositionsCount% позиций
    Sleep 1000
    ToolTip
}
Return


C::  ; Вывод всех позиций по нажатию C 
{
    List := "Сохранённые позиции:`n"

    for index, element in SavedPositions
    {
        List .= "Позиция " index ": X = " SavedPositions[index][1] ", Y = " SavedPositions[index][2] "`n"
    }

    MsgBox, % List  ; 
}
Return


; Скролл происходит путем сочетания клавишь  Win + ALT + Скролл
ScrollPoint(WhichButton, WheelTurns, SavedPositions, PasX = -1, PasY = -1) {
    CoordMode, Mouse, Screen
    WinGetPos, , , Xmax, , Program Manager
    MouseGetPos, MouseX, MouseY

    Loop, % WheelTurns {
        ; Для каждой сохраненной позиции
        for index, element in SavedPositions {
            CurrentPos := SavedPositions[index]  
            CurrentX := CurrentPos[1]  ; Извлекаем X
            CurrentY := CurrentPos[2]  ; Извлекаем Y
            MouseClick, %WhichButton%, , , 1, 0, ,

            if (CurrentX > -1) {
                MouseClick, %WhichButton%, CurrentX, CurrentY, 1, 0, ,
            } else {
                MouseClick, %WhichButton%, (Xmax - MouseX), MouseY, 1, 0, ,
            }
        }
        
        MouseMove, MouseX, MouseY, 0
    }
}
