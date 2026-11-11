<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->4
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
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
        strPaginaTitulo 							= "Rel_FrequenciaMensal_con.asp"
        strExecutarSubmitModulacaoReferencia        = "S"
        strEmpresaGrupo_submit    = "S"
    
        intCodEmpresaGrupo							= Trim(Request.Form("cmbEmpresaGrupo"))
        strAno	 									= Trim(Request("txtAno"))
        intSemestre 								= Session("strSemestre")
        intCodModulacaoReferencia					= Trim(Request.Form("cmbModulacaoReferencia"))
        if intCodEmpresaGrupo = "" or intCodEmpresaGrupo = "0" then Session("CodEmpresa")
    
        if strAno = "" then strAno = session("strAnoLetivo")
        if intSemestre = "" then intSemestre = Session("strSemestre")
		
		' Inativa todas as Modulacoes Vencidas vencidas
		sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " set status = 'I' "
		sql = sql & " where convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
		cnn.execute sql
		
		' Inativa todas as substituicoes vencidas
		sql = " Update SRH_COLABORADOR_SUBSTITUTO "
		sql = sql & " set SITUACAO = 'I' "
		sql = sql & " where Cod_Grupo = " & Session("CodGrupo")
		sql = sql & " and convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
		sql = sql & " and SITUACAO = 'A' "
		cnn.execute sql
		
    %>
    <!--=== Content Part ===-->
	<form method="post" id="frm" action="#">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Frequência - Extrato Mensal</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    
                    <div class="form-group">
                        <label class="form-label">Unidade(s)</label>
                        <!--#include file="../includes/inc_cmbEmpresaGrupo.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                    	<input  name="txtAno" type="text" class="form-control" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)" onchange="submit()">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                    	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Refer&ecirc;ncia</label>
                    	<!--#include file="../includes/inc_PeriodoModulacao.asp" -->- De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%> 
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Filtrar apenas faltas n&atilde;o Justificadas?</label>
                    	<input type="checkbox" name="FiltroFaltas" value="S">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Op&ccedil;&atilde;o de Relat&oacute;rio</label>
                    	<input type="radio" name="tipoRel" id="radio" value="A">Administrativos&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="radio" name="tipoRel" id="radio" value="P">Professores&nbsp;&nbsp;&nbsp;
                        <input type="radio" name="tipoRel" id="radio" value="G">Gestores 
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
            var tipo = "";
            
            if (frm.tipoRel[0].checked == true) {
                tipo = "Rel_frequencia_administravos_rel.asp";
            }
            if (frm.tipoRel[1].checked == true) {
                tipo = "Rel_frequencia_professores_rel.asp";
            }
            if (frm.tipoRel[2].checked == true) {
                tipo = "Rel_frequencia_gestores_rel.asp";
            }
            if (tipo==""){
                alert("Opção do relatório deve ser selecionado!");
                return false;	
            }
            
            if (frm.cmbModulacaoReferencia.value == "0") {
                alert("A Referencia deve ser informada !");
                frm.cmbModulacaoReferencia.focus();
                return false;
            }
            
            frm.action = tipo;
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 