<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Libera Período do Planejamento por Colaborador</title>
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
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	intCodEmpresa 			= Trim(Request.Form("cmbEmpresaGrupo"))
	codSituacao				= Trim(Request.Form("cmbSituacao"))
	strclasse				= "celula"
    strTituloRelatorio  	= "LIBERAÇÃO EXTRA DO PLANEJAMENTO POR COLABORADOR"
	
	sub mostraCabecalho(vetIdades)
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <%
	  if strSubTitulo <> "" then
	     %>
	     <tr bgcolor="#CCCCCC">
	     <td colspan="4" class="<%=strclasse%>"><div ="center"><%=strSubTitulo%>&nbsp;</div></td>
         </tr>
		 <%
	  end if	
	  %> 
      <tr bgcolor="#CCCCCC">
		<td  class="<%=strclasse%>"><strong>Colaborador</td>
		<td  class="<%=strclasse%>"><strong>Quinzena</td>
		<td  class="<%=strclasse%>"><strong>Motivo</td>
		<td  class="<%=strclasse%>"><strong>Usu&aacute;rio</td>
		<td  class="<%=strclasse%>"><strong>Data inclusão</td>
		<td  class="<%=strclasse%>"><strong>Data expira</td>
		<td  class="<%=strclasse%>"><strong>Situação</td>
      </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	mostraCabecalho vetIdades
	cont = 0
	empresa = ""
	turno = ""
	total_M_linha = 0
	total_F_linha = 0
	total_linha = 0
	cod_escola = 0
		
	sql = "select l.cod_planejamento_periodo_extra, c.nome, c.codFuncional, l.quinzena, l.motivo, l.data_expira, "
	sql = sql & " case when l.data_hora_altr is null or l.usuario_altr = 'sistema' then "
	sql = sql & " 			l.data_hora_incl "
	sql = sql & " else l.data_hora_altr "
	sql = sql & " end as data_hora, "
	sql = sql & " case when l.usuario_altr is null or l.usuario_altr = 'sistema' then "
	sql = sql & " 			u1.USUA_NOME_COMPLETO "
	sql = sql & " else u2.USUA_NOME_COMPLETO "
	sql = sql & " end as usuario, "
	sql = sql & " case when l.situacao = 'A' then 'Ativa' else 'Inativa' end as situacao, p.ano_letivo, p.mes, e.razaosocial "
	sql = sql & " from SCA_PLANEJAMENTO_PERIODO_EXTRA l"
	sql = sql & " inner join SRH_COLABORADOR c on c.codigo = l.cod_colaborador"
	sql = sql & " left join SEG_EMPRESA e on e.codigo = l.cod_empresa"
	sql = sql & " left join SEG_USUARIOS_SISTEMA u1 on u1.USUA_CODG = l.usuario_incl"
	sql = sql & " left join SEG_USUARIOS_SISTEMA u2 on u2.USUA_CODG = l.usuario_altr"	
	sql = sql & " left join SCA_PLANEJAMENTO_PERIODO p on p.cod_planejamento_periodo = l.cod_planejamento_periodo where 1=1"
	IF intCodEmpresa<>"0" THEN
		sql = sql & " and l.cod_empresa = " & intCodEmpresa
	END IF
	IF strAnoLetivo<>"" THEN
		sql = sql & " and YEAR(l.data_hora_incl) = " & strAnoLetivo
	END IF
	sql = sql & " order by l.data_hora_incl"
	corLinha = "bgcolor='#CCCCCC'"
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			periodo = ""
			if not isnull(rs("mes")) then
				periodo = ucase(MonthName(rs("mes"))) & "/" & rs("ano_letivo")
			end if
            if trim(rs("razaosocial")) <> trim(escola) then
				%>
				<tr>
                <td class="<%=strclasse%>" colspan="7" align="center"><strong><%=rs("razaosocial")%></strong></td>
			  </tr>
				<%
			end if
			%>
			  <tr>
				  <td class="<%=strclasse%>"><%=RS("nome")%>&nbsp;(<%=RS("codFuncional")%>)</td>
				  <td class="<%=strclasse%>"><%=RS("quinzena")%>ª&nbsp;<%=periodo%></td>
				  <td class="<%=strclasse%>"><%=RS("motivo")%>&nbsp;</td>
				  <td class="<%=strclasse%>"><%=RS("USUARIO")%>&nbsp;</td>
				  <td class="<%=strclasse%>"><%=RS("data_hora")%>&nbsp;</td>
				  <td class="<%=strclasse%>"><%=formatadataap(RS("data_expira"))%>&nbsp;</td>
				  <td class="<%=strclasse%>"><%=RS("situacao")%>&nbsp;</td>
			  </tr>
			<%
			escola    = rs("razaosocial")
			rs.movenext
		wend
		rs.close
		
	else
		%>
		  <tr>
			<td colspan="7" class="<%=strclasse%>" ="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
		rs.close
	end if
	
%>
</table>
</body>
<script>
	aguarde.style.display="none";
</script>
</html>
