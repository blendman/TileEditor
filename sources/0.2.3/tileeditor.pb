; "tile editor" (map editor with tileset)
; by blendman since 28 april 2021
; licence MIT

;{ infos

;--- TODO
; v 0.1 :
; ok - panel tileset (load image), draw tileset & select tile on canvas.
; ok - screen (move, zoom, draw sprite), mapw, maph, tilew, tileh. view reset, center.
; ok - tiles tool : add, delete, change, select (multi). 
; ok - tile properties : x, y, layer, visible, lock, selected, imagename, tileid (tilex/y)
; v 0.2 :
; ok - tileset : tilew, tileh, layer, usealpha, alphacolor (clic to get alphacolor)
; ok - draw sprite (tile) with alpha, by layer
; ok - tile : setpropertie with gadgets (panel tile)
; ok - tileset : add image to tileset list
; ok - file : new, open, save, saveas, exit.
; v 0.3 :
; ok - window mapproperties : mapw/h, tilew/h.
; - edit : copie/paste selection
; ok - edit : erase (all, selected, layer)
; - preference (options) save/load, windowpreference
; - edit : window change properties (x+val,y+val)
; v 0.4 :
; ok - layer combobox and buton +
; - Clic on buton layer + : open Window layer)
; - window layer (add, delete, rename, view, lock, move up/down)
; - menu file : export as level, export as pb example ?
; v 0.5 :
; ok - menu selection : select all, deselect all.
; - selection (+options) : all, by tileid, line/column, invert, by layer, selected tile visible, lock,...
; - selection (+options) : rectangle, clic. Selection add (+shift), supp(+ctrl)
; - tool move (move selection)
; v 0.6 :
; - tile animated (scroll, add tile frame, drawn animated), type (loop, ping-pong)
; - undo/redo (like script)
; v 0.7 :
; ok - window pixelartpaint (pap) : panel tool, canvas, zoom, movecanvas, grid/checker.
; ok - pixelartpaint : brush, eraser, pickcolor
; - pixelartpaint : select, layer, save image, open, clean layer, copy/paste
; v 0.8 :
; - pap : add/delete frame, play/stop animation, oignon skinning. timeline (fond, key, cursor, add/delete keyframe, copy/paste, move keyframe)
; v 0.9 :
; v 1.0 :


;--- URGENT
; - Copy/paste selected Tiles
; - Change Layer tiles 


;--- CHANGELOG

; 4.5.2021 (0.2.0)
;// New
; wip - Add : TheMap.sTheMap
; - Panel Tile : add w/H
; - Image list : add scalew/H to resize image if needed.
; - Add list Thelayer.Thelayers()
; - Change the TileW/H with gagdets on TileSet panel
; wip - Edit : copy Tiles
;// Changes
; - UpdateTileSetCanvas use TileSet\TileW & TileW
; - CreateTheTile use TileSet\TileW & TileW
; - change gadgets layer to layer combobox & buton + (to manage layers)
; - Add CreateGadgets() for main window
; - AddCheckBoxGadget() to create easily checkbox
;// Fixes
; - Tile with tileset with alpha aren't transparents (even with usealpha)
; - fixe some bugs


; 3.5.2021 (0.1.9)
;// New
; - tile : setpropertie with gadgets (panel tile), with selected Tiles.
; - Menu Selection : select ALL (Ctrl+A), deselect ALL (Ctrl+D)
; - Menu edit : erase all, selected, by layer
; - panel tileset : buton -> change the image ofselected tiles by current zone tileset
; - pixelartpaint : pickcolor (alt+clic on canvas), update brushcolor image
; - menu view : zoom 50,100,200%
; - tileset : add image to tileset list, update list
;// Changes
; - code cleanup
; - Tile get/setproperties : lock
; - When a tile \lock=1, we can't change its image.
;// Fixes
; - We cant create the tile in 0/0
; - bug when create tile on 2nd layer.

; 2.5.2021 (0.1.8)
;// New
; - Doc_open : add map
; - menu Map properties
; - Window mapproperties : gadgets MapW, MapH, TileW,TileH
; - Window pixelartpaint : panel tool (brushsize, alpha, type, color), canvas, draw on canvas, movecanvas, zoom, GrabImage from tileid and tileset.

; 1.5.2021 (0.1.7)
;// New
; - doc_New
; - doc_open : add tile.
; - add message help/about
; - addshortcuts : P, E, S, C
; - can add sprite on layer
; - sprite is colored in orange when selected (in fact another sprite is drawn, with alpha 100)
; - multiselection of tiles.
; - can select a tile -> getpropertie on panel tile
; - add sprite with transparency
; - tileset : Set coloralpha, usealpha
; - tileset : alt+clic to get the alphacolor
; - Tile panel : add gadget "type"
; - image alphacolor : clic -> change the alphacolor
;// changes
; - change Layer(LayerID)\Tile(TileID) by Layer(layer) but not with a predefined number of tile.
;// fixes
; - some fixes in the UI

; 30.4.2021 (0.1.5)
;// New
; - open doc : info, image, tileset
; - menu (empty) : merge, help/about
; - menu ok : Save, saveas, exit
; - doc_save : infos, map, image, tileset, tile
; - add button + (to add a new image to the tileset bank)
; - combobox to select the image as tileset
; - panel tileset : layer, tilew /tileh, usealpha, setalphacolor
; - panel tile : x, y, layer, usealpha, lock, visible, selected, type,

; 29.4.2021 (0.1.3)
;// New
; - menu : add tools : addtile, delete tile, change, select, testmap.
; - tool : delete tile, change tile
; - add zoom
; - add pan (movecanvas)
; - fill the map with current tile

; 28.4.2021 (0.1)
;// New
; - panel tileset + canvas : load image tileset, Select tile (w/h) when clic on canvas
; - panel tile properties (empty)
; - screen : clic & move+buttonleft on screen : add sprite/tile with image on tileset selected
; - menu (empty)

;}


