<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "Rel_MapaTurmas_con.asp"
    
        strExecutarSubmitCurso	  = "S"
        strExecutarSubmitPeriodo  = "S"
        strExecutarSubmitSemestre = "S"
        strExecutarSubmitTurno	  = "S"
        strEmpresaGrupo_submit    = "S"
        
    
        intCodEmpresaGrupo		    = Trim(Request.Form("cmbEmpresaGrupo"))
        intCodEmpresaGrupoUsuario	= Trim(Request.Form("cmdEmpresaGrupoUsuario"))
        intCodCurso	 				= Trim(Request.Form("cmbTodosCursoEmpresas"))
        intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
        intSemestre 				= Trim(Request.Form("cmbSemestre"))
        intCodGrade					= Trim(Request.Form("cmbGrade"))
        intCodTurno		 			= Trim(Request.Form("cmbTurno"))
        strSexo						= Trim(Request.Form("cmbSexo"))
        strIntervaloIdadeInicial 	= Trim(Request.Form("txtIntervaloIdadeInicial"))
        strIntervaloIdadeFinal  = Trim(Request.Form("txtIntervaloIdadeFinal"))
    
        strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        if intSemestre = "" then 	intSemestre  = session("strSemestre")
    
        strFiltroSerie = "0"
        strFiltroTurno = "0"
    
        if intCodComp = "" then intCodComp = "0"
        if intCodSerie = "" then intCodSerie = "0"
        if intCodTurno = "" then intCodTurno = "0"
        if intCodSemestre = "" then intCodSemestre = "0"
    
        'controla os botões
        strDesabilitaIncluir = "disabled"
        strDesabilitaExcluir = "disabled"
        strDesabilitaAlterar = ""
        strDesabilitaLimpar = ""

%>
    <form method="post" id="frm" action="#">
    <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>MAPA DE TURMAS - Modulação </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     

            <div class="panel-body">                                                        
               		
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Unidade</label>
                        <div class="col-lg-10">
                            <!--#include file="../includes/inc_cmbEmpresaGrupo.asp"-->
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-2 control-label">Ano Letivo</label>
                        <div class="col-lg-10">
                            <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo"  value="<%=strAnoLetivo%>" size="5" maxlength="4" onkeypress="return formataCampo(this,2,4)">
                        </div>
                    </div>
                    
                    
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Semestre</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                        </div>
               		 </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Faixa de Idade</label>
                        <div class="col-lg-10">
                        	<input  name="txtIntervaloIdadeInicial" type="text" class="text" id="txtIntervaloIdadeInicial" value="<%=strIntervaloIdadeInicial%>" size="3" maxlength="3" onkeypress="return formataCampo(this,2,3)">
                            a
                              <input  name="txtIntervaloIdadeFinal" type="text" class="text" id="txtIntervaloIdadeFinal" value="<%=strIntervaloIdadeFinal%>" size="3" maxlength="3" onkeypress="return formataCampo(this,2,3)">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                     	<label class="form-label">Sexo</label>
                              <!--#include file="../includes/inc_cmdSexo.asp" -->
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="form-label">Filtro</label>
                        	<%
							if request.Form("txtHiddenStatus") <> "" then
							   strDesabilitaSerie = "disabled"
							end if
						 %>
                         <input <% if strOpcaoRelatorio = "T" then response.Write("checked")%> name="optOpcao" type="radio" value="T"> Todas Turmas &nbsp;&nbsp;&nbsp;&nbsp; <br>
                        <input <% if strOpcaoRelatorio = "A" then response.Write("checked")%> name="optOpcao" type="radio" value="A">Somente Turmas Ativas (Alunos vinculados)
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="form-label">Situa&ccedil;&atilde;o</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdSituacaoAluno.asp"-->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                     	<label for="inputEmail1" class="form-label"><br>
                     	  <br>
               	      Op&ccedil;&otilde;es</label>
                         <div class="col-lg-10">
                             <input type="checkbox" name="PromoverAnoLetivo" value="S"> Promover ano letivo
                             <input type="checkbox" name="SomentoIncosistecia" value="S"> Somente inconsist&ecirc;ncia
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
    <!--/container-->	
    </form>	
	<script>
        function gerar(){
        
            var frm = document.getElementById("frm");
    
            if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false){
                alert("Selecione o filtro para relatório.");
                return false;
            }
            var filtro;
            
            if (frm.optOpcao[0].checked==true) filtro = "T"
            if (frm.optOpcao[1].checked==true) filtro = "A"
            
            frm.action = "Rel_MapaTurmasModulacao_rel.asp?f="+filtro;
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 