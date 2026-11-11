<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Disciplina 
-->
<%	

	if strExecutarSubmitGradeCurricularGrupos = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if


	sql = "select distinct c.cod_curso, c.Descricao "
	sql = sql & " from sca_gradecurricular g "
	sql = sql & " inner join sca_periodo p on p.cod_periodo = g.cod_periodo "
	sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso "
	sql = sql & " WHERE 1=1"'g.cod_empresa = " & Session("CodEmpresa")
	if intCodCurso <> "" and intCodCurso <> "0" then
		sql = sql & "and c.cod_curso = " & intCodCurso
	end if	
	RS.OPEN SQL, CNN
%>
<select name="cmbGradeagrupamento" id="cmbGradeagrupamento" style="width:80pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCurso) = trim(rs("cod_curso")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_curso")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>