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

<br>
<%
	dim intPagina
	
	strTituloRelatorio  	= "DOCUMENTAÇÕES SOLICITADAS PELA SECRETARIA"
	strCod_empresa 			= Session("CodEmpresa")
	
	%>
	<!--#include file=../../includes/inc_cabecalhoRelatorio.asp-->
	<%
	
	if trim(Session("CodSeguranca")) <> "" then
	
		sql = " Select distinct Cod_aluno  "
		sql = sql & " From SCA_ALUNO_DOCUMENTACOES  AD "
		sql = sql & " inner JOIN SCA_DOCUMENTACOES Doc ON AD.Cod_documentacoes = Doc.Codigo "
		sql = sql & " Where AD.Cod_aluno = " & trim(Session("CodSeguranca"))
		sql = sql & " and (AD.situacao = 'I' or AD.situacao is null)"
		rs.open sql, cnn
		
		if rs.eof = false then
		
		while not rs.eof
		
			intCodAluno = rs("Cod_aluno")
			%>
	<!--#include file="../includes/inc_sqlDadosAluno.asp"-->
	<hr size="1">
	<table width="100%" border="0">
			<tr>
			<td height="224" align="center">
			<table width="93%" border="0">
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">Senhor(a) Aluno(a), </td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">Comunicamos a V. S&ordf; que sua matr&iacute;cula nessa institui&ccedil;&atilde;o ainda se encontra irregular, por falta do(s) seguintes(s) documentos: </td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">
				<%
				if trim(Session("CodSeguranca")) <> "" then	%>
				
				  <table width="87%" align="center" border="0" cellpadding="0" cellspacing="0">
				   <%
					sql = " Select Cod_aluno, Cod_documentacoes, data_prorrogacao, situacao, doc.descricao "
					sql = sql & " From SCA_ALUNO_DOCUMENTACOES  AD "
					sql = sql & " inner JOIN SCA_DOCUMENTACOES Doc ON AD.Cod_documentacoes = Doc.Codigo "
					sql = sql & " Where AD.Cod_aluno = " & intCodAluno
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
					<td class="textoRelatorio">Toda documenta&ccedil;&atilde;o acima citada dever&aacute; ser apresentada  juntamente com ORIGINAL, que ser&aacute; devolvido ap&oacute;s confer&ecirc;ncia junto a Secretaria Geral.</td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">&nbsp;</td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">A n&atilde;o regulariza&ccedil;&atilde;o na Secretaria Geral, implicar&aacute; em san&ccedil;&otilde;es de natureza administrativas. </td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">&nbsp;</td>
				  </tr>
			  </table>
			  </td>
	  </tr>
	</table>
			
			<%
			rs.movenext
			
		wend
	else
		%>
		<script>
			alert("NADA CONSTA. Todos os documentos pessoais exigidos já foram entregue a secretaria. ")
			window.history.back()
		</script>
		
		<%
		end if 
		rs.close
	end if
		%>
</body>
</html>