#ProgramVersion = "0.2.0"
#ProgramDate      = #PB_Compiler_Date ; 04/2021
#ProgramName      = "Tile Editor"
Enumeration
  
  ; statusbar
  #StatusBar_WinMain =0
  #StatusBar_WinPAP
  
  ; Windows
  #WinMain=0
  #WinMapProperties
  #WinPixelArtPaint
  #WinOther
  
  ;{ menus 
  
  ;{ #WinMain
  ; file
  #Menu_FileNew =0
  #Menu_FileOpen
  #Menu_FileMerge
  #Menu_FileSave
  #Menu_FileSaveas
  #Menu_FileExit
  ; edit
  #Menu_EditCut
  #Menu_EditCopy
  #Menu_EditPaste
  #Menu_EditFillWithTile
  #Menu_EditClearLayer
  #Menu_EditClearAll
  #Menu_EditClearSelected
  ; view
  #Menu_ViewReset
  #Menu_ViewCenter
  #Menu_ViewZoom100
  #Menu_ViewZoom50
  #Menu_ViewZoom200
  ; Select
  #Menu_SelectAll
  #Menu_DeSelectAll
  ; windows
  #Menu_WindowMapProperties
  #Menu_WindowPixelArtPaint
  ; Help
  #Menu_HelpAbout
  #Menu_Help
  ; tool
  ; <-- attention : should be the same order as the action tool !
  #Menu_toolAddTile
  #Menu_toolDeleteTile
  #Menu_toolChangeTile
  #Menu_toolSelectTile
  #Menu_toolTestMap
  ; -->
  ;}
  
  ;{ menu #WinPixelArtPaint
  ;}
  
  
  ;}
  
  ;{ gadgets
  ; by Window
  ;{ WinMain
  ; TileSet
  #G_panelTileSet =0
  #G_SA_TileSet ;  scrollarea
  #G_CanvasTileSet
  #G_TileSetLayer
  #G_TileSetLayerAdd
  #G_TileSetTileW
  #G_TileSetTileH
  #G_TileSetUseAlpha
  #G_TileSetAlphacolor
  #G_TileSetChooseImg
  #G_TileSetAddImg
  #G_TileSetSetTileIDToTile
  #G_TileSetChoosefolder
  
  ; Tile
  #G_panelProperties
  #G_TileScroolArea
  #G_TileX
  #G_TileY
  #G_TileW
  #G_TileH
  #G_TileImagename
  #G_TileUseAlpha
  #G_TileLayer
  #G_TileLock
  #G_TileVisible
  #G_TileId
  #G_TileType
  ;}
  
  ; for all Windows
  #G_ButtonOk
  #G_ButtonCancel
  
  ;{ Win AddimagetoList
  #G_winAddImgtolist_Load
  ;#G_winAddImgtolist_New
  #G_winAddImgtolist_Remove
  #G_winAddImgtolist_ListImage
  #G_winAddImgtolist_ImageGad
  #G_winAddImgtolist_ImgScaleW
  #G_winAddImgtolist_ImgScaleH
  ;}
  
  ;{ WinMapProperties
  #G_WinMP_Panel
  #G_WinMP_mapw
  #G_WinMP_maph
  #G_WinMP_TileW
  #G_WinMP_TileH
  ;}
  
  ;{ WinPixelArtPaint
  #G_WinPAP_PanelTool
  #G_WinPAP_Toolsize
  #G_WinPAP_Toolalpha
  #G_WinPAP_Toolcolor
  #G_WinPAP_Toolscatter
  #G_WinPAP_Tooltype ; by tool action (brush :box, circle, image..)
  #G_WinPAP_ToolAction ; brush, eraser, select...
  
  
  #G_WinPAP_SAcanvas
  #G_WinPAP_MainCanvas
  
  ;}
  
  ;}
  
  ;{ sprite
  #sp_Background = 1
  ;}
  
  ;{ images
  #Image_alphaColor  = 1
  #image_Tileset
  #Image_PAPA ; for pixel art paint artist
              ;}
  
  ;{ actions
  ; <-- attention : should be the same order as the menu tool !
  #Action_AddTile = 0
  #Action_DeleteTile
  #Action_ChangeTile
  #Action_SelectTile
  #Action_TestGame
  ;} -->
  
  ;{ Selection
  #Selection_AllTiles =0
  #Selection_ByLayer
  #Selection_ByTileIMage
  #Selection_ByVisibility
  ;}
  
EndEnumeration

;{ Init
If InitSprite() : EndIf
If InitKeyboard() : EndIf
If UsePNGImageDecoder() : EndIf
If UsePNGImageEncoder() : EndIf
If UseJPEGImageDecoder() : EndIf
If UseJPEGImageEncoder() : EndIf
;}

;{ variables
Global TileW=32, TileH=32, TileID, TileX, TileY, TileSetW, TileSetH, winW, winH
Global screenX, screenY, screenW, ScreenH
;}

;{ Structure
Structure sTileset
  image.i
  w.w
  h.w
  name$
  usealpha.a
  alphacolor.i
  tileW.w
  tileH.w
EndStructure
Global Dim Tileset.sTileset(0)
Global TilesetCurrent, nbTileSet=-1, ImageCurrent

Structure sImageList
  name$
  filename$
  ; id.a
  scaleW.w
  scaleH.w
EndStructure
Global Dim TheImage.sImageList(0)

; layer and tiles
Structure sTile
  tileid.w
  layer.a
  sprite.i
  spriteSelect.i
  visible.a
  lock.a
  usealpha.a
  imagename$
  imageid.a
  w.w
  h.w
  x.i ; the X position on the Screen
  y.i ; the X position on the Screen
  TileX.w ; the X position on the tileset
  TileY.w ; the Y position on the tileset
  type.a
  selected.a
EndStructure
Structure sLayer
  Array Tile.sTile(0)
EndStructure
Global LayerId, TileID, tileID_byMouse, NBTile = -1
Global Dim Layer.sLayer(0)
Global Dim CopyTile.sLayer(0)

Structure sLayerList
  name$
  id.w
EndStructure
Global Dim TheLayers.sLayerList(0)
Global NbLayers=-1

Structure sTheMap
  w.w
  h.w
  tileW.w
  tileH.w
  name$
EndStructure
Global TheMap.sTheMap
Global MapW =20, MapH =20

Structure sOptions
  Lang$
  Docname$
  Autosave.a
  AutosaveTime.a
  ConfirmAtExit.a
  AutoSaveIfQuit.a
  DirTileset$
  TilesetImage$
  ; current document
  Layer.a
  UseAlpha.a
  AlphaColor.i
  Zoom.w
EndStructure
Global Options.sOptions
Options\DirTileset$ = "data\images\"
Options\Zoom = 100

Structure sBrush
  size.w
  alpha.a
  color.i
  type.a
EndStructure
Global Dim brush.sBrush(1) ; 2 action for the brush (pixelArtPaint window) : paint, eraser
Global Action
;}

;{ macros
Macro DeleteArrayElement(ar, el)
  For a=el To ArraySize(ar())-1
    ar(a) = ar(a+1)
  Next 
  ReDim ar(ArraySize(ar())-1)
EndMacro
;}

