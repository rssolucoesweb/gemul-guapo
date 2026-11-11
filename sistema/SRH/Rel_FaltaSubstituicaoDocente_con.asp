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
    strPaginaTitulo = "Rel_FaltaSubstituicaoDocente_con.asp"
        
    strExecutarSubmitProfessor             		= "S"
    strExecutarSubmitModulacaoReferencia       	= "S"
    strPeriodoModulacaoHistorico                = "S"
    
    intCodProfessor	       		 	= Trim(Request("cmbProfessor"))
    strlpp 							= Trim(Request.Form("cmblpp"))
    strclasse               		= Trim(Request.Form("cmbTamanhoFonteArial"))
    strClassificacao				= request.Form("cmbClassificacao")
    intCodModulacaoReferencia 		= Trim(Request.form("cmbModulacaoReferencia"))
    
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Faltas e Substituições - Docentes</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               <form method="post" id="frm" action="#">
			
                    <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Op&ccedil;&atilde;o de Relat&oacute;rio</label>
                        <div class="col-lg-10">
                        <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">An&aacute;litico deFaltas e Substitui&ccedil;&otilde;es <br>
                        <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1">Sint&eacute;tico deFaltas e Substitui&ccedil;&otilde;es por Curso <br>
                        <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2">Sint&eacute;tico de Faltas e Substitui&ccedil;&otilde;es <br>
                        <input <% if strOpcaoRelatorio = "3" then response.Write("checked")%> name="optOpcao" type="radio" value="3">Anal&iacute;tico de Faltas &nbsp;&nbsp;&nbsp;&nbsp; <br>
                        <input <% if strOpcaoRelatorio = "4" then response.Write("checked")%> name="optOpcao" type="radio" value="4">Anal&iacute;tico de Substitui&ccedil;&otilde;es <br>
                        </div>
               		 </div>
                     
                      <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Per&iacute;odo</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_PeriodoModulacao.asp" -->- De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%>
                            <input name="txtDataI" type="hidden" id="txtDataI" class="text" size="11" value="<%=formataDataAP(strDataInicialModulacao)%>" maxlength="10">
                            <input name="txtDataF" type="hidden" id="txtDataF" class="text" size="11" value="<%=formataDataAP(strDataFinalModulacao)%>" maxlength="10">
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Colaborador</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmdProfessor.asp" -->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Linhas por P&aacute;gina</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbLinhaPorPagina.asp"-->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Tamanho da Fonte</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"-->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Classificar</label>
                        <div class="col-lg-10">
                        	<select name="cmbClassificacao" id="cmbClassificacao" onChange="submit()" class="form-control">
                            <option <%if strClassificacao = "D" then%> selected <%end if%> value="D">Data de Lançamento</option>
                            <option <%if strClassificacao = "C" then%> selected <%end if%> value="C">Colaborador Titular </option>
                            <option <%if strClassificacao = "S" then%> selected <%end if%> value="S">Colaborador Substituto</option>
                            <option <%if strClassificacao = "T" then%> selected <%end if%> value="T">Turma</option>
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
            var caminho;
            
            if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false && frm.optOpcao[2].checked==false && frm.optOpcao[3].checked==false && frm.optOpcao[4].checked==false) {
                alert("Opção de relatório deve ser informada !");
                frm.optOpcao[0].focus();
                return false;
            }	
            if (frm.optOpcao[0].checked) {
                caminho = "Rel_FaltaSubstituicaoDocenteAnalitico_rel.asp"
            }	
            if (frm.optOpcao[1].checked) {
                caminho = "Rel_FaltaSubstituicaoDocenteSintetico_rel.asp"
            }	
            if (frm.optOpcao[2].checked) {
                caminho = "Rel_FaltaSubstituicaoDocenteSinteticoGeral_rel.asp"
            }	
            if (frm.optOpcao[3].checked) {
                caminho = "Rel_FaltaDocenteAnalitico_rel.asp"
            }	
            if (frm.optOpcao[4].checked) {
                caminho = "Rel_SubstituicaoDocenteAnalitico_rel.asp"
            }	
    
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