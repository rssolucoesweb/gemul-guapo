<%strNomeDaPaginaPortal = "Cadastro de Not&iacute;cias"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="../../../ckeditor/ckeditor.js"></script>
<script src="../../../ckeditor/config.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	
	function abreConsulta(caminho){
		window.open(caminho,"consulta","top=0,left=0,height=500,width=600,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	

	function FotoNoticia(codigo){
		var caminho
		caminho = "NoticiaFoto_cad.asp?CodNoticia=" + codigo
		window.open(caminho ,"","toolbar=no,status=no,location=no,scrollbars=yes,menubar=no,resizable=no,width=580,height=560,top=0,lef=0");
	}
	
	function qtdeDias(dias){
			var parametro = "Noticia_cad.asp?txtDiasAnuncio="+dias+"&txtDataInicio="+frm.txtDataInicio.value+"&txtDataFinal="+frm.txtDataFinal.value;
			frm.action=parametro;
			frm.submit();
	}
		
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDataInicio.value == "") {
			alert("A Data Inicio deve ser informada !");
			frm.txtDataInicio.focus();
			return false;
		}
		
		if (frm.txtDiasAnuncio.value == "") {
			alert("A Qtde de dias de Anuncio deve ser informada !");
			frm.txtDiasAnuncio.focus();
			return false;
		}
		
		if (frm.txtDataFinal.value == "") {
			alert("A Data Final deve ser informada !");
			frm.txtDataFinal.focus();
			return false;
		}

	
		if (frm.txtRetranca.value == "") {
			alert("A Retranca deve ser informada !");
			frm.txtRetranca.focus();
			return false;
		}
		
		if (frm.txtTitulo.value == "") {
			alert("O Titulo deve ser informado !");
			frm.txtTitulo.focus();
			return false;
		}
		
		if (frm.cmbTipoNoticia.value == "0") {
			alert("O Tipo Notícia deve ser informada!");
			frm.cmbTipoNoticia.focus();
			return false;
		}
		
		if (frm.txtData.value == "") {
			alert("A Data deve ser informada!");
			frm.txtData.focus();
			return false;
		}
		
		if (frm.txtResumoNoticia.value == "") {
			alert("O Resumo da Noticia deve ser informado!");
			frm.txtResumoNoticia.focus();
			return false;
		}
		
		if (frm.cmbSituacao.value == "") {
			alert("A Situação deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="Noticia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%  
	principal			= "principal.asp"
	strPagina			= "Noticia_cad.asp"
	intCodEmpresa		= session("codEmpresa")		
	intCodNoticia		= Trim(Request("txtCodNoticia"))
	strRetranca			= replace(Trim(Request.Form("txtRetranca")),"'","") 
	strTitulo			= replace(Trim(Request.Form("txtTitulo")),"'","")
	intCodTipoNoticia	= Trim(Request.Form("cmbTipoNoticia"))
	strData				= replace(Trim(Request.Form("txtData")),"'","")					
	strNoticia			= replace(Request.Form("txtNoticia"),"'","")
	strResumoNoticia	= replace(Request.Form("txtResumoNoticia"),"'","")
	strDestaqueNoticia	= Trim(request.Form("chkNoticiaDestaque"))
	strFonteNoticia		= replace(Request.Form("txtFonte"),"'","")
	strDiasAnuncio 		= Trim(Request.Form("txtDiasAnuncio"))
	strDataInicio 		= Trim(Request.Form("txtDataInicio"))
	strDataFinal 		= Trim(Request.Form("txtDataFinal"))
	strPublicado		= Trim(Request("cmbPublicado"))
	
	if trim(intCodNoticia) <> "" then
	
		sql = "SELECT Codigo, CodEmpresa, Retranca, Titulo, CodTipoNoticia, Data, "
		sql = sql & " Noticia, FonteNoticia, Destaque, NomeFoto, DataInicio, DiasAnuncio, DataFinal, Situacao, Publicado, ResumoNoticia"
		sql = sql & " FROM SIT_Noticias"
		sql = sql & " Where Codigo = " & intCodNoticia
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		sql = sql & " ORDER BY Titulo"
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodNoticia 		= rs("Codigo")
			strRetranca			= rs("Retranca")
			strTitulo			= rs("Titulo")
			intCodTipoNoticia 	= rs("CodTipoNoticia")
			strData				= formataDataAP(rs("Data"))
			strNoticia			= rs("Noticia")
			strFonte			= rs("FonteNoticia")
			strNomeFoto			= rs("NomeFoto") 
			strPublicado		= rs("Publicado")
			strSituacao			= rs("Situacao")
			strResumoNoticia	= rs("ResumoNoticia")
			
			if strDataInicio = "" then
				strDataInicio 		= formataDataAP(rs("DataInicio"))
				strDiasAnuncio 		= rs("DiasAnuncio")
				strDataFinal 		= formataDataAP(rs("DataFinal"))
			end if
					
			if rs("Destaque") = "S" then
				strDestaqueNoticia 	= "S"
			else
				strDestaqueNoticia 	= "N"
			end if
					
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoFoto				= ""
			BotaoAlbum				= ""

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoFoto   			= "disabled"
		BotaoAlbum				= "disabled"
	end if 
	
	IF strNomeFoto <> "" then
		strImagem = "<img src='..\..\..\FotoNoticia\" & intCodEmpresa & "\" & intCodNoticia & "\" & strNomeFoto & "' border='1' width='253' height='106'>"
	else
		strImagem = "<font color='#CCCCCC'>  FOTO </font>"
	end if
	
	if strDiasAnuncio <> "" and strDataInicio <> "" then
		strDataFinal 	=  DateAdd("d", strDiasAnuncio, strDataInicio)
		strDataFinal	=  formatadataAP(strDataFinal)
	end if
	
	if strData = "" then strData = formataDataAP(date)
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

	
    <table width="98%" border="0"  cellpadding="0" cellspacing="0" >
        <tr>
          <td colspan="3" bgcolor="#EFEFDE" class="TextoForm"><strong>Intervalo da Not&iacute;cia</strong></td>
          </tr>
        <tr>
          <td colspan="2" class="TextoForm">&nbsp;<input name="txtCodNoticia" type="hidden" id="txtCodNoticia" class="text" size="10" value="<%=intCodNoticia%>" maxlength="10"></td>
          <td width="26%" align="center">&nbsp;</td>
          </tr>
        <tr>
          <td class="TextoForm">Data Inicio: </td>
          <td width="60%"><input name="txtDataInicio" type="text" class="text" id="txtDataInicio" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataInicio%>" size="11" maxlength="11"></td>
          <td width="26%" align="center">&nbsp;</td>
          </tr>
        <tr>
          <td height="25" class="TextoForm">Dias Anuncio: </td>
          <td colspan="2"><input name="txtDiasAnuncio" type="text" id="txtDiasAnuncio" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strDiasAnuncio%>" maxlength="5" onBlur="qtdeDias(this.value)"></td>
          </tr>
        <tr>
          <td class="TextoForm">Data Final :</td>
          <td colspan="2"><input name="txtDataFinal" type="text" class="text" id="txtDataFinal"  onBlur="validaData(this); calculaDiferenca()" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataFinal%>" size="11" maxlength="11"></td>
          </tr>
        <tr>
          <td colspan="3" class="TextoForm">&nbsp;</td>
          </tr>
        <tr>
          <td colspan="3" bgcolor="#EFEFDE" class="TextoForm"><strong>Dados da Not&iacute;cia</strong></td>
          </tr>
        <tr>
          <td colspan="3" class="TextoForm">&nbsp;</td>
          </tr>
        <tr>
          <td class="TextoForm">Retranca :</td>
          <td colspan="2"><span class="texto">
            <input name="txtRetranca" type="text" class="text" id="txtRetranca" size="30" maxlength="30" value="<%=strRetranca%>">
            <a href="#" onClick="return abreConsulta('Noticia_con.asp')"><img  src="<%=session("strCaminhoRaiz")%>/images/Consulta_normal.gif" name="Image1311" width="26" height="26" border="0" align="absmiddle" id="Image131"></a></span></td>
          </tr>
        <tr>
          <td  width="14%" class="TextoForm">T&iacute;tulo:</td>
          <td colspan="2"><input name="txtTitulo" type="text" class="text" id="txtTitulo" size="60" maxlength="80" value="<%=strTitulo%>">
            <a href="#" onClick="return abreConsulta('Noticia_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1311','','<%=session("strCaminhoRaiz")%>/images/Consulta_over.gif',1)"></a></td>
          </tr>
        <tr>
          <td height="28" class="TextoForm" >Tipo Noticia:</td>
          <td colspan="2">
            <!--#include file="../../../includes/inc_cmbTipoNoticia.asp"-->
          </td>
          </tr>
        <tr>
          <td class="TextoForm">Data :</td>
          <td colspan="2" class="texto"><input name="txtData" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="10" maxlength="10">
              <font color="#999999">ex.: dd/mm/aaaa</font></td>
          </tr>
        <tr>
          <td height="24" class="TextoForm">Fonte :</td>
          <td colspan="2" class="texto"><input name="txtFonte" type="text" class="text" id="txtFonte" value="<%=strFonte%>" size="69"></td>
          </tr>
        <tr>
          <td height="23" class="TextoForm">Resumo  Noticia:</td>
          <td colspan="2" class="texto"><textarea name="txtResumoNoticia" cols="69" class="text" id="txtResumoNoticia"><%=strResumoNoticia%></textarea></td>
        </tr>
        <tr>
          <td height="23" class="TextoForm">Situa&ccedil;&atilde;o:</td>
          <td colspan="2" class="texto"><span class="TextoForm">
            <select name="cmbSituacao" class="Combo" id="cmbSituacao">
              <option value="0">Selecione...</option>
              <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
              <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
              <option value="B" <%if strSituacao = "B" then response.Write("selected") %>>Bloqueado</option>
            </select>
          </span></td>
        </tr>
        <tr>
          <td height="31" class="TextoForm">Publicado:</td>
          <td colspan="2" class="texto">
			<select name="cmbPublicado" class="Combo" id="cmbPublicado">
              <option value="0">Selecione...</option>
              <option value="S" <%if strPublicado = "S" then response.Write("selected") %>>Sim</option>
              <option value="N" <%if strPublicado = "N" then response.Write("selected") %>>N&atilde;o</option>
            </select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="TextoForm">
			<input name="chkNoticiaDestaque" type="checkbox" id="chkNoticiaDestaque" <%if strDestaqueNoticia ="S" then response.Write("checked")%> value="S">
Not&iacute;cia Destaque</span></td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td colspan="2" class="texto">&nbsp;</td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td colspan="2" class="texto"><input name="cmdEnviarFoto" type='button' class='botao' id="cmdEnviarFoto" value='Enviar Foto' onClick="FotoNoticia('<%=intCodNoticia%>')"<%=BotaoFoto%>></td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td colspan="2" class="texto">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" align="left" bgcolor="#EFEFDE" class="TextoForm"><strong>Descri&ccedil;&atilde;o da Not&iacute;cia</strong> </td>
        </tr>
        <tr>
          <td colspan="3" class="TextoForm">
		  <Textarea class="ckeditor" cols="100" rows="3" id="txtNoticia" name="txtNoticia"><%=strNoticia%></textarea>
	      </td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr>
          <td colspan="3">&nbsp;</td>
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
