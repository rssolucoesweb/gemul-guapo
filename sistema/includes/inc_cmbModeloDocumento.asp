<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Grau 
-->
<%
	sql = "SELECT codigo, titulo"
	sql = sql & " FROM SCA_DOCUMENTO"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	if session("NivelPermissao")<> "A" THEN
	   SQL = SQL & " AND (cod_departamento=" & Session("CodDeptoUsuario") & " or cod_departamento is null)"
	end if
	sql = sql & " Order by titulo"
	RS.OPEN SQL, CNN
%>
<select name="cmbModeloDocumento" id="cmbModeloDocumento" style="width:200pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodModeloDocumento) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("titulo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>