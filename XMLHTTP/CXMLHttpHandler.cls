VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CXMLHttpHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Const READYSTATE_COMPLETE = 4
Const HTTPSTATUS_SUCCESS = 200

Private m_xmlHttp As MSXML2.XMLHTTP
Private m_Address As Range

Public Sub Initialize(xmlHttpRequest As MSXML2.XMLHTTP, cellAddress As Range)
   Set m_xmlHttp = xmlHttpRequest
   Set m_Address = cellAddress
End Sub

Public Sub SendRequest()
    With m_xmlHttp
          .Open "GET", "http://dict.cn" & m_Address.Value, True
          .send
    End With
End Sub


Public Sub HandleResponse()
Attribute HandleResponse.VB_UserMemId = 0
' ---default method---
    Dim result As Variant

    If m_xmlHttp.readyState = READYSTATE_COMPLETE And m_xmlHttp.Status = HTTPSTATUS_SUCCESS Then
        result = ResultToArray(m_xmlHttp.responseText)
        m_Address.Offset(0, 1).Resize(1, UBound(result) + 1).Value = result
    
    
        ActiveSheet.Range("A2").Value = Now()
        ActiveSheet.Range("C3").Value = ActiveSheet.Range("A2").Value - ActiveSheet.Range("A1").Value
        If ActiveSheet.Range("C2").Value < 1 Then
            ActiveSheet.Range("C2").Formula = "=C1"
        End If
    
        DoEvents
    End If

End Sub

Private Function ResultToArray(ByVal responseText As String) As Variant

    Dim html As New HTMLDocument
    Dim i As Integer
    Dim x As Variant
    Dim s As String
    Dim sample() As String
    Dim result(4) As String
    
    On Error Resume Next
    
    s = Split(Split(responseText, "word-cont", 2)(1), "learn", 2)(0)
    
    html.body.innerHTML = Split(Split(s, "phonetic", 2)(1), "basic clearfix", 2)(0)
    result(0) = Trim(html.getElementsByTagName("span")(0).innerText) & "<br>" & Trim(html.getElementsByTagName("span")(1).innerText)
      
    html.body.innerHTML = Split(Split(s, "phonetic", 2)(1), "section def", 2)(0)
    result(1) = Replace(html.getElementsByClassName("basic clearfix")(0).innerText, vbCrLf, "<br>")
    
    html.body.innerHTML = Split(Split(s, "<h3>例句</h3>", 2)(1), "去句海，查更多例句", 2)(0)
    i = 1
    For Each x In html.getElementsByTagName("li")
        sample = Split(x.innerText, vbCrLf, 2)
        result(2) = result(2) & "(" & i & ")" & sample(0) & "<br>"
        result(3) = result(3) & "(" & i & ")" & sample(1) & "<br>"
        i = i + 1
    Next
    
    ResultToArray = result
    
End Function


Private Sub Class_Terminate()
    Set m_xmlHttp = Nothing
    Set m_Address = Nothing
End Sub
