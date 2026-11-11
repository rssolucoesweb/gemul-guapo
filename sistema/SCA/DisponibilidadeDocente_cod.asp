<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 22/12/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Disponibilida deDocente
-->

<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 									= Trim(Request.QueryString("acao"))
	intCodEmp								= Session("CodEmpresa")
	intCodDisponibilidadeDocente			= Trim(Request.Form("txtCodigo"))
	intCodProfessor							= Trim(Request.Form("cmbProfessor"))
	intDiaSemana							= Trim(Request.Form("chkDiaSemana"))
	intDisciplina							= Trim(Request.Form("chkDisciplina"))
	intCurso								= Trim(Request.Form("chkCurso"))
			
	if acao="I" then
		
		strMensagem = "Disponibilidade Docente salvo com sucesso..."
		
		if intDiaSemana <> "" then   
			vetDiaSemana = split(intDiaSemana,",")			 
		end if
		
		sql = " SET NoCount ON"			
		sql = sql & " Insert Into SCA_DISPONIBILIDADEDOCENTE(Cod_Empresa, CodColaborador)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodProfessor & "); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodDisponibilidadeDocente = rs(0)
		rs.close
		
		' Grava o dia da semana com a faixa de horario
		for intContador = 0 to ubound(vetDiaSemana)
			
			intDiaSemana 		= trim(vetDiaSemana(intContador))
			intCodFaixaHorario 	= Trim(Request.Form("chkFaixaHorario_" & intDiaSemana))
			
			if intCodFaixaHorario <> "" then   
				vetFaixaHorario = split(intCodFaixaHorario,",")			 
			end if
		
			for intCont = 0 to ubound(vetFaixaHorario)
			
				intCodFaixaHorario = trim(vetFaixaHorario(intCont))
							
				sql = " Insert Into SCA_DISPONIBILIDADEDOCENTE_Horario(CodDisponibilidadeDocente , DiaSemana, CodFaixaHorario)"
				sql = sql & " Values ("
				sql = sql & "" & intCodDisponibilidadeDocente & ","
				sql = sql & "" & intDiaSemana & ","
				sql = sql & "" & intCodFaixaHorario & ")"
				cnn.execute sql
				GravarLog sql
			
			next
			
		next
		
		if intDisciplina <> "" then   
			vetDisciplina = split(intDisciplina,",")			 
		end if
		
		' Grava a Disciplina
		for intContador = 0 to ubound(vetDisciplina)
			
			intCodDisciplina = trim(vetDisciplina(intContador))
						
			sql = "Insert Into SCA_DISPONIBILIDADEDOCENTE_Disciplina(CodDisponibilidadeDocente, COD_Disciplina)"
			sql = sql & " Values ("
			sql = sql & "" & intCodDisponibilidadeDocente & ","
			sql = sql & "" & intCodDisciplina & ")"
			cnn.execute sql
			GravarLog sql
			
		next
		
		if intCurso <> "" then   
			vetCurso = split(intCurso,",")			 
		end if
		
		' Grava Curso
		for intContador = 0 to ubound(vetCurso)
			
			intCodCurso = trim(vetCurso(intContador))
						
			sql = "Insert Into SCA_DISPONIBILIDADEDOCENTE_Curso(CodDisponibilidadeDocente, CodCurso)"
			sql = sql & " Values ("
			sql = sql & "" & intCodDisponibilidadeDocente & ","
			sql = sql & "" & intCodCurso & ")"
			cnn.execute sql
			GravarLog sql
			
		next

	elseif acao="A" then
		
		sql = "Delete from SCA_DISPONIBILIDADEDOCENTE_Curso "
		sql = sql & " Where CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
		cnn.execute sql
		
		sql = "Delete from SCA_DISPONIBILIDADEDOCENTE_Disciplina "
		sql = sql & " Where CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
		cnn.execute sql
		
		sql = "Delete from SCA_DISPONIBILIDADEDOCENTE_Horario "
		sql = sql & " Where CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
		cnn.execute sql
		
		sql = "Delete from SCA_DISPONIBILIDADEDOCENTE "
		sql = sql & " Where Codigo = " & intCodDisponibilidadeDocente
		cnn.execute sql
	
		strMensagem = "Disponibilidade Docente Alterada com sucesso..."
		
		if intDiaSemana <> "" then   
			vetDiaSemana = split(intDiaSemana,",")			 
		end if
		
		sql = " SET NoCount ON"			
		sql = sql & " Insert Into SCA_DISPONIBILIDADEDOCENTE(Cod_Empresa, CodColaborador)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodProfessor & "); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodDisponibilidadeDocente = rs(0)
		rs.close
		
		' Grava o dia da semana com a faixa de horario
		for intContador = 0 to ubound(vetDiaSemana)
			
			intDiaSemana 		= trim(vetDiaSemana(intContador))
			intCodFaixaHorario 	= Trim(Request.Form("chkFaixaHorario_" & intDiaSemana))
			
			if intCodFaixaHorario <> "" then   
				vetFaixaHorario = split(intCodFaixaHorario,",")			 
			end if
		
			for intCont = 0 to ubound(vetFaixaHorario)
			
				intCodFaixaHorario = trim(vetFaixaHorario(intCont))
							
				sql = " Insert Into SCA_DISPONIBILIDADEDOCENTE_Horario(CodDisponibilidadeDocente , DiaSemana, CodFaixaHorario)"
				sql = sql & " Values ("
				sql = sql & "" & intCodDisponibilidadeDocente & ","
				sql = sql & "" & intDiaSemana & ","
				sql = sql & "" & intCodFaixaHorario & ")"
				cnn.execute sql
				GravarLog sql
			
			next
			
		next
		
		if intDisciplina <> "" then   
			vetDisciplina = split(intDisciplina,",")			 
		end if
		
		' Grava a Disciplina
		for intContador = 0 to ubound(vetDisciplina)
			
			intCodDisciplina = trim(vetDisciplina(intContador))
						
			sql = "Insert Into SCA_DISPONIBILIDADEDOCENTE_Disciplina(CodDisponibilidadeDocente, COD_Disciplina)"
			sql = sql & " Values ("
			sql = sql & "" & intCodDisponibilidadeDocente & ","
			sql = sql & "" & intCodDisciplina & ")"
			cnn.execute sql
			GravarLog sql
			
		next
		
		if intCurso <> "" then   
			vetCurso = split(intCurso,",")			 
		end if
		
		' Grava Curso
		for intContador = 0 to ubound(vetCurso)
			
			intCodCurso = trim(vetCurso(intContador))
						
			sql = "Insert Into SCA_DISPONIBILIDADEDOCENTE_Curso(CodDisponibilidadeDocente, CodCurso)"
			sql = sql & " Values ("
			sql = sql & "" & intCodDisponibilidadeDocente & ","
			sql = sql & "" & intCodCurso & ")"
			cnn.execute sql
			GravarLog sql
			
		next
			
	else
		
		strMensagem = "Disponibilidade Docente Excluido com sucesso..."
		
		sql = "Delete from SCA_DISPONIBILIDADEDOCENTE_Curso "
		sql = sql & " Where CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
		cnn.execute sql
		
		sql = "Delete from SCA_DISPONIBILIDADEDOCENTE_Disciplina "
		sql = sql & " Where CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
		cnn.execute sql
		
		sql = "Delete from SCA_DISPONIBILIDADEDOCENTE_Horario "
		sql = sql & " Where CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
		cnn.execute sql
		
		sql = "Delete from SCA_DISPONIBILIDADEDOCENTE "
		sql = sql & " Where Codigo = " & intCodDisponibilidadeDocente
		cnn.execute sql

	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='DisponibilidadeDocente_cad.asp';
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