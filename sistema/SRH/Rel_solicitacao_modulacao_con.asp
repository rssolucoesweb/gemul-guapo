<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
	<%
	strPaginaTitulo = "Rel_solicitacao_modulacao_con.asp"
	pagina = "Rel_Justificativa_con.asp"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitGradeCurricular = "S"
    
	intCodEmpresaGrupo	 	    = TRIM(Request.Form("cmbEmpresaGrupo"))
	if session("nivelPermissao")<>"A" then intCodEmpresaGrupo = session("codEmpresa")
	intAnoLetivo	= Trim(Request("txtAnoLetivo"))
	if intAnoLetivo = "" then
		intAnoLetivo	= year(date)
	end if
	

%>
    
<div class="wrapper">

	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="../SCA/Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->

    <!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >
                <!-- General Unify Forms -->
            <form action="#" id="frm"  class="sky-form  panel-body">
                  <input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" >
                  <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                  <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                
                <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
                    <header class="panel-title" style="background:#95a5a6"><font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Relatório de Solicitação de Modulação</font></header>
                    
                    <fieldset>
                   	 <div class="row">
                        <section class="col col-2">
                            <label class="label">Ano Letivo</label>
                            <label class="input">
                            	<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onkeypress="return formataCampo(this,2,4)">
                            </label>
                        </section>

                      </div>
                      
  
  					  <div class="row">
                        <section class="col col-6">
                            <label class="label">Unidade:</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmbEmpresaGrupo.asp"-->
                            </label>
                        </section>
                      </div>
                      
                    </fieldset>  
                      
					 <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
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
			
			if (frm.txtAnoLetivo.value == "") {
				alert("O Ano Letivo deve ser informado !");
				frm.txtAnoLetivo.focus();
				return false;
			}
			if (frm.cmbEmpresaGrupo.value=="0") {
				alert("Unidade deve ser informada !");
				frm.cmbEmpresaGrupo.focus();
				return false;
			}
	
			frm.action = "Rel_solicitacao_modulacao_rel.asp";
			frm.submit();
			return true;	
		}
			
    </script>
    
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 