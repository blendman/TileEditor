; Tile editor April 2021 by blendman
; gadgets

; USefull functions 
Procedure AddButtonGadget(id, x, y, w, h, text$, tip$=#Empty$, Image=-1,toggle=-1)
  If image > 0
    If toggle = -1
      If ButtonImageGadget(id,x,y,w,h,ImageID(image)) : EndIf 
    Else
      If ButtonImageGadget(id,x,y,w,h,ImageID(image),#PB_Button_Toggle ) : EndIf 
    EndIf
  Else
    If ButtonGadget(id,x,y,w,h,text$) : EndIf 
  EndIf
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
Procedure AddCheckBoxGadget(id, x, y, w, h, text$, tip$=#Empty$, state=0)
  CheckBoxGadget(id, x, y, w, h, text$)
  SetGadgetState(id, state)
  GadgetToolTip(id,tip$)
EndProcedure


; main window
Macro AddBar()
  X+8
EndMacro
Procedure CreateGadgets()
  
  a = 2
  x = a
  Options\ToolBarH = 35
  ToolBarH = Options\ToolBarH
  y = 5
  b = 30
  ;{ Add toolbar
  AddButtonGadget(#G_ToolB_Pen,x,y,b,b,#Empty$, Lang("Add tiles")+Chr(9)+"P",#ico_IE_Pen,1) : x+b+2
  SetGadgetState(#G_ToolB_Pen, 1)
  AddButtonGadget(#G_ToolB_Brush,x,y,b,b,#Empty$, Lang("Paint tiles (even over existing tiles)")+Chr(9)+"B",#ico_IE_Brush,1) : x+b+2
  AddButtonGadget(#G_ToolB_Eraser,x,y,b,b,#Empty$, Lang("Delete the tiles")+Chr(9)+"E",#ico_IE_Eraser,1) : x+b+2
  AddButtonGadget(#G_ToolB_Select,x,y,b,b,#Empty$, Lang("Select the tiles (multi : Shift+leftbuton mouse over the tiles)")+Chr(9)+"M",#ico_IE_Select,1) : x+b+2
  AddButtonGadget(#G_ToolB_Move,x,y,b,b,#Empty$, Lang("Move the tiles")+Chr(9)+"V",#ico_IE_Move,1) : x+b+2
  AddBar()
  y+4
  AddCheckBoxGadget(#G_OptionSnap,x,y,50, 20, Lang("Snap"), LAng("Snap to the grid (When snap not use, you can't paint with mouseLeftclic+move, only with mouseLeftclic.)"), options\snap): x+GadgetWidth(#G_OptionSnap)+2
  AddSpinGadget(#G_OptionSnapW,x,y,60, 20, 1, 10000, LAng("Snap in X"), options\snapW): x+60+2
  AddSpinGadget(#G_OptionSnapH,x,y,60, 20, 1, 10000, LAng("Snap in Y"), options\snapH): x+60+2
  y+5
  ;}
  
  
  ; define some variables
  x = a
  y = screenY
  w = screenX-5
  h = screenH 
  w1 = w-15
  h1 = 400
  h2 = 25
  w2 = 70
  w3 = 120
  ; Add panel (tilset and tile properties)
  If PanelGadget(#G_panelTileSet, x, y, w, h)
    
    ;{ TileSet
    AddGadgetItem(#G_panelTileSet, -1, lang("Tileset"))
    
    ;{ add an image to test
    ;<-- temporary To test the program
    If LoadImage(#image_Tileset, GetCurrentDirectory()+ Options\DirTileset$ +"default.png")
      nbImage = -1
      nbImage +1
      ReDim TheImage.sImageList(nbImage)
      TheImage(nbImage)\name$ = "default.png"
      TheImage(nbImage)\filename$ = GetCurrentDirectory()+ Options\DirTileset$ +"default.png"
      TheImage(nbImage)\scaleW = 2
      TheImage(nbImage)\scaleH = 2
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
      ResizeImage(#image_Tileset, ImageWidth(#image_Tileset) * TheImage(nbImage)\scaleW , ImageHeight(#image_Tileset)* TheImage(nbImage)\scaleW,#PB_Image_Raw)
      wc = ImageWidth(#image_Tileset)+20
      hc = ImageWidth(#image_Tileset)+20
    EndIf
    ; -->
    ;}
    
    x = 5
    y = 5
   
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
    
    ;ComboBoxGadget(#G_TileSetLayer, x, y, w3, h2) :  x+w3+5
    ;GadgetToolTip(#G_TileSetLayer, Lang("Select the current Layer to add a tile on"))
    
    ;AddButtonGadget(#G_TileSetLayerAdd, x, y, h2, h2, Lang("+"), Lang("Set the layer (depth) For the current tile")) :  y+h2+5
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
    x = a
    y = 5
    If ScrollAreaGadget(#G_TileScroolArea, x, y, w1, h1, w1-25, hc, #PB_ScrollArea_BorderLess)
      x=5
      AddSpinGadget(#G_TileX, x, y, w2, h2, 0, MapW, lang("x position of Tile"), 0, lang("X")) : y +h2 +5 ; :  x=GadgetX(#G_TileX)+w2+5
      AddSpinGadget(#G_TileY, x, y, w2, h2, 0, MapH, lang("y position of Tile"), 0, lang("Y")) : y +h2 +5 ; :  x+w2+5
      ;y +h2 +5
      ;x = 5
      AddSpinGadget(#G_TileW, x, y, w2, h2, 0, 8096, lang("Tile Width"), 0, lang("W")) : y +h2 +5 ;  :  x=GadgetX(#G_TileW)+w2+5
      AddSpinGadget(#G_TileH, x, y, w2, h2, 0, 8096, lang("Tile Height"), 0, lang("H")) : y +h2 +5 ;  :  x+w2+5
      ;y +h2 +5
      ;x = 5
      AddSpinGadget(#G_TileLayer, x, y, w2, h2, 0, MapH, lang("Layer of the Tile"), 0, lang("Layer"))  : y +h2 +5 ; :  x=GadgetX(#G_TileLayer)+w2+5
      AddSpinGadget(#G_TileType, x, y, w2, h2, 0, MapH, 
                    lang("Type of the Tile (You use it to define some action for tile (teleporter, chest, pnj...)"), 0, lang("Type"))  : y +h2 +5 ; :  x+w2+5
     ; y +h2 +5
      ;x = 5
      CheckBoxGadget(#G_TileUseAlpha, x, y, w3, h2, Lang("Use alpha")) : y +h2 +5 ;  : x+w3+5
      ;y +h2 +5
     ; x = 5
      CheckBoxGadget(#G_TileVisible, x, y, w3, h2, Lang("Visible"), 1) : y +h2 +5 ;  : x+w3+5
      CheckBoxGadget(#G_TileLock, x, y, w3, h2, Lang("Lock"), 1)  : y +h2 +5 ; : x+w3+5
      CloseGadgetList()
    EndIf
    
    ;}
    
    CloseGadgetList()
  EndIf
  
  x = screenX+a*2+ScreenW
  y = screenY 
  w =  Options\PanelLayerW ; WindowWidth(#WinMain)-(screenX+10-screenW)
  h = screenH 
  If PanelGadget(#G_PanelLayer, x, y, w, h)
  
    ;{ layers
    AddGadgetItem(#G_PanelLayer, -1, "Layers")
    x = 5
    y = 5
    
    AddCheckBoxGadget(#G_LayerView, x,y,w2,h2,lang("View"), Lang("Set visible all tiles on the layer")) : x+w2+5
    AddCheckBoxGadget(#G_LayerLock, x,y,w2,h2,lang("Lock"), Lang("Lock all tiles on the layer)")) : y+h2+5
    x=5
    wl = 160
    If ScrollAreaGadget(#G_LayerList, x, y, wl, 200, wl-22, 200, #PB_ScrollArea_Single)
      If CanvasGadget(#G_LayerListCanvas, 0, 0, wl, 200)
        Layer_Add(0)
      EndIf
      CloseGadgetList()
    EndIf
    y+205
    AddButtonGadget(#G_LayerBtnAdd, x,y,h2,h2,lang("+"), lang("Add a new layer")) : x+h2+5
    AddButtonGadget(#G_LayerBtnDel, x,y,h2,h2,lang("-"), lang("Delete the selected layer and and its tiles")) : x+h2+5;: y+h+5
    AddButtonGadget(#G_LayerBtnMoveUp, x,y,h2,h2,lang("Up"), lang("Move the layer up")) : x+h2+5                      ;: y+h+5
    AddButtonGadget(#G_LayerBtnMoveDown, x,y,h2,h2,lang("Down"), lang("Move the layer down")) : x+h2+5                  ;: y+h+5

    ;}
    
    CloseGadgetList()
  EndIf
  
EndProcedure



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 70
; FirstLine = 12
; Folding = 5AaAAC9
; EnableXP