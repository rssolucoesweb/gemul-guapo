
<!--
	::	Data de Criação...: 21/02/2008
	::	Desenvolvedores...: SERGIO BORGES - sergiob76@hotmail.com
	::	Objetivo Pagina...: Selecionar os dados escolares do aluno
-->
<%
if intCodAluno <> "" then
	'--DADOS ESCOLARES DO ALUNO
	
	sql = " select "
	sql = sql & " SCA_VESTIBULAR.Descricao as vestibular,"
	sql = sql & " SCA_VESTIBULAR.Data,"
	sql = sql & " SCA_VESTIBULAR.Horario,"
	sql = sql & " SCA_VESTIBULAR.Campus,"
	sql = sql & " SCA_VESTIBULAR.Ano_letivo,"
	sql = sql & " SCA_VESTIBULAR.Semestre,"
	sql = sql & " SCF_UF.SIGLA,"
	sql = sql & " SCF_SITUACAO_PAGAMENTO.descricao as SITUACAO,"
	sql = sql & " SCA_VESTIBULAR_DADOS.* "
	sql = sql & " from SCA_VESTIBULAR_DADOS"
	sql = sql & " inner join SCA_VESTIBULAR ON SCA_VESTIBULAR.CODIGO = SCA_VESTIBULAR_DADOS.COD_VESTIBULAR"
	sql = sql & " left join SCF_SITUACAO_PAGAMENTO ON SCF_SITUACAO_PAGAMENTO.CODIGO = SCA_VESTIBULAR_DADOS.COD_SITUACAO_PAGAMENTO"
	sql = sql & " AND SCA_VESTIBULAR.COD_EMPRESA = SCA_VESTIBULAR_DADOS.COD_EMPRESA"
	sql = sql & " inner join SCF_UF ON SCF_UF.CODIGO = SCA_VESTIBULAR_DADOS.UF"
	sql = sql & " WHERE SCA_VESTIBULAR_DADOS.CODIGO = " & codBebitoAluno
	sql = sql & " AND SCA_VESTIBULAR_DADOS.COD_EMPRESA = " & intCodEmpresa
	sql = sql & " ORDER BY SCA_VESTIBULAR.Ano_letivo, SCA_VESTIBULAR.Semestre"
	rsAux.OPEN SQL, CNN
	IF rsAux.EOF = FALSE THEN 
		strNomeCompletoAluno = rsAux("nomealuno")
	%>
	<table width="100%" border="0" cellspacing="2" cellpadding="2" bgcolor="#F3F3F3">
	  <tr>
		<td colspan="4" class="texto1"><strong>Dados do Candidato</strong></td>
	  </tr>
	  <tr>
		<td width="11%" class="texto1">Aluno:</td>
		<td width="48%" class="texto2"><strong><%=rsAux("codigo")%> - <%=rsAux("nomealuno")%>&nbsp;</strong></td>
		<td width="15%" class="texto1">Data Inscri&ccedil;&atilde;o: </td>
		<td width="26%" class="texto2"><strong><%=rsAux("data")%></strong></td>
	  </tr>
	  <tr>
	    <td class="texto1">Vestibular:</td>
	    <td class="texto2"><%=rsAux("vestibular")%></td>
	    <td class="texto1">Hor&aacute;rio:</td>
	    <td class="texto2"><strong><%=rsAux("horario")%></strong></td>
      </tr>
	  <tr>
	    <td class="texto1">Campus:</td>
	    <td class="texto2"><%=rsAux("campus")%></td>
	    <td class="texto1">Ano/Semestre:</td>
	    <td class="texto2"><strong><%=rsAux("ano_letivo")%>/<%=rsAux("semestre")%></strong></td>
      </tr>
</table>
	<%
	END IF
	rsAux.close
end if
%>