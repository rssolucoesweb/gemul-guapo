<script>

	function ExcluirFalta(CodFalta, CodAluno, AlunoDisc, Falta, CodHistoricoDisciplina){
		var men = 'ATENÇÃO: \nA falta do aluno será excluida, deseja continuar?';
		if (confirm(men)) {
			frm.action="Faltas_exc.asp?txtAluno=" + CodAluno + "&txtAlunoDisc=" + AlunoDisc + "&txtCodFalta=" + CodFalta + "&Falta=" + Falta + "&txtCodHistoricoDisciplina=" + CodHistoricoDisciplina;
			frm.submit();
			return true;
		}
	}

	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		frm.action="sca_falta_interdisciplinar_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	acao 					= "A"

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strMes		 		= Trim(Request("cmbMes"))	
	strQuinzena		 	= Trim(Request("cmbQuinzena"))	
	strDataLancamento	= trim(request("txtDataLancamento"))

	if trim(strDataLancamento) <> "" then
		if trim(strMes) <> trim(month(strDataLancamento)) then
			%>
			<script>
				alert("O mes de lancamento nao confere com a data informada.");
				window.location="sca_falta_interdisciplinarCon.asp";
			</script>
			<%
			response.end
		end if
	end if
   
	if strMes = "12" then
	   qtdeDiasMes  = "31"
	   if strQuinzena = "1" then
	       qtdeDiasMes  = "15"
	   end if   
	else   
		aux=Cdate("01/" & cInt(ZEROLEFT(strMes,2))+1 & "/" & cInt(strAnoLetivo)) - 1
		if strQuinzena = "1" then
			aux=Cdate("16/" & cInt(ZEROLEFT(strMes,2))+1 & "/" & cInt(strAnoLetivo)) - 1
		end if	
	    qtdeDiasMes = day(aux)
	end if	
	
	'GRAVANDO NO ARQUIVO DE NOTAS
	strGravarOnde = "NOTA"
	msnHistorico  = ""
		
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
	
	intCodCurso	 				= Trim(Request("cmbCurso"))
	intCodPeriodo 				= Trim(Request("cmbPeriodo"))
	intSemestre 				= Trim(Request("cmbSemestre"))
	
	intCodTurno		 			= Trim(Request("cmbTurno"))
	strAlunos      				= Trim(Request("chkAluno"))
	intCodAvaliacao				= Trim(Request("cmbAvaliacao"))
	intCodTipoLancamento		= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	sql="select c.cod_tipo_lancamento as codigo, c.descricao, c.posicao"
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " and c.cod_tipo_lancamento = " & intCodAvaliacao
	
	rs.open sql, cnn
	if rs.eof = false then
		strNomeTipoLancamento 	= trim(rs("descricao"))
		strCodTipoLancamento	= trim(rs("codigo"))
		strPosicao 				= ZeroLeft(rs("POSICAO"),2)
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.history.back();
		</script>
		<%
		response.end
	end if
	rs.close

	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	intMarcaQuinzena = 1	
	if strQuinzena = "2" then intMarcaQuinzena = 16		
	if strQuinzena = "3" then ' So quando for por dia
		if trim(strDataLancamento) = "" then
			%>
			<script>
				alert("Informe corretamente a DATA do dia do lancamento.");
				window.location="sca_falta_interdisciplinarCon.asp";
			</script>
			<%
			response.end
		end if
		intMarcaQuinzena = day(strDataLancamento)
		qtdeDiasMes = day(strDataLancamento)		
	end if
		%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_ajuste_falta.asp">
		<input type="hidden" name="txtPosicao" value="<%=strPosicao%>">
        <input type="hidden" name="cmbQtdeFaltas" value="<%=strQtdeFaltas%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
		<input type="HIDDEN" name="txtData" value="<%=strData%>">

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
				<%=descricao_pagina%> - Cadastro de Faltas pelo Horário de Aula
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
						
						<%
						sql = "SELECT TU.NOMETURMA, TU.TURMAALUNO, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO "
						sql = sql & " FROM SCA_TURMA TU"
						sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO "
						sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
						sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
						rsAux.open sql, cnn
						if not rsAux.eof then
							TURMAALUNO = rsAux("TURMAALUNO")
							NOMETURMA = rsAux("NOMETURMA")
							DESC_TURNO = rsAux("DESC_TURNO")
						end if
						rsAux.close
						%>
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
							<input name="txtPodeEditar" value="<%=strPodeEditar%>" type="hidden">
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Turma:</label>
										<BR><STRONG><%=TURMAALUNO%> <%=NOMETURMA%></STRONG>
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Turno:</label>
										 <BR><STRONG><%=DESC_TURNO%></STRONG>
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Disciplina:</label>
										<BR><STRONG>
										<%if strNomedisciplina="" then%>Todas do Horário<%else%><%=strNomedisciplina%><%end if%>&nbsp;
										</STRONG>
									</div>
								</div>
							</div>
							
							<br>
							<div class="frame-wrap">
								<button onClick="return salvar('A')"  name="cmbCadastrar" id="cmbCadastrar" type="button" class="btn btn-outline-success">Salvar Faltas</button>
								<button onClick="window.location='sca_falta_interdisciplinarCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-danger">Voltar</button>
							</div>
							
				
					</div>
				</div>
			</div>
		</div>
	</div>
	<%

	sql = " SELECT distinct "
	sql = sql & " AD.COD_ALUNO AS CODIGO, " 
	sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
	sql = sql & " A.NOMEALUNO, "
	sql = sql & " A.MATRICULA "

	for i=intMarcaQuinzena to qtdeDiasMes
		strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(i,2)
		strDataCampo = strAnoLetivo & "-" & ZeroLeft(strMes,2) & "-" & ZeroLeft(i,2)

		sql = sql & " 			,isnull(("
		sql = sql & " 					select top 1 mn.COD_ALUNO from SCA_FALTAS_DIARIA mn "
		sql = sql & " 								inner join SCA_ALUNO_DISCIPLINA ad1 on ad1.codigo = mn.cod_aluno_disciplina "
		sql = sql & " 								where mn.COD_ALUNO  = AD.COD_ALUNO"
		sql = sql & " 								and	  mn.cod_empresa = AD.COD_EMPRESA"
		sql = sql & " 								and	  ad1.COD_TURMA_REMANEJAMENTO = AD.COD_TURMA_REMANEJAMENTO "
		sql = sql & " 								and   mn.data = '"&strData&"'"
		if trim(intCodDisciplina) <> "0" then
		   sql = sql & " 								and   mn.COD_DISCIPLINA = " & intCodDisciplina
		end if   
		sql = sql & " 					),'0') as [" &strDataCampo& "]"
	next

	sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD  " 
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO "
	sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")

	if trim(intCodTurma) <> "0" then
		sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
	end if

	if trim(intCodDisciplina) <> "0" then
		sql = sql & " AND  AD.COD_DISCIPLINA = " & intCodDisciplina
	end if
	sql = sql & " AND AD.COD_ALUNO in (" & strAlunos & ") "
	sql = sql & " ORDER BY A.NOMEALUNO "
	
	rs.open sql, cnn,3,1
	
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%>
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
									<th align="center" colspan="<%=4+qtdeDiasMes%>"><strong><%=ucase(monthName(strMes))%> / <%=strAnoLetivo%> - <%=strNomeTipoLancamento%></strong></th>
								  </tr>
								  <tr>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome do aluno</strong></th>
									<%for i=intMarcaQuinzena to qtdeDiasMes%>
									<th><strong><%=ZeroLeft(i,2)%></strong></th>
									<%next%>
								  </tr>
								</thead>
								<tbody>
								<%
								  contLanc = 0
								  while not rs.eof
										contLanc = contLanc + 1
										strCodAluno = RS("CODIGO")
																				
									  %>
									  <tr>
										<td ><%=zeroleft(contLanc,2)%></td>
										<td >&nbsp;<%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
										<td >&nbsp;<%=rs("NOMEALUNO")%><br>
										<%
										for i=intMarcaQuinzena to qtdeDiasMes
											strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(i,2)
											strDataCampo = strAnoLetivo & "-" & ZeroLeft(strMes,2) & "-" & ZeroLeft(i,2)
											selecionado = ""
											if rs(strDataCampo) <> 0 then
												selecionado = "checked"
											end if
											
											diaSemana = weekday(strData)
											if diaSemana = 1 then
											   cor = "bgcolor='#FF0000'" 
											elseif diaSemana = 7 then 
											   cor = "bgcolor='#FFFF00'"
											else   
											   cor = ""
											end if   
											
											%>
											<td <%=cor%> class="celula" width="1%" align="center"><input  <%=selecionado%> type="checkbox" name="txtFaltas_<%=strCodAluno%>_<%=strData%>" id="txtFaltas_<%=strCodAluno%>_<%=strData%>" value="<%=strData%>"></td>
											<%
										next
										%>
										</tr>
									  <%
										rs.movenext
								  wend
								  rs.close
								  cnn.close
								  %>
								  <tr>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome do aluno</strong></th>
									<%for i=intMarcaQuinzena to qtdeDiasMes%>
									<th><strong><%=ZeroLeft(i,2)%></strong></th>
									<%next%>
								  </tr>
									 </table>
									 <input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
									<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
									<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
									<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
									<input type="hidden" name="cmbDisciplinaTurma" value="<%=intCodDisciplina%>">
									<input type="hidden" name="chkTipoNota" value="<%=intCodTipoNota%>">
									<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>">
									<input type="hidden" name="cmbTurno" value="<%=intCodTurno%>">
									<input type="hidden" name="chkAluno" value="<%=strAlunos%>">
									<input type="hidden" name="cmbTipoLancamento" value="<%=intCodTipoLancamento%>">
									<input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">
									<input type="hidden" name="txtQuinzena" value="<%=strQuinzena%>">
									<input type="hidden" name="txtQtdeDias" value="<%=qtdeDiasMes%>">
									<input type="hidden" name="cmbMes" value="<%=strMes%>">	
									<input type="hidden" name="txtDataLancamento" value="<%=strDataLancamento%>">	
									<%
									
										strParametro = "sca_falta_interdisciplinarCon.asp?cmbPeriodo="&intCodPeriodo
										strParametro = strParametro & "&cmbSemestre="&intSemestre
										strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
										strParametro = strParametro & "&cmbTurma="&intCodTurma
										strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
										strParametro = strParametro & "&chkAluno="&strAlunos
										strParametro = strParametro & "&cmbTurno="&intCodTurno
										strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
										strParametro = strParametro & "&cmbCurso="&intCodCurso	
										strParametro = strParametro & "&cmbMes="&strMes
										strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplinaTurma
										strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplinaTurma
										
									%>
									 <table width="188" class="table table-bordered table-hover m-0">
									  <tr>
										<td width="18" height="22" align="center" bgcolor="#FFFF00" class="TextoForm">&nbsp;</td>
										<td width="157" class="texto">&nbsp;S&aacute;bado</td>
									  </tr>
									  <tr>
										<td height="22" align="center" bgcolor="#FF0000" class="TextoForm">&nbsp;</td>
										<td class="texto">&nbsp;Domingo</td>
									  </tr>
									</table> 
									
									<input type="hidden" name="txtAnoLetivo" value="<%=strAnoLetivo%>">
									<input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
									<input type="hidden" name="txtPaginaRetorno" value="FALTASPROF"> 
								</tbody>
							</table>
						</div>	
					</div>
				</div>
			</div>
		</div>
	</div> 
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>