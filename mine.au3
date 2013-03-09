
#include <GuiConstantsEx.au3>
#include <AVIConstants.au3>
#include <TreeViewConstants.au3>
#include <.\ImageSearch.au3>
#include <array.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>

#AutoIt3Wrapper_UseX64=n


;MsgBox(0, "Color", Hex($color, 6))

Global $PollCharlieOre = 0, $PollMickeyOre = 0, $lblGreen, $btnStart
Global $checkCharlieMiner, $checkCharlieHauler, $checkCharlieMinerHauler
Global $checkMickeyMiner, $checkMickeyHauler, $checkMickeyMinerHauler
Global $begin = TimerInit()
Global $HomeRequest = 0, $CharlieAutoPilote = 0
Global Enum $docked, $undocking, $warpingToField, $InField, $mining, $clearing, $openingCargo, $warpingToBase, $docking
Global Enum $none, $filling, $full
Global Enum $miner, $hauler
Global $cargoCount = 0
Global $cargocycle = 0
Global $state1 = $InField
Global $state2 = $docked
Global $ship1 = $miner
Global $ship2 = $miner
Global $haulerloots = 0
Global $minertimer = 0
Global $haulertimer = 0
Global $cargostate = $none
Global $haulerminercargoopen = 0
Global $WarpTime = 80000

;Opt('MustDeclareVars', 1)

; GUI
GUICreate("Sample GUI", 400, 400)
; BUTTON
;GUICtrlCreateButton("Poll New Ore", 10, 330, 100, 30)
$optPollCharlieOre = GUICtrlCreateCheckbox("PollNewOre Charlie", 20, 60, 150, 20)
GUICtrlSetState($optPollCharlieOre, $GUI_UNCHECKED)
$optPollMickeyOre = GUICtrlCreateCheckbox("PollNewOre Mickey", 180, 60, 150, 20)
GUICtrlSetState($optPollMickeyOre, $GUI_UNCHECKED)
$checkCharlieMiner = GUICtrlCreateRadio ("Miner", 20, 150, 150, 20, $WS_GROUP)
GUICtrlSetState($checkCharlieMiner, $GUI_UNCHECKED)
$checkCharlieHauler = GUICtrlCreateRadio ("Hauler", 20, 170, 150, 20)
GUICtrlSetState($checkCharlieHauler, $GUI_UNCHECKED)
$checkCharlieMinerHauler = GUICtrlCreateRadio ("Miner&Hauler", 20, 190, 150, 20)
GUICtrlSetState($checkCharlieMinerHauler, $GUI_UNCHECKED)
$CharlieNone = GUICtrlCreateRadio ("None", 20, 210, 150, 20)
GUICtrlSetState($CharlieNone, $GUI_CHECKED)
$checkMickeyMiner = GUICtrlCreateRadio ("Miner", 180, 150, 150, 20, $WS_GROUP)
GUICtrlSetState($checkCharlieMiner, $GUI_UNCHECKED)
$checkMickeyHauler = GUICtrlCreateRadio ("Hauler", 180, 170, 150, 20)
GUICtrlSetState($checkCharlieHauler, $GUI_UNCHECKED)
$checkMickeyMinerHauler = GUICtrlCreateRadio ("Miner&Hauler", 180, 190, 150, 20)
GUICtrlSetState($checkCharlieMinerHauler, $GUI_UNCHECKED)
$MickeyNone = GUICtrlCreateRadio ("None", 180, 210, 150, 20)
GUICtrlSetState($MickeyNone , $GUI_CHECKED)

; LABEL
$lblGreen = GUICtrlCreateLabel("Green" & @CRLF & "Label", 20, 20, 150, 20)
GUICtrlSetBkColor($lblGreen, 0x00FF00)
$lblGreen2 = GUICtrlCreateLabel("Green" & @CRLF & "Label", 180, 20, 150, 20)
GUICtrlSetBkColor($lblGreen2, 0x00FF00)
$lblcargo = GUICtrlCreateLabel("-", 270, 370, 100, 20)
GUICtrlSetBkColor($lblcargo, 0x0FF0FF)

; BUTTON
$btnStart = GUICtrlCreateButton("START", 350, 5, 40, 20)
$btnCharlieCreateCan = GUICtrlCreateButton("New Can", 20, 100, 150, 20)
$btnMickeyCreateCan = GUICtrlCreateButton("New Can", 180, 100, 150, 20)
$btnHome = GUICtrlCreateButton("HOME", 150, 370, 100, 20)
$btnCharlieAutoPilote  = GUICtrlCreateButton("AutoPilot", 20, 130, 150, 20)
$RScreenW = 1920


