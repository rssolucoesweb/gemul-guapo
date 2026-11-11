<%strNomeDaPaginaPortal = "Cadastro de Clientes"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="../../../js_util/mascara.js"></script>
<script type="text/javascript" language="javascript" src="../../../js_util/ajaxutil.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTipoContato.value == "0") {
			alert("O Tipo Contato deve ser informado !");
			frm.cmbTipoContato.focus();
			return false;
		}
		
		if (frm.txtNome.value == "") {
			alert("O None deve ser informado !");
			frm.txtNome.focus();
			return false;
		}
		
		if (frm.txtCEP1.value == "") {
			alert("O CEP 1 deve ser informado !");
			frm.txtCEP1.focus();
			return false;
		}
		
		if (frm.txtEndereco1.value == "") {
			alert("O Endereço 1 deve ser informado !");
			frm.txtEndereco1.focus();
			return false;
		}
		
		if (frm.txtCidade1.value == "0") {
			alert("A Cidade 1 deve ser informada !");
			frm.txtCidade1.focus();
			return false;
		}
		
		if (frm.txtBairro1.value == "") {
			alert("O Bairro 1 deve ser informado !");
			frm.txtBairro1.focus();
			return false;
		}
	
		frm.action="Cliente_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function buscaCEP(numero){
		var func = 
		function (xmlhttp)
		{
			var xml   = xmlhttp.responseXML;			
			var resultado = xml.getElementsByTagName('webservicecep')[0];	
																				  
			document.getElementById("txtEndereco"+numero).value		= getText(resultado.getElementsByTagName('endereco')[0].childNodes[0]);
			document.getElementById("txtBairro"+numero).value		= getText(resultado.getElementsByTagName('bairro')[0].childNodes[0]);
			document.getElementById("txtCidade"+numero).value		= getText(resultado.getElementsByTagName('cidade')[0].childNodes[0]);	
			document.getElementById("txtBairro"+numero).disabled=false;
			document.getElementById("txtEndereco"+numero).disabled=false;
			document.getElementById("txtCidade"+numero).disabled=false;	

		}		
	
		var parametros;
		
		if (document.getElementById("txtCEP"+numero).value != "" && document.getElementById("txtEndereco"+numero).value==""){
			
			
			parametros = 'txtCEP=' + document.getElementById("txtCEP"+numero).value;
			//window.open("../../../includes/inc_WebServiceCEP.asp?" + parametros);
			ExecAjax(func,"../../../includes/inc_WebServiceCEP.asp",parametros,'Aguarde');	

		}
	}	
</script>

