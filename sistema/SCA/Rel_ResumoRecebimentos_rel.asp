<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 07/04/2009
	::	Desenvolvedores...: Sérgio - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio de Recebimentos
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script><style type="text/css">
<!--
.style1 {font-weight: bold}
-->
</style></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<br>
<%
	strDataAP					= request.Form("txtData")
	strTituloRelatorio  	    = "RESUMO DE RECEBIMENTOS EM: " & strDataAP 
	strUsuarioIncl     		    = trim(session("usuarioWeb"))

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<div align="center" bgcolor="#E5E5E5"><strong>Recebimento - Mensalidades e Taxas </strong></div>
<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
  <tr bgcolor="#E5E5E5"> 
    <td width="4%" height="14" align="center" class="celulaextrato"><strong>Doc. n.</strong></td>
    <td width="9%" align="center" class="celulaextrato"><strong>Matr&iacute;cula</strong></td>
    <td width="16%" align="center" class="celulaextrato"><strong>Nome do Aluno</strong></td>
    <td width="8%" align="center" class="celulaextrato"><strong>Parcela</strong></td>
    <td width="5%" align="center" class="celulaextrato"><strong>Ano</strong></td>
    <td width="14%" align="center" class="celulaextrato"><strong>Tipo de Parcela</strong></td>
    <td width="13%" align="center" class="celulaextrato"><strong>Origem da Baixa</strong></td>
    <td width="10%" align="center" class="celulaextrato"><strong>Valor Pago</strong></td>
    <td width="11%" align="center" class="celulaextrato"><strong>Multas</strong></td>
    <td width="9%" align="center" class="celulaextrato"><strong>Mora</strong></td>
  </tr>
  <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina 		= 1
	mostraCabecalho
	cont 			= 0
	sql = " select d.codigo, a.matricula, a.nomealuno, d.parcela, d.ano ,tp.desc_tipo, d.ValorTotalPago, d.Tipo_Baixa, d.MultaPago, d.MoraPago"
	sql = sql & " from SCF_DEBITOALUNO d"
	sql = sql & " left join SCA_ALUNO a on a.codigo = d.cod_aluno and a.cod_empresa = d.cod_empresa"
	sql = sql & " left join SCF_TipoParcela tp on tp.cod_tipo = d.Cod_TipoParcela and tp.cod_empresa = d.cod_empresa"
	sql = sql & " Where d.Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " and cod_situacao_pagamento = 2" 'pago
	sql = sql & " and convert(varchar, dataPagamento, 103) = '" & strDataAP & "'"
	sql = sql & " and Usua_Codg = '" & strUsuarioIncl & "'" 'Somente o usuario da sessão
	sql = sql & " and CaixaFechamento is null" 'Somente os recebimentos que ainda não foram fechados
	sql = sql & " order by d.dataPagamento"
	rs.open sql, cnn
	if not rs.eof then 
	   strMensagemFechamento="Caixa FECHADO com SUCESSO."
		While not rs.eof 
		  if isnull(rs("MultaPago")) then 
		     strMulta = 0
		  else	 
		     strMulta = rs("MultaPago")
		  end if	 
		   if isnull(rs("MoraPago")) then 
		     strMora = 0
		  else	 
		     strMora = rs("MoraPago")
		  end if	 
	      %>
			<tr > 
			<td height="20" align="left" class="celulaextrato"><%=rs("codigo")%></td>
			<td align="left" class="celulaextrato">&nbsp;<%=rs("matricula")%></td>
			<td class="celulaextrato">&nbsp;<%=rs("nomealuno")%></td>
			<td class="celulaextrato">&nbsp;<%=rs("parcela")%></td>
			<td class="celulaextrato">&nbsp;<%=rs("Ano")%></td>
			<td class="celulaextrato">&nbsp;<%=rs("desc_tipo")%></td>
			<td class="celulaextrato"><%=rs("Tipo_Baixa")%> </td>
			<td class="celulaextrato">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			  <%=formatnumber(rs("ValorTotalPago"),2)%> 
			  <div align="right"></div>
			  <div align="right"></div>
			  <div align="left"></div></td>
			<td class="celulaextrato">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			  <%=formatnumber(strMulta,2)%> 
			  <div align="right"></div>
			  <div align="left"></div></td>
			 <td class="celulaextrato"> <p align="right"><%=formatnumber(strMora,2)%></p></td>
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
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		strMensagemFechamento="Não há registros para fechamento deste Caixa"
		%>
        <tr> 
        <td height="123" colspan="10" align="center" class="celulaextrato"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
        </tr>
  <%
	end if
	rs.close
    %>
