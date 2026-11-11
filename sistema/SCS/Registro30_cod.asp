<!--
	::	Data de Criação...: 01/07/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Cadastro de Escola Sendo 
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
	strTipoRegistro									= Trim(Request.Form("txtTipoRegistro"))
	strCodEscolaInep	 							= Trim(Request.Form("txtCodEscolaInep"))
	strCodINEP										= Trim(Request.Form("txtCodINEP"))
	strCodProfissionalEscola						= Trim(Request.Form("txtCodProfissionalEscola"))
	strNomeCompleto									= Trim(Request.Form("txtNomeCompleto"))
	strEmail										= Trim(Request.Form("txtEmail"))
	strNumeroIndentificacaoSocialNIS				= Trim(Request.Form("txtNumeroIndentificacaoSocialNIS"))
	strDataNascimento								= Trim(Request.Form("txtDataNascimento"))
	strSexo											= Trim(Request.Form("cmbSexo"))
	strCorRoca										= Trim(Request.Form("cmbCorRoca"))
	strNomeCompletoMae								= Trim(Request.Form("txtNomeCompletoMae"))
	strNacionalidadeProfissionalSalaAula			= Trim(Request.Form("cmbNacionalidadeProfissionalSalaAula"))
	strPaisOrigem									= Trim(Request.Form("txtPaisOrigem"))
	strUFNascimento									= Trim(Request.Form("txtUFNascimento"))
	strMunicipioNascimento							= Trim(Request.Form("txtMunicipioNascimento"))
	strProfissionalDeficiencia						= Trim(Request.Form("cmbProfissionalDeficiencia"))
	strCegueira										= Trim(Request.Form("cmbCegueira"))
	strBaixaVisao									= Trim(Request.Form("cmbBaixaVisao"))
	strSurdez										= Trim(Request.Form("cmbSurdez"))
	strAuditiva										= Trim(Request.Form("cmbAuditiva"))
	strSurdocegueira								= Trim(Request.Form("cmbSurdocegueira"))
	strDeficienciaFisica							= Trim(Request.Form("cmbDeficienciaFisica"))
	strDeficienciaIntelectual						= Trim(Request.Form("cmbDeficienciaIntelectual"))
	strDeficienciaMultipla							= Trim(Request.Form("cmbDeficienciaMultipla"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	if acao="I" then
		
		strMensagem = "Cadatro de Profissional Escola em Sala de Aula - Registro 30, Salva com sucesso..."
		
		sql = "Delete From REGISTRO30 "
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO30( CodEmpresa, TipoRegistro, CodEscolaInep, CodINEP, CodProfissionalEscola, NomeCompleto, Email, "
		sql = sql & " NumeroIndentificacaoSocialNIS, DataNascimento, Sexo, CorRoca, NomeCompletoMae, NacionalidadeProfissionalSalaAula," 
		sql = sql & " PaisOrigem, UFNascimento, MunicipioNascimento, ProfissionalDeficiencia, Cegueira, BaixaVisao, "
		sql = sql & " Surdez, Auditiva, Surdocegueira, DeficienciaFisica, DeficienciaIntelectual, DeficienciaMultipla) "
		
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & strCodEscolaInep & "',"
		sql = sql & "'" & strCodINEP & "',"
		sql = sql & "'" & strCodProfissionalEscola & "',"
		sql = sql & "'" & strNomeCompleto & "',"
		sql = sql & "'" & strEmail & "',"
		sql = sql & "'" & strNumeroIndentificacaoSocialNIS & "',"
		sql = sql & "'" & strDataNascimento & "',"
		sql = sql & "'" & strSexo & "',"
		sql = sql & "'" & strCorRoca & "',"
		sql = sql & "'" & strNomeCompletoMae & "',"
		sql = sql & "'" & strNacionalidadeProfissionalSalaAula & "',"
		sql = sql & "'" & strPaisOrigem & "',"
		sql = sql & "'" & strUFNascimento & "',"
		sql = sql & "'" & strMunicipioNascimento & "',"
		sql = sql & "'" & strProfissionalDeficiencia & "',"
		sql = sql & "'" & strCegueira & "',"
		sql = sql & "'" & strBaixaVisao & "',"
		sql = sql & "'" & strSurdez & "',"
		sql = sql & "'" & strAuditiva & "',"
		sql = sql & "'" & strSurdocegueira & "',"
		sql = sql & "'" & strDeficienciaFisica & "',"
		sql = sql & "'" & strDeficienciaIntelectual & "',"
		sql = sql & "'" & strDeficienciaMultipla & "')"
		cnn.execute sql
	
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From REGISTRO20 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro30_con.asp';
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