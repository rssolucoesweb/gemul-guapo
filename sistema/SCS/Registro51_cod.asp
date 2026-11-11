<!--
	::	Data de Criação...: 01/07/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Cadastro de Profissional Escolar em Sala de Aula - Dados de Docência - Registro 51
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 											= Trim(Request.QueryString("acao"))
	intCodEmpresa									= Trim(Request.Form("txtCodEmpresa"))
	strTipoRegistro							= Trim(Request.Form("txtTipoRegistro"))
	intCodEscolaInep	 					= Trim(Request.Form("txtCodEscolaInep"))
	strIdentificacaoProssionalInep			= Trim(Request.Form("txtIdentificacaoProssionalInep"))
	strCodProfissionalEscola				= Trim(Request.Form("txtCodProfissionalEscola"))
	
	strCodTurmaINEP							= Trim(Request.Form("txtCodTurmaINEP"))
	strCodTurmaEntidadeEscola				= Trim(Request.Form("txtCodTurmaEntidadeEscola"))
	strFuncaoExerceEscolaTurma				= Trim(Request.Form("cmbFuncaoExerceEscolaTurma"))
	strSituacaoTipoVinculo					= Trim(Request.Form("cmbSituacaoTipoVinculo"))
	strCodDisciplina1						= Trim(Request.Form("cmbCodDisciplina1"))
	strCodDisciplina2						= Trim(Request.Form("cmbCodDisciplina2"))
	strCodDisciplina3						= Trim(Request.Form("cmbCodDisciplina3"))
	strCodDisciplina4						= Trim(Request.Form("cmbCodDisciplina4"))
	strCodDisciplina5						= Trim(Request.Form("cmbCodDisciplina5"))
	strCodDisciplina6						= Trim(Request.Form("cmbCodDisciplina6"))
	strCodDisciplina7						= Trim(Request.Form("cmbCodDisciplina7"))
	strCodDisciplina8						= Trim(Request.Form("cmbCodDisciplina8"))
	strCodDisciplina9						= Trim(Request.Form("cmbCodDisciplina9"))
	strCodDisciplina10						= Trim(Request.Form("cmbCodDisciplina10"))
	strCodDisciplina11						= Trim(Request.Form("cmbCodDisciplina11"))
	strCodDisciplina12						= Trim(Request.Form("cmbCodDisciplina12"))
	strCodDisciplina13						= Trim(Request.Form("cmbCodDisciplina13"))

	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	if acao="I" then
		
		strMensagem = "Cadastro de Profissional Escolar em Sala de Aula - Dados de Docência - Registro 51, Salva com sucesso..."
		
		sql = "Delete From REGISTRO51 "
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO51( CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoProssionalInep, CodProfissionalEscola, "
		sql = sql & " CodTurmaINEP, CodTurmaEntidadeEscola, FuncaoExerceEscolaTurma, SituacaoTipoVinculo,  "
		sql = sql & " CodDisciplina1, CodDisciplina2, CodDisciplina3, CodDisciplina4, CodDisciplina5, "
		sql = sql & " CodDisciplina6, CodDisciplina7, CodDisciplina8, CodDisciplina9, CodDisciplina10, "
		sql = sql & " CodDisciplina11, CodDisciplina12, CodDisciplina13 )"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & intCodEscolaInep & "',"
		sql = sql & "'" & strIdentificacaoProssionalInep & "',"
		sql = sql & "'" & strCodProfissionalEscola & "',"
		
		sql = sql & "'" & strCodTurmaINEP & "',"
		sql = sql & "'" & strCodTurmaEntidadeEscola & "',"
		sql = sql & "'" & strFuncaoExerceEscolaTurma & "',"
		sql = sql & "'" & strSituacaoTipoVinculo & "',"
		
		sql = sql & "'" & strCodDisciplina1 & "',"
		sql = sql & "'" & strCodDisciplina2 & "',"
		sql = sql & "'" & strCodDisciplina3 & "',"
		sql = sql & "'" & strCodDisciplina4 & "',"
		sql = sql & "'" & strCodDisciplina5 & "',"
		sql = sql & "'" & strCodDisciplina6 & "',"
		sql = sql & "'" & strCodDisciplina7 & "',"
		sql = sql & "'" & strCodDisciplina8 & "',"
		sql = sql & "'" & strCodDisciplina9 & "',"
		sql = sql & "'" & strCodDisciplina10 & "',"
		sql = sql & "'" & strCodDisciplina11 & "',"
		sql = sql & "'" & strCodDisciplina12 & "',"
		sql = sql & "'" & strCodDisciplina13 & "')"
		cnn.execute sql
	
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From REGISTRO51 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro51_con.asp';
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