; GUI MESSAGE LOOP
GUISetState(@SW_SHOW)
While 1
	
	GUISetState(@SW_SHOW)
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $optPollCharlieOre
			$PollCharlieOre = GUICtrlRead($optPollCharlieOre)
		 Case $optPollMickeyOre
			$PollMickeyOre = GUICtrlRead($optPollMickeyOre)
			;MsgBox(0, "state", StringFormat("GUICtrlRead=%d\nGUICtrlGetState=%d", GUICtrlRead($optApplication), GUICtrlGetState($optApplication)))
		 Case $btnStart
			Start("D:\Jeux\Steam\steamapps\common\eve online\launcher\launcher.exe")
			Start("D:\Jeux\Steam\steamapps\common\eve online2\launcher\launcher.exe")
			Login("EVE")
			Login("EVE")

		 case $btnCharlieCreateCan
			 TestLoop()
		 case $btnMickeyCreateCan
			$haulerloots = 10
		 case $btnHome
			$HomeRequest = 1
		 case $btnCharlieAutoPilote
			if $CharlieAutoPilote = 0 Then
			   $CharlieAutoPilote = 1
			Else
			   $CharlieAutoPilote = 0
			EndIf
	EndSwitch
	$dif = TimerDiff($begin)
	if $dif >= 2000 then 
	  Polling()
	  if BitAND(GUICtrlRead($checkCharlieMiner), $GUI_CHECKED) = $GUI_CHECKED Then
		  $result = MiningLoop("EVE - Charlie Bergamotte", $state1, $ship1)
		  $state1 = $result[0]
		  $ship1 = $result[1]
	  EndIf
	  if BitAND(GUICtrlRead($checkCharlieHauler), $GUI_CHECKED) = $GUI_CHECKED Then
		  $result = HaulerLoop("EVE - Charlie Bergamotte", $state1, $ship1)
		  $state1 = $result[0]
		  $ship1 = $result[1]
	  EndIf
	  if BitAND(GUICtrlRead($checkCharlieMinerHauler), $GUI_CHECKED) = $GUI_CHECKED Then
		  $result = HaulerAndMinerLoop("EVE - Charlie Bergamotte", $state1, $ship1)
		  $state1 = $result[0]
		  $ship1 = $result[1]
	  EndIf
	  if BitAND(GUICtrlRead($checkMickeyMiner), $GUI_CHECKED) = $GUI_CHECKED Then
		  $result = MiningLoop("EVE - Mickey Mitsumoto", $state2, $ship2)
		  $state2 = $result[0]
		  $ship2 = $result[1]
	  EndIf
	  if BitAND(GUICtrlRead($checkMickeyHauler), $GUI_CHECKED) = $GUI_CHECKED Then
		  $result = HaulerLoop("EVE - Mickey Mitsumoto", $state2, $ship2)
		  $state2 = $result[0]
		  $ship2 = $result[1]
	  EndIf
	  if BitAND(GUICtrlRead($checkMickeyMinerHauler), $GUI_CHECKED) = $GUI_CHECKED Then
		  $result = HaulerAndMinerLoop("EVE - Mickey Mitsumoto", $state2, $ship2)
		  $state2 = $result[0]
		  $ship2 = $result[1]
	   EndIf
	   
	   CargoStateSet($cargocycle)
		 If $cargocycle >= 19000 Then
			$cargostate = $full
		 EndIf	                  
;~  	  HaulerLoop("EVE - Mickey Mitsumoto")
;~  	  MiningLoop("EVE - Charlie Bergamotte")
	  $begin = TimerInit()
    endif
WEnd

Func TestLoop()
    SwitchToHauler("EVE - Mickey Mitsumoto")
	SwitchToMiner("EVE - Mickey Mitsumoto")
    SwitchToHauler("EVE - Mickey Mitsumoto")
	SwitchToMiner("EVE - Mickey Mitsumoto")
;~    MiningFolderWarp("EVE - Mickey Mitsumoto", 1, "dock")
;~ FleetMemberWarp("EVE - Mickey Mitsumoto")
;~ Jettison("EVE - Charlie Bergamotte", "full")
;~ StoreInCargo("EVE - Charlie Bergamotte")
EndFunc

