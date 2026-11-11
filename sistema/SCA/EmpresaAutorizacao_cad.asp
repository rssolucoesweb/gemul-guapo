<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 16/09/2007
	::	Desenvolvedores...: Sérgio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Cadastro de empresa 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 9;
}
-->
</style>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCnpj.asp"-->
<script>
	
	
	function resultadoConsulta(intCodigo){
		frm.action="EmpresaAutorizacao_cad.asp?txtCodEmpresa="+intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		

		if (frm.txtAutorizacao.value == "") {
			alert("A Autorizacao de Funcionamento deve ser informada!");
			frm.txtAutorizacao.focus();
			return false;
		} 
		if (frm.txtEndereco.value == "") {
			alert("O Endereço deve ser informado!");
			frm.txtEndereco.focus();
			return false;
		} 
		
		if (frm.txtBairro.value == "") {
			alert("O Bairro deve ser informado!");
			frm.txtBairro.focus();
			return false;
		} 
		
		if (frm.txtMunicipio.value == "") {
			alert("O Municipio deve ser informado!");
			frm.txtMunicipio.focus();
			return false;
		} 
		
		if (frm.txtUF.value == "") {
			alert("O Estado deve ser informado!");
			frm.txtUF.focus();
			return false;
		} 
	
		if (frm.txtTelefone.value == "") {
			alert("O Telefone deve ser informado!");
			frm.txtTelefone.focus();
			return false;
		} 

	
		if (acao=="I") {
		
			frm.action="EmpresaAutorizacao_cod.asp?acao=" + acao + "&txtCodEmpresa=" + frm.txtCodEmpresa.value;
			frm.submit();
			return true;	
			} 
		else{
			var parametro;
			parametro = "&txtCodEmpresa="+frm.txtCodEmpresa.value;
			parametro = parametro + "&txtAutorizacao="+frm.txtAutorizacao.value;
			parametro = parametro + "&txtDiretor="+frm.txtDiretor.value;
			parametro = parametro + "&txtSecretaria="+frm.txtSecretaria.value;
			parametro = parametro + "&txtContato="+frm.txtContato.value;
			parametro = parametro + "&txtContato1="+frm.txtContato1.value;
			parametro = parametro + "&txtContato2="+frm.txtContato2.value;
			parametro = parametro + "&txtEndereco="+frm.txtEndereco.value;
			parametro = parametro + "&txtBairro="+frm.txtBairro.value;
			parametro = parametro + "&txtMunicipio="+frm.txtMunicipio.value;
			parametro = parametro + "&txtUF="+frm.txtUF.value;
			parametro = parametro + "&txtCep="+frm.txtCep.value;
			parametro = parametro + "&txtTelefone="+frm.txtTelefone.value;
			parametro = parametro + "&txtCodigoCenso="+frm.txtCodigoCenso.value;
			parametro = parametro + "&txtCodigoSetransp="+frm.txtCodigoSetransp.value;
			frm.action="EmpresaAutorizacaoAE_cod.asp?acao=" + acao + parametro;
			frm.submit();
			return true;	
		}

	}
</script>


