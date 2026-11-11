<%
response.Expires=0
'N�o armazena a p�gina em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	strlpp							= 50
	
	intCodEmpresa					= session("codEmpresa")
	strDataI						= formatadataAP(request.Form("txtDataI"))
	strDataF						= formatadataAP(request.Form("txtDataF"))
	intCodEmpresaChamado			= Trim(Request.Form("cmdEmpresaChamado"))
	strResponsavelAbertura			= Trim(Request.Form("UsuarioWeb"))
	intCodUsuarioChamado			= Trim(Request.Form("cmbUsuarioChamado"))
	srtSituacao						= Trim(Request.Form("cmbSituacao"))
	strPrioridade					= Trim(Request.Form("cmbPrioridade"))
	strclasse						= "celula"


	if strDataI <> "" and  strDataF <> "" then
	   msgPeriodo = strDataI & " a " & strDataF
	else
	   msgPeriodo = "Todos os Registros"
	end if   
	
	strTituloRelatorio  			= "Relatório e Chamados - " & msgPeriodo

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="5%" class="<%=strclasse%>"><div align="center"><strong>Num.</strong></div></td>
		<td width="5%" class="<%=strclasse%>"><strong>Dt.Chamado</strong></td>
		<td width="7%" class="<%=strclasse%>"><strong>Criado por:</strong></td>
        <% if Session("UsuarioMaster") = "S" then %>
			<td width="7%" class="<%=strclasse%>"><strong>Encaminhado para:</strong></td>
        <% end if %>
		<td width="26%" class="<%=strclasse%>"><strong><strong>Ocorr&ecirc;ncia</strong></strong></td>
		<td width="3%" class="<%=strclasse%>"><strong>Prior.</strong></td>
		<td width="29%" class="<%=strclasse%>"><strong>Parecer T&eacute;cnico</strong></td>
		<td width="5%" class="<%=strclasse%>"><strong>Situa&ccedil;&atilde;o</strong></td>
		<td width="12%" class="<%=strclasse%>" align="center"><strong>Data do Andamento</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	intCodTurma = 0

	sql = "SELECT Codigo, Cod_empresa, DataAbertura, Ocorrencias, "
	sql = sql & " Cod_Usuario_Abertura, Cod_Usuario_Destino, Situacao, Prioridade, observacao, dataAndamento "
	sql = sql & " FROM SCH_CHAMADO "
	sql = sql & " WHERE 1=1"

   	if strDataI <> "" and  strDataF <> "" then
	 	sql = sql & " and convert(datetime,convert(varchar, DataAbertura, 103),103) >=  convert(datetime, '" & strDataI & "',103)"
	 	sql = sql & " and convert(datetime,convert(varchar, DataAbertura, 103),103) <=  convert(datetime, '" & strDataF & "',103)"
   	end if	  
	
	if intCodUsuarioChamado <> "0" then
		sql = sql & " And Cod_Usuario_Destino = '" & intCodUsuarioChamado & "'" 
	end if

	if srtSituacao <> "0" then
		sql = sql & " And Situacao = '" & srtSituacao & "'"
	end if
	
	if strPrioridade <> "0" then
		sql = sql & " And Prioridade = '" & strPrioridade & "'"
	end if
	
	sql = sql & "Order by Codigo desc"
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		
			if trim(RS("Prioridade")) = "A" then
				strPrioridade = "Alta"
			end if
			
			if trim(RS("Prioridade")) = "B" then
				strPrioridade = "Baixa"
			end if
			
			if trim(RS("Prioridade")) = "M" then
				strPrioridade = "Media"
			end if
			
			if trim(RS("Situacao")) = "A" then
				strSituacao = "Ativo"
			end if
			
			if trim(RS("Situacao")) = "F" then
				strSituacao = "Fechada"
			end if
			
			if trim(RS("Situacao")) = "P" then
				strSituacao = "Pendente"
			end if
			
			if trim(RS("Situacao")) = "S" then
				strSituacao = "Suspen�a"
			end if
			
			if trim(RS("Situacao")) = "E" then
				strSituacao = "Executada"
			end if
		
			%>
			  <tr>
				<td class="celula" align="left"><strong><%=ZeroLeft(RS("Codigo"),3)%></strong>&nbsp;</td>
				<td class="celula" align="left"><%=formataDataAP(RS("DataAbertura"))%>&nbsp;</td>
				<td class="celula" align="left"><%=RS("Cod_Usuario_Abertura")%>&nbsp;</td>
                <% if Session("UsuarioMaster") = "S" then %>
					<td class="celula" align="left"><%=RS("Cod_Usuario_Destino")%>&nbsp;</td>
                <% end if %>
				<td class="celula" align="left"><%=RS("Ocorrencias")%></td>
				<td class="celula" align="left"><%=strPrioridade%></td>
			    <td align="left" class="celula"><%=RS("observacao")%>&nbsp;</td>
			    <td class="celula" align="left"><%=strSituacao%>&nbsp;</td>
			    <td class="celula" align="left"><%=RS("dataAndamento")%>&nbsp;</td>
			  </tr>
			<%
			
			'quantidade de registros da p�gina
			if int(intQtdeRegistroPorPagina) = int(strlpp) then
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
			<td colspan="10" class="<%=strclasse%>">Quantidade: <%=cont%></td>
	  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="10" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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