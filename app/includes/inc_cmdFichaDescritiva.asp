<!--#include file="inc_CompartilharDadosCadastrais.asp"-->
<%

	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodPeriodo = "" then intCodPeriodo = 0
	sql = "SELECT Codigo, Descricao, Ano_Letivo, Semestre"
	sql = sql & " FROM SCA_FICHA_DESCRITIVA"
	sql = sql & " where publicar = 'S'"
	if strMostraTodas <> "S" then
		sql = sql & " and situacao = 'A' "
	end if
	if intCodPeriodo<>"0" then
		sql = sql & " and cod_periodo = " & intCodPeriodo
	END IF
'	if strAnoLetivo<>"" then
'		sql = sql & " and Ano_Letivo = " & strAnoLetivo
'	end if
	sql = sql & " and Utilizacao = 'AC'" 'Somente aparecerá no acadêmico
	sql = sql & " Order by Ano_Letivo DESC, Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbFichaDescritiva" id="cmbFichaDescritiva" class="form-control"  <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFichaDescritiva) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Ano_Letivo") & " - " & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>