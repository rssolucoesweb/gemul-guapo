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
		strPaginaTitulo 								= "Cadatro de Profissional Escola em Sala de Aula - Registro 30"
		intCodEmpresa									= Trim(Request("CodEscola"))
		strTipoRegistro									= Trim(Request.Form("txtTipoRegistro"))
		strCodEscolaInep	 							= Trim(Request.Form("txtCodEscolaInep"))
		strCodINEP										= Trim(Request.Form("txtCodINEP"))
		strCodProfissionalEscola						= Trim(Request.Form("txtCodProfissionalEscola"))
		strNomeCompleto									= Trim(Request.Form("txtNomeCompleto"))
		strEmail										= Trim(Request.Form("txtEmail"))
		strNumeroIndentificacaoSocialNIS				= Trim(Request.Form("txtNumeroIndentificacaoSocialNIS"))
		strDataNascimento								= Trim(Request.Form("txtDataNascimento"))
		strSexo											= Trim(Request.Form("cmbSexo"))
		strCorRoca										= Trim(Request.Form("cmbCorRoca"))
		strNomeCompletoMae								= Trim(Request.Form("txtNomeCompletoMae"))
		strNacionalidadeProfissionalSalaAula			= Trim(Request.Form("cmbNacionalidadeProfissionalSalaAula"))
		strPaisOrigem									= Trim(Request.Form("txtPaisOrigem"))
		strUFNascimento									= Trim(Request.Form("txtUFNascimento"))
		strMunicipioNascimento							= Trim(Request.Form("txtMunicipioNascimento"))
		strProfissionalDeficiencia						= Trim(Request.Form("cmbProfissionalDeficiencia"))
		strCegueira										= Trim(Request.Form("cmbCegueira"))
		strBaixaVisao									= Trim(Request.Form("cmbBaixaVisao"))
		strSurdez										= Trim(Request.Form("cmbSurdez"))
		strAuditiva										= Trim(Request.Form("cmbAuditiva"))
		strSurdocegueira								= Trim(Request.Form("cmbSurdocegueira"))
		strDeficienciaFisica							= Trim(Request.Form("cmbDeficienciaFisica"))
		strDeficienciaIntelectual						= Trim(Request.Form("cmbDeficienciaIntelectual"))
		strDeficienciaMultipla							= Trim(Request.Form("cmbDeficienciaMultipla"))
		
		if trim(intCodEmpresa) <> "" then
			 
			sql = "SELECT CodEmpresa, TipoRegistro, CodEscolaInep, CodINEP, CodProfissionalEscola, NomeCompleto, Email, "
			sql = sql & " NumeroIndentificacaoSocialNIS, DataNascimento, Sexo, CorRoca, "
			sql = sql & " NomeCompletoMae, NacionalidadeProfissionalSalaAula, PaisOrigem, UFNascimento, MunicipioNascimento, ProfissionalDeficiencia, Cegueira, BaixaVisao, "
			sql = sql & " Surdez, Auditiva, Surdocegueira, DeficienciaFisica, DeficienciaIntelectual, DeficienciaMultipla, Surdez "
			sql = sql & " FROM REGISTRO30"
			sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
			rs.open sql, cnn
		
			if rs.eof = false then
			
				intCodEmpresa									= rs("CodEmpresa")
				strTipoRegistro									= rs("TipoRegistro")
				strCodEscolaInep	 							= trim(rs("CodEscolaInep"))
				strCodINEP										= rs("CodINEP")
				strCodProfissionalEscola						= rs("CodProfissionalEscola")
				strNomeCompleto									= rs("NomeCompleto")
				strEmail										= rs("Email")
				strNumeroIndentificacaoSocialNIS				= rs("NumeroIndentificacaoSocialNIS")
				strDataNascimento								= rs("DataNascimento")
				strSexo											= rs("Sexo")
				strCorRoca										= rs("CorRoca")
				strNomeCompletoMae								= rs("NomeCompletoMae")
				strNacionalidadeProfissionalSalaAula			= rs("NacionalidadeProfissionalSalaAula")
				strPaisOrigem									= rs("PaisOrigem")
				strUFNascimento									= rs("UFNascimento")
				strMunicipioNascimento							= rs("MunicipioNascimento")
				strProfissionalDeficiencia						= rs("ProfissionalDeficiencia")
				strCegueira										= rs("Cegueira")
				strBaixaVisao									= rs("BaixaVisao")
				strSurdez										= rs("Surdez")
				strAuditiva										= trim(rs("Auditiva"))
				strSurdocegueira								= trim(rs("Surdocegueira"))
				strDeficienciaFisica							= trim(rs("DeficienciaFisica"))
				strDeficienciaIntelectual						= trim(rs("DeficienciaIntelectual"))
				strDeficienciaMultipla							= trim(rs("DeficienciaMultipla"))
				
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadatro de Profissional Escola em Sala de Aula - Registro 30</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
  					 <table width="98%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="98%" align="center" class="tituloSistema"><%=strPaginaTitulo%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="25" class="texto1">Empresa:</td>
            <td><input style="width:100pt" name="txtCodEmpresa" type="text" class="form-control"  id="txtCodEmpresa" size="8" maxlength="8" value="<%=trim(intCodEmpresa)%>"></td>
          </tr>
          <tr>
            <td width="558" height="25" class="texto1">Tipo de Registro</td>
            <td width="659"><input style="width:100pt" name="txtTipoRegistro" type="text" class="form-control"  id="txtTipoRegistro" size="2" maxlength="5" value="<%=trim(strTipoRegistro)%>">            </td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo da Escola - INEP</td>
            <td><input style="width:100pt" name="txtCodEscolaInep" type="text" class="form-control"  onKeyPress="return formataCampo(this,2,10)" id="txtCodEscolaInep" size="8" maxlength="8" value="<%=trim(strCodEscolaInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Indentifica&ccedil;&atilde;o &Uacute;nica do Profissional escola em sala de Aula (INEP)</td>
            <td><input style="width:100pt" name="txtCodINEP" type="text" class="form-control"  id="txtCodINEP" size="8" maxlength="8" value="<%=trim(strCodINEP)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Profissional escolar em sala de Aula na Entidade/Escola</td>
            <td><input style="width:100pt" name="txtCodProfissionalEscola" type="text" class="form-control"  onKeyPress="return formataCampo(this,2,10)"  id="txtCodProfissionalEscola" size="8" maxlength="8" value="<%=trim(strCodProfissionalEscola)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">              Nome Completo</td>
            <td><input style="width:100pt" name="txtNomeCompleto" type="text" class="form-control"  id="txtNomeCompleto" size="50" maxlength="50" value="<%=trim(strNomeCompleto)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">E-mail</td>
            <td><input style="width:100pt" name="txtEmail" type="text" class="form-control"  id="txtEmail" size="50" maxlength="50" value="<%=trim(strEmail)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">N&uacute;mero de Indentifica&ccedil;&atilde;o Social(NIS)</td>
            <td><input style="width:100pt" name="txtNumeroIndentificacaoSocialNIS" type="text" class="form-control"  id="txtNumeroIndentificacaoSocialNIS" size="8" maxlength="8" value="<%=trim(strNumeroIndentificacaoSocialNIS)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Data de Nascimento</td>
            <td><input style="width:100pt" name="txtDataNascimento" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)"  id="txtDataNascimento" size="8" maxlength="10" value="<%=trim(strDataNascimento)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Sexo</td>
            <td><select name="cmbSexo" id="cmbSexo" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSexo = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSexo = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Cor/Ro&ccedil;a</td>
            <td><select name="cmbCorRoca" id="cmbCorRoca" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCorRoca = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCorRoca = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nome Completo da M&atilde;e</td>
            <td><input style="width:100pt" name="txtNomeCompletoMae" type="text" class="form-control"  id="txtNomeCompletoMae" size="50" maxlength="50" value="<%=trim(strNomeCompletoMae)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nacionalidade do Profissional Escola em Sala de Aula</td>
            <td><select name="cmbNacionalidadeProfissionalSalaAula" id="cmbNacionalidadeProfissionalSalaAula" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strNacionalidadeProfissionalSalaAula = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strNacionalidadeProfissionalSalaAula = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Pa&iacute;s de Origem</td>
            <td><input style="width:100pt" name="txtPaisOrigem" type="text" class="form-control"  id="txtPaisOrigem" size="50" maxlength="50" value="<%=trim(strPaisOrigem)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">UF de nascimento</td>
            <td><input style="width:100pt" name="txtUFNascimento" type="text" class="form-control"  id="txtUFNascimento" size="8" maxlength="8" value="<%=trim(strUFNascimento)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Munic&iacute;pio de nascimento</td>
            <td><input style="width:100pt" name="txtMunicipioNascimento" type="text" class="form-control"  id="txtMunicipioNascimento" size="50" maxlength="50" value="<%=trim(strMunicipioNascimento)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Profissional escolar em sala de Aula com defici&ecirc;ncia</td>
            <td><select name="cmbProfissionalDeficiencia" id="cmbProfissionalDeficiencia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strProfissionalDeficiencia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strProfissionalDeficiencia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia - Cegueira</td>
            <td><select name="cmbCegueira" id="cmbCegueira" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCegueira = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCegueira = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia - Baixa Vis&atilde;o</td>
            <td><select name="cmbBaixaVisao" id="cmbBaixaVisao" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strBaixaVisao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strBaixaVisao = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia - Surdez</td>
            <td><select name="cmbSurdez" id="cmbSurdez" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSurdez = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSurdez = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia - defici&ecirc;ncia auditiva</td>
            <td><select name="cmbAuditiva" id="cmbAuditiva" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAuditiva = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAuditiva = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia - Surdocegueira</td>
            <td><select name="cmbSurdocegueira" id="cmbSurdocegueira" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSurdocegueira = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSurdocegueira = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia - defici&ecirc;ncia F&iacute;sica</td>
            <td><select name="cmbDeficienciaFisica" id="cmbDeficienciaFisica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDeficienciaFisica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDeficienciaFisica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia - defici&ecirc;ncia Intelectual</td>
            <td><select name="cmbDeficienciaIntelectual" id="cmbDeficienciaIntelectual" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDeficienciaIntelectual = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDeficienciaIntelectual = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia - defici&ecirc;ncia M&uacute;ltipla</td>
            <td><select name="cmbDeficienciaMultipla" id="cmbDeficienciaMultipla" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDeficienciaMultipla = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDeficienciaMultipla = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="#CCCCCC" class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
            </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
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
		frm.action="Registro30_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 