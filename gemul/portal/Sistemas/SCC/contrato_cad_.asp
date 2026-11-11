<%strNomeDaPaginaPortal = "Contrato"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function validaContrato(intCodigo){
			var frm = document.getElementById("frm");
			if (frm.txtNumero.value == "") {
				alert("Número deve ser informado!");
				frm.txtNumero.focus();
				return false;
			}
			if (frm.txtAno.value == "") {
				alert("Ano deve ser informado!");
				frm.txtAno.focus();
				return false;
			}

			frm.action="contrato_cad.asp";
			frm.submit();
		}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtNumero.value == "") {
			alert("Número deve ser informado!");
			frm.txtNumero.focus();
			return false;
		}
		if (frm.txtAno.value == "") {
			alert("Ano deve ser informado!");
			frm.txtAno.focus();
			return false;
		}
		
		if (frm.txtProcesso.value == "") {
			alert("Processo deve ser informado!");
			frm.txtProcesso.focus();
			return false;
		}
		
		frm.action="contrato_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	principal			= "principal.asp"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strNumero 			= Trim(Request.Form("txtNumero"))
	strAno 				= Trim(Request.Form("txtAno"))

	if trim(intCodigo) <> "" or (strNumero<>"" and strAno<>"") then
	
		sql = "SELECT  codigo, codEmpresa, numero, ano, processo, codDepartamento,"
		sql = sql & " codBeneficiario, dataInicio, dataFim, dataOutorga, dataPublicacao,"
		sql = sql & " numeroDespacho, anoDespacho, numeroDiario, anoDiario, numeroFolha, totalContrato,"
		sql = sql & " obs, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr"
		sql = sql & " FROM SCC_contrato "
		sql = sql & " where 1=1"
		if intCodigo <> "" then
			sql = sql & " And Codigo = " & intCodigo
		end if
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		if strNumero <> "" then
			sql = sql & " And Numero = " & strNumero
			sql = sql & " And Ano = " & strAno
		end if
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strNumero	= trim(rs("numero"))
			strAno	= trim(rs("ano"))
			strProcesso	= trim(rs("processo"))
			intCodDepartamento	= trim(rs("codDepartamento"))
			intCodContratado	= trim(rs("codBeneficiario"))
			strDataInicial	= trim(rs("dataInicio"))
			strDataFim	= trim(rs("dataFim"))
			strDataOutorga	= trim(rs("dataOutorga"))
			strDataPublicacao	= trim(rs("dataPublicacao"))
			strNumeroDespacho	= trim(rs("numeroDespacho"))
			strAnoDespacho	= trim(rs("anoDespacho"))
			strNumeroDiario	= trim(rs("numeroDiario"))
			strAnoDiario	= trim(rs("anoDiario"))
			strNumeroFolha	= trim(rs("numeroFolha"))
			if isnull(rs("totalContrato")) then
				intTotalContrato	= ""
			else
				intTotalContrato	= formatNumber(rs("totalContrato"),2)
			end if
			strObs	= trim(rs("obs"))

						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoPDF				= ""
		else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			BotaoPDF				= "disabled"
		
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
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
    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td width="114" height="23" class="TextoForm"><strong>N&uacute;mero:</strong></td>
            <td width="250" class="TextoForm"><input name="txtNumero" type="text" id="txtNumero" onKeyPress="return formataCampo(this,2,5)" class="text" size="10" value="<%=strNumero%>" maxlength="10" >
              /
                <input name="txtAno" type="text" id="txtAno" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strAno%>" maxlength="4" >
                <a href="#" onClick="validaContrato()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','../../../images/botao_azul_over.gif',1)"><img alt="Clique para buscar o contrato" src="../../../images/botao_azul_normal.gif" name="Image3" width="26" height="26" border="0"></a></td>
            <td width="115" class="TextoForm">&nbsp;</td>
            <td width="373" class="TextoForm">&nbsp;</td>
            </tr>
          <tr>
            <td height="10" colspan="4" class="TextoForm"><hr size="1" color="#999999"></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Processo:</td>
            <td class="TextoForm"><input name="txtProcesso" type="text" class="text" id="txtProcesso" size="20" maxlength="15" value="<%=strProcesso%>"></td>
            <td class="TextoForm">&nbsp;</td>
            <td class="TextoForm">&nbsp;</td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Departamento:</td>
            <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbDepartamento.asp"--></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Contratado:</td>
            <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbContratado.asp"--></td>
            </tr>
          <tr>
            <td height="23" colspan="4" class="TextoForm"><strong>Vigência</strong></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Data Inicial:</td>
            <td class="TextoForm"><input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataInicial%>" size="14" maxlength="11"></td>
            <td class="TextoForm">Data Final:</td>
            <td class="TextoForm"><input name="txtDataFim" type="text" class="text" id="txtDataFim" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataFim%>" size="14" maxlength="11"></td>
          </tr>
          <tr>
            <td height="10" colspan="4" class="TextoForm"><hr size="1" color="#999999"></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Data Outorga:</td>
            <td class="TextoForm"><input name="txtDataOutorga" type="text" class="text" id="txtDataOutorga" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataOutorga%>" size="14" maxlength="11"></td>
            <td class="TextoForm">Data Publicação:</td>
            <td class="TextoForm"><input name="txtDataPublicacao" type="text" class="text" id="txtDataPublicacao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataPublicacao%>" size="14" maxlength="11"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">N. Despacho:</td>
            <td class="TextoForm"><input name="txtNumeroDespacho" type="text" id="txtNumeroDespacho" onKeyPress="return formataCampo(this,2,5)" class="text" size="10" value="<%=strNumeroDespacho%>" maxlength="10" >
              /
                <input name="txtAnoDespacho" type="text" id="txtAnoDespacho" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strAnoDespacho%>" maxlength="4" ></td>
            <td class="TextoForm">N. Diário Oficial:</td>
            <td class="TextoForm"><input name="txtNumeroDiario" type="text" id="txtNumeroDiario" onKeyPress="return formataCampo(this,2,5)" class="text" size="10" value="<%=strNumeroDiario%>" maxlength="10" >
              /
                <input name="txtAnoDiario" type="text" id="txtAnoDiario" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strAnoDiario%>" maxlength="4" >
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N. de folhas:
<input name="txtNumeroFolha" type="text" id="txtNumeroFolha" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strNumeroFolha%>" maxlength="5" ></td>
          </tr>
          <tr><td class="TextoForm">Total do Contrato:</td>
            <td class="TextoForm"><input name="txtTotalContrato" type="text" class="text" id="txtTotalContrato" value="<%=intTotalContrato%>" size="25" maxlength="14"  onKeyPress="return currencyFormat(this,event)"></td>
            <td class="TextoForm">&nbsp;</td>
          </tr>          <tr>
            <td height="23" class="TextoForm">Obs.:</td>
            <td colspan="3" class="TextoForm"><span class="texto">
              <textarea name="txtObs" cols="69" class="text" id="txtObs"><%=strobs%></textarea>
            </span></td>
            </tr>
        <tr valign="top">
          <td  height="15"  class="tituloPrincipal style2"></td>
          <td  height="15"  class="tituloPrincipal style2"></td>
          <td  height="15"  class="tituloPrincipal style2"></td>
          <td  height="15"  class="tituloPrincipal style2"></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="4"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        <tr valign="top">
          <td class="tituloPrincipal style2"  colspan="4"><%
				cont =0

					sql = "SELECT SCC_CONTRATO.Codigo, SCC_CONTRATO.numero, SCC_CONTRATO.ano, SCC_CONTRATO.processo, SCC_BENEFICIARIO.DESCRICAO AS BENEFICIARIO, SCC_DEPARTAMENTO.DESCRICAO AS DEPARTAMENTO"
					sql = sql & " FROM SCC_CONTRATO"
					sql = sql & " LEFT JOIN SCC_DEPARTAMENTO ON SCC_DEPARTAMENTO.CODIGO = SCC_CONTRATO.CODDEPARTAMENTO AND SCC_DEPARTAMENTO.CodEmpresa = SCC_CONTRATO.CodEmpresa"
					sql = sql & " LEFT JOIN SCC_BENEFICIARIO ON SCC_BENEFICIARIO.CODIGO = SCC_CONTRATO.CODBENEFICIARIO AND SCC_BENEFICIARIO.CodEmpresa = SCC_CONTRATO.CodEmpresa"
					sql = sql & " Where SCC_CONTRATO.CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " Order by SCC_CONTRATO.ano,SCC_CONTRATO.numero"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>Número/Ano</strong></td>
                        <td width="16%" height="21" class="celula"><strong>Processo</strong></td>
                        <td width="36%" class="celula"><strong>Departamento</strong></td>
                        <td width="37%" class="celula"><strong>Contratato</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="11%" class="celula"><%=rs("numero")%>/<%=trim(rs("ano"))%></td>
                            <td height="21" class="celula"><%=trim(rs("processo"))%>&nbsp;</td>
                            <td height="21" class="celula"><%=trim(rs("departamento"))%>&nbsp;</td>
                            <td height="21" class="celula"><%=trim(rs("beneficiario"))%>&nbsp;</td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
              <tr>
                <td height="21" colspan="4" class="celula">Total 
                  Contrato : <%=cont%></td>
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
