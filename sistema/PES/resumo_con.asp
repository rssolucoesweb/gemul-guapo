<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
	<%
        strPaginaTitulo = "Resumo_con.asp"
		
		strExecutarSubmitPesquisa = "S"
				
		cod_pesquisa = request.form("cmbPesquisa")
		if cod_pesquisa = "" then cod_pesquisa = "0"
	%>
    
<div class="wrapper">

	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">PES - Sistema de Pesquisas</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->

    <!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->     

                <form id="frm" class="sky-form  panel-body0" method="post">
                	
                    <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
                    
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Resumo das Entrevistas</font></div>

                    <fieldset>
						 <div class="row">
							<section class="col col-10">
								<label class="label">Resumo</label>
								<label class="input">
									<!--#include file="../includes/inc_cmbPesquisa.asp" -->
								</label>
							</section>
						  </div>
						  <div class="row">
							<section class="col col-10">
								<label class="label">Setor</label>
								<label class="input">
									<!--#include file="../includes/inc_cmbSetor.asp" -->
								</label>
							</section>
						  </div>
                    </fieldset>    
					 <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"--><br>
                </form>
                <!-- End Responsive Grid System -->
            </div>
            <!-- End Content -->
            
        </div>          
    </div><!--/container-->     
    <!--=== End Content Part ===-->

</div><!--/End Wrapepr-->
    
   
	<script>
    
        function gerar(){
        
            var frm = document.getElementById("frm");
            var caminho;
    
            if (frm.cmbPesquisa.value=="0") {
                alert("A pesquisa deve ser selecionada.");
                frm.cmbPesquisa.focus();
                return false
            }
            frm.action = "resumo_rel.asp?cod_pesquisa="+frm.cmbPesquisa.value+"&cod_setor="+frm.cmbSetor.value;
            frm.submit();
            return true;	
        }	
		
    </script>
    
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 