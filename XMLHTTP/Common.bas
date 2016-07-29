Attribute VB_Name = "Common"
Option Explicit
Dim xmlHttpRequest As MSXML2.XMLHTTP
Dim xmlHttpHandler As CXMLHttpHandler

Sub Search()
    Dim x As Range
    Dim m As Integer
    
    m = [a65536].End(xlUp).Row
    
    ActiveSheet.Range("C1").Formula = "=COUNTA(A:A) -4"
    ActiveSheet.Range("C2").Formula = "=COUNTBLANK(B5:B" & m & ")"
    ActiveSheet.Range("A1") = Now()
    ActiveSheet.Range("C3") = 0

    
    For Each x In ActiveSheet.Range("A5:A" & m)
        Set xmlHttpRequest = New MSXML2.XMLHTTP
        Set xmlHttpHandler = New CXMLHttpHandler
        xmlHttpHandler.Initialize xmlHttpRequest, x
        With xmlHttpRequest
            .onreadystatechange = xmlHttpHandler
            .Open "GET", "http://dict.cn/" & x.Value, True
            .send
        End With
    
    Next
    
End Sub
