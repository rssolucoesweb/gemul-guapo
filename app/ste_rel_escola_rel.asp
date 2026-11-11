<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>Escolas</title>
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
	intCodEmpresa 			= Trim(Request.Form("cmbEmpresa"))
	intCodSetor				= Trim(Request.Form("cmbSetor"))
	
	strTituloRelatorio  	= "Relação de Unidades vinculadas aos setores"
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td width="40%" align="left" class="celula"><strong>Unidade</strong></td>
		<td width="30%" align="left" class="celula"><strong>Bairro</strong></td>
		<td width="20%" align="center"  class="celula"><strong>Telefone</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	sql = "select s.codigo as cod_setor, s.descricao as setor, e.CODIGO as cod_empresa, e.RAZAOSOCIAL as unidade, e.BAIRRO, e.cep, e.TELEFONE "
	sql = sql & " from MAT_setores s"
	sql = sql & " inner join STE_ROTA_VINCULA_UNIDADE_SETORES v on v.Cod_setores = s.codigo"
	sql = sql & " inner join SEG_EMPRESA e on e.codigo = v.Cod_empresa"
	sql = sql & " where 1=1"
	if intCodSetor <> "0" then
		sql = sql & " and s.codigo = " & intCodSetor
	end if
	if intCodEmpresa<>"0" then
		sql = sql & " and e.CODIGO = " & intCodEmpresa
	end if
	sql = sql & " order by 2,4"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			if strSetor<>rs("cod_setor") then
			%>
			  <tr>
				<td colspan="3" height="25" class="celula" align="center"><font size="2"><strong><%=rs("setor")%></strong></font></td>
			</tr>
			<%
			end if
			%>
			  <tr>
				<td class="celula" align="left"><%=rs("unidade")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("bairro")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("telefone")%>&nbsp;</td>
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
			strSetor = rs("cod_setor")
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="3" bgcolor="#CCCCCC" class="celula">Registros: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td height="13" colspan="3" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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