Func HaulerAndMinerLoop($window, $state, $ship)
   WinMove($window, "", 0, -30)

	if $state = $InField And $ship = $miner And $cargocycle >= 16000 Then
	  MiningFolderWarp($window, 1, "dock")
	  $haulertimer = TimerInit()
	  $state = $warpingToBase
	  HaulerStateSet("Warping to base")
   EndIf
   
 if $state = $InField And $ship = $hauler And $cargostate = $full Then
	  OpenCargo($window, "full")
	  $state = $openingCargo
	  HaulerStateSet("Opening cargo")
	  
   EndIf
   
   if $state = $InField And $haulerloots = 1 Then
	  MiningFolderWarp($window, 1, "dock")
	  $haulertimer = TimerInit()
	  $state = $warpingToBase
	  HaulerStateSet("Warping to base")
   EndIf

;~    if $state = $InField And $ship = $miner And $haulerminercargoopen = 0 Then
;~ 	  OpenCargo($window, "full")
;~ 	  $state = $openingCargo
;~ 	  HaulerStateSet("Opening cargo")
;~ 	  
;~    EndIf


   if $state = $InField And $ship = $miner Then
	  TargetAsteroid($window, 1)
	  TargetAsteroid($window, 2)
	  TargetAsteroid($window, 3)
	  TargetAsteroid($window, 4)
	  Mine($window, 1, 1)
	  Mine($window, 2, 2)
	  Mine($window, 3, 3)
	  $haulertimer = TimerInit()
	  $state = $mining
	  HaulerStateSet("Mining")
   EndIf
     
	
   If $state = $warpingToBase And $ship = $hauler And TimerDiff($haulertimer) > $WarpTime Then
 	  if Unload($window) = False Then
		 return ReturnArray($state, $ship)
	  EndIf
	  $state = $docked
	  HaulerStateSet("Docked")
	  SwitchToMiner($window)
	  Sleep(1000)
	  $ship = $miner
	  $haulerloots = 0
	  $haulertimer = TimerInit()
   EndIf

   If $state = $warpingToBase And $ship = $miner And TimerDiff($haulertimer) > $WarpTime Then
	  $state = $docked
	  HaulerStateSet("Docked")
	  SwitchToHauler($window)
	  Sleep(1000)
	  $ship = $hauler
	  $haulertimer = TimerInit()
   EndIf

   if $state = $openingCargo And $ship = $hauler And $cargostate = $full Then
	  $status = LootCargo($window)
	  if $status = False Then
		 return ReturnArray($state, $ship)
	  EndIf
	  $state = $InField
	  HaulerStateSet("In Field")
	  $cargostate = $none
	  $haulerloots = 1
   EndIf
 
   if $state = $openingCargo And $ship = $miner Then
	  $status = CheckCargoOpen($window)
	  if $status = False Then
		 return ReturnArray($state, $ship)
	  EndIf
	  $state = $mining
	  HaulerStateSet("Mining")
	  $haulerminercargoopen = 1
   EndIf


   If $state = $docked Then
	  Undock($window)
	  $state = $undocking
	  HaulerStateSet("Undocking")
	  $haulertimer = TimerInit()
   EndIf
   
   If $state = $undocking And TimerDiff($haulertimer) > 20000 Then
	  if FleetMemberWarp($window) = False Then
		 return ReturnArray($state, $ship)
	  EndIf
	  $state = $warpingToField
	  HaulerStateSet("Warping to field")
	  $haulertimer = TimerInit()
   Endif
   
   If $state = $warpingToField And TimerDiff($haulertimer) > $WarpTime Then
	  $state = $InField
	  HaulerStateSet("In Field")
	  $haulerminercargoopen = 0
   EndIf

   if $state = $mining And $ship = $miner And $haulerminercargoopen = 0 Then
	  if OpenCargo($window, "full") = False Then
		 return ReturnArray($state, $ship)
	  EndIf		 
	  $state = $openingCargo
	  HaulerStateSet("Opening cargo")
	  
   EndIf
   
   if $state = $mining And TimerDiff($haulertimer) > 150000 Then
	  StopMine($window, 1)
	  StopMine($window, 2)
	  StopMine($window, 3)
	  
	  $state = $clearing
	  HaulerStateSet("Clearing")
   EndIf
   
   If $state = $clearing Then
	  
		 
		 StoreInCargo($window)
		 $cargocycle = $cargocycle + 2500

		 $state = $InField
		 HaulerStateSet("In Field")
	  
   EndIf
 
	return ReturnArray($state, $ship)
	
EndFunc

