<%
response.Expires=1440
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
'strPaginaDestino = "rel_Comparativoproduto_con.asp"
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
	strOrdem = request("cmbOrdem")
	strDataI = request("txtDataI")
	strDataF = request("txtDataF")
	
	intCodProduto = request("cmbProduto")
	if intCodProduto = "" then intCodProduto = "0"
	
	intCodUnidade = request("cmbEmpresa")
	if intCodUnidade = "" then intCodUnidade = "0"

	strTipo			 = request("cmbTipo")
	if strTipo = "" then strTipo = "0"
	
	dim intPagina
	strTituloRelatorio  	= "Relatório Consumo (Percapta) das Escolas"
	strTituloRelatorio 		= strTituloRelatorio & "<br>" &  strDataI & " a " & strDataF

	sub mostraCabecalho()
	%>
	<!--#include file="../../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
      <tr bgcolor="#E5E5E5">
        <td width="20%" rowspan="2" align="center" class="celula"><strong>Unidade Escolar<span class="TextoForm"></span></strong></td>
        <td width="10%" rowspan="2" align="center" class="celula"><strong>Alunos<span class="TextoForm"></span></strong></td>
        <td colspan="2" align="center" class="celula"><strong>Consumo</strong></td>
      </tr>
      <tr bgcolor="#E5E5E5">
        <td width="10%" align="center" class="celula"><strong>Total</strong></td>
        <td width="10%" align="center" class="celula"><strong>Per Capta</strong></td>
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
  	
	sql = "delete EST_ALUNOS"
	cnn.execute sql
	
	sql = "insert EST_ALUNOS"
	sql = sql & " SELECT A.COD_EMPRESA, COUNT(A.CODIGO) as qtde "
	sql = sql & " FROM aparecida.dbo.SCA_ALUNO A INNER JOIN aparecida.dbo.SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA WHERE A.COD_EMPRESA = SA.COD_EMPRESA AND (SA.Desc_SituacaoAluno = 'ATIVO') AND A.COD_EMPRESA IN ( SELECT codigo FROM aparecida.dbo.SEG_EMPRESA WHERE COD_GRUPO = 7 ) GROUP BY A.COD_EMPRESA"
	cnn.execute sql

	'if trim(strCodProd) <> trim(rs("codProduto")) then
	sql = "select _d.DESCRICAO as departamento, _rp.codProduto, _p.descricao as produto, "
	sql = sql & " sum(_rp.quantidade_liberada) as qtde,  "
	sql = sql & " isnull(_a.QTDE,0) AS ALUNOS "
	'sql = sql & "  cast(isnull(sum(_rp.quantidade_liberada),0) as float)/ cast(isnull(_a.QTDE,0) as float) as percapta  "
	sql = sql & " from dbo.EST_Requisicao _r "
	sql = sql & " inner join EST_RequisicaoProduto _rp on _rp.codRequisicao = _r.codigo "
	sql = sql & " inner join EST_Produto _p on _p.CODIGO = _rp.codProduto and _p.COD_EMPRESA = _r.codEmpresa "
	sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante "
	sql = sql & " inner join EST_DEPARTAMENTO _d on _d.CODIGO = _u.codDepartamento "
	sql = sql & " inner join SEG_empresa _e on _e.CODIGO = _d.COD_EMPRESA "
	sql = sql & " left join EST_ALUNOS _a on _a.COD_DEPARTAMENTO = _d.CODIGO "
	sql = sql & " where _r.codSituacao = 4"
	sql = sql & " and _r.codEmpresa = " & Session("CodEmpresa")
	
	if intCodProduto <> "0" then
		sql = sql & " and _rp.codProduto = " & intCodProduto
	end if
	
	IF Session("CodSecao")<>"0" THEN
		sql = sql & " and _p.COD_SECAO = "& Session("CodSecao")
	END IF		
	
	sql = sql & " and _r.data_liberacao >='" & formataDataBD(strDataI) & " 00:00:00' and _r.data_liberacao <='" & formataDataBD(strDataF) & " 23:59:59'"
	
	if trim(strTipo) <> "0" then
		sql = sql & " and _d.tipo = '" & strTipo & "'"
	end if
	
	sql = sql & " group by _d.DESCRICAO, _rp.codProduto, _p.descricao, _a.QTDE"
	
	if strOrdem = "1" then
		sql = sql & " Order by 3,5 desc,1,2 "
	else
		sql = sql & " Order by 3,1,2"
	end if
	TotalAlunos = 0
	rs.open sql, cnn
	if not rs.eof then
		strCodProd = ""
		While not rs.eof
			if trim(strCodProd) <> trim(rs("codProduto")) then
			%>
			<tr>
				<td class="celula" colspan="4" align="center"><strong><%=trim(rs("produto"))%></strong></td> 
			</tr>
			<% 
			end if
			if rs("qtde")<>0 and rs("alunos")<>0 then
				percapta = rs("qtde")/rs("alunos")
			else
				percapta = 0
			end if
			
			TotalAlunos  =  TotalAlunos + cint(rs("alunos"))
			TotalQtde = TotalQtde  + rs("qtde")
			TotalPercapta = TotalPercapta + percapta
			%>
                 <tr>
                   <td class="celula"><%=trim(rs("departamento"))%></td>
                   <td align="right" class="celula"><%=trim(rs("alunos"))%></td>
                   <td class="celula" align="right"><%=trim(rs("qtde"))%></td>
                   <td class="celula" align="right"><%=trim(formatNumber(percapta,3))%></td>
                 </tr>
                 
			<%
			intQuantRegistroImpresso = intQuantRegistroImpresso + 1
			strCodProd = rs("codProduto")
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
                <tr bgcolor="#E5E5E5">
                  <td class="celula"><strong>Total Escola: <%=cont%></strong></td>
                  <td align="right" class="celula"><strong><%=TotalAlunos%></strong></td>
                  <td align="right" class="celula"><strong><%=TotalQtde%></strong></td>
                  <td align="right" class="celula"><strong><%=trim(formatNumber(TotalPercapta,3))%></strong></td>
                </tr>
        <tr bgcolor="#E5E5E5">
                    <td class="celula"><strong>Total Media: <%=trim(formatNumber(TotalQtde / TotalAlunos,3))%> </strong></td>
          <td align="right" class="celula">&nbsp;</td>
          <td align="right" class="celula">&nbsp;</td>
          <td align="right" class="celula">&nbsp;</td> 
      </tr>
		 <%
	else
		%>
		  <tr>
			<td height="24" colspan="4" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font><br>
	        <br></td>
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