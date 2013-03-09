#include <D:\Jeux\Eve\ImageSearch\ImageSearch.au3>
#AutoIt3Wrapper_UseX64=n
;
; Demo on the functions of ImageSearch
; Assumes that you have a Recycle Bin icon at the top left of your screen
; Assumes that you have IE6 or 7 icon visible
; Please make the icon visible or we won't be able to find it
;

MsgBox(0,"MSG","You need to have the should have recycle bin, and preferably, an IE icon, a PDF icon and folder icon for the demo to go nicely. All of them should be visible on the desktop")

$x1=0
$y1=0
;
; find recycle bin and move to the center of it
; change 2nd argument to 0 to return the top left coord instead
ConsoleWrite("closeLauncher.bmp")
$result = _ImageSearch("closeLauncher.bmp",1,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a empty recycle bin here...")
EndIf

ConsoleWrite("plays.bmp")
; find recycle bin and move to the center of it
$result = _ImageSearch("plays.bmp",0,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a empty recycle bin here... cursor move to top left of image")
EndIf


; find recycle bin and move to the center of it
; change 2nd argument to 0 to return the top left coord instead
$result = _ImageSearch("recycle.bmp",1,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a recycle bin with stuff here...")
EndIf

; find recycle bin and move to the center of it
$result = _ImageSearch("recycle.bmp",0,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a recycle bin with stuff here... cursor move to top left of image")
EndIf



MsgBox(0,"MSG","Search for a recycle bin in the top left corner in a 200x200 box")

; find recycle bin if it is in the top left corner of screen
; change 2nd argument to 0 to return the top left coord instead
$result = _ImageSearchArea("recycle2.bmp",1,0,0,200,200,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a empty recycle bin in top left corner")
EndIf

; find recycle bin if it is in the top left corner of screen
; change 2nd argument to 0 to return the top left coord instead
$result = _ImageSearchArea("recycle.bmp",1,0,0,200,200,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a recycle bin with stuff in top left corner")
EndIf


; I guess most people should at least have an IE icon on the desktop
$result = _ImageSearch("ie7Desktop.bmp",0,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found an IE icon here")
EndIf

; I guess most people should at least have an PDF icon on the desktop
$result = _ImageSearch("pdf.bmp",0,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a PDF icon here")
EndIf

; I guess most people should at least have an Folder icon on the desktop
$result = _ImageSearch("folder.bmp",0,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Found a Folder icon here")
EndIf

; wait for a non empty recycle bin to appear
MsgBox(0,"MSG","Empty your recycle bin and then click OK. Then throw something in the bin within 15s")
$result = _WaitForImageSearch("plays.bmp",15,1,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Hey... your recycle bin now has stuff")
EndIf

; wait 15s for either the full or empty recycle bin
MsgBox(0,"MSG","Using WaitForImages to see whether you have a full or empty bin")
Dim $anArray[10]
$anArray[0]=2  ; two images to wait to appear
$anArray[1]="recycle.bmp"  ; image 1 to wait for
$anArray[2]="recycle2.bmp"  ; image 2 to wait for
$result = _WaitForImagesSearch($anArray,15,1,$x1,$y1,0)
if $result=1 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Hey... your recycle bin has stuff")
EndIf
if $result=2 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Hey... your recycle bin is empty")
EndIf
if $result=0 Then
	MouseMove($x1,$y1,3)
	MsgBox(0,"Found","Hey... cannot find your recycle bin")
EndIf
