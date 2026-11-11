
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
	SQL=SQL & " 	A.DATAMATRICULA,"
	SQL=SQL & " 	A.DATAFASTAMENTO,"
	SQL=SQL & "     A.LOGRADOURO, A.NUMERO_ENDERECO, A.COMP_ENDERECO, A.BAIRROALUNO, A.CIDADERESIDENCIA, UF.SIGLA AS UFRESIDENCIA, A.CEPRESIDENCIA, "
    SQL=SQL & "     A.FONERESIDENCIAL, A.FONECOMERCIAL, A.FONECELULAR, A.IDENTIDADE, A.IDENTIDADEORGAO, UFI.SIGLA AS UFIDENTIDADE, A.CPFALUNO,"
	SQL=SQL & " 	SA.DESC_SITUACAOALUNO as SITUACAOALUNO,"
	SQL=SQL & " 	T.NOMETURMA,"
	SQL=SQL & " 	FI.DESCRICAO AS FORMAINGRESSO,"
	SQL=SQL & " 	C.DESCRICAO AS CURSO,"
	SQL=SQL & " 	C.SIGLA,"
	SQL=SQL & " 	P.DESCRICAO AS PERIODO,"
	SQL=SQL & " 	PL.DESCRICAO AS PLANO,"
	SQL=SQL & " 	T.COD_SEMESTRE, T.COD_TURMA,"
	SQL=SQL & " 	SCF_CATEGORIA_DESCONTO.descricao AS CATEGORIADESCONTO,"
	SQL=SQL & " 	G.DESC_GRAU as GRAU"
	SQL=SQL & " FROM SCA_ALUNO A"
	SQL=SQL & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND A.COD_EMPRESA = SA.COD_EMPRESA"
	SQL=SQL & " LEFT JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND A.COD_EMPRESA = AT.COD_EMPRESA"
	SQL=SQL & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
	SQL=SQL & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.COD_EMPRESA = GC.COD_EMPRESA"
	SQL=SQL & " LEFT JOIN SCA_PERIODO P ON GC.COD_PERIODO = P.COD_PERIODO AND P.COD_EMPRESA = GC.COD_EMPRESA"
	SQL=SQL & " LEFT JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA"
	SQL=SQL & " LEFT JOIN SCA_GRAU G ON G.COD_GRAU = C.COD_GRAU AND G.COD_EMPRESA = C.COD_EMPRESA"
	SQL=SQL & " LEFT JOIN SCF_PLANO PL ON PL.CODIGO = T.Cod_PlanoPagamento AND PL.COD_EMPRESA = T.COD_EMPRESA "
	SQL=SQL & " LEFT JOIN SCF_UF UF ON UF.CODIGO = A.UFRESIDENCIA"
	SQL=SQL & " LEFT JOIN SCF_UF UFI ON UFI.CODIGO = A.IDENTIDADEUF"
	SQL=SQL & " LEFT JOIN SCA_FORMAINGRESSO FI ON FI.CODIGO = A.COD_FORMAINGRESSO"
	SQL=SQL & " LEFT JOIN SCF_CATEGORIA_DESCONTO ON SCF_CATEGORIA_DESCONTO.codigo = a.cod_categoria_desconto "
	SQL=SQL & " WHERE A.CODIGO=" & intCodAluno
	SQL=SQL & " Order BY AT.CODIGO DESC"
	rsAux.OPEN SQL, CNN
	IF rsAux.EOF = FALSE THEN 
	    strMatricula = rsAux("MATRICULA")
		strNomeCompletoAluno = rsAux("nomealuno")
		intCodTurma = rsAux("COD_TURMA")
		endereco = rsAux("LOGRADOURO")
		if not (rsAux("NUMERO_ENDERECO") = "" or isnull(rsAux("NUMERO_ENDERECO"))) then
			endereco = endereco & ", " & rsAux("NUMERO_ENDERECO")
		end if
		if not (rsAux("COMP_ENDERECO") = "" or isnull(rsAux("COMP_ENDERECO")))  then
			endereco = endereco & ", " & rsAux("COMP_ENDERECO")
		end if
		if not (rsAux("BAIRROALUNO")  = "" or isnull(rsAux("BAIRROALUNO"))) then
			endereco = endereco & ", " & rsAux("BAIRROALUNO")
		end if
		if not (rsAux("CIDADERESIDENCIA") = "" or isnull(rsAux("CIDADERESIDENCIA"))) then
			endereco = endereco & ", " & rsAux("CIDADERESIDENCIA")
		end if
		if not (rsAux("UFRESIDENCIA") = "" or isnull(rsAux("UFRESIDENCIA")))  then
			endereco = endereco & " - " & rsAux("UFRESIDENCIA")
		end if
		if not (rsAux("CEPRESIDENCIA") = "" or isnull(rsAux("CEPRESIDENCIA")))  then
			endereco = endereco & ", CEP: " & rsAux("CEPRESIDENCIA")
		end if
			
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
<style type="text/css">
<!--
.style2 {
	color: #FF0000;
	font-family: Arial, Helvetica, sans-serif;
}
-->
</style>

	    <table class="table table-bordered">
	    <tr>
		  <td colspan="4" bgcolor="#95A5A6"><strong>Dados Escolares </strong></td>
	    </tr>
	    <tr>
		<td class="texto1">Aluno:</td>
		<td class="texto2"><strong><%=rsAux("MATRICULA")%> - <%=rsAux("nomealuno")%>&nbsp;</strong></td>
		<td class="texto1">Situa&ccedil;&atilde;o:</td>
		<td class="texto2"><strong><%=rsAux("situacaoaluno")%>&nbsp;-&nbsp;<%=rsAux("FORMAINGRESSO")%></strong></td>
	  </tr>
	  <tr>
		<td class="texto1">Data Matr&iacute;cula: </td>
		<td class="texto2"><strong><%=rsAux("datamatricula")%>&nbsp;</strong></td>
		<td class="texto1">Data Afast.: </td>
		<td class="texto2"><strong><%=rsAux("DATAFASTAMENTO")%>&nbsp;</strong></td>
	  </tr>
	  <tr>
		<td width="11%" class="texto1">Turma:</td>
		<td width="48%" class="texto2"><strong><%=rsAux("nometurma")%>&nbsp;</strong></td>
		<td width="10%" class="texto1">Semestre:</td>
		<td width="31%" class="texto2"><strong><%=rsAux("cod_semestre")%>º. Semestre&nbsp;</strong></td>
	  </tr>
	  <tr>
		<td class="texto1">Curso:</td>
		<td class="texto2"><strong><%=rsAux("curso")%>&nbsp;</strong></td>
		<td class="texto1">Sigla:</td>
		<td class="texto2"><strong><%=rsAux("sigla")%>&nbsp;</strong></td>
	  </tr>
	  <tr>
	    <td class="texto1">Per&iacute;odo:</td>
	    <td class="texto2"><strong><%=rsAux("periodo")%></strong></td>
	    <td class="texto1">Plano Pagto:</td>
	    <td class="texto2"><strong><%=rsAux("plano")%><br/><span class="style2"><%=rsAux("CATEGORIADESCONTO")%></span></strong></td>
	    </tr>
	  <tr>
	    <td class="texto1">Endere&ccedil;o:</td>
	    <td class="texto2"><strong><%=endereco%></strong></td>
	    <td class="texto1">Telefone(s):</td>
	    <td class="texto2"><strong><%=fones%></strong></td>
	    </tr>
	  <tr>
	    <td class="texto1">Cpf:</td>
	    <td class="texto2"><strong><%=rsAux("CPFALUNO")%>&nbsp;</strong></td>
	    <td class="texto1">Identidade:</td>
	    <td class="texto2"><strong><%=rsAux("IDENTIDADE")%>/<%=rsAux("IDENTIDADEORGAO")%>-<%=rsAux("UFIDENTIDADE")%>&nbsp;</strong></td>
	    </tr>
</table>
	<%
	END IF
	rsAux.close
end if
%>