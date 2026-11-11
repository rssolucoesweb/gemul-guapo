<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">APO - Apontamento</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        pagina						= "AtualizaDataPonto_con.asp"
		intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
		strAno	 					= Trim(Request("txtAno"))
		intSemestre 				= Trim(Request("cmbSemestre"))
		if strAno = "" then strAno = session("strAnoLetivo")
		if intSemestre = "" then intSemestre = Session("strSemestre")

        	strDesabilitaIncluir = "  "
	strDesabilitaAlterar = " Disabled "
	strDesabilitaExcluir = " Disabled "
    %>
    <!--=== Content Part ===-->
    <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >

    <!--/inicio container-->
    <div class="container content">		
    
        <!-- Grey Panel -->            
        <div class="panel panel-grey">
        
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-tasks"></i>Extrato de Ponto do Colaborador</h3>
            </div>
        
            <!-- Inicia o Painel do Formulario -->     
            <div class="panel-body">
            
                    <!-- Inicia o Form -->     
                    <div class="panel-body">                                                        
                        <form id="frm" class="margin-bottom-10" method="post">
                             <div class="form-group">
                               <label class="form-label">Ano</label>
                                <span class="celula">
                                <input  name="txtAno" type="text" class="text" id="form-contro" value="<%=strAno%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)" onchange="submit()">
                                </span>
                             </div>
                            <div class="form-group">
                               <label class="form-label">Unidade</label>
                                <span class="celula">
                                <!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                                </span>
                             </div>
                            
                            <legend></legend>
                            <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                        </form>
            
                    </div>
                    <!-- Fecha o Form -->
            </div>
            <!-- Fecha o Painel do Formulario -->
		</div>
		<!-- Grey Panel -->
	</div>
    <!--/container-->		
	<script>
    
       function salvar(){
		
		var frm = document.getElementById("frm");
		
		if(frm.cmdEmpresaUsuario.value == "0"){
			
			alert("Unidade deve ser informada!")
			return false;	
		}
		else{
			frm.action = "AtualizaDataPonto_cod.asp";
			frm.submit();
			return true;	
		}
	}	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 