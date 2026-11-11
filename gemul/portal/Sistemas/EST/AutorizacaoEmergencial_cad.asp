<%strNomeDaPaginaPortal = "Autorização Emergencial"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}


	function excluir(codigo){
		
		var frm = document.getElementById("frm");
		
		var men = 'ATENÇÃO: Deseja excluir essa autorização?\n';
		if (confirm(men)) {
			frm.action="AutorizacaoEmergencial_cod.asp?acao=E&txtCodigo=" + codigo;
			frm.submit();
			return true;
		}else{
			return false;
		}
		
 	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbDepartamento.value == "0") {
			alert("A Unidade deve ser informada !");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		if (frm.cmbUsuario.value == "0") {
			alert("Usuário deve ser informado!");
			frm.cmbUsuario.focus();
			return false;
		}
		
		frm.action="AutorizacaoEmergencial_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	intCodDepartamento 		= Trim(Request.Form("cmbDepartamento"))
	if intCodDepartamento = "" then intCodDepartamento = 0
	intCodUsuario	 		= Trim(Request.Form("cmbUsuario"))

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
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
            <td width="16%" height="23" class="TextoForm">Unidade</td>
            <td width="25" class="TextoForm"><%strSubmitDepto = "S"%><!--#include file="../../../includes/inc_cmbDepartamentoEstoque.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Solicitante</td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbUsuariosDepartamento.asp"--></td>
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



					sql = "select a.codigo, upper(u.nome) as nome, d.DESCRICAO as depto, a.situacao, a.data"
					sql = sql & " from EST_RequisicaoEmergencialAutorizacao a"
					sql = sql & " inner join SEG_usuarios u on u.cpf = a.solicitante"
					sql = sql & " inner join EST_departamento d on d.codigo = u.codDepartamento"
					sql = sql & " Where a.CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " order by a.data desc"
					
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>Aut.</strong></td>
                        <td width="26%" height="21" class="celula"><strong>Unidade</strong></td>
                        <td width="27%" class="celula"><strong>Solicitante</strong></td>
                        <td width="19%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                        <td width="19%" class="celula"><strong>Data</strong></td>
                        <td width="5%" align="center" class="celula"><strong>Excluir</strong></td>
                        </tr>
              			<%
						while not rs.eof
							%>
                            <tr  onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="4%" class="celula"><%=rs("Codigo")%></td>
                            <td height="21" class="celula"><%=trim(rs("depto"))%></td>
                            <td class="celula"><%=trim(rs("nome"))%></td>
                            <td class="celula"><%=trim(rs("situacao"))%></td>
                            <td class="celula"><%=trim(rs("data"))%></td>
                            <td align="center" class="celula">&nbsp;<%if trim(rs("situacao")) = "AUTORIZADO" then%><a href="#" onClick="excluir('<%=rs("Codigo")%>')"><img border="0" src="../../../images/botao_vermelho_over.gif" width="26" height="26" alt="Excluir autorização"></a><%end if%>&nbsp;</td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
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