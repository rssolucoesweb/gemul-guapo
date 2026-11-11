<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 05/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Selecionar os dados do aluno
-->
<%
if intCodAluno <> "" then
	
	'--DADOS ESCOLARES DO ALUNO
	SQL="SELECT TOP 1"
	SQL=SQL & " A.MATRICULA,"	
	SQL=SQL & " A.NOMEALUNO,"
	SQL=SQL & " A.DATAMATRICULA,"
	SQL=SQL & " A.DATAFASTAMENTO,"
	SQL=SQL & " A.Logradouro,"
	SQL=SQL & " A.Numero_endereco,"
	SQL=SQL & " A.Comp_endereco,"
	SQL=SQL & " A.BairroAluno,"
	SQL=SQL & " A.CidadeResidencia,"
	SQL=SQL & " A.UFResidencia,"
	SQL=SQL & " A.CepResidencia,"
	SQL=SQL & " SA.DESC_SITUACAOALUNO as SITUACAOALUNO,"
	SQL=SQL & " T.NOMETURMA,"
	SQL=SQL & " C.DESCRICAO AS CURSO,"
	SQL=SQL & " C.SIGLA,"
	SQL=SQL & " P.DESCRICAO AS PERIODO,"
	SQL=SQL & " T.COD_SEMESTRE"
	SQL=SQL & " FROM SCA_ALUNO A"
	SQL=SQL & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND A.COD_EMPRESA = SA.COD_EMPRESA"
	SQL=SQL & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND A.COD_EMPRESA = AT.COD_EMPRESA"
	SQL=SQL & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
	SQL=SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.COD_EMPRESA = GC.COD_EMPRESA"
	SQL=SQL & " INNER JOIN SCA_PERIODO P ON GC.COD_PERIODO = P.COD_PERIODO AND P.COD_EMPRESA = GC.COD_EMPRESA"
	SQL=SQL & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA"
	SQL=SQL & " WHERE A.CODIGO=" & intCodAluno
	SQL=SQL & " Order BY AT.CODIGO DESC"
	
	rsAux.OPEN SQL, CNN
	IF rsAux.EOF = FALSE THEN 
		strMatricula = rsAux("MATRICULA")
		strEndereco  = rsAux("Logradouro") & ", " & rsAux("Numero_endereco") & ", " & rsAux("Comp_endereco") & ", " & rsAux("BairroAluno") & ", " & rsAux("CidadeResidencia") & " - " & rsAux("UFResidencia")  & ", " & rsAux("CepResidencia")
	%>
	<table width="93%" align="center" border="0" cellspacing="2" cellpadding="2">
	  <tr>
		<td colspan="4" class="texto1">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="11%" class="texto1">Aluno:</td>
		<td width="48%" class="texto2"><strong><%=rsAux("MATRICULA")%> - <%=rsAux("nomealuno")%>&nbsp;</strong></td>
		<td width="10%" class="texto1">Turma:</td>
		<td width="31%" class="texto2"><strong>&nbsp;<strong><%=rsAux("nometurma")%></strong></strong></td>
	  </tr>
	  <tr>
		<td class="texto1">Curso:</td>
		<td class="texto2"><strong><%=rsAux("curso")%>&nbsp;</strong></td>
		<td class="texto1">Per&iacute;odo:</td>
		<td class="texto2"><strong><strong><%=rsAux("periodo")%></strong></strong></td>
	  </tr>
</table>
	<%
	ELSE
	%>
	<table width="93%" align="center" border="0" cellspacing="2" cellpadding="2">
	 <tr>
		<td class="texto2"><div align="center">O ALUNO N&Atilde;O EST&Aacute; VINCULADO A UMA TURMA </div></td>
	  </tr>
	  </table>
	<% 
	
	END IF
	rsAux.close
end if
%>