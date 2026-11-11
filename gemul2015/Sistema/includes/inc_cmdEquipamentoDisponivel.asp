<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de EQUIPAMENTO 
-->
<%	
	if strExecutarSubmitEquipamento = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT cod_equipamento, Desc_equipamento"
	sql = sql & " FROM SCA_EQUIPAMENTO"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " and 	situacao='A'"'ativos
	'somente equipamento disponivel
	if strDataReserva <> "" then
		SQL = SQL & " and cod_equipamento not in ("
		SQL = SQL & " 					select	COD_EQUIPAMENTO from SCA_EQUIPAMENTO_RESERVA"
		SQL = SQL & " 					where	cod_empresa = " & Session("CodEmpresa")
		SQL = SQL & " 					and		data_utilizacao = '" & formatadataBD(strDataReserva) & "'"
		SQL = SQL & " 					and		cod_sequencia_aulas = " & intCodSequenciaAulas
		sql = sql & " ) "
	end if
	sql = sql & " Order by Desc_equipamento"
	RS.OPEN SQL, CNN
%>
<select name="cmbEquipamento" id="cmbEquipamento" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodEquipamento) = trim(rs("cod_equipamento")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_equipamento")& " " & strSelecionado &">" & rs("Desc_equipamento") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>