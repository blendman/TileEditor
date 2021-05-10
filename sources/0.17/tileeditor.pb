; "tile editor" (based on my old project "TEO" (tile editor Orgnaisation))
; by blendman since 28 april 2021
; licence MIT

;{ infos

;--- TODO
; - menu file : export as level, export as pb example ?
; - menu edit : change properties (x,y,layer,visible,lock,tileid,tileset)
; - select : all, by tileid, line/column, invert, layer, visible, lock,...
; - tile : setpropertie with gadgets (panel t)

;--- CHANGELOG
; 2.5.2021 (0.3.6)
;// New
; - Doc_open : add map
; - menu Map properties
; - Window mapproperties : gadgets MapW, MapH, TileW,TileH
; - Window pixelartpaint (emptu for the moment)

; 1.5.2021 (0.3.5)
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

; 30.4.2021 (0.2.8)
;// New
; - open doc : info, image, tileset
; - menu (empty) : merge, help/about
; - menu ok : Save, saveas, exit
; - doc_save : infos, map, image, tileset, tile
; - add button + (to add a new image to the tileset bank)
; - combobox to select the image as tileset
; - panel tileset : layer, tilew /tileh, usealpha, setalphacolor
; - panel tile : x, y, layer, usealpha, lock, visible, selected, type,

; 29.4.2021 (0.2)
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


#ProgramVersion = "0.3.6"
#ProgramDate      = #PB_Compiler_Date ; 04/2021
#ProgramName      = "Tile Editor"
Enumeration
  
  ; Windows
  #WinMain=0
  #WinMapProperties
  #WinPixelArtPaint
  
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
  ; view
  #Menu_ViewReset
  #Menu_ViewCenter
  #Menu_ViewZoom100
  #Menu_ViewZoom50
  #Menu_ViewZoom200
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
  #G_panelTileSet =0
  #G_SA_TileSheet ;  scrollarea
  #G_CanvasTileSheet
  #G_TileSetLayer
  #G_TileSetTileW
  #G_TileSetTileH
  #G_TileSetUseAlpha
  #G_TileSetAlphacolor
  #G_TileSetChooseImg
  #G_TileSetAddImg
  #G_TileSetChoosefolder
  
  #G_panelProperties
  #G_TileScroolArea
  #G_TileX
  #G_TileY
  #G_TileImagename
  #G_TileUseAlpha
  #G_TileLayer
  #G_TileLock
  #G_TileVisible
  #G_TileType
  ;}
  
  ; for all Windows
  #G_ButtonOk
  #G_ButtonCancel
  
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
  #imageTileset
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
  
EndEnumeration

If InitSprite() : EndIf
If InitKeyboard() : EndIf
If UsePNGImageDecoder() : EndIf
If UseJPEGImageDecoder() : EndIf

Global TileW=32, TileH=32, TileID, TileX, TileY, TileSetW, TileSetH, winW, winH

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

Structure sImage 
  name$
  id.a
EndStructure
Global Dim TheImage.sImage(0)

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
Global MapW =20, MapH =20, LayerId, TileID, tileID_byMouse, NBTile = -1
Global Dim Layer.sLayer(0)

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
EndStructure
Global Options.sOptions
Options\DirTileset$ = "data\images\"


;}

; macros
Macro DeleteArrayElement(ar, el)
  
  For a=el To ArraySize(ar())-1
    ar(a) = ar(a+1)
  Next 
  
  ReDim ar(ArraySize(ar())-1)
  
EndMacro

