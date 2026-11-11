<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 			= "Rel_Usuarios_con.asp"
        intCodGrupo					= session("CodGrupo")
        intCodOrdem 				= request.Form("cmbOrdem")
        
        if intCodOrdem = "" then intCodOrdem = 1 
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório Login Usuário</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
          <div class="panel-body">                                                        
            <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Ordem</label>
                        <select name="cmbOrdem" class="form-control" id="cmbOrdem"  style="width:100pt" >
                            <option value="1" >Nome</option>
                            <option value="2" >Login</option>
                            <option value="3" >Escola</option>
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
		frm.action = "Rel_Usuarios_rel.asp";
		frm.submit();
		return true;	
	}	
    </script>
	<!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 