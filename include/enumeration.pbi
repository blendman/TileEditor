
#ProgramDate      = #PB_Compiler_Date ; 04/2021
#ProgramName      = "Tile Editor"
Enumeration
  
  ;-- StatusBar
  #StatusBar_WinMain =0
  #StatusBar_WinPAP
  
  ;{ Windows
  ;-- Windows
  #WinMain=0
  #WinMapProperties
  #WinPixelArtPaint
  #WinOther
  ;}
  
  ;{ menus 
  ;-- Menus
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
  #Menu_ViewShowGrid
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
  #Menu_toolChangeTile
  #Menu_toolDeleteTile
  #Menu_toolSelectTile
  #Menu_ToolMoveTile
  #Menu_toolTestMap
  ; -->
  ;}
  
  ;{ menu #WinPixelArtPaint
  ;}
  
  
  ;}
  
  ;{ Gadgets
  ;-- Gadgets
  
   #G_0 = 0
  ; by Window
  ;{ WinMain
  
  ;{ Toolbar
  #G_ToolBar
  ;{ Buttons tools (on toolbar)
  ; should be the same order like "actions-Tool" (see at the bottom of enumeration)
  #G_ToolB_Pen
  #G_ToolB_Brush
  #G_ToolB_Eraser
  #G_ToolB_Select
  #G_ToolB_Move
  
;   #G_ToolB_Spray
;   #G_ToolB_Particles
;   #G_ToolB_Fill
;   #G_ToolB_Text
;   #G_ToolB_Clear
;   #G_ToolB_Pipette   
;   #G_ToolB_Transform  
;   #G_ToolB_Rotate
  #G_ToolB_Hand
  #G_ToolB_Zoom ; Always the last of the tool !
             ;}
  ;}
  #G_OptionGrid
  #G_OptionSnap
  #G_OptionSnapW
  #G_OptionSnapH
  
  ; TileSet
  #G_PanelTileSet 
  #G_SA_TileSet ;  scrollarea
  #G_CanvasTileSet
  #G_TileSetTileW
  #G_TileSetTileH
  #G_TileSetUseAlpha
  #G_TileSetAlphacolor
  #G_TileSetChooseImg
  #G_TileSetAddImg
  #G_TileSetSetTileIDToTile
  #G_TileSetChoosefolder
  
  ; Tile
  #G_PanelProperties
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
  
  ; Layers
  #G_PanelLayer
  #G_LayerList
  #G_LayerListCanvas
  #G_LayerView
  #G_LayerLock
  #G_LayerBtnAdd
  #G_LayerBtnDel
  #G_LayerBtnMoveUp
  #G_LayerBtnMoveDown
  
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
  
  ;{ sprites
  ;-- Sprites
  #sp_Background = 1
  #sp_Grid
  ;}
  
  ;{ Images
  ;-- Images
  #Image_alphaColor  = 1
  #image_Tileset
  
  #ico_IE_Pen
  #ico_IE_Brush
  #ico_IE_Eraser
  #ico_IE_Fill
  #ico_IE_Clear
  #ico_IE_Pipette
  #ico_IE_Move
  #ico_IE_Scale
  #ico_IE_Shape  
  #ico_IE_Zoom  
  #ico_IE_Hand  
  #ico_IE_Select  
  #ico_IE_Particles  
  #ico_IE_Rotate
  #ico_IE_Text
  
  
  ; for pixel art paint artist
  #Image_PAPA 
  ;}
  
  ;{ actions-Tool
  ;-- Actions-Tool
  
  ; <-- attention : should be the same order as the menu tool and the Toolbar Tools !
  #Action_AddTile = 0
  #Action_ChangeTile
  #Action_DeleteTile
  #Action_SelectTile
  #Action_Move
  #Action_TestGame
  ;} -->
  
  ;{ Selection
  ;-- Selection
  #Selection_AllTiles =0
  #Selection_ByLayer
  #Selection_ByTileIMage
  #Selection_ByVisibility
  ;}
  
EndEnumeration


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 106
; FirstLine = 11
; Folding = 669
; EnableXP