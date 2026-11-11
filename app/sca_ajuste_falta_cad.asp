<script>

	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	
	function salvar(acao){
		frm.action="sca_ajuste_falta_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	acao 					= "A"

	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao = " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
		intcategoria="1"
		strTipoAcessoCadastroNotas = "PROF"
	else
		intcategoria="0"
		strVerificaCategoria = ""
		strTipoAcessoCadastroNotas = "ADM"
	end if
	rs.close


	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	strAtivos               = trim(request("cmbativos"))
	
	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodDisciplinaTurma	= intCodDisciplina
	strAlunos      			= Trim(Request("chkAluno"))
	intCodTipoNota			= Trim(Request("chkTipoNota"))
	intCodTipoLancamento	= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	bloqueiaAcumuladaFalta	= Trim(Request("cmbBloqueiaFaltas"))	
		
	buscaHistorico = "N"
   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
	  buscaHistorico = "S"
	  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
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

	
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	strBimestreAtual 	= ""
	strBimestre1		= "1Bim"
	strBimestre2		= "2Bim"
	strBimestre3		= "3Bim"
	strBimestre4		= "4Bim"
	strExameFinal		= "5EF"
	strExameFinal		= "6CC"
	strCodBimestre		= ""
	strNotaDoTipoEF		= ""
	
	sql="select c.cod_tipo_lancamento as codigo, c.descricao, c.posicao"
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " and c.cod_tipo_lancamento = " & intCodTipoNota
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
	
	
		%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_ajuste_falta.asp">
		<input type="HIDDEN" name="txtPosicao" value="<%=strPosicao%>">
		<input type="HIDDEN" name="txtTipoLancamento" value="<%=strCodTipoLancamento%>">
        <input type="HIDDEN" name="cmbativos" value="<%=strAtivos%>">

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
				<%=descricao_pagina%> <%=msnHistorico%>
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
							<input name="txtAnoLetivo" type="hidden" id="txtAnoLetivo" value="<%=strAnoLetivo%>">
							<input name="txtPodeEditar" value="<%=strPodeEditar%>" type="hidden">
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Turma:</label>
										<BR><STRONG><%=TURMAALUNO%> <%=NOMETURMA%></STRONG>
									</div>
								</div>
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Turno:</label>
										 <BR><STRONG><%=DESC_TURNO%></STRONG>
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Disciplina:</label>
										 <%IF strTipoAcessoCadastroNotas = "ADM" THEN%>
										<!--#include file="includes/inc_cmbDisciplinaTurma.asp"-->
										<%ELSEIF strTipoAcessoCadastroNotas = "PROF" THEN%>
										<!--#include file="includes/inc_cmdDisciplinaDoProfessor.asp"-->
										<%END IF%>
									</div>
								</div>
							</div>
							
							<br>
							<div class="frame-wrap">
								<button onClick="return salvar('A')"  name="cmbCadastrar" id="cmbCadastrar" type="button" class="btn btn-outline-success">Salvar Faltas</button>
								<button onClick="window.location='sca_ajuste_faltaCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-warning">Limpar tela</button>
							</div>
							
				
					</div>
				</div>
			</div>
		</div>
	</div>
	<%

	IF buscaHistorico = "N" then
	   'SELECIONA OS ALUNOS REGULARES CONFORME DISCIPLINA CADASTRADA
	   sql = " SELECT "
	   sql = sql & " AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
	   sql = sql & " AD.COD_ALUNO AS CODIGO,"
	   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
	   sql = sql & " AD.COD_DISCIPLINA, "
	   sql = sql & " A.NOMEALUNO, "
	   sql = sql & " A.MATRICULA, "
	   sql = sql & " '' AS SEQUENCIA, " 
	   sql = sql & " SA.DESC_SITUACAOALUNO, "
	   sql = sql & " GC.COD_PERIODO, "
	   sql = sql & " NF.media, "    
	   sql = sql & " NF.nota" & strPosicao & " as NOTA, "
	   sql = sql & " NF.falta" & strPosicao & " as FALTA, "     
	   sql = sql & " NF.codigo AS COD_NOTA, "
		sql = sql & " NF.situacao "
		sql = sql & "FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
		sql = sql & "SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
		sql = sql & "SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN "
		sql = sql & "SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO INNER JOIN "
		sql = sql & "SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
		sql = sql & "SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
		sql = sql & "WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & "AND GCD.COD_DISCIPLINA = " & intCodDisciplina
		sql = sql & "AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
		'sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
		sql = sql & "AND A.CODIGO in (" & strAlunos & ") "
		sql = sql & "ORDER BY A.NOMEALUNO "
	 else
		'HISTORICO ESCOLAR
		sql = " select DISTINCT A.CODIGO, "
		sql = sql & " ' ' AS COD_ALUNO_DISCIPLINA, "
		sql = sql & " A.MATRICULA, "
		sql = sql & " A.NOMEALUNO, "
		sql = sql & " AT.COD_TURMA, "
		sql = sql & " '' AS SEQUENCIA, " 
		sql = sql & " AT.COD_TURMA, "
		sql = sql & " T.NOMETURMA, "
		sql = sql & " G.Cod_Periodo, "
		sql = sql & " HED.MEDIA, "
		sql = sql & " HED.nota" & strPosicao & " as NOTA, "
		sql = sql & " HED.falta" & strPosicao & " as FALTA, "     
		sql = sql & " D.DESC_DISCIPLINA, "
		sql = sql & " TU.DESC_TURNO, "
		sql = sql & " HED.CODIGO AS COD_NOTA, "
		sql = sql & " HED.SITUACAO "
		sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
		sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
		sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
		sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
		sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = HE.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.ANOLETIVO = AT.Ano_Letivo AND T.COD_SEMESTRE = AT.SEMESTRE AND T.cod_empresa = AT.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA = HE.COD_EMPRESA AND D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO  "
		sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND AT.COD_TURMA = " & intCodTurma
		sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
		sql = sql & " AND HED.ANO_LETIVO = " & strAnoLetivo
		sql = sql & " AND HED.SEMESTRE = " & intSemestre
		sql = sql & "AND A.CODIGO in (" & strAlunos & ") "
		sql = sql & " ORDER BY NOMEALUNO "
		
	end if
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
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome do aluno</strong></th>
									<th><strong>FALTA <%=ucase(strNomeTipoLancamento)%></strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								  contLanc = 0
								  intQtdeRegistros = 0
								  if not rs.eof then
									  intQtdeRegistros = rs.recordCount
								  end if
								  while not rs.eof
										contLanc = contLanc + 1
										strNota = RS("NOTA")
										strFalta = RS("FALTA")
										strCodAluno = RS("CODIGO")
										strCodHistoricoDisciplina = ""
										IF buscaHistorico = "S" then
											strCodHistoricoDisciplina = RS("COD_NOTA")
										end if
										
										strMediaFinal = rs("MEDIA")
										IF ISNULL(strMediaFinal) THEN strMediaFinal = ""

										strStyle = ""
										if strMediaFinal <> "" then 
											if cCur(strMediaFinal)<cCur(intMediaAprovacao) then
												strStyle = "style='color:#FF0000'"
												strSituacaoFinal = "RN"
											else
												strStyle = "style='color:#0000FF'"
												strSituacaoFinal = "AP"
											end if
										end if

										IF TRIM(RS("SITUACAO"))="RN" THEN
											strStyle = "style='color:#FF0000'"
											strSituacaoFinal = TRIM(RS("SITUACAO"))
										ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
											strStyle = "style='color:#0000FF'"
											strSituacaoFinal = TRIM(RS("SITUACAO"))
										END IF
										strPodeFazerAvaliacao = ""
										strCorPodeFazerAvaliacao = ""
										if trim(strNotaDoTipoEF) = "S" then 
											if trim(strTipoFormulaFinal) = "EF" then
											if strMediaFinal<>"" then
													if cCur(strMediaFinal)>=cCur(strCondicaoEF_notaInicial) and cCur(strMediaFinal) < cCur(strCondicaoEF_notaFinal) then
														'poderá fazer a avaliação de Exame final
														strPodeFazerAvaliacao = ""
														strCorPodeFazerAvaliacao = ""
													else
														'não pode fazer avaliação de exame final
														if trim(strNota) = "" or isnull(strNota) then
															strPodeFazerAvaliacao = "readonly"
															strCorPodeFazerAvaliacao = "bgcolor='#F5CBCB'"
														end if
													end if
												end if
											end if
										end if
									  
										if buscaHistorico = "S" then
											%>
											<input class="text" type="HIDDEN" name="txtCodHistoricoDisciplina_<%=contLanc%>" value="<%=strCodHistoricoDisciplina%>">
											<%
										end if
										
										if CInt(intQtdeRegistros) = CInt(contLanc) then
											strProximoCampoNota = "txtFalta_" & contLanc
											strProximoCampoFalta = "btnSalvar"
										else
											strProximoCampoNota = "txtFalta_" & contLanc
											strProximoCampoFalta = "txtNota_" & contLanc+1
										end if
										
									  %>
									  <tr  <%=strCorPodeFazerAvaliacao%> onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
										<td ><%=zeroleft(contLanc,2)%><input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("COD_NOTA")%>"></td>
										<td >&nbsp;<%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
										<td >&nbsp;<%=rs("NOMEALUNO")%><br>
										<input type="hidden" name="txtAlunoDisciplina_<%=contLanc%>" value="<%=rs("COD_ALUNO_DISCIPLINA")%>"></td>
										<td align="center"  <%=strMostraFalta%>><input onKeyUp="return controlaFoco('<%=strProximoCampoFalta%>')" <%=bloqueiaAcumuladaFalta%> type="text" class="text" id="txtFalta_<%=contLanc%>" name="txtFalta_<%=contLanc%>" value="<%=strFalta%>" size="4" maxlength="4" onKeyPress="return formataCampo(this,2,3)" <%=strPodeFazerAvaliacao%>></td>
										</tr>
									  <%

									  
										rs.movenext
								  wend
								  rs.close
								  cnn.close
								  %>
									 </table>
		<input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
		<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
		<input type="hidden" name="chkTipoNota" value="<%=intCodTipoNota%>">
		<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>">
		<input type="hidden" name="cmbTurno" value="<%=intCodTurno%>">
		<input type="hidden" name="chkAluno" value="<%=strAlunos%>">
		<input type="hidden" name="cmbTipoLancamento" value="<%=intCodTipoLancamento%>">
		<input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">

		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacao" value="<%=intMediaAprovacao%>"> 
		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacaoFinal" value="<%=intMediaAprovacaoFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenTipoFormulaFinal" value="<%=strTipoFormulaFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenFreqMinima" value="<%=intFreqMinima%>"> 
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenRecuperacao" value="<%=strRecuperacao%>">	
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenConselho" value="<%=strConselho%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de recuperação-->
        <input type="hidden" name="txtHiddenNumDisciplinaRec" value="<%=intNumDisciplinaRec%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de prog. parcial-->
        <input type="hidden" name="txtHiddenNumDisciplinaProgParcial" value="<%=intNumDisciplinaProgParcial%>"> 
        <!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenReprovacaoFaltaProgParcial" value="<%=strReprovacaoFaltaProgParcial%>"> 
		<!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenNotaDoTipoEF" value="<%=strNotaDoTipoEF%>"> 	
		<%
		
			strParametro = "sca_ajuste_faltaCon.asp?cmbPeriodo="&intCodPeriodo
			strParametro = strParametro & "&cmbSemestre="&intSemestre
			strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplinaTurma
			strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplina
			strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
			strParametro = strParametro & "&cmbTurma="&intCodTurma
			strParametro = strParametro & "&chkAluno="&strAlunos
			strParametro = strParametro & "&cmbTurno="&intCodTurno
			strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
			strParametro = strParametro & "&cmbCurso="&intCodCurso	
			strParametro = strParametro & "&cmbativos="&strAtivos	
			
		%>
		<br>
		  <input type="hidden" name="txtPaginaRetorno" value="NOTA">	 
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