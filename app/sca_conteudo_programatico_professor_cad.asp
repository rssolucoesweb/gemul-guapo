<script>
	function salvar(acao){
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "" ) {
			alert("O Conteúdo deve ser informado !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDataInicial.value == "") {
			alert("A Data Inicial deve ser informada !");
			frm.txtDataInicial.focus();
			return false;
		}

        TestaDataFinal = "<%=strHabilitaPlanoEnsino%>"

        if (TestaDataFinal == "S") { 
			if (frm.txtDataFinal.value == "") {
				alert("A Data Final deve ser informada !");
				frm.txtDataFinal.focus();
				return false;
			}
	
			if (frm.txtDataFinal.value <  frm.txtDataInicial.value) {
				alert("Verifique a Data informada !");
				frm.txtDataInicial.focus();
				return false;
			}
	    }	

        if ( acao != "E" ) {
			if (frm.txtTotalAulasDia.value == "" || frm.txtTotalAulasDia.value == "0" ) {
				alert("O Total de Aulas deve ser informado !");
				frm.txtTotalAulasDia.focus();
				return false;
			}
		}

		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser Informado !");
			frm.cmbSemestre.focus();
			return false;
		}

		if (frm.cmbProfessor.value == "0") {
			alert("O Professor será lançado como DEFICIT!");
		}

		if (frm.cmbTurmaProfessor.value == "0") {
			alert("A Turma do Professor deve ser Informada !");
			frm.cmbTurmaProfessor.focus();
			return false;
		}
		if (frm.cmbDisciplinaDoProfessor.value == "0") {
			alert("A Disciplina do Professor deve ser Informada !");
			frm.cmbDisciplinaDoProfessor.focus();
			return false;
		}

		frm.action="sca_conteudo_programatico_professor_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