Func HaulerLoop($window, $state, $ship)
   
   WinMove($window, "", 0, -30)
   
   if $state = $docked And $ship = $miner Then
	   if SwitchToHauler($window) = False Then
		   return MakeArray($state, $ship)
	  EndIf
	   $ship = $hauler
	EndIf
   
   if $state = $openingCargo And $cargostate = $full Then
	  $status = LootCargo($window)
	  if $status = False Then
		 return ReturnArray($state, $ship)
	  EndIf
	  $state = $InField
	  HaulerStateSet("In Field")
	  $cargostate = $none
	  $haulerloots = 1
   EndIf
   
   if $state = $InField And $haulerloots = 1 Then
	  MiningFolderWarp($window, 1, "dock")
	  $haulertimer = TimerInit()
	  $state = $warpingToBase
	  HaulerStateSet("Warping to base")
   EndIf
 
  if $state = $InField And ($cargostate = $filling Or $cargostate = $full) Then
	  OpenCargo($window, "full")
	  $state = $openingCargo
	  HaulerStateSet("Opening cargo")
	  
   EndIf
   
  
   If $state = $warpingToBase And TimerDiff($haulertimer) > $WarpTime Then
	  if Unload($window) = False Then
		 return ReturnArray($state, $ship)
	  EndIf
	  $state = $docked
	  HaulerStateSet("Docked")
	  $haulerloots = 0
	  $haulertimer = TimerInit()
   EndIf
	  
   If $state = $docked And $cargostate = $full Then
	  Undock($window)
	  $state = $undocking
	  HaulerStateSet("Undocking")
	  $haulertimer = TimerInit()
   EndIf
   
   If $state = $undocking And TimerDiff($haulertimer) > 20000 Then
	  if FleetMemberWarp($window) = False Then
		 return ReturnArray($state, $ship)
	  EndIf
	  $state = $warpingToField
	  HaulerStateSet("Warping to field")
	  $haulertimer = TimerInit()
   Endif
   
   If $state = $warpingToField And TimerDiff($haulertimer) > $WarpTime Then
	  $state = $InField
	  HaulerStateSet("In Field")
   EndIf
   
	return ReturnArray($state, $ship)
	
EndFunc

Func MiningLoop($window, $state, $ship)
   
   WinMove($window, "", 0, -30)
   
   if $state = $InField And $HomeRequest = 1 Then
	  ReturnDrones($window)
	  MiningFolderWarp($window, 1, "dock")
	  return ReturnArray($state, $ship)
   EndIf
   
   if $state = $InField Then
	  TargetAsteroid($window, 1)
	  TargetAsteroid($window, 2)
	  TargetAsteroid($window, 3)
	  Mine($window, 1, 1)
	  Mine($window, 2, 2)
	  $minertimer = TimerInit()
	  $state = $mining
	  MinerStateSet("Mining")
   EndIf
   
   if $state = $mining And TimerDiff($minertimer) > 150000 Then
	  StopMine($window, 1)
	  StopMine($window, 2)
	  
	  
	  $state = $clearing
	  MinerStateSet("Clearing")
   EndIf
   
   If $state = $clearing Then
	  
	  If $cargostate = $filling Then 
		 StoreInCargo($window)
		 $cargocycle = $cargocycle + 1600

		 $state = $InField
		 MinerStateSet("In Field")
	  Endif 

	  If $cargostate = $none Then 
		 if Jettison($window, "full") = False then 
			 return ReturnArray($state, $ship)
			Endif
		 $cargostate = $filling
		 $cargocycle = 1600
		 $state = $InField
		 MinerStateSet("In Field")
	  Endif 
	  
		 If $cargocycle >= 18000 Then
			$cargostate = $full
		 EndIf	  
   EndIf
   
	return ReturnArray($state, $ship)
   
;~    Undock($window)
;~    Undock("EVE - Mickey Mitsumoto")
;~    Sleep(30000)
;~    
;~     MiningFolderWarp($window, 1, "dock")
;~    MiningFolderWarp("EVE - Mickey Mitsumoto", 1, "dock")
  
;~    TargetAsteroid($window, 1)
;~    TargetAsteroid("EVE - Mickey Mitsumoto", 1)
;~     TargetAsteroid($window, 2)
;~    TargetAsteroid("EVE - Mickey Mitsumoto", 2)
;~    TargetAsteroid($window, 3)
;~    TargetAsteroid("EVE - Mickey Mitsumoto", 3)
;~    
;~    Orbit($window, 1)
;~     Mine($window, 1, 1)
;~ 	Mine($window, 2, 2)
;~ 	Sleep(10000)
;~ 	StopMine($window, 1)
;~ 	StopMine($window, 2)
;~     
;~    Jettison($window, "full")
;~    
;~    OpenCargo("EVE - Mickey Mitsumoto", "full")

