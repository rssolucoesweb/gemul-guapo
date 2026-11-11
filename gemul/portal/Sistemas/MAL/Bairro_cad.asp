<%strNomeDaPaginaPortal = "Cadastro de Bairro"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbCidade.value == "0") {
			alert("A Cidade deve ser informada !");
			frm.cmbCidade.focus();
			return false;
		}
		
		if (frm.txtBairro.value == "") {
			alert("O Bairro deve ser informado !");
			frm.txtBairro.focus();
			return false;
		}
	
		frm.action="Bairro_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	intCodCidade		= Trim(Request.Form("cmbCidade"))
	strBairro			= Trim(Request.Form("txtBairro"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, CodCidade, Bairro"
		sql = sql & " FROM MAL_Bairro"
		sql = sql & " Where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			intCodCidade		= rs("CodCidade")
			strBairro			= rs("Bairro")
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
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

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td height="23" class="TextoForm"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              Cidade:</td>
            <td class="TextoForm">
            
            <select name="cmbCidade" id="cmbCidade" class="combo"  style="width:200pt" onChange="submit()">
            <option value="0">Selecione...</option>
            <%
            sql = " Select Codigo, Descricao "
            sql = sql & " from MAL_Cidade"
            sql = sql & " order by Codigo"
            rs.open sql, cnn
            if rs.eof = false then
                while not rs.eof
                    if cstr(intCodCidade) = cstr(rs("codigo")) then
                        strSelecionado = "selected"
                    else
                        strSelecionado = ""
                    end if
                    response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("Descricao") & "</option>" & vbcrlf
                    rs.movenext
                wend
            end if
            rs.close
            %>
        </select>
            </td>
          </tr>
          <tr>
            <td width="16%" height="23" class="TextoForm">Bairro:              </td>
            <td width="25" class="TextoForm"><input name="txtBairro" type="text" class="text" id="txtBairro" size="40" maxlength="40" value="<%=strBairro%>"></td>
          </tr>
          <tr>
            <td height="24" colspan="2" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="2"><%
		  
		  if trim(intCodCidade) <> "" then 
				cont =0

					sql = "SELECT Codigo, CodCidade, Bairro"
					sql = sql & " FROM MAL_Bairro"
					sql = sql & " Where CodCidade = " & intCodCidade
					sql = sql & " Order by Codigo"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="89%" height="21" class="celula"><strong>Bairro</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="11%" class="celula"><%=rs("Codigo")%></td>
                            <td height="21" class="celula"><%=trim(rs("Bairro"))%></td>
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
			  rs.close
			  
		end if
		
			  %></td>
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