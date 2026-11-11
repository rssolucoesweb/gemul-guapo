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
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<%
	strFiltroUsuario		= request.Form("cmbTipoUsuario")
	strDataI				= formataDataBD(request.Form("txtDataI"))
	strDataF				= formataDataBD(request.Form("txtDataF"))
	strTituloRelatorio  	= "EMPR&Eacute;STIMO POR PUBLICA&Ccedil;ÃO"
	strMsn = ""
	if strFiltroUsuario = "TOD" then strMsn = " - ALUNOS, COLABORADORES E COMUNIDADE"
	if strFiltroUsuario = "ALU" then strMsn = " - ALUNOS"
	if strFiltroUsuario = "COL" then strMsn = " - COLABORADORES"
	if strFiltroUsuario = "COM" then strMsn = " - COMUNIDADE"
	if strDataI = "" or strDataF = "" then
	   strMsnPeriodo = ""
	else
	   strMsnPeriodo = "<BR> Per&iacute;odo de: " & formataDataAP(request.Form("txtDataI")) & " a " & formataDataAP(request.Form("txtDataF")) 
	end if   
	   
	strTituloRelatorio = strTituloRelatorio & strMsn & strMsnPeriodo
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="7%" align="center" class="celula"><strong>C&oacute;digo Pub.</strong></td>
		<td width="22%" class="celula"><strong>Titulo</strong></td>
		<td width="9%" align="center" class="celula"><strong>CDU</strong></td>
		<td width="11%" align="center" class="celula"><strong>N&uacute;mero de Empr&eacute;stimo</strong></td>
		<td width="10%" align="center" class="celula"><strong>Percentual</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	contTitulos = 0
	contexemplares = 0

	sql = " SELECT "
	sql = sql & " P.Cod_Publicacao, "
	sql = sql & " P.Cod_CDU, "
	sql = sql & " P.Titulo, "
	sql = sql & " COUNT(P.Cod_Publicacao) as total "
	sql = sql & " FROM SCB_Emprestimo E "
	sql = sql & " inner join SCB_emprestimoitens I on e.Cod_Emprestimo = I.Cod_Emprestimo "
	sql = sql & " inner join SCB_PublicacaoExemplares PE on PE.Cod_PublicacaoExemplares = I.Cod_PublicacaoExemplares "
	sql = sql & " inner join SCB_Publicacao P on P.Cod_Publicacao = PE.Cod_Publicacao "
	sql = sql & " where E.cod_empresa = " & session("CodEmpresa")
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and E.DataEmprestimo BETWEEN '" & strDataI & "' AND '" & strDataF & "' "
	end if
	if strFiltroUsuario = "ALU" then
		sql = sql & " and E.Cod_TipoUsuario = 1"	
	end if
	if strFiltroUsuario = "COL" then
		sql = sql & " and E.Cod_TipoUsuario = 2"	
	end if
	if strFiltroUsuario = "COM" then
		sql = sql & " and E.Cod_TipoUsuario = 3"	
	end if
	sql = sql & " group by "
	sql = sql & " P.Cod_Publicacao, " 
	sql = sql & " P.Cod_CDU, "
	sql = sql & " P.Titulo order by total desc "
	'
	rs.open sql, cnn
	if not rs.eof then 
       intBaseCalculo = rs.getrows()	
	end if   
    rs.close
	'
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof

		       Percentual = round((rs("total") * 100) / ubound(intBaseCalculo,2),2)
			   %>
			   <tr>
			   <td class="celula" align="left"><%=rs("Cod_Publicacao")%>&nbsp;</td>
			   <td class="celula"><%=rs("Titulo")%>&nbsp;</td>
			   <td class="celula"><%=rs("Cod_CDU")%></td>
			   <td class="celula"><div align="center"><strong><%=rs("total")%></strong></div></td>
			   <td class="celula" align="center"><strong><%=Percentual%>%</strong></td>
			   </tr>
			   <%
			   'quantidade de registros da página
			   if intQtdeRegistroPorPagina >= 50 then
				  intPagina = intPagina + 1
				  intQtdeRegistroPorPagina = 1
				  fimTabela
			      %>
				  <pre></pre>				
				  <%			
				  mostraCabecalho
			   end if	
			   contTitulos = contTitulos + 1
			   contexemplares = contexemplares + rs("total")
			   intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="5" class="celula">T&iacute;tulos Emprestados no Per&iacute;odo: <strong><%=contTitulos%></strong> - Exemplares Emprestados no Per&iacute;odo: <strong><%=contexemplares%></strong></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td colspan="5" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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