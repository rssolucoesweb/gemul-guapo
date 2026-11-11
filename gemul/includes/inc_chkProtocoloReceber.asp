
<%
	if strProtocolo_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	    
	SQL = " select p.codigo, p.numero, a.descricao as assunto FROM pro_protocolo p left join PRO_Assunto a on a.codigo = p.cod_assunto and a.cod_empresa = p.cod_empresa" 
	SQL = SQL & " where p.cod_Empresa = " & Session("CodEmpresa") & " and p.tipoAndamento='E' and p.cod_departamentoAtual = " & session("codDepartamentoAtual")
	SQL = SQL & " ORDER BY p.ano, p.codigo"
	rs.open SQL, cnn
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodProtocolo) = trim(rs("CODIGO")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
			%>
				<input name="chkProtocolo" id="chkProtocolo" type="checkbox" value="<%=rs("CODIGO")%>" /><%=rs("numero") & " - " & rs("assunto")%><br>
			<%
            rs.movenext
        wend
    END IF
    rs.close
%>
