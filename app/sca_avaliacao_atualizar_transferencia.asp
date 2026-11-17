<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/plain"
Response.Expires = -1
Response.Buffer = True
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
' Endpoint POST: a empresa de destino vem exclusivamente da sessao.
If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    Response.Status = "405 Method Not Allowed"
    Response.Write "Método não permitido."
    Response.End
End If

Dim codAluno, anoLetivo, empresa, sql, rsAtualizacao, rsVerificacao
If Not IsNumeric(Request.Form("codAluno")) Or Not IsNumeric(Request.Form("anoLetivo")) Or Not IsNumeric(Session("CodEmpresa")) Then
    Response.Status = "400 Bad Request"
    Response.Write "Parâmetros inválidos."
    Response.End
End If
codAluno = CLng(Request.Form("codAluno"))
anoLetivo = CLng(Request.Form("anoLetivo"))
empresa = CLng(Session("CodEmpresa"))
If codAluno <= 0 Or anoLetivo <= 0 Or empresa <= 0 Then
    Response.Status = "400 Bad Request"
    Response.Write "Parâmetros inválidos."
    Response.End
End If

On Error Resume Next
sql = "EXEC dbo.SP_SCA_Verificar_Notas_Transferencia " & codAluno & "," & anoLetivo & "," & empresa
Set rsVerificacao = cnn.Execute(sql)
If Err.Number <> 0 Then
    Response.Status = "500 Internal Server Error"
    Response.Write "Falha ao validar transferência: " & Err.Description
    Response.End
End If
If rsVerificacao.EOF Or IsNull(rsVerificacao("LiberarAtualizacao")) Then
    Response.Status = "409 Conflict"
    Response.Write "Não existem notas pendentes de aproveitamento."
    Response.End
End If
If not rsVerificacao("LiberarAtualizacao") Then
    Response.Status = "409 Conflict"
    Response.Write "Atualização indisponível para este aluno."
    Response.End
End If
rsVerificacao.Close
Set rsVerificacao = Nothing
Err.Clear

cnn.CommandTimeout = 300

sql = "EXEC dbo.SP_SCA_Atualizar_Notas_Transferencia " & codAluno & "," & anoLetivo & "," & empresa
Set rsAtualizacao = cnn.Execute(sql)
If Err.Number <> 0 Then
    Response.Status = "500 Internal Server Error"
    Response.Write "Erro ao atualizar: " & Err.Description
    Response.End
End If
If rsAtualizacao Is Nothing Then
    Response.Status = "500 Internal Server Error"
    Response.Write "Procedure não retornou resultado."
    Response.End
End If
If rsAtualizacao.EOF Then
    Response.Status = "500 Internal Server Error"
    Response.Write "Procedure não retornou resultado."
    Response.End
End If
If IsNull(rsAtualizacao("Sucesso")) Then
    Response.Status = "500 Internal Server Error"
    Response.Write "Retorno inválido da procedure."
ElseIf CInt(rsAtualizacao("Sucesso")) = 1 Then
    Response.Write "OK"
Else
    Response.Status = "409 Conflict"
    Response.Write "Falha na atualização: " & rsAtualizacao("Mensagem")
End If
rsAtualizacao.Close
Set rsAtualizacao = Nothing
On Error GoTo 0
%>
