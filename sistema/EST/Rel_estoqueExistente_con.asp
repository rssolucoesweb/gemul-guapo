<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%  
        StrReloadSistema	= "S"
        principal			= "principal.asp"
		Session("CodSecao") = "0"
    %>
 <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório de Estoque Existente</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               <form id="frm" name="frm" method="post">
               		
                    <%IF Session("CodSecao") = "0" THEN %>
                    
                         <div class="form-group">
                            <label for="inputEmail1" class="col-lg-2 control-label">Se&ccedil;&atilde;o</label>
                            <div class="col-lg-10">
                                <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                            </div>
                         </div>
                         
                          <div class="form-group">
                            <label for="inputEmail1" class="col-lg-2 control-label">Filtro</label>
                            <div class="col-lg-10">
                                <input type="checkbox" name="conferencia" id="conferencia" value="1">Conferidos&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="checkbox" name="conferencia" id="conferencia" value="2"> A Conferir
                            </div>
                         </div>
                         <br>
                         
                         
                        <div class="form-group">
                    		<label for="inputEmail1" class="col-lg-2 control-label">Estoque</label>
                        	<div class="col-lg-12">
                            <input type="radio" name="estoque" id="estoque" checked value="0">Geral &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="radio" name="estoque" id="estoque"  value="1">Dispon&iacute;vel&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="radio" name="estoque" id="estoque" value="2">Indispon&iacute;vel
                        	</div>
               		 	</div>
                         
                     <%ELSE%>
                     
                     	 <input name="cmbSecaoProduto" id="cmbSecaoProduto" value="<%=Session("CodSecao")%>" type="hidden">
                      
                      <%END IF%>
                   
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
            if (frm.cmbSecaoProduto.value=="0") {
                alert("Seção deve ser selecionada!");
                frm.cmbSecaoProduto.focus();
            }else{
                frm.action = "Rel_EstoqueExistente_rel.asp";
                frm.submit();
            }
            
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 