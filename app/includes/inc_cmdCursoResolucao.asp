<%	
	sql = "SELECT Codigo, habilitacao, reconhecimento, autorizacao, "
	sql = sql & " dataReconhecimento, DataAutorizacao, CH_Exigida "
	sql = sql & " FROM SCA_CURSO_RESOLUCAO"
	sql = sql & " WHERE Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " and  Cod_curso = " & intCodCurso
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbCursoResolucao" id="cmbCursoResolucao" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCursoResolucao) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("habilitacao") & "  -  " &  rs("reconhecimento") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>