;{ Declaration

; utilities
Declare.l Min(a,b)
Declare SetMin(a, min)
Declare.l Max(a, b)
Declare SetMaximum(a, b)
Declare FreeSprite2(sprite)
; Init
Declare.s Lang(text$)
; Menu
Declare CreateTheMenu()
Declare CreateTheStatusBar()
; gadgets
Declare AddSpinGadget(id, x, y, w, h, min, max, tip$=#Empty$, val=0, name$=#Empty$)
Declare AddButtonGadget(id, x, y, w, h, text$, tip$=#Empty$)
Declare TileSet_AddImageToList(window=1)
Declare TileSet_UpdateCanvas(x=0, y=0)
Declare Tileset_SetProperties()
Declare TileSet_SetAlphaColor(color)
Declare Tile_GetProperties(mode=0)
Declare Tile_SetProperties(EventGadget)
Declare CreateGadgets()
Declare TileSet_UpdateTheLayerList(add=0)
; Windows
Declare WinMapProperties()
Declare WinPixelArtPaint()
; File
Declare Doc_New(window=1)
Declare Doc_Open()
Declare Doc_Save(saveas=0)
Declare Autosave()
; Select
Declare Tile_Select(All=1, SelectionType=#Selection_AllTiles)
; edit
Declare Tile_Delete(j,i,del_Element=1)
Declare Tile_Erase(mode)
; screen et tiles
Declare FPS()
Declare TileSet_GetNb()
Declare TileSet_Add()
Declare Tile_UpdateImage(j,i)
Declare CreateTheTile(x, y)
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
  
  
  Zoom = 100
	CreateTheStatusBar()
  CreateTheMenu()
  ;{ create the screen
  screenX = 350
  screenY = 5
  screenW = w - screenX - 10
  screenH = h - screenY - 80 - MenuHeight()-StatusBarHeight(0)
  If OpenWindowedScreen(WindowID(0), screenX, screenY, screenW, screenH) : EndIf
  ;} 
  CreateGadgets()
  ;{ add some utilities
  ; create a sprite background 
  If CreateSprite(#sp_Background, 10, 10)
    If StartDrawing(SpriteOutput(#sp_Background))
      Box(0,0,OutputWidth(), OutputHeight(), RGB(150,150,150))
      StopDrawing()
    EndIf
  EndIf
  
  canvasX = (screenW-MapW*tileW)/2 
  canvasY = (screenH-MapH*tileH)/2 
  If canvasY > screenH - SpriteHeight(#sp_Background)
    canvasY = 0
  EndIf
  ;}
  
  Repeat
    
    Repeat 
      
      mx = WindowMouseX(0) - screenX
      my = WindowMouseY(0) - screenY
      Z.d = Zoom * 0.01
      event       = WaitWindowEvent(1)
      EventGadget = EventGadget()
      EventMenu   = EventMenu()
      Autosave()
      FPS()
      Onscreen = 0
      If mx>=0 And mx<=ScreenWidth() And my>=0 And my<=ScreenHeight()
        onscreen=1 ; we are on the screen
        gad = 0    ; so, not on a gadget
      EndIf
      
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
            Case #Menu_EditClearAll
            	Tile_Erase(0)
            Case #Menu_EditClearSelected
            	Tile_Erase(1)
            Case #Menu_EditClearLayer
            	Tile_Erase(2)
            Case #Menu_EditFillWithTile
              For i=0 To mapW
                For j=0 To MapH
                  ; TileID=1+i+(j)*MapH
                  If i=0 And j=0
                    tileId = 0
                  Else
                    TileID = ArraySize(layer(LayerId)\Tile())+1
                  EndIf
                   
                  ;With Layer(layerID)
                  ;If Not IsSprite(\sprite)
                  CreateTheTile(i, j)
                  ;EndIf
                  ;EndWith
                Next
              Next
              ;}
              ;{ View
            Case #Menu_ViewZoom50
              Zoom = 50 : StatusBarText(0, 0, "zoom : "+Str(zoom)+"%")
            Case #Menu_ViewZoom100
              Zoom = 100 : StatusBarText(0, 0, "zoom : "+Str(zoom)+"%")
            Case #Menu_ViewZoom200
              Zoom = 200 : StatusBarText(0, 0, "zoom : "+Str(zoom)+"%")
            Case #Menu_ViewReset
              canvasX = 0
              canvasY = 0
            Case #Menu_ViewCenter
              canvasX = (screenW-MApW*tileW)/2 
              canvasY = (screenH-MApH*tileH)/2 
              ;}
              ;{ Tool
            Case #Menu_ToolAddTile To #Menu_toolTestMap
              action = EventMenu - #Menu_ToolAddTile
              ;}
              ;{ Windows
            Case #Menu_WindowMapProperties
              WinMapProperties()
            Case #Menu_WindowPixelArtPaint
              WinPixelArtPaint()
              ;}
              ;{ Help  
            Case #Menu_HelpAbout
              MessageRequester(Lang("About"), "Tile Editor is a free and open-source level editor, made in purebasic, by BLendman, since april 2021."+Chr(13)+
                                              "Version : "+#ProgramVersion+Chr(13)+
                                              "Date : "+FormatDate("%dd/%mm/%yyyy", #ProgramDate))
              ;}
            Default
              MessageRequester(Lang("Info"), Lang("Not implemented"))
          EndSelect
          
        Case #PB_Event_Gadget
          If onscreen = 0
            gad = 1
            Select EventGadget
                ;{ Panel Tile =
              Case #G_TileX To #G_TileType
                Tile_SetProperties(EventGadget)
                ;}
                
                ;{ Panel Tileset
              Case #G_TileSetTileW
                Tileset(TilesetCurrent)\tileW  = GetGadgetState(EventGadget)
                TileSet_UpdateCanvas(TileX, TileY)
                
              Case #G_TileSetTileH
                Tileset(TilesetCurrent)\TileH = GetGadgetState(EventGadget)
                TileSet_UpdateCanvas(TileX, TileY)
                
              Case #G_TileSetLayer
                Options\Layer = GetGadgetState(EventGadget)
                layerID = options\layer
                
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
                Debug ImageCurrent
                
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
          ; 'zoom the map
          ; 'VerIfy If we are not over a gadget, but we are over the canvas-screen (to zoom in/out If its the case)
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
      
      If KeyboardPushed(#PB_Key_LeftControl)
        Control = 1
      EndIf
      If KeyboardReleased(#PB_Key_LeftControl)
        Control = 0
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
        
        x = Round(((mx - CanvasX)/Z)/TileW,  #PB_Round_Down) 
        y = Round(((my - CanvasY)/z)/tileH,  #PB_Round_Down)
        tileID_byMouse = 1+x + (y)*MapH
        ; Debug tileID_byMouse
        StatusBarText(0, 2, Lang("Tile")+" : "+Str(1+x)+"/"+Str(y))
        
        ; do actions (add/delet/select a tile...)
        If x>=0 And y>=0 And x<=MapW And y<=Maph
          
          ; get the TileID
          If layerID <= ArraySize(layer())
            TileID = ArraySize(layer(LayerId)\Tile())+1
          EndIf
          
          ;For j = 0 To ArraySize(layer())
          j = layerID
            For i = 0 To ArraySize(layer(j)\Tile())
              If layer(j)\Tile(i)\x = x And layer(j)\Tile(i)\y = y
                TileId = i
                Break
              EndIf
            Next
          ;Next
          
          
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
              
          EndSelect
          
          i = TileSet_GetNb()
          StatusBarText(0, 1, "NbTile : "+Str(i))

        EndIf
      EndIf
    EndIf
    
    ;{ draw the screen
    ClearScreen(RGB(50, 50, 50))
    ; draw a background to see the size of the map
    ZoomSprite(#sp_Background, z*(MapW+1)*TileW, z*(mapH+1)*tileH)
    DisplaySprite(#sp_Background, canvasX, canvasY)
    
    ; draw the tiles
    For i =0 To ArraySize(layer())
      For j =0 To ArraySize(layer(i)\Tile())
        With Layer(i)\Tile(j)
          If \visible And IsSprite(\sprite)
            ZoomSprite(\sprite, \w *z, \H *z)
            ;If \usealpha = 0
            ;DisplaySprite(\sprite, canvasx + \x * tileW*z, canvasy+ \y * tileH*z)
            ;Else
            DisplayTransparentSprite(\sprite, canvasx + \x * tileW*z, canvasy+ \y * tileH*z)
            ;EndIf
          EndIf
          If \selected And IsSprite(\spriteSelect)
            ZoomSprite(\spriteSelect, \w *z, \H *z)
            DisplayTransparentSprite(\spriteSelect, canvasx + \x * tileW*z, canvasy+ \y * tileH*z, 100)      
          EndIf
        EndWith
      Next 
    Next 
    
    FlipBuffers()
    ;}
    
  Until event = #PB_Event_CloseWindow
  
EndIf


;{ Procedures
;{ Math
Procedure.l min(a,b)
  If a > b
    ProcedureReturn b
  EndIf
  ProcedureReturn a
EndProcedure
Procedure SetMin(a, min)
  ; to set the min value to a variable
  If a < min
    a = min
  EndIf
  ProcedureReturn a
EndProcedure
Procedure.l max(a, b)
  If a > b
    ProcedureReturn a
  EndIf
  ProcedureReturn b
EndProcedure
Procedure SetMaximum(a,max)
  ; to set the maxi for a variable
  If a > max
    a = max
  EndIf
  ProcedureReturn a
EndProcedure

Procedure FreeSprite2(sprite)
  If IsSprite(Sprite)
    FreeSprite(Sprite)
  EndIf
EndProcedure
;}

;{ init
Procedure.s Lang(text$)
  ; ' will be changed with langages
  ProcedureReturn text$
EndProcedure
;}

;{ Menu & StatusBar
Procedure CreateTheStatusBar()
  ; statusbar
  If CreateStatusBar(0, WindowID(0))
    AddStatusBarField(100)
    AddStatusBarField(150)
    AddStatusBarField(150)
    AddStatusBarField(150)
    AddStatusBarField(150)
    StatusBarText(0, 0, Lang("zoom")+" : "+Str(Options\zoom)+"%")
    StatusBarText(0, 1, "NbTile : "+Str(1+NBTile))
  EndIf
EndProcedure
Procedure CreateTheMenu()
  If CreateMenu(0, WindowID(0))
    MenuTitle(Lang("File"))
    MenuItem(#Menu_FileNew, Lang("New"))
    MenuItem(#Menu_FileOpen, Lang("Open"))
    MenuItem(#Menu_FileMerge, Lang("Merge"))
    MenuItem(#Menu_FileSave, Lang("Save"))
    MenuItem(#Menu_FileSaveAs, Lang("Save as"))
    ; MenuItem(#Menu_FileExport, Lang("Export in purebasic"))
    MenuBar()
    MenuItem(#Menu_FileExit, Lang("Exit"))
    MenuTitle(Lang("Edit"))
    MenuItem(#Menu_EditClearAll, Lang("Delete all"))
    MenuItem(#Menu_EditClearSelected, Lang("Delete selected tiles"))
    MenuItem(#Menu_EditClearLayer, Lang("Delete the tiles by layer"))
    MenuItem(#Menu_EditFillWithTile, Lang("Fill the map with current tile"))
    MenuTitle(Lang("View"))
    MenuItem(#Menu_ViewZoom50, Lang("Zoom")+" 50%")
    MenuItem(#Menu_ViewZoom100, Lang("Zoom")+" 100%")
    MenuItem(#Menu_ViewZoom200, Lang("Zoom")+" 200%")
    MenuItem(#Menu_ViewReset, Lang("Reset the View"))
    MenuItem(#Menu_ViewCenter, Lang("Center the View"))
    MenuTitle(Lang("Select"))
    MenuItem(#Menu_SelectAll, Lang("Select all tiles")+Chr(9)+"Ctrl+A")
    MenuItem(#Menu_DeSelectAll, Lang("Deselect all tiles")+Chr(9)+"Ctrl+D")
    MenuTitle(Lang("Tools"))
    MenuItem(#Menu_ToolAddTile, Lang("Paint a tile")   +Chr(9)+"P")
    MenuItem(#Menu_ToolDeleteTile, Lang("Erase a tile")  +Chr(9)+"E")
    MenuItem(#Menu_ToolChangeTile, Lang("Change a tile")   +Chr(9)+"C")
    MenuItem(#Menu_ToolSelectTile, Lang("Select")   +Chr(9)+"S")
    MenuTitle(Lang("Windows"))
    MenuItem(#Menu_WindowMapProperties, Lang("Map Properties"))
    MenuItem(#Menu_WindowPixelArtPaint, Lang("Pixel Art Paint Tool"))
    MenuTitle(Lang("Help"))
    MenuItem(#Menu_HelpAbout, Lang("About"))
  EndIf
  AddKeyboardShortcut(0, #PB_Shortcut_B, #Menu_ToolAddTile)
  AddKeyboardShortcut(0, #PB_Shortcut_E, #Menu_ToolDeleteTile)
  AddKeyboardShortcut(0, #PB_Shortcut_C, #Menu_ToolChangeTile)
  AddKeyboardShortcut(0, #PB_Shortcut_S, #Menu_ToolSelectTile)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_A, #Menu_SelectAll)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_D, #Menu_DeSelectAll)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_W, #Menu_EditClearSelected)
EndProcedure
;}

;{ gadgets
Procedure AddButtonGadget(id, x, y, w, h, text$, tip$=#Empty$)
  ButtonGadget(id, x,y,w,h,text$)
  GadgetToolTip(id,tip$)
EndProcedure
Procedure AddSpinGadget(id, x, y, w, h, min, max, tip$=#Empty$, val=0, name$=#Empty$)
  If name$<>#Empty$
    gad = TextGadget(#PB_Any, x, y, 50, h, name$+" ", #PB_Text_Right|#PB_Text_Border)
    If gad
      x+52 ; Len(name$)*12
      c= 200
      SetGadgetColor(gad, #PB_Gadget_BackColor, RGB(c, c, c)) 
    EndIf
  EndIf
  SpinGadget(id, x, y, w, h, min, max,  #PB_Spin_Numeric )
  GadgetToolTip(id, tip$)
  SetGadgetText(id, Str(val))
EndProcedure
Procedure AddStringGadget(id,x,y,w,h,tip$,text$,name$=#Empty$)
  If name$<>#Empty$
    gad = TextGadget(#PB_Any, x, y, 50, h, name$+" ", #PB_Text_Right|#PB_Text_Border)
    If gad
      x+52 ; Len(name$)*12
           ; c= 200
           ; SetGadgetColor(gad, #PB_Gadget_BackColor, RGB(c, c, c)) 
    EndIf
  EndIf
  If StringGadget(id,x,y,w,h,text$)
    GadgetToolTip(id,tip$)
  EndIf
EndProcedure
Procedure AddCheckBoxGadget(id, x, y, w, h, text$, tip$=#Empty$)
  CheckBoxGadget(id, x, y, w, h, text$)
  GadgetToolTip(id,tip$)
EndProcedure

; Tileset
Procedure TileSet_AddImageToList(window=1)
  ; Window to manage image of tileset (add, remove...)
  ok = 1
  If Window = 1
    w1=800
    h1=500
    If OpenWindow(#WinMapProperties,0,0,w1,h1,Lang("Add image to tileSet"),#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget,WindowID(#WinMain))
      
      x = 5
      y=5
      w=50
      h=25
      w2 = w1-20
      w3 = w2 - (w+5)*2
      ComboBoxGadget(#G_winAddImgtolist_ListImage, x,y,w3,h) : x = w3+10; : y+h+5 ; lang("Add image to list"), lang("Add an image to the tileset list")
      For i=0 To ArraySize(TheImage())
        AddGadgetItem(#G_winAddImgtolist_ListImage, -1, TheImage(i)\name$)
        If TheImage(i)\name$ = Tileset(TilesetCurrent)\name$
          k=i
        EndIf
      Next
      SetGadgetState(#G_winAddImgtolist_ListImage, k)
      
      AddButtonGadget(#G_winAddImgtolist_Load, x,y,w,h,lang("Add"), lang("Add an image to the tileset list")) : x+w+5
      AddButtonGadget(#G_winAddImgtolist_Remove, x,y,w,h,lang("Remove"), lang("Remove the image from the tileset list")) : y+h+5
      AddButtonGadget(#G_winAddImgtolist_ImgScaleW, x,y,w,h,lang("Remove"), lang("Remove the image from the tileset list")) : y+h+5
      AddButtonGadget(#G_winAddImgtolist_ImgScaleH, x,y,w,h,lang("Remove"), lang("Remove the image from the tileset list")) : y+h+5
      
      ; to see the image
      x=5
      
      h2 = h1-y-30
      tmp =CopyImage(#image_Tileset, #PB_Any)
      ResizeImage(tmp, w2, (ImageHeight(#image_Tileset)*w2)/ImageWidth(#image_Tileset)) 
      ImageGadget(#G_winAddImgtolist_ImageGad, x,y,w2,h2, ImageID(tmp)) ; ,lang("Add image to list"), lang("Add an image to the tileset list")
      
      Repeat
        event=WaitWindowEvent(1)
        EventGadget = EventGadget()
        
        Select event
          Case #PB_Event_Gadget
            Select EventGadget
              Case #G_winAddImgtolist_Load
                ; add a new image to the tileset list
                name$= OpenFileRequester(Lang("Open an image"),#Empty$,"Images|*.jpg;*.png;*.jpeg;*.bmp",0)
                If name$ <> #Empty$
                  nbImage = ArraySize(TheImage())+1
                  ReDim TheImage.sImagelist(nbImage)
                  TheImage(nbImage)\filename$ = name$
                  TheImage(nbImage)\name$ = GetFilePart(name$)
                  AddGadgetItem(#G_winAddImgtolist_ListImage, -1, GetFilePart(name$))
                  SetGadgetState(#G_winAddImgtolist_ListImage, nbImage)
                  FreeImage(tmp)
                  tmp =LoadImage(#PB_Any, name$)
                  ResizeImage(tmp, w2, (ImageHeight(tmp)*w2)/ImageWidth(tmp)) 
                  SetGadgetState(#G_winAddImgtolist_ImageGad, ImageID(tmp))
                EndIf
            EndSelect
          Case #PB_Event_CloseWindow
            If GetActiveWindow() = #WinMapProperties
              quit=1
            EndIf
            
        EndSelect
        
      Until quit>=1
      
      CloseWindow(#WinMapProperties)
      FreeImage(tmp)
      
      ; update gadget item list tileset
      ClearGadgetItems(#G_TileSetChooseImg)
      For i=0 To ArraySize(TheImage())
        AddGadgetItem(#G_TileSetChooseImg, i, TheImage(i)\name$)
        If Tileset(TilesetCurrent)\name$ = TheImage(i)\name$
          j=i
        EndIf
      Next
      SetGadgetState(#G_TileSetChooseImg, j)
      
    EndIf
  EndIf
; 	If ok = 2
; 		; add a new image to the tileset list
; 		name$= OpenFileRequester(Lang("Open an image"),#Empty$,"Images|*.jpg;*.png;*.jpeg;*.bmp",0)
; 		If name$ <> #Empty$
; 			nbImage +1
;       ReDim TheImage.sImageList(nbImage)
;       TheImage(nbImage)\name$ = name$
; 		EndIf
; 	EndIf
EndProcedure
Procedure TileSet_UpdateCanvas(x=0, y=0)
  
  tw = Tileset(TilesetCurrent)\tileW
  If tw <=0
    tw = tileW
  EndIf
  th = Tileset(TilesetCurrent)\tileH
  If th <=0
    th = tileH
  EndIf

  If StartDrawing(CanvasOutput(#G_CanvasTileSet))
    Box(0,0,OutputWidth(),OutputHeight(), RGB(255,255,255))
    DrawImage(ImageID(#image_Tileset), 0, 0)
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x*tW, y*tH, tW, tH, RGB(255, 0,0))
    Box(x*tW+1, y*tH+1, tW-2, tH-2, RGB(0, 0,0))
    StopDrawing()
  EndIf
  
EndProcedure
Procedure Tileset_SetProperties()
  
  For i=0 To ArraySize(Tileset())
    If Tileset(i)\name$ = TheImage(ImageCurrent)\name$
      TilesetCurrent = i
      ok=1
      Break
    EndIf
  Next
  If ok = 1
    i = TilesetCurrent
    ; SetGadgetState(#G_TileSetLayer, options\Layer )
    SetGadgetState(#G_TileSetTileW, Tileset(i)\tileW )
    SetGadgetState(#G_TileSetTileH, Tileset(i)\tileH )
    SetGadgetState(#G_TileSetUseAlpha, Tileset(i)\usealpha )
  Else
    ; not find
    FreeImage(#image_Tileset)
    If LoadImage(#image_Tileset, TheImage(ImageCurrent)\filename$)
      TileSet_UpdateCanvas()
    EndIf
  EndIf
  
EndProcedure
Procedure TileSet_SetAlphaColor(color)
  If color <> options\AlphaColor And color > -1
    options\AlphaColor = color
    Tileset(TilesetCurrent)\alphacolor = RGB(Red(color), Green(color), Blue(color))
    ; Debug Str(color)+"/"+Str(RGB(Red(color), Green(color), Blue(color)))
    If StartDrawing(ImageOutput(#Image_alphaColor))
      Box(0,0,OutputWidth(),OutputHeight(),color)
      StopDrawing()
    EndIf
    SetGadgetState(#G_TileSetAlphacolor, ImageID(#Image_alphaColor))
  EndIf
EndProcedure
Procedure Tile_SetProperties(EventGadget)
  ; change properties for some tile
  For j=0 To ArraySize(layer())
    For i =0 To ArraySize(layer(j)\Tile())
      If layer(j)\Tile(i)\selected
        With layer(j)\Tile(i)
          Select EventGadget 
            Case #G_TileW
              \w = GetGadgetState(EventGadget)
            Case #G_TileH
              \h = GetGadgetState(EventGadget)
            Case #G_TileLock
              \lock = GetGadgetState(#G_TileLock)
            Case #G_TileVisible
              \visible = GetGadgetState(#G_TileVisible)
            Case #G_TileUseAlpha
              \usealpha = GetGadgetState(#G_TileUseAlpha)
            Case #G_TileType
              \type = GetGadgetState(#G_TileType)
            Case #G_TileLayer
              ; should cut from the current layer() and add a new element to the layer(\layer)
              \layer = GetGadgetState(#G_TileLayer)
          EndSelect
          
        EndWith
      EndIf 
    Next
  Next
  ; change all propertie for the tileID
  If layerID <= ArraySize(layer())
    If tileID <= ArraySize(layer(layerID)\Tile())
      With layer(layerID)\Tile(tileID)
        \x = GetGadgetState(#G_TileX)
        \y = GetGadgetState(#G_TileY)
      EndWith
    EndIf
  EndIf
  
  
EndProcedure
Procedure Tile_GetProperties(mode=0)
  
  ; mode = 0 -> 1 tile selected
  ; mode = 1 -> multi tiles selected
  
  ; unselect the tiles
  If mode = 0
    For i=0 To ArraySize(layer())
      For j=0 To ArraySize(layer(i)\Tile())
        layer(i)\Tile(j)\selected = 0
      Next
    Next
  EndIf
  
  If layerID <= ArraySize(layer())
    If tileID <= ArraySize(layer(layerID)\Tile())
      With layer(layerID)\Tile(TileID)
        SetGadgetState(#G_TileX, \x)
        SetGadgetState(#G_TileY, \y)
        SetGadgetState(#G_TileW, \w)
        SetGadgetState(#G_TileH, \h)
        SetGadgetState(#G_TileLayer, \layer)
        SetGadgetState(#G_TileLock, \lock)
        SetGadgetState(#G_TileVisible, \visible)
        SetGadgetState(#G_TileUseAlpha, \usealpha)
        SetGadgetState(#G_TileType, \type)
        \selected = 1
      EndWith
    EndIf
  EndIf
  
EndProcedure

; main window
Procedure TileSet_UpdateTheLayerList(add=0)
  
  If add=0
    ; create at astart, we need at least 1 layer :)
    TheLayers(0)\name$ = "0 - Base"
    LayerId = 0
    
  Else
    ; add a new layer to the list
    ; open a window to manager the layers
    
  EndIf
  
  ; Update the layer list gadget (tileset panel)
  ClearGadgetItems(#G_TileSetLayer)
  For i=0 To ArraySize(TheLayers())
    AddGadgetItem(#G_TileSetLayer, i,TheLayers(i)\name$ )
  Next
  SetGadgetState(#G_TileSetLayer, LayerId)
  
EndProcedure
Procedure CreateGadgets()
   ;{ create gadgets
  ; panel tile set
  x = 5
  y = screenY
  w = screenX-10
  h = screenH
  If PanelGadget(#G_panelTileSet, x, y, w, h)
    
    ;{ TileSet
    AddGadgetItem(#G_panelTileSet, -1, lang("Tileset"))
    
    ;{ add an image to test
    ;<-- temporary To test the program
    If LoadImage(#image_Tileset, GetCurrentDirectory()+ Options\DirTileset$ +"LJ822U2.png")
      nbImage = -1
      nbImage +1
      ReDim TheImage.sImageList(nbImage)
      TheImage(nbImage)\name$ = "LJ822U2.png"
      TheImage(nbImage)\filename$ = GetCurrentDirectory()+ Options\DirTileset$ +"LJ822U2.png"
      TilesetCurrent = nbImage
    EndIf
    If Not IsImage(#image_Tileset)
      If CreateImage(#image_Tileset, 512, 512)
        If StartDrawing(ImageOutput(#image_Tileset))
          ; draw random box
          wc = ImageWidth(#image_Tileset)/(tileW/2)
          hc = ImageWidth(#image_Tileset)/(tileH/2)
          For i =0 To wc
            For j = 0 To hc
              Box(i*tileW/2, j*tileH/2, tilew/2, tileH/2, RGB(Random(255), Random(255), Random(255)))
            Next
          Next
          StopDrawing()
        EndIf
      EndIf
    EndIf
    If IsImage(#image_Tileset)
      ResizeImage(#image_Tileset, ImageWidth(#image_Tileset)*2, ImageHeight(#image_Tileset)*2,#PB_Image_Raw)
      wc = ImageWidth(#image_Tileset)+20
      hc = ImageWidth(#image_Tileset)+20
    EndIf
    ; -->
    ;}
    
    x = 5
    y = 5
    h1 = 400
    h2 = 25
    w1 = w-15
    w2 = 70
    w3 = 120
    If ComboBoxGadget(#G_TileSetChooseImg, x, y, w1-60, h2)
      ;       If ExamineDirectory(0, GetCurrentDirectory()+ Options\DirTileset$, "*.*") ;"*.jpg;*.png;*.bmp;*.jpeg")  
      ;         While NextDirectoryEntry(0)
      ;           If DirectoryEntryType(0) = #PB_DirectoryEntry_File
      ;             nbImage +1
      ;             ReDim TheImage$(nbImage)
      ;             TheImage$(nbImage) = DirectoryEntryName(0) 
      ;             Debug TheImage$(nbImage)
      ;             AddGadgetItem(#G_TileSetChooseImg, -1, TheImage$(nbImage))
      ;             If Options\TilesetImage$ = TheImage$(nbImage)
      ;               i = nbImage
      ;             EndIf
      ;           EndIf
      ;         Wend
      ;         FinishDirectory(0)
      ;        EndIf
      For i=0 To ArraySize(TheImage())
        AddGadgetItem(#G_TileSetChooseImg, -1, TheImage(i)\name$)
        If Options\TilesetImage$ = TheImage(i)\name$
          j=i
        EndIf
      Next
      SetGadgetState(#G_TileSetChooseImg, j)
      
    EndIf
    x+GadgetWidth(#G_TileSetChooseImg)+5
    AddButtonGadget(#G_TileSetAddImg, x, y, h2, h2, "+",Lang("Open the image window"))
    x+h2+5
    AddButtonGadget(#G_TileSetSetTileIDToTile, x, y, h2, h2, "->",Lang("Set the Tiled image to the tiles selected") )
    x = 5 
    y+h2+5
    If ScrollAreaGadget(#G_SA_TileSet, x, y, w1, h1, wc, hc, #PB_ScrollArea_Flat)
      CanvasGadget(#G_CanvasTileSet, 0, 0, wc, hc)
      ; update the canvas
      TileSet_UpdateCanvas()
      CloseGadgetList()
    EndIf
    y+h1+5
    
    ComboBoxGadget(#G_TileSetLayer, x, y, w3, h2) :  x+w3+5
    GadgetToolTip(#G_TileSetLayer, Lang("Select the current Layer to add a tile on"))
    TileSet_UpdateTheLayerList()
    
    AddButtonGadget(#G_TileSetLayerAdd, x, y, h2, h2, Lang("+"), Lang("Set the layer (depth) For the current tile")) :  y+h2+5
    x = 5
    AddSpinGadget(#G_TileSetTileW, x, y, w2, h2, 1, 10000, lang("Set the width Tile (for the image)"), TileW) :  x+w2+5
    AddSpinGadget(#G_TileSetTileH, x, y, w2, h2, 1, 10000, lang("Set the height Tile (for the image)"), tileH):  x+w2+5
    x = 5
    y+h2+5
    AddCheckBoxGadget(#G_TileSetUseAlpha, x, y, w3, h2, Lang("Custom alpha"), Lang("Use Custom alpha for tileset (alt+clic on the tileset image)"))
    y+h2+5
    If CreateImage(#Image_alphaColor, h2, h2) : EndIf
    ImageGadget(#G_TileSetAlphacolor, x, y, h2, h2, ImageID(#Image_alphaColor))
    GadgetToolTip(#G_TileSetAlphacolor, Lang("Set the transparency color"))
    
    
    TileSet_Add()

    ;}
    
    ;{ Tile
    AddGadgetItem(#G_panelTileSet, -1, "Tile properties")
    x = 5
    y = 5
    If ScrollAreaGadget(#G_TileScroolArea, x, y, w1-20, h1, w1-40, hc, #PB_ScrollArea_Flat)
      AddSpinGadget(#G_TileX, x, y, w2, h2, 0, MapW, lang("x position of Tile"), 0, lang("X")) :  x=GadgetX(#G_TileX)+w2+5
      AddSpinGadget(#G_TileY, x, y, w2, h2, 0, MapH, lang("y position of Tile"), 0, lang("Y")) :  x+w2+5
      y +h2 +5
      x = 5
      AddSpinGadget(#G_TileW, x, y, w2, h2, 0, 8096, lang("Tile Width"), 0, lang("W")) :  x=GadgetX(#G_TileW)+w2+5
      AddSpinGadget(#G_TileH, x, y, w2, h2, 0, 8096, lang("Tile Height"), 0, lang("H")) :  x+w2+5
      y +h2 +5
      x = 5
      AddSpinGadget(#G_TileLayer, x, y, w2, h2, 0, MapH, lang("Layer of the Tile"), 0, lang("Layer")) :  x=GadgetX(#G_TileLayer)+w2+5
      AddSpinGadget(#G_TileType, x, y, w2, h2, 0, MapH, lang("Type of the Tile (You use it to define some action for tile (teleporter, chest, pnj...)"), 0, lang("Type")) :  x+w2+5
      y +h2 +5
      x = 5
      CheckBoxGadget(#G_TileUseAlpha, x, y, w3, h2, Lang("Use alpha")) : x+w3+5
      y +h2 +5
      x = 5
      CheckBoxGadget(#G_TileVisible, x, y, w3, h2, Lang("Visible"), 1) : x+w3+5
      CheckBoxGadget(#G_TileLock, x, y, w3, h2, Lang("Lock"), 1) : x+w3+5
      CloseGadgetList()
    EndIf
    CloseGadgetList()
    ;}
    
  EndIf
  ;}
EndProcedure
;}

;{ Screen & Tiles
Procedure FPS()
  Static ze_second, ze_fps
  ss = Second(Date())
  ze_fps+1
  If ze_second <> ss
    ze_second = ss
    SetWindowTitle(0, #ProgramName+#ProgramVersion+" - FPS: "+Str(ze_FPS))
    ;" - "+doc\name$+
    ze_fps=0
  EndIf
EndProcedure
; tile & tileset
Procedure TileSet_GetNb()
  If ArraySize(layer(layerID)\Tile()) = 0 And NbTile = -1
    n = 0
  Else
    n = ArraySize(layer(layerID)\Tile())+1
  EndIf
  ProcedureReturn n
EndProcedure
Procedure TileSet_Add()
  
  ; add the tilesetIf not add to tileset bank
  ok =1
  If nbTileSet =-1
    nbTileSet = 0
    i=nbTileSet
    ReDim Tileset.sTileset(i)
    TilesetCurrent = i
  Else
    For i=0 To ArraySize(Tileset())
      If Tileset(i)\name$ = TheImage(ImageCurrent)\name$
        ok =0
        Break
      EndIf
    Next
    
    If ok = 1
      nbTileSet = ArraySize(Tileset())+1
      i=nbTileSet
      ReDim Tileset.sTileset(i)
      TilesetCurrent = i
    EndIf
    
  EndIf
  If ok = 1
     With Tileset(i)
      \name$ = TheImage(ImageCurrent)\name$
      \tileH = GetGadgetState(#G_TileSetTileW)
      \tileW = GetGadgetState(#G_TileSetTileH)
      \alphacolor =  Options\AlphaColor ; should be the gadget to define the alphacolor on the tileset panel
      \usealpha = GetGadgetState(#G_TileSetUseAlpha ) ; Options\UseAlpha     
      \w = ImageWidth(#image_Tileset)                 ; should be the gadget to define w
      \h = ImageHeight(#image_Tileset)                ; should be the gadget to define h
    EndWith
  EndIf
EndProcedure
Procedure Tile_UpdateImage(j,i)
  sp = layer(j)\Tile(i)\sprite
  If IsSprite(sp)
    If StartDrawing(SpriteOutput(sp))
      DrawingMode(#PB_2DDrawing_AllChannels)
      DrawAlphaImage(ImageID(#image_Tileset), -tileX * Tileset(TilesetCurrent)\tileW, -tileY * Tileset(TilesetCurrent)\tileH)
      StopDrawing()
    EndIf
  EndIf
EndProcedure
Procedure CreateTheTile(x, y)
  
  If TileID <=ArraySize(Layer(LAyerId)\Tile())
    If Layer(LayerId)\Tile(TileID)\lock = 1
      ProcedureReturn 0
    EndIf
  EndIf
  
  TileSet_Add()
  
  ; create the layer array If needed
  If layerID > ArraySize(Layer())
    ReDim Layer.slayer(layerID)
  EndIf
  
  ; create the sprite If needed
  If Nbtile = -1
    TileID = 0
  EndIf
  
  If TileID > ArraySize(Layer(layerID)\Tile())
    ReDim Layer(layerID)\Tile.sTile(TileId)
  EndIf  
  FreeSprite2(Layer(layerID)\Tile(TileId)\sprite)
  FreeSprite2(Layer(layerID)\Tile(TileId)\spriteSelect)
  Layer(layerID)\Tile(TileId)\sprite = 0
  Layer(layerID)\Tile(TileId)\spriteSelect = 0
  
  
  
  tw = tileW ; TileSet(TilesetCurrent)\tileW
  th = tileH ; TileSet(TilesetCurrent)\tileH
  
  sp = Layer(LayerID)\Tile(TileID)\sprite
  If sp <=0
    spSelect = CreateSprite(#PB_Any, 4, 4)
    sp = CreateSprite(#PB_Any, tW, tH,#PB_Sprite_AlphaBlending )
    If TileSet(TilesetCurrent)\usealpha = 1
      TransparentSpriteColor(sp, Tileset(TilesetCurrent)\alphacolor)
    EndIf
    
    Layer(LayerID)\Tile(TileID)\sprite = sp  
    Layer(LayerID)\Tile(TileID)\spriteSelect = spSelect  
    
    If StartDrawing(SpriteOutput(spSelect))
      Box(0,0,OutputWidth(), OutputHeight(), RGB(255, 128, 0))
      StopDrawing()
    EndIf
  EndIf
  Tile_UpdateImage(LayeriD, tileID)
  
  ; then add the tile properties
  Layer(LayerID)\Tile(TileID)\visible = 1
  Layer(LayerID)\Tile(TileID)\Lock = 0
  Layer(LayerID)\Tile(TileID)\layer = Options\Layer
  Layer(LayerID)\Tile(TileID)\tileid = tileID_byMouse ; TileX +tileY*TileW
  Layer(LayerID)\Tile(TileID)\imagename$ = Tileset(TilesetCurrent)\name$
  Layer(LayerID)\Tile(TileID)\usealpha = Tileset(TilesetCurrent)\usealpha
  Layer(LayerID)\Tile(TileID)\x = x 
  Layer(LayerID)\Tile(TileID)\y = y
  Layer(LayerID)\Tile(TileID)\w = tw
  Layer(LayerID)\Tile(TileID)\h = th
  Layer(LayerID)\Tile(TileID)\TileX = tileX
  Layer(LayerID)\Tile(TileID)\TileY = tileY
  Layer(layerID)\Tile(TileId)\selected = 0

  NBTile = TileID

EndProcedure
;}

;{ Menu (& tile edit)
; File
Procedure Doc_New(window=1)
  ; open a window with some parameters
  If window = 1
  EndIf
  ; free the document and create the new
  If ok = 1 Or window = 0
    ; free the sprite
    For i=0 To ArraySize(layer())
      For j=0 To ArraySize(layer(i)\Tile())
        With layer(i)\Tile(j)
          FreeSprite2(\sprite)
          FreeSprite2(\spriteSelect)
        EndWith
      Next
    Next
    ; free array
    nbImage =-1
    nbTileSet =-1
    NBTile =-1
    TileID = 0
    LayerId = 0
    FreeArray(Layer())
    FreeArray(CopyTile())
    ;     FreeArray(Tileset())
    ;     FreeArray(TheImage())
    Global Dim Layer.sLayer(0)
    Global Dim CopyTile.sLayer(0)
    ReDim Tileset.sTileset(0)
    ReDim TheImage.sImageList(0)
  EndIf
  
EndProcedure
Procedure Doc_Open()
  Filter$ = "All|*.txt;*.ted|tile editor document (*.ted)|*.ted|texte (*.txt)|"
  name$ = OpenFileRequester(Lang("Open a document"), #Empty$, Filter$, 0)
  If name$<>#Empty$
    ext$ =GetExtensionPart(name$)
    If ReadFile(0, name$)
      d$=","
      Doc_New(0)
      
      While Eof(0) =0
        line$ = ReadString(0)
        index$ = StringField(line$, 1, d$)
        Select index$
          Case "info"
            
          Case "image"
            nbImage+1
            i=nbImage
            ReDim TheImage.sImageList(i)
            u=2
            With TheImage(i)
              \name$ = StringField(line$, u, d$) : u+1
              ; \id = Val(StringField(line$, 3, d$))
              \scaleW = Val(StringField(line$, u, d$)) : u+1
              \scaleH = Val(StringField(line$, u, d$)) : u+1
            EndWith
            
          Case "map"
            ;  WriteStringN(0, "map,"+Str(MapW)+d$+Str(MapH)+d$+Str(TileW)+d$+Str(TileH)+d$)
            u=2
            w = Val(StringField(line$, u, d$)) : u+1
            h = Val(StringField(line$, u, d$)) : u+1
            tw = Val(StringField(line$, u, d$)) : u+1
            th = Val(StringField(line$, u, d$)) : u+1
            If w <=0 : w = 10 : EndIf
            If h <=0 : h = 10 : EndIf
            MapW = SetMin(w, 1)
            MapH = SetMin(h, 1)
            If tw <=0 : tw = 32 : EndIf
            If th <=0 : th = 32 : EndIf
            TileW = SetMin(tw, 1)
            TileH = SetMin(th, 1)
            
          Case "tileset"
            nbTileSet+1
            i=nbTileSet
            ReDim Tileset.sTileset(i)
            With Tileset(i)
              u=2
              \name$ = StringField(line$, 2, d$) : u+1
              \w = Val(StringField(line$, u, d$)) : u+1
              \h = Val(StringField(line$, u, d$)) : u+1
              \usealpha = Val(StringField(line$, u, d$)) : u+1
              \alphacolor = Val(StringField(line$, u, d$)) : u+1
              \tileW = Val(StringField(line$, u, d$)) : u+1
              \tileW = Val(StringField(line$, u, d$)) : u+1
            EndWith
            
          Case "tile"
            ; get the layer
            u=2
            j = Val(StringField(line$, u, d$)) : u+1
            layerID = j
            ; create the layer and the tile
            If j > ArraySize(Layer())
              ReDim Layer.sLayer(J)
            EndIf
            
            ; add a tile to the layer
            x = Val(StringField(line$, u, d$)) : u+1
            y = Val(StringField(line$, u, d$)) : u+1
            TileX = Val(StringField(line$, u, d$)) : u+1
            TileY = Val(StringField(line$, u, d$)) : u+1
            If NBTile >=0
              TileID = ArraySize(layer(LayerId)\Tile())+1
            EndIf
            CreateTheTile(x, y)
            ; ReDim Layer(j)\Tile.sTile(i)
            
            With Layer(j)\Tile(i)
              \imagename$ = StringField(line$, u, d$) : u+1
              \tileid = Val(StringField(line$, u, d$)) : u+1
              \usealpha = Val(StringField(line$, u, d$)) : u+1
              \lock = Val(StringField(line$, u, d$)) : u+1
              \visible = Val(StringField(line$, u, d$)) : u+1
              \type = Val(StringField(line$, u, d$)) : u+1
            EndWith
            
        EndSelect
      Wend
      
      CloseFile(0)
    EndIf
  EndIf
EndProcedure
Procedure Doc_Save(saveas=0)
  
  Filter$ = "All|*.txt;*.ted|tile editor document (*.ted)|*.ted|texte (*.txt)|"
  If Options\Docname$ <>#Empty$ And saveas=0
    name$ =Options\Docname$
  Else
    name$ = SaveFileRequester(Lang("Save the document"), #Empty$, Filter$, 0)
  EndIf
  If name$<>#Empty$
    If OpenFile(0, "Test.txt")
      d$ = ","
      ; add information
      WriteStringN(0, "info,"+#ProgramVersion+d$)
      ; +FormatDate("%dd/%mm/%yyyy", Date())+d$
      
      ; the Map
      WriteStringN(0, "map,"+Str(MapW)+d$+Str(MapH)+d$+Str(TileW)+d$+Str(TileH)+d$)
      
      ; images
      For i=0 To ArraySize(TheImage())
        With TheImage(i)
          info$ = "image,"+\name$+d$+Str(\scaleW)+d$+Str(\scaleH)+d$
          WriteStringN(0, info$)
        EndWith
      Next
      
      ; tileset
      For i=0 To ArraySize(Tileset())
        With Tileset(i)
          info$ = "tileset,"+\name$+d$+Str(\w)+d$+Str(\h)+d$+Str(\usealpha)+d$+Str(\alphacolor)+d$+Str(\tileW)+d$+Str(\tileW)+d$
          WriteStringN(0, info$)
        EndWith
      Next
      
      ; the tile
      For i = 0 To ArraySize(Layer())
        For j = 0 To ArraySize(layer(i)\Tile())
          With Layer(i)\Tile(j)
            ;If IsSprite(\sprite)
            info$ = "tile,"+Str(i)+d$+Str(\x)+d$+Str(\y)+d$+Str(\TileX)+d$+Str(\TileY)+d$+\imagename$+d$+Str(\tileid)+d$+Str(\usealpha)+d$+Str(\lock)+d$+Str(\visible)+d$+Str(\type)+d$
            WriteStringN(0, info$)
            ;EndIf
          EndWith
        Next
      Next
      CloseFile(0)
    EndIf
  EndIf
  
EndProcedure
Procedure Autosave()
EndProcedure
; Edit
Procedure Tile_Delete(j,i, del_Element=1)
	With layer(j)\tile(i)
		FreeSprite2(\sprite)
		FreeSprite2(\spriteSelect)
	EndWith
	
	If del_Element = 1
	  If ArraySize(layer(j)\Tile()) > 0
	    DeleteArrayElement(Layer(j)\tile, i)
	    nbTile-1
	  Else
	    If ArraySize(layer(j)\Tile()) = 0
	      nbtile = -1
	    EndIf
	  EndIf
	EndIf
	
EndProcedure
Procedure Tile_Erase(mode)
  s = ArraySize(layer(j)\Tile())
	Select mode
	  Case 0, 1 ; All or selected
	    For j=0 To ArraySize(Layer())
	      For i = 0 To ArraySize(layer(j)\Tile())
	        If i<= ArraySize(layer(j)\Tile())
	          With Layer(j)\Tile(i)
	            If \selected = 1 Or mode =0
	              If ArraySize(layer(j)\Tile())= 0
	                Tile_Delete(j,i,0)
	                NbTile = -1
	                Break
	              Else
	                 Tile_Delete(j,i)
	                 i-1
	              EndIf
	            EndIf
	          EndWith
	        EndIf
	      Next
	    Next
		
		Case 2 ; layer
		  j = LayerID
		  ;s = ArraySize(layer(LayerID)\Tile())
			For i = 0 To ArraySize(layer(j)\Tile())
      	With Layer(j)\Tile(i)
      	  Tile_Delete(j,i)
      	EndWith
      Next
      nbtile = -1
      Dim layer(j)\Tile.sTile(0)
      FreeSprite2(Layer(j)\Tile(0)\sprite)
      FreeSprite2(Layer(j)\Tile(0)\spriteSelect)
  EndSelect
  i = TileSet_GetNb()
  StatusBarText(0, 1, "NbTile : "+Str(i))
EndProcedure
; Select
Procedure Tile_Select(All=1, SelectionType=#Selection_AllTiles)
  Select SelectionType
      
    Case #Selection_AllTiles
      For i = 0 To ArraySize(layer(LAyerID)\Tile())
        LAyer(LayerID)\Tile(i)\selected = all
      Next
      
    Case #Selection_ByLayer
      
  EndSelect
  
EndProcedure
;}

;{ Windows
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
      AddStringGadget(#G_WinMP_TileW,x,y,w,h,Lang("Tile width"),Str(TileW)) : x+w+5
      AddStringGadget(#G_WinMP_TileH,x,y,w,h,Lang("Tile height"),Str(TileH))
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

;}

;}



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 1540
; FirstLine = 172
; Folding = AA5XAOCBAAAAAAAHABBAEAAAAAAAAAAAQyAQ-CAeAAw8-BAEAAAAg
; EnableXP
; Warnings = Display
; EnablePurifier