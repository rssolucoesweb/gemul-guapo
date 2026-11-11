<%	
	if strExecutarSubmitProfessorGeral = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = " SELECT SRH_COLABORADOR.codigo, SRH_COLABORADOR.nome, SEG_EMPRESA.RazaoSocial, SRH_COLABORADOR.CodFuncional"
	sql = sql & " FROM SRH_COLABORADOR "
	sql = sql & " inner join SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SRH_COLABORADOR.CodLotacao" 
	sql = sql & " WHERE SEG_EMPRESA.Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " AND SRH_COLABORADOR.Situacao = 'A'" 
	sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8) "'professor
	sql = sql & " Order by SRH_COLABORADOR.Nome"
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessorGeral" id="cmbProfessorGeral" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessorGeral) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & " - " & ucase(rs("CodFuncional")) &  "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>