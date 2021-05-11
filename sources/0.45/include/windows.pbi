; tile editor
; Windows

; PixelArtPaintArtist
Procedure Pap_UpdateBrush(tmpcolor)
  color = RGBA(Red(brush(Action)\color), Green (brush(action)\color),Blue(brush(action)\color), brush(action)\alpha)
  If StartDrawing(ImageOutput(tmpcolor))
    Box(0,0,OutputWidth(), OutputHeight(),color)
    StopDrawing()
  EndIf
  SetGadgetState(#G_WinPAP_Toolcolor, ImageID(tmpcolor))
  ProcedureReturn color
EndProcedure
Procedure PAP_UpdateCanvas()
  
  Shared PAP_canvasX, PAP_canvasY, PAP_Zoom, Pap_ShowChecker  
  z.d = PAP_Zoom/100
  cnv = #G_WinPAP_MainCanvas
  temp = CopyImage(#Image_PAPA, -1)
  w = ImageWidth(#Image_PAPA)*z
  h = ImageHeight(#Image_PAPA)*z
  ResizeImage(temp, w, h, #PB_Image_Raw)
  
  s.d = Z
  If StartDrawing(CanvasOutput(cnv))
  	; checker
    Box(0,0,OutputWidth(), OutputHeight(), RGBA(250,250,250,255))
;      For i=0 To OutputWidth()/Z 
;     	For j=0 To OutputHeight()/z
;     		If Mod(j,2)=1 Or Mod(i,2)=1
;     			Box(i*z, j*z, z, z,RGBA(150,150,150,255))
;     		EndIf
;     	Next
;     Next
;     For i=0 To (OutputWidth()/Z +4)
;       For j=0 To (OutputHeight()/z +4)
;         x.d = Mod(PAP_canvasX,s*2)+i*s*2 -j*s -2*z
;         y.d = Mod(PAP_canvasY,s*2)+j*s-2*z
;         Box (x,y,s,s,RGB(150,150,150))
;         x = Mod(PAP_canvasX,s*2)+s+ i*s*2 -j*s -2*z
;         y = Mod(PAP_canvasY,s*2)+j*s -2*z
;     	  Box (x,y,s,s,RGB(80,80,80))
;     	Next
;     Next
    
    ; the image result
    DrawAlphaImage(ImageID(temp), PAP_canvasX, PAP_canvasY)
    
    ; the grid
    DrawingMode(#PB_2DDrawing_XOr)
;     For i=0 To (w/z)
;       For j=0 To (h/z)
;         x = PAP_canvasX
;         y = PAP_canvasY
; ;         x.d = Mod(PAP_canvasX,z*2)
; ;         y.d = Mod(PAP_canvasY,z*2)
; ;         LineXY(x,Y+j*z,x+OutputWidth(),y+j*z, RGB(255,255,255))
; ;         LineXY(x+i*z,y,x+i*z,y+OutputHeight(), RGB(255,255,255)) 
;         LineXY(x,Y+j*z,x+w,y+j*z, RGB(255,255,255))
;         LineXY(x+i*z,y,x+i*z,y+h, RGB(255,255,255))
;       Next 
;     Next
    
    ; the border
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(PAP_canvasX, PAP_canvasY, w+1, h+1, RGBA(0,0,0,255))
    Box(PAP_canvasX+1, PAP_canvasY+1, w-1, h-1, RGBA(255,0,0,255))
    StopDrawing()
  EndIf
  FreeImage(temp)
EndProcedure
Procedure WinPixelArtPaint()
  
  Shared PAP_canvasX, PAP_canvasY, PAP_Zoom, Pap_ShowChecker

  w1=SetMin(WinW -200, 600)
	h1=SetMIn(WinH-150, 400)
	w1=800
	h1=500
	If OpenWindow(#WinPixelArtPaint,0,0,w1,h1,Lang("Pixel Art Paint"), #PB_Window_SystemMenu|#PB_Window_ScreenCentered, WindowID(#WinMain))
		
		x.d=5
		y.d=5
		w=50
		h=20
		wp=180
		If CreateStatusBar(#StatusBar_WInPAP,WindowID( #WinPixelArtPaint))
		  AddStatusBarField(150)
		  AddStatusBarField(150)
		  AddStatusBarField(150)
		  AddStatusBarField(150)
		EndIf
		
		; brush
		OldAction = Action
		action = 0
		brush(action)\size = 1
		brush(action)\color = 0
		brush(action)\alpha = 255
		Brush(1)\Alpha =0
		brush(1)\size = 1
		
		; add tool PanelGadget
		If PanelGadget(#G_WinPAP_PanelTool, x,y,wp, h1-40)
		  AddGadgetItem(#G_WinPAP_PanelTool, -1, lang("Tool"))
		  x=10
		  y=10
		  TrackBarGadget(#G_WinPAP_Toolsize,x,y,wp-20,h,1,20) : y+25
		  TrackBarGadget(#G_WinPAP_Toolalpha,x,y,wp-20,h,0,255) : y+25
		  SetGadgetState(#G_WinPAP_Toolsize, brush(action)\size)
		  SetGadgetState(#G_WinPAP_Toolalpha, brush(action)\alpha)
		  tmpcolor=CreateImage(-1,h,h)
		  ImageGadget(#G_WinPAP_Toolcolor,x,y,h,h,ImageID(tmpcolor)) : y+25
		  ComboBoxGadget(#G_WinPAP_Tooltype,x,y,wp-20,h) : y+25
		  AddGadgetItem(#G_WinPAP_Tooltype,-1,Lang("box"))
		  AddGadgetItem(#G_WinPAP_Tooltype,-1,Lang("circle"))
		  SetGadgetState(#G_WinPAP_Tooltype, brush(action)\type)
		  ComboBoxGadget(#G_WinPAP_ToolAction,x,y,wp-20,h) : y+25
		  AddGadgetItem(#G_WinPAP_ToolAction,-1,Lang("Paint"))
		  AddGadgetItem(#G_WinPAP_ToolAction,-1,Lang("Erase"))
		  SetGadgetState(#G_WinPAP_ToolAction, action)
		  CloseGadgetList()
		EndIf
				
		; add canvas
		ImageW = tilew
		ImageH = tileH
		If CreateImage(#Image_PAPA, ImageW, ImageH, 32, #PB_Image_Transparent)
		  tmpimg = GrabImage(#image_Tileset, #PB_Any, tilex*tilew, tiley*tileH, tilew, tileH)
		  If StartDrawing(ImageOutput(#Image_PAPA))
		    DrawingMode(#PB_2DDrawing_AllChannels)
		    DrawAlphaImage(ImageID(tmpimg),0,0)
		    StopDrawing()
		  EndIf
		  FreeImage(tmpimg)
		EndIf
		y=10
		;If ScrollAreaGadget(#G_WinPAP_MainCanvas,wp+10, y, w1-(wp+10)*2, h1-150, ImageW
		w2 = w1-(wp+10)*2
		h2 = h1-150
		If CanvasGadget(#G_WinPAP_MainCanvas, wp+10, y, w2, h2,#PB_Canvas_Keyboard) : EndIf 
		PAP_Zoom = 1900
		z.d = PAP_Zoom/100
		PAP_canvasX = 10 ; (w2-ImageW*z)/2
		PAP_canvasY = 10 ; (h2-ImageH*z)/2
		
		; update the gadgets and canvas
		color = Pap_UpdateBrush(tmpcolor)
    PAP_UpdateCanvas()
    StatusBarText(#StatusBar_WInPAP, 1, Lang("Zoom")+" : "+Str(PAP_Zoom)+"%")
    SetActiveGadget(#G_WinPAP_MainCanvas)
    
		Repeat
			event = WaitWindowEvent(1)
			EventGadget = EventGadget()
			EventType = EventType()
			z.d = PAP_Zoom/100
			
			Select event
				Case #PB_Event_Gadget
				  Select EventGadget
				    Case #G_WinPAP_ToolAction
				      Action=GetGadgetState(EventGadget)
				      color = Pap_UpdateBrush(tmpcolor)
				      SetGadgetState(#G_WinPAP_Toolsize, brush(action)\size)
				      SetGadgetState(#G_WinPAP_Toolalpha, brush(action)\alpha)
				      SetGadgetState(#G_WinPAP_Tooltype, brush(action)\type)
    				    
				    Case #G_WinPAP_Toolsize
				    	brush(action)\size=GetGadgetState(EventGadget)
				    Case #G_WinPAP_Tooltype
				    	brush(action)\type=GetGadgetState(EventGadget)
				    Case #G_WinPAP_Toolalpha
				      brush(action)\alpha=GetGadgetState(EventGadget)
				      Color = Pap_UpdateBrush(tmpcolor)
				      
				    Case #G_WinPAP_Toolcolor
				    	col = ColorRequester(brushcolor)
					    If col>-1
					    	brush(action)\color = col
								color = Pap_UpdateBrush(tmpcolor)
					    EndIf
				    Case #G_WinPAP_MainCanvas
				      cnv = #G_WinPAP_MainCanvas
				      If EventType = #PB_EventType_LeftButtonDown Or (EventType = #PB_EventType_MouseMove And GetGadgetAttribute(cnv, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)
				        ; Debug "PAP_movecanvas : "+Str(PAP_movecanvas)
				        
				        x.d = GetGadgetAttribute(cnv, #PB_Canvas_MouseX)/z 
				        y.d = GetGadgetAttribute(cnv, #PB_Canvas_MouseY)/z 
				        If PAP_movecanvas = 1
				          If EventType = #PB_EventType_LeftButtonDown 
				            PAP_StartcanvasX = x - PAP_canvasX/Z
				            PAP_StartcanvasY = Y - PAP_canvasY/Z
				          Else
				            PAP_canvasX = x*z - PAP_StartcanvasX*z
				            PAP_canvasY = y*z - PAP_StartcanvasY*z
				            PAP_UpdateCanvas()
				          EndIf
				        Else
				          
				          x -s/2-PAP_canvasX/Z
				          y -s/2-PAP_canvasY/Z
				          s = brush(action)\size
				          If GetGadgetAttribute(cnv, #PB_Canvas_Modifiers) & #PB_Canvas_Alt
				            If alt =0
				              alt = 1
				              StatusBarText(#StatusBar_WInPAP, 2, Lang("Alt")+" : "+Str(alt))
				            EndIf
				          Else
				            If alt = 1
				              alt = 0
				              StatusBarText(#StatusBar_WInPAP, 2, Lang("Alt")+" : "+Str(alt))
				            EndIf
				          EndIf
                  ; do action on canvas pap				          
				          If alt = 0
				            If StartDrawing(ImageOutput(#Image_PAPA))
				              ; color = RGBA(Red(brush(Action)\color), Green (brush(action)\color),Blue(brush(action)\color), brush(action)\alpha)
				              Select Action
				                Case 0 ; paint
				                  DrawingMode(#PB_2DDrawing_AlphaBlend)
				                Case 1 ; erase
				                  DrawingMode(#PB_2DDrawing_AlphaChannel)
				              EndSelect
				              Select brush(action)\type
				                Case 0 ; box
				                  Box(X, Y, s, s,color)
				                Case 1 ; circle
				                  Circle(x,y,s*0.5,color)
				              EndSelect
				              StopDrawing()
				            EndIf
				          Else
				            If StartDrawing(ImageOutput(#Image_PAPA))
				              If x>=0 And y>=0 And X< OutputWidth()-1 And y< OutputHeight() -1
				                brush(action)\color = Point(x,y)
				              EndIf
				              StopDrawing()
				              color = Pap_UpdateBrush(tmpcolor)
				            EndIf
				          EndIf
				          ; update
				          PAP_UpdateCanvas()
				        EndIf
				      Else
				        Select EventType
				            
				          Case #PB_EventType_MouseWheel
				            delta = GetGadgetAttribute(cnv, #PB_Canvas_WheelDelta)
				            PAP_Zoom +Delta*100
				            If PAP_Zoom< 100
				              PAP_Zoom = 100
				            ElseIf PAP_Zoom > 2000
				              PAP_Zoom=2000
				            EndIf
				            PAP_UpdateCanvas()
				            StatusBarText(#StatusBar_WInPAP, 1, Lang("Zoom")+" : "+Str(PAP_Zoom)+"%")
				            
				            
				          Case #PB_EventType_KeyUp
				            Select GetGadgetAttribute(cnv, #PB_Canvas_Key) 
				              Case #PB_Shortcut_Space     
				                PAP_movecanvas = 0
				            EndSelect
				            
				          Case #PB_EventType_KeyDown
				            Select GetGadgetAttribute(cnv, #PB_Canvas_Key) 
				              Case #PB_Shortcut_Space     
				                If PAP_movecanvas = 0
				                  PAP_movecanvas = 1
				                EndIf
				            EndSelect
				        EndSelect
				      EndIf
					EndSelect
					
				Case #PB_Event_CloseWindow
				  If GetActiveWindow() = #WinPixelArtPaint
				    quit=1
				  EndIf
				  
			EndSelect
			
		Until quit=1
		
		; reset keyboard
		alt = 0
		Ctrl = 0
		Shift = 0
		Action = OldAction
    FreeImage(tmpcolor)
		CloseWindow(#WinPixelArtPaint)
	EndIf
EndProcedure


; Map properties
Procedure GetWidth(gad)
  ProcedureReturn GadgetX(gad)+GadgetWidth(gad)
EndProcedure

Procedure WinMapProperties()
  w1=600
  h1=400
  If OpenWindow(#WinMapProperties,0,0,w1,h1,Lang("Map Properties"),#PB_Window_SystemMenu|#PB_Window_ScreenCentered,WindowID(#WinMain))
    
    x=5
    y=5
    w=50
    h=20
    If PanelGadget(#G_WinMP_Panel, x,y,w1-10, h1-40)
      x=10
      y=10
      AddGadgetItem(#G_WinMP_Panel, -1, lang("Map"))
      AddStringGadget(#G_WinMP_mapw,x,y,w,h,Lang("Map width"),Str(MapW*TileW)) : x+w+5
      AddStringGadget(#G_WinMP_maph,x,y,w,h,Lang("Map height"),Str(MapH*TileH)) 
      y+h+5 : x=10
      AddStringGadget(#G_WinMP_TileW,x,y,w,h,Lang("Set the Snap Width (in X)"),Str(TileW), Lang("Snap X")) : x=GetWidth(#G_WinMP_TileW)+5
      AddStringGadget(#G_WinMP_TileH,x,y,w,h,Lang("Set the Snap height (in Y)"),Str(TileH), Lang("Snap Y"))
      CloseGadgetList()
    EndIf
    
    
    Repeat
      event=WaitWindowEvent(1)
      EventGadget = EventGadget()
      Select event
        Case #PB_Event_Gadget
          Select EventGadget
            Case #G_WinMP_TileW
              w = Val(GetGadgetText(EventGadget))
              If w>=1
                TileW = w
              EndIf 
            Case #G_WinMP_TileH
              h = Val(GetGadgetText(EventGadget))
              If h>=1
                TileH = h
              EndIf
            Case #G_WinMP_mapw
              w=Val(GetGadgetText(EventGadget))
              If w>=tileW
                MapW = w/tileW
              EndIf
            Case #G_WinMP_maph
              h=Val(GetGadgetText(EventGadget))
              If h>=tileH
                MapH=h/TileH
              EndIf
          EndSelect
        Case #PB_Event_CloseWindow
          quit=1
      EndSelect
      
    Until quit>=1
    
    CloseWindow(#WinMapProperties)
  EndIf
  
EndProcedure




; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 317
; FirstLine = 1
; Folding = AQAAA5B9
; EnableXP