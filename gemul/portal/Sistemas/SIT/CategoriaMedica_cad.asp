<%strNomeDaPaginaPortal = "Cadastro de M&eacute;dicos"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	
	function abreMedico(codigo){
		var caminho
		caminho = "Medicos_cad.asp?CodCategoria=" + codigo
		window.open(caminho ,"","toolbar=no,status=no,location=no,scrollbars=no,menubar=no,resizable=no,width=600,height=600,top=0,lef=0");
	}
		
	function resultadoConsulta(intCodCategoria){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodCategoria.value=intCodCategoria
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtCategoria.value == "") {
			alert("A Categoria deve ser informada !");
			frm.txtCategoria.focus();
			return false;
		}

		frm.action="CategoriaMedica_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%	
	principal		= "principal.asp"
	intCodEmpresa	= session("codEmpresa")	
	intCodCategoria = Trim(Request.Form("txtCodCategoria"))
	strCategoria 	= Trim(Request.Form("txtCategoria"))
	
	if intCodCategoria <> "" then 
		
		sql = " SELECT Codigo, Descricao" 
		sql = sql & " FROM SIT_CategoriaMedica " 
		sql = sql & " Where Codigo = " & intCodCategoria
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
					
		if rs.eof = false then

			strCategoria 		 = rs("Descricao")
			
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar'
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			BotaoMedico			 = "" 'Habilita o Botão Limpar'
				
		end if 
		rs.close
	
	else
	
		strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar'
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir'
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		BotaoMedico			 = "disabled" 'Desabilita o botão Excluir
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
        <tr>
          <td height="27" class="TextoForm">Categoria :  </td>
          <td><input name="txtCodCategoria" value="<%=intCodCategoria%>" type="hidden" id="txtCodCategoria">
            <input name='txtCategoria' class="text" type='text' id="txtCategoria" value='<%= strCategoria%>' size='40' maxlength='40'></td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td><span class="texto">
            <input name="cmdMedicos" type='button' class='botao' id="cmdMedicos" value='Incluir M&eacute;dicos' onClick="abreMedico('<%=intCodCategoria%>')"<%=BotaoMedico%>>
          </span></td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm"><%
							cont =0
									
								sql = " SELECT Codigo,Descricao" 
								sql = sql & " FROM SIT_CategoriaMedica " 
								sql = sql & " Where CodEmpresa = " & intCodEmpresa
								sql = sql & " Order by Codigo"
							
								rs.open sql, cnn
												
								if rs.eof = false then
									
									%>
            <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr bgcolor="#E5E5E5">
                <td class="celula"><strong>C&oacute;digo</strong></td>
                <td height="21" class="celula"><strong>Categoria</strong></td>
              </tr>
              <%
								while not rs.eof
									cont = cont + 1	
							%>
              <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                <td width="11%" class="celula"><%=rs("Codigo")%></td>
                <td width="89%" height="21" class="celula"><%=trim(rs("Descricao"))%></td>
              </tr>
              <%				
								rs.movenext
								wend
							%>
              <tr>
                <td height="21" colspan="2" class="celula">Total 
                  Registros : <%=cont%></td>
              </table>
            <%
						  end if
						  rs.close%></td>
        </tr>
        <tr>
          <td  width="13%" class="TextoForm">&nbsp;</td>
          <td width="87%">&nbsp;</td>
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
