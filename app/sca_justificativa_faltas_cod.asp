<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnndocumento.asp"-->
<!--#include file="includes/inc_formataData.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	Dim startDate, endDate, currentDate
	
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))

	intCodBimestre								= Trim(Request.form("cmbBimestre"))
	intCodAluno									= Trim(Request.form("cmbAluno"))
	intCodTurma 								= Trim(Request.form("cmbTurma"))
	strDataInicial 								= Trim(Request.Form("txtDataInicial"))
	strDataFinal 								= Trim(Request.Form("txtDataFinal"))
	strJustificativa          					= Trim(Request("txtJustificativa"))
	intCodTipoJustificativa 					= Trim(Request.form("cmbTipoJustificativa"))

	if acao <> "E" then
		strImagem								= Trim(Request("txtTexto"))
	end if
	
	strAnoLetivo             					= Trim(Request("txtAnoLetivo"))
	intSemestre             					= Trim(Request("cmbSemestre"))
	'obrigario_imagem             				= Trim(Request("obrigario_imagem"))
	obrigario_imagem = "S"
	
	if strSimouNao = "" then
	   strSimouNao = "N"
	end if 

	if acao="I" then
		if obrigario_imagem = "S" then
			if LEFT(strImagem,9)<>"<img src=" then
				cnn.rollbacktrans
				%>
				<script>
					alert("Imagem do documento invalida, devera ser enviado somente documento do tipo IMAGEM (JPG ou PNG)!");
					window.history.back();
				</script>
				<%
				response.end 
			end if	
			if LEN(strImagem)>9999999 then
				cnn.rollbacktrans
				%>
				<script>
					alert("Imagem não permitida, Favor redur o tamanho da imagem!");
					window.history.back();
				</script>
				<%
				response.end 
			end if	
		end if
	
		sql = " select codigo from SCA_ALUNO_JUSTIFICATIVA_FALTAS " 
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")  
		sql = sql & " and cod_aluno = " & intCodAluno
		sql = sql & " and convert(datetime,convert(varchar, DataInicial, 103),103) = convert(datetime, ' " & formatadataAP(strDataInicial) & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, DataFinal, 103),103) = convert(datetime, ' " & formatadataAP(strDataFinal) & " ',103) "
		rs.open sql, cnn,3,3
		if rs.eof = false then
			cnn.rollbacktrans
			%>
			<script>
				alert("Existe a mesma justificativa lançada para esse aluno. Verifique!");
				window.location='sca_justificativa_faltas.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
		
		strMensagem = "Registro incluido com sucesso..."

		sql = "SET NoCount ON Insert Into SCA_ALUNO_JUSTIFICATIVA_FALTAS(cod_empresa, cod_Tipo_Justificativa_Faltas, Cod_bimestre, ano_letivo,"
		sql = sql & " semestre, DataInicial, DataFinal, cod_aluno, Cod_turma, justificativa, usuario_incl, data_hora_incl) "
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodTipoJustificativa & ","
		sql = sql & "" & intCodBimestre & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & formatadataBD(strDataInicial) & "',"
		sql = sql & "'" & formatadataBD(strDataFinal) & "',"
		sql = sql & "" & intCodAluno & ","
		sql = sql & "" & intCodTurma & ","
		if strJustificativa <> "" then
			sql = sql & "'" & strJustificativa & "',"
		else 
			sql = sql &" null ,"
		end if
		sql = sql & "'" & session("usuarioWeb") & "',GetDate()); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodAlunoJustificativaFaltas = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
		sql = "Insert Into SCA_ALUNO_JUSTIFICATIVA_FALTAS_IMAGEM(cod_aluno_justificativa_faltas, cod_aluno, imagem)"
		sql = sql & " Values ("
		sql = sql & "" & intCodAlunoJustificativaFaltas & ","
		sql = sql & "" & intCodAluno & ","
		sql = sql & "'" & strImagem & "')"
		cnn.execute sql
		
		' Definir as datas de início e fim
		
		startDate = CDate(strDataInicial)
		endDate = CDate(strDataFinal)

		' Loop para iterar entre as datas
		currentDate = startDate
		While currentDate <= endDate
			
			sql = "select distinct SCA_HORARIO_AULA.cod_disciplina"
			sql = sql & " from SCA_HORARIO_AULA "
			sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario "
			sql = sql & " where SCA_HORARIO_AULA.cod_empresa = " & intCodEmp
			sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & year(currentDate)
			sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurma
			sql = sql & " and SCA_HORARIO_AULA.diaSemana = " & WeekDay(formatadataBD(currentDate))	
			sql = sql & " union "
			sql = sql & " select cod_disciplina"
			sql = sql & " from SCA_HORARIO_AULA_EXTRA"
			sql = sql & " where cod_empresa = " & intCodEmp
			sql = sql & " and anoletivo = " & year(currentDate)
			sql = sql & " and cod_turma = " & intCodTurma
			sql = sql & " and DataLancamento = '" & formatadataBD(currentDate) & "'"
			vetJust = null
			rs.open sql, cnn
			if not rs.eof then
				vetJust = rs.getRows
			end if
			rs.close
			
			if isArray(vetJust) then

				for i=0 to ubound(vetJust,2)

					cod_disciplina  	= vetJust(0,i) 
					sql = "Insert Into SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA (cod_aluno_justificativa_faltas, cod_aluno, cod_disciplina, diaSemana, DataFalta)"
					sql = sql & " Values ("
					sql = sql & "" & intCodAlunoJustificativaFaltas & ","
					sql = sql & "" & intCodAluno & ","
					sql = sql & "" & cod_disciplina & ","
					sql = sql & "" & WeekDay(formatadataBD(currentDate))	 & ","
					sql = sql & "'" & formatadataBD(currentDate) & "')"
					cnn.execute sql

				next
			end if

			currentDate = DateAdd("d", 1, currentDate)
			
			
		wend

	'response.end
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "update SCA_ALUNO_JUSTIFICATIVA_FALTAS set "
		sql = sql & " cod_Tipo_Justificativa_Faltas = " & intCodTipoJustificativa & ","
		sql = sql & " Cod_bimestre = " & intCodBimestre & ","
		sql = sql & " DataInicial = '" & formatadataBD(strDataInicial) & "',"
		sql = sql & " DataFinal = '" & formatadataBD(strDataFinal) & "',"
		sql = sql & " cod_aluno = " & intCodAluno & ","
		sql = sql & " Cod_turma = " & intCodTurma & ","
		if strJustificativa <> "" then
			sql = sql & " justificativa = '" & strJustificativa & "',"
		else 
			sql = sql & " justificativa = null ,"
		end if
		sql = sql & " usuario_altr = '" & session("usuarioWeb") & "',"
		sql = sql & " data_hora_altr = GetDate()"
		sql = sql & " where codigo = " & intCodigo
		cnn.Execute(sql)
		GravarLog SQL
		

		sql = "update SCA_ALUNO_JUSTIFICATIVA_FALTAS_IMAGEM set "
		sql = sql & " cod_aluno = " & intCodAluno & ","
		sql = sql & " imagem = '" & strImagem & "'"
		sql = sql & " where cod_aluno_justificativa_faltas = " & intCodigo
		cnn.execute sql
		
		sql = "delete SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA "
		sql = sql & " where cod_aluno_justificativa_faltas = " & intCodigo
		cnn.execute sql
		
		' Definir as datas de início e fim
		
		startDate = CDate(strDataInicial)
		endDate = CDate(strDataFinal)

		' Loop para iterar entre as datas
		currentDate = startDate
		While currentDate <= endDate
			
			sql = "select distinct SCA_HORARIO_AULA.cod_disciplina"
			sql = sql & " from SCA_HORARIO_AULA "
			sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario "
			sql = sql & " where SCA_HORARIO_AULA.cod_empresa = " & intCodEmp
			sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & year(currentDate)
			sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurma
			sql = sql & " and SCA_HORARIO_AULA.diaSemana = " & WeekDay(formatadataBD(currentDate))	
			sql = sql & " union "
			sql = sql & " select cod_disciplina"
			sql = sql & " from SCA_HORARIO_AULA_EXTRA"
			sql = sql & " where cod_empresa = " & intCodEmp
			sql = sql & " and anoletivo = " & year(currentDate)
			sql = sql & " and cod_turma = " & intCodTurma
			sql = sql & " and DataLancamento = '" & formatadataBD(currentDate) & "'"
			vetJust = null
			rs.open sql, cnn
			if not rs.eof then
				vetJust = rs.getRows
			end if
			rs.close
			
			if isArray(vetJust) then

				for i=0 to ubound(vetJust,2)

					cod_disciplina  	= vetJust(0,i) 
					sql = "Insert Into SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA (cod_aluno_justificativa_faltas, cod_aluno, cod_disciplina, diaSemana, DataFalta)"
					sql = sql & " Values ("
					sql = sql & "" & intCodigo & ","
					sql = sql & "" & intCodAluno & ","
					sql = sql & "" & cod_disciplina & ","
					sql = sql & "" & WeekDay(formatadataBD(currentDate))	 & ","
					sql = sql & "'" & formatadataBD(currentDate) & "')"
					response.write sql & "<hr>"
					cnn.execute sql

				next
			end if

			currentDate = DateAdd("d", 1, currentDate)
			
		wend
		
	elseif acao="E" then
		sql = "delete SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA "
		sql = sql & " where cod_aluno_justificativa_faltas = " & intCodigo
		cnn.execute sql

		sql = "delete SCA_ALUNO_JUSTIFICATIVA_FALTAS_IMAGEM "
		sql = sql & " where cod_aluno_justificativa_faltas = " & intCodigo
		cnn.execute sql
		
		sql = "delete SCA_ALUNO_JUSTIFICATIVA_FALTAS "
		sql = sql & " where codigo = " & intCodigo
		cnn.Execute(sql)
		GravarLog SQL
		
		strMensagem = "Registro excluido com sucesso..."

	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="E" then
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location="sca_justificativa_faltas.asp";
			</script>
			<%
		else
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location="sca_justificativa_faltas.asp?txtAnoLetivo=<%=strAnoLetivo%>&cmbSemestre=<%=intSemestre%>&cmbBimestre=<%=intCodBimestre%>&cmbTurma=<%=intCodTurma%>";
			</script>
			<%
		end if
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