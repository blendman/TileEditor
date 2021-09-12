; tile editor

; Menu (file, edit..)
; options
Procedure WriteDefaultOption()
  WritePreferenceString("Lang",  Options\Lang$)
  PreferenceGroup("General")
  With Options
    WritePreferenceString("Theme",  \Theme$)
    ; Paths & directories
    WritePreferenceString("TilesetDefault", RemoveString(\TilesetDefault$, GetCurrentDirectory()))
    WritePreferenceString("DirTileset",  RemoveString(\DirTileset$, GetCurrentDirectory()))
    If \PathOpen$ = ""
      \PathOpen$ = "save\"
    EndIf
    WritePreferenceString("PathOpen",  RemoveString(\PathOpen$, GetCurrentDirectory()))
    If \PathSave$ = ""
      \PathSave$ = "save\"
    EndIf
    WritePreferenceString("PathSave", RemoveString(\PathSave$, GetCurrentDirectory()))
    
    ; UI
    WritePreferenceInteger("ShowOrigin",          \ShowOrigin)
    WritePreferenceInteger("Grid",          \Grid)
    WritePreferenceInteger("GridW",         \GridW)
    WritePreferenceInteger("GridH",         \GridH)
    WritePreferenceInteger("GridColor",     \GridColor)
    WritePreferenceInteger("Snap",          \Snap)
    WritePreferenceInteger("SnapW",         \SnapW)
    WritePreferenceInteger("SnapH",         \SnapH)
    
    WritePreferenceInteger("Statusbar",     \Statusbar)
    WritePreferenceInteger("UseRighmouseToErase",   \UseRighmouseToErase)
    WritePreferenceInteger("Filtering",     \SpriteQuality)
    ; exit
    WritePreferenceInteger("ConfirmExit",   \ConfirmExit)
    ; autosave
    WritePreferenceInteger("autosave",      \Autosave)
    WritePreferenceInteger("autosaveTime",  \AutosaveTime)
    WritePreferenceInteger("autosaveAtExit",  \autosaveAtExit)
    ; Stats
    WritePreferenceInteger("NbNewFile",     \NbNewFile)
    WritePreferenceInteger("NbMinutes",     \NbMinutes)
  EndWith
EndProcedure
Procedure CreateOptionsFile()
  If CreatePreferences("Pref.ini")
    WriteDefaultOption()
    ClosePreferences()
  EndIf
