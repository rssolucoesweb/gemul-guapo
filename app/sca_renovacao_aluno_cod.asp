<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formataData.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strSemestre 		= 3
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strAnoLetivoRenovacao = request("txtAnoLetivoRenovacao")
	
	intCodAluno			= Trim(Request.Form("txtCodAluno"))
	intCodTurma			= Trim(Request.Form("cmbTurma"))

	cnn.begintrans
	
	if acao = "C" then
		intCodAluno			= Trim(Request("codAluno"))
		if intCodAluno = "" then
			%>
			<script>
				alert("ATENÇÃO: \n\nDeve ser selecionado os alunos para  a confirmação.");
				window.history.back();
			</script>
			<%	 
			response.End()
		end if	
		
		sql = " delete from SCA_ALUNO_RENOVACAO"
		sql = sql & " where COD_ALUNO = "& intCodAluno
		sql = sql & " and ANO_LETIVO = " & strAnoLetivo
		cnn.execute sql
		GravarLog sql	
		
		'Gera Ocorrencia 
		strOcorrencia		= "Matrícula de Veteranos foi CANCELADA"

		sql = " Insert Into SCA_OCORRENCIA(COD_EMPRESA, COD_DEPARTAMENTO, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, OCORRENCIA, USUARIO_INCL)"	
		sql = sql & " select "
		sql = sql & "" & intCodEmp & ",null,"
		sql = sql & " codigo,"
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & strSemestre & ","
		sql = sql & " getdate(),"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & trim(session("usuarioWeb")) & "' from sca_aluno where codigo in (" & intCodAluno & ")"
		cnn.execute sql
		
		strMensagem = "Foi CANCELADA com sucesso..."
	else
		if intCodAluno = "" then
			%>
			<script>
				alert("ATENÇÃO: \n\nDeve ser selecionado os alunos para  a confirmação.");
				window.history.back();
			</script>
			<%	
			response.End()
		end if	
		
		if intCodAluno <> "" then   
			vetAlunos	= split(intCodAluno,",")				 
		end if
		
		strMensagem=""
		for intContador = 0 to ubound(vetAlunos)
		
			intCodAluno = trim(vetAlunos(intContador))
			
			intCodCurso 	= request.form("cmbCurso" & intCodAluno)
			intCodPeriodo 	= request.form("cmbPeriodo" & intCodAluno)
			intCodTurno 	= request.form("cmbTurno" & intCodAluno)
			
			if intCodCurso<>"0" and intCodPeriodo <> "0" and intCodTurno<>"0" then
				sql = " insert into SCA_ALUNO_RENOVACAO (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,ANO_LETIVO_RENOVACAO,SEMESTRE,COD_TURMA,COD_CURSO,COD_PERIODO, COD_TURNO,USUARIO_INCL,DATA_HORA_INCL) "
				sql = sql & " values( "
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & intCodAluno & ","
				sql = sql & "" & strAnoLetivo & ","
				sql = sql & "" & strAnoLetivoRenovacao & ","
				sql = sql & "" & strSemestre & ","
				sql = sql & "" & intCodTurma & ","
				sql = sql & "" & intCodCurso & ","
				sql = sql & "" & intCodPeriodo & ","
				sql = sql & "" & intCodTurno & ","
				sql = sql & "'" & trim(session("usuarioWeb")) & "',getdate())"
				cnn.execute sql
				GravarLog sql	
							
				'Gera Ocorrencia 
				strOcorrencia		= "Confirmada Matrícula de Veteranos"
				
				sql = " Insert Into SCA_OCORRENCIA(COD_EMPRESA, COD_DEPARTAMENTO, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, OCORRENCIA, USUARIO_INCL)"	
				sql = sql & " values( "
				sql = sql & "" & intCodEmp & ",null,"
				sql = sql & "" & intCodAluno & ","
				sql = sql & "" & strAnoLetivo & ","
				sql = sql & "" & strSemestre & ","
				sql = sql & " getdate(),"
				sql = sql & "'" & strOcorrencia & "',"
				sql = sql & "'" & trim(session("usuarioWeb")) & "')"
				cnn.execute sql
				strMensagem = "Aluno confirmado com sucesso..."
			end if
		next
		
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		if strMensagem="" then
			cnn.rollbackTrans
			%>
			<script>
				alert("Aluno não foi renovado, verifique se foi informado o curso, período e turno.");
				window.location='sca_renovacao_aluno.asp?txtCodAluno=<%=intCodAluno%>';
			</script>
			<%
			response.end
		else
			cnn.commitTrans
			if acao = "C" then
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='sca_aluno.asp?txtCodAluno=<%=intCodAluno%>';
			</script>
			<%
			else
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='sca_renovacao_aluno.asp?txtCodAluno=<%=intCodAluno%>';
			</script>
			<%
			
			end if
			response.end
		end if
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