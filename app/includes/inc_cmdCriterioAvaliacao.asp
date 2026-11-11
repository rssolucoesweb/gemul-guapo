<%	
	if strExecutarSubmitTipoCriterio = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "select c.codigo,  cc.cod_curso, cc.Descricao + ' (' + tc.descricao + ')' as curso, c.cod_tipo_calculo, tc.cod_criterio"
	sql = sql & " from SCA_CRITERIO_AVALIACAO c"
	sql = sql & " inner join SCA_CURSO cc on cc.Cod_curso = c.cod_curso"
	sql = sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = c.cod_tipo_calculo"
	sql = sql & " where c.ano_letivo = " & strAnoLetivo
	RS.OPEN SQL, CNN
%>
<select name="cmbCriterioAvaliacao" id="cmbCriterioAvaliacao" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCriterioAvaliacao) = trim(rs("codigo")) then
				strSelecionado = " selected"
				intCodCriterio = rs("cod_criterio")
				intCodTipoCalculo = rs("cod_tipo_calculo")
				intCodCurso = rs("cod_curso")
				strCurso = rs("curso")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" &  rs("curso") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>