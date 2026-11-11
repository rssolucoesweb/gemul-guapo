<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro Diretrizes - Gerais
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
	strAno	 					= Trim(Request("txtAno"))
	intSemestre 				= Trim(Request("cmbSemestre"))
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	intCodFuncao 				= Trim(Request.Form("cmbFuncao"))
	intCodTurno 				= TRIM(Request.Form("cmbTurnoRH"))
	intCodTurnoTurma			= TRIM(Request.Form("cmbTurnoTurma"))
	intCodDisciplina			= Trim(Request.Form("cmbDisciplina"))
	intCodCurso 				= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
	strAulasOferecidas 			= Trim(Request.Form("txtAulasOferecidas"))
	strVagasOferecidas 			= Trim(Request.Form("txtVagasOferecidas"))
	strModularGrupo				= Trim(Request("ModularGrupo"))

	if intCodDisciplina 		= "" then intCodDisciplina = "0"
	if intCodCurso				= "" then intCodCurso = "0"
	if strAulasOferecidas 		= "" then strAulasOferecidas = "0"
	if strVagasOferecidas 		= "" then strVagasOferecidas = "0"

	if acao="I" then

		sql = "SELECT Codigo"
		sql = sql & " FROM SRH_DIRETRIZES"
		sql = sql & " where Cod_Empresa = " & intCodEmpresa			
		sql = sql & " and Ano_Letivo = " & strAno	
		sql = sql & " and Semestre = " & intSemestre	 
		sql = sql & " and CodFuncao = " & intCodFuncao			
		sql = sql & " and Cod_turno = " & intCodTurno
		if intCodCurso<>"" and intCodCurso<>"0" then
			sql = sql & " AND Cod_Curso = " & intCodCurso
		end if
		if intCodPeriodo <> "" and intCodPeriodo<>"0" then
			sql = sql & " AND Cod_Periodo = " & intCodPeriodo
		end if
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("Registro já cadastrado. Verifique!");
				window.location='DiretrizesGerais_cad.asp';
			</script>
			<%
			response.end
		end if 
		rs.close

		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_DIRETRIZES(Cod_Empresa, Ano_letivo, Semestre, CodFuncao, Cod_turno, cod_turno_turma, Cod_Disciplina, Cod_Curso, Cod_Periodo, AulasOferecidas, VagasOferecidas, usuario_incl, data_hora_incl)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & strAno & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & intCodFuncao & ","
		sql = sql & "" & intCodTurno & ","
		if intCodTurnoTurma <> "" and intCodTurnoTurma<>"0" then
			sql = sql & "" & intCodTurnoTurma & ","
		else
			sql = sql & "null,"
		end if
		if intCodDisciplina <> "" and intCodDisciplina<>"0" then
			sql = sql & "" & intCodDisciplina & ","
		else
			sql = sql & "null,"
		end if
		if intCodCurso <> "" and intCodCurso<>"0" then
			sql = sql & "" & intCodCurso & ","
		else
			sql = sql & "null,"
		end if
		if intCodPeriodo <> "" and intCodPeriodo<>"0" then
			sql = sql & "" & intCodPeriodo & ","
		else
			sql = sql & "null,"
		end if
		
		sql = sql & "" & strAulasOferecidas & ","
		sql = sql & "" & strVagasOferecidas & ",'" & session("usuarioWeb") & "',getdate())"
		cnn.execute sql
		GravarLog sql
	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_DIRETRIZES Set"
		sql = sql & " CodFuncao = " & intCodFuncao & ","
		sql = sql & " Cod_turno = " & intCodTurno & ","
		if intCodTurnoTurma <> "" and intCodTurnoTurma<>"0" then
			sql = sql & " Cod_turno_turma = " & intCodTurnoTurma & ","
		else
			sql = sql & " Cod_turno_turma = null,"
		end if
		if intCodDisciplina <> "" and intCodDisciplina<>"0" then
			sql = sql & " Cod_Disciplina = " & intCodDisciplina & ","
		else
			sql = sql & " Cod_Disciplina = null,"
		end if
		if intCodCurso <> "" and intCodCurso<>"0" then
			sql = sql & " Cod_Curso = " & intCodCurso & ","
		else
			sql = sql & " Cod_Curso = null,"
		end if
		if strVagasOferecidas<>"0" then
			sql = sql & " VagasOferecidas = " & strVagasOferecidas & ","
		end if
		if strAulasOferecidas<>"0" then
			sql = sql & " AulasOferecidas = " & strAulasOferecidas & ","
		end if
		if intCodPeriodo <> "" and intCodPeriodo<>"0" then
			sql = sql & "Cod_periodo = " & intCodPeriodo & ","
		else
			sql = sql & "Cod_periodo = null,"
		end if
		sql = sql & " usuario_altr = '" & session("usuarioWeb") & "', data_hora_altr = getdate()"
		sql = sql & " Where Codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	' Duplica o Ano anterior
	elseif acao="D" then
		
		strMensagem = "Registro Duplicado para Ano informado..."
		
		' Pega o Ano Anterior
	   if Session("strSemestre") = "1" then
	  	  strAnoLetivoAnt = Session("strAnoLetivo") - 1
	   elseif Session("strSemestre") = "2" then
		  strAnoLetivoAnt = Session("strAnoLetivo")
	   elseif Session("strSemestre") = "3" then
		  strAnoLetivoAnt = Session("strAnoLetivo") - 1
	   end if
		
		' Apaga o registro do novo ano 
		sql = " Delete From SRH_DIRETRIZES "
		sql = sql & " where Ano_letivo = " & strAno
		sql = sql & " and Cod_Empresa = " & Session("CodEmpresa")	
		cnn.execute sql
		GravarLog sql
		
		' Consulta dados do ano Anterior
		sql = " SELECT "
		sql = sql & " Codigo, "
		sql = sql & " Cod_Empresa, " 
		sql = sql & " Ano_Letivo, "  
		sql = sql & " Semestre, "    
		sql = sql & " CodFuncao, "   
		sql = sql & " Cod_Turno, "
		sql = sql & " Cod_Disciplina, " 
		sql = sql & " Cod_Curso, "   
		sql = sql & " Cod_Periodo, "   
		sql = sql & " AulasOferecidas, " 
		sql = sql & " VagasOferecidas, " 
		sql = sql & " cod_turma, "
		sql = sql & " Cod_Turno_turma "		
		sql = sql & " FROM SRH_DIRETRIZES "
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and Ano_letivo = " & strAnoLetivoAnt		
		rs.open sql, cnn
		if rs.eof = false then
			vetrs = rs.getRows
		end if
		rs.close

		if isArray(vetrs) then

			for j=0 to ubound(vetrs,2)
	
				cont = cont + 1	
	
				intCodEmpresa		= vetrs(1,j)
				'strAno				= vetrs(2,j)
				intSemestre			= vetrs(3,j)
				intCodFuncao		= vetrs(4,j)
				intCodTurno			= vetrs(5,j)
				intCodDisciplina	= vetrs(6,j)
				intCodCurso			= vetrs(7,j)
				intCodPeriodo		= vetrs(8,j)
				strAulasOferecidas 	= vetrs(9,j)
				strVagasOferecidas	= vetrs(10,j) 
				intCodTurnoTurma	= vetrs(12,j)
				if intCodDisciplina 		= "" then intCodDisciplina = "0"
				if intCodCurso				= "" then intCodCurso = "0"
				if strAulasOferecidas 		= "" then strAulasOferecidas = "0"
				if strVagasOferecidas 		= "" then strVagasOferecidas = "0"
						
				sql = "Insert Into SRH_DIRETRIZES(Cod_Empresa, Ano_letivo, Semestre, CodFuncao, Cod_turno, Cod_turno_turma, Cod_Disciplina, Cod_Curso, Cod_Periodo, AulasOferecidas, VagasOferecidas)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmpresa & ","
				sql = sql & "" & strAno & ","
				sql = sql & "" & intSemestre & ","
				sql = sql & "" & intCodFuncao & ","
				sql = sql & "" & intCodTurno & ","
				sql = sql & "" & intCodTurnoTurma & ","
				sql = sql & "" & intCodDisciplina & ","
				sql = sql & "" & intCodCurso & ","
				if isnull(intCodPeriodo) then
					sql = sql & "null,"
				else
					sql = sql & "" & intCodPeriodo & ","
				end if
				sql = sql & "" & strAulasOferecidas & ","
				sql = sql & "" & strVagasOferecidas & ")"

				cnn.execute sql
				GravarLog sql
				
			next
		else
		   'cnn.rollbackTrans
		   %>
			<script>
				alert("ATENÇÃO! Não existe registro ano/semestre anterior. Verifique!");
				window.location='DiretrizesGerais_cad.asp';
			</script>
			<%
            response.end
		end if


	else
		sql = "SELECT Codigo "
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		sql = sql & " where Ano_Letivo = " & strAno	
		sql = sql & " and Cod_Funcao = " & intCodFuncao	
		sql = sql & " and Cod_empresa = " & intCodEmpresa	
		if intCodCurso<>"" and intCodCurso<>"0" then
			sql = sql & " and Cod_Curso = " & intCodCurso
		end if
		if intCodPeriodo<>"" and intCodPeriodo<>"0" then
			sql = sql & " and Cod_periodo = " & intCodPeriodo
		end if
		if intCodTurno<>"" and intCodTurno<>"0" then
			sql = sql & " and Cod_Turno = " & intCodTurno
		end if
		if intCodDisciplina<>"" and intCodDisciplina<>"0" then
			sql = sql & " and Cod_Disciplina = " & intCodDisciplina
		end if
		sql = sql & " and status = 'A'"
		
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("Diretriz com modulação registrada, não poderá ser excluída!");
				window.history.back();
			</script>
			<%
			response.end
		end if 
		rs.close
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From SRH_DIRETRIZES "
		sql = sql & " Where Codigo = " & intCodigo
		
		cnn.execute sql
		GravarLog sql
	end if

	

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='DiretrizesGerais_cad.asp';
		</script>
		<%
		response.end
	else
		'cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>