<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Matrícula</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		strExecutarSubmitCurso	  = "S"
		strExecutarSubmitPeriodo  = "S"
		strExecutarSubmitSemestre = "S"
	
		intCodEmpresaUsuario 	= Trim(Request("cmdEmpresaUsuario"))
		strAnoLetivo 			= Trim(Request("txtAnoLetivo")) 
		intSemestre 			= Trim(Request.Form("cmbSemestre"))
		intCodTurma 			= Trim(Request.Form("txtCodigo"))
		strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
		intCodCurso	 			= Trim(Request.Form("cmbCurso"))
		intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
		intCodGrade				= Trim(Request.Form("cmbGrade"))
	
		intCodTurno		 		= Trim(Request.Form("cmbTurno"))
		intCodPlano				= Trim(Request.Form("cmbPlano"))
		strSala		 			= Trim(Request.Form("txtSala"))
		intAno		 			= Trim(Request.Form("txtAno"))
		intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
		strAtualizaVagasOcupadas= Trim(Request.Form("AtualizaVagasOcupadas"))
		
		ckAtualizaVagasOcupadas = ""
		if strAtualizaVagasOcupadas = "S" then ckAtualizaVagasOcupadas = " checked "	
		if intSemestre = "" then 	intSemestre  = session("strSemestre")	
		if strAnoLetivo = "" then 	
			strAnoLetivo = session("strAnoLetivo")
			if session("strAnoLetivo")<=2013 then 	strAnoLetivo = session("strAnoLetivo") + 1
		end if
			
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	%>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Turmas Vagas Matricula</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Unidade:</label>
                           <!--#include file="../includes/inc_cmdEmpresaUsuario.asp" -->
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Ano Letivo:</label>
                         <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" style="width:50pt" value="<%=strAnoLetivo%>" size="5" maxlength="5">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Semestre:</label>
                         <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    <legend></legend>
                    <input type="button" name="BtnAtualiza" style="cursor:hand"  value=" Atualiza Vagas e Reserva do Ano Corrente "  class="btn btn-u float-shadow" onClick="AtualizaPeriodico()">
                    <input disabled type="button" name="BtnAtualizainicial" style="cursor:hand"  value="Atualiza Vagas e Reserva do Ano Anterior"  class="btn btn-u btn-u-blue float-shadow" onClick="AtualizaInicial()">
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Vagas</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="7%" bgcolor="#95A5A6"><div align="center">Marca&ccedil;&atilde;o para confer&ecirc;ncia</div></th>
                                    <th width="6%" bgcolor="#95A5A6"><div align="center">Ano Letivo</div></th>
                                    <th width="5%" bgcolor="#95A5A6"><div align="center">Sala</div></th>
                                  <th width="23%" bgcolor="#95A5A6" align="center">Curso</th>
                                  <th width="13%" bgcolor="#95A5A6" align="center">Per&iacute;odo</th>
                                    <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Turma</div></th>
                                    <th width="7%" bgcolor="#95A5A6" align="center"><div align="center">Cap.<br>
                                    da Sala</div></th>
                                    <th width="8%" bgcolor="#95A5A6" align="center"><div align="center">Vagas <br>
                                    Preenchidas</div></th>
                                    <th width="7%" bgcolor="#95A5A6" align="center"><div align="center">Vagas <br>
                                    Existentes</div></th>
                                    <th width="7%" bgcolor="#95A5A6" align="center"><div align="center">Vagas <br>
                                    Reservadas</div></th>
                                    <th width="7%" bgcolor="#95A5A6" align="center"><div align="center">Vagas <br>
                                    Liberadas</div></th>
                                    <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Turno</div></th>
                                </tr>
                            </thead>
                            <%
							cont =0
							if intSemestre = "" then intSemestre = 0
							if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = 0
							
							sql = "SELECT T.Cod_Turma, T.Cod_GradeCurricular, c.descricao as curso, pp.descricao as periodo, T.Cod_Semestre, T.Cod_Turno, tt.Desc_Turno, isnull(T.Capacidade,'0') as Capacidade,"
							sql = sql & " T.Cod_PlanoPagamento, T.Cod_ContaCorrente, T.nomeTurma, T.Sala, T.Ano, T.AnoLetivo, T.TurmaAluno, isnull(T.VagasMatriculas,0) as VagasMatriculas, isnull(T.VagasMatriculasUtilizadas,0) as VagasMatriculasUtilizadas, "
							sql = sql & " isnull(T.VagasReservadas,0) as VagasReservadas" 
							sql = sql & " FROM SCA_TURMA T"
							sql = sql & " Inner join sca_Turno tt on TT.Cod_Turno = T.Cod_Turno "
							sql = sql & " inner join SCA_GRADECURRICULAR G on G.Cod_GradeCurricular = T.Cod_GradeCurricular and G.cod_empresa = t.cod_empresa"
							sql = sql & " inner join SCA_PERIODO pp on pp.Cod_Periodo = g.Cod_Periodo and pp.cod_empresa = G.cod_empresa"
							sql = sql & " inner join SCA_CURSO c on c.Cod_curso = pp.cod_curso"
							
							sql = sql & " where T.Cod_empresa = " & intCodEmpresaUsuario		
							
							if strAnoLetivo <> "" then
							sql = sql & " and T.AnoLetivo = " & strAnoLetivo
							end if
							
							if intSemestre <> "0" then
							sql = sql & " and  T.Cod_Semestre = " & intSemestre
							end if
							
							sql = sql & " Order by t.AnoLetivo, c.descricao, pp.descricao, t.Nometurma"
							rs.open sql, cnn
							
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
								
								strVagasNaoAutorizadas = cint(rs("Capacidade")) - cint(rs("VagasMatriculasUtilizadas")) 
								if rs("Capacidade") >= 0 then
									intCapacidadeCurso = intCapacidadeCurso + rs("Capacidade")
								end if 
								
								if rs("VagasMatriculasUtilizadas") >= 0 then  
									intVagasPreenchidaCurso = intVagasPreenchidaCurso + rs("VagasMatriculasUtilizadas")
								end if	
								
								if strVagasNaoAutorizadas >= 0 then  
									intVagasNaoAutorizadasCurso = intVagasNaoAutorizadasCurso + strVagasNaoAutorizadas
								end if	
								
								if rs("VagasReservadas") >= 0 then  
									intVagasReservadasCurso = intVagasReservadasCurso + rs("VagasReservadas")
								end if	
								if (strVagasNaoAutorizadas-rs("VagasReservadas")) >= 0 then  
									intVagasLiberadasCurso = intVagasLiberadasCurso + (strVagasNaoAutorizadas-rs("VagasReservadas"))
								end if	
							%>
                            <tbody>
                                <tr>
                                  <th width="7%"><input type="checkbox" name="marcacao<%=rs("cod_turma")%>" value="S"></th>
                                  <th width="6%"><%=trim(rs("AnoLetivo"))%></th>
                                  <th width="5%"><%=trim(rs("Sala"))%></th>
                                  <th width="23%" align="center"><%=trim(rs("curso"))%></th>
                                  <th width="13%" align="center"><%=trim(rs("periodo"))%></th>
                                  <th width="6%" align="center"><input value="<%=rs("cod_turma")%>" type="hidden" name="txtCodTurma_<%=rs("cod_turma")%>" ><%=trim(rs("NomeTurma"))%></th>
                                  <th width="7%" align="center"><%=trim(rs("Capacidade"))%></th>
                                  <th width="8%" align="center"><strong><font color="#0000CC"><%=rs("VagasMatriculasUtilizadas")%></font></strong>&nbsp;</th>
                                  <th width="7%" align="center"><strong><font color="#0066FF"><%=strVagasNaoAutorizadas%></font></strong></th>
                                  <th width="7%" align="center"><input name="txtVagasMatriculasReservadas_<%=rs("Cod_Turma")%>" type="text" class="form-control" id="txtVagasMatriculasUtilizadas<%=rs("Cod_Turma")%>" value="<%=rs("VagasReservadas")%>" size="3" maxlength="3"></th>
                                  <th width="7%" align="center"><strong><font color="#009900"><%=strVagasNaoAutorizadas-rs("VagasReservadas")%></font></strong></th>
                                  <th width="4%" align="center"><%=trim(rs("Desc_Turno"))%></th>
                              </tr>
                            </tbody>
                            <%	
								strDesabilitaAlterar 	= "" 			
								rs.movenext
								wend
							end if
							rs.close
						%>
                        <tr>
                            <th bgcolor="#95A5A6">&nbsp;</th>
                            <th bgcolor="#95A5A6">&nbsp;</th>
                            <th bgcolor="#95A5A6">&nbsp;</th>
                            <th bgcolor="#95A5A6" align="center">&nbsp;</th>
                            <th bgcolor="#95A5A6" align="center">&nbsp;</th>
                            <th bgcolor="#95A5A6" align="center"><strong>Totais:</strong></th>
                          <th bgcolor="#95A5A6" align="center"><strong><%=intCapacidadeCurso%></strong></th>
                          <th bgcolor="#95A5A6" align="center"><strong><%=intVagasPreenchidaCurso%></strong></th>
                          <th bgcolor="#95A5A6" align="center"><strong><%=intVagasNaoAutorizadasCurso%></strong></th>
                          <th bgcolor="#95A5A6" align="center"><strong><%=intVagasReservadasCurso%></strong></th>
                          <th bgcolor="#95A5A6" align="center"><strong><%=intVagasLiberadasCurso%></strong></th>
                          <th bgcolor="#95A5A6" align="center">&nbsp;</th>
                        </tr>
                    </table>
             
                  </div>                      
                </div>
                             
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    
    <!--/container-->		
    <script>
		function resultadoConsulta(intCodigo){
		
			var frm = document.getElementById("frm");
			frm.txtCodigo.value=intCodigo;
			frm.submit();
		}

	function salvar(acao){	
		var frm = document.getElementById("frm");
		if (frm.cmdEmpresaUsuario.value == "0") {
			alert("A Empresa deve ser informada!");
			frm.cmdEmpresaUsuario.focus();
			return false;
		}
		
		
		frm.action="TurmasVagasMatricula_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function AtualizaPeriodico(){	
		var frm = document.getElementById("frm");
		if (frm.cmdEmpresaUsuario.value == "0") {
			alert("A Empresa deve ser informada!");
			frm.cmdEmpresaUsuario.focus();
			return false;
		}
		frm.action="TurmasVagasMatriculaAtualiza_cod.asp?acao2=PERIODICA";
		frm.submit();
		return true;
 	}
	
	function AtualizaInicial(){	
		var frm = document.getElementById("frm");
		if (frm.cmdEmpresaUsuario.value == "0") {
			alert("A Empresa deve ser informada!");
			frm.cmdEmpresaUsuario.focus();
			return false;
		}
		frm.action="TurmasVagasMatriculaAtualiza_cod.asp?acao2=INICIAL";
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 