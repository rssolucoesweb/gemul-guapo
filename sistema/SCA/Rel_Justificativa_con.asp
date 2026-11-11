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
                <!-- General Unify Forms -->
                <form action="" id="frm"  class="sky-form  panel-body">
                <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
                    <header class="panel-title"><i class="fa fa-tasks"></i>&nbsp;Horário de Aula</header>
                    
                    <fieldset>
                   	 <div class="row">
                        <section class="col col-2">
                            <label class="label">Ano Letivo</label>
                            <label class="input">
                            	<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onkeypress="return formataCampo(this,2,4)">
                            </label>
                        </section>

                        <section class="col col-10">
                            <label class="label">Tipo de Falta</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmbJustificativaFaltas.asp" -->
                            </label>
                        </section>
                      </div>
                    </fieldset>
                    
                    <fieldset>    
  					  <div class="row">
                        <section class="col col-12">
                            <label class="label">Tipo de Colaborador</label>
                            <label class="input">
                            	<select name="cmbTipoColaborador" id="cmbTipoColaborador" style="width:300pt" class="combo" >
                                    <option  value="0">Selecione...</option>
                                    <option  value="F">Administrativo</option>
                                    <option  value="P">Professor</option>
                                </select>
                            </label>
                        </section>
                      </div>
                      
                      <div class="row">
                        <section class="col col-12">
                            <label class="label">Colaborador</label>
                            <label class="input">
                              <input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" >
                              <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                              <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                              <input name="txtNomeFuncionario" type="text" class="text" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">
                              <a  href="#" onClick="return abreConsultaColaborador('Colaborador_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a>
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
                            <label class="label">Unidade(s):</label>
                            <label class="input">
                            	<!--#include file="../includes/inc_cmbEmpresaGrupo.asp"-->
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
			if (frm.txtCodFuncionario.value == "" && frm.cmbEmpresaGrupo.value=="0") {
				alert("O colaborador ou a unidade deve ser informada !");
				frm.cmbEmpresaGrupo.focus();
				return false;
			}
	
			frm.action = "Rel_Justificativa_rel.asp";
			frm.submit();
			return true;	
		}
			
		function abreConsultaColaborador(caminho){
			window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
    </script>
    
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 