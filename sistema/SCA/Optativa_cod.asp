<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Perido
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
	intCodEmp						= Session("CodEmpresa")
	intCodOptativa					= Trim(Request.Form("txtCodigo"))
    intAnoLetivo		 			=  Trim(Request("txtAnoLetivo"))
    intSemestre 					= Trim(Request("cmbSemestre"))
	intCodCurso						= Trim(Request("cmbCurso"))
	intCodPeriodo					= Trim(Request.Form("cmbPeriodo"))
	intCodDisciplinaCurso			= Trim(Request.Form("cmbDisciplinaCurso"))
	
	strTemMesmoRegistro = false
	sql = "SELECT Ano_Letivo, Semestre_Letivo, Cod_Curso, Cod_Periodo, Cod_Disciplina"
	sql = sql & " FROM SCA_OPTATIVAS"
	sql = sql & " where Cod_Empresa = " & intCodEmp	
	sql = sql & " and 	Ano_Letivo = " & intAnoLetivo
	sql = sql & " and 	Semestre_Letivo = " & intSemestre
	sql = sql & " and 	Cod_Curso = " & intCodCurso
	sql = sql & " and 	Cod_Periodo = " & intCodPeriodo
	sql = sql & " and 	Cod_Disciplina = " & intCodDisciplinaCurso
	rs.open sql, cnn
	if rs.eof = false then
	   strTemMesmoRegistro = true
	end if 
	rs.close
	
	if acao="I" then

		if strTemMesmoRegistro then
			%>
			<script>
				alert("ATENÇÃO: Disciplina já Cadastrada na Optativa no Ano, Semestre, Curso e Período. Favor verificar as informações cadastradas.");
				window.history.back();
			</script>
			<%
			response.End()
		end if


		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_OPTATIVAS(Cod_Empresa, Ano_letivo, Semestre_Letivo, Cod_Curso, Cod_Periodo, Cod_Disciplina)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & intCodCurso & ","
		sql = sql & "" & intCodPeriodo & ","
		sql = sql & "" & intCodDisciplinaCurso & ")"
		cnn.execute sql

	elseif acao="A" then
		
		if strTemMesmoRegistro then
			%>
			<script>
				alert("ATENÇÃO: Disciplina já Cadastrada na Optativa no Ano, Semestre, Curso e Período. Favor verificar as informações cadastradas.");
				window.history.back();
			</script>
			<%
			response.End()
		end if

		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_OPTATIVAS Set"
		sql = sql & " Ano_letivo = " & intAnoLetivo & ","
		sql = sql & " Semestre_Letivo = " & intSemestre & ","
		sql = sql & " Cod_Curso = " & intCodCurso & ","
		sql = sql & " Cod_Periodo = " & intCodPeriodo & ","
		sql = sql & " Cod_Disciplina = " & intCodDisciplinaCurso
		sql = sql & " Where Cod_Optativa = " & intCodOptativa
		cnn.execute sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_OPTATIVAS "
		sql = sql & " where Cod_Optativa = " & intCodOptativa
		cnn.execute sql

	end if
	
	
	GravarLog sql
	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Optativa_cad.asp?cmbCurso=<%=intCodCurso%>';
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