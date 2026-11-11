<%strNomeDaPaginaPortal = "Período de Requisição"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
			frm.cmbDepartamento.value=intCodigo
			frm.submit();
		}
	function consultar(intCodigo){
			frm.txtCodRequisicao.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="I") {
			if (frm.cmbDiaInicial.value == "0") {
				alert("Dia Inicial deve ser informado!");
				frm.cmbDiaInicial.focus();
				return false;
			}
	
			if (frm.cmbDiaFinal.value == "") {
				alert("Dia Final deve ser informado!");
				frm.cmbDiaFinal.focus();
				return false;
			}
		}
		if (parseInt(frm.cmbDiaInicial.value) > parseInt(frm.cmbDiaFinal.value)) {
			alert("Dia inicial não pode ser maior que dia final!");
			frm.cmbDiaInicial.focus();
			return false;
		}
		
		frm.action="periodorequisicao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%  
	strPaginaLimpar 	= "periodoRequisicao_cad.asp"
	strSubmitDepto 		= "S" 
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	
	intCodDepartamento	= Trim(Request("cmbDepartamento"))
	if intCodDepartamento = "" then intCodDepartamento = "0"
	
	intDiaInicialFiltro	= Trim(Request("cmbDiaInicialFiltro"))
	if intDiaInicialFiltro = "" then intDiaInicialFiltro = "0"
	
	intDiaFinalFiltro	= Trim(Request("cmbDiaFinalFiltro"))
	if intDiaFinalFiltro = "" then intDiaFinalFiltro = "0"
	
	strSituacao	= Trim(Request("cmbSituacao"))
	if strSituacao = "" then strSituacao = "T"

	strDesabilitaIncluir 	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir 	= "" 'Desabilita o botão Excluir
	strLiberaAlteracao		= "S"
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <form id="frm" name="frm" action="periodoRequisicao_cad.asp" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td height="23" class="TextoForm"><strong>Filtrar</strong></td>
            <td colspan="2" class="TextoForm">&nbsp;</td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Unidade:</td>
            <td colspan="2" class="TextoForm"><!--#include file="../../../includes/inc_cmbDepartamentoEstoque.asp" --></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Situa&ccedil;&atilde;o:</td>
            <td colspan="2" class="TextoForm"><select name="cmbSituacao" id="cmbSituacao" class="combo" onChange="submit()">
              <option <%if strSituacao = "T" then response.Write("selected")%> value="T">Todos</option>
              <option <%if strSituacao = "M" then response.Write("selected")%> value="M">Marcados</option>
              <option <%if strSituacao = "N" then response.Write("selected")%> value="N">Não Marcados</option>
              </select>
             </td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Per&iacute;odo:</td>
            <td colspan="2" class="TextoForm"><!--#include file="../../../includes/inc_cmbDiaInicialFiltro.asp"-->&nbsp;a&nbsp;<!--#include file="../../../includes/inc_cmbDiaFinalFiltro.asp"--></td>
          </tr>
          <tr>
            <td height="23" colspan="3" class="TextoForm"><hr></td>
            </tr>
          <tr>
            <td width="139" height="23" class="TextoForm">Liberar entre os dias:</td>
            <td colspan="2" class="TextoForm">
              <!--#include file="../../../includes/inc_cmbDiaInicial.asp"-->&nbsp;a&nbsp;<!--#include file="../../../includes/inc_cmbDiaFinal.asp"-->
              </td>
          </tr>
          <tr>
            <td height="23" colspan="2" class="TextoForm"><strong>Unidades</strong>            </td>
            <td width="348" class="TextoForm"><strong>Per&iacute;odo Liberado</strong></td>
          </tr>
          <%
			sql = "SELECT "
			sql = sql & " 	_d.codigo, "
			sql = sql & " 	upper(_d.descricao) as descricao,"
			sql = sql & " 	_r.DIA_FINAL,"
			sql = sql & " 	_r.DIA_INICIAL, _r.codigo as codLib"
			sql = sql & " from EST_departamento _d"
			sql = sql & " left join EST_LIBERA_REQUISICAO _r on _r.COD_DEPARTAMENTO = _d.CODIGO and _r.COD_EMPRESA = _d.COD_EMPRESA"
			sql = sql & " where _d.cod_Empresa = " & session("Codempresa")
			if intDiaInicialFiltro<>"0" then
				sql = sql & " and _r.DIA_INICIAL=" & intDiaInicialFiltro
			end if
			if intCodDepartamento<>"0" then
				sql = sql & " and _d.codigo=" & intCodDepartamento
			end if
			if intDiaFinalFiltro<>"0" then
				sql = sql & " and _r.DIA_FINAL=" & intDiaFinalFiltro
			end if
			if strSituacao="M" then
				sql = sql & " and _r.codigo is not null"
			end if
			if strSituacao="N" then
				sql = sql & " and _r.codigo is null"
			end if
			sql = sql & " order by "
			sql = sql & " 	_d.descricao "
			rs.open sql, cnn
			if rs.eof = false then
				strCorLinha = "#CCCCCC"
				while not rs.eof
					if strCorLinha = "#CCCCCC" then
						strCorLinha = "#FFFFFF"
					else
						strCorLinha = "#CCCCCC"
					end if
					if isnull(rs("DIA_INICIAL")) then
						periodo = "&nbsp;"
					else
						periodo = rs("DIA_INICIAL") & " a " & rs("DIA_FINAL")
					end if
					if isnull(rs("codLib")) then
						selecionado = ""
					else
						selecionado = "checked"
					end if
					%>
                      <tr bgcolor="<%=strCorLinha%>">
                        <td height="23" colspan="2" class="TextoForm"><input  name="chkDepartamentoEmpresa" id="chkDepartamentoEmpresa" <%=selecionado%> type="checkbox" value="<%=rs("codigo")%>"><%=rs("descricao")%></td>
                        <td height="23" class="TextoForm"><%=periodo%></td>
                      </tr>
                    <%
					rs.movenext
				wend
			end if
			rs.close
			%>
          <tr>
            <td height="24" colspan="3" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="3"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
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