<%	

	if strExecutarSubmitAutorizacao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "select a.codigo, c.descricao + ' - ' + a.descricao as descricao"
	sql = sql & " from [dbo].[SCA_ATOS_LEGALIZACAO] a"
	sql = sql & " inner join SCA_CURSO c on c.cod_curso = a.cod_curso"
	sql = sql & " where a.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and a.cod_atos = 1" 'autorização
	sql = sql & " order by 1"
	RS.OPEN SQL, CNN
%>
<select name="cmbAutorizacao" id="cmbAutorizacao" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAutorizacao) = trim(rs("CODIGO")) then
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