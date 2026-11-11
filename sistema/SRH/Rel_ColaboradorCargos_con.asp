<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
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
        strPaginaTitulo = "Rel_ColaboradorCargos_con.asp"
        
        strSituacao					= Trim(Request.Form("cmbSituacao"))	
        strTipoRelatorio			= request.Form("cmbTipoRelatorio")
        intCodCargo 	    		= TRIM(Request.Form("cmbCargo"))
        intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Colaboradores - Cargos</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               <form method="post" id="frm" action="#">
				<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
			
					<%if Session("NivelPermissao") = "A" then%>
                    <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Unidade</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdEmpresaUsuario.asp" -->
                        </div>
               		 </div>
                     <% end if %>	
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Cargo</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbCargo.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Situa&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdSituacao.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Classificar</label>
                        <div class="col-lg-10">
                        	<select name="cmbTipoRelatorio" id="cmbTipoRelatorio" onChange="submit()" class="form-control">
                               <option <%if strTipoRelatorio = "A" then%> selected <%end if%> value="A">Analítico</option>
                               <option <%if strTipoRelatorio = "S" then%> selected <%end if%> value="S">Sintético</option>
                             </select>
                        </div>
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
            frm.action = "Rel_ColaboradorCargos_rel.asp";
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 