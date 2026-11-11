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
	intCodEscolaInep	 							= Trim(Request.Form("txtCodEscolaInep"))
	strIdentificacaoProssionalInep					= Trim(Request.Form("txtIdentificacaoProssionalInep"))
	strCodProfissionalEscola						= Trim(Request.Form("txtCodProfissionalEscola"))
	strCPF									= Trim(Request.Form("txtCPF"))
	strResidencia							= Trim(Request.Form("txtResidencia"))
	strCEP									= Trim(Request.Form("txtCEP"))
	strEndereco								= Trim(Request.Form("txtEndereco"))
	strNumEndereco							= Trim(Request.Form("txtNumEndereco"))
	strComplemento							= Trim(Request.Form("txtComplemento"))
	strBairro								= Trim(Request.Form("txtBairro"))
	strUF									= Trim(Request.Form("txtUF"))
	strMunicipio							= Trim(Request.Form("txtMunicipio"))

	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	if acao="I" then
		
		strMensagem = "Turma Salva com sucesso..."
		
		sql = "Delete From REGISTRO40 "
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO40( CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoProssionalInep, CodProfissionalEscola, "
		sql = sql & " CPF, Residencia, CEP, Endereco, NumEndereco, Complemento, Bairro, UF, Municipio )"
		
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & intCodEscolaInep & "',"
		sql = sql & "'" & strIdentificacaoProssionalInep & "',"
		sql = sql & "'" & strCodProfissionalEscola & "',"
		sql = sql & "'" & strCPF & "',"
		sql = sql & "'" & strResidencia & "',"
		sql = sql & "'" & strCEP & "',"
		sql = sql & "'" & strEndereco & "',"
		sql = sql & "'" & strNumEndereco & "',"
		sql = sql & "'" & strComplemento & "',"
		sql = sql & "'" & strBairro & "',"
		sql = sql & "'" & strUF & "',"
		sql = sql & "'" & strMunicipio & "')"

		cnn.execute sql
	
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From REGISTRO40 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro40_con.asp';
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