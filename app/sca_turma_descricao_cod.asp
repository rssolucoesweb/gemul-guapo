<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	
	sql = "SELECT T.Cod_Turma, P.DESCRICAO "
	sql = sql & " FROM SCA_TURMA T"
	sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
	sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
	sql = sql & " where T.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and T.AnoLetivo = " & strAnoLetivo
	sql = sql & " and T.Cod_Semestre = " & intSemestre
	sql = sql & " and P.Cod_Curso = " & intCodCurso
	sql = sql & " and ISNULL(T.cod_turma_grupo,'0')=0 "
	sql = sql & " Order by T.AnoLetivo, P.sequencia, T.Nometurma"
	rs.open sql, cnn,3,3
	if not rs.eof then
		strMensagem = "Registro Alterado com sucesso..."

		while not rs.eof

			intCodTurma				= trim(rs("Cod_Turma"))
			strTurmaAluno 			= replace(Trim(Request.Form("txtTurmaAluno_" & trim(rs("Cod_Turma")))),"'","")
			strTurmaAlunoComplemento 			= replace(Trim(Request.Form("txtTurmaAlunoComplemento_" & trim(rs("Cod_Turma")))),"'","")
			
			strPeriodo 				= trim(rs("DESCRICAO"))
			
			strTurmaAluno			= strPeriodo & " " & strTurmaAluno
			
			intCapacidade			= Trim(Request.Form("txtCapacidade_" & trim(rs("Cod_Turma"))))
			if intCapacidade = "" then intCapacidade = "0"
			
			if intCodTurma <> "" then
				sql = "Update SCA_TURMA Set "
				if	strTurmaAluno = "" then
					sql = sql & " TurmaAluno = Null,"
				else
					sql = sql & " TurmaAluno = '" & strTurmaAluno & "',"
				end if
				if	strTurmaAlunoComplemento = "" then
					sql = sql & " TurmaAlunoComplemento = Null,"
				else
					sql = sql & " TurmaAlunoComplemento = '" & strTurmaAlunoComplemento & "',"
				end if
				sql = sql & " Capacidade = " & intCapacidade 
				sql = sql & " where Cod_Turma = " & intCodTurma
				cnn.execute sql
				GravarLog sql
				
			end if
	
			rs.movenext
		wend
	end if
	rs.close
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_turma_descricao.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>