function dadosHistorico(codigo){
		if (document.getElementById("historico_"+codigo).style.display=="none"){
			document.getElementById("historico_"+codigo).style.display="table-row"
			document.getElementById("imgDadosHistorico_"+codigo).src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			document.getElementById("historico_"+codigo).style.display="none"
			document.getElementById("imgDadosHistorico_"+codigo).src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function reload(){
		var frm = document.getElementById("frm");
		frm.submit();
	}
	
	function mostrarConteudo(situacao){
		var frm = document.getElementById("frm");
		$("#cmdEdicao").attr("disabled", true);
		$('button#cmdEdicao').text("AGUARDE...").attr({
			title:"AGUARDE..."
		});
		$("#cmdEnviado").attr("disabled", true);
		$('button#cmdEnviado').text("AGUARDE...").attr({
			title:"AGUARDE..."
		});
		frm.action="sca_conteudo_programatico_professor.asp?mostraConteudo="+situacao;
		frm.submit();
	}
	
	function marcaTodos(){
	  if(frm.chkTodos.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
	  }else{
	  
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
	  }
	  return true;
	}
	
	function enviarTodosSelecionados(){
		var frm = document.getElementById("frm");
		
		var selecionado = "N";
		
		for (var i = 0; i < frm.elements.length; i++) {
			if (frm.elements[i].type == "checkbox"){				
				if (frm.elements[i].checked == true)
				{
					selecionado = "S";
				}
			}
		}
		
		if (selecionado == "N"){
			alert("Um ou mais conteúdo(s) deverá(rão) ser selecionado(s), para o envio!");
			return false
		}
		
		if (confirm("Deseja enviar todos os conteudos selecionados?")){
			frm.action="sca_conteudo_programatico_professor_cod.asp?acao=ENVIAR";
			frm.submit();
			return true
		}
	}
	
	function excluirTodosSelecionados(){
		var frm = document.getElementById("frm");
		
		var selecionado = "N";
		
		for (var i = 0; i < frm.elements.length; i++) {
			if (frm.elements[i].type == "checkbox"){	
				if (frm.elements[i].checked == true && frm.elements[i].name=="chkInserir")
				{
					selecionado = "S";
				}
			}
		}
		
		if (selecionado == "N"){
			alert("Um ou mais conteúdo(s) deverá(rão) ser selecionado(s), para a exclusão!");
			return false
		}
		
		if (confirm("Deseja excluir todos os conteudos selecionados?")){
			frm.action="sca_conteudo_programatico_professor_cod.asp?acao=E";
			frm.submit();
			return true
		}
	}
	
	function resultadoConsulta(intCodigo,podeEditarSemHorario){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.txtPodeEditar.value=podeEditarSemHorario;
		frm.submit();
	}
	
	function blocTexto(valor, id)
	{
		quant = 500;
		total = valor.length;
		if (total <= quant) {
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}else{
			alert("Quantidade de caracteres digitado foi atingida!")
		}
	}
	
	
</script>
<%
	acao = "I"
	
	strExecutarSubmitMes						= "S"
	strExecutarSubmitSemestre 					= "S"
	strExecutarSubmitTurma					 	= "S"
	strExecutarSubmitDisciplinaDoProfessor  	= "S"
	strExecutarSubmitProfessor					= "S"
	strVerificaTurmaProfessor 					= ""
	naochecarhorario							= "N"
	strExecutarSubmitCurso	  					= "S"
	strExecutarSubmitPeriodo  					= "S"
	strExecutarSubmitSemestre 					= "S"
	strExecutarSubmitTurno	  					= "S"
	strExecutarSubmitSemestre 					= "S"
	carregaturnodireto 							= "N"

	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaTipolancamento = "Professor"
	else
		strVerificaTipolancamento = ""
	end if
	rs.close
	
	if Session("Seg_CodCategoria") = "1" then strVerificaTipolancamento = "Professor"
	
	strVerificaRegencia	= Trim(Request.Form("txtVerificaRegencia"))
	ckVerificaRegencia = ""
    if strVerificaRegencia = "S" then ckVerificaRegencia = " checked "	

	strHabilitaPlanoEnsino = "N"
	sql = " SELECT top 1 Habilitar_PlanoEnsino, Bloqueia_ConteudoProgramatico "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	response.write sql
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strHabilitaPlanoEnsino = rs("Habilitar_PlanoEnsino")
		strBloqueiaConteudoProgramatico = rs("Bloqueia_ConteudoProgramatico")
		if isnull(strHabilitaPlanoEnsino) then strHabilitaPlanoEnsino = "N"
		if isnull(strBloqueiaConteudoProgramatico) then strBloqueiaConteudoProgramatico = "0"
	end if
	rs.close

	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	if Trim(Request.Form("cmbSemestre")) <> "" then
		intSemestre 				= Trim(Request.Form("cmbSemestre"))
	else
		intSemestre 				= session("strSemestre")
    end if	
    strBloqueio = ""
	if trim(strBloqueiaConteudoProgramatico) <> "0" then
	   	strAnoLetivo 				= session("strAnoLetivo")   
		intSemestre 				= session("strSemestre")
		strBloqueio                 = " readonly "
	end if	
	
	mostraConteudo 				= Trim(Request("mostraConteudo"))
	
 	strOpcaoDesvinculaConteudo	= Trim(Request.Form("optOpcao"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	intCodColaboradorProfessor  = Trim(Request("cmbProfessor"))
	
	intCodTurno					= Trim(Request("cmbTurnoDoProfessor"))
	intCodTurnoCombo			= Trim(Request("cmbTurnoDoProfessor"))
	
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
    intCodDisciplina		    = Trim(Request("cmbDisciplinaDoProfessor"))
	strDataFinal         		= formatadataAP(date)
    strMes		 	        	= Trim(Request("cmbMes"))
	intCodTurma					= intCodTurmaProfessor
	
	if Trim(Request("txtDataInicial")) = "" then
	   strDataInicial    	= "" 'formatadataAP(date)
	else   
	   strDataInicial      	= formatadataAP(Trim(Request("txtDataInicial")))
	end if   

	if Trim(Request("txtDataInicial")) = "" then
	   strDataFinal   	 =  "" 'formatadataAP(date)
	else   
	   strDataFinal      = formatadataAP(Trim(Request("txtDataFinal")))
	end if   
 	if trim(request("txtAnoConteudoDevolucao")) = "" then 
		strAnoConteudoDevolucao = session("strAnoLetivo")
	else
		strAnoConteudoDevolucao = request.Form("txtAnoLetivo")
	end if

    strTotalAulasDia     = Trim(Request("txtTotalAulasDia"))
	
	' Valida o ano da data de lançameto com ano Letivo
	if strDataInicial <> "" then 
		if trim(year(strDataInicial)) <> trim(strAnoLetivo) then
			%>
			<script>
				//alert("ATENÇÃO: \n\O Ano da Data de Lançamento deve ser igual ao Ano Letivo.");
			</script>
			<%	
			''strDataInicial = ""
		end if
	end if
	
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	if intCodProfessor = "" then intCodProfessor = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	if intCodTurmaProfessor <> "0" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurmaProfessor
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo 	= rs("cod_periodo")
			intSemestre 	= rs("cod_Semestre")
			strSemestre 	= rs("cod_Semestre")
		END IF
	rs.close
	end if
	
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	strPodeEditar 	= Trim(Request.Form("txtPodeEditar"))
	if strPodeEditar = "" then strPodeEditar = "N"
	strDescricao 	= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodigo) <> "" then
		sql = "SELECT *"
		sql = sql & " FROM sca_conteudo"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodHorario	 		= rs("codigo")
			strDescricao			= rs("conteudo")
			strAnoLetivo	 		= rs("anoletivo")
			intSemestre				= rs("semestre")
			intCodTurmaProfessor	= rs("cod_turma")
			intCodDisciplina		= rs("cod_disciplina")
			if SESSION("CODGRUPO")="7" THEN
				intCodTurno				= rs("cod_turno")
			end if
			
			total_aulas				= rs("total_aulas")
			
			strDataInicial          = formatadataAP(rs("datainicial"))
	        strDataFinal            = rs("datafinal")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

			acao = "A"
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if session("codGrupo") = "7" then
		if intCodTurnoRH = "" then intCodTurnoRH = "0"
		if intCodTurno = "" then intCodTurno = "0"
		sql = "select trh.cod_turno from SCA_TURNO t inner join SRH_TURNO trh on trh.desc_turno = t.desc_turno and trh.Cod_Grupo = " & session("codGrupo") & " where t.cod_turno = " & intCodTurno
		rs.open sql, cnn
		if not rs.eof then
			intCodTurnoRH = rs("cod_turno")
		end if
		rs.close
	end if

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_conteudo_programatico_professor.asp">
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
										<!--#include file="includes/inc_cmdTurmaProfessorConteudo.asp"-->
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Turno:</label>
										 <!--#include file="includes/inc_cmdTurnoDoProfessorConteudo.asp"-->
									</div>
								</div>
							</div>
							
							<div class="row">
								
									<div class="col-sm-6">
										<div class="form-group">
											<label class="form-label">Disciplina:  Ao selecionar a disciplina os lançamento cadastrados serão listado abaixo.</label>
											<!--#include file="includes/inc_cmdDisciplinaDoProfessorConteudo.asp"-->
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="form-label">Professor(a):</label>
											 <!--#include file="includes/inc_cmdProfessorComHorarioDisciplina.asp" -->
										</div>
									</div>
								
							</div>
							<%	if strDesabilitaEnvio = "" then  
									'strBloqueiaData = " readonly "
								else  
									strBloqueiaData = " "
								end if 
							 %>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Data do Lançamento:</label>
										 <!--#include file="includes/inc_cmdDataLancamentoHorarioCalendario.asp" -->
									</div>
								</div>
								 <% if strHabilitaPlanoEnsino = "N" then %>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Data do Lançamento Final:</label>
										 <input  name="txtDataFinal" type="text" class="form-control" id="txtDataFinal"  onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>">
									</div>
								</div>
								<% end if %>
							</div>
							
							<% if strHabilitaPlanoEnsino = "S" then 
							
								strConteudo = ""
								sql = "select conteudo_programatico from sca_turma t "
								sql = sql & " inner join sca_gradecurricular gc on t.cod_gradecurricular = gc.cod_gradecurricular "
								sql = sql & " inner join sca_gradecurriculardisciplina gcd on gcd.cod_gradecurricular = gc.cod_gradecurricular and T.situacao='A' "
								sql = sql & " inner join sca_planoensino pe on pe.cod_gradecurricular = gc.cod_gradecurricular and pe.cod_gradecurriculardisciplina = gcd.cod_disciplina and pe.cod_empresa=gc.cod_empresa "
								sql = sql & " where pe.anoLetivo = " & strAnoLetivo
								sql = sql & " and t.cod_empresa = " & Session("CodEmpresa")	
								sql = sql & " and gcd.cod_disciplina = " & intCodDisciplina
								sql = sql & " and t.cod_turma = " & intCodTurmaProfessor
								if ucase(session("usuarioweb")) = "SERGIO" then 
									'response.write sql & "<hr>"
									'response.write sql
								end if
								rs.open sql, cnn
								if rs.eof = false then
									strConteudo	 		= rs("conteudo_programatico")
									if isnull(strConteudo) then strConteudo = ""
								end if 
								rs.close
							
							%>
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<div class="accordion accordion-hover" id="js_demo_accordion-5">
											<div class="card">
												<div class="card-header">
													<a href="javascript:void(0);" class="card-title collapsed" data-toggle="collapse" data-target="#js_demo_accordion-5a" aria-expanded="false">
														<i class="fal fa-list width-2 fs-xl"></i>
														Conte&uacute;do Program&aacute;tico
														<span class="ml-auto">
															<span class="collapsed-reveal">
																<i class="fal fa-chevron-up fs-xl"></i>
															</span>
															<span class="collapsed-hidden">
																<i class="fal fa-chevron-down fs-xl"></i>
															</span>
														</span>
													</a>
												</div>
												<div id="js_demo_accordion-5a" class="collapse" data-parent="#js_demo_accordion-5">
													<div class="card-body">
														<%=strConteudo%>
														
														<% if strConteudo <> "" then %>
														<br><i>Obs: O quadro acima &eacute; apenas para visualiza&ccedil;&atilde;o, toda inclus&atilde;o dever&aacute; ser feita no cronograma.</i>
														<% end if%>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<% end if %>
							
					
							
							
										<%
						if strDataInicial <> "" and intCodTurmaProfessor <> "0" and intCodDisciplina <> "0" then 
							
							sql = " select SCA_HORARIO_AULA.diaSemana, isnull(SCA_HORARIO.numero_aula,'1'), isnull(SCA_HORARIO.numero_aula,'1') * COUNT(SCA_HORARIO_AULA.cod_disciplina) as total_aulas  "
							sql = sql & " from SCA_HORARIO_AULA "
							sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario " 
							sql = sql & " inner join SCA_DISCIPLINA on SCA_DISCIPLINA.cod_disciplina=SCA_HORARIO_AULA.cod_disciplina "
							IF SESSION("CODGRUPO")="7" THEN
								SQL = SQL & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = SCA_HORARIO.CodTurno " 
								SQL = SQL & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "				
							END IF
							sql = sql & " where SCA_HORARIO_AULA.cod_empresa = " & Session("CodEmpresa")
							sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & strAnoLetivo 
							sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurmaProfessor  
							IF DISCIPLINA_ATUAL = "PLANEJAMENTO" THEN
								sql = sql & " and SCA_DISCIPLINA.Desc_Disciplina = 'EDUCAÇÃO FÍSICA'"
							ELSE
								sql = sql & " and SCA_HORARIO_AULA.cod_disciplina = " & intCodDisciplina 
							END IF
							sql = sql & " and SCA_HORARIO_AULA.diaSemana = " & weekday(strDataInicial) 
							IF SESSION("CODGRUPO")="7" THEN
								sql = sql & " and TRH.cod_turno = " & intCodTurno
							END IF
							sql = sql & " group by SCA_HORARIO_AULA.diaSemana, SCA_HORARIO.numero_aula "
				
							if strDataInicial <> "" then
								sql = sql & " UNION "
								sql = sql & " select DATEPART(DW, SCA_HORARIO_AULA_EXTRA.DataLancamento) AS diaSemana, isnull(SCA_HORARIO.numero_aula,'1'), isnull(SCA_HORARIO.numero_aula,'1') * COUNT(SCA_HORARIO_AULA_EXTRA.cod_disciplina) as total_aulas  "
								sql = sql & " from SCA_HORARIO_AULA_EXTRA "
								sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA_EXTRA.Cod_Horario " 
								sql = sql & " inner join SCA_DISCIPLINA on SCA_DISCIPLINA.cod_disciplina=SCA_HORARIO_AULA_EXTRA.cod_disciplina "
								IF SESSION("CODGRUPO")="7" THEN
									sql = sql & " inner join SCA_TURNO on SCA_TURNO.Cod_Turno = SCA_HORARIO.CodTurno"
									sql = sql & " inner join SRH_TURNO on left(SRH_TURNO.Desc_Turno,3) = left(SCA_TURNO.Desc_Turno,3)	"				
								END IF
								sql = sql & " where SCA_HORARIO_AULA_EXTRA.cod_empresa = " & Session("CodEmpresa")
								sql = sql & " and SCA_HORARIO_AULA_EXTRA.anoletivo = " & strAnoLetivo 
								sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_turma = " & intCodTurmaProfessor  
								IF DISCIPLINA_ATUAL = "PLANEJAMENTO" THEN
									sql = sql & " and SCA_DISCIPLINA.Desc_Disciplina = 'EDUCAÇÃO FÍSICA'"
								ELSE
									sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_disciplina = " & intCodDisciplina 
								END IF
								sql = sql & " and SCA_HORARIO_AULA_EXTRA.DataLancamento = '" & formatadataBD(strDataInicial) & "'" 
								IF SESSION("CODGRUPO")="7" THEN
									sql = sql & " and SRH_TURNO.cod_turno = " & intCodTurno
								END IF
								sql = sql & " group by SCA_HORARIO_AULA_EXTRA.DataLancamento, SCA_HORARIO.numero_aula "
							end if
							if ucase(session("usuarioweb")) = "SERGIO" then 
								'response.write sql & "<hr>"
								'response.write sql
							end if
							RSAUX.OPEN SQL, CNN
							IF NOT RSAUX.EOF THEN
								if isnull(RSAUX("total_aulas")) then
								   TotalAulaDiaria = 0
								else   
								   TotalAulaDiaria = RSAUX("total_aulas") 
								end if 
							else
								TotalAulaDiaria = 0
							end if
							RSAUX.close
							strTotalAulasDia = TotalAulaDiaria
							
							if session("CodGrupo") = "2" then
							   soLeitura = " "
							else
							   soLeitura = " readonly "
							end if   
							if strPodeEditar = "S" then
								strTotalAulasDia = total_aulas
							end if
							%> 
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Total de Aulas (horário de aula)</label>
										<input <%=soLeitura%> name="txtTotalAulasDia" type="text" class="form-control" id="txtTotalAulasDia" value="<%=strTotalAulasDia%>" size="2" maxlength="2" > 
									</div>
								</div>						
							</div>
					   <% end if  %> 
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										
										
										<% if strHabilitaPlanoEnsino = "N" then %>
											 <label class="form-label">Conte&uacute;do</label>
									   <% else %> 
											 <label class="form-label">Cronograma</label>
											 <textarea class="form-control" aria-label="With textarea" name="txtDescricao" id="txtDescricao"><%=strDescricao%></textarea>
									   <% end if %>
										
										
									</div>
								</div>	
							</div>			
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
							
							<%if intCodDisciplina<>"0" then%>
								<button onclick="return mostrarConteudo('Edicao')"  name="cmdEdicao" id="cmdEdicao" type="button" class="btn btn-outline-info">Visualizar Conteúdo em Edição</button>
								<button onclick="return mostrarConteudo('Enviado')" name="cmdEnviado" id="cmdEnviado" type="button" class="btn btn-outline-success">Visualizar Conteúdo Enviado</button>
							<%end if%>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<%
if mostraConteudo<>"" then
	if mostraConteudo = "Edicao" then mostraConteudo = "N"
	if mostraConteudo = "Enviado" then mostraConteudo = "S"
	if intCodProfessor = "" then intCodProfessor = 0
	if isnull(intCodProfessor) then intCodProfessor = 0
	cont =0
	if intSemestre = "" then intSemestre = session("strSemestre")
	if intCodTurno = "" then intCodTurno = 0
	sql = "SELECT c.Total_Aulas, c.codigo, c.data_envio, c.Fechamento, c.datainicial, c.datafinal, c.conteudo, t.nometurma, t.turmaaluno, d.Desc_Disciplina, cc.nome, ccU.nome as nomeU, dd.codigo as cod_conteudo_dev, dd.nome_colaborador_devolveu, dd.conteudo_devolucao, dd.data_hora_incl, dd.codigo_seg_usuario_sistema_devolveu, c.Cod_Colaborador_ultima_interacao, c.cod_colaborador"
	sql = sql & " FROM SCA_Conteudo c"
	sql = sql & " inner join sca_turma t on t.cod_turma = c.cod_turma and t.cod_empresa = c.cod_empresa"
	sql = sql & " inner join sca_disciplina d on d.Cod_Disciplina = c.Cod_Disciplina and d.cod_empresa = c.cod_empresa"
	sql = sql & " left join SCA_CONTEUDO_DEVOLUCAO dd on dd.cod_conteudo = c.codigo"
	sql = sql & " left join SRH_COLABORADOR cc on cc.codigo = c.cod_colaborador"
	sql = sql & " left join SRH_COLABORADOR ccU on ccU.codigo = c.Cod_Colaborador_ultima_interacao"
	sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and c.anoletivo = " & strAnoLetivo		
	sql = sql & " and c.semestre in (" & intSemestre & ")"
	sql = sql & " and c.fechamento = '" & mostraConteudo & "'"
	'if strVerificaRegencia <> "S" then
		'sql = sql & " and c.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')"
	'	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = 0
	'	sql = sql & " and c.cod_colaborador = " & intCodColaboradorProfessor
	'end if
'	sql = sql & " and (c.cod_colaborador = " & intCodProfessor & " or c.Cod_Colaborador_ultima_interacao = " & intCodProfessor & ")"
	sql = sql & " and (c.cod_turma = " & intCodTurmaProfessor & " or c.cod_colaborador = " & intCodProfessor & " or c.Cod_Colaborador_ultima_interacao = " & intCodProfessor & ")"

	if intCodTurno <> "0" AND SESSION("CODGRUPO")="7" then
		sql = sql & " and c.cod_turno = " & intCodTurno
	end if	
	if intCodTurmaProfessor <> "0" then
		sql = sql & " and c.cod_turma = " & intCodTurmaProfessor
	end if	
	if intCodDisciplina <> "0" then
		sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
	end if	
	if strMes <> "0" and strMes<>"" and strAnoConteudoDevolucao<>"" then
		sql = sql & " and month(c.datainicial) = " & strMes
		sql = sql & " and year(c.datainicial) = " & strAnoConteudoDevolucao
	end if
	sql = sql & " Order by c.anoletivo, c.semestre, c.datainicial desc, c.codigo desc, t.nometurma, d.Desc_Disciplina"
	
	if ucase(trim(session("usuarioweb"))) = "SERGIO" then 
		'response.write sql
	end if

	rs.open sql, cnn
	if rs.eof = false then
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
						<%if mostraConteudo = "N" then%>
						<div class="panel-tag">
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<%end if%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></th>
									<th><strong>Turma</strong></th>
									<th><strong>Disciplina</strong></th>
									<th><strong>Professor</strong></th>
									<th><strong>Data</strong></th>
									<th><strong>Aulas</strong></th>
									<th><strong>Conte&uacute;do</strong></th>
									<th><strong>Status</strong></th>
									<th><strong>...</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									  codigo_conteudo = 0
									  datainicial = ""
									while not rs.eof
										
										nomeU = ""
										if not isnull(rs("nomeU")) then nomeU = "<br>" & rs("nomeU")
										
										if rs("Cod_Colaborador_ultima_interacao") = "0" then nomeU = "<br>Deficit"
										
										nome = rs("nome")
										if isnull(nome) or nome = "" then nome = "Deficit"
										
										if rs("nome") = rs("nomeU") then nomeU = ""
										if rs("Cod_Colaborador_ultima_interacao") = rs("cod_colaborador") then nomeU = ""
										
										if codigo_conteudo <> rs("codigo") and datainicial <> rs("datainicial") then
										
											if trim(rs("Fechamento")) <> "S" then
											   %>
												  <tr style="cursor: pointer">
													<td width="1%"><input name="chkInserir" type="checkbox" value="<%=rs("codigo")%>"<%=strMarca%>></td>
													<td onClick="return resultadoConsulta('<%=rs("codigo")%>','<%if not isnull(rs("cod_conteudo_dev")) then%>S<%ELSE%>N<%end if%>')"><%=rs("TurmaAluno")%>&nbsp;&nbsp;<%=rs("nometurma")%></td>
													<td onClick="return resultadoConsulta('<%=rs("codigo")%>','<%if not isnull(rs("cod_conteudo_dev")) then%>S<%ELSE%>N<%end if%>')"><%=rs("Desc_Disciplina")%></td>
													<td onClick="return resultadoConsulta('<%=rs("codigo")%>','<%if not isnull(rs("cod_conteudo_dev")) then%>S<%ELSE%>N<%end if%>')"><%=nome & nomeU%>&nbsp;</td>
													<td onClick="return resultadoConsulta('<%=rs("codigo")%>','<%if not isnull(rs("cod_conteudo_dev")) then%>S<%ELSE%>N<%end if%>')"><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;</td>
													<td onClick="return resultadoConsulta('<%=rs("codigo")%>','<%if not isnull(rs("cod_conteudo_dev")) then%>S<%ELSE%>N<%end if%>')"><%=rs("Total_Aulas")%>&nbsp;</td>
													<td onClick="return resultadoConsulta('<%=rs("codigo")%>','<%if not isnull(rs("cod_conteudo_dev")) then%>S<%ELSE%>N<%end if%>')"><%=trim(rs("conteudo"))%>&nbsp;</td>
													<td>
											
														<strong>Edi&ccedil;&atilde;o &nbsp;&nbsp;&nbsp;
														<button onClick="return enviarTodosSelecionados()"   name="btnEnviarConteudo"  id="btnEnviarConteudo"  type="button" class="btn btn-outline-success"  style="width:-webkit-fill-available">Enviar</button>
														<button onClick="return excluirTodosSelecionados()"  name="btnRemoverConteudo" id="btnRemoverConteudo" type="button" class="btn btn-outline-danger"   style="width:-webkit-fill-available">Remover</button>
														</strong>
													
													</td>
													<td height="20"  style="cursor: pointer"><%if not isnull(rs("cod_conteudo_dev")) then%><i class="fal fa-list" data-toggle="modal" data-target="#default-example-modal-lg<%=rs("codigo")%>"></i> <%end if%></td>
												  </tr>
											<%
											   TotalAulas = TotalAulas + rs("Total_Aulas")	
											   cont = cont + 1	
											else
											   %>
											   <tr>
												   <td width="1%" >&nbsp;</td>
												   <td><%=rs("TurmaAluno")%>&nbsp;&nbsp;<%=rs("nometurma")%></td>
												   <td><%=rs("Desc_Disciplina")%></td>
												   <td><%=nome & nomeU%>&nbsp;</td>
												   <td align="center"><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;</td>
												   <td><div align="center"><%=rs("Total_Aulas")%>&nbsp;</div></td>
												   <td height="20"><%=trim(rs("conteudo"))%></td>
												   <td height="20"><strong><font color='#blue'>Enviado</font></strong><br><%=rs("data_envio")%></td>
												   <td height="20"  style="cursor: pointer"><%if not isnull(rs("cod_conteudo_dev")) then%><i class="fal fa-list" data-toggle="modal" data-target="#default-example-modal-lg<%=rs("codigo")%>"></i> <%end if%></td>
											   </tr>
											   <%
											   TotalAulas = TotalAulas + rs("Total_Aulas")	
											   cont = cont + 1	
											end if
											
										end if
										if strConteudoListado = "" then
											strConteudoListado = rs("codigo")
										else
											strConteudoListado = strConteudoListado & "," & rs("codigo")
										end if
										rs.movenext
									wend
									%>
									<tr> 
									<td height="21" colspan="9" class="celula">
										<span class="texto">
											Total Registros:
										</span> 
										<%=cont%>
									</td>
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
		rs.close
		cod_conteudo_modal=""
		if strConteudoListado <> "" then
			sql = "SELECT dd.cod_conteudo, c.cod_turma, cc.nome, ccU.nome as nomeU, dd.codigo as cod_conteudo_dev, dd.nome_colaborador_devolveu, dd.conteudo_devolucao, dd.data_hora_incl, dd.codigo_seg_usuario_sistema_devolveu, c.Cod_Colaborador_ultima_interacao, c.cod_colaborador "
			sql = sql & " FROM SCA_Conteudo c "
			sql = sql & " inner join SCA_CONTEUDO_DEVOLUCAO dd on dd.cod_conteudo = c.codigo "
			sql = sql & " left join SRH_COLABORADOR cc on cc.codigo = c.cod_colaborador "
			sql = sql & " left join SRH_COLABORADOR ccU on ccU.codigo = c.Cod_Colaborador_ultima_interacao "
			sql = sql & " where c.codigo in (" & strConteudoListado & ")"
			sql = sql & "  Order by c.anoletivo, c.semestre, c.datainicial desc, c.codigo desc"
			rs.open sql, cnn
			if rs.eof = false then
				controle = ""
				while not rs.eof
					nome_colaborador_devolveu = rs("nome_colaborador_devolveu")
					if trim(nome_colaborador_devolveu) = "" or isnull(nome_colaborador_devolveu) then nome_colaborador_devolveu = rs("codigo_seg_usuario_sistema_devolveu")
					if cod_conteudo_modal <> rs("cod_conteudo") then
						if controle = "OK" then
							%>
											
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
										</div>
									</div>
								</div>
							</div> 
							<!-- Modal Large FINAL -->
							<%
						end if
						
							controle = "OK"
							%>
						
							<!-- Modal Large INICIO -->
							<div class="modal fade" id="default-example-modal-lg<%=rs("cod_conteudo")%>" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-lg" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h5 class="modal-title">Movimentação da devolução</h5>
											<button type="button" class="close" data-dismiss="modal" aria-label="Close">
												<span aria-hidden="true"><i class="fal fa-times"></i></span>
											</button>
										</div>
										<div class="modal-body">
											
										<div class="table-responsive-lg">
											<table class="table table-bordered table-hover m-0">
												<thead class="thead-themed">
												  <tr>
													<th width="30%"><strong>Colaborador que devolveu</strong></th>
													<th width="30%"><strong>Motivo da Devolução</strong></th>
													<th width="20%"><strong>Usuário Inclusão</strong></th>
													<th width="20%"><strong>Data Hora Inclusão</strong></th>
												  </tr>
												</thead>
											<tbody>
									
					<%
					end if
					%>		
									
											<tr>
												<td class="celula"><%=nome_colaborador_devolveu%></td>
												<td class="celula"><%=rs("conteudo_devolucao")%></td>
												<td class="celula"><%=rs("codigo_seg_usuario_sistema_devolveu")%></td>
												<td class="celula"><%=rs("data_hora_incl")%></td>
											</tr>	
					
					<%
					cod_conteudo_modal = rs("cod_conteudo")
					
					rs.movenext
					if not rs.eof then
						if cod_conteudo_modal <> rs("cod_conteudo") then
							'response.write "</tbody></table></div>"
						end if
					end if
				wend
				%>
													</tbody>
												</table>
											</div>
											
											
									</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
								</div>
							</div>
						</div>
					</div> 			
				<%
			end if
			rs.close
			
		end if
	end if
	%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>