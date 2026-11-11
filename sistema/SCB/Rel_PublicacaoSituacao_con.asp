	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%

    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório Emprestimos por Período</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                <div class="form-group">
                <label class="form-label">Origem da Publica&ccedil;&atilde;o</label>
                    <select name="cmbOrigem" id="cmbOrigem" class="form-control" style="width:350pt">
                        <option value="T">Todos</option>
                        <option value="E">Emprestimo</option>
                        <option value="N">Renova&ccedil;&atilde;o</option>
                    </select>
                 </div>
                <div class="form-group">
                <label class="form-label">Situa&ccedil;&atilde;o da Publica&ccedil;&atilde;o</label>
                    <select name="cmbSituacao" id="cmbSituacao" class="form-control" onChange="setaTipoFiltro(this.value)" style="width:350pt">
                    <option value="T">Todos</option>
                    <option value="E">Emprestimo</option>
                    <option value="D">Devolu&ccedil;&atilde;o</option>
                  </select>
                 </div>
                <div class="form-group">
                <label class="form-label">Filtrar por</label>
                    <select name="cmbFiltro" id="cmbFiltro" class="form-control" style="width:350pt">
                    <option value="E">Data Emprestimo </option>
                    <option value="D">Data Devolu&ccedil;&atilde;o</option>
                    </select>
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label">Periódo</label>
                 <input name="txtDataI" type="text" class="form-control" id="txtDataI" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataI%>"> a
				 <input name="txtDataF" type="text" class="form-control" id="txtDataF" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataF%>"> - ( Caso n&atilde;o seja informado uma das datas, ser&aacute; realizada uma classifica&ccedil;&atilde;o total ) 
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
		frm.action = "Rel_PublicacaoSituacao_rel.asp";
		frm.submit();
		return true;	
	}
	function setaTipoFiltro(valor){
		
		var frm = document.getElementById("frm");
		if (valor=="D"){
			frm.cmbFiltro.value = "D"
		}else{
			frm.cmbFiltro.value = "E"
		}
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 