<%

	principal			= "principal.asp"
	strPaginaLimpar		= "Cliente_cad.asp"	
	intCodEmpresa		= session("CodEmpresa")	

	intCodigo 			= Trim(Request.Form("txtCodigo"))
	intCodTipoContato	= Trim(Request.Form("cmbTipoContato"))
	strNome	 			= Trim(Request.Form("txtNome"))
	strEmail			= Trim(Request.Form("txtEmail"))
	strDatanascimento	= Trim(Request.Form("txtDatanascimento"))

	' Dados Endereco 1
	strCep1				= Trim(Request.Form("txtCep1"))
	strEndereco1		= Trim(Request.Form("txtEndereco1"))
	strCidade1			= Trim(Request.Form("txtCidade1"))
	strBairro1			= Trim(Request.Form("txtBairro1"))

	' Dados Endereco 2
	strCep2				= Trim(Request.Form("txtCep2"))
	strEndereco2		= Trim(Request.Form("txtEndereco2"))
	strCidade2			= Trim(Request.Form("txtCidade2"))
	strBairro2			= Trim(Request.Form("txtBairro2"))
	
	strFoneResidencial	= Trim(Request.Form("txtFoneResidencial"))
	strFoneComercial	= Trim(Request.Form("txtFoneComercial"))
	strFoneCelular		= Trim(Request.Form("txtFoneCelular"))
	
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, CodTipoContato, Nome, Email, Datanascimento, "
		sql = sql & " Cep1, Endereco1, Cidade1, Bairro1," 
		sql = sql & " Cep2, Endereco2, Cidade2, Bairro2, "
		sql = sql & " FoneResidencial, FoneComercial, FoneCelular"
		sql = sql & " FROM MAL_Cliente"
		sql = sql & " Where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then

			intCodigo 			= rs("Codigo")
			intCodTipoContato	= rs("CodTipoContato")
			strNome	 			= rs("Nome")
			strEmail			= rs("Email")
			strDatanascimento	= formataDataAP(rs("Datanascimento"))
			
			' Dados Endereco 1
			strEndereco1		= rs("Endereco1")
			strCep1				= rs("Cep1")
			strCidade1			= rs("Cidade1")
			strBairro1			= rs("Bairro1")
			
			' Dados Endereco 2
			if trim(rs("Cep2")) <> "" then 
			
			strCep2				= rs("Cep2")
			strEndereco2		= rs("Endereco2")
			strCidade2			= rs("Cidade2")
			strBairro2			= rs("Bairro2")
			
			end if
			' Dados Contato		
			strFoneResidencial	= rs("FoneResidencial")
			strFoneComercial	= rs("FoneComercial")
			strFoneCelular		= rs("FoneCelular")		
						
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
            <td height="23" class="TextoForm">Codigo:</td>
            <td class="TextoForm"><input name="txtCodigo" type="text" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              <a href="#"  onClick="return abreConsulta('Cliente_con.asp')"><img src="../../../images/Consulta_over.gif" alt="Consultar Empresa" name="Image4" width="26" height="26" border="0" id="Image4" align="baseline" /></a></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Tipo Contato:</td>
            <td class="TextoForm"><select name="cmbTipoContato" id="cmbTipoContato" class="combo"  style="width:200pt">
              <option value="0">Selecione...</option>
              <%
            sql = " Select Codigo, Descricao "
            sql = sql & " from MAL_TipoContato"
            sql = sql & " order by Codigo"
            rs.open sql, cnn
            if rs.eof = false then
                while not rs.eof
                    if cstr(intCodTipoContato) = cstr(rs("codigo")) then
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
            </select></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Nome:</td>
            <td class="TextoForm"><input name="txtNome" type="text" class="text" id="txtNome" size="40" maxlength="40" value="<%=strNome%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Email:</td>
            <td class="TextoForm"><input name="txtEmail" type="text" class="text" id="txtEmail" size="40" maxlength="40" value="<%=strEmail%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Data Nascimento:</td>
            <td class="TextoForm"><span class="texto1">
              <input name="txtDatanascimento" type="text" class="text" id="txtDatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatanascimento%>">
            </span></td>
          </tr>
          <tr>
            <td height="23" colspan="2" bgcolor="#CCCCCC" class="TextoForm">Dados Endere&ccedil;o I</td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Cep:</td>
            <td class="TextoForm"><input name="txtCEP1" type="text" id="txtCEP1" class="text" value="<%=strCEP1%>" size="15" maxlength="9"  onKeyPress="mascara(this,cep)" onBlur="buscaCEP(1)"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Endereço:</td>
            <td class="TextoForm"><input name="txtEndereco1" type="text" class="text" id="txtEndereco1" size="50" maxlength="40" value="<%=strEndereco1%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">              Cidade:</td>
            <td class="TextoForm"><input name="txtCidade1" type="text" class="text" id="txtCidade1" size="40" maxlength="40" value="<%=strCidade1%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Bairro: </td>
            <td class="TextoForm"><input name="txtBairro1" type="text" class="text" id="txtBairro1" size="40" maxlength="40" value="<%=strBairro1%>"></td>
          </tr>
          <tr>
            <td height="23" colspan="2" bgcolor="#CCCCCC" class="TextoForm">Dados Endere&ccedil;o II</td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Cep:</td>
            <td class="TextoForm"><input name="txtCEP2" type="text" id="txtCEP2" class="text" value="<%=strCEP2%>"  size="15" maxlength="9"  onKeyPress="mascara(this,cep)" onBlur="buscaCEP(2)"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Endereço:</td>
            <td class="TextoForm"><input name="txtEndereco2" type="text" class="text" id="txtEndereco2" size="50" maxlength="50" value="<%=strEndereco2%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Cidade:</td>
            <td class="TextoForm"><input name="txtCidade2" type="text" class="text" id="txtCidade2" size="40" maxlength="30" value="<%=strCidade2%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Bairro:</td>
            <td class="TextoForm"><input name="txtBairro2" type="text" class="text" id="txtBairro2" size="40" maxlength="40" value="<%=strBairro2%>"></td>
          </tr>
          <tr>
            <td height="23" colspan="2" bgcolor="#CCCCCC" class="TextoForm">Dados Contato</td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Fone Residencial:</td>
            <td class="TextoForm">
              <input name="txtFoneResidencial" type="text" class="text" id="txtFoneResidencial" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFoneResidencial%>">            </td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Fone Comercial</td>
            <td class="TextoForm">
              <input name="txtFoneComercial" type="text" class="text" id="txtFoneComercial" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFoneComercial%>">            </td>
          </tr>
          <tr>
            <td width="16%" height="23" class="TextoForm">Fone Celular</td>
            <td width="25" class="TextoForm">
              <input name="txtFoneCelular" type="text" class="text" id="txtFoneCelular" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFoneCelular%>">           </td>
          </tr>
          <tr>
            <td height="24" colspan="2" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="2">&nbsp;</td>
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