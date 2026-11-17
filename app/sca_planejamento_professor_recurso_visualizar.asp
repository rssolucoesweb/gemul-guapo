<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
Response.Buffer = True

codigo = Trim(Request("codigo"))
if codigo = "" or not IsNumeric(codigo) then
    Response.Status = "400 Bad Request"
    Response.Write "Arquivo inválido."
    Response.End
end if

sql = "SELECT r.nome_arquivo,r.tipo_arquivo,r.arquivo_base64 FROM SCA_PLANEJAMENTO_PROFESSOR_RECURSO r " & _
      "INNER JOIN SCA_PLANEJAMENTO_PROFESSOR p ON p.cod_planejamento_professor=r.cod_planejamento_professor " & _
      "WHERE r.codigo=" & CLng(codigo) & " AND r.tipo='A' AND p.cod_empresa=" & CLng(session("codEmpresa"))

Set rsArquivo = cnn.Execute(sql)
if rsArquivo.EOF then
    rsArquivo.Close
    Set rsArquivo = Nothing
    Response.Status = "404 Not Found"
    Response.Write "Arquivo não encontrado."
    Response.End
end if

nomeArquivo = rsArquivo("nome_arquivo") & ""
tipoArquivo = rsArquivo("tipo_arquivo") & ""
base64 = rsArquivo("arquivo_base64") & ""

rsArquivo.Close
Set rsArquivo = Nothing

if tipoArquivo = "" then tipoArquivo = "application/octet-stream"

Set xmlDoc = Server.CreateObject("MSXML2.DOMDocument.6.0")
Set node = xmlDoc.createElement("base64")
node.dataType = "bin.base64"
node.text = base64
binario = node.nodeTypedValue
Set node = Nothing
Set xmlDoc = Nothing

Response.Clear
Response.ContentType = tipoArquivo
Response.AddHeader "X-Content-Type-Options", "nosniff"

if lcase(tipoArquivo) = "application/pdf" or left(lcase(tipoArquivo),6) = "image/" then
    Response.AddHeader "Content-Disposition", "inline; filename=""" & Replace(nomeArquivo,"""","") & """"
else
    Response.AddHeader "Content-Disposition", "attachment; filename=""" & Replace(nomeArquivo,"""","") & """"
end if

Response.BinaryWrite binario
Response.End
%>
