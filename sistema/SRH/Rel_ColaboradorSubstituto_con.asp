<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<style>
.alert-info {
   font-size:11px !important;
}
</style>
<script src="../../js/js_funcoes_gerais.js"></script>  
	<%
        strPaginaTitulo 			= "Rel_ColaboradorSubstituto_con.asp"
        intCodFuncao 	   		 	= TRIM(Request.Form("cmbFuncao"))
        intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
        intCodTurno 	   		 	= TRIM(Request.Form("cmbTurnoRH"))
        intAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
        strExecutarSubmitModulacaoReferencia = "S"
        if intAnoLetivo = "" then intAnoLetivo = session("strAnoLetivo")
        intCodModulacaoReferencia		= Trim(Request.Form("cmbModulacaoReferencia"))
        strSituacao						= Trim(Request.Form("cmbSituacao"))
		
	%>

    
<div class="wrapper">

	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
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
                    
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Colaborador Substituto</font></div>

                    <fieldset>
                   	 <div class="row">
                        <section class="col col-12">
                            <label class="label">Ano Letivo</label>
                            <label class="input">
                            	<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onkeypress="return formataCampo(this,2,4)">
                            </label>
                        </section>

                      </div>
  					  <div class="row">
                        <section class="col col-12">
                            <label class="label">Refer&ecirc;ncia</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_PeriodoModulacao.asp" --> - De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%>
                            </label>
                        </section>
                      </div>
                      <div class="row">
                        <section class="col col-4">
                            <label class="form-label">Per&iacute;odo inicial</label>
                            <label class="input">
                            <input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onblur="return validaData(this);" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicialModulacao%>" title="Click aqui para visualizar o calend&aacute;rio">
                    		</label>
                        </section>
                         <section class="col col-4">
                            <label class="form-label">Per&iacute;odo final</label>
                            <label class="input">
                            <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onblur="return validaData(this);" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinalModulacao%>" title="Click aqui para visualizar o calend&aacute;rio">
                    		</label>
                        </section>
                         <section class="col col-4">
                        
                        </section>
                      </div>
  
  					  <div class="row">
                        <section class="col col-12">
                            <label class="label">Unidade</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdEmpresaUsuario.asp" -->
                            </label>
                        </section>
                      </div>
   					  <div class="row">
                        <section class="col col-4">
                            <label class="label">Turno</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdTurno.asp"-->
                            </label>

                        </section>
                        <section class="col col-6">
                            <label class="label">Função</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmbFuncao.asp" -->
                            </label>

                        </section>
                      </div>
                      <div class="row">
                        <section class="col col-12">
                            <label class="label">Situação</label>
                            <label class="input">
                            	<select name="cmbSituacao" id="cmbSituacao"  style="width:100pt"  class="form-control">
                                  <option value="0" <%if strSituacao = "0" then response.Write("selected") %>>Todas</option>
                                  <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                                  <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
                                </select>
                            </label>
                        </section>
                      </div>
                    </fieldset>    
					 <legend><label class="alert-info">&nbsp;&raquo;&nbsp;Melhor visualização do relatorio em <strong>paisagem</strong></label>&nbsp;&nbsp;&nbsp;</legend>
                     
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
    
            frm.action = "Rel_ColaboradorSubstituto_rel.asp";
            frm.submit();
            return true;	
        }
    
    </script>
    
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 