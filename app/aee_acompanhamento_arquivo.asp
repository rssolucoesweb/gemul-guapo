<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
Function Base64Decode(ByVal base64String)
    Dim xmlDoc, node

    Set xmlDoc = Server.CreateObject("MSXML2.DOMDocument")
    Set node = xmlDoc.createElement("base64")

    node.DataType = "bin.base64"
    node.Text = base64String

    Base64Decode = node.nodeTypedValue

    Set node = Nothing
    Set xmlDoc = Nothing
End Function

intCodigo = 0

If Trim(Request.QueryString("codigo")) <> "" And IsNumeric(Request.QueryString("codigo")) Then
    intCodigo = CLng(Request.QueryString("codigo"))
End If

If intCodigo <= 0 Then
    Response.Status = "404 Not Found"
    Response.End
End If

sql = "SELECT R.Nome_Arquivo, R.Tipo_Arquivo, R.Arquivo_Base64 "
sql = sql & "FROM AEE_ACOMPANHAMENTO_RECURSO R "
sql = sql & "INNER JOIN AEE_ACOMPANHAMENTO A ON A.Cod_Acompanhamento = R.Cod_Acompanhamento "
sql = sql & "WHERE R.Cod_Recurso = " & intCodigo & " "
sql = sql & "AND R.Tipo_Recurso = 'A' "
sql = sql & "AND A.Cod_Empresa = " & CLng(Session("CodEmpresa"))

Set rsArquivo = Server.CreateObject("ADODB.Recordset")
rsArquivo.Open sql, cnn

If rsArquivo.EOF Then
    rsArquivo.Close
    Set rsArquivo = Nothing

    Response.Status = "404 Not Found"
    Response.End
End If

strNomeArquivo = Trim(CStr(rsArquivo("Nome_Arquivo")))
strTipoArquivo = Trim(CStr(rsArquivo("Tipo_Arquivo")))
strBase64 = CStr(rsArquivo("Arquivo_Base64"))

If strTipoArquivo = "" Then
    strTipoArquivo = "application/octet-stream"
End If

binArquivo = Base64Decode(strBase64)

rsArquivo.Close
Set rsArquivo = Nothing

strNomeHeader = Replace(strNomeArquivo, """", "")

Response.Clear
Response.Buffer = True
Response.ContentType = strTipoArquivo
Response.AddHeader "Content-Disposition", "attachment; filename=""" & strNomeHeader & """"
Response.BinaryWrite binArquivo
Response.End
%>
