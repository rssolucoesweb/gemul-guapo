<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2008
	::	Desenvolvedores...: Roberto Barbosa - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio Extrato do Evento
-->
<html>
<head>
<title><%=session("Titulo")%> - Extrato de Notas e Faltas</title>
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
<!--#include file="../../includes/aguarde.asp"-->
<%
	dim intPagina
	strTituloRelatorio  	= "OCORR&Ecirc;NCIAS ALUNO <br>"
	%>
    <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
<%
	
	sql = "SELECT O.DATAOCORRENCIA, O.OCORRENCIA, TP.DESC_Tipo, DA.PARCELA, DA.ReferenciaMensal, O.USUARIO_INCL"
	sql = sql & " FROM SCA_OCORRENCIA O"
	sql = sql & " LEFT JOIN SCF_DEBITOALUNO DA ON DA.CODIGO = O.COD_DEBITOALUNO AND O.COD_EMPRESA = DA.COD_EMPRESA"
	sql = sql & " LEFT JOIN SCF_TIPOPARCELA TP ON TP.COD_TIPO = O.COD_TIPOPARCELA AND TP.COD_EMPRESA = O.COD_EMPRESA"
	sql = sql & " WHERE O.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " AND 	O.Cod_Aluno=" & trim(Session("CodSeguranca"))
	sql = sql & " AND 	O.TIPO_OCORRRENCIA= 'D' "
	sql = sql & " order by O.DATAOCORRENCIA desc "	

	rs.open sql, cnn
	if rs.eof = false then
	%>
	<BR>
	<table width = "98%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	<tr bgcolor="#E5E5E5">
	<td width="15%" bgcolor="#F0F0F0" class="celula"><strong><strong>Data</strong></strong></td>
	<td width="57%" class="celula"><strong><strong>Ocorr&ecirc;ncia</strong></strong></td>
	</tr>
	<%
	while not rs.eof
		%>
		  <tr>
			<td class="celula">&nbsp;<%=RS("DATAOCORRENCIA")%></td>
			<td class="celula">&nbsp;<%=RS("OCORRENCIA")%></td>
		  </tr>
		<%
	 rs.movenext
	wend
	%>
	</table>
	<%
	else
	%>
	<table width = "98%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	<tr>
	<td height="300" class="celula" align="center"><strong>Não foi encontrado nenhuma ocorrência para esse aluno.</strong></td>
    </tr>
	</table>
	<%
	end if
	rs.close
	%>
<script>
	aguarde.style.display="none";
</script>
</p>
</body>
</html>