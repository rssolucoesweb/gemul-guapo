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
	
	strDataI				= request.Form("txtDataI")
	strDataF				= request.Form("txtDataF")
	intCodProfessor	        = Trim(Request("cmbProfessor"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strClassificacao		= request.Form("cmbClassificacao")
	
	strTituloRelatorio  	= "Relatório Sintético de Faltas e Substituições"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td colspan="7" class="<%=strclasse%>"><div align="center"><strong>Faltas - Per&iacute;odo: <%=strDataI%>&nbsp;a&nbsp; <%=strDataF%> </strong></div></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
		<td width="7%" height="19" class="<%=strclasse%>"><div align="left"><strong>C&oacute;digo Funcional </strong></div></td>
		<td width="45%" class="<%=strclasse%>"><p align="left"><strong>Colaborador </strong><strong>Titular </strong></p></td>
		<td width="37%" class="<%=strclasse%>"><p align="left"><strong>Curso</strong></p></td>
		<td width="11%" class="<%=strclasse%>"><div align="left"><strong>Faltas </strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intPagina = 1
	cont = 0
    
	'Faltas 
	sql = " select CF.cod_empresa, CF.ano_letivo, CF.semestre_letivo, CF.cod_colaborador, CU.descricao as curso, C.CodFuncional, C.nome, sum(convert(int,numero_falta)) as falta " 
	sql = sql & " from dbo.SRH_COLABORADOR_FREQUENCIA CF "
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR"
	sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA = CF.COD_EMPRESA AND T.COD_TURMA = CF.COD_TURMA "
	sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR "
	sql = sql & " LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO "
	sql = sql & " LEFT JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO "
	sql = sql & " WHERE CF.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " AND CF.NUMERO_FALTA <> 0 "
	if intCodProfessor <> "" and intCodProfessor <> "0" then 
	   sql = sql & " AND CF.COD_COLABORADOR = " & intCodProfessor
	end if
    'sql = sql & " AND CF.SITUACAO <> 'S' "  'se não estiver abonada
	if Session("NivelPermissao") <> "A" then
	   sql = sql & " AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
	end if   
	sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, '" & strDataI & "',103)"
    sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, '" & strDataF & "',103)"
	'ordem de classificação do relatorio
	sql = sql & " group by CF.cod_empresa, ano_letivo, semestre_letivo, cod_colaborador, c.nome, C.CodFuncional, CU.descricao " 
	sql = sql & " order by c.nome "
    rs.open sql, cnn
	if not rs.eof then 
	   
	   mostraCabecalho
	   
	   While not rs.eof
	      %>
		  <tr>
		  <td class="<%=strclasse%>" align="left"><div align="center">&nbsp;<%=rs("CodFuncional")%></div></td>
		  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("nome")%></div></td>
		   <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("curso")%></div></td>
		  <td align="center" class="<%=strclasse%>">&nbsp;<%=rs("falta")%></td>
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
		  cont = cont + 1
		  intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		  rs.movenext
	   wend
	   %>
	   <tr>
	   <td colspan="7" class="<%=strclasse%>">Quantidade de Lan&ccedil;amento Faltas no Per&iacute;do: <%=cont%></td>
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
	'
	'Aulas 
	sql = " select CF.cod_empresa, CF.ano_letivo, CF.semestre_letivo, CU.descricao as curso, C.CodFuncional, C.nome, sum(convert(int,numero_aula)) as aula " 
	sql = sql & " from dbo.SRH_COLABORADOR_FREQUENCIA CF "
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADORSUBSTITUTO "
	sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA = CF.COD_EMPRESA AND T.COD_TURMA = CF.COD_TURMA "
	sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR "
	sql = sql & " LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO "
	sql = sql & " LEFT JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO "
	sql = sql & " WHERE CF.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " AND CF.NUMERO_AULA <> 0 "
	if intCodProfessor <> "" and intCodProfessor <> "0" then 
	   sql = sql & " AND CF.COD_COLABORADORSUBSTITUTO = " & intCodProfessor
	end if
    'sql = sql & " AND CF.SITUACAO <> 'S' "  'se não estiver abonada
    if Session("NivelPermissao") <> "A" then
	   sql = sql & " AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
	end if   
   sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, '" & strDataI & "',103)"
    sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, '" & strDataF & "',103)"
	'ordem de classificação do relatorio
	sql = sql & " group by CF.cod_empresa, ano_letivo, semestre_letivo, c.nome, C.CodFuncional, CU.descricao" 
	sql = sql & " order by c.nome " 
    rs.open sql, cnn
	if not rs.eof then 
	   %>
	   <tr bgcolor="#CCCCCC">
		 <td colspan="4" align="left" class="<%=strclasse%>"><div align="center"><strong>Aulas em Substitui&ccedil;&atilde;o - Per&iacute;odo: <%=strDataI%>&nbsp;a&nbsp; <%=strDataF%> </strong></div></td>
       </tr>
	   <%
	   While not rs.eof
	      %>
		  <tr>
		  <td class="<%=strclasse%>" align="left"><div align="center">&nbsp;<%=rs("CodFuncional")%></div></td>
		  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("nome")%></div></td>
		  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("curso")%></div></td>
		  <td align="center" class="<%=strclasse%>">&nbsp;<%=rs("aula")%></td>
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
		  cont = cont + 1
		  intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		  rs.movenext
	   wend
	   %>
	   <tr>
	   <td colspan="7" class="<%=strclasse%>">Quantidade de Lan&ccedil;amento de Substitui&ccedil;&atilde;o no Per&iacute;do: <%=cont%></td>
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
