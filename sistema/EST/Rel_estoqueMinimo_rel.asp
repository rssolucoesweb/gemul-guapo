<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
strPaginaDestino = ""
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Estoque minimo
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../../Estilo/Estilo_Impressao.css">
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="../../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	strCodSecao = request("cmbSecaoProduto")
	if strCodSecao="" then strCodSecao = "0"
	sql = "execute EST_ListaProdutosEstoqueMinimo " & strCodSecao & "," & Session("CodEmpresa")
	rs.open sql, cnn
	if not rs.eof then 
	
		session("strMensagemRelatorioNaoEncontrado") = "Nenhum registro encontrado."
		
		dim intPagina
		strTituloRelatorio  	= "Estoque Mínimo<br>"&rs("secao")
	
		sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		<br>
		<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
		  <tr bgcolor="#E5E5E5">
			<td width="5%" align="center" class="celula"><strong>C&oacute;digo</strong></td>
			<td width="35%" align="center" class="celula"><strong>Descri&ccedil;&atilde;o<span class="TextoForm"></span></strong></td>
			<td width="8%" align="center" class="celula"><strong>Unidade<span class="TextoForm"></span></strong></td>
			<td width="15%" align="center" class="celula"><strong>Qtd. Estoque Real<span class="TextoForm"></span></strong></td>
			<td width="15%" align="center" class="celula"><strong>Qtd. Estoque Dispon&iacute;vel<span class="TextoForm"></span></strong></td>
			<td width="15%" align="center" class="celula"><strong>Estoque M&iacute;nimo</strong></td>
		  </tr>
		<%
		end Sub
		
		sub fimTabela()
			response.Write("</table>")
		end Sub
	%>
	<%
		intPagina = 1
		intQtdeRegistroPorPagina = 50
		mostraCabecalho
		cont = 0
		intQuantRegistroImpresso = 0
		While not rs.eof
			%>
                 <tr>
                    <td class="celula"><%=rs("CODIGO")%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("DESCRICAO"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("UNIDADE"))%>&nbsp;</td>
                    <td class="celula" align="center"><%=trim(rs("QTD_ATUAL_REAL"))%>&nbsp;</td> 
                    <td class="celula" align="center"><%=trim(rs("QTD_ATUAL_ESTOQUE"))%>&nbsp;</td>
                    <td class="celula" align="center"><%=trim(rs("ESTOQUE_MINIMO"))%>&nbsp;</td> 
                  </tr>
			<%
			intQuantRegistroImpresso = intQuantRegistroImpresso + 1
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) =< int(intQuantRegistroImpresso) then
				 intPagina = intPagina + 1
				 intQuantRegistroImpresso = 0
				 fimTabela
				%>
				<pre>&nbsp;</pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="6" class="celula"><strong>Quantidade de produtos cadastrados: <%=cont%></strong></td>
		  </tr>
		 <%
	else
		        response.Write("<table width='90%' border='0' cellspacing='0' cellpadding='0' class='tabela' align='center'>")

		%>
		  <tr>
			<td colspan="6" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font><br><br><br><br></td>
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