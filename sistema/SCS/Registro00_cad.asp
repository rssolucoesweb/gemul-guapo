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
	strPaginaTitulo 				= "Cadastro de Escola - Indentificação - Registro 00"
	intCodEmpresa					= Trim(Request("CodEscola"))
	
	strTipoRegistro					= Trim(Request.Form("txtTipoRegistro"))
	intCodInep	 					= Trim(Request.Form("txtCodInep"))
	strSituacaoFuncional			= Trim(Request.Form("cmbSituacaoFuncional"))
	strDataInicioAnoLetivo 			= Trim(Request.Form("txtDataInicioAnoLetivo"))
	strDataTerminoAnoLetivo			= Trim(Request.Form("txtDataTerminoAnoLetivo"))
	strEscola 						= Trim(Request.Form("txtEscola"))
	strLatitude 					= Trim(Request.Form("txtLatitude"))
	strLogitude						= Trim(Request.Form("txtLogitude"))
	strCep							= Trim(Request.Form("txtCep"))
	strEndereco						= Trim(Request.Form("txtEndereco"))
	strNumero         				= Trim(Request.Form("txtNumero"))
	strComplemento         			= Trim(Request.Form("txtComplemento"))
	strBairro         				= Trim(Request.Form("txtBairro"))
	strUF         					= Trim(Request.Form("txtUF"))
	strMunicipio         			= Trim(Request.Form("txtMunicipio"))
	strDistrito         			= Trim(Request.Form("txtDistrito"))
	strDDD         					= Trim(Request.Form("txtDDD"))
	strTelefone         			= Trim(Request.Form("txtTelefone"))
	strTelefone1         			= Trim(Request.Form("txtTelefone1"))
	strOutroTelefone         		= Trim(Request.Form("txtOutroTelefone"))
	strFax         					= Trim(Request.Form("txtFax"))
	strEmail         				= Trim(Request.Form("txtEmail"))
	strCodRegional         			= Trim(Request.Form("txtCodRegional"))
	strDependenciaAdminstrativa 	= Trim(Request.Form("cmbDependenciaAdminstrativa"))
	strLocalizacaoZona         		= Trim(Request.Form("cmbLocalizacaoZona"))
	strCategoriaEscola     			= Trim(Request.Form("cmbCategoriaEscola"))
	strConveniadaComPoderPublico    = Trim(Request.Form("cmbConveniadaComPoderPublico"))
	strConveniadaComPoderPublico2   = Trim(Request.Form("cmbConveniadaComPoderPublico2"))
	strMantenedora1         		= Trim(Request.Form("txtMantenedora1"))
	strMantenedora2         		= Trim(Request.Form("txtMantenedora2"))
	strMantenedora3         		= Trim(Request.Form("txtMantenedora3"))
	strMantenedora4	        		= Trim(Request.Form("txtMantenedora4"))
	strSistemaS         			= Trim(Request.Form("cmbSistemaS"))
	strCNPJ1         				= Trim(Request.Form("txtCNPJ1"))
	strCNPJ2         				= Trim(Request.Form("txtCNPJ2"))
	strRegulamentacao         		= Trim(Request.Form("cmbRegulamentacao"))

	if trim(intCodEmpresa) <> "" then
	     
		sql = "SELECT Cod_empresa, TipoRegistro, CodInep, SituacaoFuncional, DataInicioAnoLetivo, DataTerminoAnoLetivo, Escola, Latitude, Logitude, "
		sql = sql & " Cep, Endereco, Numero, Complemento, Bairro, UF, Municipio, Distrito, DDD, "
		sql = sql & " Telefone, Telefone1, OutroTelefone,Fax,  Email, CodRegional,  "
		sql = sql & " DependenciaAdminstrativa, LocalizacaoZona, CategoriaEscola  , ConveniadaComPoderPublico ,  ConveniadaComPoderPublico2,"
		sql = sql & " Mantenedora1  , Mantenedora2, Mantenedora3, Mantenedora4, SistemaS, CNPJ1, CNPJ2,  Regulamentacao "
		sql = sql & " FROM REGISTRO00"
		sql = sql & " WHERE Cod_empresa = " & intCodEmpresa
		rs.open sql, cnn
	
		if rs.eof = false then
		
			strTipoRegistro					= rs("TipoRegistro")
			intCodInep	 					= rs("CodInep")
			strSituacaoFuncional			= rs("SituacaoFuncional")
			strDataInicioAnoLetivo 			= rs("DataInicioAnoLetivo")
			strDataTerminoAnoLetivo			= rs("DataTerminoAnoLetivo")
			strEscola 						= rs("Escola")
			strLatitude 					= rs("Latitude")
			strLogitude						= rs("Logitude")
			strCep							= rs("Cep")
			strEndereco						= rs("Endereco")
			strNumero         				= rs("Numero")
			strComplemento         			= rs("Complemento")
			strBairro         				= rs("Bairro")
			strUF         					= rs("UF")
			strMunicipio         			= rs("Municipio")
			strDistrito         			= rs("Distrito")
			strDDD         					= rs("DDD")
			strTelefone         			= rs("Telefone")
			strTelefone1         			= rs("Telefone1")
			strOutroTelefone         		= rs("OutroTelefone")
			strFax         					= rs("Fax")
			strEmail         				= rs("Email")
			strCodRegional         			= rs("CodRegional")
			strDependenciaAdminstrativa 	= rs("DependenciaAdminstrativa")
			strLocalizacaoZona         		= rs("LocalizacaoZona")
			strCategoriaEscola     			= rs("CategoriaEscola")
			strConveniadaComPoderPublico    = rs("ConveniadaComPoderPublico")
			strConveniadaComPoderPublico2   = rs("ConveniadaComPoderPublico2")
			strMantenedora1         		= rs("Mantenedora1")
			strMantenedora2         		= rs("Mantenedora2")
			strMantenedora3         		= rs("Mantenedora3")
			strMantenedora4	        		= rs("Mantenedora4")
			strSistemaS         			= rs("SistemaS")
			strCNPJ1         				= rs("CNPJ1")
			strCNPJ2         				= rs("CNPJ2")
			strRegulamentacao         		= rs("Regulamentacao")
			
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Escola - Indentifica&ccedil;&atilde;o - Registro 00</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td height="25">Empresa:</td>
                        <td><input style="width:150pt"  name="txtCodEmpresa" type="text" class="form-control" id="txtCodEmpresa" size="8" maxlength="8" value="<%=trim(intCodEmpresa)%>"></td>
                      </tr>
                      <tr>
                        <td width="235" height="25" >Tipo Registro : </td>
                        <td width="1046"><input style="width:350pt"  name="txtTipoRegistro" type="text" class="form-control" id="txtTipoRegistro" size="2" maxlength="5" value="<%=trim(strTipoRegistro)%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Cod. Escola - Inep :</td>
                        <td><input style="width:350pt"  name="txtCodInep" type="text" class="form-control" id="txtCodInep" size="8" maxlength="8" value="<%=trim(intCodInep)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Situação Funcional:</td>
                        <td>
                            <select name="cmbSituacaoFuncional" id="cmbClassificacao" class="form-control" style="width:350pt" >
                                <option value="0">Selecione...</option>
                                <option <%if strSituacaoFuncional = "1" then%> selected <%end if%> value="1">Em Atividadde</option>
                                <option <%if strSituacaoFuncional = "2" then%> selected <%end if%> value="2">Paralisada</option>
                                <option <%if strSituacaoFuncional = "3" then%> selected <%end if%> value="3">Extinta</option>
                            </select>                         </td>
                      </tr>
                      <tr>
                        <td height="25" >Data Inicio - Ano letivo: </td>
                        <td>
                          <input style="width:350pt"  name="txtDataInicioAnoLetivo" type="text" class="form-control" id="txtDataInicioAnoLetivo" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicioAnoLetivo%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Data Termino - Ano letivo:</td>
                        <td>
                          <input style="width:350pt"  name="txtDataTerminoAnoLetivo" type="text" class="form-control" id="txtDataTerminoAnoLetivo" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataTerminoAnoLetivo%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Nome Escola:</td>
                        <td>
                          <input style="width:350pt"  name="txtEscola" type="text" class="form-control" id="txtEscola" size="50" maxlength="50" value="<%=trim(strEscola)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Latitude: </td>
                        <td>
                          <input style="width:350pt"  name="txtLatitude" type="text" class="form-control" id="txtLatitude" size="8" maxlength="8" value="<%=trim(strLatitude)%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Logitude:</td>
                        <td>
                          <input style="width:350pt"  name="txtLogitude" type="text" class="form-control" id="txtLogitude" size="8" maxlength="8" value="<%=trim(strLogitude)%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >CEP:</td>
                        <td>
                          <input style="width:350pt"  name="txtCep" type="text" class="form-control" onKeyPress="mascara(this,cep)" id="txtCep" size="8" maxlength="8" value="<%=trim(strCep)%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Endereço:</td>
                        <td>
                          <input style="width:350pt"  name="txtEndereco" type="text" class="form-control" id="txtEndereco" size="50" maxlength="50" value="<%=trim(strEndereco)%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Endereço Número:</td>
                        <td>
                          <input style="width:100pt"  name="txtNumero" type="text" class="form-control" id="txtNumero" size="8" maxlength="8" value="<%=trim(strNumero)%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Complemento:</td>
                        <td><input style="width:350pt"  name="txtComplemento" type="text" class="form-control" id="txtComplemento" size="50" maxlength="50" value="<%=trim(strComplemento)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Bairro:</td>
                        <td><input style="width:350pt"  name="txtBairro" type="text" class="form-control" id="txtBairro" size="30" maxlength="30" value="<%=trim(strBairro)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >UF:</td>
                        <td><input style="width:350pt"  name="txtUF" type="text" class="form-control" id="txtUF" size="2" maxlength="5" value="<%=trim(strUF)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Municipio:</td>
                        <td><input style="width:350pt"  name="txtMunicipio" type="text" class="form-control" id="txtMunicipio" size="30" maxlength="30" value="<%=trim(strMunicipio)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Distrito:</td>
                        <td><input style="width:350pt" name="txtDistrito" type="text" class="form-control" id="txtDistrito" size="30" maxlength="30" value="<%=trim(strDistrito)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >DDD:</td>
                        <td><input style="width:350pt"  name="txtDDD" type="text" class="form-control" onKeyPress="return formataCampo(this,2,10)" id="txtDDD" size="3" maxlength="2" value="<%=trim(strDDD)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Telefone:</td>
                        <td><input style="width:350pt"  name="txtTelefone" type="text" onKeyPress="mascara(this,telefone)"  class="form-control" id="txtTelefone" size="15" maxlength="15" value="<%=trim(strTelefone)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Telefone Publico 1:</td>
                        <td><input style="width:350pt"  name="txtTelefone1" type="text" onKeyPress="mascara(this,telefone)"  class="form-control" id="txtTelefone1" size="15" maxlength="15" value="<%=trim(strTelefone1)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Outro Telefone:</td>
                        <td><input style="width:350pt"  name="txtOutroTelefone" type="text" onKeyPress="mascara(this,telefone)"  class="form-control" id="txtOutroTelefone" size="15" maxlength="15" value="<%=trim(strOutroTelefone)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >FAX:</td>
                        <td><input style="width:350pt"  name="txtFax" type="text" onKeyPress="mascara(this,telefone)"  class="form-control" id="txtFax" size="8" maxlength="15" value="<%=trim(strFax)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Email:</td>
                        <td><input style="width:350pt"  name="txtEmail" type="text" class="form-control" id="txtEmail" size="50" maxlength="50" value="<%=trim(strEmail)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Codigo Regional Ensino :</td>
                        <td><input style="width:350pt"  name="txtCodRegional" type="text" class="form-control" id="txtCodRegional" size="10" maxlength="10" value="<%=trim(strCodRegional)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Dependencia administrativa:</td>
                        <td>
                        <select name="cmbDependenciaAdminstrativa" id="cmbDependenciaAdminstrativa" class="form-control" style="width:350pt" >
                            <option value="0">Selecione...</option>
                            <option <%if strSituacaoFuncional = "1" then%> selected <%end if%> value="1">Federal</option>
                            <option <%if strSituacaoFuncional = "2" then%> selected <%end if%> value="2">Estadual</option>
                            <option <%if strSituacaoFuncional = "3" then%> selected <%end if%> value="3">Municipal</option>
                            <option <%if strSituacaoFuncional = "4" then%> selected <%end if%> value="4">Privada</option>
                        </select>                          </td>
                      </tr>
                      <tr>
                        <td height="25" >Localiza&ccedil;&atilde;o / Zona da Escola:</td>
                        <td>
                          <select name="cmbLocalizacaoZona" id="cmbLocalizacaoZona" class="form-control" style="width:350pt" >
                            <option value="0">Selecione...</option>
                            <option <%if strLocalizacaoZona = "1" then%> selected <%end if%> value="1">Urbana</option>
                            <option <%if strLocalizacaoZona = "2" then%> selected <%end if%> value="2">rural</option>
                          </select>                         </td>
                      </tr>
                      <tr>
                        <td height="25" >Categoria Escola:</td>
                        <td>
                          <select name="cmbCategoriaEscola" id="cmbCategoriaEscola" class="form-control" style="width:350pt" >
                            <option value="0">Selecione...</option>
                            <option <%if strLocalizacaoZona = "1" then%> selected <%end if%> value="1">Particular</option>
                            <option <%if strLocalizacaoZona = "2" then%> selected <%end if%> value="2">Comunit&aacute;ria</option>
                            <option <%if strLocalizacaoZona = "3" then%> selected <%end if%> value="3">Confessional</option>
                            <option <%if strLocalizacaoZona = "4" then%> selected <%end if%> value="4">Filantropia</option>
                          </select>
                          </td>
                      </tr>
                      <tr>
                        <td height="25" >Conveniada com poder publico:</td>
                        <td>
                          <select name="cmbConveniadaComPoderPublico" id="cmbConveniadaComPoderPublico" class="form-control" style="width:350pt" >
                            <option value="0">Selecione...</option>
                            <option <%if strLocalizacaoZona = "1" then%> selected <%end if%> value="1">Estadual</option>
                            <option <%if strLocalizacaoZona = "2" then%> selected <%end if%> value="2">Municipal</option>
                            <option <%if strLocalizacaoZona = "3" then%> selected <%end if%> value="3">Estadual e Municipal</option>
                          </select>
                          </td>
                      </tr>
                      <tr>
                        <td height="25" >Mantenedora da Escola privada:</td>
                        <td>
                          <select name="cmbConveniadaComPoderPublico2" id="cmbConveniadaComPoderPublico2" class="form-control" style="width:350pt" >
                            <option value="0">Selecione...</option>
                            <option <%if strLocalizacaoZona = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                            <option <%if strLocalizacaoZona = "1" then%> selected <%end if%> value="1">Sim</option>
                          </select> 
                          </td>
                      </tr>
                      <tr>
                        <td height="25" >Mantenedora 1:</td>
                        <td><input style="width:350pt"  name="txtMantenedora1" type="text" class="form-control" id="txtMantenedora1" size="50" maxlength="50" value="<%=trim(strMantenedora1)%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Mantenedora 2:</td>
                        <td>
                          <input style="width:350pt" name="txtMantenedora2" type="text" class="form-control" id="txtMantenedora2" size="50" maxlength="50" value="<%=trim(strMantenedora2)%>">            </td>
                      </tr>
                      <tr>
                        <td height="25" >Mantenedora 3:</td>
                        <td align="left" bordercolor="#CCCCCC"><input style="width:350pt"  name="txtMantenedora3" type="text" class="form-control" id="txtMantenedora3" size="50" maxlength="50" value="<%=trim(strMantenedora3)%>"></td>
                      </tr>
                      <tr>
                        <td height="25" >Mantenedora 4:</td>
                        <td>
                          <input style="width:350pt"  name="txtMantenedora4" type="text" class="form-control" id="txtMantenedora4" size="50" maxlength="50" value="<%=trim(strMantenedora4)%>"> </td>
                        </tr>
                      <tr>
                        <td height="25" >Sistema S:</td>
                        <td>
                          <select name="cmbSistemaS" id="cmbSistemaS" class="form-control" style="width:350pt" >
                            <option <%if strSistemaS = "Sisi" then%> selected <%end if%> value="Sisi">Sisi</option>
                            <option <%if strSistemaS = "Senai" then%> selected <%end if%> value="Senai">Senai</option>
                            <option <%if strSistemaS = "Sesc" then%> selected <%end if%> value="Sesc">Sesc</option>
                            <option <%if strSistemaS = "Outros" then%> selected <%end if%> value="Outros">Outros</option>
                          </select>                          </td>
                      </tr>
                      <tr>
                        <td height="25" >CNPJ 1:</td>
                        <td>
                          <input style="width:350pt"  name="txtCNPJ1" type="text" class="form-control" id="txtCNPJ1" size="15" maxlength="15" value="<%=trim(strCNPJ1)%>"></td>
                        </tr>
                      <tr>
                        <td height="25" >CNPJ 2:</td>
                        <td>
                          <input style="width:350pt"  name="txtCNPJ2" type="text" class="form-control" id="txtCNPJ2" size="15" maxlength="15" value="<%=trim(strCNPJ2)%>"></td>
                        </tr>
                      <tr>
                        <td height="25" >Regulamenta&ccedil;&atilde;o:</td>
                        <td>
                          <select name="cmbRegulamentacao" id="cmbRegulamentacao" class="form-control" style="width:350pt" >
                            <option value="0">Selecione...</option>
                            <option <%if strRegulamentacao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                            <option <%if strRegulamentacao = "1" then%> selected <%end if%> value="1">Sim</option>
                            <option <%if strRegulamentacao = "2" then%> selected <%end if%> value="2">Em Transi&ccedil;&atilde;o</option>
                          </select>                         </td>
                      </tr>
                      <tr>
                        <td colspan="2" >&nbsp;</td>
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
		frm.action="Registro00_cod.asp?acao=" + acao;
		frm.submit();
		return true;
		
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 