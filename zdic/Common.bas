Attribute VB_Name = "Common"
Sub Zdic()

Dim Client As New WebClient
Client.BaseUrl = "http://www.zdic.net/"
Client.EnableAutoProxy = True
Client.FollowRedirects = True

Dim Request As New WebRequest
Request.Method = WebMethod.HttpGet
Request.RequestFormat = WebFormat.UrlEncoded
Request.Resource = "search/"
Request.AddQuerystringParam "c", "3"
Request.AddQuerystringParam "q", EncodeHelper.UrlEncode("บบ")


WebHelpers.EnableLogging = True

Dim Response As WebResponse
Set Response = Client.Execute(Request)

If Response.StatusCode = WebStatusCode.Ok Then
  Debug.Print Response.Content
Else
  Debug.Print "Error: " & Response.StatusCode & " - " & Response.Content
End If

End Sub
