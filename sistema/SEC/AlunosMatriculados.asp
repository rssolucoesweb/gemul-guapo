<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>
<script src="../../js/js_funcoes_gerais.js"></script>  
<%
	strPaginaTitulo = "Rel_QtdeUnidadePorCurso_con.asp"

	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	intCodEmpresaGrupoUsuario 		= Trim(Request.Form("cmdEmpresaGrupoUsuario"))


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

%>
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SEC - Secretario(a)</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->

    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Alunos Matriculados</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                   <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Ano Letivo:</label>
                        <div class="col-lg-10">
                        	<input  name="txtAnoLetivo" type="text" class="text" id="form-control" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Semestre:</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                        </div>
                    </div>
                    
                      <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Situa&ccedil;&atilde;o:</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdSituacaoAluno.asp"-->
                        </div>
                    </div>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
            
            
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
        
    </div>
    
    <script>
	function gerar(){
		
		var frm = document.getElementById("frm");
		
		frm.action = "Rel_QtdeUnidadePorCurso_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 