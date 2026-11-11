<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Perido 
-->
<%	
	if strExecutarSubmitPeriodo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT distinct p.Descricao, p.sequencia"
	sql = sql & " FROM SCA_PERIODO p"
	sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
	sql = sql & " where P.MATRICULA = 'S' AND c.descricao = '" & replace(trim(strCursoAluno),"_"," ") & "'" 
	sql = sql & " AND P.DESCRICAO IN ('AGRUPAMENTO I','AGRUPAMENTO II','AGRUPAMENTO III','AGRUPAMENTO IV','AGRUPAMENTO V','1º ANO','2º ANO','3º ANO','4º ANO','5º ANO','6º ANO','7º ANO','8º ANO','9º ANO')"
	sql = sql & " Order by p.sequencia, p.Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" style="width:250pt" class="combo"  <%=strDisabilitaCombo%> <%=strFuncao%> <%=strPeriodo_Disabled%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if replace(trim(strPeriodoAluno)," ","_") = replace(trim(rs("descricao"))," ","_") then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & replace(rs("descricao")," ","_") & " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select> <span class="texto1"><strong><i>per&iacute;odo que o aluno ir&aacute; cursar</i></strong></span>