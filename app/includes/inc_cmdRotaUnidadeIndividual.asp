<%	

	if strExecutarSubmitRotaTransporteescolar = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = " SELECT distinct r.Cod_Rota, R.Descricao "
	sql = sql & " FROM ste_rota r "
	sql = sql & " left join STE_ROTA_VINCULA_SETORES vs on vs.cod_rota = r.Cod_Rota"
	sql = sql & " left JOIN STE_ROTA_VINCULA_UNIDADE_SETORES RV ON rv.Cod_setores = vs.Cod_setores"
	sql = sql & " Where (RV.Cod_empresa = " & intCodEmpresa & " or RV.Cod_empresa is null)"
	sql = sql & " Order by R.Descricao"	
	RS.OPEN SQL, CNN
	intQtdRotasUnidade = 0
%>
<select name="cmbRota" id="cmbRota" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			intQtdRotasUnidade = intQtdRotasUnidade + 1
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
<%if intCodEmpresa <> "0" and intCodEmpresa <> "" and intQtdRotasUnidade = 0 then%>
<small class="form-text text-danger">Nenhuma rota vinculada a esta unidade. Vincule a escola ao setor de uma rota no cadastro de rotas.</small>
<%end if%>