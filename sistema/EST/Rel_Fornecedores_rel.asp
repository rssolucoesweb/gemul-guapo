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
<title><%=session("Titulo")%></title>
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
	session("strMensagemRelatorioNaoEncontrado") = "Nenhum registro encontrado."
	
	dim intPagina
	strTituloRelatorio  	= "Fornecedores"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
      <tr bgcolor="#E5E5E5">
        <td width="9%" align="center" class="celula"><strong>Tipo</strong></td>
        <td width="25%" align="center" class="celula"><strong>Raz&atilde;o Social / Nome</strong></td>
        <td width="31%" align="center" class="celula"><strong>Endere&ccedil;o</strong></td>
        <td width="12%" align="center" class="celula"><strong>Telefone</strong></td>
        <td width="23%" align="center" class="celula"><p><strong>Respons&aacute;vel</strong></p></td>
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
	strCodSecao = request("cmbSecaoProduto")
	
	sql = "SELECT Codigo, CodEmpresa, TipoPessoa, Numero, RazaoSocialNome, endereco, telefone, responsavel"
	sql = sql & " FROM EST_fornecedor"
	sql = sql & " Where CodEmpresa	= " & session("codEmpresa")	
	sql = sql & " Order by RazaoSocialNome"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			if rs("TipoPessoa") = "J" then tipo="Jurídica"
			if rs("TipoPessoa") = "F" then tipo="Física"
			%>
                 <tr>
                    <td class="celula">&nbsp;<%=tipo%>&nbsp;</td>
                    <td class="celula">&nbsp;<%=trim(rs("RazaoSocialNome"))%>&nbsp;</td> 
                    <td class="celula" align="left">&nbsp;<%=trim(rs("endereco"))%>&nbsp;</td>
                    <td class="celula" align="center"><%=trim(rs("telefone"))%>&nbsp;</td>
                    <td class="celula" align="left">&nbsp;<%=trim(rs("responsavel"))%>&nbsp;</td> 
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
			<td colspan="5" class="celula"><strong>Fornecedores cadastrados: <%=cont%></strong></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="5" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font><br><br><br><br></td>
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