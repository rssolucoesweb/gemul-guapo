<%

	strCompartilharDados 			= "S"
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitTurma	  		= "S"
	strExecutarSubmitGradeCurricular= "S"
	strDisciplina_Disabled    		= "onchange='submit()'"
	strExecutarSubmitProfessorGeral = ""

	intCodEmp				= Session("CodEmpresa")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodGrade 			= Trim(Request("cmbGrade"))
	intCodDisciplinaGrade	= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodTurnoRH 			= Trim(Request("cmbTurnoHorario"))
	intCodTurmaJuncao 		= "Null"
	intDiaSemana 			= Trim(Request.Form("chkDiaSemana"))
	
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = "0"
		
	if intCodDisciplina <> "" or intCodDisciplina <>"0" then
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	end if
	if intCodDisciplinaGrade = "" or intCodDisciplinaGrade = "0" then
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Excluir
	end if

	if intCodTurma 		= "" then intCodTurma 		= "0"
		
	if intCodProfessor 	= "" then intCodProfessor 	= "0"

	if intCodTurno = "" then intCodTurno = "0"

	'controla os botões
	acao = "IE"

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_horario_aula.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-8" class="panel">
                <div class="panel-hdr">
					<h2>
						<%=pagina%> <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						
						<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
						<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
						<input name="txtPodeEditar" value="<%=strPodeEditar%>" type="hidden">
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurmaHorarioMatriz.asp" -->
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Matriz:</label>
									 <!--#include file="includes/inc_cmdGradeCurricularHorarioMatriz.asp" -->
								</div>
							</div>
						</div>
						<%
						if session("usuarioWeb") = "SERGIO" then
							'response.write "strNomeTurno:" & strNomeTurno
						end if
						%>
						<%if UCASE(strNomeTurno) = "INTEGRAL" then%>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									 <%strExecutarSubmitTurno="S"%>
									 <!--#include file="includes/inc_cmbTurnoModulacaoHorarioMatriz.asp" -->
									 <span class="textoAltSenha">&nbsp;Turno informado deverá ser o da modulação.&nbsp; </span>
								</div>
							</div>
						</div>
						<%else
								intCodTurnoRH = intCodTurno
							%>
							<input name="cmbTurnoHorario" type="hidden" id="cmbTurnoHorario" value="<%=intCodTurno%>">
						<%end if%>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Disciplina *:<input name="txtHiddenNomeTurno" type="hidden" id="txtHiddenNomeTurno" value="<%=UCASE(strNomeTurno)%>"></label>
									 <!--#include file="includes/inc_cmdDisciplinaGradeHorarioLancamento.asp" -->
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Professor(a) *:</label>
									 <!--#include file="includes/inc_cmdProfessorAtivo.asp" -->
								</div>
							</div>
						</div>
						
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp" -->
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>

