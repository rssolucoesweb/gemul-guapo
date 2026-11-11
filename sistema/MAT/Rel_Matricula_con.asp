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
	intCodEmpresaUsuario 	= request.Form("cmdEmpresaUsuario")
	intOrdenacao 			= request.Form("cmbOrdenacao")

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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Rela&ccedil;&atilde;o de  Matrícula <%=year(date)%></h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Tipo</label>
                         <!--#include file="../includes/inc_cmbTipoEmpresa.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Unidade</label>
                        <!--#include file="../includes/inc_cmdEmpresaUsuario.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Bolsa Fam&iacute;lia</label>
                        <select name="cmbBolsaFamilia" class="form-control" id="cmbBolsaFamilia"  style="width:100pt" >
                            <option value="0">Todas...</option>
                            <option value="S">Sim</option>
                            <option value="N">Não</option>
                        </select>
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Ordenação</label>
                        <select name="cmbOrdenacao" class="form-control" id="cmbOrdenacao"  style="width:100pt" >
                            <option value="0">Selecione...</option>
                            <option value="1" <%if intOrdenacao = "1" then response.Write("selected") %>>Inscrição</option>
                            <option value="2" <%if intOrdenacao = "2" then response.Write("selected") %>>Nome</option>
                            <option value="3" <%if intOrdenacao = "3" then response.Write("selected") %>>Seríe</option>
                        </select> 
                    </div>
                     <div class="form-group">
                        <label class="form-label">Mostra Nome Aluno/Mãe</label>
                        <select name="cmbAlunoMae" class="form-control" id="cmbAlunoMae"  style="width:100pt" >
                            <option value="S" <%if strAlunoMae = "S" then response.Write("selected") %>>Sim</option>
                            <option value="N" <%if strAlunoMae = "N" then response.Write("selected") %>>Não</option>
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
		caminho = "Rel_Matricula_rel.asp"
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