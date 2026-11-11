<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	strCod_empresa 			= Session("CodEmpresa")
	intCodCurso 			= Trim(Request.Form("cmbCurso"))
	intCodTipoEmpresa 		= Trim(Request.Form("cmbTipoEmpresa"))
	strTipoVaga 			= Trim(Request.Form("cmbTipoVaga"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strOrdem 				= Trim(Request.Form("cmbOrdem"))
	
	strCodGrupo 			= Session("CodGrupo")
	curso = request.Form("cmbTipoCurso")
	IF curso = "EDUCACAO INFANTIL" THEN curso = "EDUCAÇÃO INFANTIL"
	if strTipoVaga = "C" then
		strTituloRelatorio = "Mapa Geral de Vagas Oferecidas " & strAnoLetivo & "<br>"&curso
	elseif strTipoVaga = "D" then
		strTituloRelatorio = "Mapa Geral de Vagas Existentes " & strAnoLetivo & "<br>"&curso
	elseif strTipoVaga = "P" then
		strTituloRelatorio = "Mapa Geral de Vagas Preenchidas " & strAnoLetivo & "<br>"&curso
	elseif strTipoVaga = "E" then
		strTituloRelatorio = "Mapa Geral de Vagas Efetivadas " & strAnoLetivo & "<br>"&curso
	elseif strTipoVaga = "L" then
		strTituloRelatorio = "Mapa Geral de Vagas Liberadas " & strAnoLetivo & "<br>"&curso
	elseif strTipoVaga = "R" then
		strTituloRelatorio = "Mapa Geral de Vagas Reservadas " & strAnoLetivo & "<br>"&curso
	end if
	
	sub mostraCabecalho(vetPeriodo)
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
      <tr bgcolor="#CCCCCC">
	<%if isArray(vetPeriodo) then
		controle = 0%>
        <td width="28%" height="16" class="celula"><strong>Escola</strong></td>
		<td width="5%" height="16" class="celula"><strong>Ano Letivo</strong></td>
		<%for i=0 to ubound(vetPeriodo,2)%>
        <td align="center" class="celula"><strong><%=vetPeriodo(0,i)%></strong></td>
        <%next%>
        <td align="center" class="celula"><strong>TOTAL</strong></td>
    <%end if%>
      </tr>
      <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	intQtdeRegistroPorPagina = 1
	
	cont = 0
	
	vetPeriodo = null
	
	sql = "select distinct Descricao as serie"
	sql = sql & " from SCA_PERIODO"
	sql = sql & " where  cod_curso <> 809 and Cod_Curso in (select Cod_Curso from SCA_CURSO where left(Descricao,18) = '" & curso & "')"
	sql = sql & " and cod_empresa in (select codigo from seg_empresa where cod_grupo=7)"
'response.write sql
	rs.open sql, cnn
	if not rs.eof then
		vetPeriodo = rs.getRows
	end if
	rs.close

	mostraCabecalho vetPeriodo
	
	SQL = "execute SP_MapaDeVagas '" & strCodGrupo & "','" & strAnoLetivo & "','" & curso & "','" & strTipoVaga & "','" & strOrdem & "'"
'	response.Write(sql)
	vetMapa = null
	rs.open sql, cnn
	if not rs.eof then
		vetMapa = rs.getRows
	end if
	rs.close
	cont = 0
	if isArray(vetMapa) then
		cor = ""
		for i=0 to ubound(vetMapa,2)
			total = 0
			cont = cont + 1
			if cor = "" then cor = "bgcolor='#E1E1E1'" else cor = ""
			
				%>
					<tr <%=cor%>>
						<td class="celula" align="left">&nbsp;<%=vetMapa(0,i) %></td>
						<td class="celula" align="left">&nbsp;<% if vetMapa(1,i)<>"0" then response.write vetMapa(1,i) %></td>
						<% 
							for j=3 to ubound(vetPeriodo,2)+3 %>
								<td class="celula" align="center"><%=vetMapa(j,i) %>&nbsp;</td>
								<% 		
								qtde = vetMapa(j,i)
								'if qtde<0 then qtde = 0
								if not isnull(vetMapa(j,i)) then 
									total = total + qtde
								end if
							next
						%> 
						<td class="celula" align="center"><strong><%=total %></strong>&nbsp;</td>
						
					</tr>
				<%	
			
		next
	end if
	%>
    </table>
	<%response.write " -> " & cont & " Unidades"%>
    <br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
