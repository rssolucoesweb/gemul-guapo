<!--
	::	Data de Criação...: 10/09/2014
	::	Desenvolvedores...: Roberto Barbosa Silva 
	::	Objetivo Pagina...: Cadastro de Profissional Escolar em Sala de Aula - Dados Variáveris - Registro 50
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
	
	strEscolaridade									= Trim(Request.Form("cmbEscolaridade"))
	strSituacaoCursoSuperior1						= Trim(Request.Form("cmbSituacaoCursoSuperior1"))
	strFormacaoComplentacaoPedagogica1				= Trim(Request.Form("cmbFormacaoComplentacaoPedagogica1"))
	strCodigoCursoSuperior1							= Trim(Request.Form("txtCodigoCursoSuperior1"))
	strAnoInicioCursoSuperior1						= Trim(Request.Form("txtAnoInicioCursoSuperior1"))
	strAnoConclusaoCursoSuperior1					= Trim(Request.Form("txtAnoConclusaoCursoSuperior1"))
	strTipoInstituicaoCursoSuperior1				= Trim(Request.Form("cmbTipoInstituicaoCursoSuperior1"))
	strInstituicaoCursoSuperior1					= Trim(Request.Form("txtInstituicaoCursoSuperior1"))
	strSituacaoCursoSuperior2						= Trim(Request.Form("cmbSituacaoCursoSuperior2"))
	strFormacaoComplementacaoPedagogica2			= Trim(Request.Form("cmbFormacaoComplementacaoPedagogica2"))
	strCodigoSuperior2								= Trim(Request.Form("txtCodigoSuperior2"))
	strAnoInicioCursoSuperior						= Trim(Request.Form("txtAnoInicioCursoSuperior"))
	strAnoConclusaoCursoSuperior2					= Trim(Request.Form("txtAnoConclusaoCursoSuperior2"))
	strTipoInstituicaoCursoSuperior2				= Trim(Request.Form("cmbTipoInstituicaoCursoSuperior2"))
	strInstituicaoCursoSuperior2					= Trim(Request.Form("txtInstituicaoCursoSuperior2"))
	strSituacaoCursoSuperior3						= Trim(Request.Form("cmbSituacaoCursoSuperior3"))
	strFormacaoComplentacaoPedagogica3				= Trim(Request.Form("cmbFormacaoComplentacaoPedagogica3"))
	strCodigoCursoSuperior3							= Trim(Request.Form("txtCodigoCursoSuperior3"))
	strAnoInicioCursoSuperior3						= Trim(Request.Form("txtAnoInicioCursoSuperior3"))
	strAnoConclusaoCursoSuperior3					= Trim(Request.Form("txtAnoConclusaoCursoSuperior3"))
	strTipoInstituicaoCursoSuperior3				= Trim(Request.Form("cmbTipoInstituicaoCursoSuperior3"))
	strInstituicaoCursoSuperior3					= Trim(Request.Form("txtInstituicaoCursoSuperior3"))
	strPosGraduacaoEspecializacao					= Trim(Request.Form("cmbPosGraduacaoEspecializacao"))
	strPosGraduacaoMestrado							= Trim(Request.Form("cmbPosGraduacaoMestrado"))
	strPosGraduacaoDoutorado						= Trim(Request.Form("cmbPosGraduacaoDoutorado"))
	strPosGraduacaoNenhum							= Trim(Request.Form("cmbPosGraduacaoNenhum"))
	strEspecializacaoCreche0a3anos					= Trim(Request.Form("cmbEspecializacaoCreche0a3anos"))
	strEspecializacaoPreEscola						= Trim(Request.Form("cmbEspecializacaoPreEscola"))
	strEspecificoParaAnoIniciaisEnsinoFundamental	= Trim(Request.Form("cmbEspecificoParaAnoIniciaisEnsinoFundamental"))
	strEspecificoFinaisEnsinoFundamental			= Trim(Request.Form("cmbEspecificoFinaisEnsinoFundamental"))
	strEspecificoEnsinoMedio						= Trim(Request.Form("cmbEspecificoEnsinoMedio"))
	strEspecificoEducacaoJovensAdultos				= Trim(Request.Form("cmbEspecificoEducacaoJovensAdultos"))
	strEspecificoEducacaoEspecial					= Trim(Request.Form("cmbEspecificoEducacaoEspecial"))
	strEspecificoEducacaoIndigena					= Trim(Request.Form("cmbEspecificoEducacaoIndigena"))
	strEspecificoEducacaoCampo						= Trim(Request.Form("cmbEspecificoEducacaoCampo"))
	strEspecificoEducacaoAmbiental					= Trim(Request.Form("cmbEspecificoEducacaoAmbiental"))
	strEspecificoEducacaoDireitosHumanos			= Trim(Request.Form("cmbEspecificoEducacaoDireitosHumanos"))
	strGeneroDiversidadeSexual						= Trim(Request.Form("cmbGeneroDiversidadeSexual"))
	strDireitosCriancasAdolescente					= Trim(Request.Form("cmbDireitosCriancasAdolescente"))
	strAfricana										= Trim(Request.Form("cmbAfricana"))
	strOutros										= Trim(Request.Form("cmbOutros"))
	strNenhum										= Trim(Request.Form("cmbNenhum"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	if acao="I" then
		
		strMensagem = "Cadastro de Profissional Escolar em Sala de Aula - Dados Variáveris - Registro 50, Salva com sucesso..."
		
		sql = "Delete From REGISTRO50 "
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO50( CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoProssionalInep, CodProfissionalEscola, "
		
		sql = sql & " Escolaridade, SituacaoCursoSuperior1, FormacaoComplentacaoPedagogica1, CodigoCursoSuperior1, "
		sql = sql & " AnoInicioCursoSuperior1, AnoConclusaoCursoSuperior1, TipoInstituicaoCursoSuperior1, InstituicaoCursoSuperior1, "
		sql = sql & " SituacaoCursoSuperior2, FormacaoComplementacaoPedagogica2, CodigoSuperior2, AnoInicioCursoSuperior, "
		sql = sql & " AnoConclusaoCursoSuperior2, TipoInstituicaoCursoSuperior2, InstituicaoCursoSuperior2, SituacaoCursoSuperior3, "
		sql = sql & " FormacaoComplentacaoPedagogica3, CodigoCursoSuperior3, AnoInicioCursoSuperior3, AnoConclusaoCursoSuperior3, "
		sql = sql & " TipoInstituicaoCursoSuperior3, InstituicaoCursoSuperior3, PosGraduacaoEspecializacao, PosGraduacaoMestrado, "
		sql = sql & " PosGraduacaoDoutorado, PosGraduacaoNenhum, EspecializacaoCreche0a3anos, EspecializacaoPreEscola, "
		sql = sql & " EspecificoParaAnoIniciaisEnsinoFundamental, EspecificoFinaisEnsinoFundamental, EspecificoEnsinoMedio, EspecificoEducacaoJovensAdultos, "
		sql = sql & " EspecificoEducacaoEspecial, EspecificoEducacaoIndigena, EspecificoEducacaoCampo, EspecificoEducacaoAmbiental, "
		sql = sql & " EspecificoEducacaoDireitosHumanos, GeneroDiversidadeSexual, DireitosCriancasAdolescente, Africana, "
		sql = sql & " Outros, Nenhum )"
		
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & intCodEscolaInep & "',"
		sql = sql & "'" & strIdentificacaoProssionalInep & "',"
		sql = sql & "'" & strCodProfissionalEscola & "',"

		sql = sql & "'" & strEscolaridade & "',"
		sql = sql & "'" & strSituacaoCursoSuperior1 & "',"
		sql = sql & "'" & strFormacaoComplentacaoPedagogica1 & "',"
		sql = sql & "'" & strCodigoCursoSuperior1 & "',"
		sql = sql & "'" & strAnoInicioCursoSuperior1 & "',"
		sql = sql & "'" & strAnoConclusaoCursoSuperior1 & "',"
		sql = sql & "'" & strTipoInstituicaoCursoSuperior1 & "',"
		sql = sql & "'" & strInstituicaoCursoSuperior1 & "',"
		sql = sql & "'" & strSituacaoCursoSuperior2 & "',"
		sql = sql & "'" & strFormacaoComplementacaoPedagogica2 & "',"
		sql = sql & "'" & strCodigoSuperior2 & "',"
		sql = sql & "'" & strAnoInicioCursoSuperior & "',"
		sql = sql & "'" & strAnoConclusaoCursoSuperior2 & "',"
		sql = sql & "'" & strTipoInstituicaoCursoSuperior2 & "',"
		sql = sql & "'" & strInstituicaoCursoSuperior2 & "',"
		sql = sql & "'" & strSituacaoCursoSuperior3 & "',"
		sql = sql & "'" & strFormacaoComplentacaoPedagogica3 & "',"
		sql = sql & "'" & strCodigoCursoSuperior3 & "',"
		sql = sql & "'" & strAnoInicioCursoSuperior3 & "',"
		sql = sql & "'" & strAnoConclusaoCursoSuperior3 & "',"
		sql = sql & "'" & strTipoInstituicaoCursoSuperior3 & "',"
		sql = sql & "'" & strInstituicaoCursoSuperior3 & "',"
		sql = sql & "'" & strPosGraduacaoEspecializacao & "',"
		sql = sql & "'" & strPosGraduacaoMestrado & "',"
		sql = sql & "'" & strPosGraduacaoDoutorado & "',"
		sql = sql & "'" & strPosGraduacaoNenhum & "',"
		sql = sql & "'" & strEspecializacaoCreche0a3anos & "',"
		sql = sql & "'" & strEspecializacaoPreEscola & "',"
		sql = sql & "'" & strEspecificoParaAnoIniciaisEnsinoFundamental & "',"
		sql = sql & "'" & strEspecificoFinaisEnsinoFundamental & "',"
		sql = sql & "'" & strEspecificoEnsinoMedio & "',"
		sql = sql & "'" & strEspecificoEducacaoJovensAdultos & "',"
		sql = sql & "'" & strEspecificoEducacaoEspecial & "',"
		sql = sql & "'" & strEspecificoEducacaoIndigena & "',"
		sql = sql & "'" & strEspecificoEducacaoCampo & "',"
		sql = sql & "'" & strEspecificoEducacaoAmbiental & "',"
		sql = sql & "'" & strEspecificoEducacaoDireitosHumanos & "',"
		sql = sql & "'" & strGeneroDiversidadeSexual & "',"
		sql = sql & "'" & strDireitosCriancasAdolescente & "',"
		sql = sql & "'" & strAfricana & "',"
		sql = sql & "'" & strOutros & "',"
		sql = sql & "'" & strNenhum & "')"
		cnn.execute sql
	
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From REGISTRO50 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro50_con.asp';
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