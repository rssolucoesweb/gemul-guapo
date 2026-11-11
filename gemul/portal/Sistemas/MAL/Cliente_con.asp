<html>
<head>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_popup.css">
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
<title>Consulta Usuários</title>
<script src="../../../js/js_funcoes_gerais.js"></script>
<script>
	function resultadoConsulta(cod){
		window.opener.frm.txtCodigo.value=cod;
		window.opener.frm.submit();
		window.close();
	}
	
</script>
</head>
<body   topmargin="0" leftmargin="0">
<%
'as paginas do menu administrativo não vão validar o ano letivo
bolPaginaAnoLetivo 	= "N"
'as paginas do menu administrativo não vão validar a unidade de ensino
strValidaUnidadeEnsino = "N"
%>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
 
<form method="POST" id="frm" action="#">
<div class="TituloFormulario" align="center">Consulta Cliente</div>
<br>

<table width="90%" align="center" class="formulario">
	<tr>
		<td>
		<%  
           strNome 		= request.form("txtNome")
        %>
 
<table width="100%" border="0">
          <tr> 
            <td width="221">Nome</td>
            <td width="750"><input name="txtNome" type="text" id="txtNome" class="caixaTexto" size="40" maxlength="50"  onKeyPress="return formataCampo(this, 1, 50)"  value="<%=strNome%>"></td>
          </tr>
          <tr> 
            <td colspan="2"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
            <td colspan="2">		<!--#include file="../../../includes/inc_botoes_consulta.asp"--> </td>
          </tr>
        </table>
<%
		sql = " select Codigo, Nome"
		sql = sql & " from MAL_Cliente"
		if strNome <> "" then
			sql = sql & " where Nome LIKE '%" & strNome & "%'"
		end if 
		sql=sql & " order by Nome"
		rs.open sql, cnn
	%>
		<br>
	  <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		<TR bgcolor="#E5E5E5">
				<td width="26%" class="celula"><strong>Codigio</strong></td>
				<td width="63%" class="celula"><strong>Nome</strong></td>
			</tr>
	<%	
			
		if rs.eof = false then
		
			while not rs.eof
				cont = cont + 1
				%>
				  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
					<td class="celula">&nbsp;<%=rs("Codigo")%></td>
					<td class="celula">&nbsp;<%=rs("Nome")%></td>
				  </tr>
			    <%				
				rs.movenext
			wend
			%>
			<tr><td class="celula" colspan="3">Total Registros : <%=cont%></td></tr>
			<%
		else
			%>
			<tr><td class="celula" colspan="3" align="center"><%=session("strMensagemNaoEncontrado")%></td></tr>
			<%
		end if
	rs.close
	%>
	</table>	  

</td>
</tr>
</table>
</form>
</body>
</html>