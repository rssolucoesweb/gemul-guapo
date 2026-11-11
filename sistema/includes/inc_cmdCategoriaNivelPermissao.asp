<%	
	sql = "SELECT Cod_Categoria, Desc_Categoria"
	sql = sql & " FROM SRH_CATEGORIA where status='A'"
	sql = sql & " Order by Desc_Categoria"
	RS.OPEN SQL, CNN
%>
<select name="cmbCategoria" id="cmbCategoria" style="width:100pt" class="form-control" onchange="mostraLogin(), LimpaMarcacoes()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCategoria) = trim(rs("Cod_Categoria")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Categoria")& " " & strSelecionado &">" & rs("Desc_Categoria") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>