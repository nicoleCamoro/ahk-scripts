SetWorkingDir, C:\Users\TaranWORK\Documents\GitHub\2nd-keyboard\2nd keyboard support files
;the above will supposedly set A_WorkingDir. It must be done in the autoexecute area, BEFORE the code below.

#NoEnv
Menu, Tray, Icon, shell32.dll, 283 ; this changes the tray icon to a little keyboard!
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force ;only one instance of this script may run at a time!
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm




;audioMonoMaker() will open the Audio Channels box, and use the cursor to put both tracks on [left/right], turning stereo sound into mono (with the [right/right] track as the source.
audioMonoMaker(track)
{
    ifWinNotActive ahk_exe Adobe Premiere Pro.exe
        goto monoEnding
    sleep 3
    ;msgbox,,, what the hell,0.6
    CoordMode,Mouse,Screen
    CoordMode,pixel,Screen
    ;SetTitleMatchMode, 2
    ;DetectHiddenWindows, On

    BlockInput, SendAndMouse
    BlockInput, On
    BlockInput, MouseMove ;prevents mouse from moving

    ;Keyshower(track,"audioMonoMaker") ;you can delete this line, you don't need it.
    if IsFunc("Keyshower") {
        Func := Func("Keyshower")
        RetVal := Func.Call(track,"audioMonoMaker") 
    }
    global tToggle = 1
    ;msgbox, track is %track%
    if (track = "right")
    {
        ;msgbox, this is for the RIGHT audio track. As usual, your number will be smaller, since I have 150% UI scaling enabled.
        addPixels = 36
    }
    else if (track = "left")
    {
        addPixels = 0
        ;msgbox, this is for the LEFT audio track
    }
    ;Send ^!+a ;control alt shift a --- ; audio channels shortcut, asigned in premiere - dont use this key combo anywhere else. UPDATE: seems unreliable to send shortcuts that use modifier keys, inside a funciton that was triggered using modifier keys. switched to F3.
    sendinput, {F3} ;also the audio channels shortcut.
    ; sleep 15
    ; sendinput, {F3} ;again cause sometimes it fails?
    ;WARNING - this was cross-talking with !+a, causing a preset("blur with edges") macro to be executed. I dont know how to avoid. maybe change order...??
    ;WARNING - still cross talks with RENDER AUDIO, which is CTRL SHIFT A, or CTRL ALT A.
    ; fun fact, if you send this keystroke AGAIN, it does NOT close the panel, which is great... that means you can press the button anytime, and it will always result in an open panel.
    sleep 15

    MouseGetPos, xPosAudio, yPosAudio

    MouseMove, 2222, 1625, 0 ;moved the mouse onto the expected location of the "okay" box, which has a distinct white color when the cursor is over it, which will let us know the panel has appeared.

    ; msgbox where am i, cursor says
    MouseGetPos, MouseX, MouseY

    waiting = 0
    ;the following loop is waiting until it sees a specific color from the panel, which means that it has loaded and can then be affected.
    loop
        {
            waiting ++
            sleep 50
            tooltip, waiting = %waiting%`npixel color = %thecolor%
            MouseGetPos, MouseX, MouseY
            PixelGetColor, thecolor, MouseX, MouseY, RGB
            if (thecolor = "0xE8E8E8")
                {
                tooltip, COLOR WAS FOUND
                ;msgbox, COLOR WAS FOUND 
                break
                }
                
            if (waiting > 10)
                {
                tooltip, no color found, go to ending
                goto, ending
                }
        }
        
    ;*/
    CoordMode, Mouse, Client
    CoordMode, Pixel, Client

    MouseMove, 165 + addPixels, 295, 0 ;this is relative to the audio channels window itself. Again, you should reduce these numbers by like 33%...?, since i use 150% UI scaling.
    ;msgbox, now we should be on the first check box
    sleep 50

    MouseGetPos, Xkolor, Ykolor
    sleep 50
    PixelGetColor, kolor, %Xkolor%, %Ykolor%
    ;msgbox, % kolor
    ; INFORMATION:
    ; 2b2b2b or 464646 = color of empty box
    ; cdcdcd = color when cursor is over the box
    ; 9a9a9a = color when cursor NOT over the box
    ; note that these colors will be different depending on your UI brightness set in premiere.
    ; For me, the default brightness of all panels is 313131 and/or 2B2B2B

    ;msgbox, kolor = %kolor%
    If (kolor = "0x1d1d1d" || kolor = "0x333333") ; This is the color of an EMPTY checkbox. The coordinates hsould NOT lead to a position where the grey of the checkmark would be. Also, "kolor" is the variable name rather than "color" because "color" might be already used for something else in AHK.
    {
        ;msgbox, box is empty
        ; click left
        ;sendinput, LButton
        MouseClick, left, , , 1
        sleep 10
    }
    else if (kolor = "0xb9b9b9") ;We are now looking for CHECK MARKS. This coordinate, should be directly on top of the box, but NOT directly on top of the GRAY checkmark itself. You need to detect telltale WHITE color that means the box has been checked.
    {
        ; Do nothing. There was a checkmark in this box already.
    }
    sleep 5
    MouseMove, 165 + addPixels, 329, 0
    sleep 30
    MouseGetPos, Xkolor2, Ykolor2
    sleep 10
    PixelGetColor, k2, %Xkolor2%, %Ykolor2%
    sleep 30
    ;msgbox, k2 = %k2%
    If (k2 = "0x1d1d1d" || k2 = "0x333333") ;both of these are potential dark grey background panel colors
    {
        ;msgbox, box is empty. i should click
        ; click left
        ;sendinput, LButton
        MouseClick, left, , , 1
        sleep 10
        ;msgbox, did clicking happen?
    }
    else if (k2 = "0xb9b9b9")
    {
        ; Do nothing. There was a checkmark in this box already
    }
    ;msgbox, k2 color was %k2%
    sleep 5
    Send {enter}
    ending:
    CoordMode, Mouse, screen
    CoordMode, Pixel, screen
    MouseMove, xPosAudio, yPosAudio, 0
    BlockInput, off
    BlockInput, MouseMoveOff ;return mouse control to the user.
    tooltip,
    monoEnding:
} ; monomaker!!!!!!!!!!!!