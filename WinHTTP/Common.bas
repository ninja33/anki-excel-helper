Attribute VB_Name = "Common"
Dim winHTTPRequest() As New CWinHttp

Sub Search()
    Dim x As Range
    Dim m As String
    
    m = [a65536].End(xlUp).Row
    Debug.Print m
    ActiveSheet.Range("C1").Formula = "=COUNTA(A:A) -4"
    ActiveSheet.Range("C2").Formula = "=COUNTBLANK(B5:B" & m & ")"

    ActiveSheet.Range("A1") = Now()
    ActiveSheet.Range("C3") = 0
    
    ReDim winHTTPRequest(5 To m) As New CWinHttp
    
    For Each x In ActiveSheet.Range("A5:A" & m)
        With winHTTPRequest(x.Row)
            .CellAddress = x
            .SendRequest
        End With
    Next
End Sub

'Function saves cText in file, and returns 1 if successful, 0 if not
Sub WriteOut()

    
    Dim fsT, cText, tFilePath As String
    Dim x As Range
    Dim m As String
    
    tFilePath = Application.ActiveWorkbook.Path + "\anki.txt"
    Debug.Print tFilePath
    'Create Stream object
    Set fsT = CreateObject("ADODB.Stream")
    fsT.Type = 2
    fsT.Charset = "utf-8"

    'Open the stream And write binary data To the object
    fsT.Open
    fsT.writetext cText
    

    
    r = [a65536].End(xlUp).Row
    c = [a4].End(xlToRight).Column
    For Each x In ActiveSheet.Range("A5:A" & r)
        cText = ""
        For i = 0 To c - 1
            If i = c - 1 Then
                cText = cText & x.Offset(0, i).Text & vbCrLf
            Else
                cText = cText & x.Offset(0, i).Text & vbTab
            End If
        Next i
        fsT.writetext cText
    Next
    
    'Save binary data To disk
    fsT.SaveToFile tFilePath, 2
    MsgBox "文件:" & tFilePath & "已生成"

End Sub

