<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Grade Curricular
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao              = Trim(Request.QueryString("acao"))
	
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodCurso				= Trim(Request.Form("cmbCurso"))
	intCodCursoResolucao	= Trim(Request.Form("cmbCursoResolucao"))
	intCodPeriodo			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	intAno					= Trim(Request.Form("txtAno"))
	intCodDisciplina		= Trim(Request("txtCodDisciplina"))
	strDataInicioVingecia= formataDataBD(Trim(Request("txtDataInicio")))
	strDataFimVingecia= formataDataBD(Trim(Request("txtDataFim")))
	intCodAgrupamento   = Trim(Request("txtCodAgrupamento"))

	
	if intCodDisciplina <> "" then
		vetDisciplina	= split(intCodDisciplina,",")
	end if

	if acao="I" then


		'REGRA PARA INCLUSAO GRADE REPETIDA
		sql = "select cod_gradeCurricular"
		sql = sql & " from SCA_GRADECURRICULAR"
		sql = sql & " where cod_empresa = " & intCodEmp
		sql = sql & " and anoReferencia = " & intAno
		sql = sql & " and semestreReferencia = " & intSemestre
		sql = sql & " and cod_periodo = " & intCodPeriodo
		sql = sql & " and situacao = 'A'"
		
		rs.open sql, cnn
		if not RS.EOF then
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Já existe uma grade cadastrada com essas mesmas informações, favor consultas as grades existentes.");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		rs.close
	
		strMensagem = "Grade Curricular registrada com com sucesso, Agora informe as cargas horarias para disciplinas escolhidas!"
	
		sql = "SELECT Max(COD_GRADECURRICULAR) as MaiorCodigo" 
		sql = sql & " FROM SCA_GRADECURRICULAR"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
			
		sql = "Insert Into SCA_GRADECURRICULAR(Cod_Empresa, Cod_GradeCurricular, Cod_Periodo, CodCursoResolucao, "
		sql = sql & " AnoReferencia, SemestreReferencia, Situacao, dataInicioVigencia, dataFimVigencia, Cod_Agrupamento)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodPeriodo & ","
		sql = sql & "" & intCodCursoResolucao & ","
		sql = sql & "" & intAno & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strSituacao & "',"
		
		if strDataInicioVingecia <> "" then 
			sql = sql & "'" & strDataInicioVingecia & "',"
		else
			sql = sql & "null,"
		end if
		
		if strDataFimVingecia <> "" then 
			sql = sql & "'" & strDataFimVingecia & "',"
		else
			sql = sql & "null,"
		end if
		
		if intCodAgrupamento <> "" then 
			sql = sql & "" & intCodAgrupamento & ")"
		else
			sql = sql & "null)"
		end if
		cnn.execute sql
		GravarLog sql
		
		'Grade Curricular Disciplina
		for i=0 to ubound(vetDisciplina)
			
			intCh_Semanal = 1
			Ch_Mensal = 1
			Ch_Anual = 1
			
			
			sql = "INSERT INTO SCA_GRADECURRICULARDISCIPLINA (  COD_GRADECURRICULAR, Cod_Disciplina, Ch_Semanal, Ch_Mensal, Ch_Anual )"
			sql = sql & " Values (" 
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & vetDisciplina(i) & ","
			sql = sql & "" & intCh_Semanal & ","
			sql = sql & "" & Ch_Mensal & ","
			sql = sql & "" & Ch_Anual & ")"
			cnn.execute sql
			GravarLog sql
				
		next
	
	elseif acao="A" then
	
		
		strMensagem = "Registro Alterado com sucesso..."

		'Grade Curricular Disciplina
		for i=0 to ubound(vetDisciplina)
			
			intCh_Semanal = 1
			Ch_Mensal = 1
			Ch_Anual = 1
	
			sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.Cod_GRADECURRICULAR "
			sql = sql & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " & intCodigo
			sql = sql & " AND SCA_GRADECURRICULAR.COD_EMPRESA = " & intCodEmp
			sql = sql & " AND SCA_GRADECURRICULARDISCIPLINA.COD_DISCIPLINA = " & vetDisciplina(i)
			rs.open sql, cnn	
			if rs.eof then
			
				
				sql = "INSERT INTO SCA_GRADECURRICULARDISCIPLINA ( COD_GRADECURRICULAR, Cod_Disciplina, Ch_Semanal, Ch_Mensal, Ch_Anual )"
				sql = sql & " Values (" 
				sql = sql & "" & intCodigo & ","
				sql = sql & "" & vetDisciplina(i) & ","
				sql = sql & "" & intCh_Semanal & ","
				sql = sql & "" & Ch_Mensal & ","
				sql = sql & "" & Ch_Anual & ")"
				cnn.execute sql
				GravarLog sql
				
			end if
			rs.close
		next
		
		sql = "Update SCA_GRADECURRICULAR Set"
		sql = sql & " CodCursoResolucao = " & intCodCursoResolucao & ","
		sql = sql & " AnoReferencia = " & intAno & ","
		sql = sql & " SemestreReferencia = " & intSemestre & ","
		sql = sql & " Situacao = '" & strSituacao & "',"
		
		if strDataInicioVingecia <> "" then 
			sql = sql & "dataInicioVigencia = '" & strDataInicioVingecia & "',"
		else
			sql = sql & "dataInicioVigencia = null,"
		end if
		
		if strDataFimVingecia <> "" then 
			sql = sql & "dataFimVigencia = '" & strDataFimVingecia & "', "
		else
			sql = sql & "dataFimVigencia = null, "
		end if
		
		if intCodAgrupamento <> "" then 
			sql = sql & "Cod_Agrupamento = " & intCodAgrupamento
		else
			sql = sql & "Cod_Agrupamento = null "
		end if
		
		sql = sql & " where Cod_GradeCurricular = " & intCodigo

		cnn.execute sql
		GravarLog sql
	
	elseif acao="AD" then 'Alterar Disciplina
	
		intCodigo			= Trim(Request("idnt"))
		strNomeCampo		= Replace(Replace(Trim(Request("NomeCampo")),".",""),",",".")
		strValor			= Replace(Replace(Trim(Request("ValorCampo")),".",""),",",".")
		
		if strNomeCampo = "Cod_GradeCurricularDisciplina_Equivalente" then
			if trim(strValor) <> "" then
			
				sql = "select cod_disciplina from SCA_GRADECURRICULARDISCIPLINA "
				sql = sql & "WHERE Cod_GradeCurricularDisciplina = " & strValor
				rs.open sql, cnn
				if not rs.eof then
					cod_dis = rs("cod_disciplina")
				end if
				rs.close
				
				sql = "Update SCA_GRADECURRICULARDISCIPLINA Set "
				sql = sql & "Cod_GradeCurricularDisciplina_Equivalente = " & strValor & ","
				sql = sql & "Cod_Disciplina_Equivalente = " & cod_dis & ""
				sql = sql & " WHERE Cod_GradeCurricularDisciplina = " & intCodigo
				cnn.execute sql
				GravarLog sql
			end if
		else
		
			if trim(strValor) <> "" then
			
				sql = "Update SCA_GRADECURRICULARDISCIPLINA Set "
				sql = sql & strNomeCampo & " = " & strValor & ""
				sql = sql & " WHERE Cod_GradeCurricularDisciplina = " & intCodigo
				
				
				
				cnn.execute sql
				
				response.Write(sql)
				response.End()
				
				GravarLog sql
			end if
		end if			
		
	elseif acao="ED" then 'Excluir Disciplina
		
		strMensagem = "Registro Excluido com sucesso..."
		
		intCodigo						= Trim(Request("CodGrade"))
		intCodCurricularDisciplina		= Trim(Request("CodCurricularDisciplina"))

		'NÃO DEIXA EXCLUIR AS GRADE JÁ UTILIZADAS
		sql = "select top 1 AD.codigo"
		sql = sql & " from SCA_ALUNO_DISCIPLINA AD"
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricularDisciplina = AD.Cod_GradeCurricularDisciplina"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = GD.Cod_GradeCurricular AND G.cod_empresa = AD.cod_empresa "
		sql = sql & " where	GD.Cod_GradeCurricular = " & intCodigo
		sql = sql & " and	G.cod_empresa = " & intCodEmp
		sql = sql & " and	G.AnoReferencia >=2011"
		sql = sql & " And GD.Cod_GradeCurricularDisciplina = " & intCodCurricularDisciplina		
		rs.open sql, cnn
		if not RS.EOF then
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Grade não pode ser excluída, existe alunos vinculados.");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		rs.close

		sql = "select top 1 AD.codigo"
		sql = sql & " from SCA_ALUNO_DISCIPLINA AD"
		sql = sql & " INNER JOIN SCA_NOTAS_FALTAS F ON F.Cod_empresa = AD.Cod_empresa AND F.COD_ALUNO = AD.COD_ALUNO and F.Cod_aluno_Disciplina = AD.codigo"
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricularDisciplina = AD.Cod_GradeCurricularDisciplina"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = GD.Cod_GradeCurricular AND G.cod_empresa = AD.cod_empresa "
		sql = sql & " where	GD.Cod_GradeCurricular = " & intCodigo
		sql = sql & " and	G.cod_empresa = " & intCodEmp
		sql = sql & " and	G.AnoReferencia >=2011"
		sql = sql & " And GD.Cod_GradeCurricularDisciplina = " & intCodCurricularDisciplina		
		rs.open sql, cnn
		if not RS.EOF then
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Grade não pode ser excluída, existe alunos/notas vinculadas.");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		rs.close

		sql = "Delete from SCA_HISTORICO_ESCOLAR_DISCIPLINA "
		sql = sql & " where Cod_GradeCurricularDisciplina = " & intCodCurricularDisciplina
		cnn.execute sql
		GravarLog sql

		sql = "Delete from SCA_ALUNO_DISCIPLINA "
		sql = sql & " where Cod_GradeCurricularDisciplina = " & intCodCurricularDisciplina
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete from SCA_GRADECURRICULARDISCIPLINA "
		sql = sql & " where Cod_GradeCurricular = " & intCodigo
		sql = sql & " And Cod_GradeCurricularDisciplina = " & intCodCurricularDisciplina
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
			
		strMensagem = "Registro Excluido com sucesso..."

		'NÃO DEIXA EXCLUIR AS GRADE JÁ UTILIZADAS
		sql = "select top 1 AD.codigo"
		sql = sql & " from SCA_ALUNO_DISCIPLINA AD"
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricularDisciplina = AD.Cod_GradeCurricularDisciplina"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = GD.Cod_GradeCurricular AND G.cod_empresa = AD.cod_empresa "
		sql = sql & " where	GD.Cod_GradeCurricular = " & intCodigo
		sql = sql & " and	G.cod_empresa = " & intCodEmp
		sql = sql & " and	G.AnoReferencia >=2011"
		rs.open sql, cnn
		if not RS.EOF then
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Grade não pode ser excluída, existe alunos vinculados.");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		rs.close

		sql = "select top 1 AD.codigo"
		sql = sql & " from SCA_ALUNO_DISCIPLINA AD"
		sql = sql & " INNER JOIN SCA_NOTAS_FALTAS F ON F.Cod_empresa = AD.Cod_empresa AND F.COD_ALUNO = AD.COD_ALUNO and F.Cod_aluno_Disciplina = AD.codigo"
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricularDisciplina = AD.Cod_GradeCurricularDisciplina"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = GD.Cod_GradeCurricular AND G.cod_empresa = AD.cod_empresa "
		sql = sql & " where	GD.Cod_GradeCurricular = " & intCodigo
		sql = sql & " and	G.cod_empresa = " & intCodEmp
		sql = sql & " and	G.AnoReferencia >=2011"
		rs.open sql, cnn
		if not RS.EOF then
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Grade não pode ser excluída, existe alunos/notas vinculadas.");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		rs.close

		sql = "Delete from SCA_GRADECURRICULARDISCIPLINA "
		sql = sql & " Where Cod_GradeCurricular = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete from SCA_GRADECURRICULAR "
		sql = sql & " Where Cod_GradeCurricular = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	end if
		
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao <> "AD" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='GradeCurricular_cad.asp?nCodigo=<%=intCodigo%>';
		</script>
		<%
		end if
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