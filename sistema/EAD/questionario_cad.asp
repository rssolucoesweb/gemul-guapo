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
            <h1 class="pull-left">EAD - Sistema de Educação a Distância</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
    acao = "I"
	strExecutarSubmitEstado						= "S"
	strBotaoExluirRespostas					= ""
	strPaginaTitulo                  			= "questionario_cad.asp"
	strPagina						 			= "questionario_cad.asp"
	
	strAnoLetivo						= Session("strAnoLetivo")
	intSemestre							= Session("strSemestre")
	
	if Session("CodColaborador")<>"" then
		intCodProfessor	 		= Session("CodColaborador")
	else
		intCodProfessor			= Trim(Request.Form("cmbProfessor"))
	end if
	
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	nome										= Trim(Request.form("nome"))
	descricao									= Trim(Request.form("descricao"))
	data_inicial								= Trim(Request.form("data_inicial"))
	data_final									= Trim(Request.form("data_final"))
	cod_estado									= Trim(Request.form("cmbEstado"))
	cod_cidade									= Trim(Request.form("cmbCidade"))
	situacao									= Trim(Request.form("cmbSituacao"))
	limite				 						= Trim(Request.form("limite"))
	limite_entrevistador				 						= Trim(Request.form("limite_entrevistador"))
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	strBotaoExluirRespostas = ""
	if trim(intCodigo) <> "" then
		sql = "SELECT *"
		sql = sql & " FROM EAD_Questionario"
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			nome			= rs("nome")
			descricao		= rs("descricao")
			data_entrega	= FormataDataAP(rs("data_entrega"))
			situacao		= rs("situacao")
			limite			= rs("limite_resposta")
			if limite = "0" then limite = ""
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			strBotaoExluirRespostas					= "S"

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if cod_colaborador="" then
		' Consulta a Categoria	
		sql = "select codigo, cpf "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaTurmaProfessor	= "Professor"
			strCpfTurmaProfessor = rs("cpf")
		else
			strVerificaTurmaProfessor = ""
		end if
		rs.close
	else
		' Consulta a Categoria
		sql = "select codigo, cpf "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo = " & cod_colaborador
		sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaTurmaProfessor	= "Professor"
			strCpfTurmaProfessor = rs("cpf")
		else
			strVerificaTurmaProfessor = ""
		end if
		rs.close
	end if
	
    %>
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->   

					<form id="frm" method="post" action="questionario_cad.asp"  class="sky-form panel-body0">
					<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Questionário</font></div>

                    <fieldset>
                        
                       	<div class="row">
							<section class="col col-12">
                                <label class="form-label">Nome do questionário</label>
                              
                                <label class="input">
                                    <input name="nome" type="text" class="form-control" id="nome" size="100" maxlength="100" value="<%=nome%>">
                                </label>
                             </section>
						</div>
						
						<div class="row">
							<section class="col col-12">
                                <label class="form-label">Instrução do questionário</label>
                              
								<label class="input">
									<textarea name="descricao" id="descricao" class="form-control"  cols="144" rows="3"><%=descricao%></textarea>
                                </label>
                             </section>
						</div>
						
						<div class="row">	 
							<section class="col col-3">
                                <label class="form-label">Data Entrega</label>
                              
                                <label class="input">
                                    <input name="data_entrega" type="text" class="form-control" id="data_entrega" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=data_entrega%>">
                                </label>
                            </section>
							 
							<section class="col col-3">
                                <label class="form-label">Limite de respostas objetivas</label>
                              
                                <label class="input">
                                    <input name="limite" style="width: 100px;" type="text" class="form-control" id="limite" onkeypress="return formataCampo(this, 2, 5)" size="5" maxlength="5" value="<%=limite%>">
                                </label>
                            </section>

							<section class="col col-6">
								<label class="form-label">Situação</label>
							  
								<label class="input">
									<!--#include file="../includes/inc_cmbSituacaoQuestionario.asp" -->
								</label>
								
							</section>
							 
						</div>
							
						<%if strDesabilitaIncluir = "" then%>
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
						
						</div>
						<%end if%>
						</fieldset><fieldset>
					 
					</fieldset>
					 
					<div class="margin-left-60">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
				<%
					sql = "select s.codigo, s.nome, s.situacao, s.usuario_altr, s.data_hora_altr"
					sql = sql & " from EAD_questionario s where s.cod_empresa = " & session("codEmpresa")
					sql = sql & " order by s.situacao, s.nome"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
                    %> 
                  <div class="panel panel-grey">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-tasks"></i> Questionário cadastrados</strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                        <table class="table table-bordered" >
                            <thead>
								<tr  bgcolor="#E2E2E2">
									<th width="2%" align="center">Cód.</th>
                                    <th width="30%"  align="center">Nome</th>
                                    <th width="15%" align="center"><strong>Usuário</strong></td>
                                    <th width="15%" align="center"><strong>Data</strong></td>
									<th width="5%" align="center"><strong>Respostas</strong></td>
									<th width="10%" align="center"><strong>Situação</strong></td>
                                </tr>
                            </thead>
                            <%
                            cont = 0
                            while not rs.eof
								cont = cont + 1	
								strCorlinha = "FFFFFF"
								if trim(rs("situacao")) = "A" then
									strSituacao = "Em aberto"
								elseif trim(rs("situacao")) = "E" then
									strSituacao = "Encerrado"
									strCorlinha = "A9F5D0"
								else
									strSituacao = "Não informada"
									strCorlinha = "F3E2A9"
								end if
								respostas = 0
								sql = "select count(*) as qtde"
								sql = sql & " from EAD_resultado"
								sql = sql & " where cod_questionario = " & rs("codigo")
								RSAux.OPEN SQL, CNN
								IF NOT RSAux.EOF THEN
									respostas = RSAux("qtde")
								end if
								rsAux.close
                                %>
                                <tr class="pointer" bgcolor="#<%=strCorlinha%>" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
                                  	<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=rs("codigo")%></td>
									<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=RS("nome")%></td>
                                    <td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=RS("usuario_altr")%></td>
									<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=RS("data_hora_altr")%></td>
									<td><%if respostas>0 then%><a href="javascript:window.open('questionario_rel.asp?cod_pesquisa=<%=rs("CODIGO")%>', 'resultado', 'status=no, toolbar=no, menubar=no, location=yes, fullscreen=1, scrolling=auto');"><%end if%><%=respostas%> <%if respostas > 0 then%>&nbsp;<i class="fa fa-search"></i></a><%end if%></td>
									<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=strSituacao%></td>
                                </tr>
                                <%				
                                rs.movenext
                            wend
                            %>
                        </table>
                      </div>
				</div>
                    <%
                    RS.CLOSE
                END IF
            %> 
			</div>
			</form>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
      
   	   
	<script>
   
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "questionario_cad.asp";
		frm.submit();
	}
	
	
	function mostraResultados(codQuestionario){
		var frm = document.getElementById("frm");
		frm.action = "questionario_rel.asp?id="+codQuestionario;
		frm.submit();
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
		
			if (confirm("Deseja realmente excluir esse questionário, todas perguntas/resposta vinculada será todas excluidas, deseja continuar?")) {
				frm.action="questionario_cod.asp?acao=" + acao;
			frm.submit();
			return true;
			}
			
		}
		else
		{
			if (frm.nome.value == "") {
				alert("O nome deve ser informado!");
				frm.nome.focus();
				return false;
			}
	
			frm.action="questionario_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}
	function excluirRespostas(){
		
		var frm = document.getElementById("frm");
		
		if (confirm("Deseja realmente excluir TODAS resposta para esse questionário?")) {
			frm.action="questionario_cod.asp?acao=R";
			frm.submit();
			return true;
		}
 	}
	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 