<html>
<head>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_popup.css">
<link href="../estilo/css.css" rel="stylesheet" type="text/css">
<title>Consulta Usuários</title>
<script src="../js/js_funcoes_gerais.js"></script>
<script>
	function resultadoConsulta(cod){
		window.opener.frm.txtCodEmpresa.value=cod;
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
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_formataCPF.asp"-->
         <hr size="1" color="#FFFFFF">
        <table width="100%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="100%" class="CelulaDoCadastro" align="center" valign="top">

<form method="POST" id="frm" action="#">
<div class="TituloFormulario" align="center">Consulta Empresas</div>

<table width="90%" align="center" class="formulario">
	<tr>
		<td>
<%  
   strNome 		= request.form("txtNome")
%>
 
<table width="100%" border="0">
          <tr> 
            <td width="221">Raz&atilde;o Social</td>
            <td width="750"><input name="txtNome" type="text" id="txtNome" class="caixaTexto" size="40" maxlength="50"  onKeyPress="return formataCampo(this, 1, 50)"  value="<%=strNome%>"></td>
          </tr>
          <tr> 
            <td colspan="2"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
            <td colspan="2">		<!--#include file="../includes/inc_botoes_consulta.asp"--> </td>
          </tr>
        </table>
<%
		sql = " select codigo, razaoSocial, cnpj"
		sql = sql & " from SEG_empresa"
		sql = sql & " where codGrupo = " & session("codGrupo")
		if strNome <> "" then
			sql = sql & " and razaoSocial LIKE '%" & strNome & "%' COLLATE SQL_Latin1_General_CP1_CI_AI "
		end if 
		sql=sql & " order by razaoSocial"
		rs.open sql, cnn
	%>
		<br>
	  <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		<TR bgcolor="#E5E5E5">
				<td width="26%" class="celula"><strong>CNPJ</strong></td>
				<td width="63%" class="celula"><strong>Raz&atilde;o Social</strong></td>
			</tr>
	<%	
			
		if rs.eof = false then
		
			while not rs.eof
				cont = cont + 1
				%>
				  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
					<td class="celula">&nbsp;<%=formataCpfAP(rs("cnpj"))%></td>
					<td class="celula">&nbsp;<%=rs("razaoSocial")%></td>
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
                </td>
            </tr>
        </table>
        <hr size="1" color="#FFFFFF">

</body>
</html>