<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Grau 
-->
<%
	sql = "SELECT codigo, descricao"
	sql = sql & " FROM SCA_MODELO_ETIQUETA"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbModeloEtiqueta" id="cmbModeloEtiqueta" style="width:200pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodModeloEtiqueta) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>