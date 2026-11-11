<%strNomeDaPaginaPortal = "Cadastro de Empresa"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>

<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
function salvar(acao){
	
	if(document.getElementById("txtRazaoSocial").value == ""){
		alert("A Razão Social deve ser informada!");
		document.getElementById("txtRazaoSocial").focus();
		return false		
	}
	
	if(document.getElementById("txtNomeFantazia").value == ""){
		alert("O Nome Fantazia deve ser informado!");
		document.getElementById("txtNomeFantazia").focus();
		return false		
	}
	
	if(document.getElementById("txtCNPJ").value == ""){
		alert("O CNPJ deve ser informado!");
		document.getElementById("txtCNPJ").focus();
		return false		
	}
	
	if(document.getElementById("txtInscricaoMunicipal").value == ""){
		alert("A Inscrição Municipal deve ser informada!");
		document.getElementById("txtInscricaoMunicipal").focus();
		return false		
	}
	
	if(document.getElementById("txtEndereco").value == ""){
		alert("O Endereço deve ser informado!");
		document.getElementById("txtEndereco").focus();
		return false		
	}
	
	if(document.getElementById("txtCep").value == ""){
		alert("O CEP deve ser informado!");
		document.getElementById("txtCep").focus();
		return false		
	}
	
	if(document.getElementById("txtBairro").value == ""){
		alert("O Bairro deve ser informado!");
		document.getElementById("txtBairro").focus();
		return false		
	}
	
	if(document.getElementById("txtCidade").value == ""){
		alert("A Cidade deve ser informada!");
		document.getElementById("txtCidade").focus();
		return false		
	}
	
	if(document.getElementById("txtUF").value == "0"){
		alert("O Estado deve ser informada!");
		document.getElementById("txtUF").focus();
		return false		
	}
	
	if(document.getElementById("txtFone1").value == ""){
		alert("O Fone(1) deve ser informado!");
		document.getElementById("txtFone1").focus();
		return false		
	}
	
	if(document.getElementById("txtEmail").value == ""){
		alert("O E-mail deve ser informado!");
		document.getElementById("txtEmail").focus();
		return false		
	}
	
	if(document.getElementById("txtNomeContato").value == ""){
		alert("O Nome do Contato deve ser informado!");
		document.getElementById("txtNomeContato").focus();
		return false		
	}
	
	if(document.getElementById("txtFoneContato").value == ""){
		alert("O Fone do Contato deve ser informado!");
		document.getElementById("txtFoneContato").focus();
		return false		
	}
		
	frm.action= "Empresa_cod.asp?acao="+acao;
	frm.submit();
	return true;

	}
	
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
  </script>


<%  
'codigo fonte em ASP
intCodEmpresa = request.Form("txtCodEmpresa")

strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
strDesabilitaAlterar	= "disabled" 'Desabilita o botão Incluir
strDesabilitaExcluir	= "disabled" 'Desabilita o botão Incluir
strBloqueiaCampo = ""
if intCodEmpresa<> ""  then
	sql = " select *"
	sql = sql & " from SEG_empresa"
	sql = sql & " where codigo = " & intCodEmpresa
	rs.open sql, cnn
	if not rs.eof then
	
		Codigo = rs("Codigo")
		intCodGrupo = rs("CodGrupo")
		strRazaoSocial = rs("RazaoSocial")
		strNomeFantazia = rs("NomeFantazia")
		strCNPJ = rs("CNPJ")
		strCPFContato= formataCPFap(rs("cpf"))
		strInscricaoMunicipal = rs("InscricaoMunicipal")
		strEndereco = rs("Endereco")
		strCep = rs("Cep")
		strBairro = rs("Bairro")
		strCidade = rs("Cidade")
		strUF = rs("UF")
		strFone1 = rs("Fone1")
		strFone2 = rs("Fone2")
		strFax = rs("Fax")
		strCelular1 = rs("Celular1")
		strCelular2 = rs("Celular2")
		strEmail = rs("Email")
		strEmail1 = rs("Email1")
		strSite = rs("Site")
		strskype = rs("skype")
		strmsn = rs("msn")
		strNomeContato = rs("NomeContato")
		strFoneContato = rs("FoneContato")
		strAutorizado = rs("Autorizado")
		strSituacao = rs("Situacao")
		strBloqueiaCampo = "readonly"
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar	= "" 'Desabilita o botão Incluir
		strDesabilitaExcluir	= "" 'Desabilita o botão Incluir
	
	end if
	rs.close
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

