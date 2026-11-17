<%
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strBloqueia_NotasDocente = ""
	
	
	Function fnVerificaDataHabilitada(dataHoje, data)

		Dim dHoje, dVerifica
		Dim arrHoje, arrData

		' Quebra as datas
		arrHoje = Split(dataHoje, "/")
		arrData = Split(data, "/")

		' Converte para Date (ano, mês, dia)
		dHoje = DateSerial(arrHoje(2), arrHoje(1), arrHoje(0))
		dVerifica = DateSerial(arrData(2), arrData(1), arrData(0))

		' Se a data a verificar for MAIOR que hoje => FALSE
		' Senão => TRUE
		If dVerifica > dHoje Then
			fnVerificaDataHabilitada = False
		Else
			fnVerificaDataHabilitada = True
		End If

	End Function
	
	'Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and (CodCategoria = 1 OR CodCategoria = 8)"'professor (Guapó: igual às telas de faltas disciplinar/interdisciplinar)
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false and trim(Session("Seg_CodCategoria")) = "1" then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
		intcategoria="1"
	else
		intcategoria="0"
		strVerificaCategoria = ""
		
		if strAcessoPerfil = "COORDENADOR" then
			intcategoria="0"
			strVerificaCategoria = ""
		else
			sql = "select cod_colaborador "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")
			sql = sql & " and status = 'A'" 'Ativo
			sql = sql & " and cod_colaborador in ("
			sql = sql & " select codigo "
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
			sql = sql & " and Situacao = 'A'" 'Ativo
			sql = sql & " )"
			rsAux.open sql, cnn
			if rsAux.EOF = false then	
				strVerificaCategoria 		= "Professor"
				intCodColaboradorProfessor 	= trim(rsAux("cod_colaborador"))
				intcategoria="1"
			end if
			rsAux.close
		end if
	end if
	rs.close
	
	'response.write intcategoria & "-" & strVerificaCategoria
	strExecutarSubmitCurso	  	= "S"
	strExecutarSubmitPeriodo  	= "S"
	strExecutarSubmitSemestre 	= "S"
	strExecutarSubmitTurno	  	= "S"
	strExecutarSubmitTurma	 	= "S"
	strExecutarSubmitMes 		= "S"
	strSemestre 				= session("strSemestre")
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
		strAnoLetivo = session("strAnoLetivo")	'ano letivo vem da sessão (Trocar Ano Letivo)
	end if
	strQtdeFaltas = request("txtQtdeFaltas")
	if strQtdeFaltas = "" then strQtdeFaltas = "1"
	
	'REGRA QUANDO O ANO DIGITADO FOR MENOR QUE O DA SESSION
	'SERÁ GRAVADO DO ARQUIVO DE HISTORICO
	if Cint(strAnoLetivo) < Cint(session("strAnoLetivo")) then
		'GRAVANDO NO ARQUIVO DE HISTORICO
		strGravarOnde = "HISTORICO"
		strMsnBotaoHistorico  = " notas no Histórico"
	else
		'GRAVANDO NO ARQUIVO DE NOTAS
		strGravarOnde = "NOTA"
		strMsnBotaoHistorico  = ""
	end if
	
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	intCodGrade				= Trim(Request("cmbGrade"))
	strQuinzena	 			= Trim(Request("cmbQuinzena"))
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
	strMes					= Trim(Request("cmbMes"))
	intCodAvaliacao			= Trim(Request("cmbAvaliacao"))

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	strData					= trim(request("txtData"))
	strAtivos				= trim(request("cmbativos"))
	
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	strTipoPeriodo = "D"
	sql = " SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, "
	sql = sql & " SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_PERIODO.Tipo "
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
		strTipoLancamento = rs("Tipo")
	END IF
	rs.close
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

	'controla os botões
	acao = "A"
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_faltaCon.asp">
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
			
			<%'Guapó: sem vídeo tutorial%>
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
						

						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" readonly>
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
						
							
							<% if strVerificaCategoria <> "Professor" then%>
							<div class="col-sm-5">
								<div class="form-group">
								
									<label class="form-label">Turma:</label>
									<!--#include file="includes/inc_cmdTurma.asp"-->
								</div>
							</div>
							<%end if%>
							<% if strVerificaCategoria = "Professor" then%>
							<div class="col-sm-5">
								<div class="form-group">
									<label class="form-label">Turma <%=strVerificaCategoria%>:</label>
									<!--#include file="includes/inc_cmdTurmaProfessor.asp"-->
								</div>
							</div>
							<%end if%>
							
							<% if strVerificaCategoria = "Professor" then%>
							<div class="col-sm-3">
								<div class="form-group">
								
									<label class="form-label">Disciplina Professor:</label>
									<!--#include file="includes/inc_cmdDisciplinaDoProfessorFaltas.asp"-->
									- Caso n&atilde;o seja informado a disciplina ser&aacute; atualizada pelo hor&aacute;rio.
								</div>
							</div>
							<%end if%>
							
							<% if strVerificaCategoria <> "Professor" then%>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Disciplina Professor:</label>
									<!--#include file="includes/inc_cmbDisciplinaTurmaFaltas.asp"-->
								</div>
							</div>
							<%end if%>
							
						</div>
						
						<div class="row">
						
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Mês:</label>
									<!--#include file="includes/inc_cmbMes.asp"-->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Op&ccedil;&otilde;es de lan&ccedil;amentos:</label>
									<select name="cmbQuinzena" class="form-control" id="cmbQuinzena" onChange='submit()'>
										<option value="1" <%if strQuinzena = "1" then response.Write("selected") %>>1º Quinzena</option>
										<option value="2" <%if strQuinzena = "2" then response.Write("selected") %>>2º Quinzena</option>
										<option value="3" <%if strQuinzena = "3" then response.Write("selected") %>>Por dia</option>
									</select>
								</div>
							</div>
						
						<% if strQuinzena = "3" then %>
							
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Data:</label>

									<select name="txtData" id="txtData" class="form-control">
										<option value="0">Selecione</option>
										
										<%
										'Consulta os dias letivos do mês selecionado
										'--lista calendario com hosrario horario da turma
										sql="select d.dia_mes, e.letivo"
										sql=sql & " from sca_calendario_dia_ue d"
										sql=sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue"
										sql=sql & " inner join sca_calendario ca on ca.cod_calendario = c.cod_calendario_geral"
										sql=sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento"
										sql=sql & " where c.cod_empresa = " & Session("CodEmpresa")
										sql=sql & " and ca.cod_curso = " & intCodCurso
										sql=sql & " and d.mes = " & strMes
										sql=sql & " and d.ano = " & strAnoLetivo
										sql=sql & " and d.dia_semana in ("
										sql=sql & " 	select distinct SCA_HORARIO_AULA.diaSemana"
										sql=sql & " 	from SCA_HORARIO_AULA "
										sql=sql & " 	inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario "
										sql=sql & " 	where SCA_HORARIO_AULA.anoletivo = " & strAnoLetivo
										sql=sql & " 	and SCA_HORARIO_AULA.cod_turma = " & intCodTurma
										if intCodDisciplina<>"0" then
											sql=sql & " 	and SCA_HORARIO_AULA.cod_disciplina = " & intCodDisciplina
										end if
										sql=sql & " )"								
										sql=sql & " order by d.dia_mes"
										'response.write sql
										rs.open sql, cnn
										if rs.eof = false then
											while not rs.eof
												strDataDia = formataDataAP(rs("dia_mes") & "/" & strMes & "/" & strAnoLetivo)

												strSelecionado = ""
												if formataDataAP(strData) = formataDataAP(rs("dia_mes") & "/" & strMes & "/" & strAnoLetivo)  then
													strSelecionado = "selected" 
												end if

												strDesabilitaHabilitaData = ""
												if rs("letivo") <> "S" or not fnVerificaDataHabilitada(formataDataAP(date), strDataDia)  then
													strDesabilitaHabilitaData = "disabled"
												end if
												
												%>
												<option value="<%=strDataDia%>" <%=strSelecionado%> <%=strDesabilitaHabilitaData%>>
													<%=strDataDia & " | "%><% if rs("letivo") = "S" then response.write "DIA LETIVO" else response.write "DIA NÃO LETIVO" %>
												</option>
												<%
												rs.movenext
											wend
										end if
										rs.close
										%>
									</select>


								</div>
							</div>	
							
							
							
						<% end if%>
						
							
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Avaliação:</label>
									<!--#include file="includes/inc_cmbAvaliacaoFaltas.asp"-->
								</div>
							</div>
							
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Situações:</label>
									<!--#include file="includes/inc_cmbAtivos.asp"-->
								</div>
							</div>
						</div>
						
	
							
						<br>
						<div class="frame-wrap">
							<button onClick="return cadastrarFaltas()"  name="cmbCadastrar" id="cmbCadastrar" type="button" class="btn btn-outline-success">Cadastrar<%=strMsnBotaoHistorico%></button>
							<button onClick="window.location='sca_faltaCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-warning">Limpar tela</button>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%
	if intCodTurma    	= "" then intCodTurma="0"
	if intCodSemestre 			= "" then intCodSemestre="0"
	
	if intCodTurma<>"0" and strMes<>"0" and strMes<>"" then

	%>

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastradas - alunos ativos
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
									<th><input name="chkTodos" type="checkbox" value="" onClick="return MarcaTodosAlunos(this.checked)"></th>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Ocorr&ecirc;ncias</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								'seleciona os alunos da turma através de sua disciplina
								Cont=0
								if strAtivos = "A" then
									intCodSituacaoAluno = 1
								end if
								'response.write "strAtivos:" & strAtivos
								sql = sqlAlunoTurma(intCodTurma, "")
								rs.open sql, cnn
								if rs.eof = false then
									while not rs.eof
										
										strSituacaoAluno	  	= rs("Desc_SituacaoAluno")
										if strSituacaoAluno = "ATIVO" then 
											strSituacaoAluno = "" 
										Else
											strSituacaoAluno = "<br><span style='font-size:11px; color:red;'>(" & strSituacaoAluno & ")</span>"
										end if 
										
										strCodigoAluno      = rs("codigo")
										strMatricula		= rs("MATRICULA")
										
										sql = " select ad.codigo, ad.COD_DISCIPLINA, nf.codigo as codNota from SCA_ALUNO_DISCIPLINA ad "
										sql = sql & " left join SCA_NOTAS_FALTAS nf on nf.cod_aluno_disciplina = ad.CODIGO "
										sql = sql & " where ad.COD_ALUNO = " & strCodigoAluno
										'só disciplinas de turma do ano letivo da tela: sem isso, depois da renovação, criava notas do ano anterior nas disciplinas da turma do ano seguinte
										sql = sql & " and exists (select 1 from SCA_TURMA tma where tma.Cod_Turma = ad.COD_TURMA and tma.AnoLetivo = " & clng(strAnoLetivo) & ")"
										sql = sql & " and ISNULL(nf.codigo,'0') = '0' " 
										rs1.open sql, cnn
										if rs1.eof = false then
											while not rs1.eof
												strCodDisciplinaNovo  	= rs1("COD_DISCIPLINA")
												strCodAlunoDisciplina  	= rs1("CODIGO")
												
												if strCodAlunoDisciplina <> "0" then
													'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
													strCriaNotas = "S"
													'sql = "SELECT COD_ALUNO_DISCIPLINA "
													'sql = sql & " FROM SCA_NOTAS_FALTAS "
													'sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
													'rsAux.open sql, cnn
													'if rsAux.eof then
													if isnull(rs1("codNota")) then
														strCriaNotas = "N"
														strDesabilitaAluno 	= " disabled "
														strmensagem	= " <br><strong>(Não não existe registro de notas)</strong>"
													end if
													'end if
													'rsAux.close
													if strCriaNotas = "N" then
													   strMarcaCriaNotas = "N"
													   SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
													   SQL = SQL & "ano_letivo, semestre, cod_disciplina, nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05, nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10, nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, situacao, media )  VALUES ("
													   SQL = SQL & "" & Session("CodEmpresa") & ","
													   SQL = SQL & "" & strCodigoAluno & ","
													   SQL = SQL & "" & strCodAlunoDisciplina & ","
													   SQL = SQL & "" & intCodPeriodo & ","
													   SQL = SQL & "" & strAnoLetivo & ","
													   SQL = SQL & "" & intSemestre & ","
													   SQL = SQL & "" & rs1("COD_DISCIPLINA") & ","
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null,"
													   SQL = SQL & "null)"
													   cnn.execute SQL
													   'GravarLog sql - Não é necessário porque o próprio sistema cria quando não tiver notas
													end if
												 end if
												rs1.movenext
											wend
										end if
										rs1.close
										

										'Função que verifica a siuação do aluno
										strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
										 cont = cont + 1
										 %>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina">
												<input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO")%><%=strSituacaoAluno%><%=tipo_criterio%><%=strmensagem%></td>
											<td><button onClick="lancarOcorrencias('<%=rs("codigo")%>','<%=rs("NOMEALUNO")%>')" type="button" class="btn btn-outline-success btn-sm">Ocorrencias</button></td>
										</tr>
										 <%
										 rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
									 <td colspan="4" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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
		<input  name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
		<input  name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">
		<input  name="txtTipoLancamento" type="hidden" id="txtTipoLancamento" value="<%=strTipoLancamento%>">
		<input  name="txtCodCriterio" 	type="hidden" id="txtCodCriterio" value="<%=intCodCriterio%>">
		<input  name="txtPosicao" 		type="hidden" id="txtPosicao" value="<%=strPosicao%>">
		<input  name="txtDataInicio" 	type="hidden" id="txtDataInicio" 	value="<%=strDataInicio%>">
		<input  name="txtDataFim" 		type="hidden" id="txtDataFim"	 	value="<%=strDataFim%>">
		<input  name="txtBimestre" 		type="hidden" id="txtBimestre"	 	value="<%=strBimestre%>">
		<input  name="txtVerificaCategoria" 		type="hidden" id="txtVerificaCategoria"	 	value="<%=strVerificaCategoria%>">
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>