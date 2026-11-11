<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
        strExecutarSubmitSemestre = "S"
        strExecutarSubmitTipoEmpresa = "S"
    
        strPaginaTitulo 			= "ModulacaoTurmasExclusao_cad.asp"
        intCodEmpresa				= session("codEmpresa")
    
        if trim(request("txtAnoLetivo")) = "" then 
            strAnoLetivo = session("strAnoLetivo")
        else
            strAnoLetivo = request("txtAnoLetivo")
        end if
    
        if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
            intSemestre = session("strSemestre")
        else
            intSemestre  = Trim(Request.Form("cmbSemestre"))
        end if
        intCodTipoEmpresa		= Trim(Request.Form("cmbTipoEmpresa"))
        if intCodTipoEmpresa = "" then intCodTipoEmpresa = "99999"
        if intCodTipoEmpresa = "9" then intCodTipoEmpresa = "99999"
        
        strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    %>
    <!--=== Content Part ===-->
    <form id="frm" method="post">

    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Inicializar Modulação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                     <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurma%>" maxlength="10">
          			<input name="txtCodigoItem" type="hidden" id="txtCodigoItem" class="text" size="10" value="<%=intCodItem%>" maxlength="10">
                    
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                        <input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                    	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tipo Unidade</label>
                    	<!--#include file="../includes/inc_cmbTipoEmpresa.asp"-->
                    </div>
    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Turmas</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="6%" bgcolor="#95A5A6">Unidade</th>
                          <th width="41%" bgcolor="#95A5A6">Nome da Turma</th>
                          <th width="10%" bgcolor="#95A5A6">Ano Letivo</th>
                          <th width="11%" bgcolor="#95A5A6">Semestre Letivo</th>
                          <th width="6%" bgcolor="#95A5A6">Turno</th>
                          <th width="22%" bgcolor="#95A5A6">Func&atilde;o(&otilde;es) e Vagas Moduladas</th>
                          <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT EMP.RAZAOSOCIAL, T.Cod_Turma, T.nomeTurma, T.TurmaAluno, T.AnoLetivo, T.Cod_Semestre, TU.Desc_turno, T.Cod_GradeCurricular "
					sql = sql & " FROM SCA_TURMA T "
					sql = sql & " INNER JOIN SEG_EMPRESA EMP ON EMP.CODIGO = T.COD_EMPRESA"
					sql = sql & " LEFT JOIN SCA_TURNO TU ON TU.cod_turno = T.cod_turno"
					sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular "
					sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo"
					sql = sql & " where T.AnoLetivo = " & strAnoLetivo
					sql = sql & " and 	T.Cod_Semestre = " & intSemestre
					sql = sql & " and 	ISNULL(T.cod_turma_grupo,'0')=0 "
					sql = sql & " and 	EMP.CodTipoEmpresa = " & intCodTipoEmpresa
					sql = sql & " Order by EMP.RAZAOSOCIAL, T.AnoLetivo, T.nomeTurma"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
					ContaPrimeiraLinha = 0
                    while not rs.eof
                        cont = cont + 1
						strSituacao = "<strong><font color='#FF0000'>Sem Fechamento</font></strong>"
						strSituacao = "<strong><font color='#FF0000'>Inativa</font></strong>"
						
                    	%>
                        <tr>
                            <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                            <td><strong><%=trim(rs("NomeTurma"))%></strong>&nbsp;&nbsp;&nbsp;<%=trim(rs("TurmaAluno"))%></td>
                            <td><%=trim(rs("AnoLetivo"))%></td>
                            <td><%=trim(rs("Cod_Semestre"))%></td>
                            <td><%=trim(rs("Desc_turno"))%></td>
                            <td>
                            <%
						sql = " SELECT FC.DESC_FUNCAO, TMF.Total_Vaga_Funcao "
						sql = sql & " FROM SRH_TURMA_MODULACAO_FUNCAO TMF " 
						sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
						sql = sql & " where TMF.Cod_turma = " & rs("Cod_Turma")
						sql = sql & " Order by FC.DESC_FUNCAO "
						rsaux.open sql, cnn
						if rsaux.eof = false then
							while not rsaux.eof
							    response.write "<br><strong><font color='#FF0000'><li>" & rsaux("DESC_FUNCAO") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> " & rsaux("Total_Vaga_Funcao") & " Vaga(s)<li></font></strong>"
								rsaux.movenext
							wend
						  end if
						  rsaux.close
						  
						  sql = " SELECT SCA_DISCIPLINA.DESC_Disciplina, SRH_FUNCAOCOLABORADOR.DESC_FUNCAO, SCA_GRADECURRICULARDISCIPLINA.Total_Vaga_Funcao "
						  sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA " 
						  sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
						  sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR ON SRH_FUNCAOCOLABORADOR.Cod_Funcao = SCA_GRADECURRICULARDISCIPLINA.Cod_Funcao "
				          sql = sql & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " & rs("Cod_GradeCurricular")
						  sql = sql & " and ISNULL(SCA_GRADECURRICULARDISCIPLINA.Cod_Funcao,'0')<> '0' "
				          sql = sql & " order by SCA_DISCIPLINA.DESC_Disciplina" 
				    	  rsaux.open sql, cnn		
						  if not rsaux.eof then
						  	  while not rsaux.eof 
							       response.write "<br><strong><font color='#FF0000'><li>" & rsaux("DESC_FUNCAO") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> " & rsaux("Total_Vaga_Funcao") & " Aula(s)<li></font></strong>"
								   rsaux.movenext
							  wend 
					       end if
						   rsaux.close
						  
					  %>
                            </td>
                            
                            
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("Cod_Turma")%>')" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    <tr>
                        <td colspan="7">Total Registros : <%=cont%></td>
                    </tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
    
        function resultadoConsulta(intCodigo){
            
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.action = "ModulacaoTurmas_cad.asp";
            frm.submit();
        }
    
        function resultadoConsultaItem(intCodigoItem){
            
            var frm = document.getElementById("frm");
            frm.txtintCodigoItem.value=intintCodigoItem;
            frm.action = "ModulacaoTurmas_cad.asp";
            frm.submit();
        }
        
        function salvar(acao){
            
            if (frm.txtAnoLetivo.value == "") {
                alert("O Ano Letivo deve ser informado !");
                frm.txtAnoLetivo.focus();
                return false;
            }
    
            if (frm.cmbSemestre.value == "0") {
                alert("O Semestre deve ser informado !");
                frm.cmbSemestre.focus();
                return false;
            }
    
            if (frm.cmbTipoEmpresa.value == "0") {
                alert("O Tipo de Unidade deve ser informado !");
                frm.cmbTipoEmpresa.focus();
                return false;
            }
    
            frm.action="ModulacaoTurmasExclusao_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
        
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 