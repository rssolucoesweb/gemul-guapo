<%	

	if strExecutarSubmitAutorizacaoRenovacao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "select r.codigo, c.descricao + ' - ' + r.descricao as descricao"
	sql = sql & " from [dbo].[SCA_ATOS_LEGALIZACAO] a"
	sql = sql & " inner join [dbo].[SCA_ATOS_LEGALIZACAO_RENOVACAO] r on r.cod_atos_legalizacao = a.codigo"
	sql = sql & " inner join SCA_CURSO c on c.cod_curso = a.cod_curso"
	sql = sql & " where r.cod_atos_legalizacao = " & intCodAutorizacao
	sql = sql & " and a.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and a.cod_atos = 1"
	sql = sql & " order by 1"
	RS.OPEN SQL, CNN
%>
<select name="cmbAutorizacaoRenovacao" id="cmbAutorizacaoRenovacao" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAutorizacaoRenovacao) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado &">" & ucase(rs("descricao")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>