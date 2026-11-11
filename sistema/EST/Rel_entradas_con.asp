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
        strEmpresaSecaoProduto_submit = "S"
        StrReloadSistema	= "S"
        principal			= "principal.asp"
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = "0"
        
        strDataI = formatadataAP(request("txtDataI"))
        strDataF = formatadataAP(request("txtDataF"))
    %>    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório de Entrada de Materiais</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               <form id="frm" name="frm" method="post">
               
                    <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Se&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                        </div>
               		 </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Per&iacute;odo</label>
                        <div class="col-lg-10">
                        <input name="txtDataI" id="txtDataI" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataI%>" size="10" maxlength="10"> 
                  		a 
                    	<input name="txtDataF" id="txtDataF" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataF%>" size="10" maxlength="10">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Produto</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbProduto.asp"-->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Fornecedor</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbFornecedor.asp"-->
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
            if (frm.txtDataI.value == "") {
                alert("A Data inicial deve ser informada!");
                frm.txtDataI.focus();
                return false;
            }
            if (frm.txtDataF.value == "") {
                alert("A Data final deve ser informada!");
                frm.txtDataF.focus();
                return false;
            }
            
            frm.action = "Rel_entradas_rel.asp";
            frm.submit();
            
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 