<%@ Language=VBScript %>
<%
Response.Buffer = True
Server.ScriptTimeout = 300

Dim codigo, sql, rs
Dim nomeArquivo, arquivoBase64, bytes

codigo = Request.QueryString("codigo")

If codigo = "" Or Not IsNumeric(codigo) Then
    Response.Write "Código inválido"
    Response.End
End If
%>
<!--#include file="includes/inc_cnn.asp"-->
<%
sql = "SELECT nome_arquivo, arquivo_base64 FROM sca_planejamento_arquivo WHERE codigo = " & CLng(codigo)
Set rs = cnn.Execute(sql)

If rs.EOF Then
    Response.Write "Arquivo não encontrado"
    Response.End
End If

nomeArquivo = "arquivo.pdf"
arquivoBase64 = rs("arquivo_base64")

arquivoBase64 = Replace(arquivoBase64, vbCr, "")
arquivoBase64 = Replace(arquivoBase64, vbLf, "")
arquivoBase64 = Replace(arquivoBase64, vbTab, "")
arquivoBase64 = Replace(arquivoBase64, " ", "+")

bytes = Base64Decode(arquivoBase64)

Response.Clear
Response.ContentType = "application/octet-stream"
Response.AddHeader "Content-Disposition", "attachment; filename=""arquivo.pdf"""
Response.BinaryWrite bytes
Response.End

Function Base64Decode(ByVal base64String)
    Dim xml, node
    Set xml = Server.CreateObject("MSXML2.DOMDocument")
    Set node = xml.createElement("base64")
    node.DataType = "bin.base64"
    node.Text = base64String
    Base64Decode = node.NodeTypedValue
End Function
%>