<%	

	if strExecutarSubmitRotaTransporteescolar = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodEmpresa<>"" then intCodEmpresaGrupo = intCodEmpresa
	if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = Session("CodEmpresa")

	sql = " SELECT distinct r.Cod_Rota, R.Descricao "
	sql = sql & " FROM STE_ROTA_VINCULA_UNIDADE_SETORES RV "
	sql = sql & " inner join STE_ROTA_VINCULA_SETORES vs on vs.Cod_setores = rv.Cod_setores"
	sql = sql & " INNER JOIN ste_rota R ON r.Cod_Rota = vs.Cod_rota"
	sql = sql & " Where RV.Cod_empresa = " & intCodEmpresaGrupo
	sql = sql & " Order by R.Descricao"	
	'response.write sql
	RS.OPEN SQL, CNN
%>
<select name="cmbRota" id="cmbRota" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRota) = trim(rs("Cod_Rota")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Rota")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>