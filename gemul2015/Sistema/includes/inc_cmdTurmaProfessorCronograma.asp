<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2009
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Turma Professor
-->
<%	
	if Session("CodColaboradorContrato") <> "" and Session("CodColaboradorContrato") <> "0" then  intCodColaboradorProfessor =  Session("CodColaboradorContrato")

	if intSemestre = "" then intSemestre 			= session("strSemestre")
	if strAnoLetivo = "" then strAnoLetivo 			= session("strAnoLetivo")

	if strExecutarSubmitTurma = "" then
		strFuncao = ""
		if strSubmitTurmaMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaTurmaProfessor(this.value)'"
		end if

	else
		strFuncao = "onchange='submit()'"
	end if
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodGrade = "" then intCodGrade = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intSemestre = "" then intSemestre = "0"
	if intCodTurno = "" then intCodTurno = "0"
	
	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaTurmaProfessor	= "Professor"
	else
		strVerificaTurmaProfessor = ""
		if  Trim(Request.Form("optOpcao")) = "0" then ' Valor vem do radio button conteudo conteudoprofessor_cad.asp, dá o controle para checar o horário ou não.
			strVerificaTurmaProfessor	= "Professor"
		end if	
	end if
	rs.close

	strCpfTurmaProfessor = ""
    sql = " Select ISNULL(CPF,'') AS CPF, CodCategoria "
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where codigo = " & intCodColaboradorProfessor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs1.open sql, cnn
	if rs1.eof = false then
		strCpfTurmaProfessor = TRIM(rs1("CPF"))
		''if TRIM(rs1("CodCategoria")) = "1" and (Trim(Request.Form("optOpcao")) = "0" or Trim(Request.Form("optOpcao")) = "0") then
		''	strVerificaTurmaProfessor	= "Professor"
		''end if	
	end if
	rs1.close
	sql = "SELECT distinct SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma , SCA_TURMA.Cod_empresa, SCA_PERIODO.tipo, SCA_TURMA.SITUACAO, SCA_TURMA.TurmaAluno, SCA_PERIODO.Descricao, SCA_PERIODO.Sequencia  "
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
    if 	strVerificaTurmaProfessor	= "Professor" then
		sql = sql & " left JOIN SCA_HORARIO_AULA ON SCA_HORARIO_AULA.cod_turma = SCA_TURMA.cod_turma "
		sql = sql & " and SCA_HORARIO_AULA.semestre = SCA_TURMA.cod_Semestre and SCA_HORARIO_AULA.anoLetivo = SCA_TURMA.AnoLetivo"
		sql = sql & " inner JOIN SRH_COLABORADOR on SRH_COLABORADOR.codigo = SCA_HORARIO_AULA.cod_colaborador"
	end if	
	sql = sql & " where 1=1 "
    if 	strVerificaTurmaProfessor = "Professor" then
		sql = sql & " and SCA_HORARIO_AULA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
	end if	
	sql = sql & " AND ( SCA_TURMA.Situacao = 'A' or  SCA_TURMA.Situacao = 'S') " ' Turmas ativas e nao fechadas
	sql = sql & " and SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
	sql = sql & " and SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
	if 	intCodCurso <> "0" and intCodCurso <> "" then
		sql = sql & " AND SCA_PERIODO.Cod_Curso = " & intCodCurso
	end if
	if 	intCodPeriodo <> "0" and intCodPeriodo <> "" then
		sql = sql & " AND SCA_PERIODO.Cod_Periodo = " & intCodPeriodo
	end if
	if 	strVerificaTurmaProfessor = "Professor" then
		' faz filtro do acompanhamento - Variavel será alimentada somente pela include inc_cmdVerificaAcompanhamento.asp.
		if strAcompanhamento <> "0" and strAcompanhamento <> "" then 
			sql = sql & " and SCA_HORARIO_AULA.Tipo_Disciplina = '" & strAcompanhamento & "'"
		end if	
		'
	end if	
	sql = sql & " order by SCA_PERIODO.Sequencia"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurmaProfessor" id="cmbTurmaProfessor" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurmaProfessor) = trim(rs("cod_turma")) then
				strSelecionado = " selected"
				intCodComp 	= rs("cod_curso")
				intCodSerie = rs("cod_periodo")
				intCodTurno = rs("cod_turno")
				intCodSemestre = rs("cod_Semestre")
				strTipoPeriodo = rs("tipo")
				strSituacaoTurmaCad = rs("Situacao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">" & "(  " & rs("NomeTurma") & "  ) - " & rs("Descricao") & " " & trim(rs("TurmaAluno")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
	
%>
</select>