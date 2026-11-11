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
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	intCodSetores 	= request.Form("cmbSetores")
	if intCodSetores = "" then intCodSetores = "0"
	strTituloRelatorio  	= "Rela&ccedil;&atilde;o setor por região"
	
	sub mostraCabecalho()
%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="60%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
		<td align="center" class="celula"><strong>Regi&atilde;o</strong></td>
	  </tr>
	  <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	mostraCabecalho
	cont = 0

	sql = "select descricao "
	sql = sql & " from MAT_regiao "
	sql = sql & " where codigo in (select cod_regiao from [dbo].[MAT_regiao_setores]"
	sql = sql & " where cod_setores = " & intCodSetores
	sql = sql & " )"
	sql = sql & " order by descricao"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td width="20%" align="left" class="celula"><font size="+1">&nbsp;<%=rs("descricao")%>&nbsp;</font></td>
              </tr>
			<%
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
		  <tr>
			<td class="celula" align="center">Quantidade de regiões: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td height="48" align="center" class="celula"><p><br>
	          <br>
            <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
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
