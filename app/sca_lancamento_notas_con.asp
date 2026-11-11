<%

'verifica se o usuario é professor ou admnistrativo
intSemestre = session("strSemestre")
if trim(request("txtAnoLetivo")) = "" then 
	strAnoLetivo = session("strAnoLetivo")
else
	strAnoLetivo = request.Form("txtAnoLetivo")
end if

sql = "select codigo "
sql = sql & " from SRH_COLABORADOR"
sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
sql = sql & " and (CodCategoria = 1 OR CodCategoria = 8)"'professor
sql = sql & " and Situacao = 'A'"'ativo
rs.open sql, cnn
if rs.eof then
	strTipoAcessoCadastroNotas = "ADM"
	intSemestre 			= Trim(Request("cmbSemestre"))
else

	if (Session("Seg_CodCategoria") = "1") then
		strTipoAcessoCadastroNotas = "PROF"
		intCodColaboradorProfessor = rs("codigo")
		strExecutarSubmitDisciplinaDoProfessor = "S"
		strAnoLetivo = session("strAnoLetivo")
		intSemestre = session("strSemestre")
	ELSE
		strTipoAcessoCadastroNotas = "ADM"
		intSemestre 			= Trim(Request("cmbSemestre"))
	END IF	

end if
rs.close
%>
<script>
	function MarcaTodosAlunos(valor){
		var form = document.getElementById("frm");
		var i;
	
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (form.elements[i].disabled==false) {
						form.elements[i].checked=valor;
					}
				}
			}
		}
	}			
	
	function abrirConfiguracaoMediaEspecial(codAluno, codTurma, anoLetivo, semestre, codPeriodo){
		var url = "sca_aluno_media_especial_con.asp" +
			"?codAluno=" + encodeURIComponent(codAluno) +
			"&codTurma=" + encodeURIComponent(codTurma) +
			"&anoLetivo=" + encodeURIComponent(anoLetivo) +
			"&semestre=" + encodeURIComponent(semestre) +
			"&codPeriodo=" + encodeURIComponent(codPeriodo);

		var largura = 980;
		var altura = 720;
		var esquerda = Math.max(0, (screen.width - largura) / 2);
		var topo = Math.max(0, (screen.height - altura) / 2);

		window.open(
			url,
			"mediaEspecialAluno",
			"width=" + largura + ",height=" + altura + ",left=" + esquerda + ",top=" + topo + ",resizable=yes,scrollbars=yes,status=no"
		);
		return false;
	}

	function cadastrarNotas(){
		
		var frm = document.getElementById("frm");
		var form = document.getElementById("frm");
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		<%if strTipoAcessoCadastroNotas = "ADM" then%>		
			
			if (frm.cmbTurma.value == 0){
				alert("A turma deve ser informada!");
				frm.cmbTurma.focus();
				return false;
			}		
			if (frm.cmbDisciplinaTurma.value == 0){
				alert("A disciplina deve ser informada!");
				frm.cmbDisciplinaTurma.focus();
				return false;
			}		
		
		<%elseif strTipoAcessoCadastroNotas = "PROF" then%>	
		
			if (frm.cmbTurmaProfessor.value == 0){
				alert("A turma deve ser informada!");
				frm.cmbTurmaProfessor.focus();
				return false;
			}		
			
			if (frm.cmbDisciplinaDoProfessor.value == 0){
				alert("A disciplina deve ser informada!");
				frm.cmbDisciplinaDoProfessor.focus();
				return false;
			}		
		<%end if%>
	
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
		
		frm.action = "sca_lancamento_notas.asp";
		frm.submit();
		return true;	
	}
</script>
<%
acao = "A"

strExecutarSubmitCurso	  = "S"
strExecutarSubmitPeriodo  = "S"
strExecutarSubmitSemestre = "S"
strExecutarSubmitTurno	  = "S"
strExecutarSubmitTurma	  = "S"

intCodCurso	 			= Trim(Request("cmbCurso"))
intCodPeriodo 			= Trim(Request("cmbPeriodo"))

