<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Distorção idade x série</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">

<script src="js/js_funcoes_gerais.js"></script>
<script src="js/js_barra_movel.js"></script>
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

	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	intCodEmpresaGrupo			= Trim(Request.Form("cmbEmpresaGrupo"))
	
	strTituloRelatorio  	= "RELATÓRIO DE DISTORÇÃO IDADE X SÉRIE "
	
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
		
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorioGrupo.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="40%" class="celula"><strong>Empresa</strong></td>
		<td width="15%" class="celula"><div align="center"><strong>Turma</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Turno</strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Qtde. de Alunos</strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Distorções</strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>%</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	intPagina = 1
	mostraCabecalho

	cont = 0
	empresa=""
	sql = "execute SP_SCA_rel_distorcao_idade_serie '" & session("codGrupo") & "','" & intCodEmpresaGrupo & "','" & intAnoLetivoAtual & "','" & intSemestreAtual & "'"
	rs.open sql, cnn
	if not rs.eof then
		While not rs.eof
			percentual = "0"
			if rs("distorcao")>0 then percentual = formatNumber(((rs("distorcao") * 100)) / rs("ocupadas"),0)
			if rs("empresa")<>empresa then
                if cor = "bgcolor='#D2E9FF'" then
                    cor = ""
                else
                    cor = "bgcolor='#D2E9FF'"
                end if
                %>
            <tr <%=cor%>>
			  <td rowspan="<%=rs("linhas_por_empresa")%>" align="center" class="celula"><strong><%=rs("empresa")%></strong></td>
				<td align="center" class="celula"><%=rs("turmaAluno")%></td>
				<td align="center" class="celula"><%=rs("turno")%></td>
				<td align="center" class="celula"><%=rs("ocupadas")%>&nbsp;</td>
				<td align="center" class="celula"><%=rs("distorcao")%>&nbsp;</td>
				<td align="center" class="celula"><%=percentual%>&nbsp;</td>
	  		</tr>
            <%else%>
            <tr <%=cor%>>
				<td align="center" class="celula"><%=rs("turmaAluno")%></td>
				<td align="center" class="celula"><%=rs("turno")%></td>
				<td align="center" class="celula"><%=rs("ocupadas")%>&nbsp;</td>
				<td align="center" class="celula"><%=rs("distorcao")%>&nbsp;</td>
				<td align="center" class="celula"><%=percentual%>&nbsp;</td>
			</tr>
            <%end if%>
			<%
			empresa = rs("empresa")
			cont = cont  + 1
			rs.movenext
		wend
		%>
		 <tr bgcolor="#CCCCCC" >
            <td colspan="6" align="left" class="celula"><strong>Quantidade de turmas: <%=cont%></strong></td>
        </tr>
		<%
	else
		%>
		  <tr>
			<td colspan="6" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
