<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<style>
.margin-bottom-30 {
    margin-left: 30px;
}
.pointer {cursor: pointer;}
.tamanho7 { font-size: 9px; }
</style>
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
    acao = "I"

	strPaginaTitulo                  			= "faltas_nao_justificadas_funcionario_cad.asp"
	strPagina						 			= "faltas_nao_justificadas_funcionario_cad.asp"
	strExecutarSubmitModulacaoReferencia        = "S"


	
    %>
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->   

					<form id="frm" method="post" action="lancamento_faltas.asp"  class="sky-form panel-body0">
					<div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Lançamento de faltas</font></div>

                    <fieldset>
						<div class="row">
                             <section class="col col-3">
                                <label class="form-label">&nbsp;&nbsp;</label>
                              
                                <label>
									<input type="button" name="cmdFechar" style="cursor:hand"   value="   Lançar faltas Justificadas    " class="btn btn-success btn-lg"  onclick="carregaTelaJustificadas()">
									
                                </label>
                             </section>
							 <section class="col col-9">
                                <label class="form-label">&nbsp;&nbsp;</label>
                              
                                <label>
                                    <input type="button" name="cmdFechar" style="cursor:hand"   value=" Lançar faltas Não Justificadas  " class="btn btn-info btn-lg" onclick="carregaTelaNaoJustificadas()">
                                </label>
                             </section>
                        </div>
						<br>
						
						<br>
						<br>
						<br>
						<br>
					 </fieldset>
					 
			</div>
			</form>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
      
   	   
	
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 




<script>
  
	function carregaTelaJustificadas(){
		var frm = document.getElementById("frm");
		frm.action = "JustificativaProfessor_cad.asp";
		frm.submit();
	}
	function carregaTelaNaoJustificadas(){
	
		var frm = document.getElementById("frm");
		frm.action = "faltas_nao_justificadas_professor_cad.asp";
		frm.submit();
	}
	
    </script>