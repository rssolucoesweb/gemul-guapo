<!--
	::	Data de Criação...: 01/07/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Cadastro de Aluno - Indentificação - Regsitro 60
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
	strNomeCompleto							= Trim(Request.Form("txtNomeCompleto"))
	strNumeroIndenticacaoSocialNIS			= Trim(Request.Form("txtNumeroIndenticacaoSocialNIS"))
	strDataNascimento						= Trim(Request.Form("txtDataNascimento"))
	strSexo									= Trim(Request.Form("cmbSexo"))
	strCorRoca								= Trim(Request.Form("cmbCorRoca"))
	strFiliacao								= Trim(Request.Form("txtFiliacao"))
	strNomeMae								= Trim(Request.Form("txtNomeMae"))
	strNomePai								= Trim(Request.Form("txtNomePai"))
	strNacionalidadeAluno					= Trim(Request.Form("txtNacionalidadeAluno"))
	strPaisOrigem							= Trim(Request.Form("txtPaisOrigem"))
	strUFNascimento							= Trim(Request.Form("txtUFNascimento"))
	strMunicipioNascimento					= Trim(Request.Form("txtMunicipioNascimento"))
	
	strSuperdotacao							= Trim(Request.Form("cmbSuperdotacao"))
	strCegueira								= Trim(Request.Form("cmbCegueira"))
	strBaixaVisao							= Trim(Request.Form("cmbBaixaVisao"))
	strSupedotacaoSurdez					= Trim(Request.Form("cmbSupedotacaoSurdez"))
	strDeficienciaAuditiva					= Trim(Request.Form("cmbDeficienciaAuditiva"))
	strSurdocegueira						= Trim(Request.Form("cmbSurdocegueira"))
	strDeficienciaFisica					= Trim(Request.Form("cmbDeficienciaFisica"))
	strDeficienciaIntelectual				= Trim(Request.Form("cmbDeficienciaIntelectual"))
	strDeficienciaMultipla					= Trim(Request.Form("cmbDeficienciaMultipla"))
	strAutismoInfantil						= Trim(Request.Form("cmbAutismoInfantil"))
	strSindromeAsperger						= Trim(Request.Form("cmbSindromeAsperger"))
	strSindromeRett							= Trim(Request.Form("cmbSindromeRett"))
	strTranstornoInfacia					= Trim(Request.Form("cmbTranstornoInfacia"))
	strAltashabilidadesSuperdotacao			= Trim(Request.Form("cmbAltashabilidadesSuperdotacao"))
	
	strAuxilioLedor							= Trim(Request.Form("cmbAuxilioLedor"))
	strAuxilioTranscricao					= Trim(Request.Form("cmbAuxilioTranscricao"))
	strGuiaInterprete						= Trim(Request.Form("cmbGuiaInterprete"))
	strInterpreteLibras						= Trim(Request.Form("cmbInterpreteLibras"))
	strLeituraLabial						= Trim(Request.Form("cmbLeituraLabial"))
	strProvaAmpliadaTamanho16				= Trim(Request.Form("cmbProvaAmpliadaTamanho16"))
	strProvaAmpliadaTamanho20				= Trim(Request.Form("cmbProvaAmpliadaTamanho20"))
	strProvaAmpliadaTamanho24				= Trim(Request.Form("cmbProvaAmpliadaTamanho24"))
	strProvaBraille							= Trim(Request.Form("cmbProvaBraille"))
	strNenhum								= Trim(Request.Form("cmbNenhum"))

	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	if acao="I" then
		
		strMensagem = "Cadastro de Aluno - Indentificação - Regsitro 60, Salva com sucesso..."
		
		sql = "Delete From REGISTRO60 "
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO60( CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoUnicaAlunoInep, CodAlunoEntidadeEscola, "
		sql = sql & " NomeCompleto, NumeroIndenticacaoSocialNIS, DataNascimento, Sexo, CorRoca, Filiacao,    "
		sql = sql & " NomeMae, NomePai, NacionalidadeAluno, PaisOrigem, UFNascimento, MunicipioNascimento, "
		sql = sql & " Superdotacao, Cegueira, BaixaVisao, SupedotacaoSurdez, DeficienciaAuditiva, "
		sql = sql & " Surdocegueira, DeficienciaFisica, DeficienciaIntelectual, DeficienciaMultipla, "
		sql = sql & " AutismoInfantil, SindromeAsperger, SindromeRett, TranstornoInfacia, AltashabilidadesSuperdotacao, "
		sql = sql & " AuxilioLedor, AuxilioTranscricao, GuiaInterprete,  "
		sql = sql & " InterpreteLibras, LeituraLabial, ProvaAmpliadaTamanho16,  "
		sql = sql & " ProvaAmpliadaTamanho20, ProvaAmpliadaTamanho24, ProvaBraille,  Nenhum )"

		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & intCodEscolaInep & "',"
		sql = sql & "'" & strIdentificacaoUnicaAlunoInep & "',"
		sql = sql & "'" & strCodAlunoEntidadeEscola & "',"
		
		sql = sql & "'" & strNomeCompleto & "',"
		sql = sql & "'" & strNumeroIndenticacaoSocialNIS & "',"
		sql = sql & "'" & strDataNascimento & "',"
		sql = sql & "'" & strSexo & "',"
		sql = sql & "'" & strCorRoca & "',"
		sql = sql & "'" & strFiliacao & "',"
		
		sql = sql & "'" & strNomeMae & "',"
		sql = sql & "'" & strNomePai & "',"
		sql = sql & "'" & strNacionalidadeAluno & "',"
		sql = sql & "'" & strPaisOrigem & "',"
		sql = sql & "'" & strUFNascimento & "',"
		sql = sql & "'" & strMunicipioNascimento & "',"
		sql = sql & "'" & strSuperdotacao & "',"
		sql = sql & "'" & strCegueira & "',"
		sql = sql & "'" & strBaixaVisao & "',"
		sql = sql & "'" & strSupedotacaoSurdez & "',"
		sql = sql & "'" & strDeficienciaAuditiva & "',"

		sql = sql & "'" & strSurdocegueira & "',"
		sql = sql & "'" & strDeficienciaFisica & "',"
		sql = sql & "'" & strDeficienciaIntelectual & "',"
		sql = sql & "'" & strDeficienciaMultipla & "',"
		sql = sql & "'" & strAutismoInfantil & "',"
		sql = sql & "'" & strSindromeAsperger & "',"
		sql = sql & "'" & strSindromeRett & "',"
		sql = sql & "'" & strTranstornoInfacia & "',"
		sql = sql & "'" & strAltashabilidadesSuperdotacao & "',"

		sql = sql & "'" & strAuxilioLedor & "',"
		sql = sql & "'" & strAuxilioTranscricao & "',"
		sql = sql & "'" & strGuiaInterprete & "',"
		sql = sql & "'" & strInterpreteLibras & "',"
		sql = sql & "'" & strLeituraLabial & "',"
		sql = sql & "'" & strProvaAmpliadaTamanho16 & "',"
		sql = sql & "'" & strProvaAmpliadaTamanho20 & "',"
		sql = sql & "'" & strProvaAmpliadaTamanho24 & "',"
		sql = sql & "'" & strProvaBraille & "',"
		sql = sql & "'" & strNenhum & "')"
		cnn.execute sql
	
	else
	
		strMensagem = "Cadastro de Aluno - Indentificação - Regsitro 60, Registro Excluido com sucesso..."
		sql = "Delete From REGISTRO60 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro60_con.asp';
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