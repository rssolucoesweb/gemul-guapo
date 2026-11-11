<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">OS - Ordem de Serviço</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "UsuarioExterno_cad.asp"
   		submitArea = "S" 
		
		intCodArea				 					= Trim(Request("cmbArea"))
		intCodTipoServicoOS							= Trim(Request("cmbTipoServicoOS"))
		intCodTipoAndamento							= Trim(Request("cmbTipoAndamento"))
	intCodExecutor			= Trim(Request("cmbExecutor"))
	intCodEmpresaUsuario			= Trim(Request("cmdEmpresaUsuario"))				
    %>
    
    
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->     

                <form id="frm" class="sky-form  panel-body0" method="post">
                	
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Relatório de OS</font></div>


                    <fieldset>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Unidade</label>
                              
                                <label class="input">
                                   <!--#include file="../includes/inc_cmdEmpresaUsuario.asp" -->
                                </label>
                             </section>
                        </div>
                        
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Departamento</label>
                              
                                <label class="input">
                                   <!--#include file="../includes/inc_cmbArea.asp" -->
                                </label>
                             </section>
                        </div>
                        
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Tipo de Serviço</label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbTipoServicoOS.asp" -->
                                </label>
                             </section>
                        </div>

                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Executor</label>
                              
                                <label class="input">
                                  <!--#include file="../includes/inc_cmbExecutor.asp"-->
                                </label>
                             </section>
                        </div>
                        
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Situação</label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbTipoAndamento.asp"-->
                                </label>
                             </section>
                        </div>

                    </fieldset>
					
					<div class="margin-left-40">
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
					</div>
                    
                 </form>                
                
			</div>
         	<!-- Fecha o Form -->  
      </div>
   	   

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    
   	   
	<script>
        function gerar(){
            
            var frm = document.getElementById("frm");
            
            frm.action = "Rel_OS_rel.asp";
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 