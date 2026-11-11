<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 26/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: CCadastro de Ocorrencia
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_EnviarEmail.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo		 		= Trim(Request.Form("txtCodigo"))
	intCodDepartamento		= Trim(Request.Form("cmbDepartamento"))
	intCodColaborador 		= Trim(Request.Form("txtCodFuncionario"))
	strDataOcorrencia 		= FORMATADATABD(Trim(Request.Form("txtDataOcorrencia"))) & " " & time
	strDataValidade 		= FORMATADATABD(Trim(Request.Form("txtDataValidade")))
	strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
	strTipoOcorrencia		= Trim(Request.Form("cmbTipoOcorrencia"))
    
	strAnoLetivo = session("strAnoLetivo")
	intSemestre  = session("strSemestre")
	
				
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_OCORRENCIA(COD_EMPRESA, COD_DEPARTAMENTO, COD_Colaborador, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodDepartamento & ","
		sql = sql & "" & intCodColaborador & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strDataOcorrencia & "',"
		sql = sql & "'" & strDataValidade & "',"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & Session("UsuarioWeb") & "')"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_OCORRENCIA Set"
		'sql = sql & " COD_DEPARTAMENTO = " & intCodDepartamento & ","
		sql = sql & " COD_Colaborador = " & intCodColaborador & ","
		sql = sql & " DATAOCORRENCIA = '" & strDataOcorrencia & "',"
		sql = sql & " DATAVALIDADE = '" & strDataValidade & "',"
		sql = sql & " OCORRENCIA = '" & strOcorrencia & "'"
		sql = sql & " where COD_OCORRENCIA = " & intCodigo
		sql = sql & " and COD_empresa = " & intCodEmp
	else
	
		strMensagem = "Registro Excluido com sucesso..."

		sql = "Delete from SRH_OCORRENCIA "
		sql = sql & " where COD_OCORRENCIA = " & intCodigo
		sql = sql & " and COD_empresa = " & intCodEmp
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------


		'-----------------------------------------------------------------------------------
		' INICIO - Dados Para Envio de E-mail
		strDadosAluno = ""	
		sql=" SELECT cpf, nome FROM SRH_COLABORADOR "
		sql=sql & " WHERE CODIGO = " & intCodColaborador
		rs.open sql, cnn
		if not rs.eof then
		   strDadosColaborador = rs("cpf") & " - " & rs("NOME")	
		end if
		rs.close	

		strEmail = ""	
		sql=" SELECT EMAIL_FINANCEIRO, EMAIL_DOMINIO FROM SEG_EMPRESA "
		sql=sql & " WHERE CODIGO = " & Session("CodEmpresa") 
		rs.open sql, cnn
		if not rs.eof then
		   strEmail				= rs("EMAIL_FINANCEIRO")
		   strEmailOrigem		= rs("EMAIL_DOMINIO")
		   if isnull(strEmail) then strEmail = ""
		   if isnull(strEmailOrigem) then strEmailOrigem = ""
		end if
		rs.close	
		
		nomeresponsavel = ""	
		sql=" SELECT NOME, EMAIL FROM SRH_COLABORADOR "
		sql=sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA =  '" & Session("UsuarioWeb") & "'"
		rs.open sql, cnn
		if not rs.eof then
		   nomeresponsavel		= rs("nome")	
		end if
		rs.close	
		
		strAssuntoEmail	 = "Ocorrência Administrativas"  
		strMensagemEmail = "<br> Lançamento realizado por: " & nomeresponsavel & "<br>"
		strMensagemEmail = strMensagemEmail & "CPF/Nome: " & strDadosColaborador & "<br>"
		strMensagemEmail = strMensagemEmail & "Ocorrência: " & strOcorrencia & "<br>"
		
		if strEmail <> "" and strEmailOrigem <> "" then 
		   'Envia um email
		   'EnviarEmail strEmailOrigem, strEmail, strAssuntoEmail, strMensagemEmail
		end if
		
		' FIM - Dados Para Envio de E-mail
		'----------------------------------------------------------------------------------------

		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Ocorrencia_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>