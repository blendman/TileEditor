; tile editor


; macros
Macro CheckError(function, endappli, error)
  If function = 0
    MessageRequester(Lang("Error"), error, #PB_MessageRequester_Error)
    AddLogError(1, error+" ("+Chr(34)+function+Chr(34)+")")
    If endappli = 1
      End
    EndIf
  EndIf
EndMacro 

Macro DeleteArrayElement(ar, el)
  For a=el To ArraySize(ar())-1
    ar(a) = ar(a+1)
  Next 
  ReDim ar(ArraySize(ar())-1)
EndMacro


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 21
; Folding = -
; EnableXP