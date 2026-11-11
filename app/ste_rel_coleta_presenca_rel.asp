<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>Presença</title>
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
	listar	 				= Trim(Request.Form("listar"))
	if intCodRota <> "" then
		sql="select descricao from ste_rota"
		sql=sql & " where cod_rota = " & intCodRota
		rs.open sql, cnn
		if rs.eof = false then
			strRota = rs("descricao")
		end if
		rs.close
	end if
	strTurno				= Trim(Request.Form("cmbTurno"))
	if strTurno = "0" then strTurno = ""
	intCodEmpresa 			= "0"
	intCodEscolaEstadual 	= "0"
	rede 					= Trim(Request.Form("rede"))
	if rede<>"0" then
		if rede="M" then 
			intCodEmpresa 			= Trim(Request.Form("cmbEmpresa"))
			if intCodEmpresa = "0" or intCodEmpresa = "" then rede = "0"
		elseif rede="E" then 
			intCodEscolaEstadual 	= Trim(Request.Form("cmbEscolaEstadual"))
			if intCodEscolaEstadual = "0" or intCodEscolaEstadual = "" then rede = "0"
		else
			rede = "0"
		end if
	end if
	
	strDataInicial 			= FORMATADATAAP(Trim(Request.Form("txtDataLancamento")))
	strDataInicialBD		= FORMATADATABD(Trim(Request.Form("txtDataLancamento")))
	
	strTituloRelatorio  	= "Transporte Escolar " & strAnoLetivo & " <br> Coleta de Presença da <strong>" & strRota & "</strong>"
	if strDataInicial<>"" then
		strTituloRelatorio  	= strTituloRelatorio & "<br>Data: " & strDataInicial 
	end if
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td width="5%" align="left" class="celula"><strong>Rede</strong></td>
		<td width="35%" align="left" class="celula"><strong>Nome</strong></td>
		<td width="35%" align="left" class="celula"><strong>Escola</strong></td>
		<td width="5%" align="left" class="celula"><strong>Turno</strong></td>
		<td width="5%" align="center" class="celula"><strong>Presente</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	contPresentes = 0
	ssql = "select p.cod_presenca, t.codigo, t.cod_aluno, t.cod_turma, t.turno_estadual, t.codigo_escola_estadual, t.cod_empresa, t.nome, t.obs, t.obs_dda, r.Descricao as rota, t.bairro as setor, em.RAZAOSOCIAL as escola, "
	ssql = ssql & " 	t.cod_rota,ee.nome as escola_estadual,"
	ssql = ssql & " 	t.data_efetivacao, us.USUA_NOME_COMPLETO as usuario_efetivacao, tu.TurmaAluno, tur.desc_turno, t.Situacao"
	ssql = ssql & " 	from ste_solicitacao_transporte t "
	ssql = ssql & " 	left join SEG_EMPRESA em on em.codigo = t.Cod_empresa "
	ssql = ssql & " 	left join ste_escola_estadual ee on ee.codigo_escola_estadual = t.codigo_escola_estadual "
	ssql = ssql & " 	left join SEG_USUARIOS_SISTEMA us on us.USUA_CODG = t.usuario_efetivacao"
	ssql = ssql & " 	left join MAT_setores se on se.descricao = t.bairro"
	ssql = ssql & " 	left join STE_ROTA r on r.Cod_rota = t.cod_rota"
	ssql = ssql & " 	left join sca_turma tu on tu.cod_turma = t.cod_turma"
	ssql = ssql & " 	left join sca_turno tur on tur.Cod_Turno = tu.Cod_Turno"
	ssql = ssql & " 	left join ste_presenca p on p.Cod_rota = t.cod_rota and p.Cod_solicitacao_transporte= t.codigo and p.data = '" & strDataInicialBD & "'"
	ssql = ssql & " where t.situacao='D'"
	ssql = ssql & " and t.ano_letivo = " & strAnoLetivo
	if intCodRota <> "0" then
		ssql = ssql & " and r.Cod_rota = " & intCodRota
	end if
	if intCodEmpresa <> "0" then
		ssql = ssql & " and t.cod_empresa = " & intCodEmpresa
	end if
	if intCodEscolaEstadual <> "0" then
		ssql = ssql & " and t.codigo_escola_estadual = " & intCodEscolaEstadual
	end if
	
	if listar <> "0" then
		if listar = "C" then ssql = ssql & " and p.cod_presenca is not null"
		if listar = "S" then ssql = ssql & " and p.cod_presenca is null"
	end if
	if strTurno <> "0" and strTurno<>"" then
		ssql = ssql & " and (tur.desc_turno = '" & strTurno & "' or t.turno_estadual = '" & strTurno & "')"
	end if
	
	ssql = ssql & " order by t.nome"	
	rs.open ssql, cnn
	if rs.eof = false then
		while not rs.eof
			
			situacao = "&nbsp;(EM ANÁLISE)"
			if not isnull(rs("Situacao")) then
				if rs("Situacao")="D" then	
					situacao = ""
				elseif rs("Situacao")="I" then
					situacao = "&nbsp;(REPROVADO)"
				elseif rs("Situacao")="A" then
					situacao = "&nbsp;(EM ANÁLISE)"
				elseif rs("Situacao")="R" then
					situacao = "&nbsp;(CADASTRO DE RESERVA)"
				elseif rs("Situacao")="S" then
					situacao = "&nbsp;(SOLICITAÇÃO)"
				elseif rs("Situacao")="E" then
					situacao = "&nbsp;(ENCAMINHADO AO DDA)"
				end if
			end if
			
			cont = cont + 1 
			escola = rs("escola_estadual")
			rede = "Estadual"
			turno = rs("turno_estadual")
			if isnull(rs("escola_estadual")) then 
				escola = rs("escola")
				rede = "Municipal"
				turno = rs("desc_turno")
			end if
			presenca="&nbsp"
			if not isnull(rs("cod_presenca")) then 
				presenca = "&nbsp<img src='../images/check15.png' alt='Presente'>&nbsp"
				contPresentes = contPresentes + 1 
			end if
			%>
			 <tr>
				<td style="height: 20px;" class="celula" align="left"><%=rede%></td>
				<td class="celula" align="left"><%=rs("nome")%><%=situacao%></td>
				<td class="celula" align="left"><%=escola%></td>
				<td class="celula" align="left"><%=turno%></td>
				<td class="celula" align="center"><%=presenca%></td>
			</tr>
			<%
			rs.movenext
		wend
		%>
		<tr style="font-weight: bold;">
			<td  bgcolor="#CCCCCC"  class="celula" colspan="2" class="text-left">Quantidade total de aluno(s): <%=cont%></td>
			<td  bgcolor="#CCCCCC"  class="celula" class="text-left">Com presença: <%=contPresentes%> aluno(s)</td>
			<td  bgcolor="#CCCCCC"  class="celula" colspan="2" class="text-left">Sem presenca: <%=cont-contPresentes%> aluno(s)</td>
		</tr>
		<%
	  else
		 %>
		 <tr> 
		 <td colspan="6" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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