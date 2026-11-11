<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
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
            intCodGrupo = session("codGrupo")
            strPaginaTitulo 			= "Rel_DiretrizesEstruturaFisica_con.asp"
            intCodEmpresa				= session("codEmpresa")
            intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
            strAno	 					= Trim(Request("txtAno"))
			if strAno= "" then strAno= session("strAnoLetivo")
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Diretrizes Estrutura Física</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    <form method="post" id="frm" action="#">
						<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
			 
						  <div class="form-group">
							<label for="inputEmail1" class="col-lg-2 control-label">Ano</label>
							<div class="col-lg-10">
								<input  name="txtAno" type="text" class="form-control" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" onChange="submit()">
							</div>
						 </div>
                     <br>
						 <div class="form-group">
							<label for="inputEmail1" class="col-lg-2 control-label">Unidade</label>
							<div class="col-lg-10">
								<!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
							</div>
						 </div>
                     <br>
						<div class="form-group">
							<label for="inputEmail1" class="col-lg-2 control-label">Dependência</label>
							<div class="col-lg-10">
								<!--#include file="../includes/inc_cmbDependenciasFisicas.asp" -->
							</div>
						 </div><br>
						<div class="form-group">
							<label for="inputEmail1" class="col-lg-2 control-label">Situação</label>
							<div class="col-lg-10">
								<!--#include file="../includes/inc_cmbSituacao.asp"-->
							</div>
						 </div>
					<br><br><br>
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
            
            frm.action = "Rel_DiretrizesEstruturaFisica_rel.asp";
            frm.submit();
            return true;	
        }	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 