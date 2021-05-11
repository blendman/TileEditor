; tileeditor
; tiles



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
  If mode = 0 ; And  action = #Action_SelectTile
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
          ; Debug tileID
          If action = #Action_SelectTile
            If Ctrl = 0
              \selected = 1
            Else
              \selected = 0
            EndIf
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



Procedure Tile_CheckIfExists(x,y)
  For k = 0 To ArraySize(Layer(layerID)\Tile())
    With Layer(layerID)\Tile(k)
      If \x = x And \y = y 
        found = 1
        ; Debug "Tile trouvé ("+Str(k)+") en : "+Str(x)+"/"+Str(y)
        Break
      EndIf
    EndWith
  Next
  ProcedureReturn found
EndProcedure


; Edit
Procedure Tile_Copy(selected=0)
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
				\selected=selected
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
  If tileID >-1 And tileID<= ArraySize(layer(LayerId)\Tile())
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
  EndIf
EndProcedure



Procedure Tile_Fill()
  ; Debug Str(mapW/options\snapW)+"/"+Str (MapH/options\snapH)
  For j=0 To MapH/options\snapH -1
    For i=0 To mapW/options\snapW -1
      
      x = i * options\snapW
      y = j * options\snapH
      
      ; verify if we have a tile at this position
      found = Tile_CheckIfExists(x,y)
      
      ; if not found
      If found = 0
        If i = 0 And j = 0
          tileID = 0
        Else
          TileID = i + j*(MapH/options\snapH)
        EndIf
        ; Debug "Not Found : TileID "+Str(tileId)+" : " +Str(x)+"/"+Str(y)
        If tileid<= ArraySize(Layer(layerID)\Tile()) ; And tileID >=0
          With Layer(layerID)\Tile(tileID)
            If Not IsSprite(\sprite)
              CreateTheTile(x, y)
            Else
              TileID = ArraySize(layer(LayerId)\Tile())+1
              CreateTheTile(x, y)
            EndIf
          EndWith
        Else
          TileID = ArraySize(layer(LayerId)\Tile())+1
          CreateTheTile(x, y)
        EndIf
      EndIf
    Next
  Next
  StatusBarUpdate()
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


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 333
; FirstLine = 16
; Folding = AAAAAujzfAPg
; EnableXP