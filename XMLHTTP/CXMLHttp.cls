VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CXMLHttp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'---------------------------------------------------------------------------------------
' Module    : clsAsyncHTTP
' Author    : rick cooney (ace)
' Date      : 9/1/2013
' Purpose   : Make an asynchronous HTTP request to a URL
'             and receive a response
'---------------------------------------------------------------------------------------

Option Explicit

Const READYSTATE_COMPLETE = 4
Const HTTPSTATUS_SUCCESS = 200

Private m_oXmlHttp As MSXML2.XMLHTTP
Private m_ServiceURL As String
Private m_responseText As String
Private m_responseXML As String
Private m_range As Range

Public Event ResponseReady(ByVal ready As Boolean)

Public Sub HandleResponse()
Attribute HandleResponse.VB_UserMemId = 0
 '---default method---
 If m_oXmlHttp.readyState = READYSTATE_COMPLETE And m_oXmlHttp.Status = HTTPSTATUS_SUCCESS Then
   RaiseEvent ResponseReady(True)
 End If
End Sub

Public Property Let serviceURL(url As String)
 m_ServiceURL = url
End Property

Public Property Get Headers() As String
 Headers = m_oXmlHttp.getAllResponseHeaders
End Property

Public Property Get ReponseText() As String
 Dim html As New HTMLDocument
 html.body.innerHTML = m_oXmlHttp.responseText
 ReponseText = Replace(html.getElementsByClassName("basic clearfix")(0).innerText, vbCrLf, "<br>")
End Property

Public Property Get ReponseXML() As String
 
 On Error GoTo errHandler

 GetReponseXML = m_oXmlHttp.responseXML

exitHere:
 On Error GoTo 0
 Exit Property

errHandler:

 ReponseXML = "Error " & Err.Number & " (" & Err.Description & ") in procedure GetReponseXML of Class Module clsAsyncHTTP"
 Resume exitHere
End Property

Public Property Get StatusCode() As String
 StatusCode = m_oXmlHttp.statusText
End Property

Public Property Get HasServiceURL() As Boolean
 HasServiceURL = Len(m_ServiceURL) > 0
End Property

Public Sub GetRequest(Optional serviceURL As Variant, Optional action As Variant)
'errors need to be handled in the calling code of the client
Dim thisRequest As String
  
'Example:

'serviceURL: "http://services.aonaware.com/DictService/DictService.asmx/"
'    action: "Define?word="

If IsMissing(action) Then
  action = ""
End If

If Not IsMissing(serviceURL) Then
  m_ServiceURL = serviceURL
End If

If m_ServiceURL = "" Then
  Err.Raise vbObjectError + 1001, "clsAsyncHTTP.GetRequest()", "The Service URL has not been set"
End If
 
thisRequest = m_ServiceURL & action
 
Set m_oXmlHttp = New MSXML2.XMLHTTP
 
 m_oXmlHttp.Open "GET", thisRequest, True
 m_oXmlHttp.setRequestHeader "Content-Type", "text/html"
 
 'this sets the onreadystatechange call back to an instance of this object
 'which causes the default method HandleResponse to be called when the ready
 'state changes
 m_oXmlHttp.onreadystatechange = Me
 m_oXmlHttp.send

End Sub


Private Sub Class_Terminate()
 Set m_oXmlHttp = Nothing
End Sub
