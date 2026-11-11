<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.brs
	::	Objetivo Pagina...: Cadastro Grade Equivalencia 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 											= Trim(Request.QueryString("acao"))
	intCodItem 										= Trim(Request.QueryString("CodigoItem"))	

	intCodEmp 										= Session("CodEmpresa")
	intCodGradeCurricularDisciplina	 				= Trim(Request.form("txtCodGradeCurricularDisciplina")) 
	intCodTurma	 									= Trim(Request.form("txtCodTurma"))
	intCodFuncao 	    							= TRIM(Request.Form("cmbFuncao"))
	intCodTurno 	    							= TRIM(Request.Form("cmbTurnoRH"))
	intCodTurnoTurma    							= TRIM(Request("txtCodTurnoTurma"))
	strVagas	 									= TRIM(Request.Form("cmbVagas"))
	strModularGrupoGrade							= Trim(Request("ModularGrupoGrade"))
	
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = " SELECT Cod_Funcao"
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA_TURNO " 
		sql = sql & " where Cod_GradeCurricularDisciplina = " & intCodGradeCurricularDisciplina
		sql = sql & " and Cod_Funcao = " & intCodFuncao
		sql = sql & " and ISNULL(cod_TurnoFuncao,'0') = " & intCodTurno
		rs.open sql, cnn
		if rs.eof = false then
			cnn.rollbackTrans
			%>
			<script>
				alert("Funcao ja Informada para essa Disciplina. Verifique!");
				window.history.back();
			</script>
			<%
			response.end
		end if 
		rs.close

		sql = "Insert Into SCA_GRADECURRICULARDISCIPLINA_TURNO( Cod_GradeCurricularDisciplina, Cod_Funcao, Cod_TurnoFuncao, cod_turno, Total_Vaga_Funcao )"
		sql = sql & " Values ("
		sql = sql & "" & intCodGradeCurricularDisciplina & ","
		sql = sql & "" & intCodFuncao & ","
		sql = sql & "" & intCodTurno & ","
		sql = sql & "" & intCodTurnoTurma & ","
		sql = sql & "" & strVagas & ")"
		'RESPONSE.WRITE SQL
		'RESPONSE.END
		cnn.execute sql
		GravarLog sql

	end if

	if acao="EF" then
	
		strMensagem = "Item Excluido com sucesso..."
		
		sql = "Delete From SCA_GRADECURRICULARDISCIPLINA_TURNO "
		sql = sql & " Where Codigo = " & intCodItem
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location="ModulacaoCurricular_cad.asp?CodigoTurma=<%=intCodTurma%>&txtCodTurnoTurma=<%=intCodTurnoTurma%>";
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location="ModulacaoCurricular_cad.asp?CodigoTurma=<%=intCodTurma%>";
		</script>
		<%
		response.end
	end if
%>