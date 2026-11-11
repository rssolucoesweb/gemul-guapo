<%@LANGUAGE="VBScript" CODEPAGE="65001"%>
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
Response.ContentType = "text/plain"
Response.Charset = "utf-8"

' ==== CONEXÃO COM O BANCO ====
' Ajuste conforme seu ambiente:
Dim sql, id_arquivo

' ==== OBTÉM O ID DO ARQUIVO ====
id_arquivo = Request.Form("id_arquivo")

If id_arquivo = "" Then
    Response.Write "Erro: ID do arquivo não informado."
    Response.End
End If

' ==== EXECUTA A EXCLUSÃO ====
On Error Resume Next

sql = "select descricao, cod_aluno FROM SCA_ALUNO_ARQUIVO WHERE codigo = " & CLng(id_arquivo)
rs.open sql, cnn
if not rs.eof then
	intCodAluno = rs("cod_aluno")
	strDescricao = rs("descricao")
end if
rs.close

sql = "DELETE FROM SCA_ALUNO_ARQUIVO WHERE codigo = " & CLng(id_arquivo)
cnn.Execute sql

If Err.Number <> 0 Then
    Response.Write "Erro ao excluir: " & Err.Description
Else
	
	intCodEmp			= session("codEmpresa")
	intCodDepartamento	= Session("CodDeptoUsuario")
	'intCodAluno			= intCodAluno
	intCodTaxa			= ""
	intCodBebitoAluno	= ""
	strDataOcorrencia	= formatadataBD(date)
	strUsuarioIncl		= trim(session("usuarioWeb"))
	strDataValidade		= ""
	strOcorrencia		= "Laudo " & strDescricao & " foi excluído!"
	%>
	<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
	<%
	
	Response.Write "OK"
End If

On Error GoTo 0
cnn.Close
Set cnn = Nothing
%>
