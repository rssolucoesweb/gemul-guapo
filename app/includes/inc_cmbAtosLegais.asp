<%	
	if strExecutarSubmitAtosLegais = "" then
		strExecutarSubmitAtosLegais = ""
	else
		strExecutarSubmitAtosLegais = "onchange='submit()'"
	end if

	sql = "select a.codigo, aa.descricao + ' - ' + c.Descricao + ' - ' + a.descricao as descricao " 
	sql = sql & " from SCA_ATOS_LEGALIZACAO a"
	sql = sql & " inner join sca_curso c on c.cod_curso = a.cod_curso"
	sql = sql & " inner join SCA_ATOS aa on aa.codigo = a.cod_atos"
	sql = sql & " and a.cod_empresa = " & session("CodEmpresa")
	sql = sql & " order by descricao"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbAtosLegais" id="cmbAtosLegais" class="form-control" <%=strExecutarSubmitAtosLegais%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAtosLegais) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>