<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">APO - Apontamento</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 			= "Rel_DiretrizesGeraisNovo_con.asp"
        intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
		if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
        strAno	 					= Trim(Request("txtAno"))
        intSemestre 				= Trim(Request("cmbSemestre"))
        if strAno = "" then strAno = session("strAnoLetivo")
        if intSemestre = "" then intSemestre = Session("strSemestre")
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Diretrizes Gerais (Novo)</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form method="post" id="frm" action="#">
				<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">

                    <div class="form-group">
                        <label class="form-label">Ano</label>
                        <input  name="txtAno" type="text" class="form-control" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)" onchange="submit()">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                    	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Unidade</label>
                    	<!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Op&ccedil;&atilde;o de Relat&oacute;rio</label>
                    	<strong>
                        <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0" >
                        <span class="texto1">Deficit</span>
                        <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1" >
                        <span class="texto1">Modula&ccedil;&atilde;o Excedida</span>
                        <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" <%if intCodEmpresaUsuario="0" then response.write "disabled"%> type="radio" value="2" >
                        <span class="texto1">Modula&ccedil;&atilde;o Fechada</span>
                        <input <% if strOpcaoRelatorio = "3" then response.Write("checked")%> name="optOpcao" <%if intCodEmpresaUsuario="0" then response.write "disabled"%> type="radio" value="3" >
                        <span class="texto1">Todas Situa&ccedil;&otilde;es</span>
                        </strong>		
                    </div>
					<input value="<%=strOpcaoRelatorio%>" type="hidden" name="optRel">
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        function gerar(){
            
            var frm = document.getElementById("frm");
            
			if(frm.cmdEmpresaUsuario.value == "0"){
				
				frm.action = "Rel_MapaModulacaoNovoDeficit_rel.asp";
				frm.submit();
				return true;	
			}
			else{
				frm.action = "Rel_MapaModulacaoNovo_rel.asp";
				frm.submit();
				return true;	
			}

            return true;	
        }	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 