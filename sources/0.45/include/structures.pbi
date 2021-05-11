; tile editor


; Structure
Structure sTileset
  image.i
  w.w
  h.w
  name$
  usealpha.a
  alphacolor.i
  ; the tileW/H for the tile
  tileW.w
  tileH.w
  ; the scale for the image
  scaleW.d
  scaleH.d
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
  name$
  depth.w
  view.a
  lock.a
  Array Tile.sTile(0)
EndStructure
Global LayerId, TileID, tileID_byMouse, NBTile = -1
Global Dim Layer.sLayer(0)
Global Dim CopyTile.sTile(0)
Global NbLayers=-1

Structure sTheMap
  w.w
  h.w
  tileW.w
  tileH.w
  name$
  Color.i
EndStructure
Global TheMap.sTheMap
With TheMap
  \color = RGB(150,150,150)
  \w = 1024
  \h = 768
EndWith
Global MapW =640, MapH =640

Structure sOptions
  ; UI options
  Snap.a
  snapW.w
  snapH.w
  Grid.a
  GridW.w
  GridH.w
  GridColor.i
  ; UI
  ToolBarH.a
  PanelLayerW.w
  PanelTileSetW.w
  ColorBG.i
  ; show
  Statusbar.a
  ; program parameters
  Lang$
  Theme$
  SpriteQuality.a
  UseRighmouseToErase.a
  Zoom.w
  ; autosave
  Autosave.a
  AutosaveTime.a
  autosaveAtExit.a
  ConfirmExit.a
  AutoSaveIfQuit.a
  TilesetImage$
  ; statistics
  NbNewFile.w
  NbMinutes.i
  ; path
  DirTileset$
  PathOpen$
  PathSave$
  TilesetDefault$
  ; current document
  Docname$
  Layer.a
  UseAlpha.a
  AlphaColor.i
;   TilesetCurrentImage$

EndStructure
Global Options.sOptions
;{ options by default
With Options
  \Lang$ = "eng"
  \Theme$ = "data\themes\basic\"
  \DirTileset$ = "data\images\"
  \PathOpen$ = "save\"
  \PathSave$ = "save\"
  \ColorBG = RGB(100,100,100)
EndWith
;}

Structure sBrush
  size.w
  alpha.a
  color.i
  type.a
EndStructure
Global Dim brush.sBrush(1) ; 2 action for the brush (pixelArtPaint window) : paint, eraser
Global Action



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 120
; FirstLine = 47
; Folding = w4
; EnableXP