<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
on error resume next  
	 
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-UTF-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-weight: bold;
}
.style2 {
	font-size:14px;
}
-->
</style>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--  include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina

	strData 		= Trim(Request.form("txtData"))
	marcou 		= Trim(Request.form("marcou"))
	strCod_empresa 					= Session("CodEmpresa")

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
    <br>
	<table width="40%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td align="center" class="celula"><strong>Unidade</strong></td>
      </tr>
	  <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	if marcou = "N" then
		strTituloRelatorio  	= "UNIDADE SEM APONTAMENTO <BR> Data: " & formatadataAP(Trim(strData)) 
	elseif marcou = "S" then
		strTituloRelatorio  	= "UNIDADE COM APONTAMENTO <BR> Data: " & formatadataAP(Trim(strData)) 
	end if
	intPagina = 1
	mostraCabecalho

	sql = " select codigo, upper(razaosocial) as unidade"
	sql = sql & " from seg_empresa"
	sql = sql & " where (BLOQUEIO = 'N' or BLOQUEIO is null)"
	sql = sql & " and COD_GRUPO = "& session("CodGrupo")
	sql = sql & " and codTipoEmpresa in (1,2,4)"
	if marcou = "N" then
		sql = sql & " and codigo not in ("
		sql = sql & " select distinct coletor"
		sql = sql & " from gemul5.dbo.coleta"
		sql = sql & " where data = '" & formatadataBD(Trim(strData)) & "'"
		sql = sql & " and coletor <> 999"
		sql = sql & " and codi_func<>99999999 and coletor <> 999"
		sql = sql & " )"
	elseif marcou = "S" then
		sql = sql & " and codigo in ("
		sql = sql & " select distinct coletor"
		sql = sql & " from gemul5.dbo.coleta"
		sql = sql & " where data = '" & formatadataBD(Trim(strData)) & "'"
		sql = sql & " and codi_func<>99999999 and coletor <> 999"
		sql = sql & " )"
	end if
	sql = sql & " order by razaosocial"
	cont = 0
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			%>
			  <tr >
				<td align="left" class="celula style2">&nbsp;&nbsp;<%=rs("unidade")%> - <%=rs("codigo")%></td>
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
			rs.movenext	
			
		wend
	end if 
	rs.close
%>
  <tr >
    <td class="celula style2" colspan="4">&nbsp;&nbsp;<strong>Quantidade: &nbsp;<%=cont%></strong></td>
  </tr>
</table>

<script>
	aguarde.style.display="none";
</script>
<!--include file="../../includes/inc_apontamento_remove.asp"-->
</body>
</html>