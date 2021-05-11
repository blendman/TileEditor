; tile editor

OpenOptions()

; init
Procedure AddLogError(error, info$)
  LogError$ +info$ + Chr(13)
  Date$ = FormatDate("%yyyy%mm%dd", Date()) 
  Thedate$= FormatDate("%yyyy/%mm/%dd(%hh:%ii:%ss)", Date())
  LogFile$ =  "save\logError.txt" ; "save\logError"+Date$+".txt"
  If OpenFile(0,    LogFile$, #PB_File_Append) 
    ; read and save the previous infos?
    WriteStringN(0, Thedate$)
    WriteString(0,  LogError$)
    CloseFile(0)
  Else
    If CreateFile(0,  LogFile$)
      WriteStringN(0, Thedate$ )
      WriteString(0,  LogError$)
      CloseFile(0)
    EndIf
  EndIf
EndProcedure


Procedure.s Lang(text$)
  ; ' will be changed with langages
  ProcedureReturn text$
EndProcedure

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 3
; Folding = -
; EnableXP