<%strNomeDaPaginaPortal = "Consulta Autorização Emergencial"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function resultadoConsulta(intCodigo,usuario){
			var frm = document.getElementById("frm");
			frm.txtCodigoAutorizacao.value=intCodigo
			frm.txtUsuarioAutorizacao.value=usuario
			frm.action="SolicitacaoEmergencial_cad.asp";
			frm.submit();
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
    <input type="hidden" id="txtCodigoAutorizacao" name="txtCodigoAutorizacao">
    <input type="hidden" id="txtUsuarioAutorizacao" name="txtUsuarioAutorizacao">

   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
        
        <tr valign="top">
          <td width="41" class="tituloPrincipal style2"><%
				cont =0

					strUsuario_incl   	=	session("strNomeUsuario")

					sql = "select a.codigo, a.solicitante, upper(u.nome) as nome, d.DESCRICAO as depto, a.situacao, a.data, isnull(r.codSituacao,0) as codSituacao, sr.descricao as sit"
					sql = sql & " from EST_RequisicaoEmergencialAutorizacao a"
					sql = sql & " inner join SEG_usuarios u on u.cpf = a.solicitante"
					sql = sql & " inner join EST_departamento d on d.codigo = u.codDepartamento"
					sql = sql & " left join EST_Requisicao r on r.codigo = a.cod_requisicao"
					sql = sql & " left join EST_situacao sr on sr.codigo = r.codSituacao"
					sql = sql & " Where a.CodEmpresa	= " & session("codEmpresa")
					sql = sql & " and a.solicitante	= '" & strUsuario_incl & "'"
					sql = sql & " order by a.data desc"
					
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
            <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr bgcolor="#E5E5E5">
                <td height="21" colspan="5" align="center" class="celula"><strong>LISTA DE AUTORIZA&Ccedil;&Atilde;O PARA SOLICITA&Ccedil;&Atilde;O EMERGENCIAL<br>
                  </strong>(Clique na autoriza&ccedil;&atilde;o para sua libera&ccedil;&atilde;o)</td>
                </tr>
              <tr bgcolor="#E5E5E5">
                <td class="celula"><strong>Aut.</strong></td>
                <td width="22%" height="21" class="celula"><strong>Unidade Autorizada</strong></td>
                <td width="23%" class="celula"><strong>Solicitante Autorizado</strong></td>
                <td width="29%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                <td width="21%" class="celula"><strong>Data</strong></td>
                </tr>
              <%
						while not rs.eof
							msn = ""
							if trim(rs("codSituacao")) = "2" or trim(rs("codSituacao")) = "3" or trim(rs("codSituacao")) = "4" then
								msn = " - <strong>" & rs("sit") & "</strong>"
							end if
							%>
              <tr <%if rs("codSituacao") = "0" or rs("codSituacao") = "1" then%>style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>','<%=rs("solicitante")%>')" <%else%> bgcolor="#CCCCCC" <%end if%>>
                <td width="5%" class="celula"><%=rs("Codigo")%></td>
                <td height="21" class="celula"><%=trim(rs("depto"))%></td>
                <td class="celula"><%=trim(rs("nome"))%></td>
                <td class="celula"><strong><%=trim(rs("situacao"))%><%=msn%></strong></td>
                <td class="celula"><%=trim(rs("data"))%></td>
                </tr>
              <%				
					rs.movenext
					wend
					%>
              </table>
            <%
			  else
			  		response.Write "<br><p align='center'>Não existe Autorização Emergencial</p><br>"
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