</table>
<div align="center" class="textoCabecalho">
<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		  <tr bgcolor="#E5E5E5">
		    <td colspan="7" class="celulaextrato"><div align="center"><strong>Recebimento - Processo Seletivo </strong></div></td>
		  </tr>
		  <tr bgcolor="#E5E5E5">
			<td width="13%" class="celulaextrato"><div align="center"><strong>N.Doc / </strong><strong>Inscri&ccedil;&atilde;o</strong></div></td>
			<td width="25%" class="celulaextrato"><div align="center"><strong>Nome do Aluno </strong></div></td>
			<td width="12%" class="celulaextrato"><div align="center"><strong>Valor Inscri&ccedil;&atilde;o</strong></div></td>
			<td width="14%" class="celulaextrato"><div align="center"><strong>Origem da Baixa </strong></div></td>
			<td width="11%" class="celulaextrato"><div align="center"><strong>Valor Pago</strong></div></td>
			<td width="14%" class="celulaextrato"><div align="center"><strong>Multas</strong></div></td>
			<td width="11%" class="celulaextrato"><div align="center"><strong> Mora </strong></div></td>
    </tr>
			<%
			sql = " select "
			sql = sql & " CODIGO,"
			sql = sql & " NOMEALUNO,"
			sql = sql & " VALOR,"
			sql = sql & " TIPO_BAIXA,"
			sql = sql & " VALORPAGAMENTO,"
			sql = sql & " MULTA,"
			sql = sql & " MORA"
			sql = sql & " from SCA_VESTIBULAR_DADOS"
			sql = sql & " WHERE cod_situacao_pagamento = 2" 'pago
		    sql = sql & " and Cod_Empresa = " & Session("CodEmpresa")
	        sql = sql & " and convert(varchar, dataPagamento, 103) = '" & strDataAP & "'"
	        sql = sql & " and Usua_Codg = '" & strUsuarioIncl & "'" 'Somente o usuario da sessão
	        sql = sql & " and CaixaFechamento is null" 'Somente os recebimentos que ainda não foram fechados
	        sql = sql & " order by dataPagamento"
			rs.open sql, cnn
			if rs.eof = false then
				intTotalValorPagamento 	= 0
				while not rs.eof
				    strMensagemFechamento="Caixa FECHADO com SUCESSO."
					ValorTotalPago = ""
					if not isnull(rs("ValorPagamento")) then
						ValorTotalPago = formatnumber(rs("ValorPagamento"),2)
					end if
					if isnull(rs("Valor")) then
						valorParcela 		= "0,00"
					else
						valorParcela 		= formatnumber(rs("Valor"),2)
					end if
					if isnull(rs("Multa")) then
						valorMultaPago 		= "0,00"
					else
						valorMultaPago 		= formatnumber(rs("Multa"),2)
					end if
					if isnull(rs("Mora")) then
						valorMoraPago 		= "0,00"
					else
						valorMoraPago 		= formatnumber(rs("Mora"),2)
					end if
				%>
					  <tr  height="20">
						<td class="celulaextrato" align="center"><%=rs("CODIGO")%></td>
						<td class="celulaextrato" align="center"><%=rs("NOMEALUNO")%></td>
						<td class="celulaextrato" align="right"><%=formatNumber(rs("VALOR"),2)%>&nbsp;</td>
						<td class="celulaextrato" align="center"><%=rs("TIPO_BAIXA")%>&nbsp;</td>
						<td class="celulaextrato" align="right"><strong><%=ValorTotalPago%></strong>&nbsp;</td>
						<td class="celulaextrato" align="center"><%=valorMultaPago%></td>
						<td class="celulaextrato" align="center"><%=valorMoraPago%></td>
					</tr>
						<%			
					
						if not isnull(rs("ValorPagamento")) then
							intTotalValorPagamento = intTotalValorPagamento + rs("ValorPagamento")
						end if
					rs.movenext
				wend %>
				  <tr  bgcolor="#E5E5E5">
					<td colspan="2" align="center" class="celulaextrato">&nbsp;</td>
					<td align="right" class="celulaextrato">&nbsp;</td>
					<td class="celulaextrato">&nbsp;</td>
					<td align="right" class="celulaextrato"><strong>&nbsp;</strong></td>
					<td align="center" class="celulaextrato"><strong>Totais</strong>.................</td>
					<td align="center" class="celulaextrato"><strong><%=formatNumber(intTotalValorPagamento,2)%></strong></td>
		            </tr>
		    <%else 
			        strMensagemFechamento="Não há registros para fechamento deste Caixa"
			        %>
				   <tr>
                   <td height="123" colspan="10" align="center" class="celulaextrato"> <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		         </tr>
