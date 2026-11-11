
<%
	if strProtocolo_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	    
	SQL = " select p.codigo, p.numero, a.descricao as assunto FROM pro_protocolo p left join PRO_Assunto a on a.codigo = p.cod_assunto and a.cod_empresa = p.cod_empresa" 
	SQL = SQL & " where p.cod_Empresa = " & Session("CodEmpresa") 
	SQL = SQL & " and p.cod_Situacao = 1" 'aberto
	SQL = SQL & " ORDER BY p.ano, p.codigo"
	rs.open SQL, cnn
%>
	<select name="cmbProtocolo" id="cmbProtocolo" style="width:250pt" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodProtocolo) = trim(rs("CODIGO")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("numero") & " - " & rs("assunto") & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>