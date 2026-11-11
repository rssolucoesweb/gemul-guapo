<%strNomeDaPaginaPortal = "Usuário/Departamento"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtCPF.value == "") {
			alert("Usuário deve ser informado !");
			frm.txtCPF.focus();
			return false;
		}
		if (frm.cmbDepartamento.value == "0") {
			alert("Departamento deve ser informado !");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		frm.action="usuarioDepartamento_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strCPF				= Trim(Request.Form("txtCPF"))

	if trim(strCPF)<>"" then
		'acessa o cadastra de senha
		sql = " SELECT nome"
		sql = sql & " FROM SEG_usuarios" 
		sql = sql & " WHERE cpf = " & formataCpfBD(strCPF)
		rs.open sql , cnn		
		if not rs.eof then	
			strNomeServidor = rs("nome")
		end if
		rs.close		
	end if		

	if trim(intCodigo) <> "" then
	
		sql = "SELECT u.CODIGO, u.cpf_SEG_usuarios, u.cod_departamento, us.nome "
		sql = sql & " FROM PRO_UsuarioDepartamento u"
		sql = sql & " inner join SEG_usuarios us on us.cpf = u.cpf_SEG_usuarios"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_Empresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strCPF				= rs("cpf_SEG_usuarios")
			strNomeServidor		= rs("nome")
			intCodDepartamento	= rs("cod_departamento")
						
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
            <td height="23" class="TextoForm">usu&aacute;rio:
              <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
            <td class="TextoForm"><input name="txtCPF" type="text" class="caixaTexto" id="txtCPF" onBlur="validaCPF(this); return reload()" onKeyPress="return formataCampo(this, 5, 14)" value="<%=formataCpfAP(strCPF)%>" size="15" maxlength="14">
              <a href="#" onClick="return abreConsulta('../seg/Seg_UsuarioEmpresa_con.asp')"> <img src="../../../images/Consulta_normal.gif" alt="" name="Consulta" width="26" height="26" border="0" align="absmiddle"></a>&nbsp;&nbsp;<strong><%=strNomeServidor%></strong></td>
          </tr>
          <tr>
            <td width="16%" height="23" class="TextoForm">Departamento:</td>
            <td width="25" class="TextoForm"><!--#include file="../../../includes/inc_cmbDepartamentoProtocolo.asp"-->
            </td>
            </tr>
          <tr>
            <td height="24" colspan="2" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="2"><%
				cont =0

					sql = "select u.codigo, u.cpf_SEG_usuarios, us.nome, d.descricao as departamento"
					sql = sql & " from PRO_UsuarioDepartamento u"
					sql = sql & " inner join SEG_usuarios us on us.cpf = u.cpf_SEG_usuarios"
					sql = sql & " inner join PRO_Departamento d on d.codigo = u.cod_departamento"
					sql = sql & " Where u.Cod_Empresa	= " & session("codEmpresa")	
					sql = sql & " Order by us.nome"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>Usu&aacute;rio</strong></td>
                        <td width="54%" height="21" class="celula"><strong>Departamento</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="46%" class="celula"><%=rs("nome")%></td>
                            <td height="21" class="celula"><%=trim(rs("departamento"))%></td>
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