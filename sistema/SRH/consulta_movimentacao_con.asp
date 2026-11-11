<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
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
    strPaginaTitulo = "consulta_movimentacao_con.asp"
	intCodEmpresaUsuario 			= Trim(Request.Form("cmdEmpresaUsuario"))
	if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = session("codEmpresa")
    strAno 			= Trim(Request.Form("txtAno"))
    strOpcao	 	= Trim(Request.Form("cmbOpcao"))
    if strOpcao = "" then strOpcao = "0"
        
    if strAno = "" then strAno = Session("strAnoLetivo")
    if strAno = "" then strAno = year(date)
    %>
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->     

                <form id="frm" name="frm" action="consulta_movimentacao_con.asp" class="sky-form  panel-body0" method="post">
                	
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Funcionário de outra secretaria</font></div>

                    <fieldset>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Unidade</label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmdEmpresaUsuario.asp" -->
                                </label>
                             </section>
                        </div>
                        
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Ano</label>
                              
                                <label class="input">
                                    <input name="txtAno" type="text" class="form-control" id="txtAno" size="5" maxlength="4" value="<%=strAno%>"  onkeypress="return formataCampo(this,2,10)" onchange="submit()">
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Opção de Consulta</label>
                              
                                <label class="input">
                                    <select name="cmbOpcao" class="form-control" id="cmbOpcao"  style="width:150pt" >
                                      <option value="0">Selecione...</option>
                                      <option value="R" <%if strOpcao = "R" then response.Write("selected") %>>REMOÇÃO/LOTAÇÃO</option>
                                      <option value="M" <%if strOpcao = "M" then response.Write("selected") %>>MODULAÇÃO</option>
                                      <option value="S" <%if strOpcao = "S" then response.Write("selected") %>>SUBSTITUIÇÃO</option>
                                   </select>
                                </label>
                                
                             </section>
                        </div>

                    </fieldset>
					
					<div class="margin-left-40">
                    <!--#include file="../../includes/inc_botoes_consulta.asp"-->
					</DIV>
                    <br>
                 </form>                
                
			</div>
         	<!-- Fecha o Form -->  
      </div>
   	   <%if strOpcao="R" and intCodEmpresaUsuario<>"0" then%>
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista Remoções/Lotações</h3>
          	</div>
      		<div class="panel-body">
            	<div class="table-responsive">
                    <%
					codEmpresaHistorico = intCodEmpresaUsuario
					%>
					<!--#include file="../includes/inc_ListaHistoricoLotacaoAlertas.asp" -->
                </div>
          	</div>                      
        </div>
        <!--End Table Bordered-->	
        <%end if%>
        
		<%if strOpcao="M" and intCodEmpresaUsuario<>"0" then%>
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista Modulação</h3>
          	</div>
      		<div class="panel-body">
            	<div class="table-responsive">
                    <%
					codEmpresaHistorico = intCodEmpresaUsuario
					%>
					<!--#include file="../includes/inc_ListaHistoricoModulacaoAlertas.asp" -->
                </div>
          	</div>                      
        </div>
        <!--End Table Bordered-->	
        <%end if%>
		<%if strOpcao="S" and intCodEmpresaUsuario<>"0" then%>
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista Substituições</h3>
          	</div>
      		<div class="panel-body">
            	<div class="table-responsive">
                    <%
					codEmpresaHistorico = intCodEmpresaUsuario
					%>
					<!--#include file="../includes/inc_ListaHistoricoSubstituicaoAlertas.asp" -->
                </div>
          	</div>                      
        </div>
        <!--End Table Bordered-->	
        <%end if%> 

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    
   	   
	<script>
        function resultadoConsulta(intCodigo){
            
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
        
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtNome.value == "") {
                alert("O nome deve ser informado!");
                frm.txtNome.focus();
                return false;
            }
            if (frm.txtSecretaria.value == "") {
                alert("A secretaria deve ser informada!");
                frm.txtSecretaria.focus();
                return false;
            }
            
            frm.action="usuarioExterno_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 