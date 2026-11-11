<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
Response.Clear
Response.Buffer = True

codigo = CLng(Request.QueryString("codigo"))

sql = "SELECT NomeArquivo, base64 "
sql = sql & "FROM SCA_ALUNO_ARQUIVO "
sql = sql & "WHERE codigo = " & codigo

rs.Open sql, cnn

If Not rs.EOF Then

    nomeArquivo = rs("NomeArquivo")
    base64Arquivo = rs("base64")

    'Remove o prefixo caso exista:
    'data:application/pdf;base64,
    If InStr(base64Arquivo, ",") > 0 Then
        base64Arquivo = Mid(base64Arquivo, InStr(base64Arquivo, ",") + 1)
    End If

    Set xmlDoc = Server.CreateObject("MSXML2.DOMDocument")
    Set node = xmlDoc.createElement("base64")
    
    node.DataType = "bin.base64"
    node.Text = base64Arquivo

    arquivo = node.NodeTypedValue

    Response.ContentType = "application/pdf"
    Response.AddHeader "Content-Disposition", "inline; filename=""" & nomeArquivo & """"
    Response.BinaryWrite arquivo

    Set node = Nothing
    Set xmlDoc = Nothing

End If

rs.Close
%>