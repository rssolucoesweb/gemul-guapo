<%	
if Session("CodColaboradorSubstituicao") <> "" then
	if strSubmitSubstituicao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	strDataAP = formataDataAP(date)
	marcouSubstituicao = ""
	
	if Session("CodGrupo") = "" then Session("CodGrupo") = 0
		
	sql = " Select distinct C.codigo, C.nome, C.codigo_SEG_USUARIOS_SISTEMA, C.codFuncional, CS.Status as Situacao"
	sql = sql & " From SRH_COLABORADOR C"
	sql = sql & " inner join SRH_MODULACAO_DISCIPLINAR_DOCENTE CS on C.codigo = CS.Cod_ColaboradorSubstituido "
	sql = sql & " Where C.codigo in ( " & trim(Session("CodColaboradorSubstituicao")) & ")"
	sql = sql & " AND CS.Status = 'A' and C.SITUACAO='A'"
	RS.OPEN SQL, CNN
	%>
    <label for="exampleInputPassword1"> Substitui&ccedil;&atilde;o</label>
	<select name="cmbSubstituicao" id="cmbSubstituicao" style="width:250pt"  class="form-control" <%=strFuncao%> >
		<option value="0">Selecione...</option>
		<%
		verificarSeFoiMarcado = "N"
		IF RS.EOF = FALSE THEN
			while not rs.eof
	
				if trim(intCodSubstituicao) = trim(rs("codigo")) then
					strSelecionado = " selected"
					marcouSubstituicao = "S"
					verificarSeFoiMarcado = "S"
				else
					strSelecionado = ""
				end if
				response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("codFuncional")) & " - " & ucase(rs("nome")) & "</option> "  & vbcrlf
				rs.movenext
			wend
		END IF
		rs.close
		
		if verificarSeFoiMarcado = "N" then Session("UsuarioWeb") = UsuarioWebLogou
		
	%>
</select>
<%
end if
%>