<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
      <tr >
        <td height="20" colspan="3" bgcolor="#DEE8EA" class="texto"><strong>Dados Grupo </strong></td>
      </tr>
      <tr >
        <td height="10" colspan="3" class="texto"></td>
      </tr>
      <tr >
        <td height="20" colspan="3" class="texto"><!--#include file="../../../includes/inc_cmbGrupo.asp"--></td>
      </tr>
      <tr >
        <td height="10" colspan="3" class="texto"></td>
      </tr>
      <tr >
        <td height="20" colspan="3" bgcolor="#DEE8EA" class="texto"><strong>Dados Empresa </strong></td>
      </tr>
      <tr >
        <td colspan="3" class="texto">&nbsp;</td>
      </tr>
      <tr >
        <td colspan="3" class="texto"><strong>Raz&atilde;o Social </strong></td>
      </tr>
      <tr >
        <td colspan="3"><input name="txtRazaoSocial" type="text" class="text" id="txtRazaoSocial" value="<%=strRazaoSocial%>" size="60" maxlength="60">
          <a href="#"  onClick="return abreConsulta('empresa_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','../../../images/Consulta_normal.gif',1)"><img src="../../../images/Consulta_over.gif" alt="Consultar Empresa" name="Image4" width="26" height="26" border="0" id="Image4" /><span class="texto">
          <input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa"  value="<%=intCodEmpresa%>" />
          </span></a></td>
      </tr>
      <tr >
        <td colspan="3" class="texto"><strong>Nome Fantasia </strong></td>
      </tr>
      <tr >
        <td colspan="3" class="texto"><input name="txtNomeFantazia" type="text" class="text" id="txtNomeFantazia" value="<%=strNomeFantazia%>" size="40" maxlength="40"></td>
      </tr>
      <tr >
        <td class="texto"><strong>CNPJ</strong></td>
        <td width="167" class="texto"><strong>Inscri&ccedil;&atilde;o Municipal </strong></td>
        <td width="156" class="texto">&nbsp;</td>
      </tr>
      <tr >
        <td><input name="txtCNPJ" type="text" class="text" id="txtCNPJ" onKeyPress="return funcCheckCPF_CNPJ(this,18,18)" value="<%=strCNPJ%>" size="19" maxlength="18"></td>
        <td><input name="txtInscricaoMunicipal" type="text" class="text" id="txtInscricaoMunicipal" value="<%=strInscricaoMunicipal%>" size="20" maxlength="20"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td colspan="3" height="20" class="texto">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="3" bgcolor="#DEE8EA" height="20" class="texto"><strong>Dados Endere&ccedil;o </strong></td>
      </tr>
      <tr >
        <td colspan="3" class="texto">&nbsp;</td>
      </tr>
      <tr >
        <td colspan="3" class="texto"><strong>Endere&ccedil;o</strong></td>
      </tr>
      <tr >
        <td colspan="3" class="texto"><input name="txtEndereco" type="text" class="text" id="txtEndereco" value="<%=strEndereco%>" size="60" maxlength="60"></td>
      </tr>
      <tr >
        <td class="texto"><strong>Cep</strong></td>
        <td colspan="2" class="texto">&nbsp;</td>
      </tr>
      <tr >
        <td class="texto"><span class="TextoForm">
          <input name="txtCep" type="text" class="text" id="txtCep" onKeyPress="mascara(this,cep)"  value="<%=strCep%>" size="11" maxlength="9">
        </span></td>
        <td colspan="2" class="texto">&nbsp;</td>
      </tr>
      <tr>
        <td class="texto"><strong>Bairro</strong></td>
        <td colspan="2" class="texto">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="3" class="texto"><input name='txtBairro' value="<%=strBairro%>" class="text" type='text' id="txtBairro" size='40' maxlength='40'></td>
      </tr>
      <tr>
        <td width="172" class="texto"><strong>Cidade</strong></td>
        <td class="texto">&nbsp;</td>
        <td class="texto"><strong>UF</strong></td>
      </tr>
      <tr>
        <td colspan="2"><input name="txtCidade" type="text" class="text" id="txtCidade" value="<%=strCidade%>" size="40" maxlength="40">
        </td>
        <td><input name="txtUF" type="text" class="text" id="txtUF" value="<%=strUF%>" size="5" maxlength="2" /></td>
      </tr>
      <tr>
        <td height="20" class="texto"><strong>Fone(1)</strong></td>
        <td colspan="2" class="texto"><strong>Fone(2)</strong></td>
      </tr>
      <tr>
        <td class="texto"><span class="TextoForm">
          <input name="txtFone1" type="text" class="text" id="txtFone1" onKeyPress="mascara(this,telefone)"  maxlength="14"  value="<%=strFone1%>" size="18" >
        </span></td>
        <td colspan="2" class="texto"><span class="TextoForm">
          <input name="txtFone2" type="text" class="text" id="txtFone2"  onkeypress="mascara(this,telefone)"  maxlength="14"  value="<%=strFone2%>" size="18">
        </span></td>
      </tr>
      <tr>
        <td class="texto"><strong>Fax</strong></td>
        <td colspan="2" class="texto">&nbsp;</td>
      </tr>
      <tr>
        <td class="texto"><span class="TextoForm">
          <input name="txtFax" type="text" class="text" id="txtFax" value="<%=strFax%>"  onkeypress="mascara(this,telefone)"  maxlength="14"  size="18">
        </span></td>
        <td colspan="2" class="texto">&nbsp;</td>
      </tr>
      <tr>
        <td class="texto"><strong>Celular(1)</strong></td>
        <td colspan="2" class="texto"><strong>Celular(2)</strong></td>
      </tr>
      <tr>
        <td class="texto"><span class="TextoForm">
          <input name="txtCelular1" type="text" class="text" id="txtCelular1"  onkeypress="mascara(this,telefone)"  maxlength="14"  value="<%=strCelular1%>" size="18">
        </span></td>
        <td colspan="2" class="texto"><span class="TextoForm">
          <input name="txtCelular2" type="text" class="text" id="txtCelular2"  onkeypress="mascara(this,telefone)"  maxlength="14"  value="<%=strCelular2%>" size="18">
        </span></td>
      </tr>
      <tr>
        <td colspan="3" class="texto"><strong>E-mail</strong></td>
      </tr>
      <tr>
        <td colspan="3" class="texto"><input name='txtEmail' class="text"  value="<%=strEmail%>" type='text' id="txtEmail" size='60' maxlength='60'></td>
      </tr>
      <tr>
        <td colspan="3" class="texto"><strong>Site</strong></td>
      </tr>
      <tr>
        <td colspan="3" class="texto"><input name='txtSite' class="text" onKeyUp="mascara(this,site)" value="<%=strSite%>" type='text' id="txtSite" size='60' maxlength='60'></td>
      </tr>
      <tr>
        <td colspan="3" class="texto">&nbsp;</td>
      </tr>



            <tr>
              <td height="20" colspan="3" bgcolor="#DEE8EA" class="texto"><strong>Dados do contato para acesso a area administrativa</strong></td>
            </tr>
            <tr>
              <td colspan="3"  class="texto"><strong>CPF </strong></td>
            </tr>
            <tr>
              <td colspan="3"  class="texto"><input name='txtCPFContato' class="text" type='text' id="txtCPFContato" size='16' maxlength='14' value="<%=strCPFContato%>" onKeyPress="return funcCheckCPF_CNPJ(this,18,11)" <%=strBloqueiaCampo%> ></td>
            </tr>
            <tr>
              <td colspan="3"  class="texto">Com esse CPF o usu&aacute;rio ater&aacute; acesso a area administrativa com acesso aos servi&ccedil;os</td>
            </tr>
            <tr>
              <td colspan="3"  class="texto"><strong>Nome </strong></td>
            </tr>
            <tr>
              <td colspan="3"  class="texto"><input name='txtNomeContato' class="text" type='text' id="txtNomeContato" size='60' maxlength='60' value="<%=strNomeContato%>"></td>
            </tr>
            <tr>
              <td colspan="3"  class="texto"><strong>Fone</strong></td>
            </tr>
            <tr>
              <td colspan="3"  class="texto"><span class="TextoForm">
                <input name="txtFoneContato" type="text" class="text" id="txtFoneContato" value="<%=strFoneContato%>" size="18" onKeyPress="mascara(this,telefone)"  maxlength="14" >
              </span></td>
            </tr>
            <tr>
              <td colspan="3" class="texto"><strong>Senha</strong></td>
            </tr>
            <tr>
              <td colspan="3"><input  name="txtSenha" class="text" type="password" value="<%=strSenha%>" id="txtSenha" size="20" maxlength="32" <%=strBloqueiaCampo%> ></td>
            </tr>
            <tr>
              <td colspan="3" class="texto"><strong>Confirmar Senha</strong></td>
            </tr>
            <tr>
              <td colspan="3">
                <input  name="txtCSenha" class="text" type="password" value="<%=strSenha%>" id="txtCSenha" size="20" maxlength="32" <%=strBloqueiaCampo%>></td>
            </tr>
            <tr>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
              <td height="20" colspan="3" bgcolor="#DEE8EA" class="texto"><strong>M&oacute;dulos</strong></td>
            </tr>
            <tr>
              <td colspan="3"  class="texto">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="3">
              
              <%
			IF intCodEmpresa = "" then intCodEmpresa = "0"
			sql = " select s.codigo, s.descricao, null as codEmpresa"
			sql = sql & " from SEG_servicos s"
			sql = sql & " where s.codigo not in "
			sql = sql & " ("
			sql = sql & " select codServico"
			sql = sql & " from SEG_empresa_servicos"
			sql = sql & " where codEmpresa = " & intCodEmpresa
			sql = sql & " )"
			sql = sql & " union"
			sql = sql & " select s.codigo, s.descricao, es.codEmpresa"
			sql = sql & " from SEG_servicos s"
			sql = sql & " inner join SEG_empresa_servicos es on s.codigo = es.codServico"
			sql = sql & " where es.codEmpresa = " & intCodEmpresa
			sql = sql & " order by 1"
			rs.open sql, cnn
			if not rs.eof then  
				while not rs.eof
					if isnull(rs("codEmpresa")) then
						strChecked = ""
					else
						strChecked = "Checked"
					end if
				
				%>
              <table width="93%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="16%" class="texto"><input <%=strChecked%> type="checkbox" name="chkServico" id="chkServico" value="<%=rs("codigo")%>">&nbsp;<%=rs("Descricao")%></td>
                </tr>
                </table>
            <%
					rs.movenext
				wend
			end if
			rs.close				  
			%>
              
              </td>
            </tr>
            <tr>
              <td align="center">&nbsp;</td>
              <td align="center">&nbsp;</td>
              <td align="center">&nbsp;</td>
            </tr>


      <tr>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="3"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
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