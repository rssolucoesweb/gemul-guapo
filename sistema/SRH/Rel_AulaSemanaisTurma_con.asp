<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
	<%
        strPaginaTitulo = "Rel_AulaSemanaisTurma_con.asp"
        
        strExecutarSubmitCurso	  = "S"
        strExecutarSubmitPeriodo  = "S"
        strExecutarSubmitTurno	  = "S"
        strExecutarSubmitTurma	  = "S"
        strExecutarSubmitGradeCurricular = "S"
    
        intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        if intSemestre = "" then 	intSemestre 			= session("strSemestre")
        
        intCodProfessor 	        = Trim(Request("cmbProfessor"))
        intCodColaboradorProfessor  = Trim(Request("cmbProfessor"))
        intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
        
        intCodigo	 			= Trim(Request.Form("txtCodigo"))
        intCodTurma 			= Trim(Request.Form("cmbTurma"))
        intCodCurso	 			= Trim(Request.Form("cmbCurso"))
        intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
        intCodTurno		 		= Trim(Request.Form("cmbTurno"))
        intCodGrade				= Trim(Request.Form("cmbGrade"))
        intCodTurma				= intCodTurmaProfessor
    
        if trim(intCodTurma) <> "" then
            sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
            sql = sql & " FROM SCA_TURMA "
            sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
            sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
            SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
            sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
            RS.OPEN SQL, CNN
            IF not RS.EOF THEN
                intCodCurso 	= rs("cod_curso")
                intCodPeriodo = rs("cod_periodo")
                intCodTurno = rs("cod_turno")
                intSemestre = rs("cod_Semestre")
            END IF
            rs.close
        end if
        
        strFiltroSerie 			= "0"
        strFiltroTurno 			= "0"
    
        if intCodCurso 		= "" then intCodCurso 		= "0"
        if intCodSerie 		= "" then intCodSerie 		= "0"
        if intCodTurno 		= "" then intCodTurno 		= "0"
        if intCodTurma 		= "" then intCodTurma 		= "0"
        if intCodProfessor = "" then intCodProfessor = "0"
        if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
        if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
%>
    
<div class="wrapper">

	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
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
                    
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Horário de Aula</font></div>

                    <fieldset>
                   	 <div class="row">
                        <section class="col col-2">
                            <label class="label">Ano Letivo</label>
                            <label class="input">
                            	<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onkeypress="return formataCampo(this,2,4)">
                            </label>
                        </section>

                        <section class="col col-10">
                            <label class="label">Semestre</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                            </label>
                        </section>
                      </div>
                    </fieldset>
                    
                    <fieldset>    
  					  <div class="row">
                        <section class="col col-12">
                            <label class="label">Professor</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdProfessor.asp" -->
                            </label>
                        </section>
                      </div>
                      
                      <div class="row">
                        <section class="col col-12">
                            <label class="label">ou</label>
                        </section>
                      </div>
  
  					  <div class="row">
                        <section class="col col-4">
                            <label class="label">Curso</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdCurso.asp"-->
                            </label>
                        </section>
                        <section class="col col-6">
                            <label class="label">Per&iacute;odo</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdPeriodo.asp"-->
                            </label>
                        </section>
                      </div>
   					  <div class="row">
                        <section class="col col-4">
                            <label class="label">Grade</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdGradeCurricular.asp" -->
                            </label>
                        </section>
                        <section class="col col-4">
                            <label class="label">Turno</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdTurno.asp"-->
                            </label>
                        </section>
                        <section class="col col-4">
                            <label class="label">Turma</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmdTurmaProfessor.asp"-->
                            </label>
                        </section>
                      </div>
  
					  <div class="row">
                        <section class="col col-12">
                            <label class="label">Opção de Relatório</label>
                            <div class="inline-group">
								<label class="radio"><input name="txtOpt" type="radio" class="radio" value="0" <% if strOpt = "" or strOpt = "0" then response.Write("checked")%>><i class="rounded-x"></i>Normal</label>
                                <label class="radio"><input name="txtOpt" type="radio" class="radio" value="1" <% if strOpt = "1" then response.Write("checked")%>><i class="rounded-x"></i>Extra</label>
                            </div>
                        </section>
           			  </div>
                      <div class="row">
						<section class="col col-12">
                            <label class="label">Opção de Relatório</label>
                            <div class="inline-group">
                                <label class="checkbox"><input type="checkbox" name="txtOmitirHorario" value="S"><i></i>Omitir Hor&aacute;rios?</label>
                            </div>
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
            var caminho;
    
            if (frm.txtAnoLetivo.value=="") {
                alert("Ano Letivo deve ser informado.");
                frm.txtAnoLetivo.focus();
                return false
            }
            if (frm.cmbSemestre.value=="0") {
                alert("Semestre deve ser informado.");
                frm.cmbSemestre.focus();
                return false
            }
    
            if (frm.cmbCurso.value == "0" && frm.cmbProfessor.value=="0"){
                alert("O Professor ou o curso devem ser informado!");
                frm.cmbCurso.focus();
                return false;
            }
    
            if (frm.txtOpt[0].checked==true) {
                caminho = 'Rel_AulaSemanaisTurma_rel.asp';
            }
            if (frm.txtOpt[1].checked==true) {
                caminho = 'Rel_AulaSemanaisTurmaExtra_rel.asp?';						
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