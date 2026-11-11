<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/09/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Diretrizes
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))	
	intCodEmpresa				= session("codEmpresa")

	strAnoLetivo 			= request("txtAnoLetivo")
	intSemestre  			= Trim(Request.Form("cmbSemestre"))
	intCodTipoEmpresa		= Trim(Request.Form("cmbTipoEmpresa"))

	if acao="I" then
	
		strMensagem = "Registro Incluido com sucesso..."
		
	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = " DELETE FROM SRH_TURMA_MODULACAO_FUNCAO WHERE CODIGO IN "
		sql = sql & " (SELECT * FROM SCA_TURMA T "
		sql = sql & " INNER JOIN SRH_TURMA_MODULACAO_FUNCAO TMF ON TMF.Cod_Turma = T.Cod_Turma "
		sql = sql & " where Cod_Empresa in (select codigo from SEG_EMPRESA where CodTipoEmpresa = " & intCodTipoEmpresa & ")"
		sql = sql & " AND AnoLetivo = " & strAnoLetivo
		sql = sql & " AND Cod_Semestre = " & intSemestre & ")"
		cnn.execute sql
		GravarLog sql

		sql = " UPDATE SCA_GRADECURRICULARDISCIPLINA SET Cod_Funcao = NULL, Total_Vaga_Funcao = NULL WHERE Cod_GradeCurricularDisciplina IN "
		sql = sql & " (select Distinct Cod_GradeCurricularDisciplina from SCA_GRADECURRICULAR GC "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular "
		sql = sql & " where GC.Cod_Empresa in (select codigo from SEG_EMPRESA where CodTipoEmpres = " & intCodTipoEmpresa & ")"
		sql = sql & " AND t.AnoLetivo = " & strAnoLetivo
		sql = sql & " AND t.Cod_Semestre = " & intSemestre & ")"
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			<% if acao <> "EF" then %>
				window.navigate('ModulacaoTurmas_cad.asp');
			<% else %>
				window.close();
			<% end if %> 
			window.opener.frm.submit();
		</script>
		<%
		response.end
	else
		'cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.navigate('ModulacaoTurmas_cad.asp');
		</script>
		<%
	end if
%>