
;-- infos/changelog
; XIncludeFile "changelog.txt" 
; XIncludeFile "include\infos.pbi" 

;-- constantes
XIncludeFile "include\enumeration.pbi"
#ProgramVersion = "0.4.5"
#ProgramVersionNum = 0.4300
#ProgramRevision = 0

;-- structure
XIncludeFile "include\structures.pbi"

;-- declare
XIncludeFile "include\declare.pbi" 

;-- macro & utiles (maths....)
XIncludeFile "include\macros.pbi"

;-- for langage
XIncludeFile "include\lang.pbi" 

;-- init (Screen & image)
XIncludeFile "include\init.pbi" ;  init screen (keyboard, sprites), init image encoder/decoder, load images For GUI

;-- Variables
XIncludeFile "include\variables.pbi"


;{*** procedures
XIncludeFile "include\procedures.pbi" ;  screen et sprite & Canvas (main, for rendering preview)

;-- procedures
; contain :
; Math
; images
; Menu & StatusBar

; XIncludeFile "include\gadgets.pbi"

; Tileset, Layer, Tiles
; Screen
; XIncludeFile "include\menu.pbi" ; Menu (file, edit..) (& tile edition)
; XIncludeFile "include\windows.pbi"
;}


; open the window
If ExamineDesktops()
  WinW = DesktopWidth(0)
  w = WinW
  WinH = DesktopHeight(0)
  h = WinH
EndIf

