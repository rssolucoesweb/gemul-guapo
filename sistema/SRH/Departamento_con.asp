<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 16/09/2007
	::	Desenvolvedores...: Sérgio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta Empresa
-->
<html>
<head>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<title>Consulta de Departamento</title>
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function resultadoConsulta(intCodigo, strDescDepto){
		window.opener.document.getElementById('txtCodDepto').value = intCodigo;
		window.opener.document.getElementById('txtDescDepto').value =  strDescDepto; 
		window.opener.document.getElementById('frm').submit();
		window.close();
	}
</script></head>
<body   topmargin="0" leftmargin="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<form method="POST" id="frm" "#">
<table width="98%" align="center" class="corFundo">
<tr> 
	<td>
	<%  
	strDescricao 			= trim(request.form("txtDescricao"))
	IntCodEmpresa 			= Session("CodEmpresa")
	%>
	<table width="100%" border="0">
          <tr> 
            <td width="121" class="label">Departamento:</td>
            <td width="630"><input name="txtDescricao" type="text" id="txtDescricao" onKeyPress="return formataCampo(this, 1, 50)" class="text" size="40" maxlength="50" value="<%=strDescricao%>"></td>
          </tr>
          <tr> 
            <td colspan="2"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
            <td colspan="2"> 
              <!--#include file="../../includes/inc_botoes_consulta.asp"-->            </td>
          </tr>
        </table>
		<br>
		<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
    	<tr bgcolor="#CCCCCC">
    	  <td width="13%" class="celula"><strong>C&oacute;digo</strong></td> 
        <td width="51%" class="celula"><strong>Departamento</strong></td>
       </tr>
    <%
		IF IntCodEmpresa = "" THEN IntCodEmpresa = "0"
		sql = "SELECT CODIGO, DESCRICAO "
		sql = sql & " FROM SEG_DEPARTAMENTO"
		if strCompartilharDados = "S" then
			sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		else   
			sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
		end if   
		if strDescricao <> ""then
			sql = sql & " and DESCRICAO LIKE '%" & strDescricao  & "%'"
		end if 
		sql = sql & " ORDER BY DESCRICAO"

		rs.open sql, cnn
		
		cont=0
		if rs.eof = false then

			while not rs.eof
					
			cont = cont + 1		
			%>
          <tr bgcolor="#FFFFFF"  style="cursor:hand" onClick="return resultadoConsulta('<%=rs("CODIGO")%>','<%=rs("DESCRICAO")%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
            <td class="celula">&nbsp;<%=trim(rs("CODIGO"))%></td> 
            <td class="celula">&nbsp;<%=trim(rs("DESCRICAO"))%></td>
          </tr>
          <%				
			rs.movenext
			wend
	else
		%>
          <strong> 
          <center>
            <%=strMensagemNaoEncontrado%> 
          </center>
          </strong> 
          <%		
	end if
	rs.close
%>
          <tr bgcolor="#FFFFFF"> 
            <td height="20" colspan="4" class="celula">Total de Sistemas : <%=cont%></td>
          </tr>
        </table>
</td>
</tr>
</table>
</form>
</body>
</html>