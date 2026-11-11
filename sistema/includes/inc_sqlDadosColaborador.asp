
<!--
	::	Data de Criação...: 21/02/2008
	::	Desenvolvedores...: SERGIO BORGES - sergiob76@hotmail.com
	::	Objetivo Pagina...: Selecionar os dados escolares do aluno
-->
<%
if intCodColaborador <> "" then
	'--DADOS DO COLABORADOR
	
	SQL="SELECT CODIGO, NOME, SITUACAO "
	SQL=SQL & " FROM SRH_COLABORADOR "
	SQL=SQL & " WHERE CODIGO = " & intCodColaborador
	
	rsAux.OPEN SQL, CNN
	IF rsAux.EOF = FALSE THEN 
	    strCodigo                  = rsAux("CODIGO")
		strNomeCompletoColaborador = rsAux("NOME")
		 if trim(rsAux("SITUACAO")) = "A" then
		    strSituacao                = "ATIVO"
		 else	
 		    strSituacao                = "INATIVO"
		 end if	

	    %>
	    <table width="100%" border="0" cellspacing="2" cellpadding="2" bgcolor="#F3F3F3">
	    <tr>
		<td colspan="4" class="texto1"><strong>Dados do Colaborador </strong></td>
	    </tr>
	    <tr>
		<td width="11%" class="texto1">Colaborador:</td>
		<td width="48%" class="texto2"><strong><%=rsAux("CODIGO")%> - <%=rsAux("NOME")%>&nbsp;</strong></td>
		<td width="10%" class="texto1">Situa&ccedil;&atilde;o:</td>
		<td width="31%" class="texto2"><strong><%=strSituacao%>&nbsp;</strong></td>
	    </tr>
        </table>
	    <%
	END IF
	rsAux.close
end if
%>