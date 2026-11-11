<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Perido 
-->
<%	
	if strExecutarSubmitPeriodo = "" then
		if strSubmitPeriodoMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaPeriodo(this.value)'"
		end if
	else
		strFuncao = "onchange='submit()'"
	end if

	if trim(intCodCurso) = "" then intCodCurso = "0"

	sql = " select DISTINCT P.Cod_Periodo, P.Cod_Curso, P.Descricao, P.Sequencia from SCA_CONTEUDO CON "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = CON.COD_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
	sql = sql & " WHERE 1=1"
	if strAnoLetivo <> "" then
		sql = sql & " AND CON.AnoLetivo = " & strAnoLetivo
	end if
	sql = sql & " AND CON.Semestre = " & intSemestre
	sql = sql & " AND CON.Cod_Colaborador = " & intCodProfessor
	sql = sql & " AND C.Cod_Curso = " & trim(intCodCurso)
	sql = sql & " and CON.Fechamento = 'S' "
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" style="width:230pt" class="form-control"  <%=strDisabilitaCombo%> <%=strFuncao%> <%=strPeriodo_Disabled%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPeriodo) = trim(rs("Cod_Periodo")) then
				strSelecionado = " selected"
				strSerie = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Periodo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>