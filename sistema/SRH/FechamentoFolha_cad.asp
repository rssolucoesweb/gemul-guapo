<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
        strPaginaTitulo 	= "FechamentoFolha_cad.asp"
        
        strMes				= Trim(Request("cmbMes"))
        strAno				= Trim(Request("cmbAno"))
        if strMes = "" then strMes = month(date)
        if strAno = "" then strAno = year(date)
        strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
        strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Gerar Folha</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form method="post" id="frm" action="FechamentoFolha_cad.asp">
                
                    <div class="form-group">
                        <label class="form-label">Folha</label>
                        <!--#include file="../includes/inc_cmbTipoFolha.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">M&ecirc;s/Ano</label>
                    	<!--#include file="../includes/inc_cmbMes.asp"-->/<!--#include file="../includes/inc_cmbAno.asp"-->
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
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            var men = 'ATENÇÃO: \nDeseja realmente gerar a folha para o mês/ano informado?';
            
            if (confirm(men)) {
                frm.action="FechamentoFolha_cod.asp?acao=" + acao;
                frm.submit();
                return true;
            }
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 