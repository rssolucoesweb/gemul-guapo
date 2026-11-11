<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<style>
.margin-bottom-30 {
    margin-left: 30px;
}
.pointer {cursor: pointer;}
.tamanho7 { font-size: 9px; }
</style>
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
         <%if Session("mobile")<>"S" then%>
            <h1 class="pull-left">EAD - Sistema de Ensino a Distância</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
          <%end if%>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "atividade_cad.asp"
		strExecutarSubmitProfessor = "S"
		
		
		if Session("CodColaborador")<>"" then
			intCodProfessor	 		= Session("CodColaborador")
		else
			intCodProfessor			= Trim(Request.Form("cmbProfessor"))
		end if
		
        intCodigo	 			= Trim(Request.Form("txtCodigo"))
		titulo		 			= Trim(Request.Form("txtTitulo"))
		descricao 				= Trim(Request.Form("txtDescricao"))
			
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT cod_atividade_pai as codigo, cod_tipo_atividade, titulo, descricao, cod_tipo_link, link, data_hora_agendamento, situacao"
            sql = sql & " FROM EAD_ATIVIDADE_PAI"
            sql = sql & " where cod_atividade_pai = " & intCodigo
			
            rs.open sql, cnn
            if rs.eof = false then
                intCodigo				= rs("codigo")
				cod_atividade_pai		= rs("codigo")
				cod_tipo_atividade		= rs("cod_tipo_atividade")
                titulo					= rs("titulo")
				descricao				= rs("descricao")
				cod_tipo_link			= rs("cod_tipo_link")
				link					= rs("link")
				situacao				= rs("situacao")	

                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    			
            end if 
            rs.close
			
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if 
		
	   strAnoLetivo          		= session("strAnoLetivo")
	   intSemestre          		= session("strSemestre")
    %>
    
    
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->     

                <form id="frm" class="sky-form  panel-body0" method="post">
                	
                    <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
					<input name="cod_atividade_pai" type="hidden" id="cod_atividade_pai" value="<%=cod_atividade_pai%>">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Atividades</font></div>


                    <fieldset>
						<div class="row">
                             <section class="col col-5">
                                <label class="form-label">Professor</label>
                                <label class="input">
                                    <!--#include file="../includes/inc_cmdProfessorEAD.asp" -->
                                </label>
                             </section>
                        </div>
						
						<div class="row">
                             <section class="col col-5">
                                <label class="form-label">Tipo de postagem</label>
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbTipoAtividade.asp" -->
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Título</label>
                              
                                <label class="input">
                                     <input name="titulo" type="text" class="form-control" id="titulo" size="150" maxlength="250" value="<%=titulo%>">
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Descrição</label>
                              
                                <label class="input">
									<textarea name="descricao" id="descricao" class="form-control"  cols="144" rows="3"><%=descricao%></textarea>
                                </label>
                             </section>
                        </div>
                        
                         <div class="row">
                             <section class="col col-3">
                                <label class="form-label">Tipo de link</label>
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbTipoLink.asp" -->
                                </label>
                             </section>
                             <section class="col col-9">
                                <label class="form-label">Link</label>
                              
                                <label class="input">
                                     <input name="link" type="text" class="form-control" id="link" size="50" maxlength="70" value="<%=link%>">
                                </label>
                             </section>
                        </div>
						<%if strDesabilitaAlterar <> "" then%>
                        <div class="row">
                             <section class="col col-6">
                                <label class="form-label">Liberar para as Turmas</label>
									<label>
									<%

								if intCodProfessor="" then
									' Consulta a Categoria	
									sql = "select codigo "
									sql = sql & " from SRH_COLABORADOR"
									sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
									sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
									sql = sql & " and Situacao = 'A'" 'Ativo
									rs.open sql, cnn
									if rs.EOF = false then	
										strVerificaTurmaProfessor	= "Professor"
									else
										strVerificaTurmaProfessor = ""
									end if
									rs.close
								else
									' Consulta a Categoria
									if Session("Seg_CodCategoria")	<>"" then
										if Session("Seg_CodCategoria")="1" or Session("Seg_CodCategoria")="8" then	
											strVerificaTurmaProfessor	= "Professor"
										else
											strVerificaTurmaProfessor = ""
										end if
									else
										sql = "select codigo "
										sql = sql & " from SRH_COLABORADOR"
										sql = sql & " where codigo = " & intCodProfessor
										sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
										sql = sql & " and Situacao = 'A'" 'Ativo
										rs.open sql, cnn
										if rs.EOF = false then	
											strVerificaTurmaProfessor	= "Professor"
										else
											strVerificaTurmaProfessor = ""
										end if
										rs.close
									end if
								end if
								
								sql = "SELECT distinct SCA_TURMA.cod_turma, SCA_TURNO.DESC_TURNO AS TURNO, SCA_TURMA.NomeTurma, SCA_TURMA.TurmaAluno AS TURMA "
								sql = sql & " FROM SCA_TURMA "
								sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
								sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
								sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_curso "
								sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO "

								if 	strVerificaTurmaProfessor	= "Professor" then
									sql = sql & " left JOIN SCA_HORARIO_AULA ON SCA_HORARIO_AULA.cod_turma = SCA_TURMA.cod_turma "
									sql = sql & " and SCA_HORARIO_AULA.semestre = SCA_TURMA.cod_Semestre and SCA_HORARIO_AULA.anoLetivo = SCA_TURMA.AnoLetivo"
									sql = sql & " inner JOIN SRH_COLABORADOR on SRH_COLABORADOR.codigo = SCA_HORARIO_AULA.cod_colaborador"
								end if	
								sql = sql & " where 1=1 "
								if 	strVerificaTurmaProfessor = "Professor" then
									sql = sql & " and SCA_HORARIO_AULA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
								end if	
								sql = sql & " AND SCA_TURMA.Situacao = 'A' " 
								sql = sql & " and SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
								sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
								sql = sql & " and SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
								
								if strDataHorarioAulaExtra <> "" then
									sql = sql & " UNION "
									'
									sql = sql & " SELECT distinct SCA_TURMA.cod_turma, SCA_TURNO.DESC_TURNO AS TURNO, SCA_TURMA.NomeTurma, SCA_TURMA.TurmaAluno AS TURMA"
									sql = sql & " FROM SCA_TURMA "
									sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
									sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
									sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_curso "
									sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO "
									if 	strVerificaTurmaProfessor	= "Professor" then
										sql = sql & " left JOIN SCA_HORARIO_AULA_EXTRA ON SCA_HORARIO_AULA_EXTRA.cod_turma = SCA_TURMA.cod_turma "
										sql = sql & " and SCA_HORARIO_AULA_EXTRA.semestre = SCA_TURMA.cod_Semestre and SCA_HORARIO_AULA_EXTRA.anoLetivo = SCA_TURMA.AnoLetivo"
										sql = sql & " inner JOIN SRH_COLABORADOR on SRH_COLABORADOR.codigo = SCA_HORARIO_AULA_EXTRA.cod_colaborador"
									end if	
									sql = sql & " where 1=1 "
									if 	strVerificaTurmaProfessor = "Professor" then
										sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
									end if	
									if 	strVerificaTurmaProfessor	= "Professor" then
										sql = sql & " AND SCA_HORARIO_AULA_EXTRA.DataLancamento = '" & formatadataBD(strDataHorarioAulaExtra) & "' " 
									end if
									sql = sql & " AND SCA_TURMA.Situacao = 'A' " 
									sql = sql & " and SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
									sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
									sql = sql & " and SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
									sql = sql & " order by SCA_TURMA.NomeTurma"
								else
									sql = sql & " order by SCA_TURMA.NomeTurma"
								end if
								
								RS.OPEN SQL, CNN
								IF RS.EOF = FALSE THEN
									while not rs.eof
										%>
										<input name="turma" id="turma" type="checkbox" value="<%=rs("Cod_Turma")%>" /> <%=rs("turma")%> | <%=rs("turno")%> (<%=rs("nometurma")%>)<br>
										<%
										rs.movenext
									wend
								END IF
								rs.close
								%>

									</label>
                             </section>
							 <section class="col col-6">
                                <label class="form-label">Liberar para as Disciplinas</label>
                              
                                <label>
									<%
									sql = "Select distinct sca_disciplina.desc_disciplina, sca_disciplina.cod_disciplina"
									sql = sql & " FROM SCA_TURMA "
									sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
									sql = sql & " INNER JOIN sca_gradecurriculardisciplina on sca_gradecurriculardisciplina.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
									sql = sql & " INNER JOIN sca_disciplina on sca_disciplina.cod_disciplina = sca_gradecurriculardisciplina.Cod_Disciplina "
									sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
									sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_curso "
									sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO "

									if 	strVerificaTurmaProfessor	= "Professor" then
										sql = sql & " left JOIN SCA_HORARIO_AULA ON SCA_HORARIO_AULA.cod_turma = SCA_TURMA.cod_turma "
										sql = sql & " and SCA_HORARIO_AULA.semestre = SCA_TURMA.cod_Semestre and SCA_HORARIO_AULA.anoLetivo = SCA_TURMA.AnoLetivo"
										sql = sql & " inner JOIN SRH_COLABORADOR on SRH_COLABORADOR.codigo = SCA_HORARIO_AULA.cod_colaborador"
									end if	
									sql = sql & " where 1=1 "
									if 	strVerificaTurmaProfessor = "Professor" then
										sql = sql & " and SCA_HORARIO_AULA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
									end if	
									sql = sql & " AND SCA_TURMA.Situacao = 'A' " 
									sql = sql & " and SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
									sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
									sql = sql & " and SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
									
									if strDataHorarioAulaExtra <> "" then
										sql = sql & " UNION "
										'
										sql = sql & " SELECT distinct sca_disciplina.desc_disciplina, sca_disciplina.cod_disciplina"
										sql = sql & " FROM SCA_TURMA "
										sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
										sql = sql & " INNER JOIN sca_gradecurriculardisciplina on sca_gradecurriculardisciplina.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
										sql = sql & " INNER JOIN sca_disciplina on sca_disciplina.cod_disciplina = sca_gradecurriculardisciplina.Cod_Disciplina "
										sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
										sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_curso "
										sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO "
										if 	strVerificaTurmaProfessor	= "Professor" then
											sql = sql & " left JOIN SCA_HORARIO_AULA_EXTRA ON SCA_HORARIO_AULA_EXTRA.cod_turma = SCA_TURMA.cod_turma "
											sql = sql & " and SCA_HORARIO_AULA_EXTRA.semestre = SCA_TURMA.cod_Semestre and SCA_HORARIO_AULA_EXTRA.anoLetivo = SCA_TURMA.AnoLetivo"
											sql = sql & " inner JOIN SRH_COLABORADOR on SRH_COLABORADOR.codigo = SCA_HORARIO_AULA_EXTRA.cod_colaborador"
										end if	
										sql = sql & " where 1=1 "
										if 	strVerificaTurmaProfessor = "Professor" then
											sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
										end if	
										if 	strVerificaTurmaProfessor	= "Professor" then
											sql = sql & " AND SCA_HORARIO_AULA_EXTRA.DataLancamento = '" & formatadataBD(strDataHorarioAulaExtra) & "' " 
										end if
										sql = sql & " AND SCA_TURMA.Situacao = 'A' " 
										sql = sql & " and SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
										sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
										sql = sql & " and SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
										sql = sql & " order by sca_disciplina.desc_disciplina"
									else
										sql = sql & " order by sca_disciplina.desc_disciplina"
									end if
									rs.open sql, cnn
									if not rs.eof then
										while not rs.eof
											%>
											<input name="disciplina" id="disciplina" type="checkbox" value="<%=rs("cod_disciplina")%>" /> <%=rs("desc_disciplina")%><br>
											<%
											rs.movenext
										wend
									end if
									rs.close
									%>
									
                                </label>
                             </section>
                        </div>
						<%end if%>
                        <div class="row">
                             
                              <section class="col col-6">
                                <label class="form-label">Situação</label>
                                <label class="input">
                                    <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:150pt" >
                                      <option value="A" <%if trim(strSituacao) = "A" then response.Write("selected") %>>ATIVO</option>
                                      <option value="I" <%if trim(strSituacao) = "I" then response.Write("selected") %>>INATIVO</option>
                                   </select>
                                </label>
                             </section>
                        </div>

                    </fieldset>
					
					<div class="margin-left-40">
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</DIV>
                    
                 </form>                
                
			</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Atividades</h3>
          	</div>
      		<div class="panel-body">
            	<div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                              <th width="15%" bgcolor="#95A5A6">Tipo</th>
							  <th width="45%" bgcolor="#95A5A6">Título</th>
                              <th width="20%" bgcolor="#95A5A6">Data Inclusão</th>
							  <th width="15%" bgcolor="#95A5A6">Situação</th>
                              <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Remover</div></th>
                          </tr>
                        </thead>
                         <tbody>
                        <%
                        cont =0
                        sql = "SELECT a.cod_atividade_pai, a.titulo, a.situacao, a.data_hora_incl, ta.descricao as tipo_atividade, A.COD_TIPO_ATIVIDADE"
                        sql = sql & " FROM EAD_ATIVIDADE_PAI a "
						sql = sql & " inner join EAD_TIPO_ATIVIDADE TA ON TA.COD_TIPO_ATIVIDADE = A.COD_TIPO_ATIVIDADE"
						IF cod_colaborador <> "" THEN
							sql = sql & " where	A.cod_colaborador = " & cod_colaborador
						END IF
                        sql = sql & " Order by A.data_hora_incl desc"
                        rs.open sql, cnn
                        if rs.eof = false then
                        
                        while not rs.eof
                            cont = cont + 1
							cor = ""
							situacao = "ATIVO"
							if trim(rs("situacao"))	 = "I" then 
								cor = " bgcolor='#FFCACA'"
								situacao = "INATIVO"
							end if
                            %>
							<tr class="pointer" <%=cor%> onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
								<td  onclick="return resultadoConsulta('<%=rs("cod_atividade_pai")%>')"><%=trim(rs("tipo_atividade"))%></td>
                                <td  onclick="return resultadoConsulta('<%=rs("cod_atividade_pai")%>')"><%=trim(rs("titulo"))%></td>
								<td  onclick="return resultadoConsulta('<%=rs("cod_atividade_pai")%>')"><%=trim(rs("data_hora_incl"))%></td>
                                <td  onclick="return resultadoConsulta('<%=rs("cod_atividade_pai")%>')"><%=trim(situacao)%></td>
                                <td align="center" >
									<button class="btn-u btn-u-red" onclick="removeAtividade('<%=trim(rs("cod_atividade_pai"))%>')" type="button"><i class="fa fa-remove"></i></button>                            
								</td> 
                            </tr>
                            <%				
                            rs.movenext
                            wend
                        end if
                        rs.close
                        %>
                            <tr>
                                <td colspan="5">Total Registros : <%=cont%></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
          	</div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    
   	   
	<script>
        function removeAtividade(cod_atividade_pai){
            
            var frm = document.getElementById("frm");
            
			frm.cod_atividade_pai.value=cod_atividade_pai;
            frm.action="atividade_cod.asp?acao=E";
            frm.submit();
            return true;
        }
		function resultadoConsulta(cod_atividade_pai){
            
            var frm = document.getElementById("frm");
            frm.cod_atividade_pai.value=cod_atividade_pai;
			frm.txtCodigo.value=cod_atividade_pai;
            frm.action="atividade_cad.asp";
            frm.submit();
            return true;
        }
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.cmbTipoAtividade.value == "0") {
                alert("O tipo deve ser informado!");
                frm.cmbTipoAtividade.focus();
                return false;
            }
            if (frm.titulo.value == "") {
                alert("O título deve ser informado!");
                frm.titulo.focus();
                return false;
            }
			
			if (acao!="A"){
				var marcou = "N"
				for (var i = 0; i < frm.elements.length; i++) {
						//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox" && frm.elements[i].name=="turma"){				
						if (frm.elements[i].checked == true){
							marcou = "S"
						}		
					}
					
				}
				if (marcou == "N") {
					alert("A turma deve ser selecionada!");
					return false;
				}
			}
            frm.action="atividade_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 