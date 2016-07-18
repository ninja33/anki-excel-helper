VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CWinHttp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private WithEvents WinHttp As WinHttp.winHTTPRequest
Attribute WinHttp.VB_VarHelpID = -1
Private Const url As String = "http://dict.cn/"
Private m_address As Range

Public Property Let CellAddress(r As Range)
      Set m_address = r
End Property
Public Sub SendRequest()
Set WinHttp = New WinHttp.winHTTPRequest
      With WinHttp
            '.SetProxy 2, "proxy.com:8080"
            .Open "GET", url & m_address.Value, True
            .Send
      End With
End Sub

Private Sub Class_Terminate()
    Set WinHttp = Nothing
End Sub

Private Sub winHttp_OnError(ByVal ErrorNumber As Long, ByVal ErrorDescription As String)
      Debug.Print ErrorNumber & " : " & ErrorDescription
End Sub

Private Sub winHttp_OnResponseFinished()
    Dim result As Variant
    
    On Error Resume Next
    
    result = resultFromHaici(WinHttp.responseText)
    m_address.Offset(0, 1).Resize(1, UBound(result)).Value = result
    
    ActiveSheet.Range("A2").Value = Now()
    ActiveSheet.Range("C3").Value = ActiveSheet.Range("A2").Value - ActiveSheet.Range("A1").Value

    If ActiveSheet.Range("C2").Value < 10 Then
        ActiveSheet.Range("C2").Formula = "=C1"
    End If
    
    DoEvents
End Sub

Private Function resultFromHaici(ByVal responseText As String) As Variant

    Dim html As New HTMLDocument
    Dim i As Integer
    Dim x, d As Variant
    Dim s As String
    Dim sample() As String
    Dim result(4) As String
    Dim definitions() As String
    Dim pos() As String
    
    On Error Resume Next
    
    s = Split(Split(responseText, "word-cont", 2)(1), "去句海，查更多例句", 2)(0)
    
    html.body.innerHTML = Split(Split(s, "phonetic", 2)(1), "basic clearfix", 2)(0)
    result(0) = Trim(html.getElementsByTagName("span")(0).innerText) & "&nbsp;" & Trim(html.getElementsByTagName("span")(1).innerText)
      
    html.body.innerHTML = Split(Split(s, "phonetic", 2)(1), "section def", 2)(0)
    definitions = Split(html.getElementsByClassName("basic clearfix")(0).innerText, vbCrLf)
    For Each d In definitions
        pos = Split(d, ".", 2)
        Select Case pos(0)
            Case "n"
                result(1) = result(1) & "<a class='pos_n'>n.</a>" & pos(1) & "<br>"
            Case "v", "vi", "vt"
                result(1) = result(1) & "<a class='pos_v'>" & pos(0) & ".</a>" & pos(1) & "<br>"
            Case "adj"
                result(1) = result(1) & "<a class='pos_a'>adj.</a>" & pos(1) & "<br>"
            Case Else
                result(1) = result(1) & "<a class='pos_r'>" & pos(0) & ".</a>" & pos(1) & "<br>"
        End Select
    Next d
    'result(1) = Replace(html.getElementsByClassName("basic clearfix")(0).innerText, vbCrLf, "<br>")
    
    html.body.innerHTML = Split(Split(s, "<h3>例句</h3>", 2)(1), "去句海，查更多例句", 2)(0)
    i = 1
    For Each x In html.getElementsByTagName("li")
        sample = Split(x.innerText, vbCrLf, 2)
        result(2) = result(2) & "(" & i & ")" & sample(0) & "<br>"
        result(3) = result(3) & "(" & i & ")" & sample(1) & "<br>"
        i = i + 1
    Next
    
    resultFromHaici = result
    
End Function

