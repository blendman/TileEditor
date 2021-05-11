; tile editor


;-- Init 
CheckError(InitSprite(), 1, lang("Sprite system error (direct X or OpenGL error)"))
CheckError(InitKeyboard(), 1, lang("Keyboard error"))

;-- Image decoder/endcoder
CheckError(UsePNGImageDecoder(), 1, lang("PNG Image Decoder error"))
CheckError(UsePNGImageEncoder(), 1, lang("PNG Image Encoder error"))
CheckError(UseJPEGImageDecoder(), 1, lang("JPEG Image Decoder error"))
CheckError(UseJPEGImageEncoder(), 1, lang("JPEG Image Encoder error"))

;-- LoadImages
LoadImage2(#ico_IE_Pen, Options\Theme$+"pen.png") 
LoadImage2(#ico_IE_Brush, Options\Theme$+"brush.png") 
LoadImage2(#ico_IE_Eraser, Options\Theme$+"eraser.png") 
LoadImage2(#ico_IE_Select, Options\Theme$+"select.png") 
LoadImage2(#ico_IE_Move, Options\Theme$+"move.png") 




; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 14
; EnableXP