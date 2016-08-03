Attribute VB_Name = "EncodeHelper"
Public Function UrlEncode(ByRef szString As String) As String

       Dim szChar   As String
       Dim szTemp   As String
       Dim szCode   As String
       Dim szHex    As String
       Dim szBin    As String
       Dim iCount1  As Integer
       Dim iCount2  As Integer
       Dim iStrLen1 As Integer
       Dim iStrLen2 As Integer
       Dim lResult  As Long
       Dim lAscVal  As Long
       szString = Trim$(szString)
       iStrLen1 = Len(szString)
       For iCount1 = 1 To iStrLen1
           szChar = Mid$(szString, iCount1, 1)
           lAscVal = AscW(szChar)
           If lAscVal >= &H0 And lAscVal <= &HFF Then
              If (lAscVal >= &H30 And lAscVal <= &H39) Or _
                 (lAscVal >= &H41 And lAscVal <= &H5A) Or _
                 (lAscVal >= &H61 And lAscVal <= &H7A) Then
                 szCode = szCode & szChar
              Else
                 szCode = szCode & "%" & Hex(AscW(szChar))
              End If
           Else
              szHex = Hex(AscW(szChar))
              iStrLen2 = Len(szHex)
              For iCount2 = 1 To iStrLen2
                  szChar = Mid$(szHex, iCount2, 1)
                  Select Case szChar
                         Case Is = "0"
                              szBin = szBin & "0000"
                         Case Is = "1"
                              szBin = szBin & "0001"
                         Case Is = "2"
                              szBin = szBin & "0010"
                         Case Is = "3"
                              szBin = szBin & "0011"
                         Case Is = "4"
                              szBin = szBin & "0100"
                         Case Is = "5"
                        szBin = szBin & "0101"
                         Case Is = "6"
                              szBin = szBin & "0110"
                         Case Is = "7"
                              szBin = szBin & "0111"
                         Case Is = "8"
                              szBin = szBin & "1000"
                         Case Is = "9"
                              szBin = szBin & "1001"
                         Case Is = "A"
                              szBin = szBin & "1010"
                         Case Is = "B"
                              szBin = szBin & "1011"
                         Case Is = "C"
                              szBin = szBin & "1100"
                         Case Is = "D"
                              szBin = szBin & "1101"
                         Case Is = "E"
                              szBin = szBin & "1110"
                         Case Is = "F"
                              szBin = szBin & "1111"
                         Case Else
                  End Select
              Next iCount2
              szTemp = "1110" & Left$(szBin, 4) & "10" & Mid$(szBin, 5, 6) & "10" & Right$(szBin, 6)
              For iCount2 = 1 To 24
                  If Mid$(szTemp, iCount2, 1) = "1" Then
                     lResult = lResult + 1 * 2 ^ (24 - iCount2)
                  Else: lResult = lResult + 0 * 2 ^ (24 - iCount2)
                  End If
              Next iCount2
              szTemp = Hex(lResult)
                    szCode = szCode & "%" & Left$(szTemp, 2) & "%" & Mid$(szTemp, 3, 2) & "%" & Right$(szTemp, 2)
           End If
szBin = vbNullString
           lResult = 0
       Next iCount1
       UrlEncode = szCode
End Function

Function URLDecode(ByVal What)
 'URL decode Function
'2001 Antonin Foller, PSTRUH Software, http://www.motobit.com
   Dim Pos, pPos

  'replace + To Space
   What = Replace(What, "+", " ")

  On Error Resume Next
  Dim Stream: Set Stream = CreateObject("ADODB.Stream")
  If Err = 0 Then 'URLDecode using ADODB.Stream, If possible
     On Error GoTo 0
    Stream.Type = 2 'String
     Stream.Open

    'replace all %XX To character
    Pos = InStr(1, What, "%")
    pPos = 1
    Do While Pos > 0
      Stream.WriteText Mid(What, pPos, Pos - pPos) + _
        Chr(CLng("&H" & Mid(What, Pos + 1, 2)))
      pPos = Pos + 3
      Pos = InStr(pPos, What, "%")
    Loop
    Stream.WriteText Mid(What, pPos)

    'Read the text stream
    Stream.Position = 0
    URLDecode = Stream.ReadText

    'Free resources
    Stream.Close
  Else 'URL decode using string concentation
    On Error GoTo 0
    'UfUf, this is a little slow method.
    'Do Not use it For data length over 100k
    Pos = InStr(1, What, "%")
    Do While Pos > 0
      What = Left(What, Pos - 1) + _
        Chr(CLng("&H" & Mid(What, Pos + 1, 2))) + _
        Mid(What, Pos + 3)
      Pos = InStr(Pos + 1, What, "%")
    Loop
    URLDecode = What
  End If
End Function
