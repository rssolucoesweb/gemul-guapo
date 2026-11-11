<%
	strSimouNao_submit 					= "S"
    strExecutarSubmitCurso              = "S"
    strExecutarSubmitSemestre			= "S"
	strExecutarSubmitDisciplina	        = "S"
	strBotaoLimparTela 					= "N"
	strBotaoVoltaTelaAnterior 			= "S"
	
	if request("atualizamostrarel") = "S" then
		resultado = "N"
		if request("mostraRel") = "true" then
			resultado = "S"
		end if
		sql = "UPDATE sca_historico_escolar SET mostrar_historico_rel = '" &resultado & "' where codigo = " & request("codhistoricoEscolar")
		cnn.execute sql
	
	end if
	
	intCodEmpresa 						= Session("CodEmpresa")

	if Trim(Request("txtAnoHistorico")) = "" then
	   strAnoHistorico 					= session("strAnoLetivo")
	else   
	   strAnoHistorico 					= Trim(Request("txtAnoHistorico"))
	end if   

	if Trim(Request("cmbSemestreHistorico")) = "0" then
	   intSemestreHistorico 				= session("strSemestre")
	else   
	   intSemestreHistorico				= Trim(Request("cmbSemestreHistorico"))
	end if   

	intCodAluno							= Trim(Request("txtCodAluno"))
	strMatricula						= Trim(Request("txtMatricula"))
	codHistoricoEscolar					= Trim(Request("codHistoricoEscolar"))
	codHistoricoEscolarDisciplina		= Trim(Request("codHistoricoEscolarDisciplina"))
	strExpandirHistorico				= Trim(Request("txtExpandirHistorico"))
	strEscola							= Trim(Request("txtEscola"))
	strCidade							= Trim(Request("txtCidade"))
	strUfResidencia						= Trim(Request("cmbUFResidencia"))
	
	intCodPeriodo 						= Trim(Request("cmbPeriodo"))
	intCodCurso	            			= Trim(Request("cmbCurso"))
	
	'response.write "intCodCurso:" & intCodCurso
	
	intCodDisciplina					= Trim(Request("cmbDisciplina"))
	intCodTurmaHistorico				= Trim(Request("cmbTurmaHistorico"))
	strCH 								= Trim(Request("txtCH"))
	strMedia 							= Trim(Request("txtMedia"))
	strSituacaoPromocao 				= Trim(Request("cmbSituacaoPromocao"))
	strObservacao		   	 			= Trim(Request.Form("txtObservacao"))
	strSimouNao         				= Trim(Request("cmbSimouNao"))
	
	'bloqueia historico disciplina
	strPeriodo_Disabled = "" 
	strDisciplina_Disabled = ""  
	strAno_Disabled = "" 
	strSemestre_Disabled = "" 
	strCH_Disabled = "" 
	strSituacaoPromocao_Disabled = "" 
	strMedia_Disabled = "" 
	
	strExecutarSubmitPeriodo = "S"
	strFuncaoSitPromocao = "S"
	
	acao="I"
	
	if codHistoricoEscolar <> "" then
		sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
		sql = sql & " WHERE	CODIGO = " & codHistoricoEscolar
		'response.Write(sql)
		rs.open sql, cnn
		if not rs.eof then
			'DADOS DO HISTORICO 
			strEscola			= Trim(Rs("escola"))
			strCidade			= Trim(Rs("cidade"))
			strUfResidencia		= Trim(Rs("uf"))
			if Trim(Request("txtAnoHistorico"))="" then
			   strAnoHistorico		= Trim(Rs("ano_letivo"))
			end if 
			
			intSemestreHistorico= Trim(Rs("semestre"))
			strCurso			= Trim(Rs("curso"))
			strSerie			= Trim(Rs("serie"))
		    if Trim(Request("cmbCurso")) = "0" or Trim(Request("cmbCurso")) = "" then
			   intCodCurso		= Trim(Rs("cod_curso"))
			end if   
		    if Trim(Request("cmbPeriodo")) = "0" or Trim(Request("cmbPeriodo")) = "" then
			   intCodPeriodo		= Trim(Rs("cod_periodo"))
			end if   
			intCodAluno      	= Trim(rs("cod_aluno"))
			if  Trim(Request.Form("txtObservacao")) = "" then
				strObservacao		= Trim(Rs("observacao"))
			end if	
			strCHTotal = Trim(Rs("ch_total"))
