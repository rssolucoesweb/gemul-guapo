<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	strDataI				= formatadataAP(request.Form("txtDataI"))
	strDataF				= formatadataAP(request.Form("txtDataF"))
    intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma   = Trim(Request.Form("cmbDisciplinaTurma"))
	intCodTaxa              = Trim(Request.Form("cmbTaxa"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strOpcaoRelatorio		= request.Form("optOpcao")
	strTipoRelatorio		= request.Form("cmbTipoRelatorio")


	sub mostraCabecalho()
        strTituloRelatorio  	= "Relação de Requerimento - " & trim(rs("TAXA"))
	    %>
	    <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	    <br>
	    <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	    <tr bgcolor="#CCCCCC">
	    <td colspan="7" class="<%=strclasse%>"><div align="center"><strong>Per&iacute;odo de Requerimento: <%=strDataI%>&nbsp;a&nbsp;<%=strDataF%> </strong></div></td>
        </tr>
	    <tr bgcolor="#CCCCCC">
		<td width="5%" height="19" class="<%=strclasse%>"><div align="left"><strong>Ord.</strong></div></td>
		<td width="11%" class="<%=strclasse%>"><strong>Turma</strong></td>
		<td width="73%" class="<%=strclasse%>"><div align="left"><strong>Disciplina </strong></div></td>
	    <td width="11%" class="<%=strclasse%>"><strong>Quantidade</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intPagina = 1
	cont = 0
	contProvas = 0
	sql = "SELECT TX.DESCRICAO AS TAXA, T.NOMETURMA, DI.DESC_DISCIPLINA, COUNT(DI.DESC_DISCIPLINA) AS TOTAL "
	sql = sql & " FROM SCF_PROTOCOLO P "
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = P.COD_ALUNO AND A.COD_EMPRESA = P.COD_EMPRESA "
	sql = sql & " INNER JOIN SCF_DEBITOALUNO D ON D.CODIGO = P.COD_DEBITOALUNO "
	sql = sql & " INNER JOIN SCF_DEBITOALUNO_COMPLEMENTO DC ON DC.COD_DEBITOALUNO = D.CODIGO "
	sql = sql & " INNER JOIN SCF_TAXA TX ON TX.COD_TAXA = D.COD_TAXA "
	sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA AD ON AD.CODIGO = DC.COD_ALUNO_DISCIPLINA "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO "
	sql = sql & " INNER JOIN SCA_DISCIPLINA DI ON DI.COD_DISCIPLINA = AD.COD_DISCIPLINA " 
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular"
	sql = sql & " INNER JOIN SCA_PERIODO PE ON PE.Cod_Periodo = GC.Cod_Periodo and PE.cod_empresa = GC.cod_empresa"
	sql = sql & " INNER JOIN SCA_CURSO CU ON CU.Cod_Curso = PE.Cod_Curso and CU.cod_empresa = PE.cod_empresa"
	sql = sql & " WHERE P.COD_EMPRESA= " & session("CodEmpresa")
	sql = sql & " AND D.COD_SITUACAO_PAGAMENTO = '2' "
	sql = sql & " and convert(datetime,convert(varchar, D.DATAPAGAMENTO, 103),103) >=  convert(datetime, ' " & strDataI & "',103) "
    sql = sql & " and convert(datetime,convert(varchar, D.DATAPAGAMENTO, 103),103) <=  convert(datetime, ' " & strDataF & "',103) "
	sql = sql & " AND D.COD_TAXA = " & intCodTaxa
	if intCodTurma <> "0" and intCodTurma <> "" then
	   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma
	end if 
	if intCodDisciplinaTurma <> "0" and intCodDisciplinaTurma <> "" then
 	   sql = sql & " AND AD.COD_DISCIPLINA = " & intCodDisciplinaTurma
	end if   
	if intCodCurso <> "0" then
	   sql = sql & " and CU.Cod_Curso = " & intCodCurso
	end if
	sql = sql & " GROUP BY TX.DESCRICAO, T.NOMETURMA, DI.DESC_DISCIPLINA "
	sql = sql & " ORDER BY T.NOMETURMA, DI.DESC_DISCIPLINA "
    rs.open sql, cnn
	if not rs.eof then 
	   
	   mostraCabecalho
	   
	   While not rs.eof
	      if isnull(rs("TOTAL")) or trim(rs("TOTAL")) = "" then
		     contProvas = contProvas + 0
	      else		 
   		     contProvas = contProvas + int(rs("TOTAL"))
		  end if	 
    
          cont = cont + 1
	      %>
		  <tr>
		  <td class="<%=strclasse%>" align="left"><div align="center">&nbsp;<%=cont%></div></td>
		  <td align="center" class="<%=strclasse%>">&nbsp;<%=rs("NOMETURMA")%></td>
	  	  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("DESC_DISCIPLINA")%></div></td>
		  <td align="center" class="<%=strclasse%>">&nbsp;<%=rs("TOTAL")%></td>
		  </tr>
		  <%
	 	  'quantidade de registros da página
		  if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
			 intPagina = intPagina + 1
			 intQtdeRegistroPorPagina = 1
			 fimTabela
			 %>
			 <pre></pre>				
		 	 <%			
			 mostraCabecalho
	 	  end if	
		  intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		  rs.movenext
	   wend
	   %>
	   <tr>
	   <td colspan="7" class="<%=strclasse%>">Quantidade de Lan&ccedil;amento no Per&iacute;do: <%=cont%></td>
	   </tr>
	   <tr>
	   <td colspan="7" class="<%=strclasse%>">Quantidade de PROVAS requeridas no Per&iacute;do: <%=contProvas%></td>
	   </tr>
	   <%
	else
		%>
		  <tr>
			<td height="62" colspan="7" align="center" class="<%=strclasse%>"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
