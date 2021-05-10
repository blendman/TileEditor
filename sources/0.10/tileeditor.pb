; tile editor
; by blendman 28 april 2021
; licence mit

;{ infos

; 29.4.2021 (0.2)
;// New
; - menu : add tools : addtile, delete tile, change, select, testmap.
; - tool : delete tile

; 28.4.2021 (0.1)
;// New
: - panel tileset + canvas : load image tileset, select tileset when clic on canvas
; - screen : clic & move+buttonleft on screen : add sprite/tile with image on tileset selected
; - menu (empty)

;}


If UsePNGImageDecoder() : EndIf

Enumeration
  
  ; gadgets
  #G_panelTile =0
  #G_SA_TileSheet ;  scrollarea
  #G_CanvasTileSheet
  
  #G_panelProperties
  
  ; images
  #imageTileset = 1
  
  ;{ menus
  #Menu_fileopen =0
  #Menu_filesave
  #Menu_fileexit
  #Menu_toolAddTile
  #Menu_toolChangeTile
  #Menu_toolDeleteTile
  #Menu_toolSelectTile
  #Menu_toolTestMap
  #Menu_EditCopy
  #Menu_EditPaste
  #Menu_ViewReset
  ;}
  
  ; actions
  #Action_AddTile = 0
  #Action_DeleteTile
  #Action_SelectTile
  #Action_ChangeTile
  #Action_TestGame
  
EndEnumeration


If InitSprite() : EndIf
If InitKeyboard() : EndIf

Global TileW, TileH, TileID, TileSetW, TileSetH
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


Procedure UpdateCanvasTileSet(x=0, y=0)
  
  If StartDrawing(CanvasOutput(#G_CanvasTileSheet))
    
    DrawImage(ImageID(#imageTileset), 0, 0)
    
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x*tileW, y*tileH, tileW, tileH, RGB(255, 0,0))
    Box(x*tileW+1, y*tileH+1, tileW-2, tileH-2, RGB(0, 0,0))
    
    StopDrawing()
  EndIf
  
EndProcedure






; open the window
If ExamineDesktops()
  WinW = DesktopWidth(0)
  w = WinW
  WinH = DesktopHeight(0)
  h = WinH
EndIf

If OpenWindow(0, 0, 0, w, h, "Tile Editor", 
              #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_Maximize)
  
  
  
  
  screenX = 350
  screenY = 5
  canvasW = w - screenX - 10
  canvasH = h - screenY - 80 - MenuHeight()
  If OpenWindowedScreen(WindowID(0), screenX, screenY, canvasW, canvasH) : EndIf
  
  ;{ create the menu
  CreateMenu(0, WindowID(0))
  MenuTitle("File")
  MenuTitle("Edit")
  MenuTitle("View")
  MenuTitle("Tools")
  MenuItem(#Menu_ToolAddTile, "Add a tile"   +Chr(9)+"A")
  MenuItem(#Menu_ToolDeleteTile, "Delete a tile"   +Chr(9)+"D")
  MenuItem(#Menu_ToolChangeTile, "Change a tile"   +Chr(9)+"C")
  MenuItem(#Menu_ToolSelectTile, "Select"   +Chr(9)+"S")
  MenuTitle("Help")
  ;}
  
  ;{ gadgets
  ; panel tile set
  x = 5
  y = screenY
  w = screenX-10
  h = canvasH
  If PanelGadget(#G_panelTile, x, y, w, h)
    AddGadgetItem(#G_panelTile, -1, "Tile set")
    
    If LoadImage(#imageTileset, "LJ822U2.png")
      ResizeImage(#imageTileset, ImageWidth(#imageTileset)*2, ImageHeight(#imageTileset)*2,#PB_Image_Raw   )
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
  
  
  
  Repeat
    Repeat 
      
      mx = WindowMouseX(0) - screenX
      my = WindowMouseY(0) - screenY
      
      Z.d = Zoom * 0.01
      ; Debug z
      
      ;     x = canvasX
      ;     y = canvasY
      
      event = WaitWindowEvent(1)
      EventGadget = EventGadget()
      
      Onscreen = 0
      If mx>=0 And mx<=ScreenWidth() And my>=0 And my<=ScreenHeight()
        onscreen=1
      EndIf
      
      Select event 
          
        Case #PB_Event_Gadget
        if onscreen = 0
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
              if clic = 0
                clic = 1
                if movecanvas =1
                    oldcanvasx = canvasx
                    oldcanvasy = canvasy
                endif
              endif
          EndIf
          
        Case #WM_LBUTTONUP
          clic=0
          
        case #WM_MOUSEWHEEL
          ; zoom the map
          
      EndSelect
      
    Until event =0 Or event = #PB_Event_CloseWindow
    
    ; events for the screen
    ;{ keyboard
    ExamineKeyboard()
    if keyboardpushed(#PB_Key_Space)
        if movecanvas =0
            movecanvas=1
        endif
    endif
    If keyboardReleased(#PB_Key_Space)
        movecanvas=0
    EndIf
    ;}
    
    If clic = 1
      If movecanvas =1
          canvasx = mx- oldcanvasx
          canvasy = my- oldcanvasy
          updatescreen = 1
      Else
          
        x = mx/TileW
        y = my/tileH
        ; do actions (add/delet/select a tile...)
          If x>=0 And y>=0 And x<=MapW And y<=Maph
            Select action
                case #Action_AddTile, #Action_ChangeTile
                    If themap(x, y)\sprite <= 0 or action = #ActionChangeTile
                        
                        If action =#ActionChangeTile
                            sp = themap(x, y)\sprite
                        Else
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
                      Debug "create a tile "+Str(x)+"/"+Str(y)
                    Else
                      
                    EndIf
                    
               Case #Action_DeleteTile
                    If themap(x,y)\sprite <> 0
                        ; delete the sprite
                        FreeSprite(themap(x,y)\sprite)
                        with themap(x,y)
                            \sprite =0
                            \visible =0
                        EndWith
                    EndIf
                    
               case #Action_SelectTile
                If themap(x,y)\sprite <> 0
                  tileid = x + y * MapW
                  ; set tile properties
                EndIf
                
            EndSelect
          EndIf
      Endif
    EndIf
    
    
    ; draw the screen
    if updatemap =1
      updatemap = 0
    ClearScreen(RGB(150, 150, 150))
    
    For i =0 To MapW
      For j =0 To MapH
        With themap(i, j)
          If \visible and IsSprite(\sprite)
            ZoomSprite(\sprite, tilew *z, tileH *z)
            DisplaySprite(\sprite, canvasx + \x * tileW, canvasy+ \y * tileH)
          EndIf
        EndWith
      Next 
    Next 
    
    FlipBuffers()
    endif
    
  Until event = #PB_Event_CloseWindow
  
EndIf

; IDE Options = PureBasic 5.61 (Windows - x86)
; CursorPosition = 203
; FirstLine = 191
; Folding = -----
; EnableXP