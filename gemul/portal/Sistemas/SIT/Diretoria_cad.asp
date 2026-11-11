<%strNomeDaPaginaPortal = "Cadastro de Diretoria "%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.action="Destaque_cad.asp?txtCodigo="+intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
	
		if (acao=="I"){
		
			if (frm.txtDescricao.value == "") {
				alert("A Descrição do Link deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
			
			if (frm.Foto.value == "") {
				alert("A Foto deve ser informada !");
				frm.Foto.focus();  
				return false;
			}	
			
			frm.action="Diretoria_cod.asp?acao="+acao;
			frm.submit();
			return true;
		
		}
		
		if (acao=="E"){
			
			var men = 'ATENÇÃO: Deseja realmente excluir este Destaque?\n '
			if (confirm(men)) {
				frm.action="Diretoria_cod_e.asp?id="+ frm.txtCodigo.value;
				frm.submit();
			} else {
				return false;
			}
		
		}
	}
</script>
<%
	principal			= "principal.asp"
	intCodigo 			= Trim(Request("txtCodigo"))
	intCodEmpresa 		= session("codEmpresa")
	strDescricao 		= Trim(Request("txtDescricao"))
	strSite		 		= Trim(Request("txtSite"))
	strLinkNoticia	    = Trim(Request("txtLinkNoticia"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT  Codigo, Descricao"
		sql = sql & " FROM SIT_Diretoria"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & session("codEmpresa")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strDescricao		= rs("Descricao")
			strFoto				= rs("Codigo") & "_g.jpg"
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoPDF   				= "disabled"
	end if 
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">
	<form name="frm" action="" method="POST" enctype="multipart/form-data">
   	<!-- inicio do formulario da pagina-->
    <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td align="left" >
		  <!-- inicio tabela de cadastro de funcionario -->
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td height="23" class="TextoForm">&nbsp;</td>
			    <td class="TextoForm"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
			    </tr>
			  <tr>
				<td width="16%" height="23" class="TextoForm">Descri&ccedil;&atilde;o:</td>
				<td width="25" class="TextoForm"><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
				</tr>
			  <tr>
			    <td height="24" class="TextoForm"><span class="texto">Selecione a Foto:</span></td>
			    <td class="TextoForm"><input type="file" name="Foto" id="Foto" class="text" value="" style="width:400px;">
			      <span class="titulo1">
			        <input name="txtFoto" type="hidden" class="text" id="txtFoto" size="40" maxlength="40" value="<%=strFoto%>" />
		          </span></td>
			    </tr>
			</table>
		</td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><%
				cont =0
					
					sql = "SELECT Codigo, Descricao"
					sql = sql & " FROM SIT_Diretoria"
					sql = sql & " Where CodEmpresa = " & session("codEmpresa")
					sql = sql & " Order by Codigo"
					rs.open sql, cnn
									
					if rs.eof = false then
						%>
                        <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                            <tr bgcolor="#E5E5E5">
                            <td class="celula"><strong>C&oacute;digo</strong></td>
                            <td height="21" class="celula"><strong>Descricao</strong></td>
                          </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							
							intID			= trim(rs("Codigo")) 
							%>
                              <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                                <td width="10%" class="celula"><%=rs("Codigo")%></td>
                                <td height="21" class="celula"><%=trim(rs("Descricao"))%></td>
                              </tr>
                              <%				
						rs.movenext
						wend
						%>
              		<tr>
                	<td height="21" colspan="2" class="celula">Total Registros : <%=cont%></td>
              	</table>
            	<%
			  end if
			  rs.close%>
          </td>
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
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>