intCodGrade				= Trim(Request("cmbGrade"))
intCodTurno		 		= Trim(Request("cmbTurno"))
intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
strSala		 			= Trim(Request("txtSala"))
intAno		 			= Trim(Request("txtAno"))
intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
intCodTipoLancamento    = trim(request("cmbTipoLancamento"))

strFalhaNotasFaltas	= Trim(Request.Form("txtFalhaNotasFaltas"))
ckFalhaNotasFaltas = ""
if strFalhaNotasFaltas = "S" then ckFalhaNotasFaltas = " checked "	

if strTipoAcessoCadastroNotas = "ADM" then
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodDisciplinaTurma	= trim(request("cmbDisciplinaTurma"))
	intCodDisciplina	   	= trim(request("cmbDisciplinaTurma"))
	intCodTurmaProfessor	= intCodTurma

	strBloqueia_NotasSecretaria = ""
	sql = " SELECT top 1 Bloqueia_NotasSecretaria "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strBloqueia_NotasSecretaria  = trim(rs("Bloqueia_NotasSecretaria"))
	end if
	rs.close
	if strBloqueia_NotasSecretaria = "S" then
		%>
		<script>
			alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
			window.history.back();
		</script>
		<%
	end if
	
end if

if strTipoAcessoCadastroNotas = "PROF" then
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	intCodDisciplinaTurma	= trim(request("cmbDisciplinaDoProfessor"))
	intCodTurma			 	= Trim(Request("cmbTurmaProfessor"))
	intCodTurmaProfessor	= intCodTurma
	
	' Verifica a liberação da secretaria para o professor lançar notsa
	strBloqueia_NotasDocente = ""
	sql = " SELECT top 1 Bloqueia_NotasDocente, Bloqueia_CampoAcumuladaFalta "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strBloqueia_NotasDocente        = trim(rs("Bloqueia_NotasDocente"))
	end if
	rs.close
	if strBloqueia_NotasDocente = "S" then
		%>
		<script>
			alert("ATENÇÃO: \n\nAplicação Bloqueada para Lançamento, procure a Secretaria Geral.");
			window.history.back();
		</script>
		<%	
		response.End()
	end if	

end if
strAtivos               = trim(request("cmbativos"))

strFiltroSerie = "0"
strFiltroTurno = "0"

