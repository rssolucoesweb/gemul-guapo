<!--#include file="../ConfigModulo.asp"-->
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
        strPaginaTitulo = "CargoColaborador_cad.asp"
	    strMostraBotaoVoltar  	= "S"
		strPagina				= "ColaboradorSubstitutoNovo_cad.asp"
        intCodCodSubstituicao	= Trim(Request.Form("chkCodSubistituicao"))
		strDataInicial			= formatadataAP(date)
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Efetuar Inativação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="chkCodSubistituicao" type="text" id="chkCodSubistituicao" class="text" size="10" value="<%=intCodCodSubstituicao%>" maxlength="10">
              
                    <div class="form-group">
                      <label class="form-label">Data da Inativação</label>
                        <input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataInicial%>"  style="cursor:hand" >
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
        function resultadoConsulta(intCodigo){
            
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
        
        function salvar(acao){
            var frm = document.getElementById("frm");
            if (frm.txtDataInicial.value == "") {
                alert("A data da inativação deve ser informada!");
                frm.txtDataInicial.focus();
                return false;
            }
            
            frm.action="ColaboradorSubstitutonovoInativar_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 