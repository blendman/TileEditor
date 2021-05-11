; tile editor 
; Declaration
Declare AddLogError(error, info$)
; utilities
Declare.l Min(a,b)
Declare SetMin(a, min)
Declare.l Max(a, b)
Declare SetMaximum(a, b)
Declare FreeSprite2(sprite)
Declare LoadImage2(image,filename$)
; Init
Declare.s Lang(text$)
; Menu
Declare CreateTheMenu()
Declare CreateTheStatusBar()
Declare StatusBarUpdate()
; gadgets
Declare AddSpinGadget(id, x, y, w, h, min, max, tip$=#Empty$, val=0, name$=#Empty$)
Declare AddButtonGadget(id, x, y, w, h, text$, tip$=#Empty$, Image=-1,toggle=-1)
Declare CreateGadgets()
; TileSet
Declare TileSet_UpdateList()
Declare TileSet_AddImageToList(window=1)
Declare TileSet_UpdateCanvas(x=0, y=0)
Declare Tileset_SetProperties()
Declare TileSet_SetAlphaColor(color)
Declare TileSet_GetNb()
Declare TileSet_Add()
; Tiles
Declare Tile_GetProperties(mode=0)
Declare Tile_SetProperties(EventGadget)
Declare Tile_Select(All=1, SelectionType=#Selection_AllTiles)
Declare Tile_Copy()
Declare Tile_Paste(x1,y1)
Declare Tile_Delete(idlayer, idtile, del_Element=1)
Declare Tile_Erase(mode)
Declare Tile_Move(x,y)
Declare Tile_UpdateImage(j,i)
Declare CreateTheTile(x, y)
; layers
Declare Layer_Add(add=1)
Declare Layer_Delete()
Declare Layer_GetLayerId()
Declare Layer_UpdateList(all=-1)
Declare Layer_ChangePos(up=1)
; Windows
Declare WinMapProperties()
Declare WinPixelArtPaint()
; File
Declare OpenOptions()
Declare SaveOptions()
Declare Doc_New(window=1)
Declare Doc_Open()
Declare Doc_Save(saveas=0)
Declare Autosave()
; screen et tiles
Declare FPS()
Declare UpdateSpriteUtils()
Declare Screen_DrawGrid()



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 21
; FirstLine = 6
; EnableXP