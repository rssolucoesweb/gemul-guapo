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
<title><%=session("Titulo")%> - Candidatos </title>
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
	
	intCodVestibular        	= Trim(Request.Form("cmbVestibular"))
	intTipoProcesso				= Trim(Request("cmbTipoProcesso"))
	strAnoLetivo 			    = Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			    = Trim(Request.Form("cmbSemestre"))
	intCodCursoPrimeiraOpcao	= Trim(Request("cmbCursoPrimeiraOpcao"))
	intCodTurnoPrimeiraOpcao	= Trim(Request("cmbTurnoPrimeiraOpcao"))
	strOrdem        	        = Trim(Request.Form("cmbOrdem"))
	strSituacaoFinanceira       = Trim(Request.Form("cmbSituacaoFinanceira"))
	strLetraInicial         	= Trim(Request.Form("txtLetraInicial"))
	strLetraFinal           	= Trim(Request.Form("txtLetraFinal"))
	strDescricao           		= " "
	
	strTurnoDescricao          	= Trim(Request.Form("txtTurnoDescricao"))
	strCursoDescricao          	= Trim(Request.Form("txtCursoDescricao"))

	sql = "SELECT Descricao"
	sql = sql & " FROM SCA_VESTIBULAR"
    sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and Codigo = " & intCodVestibular 
	rs.open sql, cnn
	if rs.eof = false then
	   while not rs.eof
	     strDescricao = trim(rs("Descricao"))
	     rs.movenext
       wend
	end if
	rs.close
	strTituloRelatorio  	= strDescricao  & "<BR>" & strCursoDescricao & " " &strTurnoDescricao
	
	sub mostraCabecalho()
%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="11%" class="celula"><div align="center"><strong>Inscri&ccedil;&atilde;o</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Identidade</strong></div></td>
		<td width="17%" class="celula"><div align="center"><strong>Org&atilde;o Expedidor </strong></div></td>
		<td width="5%" class="celula"><div align="center"><strong>UF</strong></div></td>
		<td width="52%" class="celula"><div align="center"><strong>Nome do Candidato </strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = "SELECT VD.Codigo, VD.NomeAluno, VD.Identidade, VD.OrgaoExpedidor, VD.UFExpedidor, VD.DataNascimento, VD.DataInscricao, VD.Cod_Vestibular "
	sql = sql & " FROM SCA_VESTIBULAR_DADOS VD "
	sql = sql & " INNER JOIN SCA_VESTIBULAR V ON V.Codigo = VD.Cod_Vestibular "
	sql = sql & " where VD.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and  V.Ano_letivo = " & strAnoLetivo
	sql = sql & " and  V.Semestre = " & intSemestre
	if intCodVestibular	<> "0" then
		sql = sql & " and VD.Cod_Vestibular = " & intCodVestibular
	end if	
	if strSituacaoFinanceira = "PG" then
		sql = sql & " and VD.cod_situacao_pagamento <> 1 "
	elseif strSituacaoFinanceira = "DV"	then
		sql = sql & " and VD.cod_situacao_pagamento = 1 "
	end if	
	if intCodTurnoPrimeiraOpcao <> "0" then
		sql = sql & " and VD.cod_turnoprimeiraopcao = " & intCodTurnoPrimeiraOpcao
	end if	
	if intCodCursoPrimeiraOpcao <> "0" then
		sql = sql & " and VD.cod_cursoprimeiraopcao = " & intCodCursoPrimeiraOpcao
	end if	
	if strLetraInicial <> "" and strLetraFinal <> "" then
	   sql = sql & " and SUBSTRING(VD.NomeAluno,1,1) >= '" & strLetraInicial & "'"
	   sql = sql & " and SUBSTRING(VD.NomeAluno,1,1) <= '" & strLetraFinal & "'"
	end If 
	if intTipoProcesso <> "0" then
		sql = sql & " and V.TipoProcesso = " & intTipoProcesso
	end if	
	'ordem de classificação do relatorio
	if strOrdem = "alfabetica" then
	   sql = sql & " order by NomeAluno"
	elseif strOrdem = "inscricao" then
	   sql = sql & " order by codigo"
	elseif strOrdem = "datainscricao" then
	   sql = sql & " order by DataInscricao"
	elseif strOrdem = "datanascimento" then
	   sql = sql & " order by DataNascimento"
	end if
    
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td class="celula" align="left"><%=rs("Codigo")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("Identidade")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("OrgaoExpedidor")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("UFExpedidor")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("NomeAluno")%></td>
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
		  <tr>
			<td colspan="5" class="celula">Quantidade de Candidatos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="5" class="celula" align="center"><p><br>
		      </p>
			  <p>&nbsp;</p>
			  <p><br>
		        <br>
		        <br>
		        <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
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
