<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>Vaga</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	intCodGrupo				= Session("CodGrupo") 		
	strAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
	intCodRota 				= Trim(Request.Form("cmbRota"))
	
	strTituloRelatorio  	= "Transporte Escolar " & strAnoLetivo & " <br> Vagas"
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td width="30%" rowspan="2" align="left" class="celula"><strong>Rota</strong></td>

		<td width="5%" colspan="3" align="center" class="celula"><strong>Capacidade</strong></td>
		<td width="5%" colspan="3" align="center" class="celula"><strong>Reserva</strong></td>
		<td width="5%" colspan="4" align="center" class="celula"><strong>Alocado</strong></td>
		<td width="5%" colspan="3" align="center" class="celula"><strong>Vaga</strong></td>

	  </tr>
	  <tr bgcolor="#CCCCCC">

		<td width="5%" align="center" class="celula"><strong>Matutino</strong></td>
		<td width="5%" align="center" class="celula"><strong>Vespertino</strong></td>
		<td width="5%" align="center" class="celula"><strong>Noturno</strong></td>

		<td width="5%" align="center" class="celula"><strong>Matutino</strong></td>
		<td width="5%" align="center" class="celula"><strong>Vespertino</strong></td>
		<td width="5%" align="center" class="celula"><strong>Noturno</strong></td>

		<td width="5%" align="center" class="celula"><strong>Matutino</strong></td>
		<td width="5%" align="center" class="celula"><strong>Vespertino</strong></td>
		<td width="5%" align="center" class="celula"><strong>Noturno</strong></td>
		<td width="5%" align="center" class="celula"><strong><font color="red">Sem Turno*</font></strong></td>
		
		<td width="5%" align="center" class="celula"><strong>Matutino</strong></td>
		<td width="5%" align="center" class="celula"><strong>Vespertino</strong></td>
		<td width="5%" align="center" class="celula"><strong>Noturno</strong></td>
		
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	sql = " exec [SP_STE_Rel_rotas_vagas] " & strAnoLetivo & "," & intCodRota
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			
			%>
			  <tr>
				<td class="celula" align="left"><%=rs("rota")%>&nbsp;</td>
				
				<td class="celula" align="center"><%=rs("capacidade_matutino")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("capacidade_vespertino")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("capacidade_noturno")%>&nbsp;</td>

				<td class="celula" align="center"><%=rs("reservado_matutino")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("reservado_vespertino")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("reservado_noturno")%>&nbsp;</td>

				<td class="celula" align="center"><%=rs("alocado_matutino")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("alocado_vespertino")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("alocado_noturno")%>&nbsp;</td>
				<td class="celula" align="center"><font color="red"><%=rs("alocado_sem_turno")%>&nbsp;</font></td>
				
				<td class="celula" align="center"><%=rs("vagas_matutino")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("vagas_vespertino")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("vagas_noturno")%>&nbsp;</td>
			</tr>
			<%
			capacidade_matutino 	= capacidade_matutino 	+ rs("capacidade_matutino")
			capacidade_vespertino 	= capacidade_vespertino + rs("capacidade_vespertino")
			capacidade_noturno 		= capacidade_noturno 	+ rs("capacidade_noturno")

			reservado_matutino 		= reservado_matutino 	+ rs("reservado_matutino")
			reservado_vespertino 	= reservado_vespertino 	+ rs("reservado_vespertino")
			reservado_noturno 		= reservado_noturno 	+ rs("reservado_noturno")

			alocado_matutino 		= alocado_matutino 		+ rs("alocado_matutino")
			alocado_vespertino 		= alocado_vespertino 	+ rs("alocado_vespertino")
			alocado_noturno 		= alocado_noturno 		+ rs("alocado_noturno")
			alocado_sem_turno 		= alocado_sem_turno 		+ rs("alocado_sem_turno")

			vagas_matutino 			= vagas_matutino 		+ rs("vagas_matutino")
			vagas_vespertino 		= vagas_vespertino 		+ rs("vagas_vespertino")
			vagas_noturno 			= vagas_noturno 		+ rs("vagas_noturno")

			cont = cont + 1
			rs.movenext
		wend
		%>
			<tr>
				<td class="celula" align="right"><strong>Total</strong>&nbsp;</td>
				
				<td class="celula" align="center"><strong><%=capacidade_matutino%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><%=capacidade_vespertino%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><%=capacidade_noturno%>&nbsp;</strong></td>

				<td class="celula" align="center"><strong><%=reservado_matutino%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><%=reservado_vespertino%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><%=reservado_noturno%>&nbsp;</strong></td>

				<td class="celula" align="center"><strong><%=alocado_matutino%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><%=alocado_vespertino%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><%=alocado_noturno%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><font color="red"><%=alocado_sem_turno%>&nbsp;</font></strong></td>
				
				<td class="celula" align="center"><strong><%=vagas_matutino%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><%=vagas_vespertino%>&nbsp;</strong></td>
				<td class="celula" align="center"><strong><%=vagas_noturno%>&nbsp;</strong></td>
			</tr>
		  <tr>
			<td colspan="14" bgcolor="#CCCCCC" class="celula">Quantidade de rotas: <strong><%=cont%></strong></td>
		  </tr>
		  <tr>
			<td colspan="14" bgcolor="#CCCCCC" class="celula"><font color="red">* Caso existir alunos alocado sem turno, não serão considerados nas vagas.</font></strong></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td height="10" colspan="14" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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