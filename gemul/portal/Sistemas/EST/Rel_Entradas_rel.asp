<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
'strPaginaDestino = "rel_saidaProduto_con.asp"
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
</head>
<body>
<!--#include file="../../../includes/inc_verificaSession.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<!--#include file="../../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<br>
<%
	session("strMensagemRelatorioNaoEncontrado") = "Nenhum registro encontrado."
	
	strDataI = request("txtDataI")
	strDataF = request("txtDataF")
	
	intCodProduto = request("cmbProduto")
	if intCodProduto = "" then intCodProduto = "0"
	
	intCodFornecedor = request("cmbFornecedor")
	if intCodFornecedor = "" then intCodFornecedor = "0"

	intSecaoProduto = request("cmbSecaoProduto")
	if intSecaoProduto = "" then intSecaoProduto = "0"
	
	dim intPagina
	strTituloRelatorio  	= "Entrada de Produto"
	strTituloRelatorio 		= strTituloRelatorio & "<br>" &  strDataI & " a " & strDataF

	sub mostraCabecalho()
	%>
	<!--#include file="../../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
      <tr bgcolor="#E5E5E5">
        <td width="50%" align="center" class="celula"><strong>Produto</strong></td>
        <td width="18%" align="center" class="celula"><strong>Unidade</strong></td>
        <td width="14%" align="center" class="celula"><strong>Quantidade<span class="TextoForm"></span></strong></td>
        <td width="18%" align="center" class="celula"><strong>Total</strong></td>
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
	intTotal = 0
	intQuantRegistroImpresso = 0
	
	sql = "select _e.codigo, _e.DATA_ENTRADA, _e.VALOR_TOTAL, _e.NUMERO, _f.razaosocialNome as fornecedor, _ei.quantidade, _ei.valor_unitario as total, _p.DESCRICAO as produto, _e.obs,_u.DESCRICAO as unidade"
	sql = sql & " from EST_Entrada _e"
	sql = sql & " inner join EST_FORNECEDOR _f on _f.codigo = _e.CODFORNECEDOR"
	sql = sql & " inner join EST_EntradaItens _ei on _ei.codEntrada = _e.CODIGO"
	sql = sql & " inner join EST_PRODUTO _p on _p.codigo = _ei.codProduto"
	sql = sql & " left join EST_UNIDADE_PRODUTO _u on _u.codigo = _p.COD_UNIDADE"
	sql = sql & " where _e.CODEMPRESA =" & Session("CodEmpresa")
	sql = sql & " and _e.DATA_ENTRADA between '" & formataDataBD(strDataI) & "' and '" & formataDataBD(strDataF) & "'"
	IF intCodProduto<>"0" THEN
		sql = sql & " and _p.CODIGO = " & intCodProduto
	end if
	IF intCodFornecedor<>"0" THEN
		sql = sql & " and _f.codigo = " & intCodFornecedor
	end if
	IF intSecaoProduto<>"0" THEN
		sql = sql & " and _p.COD_SECAO = "& intSecaoProduto
	END IF	
	sql = sql & " order by 1,5,8"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			if trim(rs("CODIGO"))<>trim(strCODIGO) then
				strObs = rs("obs")
			%>
             <tr>
                <td colspan="4" align="center" class="celula">
                <br>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#CCCCCC">
                    <tr>
                      <td width="25%"><strong>Fornecedor</strong></td>
                      <td width="17%"><strong>C&oacute;digo da Entrada</strong></td>
                      <td width="16%"><strong>Data Entrada</strong></td>
                      <td width="17%"><strong>Numero</strong></td>
                      <td width="25%"><strong>Valor Total</strong></td>
                    </tr>
                    <tr>
                      <td><%=rs("fornecedor")%></td>
                      <td><%=rs("codigo")%></td>
                      <td><%=rs("DATA_ENTRADA")%></td>
                      <td><%=rs("NUMERO")%></td>
                      <td><%=rs("VALOR_TOTAL")%></td>
                    </tr>
                	<%if trim(strObs)<>"" then%>
                    <tr>
                      <td colspan="5">Obs:&nbsp;<%=strObs%></td>
                    </tr>
                    <%end if%>
                </table>
                <br>
				</td>
              </tr>
			<%
			end if
			%>
             <tr>
                <td class="celula"><%=rs("produto")%>&nbsp;</td>
                <td class="celula" align="center"><%=rs("unidade")%>&nbsp;</td>
                <td class="celula" align="center"><%=trim(rs("quantidade"))%>&nbsp;</td>
                <td class="celula" align="right"><%=trim(formatNumber(rs("total"),2))%>&nbsp;</td> 
              </tr>
			<%
			intTotal = intTotal + rs("total")
			strCODIGO = trim(rs("CODIGO"))
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
			<td colspan="3" align="right" class="celula"><strong>Total Geral&nbsp;&nbsp;</strong></td>
			<td class="celula" align="right"><strong><%=formatNumber(intTotal,2)%></strong>&nbsp;</td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="4" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font><br><br><br><br></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<script src="../../../js/js_barra_movel.js"></script>
<script>
	document.all.aguarde.style.display="none";
</script>
</body>
</html>