<table width="100%" height="355" border="0" cellpadding="0" bgcolor="#FFFFFF" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form method="post" id="frm" ENCTYPE="multipart/form-data">
		<%
		strPagina					= "EmpresaAutorizacao_cad.asp"
		strCodigo 					= Trim(Request("txtCodEmpresa"))
		strAutorizacao 				= Trim(Request.Form("txtAutorizacao"))
		strSecretaria				= Trim(Request.Form("txtSecretaria"))
		strContato					= Trim(Request.Form("txtContato"))
		strContato1					= Trim(Request.Form("txtContato1"))
		strContato2					= Trim(Request.Form("txtContato2"))
		strEndereco					= Trim(Request.Form("txtEndereco"))
		strBairro					= Trim(Request.Form("txtBairro"))
		strMunicipio				= Trim(Request.Form("txtMunicipio"))
		strUF						= Trim(Request.Form("txtUF"))
		strCep						= Trim(Request.Form("txtCep"))
		strTelefone					= Trim(Request.Form("txtTelefone"))
		strCodigoCenso				= Trim(Request.Form("txtCodigoCenso"))
		strCodigoSetransp			= Trim(Request.Form("txtCodigoSetransp"))


		if strCodigo <> "" then
		
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar'
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir'
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			
			sql = "SELECT * "
			sql = sql & " FROM SEG_EMPRESA"
			sql = sql & " WHERE CODIGO = " & strCodigo
			
			rs.open sql, cnn
			if rs.eof = false then
				strCodigo  					= Trim(RS("CODIGO"))
				strAutorizacao 				= Trim(RS("Autorizacao"))
				strDiretor					= Trim(RS("Diretor"))
				strSecretaria				= Trim(RS("Secretaria"))
				strContato					= Trim(RS("Contato"))
				strContato1					= Trim(RS("Contato1"))
				strContato2					= Trim(RS("Contato2"))
				strEndereco					= Trim(RS("Endereco"))
				strBairro					= Trim(RS("Bairro"))
				strMunicipio				= Trim(RS("Municipio"))
				strUF						= Trim(RS("UF"))
				strCep						= Trim(RS("Cep"))
				strTelefone					= Trim(RS("Telefone"))
				strNomeLogo					= Trim(RS("LOGOMARCA"))	
				strLogoConvenio				= Trim(RS("LogoConvenio"))	
				strNotificacao				= Trim(RS("NOTIFICACAO"))
				strCodigoCenso					= Trim(RS("CODIGO_CENSO"))
				strCodigoSetransp				= Trim(RS("CODIGO_SETRANSP"))
			else
			    strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
			end if 
			rs.close
		else
		    strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
			strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
		end if 
		
		IF strNomeLogo <> "" then
			strImagem = "<img src='..\..\LogoMarcas\" & strNomeLogo & "\" & strCodigo & "' border='1' width='85' height='113'>"
		else
			strImagem = "<font color='#CCCCCC'>  LOGO </font>"
		end if
		
		IF strLogoConvenio <> "" then
			strImagem = "<img src='..\..\LogoConvenio\" & intCodGrupo & "\" & strLogoConvenio & "' border='1' width='85' height='113'>"
		else
			strImagem = "<font color='#CCCCCC'>  LOGO </font>"
		end if
		%>
		  <table width="98%">
			<tr> 
			  <td class="titulo" align="center" colspan="5"><strong>Cadastro de Empresa </strong></td>
			</tr>
			<tr> 
			  <td class="titulo" align="center" colspan="5"><input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa" class="text" size="10" value="<%=strCodigo%>" maxlength="10"></td>
			</tr>
			<tr>
			  <td width="12%" class="label" >&nbsp;</td>
			  <td colspan="4" class="titulo1">&nbsp;</td>
			  </tr>
			
			<tr>
			  <td class="label">Autoriza&ccedil;&atilde;o:</td>
			  <td colspan="4" class="label"><textarea name="txtAutorizacao" cols="70" rows="5" class="text" id="txtAutorizacao"><%=strAutorizacao%></textarea>
			    Para realizar uma quebra	de	linha	utilize a tag &lt;BR&gt; dentro seu texto.
			</tr>
			<tr>
			  <td class="label"><strong>Diretor(a):</strong></td>
			  <td colspan="4" class="titulo1"><input name="txtDiretor" type="text" class="text" id="txtDiretor" value="<%=strDiretor%>" size="60" maxlength="50"></td>
			  </tr>
			<tr>
			  <td class="label"  ><strong>Secretario(a):</strong></td>
			  <td colspan="4" class="titulo1"><input name="txtSecretaria" type="text" class="text" id="txtSecretaria" value="<%=strSecretaria%>" size="60" maxlength="50"></td>
			  </tr>
			<tr>
			  <td class="label"  ><strong>1&ordm; Contato:</strong></td>
			  <td class="titulo1"><input name="txtContato" type="text" class="text" id="txtContato" value="<%=strContato%>" size="60" maxlength="50"></td>
			  <td width="12%" class="titulo1">&nbsp;</td>
			  <td colspan="2" class="titulo1">&nbsp;</td>
			  </tr>
			<tr>
			  <td class="label"  ><strong>2&ordm; Contato:</strong></td>
			  <td class="titulo1"><input name="txtContato1" type="text" class="text" id="txtContato1" value="<%=strContato1%>" size="60" maxlength="50"></td>
			  <td class="titulo1">&nbsp;</td>
			  <td colspan="2" class="titulo1">&nbsp;</td>
			  </tr>
			<tr>
			  <td class="label"  ><strong>3&ordm; Contato:</strong></td>
			  <td class="titulo1"><input name="txtContato2" type="text" class="text" id="txtContato2" value="<%=strContato2%>" size="60" maxlength="50"></td>
			  <td class="titulo1"><span class="label"><strong>Telefone Unidade:</strong></span></td>
			  <td colspan="2" class="titulo1"><input name="txtTelefone" type="text" class="text" id="txtTelefone" onKeyPress="mascara(this,telefone)" value="<%=strTelefone%>" size="20" maxlength="14"></td>
			  </tr>
			<tr>
			  <td class="label"  ><strong>Endere&ccedil;o:</strong></td>
			  <td class="titulo1"><input name="txtEndereco" type="text" class="text" id="txtEndereco" value="<%=strEndereco%>" size="60" maxlength="50"></td>
			  <td class="titulo1"><span class="label"><strong>Cep:</strong></span></td>
			  <td colspan="2" class="titulo1"><span class="texto1">
			    <input name="txtCep" type="text" class="text" id="txtCep" onKeyPress="return formataCampo(this,2,8)" size="10" maxlength="10" value="<%=strCep%>">
			  </span></td>
			  </tr>
			<tr> 
			  <td class="label"  ><strong>Bairro:</strong></td>
			  <td colspan="4" class="titulo1">			    <input name="txtBairro" type="text" class="text" id="txtBairro" value="<%=strBairro%>" size="40" maxlength="30">			    </td>
			</tr>
			<tr>
			  <td class="label"  ><strong>Munic&iacute;pio:</strong></td>
			  <td class="titulo1"><input name="txtMunicipio" type="text" class="text" id="txtMunicipio" value="<%=strMunicipio%>" size="60" maxlength="50"></td>
			  <td class="titulo1"><span class="label"><strong>Estado:</strong></span></td>
			  <td colspan="2" class="titulo1"><span class="texto1">
			    <input name="txtUF" type="text" class="text" id="txtUF" size="3" maxlength="2" value="<%=strUF%>" onKeyPress="return formataCampo(this, 1, 2)">
			  </span></td>
			  </tr>
			
			<tr>
			  <td class="label"  >C&oacute;digo Inep:</td>
			  <td colspan="4" class="titulo1"><span class="texto1">
			    <input name="txtCodigoCenso" type="text" class="text" id="txtCodigoCenso" onKeyPress="return formataCampo(this,2,8)" size="10" maxlength="10" value="<%=strCodigoCenso%>">
			  </span></td>
			  </tr>
			<tr>
			  <td class="label"  >C&oacute;digo Setransp:</td>
			  <td colspan="4" class="titulo1"><span class="texto1">
			    <input name="txtCodigoSetransp" type="text" class="text" id="txtCodigoSetransp" onKeyPress="return formataCampo(this,2,8)" size="10" maxlength="10" value="<%=strCodigoSetransp%>">
			  </span></td>
			  </tr>
			
			<tr>
			  <td colspan="5" class="label" align="left">&nbsp;</td>
			  </tr>
			<tr>
			  <td colspan="5" class="label" align="left"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
			  </tr>
			<tr>
			  <td colspan="5" class="label" align="left"  >&nbsp;</td>
			  </tr>
			
			<tr>
			  <td colspan="5" class="label"  >
			<%
			cont =0
			
			sql = "SELECT SEG_EMPRESA.Codigo, Cnpj, RazaoSocial, LOGOMARCA, SEG_GRUPO.DESCRICAO AS GRUPO, LogoConvenio, COD_GRUPO"
			sql = sql & " FROM SEG_EMPRESA "  
			sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
		    sql = sql & " WHERE  1=1" 
			sql = sql & "and SEG_EMPRESA.CODIGO = " & Session("CodEmpresa")  
			sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RazaoSocial"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="21%" height="21" class="celula"><strong>Grupo</strong></td>
                    <td width="3%" class="celula"><strong>Cod.</strong></td>
                    <td width="13%" class="celula"><strong>CNPJ </strong></td>
                    <td width="33%" class="celula"><strong>Raz&atilde;o Social<span class="TextoForm"></span></strong></td>
                    <td width="10%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Logo Marca</strong></td>
                    <td width="12%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Logo Convenio </strong></td>
                    </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					
					if isnull(rs("LOGOMARCA")) or rs("LOGOMARCA") = "" then
						caminhoLogo = "../../LogoMarcas/LogoEmpresa.gif"
					else
						caminhoLogo = "../../LogoMarcas/" & rs("Codigo") & "/" & rs("LOGOMARCA")
					end if
					
					if isnull(rs("LogoConvenio")) or rs("LogoConvenio") = "" then
						caminhoLogoConvenio = "../../LogoConvenio/LogoEmpresa.gif"
					else
						caminhoLogoConvenio = "../../LogoConvenio/" & Session("CodEmpresa") & "/" & rs("LogoConvenio")
					end if
					%>
                  <tr>
                    <td style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')" class="celula">&nbsp;<%=trim(rs("GRUPO"))%></td>
                    <td class="celula">&nbsp;<%=trim(rs("CODIGO"))%></td>
                    <td class="celula">&nbsp;<%=formataCnpjAP(rs("Cnpj"))%></td>
                    <td class="celula">&nbsp;<%=trim(rs("RazaoSocial"))%></td>
                    <td align="center" class="celula"><img src="<%=caminhoLogo%>" width="47" height="50"></td>
                    <td align="center" class="celula"><img src="<%=caminhoLogoConvenio%>" width="47" height="50"></td>
                    </tr>
                  <%				
					rs.movenext
					wend
				%>
                 <tr>
                 <td height="18" colspan="6" class="celula">Total Registros :<%=cont%></td>
                 </tr>
				  </table>
                <%
			  end if
			  rs.close%></td>
			  </tr>
			<tr> 
			  <td align="center" class="label"  >&nbsp;</td>
			  <td width="31%" align="center" class="titulo1">&nbsp;</td>
			  <td colspan="2" align="center" class="label" >&nbsp;</td>
			  <td width="30%" align="center" class="titulo1">&nbsp;</td>
			</tr>
			  <td colspan="5" align="left">&nbsp;</td>
			  </tr>
			<tr> 
			  <td colspan="5" align="left">&nbsp;</td>
			</tr>
		  </table>
		 <!-- FIM PAGINA -->
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>