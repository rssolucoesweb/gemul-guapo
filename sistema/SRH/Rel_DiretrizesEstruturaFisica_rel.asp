<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/09/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatório de Diretrizes
-->
<html>
<head>
<title><%=session("Titulo")%> - Estrutura Física</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	intCodEmpresa			= session("codEmpresa")
	intCodEmpresaUsuario    = TRIM(Request.Form("cmdEmpresaUsuario"))
	 intCodDependenciasFisicas 	    = TRIM(Request.Form("cmbDependenciasFisicas"))
	strSituacao 			= Trim(Request.Form("cmbSituacao"))
	strAno	 				= Trim(Request("txtAno"))
	   
	strTituloRelatorio  	= "DIRETRIZES ESTRUTURA FÍSICA <BR>" & strAno 
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
		<tr>
		  <td height="15" colspan="7" class="celula"><div align="center"><strong>DEPENDÊNCIAS</strong></div></td>
		</tr>
	
	  <tr bgcolor="#CCCCCC">
		<td width="20%" class="celula"><div align="center"><strong>Unidade</strong></div></td>
		<td width="1%" class="celula"><div align="center"><strong>ID</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Dependência</strong></div></td>
		<td width="10%" class="celula"><div align="center"><strong>Tipo</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Comprimento (m)</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Largura (m)</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Área (m2)</strong></div></td>
      </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = "SELECT em.razaosocial as empresa, e.Codigo, e.id, df.descricao as dependencia, td.descricao as tipo, e.comprimento, e.largura, isnull(e.area,0) as area"
	sql = sql & " FROM SRH_DIRETRIZES_ESTRUTURA_FISICA E"
	sql = sql & " INNER JOIN SRH_DEPENDENCIAS_FISICAS DF ON DF.Codigo = E.Cod_Dependencias_fisicas"
	sql = sql & " INNER JOIN SRH_TIPO_DEPENDENCIAS_FISICAS TD ON TD.Codigo = E.Cod_tipo_Dependencias_fisicas"
	sql = sql & " INNER JOIN seg_empresa em ON em.Codigo = E.Cod_empresa"
	sql = sql & " WHERE e.ano_letivo = " & strAno
	if intCodEmpresaUsuario<>"0" then
		sql = sql & " and E.Cod_Empresa  = " & intCodEmpresaUsuario
	end if
	if intCodDependenciasFisicas<>"0" then
		sql = sql & " and E.Cod_Dependencias_fisicas  = " & intCodDependenciasFisicas
	end if
	
	sql = sql & " and E.situacao  = '" & strSituacao & "'"
	sql = sql & " and em.CodTipoEmpresa not in (5,3)"
	'if intCodEmpresaUsuario <> "0" then
   	'	sql = sql & "and E.Cod_Empresa in (" & intCodEmpresaUsuario & ")"	
    'else
    '	sql = sql & "and em.bloqueio='N' and Em.Cod_Grupo in (" & session("CodGrupo") & ")"
   	'end if	
	
	sql = sql & " ORDER BY empresa, e.id"	
	
	rs.open sql, cnn
	intTotalArea = 0
	intTotalAreaGeral = 0
	controle = 0
	empresa = ""
	if not rs.eof then 
	    strUnidade = "1"
		While not rs.eof 
			if trim(empresa) <> trim(rs("empresa")) and controle = 1 then
				%>
				<tr height="28">
					<td colspan="7"  align="left" class="celula">Quantidade de dependências da Escola: <%=intQtde%>&nbsp;</td>
				</tr>
				<tr height="28">
					<td colspan="7"  align="left" class="celula">Área total construída Escola: <%=formatNumber(intTotalArea,2)%>m2&nbsp;</td>
				</tr>
				<%
				
				intQtde = 0
				intTotalArea = 0
			end if
			%>
			  <tr height="28">
		    	<td align="left" class="celula"><%=rs("empresa")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("id")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("dependencia")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("tipo")%>&nbsp;</td>
				<td align="center" class="celula"><%=rs("comprimento")%>&nbsp;</td>
				<td align="center" class="celula"><%=rs("largura")%>&nbsp;</td>
				<td align="center" class="celula"><%=formatNumber(rs("area"),2)%>&nbsp;</td>
			</tr>
			<%
			intQtde = intQtde + 1
			intQtdeTotal = intQtdeTotal + 1
			intTotalArea = intTotalArea + formatNumber(rs("area"),2)
			intTotalAreaGeral = intTotalAreaGeral + formatNumber(rs("area"),2)
			empresa = rs("empresa")
			controle = 1
			rs.movenext
		wend
		%>
   		    <tr height="28">
		    	<td colspan="7"  align="left" class="celula">Quantidade de dependências da Escola: <%=intQtde%>&nbsp;</td>
			</tr>
   		    <tr height="28">
		    	<td colspan="7"  align="left" class="celula">Área total construída Escola: <%=formatNumber(intTotalArea,2)%>m2&nbsp;</td>
			</tr>
			<tr height="28">
		    	<td colspan="7"  align="left" class="celula">&nbsp;</td>
			</tr>
			 <tr height="28">
		    	<td colspan="7"  align="left" class="celula">Quantidade de dependências: <%=intQtdeTotal%>&nbsp;</td>
			</tr>
   		    <tr height="28">
		    	<td colspan="7"  align="left" class="celula">Área total construída: <%=formatNumber(intTotalAreaGeral,2)%>m2&nbsp;</td>
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
<br>
<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
