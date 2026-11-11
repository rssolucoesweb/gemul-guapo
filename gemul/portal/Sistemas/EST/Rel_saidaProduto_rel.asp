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
<script src="../../../js/js_barra_movel.js"></script>
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
	
	intCodUnidade = request("cmbDepartamento")
	if intCodUnidade = "" then intCodUnidade = "0"
	
	dim intPagina
	strTituloRelatorio  	= "Saída de Produto"
	strTituloRelatorio 		= strTituloRelatorio & "<br>" &  strDataI & " a " & strDataF

	sub mostraCabecalho()
	%>
	<!--#include file="../../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
      <tr bgcolor="#E5E5E5">
        <td width="20%" align="center" class="celula"><strong>Unidade</strong></td>
        <td width="20%" align="center" class="celula"><strong>Departamento<span class="TextoForm"></span></strong></td>
        <td width="20%" align="center" class="celula"><strong>Solicitante<span class="TextoForm"></span></strong></td>
        <td width="10%" align="center" class="celula"><strong>Data Solicita&ccedil;&atilde;o<span class="TextoForm"></span></strong></td>
        <td width="10%" align="center" class="celula"><strong>Data Libera&ccedil;&atilde;o<span class="TextoForm"></span></strong></td>
        <td width="20%" align="center" class="celula"><strong>Produto Abreviada<span class="TextoForm"></span></strong></td>
        <td width="10%" align="center" class="celula"><strong>Quantidade</strong></td>
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
	
	sql = "select _e.NomeFantazia as empresa, _d.DESCRICAO as departamento, _u.nome as solicitante, _r.dataEntrada as dataSolicitacao, convert(varchar,_r.data_liberacao,103) as data, _rp.codProduto, _p.descricao_abreviada as produto, sum(_rp.quantidade_liberada) as qtde"
	sql = sql & " from dbo.EST_Requisicao _r"
	sql = sql & " inner join EST_RequisicaoProduto _rp on _rp.codRequisicao = _r.codigo"
	sql = sql & " inner join EST_Produto _p on _p.CODIGO = _rp.codProduto and _p.COD_EMPRESA = _r.codEmpresa"
	sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante"
	sql = sql & " inner join EST_DEPARTAMENTO _d on _d.CODIGO = _u.codDepartamento"
	sql = sql & " inner join SEG_empresa _e on _e.CODIGO = _d.COD_EMPRESA"
	sql = sql & " where _r.codSituacao = 4"
	sql = sql & " and _r.codEmpresa = " & Session("CodEmpresa")
	if intCodProduto <> "0" then
		sql = sql & " and _rp.codProduto = " & intCodProduto
	end if
	if intCodUnidade <> "0" then
		sql = sql & " and _u.codDepartamento = " & intCodUnidade
	end if
	IF Session("CodSecao")<>"0" THEN
		sql = sql & " and _p.COD_SECAO = "& Session("CodSecao")
	END IF	
	sql = sql & " and _r.data_liberacao >='" & formataDataBD(strDataI) & " 00:00:00' and _r.data_liberacao <='" & formataDataBD(strDataF) & " 23:59:59'"
	sql = sql & " group by _e.NomeFantazia, _d.DESCRICAO, _u.nome, _r.dataEntrada, convert(varchar,_r.data_liberacao,103), _rp.codProduto, _p.descricao_abreviada"
	sql = sql & " Order by _e.NomeFantazia,_d.DESCRICAO,4 "
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
                 <tr>
                    <td class="celula"><%=rs("empresa")%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("departamento"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("solicitante"))%>&nbsp;</td>
                    <td class="celula" align="center"><%=formataDataAP(trim(rs("dataSolicitacao")))%>&nbsp;</td> 
                    <td class="celula" align="center"><%=trim(rs("data"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("produto"))%>&nbsp;</td>
                    <td class="celula" align="right"><%=trim(rs("qtde"))%>&nbsp;</td> 
                  </tr>
			<%
			intTotal = intTotal + rs("qtde")
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
			<td colspan="6" align="right" class="celula"><strong>Total&nbsp;&nbsp;</strong></td>
			<td class="celula" align="right"><strong><%=intTotal%></strong>&nbsp;</td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="7" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font><br><br><br><br></td>
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