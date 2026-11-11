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

	if trim(intCodCurso) = "" then intCodCurso = "0"
	if isnull(intCodCurso) then intCodCurso = "0"
	
	sql = "SELECT distinct p.Descricao, p.sequencia"
	sql = sql & " FROM SCA_PERIODO p"
	sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
	sql = sql & " where c.descricao = '" & strCurso & "'" 
	sql = sql & " Order by p.sequencia, p.Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" style="width:250pt" class="combo"  <%=strDisabilitaCombo%> <%=strFuncao%> <%=strPeriodo_Disabled%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if replace(trim(strPeriodo)," ","_") = replace(trim(rs("descricao"))," ","_") then
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
</select>