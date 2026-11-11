<%strNomeDaPaginaPortal = "Abrir Protocolo"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function recibo(){
		frm.action="AbrirProtocolo_rel.asp";
		frm.submit();
 	}		
	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTipoProtocolo.value == "0") {
			alert("Tipo Protocolo deve ser informado !");
			frm.cmbTipoProtocolo.focus();
			return false;
		}
		if (frm.txtCPF.value == "") {
			alert("CPF do Requerente deve ser informado !");
			frm.txtCPF.focus();
			return false;
		}
		if (frm.txtRequerente.value == "") {
			alert("Requerente deve ser informado !");
			frm.txtRequerente.focus();
			return false;
		}
		if (frm.cmbAssunto.value == "0") {
			alert("Assunto deve ser informada !");
			frm.cmbAssunto.focus();
			return false;
		}
		if (frm.cmbTipoDocumento.value == "0") {
			alert("Tipo Documento deve ser informado !");
			frm.cmbTipoDocumento.focus();
			return false;
		}
		if (frm.cmbDepartamento.value == "0") {
			alert("Departamento deve ser informado !");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		if (frm.txtMotivo.value == "") {
			alert("Motivo deve ser informado !");
			frm.txtMotivo.focus();
			return false;
		}
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}

		frm.action="AbrirProtocolo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	strMostraBotaoReciboProtocolo = "S"
	strDesabilitaBotaoReciboProtocolo = "disabled"
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strTipoProtocolo 	= Trim(Request.Form("cmbTipoProtocolo"))
	strRequerente 		= Trim(Request.Form("txtRequerente"))
	strCPF			 	= Trim(Request.Form("txtCPF"))
	intCodAssunto 		= Trim(Request.Form("cmbAssunto"))
	intCodTipoDocumento = Trim(Request.Form("cmbTipoDocumento"))
	intCodDepartamento 	= Trim(Request.Form("cmbDepartamento"))
	strSituacao 		= "ABERTO"
	intCodSituacao 		= "1"
	strNumeroDocumento 	= Trim(Request.Form("txtNumeroDocumento"))
	strMotivo 			= Trim(Request.Form("txtMotivo"))
	strObs		 		= Trim(Request.Form("txtObs"))
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT p.codigo, p.cod_empresa, p.numero, p.TipoProtocolo, p.ano, p.dataAbertura, p.requerente, p.cpf, p.cod_Assunto, p.motivo, p.obs, p.cod_TipoDocumento, p.numeroDocumento, "
		sql = sql & " s.descricao as Situacao, p.cod_Departamento, p.cod_Situacao"
		sql = sql & " FROM PRO_Protocolo p inner join pro_situacao s on s.codigo = p.cod_situacao"
		sql = sql & " Where p.Codigo = " & intCodigo
		sql = sql & " And p.Cod_Empresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strNumero			= Trim(rs("numero"))
			strTipoProtocolo 	= Trim(rs("TipoProtocolo"))
			strRequerente	 	= Trim(rs("Requerente"))
			strCPF			 	= Trim(rs("CPF"))
			intCodAssunto 		= Trim(rs("cod_Assunto"))
			intCodTipoDocumento = Trim(rs("cod_TipoDocumento"))
			intCodDepartamento 	= Trim(rs("cod_Departamento"))
			intCodSituacao 		= Trim(rs("cod_Situacao"))
			strSituacao 		= Trim(rs("Situacao"))
			strNumeroDocumento 	= Trim(rs("NumeroDocumento"))
			strMotivo 			= Trim(rs("motivo"))
			strObs		 		= Trim(rs("Obs"))
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			strDesabilitaBotaoReciboProtocolo = ""
			if intCodSituacao<>"1" then
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaBotaoReciboProtocolo = ""
			end if


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
                <td width="97%" class="TextoForm" align="center" valign="top">
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td width="137" height="28" class="TextoForm">Data Abertura:
              <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
            <td width="354" class="TextoForm"><strong><%=FORMATADATAAP(DATE)%></strong></td>
            <td width="120" class="TextoForm"><%if intCodigo<>"" then%>
            N&uacute;mero:
            <%end if%></td>
            <td width="243" class="TextoForm"><%if intCodigo<>"" then%><strong><font color="#000099"><%=strNumero%></font></strong><%end if%></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Tipo Protocolo:</td>
            <td colspan="3" class="TextoForm"><select name="cmbTipoProtocolo" class="Combo" id="cmbTipoProtocolo">
              <option value="0">Selecione...</option>
              <option value="INTERNO" <%if strTipoProtocolo = "INTERNO" then response.Write("selected") %>>INTERNO</option>
              <option value="EXTERNO" <%if strTipoProtocolo = "EXTERNO" then response.Write("selected") %>>EXTERNO</option>
            </select></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">CPF/Requerente:</td>
            <td colspan="3" class="TextoForm"><input name="txtCPF" type="text" class="text" id="txtCPF" value="<%=strCPF%>" onBlur="validaCPF(this)" onKeyPress="return formataCampo(this, 5, 14)" size="15" maxlength="14">
            /
              <input name="txtRequerente" type="text" class="text" id="txtRequerente" size="60" maxlength="150" value="<%=strRequerente%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Assunto:</td>
            <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbAssuntoProtocolo.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Tipo de Documento:</td>
            <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbTipoDocumentoProtocolo.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">N&uacute;mero Documento:</td>
            <td colspan="3" class="TextoForm"><input name="txtNumeroDocumento" type="text" class="text" id="txtNumeroDocumento" size="40" maxlength="40" value="<%=strNumeroDocumento%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Departamento Destino:</td>
            <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbDepartamentoProtocolo.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Motivo:              </td>
            <td colspan="3" class="TextoForm"><input name="txtMotivo" type="text" class="text" id="txtMotivo" size="80" maxlength="200" value="<%=strMotivo%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Observa&ccedil;&atilde;o: </td>
            <td colspan="3" class="TextoForm"><textarea name="txtObs" id="txtObs" cols="75" rows="3" class="text"><%=strObs%></textarea></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Situa&ccedil;&atilde;o:</td>
            <td colspan="3" class="TextoForm"><strong><%=strSituacao%></strong></td>
          </tr>
          <tr>
            <td height="24" colspan="4" class="TextoForm">&nbsp; <input name="cmbSituacao" type="hidden" id="cmbSituacao" class="text" size="10" value="<%=intCodSituacao%>" maxlength="10"></td>
          </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="4"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="4"><%
				cont =0

					sql = "select p.codigo, p.numero, p.ano, p.cpf, p.requerente, a.descricao as assunto, p.cod_situacao, td.descricao as tipodocumento, d.descricao as departamento, s.descricao as situacao"
					sql = sql & " from pro_protocolo p "
					sql = sql & " left join pro_assunto a	   on a.codigo = p.cod_assunto and a.cod_empresa = p.cod_empresa"
					sql = sql & " left join pro_tipoDocumento td on td.codigo = p.cod_tipodocumento and td.cod_empresa = p.cod_empresa"
					sql = sql & " left join pro_departamento d on d.codigo = p.cod_departamento and d.cod_empresa = p.cod_empresa"
					sql = sql & " left join pro_situacao s on s.codigo = p.cod_situacao"
					sql = sql & " Where p.Cod_Empresa	= " & session("codEmpresa")	
					sql = sql & " Order by p.codigo desc"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>N&uacute;mero</strong></td>
                        <td width="32%" height="21" class="celula"><strong>Requerente</strong></td>
                        <td width="13%" class="celula"><strong>Tipo Documento</strong></td>
                        <td width="33%" class="celula"><strong>Departamento Destino</strong></td>
                        <td width="13%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="9%" class="celula"><%=rs("numero")%></td>
                            <td height="21" class="celula"><%=trim(rs("cpf"))%> - <%=trim(rs("requerente"))%></td>
                            <td height="21" class="celula"><%=trim(rs("tipodocumento"))%>&nbsp;</td>
                            <td height="21" class="celula"><%=trim(rs("departamento"))%>&nbsp;</td>
                            <td height="21" class="celula"><%=trim(rs("situacao"))%>&nbsp;</td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
              <tr>
                <td height="21" colspan="5" class="celula">Total 
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