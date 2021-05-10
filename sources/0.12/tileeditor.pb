; "tile editor" (based on my old project "TEO" (tile editor Orgnaisation))
; by blendman 28 april 2021
; licence mit

;{ infos

; 29.4.2021 (0.2)
;// New
; - menu : add tools : addtile, delete tile, change, select, testmap.
; - tool : delete tile
; - add zoom
; - add pan (movecanvas)
; - fill the map with current tile

; 28.4.2021 (0.1)
;// New
; - panel tileset + canvas : load image tileset, Select tileset when clic on canvas
; - screen : clic & move+buttonleft on screen : add sprite/tile with image on tileset selected
; - menu (empty)

;}


#VersionProgram = "0.2"
Enumeration
  
  ; gadgets
  #G_panelTile =0
  #G_SA_TileSheet ;  scrollarea
  #G_CanvasTileSheet
  
  #G_panelProperties
  
  ; sprite
  #sp_Background = 1
  
  ; images
  #imageTileset = 1
  
  ;{ menus
  ; file
  #Menu_fileopen =0
  #Menu_filesave
  #Menu_fileexit
  ; edit
  #Menu_EditCopy
  #Menu_EditPaste
  #Menu_EditFillWithTile
  ; view
  #Menu_ViewReset
  #Menu_ViewCenter
  ; tool
  ; <-- attention : should be the same order as the action tool !
  #Menu_toolAddTile
  #Menu_toolDeleteTile
  #Menu_toolChangeTile
  #Menu_toolSelectTile
  #Menu_toolTestMap
  ; -->
  ;}
  
  ; actions
  ; <-- attention : should be the same order as the menu tool !
  #Action_AddTile = 0
  #Action_DeleteTile
  #Action_ChangeTile
  #Action_SelectTile
  #Action_TestGame
  ; -->
  
EndEnumeration


If InitSprite() : EndIf
If InitKeyboard() : EndIf
If UsePNGImageDecoder() : EndIf

Global TileW, TileH, TileID, TileX, TileY, TileSetW, TileSetH
TileW = 32
TileH = 32

Structure sMap
  tileid.w
  layer.a
  sprite.i
  visible.a
  x.i
  y.i
EndStructure
Global MapW =20, MapH =20
Global Dim themap.sMap(MapW, MapH)

