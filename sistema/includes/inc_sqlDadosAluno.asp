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
	SQL=SQL & " UF.SIGLA AS UFResidencia,"
	SQL=SQL & " A.CepResidencia,"
	SQL=SQL & " A.FONECOMERCIAL,"
	SQL=SQL & " A.FONECELULAR,"
	SQL=SQL & " A.FONERESIDENCIAL,"
	SQL=SQL & " SA.DESC_SITUACAOALUNO as SITUACAOALUNO,"
	SQL=SQL & " T.NOMETURMA,"
	SQL=SQL & " C.DESCRICAO AS CURSO,"
	SQL=SQL & " C.COD_CURSO,"
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
    sql=sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = A.UFRESIDENCIA "
	SQL=SQL & " WHERE A.CODIGO=" & intCodAluno
	SQL=SQL & " Order BY AT.CODIGO DESC"
	rsAux.OPEN SQL, CNN
	IF rsAux.EOF = FALSE THEN 
	
	    intCodCurso = rsAux("COD_CURSO")
		strMatricula = rsAux("MATRICULA")
		strEndereco  = rsAux("Logradouro") & ", " & rsAux("Numero_endereco") & ", " & rsAux("Comp_endereco") & ", " & rsAux("BairroAluno") & ", " & rsAux("CidadeResidencia") & " - " & rsAux("UFResidencia")  & ", " & rsAux("CepResidencia")
	
		fones = ""
			
		if not (rsAux("FONECOMERCIAL") = "" or isnull(rsAux("FONECOMERCIAL"))) then
			fones = rsAux("FONECOMERCIAL")
		end if
		if not (rsAux("FONECOMERCIAL") = "" or isnull(rsAux("FONECOMERCIAL"))) then
			if fones = "" then 
				fones = rsAux("FONECOMERCIAL")
			else
				fones = fones & " - " & rsAux("FONECOMERCIAL")
			end if
		end if
		if not (rsAux("FONECELULAR") = "" or isnull(rsAux("FONECELULAR")))  then
			if fones = "" then 
				fones = rsAux("FONECELULAR")
			else
				fones = fones & " - " & rsAux("FONECELULAR")
			end if
		end if
		
	%>
	<table width="93%" align="center" border="0" cellspacing="2" cellpadding="2">
	  <tr>
		<td colspan="6" class="texto1">&nbsp;</td>
	  </tr>
	  <tr>
		<td class="texto1">Aluno:</td>
		<td class="texto2"><strong><%=rsAux("MATRICULA")%> - <%=rsAux("nomealuno")%>&nbsp;</strong></td>
		<td class="texto1">Data Matr&iacute;cula: </td>
		<td colspan="3" class="texto2"><strong><%=rsAux("DATAMATRICULA")%></strong></td>
	  </tr>
	  <tr>
		<td class="texto1">Turma:</td>
		<td class="texto2"><strong><strong><%=rsAux("nometurma")%></strong></strong></td>
		<td class="texto1">Semestre:</td>
		<td colspan="3" class="texto2"><strong><strong><%=rsAux("cod_semestre")%>º. Semestre&nbsp;</strong></strong></td>
	  </tr>
	  <tr>
		<td width="13%" class="texto1">Curso:</td>
		<td width="44%" class="texto2"><strong><strong><%=rsAux("curso")%></strong></strong></td>
		<td width="14%" class="texto1">Sigla:</td>
		<td width="11%" class="texto2"><strong><%=rsAux("sigla")%></strong></td>
	    <td width="7%" class="texto2"><span class="texto1">Per&iacute;odo:</span></td>
	    <td width="11%" class="texto2"><strong><strong><%=rsAux("periodo")%></strong></strong></td>
	  </tr>
	  <tr>
		<td class="texto1">Endere&ccedil;o:</td>
		
		<td colspan="5" class="texto2"><strong><%=strEndereco%></strong></td>
	  </tr>
	  <tr>
	    <td class="texto1">Contatos:</td>
	    <td colspan="5" class="texto2"><strong><%=fones%></strong></td>
      </tr>
	  <tr>
	    <td height="10" colspan="6" class="texto1"></td>
      </tr>
</table>
	<%
	END IF
	rsAux.close
end if
%>