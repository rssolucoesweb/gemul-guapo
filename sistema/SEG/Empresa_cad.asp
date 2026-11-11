<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCnpj.asp"-->
<!--#include file="../menuModulos.asp"-->  
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../SRH/json/jquery-1.7.1/jquery-1.7.1.min.js"></script> <!--para o busca cep -->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Seguran&ccedil;a</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%	
		strExecutarSubmitGrupo			= "S"	
		strSimouNao_submit	 			= "N"
		
		strPagina						= "Empresa_cad.asp"
		strCodigo 						= Trim(Request("txtCodEmpresa"))
		strCNPJ  						= Trim(Request.Form("txtCNPJ"))
		intCodGrupo 					= Trim(Request.Form("cmdGrupo"))
		strRazaoSocial 					= Trim(Request.Form("txtRazaoSocial"))
		strMantenedora 					= Trim(Request.Form("txtMantenedora"))
		strAutorizacao 					= Trim(Request.Form("txtAutorizacao"))
		strDiretor						= Trim(Request.Form("txtDiretor"))
		strSecretaria					= Trim(Request.Form("txtSecretaria"))
		strContato						= Trim(Request.Form("txtContato"))
		strContato1						= Trim(Request.Form("txtContato1"))
		strContato2						= Trim(Request.Form("txtContato2"))
		strEndereco						= Trim(Request.Form("txtEndereco"))
		strBairro						= Trim(Request.Form("txtBairro"))
		strMunicipio					= Trim(Request.Form("txtMunicipio"))
		strUF							= Trim(Request.Form("txtUF"))
		strCep							= Trim(Request.Form("txtCep"))
		strTelefone						= Trim(Request.Form("txtTelefone"))
		stremail						= Trim(Request.Form("txtemail"))
		stremailDiretoria				= Trim(Request.Form("txtemailDiretoria"))
		stremailFinanceiro				= Trim(Request.Form("txtemailFinanceiro"))
		stremailModulacao				= Trim(Request.Form("txtemailModulacao"))
		stremailLogins					= Trim(Request.Form("txtemailLogins"))
		strSimouNao						= Trim(Request.Form("cmbSimouNao"))
		strSimouNaoDadosCadastrais		= Trim(Request.Form("cmbSimouNaoDadosCadastrais"))
		strNotificacao					= Trim(Request.Form("txtNotificacao"))
		strCodigoCenso					= Trim(Request.Form("txtCodigoCenso"))
		strCodigoSetransp				= Trim(Request.Form("txtCodigoSetransp"))
		strNumeroSalaAula				= Trim(Request.Form("txtNumeroSalaAula"))
		strSimouNaoPersonalizarSistema	= Trim(Request.Form("cmbSimouNaoPersonalizarSistema"))
		
		if intCodGrupo = "" then intCodGrupo = 0

		if strCodigo <> "" then
			
			sql = "SELECT * "
			sql = sql & " FROM SEG_EMPRESA"
			sql = sql & " WHERE CODIGO = " & strCodigo
			
			rs.open sql, cnn
			if rs.eof = false then
				strCodigo  					= Trim(RS("CODIGO"))
				strCNPJ  					= Trim(RS("Cnpj"))
				strRazaoSocial 				= Trim(RS("RazaoSocial"))
				strMantenedora 				= Trim(RS("Mantenedora"))
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
 			    intCodGrupo					= Trim(RS("COD_GRUPO"))	
				stremail					= Trim(RS("EMAIL"))	
				stremailDiretoria			= Trim(RS("EMAIL_DIRETORIA"))
				stremailFinanceiro			= Trim(RS("EMAIL_FINANCEIRO"))
				stremailModulacao			= Trim(RS("EMAIL_MODULACAO"))
				stremailLogins				= Trim(RS("EMAIL_LOGINS"))
				strSimouNao					= Trim(RS("BLOQUEIO"))
				strSimouNaoDadosCadastrais	= Trim(RS("COMPARTILHAR_DADOS"))
				strNotificacao				= Trim(RS("NOTIFICACAO"))
				intCodTipoEmpresa			= Trim(RS("codTipoEmpresa"))
				strCodigoCenso					= Trim(RS("CODIGO_CENSO"))
				strCodigoSetransp				= Trim(RS("CODIGO_SETRANSP"))
				strNumeroSalaAula				= Trim(RS("TOTAL_SALAS_AULAS"))
				strSimouNaoPersonalizarSistema	= Trim(RS("PERSONALIZAR_SISTEMA"))
				
				strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
				strDesabilitaAlterar = "" 'Habilita o botão Alterar'
				strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
				
			else
			
			    if Session("UsuarioMaster") = "S" then
				   strDesabilitaIncluir = ""'Desabilita o botão Incluir
				else   
				   strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
				end if  
				 
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
				
			end if 
			rs.close
		else
			
			if Session("UsuarioMaster") = "S" then
			   strDesabilitaIncluir = ""'Desabilita o botão Incluir
			else   
			   strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
			end if   
			
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
		if Session("UsuarioMaster") <> "S" then
		   bloqueiaAcessoAlteracao = "readonly"
		   bloqueiaComboAlteracao = "disabled"
		end if   
		
		%>
      <!--=== Content Part ===-->
      <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Empresa</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                     <input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa" class="form-control" size="10" value="<%=strCodigo%>" maxlength="10">
                    <div class="form-group">
                        <label class="form-label">Grupo</label>
                         <!--#include file="../includes/inc_cmdGrupo.asp"-->
                    </div>
         
                    <div class="form-group">
                        <label class="form-label">CNPJ</label>
                         <input <%=bloqueiaAcessoAlteracao%>  name="txtCNPJ" type="text" class="form-control" id="txtCNPJ" onkeypress="return FormataCNPJ(this, 18)" value="<%=formataCnpjAP(strCNPJ)%>" style="width:200pt" size="20" maxlength="18">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label"> Raz&atilde;o Social</label>
                        <input <%=bloqueiaAcessoAlteracao%> name="txtRazaoSocial" type="text" class="form-control" id="txtRazaoSocial" value="<%=strRazaoSocial%>" size="60" maxlength="50" style="width:300pt">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Mantenedora</label>
                        <input <%=bloqueiaAcessoAlteracao%> name="txtMantenedora" type="text" class="form-control" id="txtMantenedora" value="<%=strMantenedora%>" size="60" maxlength="50" style="width:300pt">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Autoriza&ccedil;&atilde;o:</label>
                        <input name="txtAutorizacao" type="text" class="form-control" id="txtAutorizacao" value="<%=strAutorizacao%>" size="60" maxlength="50" style="width:300pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Diretor(a):</label>
                        <input name="txtDiretor" type="text" class="form-control" id="txtDiretor" value="<%=strDiretor%>" size="60" maxlength="50" style="width:300pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Secretario(a)</label>
                        <input name="txtSecretaria" type="text" class="form-control" id="txtSecretaria" value="<%=strSecretaria%>" size="60" maxlength="50" style="width:300pt">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Contato</label>
                        <input name="txtContato1" type="text" class="form-control" id="txtContato1" value="<%=strContato1%>" size="60" maxlength="50" style="width:300pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Contato 1</label>
                        <input name="txtContato2" type="text" class="form-control" id="txtContato2" value="<%=strContato2%>" size="60" maxlength="50" style="width:300pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Telefone Unidade:</label>
                        <input name="txtTelefone" type="text" class="form-control" id="txtTelefone" onkeypress="mascara(this,telefone)" value="<%=strTelefone%>" size="20" maxlength="14" style="width:100pt">
                    </div>
                    
					<div class="form-group">
                        <label class="form-label">Cep:</label>
                        <input name="txtCep" type="text" class="form-control" id="txtCep" onkeypress="mascara(this,cep)" size="10" maxlength="10" value="<%=strCep%>" style="width:100pt">
                    </div>
					
                    <div class="form-group">
                        <label class="form-label">Endere&ccedil;o:</label>
                        <input name="txtEndereco" type="text" class="form-control" id="txtEndereco" value="<%=strEndereco%>" size="60" maxlength="50" style="width:500pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Bairro:</label>
                        <input name="txtBairro" type="text" class="form-control" id="txtBairro" value="<%=strBairro%>" size="40" maxlength="30" style="width:300pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Munic&iacute;pio:</label>
                        <input name="txtMunicipio" type="text" class="form-control" id="txtMunicipio" value="<%=strMunicipio%>" size="60" maxlength="50" style="width:300pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Estado</label>
                        <input name="txtUF" type="text" class="form-control" id="txtUF" size="3" maxlength="2" value="<%=strUF%>" onkeypress="return formataCampo(this, 1, 2)" style="width:50pt">
                    </div>
                     
                    <div class="form-group">
                        <label class="form-label">Avisos:</label>
                        <input <%=bloqueiaAcessoAlteracao%> name="txtNotificacao" type="text" class="form-control" id="txtNotificacao" size="120" maxlength="120" value="<%=strNotificacao%>" style="width:300pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Avisos:</label>
                        <input <%=bloqueiaAcessoAlteracao%> name="txtNotificacao" type="text" class="form-control" id="txtNotificacao" size="120" maxlength="120" value="<%=strNotificacao%>" style="width:300pt">
                    </div>
                           
                    <div class="form-group">
                        <label class="form-label">Compartilhar Dados Cadastrais</label>
                        <select <%=bloqueiaComboAlteracao%> name="cmbSimouNaoDadosCadastrais" class="form-control" id="cmbSimouNaoDadosCadastrais"  style="width:130pt">
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strSimouNaoDadosCadastrais = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if strSimouNaoDadosCadastrais = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                  <div class="form-group">
                    <label class="form-label">Tipo Unidade</label>
                        <!--#include file="../includes/inc_cmbTipoEmpresa.asp"-->
                    </div>
                    <div class="form-group">
                        <label class="form-label">Bloquear Unidade?</label>
                        <!--#include file="../includes/inc_cmbSimouNao.asp"-->
                    </div>
                    
                    <div class="headline"><h2>NOTIFICA&Ccedil;&Otilde;ES</h2></div>
                  
                    <div class="col-md-16">
                        <label class="form-label">Email 01:</label>
                        <input name="txtemailDiretoria" type="text" class="form-control" id="txtemailDiretoria" size="40" maxlength="70" value="<%=stremailDiretoria%>" style="width:300pt"> - Diretoria Geral
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Email 02:</label>
                        <input name="txtemailFinanceiro" type="text" class="form-control" id="txtemailFinanceiro" size="40" maxlength="70" value="<%=stremailFinanceiro%>" style="width:300pt">  - Diretoria Financeira
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Email 03:</label>
                        <input name="txtemail" type="text" class="form-control" id="txtemail" size="40" maxlength="70" value="<%=stremail%>" style="width:300pt">- Secretaria Acad&ecirc;mica 
                    </div>
                    
                    
                     <div class="form-group">
                        <label class="form-label">Email 04:</label>
                        <input name="txtemailModulacao" type="text" class="form-control" id="txtemailModulacao" size="40" maxlength="70" value="<%=stremailModulacao%>" style="width:300pt">  - Modula&ccedil;&atilde;o RH
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Email 05:</label>
                        <input name="txtemailLogins" type="text" class="form-control" id="txtemailLogins" size="40" maxlength="70" value="<%=stremailLogins%>" style="width:300pt">  - Acompanhamento de Login
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">C&oacute;digo Inep:</label>
                        <input name="txtCodigoCenso" type="text" class="form-control" id="txtCodigoCenso" onkeypress="return formataCampo(this,2,8)" size="10" maxlength="10" value="<%=strCodigoCenso%>" style="width:100pt">
                    </div>
                  
                    <div class="form-group">
                        <label class="form-label">C&oacute;digo Setransp:</label>
                        <input name="txtCodigoSetransp" type="text" class="form-control" id="txtCodigoSetransp" onkeypress="return formataCampo(this,2,8)" size="10" maxlength="10" value="<%=strCodigoSetransp%>" style="width:100pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">N&uacute;mero de Salas:</label>
                        <input name="txtNumeroSalaAula" type="text" class="form-control" id="txtNumeroSalaAula" onkeypress="return formataCampo(this,2,4)" size="4" maxlength="4" value="<%=strNumeroSalaAula%>" style="width:100pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Personalizar Sistema:</label>
                        <select <%=bloqueiaComboAlteracao%> name="cmbSimouNaoPersonalizarSistema" class="form-control" id="cmbSimouNaoPersonalizarSistema"  style="width:130pt">
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strSimouNaoPersonalizarSistema = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if strSimouNaoPersonalizarSistema = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <%if intCodGrupo <> 0 then %>
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Empresas</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th width="3%" bgcolor="#95A5A6">#</th>
                            <th width="39%" bgcolor="#95A5A6">CNPJ</th>
                            <th width="52%" bgcolor="#95A5A6">Raz&atilde;o Social</th>
                            <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                        </tr>
                    </thead>
                    <%
                    
                    sql = "SELECT SEG_EMPRESA.Codigo, Cnpj, RazaoSocial, LOGOMARCA, SEG_GRUPO.DESCRICAO AS GRUPO, LogoConvenio, COD_GRUPO"
                    sql = sql & " FROM SEG_EMPRESA "  
                    sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
                    sql = sql & " WHERE  1=1" 
                    sql = sql & "and SEG_EMPRESA.COD_GRUPO = " & intCodGrupo
                    sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RazaoSocial"
                    rs.open sql, cnn
    
                    cont=0
                    if rs.eof = false then
                    
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
                    <tbody>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=formataCnpjAP(rs("Cnpj"))%></td>
                            <td align="left">&nbsp;<%=trim(rs("RazaoSocial"))%></td>
                          <td align="center" >
                            <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>  
                        </tr>
                    </tbody>
                    <%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
                </table>
            </div>                      
        </div>
         <%end if%>
        <!--End Table Bordered-->	
