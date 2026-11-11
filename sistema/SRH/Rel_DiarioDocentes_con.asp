<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
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
        strPaginaTitulo = "Rel_DiarioDocentes_con.asp"
        strData	 			= formatadataAP(date)
        strSubTitulo 		= Trim(Request.Form("txtSubTitulo"))
    
        intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        if intSemestre = "" then 	intSemestre 			= session("strSemestre")
    %>
    <!--=== Content Part ===-->
    <form method="post" id="frm" action="#">
    <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Folha de Ponto - Professor</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                        <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                    	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Curso</label>
                    	<!--#include file="../includes/inc_cmdCurso.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Data</label>
                    	<input name="txtData" type="text" class="form-control" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Sub-T&iacute;tulo (Opcional)</label>
                    	<input name="txtSubTitulo" type="text" class="form-control" id="txtSubTitulo" size="100" maxlength="100" value="<%=strSubTitulo%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Op&ccedil;&atilde;o</label>
                    	<input type="checkbox" name="filtro" value="S"> -  Mostrar Docentes/Disciplinas 
                    </div>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
    <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function gerar(){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtAnoLetivo.value=="") {
                alert("Ano Letivo deve ser informado.");
                frm.txtAnoLetivo.focus();
                return false
            }
        
            if (frm.txtData.value==""){
                alert("A data deve ser informada.");
                frm.txtData.focus();
                return false
            }
            
            frm.action = "Rel_DiarioDocentes_rel.asp";
            frm.submit();
            return true;	
        }	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 