<%

	if trim(intCodTurma) <> "0" and  trim(intCodDisciplinaGrade) <> "0" then
		sql = " SELECT count(cod_turma) as total from SCA_HORARIO_AULA "
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and cod_turma = " & intCodTurma
		sql = sql & " and anoLetivo = " & strAnoLetivo
		sql = sql & " and semestre = " & intSemestre
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		sql = sql & " GROUP BY cod_turma "
		RSAUX.OPEN SQL, CNN
		IF NOT RSAUX.EOF THEN
			TotalHorario = RSAUX("total")
			if isnull(RSAUX("total")) then
			   TotalHorario = "0"
			end if   
		END IF
		RSAUX.CLOSE
		
		'BUSCA SE A TURMA POSSUI MATRIZ CADASTRADA
		Matriz = "NÃO"
		sql = " SELECT "
		sql = sql & " SUM(GD.Ch_Semanal) as total "
		sql = sql & " FROM SCA_TURMA T "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND G.SITUACAO = 'A' "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR "
		sql = sql & " WHERE T.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND COD_TURMA = " & intCodTurma
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		RSAUX.OPEN SQL, CNN
		IF NOT RSAUX.EOF THEN
			TotalMatriz = RSAUX("total")
			if isnull(RSAUX("total")) then
			   TotalMatriz = "0"
			end if   
		END IF
		RSAUX.CLOSE
		SaldoAulas =  TotalHorario - TotalMatriz
		if SaldoAulas < 0 then StatusSaldo = "** Incompleto **"
		if SaldoAulas = 0 then StatusSaldo = "** OK! **"
		if SaldoAulas > 0 then StatusSaldo = "** Carga Horaria Execedida, Verifique! **"
		
	else	
		if SaldoAulas = "" then StatusSaldo = ""
	end if
	
	if intCodDiaSemana = "" then intCodDiaSemana = 0
	if intCodTurma = "" then intCodTurma = 0
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = 0
	if intCodTurnoRH = "" then intCodTurnoRH = 0
	if intCodTurnoRH <> "0" then
	%>
	
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Dia da Semana	
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">		
						
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Dia da Semana</strong></th>
									<th><strong>Sequencia</strong></th>
								  </tr>
								</thead>
								<tbody>
          <% 
		  strAtiva = "none"
		  
		  for i=1 to 7
			
			if trim(intCodTurma) <> "0" then
				
				sql = "  SELECT distinct HA.DIASEMANA"
				sql = sql & " FROM  SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON  T.COD_EMPRESA = HA.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
				sql = sql & " WHERE T.COD_TURMA = " & intCodTurma
				sql = sql & " AND ha.DiaSemana = " & cint(i)
				sql = sql & " AND HA.ANOLETIVO	= " & strAnoLetivo
				RS.OPEN SQL, CNN
				IF not RS.EOF THEN
					seleciona = "checked"
					strAtiva = "block" 
				else
					seleciona = ""
					strAtiva = "none"
				END IF
				rs.close
				
			end if
		  %>		
          <tr>
            <td><input <%=seleciona%> name="chkDiaSemana" onClick="return Sequencia('<%=i%>')" type="checkbox" id="chkDiaSemana" value="<%=i%>" ></td>
            <td><%=WeekDayName(i)%></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>
                <%
				' O padrão aqui e strSemestre, foi alterado para atender o cadastramento da Fanap

				if UCASE(strNomeTurno) = "INTEGRAL" then 
					sql = " SELECT H.Codigo, H.cod_empresa, H.anoLetivo, H.semestre, H.horario, H.Sequencia_Aulas, H.Tempo "
					sql = sql & " FROM SCA_HORARIO H"
					sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = H.CodTurno"
					sql = sql & " where H.Cod_empresa = " & Session("CodEmpresa") 
					sql = sql & " and H.AnoLetivo = " & strAnoLetivo 
					sql = sql & " and H.Semestre = " & intSemestre 
					if intCodTurnoRH <> "0" then
						sql = sql & " and TU.Cod_Turno = " & intCodTurnoRH
					end if
					sql = sql & " Order by H.horario, H.Tempo"
				else
					sql = " SELECT H.Codigo, H.cod_empresa, H.anoLetivo, H.semestre, H.horario, H.Sequencia_Aulas, H.Tempo "
					sql = sql & " FROM SCA_HORARIO H"
					sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = H.CodTurno"
					sql = sql & " where H.Cod_empresa = " & Session("CodEmpresa") 
					sql = sql & " and H.AnoLetivo = " & strAnoLetivo 
					sql = sql & " and H.Semestre = " & intSemestre 
					if intCodTurno <> "0" then
						sql = sql & " and TU.Cod_Turno = " & intCodTurno
					end if
					sql = sql & " Order by H.horario, H.Tempo"
				end if
				
				rs.open sql, cnn
				if not rs.eof then  
					%>
                    <div align="center"  id="mostraSequencia<%=i%>" style="display:<%=strAtiva%>">
                	<table width="98%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						<%	
						cont = 0
						contador = 0
						while not rs.eof
						
							sql = "  SELECT H.horario, HA.COD_DISCIPLINA, D.Desc_Disciplina"
							sql = sql & " FROM  SCA_HORARIO_AULA HA "
							sql = sql & " INNER JOIN SCA_TURMA T ON  T.COD_EMPRESA = HA.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
							sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
							sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina=HA.COD_DISCIPLINA"
							sql = sql & " WHERE T.COD_TURMA = " & intCodTurma
							sql = sql & " AND HA.ANOLETIVO	= " & strAnoLetivo
							sql = sql & " AND ha.DiaSemana = " & cint(i)
							sql = sql & " AND H.codigo =  " & rs("Codigo")
							'if UCASE(session("usuarioWeb")) = "SERGIO" then
							'	response.Write(sql)
							'	RESPONSE.END
							'end if
							
							RSAUX.OPEN SQL, CNN
							IF not RSAUX.EOF THEN
								
								selecionaHorario = "checked"
								selecionaInativa = "SIM"
								strDisciplina = trim(RSAUX("Desc_Disciplina"))
								
								if intCodDisciplinaGrade = trim(RSAUX("COD_DISCIPLINA")) then
									selecionaCor	= "#FB5424"
									selecionaInativa = ""
								else
									selecionaCor	= "#FFFFCC"
								end if
								
								'if trim(RSAUX("TipoHorario")) = "E" then 'Horario Extra
								'	selecionaCor	= "#C4E1FF"
								'	selecionaHorario = ""
								'	selecionaInativa = "SIM"
								'end if
								
							else
								selecionaHorario = ""
								selecionaCor = ""
								selecionaInativa =""
							END IF
							RSAUX.close
					
					 
							if cint(cont) = 3 then 
								%>
							<tr>
							  <%
							end if
							
							if isnull(rs("Tempo")) or rs("Tempo") = "" then
								strMensagem = "Verifique o cadastro de faixa de horario. Campo Tempo invalido!"
								%>
								<script>
									alert("<%=strMensagem%>");
									window.location.href ='Default.asp'
								</script>
								<%
								response.end
							end if	
							%>
							<td width="33%" class="TextoForm" bgcolor="<%=selecionaCor%>" >
							<%if selecionaInativa = "" then %>
							 <input <%=selecionaHorario%> name="chkSequenciaAula<%=i%>" type="checkbox" value="<%=rs("Codigo")%>"><%=rs("horario")%> - <%=rs("Sequencia_Aulas")%>&ordf; Aula
							<%else %>
							 &nbsp;&nbsp;&nbsp;<%=rs("horario")%> - <%=rs("Sequencia_Aulas")%>&ordf; Aula - <%=strDisciplina%>
							<%End if %>                    
							</td>
							  <%
							cont = cont + 1
							contador = contador + 1
							if cint(cont) = 3 then 
								%>
								</tr>
								<tr>
								<%
								cont  = 0
							end if
							rs.movenext
						wend
						%>
						</tr>
					  </table>
					  </div>
					<%
				else	
					strMensagem = "Faixa de horario ainda nao cadastrada para esse Ano/Semestre. Verifique!"
					%>
					<script>
						alert("<%=strMensagem%>");
					</script>
					<%
					response.end
					
				end if
				rs.close				  
				%>
				</td>
			 </tr>
          <% next%>
		  
		  <tr>
			<td colspan="2">
			<div align="center"><strong>Status do Lan&ccedil;amento</strong> ( Matriz Curricular:&nbsp;<span class="texto1"><strong><%=TotalMatriz%></strong></span>&nbsp;-&nbsp; Hor&aacute;rio de Aula:&nbsp;<span class="texto1"><strong><%=TotalHorario%></strong></span>&nbsp;) = Saldo:&nbsp;<span class="texto1"><strong><%=SaldoAulas%></strong></span>&nbsp; - <span class="texto1"><strong><%=StatusSaldo%></strong></span>&nbsp;</div>
			</td>
		  </tr>
		   <tr>
			<td colspan="2">
			<div align="center"><strong>Obs: Todos campos marcados com (*) permitir&aacute; altera&ccedil;&atilde;o durante a manuten&ccedil;&atilde;o do hor&aacute;rio. </div>
			</td>
		  </tr>
								</tbody>
							</table>
						</div>	
					</div>
				</div>
			</div>
		</div>
	</div> 
	
    <%
	end if
	%>
	
