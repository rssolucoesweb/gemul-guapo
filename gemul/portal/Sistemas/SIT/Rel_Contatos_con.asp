<%strNomeDaPaginaPortal = "Contatos pelo Site"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function ResponderEmail(intCodContato){
		window.open("RespondeEmail.asp?intCodContato="+intCodContato,"","toolbar=no,status=no,location=no,scrollbars=yes,menubar=no,resizable=no,width=438,height=380,top=100,lef=400");			
	}

	function salvar(acao){		
		
		var frm = document.getElementById("frm");
		
		var intContMarcado=0;
		//*****verifica se um aluno foi selecionado
		for (var i = 0; i < frm.elements.length; i++) {
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (frm.elements[i].checked){
					intContMarcado = intContMarcado + 1;
				}
			}
		}	
			
		if (intContMarcado==0){
			alert("Selecione um Contato para ela ser excluida!");
			return false;
		}

		frm.action="Contato_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
		
	}
</script>
<%		
		principal				= "principal.asp"
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
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
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td height="23" class="TextoForm"><table width="100%" border="0">
                  <tr>
                    <td class="TextoForm"><strong>Obs 
                      : Para responder o e-mail, passe o mouse em cima do 
                      campo <font color="#FF0000">e-mail</font></strong></td>
                  </tr>
                  <tr>
                  <td class="TextoForm">
					<%
					sql = "Select Codigo, Nome, Email, Telefone, Data, Assunto, Mensagem, Status"
					sql = sql & " FROM SIT_Contatos"
					sql = sql & " Order by Data desc"
					rs.open sql, cnn

					if rs.eof = false then
						%></td>
                  </tr>
                  <tr>
				 
                    <td class="TextoForm">
					
					  <%
							while not rs.eof
							cont = cont + 1
							
							strStatus = rs("Status")
							
							if strStatus = "L" then
								strStatus = "E-mail j&aacute; respondido"
								strCor 	  = "#0000FF"
							else
								strStatus = "E-mail ainda n&atilde;o respondido"
								strCor 	  = "#FF0000"
							end if
							%>
					<table width = "100%"  border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                          <tr>
                            <td width="4%" rowspan="7" align="center" bgcolor="#CCCCCC" class="celula"><input name="chkSelecionar" type="checkbox" value="<%=rs("Codigo")%>"></td>
                            <td colspan="4" class="celula"><font color="<%=strCor%>"><%=strStatus%></font></td>
                          </tr>
                          <tr>
                            <td width="14%" class="celula" ><strong>Nome :</strong></td>
                            <td colspan="3" class="celula"><%=rs("Nome")%></td>
                          </tr>
                          <tr>
                            <td class="celula"><strong>E-Mail :</strong></td>
                            <td class="celula" width="45%" style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return ResponderEmail('<%=rs("Codigo")%>')"><%=rs("Email")%>
                            <td width="14%" class="celula"><strong>Telefone 
                              :</strong></td>
                            <td width="23%" class="celula"><%=rs("Telefone")%></td>
                          </tr>
                          <tr>
                            <td class="celula"><strong>Data :</strong></td>
                            <td colspan="3" class="celula"><%=FormataDataAP(rs("Data"))%>&nbsp;</td>
                          </tr>
                          <tr>
                            <td class="celula"><strong>Asssunto :</strong></td>
                            <td colspan="3" class="celula"><%=rs("Assunto")%></td>
                          </tr>
                          <tr>
                            <td class="celula"><strong>Mensagem :</strong></td>
                            <td colspan="3" class="celula"><div align="justify"><%=rs("Mensagem")%></div></td>
                          </tr>
                          <tr>
                            <td colspan="4" class="celula">&nbsp;</td>
                          </tr>
					</table>
						  <br>
						  <%				
							rs.movenext
							wend
						end if
						rs.close
						  %>					    </td>
                  </tr>
                  <tr>
                    <td></td>
                  </tr>
                </table>			  </tr>
			</table>		  </td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><table width = "100%"  border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr>
              <td height="21" colspan="5" class="celula"><font color="#CC3300"><strong>Total 
                Contatos :</strong></font> <%=cont%></td>
            </table></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
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