If OpenWindow(0, 0, 0, w, h, #ProgramName+#ProgramVersion, 
              #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_Maximize)
  
  
  ;{ Add menu, gagdets, status, toolbar...
  If Options\Zoom <= 10
    Options\Zoom = 100
  EndIf
	CreateTheStatusBar()
  CreateTheMenu()
  ;{ create the screen
  Options\ToolBarH = 35
  Options\PanelLayerW = 185
  Options\PanelTileSetW = 230
  screenX = Options\PanelTileSetW
  screenY = Options\ToolBarH
  screenW = w - (screenX + 4 +Options\PanelLayerW) ; *2 : because 2 panels (TileSet, Layers)
  screenH = h - screenY - 80 - MenuHeight()-StatusBarHeight(0)
  If OpenWindowedScreen(WindowID(0), screenX, screenY, screenW, screenH) : EndIf
  ;} 
  CreateGadgets()
  ;{ add some utilities
  ; create the sprite utils (background, grid..)
  UpdateSpriteUtils()
  
  canvasX = (screenW-MapW)/2 
  canvasY = (screenH-MapH)/2 
  If canvasY > screenH - SpriteHeight(#sp_Background)
    canvasY = 0
  EndIf
  Define x, y
  ;}
  ;}
  
  Repeat
    
    Repeat 
      
      mx = WindowMouseX(0) - screenX
      my = WindowMouseY(0) - screenY
      Z.d = Options\Zoom * 0.01
      event       = WaitWindowEvent(1)
      EventGadget = EventGadget()
      EventMenu   = EventMenu()
      Autosave()
      FPS()
      Onscreen = 0
      If gad = 0
        If mx>=0 And mx<=ScreenWidth() And my>=0 And my<=ScreenHeight()
          onscreen=1 ; we are on the screen
          gad = 0    ; so, not on a gadget
        EndIf
      EndIf
      SetWindowTitle(0, Str(onscreen))
      
      gad =0
      
      Select event 
          
        Case #PB_Event_Menu
          Select EventMenu
              ;{ File
            Case #Menu_FileNew
              Doc_New(0)
            Case #Menu_FileOpen
              Doc_Open()
            Case #Menu_FileSave
              Doc_Save()
            Case #Menu_FileSaveAs
              Doc_Save(1)
            Case #Menu_FileExit
              quit =1
              ;}
              ;{ select
            Case #Menu_DeSelectAll
              Tile_Select(0)
            Case #Menu_SelectAll
              Tile_Select()
              ;}
              ;{ Edit
            Case #Menu_EditCut
               Tile_Copy()
              Tile_Erase(1)
            Case #Menu_EditCopy
              Tile_Copy()
            Case #Menu_EditPaste
              x1 = Round(((mx - CanvasX)/Z)/Options\SnapW,  #PB_Round_Down) 
              x = x1 * Options\SnapW
              y1 = Round(((my - CanvasY)/z)/Options\SnapH,  #PB_Round_Down)
              y = y1 * Options\SnapH
              ;Debug Str(x)+"/"+Str(y)
              Tile_Paste(x,y)
            Case #Menu_EditClearAll
            	Tile_Erase(0)
            Case #Menu_EditClearSelected
            	Tile_Erase(1)
            Case #Menu_EditClearLayer
            	Tile_Erase(2)
            Case #Menu_EditFillWithTile
              For i=0 To mapW/options\snapW -1
                For j=0 To MapH/options\snapH -1
                  ; TileID=1+i+(j)*MapH
                  If i=0 And j=0
                    tileId = 0
                  Else
                    TileID = ArraySize(layer(LayerId)\Tile())+1
                  EndIf
                   
                  ;With Layer(layerID)
                  ;If Not IsSprite(\sprite)
                  CreateTheTile(i*options\snapW, j*options\snapH)
                  ;EndIf
                  ;EndWith
                Next
              Next
              StatusBarUpdate()
              ;}
              ;{ View
            Case #Menu_ViewShowGrid
              Options\Grid = 1-Options\Grid
              SetMenuItemState(0, EventMenu, Options\Grid)
              
            Case #Menu_ViewZoom50
              Options\Zoom = 50 : StatusBarUpdate()
            Case #Menu_ViewZoom100
              Options\Zoom = 100 : StatusBarUpdate()
            Case #Menu_ViewZoom200
              Options\Zoom = 200 : StatusBarUpdate()
            Case #Menu_ViewReset
              canvasX = 0
              canvasY = 0
            Case #Menu_ViewCenter
              canvasX = (screenW-MApW)/2 
              canvasY = (screenH-MApH)/2 
              ;}
              ;{ Tool
            Case #Menu_ToolAddTile To #Menu_toolTestMap
              action = EventMenu - #Menu_ToolAddTile
              For i = #G_ToolB_Pen To #G_ToolB_Move
                SetGadgetState(i,0)
              Next
              SetGadgetState(#G_ToolB_Pen+action,1)
              ;}
              ;{ Windows
            Case #Menu_WindowMapProperties
              WinMapProperties()
            Case #Menu_WindowPixelArtPaint
              WinPixelArtPaint()
              ;}
              ;{ Help  
            Case #Menu_HelpAbout
              MessageRequester(Lang("About"), "Tile Editor is a free and open-source level editor, made in purebasic, by Blendman, since april 2021."+Chr(13)+
                                              Lang("Version")+" : "+#ProgramVersion+Chr(13)+
                                              Lang("Date")+" : "+FormatDate("%dd/%mm/%yyyy", #ProgramDate)+Chr(13)+
                                              "Github source and update : "+"https://github.com/blendman/TileEditor"+Chr(13)+
                                              Lang("Default tileset")+" by Michele 'Buch' Bucelli (https://opengameart.org/users/buch)")
              ;}
            Default
              MessageRequester(Lang("Info"), Lang("Not implemented"))
          EndSelect
          
        Case #PB_Event_Gadget
          ;If onscreen = 0
            gad = 1
            Select EventGadget
              ;{ toolbar  
              Case #G_ToolB_Pen To #G_ToolB_Zoom
                action = EventGadget - #G_ToolB_Pen
                For i = #G_ToolB_Pen To #G_ToolB_Zoom
                  If IsGadget(i)
                    SetGadgetState(i,0)
                  EndIf
                Next
                SetGadgetState(EventGadget, 1)
                
              Case #G_OptionSnap
                Options\Snap = GetGadgetState(EventGadget) 
                
              Case #G_OptionSnapW
                Options\SnapW = GetGadgetState(EventGadget) 
                ;TileW = GetGadgetState(EventGadget) 
                ; Debug GetGadgetState(EventGadget)
                
              Case #G_OptionSnapH
                ;TileH = GetGadgetState(EventGadget)
                Options\snapH = GetGadgetState(EventGadget)
                ; Debug GetGadgetState(EventGadget)
                ;}
                
              ;{ Panel Tile
              Case #G_TileX To #G_TileType
                Tile_SetProperties(EventGadget)
              ;}
                
              ;{ Panel Tileset
              Case #G_TileSetTileW
                Tileset(TilesetCurrent)\tileW  = Val(GetGadgetText(#G_TileSetTileW))
                tileW  = Tileset(TilesetCurrent)\tileW
                TileSet_UpdateCanvas(TileX, TileY)
                
              Case #G_TileSetTileH
                Tileset(TilesetCurrent)\TileH = Val(GetGadgetText(#G_TileSetTileH))
                TileH =  Tileset(TilesetCurrent)\TileH
                TileSet_UpdateCanvas(TileX, TileY)
                
              Case #G_TileSetUseAlpha
                Tileset(TilesetCurrent)\usealpha = GetGadgetState(EventGadget)
                Options\UseAlpha = GetGadgetState(EventGadget)
                
              Case #G_TileSetAlphacolor
                If EventType() = #PB_EventType_LeftClick       
                  color = ColorRequester(options\AlphaColor)
                  TileSet_SetAlphaColor(color)
                EndIf
                
              Case #G_TileSetSetTileIDToTile
                For j=0 To ArraySize(Layer())
                  For i=0 To ArraySize(Layer(J)\Tile())
                    With layer(j)\Tile(i)
                      If \selected = 1
                        Tile_UpdateImage(j,i)
                      EndIf
                    EndWith
                  Next
                Next
                
              Case #G_TileSetAddImg
                TileSet_AddImageToList()
                
              Case #G_TileSetChooseImg
                ImageCurrent = GetGadgetState(EventGadget)
                Tileset_SetProperties()
                ; Debug ImageCurrent
                
              Case #G_CanvasTileSet
                If EventType() = #PB_EventType_LeftButtonDown 
                  x = GetGadgetAttribute(#G_CanvasTileSet, #PB_Canvas_MouseX)
                  y = GetGadgetAttribute(#G_CanvasTileSet, #PB_Canvas_MouseY)
                  If Alt = 1
                    If StartDrawing(CanvasOutput(#G_CanvasTileSet))
                      color = Point(x,y)
                      StopDrawing()
                    EndIf
                    TileSet_SetAlphaColor(color)
                  Else
                    If StartDrawing(CanvasOutput(#G_CanvasTileSet))
                      x/TileSet(TilesetCurrent)\TileW
                      y/TileSet(TilesetCurrent)\TileH
                      TileX = x
                      TileY = y
                      Debug Str(x)+"/"+Str(y)
                      StopDrawing()
                    EndIf
                  EndIf
                  TileSet_UpdateCanvas(x, y)
                EndIf
                ;}
                
              ;{ panel Layers 
              Case #G_LayerListCanvas
                Layer_GetLayerId()
                
              Case #G_LayerLock
                Layer(layerId)\lock = GetGadgetState(EventGadget)
                Layer_UpdateList()
                
              Case #G_LayerView
                Layer(layerId)\view = GetGadgetState(EventGadget)
                Layer_UpdateList()
                
              Case #G_LayerBtnAdd
                Layer_Add()
              
              Case #G_LayerBtnDel
                Layer_Delete()
                
              Case #G_LayerBtnMoveDown
                Layer_ChangePos(-1) 
                
              Case #G_LayerBtnMoveUp
                Layer_ChangePos()
              ;}
                
            EndSelect
          ;EndIf
          
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
          ; 'zoom the map
          ; 'VerIfy If we are not over a gadget, but we are over the canvas-screen (to zoom in/out If its the case) and have not an active gadget
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
                Options\zoom + (wheelDelta / 12)     
                If Options\zoom > 5000
                  Options\zoom = 5000
                EndIf    
                If Options\zoom < 10
                  Options\zoom = 10
                EndIf 
                StatusBarUpdate()
              EndIf
            EndIf
          EndIf
          
        Case #PB_Event_CloseWindow
          quit = 1
      EndSelect
      
    Until event =0 Or quit = 1
    
    ; events for the screen
    ;{ keyboard
    If ExamineKeyboard()
      
      If KeyboardPushed(#PB_Key_LeftControl)
        ctrl = 1
      EndIf
      If KeyboardReleased(#PB_Key_LeftControl)
        ctrl = 0
      EndIf
      If KeyboardPushed(#PB_Key_LeftAlt)
        Alt = 1
      EndIf
      If KeyboardReleased(#PB_Key_LeftAlt)
        Alt = 0
      EndIf
      If KeyboardPushed(#PB_Key_LeftShift)
        ShIft = 1
      EndIf
      If KeyboardReleased(#PB_Key_LeftShift)
        ShIft = 0
      EndIf
      
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
        
        If  Options\Snap
          x1 = Round(((mx - CanvasX)/Z)/Options\SnapW,  #PB_Round_Down) 
          x = x1 * Options\SnapW
          y1 = Round(((my - CanvasY)/z)/Options\SnapH,  #PB_Round_Down)
          y = y1 * Options\SnapH
        Else
          x = (mx - CanvasX)/Z
          y = (my - CanvasY)/Z
        EndIf
        x1 = (mx - CanvasX)/Z
        y1 = (my - CanvasY)/Z
        
        tileID_byMouse = 1+x + (y)*MapH/Options\SnapH
        ;Debug tileID_byMouse
       ; Debug Str(x1)+"/"+Str(y1)
        StatusBarText(0, 2, Lang("Tile")+" : "+Str(x)+"/"+Str(y))
        
        ; do actions (add/delet/select a tile...)
        If (x>=0 And y>=0 And x<MapW And y<Maph) Or options\Snap = 0
          
          ; get the TileID
          If action <> #Action_Move
            If layerID <= ArraySize(layer())
              TileID = ArraySize(layer(LayerId)\Tile())+1
            EndIf
            
           
            j = layerID
            If action = #Action_ChangeTile
              For i = 0 To ArraySize(layer(j)\Tile())
                If x1>layer(j)\Tile(i)\x And x1<layer(j)\Tile(i)\x+layer(j)\Tile(i)\w And y1>layer(j)\Tile(i)\y And y1<layer(j)\Tile(i)\y+layer(j)\Tile(i)\h
                  TileId = i
                  Break
                EndIf
              Next
            Else
              For i = 0 To ArraySize(layer(j)\Tile())
                If x1>=layer(j)\Tile(i)\x And x1=<layer(j)\Tile(i)\x+layer(j)\Tile(i)\w And y1>=layer(j)\Tile(i)\y And y1<=layer(j)\Tile(i)\y+layer(j)\Tile(i)\h
                  TileId = i
                  Break
                EndIf
              Next
            EndIf
           
          EndIf
          ;Debug tileID
          
          Select action
            Case #Action_AddTile
              If layerID > ArraySize(Layer()) Or tileID > ArraySize(layer(layerID)\Tile()) Or NBTile = -1
                CreateTheTile(x, y)
              EndIf
              
            Case #Action_ChangeTile 
              CreateTheTile(x, y)
              
            Case #Action_DeleteTile
              If layerID <= ArraySize(Layer())
                If TileID <= ArraySize(Layer(LayerID)\Tile()) And tileID >-1 And nbTile> -1
                  If Layer(LayerID)\Tile(TileID)\sprite <> 0
                    ; delete the sprite
                    FreeSprite2(Layer(LayerID)\Tile(TileID)\sprite)
                    FreeSprite2(Layer(LayerID)\Tile(TileID)\spriteSelect)
                    If ArraySize(Layer(LayerID)\Tile())>0
                      DeleteArrayElement(Layer(LayerID)\Tile, TileID)
                      nbTile-1
                    Else
                      ReDim Layer(LayerID)\Tile(0)
                      NbTile = -1
                    EndIf
                    
                  EndIf
                EndIf
              EndIf
              
            Case #Action_SelectTile
              ; temporary for select mode.
              Tile_GetProperties(shift)
              
            Case #Action_Move
            	Tile_Move(x,y)
            
          EndSelect
          If options\Snap = 0
            clic = 0
          EndIf
          
          StatusBarUpdate()

        EndIf
        
      EndIf
    EndIf
    
    ;{ draw the screen
    
    
    ClearScreen(Options\ColorBG)
    ; draw a background to see the size of the map
    ZoomSprite(#sp_Background, z*(MapW), z*(mapH))
    DisplaySprite(#sp_Background, canvasX, canvasY)
    
    ; draw the tiles
    For i =0 To ArraySize(layer())
      For j =0 To ArraySize(layer(i)\Tile())
        If Layer(i)\View
          With Layer(i)\Tile(j)
            If \visible And IsSprite(\sprite)
              ZoomSprite(\sprite, Round(\w *z,#PB_Round_Up), Round(\H *z,#PB_Round_Up))   
              DisplayTransparentSprite(\sprite,Round(canvasx + \x * z,#PB_Round_Up) , Round(canvasy + \y * z,#PB_Round_Up))
            EndIf
            If \selected And IsSprite(\spriteSelect)
              ZoomSprite(\spriteSelect, Round(\w *z,#PB_Round_Up),  Round(\H *z,#PB_Round_Up))
              DisplayTransparentSprite(\spriteSelect, Round(canvasx + \x * z,#PB_Round_Up) , Round(canvasy + \y * z,#PB_Round_Up), 100)      
            EndIf
          EndWith
        EndIf
      Next 
    Next
    
    ; grid
    If options\Grid
      If StartDrawing(ScreenOutput())
        Screen_DrawGrid()
        StopDrawing()
      EndIf
      ;ZoomSprite(#sp_Grid, Round(z*(MapW+1)*TileW,#PB_Round_Up) , Round(z*(mapH+1)*tileH, #PB_Round_Up))
      ;DisplayTransparentSprite(#sp_Grid, canvasX, canvasY, 200)
    EndIf
    
    FlipBuffers()
    ;}
    
  Until quit = 1
  
  SaveOptions()
  
  If Options\AutoSaveIfQuit
    Autosave()
  EndIf
  
  
EndIf



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 358
; FirstLine = 107
; Folding = N-LnAGAAwB9-f3X-
; EnableXP
; UseIcon = tileeditor.ico
; Executable = _release\tileeditor0.3.exe
; Warnings = Display