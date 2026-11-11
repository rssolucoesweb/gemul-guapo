<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		strPaginaTitulo = "Rel_AlunoNomesIguais_con.asp"
	
		strExecutarSubmitSemestre = "S"
		strExecutarSubmitTurno	  = "S"
		'intCodEmpresaGrupoUsuario 		= Trim(Request.Form("cmdEmpresaGrupoUsuario"))
	
		strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
		if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
		intSemestre 			= Trim(Request.Form("cmbSemestre"))
		if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
		strFiltroSerie = "0"
		strFiltroTurno = "0"
	
		if intCodSemestre = "" then intCodSemestre = "0"
	
		'controla os botões
		strDesabilitaIncluir = "disabled"
		strDesabilitaExcluir = "disabled"
		strDesabilitaAlterar = ""
		strDesabilitaLimpar = ""
		retiraSelecione = "S"
	%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório de Alunos/Nomes iguais</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">

                    <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                         <!--#include file="../includes/inc_cmdSituacaoAluno.asp"-->
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
            
            frm.action = "Rel_AlunoNomesIguais_rel.asp";
            frm.submit();
            return true;	
        }	
    </script>
	<!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 