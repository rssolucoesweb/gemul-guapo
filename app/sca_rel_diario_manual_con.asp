<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitBimestre = "S"

	strOpcaoRelatorio 		= Trim(Request.Form("optOpcao"))
	if strOpcaoRelatorio = "" then strOpcaoRelatorio = "T"
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodDisciplinaCurso	= Trim(Request.Form("cmbDisciplinaCurso"))
	intCodEstagio     		= Trim(Request.Form("cmbEstagio"))
	
	strclasse=Trim(Request.Form("cmbTamanhoFonteArial"))
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   
	'intSemestre 			= session("strSemestre")
	intCodBimestre			= Trim(Request.Form("cmbBimestre"))
	
	strMes 					= Trim(Request.Form("cmbMes"))
	if strMes = "" then strMes = month(date)
	
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intSemestre = "" then intSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"
	if intCodEstagio = "" then intCodEstagio="0"
	
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
	else
		strVerificaCategoria = ""
	end if
	rs.close

    if strVerificaCategoria <> "Professor" then
	   intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
	   intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	else
	   intCodDisciplina		    = Trim(Request("cmbDisciplinaDoProfessor"))
	   intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))
	end if   

    if strVerificaCategoria <> "Professor" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else   
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if   

	if trim(intCodTurma) <> "" then
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
			if Trim(Request.Form("cmbTurno")) = "0" or Trim(Request.Form("cmbTurno"))="" then
				intCodTurno = rs("cod_turno")
			end if
			intSemestre = rs("cod_Semestre")
		END IF
		rs.close
	end if


	'controla os botões
	strDesabilitaIncluir 	= "disabled"
	strDesabilitaExcluir 	= "disabled"
	strDesabilitaAlterar 	= ""
	strDesabilitaLimpar 	= ""
	
	if intCodBimestre <> "0" then
		strColunas = 60
	else
		strColunas = 30
	end if

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_diario_manualCon.asp">
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
						
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Opção de relatório:</label>
									<select name="optOpcao" id="optOpcao"  class="form-control" >
										<option value="T" <% if strOpcaoRelatorio = "T" then response.Write("selected")%> >Por Turma</option>
										<option value="A" <% if strOpcaoRelatorio = "A" then response.Write("selected")%> >Por Turma</option>
									</select>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									<!--#include file="includes/inc_cmdCurso.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Per&iacute;odo:</label>
									<%
										if request.Form("txtHiddenStatus") <> "" then
										   strDesabilitaSerie = "disabled"
										end if
									 %>
									<!--#include file="includes/inc_cmdPeriodo.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									<!--#include file="includes/inc_cmdTurno.asp"-->
								</div>
							</div>
							<% if strVerificaCategoria = "" then%>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurma.asp" -->
								</div>
							</div>
							 <%end if%>
							 <% if strVerificaCategoria = "Professor" then%>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurmaProfessor.asp" -->
								</div>
							</div>
							 <%end if%>
							 <%if intCodTurma <>"0" then%>
								<% if strVerificaCategoria = "Professor" then%>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Disciplina:</label>
										 <!--#include file="includes/inc_cmdDisciplinaDoProfessor.asp" -->
									</div>
								</div>
								<%end if%>
								<% if strVerificaCategoria = "" then%>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Disciplina:</label>
										 <!--#include file="includes/inc_cmbDisciplinaTurma.asp" -->
									</div>
								</div>
								<%end if%>
							
							<% else%>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Disciplina:</label>
										 <!--#include file="includes/inc_cmbDisciplinaCurso.asp" -->
									</div>
								</div>
							<%end if%>
						</div>
						<div class="row">						
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Bimestre:</label>
									 <!--#include file="includes/inc_cmdBimestre.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">M&ecirc; Refer&ecirc;ncia:</label>
									 <!--#include file="includes/inc_cmbMes.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Tipo de Disciplinas:</label>
									 <select name="cmbTipoDisciplina" class="form-control" id="cmbTipoDisciplina">
										  <option value="CR" >Curricular</option>
										  <option value="DE" >Depend&ecirc;cia</option>
										  <option value="CD" >Curricular e Depend&ecirc;cia</option>
									  </select>
								</div>
							</div>
						</div>
						<div class="row">	
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Conte&uacute;do Program&aacute;tico:</label>
									<input type="checkbox" name="mostraConteudo" value="S">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Omitir Dados:</label>
									<input type="checkbox" name="omiteDadosdoDiario" value="S">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Omitir Data Impress&atilde;o:</label>
									<input type="checkbox" name="omiteDataImpressao" value="S">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Omitir ACM. FAL.:</label>
									<input type="checkbox" name="omiteAcumuladoFalta" value="S">
								</div>
							</div>
						</div>
						<div class="row">	
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Colunas:</label>
									<select name="cmbColunas" class="form-control" id="cmbColunas">
									  <option value="15" <%if strColunas = "15" then response.Write("selected") %>>15</option>
									  <option value="16" <%if strColunas = "16" then response.Write("selected") %>>16</option>
									  <option value="17" <%if strColunas = "17" then response.Write("selected") %>>17</option>
									  <option value="18" <%if strColunas = "18" then response.Write("selected") %>>18</option>
									  <option value="19" <%if strColunas = "19" then response.Write("selected") %>>19</option>
									  <option value="20" <%if strColunas = "20" then response.Write("selected") %>>20</option>
									  <option value="21" <%if strColunas = "21" then response.Write("selected") %>>21</option>
									  <option value="22" <%if strColunas = "22" then response.Write("selected") %>>22</option>
									  <option value="23" <%if strColunas = "23" then response.Write("selected") %>>23</option>
									  <option value="24" <%if strColunas = "24" then response.Write("selected") %>>24</option>
									  <option value="25" <%if strColunas = "25" then response.Write("selected") %>>25</option>
									  <option value="26" <%if strColunas = "26" then response.Write("selected") %>>26</option>
									  <option value="27" <%if strColunas = "27" then response.Write("selected") %>>27</option>
									  <option value="28" <%if strColunas = "28" then response.Write("selected") %>>28</option>
									  <option value="29" <%if strColunas = "29" then response.Write("selected") %>>29</option>
									  <option value="30" <%if strColunas = "30" then response.Write("selected") %>>30</option>
									  <%if intCodBimestre <> "0" then %>
										<option value="31" <%if strColunas = "31" then response.Write("selected") %>>31</option>
										<option value="32" <%if strColunas = "32" then response.Write("selected") %>>32</option>
										<option value="33" <%if strColunas = "33" then response.Write("selected") %>>33</option>
										<option value="34" <%if strColunas = "34" then response.Write("selected") %>>34</option>
										<option value="35" <%if strColunas = "35" then response.Write("selected") %>>35</option>
										<option value="36" <%if strColunas = "36" then response.Write("selected") %>>36</option>
										<option value="37" <%if strColunas = "37" then response.Write("selected") %>>37</option>
										<option value="38" <%if strColunas = "38" then response.Write("selected") %>>38</option>
										<option value="39" <%if strColunas = "39" then response.Write("selected") %>>39</option>
										<option value="40" <%if strColunas = "40" then response.Write("selected") %>>40</option>
										<option value="41" <%if strColunas = "41" then response.Write("selected") %>>41</option>
										<option value="42" <%if strColunas = "42" then response.Write("selected") %>>42</option>
										<option value="43" <%if strColunas = "43" then response.Write("selected") %>>43</option>
										<option value="44" <%if strColunas = "44" then response.Write("selected") %>>44</option>
										<option value="45" <%if strColunas = "45" then response.Write("selected") %>>45</option>
										<option value="46" <%if strColunas = "46" then response.Write("selected") %>>46</option>
										<option value="47" <%if strColunas = "47" then response.Write("selected") %>>47</option>
										<option value="48" <%if strColunas = "48" then response.Write("selected") %>>48</option>
										<option value="49" <%if strColunas = "49" then response.Write("selected") %>>49</option>
										<option value="50" <%if strColunas = "50" then response.Write("selected") %>>50</option>
										<option value="51" <%if strColunas = "51" then response.Write("selected") %>>51</option>
										<option value="52" <%if strColunas = "52" then response.Write("selected") %>>52</option>
										<option value="53" <%if strColunas = "53" then response.Write("selected") %>>53</option>
										<option value="54" <%if strColunas = "54" then response.Write("selected") %>>54</option>
										<option value="55" <%if strColunas = "55" then response.Write("selected") %>>55</option>
										<option value="56" <%if strColunas = "56" then response.Write("selected") %>>56</option>
										<option value="57" <%if strColunas = "57" then response.Write("selected") %>>57</option>
										<option value="58" <%if strColunas = "58" then response.Write("selected") %>>58</option>
										<option value="59" <%if strColunas = "59" then response.Write("selected") %>>59</option>
										<option value="60" <%if strColunas = "60" then response.Write("selected") %>>60</option>
									  <% end if %> 
									  </select>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Tamanho da Fonte:</label>
									 <!--#include file="includes/inc_cmbTamanhoFonteArial.asp" -->
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Linhas por P&aacute;gina:</label>
									<!--#include file="includes/inc_cmbLinhaPorPagina.asp" -->
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Op&ccedil;&atilde;o de Visualiza&ccedil;&atilde;o:</label>
									<!--#include file="includes/inc_cmbOpcaoVisualizacao.asp" -->
								</div>
							</div>
						</div>
						
						
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<strong>Obs:</strong> Melhor visualização e impressão modo paisagem.
								</div>
							</div>
						</div>
						

						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
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