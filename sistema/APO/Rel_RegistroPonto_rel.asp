<%
response.Expires=0
'N�o armazena a p�gina em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-weight: bold;
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


	strDataInicial=request.Form("txtDataInicial")
	strDataFinal=request.Form("txtDataFinal")
	
	
	strCod_empresa 					= request("cmdEmpresaUsuario")
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="40%" align="center" class="celula"><strong>Funcionário</strong></td>
	    <td width="15%" class="celula"><div align="center"><strong>Data</strong></div></td>
	    <td width="15%" height="15" class="celula"><div align="center"><strong>Hora</strong></div></td>
      </tr>
	  <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	strTituloRelatorio  	= "BATIDA DE PONTO <BR> Período de: " & formatadataAP(Trim(strDataInicial)) & " a " & formatadataAP(Trim(strDataFinal))

	intPagina = 1
	mostraCabecalho


	
	    MarcaColaborador = "0"

		sql = " SELECT f.data, f.hora, E.CODIGO, E.RAZAOSOCIAL, e.codigo, FF.NOME_FUNC, FF.CODI_FUNC"
		sql = sql & " FROM gemul5.dbo.funcionarios ff "
		sql = sql & " LEFT JOIN gemul5.dbo.COLETA f ON FF.CODI_FUNC = F.CODI_FUNC"
		sql = sql & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = F.COLETOR  "
		sql = sql & " WHERE ff.excluido='N' and f.coletor  = " & strCod_empresa
		if strDataInicial <> "" then
		sql = sql & " And data between '" & formatadataBD(Trim(strDataInicial)) & "' and '" & formatadataBD(Trim(strDataFinal)) & "'"
		end if
		sql = sql & " order by E.RAZAOSOCIAL, FF.NOME_FUNC, f.data, f.hora"
		cont = 0
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
				if codEmp <> rs("codigo") then
				%>
				  <tr >
				    <td height="40" colspan="3" align="center" class="celula">&nbsp;<strong><%=rs("RAZAOSOCIAL")%> - <%=rs("codigo")%></strong></td>
				  </tr>
                 <%
				 end if
				%>
				  <tr >
				    <td align="left" class="celula">&nbsp;<%=rs("NOME_FUNC")%> - <%=rs("CODI_FUNC")%></td>
					<td align="center" height="19" class="celula"><%=formatadataAP(rs("data"))%></td>
					<td align="center" class="celula"><div align="center"><%=rs("hora")%>&nbsp;</div></td>
				  </tr>
                 <%
				 codEmp = rs("codigo")
				'quantidade de registros da p�gina
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
				DATA = RS("DATA") 
				rs.movenext	
				
			wend
		else
			%>
			<script>
				alert("Sem registro de ponto!");
				window.history.back();
			</script>
			<%
			response.end
			
		end if 
		rs.close
%>
</table>

<script>
	aguarde.style.display="none";
</script>
<!--include file="../../includes/inc_apontamento_remove.asp"-->
</body>
</html>