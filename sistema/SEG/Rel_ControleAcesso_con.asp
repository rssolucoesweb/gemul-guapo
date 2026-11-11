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
        strPaginaTitulo 			= "Rel_ControleAcesso_con.asp"
        intCodGrupo					= session("CodGrupo")
        intCodEmpresaUsuario	 	= request.Form("cmdEmpresaUsuario")
        intCodUsuario               = request.Form("cmbUsuario")
		
		if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Controle de Acesso</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <label>Unidades</label>
                    <div class="form-group">
                     <!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                    </div>
                    <label>Usu&aacute;rio</label>
                    <div class="form-group">
                      <!--#include file="../includes/inc_cmbUsuario.asp"-->
                    </div>
                    <br>
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
		frm.action = "Rel_ControleAcesso_rel.asp";
		frm.submit();
		return true;	
	}	
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 