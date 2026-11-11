<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
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
            intCodGrupo = session("codGrupo")
            strPaginaTitulo 			= "Rel_Diretrizes_con.asp"
            intCodEmpresa				= session("codEmpresa")
            intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
            intCodFuncao 				= Trim(Request.Form("cmbFuncao"))
            strTipoModulacao 			= Trim(Request.Form("cmbTipoModulacao"))
            strAno	 					= Trim(Request("txtAno"))
            intCodCurso 				= Trim(Request.Form("cmbCurso"))
            if Trim(Request("cmbSemestre")) <> "0" then
                intSemestre 		= Trim(Request("cmbSemestre"))
            else	
                intSemestre 		=  Session("strSemestre")
            end if	
            if strAno = "" then strAno = session("strAnoLetivo")
            if intSemestre = "" then intSemestre = Session("strSemestre")
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Diretrizes Gerais</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    <form method="post" id="frm" action="#">
                    <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
			 
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Ano</label>
                        <div class="col-lg-10">
                        	<input  name="txtAno" type="text" class="form-control" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" onChange="submit()">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Semestre</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Unidade</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Curso</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdCurso.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Situa&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	 <select name="cmbSituacao" id="cmbSituacao" class="form-control">
                           <option <%if strSituacao = "T" then%> selected <%end if%> value="T">Total</option>
                           <option <%if strSituacao = "D" then%> selected <%end if%> value="D">Deficit</option>
                           <option <%if strSituacao = "L" then%> selected <%end if%> value="L">Lotado</option>
                           <option <%if strSituacao = "E" then%> selected <%end if%> value="E">Execedente</option>
                         </select>
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Fun&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbFuncao.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Tipo</label>
                        <div class="col-lg-10">
                        	<select name="cmbTipoModulacao" id="cmbTipoModulacao" class="form-control">
                             <option value="0">Selecione...</option>
                               <option <%if strTipoModulacao = "I" then%> selected <%end if%> value="I">Interdisciplinar</option>
                               <option <%if strTipoModulacao = "D" then%> selected <%end if%> value="D">Disciplinar</option>
                             </select>
                        </div>
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
            
            var frm = document.getElementById("frm");
            
            frm.action = "Rel_Diretrizes_rel.asp";
            frm.submit();
            return true;	
        }	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 