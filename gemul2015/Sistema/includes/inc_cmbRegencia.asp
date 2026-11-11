<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/06/2011
	::	Desenvolvedores...: Roberto Barbosa Silva
	::	Objetivo Pagina...: Consulta Regencia
-->
<%
	sql = "SELECT Codigo, Cod_Empresa, Cod_Grupo, Cod_Curso, Periodo, Regencia, Descricao"
	sql = sql & " FROM SRH_REGENCIACOLABORADOR"
	sql = sql & " where Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " Order by codigo"		
	rs.open sql, cnn
%>
<select name="cmbRegencia" id="cmbRegencia" style="width:130pt" class="combo">
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRegencia) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & formatnumber(rs("Regencia"),2) & " - " & trim(rs("Descricao")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>