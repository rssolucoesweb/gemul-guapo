<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Matrícula</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "Rel_Reserva_rel.asp"
    
        'controla os botões
        strDesabilitaIncluir = "disabled"
        strDesabilitaExcluir = "disabled"
        strDesabilitaAlterar = ""
        strDesabilitaLimpar = ""
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Rela&ccedil;&atilde;o de Cadastro de Reservas na Matricula <%=year(date)%></h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Tipo</label>
                         <select name="cmbTipo" id="cmbTipo" class="form-control">
                            <option value="N">Nominal</option>
                            <option value="T">Total</option>
                          </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Filtro</label>
                         <!--#include file="../includes/inc_cmbAgrupamento.asp"-->
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ordenação</label>
                        <select name="cmbOrdenacao" class="form-control" id="cmbOrdenacao"  style="width:100pt" >
                            <option value="0">Selecione...</option>
                            <option value="1" <%if intOrdenacao = "1" then response.Write("selected") %>>Incrição</option>
                            <option value="2" <%if intOrdenacao = "2" then response.Write("selected") %>>Nome</option>
                            <option value="3" <%if intOrdenacao = "3" then response.Write("selected") %>>Seríe</option>
                            <option value="4" <%if intOrdenacao = "4" then response.Write("selected") %>>Bairro</option>
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
		var caminho;
		if (frm.cmbTipo.value=="N")
			caminho = "Rel_Reserva_rel.asp"
		if (frm.cmbTipo.value=="T")
			caminho = "Rel_ReservaTotal_rel.asp"
			
		frm.action = caminho;
		frm.submit();
		return true;	
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 