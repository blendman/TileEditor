; "tile editor" (map editor with tileset)
; by blendman since 28 april 2021
; licence MIT

; infos

;{ TODO
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
; ok - edit : copie/paste selection
; ok - edit : erase (all, selected, layer)
; ok - preference (options) save/load
; - windowpreference
; ok - Tile_move
; v 0.4 :
; ok - layer combobox and buton +
; ok - Clic on buton layer + : open Window layer
; ok - Panel layer with gadgets ok (add, delete, rename, view, lock)
; ok - Panel layer : move up/down
; - menu file : export as level, export as pb example ?
; v 0.5 :
; ok - menu selection : select all, deselect all.
; - selection (+options) : all, by tileid, line/column, invert, by layer, selected tile visible, lock,...
; - selection (+options) : rectangle, clic. Selection add (+shift), supp(+ctrl)
; ok - tool move (move selection)
; v 0.6 :
; - tile animated (scroll, add tile frame, drawn animated), type (loop, ping-pong)
; - undo/redo (like script)
; v 0.7 :
; ok - window pixelartpaint (pap) : panel tool, canvas, zoom, movecanvas, grid/checker.
; ok - pixelartpaint : brush, eraser, pickcolor
; v 0.8 :
; - Edit : change tile properties
; v 0.9 :
; v 1.0 :
; - pixelartpaint : select, layer, save image, open, clean layer, copy/paste
; - pap : add/delete frame, play/stop animation, oignon skinning. timeline (fond, key, cursor, add/delete keyframe, copy/paste, move keyframe)
;}

;--- URGENT
; - Change Layer tiles (position)

;{ CHANGELOG
;--- CHANGELOG

; 10.5.2021 (0.4.5)
;// Changes
; - use options\DirTileset$ when add an new to the image list.
; // Fixes
; - When change the tileset image, the tileset image is'nt updated if the tileset already exists
; - When change the tileset, the image of alphacolor isn't updated
; - When change the tileset, the image tileset isn't updated if we change the tileset
; - Doc_new : TileSet_UpdateList() isn't updated
; - Doc_Open : use not options\PathOpen$
; - Doc_Open : Tileset()\tileH was always= 1
; - Doc_Save : use not options\PathSave$
; - SnapW/H aren't change when change the snapW/H gadgets
; - Fixe some bugs when we use a gadget oevr the screen, the eventgagdet does'nt work



; 9.5.2021 (0.4.4)
;// New
; - MapPriperties window : now mapW/mapH is full
; - options : save/load snapW/H
;// Changes
; - lots of changes with the new system for map size and snapW/H
;// Fixes
; - Doc_open : image list hasn't filename$
; - Doc_open : Tile has'nt the good tileset image
; - Doc_open : TileSet list isn't updated


; 8.5.2021 (0.4.3)
;// New
; - add themap\color to set the color of the background (#sp_Background)
;// Changes
; - changes the system for creating tile : not use tileW/tileH but SNap? 
; - mapW/H is now full not mapw*TileW, but MapW=1024 for example
; - Code is now separate in several little files (enumration.pbi, structures.pbi....

; 7.5.2021 (0.4.2)
;// New
; - Select : use key leftctrl to get out a selected tile from the selection
; - Add Options\snap (+save/load options)
; - Add Grid
; - Add Toolbar + butons tools : pen, brush, eraser, select, move.
; - Add Panel layer (right)
;// Changes
; - Change the size of the screen & the TileSet Panel with the 2nd panel (layer)
;// Fixes
; - change tileset image : the new image isn't resized avec its scale
; - change tileset image : the canvas isn't resized
; - change tileset image : the scrollarea (for canvas tileset) isn't resized
; - Add image to imagelist : when change the image, the gadget image -preview isn't updated
; - Add image to imagelist : the scale isn't updated when open the window
; - Add image to imagelist : the scale isn't updated when change the image preview
; - Add image to imagelist : the scale isn't Saved when change the image preview
; - Doc_open : Bug whith Layer: isn't added.

; 6.5.2021 (0.3.8)
;// New
; - Layer_changepos() : move the layer Depth.
; - new tool : move tile 
; - tile_move(x,y)
; - clic on buton layer delete -> layer_delete()
; - doc_open : add Layer() and properties (name, view, lock)
; - doc_save : add Layer() and properties (name, view, lock)
; - Window ImageTileset : add string scaleW/H
; - Window ImageTileset : set scaleW/H to TheImage()
; - When choose the ImageTileset : use  scaleW/H to draw the image on canvas and tile.
; - CheckError(), AddLogError()
; - Now, I check if there is an init error (initsprite, keyboard, image decoder/encoder..)
; - options : add TilesetDefault$
; - add a default TileSet image (Made by Buch https://opengameart.org/users/buch)
;// Fixes
; - when change image on tile, the layer()\tile()\image, tileID, etc aren't updated
; - when create a layer, the gadgets arent updated

; 5.5.2021 (0.3.0)
;// New
; - Clic on buton layer + : open Window layer
; - Menu : shortcut Cut, Copy, Paste, doc_new/open/save
;// Fixes
; - paste Tiles : tile aren't at the good position (by at the old)

; 4.5.2021 (0.2.5)
;// New
; - Add : TheMap.sTheMap
; - Panel Tile : add w/H
; - Image list : add scalew/H to resize image if needed.
; - Add list Thelayer.Layer()
; - Change the TileW/H with gagdets on TileSet panel
; - Edit : copy Tiles
; - Edit : paste Tiles
;// Changes
; - UpdateTileSetCanvas use TileSet\TileW & TileH
; - CreateTheTile use TileSet\TileW & TileH
; - change gadgets layer to layer combobox & buton + (to manage layers)
; - Add CreateGadgets() for main window
; - AddCheckBoxGadget() to create easily checkbox
;// Fixes
; - Tile with tileset with alpha aren't transparents (even with usealpha)
; - fixe some bugs
; - when delete/erase tiles, in some case, a tile isnt properly erased

; 3.5.2021 (0.2.2)
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



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 69
; FirstLine = 39
; Folding = -
; EnableXP