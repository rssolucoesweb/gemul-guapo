<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina da grade
-->
<%	
	if intCodPeriodo = "" then intCodPeriodo = 0
	if isnull(intCodPeriodo) then intCodPeriodo = 0
	sql = "EXEC SP_MostraDisponibilidadeDisciplina " & intCodEmpresaGrupo & "," & strAnoLetivo & "," & intSemestre & ",'" & strTipoModulacao & "','" &strTipoLancamento& "'," &intCodTurnoColaborador&"," &intCodCursoCombo&"," &intCodFuncao&"," &intCodPeriodo
'response.Write(sql)
	RS.OPEN SQL, CNN
	%>
	<select name="cmbDisciplina" id="cmbDisciplina" style="width:150pt" class="combo" onchange="submit()">
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplina) = trim(rs("COD_Disciplina")) then
				strSelecionado = " selected"
				funcao = rs("aulasLiberadasDiretriz")
				modulacao = rs("aulasModuladas")
				saldo = rs("saldo")
				if saldo <= 0 then 
					strDesbilitaAulas = "disabled"
					saldo = 0
				end if
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & rs("Disciplina") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>