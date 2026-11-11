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

	cod_grupo = session("codGrupo")
	if session("codGrupo") = "" then cod_grupo = 0
	
	acao = "I"

	strExecutarSubmit	  					= "S"
	strExecutarSubmitCurso	  				= "S"
	strExecutarSubmitPeriodo  				= "S"
	strExecutarSubmitSemestre 				= "S"
	strExecutarSubmitTurno	  				= "S"
	strExecutarSubmitTurnoRH				= "S"
	strExecutarSubmitProfessor				= "S"
	strExecutarSubmitTurma	  				= "S"
	strExecutarSubmitDisciplinaDoProfessor  = "S"
	strPaginaTitulo = "FichaDescritivaNotas_con.asp"
	strExecutarSubmitSemestre = "S"
	strAtivos               = trim(request("cmbativos"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
		intAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request.Form("txtAnoLetivo")
		intAnoLetivo = request.Form("txtAnoLetivo")
	end if
	if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
		intSemestre = session("strSemestre")
	    strSemestre = session("strSemestre")
	else
		intSemestre = request.Form("cmbSemestre")
	    strSemestre = request.Form("cmbSemestre")
	end if

	intCodBimestre				= Trim(Request("cmbBimestre"))
 	intCodFichaDescritiva	    = Trim(Request("cmbFichaDescritiva"))
    intCodColaboradorProfessor 	= Trim(Request("cmbProfessor"))
	
	
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
	intCodCurso	 			    = Trim(Request("cmbCurso"))
	intCodPeriodo 			    = Trim(Request("cmbPeriodo"))
	intCodGrade				    = Trim(Request("cmbGrade"))
	intCodTurno		 		    = Trim(Request("cmbTurno"))
	intCodTurnoRH		 		= Trim(Request("cmbTurnoRH"))
	intCodPlanoPagamento	    = Trim(Request("cmbPlanoPagamento"))
	strSala		 			    = Trim(Request("txtSala"))
	intAno		 			    = Trim(Request("txtAno"))
	intAnoLetivo 			    = Trim(Request("txtAnoLetivo"))
	intCodDisciplina            = trim(request("cmbDisciplinaDoProfessor"))
	strDataInicial              = formatadataAP(date)'Trim(Request("txtData"))
	strDataFinal                = formatadataAP(date)'Trim(Request("txtData"))
    strMes		 		        = Trim(Request("cmbMes"))
	

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina= "" then intCodDisciplina = "0"
	if intCodBimestre= "" then intCodBimestre = "0"

	if trim(Session("CodColaboradorContrato")) = "" then
	
		if Session("Seg_Perfil_especial") = "" or Session("Seg_Perfil_especial") = "N" then
			' Consulta a Categoria	
			'Consulta a Categoria	
			sql = "select codigo "
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
			sql = sql & " and (CodCategoria = 1 OR CodCategoria = 8)"'professor
			sql = sql & " and Situacao = 'A'"'ativo
			
			rs.open sql, cnn
			if rs.eof then
				strVerificaCategoria = ""
			else
			
				if (Session("Seg_CodCategoria") = "1") then
					strVerificaCategoria 		= "Professor"
					'intCodColaboradorProfessor 	= rs("codigo")
					'intCodProfessor 	      	= rs("codigo")
				ELSE
					strVerificaCategoria = ""
				END IF	
			
			end if
			rs.close
		end if
	end if

    strFichaDescritivaInterDisciplinar = "S"
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre, SCA_CURSO.descricao as curso, SCA_PERIODO.descricao as periodo , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.Cod_FichaDescritiva, isnull(SCA_PERIODO.tipo,'I') as TipoFicha,  TRH.cod_turno as Turno_RH"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_curso"
	sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = SCA_TURMA.Cod_Turno "  
	sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) and TRH.Cod_Grupo = " & Session("CodGrupo")	  
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurmaProfessor
	if session("usuarioWeb") = "SERGIO" THEN
			'RESPONSE.WRITE SQL & "<hr>"
		end if
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN

		intCodCurso 		= rs("cod_curso")
		intCodPeriodo 		= rs("cod_periodo")
		strCurso 			= rs("curso")
		strSerie 			= rs("periodo")
		intCodTurno 		= rs("cod_turno")
		intCodTurnoFicha 	= rs("cod_turno")
		intSemestre 		= rs("cod_Semestre")
		strTurnoNomeTurma 	= mid(rs("NomeTurma"),6,1)
		'if Trim(Request("cmbTurnoRH")) = "" or Trim(Request("cmbTurnoRH")) = "0" then
		intCodTurnoRH 	   	= rs("Turno_RH")
		'end if		
		if trim(rs("TipoFicha")) = "D" then
		   strFichaDescritivaInterDisciplinar = "N"
		else
		   strFichaDescritivaInterDisciplinar = "S"
		end if   
	END IF
	rs.close
	intCodigo 		    = Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM sca_conteudo"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodHorario	 		  = rs("codigo")
			strDescricao			  = rs("conteudo")
			strAnoLetivo	 		  = rs("anoletivo")
			intSemestre				  = rs("semestre")
			intCodColaboradorProfessor= rs("Cod_Colaborador")
			intCodTurmaProfessor	  = rs("cod_turma")
			intCodDisciplina		  = rs("cod_disciplina")
			strData					  = rs("data")
			strDesabilitaIncluir	  = "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	  = "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	  = "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	strDesabilitaConsultar = " disabled "
	if request.Form("cmbTurnoRH")<>"" then
		intCodTurnoRH = request.Form("cmbTurnoRH")
	end if

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_ficha_descritiva_alunoCon.asp">
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
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Bimestre/Trimestre:</label>
									<!--#include file="includes/inc_cmdBimestre.asp"-->
								</div>
							</div>
						</div>
						
						<div class="row">
						
							
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Professor:</label>
									<!--#include file="includes/inc_cmdProfessor.asp"-->
								</div>
							</div>
												
							<div class="col-sm-6">
								<div class="form-group">
								
									<label class="form-label">Turma:</label>
									<!--#include file="includes/inc_cmdTurmaProfessor.asp"-->
								</div>
							</div>
						</div>	
						
						<% if strTurnoNomeTurma = "I" then %>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Turno do Regente:</label>
									<!--#include file="includes/inc_cmbTurnoRH_FichaDescritiva.asp"-->
								</div>
							</div>
						</div>
						<% else %>
							<input name="cmbTurnoRH" value="<%=intCodTurnoRH%>" type="hidden">
						<% end if %>

						
						<%=intCodPeriodo%>
						<div class="row">
						
							<div class="col-sm-6">
								<div class="form-group">
								
									<label class="form-label">Disciplina:</label>
									<!--#include file="includes/inc_cmdDisciplinaDoProfessorDescritiva.asp"-->
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Ficha Descritiva:</label>
									<!--#include file="includes/inc_cmdFichaDescritiva.asp"-->
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Situações:</label>
									<!--#include file="includes/inc_cmbAtivos.asp"-->
								</div>
							</div>
						</div>
						
						<br>
						<div class="frame-wrap">
							<button onClick="submit()"  name="cmbConsultar" id="cmbConsultar" type="button" class="btn btn-outline-info">Consultar</button>
							<button onClick="window.location='sca_ficha_descritiva_alunoCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-warning">Limpar tela</button>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%if intCodTurma <> "0" and intCodFichaDescritiva<>"0" then%>

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
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
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
									'if buscaHistorico = "N" then
									'
									'   sql = " SELECT DISTINCT"
									'   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
									'   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
									'   sql = sql & " A.NOMEALUNO, "
									'   sql = sql & " A.MATRICULA, "
									'   sql = sql & " '' AS SEQUENCIA, "
									'   sql = sql & " SA.DESC_SITUACAOALUNO "
									'			   
									'   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
									'   sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
									'   sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN "
									'   sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
									'   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
									'   if intCodDisciplina <> "0" then
									'	 sql = sql & " AND GCD.COD_DISCIPLINA= " & intCodDisciplina
									'   end if
									'   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurmaProfessor
									'   if strAtivos = "A" then	
									'	  sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
									'   end if	  
									'   sql = sql & " ORDER BY A.NOMEALUNO "
									'else   
									'   'seleciona os alunos pelo ano e semestres do histórico 			
									'   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO "
									'   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
									'   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
									'   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
									'   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO" 
									'   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = HE.COD_EMPRESA "
									'   sql = sql & " WHERE HE.COD_EMPRESA = " & Session("CodEmpresa")
									'   sql = sql & " AND AT.COD_TURMA = " & intCodTurmaProfessor	
									'   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
									'   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
									'   if intCodDisciplina <> "0" then
									'	   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
									'   end if
									'   sql = sql & " ORDER BY NOMEALUNO "
									'end if
									'if ucase(session("usuarioWeb"))="SERGIO" then
									'seleciona os alunos da turma'		
										intCodTurma = intCodTurmaProfessor									
										sql = sqlAlunoTurma(intCodTurma, "")
										'RESPONSE.WRITE SQL
									'end if
									
									rs.open sql, cnn
									if rs.eof = false then
										selecionado = "checked"
										while not rs.eof
											strCodigoAluno        			= rs("codigo")
											strMatricula		  			= rs("MATRICULA")
											
											preencheu = ""
											cor = ""
										 %>
										 <tr style="cursor: pointer" onClick="carregaFicha('<%=rs("CODIGO")%>','<%=cod_grupo%>')">
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=tipo_criterio%></td>
											<td><%=rs("DESC_SITUACAOALUNO")%></td>
										</tr>
										 <%
										 rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
									 <td colspan="3" align="center"><%=session("strMensagemNaoEncontrado")%></td>
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