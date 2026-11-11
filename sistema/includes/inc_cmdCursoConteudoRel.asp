<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso 
-->
<%	
	if strExecutarSubmitCurso = "" then
		if strSubmitCursoMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaCurso(this.value)'"
		end if
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = " select DISTINCT C.Cod_curso, C.Descricao, C.Desc_Abreviada, C.Sigla, C.Cod_Grau, isnull(C.Tipo_Modulacao,'') as Tipo_Modulacao from SCA_CONTEUDO CON "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = CON.COD_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
	sql = sql & " WHERE CON.Cod_Empresa = " & Session("CodEmpresa")
	if strAnoLetivo <> "" then
		sql = sql & " AND CON.AnoLetivo = " & strAnoLetivo
	end if
	sql = sql & " AND CON.Semestre = " & intSemestre
	sql = sql & " AND CON.Cod_Colaborador = " & intCodProfessor
	sql = sql & " and CON.Fechamento = 'S' "
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbCurso" id="cmbCurso" style="width:230pt" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCurso) = trim(rs("Cod_curso")) then
				strSelecionado = " selected"
				strCurso = rs("Descricao")
				strTipoModulacao = rs("Tipo_Modulacao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_curso")& " " & strSelecionado &">" & rs("Sigla") & "-" &  rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>