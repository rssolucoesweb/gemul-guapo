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
        strPaginaTitulo = "Rel_ColaboradorAssinatura_con.asp"
        strSituacao					= Trim(Request.Form("cmbSituacao"))	
        intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
    %>
    <!--=== Content Part ===-->
    <form method="post" id="frm" action="#">
    <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório - Colaborador Assinatura</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    
                    <div class="form-group">
                        <label class="form-label">Unidade</label>
                        <!--#include file="../includes/inc_cmdEmpresaUsuario.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                    	<!--#include file="../includes/inc_cmdSituacao.asp" -->
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
            frm.action = "Rel_ColaboradorAssinatura_rel.asp";
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 