<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Avaliação Educacional</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
<%
	strPaginaTitulo 				= "Rel_Avaliacao_con.asp"
	strExecutarSubmit				= "S"
	
	intCodAvaliacaoInstitucional	= Trim(Request.Form("cmbAvaliacaoInstitucional"))
	strSemestre 					= session("strSemestre")
	strAnoLetivo 					= session("strAnoLetivo")
	intCodCategoria 				= Trim(Request.Form("cmbCategoria"))
	intCodTurma 					= Trim(Request.Form("cmbTurma"))
	intCodSituacaoAluno				= Trim(Request.Form("cmbSituacaoAluno"))
	
	if intCodAvaliacaoInstitucional = "" then intCodAvaliacaoInstitucional 	= "0"
	if intCodTurma 					= "" then intCodTurma 					= "0"
	
	if trim(intCodAvaliacaoInstitucional) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Tipo_Avaliacao, Tipo_Consulta"
		sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
		sql = sql & " Where Codigo = " & intCodAvaliacaoInstitucional
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodigo	 			= rs("Codigo")
			strDescricao			= rs("Descricao")
			intAnoLetivo			= rs("Ano_Letivo")
			intSemestre				= rs("Semestre")
			intTipoAvaliacao		= rs("Tipo_Avaliacao")
			intTipoConsulta			= rs("Tipo_Consulta")
		end if 
		rs.close
	end if 
%>

    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório Formulário da Avaliação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Avalia&ccedil;&atilde;o</label>
                        <!--#include file="../includes/inc_cmdAvaliacaoInstitucional.asp" -->
                    </div>
                    
                    <%
					' 2 - Não Curricular	-->> 2 - Colaborador
					if intTipoAvaliacao =  2 and intTipoConsulta = 2 then
					%>
                    
                    <div class="form-group">
                        <label class="form-label">Categoria</label>
                         <!--#include file="../includes/inc_cmdCategoria.asp" -->
                    </div>
                    
                    <%end if%>
                    
                    <%
					' 1 - Curricular	-->> 1 - Aluno 
					' Busca todos os alunos pela turma informada, gerendo uma avaliação por disciplina
					' 2 - Não Curricular	-->> 1 - Aluno 
					' Busca todos os alunos pela turma informada
					if intTipoAvaliacao =  1 and intTipoConsulta = 1 or intTipoAvaliacao =  2 and intTipoConsulta = 1 then
				
					%>

                    <div class="form-group">
                        <label class="form-label">Turma</label>
                        <!--#include file="../includes/inc_cmdTurma.asp"-->
                    </div>
                    
                    <%end if%>
                    
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
            
            if (frm.cmbAvaliacaoInstitucional.value == "0"){
                alert("A Avaliação deve ser informada.");
                frm.cmbAvaliacaoInstitucional.focus();
                return false;
            }
    
            frm.action = "Rel_Avaliacao_rel.asp";
            frm.submit();
            
            return true;	
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 