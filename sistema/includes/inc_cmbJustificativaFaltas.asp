<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 15/04/2013
	::	Desenvolvedores...: Sérgio Borges
	::	Objetivo Pagina...: Consulta faltas
-->
<%
	sql = "SELECT Codigo, Descricao, isnull(totalDias,0) as totalDias "
	sql = sql & " FROM SRH_JUSTIFICATIVAFALTAS"
	SQL = SQL & " WHERE situacao = 'A' and cod_grupo=" & Session("Codgrupo")
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbJustificativaFaltas" id="cmbJustificativaFaltas" style="width:300pt" class="form-control" onchange="submit()">
<option  value="0">Selecione...</option>
<%
	intQtdeFaltas = 0
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodJustificativaFaltas) = trim(rs("codigo")) then
				strSelecionado = " selected"
				intQtdeFaltas = rs("totalDias")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>