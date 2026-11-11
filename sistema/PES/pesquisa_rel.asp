<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 03/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: feriados
-->
<html>
<head>
<title><%=session("Titulo")%> - resultados</title>
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
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	cod_pesquisa = request("cod_pesquisa")
	cod_setor = request("cod_setor")
	if cod_setor = "" then cod_setor = "0"
	
	sql = "select s.codigo, s.nome, c.nome as cidade, e.nome as estado, s.situacao, s.usuario_altr, s.data_hora_altr"
	sql = sql & " from PES_pesquisa s "
	sql = sql & " left join PES_cidade c on c.codigo = s.cod_cidade"
	sql = sql & " left join PES_estado e on e.codigo = c.cod_estado"
	sql = sql & " where s.codigo = " & cod_pesquisa
	sql = sql & " order by s.situacao, s.nome"
	rs.open sql, cnn
	if not rs.eof then
		pesquisa = rs("nome") & "<br>" & rs("cidade") & "-" & rs("estado")
	end if
	rs.close
	setor = ""
	if cod_setor <> "0" then
		sql = "select nome"
		sql = sql & " from PES_setor s "
		sql = sql & " where codigo = " & cod_setor
		rs.open sql, cnn
		if not rs.eof then
			setor = "<br>" & rs("nome")
		end if
		rs.close
	end if
	strTituloRelatorio  	= "Resultados da Pesquisa <br>" & pesquisa & setor

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="25%" class="celula"><div align="center"><strong>Data</strong></div></td>
		<td width="30%" class="celula"><strong>Entrevistador</strong></td>
		<td width="30%" class="celula"><strong>Entrevistado</strong></td>
		<td width="15%" class="celula"><div align="center"><strong>IP</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	intQtdeRegistro = 0
	sql = "select r.data_hora_incl as data, e.nome as entrevistador, r.cod_entrevistado, o.nome as entrevistado, r.ip_dispositivo"
	sql = sql & " from PES_resultado  r"
	sql = sql & " left join PES_entrevistador e on e.Codigo = r.cod_entrevistador"
	sql = sql & " left join PES_entrevistado o on o.codigo = r.cod_entrevistado"
	sql = sql & " where r.cod_pesquisa = " & cod_pesquisa
	if cod_setor <> "0" then
		sql = sql & " and o.cod_setor = " & cod_setor
	end if	
	sql = sql & " order by 1 desc"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			<tr> 
			  <td align="left" class="celula"><strong><%=rs("data")%></strong>&nbsp;</td>
			  <td align="left" class="celula"><strong><%=Ucase(rs("entrevistador"))%></strong>&nbsp;</td>
			  <td align="left" class="celula"><strong><%=Ucase(rs("entrevistado"))%>&nbsp;</strong></td>
			  <td align="left" class="celula"><strong><%=rs("ip_dispositivo")%>&nbsp;</strong></td>
			</tr>
			<%			
			
			intQtdeRegistro = intQtdeRegistro + 1
			rs.movenext
		wend
		%>
		<tr> 
		  <td align="left" colspan="4"  class="celula"><strong>Entrevistas:&nbsp;<%=intQtdeRegistro%> </strong></td>
		</tr>
		<%
	else
		%>
		  <tr>
			<td colspan="4" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
