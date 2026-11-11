<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"--> 
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
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Usu&aacute;rio</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
               
                    <div class="form-group">
                        <label class="form-label">Usu&aacute;rio Origem</label>
                        <input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30" onblur="submit()" style="width:200pt">
                        <button class="btn-u btn-u-sea" onclick="return abreConsulta('Usuario_con.asp')" type="button"><i class="fa fa-search"></i></button>  
                    </div>
                    
                    <legend></legend>
                    
                    <div class="form-group">
                        <label class="form-label">Empresa</label>
                        <!--#include file="../includes/inc_cmdEmpresa.asp"-->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Departamento</label>
                        <!--#include file="../includes/inc_cmbDepartamento.asp"-->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">CPF</label>
                        <input name="txtCPF" type="text" class="form-control" id="txtCPF" value="<%=strCPF%>" size="30" maxlength="30"  style="width:200pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Nome Completo</label>
                        <input name="txtNomeCompleto" type="text" class="form-control" id="txtNomeCompleto" value="<%=strNomeCompleto%>" size="30" maxlength="30" style="width:300pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Telefone</label>
                        <input name="txtTelefone" type="text" class="form-control" id="txtTelefone" value="<%=strTelefone%>" size="30" maxlength="30" style="width:100pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Email</label>
                        <input name="txtEmail" type="text" class="form-control" id="txtEmail" value="<%=strEmail%>" size="30" maxlength="30" style="width:300pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Senha</label>
                        <input name="txtSenha" type="text" class="form-control" id="txtSenha" value="<%=strSenha%>" size="30" maxlength="30" style="width:200pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Confirma Senha</label>
                        <input name="txtSenhaC" type="text" class="form-control" id="txtSenhaC" value="<%=strSenhaC%>" size="30" maxlength="30" style="width:200pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Data Ativa&ccedil;&atilde;o</label>
                        <input disabled="disabled" name="txtDataAtivacao" type="text" class="form-control" id="txtDataAtivacao" value="<%=strDataAtivacao%>" size="30" maxlength="30" style="width:200pt">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Data Altera&ccedil;&atilde;o Senha</label>
                        <input disabled="disabled" name="txtDataAlteracao" type="text" class="form-control" id="txtDataAlteracao" value="<%=strDataAlteracao%>" size="30" maxlength="30" style="width:200pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Data Ultimo Acesso</label>
                        <input disabled="disabled" name="txtDataLogon" type="text" class="form-control" id="txtDataLogon" value="<%=strDataLogon%>" size="30" maxlength="30" style="width:200pt">
                    </div>
                    
                     <div class="form-group">
                        <label >Usu&aacute;rio Master</label>
                         <input <%if usuarioMaster="S" then response.Write("checked")%> type="checkbox" name="usuarioMaster" id="usuarioMaster" value="S">
                    </div>

                    <div class="form-group">
                        <label >Gestor de Financeiro </label>
                         <input <%if GestorFinanceiro="S" then response.Write("checked")%> type="checkbox" name="GestorFinanceiro" id="GestorFinanceiro" value="S">  
                    </div>
                    
                    <div class="form-group">
                        <label> Gestor de Suporte </label>
                         <input <%if GestorSuporte="S" then response.Write("checked")%> type="checkbox" name="GestorSuporte" id="GestorSuporte" value="S"> 
                    </div>
                    
                    <div class="form-group">
                        <label > Gestor de Manuten&ccedil;&atilde;o </label>
                         <input <%if GestorManutencao="S" then response.Write("checked")%> type="checkbox" name="GestorManutencao" id="GestorManutencao" value="S">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                        <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:130pt">
                          <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                          <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
                          <option value="B" <%if strSituacao = "B" then response.Write("selected") %>>Bloqueado</option>
                        </select>
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	
	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function salvar(acao){
		
		if (frm.txtUsuarioPortal.value == "") {
			alert("O Us?ario deve ser informado!");
			frm.txtUsuarioPortal.focus();
			return false;
		} 
		
		if (frm.cmdEmpresa.value == "0") {
			alert("A empresa deve ser informado!");
			frm.cmdEmpresa.focus();
			return false;
		} 
		if (frm.cmbDepartamento.value == "0") {
			alert("O departamento deve ser informado!");
			frm.cmbDepartamento.focus();
			return false;
		} 
		
		if (frm.txtUsuarioPortal.value == "") {
			alert("O Usu?rio PORTAL deve ser informado!");
			frm.txtUsuarioPortal.focus();
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
				alert("A senha deve ter pelo menos 6 d?gitos!");
				frm.txtSenha.value = "";
				frm.txtSenhaC.value = "";
				frm.txtSenha.focus();
				return false;
			}
			
	    	if (frm.txtSenha.value != frm.txtSenhaC.value) {
				alert("As senhas n?o conferem, tente novamente!");
				frm.txtSenha.value = "";
				frm.txtSenhaC.value = "";
				frm.txtSenha.focus();
				return false;
			}
		} 

		if (frm.cmbSituacao.value == "0") {
			alert("A Situa??o deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		} 
		
		frm.action="Usuario_cod.asp?acao=" + acao;
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