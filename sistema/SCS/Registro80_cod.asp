<!--
	::	Data de Criação...: 01/07/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Cadastro de Aluno - Vínculo (Matrícula) - Registro 80
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

	strCodigoTurma							= Trim(Request.Form("txtCodigoTurma"))
	strCodigoTurmaEntidadeEscola			= Trim(Request.Form("txtCodigoTurmaEntidadeEscola"))
	strCodigoMatriculaAluno					= Trim(Request.Form("txtCodigoMatriculaAluno"))
	strTurmaUnificada						= Trim(Request.Form("cmbTurmaUnificada"))
	strEtapa								= Trim(Request.Form("cmbEtapa"))
	strRecebeEscolarizacaoOutroEspacao		= Trim(Request.Form("cmbRecebeEscolarizacaoOutroEspacao"))
	strTransposteEscolarPublico				= Trim(Request.Form("cmbTransposteEscolarPublico"))
	strPoderPublicoResponsavel				= Trim(Request.Form("cmbPoderPublicoResponsavel"))
	strVansKombis							= Trim(Request.Form("cmbVansKombis"))
	strMicroOnibus							= Trim(Request.Form("cmbMicroOnibus"))
	strOnibus								= Trim(Request.Form("cmbOnibus"))
	strBicicleta							= Trim(Request.Form("cmbBicicleta"))
	strTransporteAnimal						= Trim(Request.Form("cmbTransporteAnimal"))
	strRodoviarioOutro						= Trim(Request.Form("cmbRodoviarioOutro"))
	strCapacidade5Alunos					= Trim(Request.Form("cmbCapacidade5Alunos"))
	strCapacidade5e15Alunos					= Trim(Request.Form("cmbCapacidade5e15Alunos"))
	strCapacidadeAcima35Alunos				= Trim(Request.Form("cmbCapacidadeAcima35Alunos"))
	strTremMetro							= Trim(Request.Form("cmbTremMetro"))
	strFormaIngressoAluno					= Trim(Request.Form("cmbFormaIngressoAluno"))
	
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	if acao="I" then
		
		strMensagem = "Cadastro de Aluno - Vínculo (Matrícula) - Registro 80, Salva com sucesso..."
		
		sql = "Delete From REGISTRO80 "
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO80( CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoUnicaAlunoInep, CodAlunoEntidadeEscola, "
		sql = sql & " CodigoTurma, CodigoTurmaEntidadeEscola, CodigoMatriculaAluno, TurmaUnificada, Etapa, RecebeEscolarizacaoOutroEspacao, "
		sql = sql & " TransposteEscolarPublico, PoderPublicoResponsavel, VansKombis, MicroOnibus, Onibus, Bicicleta, "
		sql = sql & " TransporteAnimal, RodoviarioOutro, Capacidade5Alunos, Capacidade5e15Alunos, CapacidadeAcima35Alunos, "
		sql = sql & " TremMetro, FormaIngressoAluno )"
		
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & intCodEscolaInep & "',"
		sql = sql & "'" & strIdentificacaoUnicaAlunoInep & "',"
		sql = sql & "'" & strCodAlunoEntidadeEscola & "',"
	
		sql = sql & "'" & strCodigoTurma & "',"
		sql = sql & "'" & strCodigoTurmaEntidadeEscola & "',"
		sql = sql & "'" & strCodigoMatriculaAluno & "',"
		sql = sql & "'" & strTurmaUnificada & "',"
		sql = sql & "'" & strEtapa & "',"
		sql = sql & "'" & strRecebeEscolarizacaoOutroEspacao & "',"
		sql = sql & "'" & strTransposteEscolarPublico & "',"
		sql = sql & "'" & strPoderPublicoResponsavel & "',"
		sql = sql & "'" & strVansKombis & "',"
		sql = sql & "'" & strMicroOnibus & "',"
		sql = sql & "'" & strOnibus & "',"
		sql = sql & "'" & strBicicleta & "',"
		sql = sql & "'" & strTransporteAnimal & "',"
		sql = sql & "'" & strRodoviarioOutro & "',"
		sql = sql & "'" & strCapacidade5Alunos & "',"
		sql = sql & "'" & strCapacidade5e15Alunos & "',"
		sql = sql & "'" & strCapacidadeAcima35Alunos & "',"
		sql = sql & "'" & strTremMetro & "',"
		sql = sql & "'" & strFormaIngressoAluno & "')"
		cnn.execute sql
	
	else
	
		strMensagem = "Cadastro de Aluno - Vínculo (Matrícula) - Registro 80, Registro Excluido com sucesso..."
		
		sql = "Delete From REGISTRO80 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro80_con.asp';
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