<%	
if Session("CodColaboradorSubstituicao") <> "" then
	strFuncao = "onchange='submit()'"
	
	strDataAP = formataDataAP(date)
	
	if Session("CodGrupo") = "" then Session("CodGrupo") = 0
		
	sql = " Select distinct C.codigo, C.nome, C.codigo_SEG_USUARIOS_SISTEMA, C.codFuncional, CS.Status as Situacao , t.Desc_Turno"
	sql = sql & " From SRH_COLABORADOR C"
	sql = sql & " inner join SRH_MODULACAO_DISCIPLINAR_DOCENTE CS on C.codigo = CS.Cod_ColaboradorSubstituido "
	sql = sql & " inner join SRH_TURNO t on t.Cod_Turno = cs.Cod_Turno"
	sql = sql & " Where C.codigo in ( " & trim(Session("CodColaboradorSubstituicao")) & ")"
	sql = sql & " AND CS.Status = 'A' and C.SITUACAO='A'"
	'response.write sql
	RS.OPEN SQL, CNN
	%>
    <label for="exampleInputPassword1"> Substituir o acesso atual pela Substituição</label>
	<select name="cmbSubstituicaoAcesso" id="cmbSubstituicaoAcesso" style="width:100%"  class="form-control" <%=strFuncao%> >
		<option value="0">Selecione...</option>
		<%
		IF RS.EOF = FALSE THEN
			while not rs.eof
	
				if trim(intCodSubstituicao) = trim(rs("codigo")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
				response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("codFuncional")) & " - " & ucase(rs("nome")) & " | " & RS("Desc_Turno") & "</option> "  & vbcrlf
				rs.movenext
			wend
		END IF
		rs.close
	%>
</select>
<%
end if
%>