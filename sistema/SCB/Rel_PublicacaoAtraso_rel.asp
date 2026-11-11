<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<%
	strTituloRelatorio  	= "Publica&ccedil;&atilde;o em Atraso"
	strDataDia			  	= formataDataAP(date)
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="7%" align="center" class="celula"><strong>Matr&iacute;cula</strong></td>
		<td width="21%" class="celula"><strong>Nome </strong></td>
		<td width="22%" class="celula"><strong>Titulo</strong></td>
		<td width="11%" class="celula"><strong>Cod. Exemplar </strong>
	      <div align="center"></div></td>
		<td width="9%" align="center" class="celula"><strong>CDU</strong></td>
		<td width="11%" align="center" class="celula"><strong>Data Emprestimo </strong></td>
		<td width="10%" align="center" class="celula"><strong>Data Devolu&ccedil;&atilde;o </strong></td>
		<td width="9%" align="center" class="celula"><strong>Dias em atraso</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = " SELECT SCA_ALUNO.Matricula, SCA_ALUNO.NOMEALUNO, SRH_COLABORADOR.Codigo as CodColaborador, SRH_COLABORADOR.Nome as Colaborador, "
	sql = sql & " SCB_Comunidade.Codigo as CodComunidade , SCB_Comunidade.Nome as Comunidade, E.Situacao, E.Cod_TipoUsuario, E.DataEmprestimo, I.DataDevolucao,"
	sql = sql & " I.Cod_PublicacaoExemplares, P.Cod_CDU, P.Titulo, "
	sql = sql & " SUM(CAST(CAST(FLOOR(CAST(GETDATE() AS float)) AS datetime) - i.DataDevolucao  AS INT )) as DiasAtraso"
	'sql = sql & " SUM(CAST(getdate() - i.DataDevolucao -1 AS INT )) as DiasAtraso"
	sql = sql & " FROM SCB_Emprestimo E left JOIN SCA_ALUNO "
	sql = sql & " ON E.Cod_aluno = SCA_ALUNO.Codigo left JOIN SRH_COLABORADOR "
	sql = sql & " ON E.Cod_Colaborador = SRH_COLABORADOR.Codigo left JOIN SCB_Comunidade "
	sql = sql & " ON E.Cod_Comunidade = SCB_Comunidade.Codigo "
	sql = sql & " inner join SCB_emprestimoitens I on e.Cod_Emprestimo = I.Cod_Emprestimo"
	sql = sql & " inner join SCB_PublicacaoExemplares PE on PE.Cod_PublicacaoExemplares = I.Cod_PublicacaoExemplares"
	sql = sql & " inner join SCB_Publicacao P on P.Cod_Publicacao = PE.Cod_Publicacao"
	sql = sql & " where E.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and I.Status = 'A'"
	sql = sql & " and E.situacao = 'E' "
	sql = sql & " and convert(datetime,convert(varchar, i.DataDevolucao, 103),103) <  convert(datetime, '" & strDataDia & "',103)"
	sql = sql & " group by SCA_ALUNO.Matricula, SCA_ALUNO.NOMEALUNO, SRH_COLABORADOR.Codigo, SRH_COLABORADOR.Nome, "
	sql = sql & " SCB_Comunidade.Codigo, SCB_Comunidade.Nome, E.Situacao, E.Cod_TipoUsuario, E.DataEmprestimo, I.DataDevolucao, "
	sql = sql & " I.Cod_PublicacaoExemplares, P.Cod_CDU, P.Titulo  "
	rs.open sql, cnn
	
	if not rs.eof then 
	
		While not rs.eof
			
			if trim(rs("Cod_TipoUsuario")) = 1 then
				strMatricula 	= rs("Matricula")
				strNome 		= rs("NOMEALUNO")
			end if
		
			if trim(rs("Cod_TipoUsuario")) = 2 then
				strMatricula 	= rs("CodColaborador")
				strNome 		= rs("Colaborador")
			end if
		
			if trim(rs("Cod_TipoUsuario")) = 3 then
				strMatricula = rs("CodComunidade")
				strNome = rs("Comunidade")
			end if
			if int(rs("DiasAtraso")) > 0 then
			   %>
			   <tr>
			   <td class="celula" align="left"><%=strMatricula%>&nbsp;</td>
			   <td class="celula" align="left"><%=strNome%>&nbsp;</td>
			   <td class="celula"><%=rs("Titulo")%>&nbsp;</td>
			   <td class="celula"><%=rs("Cod_PublicacaoExemplares")%></td>
			   <td class="celula"><%=rs("Cod_CDU")%></td>
			   <td class="celula" align="center"><%=formataDataAP(rs("DataEmprestimo"))%>&nbsp;</td>
			   <td class="celula" align="center"><%=formataDataAP(rs("DataDevolucao"))%>&nbsp;</td>
			   <td class="celula" align="center"><%=rs("DiasAtraso")%>&nbsp;</td>
			   </tr>
			   <%
			   'quantidade de registros da página
			   if intQtdeRegistroPorPagina = 50 then
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
			end if     
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="8" class="celula">Quantidade: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td colspan="8" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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