<%
	if intCodTurma    = "" then intCodTurma="0"
	if intCodTurma<>"0" then%> 

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastradas
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">		
						
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Per&iacute;odo</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Hor&aacute;rio</strong></th>
									<th><strong>Sequencia</strong></th>
									<th><strong>Tempo</strong></th>
									<th><strong>Dia Semana</strong></th>
									<th><strong>Disciplina</strong></th>
									<th><strong>Turno</strong></th>
									<th><strong>Professor(a)</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								cont =0
								sql = "SELECT distinct	HA.CODIGO, P.DESCRICAO AS PERIODO, T.NOMETURMA, T.TURMAALUNO, H.HORARIO, HA.TEMPO, HA.DIASEMANA, HA.SEQUENCIA, C.NOME AS PROFESSOR, "
								sql = sql & " D.DESC_DISCIPLINA, TJ.NOMETURMA AS TURMAJUNCAO, HA.TipoHorario, turSCA.desc_turno as turno"
								sql = sql & " FROM	SCA_HORARIO_AULA HA"
								sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
								sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
								sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
								sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
								sql = sql & " LEFT JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.Cod_Colaborador = HA.COD_COLABORADOR AND HA.ANOLETIVO = M.ANO_LETIVO"
							    sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR "
								
								sql = sql & " LEFT  JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
								sql = sql & " LEFT JOIN SCA_TURMA TJ ON TJ.COD_EMPRESA=HA.COD_EMPRESA AND TJ.COD_TURMA=HA.TURMA_JUNCAO"
								sql = sql & " LEFT JOIN SCA_turno turSCA ON turSCA.COD_turno=H.codturno"
								
								sql = sql & " WHERE	1=1 "
								if UCASE(strNomeTurno) = "INTEGRAL"  then 
									if intCodTurnoRH <> "0" then
										sql = sql & " AND M.Cod_Turno = " & intCodTurnoRH
									end if
								end if
								if strCompartilharDados = "S" then
									sql = sql & " AND	HA.COD_EMPRESA	= " & Session("CodEmpresa")
								end if   
								
								sql = sql & " AND		HA.ANOLETIVO	= " & strAnoLetivo
								sql = sql & " AND		HA.SEMESTRE		in (" & intSemestre & ")"
								sql = sql & " AND		P.COD_CURSO		= " & intCodCurso
								
								if intCodDisciplinaGrade <> "0" then
									sql = sql & " AND		D.COD_DISCIPLINA		= " & intCodDisciplinaGrade
								end if
								
								if intCodTurno <> "0" then
									sql = sql & " AND		T.COD_TURNO		= " & intCodTurno
								end if
								
								if intcodPeriodo <> "0" then
									sql = sql & " AND		G.COD_PERIODO	= " & intcodPeriodo
								end if
								
								if intCodTurma <> "0" then
									sql = sql & " AND		T.COD_TURMA		= " & intCodTurma
								end if
								
								sql = sql & " Order by DESCRICAO, NOMETURMA, DIASEMANA, horario "
								
								rs.open sql, cnn
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1	
					
										strCorLinha = ""
										
										if ucase(trim(rs("diasemana"))) = 1 then
											strCorLinha = "bgcolor='#FDA29F'"
										end if
										
										if ucase(trim(rs("diasemana"))) = 2 then
											strCorLinha = "bgcolor='#FFFFCC'"
										end if
										
										if ucase(trim(rs("diasemana"))) = 3 then
											strCorLinha = "bgcolor='#CAFEB4'"
										end if
										
										if ucase(trim(rs("diasemana"))) = 4 then
											strCorLinha = "bgcolor='#D8D8D8'"
										end if
										
										if ucase(trim(rs("diasemana"))) = 5 then
											strCorLinha = "bgcolor='#C2CAFC'"
										end if
										
										if ucase(trim(rs("diasemana"))) = 6 then
											strCorLinha = "bgcolor='#CCE6E6'"
										end if
										
										if ucase(trim(rs("diasemana"))) = 7 then
											strCorLinha = "bgcolor='#FDA29F'"
										end if
										
										%>
										 <tr <%=strCorLinha%>>
											<td><%=rs("periodo")%></td>
											<td><%=rs("TurmaAluno")%>&nbsp;&nbsp;<%=rs("nometurma")%></td>
											<td><%=trim(rs("horario"))%></td>
											<td><%=trim(rs("sequencia"))%>&ordf; Aula </td>
											<td><%=trim(rs("tempo"))%>&deg;</td>
											<td><%=WeekDayName(trim(rs("diasemana")))%></td>
											<% if isnull(rs("DESC_DISCIPLINA")) or trim(rs("DESC_DISCIPLINA")) = "" then %>
												<td> ** Planejamento **</td>
											<% else %>    
												<td><%=trim(rs("DESC_DISCIPLINA"))%>&nbsp;</td>
											<% end if %> 
											
											<td><%=trim(rs("turno"))%>&nbsp;</td>
											<% if isnull(rs("PROFESSOR")) then %>
												<td> ** Deficit **</td>
											<% else %>    
												<td><%=trim(rs("PROFESSOR"))%>&nbsp;</td>
											<% end if %> 
										</tr>
										<%
										rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
									 <td colspan="9" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
									 </tr>
									 <%
								  end if
								  rs.close
								%>
								</tbody>
							</table>
						</div>	
					</div>
				</div>
			</div>
		</div>
	</div> 
		<%
		end if
		%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>