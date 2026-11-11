
<!--
	::	Data de Criação...: 21/02/2008
	::	Desenvolvedores...: SERGIO BORGES - sergiob76@hotmail.com
	::	Objetivo Pagina...: Selecionar os dados escolares do aluno
-->
<%
if intCodAluno <> "" then
	'--DADOS ESCOLARES DO ALUNO
	
	SQL="SELECT TOP 1"
	SQL=SQL & " 	A.MATRICULA,"	
	SQL=SQL & " 	A.NOMEALUNO,"
	SQL=SQL & " 	T.NOMETURMA,"
	SQL=SQL & " 	C.DESCRICAO AS CURSO,"
	SQL=SQL & " 	C.SIGLA,"
	SQL=SQL & " 	P.DESCRICAO AS PERIODO, A.LOGRADOURO, A.NUMERO_ENDERECO,"
	SQL=SQL & " 	A.COMP_ENDERECO, A.BAIRROALUNO, A.CIDADERESIDENCIA, A.UFRESIDENCIA, A.CEPRESIDENCIA"
	SQL=SQL & " FROM SCA_ALUNO A"
	SQL=SQL & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
	SQL=SQL & " LEFT JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO "
	SQL=SQL & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
	SQL=SQL & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR "
	SQL=SQL & " LEFT JOIN SCA_PERIODO P ON GC.COD_PERIODO = P.COD_PERIODO "
	SQL=SQL & " LEFT JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO"
	SQL=SQL & " LEFT JOIN SCA_GRAU G ON G.COD_GRAU = C.COD_GRAU "
	SQL=SQL & " WHERE A.CODIGO=" & intCodAluno
	SQL=SQL & " Order BY AT.CODIGO DESC"
	rsAux.OPEN SQL, CNN
	IF rsAux.EOF = FALSE THEN 
	    strMatricula = rsAux("MATRICULA")
		strNomeCompletoAluno = rsAux("nomealuno")
	    %>
	      <table width="100%" border="0" cellspacing="2" cellpadding="2" bgcolor="#F3F3F3">
	    
	    <tr>
		<td class="texto1">Aluno:</td>
		<td colspan="3" class="texto2"><strong><%=rsAux("MATRICULA")%> - <%=rsAux("nomealuno")%>&nbsp;</strong><strong>&nbsp;</strong></td>
		</tr>
	  
	  <tr>
		<td width="11%" class="texto1">Turma:</td>
		<td width="30%" class="texto2"><strong><%=rsAux("nometurma")%>&nbsp;</strong></td>
		<td width="6%" class="texto1">Curso:</td>
		<td width="53%" class="texto2">&nbsp;</td>
	  </tr>
	  <tr>
		<td class="texto1">Per&iacute;odo:</td>
		<td class="texto2"><strong><%=rsAux("curso")%>&nbsp;</strong></td>
		<td class="texto1">Sigla:</td>
		<td class="texto2"><strong><%=rsAux("sigla")%>&nbsp;</strong></td>
	  </tr>
	  <tr>
	    <td class="texto1">Endere&ccedil;o:</td>
	    <td class="texto2"><%=rsAux("LOGRADOURO")%>&nbsp;</td>
	    <td class="texto1">Compl.:</td>
	    <td class="texto2"><%=rsAux("COMP_ENDERECO")%></td>
	    </tr>
	  <tr>
	    <td class="texto1">N&uacute;mero:</td>
	    <td class="texto2"><%=rsAux("NUMERO_ENDERECO")%></td>
	    <td class="texto1">Bairro:</td>
	    <td class="texto2"><%=rsAux("BAIRROALUNO")%></td>
	    </tr>
	  <tr>
	    <td class="texto1">Cidade:</td>
	    <td class="texto2"><%=rsAux("CIDADERESIDENCIA")%> - <%=rsAux("UFRESIDENCIA")%></td>
	    <td class="texto1">Cep:</td>
	    <td class="texto2"><%=rsAux("CEPRESIDENCIA")%></td>
	    </tr>
</table>
	<%

	END IF
	rsAux.close
end if
%>