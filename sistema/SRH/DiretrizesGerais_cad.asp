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
        strExecutarSubmitDisciplina = "S"
        strExecutarSubmitCurso 		= "S"
		strSubmitTurnoTurma			= "S"
        
        strPaginaTitulo 			= "DiretrizesGerais_cad.asp"
        intCodEmpresa				= session("codEmpresa")
        strAno	 					= Trim(Request("txtAno"))
        if Trim(Request("cmbSemestre")) <> "0" then
            intSemestre 		= Trim(Request("cmbSemestre"))
        else	
            intSemestre 		=  Session("strSemestre")
        end if	
        if strAno = "" then strAno = session("strAnoLetivo")
        if intSemestre = "" then intSemestre = Session("strSemestre")
    
        intCodigo	 				= Trim(Request.Form("txtCodigo"))
        intCodFuncao 				= Trim(Request.Form("cmbFuncao"))
        intCodTurno 				= TRIM(Request.Form("cmbTurnoRH"))
		if intCodTurno = "" then intCodTurno = "0"
		intCodTurnoTurma			= TRIM(Request.Form("cmbTurnoTurma"))
		if intCodTurnoTurma = "" then intCodTurnoTurma = "0"
        intCodDisciplina			= Trim(Request.Form("cmbDisciplina"))
        intCodCurso 				= Trim(Request.Form("cmbCurso"))
		intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
        strAulasOferecidas 			= Trim(Request.Form("txtAulasOferecidas"))
        strVagasOferecidas 			= Trim(Request.Form("txtVagasOferecidas"))
        
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Cod_Empresa, Ano_letivo, Semestre, CodFuncao, Cod_turno, Cod_turno_turma, Cod_Disciplina, Cod_Curso, Cod_periodo, AulasOferecidas, VagasOferecidas"
            sql = sql & " FROM SRH_DIRETRIZES"
            sql = sql & " where Codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                strAno	 						= rs("Ano_letivo")
                intSemestre 					= rs("Semestre")
                intCodigo	 					= rs("Codigo")
                intCodFuncao 					= rs("CodFuncao")
                intCodTurno 					= rs("Cod_turno")
				intCodTurnoTurma				= rs("Cod_turno_turma")
				intCodPeriodo 					= rs("Cod_periodo")
                intCodDisciplina				= rs("Cod_Disciplina")
                if isnull(intCodDisciplina) then intCodDisciplina = "0"
                intCodCurso 					= rs("Cod_Curso")
				intCodPeriodo 					= rs("Cod_Periodo")
                strAulasOferecidas 				= rs("AulasOferecidas")
                strVagasOferecidas 				= rs("VagasOferecidas")
        
                strDesabilitaIncluir			= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 			= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir			= "" 'Desabilita o botão Excluir
    
            end if 
            rs.close
            
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if
        if trim(intCodCurso) 	= "" then intCodCurso = "0"
		if trim(intCodPeriodo) 	= "" then intCodPeriodo = "0"
        if trim(strSiglaTurno) 	= "" then strSiglaTurno = "0"
        if intCodTurno 			= "" then intCodTurno = "0"
		if intCodTurnoTurma 	= "" then intCodTurnoTurma = "0"
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Diretrizes - Gerais</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                        <input  name="txtAno" type="text" class="form-control" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" onChange="submit()">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                    	<!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                    <div class="form-group"><%strSubmitFuncao=" onChange='submit()'"%>
                        <label class="form-label">Fun&ccedil;&atilde;o</label>
                    	 <!--#include file="../includes/inc_cmbFuncao.asp" -->
                    </div>
                    <%if TipoFuncao = "PROFESSOR" then%>
                    <div class="form-group"><%strExecutarSubmitCurso="S"%>
                        <label class="form-label">Turno da Turma</label>
                    	 <!--#include file="../includes/inc_cmbTurnoTurma.asp" -->
                    </div>
					<div class="form-group"><%strSubmitTurno=" onChange='submit()'"%>
                        <label class="form-label">Turno do Professor(a)</label>
                    	 <!--#include file="../includes/inc_cmbTurno.asp" -->
                    </div>
					<%end if%>
					<%if TipoFuncao = "FUNCIONARIO" then%>
                    <div class="form-group"><%strSubmitTurno=" onChange='submit()'"%>
                        <label class="form-label">Turno</label>
                    	 <!--#include file="../includes/inc_cmbTurno.asp" -->
                    </div>
					<%end if%>
                    <%if TipoFuncao = "PROFESSOR" then%>
                    <div class="form-group"><%strExecutarSubmitCurso="S"%>
                        <label class="form-label">Curso</label>
                    	 <!--#include file="../includes/inc_cmdCurso.asp" -->
                    </div>
					<%end if%>
					<%if TipoFuncao = "PROFESSOR" then%>
					<div class="form-group"><%strExecutarSubmitPeriodo="S"%>
                        <label class="form-label">Período</label>
                    	 <!--#include file="../includes/inc_cmdPeriodo.asp" -->
                    </div>
					<%end if%>
                    <%if trim(Situacao_Disciplinar)="D" and TipoFuncao = "PROFESSOR" then %>
                     <div class="form-group">
                        <label class="form-label">Disciplina</label>
                    	<!--#include file="../includes/inc_cmdDisciplina.asp" -->
                    </div>
                    <%end if%>
                     <% 
					  strHabilitaVagasOferecidas = "text"
					  
						if TipoFuncao = "PROFESSOR" and intCodDisciplina <> "0" and intCodDisciplina <> "" and trim(Situacao_Disciplinar)="D" then 
							strHabilitaVagasOferecidas = "hidden"
							NaoExisteRegistro = "N"
							sql = " SELECT "
							sql = sql & " SUM(GD.Ch_Semanal) as total "
							sql = sql & " FROM SCA_TURMA T "
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND G.SITUACAO = 'A' "
							sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR  "
							sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo  "
							sql = sql & " WHERE T.COD_EMPRESA = " & intCodEmpresa	
							sql = sql & " AND T.ANOLETIVO = " & strAno	
							sql = sql & " AND T.Cod_Semestre = " & intSemestre
							if intCodTurnoTurma = "4" then 
								sql = sql & " and t.Cod_Turno = " & intCodTurnoTurma
							else
								sql = sql & " and t.Cod_Turno = " & intCodTurno
							end if
							sql = sql & " AND P.Cod_Curso = " & intCodCurso
							if intCodPeriodo<>"" and intCodPeriodo<>"0" and not isnull(intCodPeriodo) then
								sql = sql & " AND P.Cod_Periodo = " & intCodPeriodo
							end if
							if intCodDisciplina="56" then 'recreacao
								sql = sql & " AND (GD.Cod_Disciplina = " & intCodDisciplina & ")" 'quando a disciplina na grade for interdisciplinar
							else
								sql = sql & " AND (GD.Cod_Disciplina = " & intCodDisciplina & " or GD.Cod_Disciplina = 16)" 'quando a disciplina na grade for interdisciplinar
							end if
							sql = sql & " and T.Situacao = 'A'"
							
							
							if session("usuarioWeb") = "sergio" or session("usuarioWeb") = "SERGIO" then
								'	response.write sql
							end if
							rsaux.open sql, cnn
							if rsaux.eof = false then
								strAulasOferecidas	= rsaux("total")
							end if 
							rsaux.close
							%>
                            <div class="form-group">
                                <label class="form-label">Aulas Oferecidas</label>
                                <input name="txtAulasOferecidas" type="hidden" class="text" id="txtAulasOferecidas"  size="5" maxlength="5" value="<%=strAulasOferecidas%>">&nbsp;<%=strAulasOferecidas%>
                            </div>
							<%
						end if 
						if TipoFuncao = "PROFESSOR" and intCodDisciplina <> "0" and intCodDisciplina <> "" and trim(Situacao_Disciplinar)="I" then
							strHabilitaVagasOferecidas = "hidden"
							sql = " select count(*) as qtdeTurma"
							sql = sql & " from sca_turma t"
							sql = sql & " inner join SCA_PERIODO p on p.Cod_Periodo = t.Cod_periodo"
							sql = sql & " where t.Situacao = 'A'"
							sql = sql & " and t.Cod_Empresa = " & intCodEmpresa
							sql = sql & " AND T.Cod_Semestre = " & intSemestre
							sql = sql & " and p.Cod_Curso = " & intCodCurso
							sql = sql & " AND P.Cod_Periodo = " & intCodPeriodo
							if intCodTurnoTurma = "4" then 
								sql = sql & " and t.Cod_Turno = " & intCodTurnoTurma
							else
								sql = sql & " and t.Cod_Turno = " & intCodTurno
							end if
							sql = sql & " and t.AnoLetivo = " & strAno
							rsaux.open sql, cnn
							if rsaux.eof = false then
								strAulasOferecidas	= rsaux("qtdeTurma")
							end if 
							rsaux.close
							%>
                            <div class="form-group">
                                <label class="form-label">Aulas Oferecidas</label>
                                <input name="txtAulasOferecidas" type="hidden" class="text" id="txtAulasOferecidas"  size="5" maxlength="5" value="<%=strAulasOferecidas%>">&nbsp;<%=strAulasOferecidas%>
                            </div>
							<%
						end if
						if  TipoFuncao = "PROFESSOR" and (intCodDisciplina = "0" or  intCodDisciplina = "") and trim(Situacao_Disciplinar)="I" then
							strHabilitaVagasOferecidas = "hidden"
							sql = " select count(*) as qtdeTurma"
							sql = sql & " from sca_turma t"
							sql = sql & " inner join SCA_PERIODO p on p.Cod_Periodo = t.Cod_periodo"
							sql = sql & " where t.Situacao = 'A'"
							sql = sql & " and t.Cod_Empresa = " & intCodEmpresa
							sql = sql & " AND T.Cod_Semestre = " & intSemestre
							sql = sql & " and p.Cod_Curso = " & intCodCurso
							sql = sql & " AND P.Cod_Periodo = " & intCodPeriodo
							if intCodTurnoTurma = "4" then 
								sql = sql & " and t.Cod_Turno = " & intCodTurnoTurma
							else
								sql = sql & " and t.Cod_Turno = " & intCodTurno
							end if
							sql = sql & " and t.AnoLetivo = " & strAno
							rsaux.open sql, cnn
							if rsaux.eof = false then
								strVagasOferecidas	= rsaux("qtdeTurma")
							end if 
							rsaux.close
							%>
                            <div class="form-group">
                                <label class="form-label">Vagas Oferecidas</label>
                                <input name="txtVagasOferecidas" type="hidden" class="text" id="txtVagasOferecidas"  size="5" maxlength="5" value="<%=strVagasOferecidas%>">&nbsp;<%=strVagasOferecidas%>
                            </div>
							<%
						end if
						%> 
                        
                        <% if strHabilitaVagasOferecidas <> "hidden" then %> 
                        
                        	<div class="form-group">
                                <label class="form-label">Vagas Oferecidas</label>
                                <input name="txtVagasOferecidas" type="<%=strHabilitaVagasOferecidas%>" class="form-control" id="txtVagasOferecidas"  size="5" maxlength="5" value="<%=strVagasOferecidas%>">
                            </div>
                        <% end if %> 
                        

                         <input name="txtSituacaoDisciplinar" type="hidden" class="text" id="txtSituacaoDisciplinar" value="<%=Situacao_Disciplinar%>">
                            
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Diretrizes - Gerais</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
					<thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="34%" bgcolor="#95A5A6">Função</th>
                          <th width="9%" bgcolor="#95A5A6">Turno</th>
                          <th width="16%" bgcolor="#95A5A6">Disciplina</th>
                          <th width="15%" bgcolor="#95A5A6">Curso</th>
						  <th width="10%" bgcolor="#95A5A6">Período</th>
                          <th width="2%" bgcolor="#95A5A6">Aulas</th>
                          <th width="2%" bgcolor="#95A5A6">Vagas</th>
                          <th width="2%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT D.Codigo, D.Cod_Empresa, F.tipo_funcao, D.CodFuncao, D.VagasOferecidas, F.desc_funcao, TU.Desc_Turno, di.desc_disciplina, cu.descricao as Desc_curso, pe.descricao as Desc_Periodo, D.AulasOferecidas"
					sql = sql & " FROM SRH_DIRETRIZES D"
					sql = sql & " inner join SRH_FUNCAOCOLABORADOR F on F.cod_funcao = D.CodFuncao "
					sql = sql & " left join SRH_TURNO TU on TU.cod_Turno = D.Cod_turno "
					sql = sql & " left join SCA_DISCIPLINA DI on DI.Cod_Disciplina = D.Cod_Disciplina "
					sql = sql & " left join SCA_CURSO CU on CU.Cod_Curso = D.Cod_Curso "
					sql = sql & " left join SCA_PERIODO PE on PE.COD_PERIODO = D.COD_PERIODO"
					sql = sql & " where D.Cod_Empresa = " & intCodEmpresa	
					sql = sql & " and D.Ano_Letivo = " & strAno	
					sql = sql & " and D.Semestre = " & intSemestre	 
					sql = sql & " order by F.desc_funcao " 	
							if session("usuarioWeb") = "sergio" or session("usuarioWeb") = "SERGIO" then
									'response.write sql
							end if					
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1
							
							if rs("tipo_funcao")<>tipo_funcao then
							%>
							<tr bgcolor="#93c3ff">
							  <td align="center" colspan="9"><strong><%=trim(rs("tipo_funcao"))%></strong></td>
							</tr>
							<%
							end if
							
							if isnull(rs("Desc_disciplina")) or rs("Desc_disciplina") = "" then
								strDesc_disciplina  = "** Interdisciplinar **"
							else
								strDesc_disciplina  = rs("Desc_disciplina")
							end if
							
							if isnull(rs("Desc_curso")) or rs("Desc_curso") = "" then
								strDesc_curso  = "** Interdisciplinar **"
							else
								strDesc_curso  = rs("Desc_curso")
							end if
							if isnull(rs("Desc_Periodo")) or rs("Desc_Periodo") = "" then
								strDesc_Periodo  = ""
							else
								strDesc_Periodo  = rs("Desc_Periodo")
							end if
							if trim(rs("AulasOferecidas")) <> "0" then
								strAulasOferecidas = rs("AulasOferecidas")
							else
								strAulasOferecidas = ""
							end if
							
							if trim(rs("VagasOferecidas")) <> "0" then
								strVagasOferecidas = rs("VagasOferecidas")
							else
								strVagasOferecidas = ""
							end if
							
							if rs("tipo_funcao") = "FUNCIONARIO" then
								strDesc_curso = ""
								strDesc_disciplina = ""
								strDesc_Periodo = ""
							end if	
						%>
                        <tr>
                          <td><%=trim(rs("Codigo"))%></td>
                          <td><%=trim(rs("desc_funcao"))%></td>
                          <td><%=rs("Desc_Turno")%></td>
                          <td><%=strDesc_disciplina%></td>
                          <td><%=strDesc_curso%></td>
						  <td><%=strDesc_Periodo%></td>
                          <td align="center"><%=strAulasOferecidas%></td>
                          <td align="center"><%=strVagasOferecidas%></td>
                          <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
                        </tr>
                    	<%	
						tipo_funcao = rs("tipo_funcao")
                        rs.movenext
                        wend
					else
					 	NaoExisteRegistro = "S"  		
                    end if
                    rs.close
                	%>
                    <tr>
                        <td colspan="8">Total Registros : <%=cont%></td>
                    </tr>
                    </tbody>
                </table>
             <div class="form-group">
			   <% if NaoExisteRegistro = "S*****" then %>
                  <tr>
                    <td colspan="2"><span class="celula">ATEN&Ccedil;&Atilde;O: N&atilde;o existe Diretrizes para ano e semestre informado, deseja copiar dados do ano anterior
                      <div class="margin-bottom-30">
                           <input type="button" name="cmdSim" style="cursor:hand"   value="Sim" class="btn-u btn-u-default" onClick="return salvar('D')">
                    </div>                      
                    </span></td>
                  </tr>
              <% end if %>    
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
            
            if (frm.txtSituacaoDisciplinar.value == "D"){
                if (frm.cmbFuncao.value == "0") {
                    alert("A Função deve ser informada!");
                    frm.cmbFuncao.focus();
                    return false;
                }
        
                if (frm.cmbTurnoRH.value == "0") {
                    alert("O Turno deve ser informado!");
                    frm.cmbTurnoRH.focus();
                    return false;
                }
				<%if strTipo="D" then%>
                if (frm.cmbDisciplina.value == "0") {
                    alert("Disciplina deve ser informada!");
                    frm.cmbDisciplina.focus();
                    return false;
                }
				<%end if%>
				if (frm.txtAulasOferecidas.value == "") {
					alert("As Aulas Oferecidas devem ser informadas !");
					frm.txtAulasOferecidas.focus();
					return false;
				}
            }
            if (frm.txtSituacaoDisciplinar.value == "I"){
                if (frm.cmbFuncao.value == "0") {
                    alert("A Função deve ser informada!");
                    frm.cmbFuncao.focus();
                    return false;
                }
        
                if (frm.cmbTurnoRH.value == "0") {
                    alert("O Turno deve ser informado!");
                    frm.cmbTurnoRH.focus();
                    return false;
                }
                
				if (frm.txtVagasOferecidas.value == "") {
					alert("As Vagas Oferecidas devem ser informadas !");
					frm.txtVagasOferecidas.focus();
					return false;
				}
            }
            frm.action="DiretrizesGerais_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
        function atualizar(){
            var frm = document.getElementById("frm");
            if (frm.txtAno.value == "") {
                alert("O ano letivo ser informado!");
                frm.txtAno.focus();
                return false;
            }
            if (frm.cmbSemestre.value == "0") {
                alert("O semestre deve ser informado!");
                frm.cmbSemestre.focus();
                return false;
            }
            frm.action="DiretrizesGeraisAtualizar_cod.asp";
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 