if intCodComp = "" then intCodComp = "0"
if intCodSerie = "" then intCodSerie = "0"
if intCodTurno = "" then intCodTurno = "0"
if intCodTurma = "" then intCodTurma = "0"
if intCodSemestre = "" then intCodSemestre = "0"
if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"

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

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_lancamento_notasCon.asp">
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
			
			<div align="right">
				<ul class="list-table m-0">
					<li class="pl-3"><a href="#" onclick="abreVideo('tutorial/SCA/sca_lancamento_notasCon.mp4')" class="text-secondary fw-700"><font color="blue">Tutorial</font></a></li>
					<li class="pl-1 fs-xl"><a href="#" onclick="abreVideo('tutorial/SCA/sca_lancamento_notasCon.mp4')" class="text-secondary"><font color="blue"><i class="fal fa-question-circle" aria-hidden="true"></i></font></a></li>
				</ul>
			</div>	
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
						
						<input name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
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
						
						<%IF strTipoAcessoCadastroNotas = "ADM" then%>
						<div class="row">
						
							<div class="col-sm-6">
								<div class="form-group">
								
									<label class="form-label">Turmas:</label>
									<!--#include file="includes/inc_cmdTurma.asp"-->
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Disciplina da Turma:</label>
									<!--#include file="includes/inc_cmbDisciplinaTurma.asp"-->
								</div>
							</div>
						</div>
						<%end if%>
						<%IF strTipoAcessoCadastroNotas = "PROF" then%>
						<div class="row">
						
							<div class="col-sm-6">
								<div class="form-group">
								
									<label class="form-label">Turma do Professor:</label>
									<!--#include file="includes/inc_cmdTurmaProfessor_NotasFaltas.asp"-->
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Disciplina do Professor:</label>
									<!--#include file="includes/inc_cmdDisciplinaDoProfessor.asp"-->
								</div>
							</div>
						</div>
						<%end if%>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Situações:</label>
									<!--#include file="includes/inc_cmbAtivos.asp"-->
								</div>
							</div>
						</div>
						<div class="row">
							
								<div class="col-sm-12">
									<div class="form-group">
										<label class="form-label">Obs: Para acessar dados de notas e faltas no hist&oacute;rico, &eacute; necess&aacute;rio apenas informar o ANO ou SEMESTRE anterior ao atual. </label>
									</div>
								</div>
						</div>
									
						<br>
						<div class="frame-wrap">
							<button onClick="return cadastrarNotas()"  name="cmbCadastrar" id="cmbCadastrar" type="button" class="btn btn-outline-success">Cadastrar<%=strMsnBotaoHistorico%></button>
							<button onClick="window.location='sca_lancamento_notasCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-warning">Limpar tela</button>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%
	if intCodTurma    = "" then intCodTurma="0"
	if intCodSemestre = "" then intCodSemestre="0"
	if intCodTurma<>"0" and intCodDisciplinaTurma<>"0" then
		'seleciona os alunos da turma através de sua disciplina
		Cont=0

	%>

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
									<th><input name="chkTodos" type="checkbox" value="" onClick="return MarcaTodosAlunos(this.checked)"></th>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
									<th><strong>Média Diferenciada</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
									'seleciona os alunos da turma através de sua disciplina
									Cont=0
									buscaHistorico = "N"
									if trim(intSemestre) = "3" then
									   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
										  buscaHistorico = "S"
									   end if
									else
									   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
										  buscaHistorico = "S"
									   end if	   
									end if
									if buscaHistorico = "N" then
										sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
										sql = sql & " AD.COD_ALUNO AS CODIGO, "
										sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
										sql = sql & " GCD.COD_DISCIPLINA, "
										sql = sql & " ISNULL(GCD.Omitir_Criterio,'N') AS Omitir_Criterio, "
										sql = sql & " A.NOMEALUNO, "
										sql = sql & " A.MATRICULA, "
										sql = sql & " '' AS SEQUENCIA, "
										sql = sql & " ISNULL(ST.Desc_SituacaoAluno,'ATIVO') AS DESC_SITUACAOALUNO, "
										sql = sql & " TC.DESCRICAO AS TIPO_CRITERIO "

										sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD "

										sql = sql & " INNER JOIN SCA_ALUNO A "
										sql = sql & "     ON A.CODIGO = AD.COD_ALUNO "

										sql = sql & " INNER JOIN SCA_TURMA TUR "
										sql = sql & "     ON TUR.COD_TURMA = AD.COD_TURMA "

										sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD "
										sql = sql & "     ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "

										sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI "
										sql = sql & "     ON TAI.COD_ALUNO = AD.COD_ALUNO "
										sql = sql & "    AND TAI.ANO_LETIVO = TUR.ANOLETIVO "

										sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC "
										sql = sql & "     ON TC.CODIGO = TAI.COD_TIPO_CALCULO "

										' Situação atual do aluno
										sql = sql & " OUTER APPLY ( "
										sql = sql & "     SELECT TOP 1 "
										sql = sql & "         SS.Cod_SituacaoAluno, "
										sql = sql & "         SS.Desc_SituacaoAluno "
										sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO CS "
										sql = sql & "     INNER JOIN SCA_SITUACAOALUNO SS "
										sql = sql & "         ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO "
										sql = sql & "     WHERE CS.COD_EMPRESA = " & Session("CodEmpresa")
										sql = sql & "       AND CS.COD_ALUNO = AD.COD_ALUNO "
										sql = sql & "       AND CS.ANO_LETIVO = TUR.ANOLETIVO "
										sql = sql & "     ORDER BY CS.CODIGO DESC "
										sql = sql & " ) ST "

										sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
										sql = sql & " AND GCD.COD_DISCIPLINA = " & intCodDisciplinaTurma
										sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma

										If strAtivos = "A" Then
											sql = sql & " AND ISNULL(ST.Cod_SituacaoAluno,1) = 1 "
										End If

										sql = sql & " ORDER BY A.NOMEALUNO "
									   'if ucase(session("usuarioweb")) = "SERGIO" then
										'	response.write sql
									   'end if
									
									else   
									
									   'seleciona os alunos pelo ano e semestres do histórico 			
									   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO, 'N' as Omitir_Criterio, TC.DESCRICAO AS TIPO_CRITERIO "
									   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
									   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
									   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
									   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO " 
									   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = HE.COD_EMPRESA "
									   sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AT.COD_ALUNO AND AT.ANO_LETIVO = TAI.ANO_LETIVO"
									   sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_calculo"
									   sql = sql & " WHERE At.COD_EMPRESA = " & Session("CodEmpresa")
									   sql = sql & " AND AT.COD_TURMA = " & intCodTurma	
									   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
									   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
									   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplinaTurma
									   sql = sql & " ORDER BY NOMEALUNO "
									end if

									rs.open sql, cnn
									if rs.eof = false then
										while not rs.eof
										  
										strCodAluno             = rs("CODIGO")
										intCodEmp               = Session("CodEmpresa") 
										strDesabilitaAluno 	  	= ""
										strSituacaoAluno 		= ""
										tipo_criterio = rs("tipo_criterio")
										if not isnull(tipo_criterio) then
											tipo_criterio = "<br><font color='blue'>&nbsp;(" & rs("tipo_criterio") & ")</font>"
										end if
										if buscaHistorico = "N" then
										  
											sql = " select ad.codigo, ad.COD_DISCIPLINA, nf.codigo as codNota from SCA_ALUNO_DISCIPLINA ad "
											sql = sql & " left join SCA_NOTAS_FALTAS nf on nf.cod_aluno_disciplina = ad.CODIGO "
											sql = sql & " where ad.COD_ALUNO = " & strCodAluno
											sql = sql & " and ISNULL(nf.codigo,'0') = '0' " 
											
											rs1.open sql, cnn
											if rs1.eof = false then
												while not rs1.eof
												
													strCodAlunoDisciplina  	= rs1("CODIGO")
													
													if strCodAlunoDisciplina <> "0" then
														'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
														strCriaNotas = "S"

														if isnull(rs1("codNota")) then
															strCriaNotas = "N"
															strDesabilitaAluno 	= " disabled "
															strSituacaoAluno	= " <strong>(registro de notas atualizado)</strong>"
														end if
														
														if strCriaNotas = "N" then
														   strMarcaCriaNotas = "N"
														   SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
														   SQL = SQL & "ano_letivo, semestre, cod_disciplina, nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05, nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10, nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, situacao, media )  VALUES ("
														   SQL = SQL & "" & intCodEmp & ","
														   SQL = SQL & "" & strCodAluno & ","
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
										 end if	
										 if rs("Omitir_Criterio") = "S" then
											strDesabilitaAluno 	= " disabled "
										 end if
										 strMatricula		          = rs("MATRICULA")
										 strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
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
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=tipo_criterio%></td>
											<td><%=strDesc_SituacaoAluno%></td>
											<td class="text-left">
											<%if session("usuarioWeb") = "SERGIO" then%>
												<button type="button" class="btn btn-sm btn-outline-primary" title="Configurar m餩a especial"
													onclick="return abrirConfiguracaoMediaEspecial('<%=strCodAluno%>','<%=intCodTurma%>','<%=strAnoLetivo%>','<%=intSemestre%>','<%=intCodPeriodo%>');">
													<i class="fal fa-cog"></i> Configurar
												</button>
											<%end if%>
											</td>
										</tr>
										 <%
										 rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
									 <td colspan="7" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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