<%end if 
			rs.close
		    %>
		</table>

</div>
<br>
<%
	sql = " select tp.descricao, sum(d.ValorTotalPago) as pago"
	sql = sql & " from SCF_DEBITOALUNO d"
	sql = sql & " left join SCF_TipoPagamento tp on tp.codigo = d.Cod_TipoPagamento"
	sql = sql & " Where d.Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " and cod_situacao_pagamento = 2" 'pago
	sql = sql & " and convert(varchar, dataPagamento, 103) = '" & strDataAP & "'"
	sql = sql & " and Usua_Codg = '" & strUsuarioIncl & "'" 'Somente o usuario da sessão 
	sql = sql & " and CaixaFechamento is null" 'Somente os recebimentos que ainda não foram fechados
	sql = sql & " group by codigo "
	rs.open sql, cnn
	if not rs.eof then 
		%>
<div align="center" class="textoCabecalho"><strong>FECHAMENTO DO CAIXA - <%=strDataAP%></strong></div>
		<br>
		<table width="50%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
		  <tr bgcolor="#CCCCCC">
			<td height="14" colspan="2" align="center" class="celulaextrato"><strong>Recebimentos</strong></td>
		  </tr>
		  <tr bgcolor="#CCCCCC">
			<td width="22%" align="center" class="celulaextrato"><strong>Tipo de Pagamento</strong></td>
			<td width="14%" height="14" align="center" class="celulaextrato"><strong>Valor Total</strong></td>
		  </tr>
		<%
		While not rs.eof 
			%>
			  <tr >
				<td class="celulaextrato">&nbsp;<strong><%=ucase(rs("descricao"))%></strong>&nbsp;</td>
				<td align="right" class="celulaextrato">&nbsp;<strong><%=formatnumber(rs("pago"),2)%></strong>&nbsp;</td>
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
			rs.movenext
		wend
		%>
		<tr >
		<td class="celulaextrato">&nbsp;<strong>PROCESSO SELETIVO</strong></td>
		<td align="right" class="celulaextrato"><strong><%=formatNumber(intTotalValorPagamento,2)%></strong>&nbsp;</td>
		</tr>
	
		</table>
<p>&nbsp;</p>
        <p><br>
            <br>
            <br>
            <!--#include file="../includes/inc_RepresentantesLegaisFinanceiro.asp"-->
<%
	end if
	rs.close
	
	sql = " update SCF_DEBITOALUNO set CaixaFechamento = 'S'" 
	sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " and cod_situacao_pagamento = 2" 'pago
	sql = sql & " and convert(varchar, dataPagamento, 103) = '" & strDataAP & "'"
	sql = sql & " and Usua_Codg = '" & strUsuarioIncl & "'" 'Somente o usuario da sessão fecha o seu caixa
	sql = sql & " and CaixaFechamento is null" 'Somente os recebimentos que ainda não foram fechados
	cnn.execute sql
	GravarLog sql
	
	sql = " update SCA_VESTIBULAR_DADOS set CaixaFechamento = 'S'" 
	sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " and cod_situacao_pagamento = 2" 'pago
	sql = sql & " and convert(varchar, dataPagamento, 103) = '" & strDataAP & "'"
	sql = sql & " and Usua_Codg = '" & strUsuarioIncl & "'" 'Somente o usuario da sessão fecha o seu caixa
	sql = sql & " and CaixaFechamento is null" 'Somente os recebimentos que ainda não foram fechados
	cnn.execute sql
	GravarLog sql

%>
    <script>
	   aguarde.style.display="none";
    </script>
    <script>
       alert("ATENÇÃO! \n<%=strMensagemFechamento%>");
    </script>
</p>
</body>
</html>
