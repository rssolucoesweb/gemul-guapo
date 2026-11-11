<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"--> 
<script src="../../js/js_funcoes_gerais.js"></script> 
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Senso</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
<%
	strFuncao = ""
	strPaginaTitulo 						= "Cadastro de Aluno - Documentos e Endere&ccedil;o - Registro 70"
	
	intCodEmpresa							= Trim(Request("CodEscola"))
	strTipoRegistro							= Trim(Request.Form("txtTipoRegistro"))
	intCodEscolaInep	 					= Trim(Request.Form("txtCodEscolaInep"))
	strIdentificacaoUnicaAlunoInep			= Trim(Request.Form("txtIdentificacaoUnicaAlunoInep"))
	strCodAlunoEntidadeEscola				= Trim(Request.Form("txtCodAlunoEntidadeEscola"))
	
	strNumIdentidade						= Trim(Request.Form("txtNumIdentidade"))
	strComplementoIdentidade				= Trim(Request.Form("txtComplementoIdentidade"))
	strOrgaoEmissorIdentidade				= Trim(Request.Form("txtOrgaoEmissorIdentidade"))
	strUFIdentidade							= Trim(Request.Form("cmbUFIdentidade"))
	strTipoCertidaoCivil					= Trim(Request.Form("cmbTipoCertidaoCivil"))
	strNumeroTermo							= Trim(Request.Form("txtNumeroTermo"))
	strFolha								= Trim(Request.Form("txtFolha"))
	strLivro								= Trim(Request.Form("txtLivro"))
	strDataEmissaoCertidao					= Trim(Request.Form("txtDataEmissaoCertidao"))
	strUFCartorio							= Trim(Request.Form("txtUFCartorio"))
	strMunicipioCartorio					= Trim(Request.Form("txtMunicipioCartorio"))
	strCodigoCartorio						= Trim(Request.Form("txtCodigoCartorio"))
	strNumeroMatricula						= Trim(Request.Form("txtNumeroMatricula"))
	strNumeroCPF							= Trim(Request.Form("txtNumeroCPF"))
	strDocumentoEstrangeiro					= Trim(Request.Form("txtDocumentoEstrangeiro"))
	strNumeroIdentificacaoSocial			= Trim(Request.Form("txtNumeroIdentificacaoSocial"))
	strJustificativaFaltaDocumentoAluno		= Trim(Request.Form("txtJustificativaFaltaDocumentoAluno"))
	strLocalizacaoZonaResidencia			= Trim(Request.Form("txtLocalizacaoZonaResidencia"))
	strCEP									= Trim(Request.Form("txtCEP"))
	strEndereco								= Trim(Request.Form("txtEndereco"))
	strNumero								= Trim(Request.Form("txtNumero"))
	strUF									= Trim(Request.Form("txtUF"))
	strMunicipio							= Trim(Request.Form("txtMunicipio"))
	strComplemento							= Trim(Request.Form("txtComplemento"))
	strBairro								= Trim(Request.Form("txtBairro"))
	
	if trim(intCodEmpresa) <> "" then
	     
		sql = "SELECT CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoUnicaAlunoInep, CodAlunoEntidadeEscola, "
		sql = sql & " NumIdentidade, ComplementoIdentidade, OrgaoEmissorIdentidade, UFIdentidade, TipoCertidaoCivil, NumeroTermo, "
		sql = sql & " Folha, Livro, DataEmissaoCertidao, UFCartorio, MunicipioCartorio, CodigoCartorio, "
		sql = sql & " NumeroMatricula, NumeroCPF, DocumentoEstrangeiro, NumeroIdentificacaoSocial, NumeroIdentificacaoSocial, "
		sql = sql & " JustificativaFaltaDocumentoAluno, LocalizacaoZonaResidencia, CEP, Endereco, "
		sql = sql & " Numero, UF, Municipio, Complemento, Bairro "
		sql = sql & " FROM REGISTRO70"
		sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
	
		if rs.eof = false then
		
			intCodEmpresa							= rs("CodEmpresa")
			strTipoRegistro							= rs("TipoRegistro")
			intCodEscolaInep	 					= rs("CodEscolaInep")
			strIdentificacaoUnicaAlunoInep			= rs("IdentificacaoUnicaAlunoInep")
			strCodAlunoEntidadeEscola				= rs("CodAlunoEntidadeEscola")
		
			strNumIdentidade						= rs("NumIdentidade")
			strComplementoIdentidade				= rs("ComplementoIdentidade")
			strOrgaoEmissorIdentidade				= rs("OrgaoEmissorIdentidade")
			strUFIdentidade							= rs("UFIdentidade")
			strTipoCertidaoCivil					= rs("TipoCertidaoCivil")
			strNumeroTermo							= rs("NumeroTermo")
			strFolha								= rs("Folha")
			strLivro								= rs("Livro")
			strDataEmissaoCertidao					= rs("DataEmissaoCertidao")
			strUFCartorio							= rs("UFCartorio")
			strMunicipioCartorio					= rs("MunicipioCartorio")
			strCodigoCartorio						= rs("CodigoCartorio")
			strNumeroMatricula						= rs("NumeroMatricula")
			strNumeroCPF							= rs("NumeroCPF")
			strDocumentoEstrangeiro					= rs("DocumentoEstrangeiro")
			strNumeroIdentificacaoSocial			= rs("NumeroIdentificacaoSocial")
			strJustificativaFaltaDocumentoAluno		= rs("JustificativaFaltaDocumentoAluno")
			strLocalizacaoZonaResidencia			= rs("LocalizacaoZonaResidencia")
			strCEP									= rs("CEP")
			strEndereco								= rs("Endereco")
			strNumero								= rs("Numero")
			strUF									= rs("UF")
			strMunicipio							= rs("Municipio")
			strComplemento							= rs("Complemento")
			strBairro								= rs("Bairro")
		

			strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
			
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if
%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Aluno - Documentos e Endere&ccedil;o - Registro 70</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="25" class="texto1">Empresa:</td>
            <td><input style="width:100pt" name="txtCodEmpresa" type="text" class="form-control" id="txtCodEmpresa" size="8" maxlength="8" value="<%=trim(intCodEmpresa)%>"></td>
          </tr>
          <tr>
            <td width="424" height="25" class="texto1">Tipo de Registro</td>
            <td width="857"><input style="width:100pt" name="txtTipoRegistro" type="text" class="form-control" id="txtTipoRegistro" size="2" maxlength="5" value="<%=trim(strTipoRegistro)%>">            </td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo da Escola - Inep</td>
            <td><input style="width:100pt" name="txtCodEscolaInep" type="text" class="form-control" id="txtCodEscolaInep" size="8" maxlength="8" value="<%=trim(intCodEscolaInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Indentifica&ccedil;&atilde;o &uacute;nicia do aluno (inep)</td>
            <td><input style="width:100pt" name="txtIdentificacaoUnicaAlunoInep" type="text" class="form-control" id="txtIdentificacaoUnicaAlunoInep" size="8" maxlength="8" value="<%=trim(strIdentificacaoUnicaAlunoInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do aluno na entidade/Escola</td>
            <td><input style="width:100pt" name="txtCodAlunoEntidadeEscola" type="text" class="form-control" id="txtCodAlunoEntidadeEscola" size="8" maxlength="8" value="<%=trim(strCodAlunoEntidadeEscola)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">N&uacute;mero da Identidade</td>
            <td><input style="width:100pt" name="txtNumIdentidade" type="text" class="form-control" id="txtNumIdentidade" size="8" maxlength="8" value="<%=trim(strNumIdentidade)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Complemento da Identidade</td>
            <td><input style="width:100pt" name="txtComplementoIdentidade" type="text" class="form-control" id="txtComplementoIdentidade" size="8" maxlength="8" value="<%=trim(strComplementoIdentidade)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">&Oacute;rg&atilde;o emissor da Identidade</td>
            <td><input style="width:100pt" name="txtOrgaoEmissorIdentidade" type="text" class="form-control" id="txtOrgaoEmissorIdentidade" size="8" maxlength="8" value="<%=trim(strOrgaoEmissorIdentidade)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">UF da identidade</td>
            <td><select name="cmbUFIdentidade" id="cmbUFIdentidade" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strUFIdentidade = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strUFIdentidade = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Data de expedi&ccedil;&atilde;o da identidade</td>
            <td><input style="width:100pt" name="txtDataExpedicaoIdentidade" type="text" class="form-control" id="txtDataExpedicaoIdentidade" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="8" maxlength="10" value="<%=trim(strDataExpedicaoIdentidade)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipo de Certid&atilde;o Civil</td>
            <td><select name="cmbTipoCertidaoCivil" id="cmbTipoCertidaoCivil" class="form-control" style="width:100pt" >
                <option value="0">Selecione...</option>
                <option <%if strTipoCertidaoCivil = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                <option <%if strTipoCertidaoCivil = "1" then%> selected <%end if%> value="1">Sim</option>
              </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">N&uacute;mero do Termo</td>
            <td><input style="width:100pt" name="txtNumeroTermo" type="text" class="form-control" id="txtNumeroTermo" size="8" maxlength="8" value="<%=trim(strNumeroTermo)%>"></td>
          </tr>
          <tr>
            <td height="20" class="texto1">Folha</td>
            <td><input style="width:100pt" name="txtFolha" type="text" class="form-control" id="txtFolha" size="8" maxlength="8" value="<%=trim(strFolha)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Livro</td>
            <td><input style="width:100pt" name="txtLivro" type="text" class="form-control" id="txtLivro" size="8" maxlength="8" value="<%=trim(strLivro)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Data de emiss&atilde;o da certid&atilde;o</td>
            <td><input style="width:100pt" name="txtDataEmissaoCertidao" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" id="txtDataEmissaoCertidao" size="8" maxlength="10" value="<%=trim(strDataEmissaoCertidao)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">UF do Cart&oacute;rio</td>
            <td><input style="width:100pt" name="txtUFCartorio" type="text" class="form-control" id="txtUFCartorio" size="8" maxlength="8" value="<%=trim(strUFCartorio)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Munic&iacute;pio do Cart&oacute;rio</td>
            <td><input style="width:100pt" name="txtMunicipioCartorio" type="text" class="form-control" id="txtMunicipioCartorio" size="8" maxlength="8" value="<%=trim(strMunicipioCartorio)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Cart&oacute;rio</td>
            <td><input style="width:100pt" name="txtCodigoCartorio" type="text" class="form-control" id="txtCodigoCartorio" size="8" maxlength="8" value="<%=trim(strCodigoCartorio)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">N&uacute;mero da Matr&iacute;cula ( Registro Civil - Certid&atilde;o nova)</td>
            <td><input style="width:100pt" name="txtNumeroMatricula" type="text" class="form-control" id="txtNumeroMatricula" size="8" maxlength="8" value="<%=trim(strNumeroMatricula)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">N&uacute;mero do CPF</td>
            <td><input style="width:100pt" name="txtNumeroCPF" type="text" class="form-control" id="txtNumeroCPF" maxlength="14" onKeyPress="return formataCampo(this, 5, 14)" onBlur="return validaCPF(this)" value="<%=trim(strNumeroCPF)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Documento estrangeiro/Passaporte</td>
            <td><input style="width:100pt" name="txtDocumentoEstrangeiro" type="text" class="form-control" id="txtDocumentoEstrangeiro" size="8" maxlength="8" value="<%=trim(strDocumentoEstrangeiro)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">N&uacute;mero de Identifica&ccedil;&atilde;o Social (NIS)</td>
            <td><input style="width:100pt" name="txtNumeroIdentificacaoSocial" type="text" class="form-control" id="txtNumeroIdentificacaoSocial" size="8" maxlength="8" value="<%=trim(strNumeroIdentificacaoSocial)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Justificativa para a falta de documenta&ccedil;&atilde;o do aluno</td>
            <td><input style="width:100pt" name="txtJustificativaFaltaDocumentoAluno" type="text" class="form-control" id="txtJustificativaFaltaDocumentoAluno" size="8" maxlength="8" value="<%=trim(txtJustificativaFaltaDocumentoAluno)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Localiza&ccedil;&atilde;o / Zona de resid&ecirc;ncia</td>
            <td><input style="width:100pt" name="txtLocalizacaoZonaResidencia" type="text" class="form-control" id="txtLocalizacaoZonaResidencia" size="8" maxlength="8" value="<%=trim(strLocalizacaoZonaResidencia)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">CEP</td>
            <td><input style="width:100pt" name="txtCEP" type="text" onKeyPress="mascara(this,cep)"  class="form-control" id="txtCEP" maxlength="9" value="<%=trim(strCEP)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Endere&ccedil;o</td>
            <td><input style="width:100pt" name="txtEndereco" type="text" class="form-control" id="txtEndereco" size="8" maxlength="8" value="<%=trim(strEndereco)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">N&uacute;mero</td>
            <td><input style="width:100pt" name="txtNumero" type="text" class="form-control" id="txtNumero" size="8" maxlength="8" value="<%=trim(strNumero)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">UF</td>
            <td><input style="width:100pt" name="txtUF" type="text" class="form-control" id="txtUF" size="8" maxlength="8" value="<%=trim(strUF)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Munic&iacute;pio</td>
            <td><input style="width:100pt" name="txtMunicipio" type="text" class="form-control" id="txtMunicipio" size="8" maxlength="8" value="<%=trim(strMunicipio)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Complemento</td>
            <td><input style="width:100pt" name="txtComplemento" type="text" class="form-control" id="txtComplemento" size="8" maxlength="8" value="<%=trim(strComplemento)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Bairro</td>
            <td><input style="width:100pt" name="txtBairro" type="text" class="form-control" id="txtBairro" size="8" maxlength="8" value="<%=trim(strBairro)%>"></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
           </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
        </table>
        </form>
        </div>
    </div>
   	<!-- Fecha o Form -->  
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		var frm = document.getElementById("frm");
		frm.action="Registro70_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 