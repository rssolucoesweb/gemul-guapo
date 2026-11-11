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
        strPaginaTitulo 		  = "ProjetoSociais_Vincula_Aluno_cad.asp"
        strPagina				  = "ProjetoSociais_Vincula_Aluno_cad.asp"
        strExecutarSubmitCurso	  = "S"
        strExecutarSubmitPeriodo  = "S"
        strExecutarSubmitSemestre = "S"
        strExecutarSubmitTurno	  = "S"
        strExecutarSubmitTurma	  = "S"
        
        intCodTurma 			= Trim(Request.Form("cmbTurma"))
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        intAno		 			= Trim(Request.Form("txtAno"))
        intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        intCodProjetoSociais 	= Trim(Request.Form("cmbProjetoSociais"))
        
        strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        if intSemestre = "" then 	intSemestre  = session("strSemestre")
    
        if intCodTurma = "" then intCodTurma = "0"
        if intCodSemestre = "" then intCodSemestre = "0"
        
        if intCodTurma <> "0" then
        
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
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if 
    %>

     <!--=== Content Part ===-->
    <form id="frm" method="post">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Projetos Sociais</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                    
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                        <input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                        <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Turma</label>
                        <!--#include file="../includes/inc_cmdTurma.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Projetos Sociais</label>
                        <!--#include file="../includes/inc_cmdProjetoSociais.asp"-->
                    </div>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
               
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%
		if intCodTurma    = "" then intCodTurma="0"
		if intCodPeriodo = "" then intCodPeriodo="0"
		if intCodTurma<>"0" then%>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Alunos</h3>
            </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></th>
                          <th width="10%" bgcolor="#95A5A6">Matr&iacute;cula</th>
                          <th width="35%" bgcolor="#95A5A6">Nome</th>
                          <th width="18%" bgcolor="#95A5A6">Turma</th>
                          <th width="9%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                          <th width="21%" bgcolor="#95A5A6">N&uacute;mero do Benef&iacute;cio</th>
                          <th width="4%" bgcolor="#95A5A6">A&ccedil;&atilde;o</th>
                      </tr>
                    </thead>
                    <%
                    cont =0
					sql = "SELECT  SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_SITUACAOALUNO.DESC_SITUACAOALUNO"
					sql = sql & " FROM SCA_ALUNO_TURMA "
					sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
					sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
					sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
					sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
					sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.Cod_SituacaoAluno and SCA_SITUACAOALUNO.cod_empresa = SCA_ALUNO.cod_empresa"				
					sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
					sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
					sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
					sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
					sql = sql & " and 	SCA_ALUNO_TURMA.Semestre IN (" & intSemestre & ")"
					if intCodCurso <> "0" then
						sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
					end if
					if intCodPeriodo <> "0" then
						sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
					end if
					if intCodTurno <> "0" then
						sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
					end if
					if intCodTurma <> "0" then
						sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
					end if
					sql = sql & " and SCA_SITUACAOALUNO.DESC_SITUACAOALUNO = 'ATIVO'"
					sql = sql & " Order By SCA_TURMA.COD_TURMA, SCA_ALUNO.NOMEALUNO"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                       	strMarca  				= ""
						strBeneficio			= ""
						strCodigoAluno        	= rs("codigo")
						strMatricula		  	= rs("MATRICULA")
													
				   
						sql = "SELECT cod_aluno, NumeroBeneficio "
						sql = sql & " FROM SCA_PROJETOSOCIAIS_VINCULO"
						sql = sql & " WHERE cod_aluno = " & strCodigoAluno
						sql = sql & " and CodProjetoSociais = " & intCodProjetoSociais
						sql = sql & " and cod_empresa = " & session("CodEmpresa")
						RsAux.open sql, cnn
						 
						if RsAux.eof = false then
							strMarca = "checked"
							strBeneficio = RsAux("NumeroBeneficio")
						end if
						RsAux.close
                    %>
                    <tbody>
                        <tr>
                            <td><input type="checkbox" id="chkAluno" name="chkAluno" <%=strMarca%> value="<%=rs("codigo")%>"></td>
                            <td><%=strMatricula%></td>
                            <td><%=rs("NOMEALUNO")%></td>
                            <td><%=rs("NOMETURMA")%></td>
                            <td><%=rs("DESC_SITUACAOALUNO")%></td>
                            <td><input  name="txtBeneficio<%=strCodigoAluno%>" type="text" class="form-control" id="txtBeneficio<%=strCodigoAluno%>" value="<%=strBeneficio%>" onKeyPress="return formataCampo(this, 2, 20)" size="20" maxlength="20"></td>
                            <td align="center" ><button class="btn-u btn-u-sea" onClick="Excluir('E','<%=strCodigoAluno%>')" type="button"><i class="fa fa-trash-o"></i></button>
                            </td> 
                        </tr>
                    </tbody>
                    <%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
                </table>
                </div>
            </div>                      
        </div>
        <%end if%>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
     </form>
    <!--/container-->		
	<script>
    
        function marcaTodos(valor){
            
            var form = window.document.forms[0];
            var i;
            for (var i = 0; i < form.elements.length; i++) {
                //verifica todos os checkbox
                if (form.elements[i].type == "checkbox"){
                    //verifica se o checkbox está marcado
                    form.elements[i].checked=valor;
                }
            }
        }
        
        function Excluir(acao, CodAluno){
            
            var frm = document.getElementById("frm");
            var men = 'ATENÇÃO: Deseja realmente excluir este Vinculo do Projeto Social?\n '
            if (confirm(men)) {
                    
                frm.action="ProjetoSociais_Vincula_Aluno_cod.asp?acao=" + acao + "&CodAluno=" + CodAluno ;
                frm.submit();
                return true;
    
            } else {
                return false;
            }
        }
    
        
        function salvar(acao){
            
            var form = window.document.forms[0];
            var frm = document.getElementById("frm");
            
            var intContMarcado=0;
            var strAlunos='';
            var intAnoSession = <%=session("strAnoLetivo")%>;
            
            if (frm.txtAnoLetivo.value=="") {
                alert("Ano Letivo deve ser informado.");
                frm.txtAnoLetivo.focus();
                return false
            }
            
            if (frm.txtAnoLetivo.value>intAnoSession) {
                alert("Ano/Semestre letivo não permitido.");
                frm.txtAnoLetivo.focus();
                return false
            }
        
            if (frm.cmbSemestre.value == 0){
                alert("O Semestre deve ser informado!");
                frm.cmbSemestre.focus();
                return false;
            }
            
            if (frm.cmbTurma.value == 0){
                alert("A turma deve ser informada!");
                frm.cmbTurma.focus();
                return false;
            }		
            
            if (frm.cmbProjetoSociais.value == 0){
                alert("A Projeto Social deve ser informado!");
                frm.cmbProjetoSociais.focus();
                return false;
            }
                    
            //*****verifica se um aluno foi selecionado
            intContMarcado=0;
            for (var i = 0; i < form.elements.length; i++) {
                //verifica todos os checkbox
                if (form.elements[i].type == "checkbox"){
                    if (form.elements[i].name == "chkAluno"){
                        //verifica se o checkbox está marcado
                        if (form.elements[i].checked){
                            intContMarcado = intContMarcado + 1;
                        }
                    }
                }
            }	
            
            if (intContMarcado==0){
                alert("O(s) aluno(s) deve(m) ser informado(s)!");
                return false;
            }
            
            frm.action= "ProjetoSociais_Vincula_Aluno_cod.asp?acao=" + acao;
            frm.submit();
            return true;
                
        }
    </script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 