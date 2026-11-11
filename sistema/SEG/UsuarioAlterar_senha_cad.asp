<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<body>
    <!--include file="topo.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Seg - Alteração de Senha</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="../default.asp">Home</a></li>
                <li>Altera Senha</li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    
    <%
			strMostraBotaoCadastroPrincipal = "N"
			strUsuarioPortal	= session("usuarioWeb")
			
			if strUsuarioPortal <> "" then
			
				' Testando o login de aluno
				sql = " SELECT Usua_Codg, USUA_STAT, Usua_Info_Senha, Usua_data_alteracao_senha, "
				sql = sql & " Usua_data_hora_ult_logon_web, cod_empresa" 
				sql = sql & " FROM SEG_Usuarios_Sistema" 
				sql = sql & " Where Usua_Codg = '" & strUsuarioPortal & "'"
				RsAux.Open SQL, cnn
				if RsAux.EOF then
					%>
					<script>
						alert("Usuário Invalido, verifique!");
						window.location = 'default.asp';
					</script>
					<%
					response.end()
				end if
				RsAux.close
			
			end if
			
			if strUsuarioPortal <> "" then
								
				sql = " SELECT SEG_USUARIOS_SISTEMA.USUA_CODG, SEG_USUARIOS_SISTEMA.USUA_STAT, SEG_USUARIOS_SISTEMA.USUA_NOME_COMPLETO, "
				sql = sql & " SEG_USUARIOS_SISTEMA.USUA_CPF, SEG_USUARIOS_SISTEMA.USUA_TELEFONE, SEG_USUARIOS_SISTEMA.USUA_INFO_SENHA, "
				sql = sql & " SEG_USUARIOS_SISTEMA.USUA_EMAIL, SEG_USUARIOS_SISTEMA.USUA_DATA_ATIVACAO, SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO, "
				sql = sql & " SEG_USUARIOS_SISTEMA.COD_EMPRESA, SEG_USUARIOS_SISTEMA.USUA_DATA_HORA_ULT_LOGON_WEB, SEG_USUARIOS_SISTEMA.USUA_DATA_ALTERACAO_SENHA, "
				sql = sql & " SEG_DEPARTAMENTO.DESCRICAO AS DEPTO, SEG_EMPRESA.RAZAOSOCIAL "
				sql = sql & " FROM SEG_EMPRESA "
				sql = sql & " RIGHT JOIN (SEG_DEPARTAMENTO RIGHT JOIN SEG_USUARIOS_SISTEMA ON (SEG_DEPARTAMENTO.CODIGO = SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO) "
				sql = sql & " AND (SEG_DEPARTAMENTO.COD_EMPRESA = SEG_USUARIOS_SISTEMA.COD_EMPRESA)) ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_SISTEMA.COD_EMPRESA "
				sql = sql & " WHERE SEG_USUARIOS_SISTEMA.USUA_CODG = '" &  strUsuarioPortal & "'"
				rs.open sql, cnn
				
				if rs.eof = false then
				
					 
					strDesabilitaIncluir = "disabled" 'Desabilita o botão Alterar
					strDesabilitaAlterar = "" 'Desabilita o botão Alterar
					strDesabilitaExcluir = "disabled" 'Desabilita o botão Alterar
					strDesabilitaLimpar  = "disabled" 'Habilita o Botão Limpar
					strDesabilitaPrincipal  = "disabled" 'Desabilita o botão Principal
					strMostraBotaoPrincipal = "N"
					strMostraBotaoPrincipalAlterarSenha = "S"
						
					IntCodDepto					= Trim(rs("CODIGO_DEPARTAMENTO"))
					strDescDepto				= Trim(rs("DEPTO"))
					IntCodEmpresa				= Trim(rs("COD_EMPRESA"))
					strDescEmpresa				= Trim(rs("RAZAOSOCIAL"))
					strUsuarioPortal  			= Trim(rs("Usua_Codg"))
					'strSenha 					= Trim(rs("Usua_Info_senha"))
					strDataAtivacao 			= Trim(rs("Usua_Data_Ativacao"))
					strDataAlteracao 			= Trim(rs("USUA_DATA_ALTERACAO_SENHA"))
					strDataLogon	 			= Trim(rs("USUA_DATA_HORA_ULT_LOGON_WEB"))
					strStatus					= Trim(rs("Usua_Stat"))
					strNomeCompleto				= Trim(rs("USUA_NOME_COMPLETO"))
					strCPF						= Trim(rs("USUA_CPF"))
					strTelefone					= Trim(rs("USUA_TELEFONE"))
					strEmail					= Trim(rs("USUA_EMAIL"))
					
				else
					strDesabilitaIncluir = "disabled" 'Desabilita o botão Alterar
					strDesabilitaAlterar = "" 'Desabilita o botão Alterar
					strDesabilitaExcluir = "disabled" 'Desabilita o botão Alterar
					strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
					'strMostraBotaoPrincipal = true
					strDesabilitaPrincipal  = "disabled" 'Desabilita o botão Principal
					
					strSenha 					= ""
					IntCodDepto					= Trim(Request.Form("txtCodDepto"))
					strDescDepto				= Trim(Request.Form("txtDescDepto"))
					IntCodEmpresa				= Trim(Request.Form("txtCodEmpresa"))
					strDescEmpresa				= Trim(Request.Form("txtRazaoSocial"))
					strDataAtivacao 			= date & " " & time
					strDataAlteracao 			= ""
					strDataLogon	 			= ""
					strStatus					= ""
					strNomeCompleto				= ""
					strCPF						= ""
					strTelefone					= ""
					strEmail					= ""

				end if
			else
			
				
				strDesabilitaIncluir = "" 'Desabilita o botão Alterar
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Alterar
				strDesabilitaPrincipal = "" 'Desabilita o botão Principal
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
				'strMostraBotaoPrincipal = true
				
			end if
		%>		
        
    <!--=== Content Part ===-->
    <div class="container content">
    
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Alterar Senha</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                   <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurno%>" maxlength="10">
                    
                    <div class="form-group">
                        <label class="form-label">Usu&aacute;rio</label>
                        <input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="23" maxlength="30" readonly="true" >
                    </div>
                    <legend></legend>
                    
                    <div class="form-group">
                        <label class="form-label">Empresa</label>
                    	<input name="txtRazaoSocial" type="text" class="form-control" id="txtRazaoSocial" value="<%=strDescEmpresa%>"  size="23" maxlength="60" disabled>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Departamento</label>
                    	<input name="txtDescDepto" type="text" class="form-control" id="txtDescDepto" value="<%=strDescDepto%>"  size="23" maxlength="60" disabled>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">CPF</label>
                    	<input name="txtCPF" type="text" class="form-control" id="txtCPF" value="<%=strCPF%>" onKeyPress="return formataCampo(this,5,14)" size="23" maxlength="14" onBlur="return validaCPF(this)"  disabled>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Nome Completo</label>
                    	<input name="txtNomeCompleto" type="text" class="form-control" id="txtNomeCompleto" value="<%=strNomeCompleto%>"  size="23" maxlength="50" disabled>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Telefone</label>
                    	<input name="txtTelefone" class="form-control" type="text" id="txtTelefone" value="<%=strTelefone%>" size="23" maxlength="15" disabled> 
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Email</label>
                    	<input name="txtEmail" type="text" class="form-control" id="txtEmail" value="<%=strEmail%>"  size="23" maxlength="50" disabled>
                    </div>
                    
                    <div class="headline"><h2>Obs: A senha dever&aacute; ser informada com o m&iacute;nimo de 6 caracteres, caso contr&aacute;rio ser&aacute; expirada no pr&oacute;ximo login..</h2></div>
                    
                      <div class="form-group">
                        <label class="form-label">Nova Senha</label>
                    	<input name="txtSenha" type="password" class="form-control" id="txtSenha" value="<%=strSenha%>" size="15" maxlength="15" >
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Confirma Nova Senha</label>
                    	<input name="txtSenhaC" type="password" class="form-control" id="txtSenhaC" value="<%=strSenha%>" size="15" maxlength="15" >
                    </div>
                    
                    <%
					if strSistema = "SAU" then
						strDesabilitaIncluir="disabled"
					end if
					%>
                  
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>

  	
    </div>
    </div>
    <script>
			function salvar(acao){
			
			var frm = document.getElementById("frm");
			
			if (frm.txtUsuarioPortal.value == "") {
				alert("O Usuário PORTAL deve ser informado!");
				frm.txtUsuarioPortal.focus();
				return false;
			} 
	
			if (frm.txtSenha.value == "") {
				alert("Senha deve ser informada!");
				frm.txtSenha.focus();
				return false;
			} 
	
			if (frm.txtSenha.value != "") {
				if (frm.txtSenha.value.length < 6 ) {
					alert("A senha deve ter pelo menos 6 dígitos!");
					frm.txtSenha.value = "";
					frm.txtSenhaC.value = "";
					frm.txtSenha.focus();
					return false;
				}
				
				if (frm.txtSenha.value != frm.txtSenhaC.value) {
					alert("As senhas não conferem, tente novamente!");
					frm.txtSenha.value = "";
					frm.txtSenhaC.value = "";
					frm.txtSenha.focus();
					return false;
				}
			} 
	
			frm.action="UsuarioAlterar_senha_cod.asp?acao=" + acao;
			frm.submit();
			return true;	 
	}
	
	function limparUsuario(){
		//limpa os campos do formulário
		var form = window.document.forms[0]
		var urlForm
		urlForm = location.href; //retorna a url da página
		
		//limpa os parametros da url
		urlForm = urlForm.substring(0, urlForm.indexOf("?"));
		
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			
			if (form.elements[i].type == "checkbox"){
				form.elements[i].checked = false;			
			}	
			
			if (form.elements[i].type == "radio"){ //option button
				form.elements[i].value= "";			
			}	
			
			if (form.elements[i].type == "select-one") //combo
				form.elements[i].value=0;
			
			if (form.elements[i].type == "text") //text box
				form.elements[i].value="";
				
			if (form.elements[i].type == "hidden") //text box escondido
				form.elements[i].value="";				
			
			if (form.elements[i].type == "textarea")
				form.elements[i].value="";
		}
		
		form.action="UsuarioAlterar_senha_cod.asp?Sistema=SAU";
		form.submit();
		return true;	
	}	
	</script>
    <!--/container-->
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html>
