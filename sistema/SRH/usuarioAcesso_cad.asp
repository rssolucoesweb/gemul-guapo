<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"--> 
  <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo RH</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
<%
	strExecutarSubmitEmpresa	= "SIM"
    strUsuarioPortal			= ucase(Trim(Request.Form("txtUsuarioPortal")))
    intCodEmpresa				= Trim(Request.Form("cmdEmpresa"))
	intCodDepartamento			= Trim(Request.Form("cmbDepartamento"))

    if strUsuarioPortal <> "" then
                        
        sql = " SELECT SEG_USUARIOS_SISTEMA.USUA_CODG, SEG_USUARIOS_SISTEMA.usuario_Master, "
        sql = sql & " SEG_USUARIOS_SISTEMA.GESTOR_FINANCEIRO, SEG_USUARIOS_SISTEMA.GESTOR_SUPORTE, "
        sql = sql & " SEG_USUARIOS_SISTEMA.GESTOR_MANUTENCAO, "
        sql = sql & " SEG_USUARIOS_SISTEMA.USUA_STAT, SEG_USUARIOS_SISTEMA.USUA_NOME_COMPLETO, "
        sql = sql & " SEG_USUARIOS_SISTEMA.USUA_CPF, SEG_USUARIOS_SISTEMA.USUA_TELEFONE, "
        sql = sql & " SEG_USUARIOS_SISTEMA.USUA_INFO_SENHA, SEG_USUARIOS_SISTEMA.USUA_EMAIL, "
        sql = sql & " SEG_USUARIOS_SISTEMA.USUA_DATA_ATIVACAO, SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO," 
        sql = sql & " SEG_USUARIOS_SISTEMA.COD_EMPRESA, SEG_USUARIOS_SISTEMA.USUA_DATA_HORA_ULT_LOGON_WEB," 
        sql = sql & " SEG_USUARIOS_SISTEMA.USUA_DATA_ALTERACAO_SENHA, SEG_DEPARTAMENTO.DESCRICAO AS DEPTO, "
        sql = sql & " SEG_EMPRESA.RAZAOSOCIAL "
        sql = sql & " FROM SEG_EMPRESA RIGHT JOIN (SEG_DEPARTAMENTO RIGHT JOIN SEG_USUARIOS_SISTEMA ON (SEG_DEPARTAMENTO.CODIGO = SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO) AND (SEG_DEPARTAMENTO.COD_EMPRESA = SEG_USUARIOS_SISTEMA.COD_EMPRESA)) ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_SISTEMA.COD_EMPRESA "
        sql = sql & " WHERE SEG_USUARIOS_SISTEMA.USUA_CODG = '" &  strUsuarioPortal & "'"
        rs.open sql, cnn
        
        if rs.eof = false then
        
            strDesabilitaIncluir = "disabled"'Desabilita o bot?o Incluir
            strDesabilitaAlterar = "" 'Desabilita o bot?o Alterar
            strDesabilitaLimpar  = "" 'Habilita o Bot?o Limpar
                
            intCodEmpresa				= Trim(rs("COD_EMPRESA"))
           	intCodDepartamento			= Trim(rs("CODIGO_DEPARTAMENTO"))

            strUsuarioPortal  			= Trim(rs("Usua_Codg"))
            strSenha 					= Trim(rs("Usua_Info_senha"))
            strDataAtivacao 			= Trim(rs("Usua_Data_Ativacao"))
            strDataAlteracao 			= Trim(rs("USUA_DATA_ALTERACAO_SENHA"))
            strDataLogon	 			= Trim(rs("USUA_DATA_HORA_ULT_LOGON_WEB"))
            strSituacao					= Trim(rs("Usua_Stat"))
            strNomeCompleto				= Trim(rs("USUA_NOME_COMPLETO"))
            strCPF						= Trim(rs("USUA_CPF"))
            strTelefone					= Trim(rs("USUA_TELEFONE"))
            strEmail					= Trim(rs("USUA_EMAIL"))
            
            usuarioMaster				= Trim(rs("usuario_Master"))
            GestorSuporte				= Trim(rs("GESTOR_SUPORTE"))
            GestorManutencao			= Trim(rs("GESTOR_MANUTENCAO"))
            GestorFinanceiro			= Trim(rs("GESTOR_FINANCEIRO"))
	
        else
            strDesabilitaIncluir = "" 'Desabilita o bot?o Alterar
            strDesabilitaAlterar = "disabled" 'Desabilita o bot?o Alterar
            strDesabilitaExcluir = "disabled" 'Desabilita o bot?o Alterar
            strDesabilitaLimpar  = "" 'Habilita o Bot?o Limpar

        end if
		rs.close
    else
    
        
        strDesabilitaIncluir = "" 'Desabilita o bot?o Alterar
        strDesabilitaAlterar = "disabled" 'Desabilita o bot?o Alterar
        strDesabilitaExcluir = "disabled" 'Desabilita o bot?o Alterar
        strDesabilitaLimpar  = "" 'Habilita o Bot?o Limpar
        
    end if
	
	if IntCodEmpresa = "" then IntCodEmpresa = 0
	if intCodDepartamento = "" then intCodDepartamento = 0
	%>
    <!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->     

                <form id="frm" class="sky-form  panel-body0" method="post">
                	
                    <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
                    
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Usu&aacute;rio para acesso ao sistema</font></div>

					<fieldset>
						<div class="row">
							 <section class="col col-2">
								<label class="form-label">Usu&aacute;rio (login)</label>
							  
								<label class="input">
									 <input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30" onblur="submit()">
								</label>
							 </section>
							 <section class="col col-10">
								<label class="form-label">Pesquisar</label>
							  
								<label class="input">
									 <button class="btn-u btn-u-sea" onclick="return abreConsulta('Usuario_con.asp')" type="button"><i class="fa fa-search"></i></button>  
								</label>
							 </section>
						</div>
						
						<div class="row">
							<section class="col col-12">
								<label class="label">Unidade</label>
								<label class="input">
									<!--#include file="../includes/inc_cmdEmpresa.asp"-->
								</label>

							</section>
						</div>
					
					
						<div class="row">
							 <section class="col col-4">
								<label class="label">Nome Completo</label>
							  
								<label class="input">
									 <input name="txtNomeCompleto" type="text" class="form-control" id="txtNomeCompleto" value="<%=strNomeCompleto%>" size="30" maxlength="30">
								</label>
							 </section>
							 <section class="col col-2">
								<label class="label">CPF</label>
							  
								<label class="input">
									 <input name="txtCPF" type="text" class="form-control" id="txtCPF" value="<%=strCPF%>" size="30" maxlength="30">
								</label>
							 </section>
							 
							 <section class="col col-2">
								<label class="label">Telefone</label>
							  
								<label class="input">
									 <input name="txtTelefone" type="text" class="form-control" id="txtTelefone" value="<%=strTelefone%>" size="30" maxlength="30">
								</label>
							 </section>
							 <section class="col col-4">
								<label class="label">Email</label>
							  
								<label class="input">
									 <input name="txtEmail" type="text" class="form-control" id="txtEmail" value="<%=strEmail%>" size="30" maxlength="30">
								</label>
							 </section>
						</div>

						<div class="row">
							 <section class="col col-3">
								<label class="label">Senha</label>
							  
								<label class="input">
									 <input name="txtSenha" type="text" class="form-control" id="txtSenha" value="<%=strSenha%>" size="30" maxlength="30">
								</label>
							 </section>
							 <section class="col col-3">
								<label class="label">Confirma Senha</label>
							  
								<label class="input">
									 <input name="txtSenhaC" type="text" class="form-control" id="txtSenhaC" value="<%=strSenhaC%>" size="30" maxlength="30">
								</label>
							 </section>
							 <section class="col col-6">
								<label class="label">Situação</label>
							  
								<label class="input">
									 <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:130pt">
									  <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
									  <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
									  <option value="B" <%if strSituacao = "B" then response.Write("selected") %>>Bloqueado</option>
									</select>
								</label>
							</section>
						</div>
						<div class="row">
							 <section class="col col-2">
								<label class="label">Data Ativa&ccedil;&atilde;o</label>
							  
								<label class="input">
									 <input disabled="disabled" name="txtDataAtivacao" type="text" class="form-control" id="txtDataAtivacao" value="<%=strDataAtivacao%>" size="30" maxlength="30">
								</label>
							 </section>
							 <section class="col col-2">
								<label class="label">Data Altera&ccedil;&atilde;o Senha</label>
							  
								<label class="input">
									 <input disabled="disabled" name="txtDataAlteracao" type="text" class="form-control" id="txtDataAlteracao" value="<%=strDataAlteracao%>" size="30" maxlength="30">
								</label>
							 </section>
							 <section class="col col-2">
								<label class="label">Data Ultimo Acesso</label>
							  
								<label class="input">
									 <input disabled="disabled" name="txtDataLogon" type="text" class="form-control" id="txtDataLogon" value="<%=strDataLogon%>" size="30" maxlength="30">
								</label>
							</section>
							<section class="col col-6">
								<label class="label"></label>
							  
								<label class="input">
								</label>
							</section>
						</div>
						<div class="row">
							<section class="col col-12">
								<label class="label">Perfil de acesso</label>
							  
								<label>
									 <!--#include file="../includes/inc_cmdPerfilGrupo.asp" -->
								</label>
							</section>
							
						</div>
						
					</fieldset>  
					
					<legend></legend>
					
					<!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</form>
            	<!-- End Responsive Grid System -->
            </div>
            <!-- End Content -->
            
        </div>          
    </div><!--/container-->     
    <!--=== End Content Part ===-->

</div><!--/End Wrapepr-->		
    <script>
	
	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function salvar(acao){
		
		if (frm.txtUsuarioPortal.value == "") {
			alert("O Usuário deve ser informado!");
			frm.txtUsuarioPortal.focus();
			return false;
		} 
		
		if (frm.cmdEmpresa.value == "0") {
			alert("A empresa deve ser informado!");
			frm.cmdEmpresa.focus();
			return false;
		} 

		if (frm.txtNomeCompleto.value == "") {
			alert("O Nome Compledo deve ser informado!");
			frm.txtNomeCompleto.focus();
			return false;
		} 
		if (frm.txtCPF.value == "") {
			alert("O CPF deve ser informado!");
			frm.txtCPF.focus();
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

		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		} 
		
		frm.action="UsuarioAcesso_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
		
		}
		
		function resultadoConsulta(intCodigo){
			
			var frm = document.getElementById("frm");
			frm.txtCodigo.value=intCodigo;
			frm.submit();
		}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 