<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
if request("exportar") = "" then
	Response.Buffer = false
end if


dim intPagina
paginaatual = request.ServerVariables("SCRIPT_NAME")

intCodGrupo				= Session("CodGrupo") 		
intCodEmpresa 			= Trim(Request("cmbEmpresa"))
intCodSetor				= Trim(Request("cmbSetor"))
strSituacao				= Trim(Request("cmbSituacao"))

if strSituacao = "S" then situacao = "<br>Solicitação"
if strSituacao = "D" then situacao = "<br>Deferido"
if strSituacao = "E" then situacao = "<br>Encaminhado ao DDA"
if strSituacao = "I" then situacao = "<br>Indeferido"

strTituloRelatorio  	= "Relação de solicitações" & situacao

strExportarWord 	= paginaatual & "?exportar=w&cmbEmpresa=" & intCodEmpresa & "&cmbSetor=" & intCodSetor & "&cmbSituacao=" & strSituacao
strExportarExcel 	= paginaatual & "?exportar=e&cmbEmpresa=" & intCodEmpresa & "&cmbSetor=" & intCodSetor & "&cmbSituacao=" & strSituacao


%>
<html>
<head>
<title>Solicitação</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
if request("exportar") = "" then 
    %>
	<!--#include file="includes/inc_Botoes_relatorio_word_excel.asp"-->
	<!--#include file="includes/inc_aguarde.asp"-->
	<%
end if
%>

<br>
<%
	sub mostraCabecalho()
	%>
	<%if request("exportar") = "" then %>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%end if %>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td  width="20%" class="celula"><strong>Nome</strong></td>
		<td class="celula"><strong>Setor</strong></td>
		<td class="celula"><strong>Escola</strong></td>
		<td class="celula"><strong>Data</strong></td>
		<td class="celula"><strong>Situação</strong></td>
		<td class="celula"><strong>DDA</strong></td>
		<td class="celula"><strong>Rota</strong></td>
		<td class="celula"><strong>Execução</strong></td>
		<td class="celula"><strong>Ação/Obs</strong></td>
		<td class="celula"><strong>Obs. DDA</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	sql = "select t.codigo, t.nome, t.obs, t.obs_dda, r.Descricao as rota, t.bairro as setor, em.RAZAOSOCIAL as escola, "
	sql = sql & " 	t.Situacao as cod_sit, "
	sql = sql & " 	case"
	sql = sql & " 		when t.Situacao='S' then 'Solicitação'"
	sql = sql & " 		when t.Situacao='D' then 'Deferido'"
	sql = sql & " 		when t.Situacao='E' then 'Encaminhado ao DDA'"
	sql = sql & " 		when t.Situacao='I' then 'Indeferido'"
	sql = sql & " 		when t.Situacao='T' then 'Devolvido ao Transporte'"
	sql = sql & " 		end as situacao,"
	sql = sql & " 	case"
	sql = sql & " 		when t.Situacao_DDA='S' then 'Solicitação'"
	sql = sql & " 		when t.Situacao_DDA='D' then 'Deferido'"
	sql = sql & " 		when t.Situacao_DDA='E' then 'Encaminhado ao DDA'"
	sql = sql & " 		when t.Situacao_DDA='I' then 'Indeferido'"
	sql = sql & " 		when t.Situacao_DDA='T' then 'Devolvido ao Transporte'"
	sql = sql & " 		when t.Situacao='E' and t.Situacao_DDA is null then 'Aguardando DDA'"
	sql = sql & " 		end as situacaoDDA,"
	sql = sql & " 	t.situacao_DDA as cod_sit_dda, "
	sql = sql & " 	t.data_hora_incl,"
	sql = sql & " 	t.data_efetivacao, us.USUA_NOME_COMPLETO as usuario_efetivacao"
	sql = sql & " 	from ste_solicitacao_transporte t "
	sql = sql & " 	inner join SEG_EMPRESA em on em.codigo = t.Cod_empresa "
	sql = sql & " 	left join SEG_USUARIOS_SISTEMA us on us.USUA_CODG = t.usuario_efetivacao"
	sql = sql & " 	left join MAT_setores se on se.descricao = t.bairro"
	sql = sql & " 	left join STE_ROTA r on r.Cod_rota = t.cod_rota"
	sql = sql & " 	where 1=1"
	if strSituacao <> "0" then
		sql = sql & " and t.Situacao = '" & strSituacao & "'"
	end if
	if intCodSetor <> "0" then
		sql = sql & " and se.codigo = " & intCodSetor
	end if
	if intCodEmpresa<>"0" then
		sql = sql & " and em.CODIGO = " & intCodEmpresa
	end if
	sql = sql & " order by t.data_hora_incl	"
	
	rs.open sql, cnn
	if not rs.eof then 
		while not rs.eof
			cont = cont + 1	
			rota = "<strong>---</strong>"
			if not isnull(rs("rota")) then
				rota = "<strong>" & rs("rota") & "</strong>"
			end if
			%>
			  <tr>
				<td class="celula"><%=rs("nome")%></td>
				<td class="celula"><%=rs("setor")%></td>
				<td class="celula"><%=rs("escola")%></td>
				<td class="celula"><%=formatadataAP(rs("data_hora_incl"))%></td>
				<td class="celula"><%=rs("situacao")%><span class="fonteCodigo"><%=rs("codigo")%></span></td>
				<td class="celula"><%=rs("situacaoDDA")%></td>
				<td class="celula"><%=rota%></td>
				<td class="celula"><%=rs("usuario_efetivacao")%><br><%=rs("data_efetivacao")%></td>
				<td height="20" class="celula">
					<%
					if rs("cod_sit_dda")="I" or rs("cod_sit_dda")="D" or rs("cod_sit")="I" or rs("cod_sit")="D" then
						response.write rs("obs")
					else
						if rs("cod_sit_dda")="T" then
							response.write rs("obs")
							
						else
							if rs("cod_sit")="S" then
							response.write "---"
							else
								response.write rs("obs")
							end if
						end if
					end if
					%>
				</td>
				<td class="celula"><%=rs("obs_DDA")%></td>
			  </tr>
			  <%				
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="10" bgcolor="#CCCCCC" class="celula">Registros: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td height="10" colspan="3" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>
<%if request("exportar") = "" then %>
<script>
	aguarde.style.display="none";
</script>
<%end if %>
<%
if request("exportar") = "w" then 
	Response.ContentType = "application/vnd.ms-word"
	Response.AddHeader "content-disposition","attachment;filename=relatorioSolicitacao.doc"
elseif request("exportar") = "e" then 
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "content-disposition","attachment;filename=relatorioSolicitacao.xls"
end if
%>	
</body>
</html>	
