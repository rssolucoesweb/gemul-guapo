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
	acao 							= Trim(Request.QueryString("acao"))
	intCodEmpresa					= Trim(Request.Form("txtCodEmpresa"))
	strTipoRegistro					= Trim(Request.Form("txtTipoRegistro"))
	intCodInep	 					= Trim(Request.Form("txtCodInep"))
	strSituacaoFuncional			= Trim(Request.Form("cmbSituacaoFuncional"))
	strDataInicioAnoLetivo 			= formataDataBD(Trim(Request.Form("txtDataInicioAnoLetivo")))
	strDataTerminoAnoLetivo			= formataDataBD(Trim(Request.Form("txtDataTerminoAnoLetivo")))
	strEscola 						= Trim(Request.Form("txtEscola"))
	strLatitude 					= Trim(Request.Form("txtLatitude"))
	strLogitude						= Trim(Request.Form("txtLogitude"))
	strCep							= Trim(Request.Form("txtCep"))
	strEndereco						= Trim(Request.Form("txtEndereco"))
	strNumero         				= Trim(Request.Form("txtNumero"))
	strComplemento         			= Trim(Request.Form("txtComplemento"))
	strBairro         				= Trim(Request.Form("txtBairro"))
	strUF         					= Trim(Request.Form("txtUF"))
	strMunicipio         			= Trim(Request.Form("txtMunicipio"))
	strDistrito         			= Trim(Request.Form("txtDistrito"))
	strDDD         					= Trim(Request.Form("txtDDD"))
	strTelefone         			= Trim(Request.Form("txtTelefone"))
	strTelefone1         			= Trim(Request.Form("txtTelefone1"))
	strOutroTelefone         		= Trim(Request.Form("txtOutroTelefone"))
	strFax         					= Trim(Request.Form("txtFax"))
	strEmail         				= Trim(Request.Form("txtEmail"))
	strCodRegional         			= Trim(Request.Form("txtCodRegional"))
	strDependenciaAdminstrativa 	= Trim(Request.Form("cmbDependenciaAdminstrativa"))
	strLocalizacaoZona         		= Trim(Request.Form("cmbLocalizacaoZona"))
	strCategoriaEscola     			= Trim(Request.Form("cmbCategoriaEscola"))
	strConveniadaComPoderPublico    = Trim(Request.Form("cmbConveniadaComPoderPublico"))
	strConveniadaComPoderPublico2   = Trim(Request.Form("cmbConveniadaComPoderPublico2"))
	strMantenedora1         		= Trim(Request.Form("txtMantenedora1"))
	strMantenedora2         		= Trim(Request.Form("txtMantenedora2"))
	strMantenedora3         		= Trim(Request.Form("txtMantenedora3"))
	strMantenedora4	        		= Trim(Request.Form("txtMantenedora4"))
	strSistemaS         			= Trim(Request.Form("cmbSistemaS"))
	strCNPJ1         				= Trim(Request.Form("txtCNPJ1"))
	strCNPJ2         				= Trim(Request.Form("txtCNPJ2"))
	strRegulamentacao         		= Trim(Request.Form("cmbRegulamentacao"))
			
	if acao="I" then
		
		strMensagem = "Escola Salva com sucesso..."
		
		sql = "Delete From REGISTRO00 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO00( Cod_empresa, TipoRegistro, CodInep, SituacaoFuncional, DataInicioAnoLetivo, DataTerminoAnoLetivo, Escola, Latitude, Logitude, "
		sql = sql & " Cep, Endereco, Numero, Complemento, Bairro, UF, Municipio, Distrito, DDD, "
		sql = sql & " Telefone, Telefone1, OutroTelefone,Fax,  Email, CodRegional,  "
		sql = sql & " DependenciaAdminstrativa, LocalizacaoZona, CategoriaEscola  , ConveniadaComPoderPublico ,  ConveniadaComPoderPublico2,"
		sql = sql & " Mantenedora1  , Mantenedora2, Mantenedora3, Mantenedora4, SistemaS, CNPJ1, CNPJ2,  Regulamentacao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & intCodInep & "',"
		sql = sql & "'" & strSituacaoFuncional & "',"
		sql = sql & "'" & strDataInicioAnoLetivo & "',"
		sql = sql & "'" & strDataTerminoAnoLetivo & "',"
		sql = sql & "'" & strEscola & "',"
		sql = sql & "'" & strLatitude & "',"
		sql = sql & "'" & strLogitude & "',"
		sql = sql & "'" & strCep & "',"
		sql = sql & "'" & strEndereco & "',"
		sql = sql & "'" & strNumero & "',"
		sql = sql & "'" & strComplemento & "',"
		sql = sql & "'" & strBairro & "',"
		sql = sql & "'" & strUF & "',"
		sql = sql & "'" & strMunicipio & "',"
		sql = sql & "'" & strDistrito & "',"
		sql = sql & "'" & strDDD & "',"
		sql = sql & "'" & strTelefone & "',"
		sql = sql & "'" & strTelefone1 & "',"
		sql = sql & "'" & strOutroTelefone & "',"
		sql = sql & "'" & strFax & "',"
		sql = sql & "'" & strEmail & "',"
		sql = sql & "'" & strCodRegional & "',"
		sql = sql & "'" & strDependenciaAdminstrativa & "',"
		sql = sql & "'" & strLocalizacaoZona & "',"
		sql = sql & "'" & strCategoriaEscola & "',"
		sql = sql & "'" & strConveniadaComPoderPublico & "',"
		sql = sql & "'" & strConveniadaComPoderPublico2 & "',"
		sql = sql & "'" & strMantenedora1 & "',"
		sql = sql & "'" & strMantenedora2 & "',"
		sql = sql & "'" & strMantenedora3 & "',"
		sql = sql & "'" & strMantenedora4 & "',"
		sql = sql & "'" & strSistemaS & "',"
		sql = sql & "'" & strCNPJ1 & "',"
		sql = sql & "'" & strCNPJ2 & "',"
		sql = sql & "" & strRegulamentacao & ")"
		cnn.execute sql
	
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete From REGISTRO00 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro00_con.asp';
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