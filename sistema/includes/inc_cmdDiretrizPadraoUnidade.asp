<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso 
-->
<%	
	if strExecutarDiretrizPadraoUnidade = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = " select DP.codigo, DP.curso, DP.Turno, DP.cod_disciplina, "
	sql = sql & " DP.cod_funcao, FC.Desc_Funcao, UPPER(D.Desc_Abreviada) as Desc_Abreviada " 
	sql = sql & " from SRH_DIRETRIZES_PADRAO DP "
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = DP.Cod_funcao "
	sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = DP.Cod_Disciplina "
	sql = sql & " WHERE DP.TIPO_MODULACAO='P' "
	sql = sql & " ORDER BY DP.curso, DP.Turno, D.Desc_Abreviada "
	RS.OPEN SQL, CNN
%>
<select name="cmbDiretrizPadraoUnidade" id="cmbDiretrizPadraoUnidade" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intDiretrizPadraoUnidade) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("Curso") & " - " &  rs("Turno") & " " &  rs("Desc_Funcao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>