<%strNomeDaPaginaPortal = "Cadastro de Video"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>

<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("O Descrição deve ser informado !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtLink.value == "") {
			alert("O Link deve ser informado !");
			frm.txtLink.focus();
			return false;
		}
		
		if (frm.txtData.value == "") {
			alert("O Data deve ser informada !");
			frm.txtData.focus();
			return false;
		}
							
		frm.action="Videos_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
	
</script>
<%
	principal			= "principal.asp"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo	 		= Trim(Request("txtCodigo"))
	strDescricao 		= Trim(Request("txtDescricao"))
	strLink				= Trim(Request("txtLink"))
	strData 			= Trim(Request.Form("txtData"))
	
	if strData = "" then strData = formataDataAP(date)
	
	if trim(intCodigo) <> "" then
		
		sql = "SELECT Codigo, Descricao, Link, Data"
		sql = sql & " FROM SIT_Video"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strDescricao		= rs("Descricao")
			strLink				= rs("Link")
			strData 			= formataDataAP(rs("Data"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoSeguimento		 	= "" 'Desabilita o botão Excluir
			
		end if 
		rs.close
	else
	
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoSeguimento		 = "disabled" 'Desabilita o botão Excluir
	end if 
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">
        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->

	<table width="98%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="left" >
		  <!-- inicio tabela de cadastro de funcionario -->
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td height="27" class="TextoForm">Descri&ccedil;&atilde;o:<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
			    <td class="TextoForm"><input name="txtDescricao" type="text" class="text" id="txtDescricao" value="<%=strDescricao%>" size="50"></td>
			    <td class="TextoForm">&nbsp;</td>
			    </tr>
			  <tr>
			    <td height="27" class="TextoForm">Link:</td>
			    <td class="TextoForm"><input name="txtLink" type="text" class="text" id="txtLink" value="<%=strLink%>" size="50"></td>
			    <td class="TextoForm">&nbsp;</td>
			    </tr>
			  <tr>
			    <td height="27" class="TextoForm">Data:</td>
			    <td class="TextoForm"><span class="texto">
			      <input name="txtData" type="text"  value="<%=strData%>" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="14" maxlength="11">
			    </span></td>
			    <td class="TextoForm">&nbsp;</td>
			    </tr>
			</table>
		  <!-- fim tabela de cadastro de funcionario -->		  </td>
        </tr>
        <tr valign="top">
          <td class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
        <td class="tituloPrincipal style2">
		<%
		cont = 0
		
		sql = "SELECT Codigo, Descricao, Data"
		sql = sql & " FROM SIT_Video"
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		sql = sql & " ORDER BY Codigo"
		rs.open sql, cnn
							
		if rs.eof = false then
		%>
		<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
			<tr bgcolor="#E5E5E5">
			<td class="celula"><strong>C&oacute;digo</strong></td>
			<td width="48%" bgcolor="#E5E5E5" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
			<td width="41%" height="21" bgcolor="#E5E5E5" class="celula"><strong>Data</strong></td>
		</tr>
		  <%
		  while not rs.eof
		  cont = cont + 1	
		  %>
		  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
			<td width="11%" class="celula"><%=rs("Codigo")%></td>
			<td height="20" class="celula"><%=trim(rs("Descricao"))%>&nbsp;</td>
			<td height="20" class="celula"><%=trim(formataDataAP(rs("Data")))%></td>
		  </tr>
		  <%				
			rs.movenext
			wend
		%>
	  <tr>
		<td height="21" colspan="3" class="celula">Total 
		  Registros : <%=cont%></td>
	  </table>
	<%
	  end if
	  rs.close%></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
      </table>

   	<!-- fim do formulario da pagina-->
    </form>
    
                    </td>
            </tr>
        </table>
        <hr size="1" color="#FFFFFF">

    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>
