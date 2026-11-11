<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Transporte Escolar</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 		= "Rel_Rota_con.asp"
        intCodRota 				= Trim(Request.Form("cmbRota"))
        intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
        intDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
		intCodEmpresaUsuario	= Trim(Request.Form("cmdEmpresaUsuario"))
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório de Rota</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    
					<div class="form-group">
                        <label class="form-label">Unidade</label>
                         <!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                    </div>
					<div class="form-group">
                        <label class="form-label">Nome da Rota</label>
                         <!--#include file="../includes/inc_cmdRota.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Ordem</label>
                        <select name="cmbOrdem" class="form-control" id="cmbOrdem"  style="width:130pt">
                          <option value="alfabetica" >Alfabetica</option>
                          <option value="Turma" >Turma</option>
                        </select>
                    </div>
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
		
		
		
		frm.action = "Rel_Rota_rel.asp";
		frm.submit();
		return true;	
	}	

	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 