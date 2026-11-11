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
        strPaginaTitulo = "Rel_Etiquetas_con.asp"
        
        strOpcaoRelatorio			= Trim(Request.Form("optOpcao"))
        intCodModeloEtiqueta		= Trim(Request.Form("cmbModeloEtiqueta"))
        strSituacao					= Trim(Request.Form("cmbSituacao"))	
        intCodCategoria				= Trim(Request.Form("cmbCategoria"))	
        intCodDepartamento			= Trim(Request.Form("cmbDepartamento"))
        strClassificacao			= request.Form("cmbClassificacao")
        intCodCargo 	    		= TRIM(Request.Form("cmbCargo"))
        intCodFuncao 	   		 	= TRIM(Request.Form("cmbFuncao"))
        intCodGrauInstrucao			= Trim(Request.Form("cmbGrauInstrucao"))	
        intcodLotacao 	    		= TRIM(Request.Form("cmbLotacao"))
        intCodFormaNomeacao 		= TRIM(Request.Form("cmbFormaNomeacao"))
        intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
    
        campo1			= Trim(Request.Form("cmbCampo1"))
        campo2			= Trim(Request.Form("cmbCampo2"))
        campo3			= Trim(Request.Form("cmbCampo3"))
        campo4			= Trim(Request.Form("cmbCampo4"))
        campo5			= Trim(Request.Form("cmbCampo5"))
        campo6			= Trim(Request.Form("cmbCampo6"))
        
    %>
    <!--=== Content Part ===-->
    <form method="post" id="frm" action="#">
    <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">

    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Etiquetas Mala Direta</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        

                    <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Op&ccedil;&atilde;o de Relat&oacute;rio</label>
                        <div class="col-lg-10">
                        	 <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">Todos<br>
                             <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1">Aniversariantes do M&ecirc;s:
							 <!--#include file="../includes/inc_cmbMes.asp"-->&nbsp;apartir de
							 <!--#include file="../includes/inc_cmbIdade.asp"-->&nbsp;anos<br>
                            <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2">Documenta&ccedil;&otilde;es Pendentes &nbsp;&nbsp;
                        </div>
               		 </div>
                     
                     
                     <div class="headline"><h2>Configurando Filtros</h2></div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Cargo</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbCargo.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Fun&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbFuncao.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Grau de Instru&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdGrauInstrucaoColaborador.asp" -->
                        </div>
               		 </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Lota&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbLotacao.asp" -->
                        </div>
               		 </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Nomea&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbFormaNomeacao.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Categoria</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdCategoria.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Departamento</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdDepartamento.asp" -->
                        </div>
               		 </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Situa&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdSituacao.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Modelo da Etiqueta</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbModeloEtiqueta.asp"-->
                        </div>
               		 </div>
                     
                     <%for i=1 to 6%>
                     	<div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label"><%=i%>&ordm; Campo</label>
                        <div class="col-lg-10">
                        	<select name="cmbCampo<%=i%>" class="form-control" id="cmbCampo<%=i%>"  style="width:100pt" >
                            <option value="" >Selecione...</option>
                            <option value="1" >Código Funcional</option>
                            <option value="2" >Nome</option>
                            <option value="3" >Fone Residencial</option>
                            <option value="4" >Fone Comercial</option>
                            <option value="5" >Data Admissão</option>
                            <option value="6" >Data Afastamento</option>
                            <option value="7" >Email</option>
                            <option value="8" >Naturalidade</option>
                            <option value="9">Endereço</option>
                            <option value="10">Bairro - Cep</option>
                            <option value="11" >Cidade - UF</option>
                          </select>  
                        </div>
               		 </div>
                     <%next%>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Classificar</label>
                        <div class="col-lg-10">
                        	<select name="cmbClassificacao" id="cmbClassificacao" class="form-control">
                           <option <%if strClassificacao = "COD" then%> selected <%end if%> value="COD">Codigo</option>
                           <option <%if strClassificacao = "MAT" then%> selected <%end if%> value="MAT">Codigo Funcional</option>
                           <option <%if strClassificacao = "NOM" then%> selected <%end if%> value="NOM">Nome</option>
                           <option <%if strClassificacao = "BAI" then%> selected <%end if%> value="BAI">Bairro</option>
                           <option <%if strClassificacao = "CID" then%> selected <%end if%> value="CID">Cidade</option>
                         </select>
                        </div>
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
            
            if (frm.cmbModeloEtiqueta.value=='0'){
                alert('Modelo da etiqueta deve ser informada.');
                frm.cmbModeloEtiqueta.focus();
                return false
            }
    
            frm.action = "Rel_Etiquetas_rel.asp";
            frm.submit();
            return true;	
        }	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 