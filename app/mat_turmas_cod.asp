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
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmpresaGrupo 		= Trim(Request("cmbEmpresaGrupo"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	
	sql = "SELECT T.Cod_Turma, t.VagasMatriculaInicial, T.Cod_GradeCurricular, c.descricao as curso, pp.descricao as periodo, T.Cod_Semestre, T.Cod_Turno, tt.Desc_Turno, isnull(T.Capacidade,'0') as Capacidade,"
	sql = sql & " T.Cod_PlanoPagamento, T.Cod_ContaCorrente, T.nomeTurma, T.Sala, T.Ano, T.AnoLetivo, T.TurmaAluno, isnull(T.VagasMatriculas,0) as VagasMatriculas, isnull(T.VagasMatriculasUtilizadas,0) as VagasMatriculasUtilizadas, "
	sql = sql & " isnull(T.VagasReservadas,0) as VagasReservadas" 
	sql = sql & " FROM SCA_TURMA T"
	sql = sql & " Inner join sca_Turno tt on TT.Cod_Turno = T.Cod_Turno "
	sql = sql & " inner join SCA_PERIODO pp on pp.Cod_Periodo = t.Cod_Periodo"
	sql = sql & " inner join SCA_CURSO c on c.Cod_curso = pp.cod_curso"
	
	sql = sql & " where isnull(c.Sigla,'') NOT IN ('AE','AT') and T.SITUACAO = 'A' AND T.Cod_empresa = " & intCodEmpresaGrupo		
	
	if strAnoLetivo <> "" then
		sql = sql & " and T.AnoLetivo = " & strAnoLetivo
	end if
	
	if intSemestre <> "0" then
		sql = sql & " and  T.Cod_Semestre = " & intSemestre
	end if
	
	if intCodPeriodo <> "0" then
		sql = sql & " and  t.Cod_Periodo = " & intCodPeriodo
	end if
	if intCodTurno <> "0" then
		sql = sql & " and  T.Cod_Turno = " & intCodTurno
	end if
	if intCodCurso <> "0" then
		sql = sql & " and  pp.cod_curso = " & intCodCurso
	end if
	
	sql = sql & " Order by t.AnoLetivo, c.descricao, pp.descricao, tt.Desc_Turno, t.Nometurma"
	
	rs.open sql, cnn,3,3
	if not rs.eof then

		strMensagem = "Registro Alterado com sucesso..."

		while not rs.eof
			
			intVagasReservadas 	= Trim(Request.Form("txtVagasMatriculasReservadas_" & rs("Cod_Turma")))
			intNumCapacidade 	= Trim(Request.Form("txtNumCapacidade_" & rs("Cod_Turma")))
'			intSala			 	= Trim(Request.Form("txtSala_" & rs("Cod_Turma")))
			
			sql = "Update SCA_TURMA Set "
			if 	intVagasReservadas  = "" then
				sql = sql & "VagasReservadas = 0,"
			else
				sql = sql & "VagasReservadas = " & intVagasReservadas & ","
			end if	
			if 	intNumCapacidade  = "" then
				sql = sql & "Capacidade = 0, VagasMatriculas = 0,"
			else
				sql = sql & "Capacidade = " & intNumCapacidade & ", VagasMatriculas = " & intNumCapacidade & ","
			end if
			sql = sql & "usuario_altr = '" & session("usuarioWeb") & "',"
			sql = sql & "data_hora_altr = getdate()"
			
			sql = sql & " where Cod_Turma = " & trim(rs("Cod_Turma"))
			sql = sql & " and Cod_Empresa = " & intCodEmpresaGrupo
			cnn.execute sql
			
			if trim(intVagasReservadas) <> trim(rs("VagasReservadas")) then
				intCodEmp			= intCodEmpresaGrupo
				intCodTurma			= trim(rs("Cod_Turma"))
				strUsuarioIncl		= trim(session("usuarioWeb"))
				strOcorrencia		= "Turma " & trim(rs("TurmaAluno")) & " (" & trim(rs("nomeTurma")) & ") foi alterada as vagas reservadas de " & trim(rs("VagasReservadas")) & " para " & intVagasReservadas & "."
				%>
				<!--#include file="includes/inc_lancamentoDeOcorrenciaTurma.asp"-->	
				<%
			end if
			if trim(intNumCapacidade) <> trim(rs("capacidade")) then
				intCodEmp			= intCodEmpresaGrupo
				intCodTurma			= trim(rs("Cod_Turma"))
				strUsuarioIncl		= trim(session("usuarioWeb"))
				strOcorrencia		= "Turma " & trim(rs("TurmaAluno")) & " (" & trim(rs("nomeTurma")) & ") foi alterada a capacidade de " & trim(rs("capacidade")) & " para " & intNumCapacidade & "."
				%>
				<!--#include file="includes/inc_lancamentoDeOcorrenciaTurma.asp"-->	
				<%
			end if
			rs.movenext
		wend
	end if
	rs.close
	
	sql = "EXEC SP_MAT_AtualizaTurmaVagaMatricula " & strAnoLetivo & ", " & clng(session("codGrupo"))
	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='mat_turmasCon.asp?txtAnoLetivo=<%=strAnoLetivo%>&cmbEmpresaGrupo=<%=intCodEmpresaGrupo%>';
		</script>
		<%
		response.end
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>