'response.write "intCodCurso:" & intCodCurso
			'libera historico disciplina
			strPeriodo_Disabled = ""
			strDisciplina_Disabled = "" 
			strAno_Disabled = ""
			strSemestre_Disabled = ""
			strCH_Disabled = ""
			strSituacaoPromocao_Disabled = ""
			strMedia_Disabled = ""
			acao="AE"
		end if
		rs.close
		strObservacaoGeral=""
		sql = "SELECT observacoes FROM SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL "
		sql = sql & " WHERE	cod_aluno = " & intCodAluno
		rs.open sql, cnn
		if not rs.eof then
			strObservacaoGeral			= Trim(Rs("observacoes"))
		end if
		rs.close
	end if

	sql = " select RAZAOSOCIAL, MUNICIPIO, SCF_UF.codigo "
	sql = sql & " from seg_empresa "
	sql = sql & " INNER JOIN SCF_UF ON SCF_UF.sigla=SEG_EMPRESA.UF	"
	sql = sql & " and seg_empresa.codigo = " & intCodEmpresa
	rs.open sql, cnn
	if not rs.eof then
       if strEscola = "" then strEscola = Trim(Rs("RAZAOSOCIAL"))
       if strCidade = "" then strCidade = Trim(Rs("MUNICIPIO"))
       if strUfResidencia = "" then strUfResidencia = Trim(Rs("codigo"))
    end if
	rs.close

	
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_historico_escolar.asp">

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
						<%
						strMatricula = ""
						strDataNascimento = ""
						strNomeCompleto = ""
						if intSemestreHistorico = "" then intSemestreHistorico = "0"
						sql = "SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO,"
						sql = sql & " SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATACOLACAO,SCA_ALUNO.ANOCONCLUSAO,SCA_ALUNO.MAE "
						sql = sql & " FROM SCA_ALUNO "
						sql = sql & " where SCA_ALUNO.CODIGO = " & intCodAluno
						
						rs.open sql, cnn
						if not rs.eof then
							strMatricula = rs("MATRICULA")
							strDataNascimento = formatadataap(rs("DATANASCIMENTO"))
							strNomeCompleto = rs("NOMEALUNO") 
							
							%>
							<div class="table-responsive-lg">
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										<th><strong>Matr&iacute;cula:</strong></th>
										<th><strong><%=strMatricula%></strong></th>
										<th><strong>Aluno:</strong></th>
										<th><strong><%=strNomeCompleto%></strong></th>
										<th><strong>Data Nasc.:</strong></th>
										<th><strong><%=strDataNascimento%></strong></th>
									  </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
							<%
						else
						   %>
							<script>
							   alert("ATENÇÃO: O Aluno não encontrado, verifique!");
							   window.history.back();
							</script>
						   <%
						end if
						rs.close
					  %>
					 <%		
			strMediaAprovacao = 0
			
			if intCodCurso = "" then intCodCurso = 0
			sql	=	"select media_aprovacao as resultado_aprovacao_final from SCA_CRITERIO_AVALIACAO"
			sql	=	sql & " where cod_curso=" & intCodCurso
		    rs.open sql, cnn
			if rs.eof = false then
				strMediaAprovacao           = trim(rs("resultado_aprovacao_final"))
			end if
			rs.close
			sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
			sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	COD_ALUNO = " & intCodAluno
			sql = sql & " order by ano_letivo, semestre, serie "
			rs.open sql, cnn
			if not rs.eof then	%>
			<div align="center"><strong>Estudos Realizados </strong></div>
			<div class="table-responsive-lg">
				<table class="table table-bordered table-hover m-0">
					<thead class="thead-themed">
					  <tr>
						<th><strong>Cód.</strong></th>
						<th><strong>Ano</strong></th>
						<th><strong>Semestre</strong></th>
						<th><strong>Escola</strong></th>
						<th><strong>Curso</strong></th>
						<th><strong>Per&iacute;odo/S&eacute;rie</strong></th>
						<th><strong>Mostrar relat&oacute;rio</strong></th>
						<th><strong>Ação</strong></th>
					  </tr>
					</thead>
					<tbody>
                <%
				while not rs.eof 
					%>
					 <tr <%if trim(codHistoricoEscolar) = trim(rs("codigo")) then %>  bgcolor="#e8fbec" <%end if%>>
						<td><%=rs("CODIGO")%></td>
						<td><%=rs("ano_letivo")%></td>
						<td><%=trim(rs("semestre"))%></td>
						<td><%=trim(rs("escola"))%></td>
						<td><%=trim(rs("curso"))%></td>
						<td><%=trim(rs("serie"))%></td>
						<td align="center">&nbsp;<input <%if trim(rs("mostrar_historico_rel")) = "S" then response.write "checked"%> name="mostrar_historico_rel" type="checkbox" value="S" onClick="salvaMostrarRel(this.checked,'<%=rs("CODIGO")%>')"></td>
						<td>
						<button onClick="return resultadoConsulta('<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Editar</button>
						&nbsp;<button onClick="return excluirHistorico('<%=rs("CODIGO")%>')"  type="button" class="btn btn-outline-danger btn-sm">Excluir</button>
						</td>
					</tr>
					<%
				
					rs.movenext
				wend
				%>
              </table>
				<%
			end if
			rs.close
			%>	
			<div id="card_obs" class="card border">
				<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_obs > .card-card_obs" aria-expanded="true">
						<span class="collapsed-hidden"><strong>Observação Geral&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
						<span class="collapsed-reveal"><strong>Observação Geral&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
				</div>
				
				<div class="card-card_obs p-0 collapse show" style="">
					<!-- notice we place the padding inside another div and remove the padding from the card body -->
					<div class="p-4">
						<div class="row">	
							
							<div class="col-sm-12">	
								<div class="form-group">
									<label class="form-label">Observação para todos os anos</label>
									<textarea name="txtObservacaoGeral" cols="120" rows="4" class="form-control" id="txtObservacaoGeral"> <%=strObservacaoGeral%> </textarea>
									<br>M&aacute;ximo 2000 caracteres
								</div>
							</div>
							
						</div>								
						
					</div>
				</div>
			</div>
		
		
			<div id="card_endereco" class="card border">
				<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_endereco > .card-dados_endereco" aria-expanded="true">
						<span class="collapsed-hidden"><strong>Dados do Histórico&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
						<span class="collapsed-reveal"><strong>Dados do Histórico&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
				</div>
				
				<div class="card-dados_endereco p-0 collapse show" style="">
					<!-- notice we place the padding inside another div and remove the padding from the card body -->
					<div class="p-4">
						
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano</label>
									<input name="txtAnoHistorico" type="text" class="form-control" id="txtAnoHistorico" size="5" maxlength="4" value="<%=strAnoHistorico%>" onKeyPress="return formataCampo(this, 2, 4)" onchange='submit()'>
								</div>
							</div>	
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									<!--#include file="includes/inc_cmdSemestreHistorico.asp" -->
								</div>
							</div>	
						
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Curso</label>
									<!--#include file="includes/inc_cmdCurso.asp" -->
									<input name="txtCurso" type="hidden" class="text" id="txtCurso" size="50" maxlength="100" value="<%=strCurso%>" >
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Período/Série</label>
									<!--#include file="includes/inc_cmdPeriodo.asp" --> 
									<input name="txtSerie" type="hidden" class="text" id="txtSerie" size="15" maxlength="100" value="<%=strSerie%>" >
								</div>
							</div>
						</div>							
						<br>
						<div class="row">	
							
							<div class="col-sm-5">	
								<div class="form-group">
									<label class="form-label">Escola</label>
									<input name="txtEscola" type="text" class="form-control" id="txtEscola" size="50" maxlength="100" value="<%=strEscola%>">
								</div>
							</div>
							<div class="col-sm-3">	
								<div class="form-group">
									<label class="form-label">Cidade</label>
									<input name="txtCidade" type="text" class="form-control" id="txtCidade" size="50" maxlength="50" value="<%=strCidade%>">
								</div>
							</div>
						
							<div class="col-sm-2">	
								<div class="form-group">
									<label class="form-label">UF</label>
									<!--#include file="includes/inc_cmdUFResidencia.asp"-->
								</div>
							</div>
							
							<div class="col-sm-2">	
								<div class="form-group">
									<label class="form-label">Carga Hor&aacute;ria Total</label>
									<input name="txtCHTotal" type="text" class="form-control" id="txtCHTotal" size="5" maxlength="4" value="<%=strCHTotal%>" onKeyPress="return formataCampo(this, 2, 5)">
								</div>
							</div>
						</div>	
						<br>
						<div class="row">	
							
							<div class="col-sm-12">	
								<div class="form-group">
									<label class="form-label">Observação</label>
									<textarea name="txtObservacao" cols="120" rows="4" class="form-control" id="txtObservacao"> <%=strObservacao%> </textarea>
									<br>M&aacute;ximo 2000 caracteres
								</div>
							</div>
							
						</div>								
						
					</div>
				</div>
			</div>
		<%	
		IF codHistoricoEscolarDisciplina <> "" then
			sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA "
			sql = sql & " WHERE	CODIGO = " & codHistoricoEscolarDisciplina
			sql = sql & " AND	cod_historico_escolar = " & codHistoricoEscolar
			rs.open sql, cnn
			if not rs.eof then	
				intCodDisciplina    = Trim(Rs("cod_disciplina"))
				strSituacaoPromocao = Trim(Rs("situacao"))
				intSemestreHistorico= Trim(Rs("semestre"))
				strCH 				= Trim(Rs("carga_horaria"))
				strAnoHistorico		= Trim(Rs("ano_letivo"))
				strMedia			= ""
				intCodTurmaHistorico= Trim(Rs("cod_turma"))
				if not isnull(Rs("media")) then
					strMedia			= formatNumber(Rs("media"),1)
				end if
				strMostraNota		= rs("mostraNota")
				if isnull(strMostraNota) then strMostraNota = "S"
			end if
			rs.close	  
		  
		  END IF
		  %>
			<div id="card_dados_familiares" class="card border">
				<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_dados_familiares > .card-dados_familiares" aria-expanded="true">
						<span class="collapsed-hidden"><strong>Disciplinas do Histórico&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
						<span class="collapsed-reveal"><strong>Disciplinas do Histórico&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
				</div>
				<div class="card-dados_familiares p-0 collapse show" style="">
					<!-- notice we place the padding inside another div and remove the padding from the card body -->
					<div class="p-4">
						
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Disciplina</label>
									<!--#include file="includes/inc_cmdDisciplina.asp" -->
								</div>
							</div>	
							
							<div class="col-sm-3" style="display:none">
								<div class="form-group">
									<label class="form-label">Turma</label>
									<!--#include file="includes/inc_cmdTurmaHistorico.asp" -->
								</div>
							</div>	
							<%
							if intCodCurso <> "" and intCodPeriodo <> "" and intCodDisciplina <> "" then
								sql = "select CH_ANUAL from SCA_GRADECURRICULAR G "
								sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GradeCurricular "
								sql = sql & " inner join SCA_PERIODO P ON P.Cod_Periodo=G.Cod_Periodo "
								sql = sql & " WHERE P.Cod_Curso = " & intCodCurso 
								sql = sql & " AND P.Cod_Periodo = " & intCodPeriodo
								sql = sql & " AND GD.Cod_Disciplina = "& intCodDisciplina
								sql = sql & " order by GD.Cod_GradeCurricularDisciplina desc "				
								rs.open sql, cnn
								if not rs.eof then
									if strCH = "" then strCH = Trim(Rs("CH_ANUAL"))
								end if	
								rs.close
							end if	
							%>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Ano</label>
									<input  disabled="disabled" name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" size="5" maxlength="4" value="<%=strAnoHistorico%>" onKeyPress="return formataCampo(this, 2, 4)"  <%=strAno_Disabled%>>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									<input  disabled="disabled" name="txtSemestreHistorico" type="text" class="form-control" id="txtSemestreHistorico" size="5" maxlength="4" value="<%=intSemestreHistorico%>" onKeyPress="return formataCampo(this, 2, 4)"  <%=strSemestre_Disabled%>>
								</div>
							</div>
						</div>							
						<br>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">C.H.</label>
									<input name="txtCH" type="text" class="form-control" id="txtCH" size="5" maxlength="4" value="<%=strCH%>" onKeyPress="return formataCampo(this, 2, 5)" <%=strCH_Disabled%>>
								</div>
							</div>	
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Situação</label>
									<!--#include file="includes/inc_cmdSituacaoPromocao.asp" -->
								</div>
							</div>	
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Média</label>
									<input id="txtMedia" type="text" class="form-control" name="txtMedia" value="<%=strMedia%>" size="6" <%=strMedia_Disabled%> onKeyPress="return formataCampo(this,6,4)">
								</div>
							</div>	
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Omitir M&eacute;dia</label>
									<input <%if trim(strMostraNota) = "N" then response.Write("checked")%>  type="checkbox" name="txtMostraNota" value="N">
								</div>
							</div>	
					
						</div>							
						
					</div>
				</div>
			</div>
			<%
			pagina_anterior						= "sca_historico_escolarCon.asp?txtMatricula=" & strMatricula
			%>
			<br>
			<div class="frame-wrap">
				<!--#include file="includes/inc_botoes_cadastro.asp"-->
			</div>
					
		</div>
	</div>
	
	
	<%
	if codHistoricoEscolar<>"" then%> 

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Disciplinas Cadastradas no Histórico
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
									<th><strong>Disciplina</strong></th>
									<th><strong>Per&iacute;odo</strong></th>
									<th><strong>Ano/Sem.</strong></th>
									<th><strong>C.H.</strong></th>
									<th><strong>M&eacute;dia</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
									<th><strong>Omitir</strong></th>
									<th><strong>Ação</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								cont = 0
								sql = "SELECT H.*, D.DESC_DISCIPLINA, P.DESCRICAO AS PERIODO, H.situacao AS SITPROMOCAO, isnull(H.MOSTRANOTA,'S') as MOSTRANOTA"
								sql = sql & " FROM SCA_HISTORICO_ESCOLAR E"
								sql = sql & " inner JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA H ON H.cod_historico_escolar = E.CODIGO"
								sql = sql & " LEFT JOIN SCA_PERIODO P ON P.COD_PERIODO = E.COD_PERIODO "
								sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = H.COD_DISCIPLINA "
								sql = sql & " WHERE H.cod_historico_escolar  = " & codHistoricoEscolar
								sql = sql & " AND 	E.COD_EMPRESA  = " & Session("CodEmpresa") 
								sql = sql & " order by H.ano_letivo, H.semestre, P.DESCRICAO "
								rs.open sql, cnn
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1	
										OMITIR = ""
										if RS("MOSTRANOTA") = "N" then
											OMITIR = "Sim"
										end if
										%>
										 <tr>
											<td><%=rs("DESC_DISCIPLINA")%></td>
											<td><%=rs("PERIODO")%></td>
											<td><%=rs("ANO_LETIVO")%>/<%=rs("SEMESTRE")%></td>
											<td><%=trim(rs("CARGA_HORARIA"))%></td>
											<% 
											if not isnull(rs("MEDIA")) then
											%>	
											 <td>&nbsp;<%=round(rs("MEDIA"),1)%></td>
											<%	 
											else
											%>	
											 <td>&nbsp;----</td>
											<%	 
											end if	
											%>  
											<td><%=trim(rs("SITPROMOCAO"))%></td>
											<td><%=trim(OMITIR)%></td>
											<td>
											<button onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Editar</button>
												&nbsp;
											<button onClick="excluirDisciplina('<%=rs("CODIGO")%>')"  type="button" class="btn btn-outline-danger btn-sm">Excluir</button>
											
											</td>
										</tr>
										
										<%
										rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
									 <td colspan="7" align="center" class="celula">Nenhuma disciplina cadastrada!</td>
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
		<input type="hidden" name="txtCodAluno"  value="<%=intCodAluno%>">
		<input type="hidden" name="txtMatricula"  value="<%=strMatricula%>">
		<input type="hidden" name="codHistoricoEscolar"  value="<%=codHistoricoEscolar%>">
		<input type="hidden" name="codHistoricoEscolarDisciplina"  value="<%=codHistoricoEscolarDisciplina%>">
		<input type="hidden" name="txtExpandirHistorico" value="<%=strExpandirHistorico%>">
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>