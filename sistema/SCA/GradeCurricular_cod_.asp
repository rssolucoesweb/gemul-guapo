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
	acao 				= Trim(Request.QueryString("acao"))
	
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	intCodCurso			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo		= Trim(Request.Form("cmbPeriodo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	intAno				= Trim(Request.Form("txtAno"))
	intCodDisciplina	= Trim(Request("txtCodDisciplina"))
	strDataInicioVingecia= formataDataBD(Trim(Request("txtDataInicio")))
	strDataFimVingecia= formataDataBD(Trim(Request("txtDataFim")))
	
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
				alert("ATENÇÃO: Já existe uma grade cadastrada com essas mesmas informções, favor consultas as grades existentes.");
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
			
		sql = "Insert Into SCA_GRADECURRICULAR(Cod_Empresa, Cod_GradeCurricular, Cod_Periodo, AnoReferencia, SemestreReferencia, Situacao, dataInicioVigencia, dataFimVigencia)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodPeriodo & ","
		sql = sql & "" & intAno & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strSituacao & "',"
		if strDataInicioVingecia <> "" then 
			sql = sql & "'" & strDataInicioVingecia & "',"
		else
			sql = sql & "null,"
		end if
		if strDataFimVingecia <> "" then 
			sql = sql & "'" & strDataFimVingecia & "')"
		else
			sql = sql & "null)"
		end if
		cnn.execute sql
		GravarLog sql
		
		'Grade Curricular Disciplina
		for i=0 to ubound(vetDisciplina)
		
			sql = "SELECT Max(Cod_GradeCurricularDisciplina) as MaiorCodigo" 
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA"
			rs.open sql, cnn
			
			if not RS.EOF then
			
				if rs("MaiorCodigo") <> "" then
					intCodNovo = cstr(rs("MaiorCodigo")) + 1
					intCodCurricularDiscip = intCodNovo
				else
					intCodCurricularDiscip = 1	
				end if
			
			end if
			rs.close
		
			sql = "INSERT INTO SCA_GRADECURRICULARDISCIPLINA ( Cod_GradeCurricularDisciplina, COD_GRADECURRICULAR, Cod_Disciplina )"
			sql = sql & " Values (" 
			sql = sql & "" & intCodCurricularDiscip & ","
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & vetDisciplina(i) & ")"
			cnn.execute sql
			GravarLog sql
		next
	
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_GRADECURRICULAR Set"
		sql = sql & " AnoReferencia = " & intAno & ","
		sql = sql & " SemestreReferencia = " & intSemestre & ","
		sql = sql & " Situacao = '" & strSituacao & "',"
		if strDataInicioVingecia <> "" then 
			sql = sql & "dataInicioVigencia = '" & strDataInicioVingecia & "',"
		else
			sql = sql & "dataInicioVigencia = null,"
		end if
		if strDataFimVingecia <> "" then 
			sql = sql & "dataFimVigencia = '" & strDataFimVingecia & "' "
		else
			sql = sql & "dataFimVigencia = null "
		end if
		sql = sql & " where Cod_GradeCurricular = " & intCodigo

		cnn.execute sql
		GravarLog sql
	
	elseif acao="AD" then 'Alterar Disciplina
	
		intCodigo			= Trim(Request("idnt"))
		strNomeCampo		= Replace(Replace(Trim(Request("NomeCampo")),".",""),",",".")
		strValor			= Replace(Replace(Trim(Request("ValorCampo")),".",""),",",".")
		
		if trim(strValor) <> "" then
			sql = "Update SCA_GRADECURRICULARDISCIPLINA Set "
			sql = sql & strNomeCampo & " = " & strValor & ""
			sql = sql & " WHERE Cod_GradeCurricularDisciplina = " & intCodigo
			cnn.execute sql
			GravarLog sql
	end if
			
	elseif acao="ED" then 'Excluir Disciplina
		
		strMensagem = "Registro Excluido com sucesso..."
		
		intCodigo						= Trim(Request("CodGrade"))
		intCodCurricularDisciplina		= Trim(Request("CodCurricularDisciplina"))

		sql = "Delete from SCA_GRADECURRICULARDISCIPLINA "
		sql = sql & " where Cod_GradeCurricular = " & intCodigo
		sql = sql & " And Cod_GradeCurricularDisciplina = " & intCodCurricularDisciplina
		cnn.execute sql
		GravarLog sql
	elseif acao="E" then
			
		strMensagem = "Registro Excluido com sucesso..."
		
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
			window.navigate('GradeCurricular_cad.asp?nCodigo=<%=intCodigo%>');
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