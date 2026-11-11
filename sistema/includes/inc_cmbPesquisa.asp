<%	
	if strExecutarSubmitPesquisa = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT p.CODIGO, p.NOME, c.nome as cidade, e.nome as estado"
	sql = sql & " FROM PES_PESQUISA p "
	sql = sql & " left join PES_cidade c on c.Codigo = p.cod_cidade"
	sql = sql & " left join PES_estado e on e.Codigo = c.cod_estado"
	if strPerfil = "77" then
		sql = sql & " where p.codigo in (select cp.cod_pesquisa from PES_contratante_pesquisa cp inner join PES_contratante c on c.codigo = cp.cod_contratante where c.email = '" & session("usuarioWeb") & "')"
	end if
	'sql = sql & " WHERE SITUACAO='A'"
	sql = sql & " Order by p.NOME"
	RS.OPEN SQL, CNN
%>
<select name="cmbPesquisa" id="cmbPesquisa" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_pesquisa) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("nome") & " | " & rs("cidade") & "-" & rs("estado") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>