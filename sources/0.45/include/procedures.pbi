; tile editor

; Procedures

IncludePath ""

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

;{ images
Procedure LoadImage2(image,filename$)
  If LoadImage(image, filename$) = 0
    MessageRequester(lang("Error"), Lang("Unable to load the image")+" "+filename$)
    AddLogError(1, info$)
    If CreateImage(image, 30,30)
    EndIf
  EndIf
EndProcedure
Procedure FreeImage2(image)
  If IsImage(image)
    FreeImage(image)
  EndIf 
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
Procedure StatusBarUpdate()
  StatusBarText(0, 0, "Zoom : "+Str(Options\zoom)+"%")
  i = TileSet_GetNb()
  StatusBarText(0, 1, "NbTile : "+Str(i))
EndProcedure
Procedure CreateTheMenu()
  If CreateMenu(0, WindowID(0))
    MenuTitle(Lang("File"))
    MenuItem(#Menu_FileNew, Lang("New")+Chr(9)+"Ctrl+N")
    MenuItem(#Menu_FileOpen, Lang("Open")+Chr(9)+"Ctrl+O")
    MenuItem(#Menu_FileMerge, Lang("Merge"))
    MenuItem(#Menu_FileSave, Lang("Save")+Chr(9)+"Ctrl+S")
    MenuItem(#Menu_FileSaveAs, Lang("Save as"))
    ; MenuItem(#Menu_FileExport, Lang("Export in purebasic"))
    MenuBar()
    MenuItem(#Menu_FileExit, Lang("Exit")+Chr(9)+"Esc")
    MenuTitle(Lang("Edit"))
    MenuItem(#Menu_EditCut, Lang("Cut")+Chr(9)+"Ctrl+X")
    MenuItem(#Menu_EditCopy, Lang("Copy")+Chr(9)+"Ctrl+C")
    MenuItem(#Menu_EditPaste, Lang("Paste")+Chr(9)+"Ctrl+V")
    MenuBar()
    MenuItem(#Menu_EditClearAll, Lang("Delete all"))
    MenuItem(#Menu_EditClearSelected, Lang("Delete selected tiles")+Chr(9)+"Ctrl+W")
    MenuItem(#Menu_EditClearLayer, Lang("Delete the tiles by layer"))
    MenuItem(#Menu_EditFillWithTile, Lang("Fill the map with current tile"))
    MenuTitle(Lang("View"))
    MenuItem(#Menu_ViewShowGrid, Lang("Grid")+Chr(9)+"G")
    MenuItem(#Menu_ViewZoom50, Lang("Zoom")+" 50%")
    MenuItem(#Menu_ViewZoom100, Lang("Zoom")+" 100%")
    MenuItem(#Menu_ViewZoom200, Lang("Zoom")+" 200%")
    MenuItem(#Menu_ViewReset, Lang("Reset the View"))
    MenuItem(#Menu_ViewCenter, Lang("Center the View"))
    MenuTitle(Lang("Select"))
    MenuItem(#Menu_SelectAll, Lang("Select all tiles")+Chr(9)+"Ctrl+A")
    MenuItem(#Menu_DeSelectAll, Lang("Deselect all tiles")+Chr(9)+"Ctrl+D")
;     MenuTitle(Lang("Tools"))
;     MenuItem(#Menu_ToolAddTile, Lang("Paint a tile")   +Chr(9)+"P")
;     MenuItem(#Menu_ToolDeleteTile, Lang("Erase a tile")  +Chr(9)+"E")
;     MenuItem(#Menu_ToolChangeTile, Lang("Change a tile")   +Chr(9)+"C")
;     MenuItem(#Menu_ToolSelectTile, Lang("Select")   +Chr(9)+"S")
;     MenuItem(#Menu_ToolMoveTile, Lang("Move")   +Chr(9)+"V")
    MenuTitle(Lang("Windows"))
    MenuItem(#Menu_WindowMapProperties, Lang("Map Properties"))
    MenuItem(#Menu_WindowPixelArtPaint, Lang("Pixel Art Paint Tool"))
    MenuTitle(Lang("Help"))
    MenuItem(#Menu_HelpAbout, Lang("About"))
  EndIf
  AddKeyboardShortcut(0, #PB_Shortcut_G, #Menu_ViewShowGrid)
  AddKeyboardShortcut(0, #PB_Shortcut_P, #Menu_ToolAddTile)
  AddKeyboardShortcut(0, #PB_Shortcut_E, #Menu_ToolDeleteTile)
  AddKeyboardShortcut(0, #PB_Shortcut_B, #Menu_ToolChangeTile)
  AddKeyboardShortcut(0, #PB_Shortcut_S, #Menu_ToolSelectTile)
  AddKeyboardShortcut(0, #PB_Shortcut_V, #Menu_ToolMoveTile)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_N, #Menu_FileNew)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_O, #Menu_FileOpen)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_S, #Menu_FileSave)
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, #Menu_FileExit)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_C, #Menu_EditCopy)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_X, #Menu_EditCut)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_V, #Menu_EditPaste)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_A, #Menu_SelectAll)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_D, #Menu_DeSelectAll)
  AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_W, #Menu_EditClearSelected)
EndProcedure
;}

XIncludeFile "gadgets.pbi"

;{ Tileset, Layer, Tiles
; Tileset

Procedure TileSet_UpdateList()
  
  ClearGadgetItems(#G_TileSetChooseImg)
  For i=0 To ArraySize(TheImage())
    AddGadgetItem(#G_TileSetChooseImg, i, TheImage(i)\name$)
    If Tileset(TilesetCurrent)\name$ = TheImage(i)\name$
      j=i
    EndIf
  Next
  SetGadgetState(#G_TileSetChooseImg, j)

EndProcedure
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
      w4 =100
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
      x=5
      AddStringGadget(#G_winAddImgtolist_ImgScaleW, x,y,w,h,lang("Define the width scale if needed"), StrD(Tileset(TilesetCurrent)\scaleW, 2), lang("Scale W")) 
      x+GadgetX(#G_winAddImgtolist_ImgScaleW)+GadgetWidth(#G_winAddImgtolist_ImgScaleW)+5
      AddStringGadget(#G_winAddImgtolist_ImgScaleH, x,y,w,h,lang("Define the height scale if needed"), StrD(Tileset(TilesetCurrent)\scaleH, 2), lang("Scale H")) : y+h+5
      
      ; to see the image
      x=5
      
      h2 = h1-y-30
      tmp =CopyImage(#image_Tileset, #PB_Any)
      ResizeImage(tmp, w2, (ImageHeight(#image_Tileset)*w2)/ImageWidth(#image_Tileset)) 
      ImageGadget(#G_winAddImgtolist_ImageGad, x,y,w2,h2, ImageID(tmp)) ; ,lang("Add image to list"), lang("Add an image to the tileset list")
      FreeImage(tmp)
      
      Repeat
        event=WaitWindowEvent(1)
        EventGadget = EventGadget()
        
        Select event
          Case #PB_Event_Gadget
            Select EventGadget
              Case #G_winAddImgtolist_ImgScaleH
                scaleH.d = ValD(GetGadgetText(EventGadget))
                If scaleH >0
                  TheImage(ImageCurrent)\scaleH = scaleH
                EndIf
              
              Case #G_winAddImgtolist_ImgScaleH
                scaleW.d = ValD(GetGadgetText(EventGadget))
                If scaleW > 0
                  TheImage(ImageCurrent)\scalew = scalew
                EndIf
              
              Case #G_winAddImgtolist_ListImage
                pos = GetGadgetState(EventGadget)
                ok = 0
                If TheImage(pos)\name$ = CurrentImageName$ ;Tileset(i)\name$
                  ok =1
                EndIf
                ; not the same as current image
                If ok = 0
                  CurrentImageName$ = TheImage(pos)\filename$
                  tmp = LoadImage(#PB_Any, TheImage(pos)\filename$)
                  ResizeImage(tmp, w2, (ImageHeight(tmp)*w2)/ImageWidth(tmp)) 
                  SetGadgetState(#G_winAddImgtolist_ImageGad, ImageID(tmp))
                  FreeImage(tmp)
                  SetGadgetText(#G_winAddImgtolist_ImgScaleW, StrD(TheImage(pos)\scaleW, 2))
                  SetGadgetText(#G_winAddImgtolist_ImgScaleH, StrD(TheImage(pos)\scaleH, 2))
                EndIf
                
              Case #G_winAddImgtolist_Load
                ; add a new image to the tileset list
                name$= OpenFileRequester(Lang("Open an image"), options\DirTileset$, "Images|*.jpg;*.png;*.jpeg;*.bmp",0)
                If name$ <> #Empty$
                  nbImage = ArraySize(TheImage())+1
                  ReDim TheImage.sImagelist(nbImage)
                  With TheImage(nbImage)
                    \filename$ = name$
                    \name$ = GetFilePart(name$)
                    \scaleW = 1.0
                    \scaleH = 1.0
                  EndWith
                  ; update gadgets
                  AddGadgetItem(#G_winAddImgtolist_ListImage, -1, GetFilePart(name$))
                  SetGadgetState(#G_winAddImgtolist_ListImage, nbImage)
                  SetGadgetText(#G_winAddImgtolist_ImgScaleW, "1.0")
                  SetGadgetText(#G_winAddImgtolist_ImgScaleH, "1.0")
                  ImageCurrent = nbImage
                  CurrentImageName$ = TheImage(nbImage)\filename$
                  tmp =LoadImage(#PB_Any, name$)
                  ResizeImage(tmp, w2, (ImageHeight(tmp)*w2)/ImageWidth(tmp)) 
                  SetGadgetState(#G_winAddImgtolist_ImageGad, ImageID(tmp))
                  FreeImage(tmp)
                EndIf
            EndSelect
            
          Case #PB_Event_CloseWindow
            If GetActiveWindow() = #WinMapProperties
              quit=1
            EndIf
            
        EndSelect
        
      Until quit>=1
      
      CloseWindow(#WinMapProperties)
      FreeImage2(tmp)
      
      TileSet_UpdateList()
      
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
    DrawAlphaImage(ImageID(#image_Tileset), 0, 0)
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x*tW, y*tH, tW, tH, RGB(255, 0,0))
    Box(x*tW+1, y*tH+1, tW-2, tH-2, RGB(0, 0,0))
    StopDrawing()
  EndIf
  
EndProcedure
Procedure Tileset_SetProperties()
  
  ; check if we need to change the image
  load =0
  ;Debug options\TilesetImage$ + "/" + TheImage(ImageCurrent)\name$
  If options\TilesetImage$ <> TheImage(ImageCurrent)\name$
    load = 1
  EndIf
  
  ; verify if we have already the image as tileset
  For i=0 To ArraySize(Tileset())
    If Tileset(i)\name$ = TheImage(ImageCurrent)\name$
      TilesetCurrent = i
      ok=1
      Break
    EndIf
  Next
  
  ; set the gadget for the tile
  If ok = 1 
    i = TilesetCurrent
    ; SetGadgetState(#G_TileSetLayer, options\Layer )
    SetGadgetState(#G_TileSetTileW, Tileset(i)\tileW )
    SetGadgetState(#G_TileSetTileH, Tileset(i)\tileH )
    SetGadgetState(#G_TileSetUseAlpha, Tileset(i)\usealpha )
    ; update the color of alpha if needed
    TileSet_SetAlphaColor(Tileset(i)\alphacolor)
  EndIf
  
  ; we have not the tileset or we need to change the image
  If ok = 0 Or load  = 1
    FreeImage(#image_Tileset)
    If LoadImage(#image_Tileset, TheImage(ImageCurrent)\filename$)
      options\TilesetImage$ = TheImage(ImageCurrent)\name$
      ResizeImage(#image_Tileset, ImageWidth(#image_Tileset) * TheImage(nbImage)\scaleW , ImageHeight(#image_Tileset)* TheImage(nbImage)\scaleW,#PB_Image_Raw)
      wc = ImageWidth(#image_Tileset)+20
      hc = ImageWidth(#image_Tileset)+20
      SetGadgetAttribute(#G_SA_TileSet, #PB_ScrollArea_InnerWidth, wc)
      SetGadgetAttribute(#G_SA_TileSet, #PB_ScrollArea_InnerHeight, hc)
      ResizeGadget(#G_CanvasTileSet, #PB_Ignore, #PB_Ignore, wc, hc)
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
      \scaleW = TheImage(ImageCurrent)\scaleW
      \scaleH = TheImage(ImageCurrent)\scaleH
      \tileH = GetGadgetState(#G_TileSetTileW)
      \tileW = GetGadgetState(#G_TileSetTileH)
      \alphacolor =  Options\AlphaColor ; should be the gadget to define the alphacolor on the tileset panel
      \usealpha = GetGadgetState(#G_TileSetUseAlpha ) ; Options\UseAlpha     
      \w = ImageWidth(#image_Tileset)                 ; should be the gadget to define w
      \h = ImageHeight(#image_Tileset)                ; should be the gadget to define h
    EndWith
  EndIf
EndProcedure

; Tiles
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
          Debug tileID
          If Ctrl = 0
            \selected = 1
          Else
            \selected = 0
          EndIf
        EndWith
      EndIf
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
    If TileSet(TilesetCurrent)\usealpha = 1
      sp = CreateSprite(#PB_Any, tW, tH)
      TransparentSpriteColor(sp, Tileset(TilesetCurrent)\alphacolor)
    Else
      sp = CreateSprite(#PB_Any, tW, tH, #PB_Sprite_AlphaBlending)
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

; Layers
Procedure Layer_SetGadgetState()
  SetGadgetState(#G_LayerLock, Layer(layerID)\lock)
  SetGadgetState(#G_LayerView, Layer(layerID)\view)
EndProcedure
Procedure Layer_UpdateList(all=-1)
  
  ; update the layer UI
  h = 26 ; ImageHeight(#Img_LayerCenterSel) 
  
  ; verify the height needed to draw all layers
  hl = (ArraySize(Layer())+1) *(h+1)
  If hl > 200
    ResizeGadget(#G_LayerListCanvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, hl)
    SetGadgetAttribute(#G_LayerList, #PB_ScrollArea_InnerHeight , hl+10)
  ElseIf hl < 200
    If GadgetHeight(#G_LayerListCanvas) <> 200
      ResizeGadget(#G_LayerListCanvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, 200)
      SetGadgetAttribute(#G_LayerList, #PB_ScrollArea_InnerHeight , 200)
    EndIf
  EndIf
  
  If StartDrawing(CanvasOutput(#G_LayerListCanvas))
    
    ; the canvas grey background
    Box(0, 0, OutputWidth(), OutputHeight(), RGB(160, 160, 160))
    
    ; for the checker image (for layer image preview)
    ;s = 19
    ;checker = CopyImage(#Img_Checker,#PB_Any)
    ;ResizeImage(checker, s, s) 
    
    ; temporaire
    all = -1
    
    ; draw the image For each layer    
    If all <> -1
      ; just the layerID
      i = layerId
      ;Box(0, 1+layer(i)\depth * (h+1), OutputWidth(), h, RGB(100, 100, 100))
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(40, 2, Layer(i)\name$, RGB(255, 255, 255))
      
    Else
      
      ; draw all layer
      For i = ArraySize(Layer()) To 0 Step -1
        
        pos = ArraySize(Layer()) - Layer(i)\depth
        
        xx1 = 0
        yy1 = 1+pos *(h+1)
        ; a box for BG layer (not selected)
        Box(0, 1+pos *(h+1), OutputWidth(), h, RGB(120, 120, 120))
        
        ; if layer is selected
        If i = layerid
          Box(0, 1+pos *(h+1), OutputWidth(), h, RGB(100, 100, 100))
        EndIf
        
;         If i = layerId
;           Box(0,0,OutputWidth(),h,  xx1, yy1)
;           ;DrawImage(ImageID(#Img_LayerCenterSel), xx1, yy1)
;         Else
;           ;DrawImage(ImageID(#Img_LayerCenter), xx1, yy1)
;         EndIf
        
        
        ; the image for layer\view
        a = 11
        If Layer(i)\view
           Box(5, 8+pos*(h+1), a, a, RGB(220, 220, 220))
          ; DrawAlphaImage(ImageID(#ico_LayerEye),5,8+pos*(h+1))
        EndIf
        
        ; the image of the layer 
;         DrawImage(ImageID(checker), 23,3+yy1)
        
        ; the image for layer\lock
        If Layer(i)\lock
           Box(104, 4+pos*(h+1), a, a, RGB(250, 120, 0))
          ;DrawAlphaImage(ImageID(#ico_LayerLocked),104,4+pos*(h+1))
        EndIf
        
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(44+d*22, 4+pos*(h+1), Layer(i)\name$, RGB(255, 255, 255))
         
      Next
    EndIf
    
    StopDrawing()
  EndIf
  Layer_SetGadgetState()
EndProcedure
Procedure Layer_Add(add=1)
  If add=0
    ; create at astart, we need at least 1 layer :)
    Layer(0)\name$ = "Base"
    Layer(0)\view = 1
    LayerId = 0
  Else
    ; add a new layer to the list
    i = ArraySize(Layer())+1
    ReDim Layer.sLayer(i)
   ; ReDim TheLayers.sLayerList(i)
    With Layer(i)
      \name$ = "Layer"+Str(i)
      \view = 1
      \depth = i
    EndWith
    LayerId = i
  EndIf
  Layer_UpdateList()
EndProcedure
Procedure Layer_Delete()
  If ArraySize(layer())>0
    j=LayerId
    For i=0 To ArraySize(Layer(j)\Tile())
      Tile_Delete(j,i,0)
    Next
    DeleteArrayElement(Layer, j)
    layerId = 0
    Layer_UpdateList()
  Else
    MessageRequester(lang("Info"), Lang("You can't delete this layer. You should have at least 1 layer in your document."))
  EndIf
EndProcedure
Procedure Layer_GetLayerId()
  
  h = 26+1
  lx = GetGadgetAttribute(#G_LayerListCanvas, #PB_Canvas_MouseX)
  ly = GetGadgetAttribute(#G_LayerListCanvas, #PB_Canvas_MouseY)

  Select EventType()
      
    Case #PB_EventType_LeftDoubleClick
      If Lx > 45 And Lx <= 80
        name$ = InputRequester("Name", "Name of the layer : ", "")
        If name$ <> ""
          Layer(layerId)\name$ = name$
          Layer_UpdateList();-1)
        EndIf
      ElseIf Lx > 80 
        ; layer properties
        ;WindowLayerProp()
      EndIf
      
    Case #PB_EventType_LeftButtonDown
      pos = ly/h
      i = ArraySize(Layer())- pos
      Debug i
      If i <0
        i = 0
      ElseIf i> ArraySize(Layer())
         i = ArraySize(Layer())
      EndIf
      
      If Lx < 20
        ; view
        Layer(i)\View = 1 - Layer(i)\View
      Else
        layerId = i
        ; testlayer(LayerId)
      EndIf
    
      ; Debug pos
      Layer_SetGadgetState()
      Layer_UpdateList(-1)
    
      
  EndSelect
EndProcedure
Procedure Layer_ChangePos(up=1)
  
  ; up = 1 : Up // on monte d'une position
  ; up = -1, : Down // on descnd d'une position
  
  ; Check if we can move UP/down the layer // on verifie qu'on peut bien bouger le layer courrant
  
  ; Debug Str(Layerid)+ " - "+Str(Layer(LayerId)\depth) + "/"+Str(ArraySize(layer()))
  
  If (up=1 And Layer(LayerId)\depth<ArraySize(layer()))  Or (up=-1 And Layer(LayerId)\depth>0)
    
    i = layerid
    j = layerid+up
    layer(LayerId)\depth + up
    Newdepth = layer(LayerId)\depth
    layer(LayerId+up)\depth - up
    
    ; Trie le tableau en fonction du champ 'depth' qui est un long  ;
    If up=1
      SortStructuredArray(layer(), #PB_Sort_Ascending, OffsetOf(sLayer\depth),  TypeOf(sLayer\depth),i, j)
    Else
      SortStructuredArray(layer(), #PB_Sort_Ascending, OffsetOf(sLayer\depth),  TypeOf(sLayer\depth),j, i)
    EndIf
    
    
    For i = 0 To ArraySize(layer())
      If layer(i)\depth = Newdepth
        LayerId = i
        Break
      EndIf
    Next i
    
    Layer_UpdateList()
    
  EndIf
  
EndProcedure
;}

;{ Screen
Procedure Screen_DrawGrid()
  
  Z.d = Options\Zoom * 0.01
  x = canvasX
  y = canvasY
  h = (MapH) * z
  w = (MapH) * z
  
  tw = Options\SnapW
  th = Options\SnapH
  
  DrawingMode(#PB_2DDrawing_AllChannels)
  Define j.f
  ; white lines
  For i=0 To w ; OutputWidth() 
    LineXY(X+j, y+0, x+j, y+h, RGBA(255,255,255,10))
    ;i =Round(i+(TileW*z-1), #PB_Round_Nearest)
    j + (tw)
    i = j
  Next
  LineXY(X+w, y+0, x+w, y+h, RGB(255,255,255))
  j=0
  For i=0 To h ; OutputHeight() 
    LineXY(x+0, y+j, x+w, y+j, RGBA(255,255,255,10))
    ;i =Round(i+ (TileH*z-1), #PB_Round_Nearest)
    j + (TH*z)
    i=j
  Next
   LineXY(x+0, y+h, x+w, y+h, RGB(255,255,255))
  
EndProcedure
Procedure UpdateSpriteUtils()
  
  If Not IsSprite(#sp_Background)
    If CreateSprite(#sp_Background, 10, 10)
      If StartDrawing(SpriteOutput(#sp_Background))
        Box(0,0,OutputWidth(), OutputHeight(), Themap\Color)
        StopDrawing()
      EndIf
    EndIf
  EndIf
  
;   FreeSprite2(#sp_grid)
;   w = MapW
;   h = MapH
;   tw = Options\snapW
;   th = Options\snapH
;   If CreateSprite(#sp_grid, w, h,#PB_Sprite_AlphaBlending)
;     
;     If StartDrawing(SpriteOutput(#sp_grid))
;       DrawingMode(#PB_2DDrawing_AllChannels)
;       Box(0,0,OutputWidth(), OutputHeight(), RGBA(0,0,0,0))
;       
;       ; grey lines
;       For i=0 To OutputWidth() 
;         LineXY(i+1, 0, i+1, h, RGBA(255,255,255,100))
;         LineXY(i-1, 0, i-1, h, RGBA(255,255,255,100))
;         i +TW-1
;       Next
;       For i=0 To OutputHeight() 
;         LineXY(0, i-1, w, i-1, RGBA(255,255,255,100))
;         LineXY(0, i+1, w, i+1, RGBA(255,255,255,100))
;         i + TH-1
;       Next
;       
;       ; white lines
;       For i=0 To OutputWidth() 
;         LineXY(i, 0, i, h, RGBA(255,255,255,255))
;         i +TW-1
;       Next
;       For i=0 To OutputHeight() 
;         LineXY(0, i, w, i, RGBA(255,255,255,255))
;         i + TH-1
;       Next
;       
;       StopDrawing()
;     EndIf
;   EndIf

EndProcedure
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
;}

XIncludeFile "menu.pbi"

; Edit
Procedure Tile_Copy()
	Shared nbcopytile
	
	;If IsArray(copytile())
		FreeArray(copytile())
	;EndIf
	Global Dim copytile.sTile(0)
	
	nbcopytile = -1
	j= LayerID
	For i=0 To ArraySize(Layer(j)\Tile())
		With Layer(j)\Tile(i)
			If \selected
				nbcopytile + 1
				u = nbcopytile
				ReDim copytile.sTile(u)
				copytile(u) = Layer(j)\Tile(i)
				\selected=0
			EndIf
		EndWith
	Next

EndProcedure
Procedure Tile_Paste(x1,y1)
	Shared nbcopytile
	
	j = LayerID
	OldTileX = TileX
	OldTileY = TileY
	; get the difference of position
	x2 = x1 - copytile(0)\x
	y2 = y1 - copytile(0)\y
	
	For i=0 To ArraySize(copytile())
		; NbTile +1
		;u = NbTile+1
		; ReDim Layer(j)\Tile(u)
		x = copytile(i)\x +x2
		y = copytile(i)\y +y2
		; set the good TileX/TileY for the image on new tile
		TileX = copytile(i)\TileX
		TileY = copytile(i)\TileY
		TileID =  ArraySize(Layer(j)\Tile())+1
		; Debug "tilecopied : "+Str(x)+"/"+Str(y)
		CreateTheTile(x, y)
		; copy the sprite
		u = ArraySize(Layer(j)\Tile())
		sp1 = Layer(j)\Tile(u)\sprite
		sp2 = Layer(j)\Tile(u)\spriteSelect
		; copy the tile properties from copytile()
		Layer(j)\Tile(u) = copytile(i)
		; then set the sprite again on the copied tiles
		Layer(j)\Tile(u)\sprite = sp1
		Layer(j)\Tile(u)\spriteSelect = sp2
		Layer(j)\Tile(u)\selected = 0
		Layer(j)\Tile(u)\x = x
		Layer(j)\Tile(u)\y = y
	Next
	; then set the TileX/TileY with old value.
	TileX = OldTileX
	TileY = OldTileY
	StatusBarUpdate()
EndProcedure
Procedure Tile_Delete(idlayer, idtile, del_Element=1)
  j = idlayer
  i = idtile
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
  StatusBarUpdate()
EndProcedure
Procedure Tile_Move(x1,y1)
  j = LayerId
  i = TileID
  ; get the difference of position
	x2 = x1 - layer(j)\Tile(i)\x
	y2 = y1 - layer(j)\Tile(i)\y
	; move the tile
	For j=0 To ArraySize(layer())
	  For i = 0 To ArraySize(layer(j)\Tile())
	    If layer(j)\Tile(i)\selected
	      Layer(j)\Tile(i)\x +x2
		    Layer(j)\Tile(i)\y +y2
	    EndIf
	  Next
	Next
  
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


XIncludeFile "windows.pbi"


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 136
; Folding = AAAAAAAAAAAAAAAAAAAAAAAAAA5
; EnableXP