EndProcedure
Procedure OpenOptions()
  If OpenPreferences("Pref.ini")
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        pgn$ = PreferenceGroupName()
        If pgn$ = "General"
          With Options
            ; UI & program
            \Theme$         = ReadPreferenceString("Theme","data\themes\basic")
            \SpriteQuality  = ReadPreferenceInteger("Filtering",  1)
            \UseRighmouseToErase    = ReadPreferenceInteger("UseRighmouseToErase",   0)
            ; show
            \Statusbar      = ReadPreferenceInteger("Statusbar",  1)
            \Snap           = ReadPreferenceInteger("Snap",       1)
            \snapW          = ReadPreferenceInteger("snapW",      32)
            \snapH          = ReadPreferenceInteger("snapH",      32)
            \ShowOrigin     = ReadPreferenceInteger("ShowOrigin",       0)
            \Grid           = ReadPreferenceInteger("Grid",       1)
            \GridW          = ReadPreferenceInteger("GridW",      32)
            \GridH          = ReadPreferenceInteger("GridH",      32)
            \GridColor      = ReadPreferenceInteger("GridColor",  RGB(255,255,255))
            ; Options precedent file
            \Zoom           = ReadPreferenceInteger("Zoom",       100)
            ; exit
            \ConfirmExit    = ReadPreferenceInteger("ConfirmExit",   1)
            ; autosave
            \autosaveAtExit = ReadPreferenceInteger("autosaveAtExit",   0)
            \autosave       = ReadPreferenceInteger("autosave",   1)
            \AutosaveTime   = ReadPreferenceInteger("autosaveTime",   10)
            If \AutosaveTime <= 0
              \AutosaveTime = 1
            EndIf
            ; Paths
            \TilesetDefault$ = ReadPreferenceString("TilesetDefault$", "data\images\default.png")
            \DirTileset$ = ReadPreferenceString("DirTileset", "data\images\")
            \PathOpen$  = ReadPreferenceString("PathOpen", GetCurrentDirectory() +"save\")
            \PathSave$  = ReadPreferenceString("PathSave", GetCurrentDirectory() + "save\")
            ; statistics
            \NbNewFile       = ReadPreferenceInteger("NbNewFile", 1)
            \NbMinutes       = ReadPreferenceInteger("NbMinutes", 0)
          EndWith
        EndIf
      Wend
    EndIf
    ClosePreferences()
  Else
    CreateOptionsFile()
    OpenOptions()
    SaveOptions()
  EndIf
EndProcedure
Procedure SaveOptions()
  If OpenPreferences("Pref.ini")
    WriteDefaultOption()
    ClosePreferences()
  Else
    If CreatePreferences("Pref.ini")
      WriteDefaultOption() 
      ClosePreferences()  
    EndIf
  EndIf
EndProcedure


; File
Procedure VD_GetFileExists(filename$)
  
  If FileSize(filename$)<=0
    ProcedureReturn 0
  Else
    If MessageRequester(lang("Info"), lang("The file already exists. Do you want ot overwrite it ?"), #PB_MessageRequester_YesNo) = #PB_MessageRequester_No
      ProcedureReturn 1
    Else
      ProcedureReturn 0
    EndIf
  EndIf
  
EndProcedure

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
    TilesetCurrent = 0
    ImageCurrent = 0
    FreeArray(Layer())
    FreeArray(CopyTile())
    ;     FreeArray(Tileset())
    ;     FreeArray(TheImage())
    Global Dim Layer.sLayer(0)
    Layer_Add(0)
    Layer_UpdateList()
    Global Dim CopyTile.sTile(0)
    ReDim Tileset.sTileset(0)
    ReDim TheImage.sImageList(0)
    TileSet_UpdateList()
  EndIf
  
EndProcedure
Procedure Doc_Open()
  Filter$ = "All|*.txt;*.ted|tile editor document (*.ted)|*.ted|texte (*.txt)|"
  name$ = OpenFileRequester(Lang("Open a document"), Options\PathOpen$, Filter$, 0)
  If name$<>#Empty$
    
    ext$ =GetExtensionPart(name$)
    
    If ReadFile(0, name$)
      d$=","
      Doc_New(0)
      
      ; free the image to open the new image
      FreeArray(Tileset())
      FreeArray(TheImage())
      Global Dim TheImage.sImageList(0)
      Global Dim Tileset.sTileset(0)
      nbImage = -1
      nbTileSet = -1
      TilesetCurrent = 0
      
      While Eof(0) =0
        line$ = ReadString(0)
        index$ = StringField(line$, 1, d$)
        Select index$
            
          Case "info"
            u=2
            Version$ = StringField(line$, u, d$) : u+1
            Version.d = ValD(StringField(line$, u, d$)) : u+1
            ;Debug version
            
          Case "image"
            ;{ images
            nbImage+1
            i=nbImage
            ReDim TheImage.sImageList(i)
            u=2
            With TheImage(i)
              \name$ = StringField(line$, u, d$) : u+1
              ; \id = Val(StringField(line$, 3, d$))
              \scaleW = Val(StringField(line$, u, d$)) : u+1
              If \scaleW <=0
                \scaleW = 1
              EndIf
              \scaleH = Val(StringField(line$, u, d$)) : u+1
              If \scaleH <=0
                \scaleH = 1
              EndIf             
              \filename$ = StringField(line$, u, d$) : u+1
            EndWith
            If TheImage(i)\filename$ = #Empty$
              TheImage(i)\filename$ = GetCurrentDirectory()+ Options\DirTileset$ +TheImage(i)\name$ 
            EndIf
            ; Debug "image pour theimage: "+TheImage(i)\filename$ 
            ;}
            
          Case "map"
            ;{ map
            u=2
            w = Val(StringField(line$, u, d$)) : u+1
            h = Val(StringField(line$, u, d$)) : u+1
            tw = Val(StringField(line$, u, d$)) : u+1
            th = Val(StringField(line$, u, d$)) : u+1
            If w <=0 : w = 10 : EndIf
            If h <=0 : h = 10 : EndIf
            k=1
            If Version < 0.43
              k = 32
            EndIf
            MapW = SetMin(w, 1) * k
            MapH = SetMin(h, 1) * k
            If tw <=0 : tw = 32 : EndIf
            If th <=0 : th = 32 : EndIf
            TileW = SetMin(tw, 1)
            TileH = SetMin(th, 1)
            ;}
            
          Case "tileset"
            ;{ tileSet
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
              \tileH = Val(StringField(line$, u, d$)) : u+1
            EndWith
            ;}
            
          Case "layer"
            ;{ layer
            u=2
            j = Val(StringField(line$, u, d$)) : u+1
            If j>0
              Layer_Add()
            EndIf
            i = ArraySize(layer())
            With layer(i)
              \name$ = StringField(line$, u, d$) : u+1
              \view = Val(StringField(line$, u, d$)) : u+1
              \lock =  Val(StringField(line$, u, d$)) : u+1
              \depth =  Val(StringField(line$, u, d$)) : u+1
            EndWith
            Layer_UpdateList()
            ;}
            
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
            k=1
            If Version < 0.42
              k = 32
            EndIf
            x = Val(StringField(line$, u, d$))*k : u+1
            y = Val(StringField(line$, u, d$))*k : u+1
            TileX = Val(StringField(line$, u, d$)) : u+1
            TileY = Val(StringField(line$, u, d$)) : u+1
            ; the image for tile
            imagename$ = StringField(line$, u, d$) : u+1
            If imagename$ <> #Empty$
              If NBTile >=0
                TileID = ArraySize(layer(LayerId)\Tile())+1
              EndIf
              ; Debug "Add a tile : "+imagename$
              ok = 0
              
              ; check if it's the current image and tileset
;               For i=0 To ArraySize(TheImage())
;                 If TheImage(i)\name$ = imagename$
;                   ImageCurrent = i
;                   Break
;                 EndIf
;               Next
               
                   ; Set The TileSet image for the tile
              If TileSet(TilesetCurrent)\name$ <> imagename$ ; Or Not IsImage(#image_Tileset)
                For i=0 To ArraySize(TheImage())
                  If TheImage(i)\name$ = imagename$
                    Debug "image trouvé pour tileset inexistant : "+TheImage(i)\filename$ 
                    ImageCurrent = i
                    Tileset_SetProperties()
                    ok = 1
                    Break
                  EndIf
                Next
                ; not found the image ?
                If ok = 0
                EndIf
              EndIf
              
              ; Create the tile
              CreateTheTile(x, y)
              ; ReDim Layer(j)\Tile.sTile(i)
              i = ArraySize(layer(LayerId)\Tile())
              With Layer(j)\Tile(i)
                \imagename$ = imagename$
                \tileid = Val(StringField(line$, u, d$)) : u+1
                \usealpha = Val(StringField(line$, u, d$)) : u+1
                \lock = Val(StringField(line$, u, d$)) : u+1
                \visible = Val(StringField(line$, u, d$)) : u+1
                \type = Val(StringField(line$, u, d$)) : u+1
              EndWith
            EndIf
          
        EndSelect
      Wend

      CloseFile(0)
      StatusBarUpdate()
      TileSet_UpdateList()
      
      ;SortStructuredArray(layer(), #PB_Sort_Ascending, OffsetOf(sLayer\depth),  TypeOf(sLayer\depth))
      ;Layer_UpdateList()
    EndIf
  
  EndIf
EndProcedure
Procedure Doc_Save(saveas=0)
  
  Filter$ = "All|*.txt;*.ted|tile editor document (*.ted)|*.ted"
  If Options\Docname$ <>#Empty$ And saveas=0
    name$ =Options\Docname$
  Else
    name$ = SaveFileRequester(Lang("Save the document"), options\PathSave$, Filter$, 0)
  EndIf
  
  If name$<>#Empty$
    ext$ = GetExtensionPart(name$)
    If ext$ <>"txt"
      name$ = RemoveString(name$, ext$)+".txt"
    EndIf
    
    If VD_GetFileExists(name$) = 0
    
    If OpenFile(0, name$)
      d$ = ","
      ; add information
      WriteStringN(0, "info,"+#ProgramVersion+d$+#ProgramVersionNum+d$)
      ; +FormatDate("%dd/%mm/%yyyy", Date())+d$
      
      ; the Map
      WriteStringN(0, "map,"+Str(MapW)+d$+Str(MapH)+d$+Str(TileW)+d$+Str(TileH)+d$)
      
      ; images
      For i=0 To ArraySize(TheImage())
        With TheImage(i)
          info$ = "image,"+\name$+d$+Str(\scaleW)+d$+Str(\scaleH)+d$+\filename$+d$
          WriteStringN(0, info$)
        EndWith
      Next
      
      ; Layer
      For i=0 To ArraySize(layer())
      	With layer(i)
      	  info$="layer,"+Str(i)+d$+\name$+d$+Str(\view)+d$+Str(\lock)+d$+Str(\depth)+d$
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
  EndIf
  
EndProcedure
Procedure Autosave()
EndProcedure


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 375
; FirstLine = 6
; Folding = Cew+74f5-vh8
; EnableXP