<!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	
    function AbreLogoConvenio(Codigo){
		window.open("EmpresaLogoConvenio_cad.asp?txtCodEmpresa=" + Codigo, "consulta6", "top=0,left=0,height=580,width=750,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
 	}
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.action="Empresa_cad.asp?txtCodEmpresa="+intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if (frm.cmdGrupo.value == "0") {
			alert("O Grupo deve ser informado!");
			frm.cmdGrupo.focus();
			return false;
		} 

		if (frm.txtCNPJ.value == "") {
			alert("O CNPJ deve ser informado!");
			frm.txtCNPJ.focus();
			return false;
		} 
		
		if (frm.txtRazaoSocial.value == "") {
			alert("A Razão Social deve ser informada!");
			frm.txtRazaoSocial.focus();
			return false;
		} 

		if (frm.txtMantenedora.value == "") {
			alert("A Mantenedora deve ser informada!");
			frm.txtMantenedora.focus();
			return false;
		} 

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
		
		frm.action="Empresa_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 

	}
	
	$(document).ready(function () {
		 $("#txtCep").on("blur", function () {
			var cep = $(this).val();
			if (cep != ""){
				obterEndercoPorCEP(cep);			
			}
		});
	});
	
	var obterEndercoPorCEP = function (numeroCEP) {
		$("#txtEndereco").val("");
		$("#txtBairro").val("");
		$("#txtUF").val("");
		$("#txtMunicipio").val("");

		var cep = numeroCEP.replace("-", "");
		var url = "https://viacep.com.br/ws/" + cep + "/json/";

		$.getJSON(url, cep)
		 .done(function (endereco) {
			 if (endereco != null) {
				 $("#txtEndereco").val($.trim(endereco.logradouro));
				 $("#txtBairro").val(endereco.bairro);
				 $("#txtUF").val(endereco.uf);
				 $("#txtMunicipio").val(endereco.localidade);
			 }
		 });
	};
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 