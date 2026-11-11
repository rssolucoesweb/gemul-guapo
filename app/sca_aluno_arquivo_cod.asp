<%@ Language="VBScript" %>
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
Response.Buffer = True
Response.Expires = -1
On Error Resume Next

' === Recebe dados do formulário ===
Dim tipo, descricao, nomeArquivo, arquivoBase64, cod_aluno
tipo = Trim(Request.Form("tipo"))
descricao = Trim(Request.Form("descricao"))
nomeArquivo = Trim(Request.Form("nomeArquivo"))
arquivoBase64 = Trim(Request.Form("arquivoBase64"))
cod_aluno = Trim(Request.Form("cod_aluno"))

If tipo = "" Or arquivoBase64 = "" Or cod_aluno = "" Then
    Response.Write "Dados inválidos!"
    Response.End
End If

' === Conexão com o banco ===
Dim sql

' ⚙️ Monta SQL dinamicamente, escapando aspas simples
descricao = Replace(descricao, "'", "''")
tipo = Replace(tipo, "'", "''")
nomeArquivo = Replace(nomeArquivo, "'", "''")
arquivoBase64 = Replace(arquivoBase64, "'", "''")

' ⚙️ Adiciona prefixo padrão de Base64
If Left(arquivoBase64, 5) <> "data:" Then
    arquivoBase64 = "data:application/pdf;base64," & arquivoBase64
End If


sql = "INSERT INTO SCA_ALUNO_ARQUIVO (cod_aluno, Tipo, Descricao, NomeArquivo, base64, usuario_incl, data_hora_incl) VALUES (" & _
      CLng(cod_aluno) & ", '" & tipo & "', '" & descricao & "', '" & nomeArquivo & "', '" & arquivoBase64 & "','" & session("usuarioWeb") & "',getdate())"

cnn.Execute sql

If Err.Number <> 0 Then
    Response.Write "Erro ao gravar no banco: " & Err.Description & "<br>SQL: " & sql
Else

	intCodEmp			= session("codEmpresa")
	intCodDepartamento	= Session("CodDeptoUsuario")
	intCodAluno			= cod_aluno
	intCodTaxa			= ""
	intCodBebitoAluno	= ""
	strDataOcorrencia	= formatadataBD(date)
	strUsuarioIncl		= trim(session("usuarioWeb"))
	strDataValidade		= ""
	strOcorrencia		= "Laudo " & descricao & " foi incluído!"
	%>
	<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
	<%

    Response.Write "Arquivo enviado e salvo com sucesso!"
End If

cnn.Close
Set cnn = Nothing
%>
