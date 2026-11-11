<%
strExecutarSubmit	  					= "S"
	strExecutarSubmitCurso	  				= "S"
	strExecutarSubmitPeriodo  				= "S"
	strExecutarSubmitSemestre 				= "S"
	strExecutarSubmitTurno	  				= "S"
	strExecutarSubmitProfessor				= "S"
	strExecutarSubmitTurma	  				= "S"
	strExecutarSubmitDisciplinaDoProfessor  = "S"
	strPaginaTitulo = "Rel_FichaDescritiva_con.asp"
	strExecutarSubmitSemestre = "S"

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

 	intCodFichaDescritiva	    = Trim(Request.form("cmbFichaDescritiva"))
'	RESPONSE.WRITE "intCodFichaDescritiva:" & intCodFichaDescritiva
	
    intCodColaboradorProfessor 	= Trim(Request("cmbProfessor"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	'intCodCurso	 			    = Trim(Request("cmbCurso"))
	'intCodPeriodo 			    = Trim(Request("cmbPeriodo"))
	intCodGrade				    = Trim(Request("cmbGrade"))
	intCodTurno		 		    = Trim(Request("cmbTurno"))
	intCodTurnoRH		 		= Trim(Request("cmbTurnoRH"))
	intAno		 			    = Trim(Request("txtAno"))
	intAnoLetivo 			    = Trim(Request("txtAnoLetivo"))
	intCodDisciplina            = trim(request("cmbDisciplinaDoProfessor"))

	intCodTurma 	    		= Trim(Request("cmbTurma"))
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
	
	strMatricula		= Trim(Request.Form("txtMatricula"))
    strCodAluno			    = Trim(Request("txtCodAluno"))
	strNomealuno 		    = Trim(Request("txtNomealuno"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	
	if intCodTurma = "" then intCodTurma = intCodTurmaProfessor
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodTurma = "" then intCodTurma = "0"
	
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina= "" then intCodDisciplina = "0"
	
	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			    = Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 	    	= Trim(rs("Nomealuno"))
		else
			strCodAluno			= 0
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close
		

	else
		strCodAluno			    = ""
		strMatricula 		= ""
		strNomealuno 		    = ""
	end if	

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
			intCodColaboradorProfessor 	= rs("codigo")
			intcategoria="1"
		ELSE
			strVerificaCategoria = ""
			intcategoria="0"
		END IF	
	
	end if
	rs.close

	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.Cod_FichaDescritiva, isnull(SCA_PERIODO.tipo,'I') as TipoFicha" 
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_curso"
	sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = SCA_TURMA.Cod_Turno "  
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		intCodTurno 		= rs("cod_turno")
		intSemestre 		= rs("cod_Semestre")
		strTurnoNomeTurma 	= mid(rs("NomeTurma"),6,1)
		strCurso 		= rs("curso")
		strSerie 		= rs("periodo")
		intCodPeriodo	= rs("Cod_Periodo")
		if Trim(Request("cmbTurnoRH")) = "" or Trim(Request("cmbTurnoRH")) = "0" then
			intCodTurnoRH 	= rs("cod_turno")
		end if	
			
		if trim(rs("TipoFicha")) = "D" then
		   strFichaDescritivaInterDisciplinar = "N"
		else
		   strFichaDescritivaInterDisciplinar = "S"
		end if   
	END IF
	rs.close
	
	
	strFichaDescritivaInterDisciplinar = ""
	sql = " SELECT top 1 isnull(FichaDescritiva_InterDisciplinar,'S') as TipoFicha "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strFichaDescritivaInterDisciplinar  = trim(rs("TipoFicha"))
	end if
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
			intCodTurma	  = rs("cod_turma")
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
   if intCodTurma = "0" then intCodTurma = intCodTurmaProfessor
   if intCodTurmaProfessor = "0" then intCodTurmaProfessor = intCodTurma
   
  ' response.write "intCodTurmaProfessor:" & intCodTurmaProfessor
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
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_ficha_descritivaCon.asp">
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
						
						<input name="txtCodigo" value="<%=intCodigo%>" type="hidden">
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
								
									<label class="form-label">Bimestre/Trimestre:</label>
									<!--#include file="includes/inc_cmdBimestre.asp"-->
								</div>
							</div>
						</div>	
						
						<%IF TRIM(strAnoLetivo) <> TRIM(session("strAnoLetivo")) THEN%>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group"><strong>Matrícula do Aluno</strong></label>
									<div class="input-group">
										<input type="text" class="form-control" value="<%=strMatricula%>" name="txtMatricula" id="txtMatricula" placeholder="" aria-label="" aria-describedby="button-addon5" onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
										<input name="txtCodAluno" type="hidden" id="txtCodAluno"  value="<%=strCodAluno%>">
										<div class="input-group-append">
											<button class="btn btn-primary waves-effect waves-themed" type="button" id="button-addon5" onClick="return abreConsulta('sca_aluno_con.asp')" ><i class="fal fa-search"></i></button>
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-9">
								<div class="form-group">
									<label class="form-label"></label>
									<input type="text" name="txtNomealuno" readonly id="txtNomealuno" class="form-control" value="<%=strNomeAluno%>">
								</div>
							</div>
						</div>

						<%ELSE%>
						
						
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									
									<% if strVerificaCategoria <> "Professor" then %>
										<!--#include file="includes/inc_cmdTurma.asp"-->
										<input name="cmdTurmaHidden" id="cmdTurmaHidden" value="<%=intCodTurma%>" type="hidden">
									<% else %>	 
										<!--#include file="includes/inc_cmdTurmaProfessor.asp"-->
										<input name="cmdTurmaHidden" id="cmdTurmaHidden" value="<%=intCodTurmaProfessor%>" type="hidden">
									<% end if %> 
									
								</div>
							</div>
							
							<% if strTurnoNomeTurma = "I" then %>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Turno do Regente:</label>
									<!--#include file="includes/inc_cmbTurnoRH_FichaDescritiva.asp"--><% if strcheckProfessor = "" then %> - Opcional <% end if %></td>
								</div>
							</div>
							<% else %>
										<input name="cmbTurnoRH" value="<%=intCodTurnoRH%>" type="hidden">
							<% end if %>
						
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Disciplina:</label>
									<!--#include file="includes/inc_cmdDisciplinaDoProfessorDescritiva.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Ficha Descritiva:</label>
									<%strMostraTodas="S"%>
									 <!--#include file="includes/inc_cmdFichaDescritiva.asp" -->
								</div>
							</div>
							
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Filtro:</label>
									<select name="cmbFiltro" id="cmbFiltro" class="form-control">
										<option value="0">Todos</option>
										<option value="C">Somente Conceito</option>
										<option value="D">Somente Descritivo</option>
									</select>
								</div>
							</div>
						</div>
						<%END IF%>
						
						<br>
						<div class="frame-wrap">
							<%strDesabilitaGerar = "S"%>
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
						</div>
					
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%
	cont  = 0
	if intCodTurma    = "" then intCodTurma="0"

	if intCodTurma <> "0" OR strCodAluno <> "" then
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
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Situa&ccedil;&atilde;o/Ficha</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								if buscaHistorico = "N" then
								   sql = " SELECT DISTINCT"
								   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
								   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
								   sql = sql & " A.NOMEALUNO, "
								   sql = sql & " A.MATRICULA, "
								   sql = sql & " '' AS SEQUENCIA, "
								   sql = sql & " SA.DESC_SITUACAOALUNO, '' as cod_ficha_descritiva "
								   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
								   sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
								   sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN "
								   sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
								   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
								   if intCodDisciplina <> "0" then
									 sql = sql & " AND GCD.COD_DISCIPLINA= " & intCodDisciplina
								   end if
								   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma
								   if strAtivos = "A" then	
									  sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
								   end if	  
								   sql = sql & " ORDER BY A.NOMEALUNO "
								else  
									IF strCodAluno = "" THEN strCodAluno = 0
								   'seleciona os alunos pelo ano e semestres do histórico 			
									sql = "SELECT DISTINCT A.CODIGO, A.NOMEALUNO, A.MATRICULA,  FD.descricao AS DESC_SITUACAOALUNO, P.cod_ficha_descritiva "
									 sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA F"
									 sql = sql & " inner join SCA_FICHA_DESCRITIVA_PERGUNTA P ON P.codigo = F.Cod_Ficha_Descritiva_Pergunta"
									 sql = sql & " INNER JOIN SCA_FICHA_DESCRITIVA FD ON FD.CODIGO = P.cod_ficha_descritiva"
									 sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = F.Cod_Turma"
									 sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_TURMA = T.COD_TURMA AND AT.COD_ALUNO = F.Cod_aluno"
									 sql = sql & " inner join SCA_ALUNO a on a.CODIGO = AT.COD_ALUNO "
									 sql = sql & " WHERE T.AnoLetivo=" & strAnoLetivo
									 sql = sql & " AND T.Cod_Empresa = " & Session("CodEmpresa") 
									 sql = sql & " and F.Cod_aluno = " & strCodAluno
									 sql = sql & " AND AT.ANO_LETIVO = " & strAnoLetivo
									 ANOSANTERIORES = "S"
								end if
								rs.open sql, cnn
								if rs.eof = false then
									cont = 0
									while not rs.eof
										strCodigoAluno        			= rs("codigo")
										strMatricula		  			= rs("MATRICULA")
										%>
										 <tr style="cursor: pointer"  onClick="return resultadoConsulta('<%=rs("CODIGO")%>','<%=rs("cod_ficha_descritiva")%>')">
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO")%></td>
											<td><%=rs("Desc_SituacaoAluno")%></td>											
										</tr>
										 <%
										 strNomeTurmaAnt = strNomeTurma
										 cont = cont + 1
										 rs.movenext
									  wend
									  %>
									   <tr>
										<td colspan="3" align="left"><strong>Quantidade de alunos: <%=cont%></strong></td>
									  </tr>
									  <%
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
		<input name="ANOSANTERIORES" id="ANOSANTERIORES" value="<%=ANOSANTERIORES%>" type="hidden">
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>