; procedures
Procedure UpdateCanvasTileSet(x=0, y=0)
  
  If StartDrawing(CanvasOutput(#G_CanvasTileSheet))
    
    DrawImage(ImageID(#imageTileset), 0, 0)
    
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x*tileW, y*tileH, tileW, tileH, RGB(255, 0,0))
    Box(x*tileW+1, y*tileH+1, tileW-2, tileH-2, RGB(0, 0,0))
    
    StopDrawing()
  EndIf
  
EndProcedure
Procedure CreateTheTile(x, y)
  sp = themap(x, y)\sprite
  If sp <=0
    sp = CreateSprite(#PB_Any, TileW, tileH)
    themap(x, y)\sprite = sp  
  EndIf
  
  If StartDrawing(SpriteOutput(sp))
    DrawingMode(#PB_2DDrawing_AllChannels)
    DrawImage(ImageID(#imageTileset), -tileX * tileW, -tileY * tileH)
    StopDrawing()
  EndIf
  themap(x, y)\visible = 1
  themap(x, y)\x = x 
  themap(x, y)\y = y
EndProcedure


; open the window
If ExamineDesktops()
  WinW = DesktopWidth(0)
  w = WinW
  WinH = DesktopHeight(0)
  h = WinH
EndIf

If OpenWindow(0, 0, 0, w, h, "Tile Editor "+#VersionProgram, 
              #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_Maximize)
  
  
  
  Zoom = 100
  ; statusbar
  If CreateStatusBar(0, WindowID(0))
    AddStatusBarField(100)
    AddStatusBarField(150)
    AddStatusBarField(150)
    AddStatusBarField(150)
    AddStatusBarField(150)
    StatusBarText(0, 0, "zoom : "+Str(zoom)+"%")
  EndIf
  
  ;{ create the menu
  CreateMenu(0, WindowID(0))
  MenuTitle("File")
  MenuTitle("Edit")
  MenuItem(#Menu_EditFillWithTile, "Fill the map with current tile")
  MenuTitle("View")
  MenuItem(#Menu_ViewReset, "Reset the View")
  MenuItem(#Menu_ViewCenter, "Center the View")
  MenuTitle("Tools")
  MenuItem(#Menu_ToolAddTile, "Add a tile"   +Chr(9)+"A")
  MenuItem(#Menu_ToolDeleteTile, "Delete a tile"   +Chr(9)+"D")
  MenuItem(#Menu_ToolChangeTile, "Change a tile"   +Chr(9)+"C")
  MenuItem(#Menu_ToolSelectTile, "Select"   +Chr(9)+"S")
  MenuTitle("Help")
  ;}
  screenX = 350
  screenY = 5
  canvasW = w - screenX - 10
  canvasH = h - screenY - 80 - MenuHeight()-StatusBarHeight(0)
  If OpenWindowedScreen(WindowID(0), screenX, screenY, canvasW, canvasH) : EndIf
  
  ;{ gadgets
  ; panel tile set
  x = 5
  y = screenY
  w = screenX-10
  h = canvasH
  If PanelGadget(#G_panelTile, x, y, w, h)
    AddGadgetItem(#G_panelTile, -1, "Tile set")
    
    If LoadImage(#imageTileset, GetCurrentDirectory()+"\data\images\LJ822U2.png")
    EndIf
    If Not IsImage(#imageTileset)
      If CreateImage(#imageTileset, 512, 512)
        If StartDrawing(ImageOutput(#imageTileset))
          ; draw random box
          wc = ImageWidth(#imageTileset)/(tileW/2)
          hc = ImageWidth(#imageTileset)/(tileH/2)
          For i =0 To wc
            For j = 0 To hc
              Box(i*tileW/2, j*tileH/2, tilew/2, tileH/2, RGB(Random(255), Random(255), Random(255)))
            Next
          Next
          
          StopDrawing()
        EndIf
      EndIf
    EndIf
    
    If IsImage(#imageTileset)
      ResizeImage(#imageTileset, ImageWidth(#imageTileset)*2, ImageHeight(#imageTileset)*2,#PB_Image_Raw)
      wc = ImageWidth(#imageTileset)+20
      hc = ImageWidth(#imageTileset)+20
    EndIf
    
    x = 5
    y = 5
    h1 = 400
    If ScrollAreaGadget(#G_SA_TileSheet, x, y,  w-15, h1, wc, hc)
      CanvasGadget(#G_CanvasTileSheet, 0, 0, wc, hc)
      ; update the canvas
      UpdateCanvasTileSet()
      CloseGadgetList()
    EndIf
    
    AddGadgetItem(#G_panelTile, -1, "Tile properties")
    x = 5
    y = 5
    CloseGadgetList()
  EndIf
  ;}
  ;{ add some utilities
  If CreateSprite(#sp_Background, 10, 10)
    If StartDrawing(SpriteOutput(#sp_Background))
      Box(0,0,OutputWidth(), OutputHeight(), RGB(150,150,150))
      StopDrawing()
    EndIf
  EndIf
  
  canvasX = (canvasW-MApW*tileW)/2 
  canvasY = (canvasH-MApH*tileH)/2 
  If canvasY > canvasH - SpriteHeight(#sp_Background)
    canvasY = 0
  EndIf
  ;}
  
  Repeat
    
    Repeat 
      
      mx = WindowMouseX(0) - screenX
      my = WindowMouseY(0) - screenY
      
      Z.d = Zoom * 0.01
      ; Debug z
      
      event = WaitWindowEvent(1)
      EventGadget = EventGadget()
      EventMenu = EventMenu()
      
      Onscreen = 0
      If mx>=0 And mx<=ScreenWidth() And my>=0 And my<=ScreenHeight()
        onscreen=1 ; we are on the screen  :)
        gad = 0 ; not on a gadget
      EndIf
      
      Select event 
          
        Case #PB_Event_Menu
          Select EventMenu()
            Case #Menu_ToolAddTile To #Menu_toolTestMap
              action = EventMenu - #Menu_ToolAddTile
              
            Case #Menu_ViewReset
              canvasX = 0
              canvasY = 0
              
            Case #Menu_ViewCenter
              canvasX = (canvasW-MApW*tileW)/2 
              canvasY = (canvasH-MApH*tileH)/2 

            Case #Menu_EditFillWithTile
              For i=0 To mapW
                For j=0 To MapH
                  With themap(i, j)
                    If Not IsSprite(\sprite)
                      CreateTheTile(i, j)
                    EndIf
                  EndWith
                Next
              Next
              
          EndSelect
          
        Case #PB_Event_Gadget
          If onscreen = 0
            gad = 1
            Select eventgadget
              Case #G_CanvasTileSheet
                If EventType() = #PB_EventType_LeftButtonDown 
                  If StartDrawing(CanvasOutput(#G_CanvasTileSheet))
                    x = GetGadgetAttribute(#G_CanvasTileSheet, #PB_Canvas_MouseX)
                    y = GetGadgetAttribute(#G_CanvasTileSheet, #PB_Canvas_MouseY)
                    x/TileW
                    y/TileH
                    TileX = x
                    TileY = y
                    Debug Str(x)+"/"+Str(y)
                    
                    StopDrawing()
                  EndIf
                  UpdateCanvasTileSet(x, y)
                EndIf
                
            EndSelect
          EndIf
          
        Case #WM_LBUTTONDOWN
          If onscreen = 1
            If clic = 0
              clic = 1
              If movecanvas =1
                oldcanvasx = mx-canvasx
                oldcanvasy = my-canvasy
              EndIf
            EndIf
          EndIf
          
        Case #WM_LBUTTONUP
          clic=0
          
        Case #WM_MOUSEWHEEL
          ; zoom the map
            ; Verify if we are not over a gadget, but we are over the canvas-screen (to zoom in/out if its the case)
          If Gad= 0
            If Onscreen ; Mx>0 And My>0 And Mx<GadgetWidth(#G_ContScreen)-1 And My<GadgetHeight(#G_ContScreen)-1 
              If EventType() = -1
                
                If startzoom = 0
                  startzoom = 1
                  OldCanvasX = mx - canvasX
                  OldCanvasY = my - canvasY
                EndIf
                
                ePar = EventwParam()
                wheelDelta.w = ((ePar>>16)&$FFFF) 
                zoom + (wheelDelta / 12)     
                If zoom > 5000
                  zoom = 5000
                EndIf    
                If zoom < 10
                  zoom = 10
                EndIf 
                StatusBarText(0, 0, "zoom : "+Str(zoom)+"%")
              EndIf
            EndIf
            
          EndIf
      EndSelect
      
    Until event =0 Or event = #PB_Event_CloseWindow
    
    ; events for the screen
    ;{ keyboard
    If ExamineKeyboard()
      If KeyboardPushed(#PB_Key_Space)
        If movecanvas =0
          movecanvas=1
        EndIf
      EndIf
      If KeyboardReleased(#PB_Key_Space)
        movecanvas=0
      EndIf
    EndIf
    ;}
    
    If clic = 1
      If movecanvas =1
        canvasX = mx- oldcanvasX
        canvasY = my- oldcanvasY
      Else
        
        x = Round(((mx - CanvasX)/Z)/TileW,  #PB_Round_Down     ) 
        y = Round(((my - CanvasY)/z)/tileH,  #PB_Round_Down     )
        ; do actions (add/delet/select a tile...)
        If x>=0 And y>=0 And x<=MapW And y<=Maph
          Select action
            Case #Action_AddTile, #Action_ChangeTile
              If themap(x, y)\sprite <= 0 Or action = #Action_ChangeTile
                sp = -1
                If action =#Action_ChangeTile And themap(x, y)\sprite > 0
                  sp = themap(x, y)\sprite
                Else
                  sp = CreateSprite(#PB_Any, TileW, tileH)
                  themap(x, y)\sprite = sp
                EndIf
                
                If sp > -1
                  CreateTheTile(x, y)
                EndIf
                ; Debug "create a tile "+Str(x)+"/"+Str(y)
              Else
                
              EndIf
              
            Case #Action_DeleteTile
              If themap(x,y)\sprite <> 0
                ; delete the sprite
                FreeSprite(themap(x,y)\sprite)
                With themap(x,y)
                  \sprite =0
                  \visible =0
                EndWith
              EndIf
              
            Case #Action_SelectTile
              If themap(x,y)\sprite <> 0
                tileid = x + y * MapW
                ; set tile properties
              EndIf
              
          EndSelect
        EndIf
      EndIf
    EndIf
    
    ;{ draw the screen
      ClearScreen(RGB(50, 50, 50))
      ; draw a background to see the size of the map
      ZoomSprite(#sp_Background, z*(MapW+1)*TileW, z*(mapH+1)*tileH)
      DisplaySprite(#sp_Background, canvasX, canvasY)
      
      ; draw the tiles
      For i =0 To MapW
        For j =0 To MapH
          With themap(i, j)
            If \visible And IsSprite(\sprite)
              ZoomSprite(\sprite, tilew *z, tileH *z)
              DisplaySprite(\sprite, canvasx + \x * tileW*z, canvasy+ \y * tileH*z)
            EndIf
          EndWith
        Next 
      Next 
      
      FlipBuffers()
      ;}
    
  Until event = #PB_Event_CloseWindow
  
EndIf

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 372
; FirstLine = 278
; Folding = +37--4v-f--4-
; EnableXP