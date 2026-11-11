<script>

	function maskIt(w,e,m,r,a){
		  // Cancela se o evento for Backspace
		  if (!e) var e = window.event
		  if (e.keyCode) code = e.keyCode;
		  else if (e.which) code = e.which;
		  // Variáveis da função
		  var txt  = (!r) ? w.value.replace(/[^\d]+/gi,'') : w.value.replace(/[^\d]+/gi,'').reverse();
		  var mask = (!r) ? m : m.reverse();
		  var pre  = (a ) ? a.pre : "";
		  var pos  = (a ) ? a.pos : "";
		  var ret  = "";
		  if(code == 9 || code == 8 || txt.length == mask.replace(/[^#]+/g,'').length) return false;
		  // Loop na máscara para aplicar os caracteres
		  for(var x=0,y=0, z=mask.length;x<z && y<txt.length;){
		  if(mask.charAt(x)!='#'){
		  ret += mask.charAt(x); x++; } 
		  else {
		  ret += txt.charAt(y); y++; x++; } }
		  // Retorno da função
		  ret = (!r) ? ret : ret.reverse() 
		  w.value = pre+ret+pos; }
		  // Novo método para o objeto 'String'
		  String.prototype.reverse = function(){
		 return this.split('').reverse().join(''); 
	 
	 };	

	function controlaFoco(proximoEnter) {
		var codigoTecla = event.keyCode;
		if (codigoTecla==13) { //enter
			document.all(proximoEnter).focus();
			document.all(proximoEnter).select();
		}
			
	}
	function calculaNota(valor){ //->função que ignora deixa somente 1 número após a vírgula. Ex.: 6.86 para 6.8
	
		var qtde;
		var i;
		var VNota = "";
		var ponto = false;
		valor = "" + valor.toFixed(1); //->converte para string
		qtde = valor.length;
	
		for(i=0;i<qtde;i++){
			VNota = VNota + valor.substring(i,i+1);
			if (valor.substring(i,i+1) =="."){
				ponto = true;
				break;
			}
		}
		
		if (ponto){
			VNota = VNota + valor.substring(i+1,i+2)
		}	
		
		return VNota;
	}


	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function validaNota(valor, qtde_caracter_digitador, posicao, linha){
		if (qtde_caracter_digitador==2) {
			valor = valor.replace(",", "");
			
			if (parseInt(valor,10) < 0 || parseInt(valor,10) > 10){
					alert("Atenção: nota inválida, deve estar entre 0 a 10!");
					document.all["txtNota_" + linha + "_" + posicao].value = "";
					document.all["txtNota_" + linha + "_" + posicao].select();
					document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#DAFA7A";
					document.all["txtNota_" + linha + "_" + posicao].focus();
					return false;
			}
		} else {
		
			valor = valor.replace(",", "");
		
			if (parseInt(valor,10) < 0 || parseInt(valor,10) > 100){
				alert("Atenção: nota inválida, deve estar entre 0 a 10!");
				document.all["txtNota_" + linha + "_" + posicao].value = "";
				document.all["txtNota_" + linha + "_" + posicao].select();
				document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#DAFA7A";
				document.all["txtNota_" + linha + "_" + posicao].focus();
				return false;
			}else{
				if (valor.substring(0,2) == "10" && valor.substring(2,3) == "," && valor.substring(3,4) != "0") {
					alert("Atenção: nota inválida, deve estar entre 0 a 10!");
					document.all["txtNota_" + linha + "_" + posicao].value = "";
					document.all["txtNota_" + linha + "_" + posicao].select();
					document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#DAFA7A";
					document.all["txtNota_" + linha + "_" + posicao].focus();
					return false;
				
				}
				document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#FFB7B7";
				return true;
			}
		}
	}	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		frm.action="sca_lancamento_notas_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<style>
	.campo-media-especial {
	background-color: #e9ecef !important;
	color: #6c757d !important;
	cursor: not-allowed !important;
}

.campo_nota {
		display: block;
		height: calc(1.47em + 1rem + 2px);
		padding: 0.5rem 0.875rem;
		font-size: 0.8125rem;
		font-weight: 400;
		line-height: 1.47;
		color: #495057;
		background-color: #fff;
		background-clip: padding-box;
		border: 1px solid #E5E5E5;
		border-radius: 4px;
		-webkit-transition: border-color 0.15s ease-in-out, -webkit-box-shadow 0.15s ease-in-out;
		transition: border-color 0.15s ease-in-out, -webkit-box-shadow 0.15s ease-in-out;
		transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
		transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out, -webkit-box-shadow 0.15s ease-in-out;
		
	}
	.textDesabilitaSemCaixa {
		display: block;
		height: calc(1.47em + 1rem + 2px);
		padding: 0.5rem 0.875rem;
		font-size: 0.8125rem;
		font-weight: 400;
		line-height: 1.47;
		color: #495057;
		background-color: #dfd8d8 !important;
		background-clip: padding-box;
		border: 1px solid #E5E5E5;
		border-radius: 4px;
		-webkit-transition: border-color 0.15s ease-in-out, -webkit-box-shadow 0.15s ease-in-out;
		transition: border-color 0.15s ease-in-out, -webkit-box-shadow 0.15s ease-in-out;
		transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
		transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out, -webkit-box-shadow 0.15s ease-in-out;
		
	}
</style>
<%
	acao 					= "A"

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	
    intPermitirAlteracaoNotaDocente = "0"
	sql = " SELECT top 1 Permitir_AlteracaoNotaDocente "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		intPermitirAlteracaoNotaDocente	 = trim(rs("Permitir_AlteracaoNotaDocente"))
		if isnull(intPermitirAlteracaoNotaDocente) then intPermitirAlteracaoNotaDocente = "0"
	end if
	rs.close

	'verifica se o usuario é professor ou admnistrativo
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao= " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		strTipoAcessoCadastroNotas = "ADM"
		msnTipoLanc = ""		
	else
		strTipoAcessoCadastroNotas = "PROF"
		intCodColaboradorProfessor = rs("codigo")
		strExecutarSubmitDisciplinaDoProfessor = "S"
		msnTipoLanc = " - Professor"		
	end if
	rs.close
	'strTipoAcessoCadastroNotas = "PROF"
	if strTipoAcessoCadastroNotas = "ADM" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		if intCodTurma = "" then intCodTurma = trim(request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= intCodTurma
		intCodDisciplina  		= trim(request("cmbDisciplinaTurma"))
		if intCodDisciplina = "" then intCodDisciplina = trim(request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma	= intCodDisciplina
	elseif strTipoAcessoCadastroNotas = "PROF" then
		intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
		if intCodTurma = "" then intCodTurma = trim(request("cmbTurma"))
		intCodTurmaProfessor	= intCodTurma
		intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
		if intCodDisciplina = "" then intCodDisciplina = trim(request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma	= intCodDisciplina
	end if

	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	strAtivos               = trim(request("cmbativos"))
	
	intCodTurno		 		= Trim(Request("cmbTurno"))
	strAlunos      			= Trim(Request("chkAluno"))
	intCodTipoNota			= Trim(Request("chkTipoNota"))
	intCodTipoLancamento	= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	bloqueiaAcumuladaFalta	= Trim(Request("cmbBloqueiaFaltas"))	
		
	buscaHistorico			= Trim(Request("buscaHistorico"))	
	if buscaHistorico = "" then 
		buscaHistorico = "N"
		if trim(intSemestre) = "3" then
		   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
			  buscaHistorico = "S"
			  msnHistorico  = "<font color='#0000FF'>(<strong>HIST&Oacute;RICO</strong>)</font>"
		   end if
		else
		   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
			  buscaHistorico = "S"
			  msnHistorico  = "<font color='#0000FF'>(<strong>HIST&Oacute;RICO</strong>)</font>"
		   end if	   
		end if
	else
		if buscaHistorico = "S" then 
			buscaHistorico = "S"
			msnHistorico  = "<font color='#0000FF'>(<strong>HIST&Oacute;RICO</strong>)</font>"
		end if
	end if

	'carrega campos
	sql="select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, c.codigo AS COD_CALCULO, ca.* "
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " order by c.posicao"
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		strTipoCalculo 				= rs("TIPO_CALCULO")
		strMediaAprovacaoFinal 		= rs("media_aprovacao_final")
		strMediaAprovacaoExame 		= rs("media_aprovacao")
		intCondicaoEF_notaInicial 	= rs("condicaoEF_notaInicial")
		intCondicaoEF_notaFinal 	= rs("condicaoEF_notaFinal")
		strTipoFormulaFinal 		= rs("tipoFormulaFinal")
		intFrequenciaMinimaPerc		= rs("frequencia_minima_percentual")
		vetCampo = rs.getRows
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
	
		
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	strMostraNota = "style='display:block'"
	strMostraFalta = "style='display:block'"

	strParametro = "sca_lancamento_notas.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
	strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
	strParametro = strParametro & "&cmbTurma="&intCodTurma
	strParametro = strParametro & "&chkAluno="&strAlunos
	strParametro = strParametro & "&cmbTurno="&intCodTurno
	strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
	strParametro = strParametro & "&cmbCurso="&intCodCurso	
	strParametro = strParametro & "&cmbativos="&strAtivos	
		%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_lancamento_notas.asp">
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
						sql = "SELECT TU.NOMETURMA, TU.TURMAALUNO, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO, P.DESCRICAO AS PERIODO, P.COD_PERIODO "
						sql = sql & " FROM SCA_TURMA TU"
						sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO "
						sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = TU.COD_PERIODO"
						sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
						sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
						rsAux.open sql, cnn
						if not rsAux.eof then
							TURMAALUNO = rsAux("TURMAALUNO")
							NOMETURMA = rsAux("NOMETURMA")
							DESC_TURNO = rsAux("DESC_TURNO")
							intCodPeriodo = rsAux("COD_PERIODO")
							strPeriodo = rsAux("PERIODO")
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
										<BR><STRONG><%=strPeriodo%>&nbsp<%=TURMAALUNO%>&nbsp<%=NOMETURMA%></STRONG>
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
								<button onClick="return salvar('A')"  name="cmbCadastrar" id="cmbCadastrar" type="button" class="btn btn-outline-success">Salvar Notas</button>
								<button onClick="window.location='sca_lancamento_notasCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-warning">Limpar tela</button>
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
	   sql = sql & " NF.codigo AS COD_NOTA, "
		for n=1 to 15
			strComplemento = "0"	
			if cInt(n)>9 then strComplemento = ""
			sql = sql & " NF.nota" & strComplemento & n & ", "
		next
		sql = sql & " NF.situacao "
		sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
		sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
		sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN "
		sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO INNER JOIN "
		sql = sql & " SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
		sql = sql & " SCA_PERIODO PE ON PE.COD_PERIODO = GC.COD_PERIODO INNER JOIN "
		sql = sql & " SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
		sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND GCD.COD_DISCIPLINA = " & intCodDisciplina
		sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
		'sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
		sql = sql & " AND A.CODIGO in (" & strAlunos & ") "
		sql = sql & " AND A.CODIGO not in (SELECT COD_ALUNO FROM SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO WHERE ANO_LETIVO = NF.ANO_LETIVO AND COD_CURSO = PE.COD_CURSO)"
		sql = sql & "ORDER BY A.NOMEALUNO "
	 else
		'HISTORICO ESCOLAR
		'sql = " select DISTINCT A.CODIGO, "
		'sql = sql & " ' ' AS COD_ALUNO_DISCIPLINA, "
		'sql = sql & " A.MATRICULA, "
		'sql = sql & " A.NOMEALUNO, "
		'sql = sql & " AT.COD_TURMA, "
		'sql = sql & " '' AS SEQUENCIA, " 
		'sql = sql & " AT.COD_TURMA, "
		'sql = sql & " T.NOMETURMA, "
		'sql = sql & " G.Cod_Periodo, "
		'sql = sql & " HED.MEDIA, "
		'for n=1 to 15
		'	strComplemento = "0"	
		'	if cInt(n)>9 then strComplemento = ""
		'	sql = sql & " HED.nota" & strComplemento & n & ", "
		'next
		'sql = sql & " D.DESC_DISCIPLINA, "
		'sql = sql & " TU.DESC_TURNO, "
		'sql = sql & " HED.CODIGO AS COD_NOTA, "
		'sql = sql & " HED.SITUACAO "
		'sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
		'sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
		'sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO  "
		'sql = sql & " INNER JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO F on f.COD_ALUNO = A.CODIGO AND HED.ANO_LETIVO = F.ANO_LETIVO"
		'sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = F.COD_SITUACAOALUNO_ATUAL "
		'sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = HE.COD_EMPRESA "
		'sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.ANOLETIVO = AT.Ano_Letivo AND T.COD_SEMESTRE = AT.SEMESTRE AND T.cod_empresa = AT.cod_empresa "
		'sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
		'sql = sql & " INNER JOIN SCA_PERIODO PE ON PE.COD_PERIODO = G.COD_PERIODO "				
		'sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
		'sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO "
		'sql = sql & " WHERE AT.COD_EMPRESA = " & Session("CodEmpresa")
		'sql = sql & " AND AT.COD_TURMA = " & intCodTurma
		'sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
		'sql = sql & " AND HED.ANO_LETIVO = " & strAnoLetivo
		'sql = sql & " AND HED.SEMESTRE = " & intSemestre
		'sql = sql & " AND A.CODIGO in (" & strAlunos & ") "
		'sql = sql & " AND A.CODIGO not in (SELECT COD_ALUNO FROM SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO WHERE ANO_LETIVO = HED.ANO_LETIVO AND COD_CURSO = PE.COD_CURSO)"
		'sql = sql & " ORDER BY NOMEALUNO "
	
		sql = " select DISTINCT A.CODIGO, "
		sql = sql & " ' ' AS COD_ALUNO_DISCIPLINA, "
		sql = sql & " A.MATRICULA, "
		sql = sql & " A.NOMEALUNO, "
		sql = sql & " f.COD_TURMA, "
		sql = sql & " '' AS SEQUENCIA, " 
		sql = sql & " f.COD_TURMA, "
		sql = sql & " T.NOMETURMA, "
		sql = sql & " G.Cod_Periodo, "
		sql = sql & " HED.MEDIA, "
		for n=1 to 15
			strComplemento = "0"	
			if cInt(n)>9 then strComplemento = ""
			sql = sql & " HED.nota" & strComplemento & n & ", "
		next
		sql = sql & " D.DESC_DISCIPLINA, "
		sql = sql & " TU.DESC_TURNO, "
		sql = sql & " HED.CODIGO AS COD_NOTA, "
		sql = sql & " HED.SITUACAO "
		sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
		sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "	
		sql = sql & " INNER JOIN SCA_ALUNO A ON A.codigo = HE.cod_aluno "	
		sql = sql & " INNER JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO F on f.COD_ALUNO = A.CODIGO"
		sql = sql & " LEFT JOIN SCA_TURMA T ON f.COD_TURMA = T.Cod_Turma AND f.ANO_LETIVO = T.AnoLetivo AND f.SEMESTRE = T.Cod_Semestre AND f.cod_empresa = T.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON T.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = f.COD_SITUACAOALUNO_ATUAL"
		sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular "
		sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
		sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO "
		sql = sql & " where f.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and f.COD_TURMA = " & intCodTurma  
		sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
		sql = sql & " and f.ANO_LETIVO = " & strAnoLetivo
		sql = sql & " AND A.CODIGO in (" & strAlunos & ") "
		sql = sql & " AND A.CODIGO not in (SELECT COD_ALUNO FROM SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO WHERE ANO_LETIVO = HED.ANO_LETIVO AND COD_CURSO = P.COD_CURSO)"
		sql = sql & " order by A.NOMEALUNO	"
		
	end if
	if ucase(session("usuarioWeb")) = "SERGIO"  then
			'response.write sql
		'response.end
	end if
	rs.open sql, cnn,3,1	
	
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Tipo do Critério de avaliação: <%=strTipoCalculo%>
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
									<th  class="tamanhoFonte"><strong>Ordem</strong></th>
									<th  class="tamanhoFonte"><strong>Matr&iacute;cula</strong></th>
									<th  class="tamanhoFonte"><strong>Nome do aluno</strong></th>
									<%
										for i=0 to ubound(vetCampo,2)
										%>
											<th  class="tamanhoFonte"><strong><%=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ucase(vetCampo(1,i)),"BIMESTRE","BIM."),"TRIMESTRE","TRIM."),"CONSELHO DE CLASSE","C.CLASSE"),"MÉDIA FINAL","MÉDIA"),"MÉDIA DA RECUPERAÇÃO","M.RECUP.")%></strong></th>
										<%
										next
									%>
									<!--th  class="tamanhoFonte"><strong>RESULTADO</strong></th-->
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
										strCodAluno = RS("CODIGO")

										' M�dia especial: carrega os c�lculos/bimestres bloqueados para este aluno/disciplina
										strMediaEspecialCalculos = ","
										SQLMediaEspecial = "SELECT ME.COD_CALCULO FROM SCA_ALUNO_MEDIA_ESPECIAL ME "
										SQLMediaEspecial = SQLMediaEspecial & "WHERE ME.COD_EMPRESA = " & Session("CodEmpresa")
										SQLMediaEspecial = SQLMediaEspecial & " AND ME.COD_ALUNO = " & strCodAluno
										SQLMediaEspecial = SQLMediaEspecial & " AND ME.ANO_LETIVO = " & strAnoLetivo
										SQLMediaEspecial = SQLMediaEspecial & " AND ME.SEMESTRE = " & intSemestre
										SQLMediaEspecial = SQLMediaEspecial & " AND ME.COD_PERIODO = " & RS("COD_PERIODO")
										SQLMediaEspecial = SQLMediaEspecial & " AND ME.COD_DISCIPLINA = " & intCodDisciplina
										rsAux.open SQLMediaEspecial, cnn
										do while not rsAux.eof
											strMediaEspecialCalculos = strMediaEspecialCalculos & CStr(rsAux("COD_CALCULO")) & ","
											rsAux.movenext
										loop
										rsAux.close

										strCodAlunoZeros = ZeroLeft(RS("CODIGO"),10)  
										strCodHistoricoDisciplina = ""
										IF buscaHistorico = "S" then
											strCodHistoricoDisciplina = RS("COD_NOTA")
										end if

										IF TRIM(RS("SITUACAO"))="RN" THEN
											strStyle = "style='color:#FF0000'"
											strSituacaoFinal = TRIM(RS("SITUACAO"))
										ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
											strStyle = "style='color:#0000FF'"
											strSituacaoFinal = TRIM(RS("SITUACAO"))
										END IF

										if buscaHistorico = "S" then
											%>
											<input class="text" type="HIDDEN" name="txtCodHistoricoDisciplina_<%=contLanc%>" value="<%=strCodHistoricoDisciplina%>">
											<%
										end if

										if buscaHistorico = "N" then
									
											' Início da Regra de reprovação por Falta
												SQL = "SELECT "
												SQL = SQL &   "Isnull(NF.falta01,'0') + Isnull(NF.falta02,'0') + Isnull(NF.falta03,'0') + Isnull(NF.falta04,'0') + Isnull(NF.falta05,'0') + Isnull(NF.falta06,'0') + Isnull(NF.falta07,'0') + Isnull(NF.falta08,'0') + Isnull(NF.falta09,'0') + Isnull(NF.falta10,'0') + Isnull(NF.falta11,'0') + Isnull(NF.falta12,'0') + Isnull(NF.falta13,'0') + Isnull(NF.falta14,'0') + Isnull(NF.falta15,'0') as totalfalta, "
												SQL = SQL & "AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
												SQL = SQL & "AD.COD_ALUNO AS CODIGO, "
												SQL = SQL & "AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
												SQL = SQL & "AD.COD_DISCIPLINA, "
												SQL = SQL & "GCD.Ch_Anual "
												SQL = SQL & "FROM SCA_ALUNO_DISCIPLINA AD " 
												SQL = SQL & "INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
												SQL = SQL & "INNER JOIN SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO " 
												SQL = SQL & "INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA "
												SQL = SQL & "WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
												SQL = SQL & "AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma 
												SQL = SQL & "AND A.CODIGO = " & strCodAluno 
												SQL = SQL & "AND AD.COD_DISCIPLINA = " & intCodDisciplina
												rs1.open sql, cnn
												if not rs1.eof then
												   if rs1("CH_ANUAL") = "" or rs1("CH_ANUAL") = "0" then
													  strCHDisciplina = 0
												   else  
													  strCHDisciplina = rs1("CH_ANUAL")
													  IF rs1("TOTALFALTA") = "" or rs1("TOTALFALTA") = "0" then
														 strTotalFaltas  = 0
													  else	 
														 strTotalFaltas  = rs1("TOTALFALTA")
													  end if	 
												   end if  
												   if strCHDisciplina = "0" or strCHDisciplina = "" then
													  strPercFaltas = 0 
												   else	
													  strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
												   end if	   
												else 
												   strPercFaltas = 0
												end if  
												rs1.close
												if strPercFaltas > intFrequenciaMinimaPerc then	
												   strSituacaoFinalFaltas = "RN"
												else
												   strSituacaoFinalFaltas = ""
												end if   
											' Fim da regra de reprovação por faltas	
										end if

										%>
										 <tr style="cursor: pointer">
											<td width="1%" class="tamanhoFonte">
												<input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("COD_NOTA")%>"><%=contLanc%>
												<input type="hidden" name="txtAlunoDisciplina_<%=contLanc%>" value="<%=rs("COD_ALUNO_DISCIPLINA")%>">
												<input type="hidden" name="CODIGO_TIPO_CALCULO_<%=contLanc%>" value="1">
											</td>
											<td class="tamanhoFonte"><%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
											<td class="tamanhoFonte"><%=rs("NOMEALUNO")%></td>
											
											<%
											for i=0 to ubound(vetCampo,2)
												strComplementoNota = "0"	
												if cInt(vetCampo(0,i))>9 then strComplementoNota = ""
												strNota = RS("NOTA" &strComplementoNota& vetCampo(0,i))
												strCampoEdicao = ""
												strStyleCampo = "campo_nota"
												strStyleFundoCelulaTabela = ""
												bolMediaEspecial = (InStr(strMediaEspecialCalculos, "," & CStr(vetCampo(6,i)) & ",") > 0) 
												if isnull(strNota) or strNota="" then
													strPodeFazerAlteracao = ""
												else
													'Encerramento das atividade esta como liberado, desconsidera a regra de bloqueio
													if intPermitirAlteracaoNotaDocente <> 9 then ' Liberado
														if strTipoAcessoCadastroNotas = "PROF" then 
														   strStyleCampo = "textDesabilitaSemCaixa"
														   strPodeFazerAlteracao = "readonly"
														   if trim(vetCampo(4,i)) = trim(intPermitirAlteracaoNotaDocente) then 
																strPodeFazerAlteracao = ""
															end if
														else
															strPodeFazerAlteracao = ""   
														end if   
													else
														strPodeFazerAlteracao = ""  
													end if
												end if
												
												if vetCampo(3,i) = "N" then 
													strCampoEdicao = "readonly"
													'strStyleFundoCelulaTabela = "bgcolor='#e9e9e9'" 
												end if

												' Se existe SCA_ALUNO_MEDIA_ESPECIAL para este c�lculo, n�o permite digita��o
												if bolMediaEspecial then
													strCampoEdicao = "readonly tabindex='-1' title='Bimestre configurado para não cadastrar nota!'"
													strStyleCampo = strStyleCampo & " campo-media-especial"
												end if

												strComplemento = "0"
												if cInt(i)>9 then strComplemento = ""
												if CInt(intQtdeRegistros) = CInt(contLanc) then
													strProximoCampo = "btnSalvar"
												else
													strProximoCampo = "txtNota_" & contLanc+1 & "_" &strComplemento & i
												end if
												
												strMediaFinal = rs("MEDIA")
												IF ISNULL(strMediaFinal) THEN strMediaFinal = ""
								
												strStyle = ""
												if strMediaFinal <> "" then 
													if cCur(strMediaFinal)<cCur(intMediaAprovacao) then
														strStyle = "class='color-danger-400'"
														strSituacaoFinal = "RN"
													else
														strStyle = "class='color-success-400'"
														strSituacaoFinal = "AP"
													end if
												end if

												
												%>
											  <td align="center" <%=strStyleFundoCelulaTabela%>  >
												<%
												if vetCampo(3,i) = "N" then 
												%>
												<%=strNota%>&nbsp;
												<%
												else
												%>
												<input <%=strPodeFazerAlteracao%> <%=strCampoEdicao%> onBlur="return validaNota(this.value, this.value.length,'<%=strComplemento%><%=i%>','<%=contLanc%>')" type="text" class="<%=strStyleCampo%>" name="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" id="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" value="<%=strNota%>" size="5" maxlength="4" onKeyUp="maskIt(this,event,'###,#',true)"  <%if vetCampo(4,i)="8" then response.Write strStyle%>>
												<%
												end if
												%>                  
											  </td>
											  <%
											next
											if strSituacaoFinalFaltas = "" then
												if RS("SITUACAO")="RN" then
													strStyle = "class='color-danger-400'"
												elseif RS("SITUACAO")="AP" then
													strStyle = "class='color-success-400'"
												end if
												%>
												 <!--td align="center" width="10%" <%=strStyle%>><%'=RS("SITUACAO")%>&nbsp;</td-->
												</tr>
												<%
											else 
												%>
												 <td align="center" width="10%" class="color-danger-800">RF (<%=round(strPercFaltas,2)%>%)</td>
												</tr>
												<%
											end if	
											
											rs.movenext
									  wend
									  
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
	' <> QUATRO BIMESTRES	
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
               sql = sql & " NF.codigo AS COD_NOTA, "
				for n=1 to 15
					strComplemento = "0"	
					if cInt(n)>9 then strComplemento = ""
					sql = sql & " NF.nota" & strComplemento & n & ", "
				next
		        sql = sql & " NF.situacao, TC.CODIGO AS CODIGO_TIPO_CALCULO  "
				sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
 				sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
 				sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN "
 				sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO INNER JOIN "
 				sql = sql & " SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
				sql = sql & " SCA_PERIODO PE ON PE.COD_PERIODO = GC.COD_PERIODO INNER JOIN "
 				sql = sql & " SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
				sql = sql & " INNER JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAA ON TAA.COD_ALUNO = A.CODIGO AND PE.COD_CURSO = TAA.COD_CURSO AND TAA.COD_EMPRESA = NF.COD_EMPRESA AND TAA.ANO_LETIVO = NF.ANO_LETIVO "
				sql = sql & " INNER JOIN SCA_TIPO_CALCULO TC ON TC.CODIGO = TAA.COD_TIPO_CALCULO"
				sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & " AND GCD.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
				'sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				sql = sql & " AND A.CODIGO in (" & strAlunos & ") "
				sql = sql & " AND A.CODIGO in (SELECT COD_ALUNO FROM SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO WHERE ANO_LETIVO = NF.ANO_LETIVO AND COD_CURSO = PE.COD_CURSO)"
 				sql = sql & "ORDER BY A.NOMEALUNO "
		     else
		   		'HISTORICO ESCOLAR
				sql = " select DISTINCT A.CODIGO, "
				sql = sql & " ' ' AS COD_ALUNO_DISCIPLINA, "
				sql = sql & " A.MATRICULA, "
				sql = sql & " A.NOMEALUNO, "
				sql = sql & " AT.COD_TURMA, "
			    sql = sql & " '' AS SEQUENCIA, " 
				sql = sql & " T.NOMETURMA, "
				sql = sql & " G.Cod_Periodo, "
				sql = sql & " HED.MEDIA, "
				for n=1 to 15
					strComplemento = "0"	
					if cInt(n)>9 then strComplemento = ""
					sql = sql & " HED.nota" & strComplemento & n & ", "
				next
				sql = sql & " D.DESC_DISCIPLINA, "
				sql = sql & " TU.DESC_TURNO, "
				sql = sql & " HED.CODIGO AS COD_NOTA, "
				sql = sql & " HED.SITUACAO, TC.CODIGO AS CODIGO_TIPO_CALCULO "
				sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
				sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
				sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = HE.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.ANOLETIVO = AT.Ano_Letivo AND T.COD_SEMESTRE = AT.SEMESTRE AND T.cod_empresa = AT.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
				sql = sql & " INNER JOIN SCA_PERIODO PE ON PE.COD_PERIODO = G.COD_PERIODO "				
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO "
				sql = sql & " INNER JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAA ON TAA.COD_ALUNO = A.CODIGO AND PE.COD_CURSO = TAA.COD_CURSO AND TAA.ANO_LETIVO = HED.ANO_LETIVO "
				sql = sql & " INNER JOIN SCA_TIPO_CALCULO TC ON TC.CODIGO = TAA.COD_TIPO_CALCULO"
				sql = sql & " WHERE AT.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & " AND AT.COD_TURMA = " & intCodTurma
		        sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
				sql = sql & " AND HED.ANO_LETIVO = " & strAnoLetivo
				sql = sql & " AND HED.SEMESTRE = " & intSemestre
				sql = sql & " AND A.CODIGO in (" & strAlunos & ") "
				sql = sql & " AND A.CODIGO in (SELECT COD_ALUNO FROM SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO WHERE COD_EMPRESA = AT.COD_EMPRESA AND ANO_LETIVO = HED.ANO_LETIVO AND COD_CURSO = PE.COD_CURSO)"
				sql = sql & " ORDER BY NOMEALUNO "
				
				'RESPONSE.WRITE SQL
				'RESPONSE.WRITE "<br>sim"
				
			end if
			
			rs.open sql, cnn,3,1	
			
			  controteAVIndividual = 0
			  intQtdeRegistros = 0
			  if not rs.eof then
				  intQtdeRegistros = rs.recordCount
			  end if
			  while not rs.eof
			  
					IF RS("CODIGO_TIPO_CALCULO") <> CODIGO_TIPO_CALCULO THEN 
					
						if controteAVIndividual <> 0 then
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
						controteAVIndividual = 1		
					'carrega campos
						
						sql = "select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, c.codigo AS COD_CALCULO"
						sql = sql & " from SCA_TIPO_CALCULO tc "
						sql = sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo "
						sql = sql & " where tc.codigo = " & RS("CODIGO_TIPO_CALCULO")
						sql = sql & " order by c.posicao"
						
						vetCampo = null
						naoachoucriterio = "N"
						rsAux.open sql, cnn
						if not rsAux.eof then
							vetCampo = rsAux.getRows
						end if
						rsAux.close
						%>
						
						<div class="row">
							<div class="col-xl-12">
								<div id="panel-1" class="panel">
									<div class="panel-hdr">
										<h2>
											<%=ucase(vetCampo(5,0))%>
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
														<%
															for i=0 to ubound(vetCampo,2)
															%>
																<th><strong><%=REPLACE(REPLACE(REPLACE(ucase(vetCampo(1,i)),"BIMESTRE","BIM."),"CONSELHO DE CLASSE","CONS.CLASSE"),"MÉDIA FINAL","MÉD.FINAL")%></strong></th>
															<%
															next
														%>
													  </tr>
													</thead>
													<tbody>
						<%
					END IF
					
						controletela = controletela + 1
				  
						contLanc = contLanc + 1
						strCodAluno = RS("CODIGO")

						' M�dia especial: carrega os c�lculos/bimestres bloqueados para este aluno/disciplina
						strMediaEspecialCalculos = ","
						SQLMediaEspecial = "SELECT ME.COD_CALCULO FROM SCA_ALUNO_MEDIA_ESPECIAL ME "
						SQLMediaEspecial = SQLMediaEspecial & "WHERE ME.COD_EMPRESA = " & Session("CodEmpresa")
						SQLMediaEspecial = SQLMediaEspecial & " AND ME.COD_ALUNO = " & strCodAluno
						SQLMediaEspecial = SQLMediaEspecial & " AND ME.ANO_LETIVO = " & strAnoLetivo
						SQLMediaEspecial = SQLMediaEspecial & " AND ME.SEMESTRE = " & intSemestre
						SQLMediaEspecial = SQLMediaEspecial & " AND ME.COD_PERIODO = " & RS("COD_PERIODO")
						SQLMediaEspecial = SQLMediaEspecial & " AND ME.COD_DISCIPLINA = " & intCodDisciplina
						rsAux.open SQLMediaEspecial, cnn
						do while not rsAux.eof
							strMediaEspecialCalculos = strMediaEspecialCalculos & CStr(rsAux("COD_CALCULO")) & ","
							rsAux.movenext
						loop
						rsAux.close

						strCodAlunoZeros = ZeroLeft(RS("CODIGO"),10)  
						strCodHistoricoDisciplina = ""
						IF buscaHistorico = "S" then
							strCodHistoricoDisciplina = RS("COD_NOTA")
						end if

						IF TRIM(RS("SITUACAO"))="RN" THEN
							strStyle = "style='color:#FF0000'"
							strSituacaoFinal = TRIM(RS("SITUACAO"))
						ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
							strStyle = "style='color:#0000FF'"
							strSituacaoFinal = TRIM(RS("SITUACAO"))
						END IF

						if buscaHistorico = "S" then
							%>
							<input class="text" type="HIDDEN" name="txtCodHistoricoDisciplina_<%=contLanc%>" value="<%=strCodHistoricoDisciplina%>">
							<%
						end if

						if buscaHistorico = "N" then
					
							' Início da Regra de reprovação por Falta
								SQL = "SELECT "
								SQL = SQL &   "Isnull(NF.falta01,'0') + Isnull(NF.falta02,'0') + Isnull(NF.falta03,'0') + Isnull(NF.falta04,'0') + Isnull(NF.falta05,'0') + Isnull(NF.falta06,'0') + Isnull(NF.falta07,'0') + Isnull(NF.falta08,'0') + Isnull(NF.falta09,'0') + Isnull(NF.falta10,'0') + Isnull(NF.falta11,'0') + Isnull(NF.falta12,'0') + Isnull(NF.falta13,'0') + Isnull(NF.falta14,'0') + Isnull(NF.falta15,'0') as totalfalta, "
								SQL = SQL & "AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
								SQL = SQL & "AD.COD_ALUNO AS CODIGO, "
								SQL = SQL & "AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
								SQL = SQL & "AD.COD_DISCIPLINA, "
								SQL = SQL & "GCD.Ch_Anual "
								SQL = SQL & "FROM SCA_ALUNO_DISCIPLINA AD " 
								SQL = SQL & "INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
								SQL = SQL & "INNER JOIN SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO " 
								SQL = SQL & "INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA "
								SQL = SQL & "WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
								SQL = SQL & "AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma 
								SQL = SQL & "AND A.CODIGO = " & strCodAluno 
								SQL = SQL & "AND AD.COD_DISCIPLINA = " & intCodDisciplina
								rs1.open sql, cnn
								if not rs1.eof then
								   if rs1("CH_ANUAL") = "" or rs1("CH_ANUAL") = "0" then
									  strCHDisciplina = 0
								   else  
									  strCHDisciplina = rs1("CH_ANUAL")
									  IF rs1("TOTALFALTA") = "" or rs1("TOTALFALTA") = "0" then
										 strTotalFaltas  = 0
									  else	 
										 strTotalFaltas  = rs1("TOTALFALTA")
									  end if	 
								   end if  
								   if strCHDisciplina = "0" or strCHDisciplina = "" then
									  strPercFaltas = 0 
								   else	
									  strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
								   end if	   
								else 
								   strPercFaltas = 0
								end if  
								rs1.close
								if strPercFaltas > intFrequenciaMinimaPerc then	
								   strSituacaoFinalFaltas = "RN"
								else
								   strSituacaoFinalFaltas = ""
								end if   
							' Fim da regra de reprovação por faltas	
						end if

										%>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("COD_NOTA")%>"><%=contLanc%>
												<input type="hidden" name="txtAlunoDisciplina_<%=contLanc%>" value="<%=rs("COD_ALUNO_DISCIPLINA")%>">
												<input type="hidden" name="CODIGO_TIPO_CALCULO_<%=contLanc%>" value="1">
											</td>
											<td><%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
											<td><%=rs("NOMEALUNO")%></td>
											
											<%
											for i=0 to ubound(vetCampo,2)
												strComplementoNota = "0"	
												if cInt(vetCampo(0,i))>9 then strComplementoNota = ""
												strNota = RS("NOTA" &strComplementoNota& vetCampo(0,i))
												strCampoEdicao = ""
												strStyleCampo = "form-control"
												strStyleFundoCelulaTabela = "" 
												if isnull(strNota) or strNota="" then
													strPodeFazerAlteracao = ""
												else
													'Encerramento das atividade esta como liberado, desconsidera a regra de bloqueio
													if intPermitirAlteracaoNotaDocente <> 9 then ' Liberado
														if strTipoAcessoCadastroNotas = "PROF" then 
														   strStyleCampo = "textDesabilitaSemCaixa"
														   strPodeFazerAlteracao = "readonly"
														   if trim(vetCampo(4,i)) = trim(intPermitirAlteracaoNotaDocente) then 
																strPodeFazerAlteracao = ""
															end if
														else
															strPodeFazerAlteracao = ""   
														end if   
													else
														strPodeFazerAlteracao = ""  
													end if
												end if
												
												if vetCampo(3,i) = "N" then 
													strCampoEdicao = "readonly"
													strStyleFundoCelulaTabela = "bgcolor='#D4D4D4'" 
												end if

												strComplemento = "0"
												if cInt(i)>9 then strComplemento = ""
												if CInt(intQtdeRegistros) = CInt(contLanc) then
													strProximoCampo = "btnSalvar"
												else
													strProximoCampo = "txtNota_" & contLanc+1 & "_" &strComplemento & i
												end if
												
												strMediaFinal = rs("MEDIA")
												IF ISNULL(strMediaFinal) THEN strMediaFinal = ""
								
												strStyle = ""
												if strMediaFinal <> "" then 
													if cCur(strMediaFinal)<cCur(intMediaAprovacao) then
														strStyle = "class='color-danger-400'"
														strSituacaoFinal = "RN"
													else
														strStyle = "class='color-success-400'"
														strSituacaoFinal = "AP"
													end if
												end if

												
												%>
											  <td align="center" >
												<%
												if vetCampo(3,i) = "N" then 
												%>
												<%=strNota%>&nbsp;
												<%
												else
												%>
												<input <%=strPodeFazerAlteracao%> <%=strCampoEdicao%> onBlur="return validaNota(this.value, this.value.length,'<%=strComplemento%><%=i%>','<%=contLanc%>')" type="text" class="<%=strStyleCampo%>" name="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" id="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" value="<%=strNota%>" size="4" maxlength="4" onKeyUp="maskIt(this,event,'###,#',true)"  <%if vetCampo(4,i)="8" then response.Write strStyle%>>
												<%
												end if
												%>                  
											  </td>
											  <%
											next
											
											CODIGO_TIPO_CALCULO = RS("CODIGO_TIPO_CALCULO")
											rs.movenext
									  wend
									  
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
	
		<input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
		<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
		<input type="hidden" name="chkTipoNota" value="<%=intCodTipoNota%>">
		<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>">
        <input type="hidden" name="cmbTurmaProfessor" value="<%=intCodTurma%>">
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
		<input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
		<input type="hidden" name="txtPaginaRetorno" value="NOTA">
		<input type="hidden" name="buscaHistorico" value="<%=buscaHistorico%>">
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>