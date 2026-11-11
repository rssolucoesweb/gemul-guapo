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
	strPaginaTitulo = "DadosMalaDireta_con.asp"
	strTextoBotaoRel = "Gerar Dados"
	
	strCdu 	               = Trim(Request.Form("txtCdu"))
	strSimouNao            = Trim(Request.Form("cmbSimouNao"))

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = "disabled"
	strDesabilitaLimpar = ""

    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Dados para Mala Direta</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
                    <div class="form-group">
                        <label class="form-label">Ignorar Etiquetas já Emitidas?</label>
                         <!--#include file="../includes/inc_cmbSimouNao.asp"-->
                    </div>
                    <div class="form-group">
                        <label class="form-label"> C.D.U:</label>
                        <input name="txtCdu" type="text" class="form-control" id="txtCdu" style="width:100px;" size="40" maxlength="40" value="<%=strCdu%>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">  Op&ccedil;&atilde;o de Relat&oacute;rio:</label>
                         <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">Cartas de Agradecimentos
                         <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">Renova&ccedil;&otilde;es
                    </div>
                    Obs: Os dados Gerados são texto "CSV" que deverão ser carregado e salvo como planilha XLS.
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
    
    </div>
    <!--/container-->		
    <script>
	function gerar(){
		var caminho;
		var frm = document.getElementById("frm");
		
       	caminho = "DadosMalaDireta_cod.asp"
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