<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"--> 
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	strUsuarioPortal	= ucase(Trim(Request.Form("txtUsuarioPortal")))
	IntCodEmpresa		= Trim(Request("txtCodEmpresa"))
	
	if strUsuarioPortal <> "" then
						
		sql = " SELECT SEG_USUARIOS_SISTEMA.USUA_CODG, SEG_USUARIOS_SISTEMA.usuario_Master, SEG_USUARIOS_SISTEMA.GESTOR_FINANCEIRO, SEG_USUARIOS_SISTEMA.GESTOR_SUPORTE, SEG_USUARIOS_SISTEMA.USUA_STAT, SEG_USUARIOS_SISTEMA.USUA_NOME_COMPLETO, SEG_USUARIOS_SISTEMA.USUA_CPF, SEG_USUARIOS_SISTEMA.USUA_TELEFONE, SEG_USUARIOS_SISTEMA.USUA_INFO_SENHA, SEG_USUARIOS_SISTEMA.USUA_EMAIL, SEG_USUARIOS_SISTEMA.USUA_DATA_ATIVACAO, SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO, SEG_USUARIOS_SISTEMA.COD_EMPRESA, SEG_USUARIOS_SISTEMA.USUA_DATA_HORA_ULT_LOGON_WEB, SEG_USUARIOS_SISTEMA.USUA_DATA_ALTERACAO_SENHA, SEG_DEPARTAMENTO.DESCRICAO AS DEPTO, SEG_EMPRESA.RAZAOSOCIAL, SEG_USUARIOS_SISTEMA.GESTOR_MANUTENCAO "
		sql = sql & " FROM SEG_EMPRESA RIGHT JOIN (SEG_DEPARTAMENTO RIGHT JOIN SEG_USUARIOS_SISTEMA ON (SEG_DEPARTAMENTO.CODIGO = SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO) AND (SEG_DEPARTAMENTO.COD_EMPRESA = SEG_USUARIOS_SISTEMA.COD_EMPRESA)) ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_SISTEMA.COD_EMPRESA "
		sql = sql & " WHERE SEG_USUARIOS_SISTEMA.USUA_CODG = '" &  strUsuarioPortal & "'"
		rs.open sql, cnn
		
		if rs.eof = false then
		
			 
			strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
			strDesabilitaAlterar = "" 'Desabilita o botão Alterar
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
				
			IntCodDepto					= Trim(rs("CODIGO_DEPARTAMENTO"))
			strDescDepto				= Trim(rs("DEPTO"))
			if IntCodEmpresa = "" then
				IntCodEmpresa				= Trim(rs("COD_EMPRESA"))
			end if
			strDescEmpresa				= Trim(rs("RAZAOSOCIAL"))
			strUsuarioPortal  			= Trim(rs("Usua_Codg"))
			strSenha 					= Trim(rs("Usua_Info_senha"))
			strDataAtivacao 			= Trim(rs("Usua_Data_Ativacao"))
			strDataAlteracao 			= Trim(rs("USUA_DATA_ALTERACAO_SENHA"))
			strDataLogon	 			= Trim(rs("USUA_DATA_HORA_ULT_LOGON_WEB"))
			strStatus					= Trim(rs("Usua_Stat"))
			strNomeCompleto				= Trim(rs("USUA_NOME_COMPLETO"))
			strCPF						= Trim(rs("USUA_CPF"))
			strTelefone					= Trim(rs("USUA_TELEFONE"))
			strEmail					= Trim(rs("USUA_EMAIL"))
			GestorManutencao			= Trim(rs("GESTOR_MANUTENCAO"))
			
			IF Trim(Request.Form("txtCodEmpresa"))<>"" THEN
				IntCodEmpresa 			= Trim(Request.Form("txtCodEmpresa"))
				strDescEmpresa				= Trim(Request.Form("txtRazaoSocial"))
			END IF
			
			IF Trim(Request.Form("txtCodDepto"))<>"" THEN
				IntCodDepto 			= Trim(Request.Form("txtCodDepto"))
				strDescDepto				= Trim(Request.Form("txtDescDepto"))
			END IF
			
		else
			strDesabilitaIncluir = "" 'Desabilita o botão Alterar
			strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Alterar
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
			
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
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
		
	end if
	%>		
    <!--=== Content Part ===-->
    <form id="frm" method="post">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Manuten&ccedil;&atilde;o de Login</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    
                    <div class="form-group">
                    	<label class="form-label">Usu&aacute;rio</label>
                    	<input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30"  onBlur="submit()">
                    	<button class="btn-u btn-u-sea" onclick="return abreConsulta('Usuario_con.asp')" type="button"><i class="fa fa-search"></i></button>
                    </div>
              
                               
                    <div class="form-group">
                    	<label class="form-label">Empresa</label>
                    	<input name="txtCodEmpresa" type="text" class="form-control" id="txtCodEmpresa" value="<%=intCodEmpresa%>" size="30" maxlength="10" readonly="true" >
                    	<button class="btn-u btn-u-green" onclick="return abreConsulta('Empresa_con.asp')" type="button"><i class="fa fa-search"></i></button>
                        <input name="txtRazaoSocial" type="text" class="form-control" id="txtRazaoSocial" value="<%=strDescEmpresa%>"  size="60" maxlength="60" readonly="true">
                    </div>
              
                    <div class="form-group">
                    	<label class="form-label">Departamento</label>
                    	<input name="txtCodDepto" type="text" class="form-control" id="txtCodDepto" value="<%=intCodDepto%>" size="30" maxlength="10" readonly="true" >
                        <button class="btn-u btn-u-green" onclick="return abreConsulta('Departamento_con.asp?txtCodEmpresa=<%=IntCodEmpresa%>')" type="button"><i class="fa fa-search"></i></button>
                    	<input name="txtDescDepto" type="text" class="form-control" id="txtDescDepto" value="<%=strDescDepto%>"  size="60" maxlength="60" readonly="true">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">CPF</label>
                    	<input name="txtCPF" type="text" class="form-control" id="txtCPF" value="<%=strCPF%>" onkeypress="return formataCampo(this,5,14)" size="16" maxlength="14" onblur="return validaCPF(this)"  >
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Nome Completo</label>
                    	<input name="txtNomeCompleto" type="text" class="form-control" id="txtNomeCompleto" value="<%=strNomeCompleto%>"  size="50" maxlength="50" >
                    </div>
                    
                     <div class="form-group">
                    	<label class="form-label">Telefone</label>
                        <input name="txtTelefone" class="form-control" type="text" id="txtTelefone" value="<%=strTelefone%>" size="15" maxlength="15" >  
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Email</label>
                        <input name="txtEmail" type="text" class="form-control" id="txtEmail" value="<%=strEmail%>"  size="50" maxlength="50" >
                    </div>
                    
                     <div class="form-group">
                    	<label  class="form-label">Senha</label>
                        <input name="txtSenha" type="password" class="form-control" id="txtSenha" value="<%=strSenha%>" size="15" maxlength="15" >
                    </div>
                    
                     <div class="form-group">
                    	<label class="form-label">Confirma Senha</label>
                        <input name="txtSenhaC" type="password" class="form-control" id="txtSenhaC" value="<%=strSenha%>" size="15" maxlength="15" > 
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Data Ativa&ccedil;&atilde;o</label>
                        <input disabled="disabled" name="txtDataAtivacao" type="text" class="form-control" id="txtDataAtivacao"   onBlur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" value="<%=strDataAtivacao%>"  size="25" maxlength="11" >
                    </div>

					<div class="form-group">
                    	<label class="form-label">Data Altera&ccedil;&atilde;o Senha</label>
                    	<input disabled="disabled" name="txtDataAlteracao" type="text" class="form-control" id="txtDataAlteracao"   onBlur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" value="<%=strDataAlteracao%>"  size="25" maxlength="11" >
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Data Ultimo Acesso</label>
                    	<input disabled="disabled" name="txtDataLogon" type="text" class="form-control" id="txtDataLogon"   onBlur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" value="<%=strDataLogon%>"  size="25" maxlength="11" >
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Gestor de Manuten&ccedil;&atilde;o</label>
                    	<input <%if GestorManutencao="S" then response.Write("checked")%> type="checkbox" name="GestorManutencao" id="GestorManutencao" value="S">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Situa&ccedil;&atilde;o</label>
                        <input name="optStatus" type="radio" value="A" <%if strStatus ="A" then response.Write("checked")%>> Ativo &nbsp;&nbsp;
                        <input type="radio" name="optStatus" value="I"  <%if strStatus ="I" then response.Write("checked")%>>Inativo &nbsp;&nbsp;
                        <input type="radio" name="optStatus" value="B"  <%if strStatus ="B" then response.Write("checked")%>>Bloqueado
                    </div>

					<legend></legend>
					<!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                    
                    <input name="txtSenhaAnterior" type="hidden" id="txtSenhaAnterior" value="<%=strSenha%>" >
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
    <!--End Table Bordered-->	
    <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <script>
	function salvar(acao){
		
			var intContMarcado=0;
			var frm = document.getElementById("frm");
	
			if (frm.txtUsuarioPortal.value == "") {
				alert("O usuário deve ser informado!");
				frm.txtUsuarioPortal.focus();
				return false;
			} 
			
			frm.action="ManutencaoLogin_cod.asp?acao=" + acao;
			frm.submit();
			return true;	 
	}
	
	function marcaTodos(){
		
		var frm = document.getElementById("frm");
		
		if(frm.chkTodos.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
		}else{
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
		}
		return true;
	}
    </script>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 