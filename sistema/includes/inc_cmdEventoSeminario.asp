<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Grau 
-->
<%
	sql = "SELECT codigo, evento"
	sql = sql & " FROM SCA_SEMINARIO_EVENTO"
	sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
    sql = sql & " AND COD_CURSO = " & intCodCurso
	sql = sql & " AND Situacao = 'A'"
	if intAnoletivo <> "" then
	   sql = sql & " AND Ano_Letivo = " & intAnoLetivo
	end if
	if intSemestre <> "0" and intSemestre <> "" then
	   sql = sql & " AND Semestre = " & intSemestre
	end if	   
    sql = sql & " Order by evento"
	RS.OPEN sql, CNN
%>
<select name="cmbEventoSeminario" id="cmbEventoSeminario" style="width:550pt" class="combo" onchange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodEventoSeminario) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("evento") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>