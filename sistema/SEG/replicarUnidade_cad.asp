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
        strPagina			= "replicarUnidade_cad.asp"
    
       
        strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
        strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
        
    %>
    <form method="post" id="frm">
  <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-tasks"></i>Clonar Unidade</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <label>Unidade Origem</label>
                <div class="form-group">
                <!--#include file="../includes/inc_cmbEmpresaGrupo.asp"-->
                </div>
                <label>Unidade Destino</label>
                <div class="form-group">
                <!--#include file="../includes/inc_cmbEmpresaGrupoDestino.asp"-->
                </div>
                
                <legend></legend>
                <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
         </div>
       <!-- Fecha o Painel do Formulario -->        
       </div>
    </div>
    <!--/container-->	
    </form>	
    <script>
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if (frm.cmbEmpresaGrupo.value == "0") {
			alert("Unidade Origem deve ser informada!");
			frm.cmbEmpresaGrupo.focus();
			return false;
		} 
		
		if (frm.cmbEmpresaGrupoDestino.value == "0") {
			alert("Unidade Destino deve ser informada!");
			frm.cmbEmpresaGrupoDestino.focus();
			return false;
		} 
		
		frm.action="replicarUnidade_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 

	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 