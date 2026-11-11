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
	strPaginaTitulo 						= "Cadastro de Profissional Escolar em Sala de Aula - Documentos e Endereço - Registro 40"
	intCodEmpresa							= Trim(Request("CodEscola"))
	strTipoRegistro							= Trim(Request.Form("txtTipoRegistro"))
	intCodEscolaInep	 					= Trim(Request.Form("txtCodEscolaInep"))
	strIdentificacaoProssionalInep			= Trim(Request.Form("txtIdentificacaoProssionalInep"))
	strCodProfissionalEscola				= Trim(Request.Form("txtCodProfissionalEscola"))
	strCPF									= Trim(Request.Form("txtCPF"))
	strResidencia							= Trim(Request.Form("txtResidencia"))
	strCEP									= Trim(Request.Form("txtCEP"))
	strEndereco								= Trim(Request.Form("txtEndereco"))
	strNumEndereco							= Trim(Request.Form("txtNumEndereco"))
	strComplemento							= Trim(Request.Form("txtComplemento"))
	strBairro								= Trim(Request.Form("txtBairro"))
	strUF									= Trim(Request.Form("txtUF"))
	strMunicipio							= Trim(Request.Form("txtMunicipio"))
	
	
	if trim(intCodEmpresa) <> "" then
	     
		sql = "SELECT CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoProssionalInep, CodProfissionalEscola, "
		sql = sql & " CPF, Residencia, CEP, Endereco, NumEndereco, Complemento, Bairro, UF, Municipio "
		sql = sql & " FROM REGISTRO40"
		sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
	
		if rs.eof = false then
		
			intCodEmpresa							= rs("CodEmpresa")
			strTipoRegistro							= rs("TipoRegistro")
			intCodEscolaInep	 					= rs("CodEscolaInep")
			strIdentificacaoProssionalInep			= rs("IdentificacaoProssionalInep")
			strCodProfissionalEscola				= rs("CodProfissionalEscola")
			strCPF									= rs("CPF")
			strResidencia							= rs("Residencia")
			strCEP									= rs("CEP")
			strEndereco								= rs("Endereco")
			strNumEndereco							= rs("NumEndereco")
			strComplemento							= rs("Complemento")
			strBairro								= rs("Bairro")
			strUF									= rs("UF")
			strMunicipio							= rs("Municipio")

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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Profissional Escolar em Sala de Aula - Documentos e Endereço - Registro 40</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
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
                    <td height="25" class="texto1">C&oacute;digo da Escola - INEP</td>
                    <td><input style="width:100pt" name="txtCodEscolaInep" type="text" class="form-control" id="txtCodEscolaInep" size="8" maxlength="8" value="<%=trim(intCodEscolaInep)%>"></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">              Identifica&ccedil;&atilde;o &uacute;nica do Profissional escolar em sala de Aula (Inep)</td>
                    <td><input style="width:100pt" name="txtIdentificacaoProssionalInep" type="text" class="form-control" id="txtIdentificacaoProssionalInep" size="8" maxlength="8" value="<%=trim(strIdentificacaoProssionalInep)%>"></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">C&oacute;digo do Profissional escolar em sala de Aula na Entidade/Escola</td>
                    <td><input style="width:100pt" name="txtCodProfissionalEscola" type="text" class="form-control" id="txtCodProfissionalEscola" size="8" maxlength="8" value="<%=trim(strCodProfissionalEscola)%>"></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">CPF</td>
                    <td><input style="width:100pt" name="txtCPF" type="text" class="form-control" id="txtCPF" size="18" maxlength="14" onKeyPress="return formataCampo(this, 5, 14)" onBlur="return validaCPF(this)" value="<%=trim(strCPF)%>"></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">Localiza&ccedil;&atilde;o Zona de Residencia</td>
                    <td><input style="width:100pt" name="txtResidencia" type="text" class="form-control" id="txtResidencia" size="50" maxlength="50" value="<%=trim(strResidencia)%>"></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1"> CEP             </td>
                    <td><input style="width:100pt" name="txtCEP" type="text" class="form-control" id="txtCEP" size="8" maxlength="8" value="<%=trim(strCEP)%>"></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">Endere&ccedil;o</td>
                    <td><input style="width:100pt" name="txtEndereco" type="text" class="form-control" id="txtEndereco" size="8" maxlength="8" value="<%=trim(strEndereco)%>"></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1"> N&uacute;merpo             Endere&ccedil;o</td>
                    <td><input style="width:100pt" name="txtNumEndereco" type="text" class="form-control" id="txtNumEndereco" size="8" maxlength="8" value="<%=trim(strNumEndereco)%>" /></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">Complemento</td>
                    <td><input style="width:100pt" name="txtComplemento" type="text" class="form-control" id="txtComplemento" size="50" maxlength="50" value="<%=trim(strComplemento)%>" /></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">Bairro</td>
                    <td><input style="width:100pt" name="txtBairro" type="text" class="form-control" id="txtBairro" size="50" maxlength="50" value="<%=trim(strBairro)%>" /></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">UF</td>
                    <td><input style="width:100pt" name="txtUF" type="text" class="form-control" id="txtUF" size="8" maxlength="8" value="<%=trim(strUF)%>" /></td>
                  </tr>
                  <tr>
                    <td height="25" class="texto1">Municipio</td>
                    <td><input style="width:100pt" name="txtMunicipio" type="text" class="form-control" id="txtMunicipio" size="50" maxlength="50" value="<%=trim(strMunicipio)%>" /></td>
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
		frm.action="Registro40_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 