;~    LootCargo("EVE - Mickey Mitsumoto")
   
;~    FleetMemberWarp("EVE - Mickey Mitsumoto")
   
EndFunc

func ReturnArray($p1, $p2)
	Dim $result[2]
	$result[0] = $p1
	$result[1] = $p2
	return $result
EndFunc

Func SwitchToHauler($window)
   
   $x1 = 0
   $y1 = 0
   WinActivate($window)
   Sleep(100)
   $result = _ImageSearchWindow($window, "ships.bmp", 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find items menu" & @CRLF)
	  return False
   EndIf
   Sleep(400)
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")
   Sleep(400)
   $result = _ImageSearchWindow($window, "shiphauler.bmp", 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find shiphauler " & @CRLF)
	  return False
   EndIf
   Sleep(400)
   MouseMove($x1,$y1-30,3)
   Sleep(400)
  MouseMove($x1,$y1,3)
   Sleep(400)   
   MouseClick ( "right")
   Sleep(400)
   $result = _WaitForImageSearch("MakeActive.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find MakeActive menu" & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")		
	return True
EndFunc

Func SwitchToMiner($window)
   
   $x1 = 0
   $y1 = 0
   Sleep(100)
   $result = _ImageSearchWindow($window, "ships.bmp", 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find items menu" & @CRLF)
	  return False
   EndIf
   Sleep(400)
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")
   Sleep(400)
   WinActivate($window)
   $result = _ImageSearchWindow($window, "retriever.bmp", 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find retriever " & @CRLF)
	  return False
   EndIf
   Sleep(400)
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "right")
   Sleep(400)
   $result = _WaitForImageSearch("MakeActive.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find MakeActive menu" & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")	
	return True
EndFunc




Func Polling()
   if $PollCharlieOre = $GUI_CHECKED then 
	  PollNewOre("EVE - Charlie Bergamotte", 64, 260, 110, 310)
   EndIf
   
   if $PollMickeyOre = $GUI_CHECKED then 

	  PollNewOre("EVE - Mickey Mitsumoto", 64, 260, 110, 310)
   EndIf
     
   ;Sleep(2000)
EndFunc

Func PollNewOre($window, $x1, $y1, $x2, $y2)
   
	;  MouseMove($x1 ,$y1)
	  ; Check charlie ore
   $hwnd = WinGetHandle($window)
   Local $size = WinGetPos($window)
   ConsoleWrite($window & "(x,y,width,height):" & $size[0] & " " & $size[1] & " " & $size[2] & " " & $size[3] & @CRLF)

$offsetY = $size[3] - $y1 + $size[1]
   SearchArea($window, $size[0] + $x1, $size[3] - $y1 + $size[1], $size[0] +$x2, $size[3] - $y2 + $size[1])
  
EndFunc
;MsgBox(0, "X and Y are:", $coord[0] & "," & $coord[1])

Func SearchArea($window, $x1, $y1, $x2, $y2)
   $hwnd = WinGetHandle($window)
   ConsoleWrite("Search" & $x1 & " " & $y1 & " " & $x2 & " " & $y2 & @CRLF)
  ; MouseMove($x1, $y1)
 ;  Sleep(1000)
  ; MouseMove($x2, $y2)
   $coord = PixelSearch($x1, $y1, $x2, $y2 , 0xFFFFFF, 0, 0 , $hwnd)
   If @error = 0 then
	  StoreInJetCan($coord, $window)
   EndIf
   
EndFunc
;MsgBox(0, "X and Y are:", $coord[0] & "," & $coord[1])

;Drag item from pixel discovered to up relative position
Func StoreInJetCan($coord, $window)

   Trace("Store " & $window)
   $hwnd = WinActivate($window)
   MouseMove($coord[0] ,$coord[1])
   MouseClickDrag ( "left", $coord[0], $coord[1], $coord[0], 620 ) 
   
   ; open context menu
   ;Local $pos = MouseGetPos()
   ;MouseMove($pos[0] + 300 ,$pos[1])

   ;Sleep(100)
   ;Local $pos = MouseGetPos()
   ;MouseClick ( "right")
   
   ;click on Stack All
   ;Sleep(200)
   ;MouseMove($pos[0] + 40 ,$pos[1] + 57)
   ;MouseClick ( "left")

EndFunc

Func CreateNewCan($window, $xorigin)
   
   $hwnd = WinGetHandle($window)
   $coord = PixelSearch( $xorigin + 140, 794, 196, 850, 0xFFFFFF, 0, 0 , $hwnd)
   If @error = 0 then
	  StoreInJetCan($coord, $window)
   EndIf   

EndFunc


Func HaulerStateSet($text)
   GUICtrlSetData($lblGreen2, $text)
EndFunc

Func MinerStateSet($text)
   GUICtrlSetData($lblGreen, $text)
EndFunc

Func CargoStateSet($text)
   GUICtrlSetData($lblcargo, $text)
EndFunc


Func Trace($text)
   GUICtrlSetData($lblGreen, $text)
EndFunc

Func AutoPilot()
   $x1 = 0
   $y1 = 0
   
   $hwnd = WinActivate("EVE - Charlie Bergamotte")
   ConsoleWrite("AutoPilot" & @CRLF)
   $result = _ImageSearch("autoPiloteNext.bmp",1,$x1,$y1,20)
   if $result=0 Then
	  ConsoleWrite("Cannot find next jump" & @CRLF)
	  return 0
   Endif
   
   MouseMove($x1,$y1,3)
   MouseClick ( "left")
   Sleep(100)
   MouseClick ( "right")
   Sleep(100)
   $result = _WaitForImageSearch("menuJump.bmp",5, 1,$x1,$y1,0)
   if $result=0 Then
	  ConsoleWrite("Cannot find jump menu" & @CRLF)
	  return 0
   EndIf
   MouseMove($x1,$y1,3)
   MouseClick ( "left")
EndFunc

Func ReturnDrones($window)
   $x1 = 0
   $y1 = 0
   WinActivate($window)
   $result = _ImageSearchWindow($window, "dronesinlocal.bmp", 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find dronesinlocal menu" & @CRLF)
	  return False
   EndIf
   Sleep(400)
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "right")
   Sleep(400)
   $result = _WaitForImageSearch("returntodronesbay.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find returntodronesbay menu" & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")
   
EndFunc

Func Unload($window)
   $x1 = 0
   $y1 = 0
   WinActivate($window)
   WindowRelMoveYREV($window, 185, 672)
   Sleep(100)
   MouseClick("right")
   $result = _WaitForImageSearch("stackall.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find stackall menu" & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")
   Sleep(400)
   WindowRelMoveYREV($window, 185, 672)
   Sleep(100)
   MouseClick("right")
   $result = _WaitForImageSearch("selectall.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find selectall menu" & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")
   
   Sleep(100)
   $result = _ImageSearchWindow($window, "items.bmp", 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find items menu" & @CRLF)
	  return False
   EndIf
   Sleep(400)
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")
   Sleep(400)
   WindowRelMoveYREV($window, 144, 626)
   Sleep(400)
   $from = GetCoordFromWindowYREV($window, 144, 626)
   $to = GetCoordFromWindowYREV($window, 891, 550)
   
   MouseClickDrag ( "left", $from[0], $from[1], $to[0], $to[1] ) 
   Sleep(1000)
   
   return True
EndFunc
   
Func CheckCargoOpen($window)
   $x1 = 0
   $y1 = 0
   WinActivate($window)
   $result = _ImageSearchWindow($window, "lootall.bmp",1, $x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find lootall" & @CRLF)
	  return False
   Endif
   
   return True
EndFunc
   
   
Func LootCargo($window)
   $x1 = 0
   $y1 = 0
   WinActivate($window)
   $result = _ImageSearchWindow($window, "lootall.bmp",1, $x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find lootall" & @CRLF)
	  return False
   Endif
   MouseMove($x1,$y1,3)
   Sleep(300)
   MouseClick("left")
   Sleep(3000)
   
   ; ensure lootall has disapear
   $result = _ImageSearchWindow($window, "lootall.bmp",1, $x1,$y1,40)
   if $result<>0 Then
	  ConsoleWrite("lootall still there.." & @CRLF)
	  return False
   Endif
   
   return True
EndFunc

Func OpenCargo($window, $name)
   $x1 = 0
   $y1 = 0
   WinActivate($window)
   
   $result = _ImageSearchWindow($window, "lootingtab.bmp",1, $x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find tabMine" & @CRLF)
	  return False
   Endif
   MouseMove($x1,$y1,3)
   Sleep(300)
   MouseClick("left")
   $result = _WaitForImageSearch("cargo_full.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find cargo_full " & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "right")
   $result = _WaitForImageSearch("opencargo.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find opencargo " & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   Send("{SHIFTDOWN}")
   Sleep(500)
   MouseClick ( "left")
   Sleep(500)
   Send("{SHIFTUP}")
    Sleep(100)
   
   return True
   
EndFunc

Func StoreInCargo($window )
   
   $x1 = 0
   $y1 = 0
   
   WinActivate($window)
;~    WindowRelMoveYREV($window, 47, 719)
;~    Sleep(400)
;~    MouseClick("right")
;~    $result = _WaitForImageSearch("selectall.bmp",5, 1,$x1,$y1,0)
;~    if $result=0 Then
;~ 	  ConsoleWrite("Cannot find selectall menu" & @CRLF)
;~ 	  return 0
;~    EndIf
;~    MouseMove($x1,$y1,3)
;~    Sleep(400)
;~    MouseClick ( "left")
   WindowRelMoveYREV($window, 87, 726)
   $from = GetCoordFromWindowYREV($window, 87, 726)
   $to = GetCoordFromWindowYREV($window, 820, 727)
   Sleep(400)
   MouseClickDrag ( "left", $from[0], $from[1], $to[0], $to[1] ) 
   Sleep(400)
   WindowRelMoveYREV($window, 165, 726)
   $from = GetCoordFromWindowYREV($window, 165, 726)
   $to = GetCoordFromWindowYREV($window, 820, 727)
   Sleep(400)
   MouseClickDrag ( "left", $from[0], $from[1], $to[0], $to[1] ) 
   Sleep(400)
   WindowRelMoveYREV($window, 243, 726)
   $from = GetCoordFromWindowYREV($window, 243, 726)
   $to = GetCoordFromWindowYREV($window, 820, 727)
   Sleep(400)
   MouseClickDrag ( "left", $from[0], $from[1], $to[0], $to[1] ) 
EndFunc

Func Jettison($window, $name)
   $x1 = 0
   $y1 = 0
   
   WinActivate($window)
   WindowRelMoveYREV($window, 47, 719)
   Sleep(400)
   MouseClick("right")
   $result = _WaitForImageSearch("selectall.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find selectall menu" & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")
   WindowRelMoveYREV($window, 87, 726)
   Sleep(100)
   MouseClick("right")
   $result = _WaitForImageSearch("jettison.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find jettison menu" & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "left")

   $x1 = 0
   $y1 = 0
   
   WinActivate($window)
   $result = _ImageSearchWindow($window, "LootingTab.bmp",1, $x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find tabMine" & @CRLF)
	  return False
   Endif
   MouseMove($x1,$y1,3)
   Sleep(300)
   MouseClick("left")

   Sleep(2000)
   $result = _WaitForImageSearch("cargo.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find cargo menu" & @CRLF)
	  return 0
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "right")
   $result = _WaitForImageSearch("setname.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find setname menu" & @CRLF)
	  return 0
   EndIf
   MouseMove($x1,$y1,3)
   MouseClick ( "left")   
   Sleep(400)
   Send ($name, 1)
   Sleep(400)
   Send("{ENTER}")
   Sleep(400)
   
   $result = _WaitForImageSearch("cargo.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find cargo menu" & @CRLF)
	  return 0
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   MouseClick ( "right")
   
   $result = _WaitForImageSearch("opencargo.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find opencargo " & @CRLF)
	  return 0
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(400)
   Send("{SHIFTDOWN}")
   Sleep(500)
   MouseClick ( "left")
   Sleep(500)
   Send("{SHIFTUP}")
    Sleep(100)
   
   return True
   
EndFunc

func Orbit($window, $target)
   $x1 = 0
   $y1 = 0
   WinActivate($window)
   WindowRelMoveYREV($window, 694 - 100 * ($target - 1), 73)
    Sleep(100)
   MouseClick("left")  
   $result = _ImageSearchWindow($window, "orbit.bmp",1, $x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find orbit" & @CRLF)
	  return 0
   Endif
   MouseMove($x1,$y1,3)
   Sleep(100)
   MouseClick("left")    
EndFunc


Func StopMine($window, $miner)
   WinActivate($window)
   WindowRelMoveYREV($window, 621 + 50 * ($miner - 1), 657)
   Sleep(100)
   MouseClick("left")
EndFunc

Func Mine($window, $miner, $target)
   WinActivate($window)
   WindowRelMoveYREV($window, 694 - 100 * ($target - 1), 73)
    Sleep(100)
   MouseClick("left")  
   
   WindowRelMoveYREV($window, 621 + 50 * ($miner - 1), 657)
   Sleep(100)
   MouseClick("left")
EndFunc

Func TargetAsteroid($window, $item)
   $x1 = 0
   $y1 = 0
   
   WinActivate($window)
   $result = _ImageSearchWindow($window, "tabMine.bmp",1, $x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find tabMine" & @CRLF)
	  return 0
   Endif
   MouseMove($x1,$y1,3)
   Sleep(300)
   MouseClick("left")
  ; WindowRelMoveYREV($window, 845 , $y1 + 40 + 19 * ($item - 1))
   MouseMove($x1, $y1 + 40 + 19 * ($item - 1))
   Sleep(300)
   Send("{CTRLDOWN}")
   Sleep(100)
   MouseClick("left")
	Sleep(100)  
	Send("{CTRLUP}")

EndFunc

Func WindowRelMove($window, $x, $y)
   $coord = GetCoordFromWindow($window, $x, $y)
   MouseMove($coord[0], $coord[1])
EndFunc
Func WindowRelMoveYREV($window, $x, $y)
   $coord = GetCoordFromWindowYREV($window, $x, $y)
   MouseMove($coord[0], $coord[1])
EndFunc

Func Undock($window)
   WinActivate($window)
   WindowRelMove($window, 23, 38)
   Sleep(300)
   MouseClick("left")
EndFunc

Func MiningFolderWarp($window, $item, $action)
   $x1 = 0
   $y1 = 0
   
   WinActivate($window)
   $coord = GetCoordFromWindowYREV($window, 170, 155)
   MouseMove($coord[0], $coord[1])
   Sleep(500)
   MouseClick("left")
   $coord = GetCoordFromWindowYREV($window, 120, 74 + 10 * $item)
   MouseMove($coord[0], $coord[1])
   Sleep(500)
   MouseClick("right")
   Sleep(500)
   if $action = "warp" Then
	  $result = _WaitForImageSearch("Warp0m.bmp",5, 1,$x1,$y1,20)
   EndIf
   if $action = "dock" Then
	  $result = _WaitForImageSearch("dock.bmp",5, 1,$x1,$y1,20)
   EndIf
   
   if $result=0 Then
	  ConsoleWrite("Cannot find warp menu" & @CRLF)
	  return 0
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(300)
   MouseClick("left")   
EndFunc

Func FleetMemberWarp($window)
   $x1 = 0
   $y1 = 0
   WinActivate($window)
   WindowRelMoveYREV($window, 500 , 380)
   MouseClick("left")
   Sleep(300)
   $result = _ImageSearchWindow($window, "CharlieBergamotte.bmp",1, $x1,$y1,20)
   if $result=0 Then
	  ConsoleWrite("Cannot find CharlieBergamotte" & @CRLF)
	  return False
   Endif
   MouseMove($x1,$y1,3)
   Sleep(300)
   MouseClick("right")
   Sleep(500)
   $result = _WaitForImageSearch( "warpmember.bmp",5, 1,$x1,$y1,40)
   if $result=0 Then
	  ConsoleWrite("Cannot find warpmember menu" & @CRLF)
	  return False
   EndIf
   MouseMove($x1,$y1,3)
   Sleep(300)
   MouseClick("left")   
   
   return True

EndFunc

Func GetCoordFromWindow($window, $x, $y)
   Local $size = WinGetPos($window)
   Local $return[2]
   
   $return[0] = $size[0] + $x
   $return[1] = $size[3] - $y + $size[1]

   return $return

EndFunc

Func GetCoordFromWindowYREV($window, $x, $y)
   Local $size = WinGetPos($window)
   Local $return[2]
   
   $return[0] = $size[0] + $x
   $return[1] = $size[1] + $y

   return $return

EndFunc

Func _ImageSearchWindow($window, $findImage,$resultPosition,ByRef $x, ByRef $y, $tolerance)
   
   $coord = WinGetPos($window)
   ConsoleWrite("_ImageSearchWindow " & $coord[0] & " " & $coord[1] & " " & $coord[2] & " " & $coord[3] & @CRLF)
   
   return _ImageSearchArea($findImage,$resultPosition, $coord[0], $coord[1], 1900, $coord[3], $x,$y,$tolerance)
EndFunc
