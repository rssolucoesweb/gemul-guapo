<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
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
	strPagina			= "Modulos_cad.asp"
	strSiglaSistema 	= Trim(Request("cmbSistemas"))

	strSiglaModulo		= Trim(Request.Form("txtSiglaModulo"))
	strDescModulo		= Trim(Request.Form("txtDescModulo")) 
	strMensModulo		= Trim(Request.Form("txtMensagem"))
	strSituacao			= Trim(Request.Form("cmdSituacao"))
	strURL 				= Trim(Request.Form("txtURL"))
	
	' Busca o Sistema
	if strSiglaSistema <> "" then
			
		sql = "SELECT Sist_Stat, Sist_Desc "
		sql = sql & " FROM SEG_SISTEMAS_INFORMATICA"
		sql = sql & " WHERE Sist_Sigl = '" & strSiglaSistema & "'"
		rs.open sql, cnn
			
		if rs.eof = false then
			strSituacaoSist 	=	Trim(rs("Sist_Stat"))
			strDescSistema		=	Trim(rs("Sist_Desc"))
		end if
		rs.close
		
	end if
	
	' Busca o Modulo
	if strSiglaSistema <> "" then
		sql = "SELECT Modu_Sist_Sigl, Modu_Sigl, Modu_Desc, Modu_Stat"
		sql = sql & " FROM SEG_MODULOS_SISTEMA"
		sql = sql & " WHERE Modu_Sist_Sigl = '" & strSiglaSistema  & "'"
	
		rs.open sql, cnn
			
		if rs.eof = false then
			strSiglaModulo		=	Trim(rs("Modu_Sigl"))
			strDescModulo		=	Trim(rs("Modu_Desc"))
		end if
		rs.close
	end if
	
	if strSiglaSistema <> "" and strSiglaModulo <> "" then
	
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar'
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	
		
			sql = "SELECT Modu_Sist_Sigl, Modu_Sigl, Modu_Desc, Modu_Info_Mensagem, Modu_Stat, Sist_Desc, Modu_URL"
			sql = sql & " FROM SEG_MODULOS_SISTEMA, SEG_SISTEMAS_INFORMATICA"
			sql = sql & " WHERE Modu_Sist_Sigl = Sist_Sigl"
			sql = sql & " AND Modu_Sist_Sigl LIKE '%" & strSiglaSistema  & "%'"
			sql = sql & " AND Modu_Sigl LIKE '%" & strSiglaModulo  & "%'"
			rs.open sql, cnn
			
			if rs.eof = false then
				
				strDescSistema 	= trim(rs("Sist_Desc"))
				strDescModulo  	= trim(rs("Modu_Desc"))
				strMensModulo  	= trim(rs("Modu_Info_Mensagem"))
				strSituacao  	= trim(rs("Modu_Stat"))
				strURL			= trim(rs("Modu_URL"))
			else
				
				strDesabilitaIncluir = ""'Desabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
				
				strDescModulo 		= ""
				strMensagem		 		= ""
				strSituacao				= ""
	
			end if
			rs.close
	
	else
			
			if strSituacaoSist <> "I" then
				strNovaMensagem 		 = ""
				strDesabilitaIncluir = ""'Desabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
			else
				strNovaMensagem  		 = "Atenção : Sistema informado acima, esta inativo"
				strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
				
			end if 
			
			strDescModulo 			= ""
			strMensagem		 		= ""
			strSituacao				= ""
	
	end if
	%>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Módulos</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                        <label>Sistema</label>
                        <div class="form-group">
                          <!--#include file="../includes/inc_cmdSistemas.asp"-->
                        </div>
                        <label>Sigla</label>
                        <div class="form-group">
                         <input id="txtSiglaModulo" name="txtSiglaModulo" type="text"  value="<%=strSiglaModulo%>"  size="20" class="form-control" maxlength="20" width="100" onChange="Submit()">
                        </div>
                        <label>Descrição</label>
                         <div class="form-group">
                        <input id="txtDescModulo" name="txtDescModulo" type="text"  value="<%=strDescModulo%>"  size="50" class="form-control" maxlength="50" width="100">
                        </div>
                        <label>Mensagem</label>
                        <div class="form-group">
                        <input id="txtMensagem" name="txtMensagem" type="text"  value="<%=strMensModulo%>"  size="50" class="form-control" maxlength="50" width="100">
                        </div>
                        <label>URL</label>
                        <div class="form-group">
                        <input id="txtURL" name="txtURL" type="text"  value="<%=strURL%>"  size="50" class="form-control" maxlength="50" width="100">
                        </div>
                        <label>Situação</label>
                        <div class="form-group">
                        <select name="cmdSituacao" id="cmdSituacao" style="width:80pt" class="form-control">
                            <option value="0">Selecione...</option>
                             <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                             <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Intativo</option>
                             <option value="D" <%if strSituacao = "D" then response.Write("selected") %>>Desabilitado</option>
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
		function salvar(acao){
		
		if (frm.cmbSistemas.value == "0") {
			alert("O Sistema deve ser informado!");
			frm.cmbSistemas.focus();
			return false;
		} 
		
		if (frm.txtSiglaModulo.value == "") {
			alert("A Sigla do Modulo deve ser informada!");
			frm.txtSiglaModulo.focus();
			return false;
		} 

		if (frm.txtDescModulo.value == "") {
			alert("A Descrição do Modulo deve ser informada!");
			frm.txtDescModulo.focus();
			return false;
		} 
		
		if (frm.txtURL.value == "") {
			alert("A URL deve ser informada!");
			frm.txtURL.focus();
			return false;
		} 
		
		if (frm.cmdSituacao.value == "0") {
			alert("A Situação deve ser informada!");
			frm.cmdSituacao.focus();
			return false;
		} 

		frm.action="modulos_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 