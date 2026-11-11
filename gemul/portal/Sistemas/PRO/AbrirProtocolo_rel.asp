<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
strPaginaDestino = "window.location='AbrirProtocolo_cad.asp'"
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 07/04/2009
	::	Desenvolvedores...: Sérgio - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio de LIquidacao diária
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../../Estilo/Estilo_Impressao.css">
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="../../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../../includes/inc_verificaSession.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<!--#include file="../../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<br>
<%
	intCodProtocolo        	= Trim(Request("txtCodigo"))
	strTituloRelatorio  	= "RECIBO DO PROTOCOLO ABERTO"
	intCodEmpresa	= session("CodEmpresa")	
	%>
	<!--#include file="../../../includes/inc_cabecalhoRelatorio.asp"-->

	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	<%
	sql = " select p.codigo, p.numero, p.dataAbertura, p.tipoProtocolo, p.cpf, p.requerente, a.descricao as assunto, td.acompanhamento,"
	sql = sql & " p.motivo, p.obs, td.descricao as tipodocumento, p.numeroDocumento, p.senha, d.descricao as depto"
	sql = sql & " from PRO_Protocolo p"
	sql = sql & " inner join PRO_Assunto a on a.codigo = p.cod_Assunto"
	sql = sql & " inner join PRO_TipoDocumento td on td.codigo = p.cod_tipoDocumento"
	sql = sql & " inner join PRO_Departamento d on d.codigo = p.cod_Departamento"
	sql = sql & " where p.codigo = "& intCodProtocolo
	sql = sql & " and p.cod_empresa = " & intCodEmpresa
	rs.open sql, cnn
	if not rs.eof then 
	%>
	  <tr bgcolor="#CCCCCC">
	    <td height="39" colspan="4" align="center" class="celula"><strong class="textoRelatorio">N&uacute;mero do Protocolo: <%=rs("numero")%></strong></td>
      </tr>
	  	<tr>
	  	  <td width="9%" height="35" align="left" class="celula">Data Abertura:</td>
	  	  <td width="35%" align="left" class="celula">&nbsp;<%=rs("dataAbertura")%></td>
	  	  <td width="8%" align="left" class="celula">Tipo Protocolo:</td>
	  	  <td width="48%" align="left" class="celula">&nbsp;<%=rs("tipoProtocolo")%></td>
      </tr>
      <tr>
	  	  <td width="9%" height="35" align="left" class="celula">Cpf/Requerente:</td>
  	    <td width="35%" align="left" class="celula">&nbsp;<%=rs("cpf")%> - <%=rs("requerente")%></td>
	  	  <td width="8%" align="left" class="celula">Assunto:</td>
	  	  <td width="48%" align="left" class="celula">&nbsp;<%=rs("Assunto")%></td>
      </tr>
      <tr>
	  	  <td width="9%" height="35" align="left" class="celula">Tipo de Documento:</td>
  	    <td width="35%" align="left" class="celula">&nbsp;<%=rs("tipoDocumento")%></td>
	  	  <td width="8%" align="left" class="celula">N&uacute;mero Documento:</td>
	  	  <td width="48%" align="left" class="celula">&nbsp;<%=rs("numeroDocumento")%></td>
      </tr>
      <tr>
	  	  <td width="9%" height="35" align="left" class="celula">Departamento Destino:</td>
  	    <td width="35%" align="left" class="celula">&nbsp;<%=rs("depto")%></td>
	  	  <td width="8%" align="left" class="celula">Motivo:</td>
	  	  <td width="48%" align="left" class="celula">&nbsp;<%=rs("motivo")%></td>
      </tr>
      <tr>
	  	  <td width="9%" height="35" align="left" class="celula">Observa&ccedil;&atilde;o:</td>
  	    <td colspan="3" align="left" class="celula">&nbsp;<%=rs("obs")%></td>
  	  </tr>
  	  <%if rs("acompanhamento")="INTERNET" then%>
      <tr>
	  	  <td width="9%" colspan="4" height="65" align="left" class="celula">Acompanhamento do andamento do protocolo pela internet, acesse: <strong>www.aparecida.go.gov.br após, clique no icone PORTAL DA SECRETARIA DA EDUCAÇÃO e acesse o banner ANDAMENTO DO PROTOCOLO</strong><br>Informe o número do protocolo<strong> <%=rs("numero")%></strong> com a senha: <strong><%=rs("senha")%></strong></td>
  	  </tr>      
      <%end if%>
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
