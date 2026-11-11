<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 05/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Relatorio - Comunicado de Documentação em Debito
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<br>
<%
	dim intPagina
	
	strTituloRelatorio  	= "Comunicado de Documentação em Débito"
	strCod_empresa 			= Session("CodEmpresa")
	strCodFunc				= Trim(Request("txtCodFunc"))
	
	if strCodFunc = "" then
		strCodFunc			=	Trim(Request.form("chkFunc"))
	end if
	%>
	<!--#include file=../../includes/inc_cabecalhoRelatorio.asp-->
	<%
	
	if trim(strCodFunc) <> "" then
	
		sql = " Select distinct Cod_colaborador  "
		sql = sql & " From SRH_COLABORADOR_DOCUMENTACOES  AD "
		sql = sql & " inner JOIN SRH_DOCUMENTACOES Doc ON AD.Cod_documentacoes = Doc.Codigo "
		sql = sql & " Where AD.Cod_colaborador in (" & strCodFunc & ")"
		sql = sql & " and (AD.situacao = 'I' or AD.situacao is null)"
		
		rs.open sql, cnn
		
		if rs.eof = false then
		
		while not rs.eof
		
			intCodFunc = rs("Cod_colaborador")
			intCodColaborador = rs("Cod_colaborador")
			%>
	<!--#include file="../includes/inc_sqlDadosColaborador.asp"-->
	<hr size="1">
	<table width="100%" border="0">
			<tr>
			<td height="224" align="center">
			<table width="93%" border="0">
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">Senhor(a) Colaborador(a), </td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">Comunicamos a V. S&ordf; que seu cadastro nessa institui&ccedil;&atilde;o ainda se encontra irregular, por falta do(s) seguintes(s) documentos: </td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">
				<%
				if strCodFunc <> "" then	%>
				
				  <table width="87%" align="center" border="0" cellpadding="0" cellspacing="0">
				   <%
					sql = " Select Cod_colaborador, Cod_documentacoes, data_prorrogacao, situacao, doc.descricao "
					sql = sql & " From SRH_COLABORADOR_DOCUMENTACOES  AD "
					sql = sql & " inner JOIN SRH_DOCUMENTACOES Doc ON AD.Cod_documentacoes = Doc.Codigo "
					sql = sql & " Where AD.Cod_colaborador = " & intCodFunc
					sql = sql & " and situacao = 'I'"
					rsAux.open sql, cnn
			
					if rsAux.eof = false then
						
						while not rsAux.eof
							%>
							<tr>
								<td width="6%" height="24" align="center">* </td>
								<td width="94%"><strong><%=rsAux("descricao")%>&nbsp;</strong></td>
							</tr>
							<%
							rsAux.movenext
							wend
					end if 
					rsAux.close
				end if
				%>
				 </table>
				 <br>
			    </td>
			  </tr>
				  <tr>
					<td class="textoRelatorio">Toda documenta&ccedil;&atilde;o acima citada dever&aacute; ser apresentada em DUAS C&Oacute;PIAS E O ORIGINAL, que ser&aacute; devolvido ap&oacute;s confer&ecirc;ncia junto a Secretaria Geral.</td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">&nbsp;</td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">A n&atilde;o regulariza&ccedil;&atilde;o na Secretaria Geral, no prazo de 72 (setenta e duas ) horas a contar do recebimento desta, implicar&aacute; em san&ccedil;&otilde;es de natureza administrativas. </td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">&nbsp;</td>
				  </tr>
			  </table>
			  </td>
	  </tr>
	</table>
			<!--#include file="../includes/inc_RepresentantesLegaisDiretoria.asp"-->
			<pre></pre>	
			
			<%
			rs.movenext
			if not rs.eof  then
			%>
				<!--#include file=../../includes/inc_cabecalhoRelatorio.asp-->
			<%
			end if
			
		wend
		else
		%>
		<script>
			alert("Não existe documentos em débito.")
			window.history.back()
		</script>
		
		<%
		end if 
		rs.close
	end if
		%>
</body>
</html>