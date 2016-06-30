## Excel User Defined Function e2c(w, f)

#### Purpose:

This udf will be used to perform online inquery based on below 5 dictionaries.

1. 有道
2. 百度
3. 必应
4. 词霸
5. 海词(with sample)

#### Usage:
`=e2c(w, f)` 

Parameter "w" is the english word itself to be queried

Parameter "f" is for inquery function indicator

- "e" for explaination
- "p" for pronounciation
- "s" for sample sentence


For example, it you want to query word "test" for its chinese meaning, select a cell, like A1, and input `=e2c("test","e")`, then the cell will display the chinese. 

You also can use cell reference in udf. for example, you input "test" in cell "A1", then input `=e2c(A1, "p")` in cell "A2", the cell A2 will display the pronounciation of word "test"

---
#### Code sample:

Below is sample for dict.cn(海词)

```vba
Option Explicit

Function e2c(w As String, f As String) As String
On Error Resume Next
Dim html As New HTMLDocument, url, p, i, s
    With CreateObject("MSXML2.XMLHTTP") 'CreateObject("WinHttp.WinHttpRequest.5.1")'

       url = "http://dict.cn/" & w
        Debug.Print url
        .Open "GET", url, True
        .setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        .setRequestHeader "Referer", ""
        .Send

        While .readyState <> 4
              DoEvents
        Wend

        html.body.innerHTML = .responsetext

        Select Case f
        Case "e"
            e2c = Replace(html.getElementsByClassName("basic clearfix")(0).innerText, vbCrLf, "<br>")
        Case "p"
            html.body.innerHTML = html.getElementsByClassName("phonetic")(0).innerHTML
            e2c = Trim(html.getElementsByTagName("span")(0).innerText) & "<br>" & Trim(html.getElementsByTagName("span")(1).innerText)
        Case "s"
            html.body.innerHTML = html.getElementsByClassName("layout sort")(0).innerHTML
            For Each s In html.getElementsByTagName("li")
                e2c = e2c & Replace(s.innerText, vbCrLf, "<br>") & "<br>"
            Next
        Case Else
            e2c = Replace(html.getElementsByClassName("basic clearfix")(0).innerText, vbCrLf, "<br>")
        End Select
    End With
End Function
```
---
#### Change dict service:

Above sample is for 海词 online dict, replace below `url` if need different dictionary service

Below is inquery url

- 有道

`url = "http://dict.youdao.com/search?q=" & w`
- 百度

`url = "http://dict.baidu.com/s?wd=" & w`
- 必应

`url = "http://cn.bing.com/dict/search?q=" & w`
- 词霸

`url = "http://www.iciba.com/" & w`

below is inquery result

- 有道

```
e2c = html.getElementsByClassName("baav")(0).innerText
e2c = html.getElementsByClassName("trans-container")(0).innerText
```
- 百度

```
e2c = Replace(html.getElementById("pronounce").innerText, w, "")
e2c = html.getElementsByClassName("tab-content")(0).innerText
```
- 必应

```
e2c = html.getElementsByClassName("hd_p1_1")(0).innerText
e2c = html.getElementsByTagName("ul")(1).innerText
```
- 词霸

```
e2c = html.getElementsByClassName("prons")(0).innerText
e2c = html.getElementsByClassName("group_pos")(0).innerText
```