;{ procedures
Declare.l Min(a,b)
Declare SetMin(a, min)
Declare.l Max(a, b)
Declare SetMaximum(a, b)
Declare WinMapProperties()
Declare WinPixelArtPaint()

Procedure.s Lang(text$)
  ; ' will be changed with langages
  ProcedureReturn text$
EndProcedure
; gagdets
Procedure AddSpinGadget(id, x, y, w, h, min, max, tip$="", val=0, name$="")
  If name$<>""
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
Procedure UpdateCanvasTileSet(x=0, y=0)
  
  If StartDrawing(CanvasOutput(#G_CanvasTileSheet))
    DrawImage(ImageID(#imageTileset), 0, 0)
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x*tileW, y*tileH, tileW, tileH, RGB(255, 0,0))
    Box(x*tileW+1, y*tileH+1, tileW-2, tileH-2, RGB(0, 0,0))
    StopDrawing()
  EndIf
  
EndProcedure
Procedure FreeSprite2(sprite)
  If IsSprite(Sprite)
    FreeSprite(Sprite)
  EndIf
EndProcedure
; tile & tileset
Procedure CreateTheTile(x, y)
  
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
  EndIf
  If ok = 1
    With Tileset(i)
      \name$ = TheImage(ImageCurrent)\name$
      \tileH = TileH
      \tileW = TileW
      \alphacolor =  Options\AlphaColor ; should be the gadget to define the alphacolor on the tileset panel
      \usealpha = GetGadgetState(#G_TileSetUseAlpha ) ; Options\UseAlpha     
      \w = ImageWidth(#imageTileset)   ; should be the gadget to define w
      \h = ImageHeight(#imageTileset)   ; should be the gadget to define h
    EndWith
  EndIf
  
  ; create the layer array If needed
  If layerID > ArraySize(layer())
    ReDim Layer.slayer(layerID)
  EndIf
  
  
  ; create the sprite If needed
  If TileID > ArraySize(layer(layerID)\Tile())
    ReDim layer(layerID)\Tile.sTile(TileId)
  EndIf
  
  sp = Layer(LayerID)\Tile(TileID)\sprite
  If sp <=0
    spSelect = CreateSprite(#PB_Any, 4, 4)
    sp = CreateSprite(#PB_Any, TileW, tileH)
    If tileset(TilesetCurrent)\usealpha = 1
      TransparentSpriteColor(sp, Tileset(TilesetCurrent)\alphacolor)
    EndIf
    
    Layer(LayerID)\Tile(TileID)\sprite = sp  
    Layer(LayerID)\Tile(TileID)\spriteSelect = spSelect  
    
    If StartDrawing(SpriteOutput(spSelect))
      Box(0,0,OutputWidth(), OutputHeight(), RGB(255, 128, 0))
    StopDrawing()
  EndIf
  EndIf
  If StartDrawing(SpriteOutput(sp))
    ; DrawingMode(#PB_2DDrawing_AllChannels)
    DrawImage(ImageID(#imageTileset), -tileX * tileW, -tileY * tileH)
    StopDrawing()
  EndIf
  
 
  ; then add the tile properties
  Layer(LayerID)\Tile(TileID)\visible = 1
  Layer(LayerID)\Tile(TileID)\Lock = 0
  Layer(LayerID)\Tile(TileID)\layer = Options\Layer
  Layer(LayerID)\Tile(TileID)\tileid = tileID_byMouse ; TileX +tileY*TileW
  Layer(LayerID)\Tile(TileID)\imagename$ = Tileset(TilesetCurrent)\name$
  Layer(LayerID)\Tile(TileID)\usealpha = Tileset(TilesetCurrent)\usealpha
  Layer(LayerID)\Tile(TileID)\x = x 
  Layer(LayerID)\Tile(TileID)\y = y
  Layer(LayerID)\Tile(TileID)\TileX = tileX
  Layer(LayerID)\Tile(TileID)\TileY = tileY
  NBTile = TileID
  
EndProcedure
Procedure SetTilesetProperties()
  
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
  EndIf
  
EndProcedure
Procedure GetTileProperties(mode=0)
  
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
    
    If  tileID <= ArraySize(layer(layerID)\Tile())
      With layer(layerID)\Tile(TileID)
        SetGadgetState(#G_TileX, \x)
        SetGadgetState(#G_TileY, \y)
        SetGadgetState(#G_TileLayer, \layer)
        SetGadgetState(#G_TileVisible, \visible)
        \selected = 1
      EndWith
    EndIf
  EndIf
  
EndProcedure
Procedure SetAlphaColor(color)
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
; menu
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
;     FreeArray(Tileset())
;     FreeArray(TheImage())
    Global Dim Layer.sLayer(0)
    ReDim Tileset.sTileset(0)
    ReDim TheImage.sImage(0)
  EndIf
  
EndProcedure
Procedure Doc_Open()
  Filter$ = "All|*.txt;*.ted|tile editor document (*.ted)|*.ted|texte (*.txt)|"
  name$ = OpenFileRequester(Lang("Open a document"), "", Filter$, 0)
  If name$<>""
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
            ReDim TheImage.sImage(i)
            With TheImage(i)
              \name$ = StringField(line$, 2, d$)
              \id = Val(StringField(line$, 3, d$))
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
  If Options\Docname$ <>"" And saveas=0
    name$ =Options\Docname$
  Else
    name$ = SaveFileRequester(Lang("Save the document"), "", Filter$, 0)
  EndIf
  If name$<>""
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
          info$ = "image,"+\name$+d$+Str(\id)+d$
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
Procedure FPS()
EndProcedure
;}

; open the window
If ExamineDesktops()
  WinW = DesktopWidth(0)
  w = WinW
  WinH = DesktopHeight(0)
  h = WinH
EndIf

If OpenWindow(0, 0, 0, w, h, "Tile Editor "+#ProgramVersion, 
              #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_Maximize)
  
  
  Zoom = 100
  ; statusbar
  If CreateStatusBar(0, WindowID(0))
    AddStatusBarField(100)
    AddStatusBarField(150)
    AddStatusBarField(150)
    AddStatusBarField(150)
    AddStatusBarField(150)
    StatusBarText(0, 0, Lang("zoom")+" : "+Str(zoom)+"%")
  EndIf
  ;{ create the menu
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
    MenuItem(#Menu_EditFillWithTile, Lang("Fill the map with current tile"))
    MenuTitle(Lang("View"))
    MenuItem(#Menu_ViewReset, Lang("Reset the View"))
    MenuItem(#Menu_ViewCenter, Lang("Center the View"))
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
  
  AddKeyboardShortcut(0, #PB_Shortcut_P, #Menu_ToolAddTile)
  AddKeyboardShortcut(0, #PB_Shortcut_E, #Menu_ToolDeleteTile)
  AddKeyboardShortcut(0, #PB_Shortcut_C, #Menu_ToolChangeTile)
  AddKeyboardShortcut(0, #PB_Shortcut_S, #Menu_ToolSelectTile)

  ;}
  ;{ create the screen
  screenX = 350
  screenY = 5
  canvasW = w - screenX - 10
  canvasH = h - screenY - 80 - MenuHeight()-StatusBarHeight(0)
  If OpenWindowedScreen(WindowID(0), screenX, screenY, canvasW, canvasH) : EndIf
  ;} 
  ;{ create gadgets
  ; panel tile set
  x = 5
  y = screenY
  w = screenX-10
  h = canvasH
  If PanelGadget(#G_panelTileSet, x, y, w, h)
    AddGadgetItem(#G_panelTileSet, -1, lang("Tile set"))
    
    ;{ add an image to test
    ;<-- temporary To test the program
    If LoadImage(#imageTileset, GetCurrentDirectory()+ Options\DirTileset$ +"LJ822U2.png")
      nbImage = -1
      nbImage +1
      ReDim TheImage.sImage(nbImage)
      TheImage(nbImage)\name$ = "LJ822U2.png"
      TilesetCurrent = nbImage
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
    ; -->
    ;}
    
    x = 5
    y = 5
    h1 = 400
    h2 = 25
    w1 = w-15
    w2 = 70
    w3 = 120
    If ComboBoxGadget(#G_TileSetChooseImg, x, y, w1-30, h2)
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
    
    ButtonGadget(#G_TileSetAddImg, x+GadgetWidth(#G_TileSetChooseImg)+5, y, h2, h2, "+")
    y+h2+5
    
    If ScrollAreaGadget(#G_SA_TileSheet, x, y, w1, h1, wc, hc, #PB_ScrollArea_Flat)
      CanvasGadget(#G_CanvasTileSheet, 0, 0, wc, hc)
      ; update the canvas
      UpdateCanvasTileSet()
      CloseGadgetList()
    EndIf
    y+h1+5
    
    AddSpinGadget(#G_TileSetLayer, x, y, w2, h2, 0, 1000, Lang("Set the layer (depth) for the current tile"), 0):  x+w2+5
    AddSpinGadget(#G_TileSetTileW, x, y, w2, h2, 1, 10000, lang("Set the width Tile (for the image)"), TileW) :  x+w2+5
    AddSpinGadget(#G_TileSetTileH, x, y, w2, h2, 1, 10000, lang("Set the height Tile (for the image)"), tileH):  x+w2+5
    x = 5
    y+h2+5
    CheckBoxGadget(#G_TileSetUseAlpha, x, y, w3, h2, Lang("Use alpha for tileset"))
    y+h2+5
    If CreateImage(#Image_alphaColor, h2, h2) : EndIf
    ImageGadget(#G_TileSetAlphacolor, x, y, h2, h2, ImageID(#Image_alphaColor))
    GadgetToolTip(#G_TileSetAlphacolor, Lang("Set the transparency color"))
    
    
    AddGadgetItem(#G_panelTileSet, -1, "Tile properties")
    x = 5
    y = 5
    If ScrollAreaGadget(#G_TileScroolArea, x, y, w1-20, h1, w1-40, hc, #PB_ScrollArea_Flat)
      AddSpinGadget(#G_TileX, x, y, w2, h2, 0, MapW, lang("x position of Tile"), 0, lang("X")) :  x=GadgetX(#G_TileX)+w2+5
      AddSpinGadget(#G_TileY, x, y, w2, h2, 0, MapH, lang("y position of Tile"), 0, lang("Y")) :  x+w2+5
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
  EndIf
  ;}
  ;{ add some utilities
  If CreateSprite(#sp_Background, 10, 10)
    If StartDrawing(SpriteOutput(#sp_Background))
      Box(0,0,OutputWidth(), OutputHeight(), RGB(150,150,150))
      StopDrawing()
    EndIf
  EndIf
  
  canvasX = (canvasW-MapW*tileW)/2 
  canvasY = (canvasH-MapH*tileH)/2 
  If canvasY > canvasH - SpriteHeight(#sp_Background)
    canvasY = 0
  EndIf
  ;}
  
  Repeat
    
    Repeat 
      
      mx = WindowMouseX(0) - screenX
      my = WindowMouseY(0) - screenY
      Z.d = Zoom * 0.01
      event = WaitWindowEvent(1)
      EventGadget = EventGadget()
      EventMenu = EventMenu()
      
      Onscreen = 0
      If mx>=0 And mx<=ScreenWidth() And my>=0 And my<=ScreenHeight()
        onscreen=1 ; we are on the screen  :)
        gad = 0    ; not on a gadget
      EndIf
      
      Select event 
          
        Case #PB_Event_Menu
          Select EventMenu()
              ; File
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
              ; Tool
            Case #Menu_ToolAddTile To #Menu_toolTestMap
              action = EventMenu - #Menu_ToolAddTile
              ; View
            Case #Menu_ViewReset
              canvasX = 0
              canvasY = 0
            Case #Menu_ViewCenter
              canvasX = (canvasW-MApW*tileW)/2 
              canvasY = (canvasH-MApH*tileH)/2 
              ; Edit
            Case #Menu_EditFillWithTile
              For i=0 To mapW
                For j=0 To MapH
                	TileID=i+(1+j)*TileW
                  ;With Layer(layerID)
                    ;If Not IsSprite(\sprite)
                      CreateTheTile(i, j)
                    ;EndIf
                  ;EndWith
                Next
              Next
              ; Windows
            Case #Menu_WindowMapProperties
              WinMapProperties()
            Case #Menu_WindowPixelArtPaint
              WinPixelArtPaint()
              ; Help  
            Case #Menu_HelpAbout
              MessageRequester(Lang("About"), "Tile Editor is a free and open-source level editor, made in purebasic, by BLendman, since april 2021."+Chr(13)+
                                              "Version : "+#ProgramVersion+Chr(13)+
                                              "Date : "+FormatDate("%dd/%mm/%yyyy", #ProgramDate))
            Default
              MessageRequester(Lang("Info"), Lang("Not implemented"))
          EndSelect
          
        Case #PB_Event_Gadget
          If onscreen = 0
            gad = 1
            Select eventgadget
              Case #G_TileSetLayer
                Options\Layer = GetGadgetState(EventGadget)
                layerID = options\layer
                
              Case #G_TileSetUseAlpha
                Tileset(TilesetCurrent)\usealpha = GetGadgetState(EventGadget)
                Options\UseAlpha = GetGadgetState(EventGadget)
                
              Case #G_TileSetAlphacolor
                If EventType() = #PB_EventType_LeftClick       
                  color = ColorRequester(options\AlphaColor)
                 SetAlphaColor(color)
                EndIf
                
              Case #G_TileSetChooseImg
                ImageCurrent = GetGadgetState(eventgadget)
                SetTilesetProperties()
                
              Case #G_CanvasTileSheet
                If EventType() = #PB_EventType_LeftButtonDown 
                  x = GetGadgetAttribute(#G_CanvasTileSheet, #PB_Canvas_MouseX)
                  y = GetGadgetAttribute(#G_CanvasTileSheet, #PB_Canvas_MouseY)
                  If Alt = 1
                    If StartDrawing(CanvasOutput(#G_CanvasTileSheet))
                      color = Point(x,y)
                      StopDrawing()
                    EndIf
                    SetAlphaColor(color)
                  Else
                    If StartDrawing(CanvasOutput(#G_CanvasTileSheet))
                      x/TileW
                      y/TileH
                      TileX = x
                      TileY = y
                      Debug Str(x)+"/"+Str(y)
                      StopDrawing()
                    EndIf
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
          
          For j = 0 To ArraySize(layer())
            For i = 0 To ArraySize(layer(j)\Tile())
              If layer(j)\Tile(i)\x = x And layer(j)\Tile(i)\y = y
                TileId = i
                Break
              EndIf
            Next
          Next
          
          
          Select action
            Case #Action_AddTile
              If layerID > ArraySize(Layer()) Or tileID > ArraySize(layer(layerID)\Tile()) Or NBTile = -1
                CreateTheTile(x, y)
              EndIf
              
            Case #Action_ChangeTile 
              CreateTheTile(x, y)
              
            Case #Action_DeleteTile
              If layerID <= ArraySize(Layer())
                If TileID <= ArraySize(Layer(LayerID)\Tile()) And tileID >-1
                  If Layer(LayerID)\Tile(TileID)\sprite <> 0
                    ; delete the sprite
                    FreeSprite(Layer(LayerID)\Tile(TileID)\sprite)
                    FreeSprite(Layer(LayerID)\Tile(TileID)\spriteSelect)
                    DeleteArrayElement(Layer(LayerID)\Tile, TileID)
                  EndIf
                EndIf
              EndIf
              
            Case #Action_SelectTile
              ; temporary for select mode.
              GetTileProperties(shIft)
              
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
    For i =0 To ArraySize(layer())
      For j =0 To ArraySize(layer(i)\Tile())
        With Layer(i)\Tile(j)
          If \visible And IsSprite(\sprite)
            ZoomSprite(\sprite, tilew *z, tileH *z)
            ;If \usealpha = 0
            ;DisplaySprite(\sprite, canvasx + \x * tileW*z, canvasy+ \y * tileH*z)
            ;Else
            DisplayTransparentSprite(\sprite, canvasx + \x * tileW*z, canvasy+ \y * tileH*z)
            ;EndIf
          EndIf
          If \selected
            ZoomSprite(\spriteSelect, tilew *z, tileH *z)
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
;}
;{ gadgets
Procedure AddStringGadget(id,x,y,w,h,tip$,text$,name$="")
	If StringGadget(id,x,y,w,h,text$)
		GadgetToolTip(id,tip$)
	EndIf
EndProcedure
;}
;{ windows
Procedure PAP_UpdateCanvas()
  
  Shared PAp_canvasX, PAP_canvasY, PAP_Zoom
  z.d = PAP_Zoom/100
  cnv = #G_WinPAP_MainCanvas
  temp = CopyImage(#Image_PAPA, -1)
  w = ImageWidth(#Image_PAPA)*z
  h = ImageHeight(#Image_PAPA)*z
  ResizeImage(temp, w, h, #PB_Image_Raw)
  If StartDrawing(CanvasOutput(cnv))
    Box(0,0,OutputWidth(), OutputHeight(), RGBA(100,100,100,255))
    
    DrawAlphaImage(ImageID(temp), PAp_canvasX, PAp_canvasY)
    
    DrawingMode(#PB_2DDrawing_Outlined)
     Box(PAp_canvasX, PAp_canvasY, w, h, RGBA(255,0,0,255))
    StopDrawing()
  EndIf
  FreeImage(temp)
EndProcedure
Procedure WinPixelArtPaint()
  
  Shared PAP_canvasX, PAP_canvasY, PAP_Zoom
  
  
  w1=SetMin(WinW -200, 600)
	h1=SetMIn(WinH-150, 400)
	w1=600
	h1=400
	If OpenWindow(#WinPixelArtPaint,0,0,w1,h1,Lang("Pixel Art Paint"), #PB_Window_SystemMenu|#PB_Window_ScreenCentered, WindowID(#WinMain))
		
		x.d=5
		y.d=5
		w=50
		h=20
		wp=180
		; add tool PanelGadget
		If PanelGadget(#G_WinPAP_PanelTool, x,y,wp, h1-40)
		  AddGadgetItem(#G_WinPAP_PanelTool, -1, lang("Tool"))
		  x=10
		  y=10
		  CloseGadgetList()
		EndIf
				
		; add canvas
		ImageW = 16
		ImageH = 16
		If CreateImage(#Image_PAPA, ImageW, ImageH, 32, #PB_Image_Transparent) : EndIf
		y=10
		;If ScrollAreaGadget(#G_WinPAP_MainCanvas,wp+10, y, w1-(wp+10)*2, h1-150, ImageW
		w2 = w1-(wp+10)*2
		h2 = h1-150
		If CanvasGadget(#G_WinPAP_MainCanvas, wp+10, y, w2, h2) : EndIf 
		PAP_Zoom = 800
		z.d = PAP_Zoom/100
		PAP_canvasX = (w2-ImageW*z)/2
		PAP_canvasY = (h2-ImageH*z)/2
		
		brushsize = 1
    PAP_UpdateCanvas()
		
		Repeat
			event = WaitWindowEvent(1)
			EventGadget = EventGadget()
			z.d = PAP_Zoom/100
			
			Select event
				Case #PB_Event_Gadget
				  Select EventGadget
				    Case #G_WinPAP_MainCanvas
				      cnv = #G_WinPAP_MainCanvas
				      If EventType() = #PB_EventType_LeftButtonDown Or (EventType() = #PB_EventType_MouseMove And GetGadgetAttribute(cnv, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)
				        x.d = (GetGadgetAttribute(cnv, #PB_Canvas_MouseX)/z-PAP_canvasX/Z)-s/2
				        y.d = (GetGadgetAttribute(cnv, #PB_Canvas_MouseY)/z-PAP_canvasY/Z)-s/2
                s = brushsize
				        If StartDrawing(ImageOutput(#Image_PAPA))
				          DrawingMode(#PB_2DDrawing_AllChannels)
				          Box(X, Y, s, s, RGBA(0,0,0,255))
				          StopDrawing()
				        EndIf
				        PAP_UpdateCanvas()
				      EndIf

					EndSelect
					
				Case #PB_Event_CloseWindow
					quit=1
			EndSelect
			
		Until quit=1
		
		CloseWindow(#WinPixelArtPaint)
	EndIf
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
; CursorPosition = 1221
; FirstLine = 221
; Folding = AQPAAAAAAAA5BAAbBAIYBAAAA+DCCA9--4-
; EnableXP