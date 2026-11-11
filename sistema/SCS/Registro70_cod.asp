<!--
	::	Data de Criação...: 01/07/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Cadastro de Aluno - Documentos e Endereço - Registro 70
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 									= Trim(Request.QueryString("acao"))
	
	intCodEmpresa							= Trim(Request.Form("txtCodEmpresa"))
	strTipoRegistro							= Trim(Request.Form("txtTipoRegistro"))
	intCodEscolaInep	 					= Trim(Request.Form("txtCodEscolaInep"))
	strIdentificacaoUnicaAlunoInep			= Trim(Request.Form("txtIdentificacaoUnicaAlunoInep"))
	strCodAlunoEntidadeEscola				= Trim(Request.Form("txtCodAlunoEntidadeEscola"))

	strNumIdentidade						= Trim(Request.Form("txtNumIdentidade"))
	strComplementoIdentidade				= Trim(Request.Form("txtComplementoIdentidade"))
	strOrgaoEmissorIdentidade				= Trim(Request.Form("txtOrgaoEmissorIdentidade"))
	strUFIdentidade							= Trim(Request.Form("cmbUFIdentidade"))
	strTipoCertidaoCivil					= Trim(Request.Form("cmbTipoCertidaoCivil"))
	strNumeroTermo							= Trim(Request.Form("txtNumeroTermo"))
	strFolha								= Trim(Request.Form("txtFolha"))
	strLivro								= Trim(Request.Form("txtLivro"))
	strDataEmissaoCertidao					= Trim(Request.Form("txtDataEmissaoCertidao"))
	strUFCartorio							= Trim(Request.Form("txtUFCartorio"))
	strMunicipioCartorio					= Trim(Request.Form("txtMunicipioCartorio"))
	strCodigoCartorio						= Trim(Request.Form("txtCodigoCartorio"))
	strNumeroMatricula						= Trim(Request.Form("txtNumeroMatricula"))
	strNumeroCPF							= Trim(Request.Form("txtNumeroCPF"))
	strDocumentoEstrangeiro					= Trim(Request.Form("txtDocumentoEstrangeiro"))
	strNumeroIdentificacaoSocial			= Trim(Request.Form("txtNumeroIdentificacaoSocial"))
	strJustificativaFaltaDocumentoAluno		= Trim(Request.Form("txtJustificativaFaltaDocumentoAluno"))
	strLocalizacaoZonaResidencia			= Trim(Request.Form("txtLocalizacaoZonaResidencia"))
	strCEP									= Trim(Request.Form("txtCEP"))
	strEndereco								= Trim(Request.Form("txtEndereco"))
	strNumero								= Trim(Request.Form("txtNumero"))
	strUF									= Trim(Request.Form("txtUF"))
	strMunicipio							= Trim(Request.Form("txtMunicipio"))
	strComplemento							= Trim(Request.Form("txtComplemento"))
	strBairro								= Trim(Request.Form("txtBairro"))
	
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	if acao="I" then
		
		strMensagem = "Cadastro de Aluno - Documentos e Endereço - Registro 70, Salva com sucesso..."
		
		sql = "Delete From REGISTRO70 "
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO70( CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoUnicaAlunoInep, CodAlunoEntidadeEscola, "
		sql = sql & " NumIdentidade, ComplementoIdentidade, OrgaoEmissorIdentidade, UFIdentidade, TipoCertidaoCivil, NumeroTermo, "
		sql = sql & " Folha, Livro, DataEmissaoCertidao, UFCartorio, MunicipioCartorio, CodigoCartorio, "
		sql = sql & " NumeroMatricula, NumeroCPF, DocumentoEstrangeiro, NumeroIdentificacaoSocial, JustificativaFaltaDocumentoAluno, "
		sql = sql & " LocalizacaoZonaResidencia, CEP, Endereco, "
		sql = sql & " Numero, UF, Municipio, Complemento, Bairro ) "
		
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & intCodEscolaInep & "',"
		sql = sql & "'" & strIdentificacaoUnicaAlunoInep & "',"
		sql = sql & "'" & strCodAlunoEntidadeEscola & "',"
		
		sql = sql & "'" & strNumIdentidade & "',"
		sql = sql & "'" & strComplementoIdentidade & "',"
		sql = sql & "'" & strOrgaoEmissorIdentidade & "',"
		sql = sql & "'" & strUFIdentidade & "',"
		sql = sql & "'" & strTipoCertidaoCivil & "',"
		sql = sql & "'" & strNumeroTermo & "',"
		sql = sql & "'" & strFolha & "',"
		sql = sql & "'" & strLivro & "',"
		sql = sql & "'" & strDataEmissaoCertidao & "',"
		sql = sql & "'" & strUFCartorio & "',"
		sql = sql & "'" & strMunicipioCartorio & "',"
		sql = sql & "'" & strCodigoCartorio & "',"
		sql = sql & "'" & strNumeroMatricula & "',"
		sql = sql & "'" & strNumeroCPF & "',"
		sql = sql & "'" & strDocumentoEstrangeiro & "',"
		sql = sql & "'" & strNumeroIdentificacaoSocial & "',"
		sql = sql & "'" & strJustificativaFaltaDocumentoAluno & "',"
		sql = sql & "'" & strLocalizacaoZonaResidencia & "',"
		sql = sql & "'" & strCEP & "',"
		sql = sql & "'" & strEndereco & "',"
		sql = sql & "'" & strNumero & "',"
		sql = sql & "'" & strUF & "',"
		sql = sql & "'" & strMunicipio & "',"
		sql = sql & "'" & strComplemento & "',"
		sql = sql & "'" & strBairro & "')"
		cnn.execute sql
	
	else
	
		strMensagem = "Cadastro de Aluno - Documentos e Endereço - Registro 70, Registro Excluido com sucesso..."
		
		sql = "Delete From REGISTRO70 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro70_con.asp';
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