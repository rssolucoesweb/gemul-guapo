<%
	
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitPeriodo  		= "S"
	strExecutarSubmitTurno	 		= "S"
	strExecutarSubmitTurma	 		= "S"	

	intSemestre 			= Trim(Request("cmbSemestre"))
	strSemestre 			= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	if strMatricula <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		end if
		rs.close	
	else
			strCodAluno			= ""
			strMatricula 		= ""
			strNomealuno 		= ""
	end if


	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"

	strMostraAlunos = ""
	if 	intCodCurso <> "0" then strMostraAlunos = "S"
	if 	intCodSerie <> "0" then strMostraAlunos = "S"
	if 	intCodTurno <> "0" then strMostraAlunos = "S"
	if 	intCodTurma <> "0" then strMostraAlunos = "S"

	acao = "I"
	
	strbotaoAtualizar		= "S"


%>
<!--#include file="includes/inc_verifica_fechamento_anual.asp"-->
<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_troca_situacao_aluno.asp">
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
						<%if Session("strBloqueiaFechamento") <> "S" then%>
						<div class="alert alert-warning  alert-dismissible fade show">
							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
								<span aria-hidden="true"><i class="fal fa-times"></i></span>
							</button>
							<div class="d-flex align-items-center">
								<div class="alert-icon width-8">
									<span class="icon-stack icon-stack-xl">
										<i class="base-2 icon-stack-3x color-warning -400"></i>
										<i class="base-10 text-white icon-stack-1x"></i>
										<i class="ni md-profile color-warning -800 icon-stack-2x"></i>
									</span>
								</div>
								<div class="flex-1 pl-1">
									<span class="h2">
										Aviso!
									</span>
									<br>
									O bloqueio de alocação de alunos em turmas está desativado. Dessa forma, os alunos poderão ser alocados sem a necessidade de fechamento anual das turmas.
								</div>
							</div>
						</div>
						<%end if%>				
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
						
							<div class="col-sm-6">
								<div class="form-group">
								
									<label class="form-label">Turma</label>
									<!--#include file="includes/inc_cmdTurma.asp"-->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Trocar Situa&ccedil;&atilde;o para</label>
									<!--#include file="includes/inc_cmdSituacaoAluno.asp"-->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Dt. Matr&iacute;cula</label>
									 <input name="txtDatamatricula" type="text" class="form-control" id="txtDatamatricula" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatamatricula%>" >
								</div>
							</div>
						
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Dt. Afastamento</label>
									<input name="txtDatafastamento" type="text" class="form-control" id="txtDatafastamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatafastamento%>">
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<%
			if strMostraAlunos = "S" OR strMatricula <> "" then%> 
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
									<th><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></th>
									<th><strong>Ord.</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Incompleto</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
							cont = 0				
							'seleciona os alunos da turma'					
							sql = sqlAlunoTurma(intCodTurma, "")
							'response.write "teste"
							if ucase(session("usuarioweb")) = "SERGIO" then
							
								'response.write sql
								
							end if
							
							rs.open sql, cnn
							if rs.eof = false then
								selecionado = "checked"
								while not rs.eof
									cont = cont +1
									strCodigoAluno        = rs("codigo")
									strMatricula		  = rs("MATRICULA")
									intCodSituacaoAluno	  = rs("COD_SITUACAOALUNOATUAL")
									strPendencias		  = rs("pendencias")
									if isnull(strPendencias) then 
										strPendencias = ""
									else
										strPendencias = "<a href=""sca_aluno.asp?txtCodAluno=" & strCodigoAluno & """ class=""pendencia""><button type=""button"" class=""btn btn-danger waves-effect waves-themed"" data-template=""<div class=&quot;tooltip&quot; role=&quot;tooltip&quot;><div class=&quot;tooltip-inner bg-danger-500&quot;></div></div>"" data-toggle=""tooltip"" title="""" data-original-title=""Aluno com ficha cadastral incompleta, clique para fazer o preenchimento."">Atenção!</button></a>"
									end if
									
									strBloqAltrExcl 	  = ""
									corLinha 			  = " "
									if intCodSituacaoAluno="2" then
					
										sql = "select efetivacao, codigo as codInscricao from mat_inscricao where cod_aluno = " & strCodigoAluno
										rsAux.open sql, cnn
										if not rsAux.eof then
											strEfetivacao		  = rsAux("EFETIVACAO")
											if not isnull(rsAux("codInscricao")) then
												if strEfetivacao = "S" then
													strBloqAltrExcl = ""
													corLinha = " "
												else
													strBloqAltrExcl = "disabled"
													strPendencias = "<a href=""https://gemul-guapo.com.br/gemul2015/Sistema/mat/EfetivacaoAluno_con.asp"" class=""pendencia""><button type=""button"" class=""btn btn-danger waves-effect waves-themed"" data-template=""<div class=&quot;tooltip&quot; role=&quot;tooltip&quot;><div class=&quot;tooltip-inner bg-danger-500&quot;></div></div>"" data-toggle=""tooltip"" title="""" data-original-title=""Aluno não está efetivado, clique para fazer a efetivação no módulo matrícula."">Atenção!</button></a>"
													corLinha = " bgcolor='#9BCDFF' "
												end if
											end if			
										end if
										rsAux.close
									end if
									
									LIBERADO = "N"
									IF TRIM(COD_SITUACAOALUNO) = "5" and cod_empresa = session("codEmpresa") THEN
										LIBERADO = "S"
									END IF
									IF TRIM(COD_SITUACAOALUNO) <> "5" THEN
										LIBERADO = "S"
									END IF
									sit = rs("Desc_SituacaoAluno")
									if situacaoAlunoTurma = "T" then
										sit = "TRANSFERIDO"
									end if
									
									if strPendencias <> "" then	
										LIBERADO = "N"
									end if
									mensagemAlocadoEmOutraUnidade = ""
									msn = ""
									sql = "SELECT C.COD_ALUNO, C.COD_EMPRESA, E.RAZAOSOCIAL AS UNIDADE, C.COD_SITUACAOALUNO "
									sql = sql & " FROM SCA_CONTROLE_SITUACAO_ALUNO C"
									sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA "
									sql = sql & " where C.COD_ALUNO = " & strCodigoAluno 
									sql = sql & " AND C.COD_EMPRESA <> " & SESSION("CODEMPRESA") 
									sql = sql & " AND C.ANO_LETIVO = " & SESSION("strAnoLetivo") 
									sql = sql & " AND C.CODIGO IN ("
									sql = sql & " 				SELECT MAX(C.codigo)"
									sql = sql & " 				FROM SCA_CONTROLE_SITUACAO_ALUNO C"
									sql = sql & " 				INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA "
									sql = sql & " 				where C.COD_ALUNO = " & strCodigoAluno 
									sql = sql & " 				AND C.COD_EMPRESA <> " & SESSION("CODEMPRESA") 
									sql = sql & " 				AND C.ANO_LETIVO = " & SESSION("strAnoLetivo") 
									sql = sql & " 				GROUP BY  C.COD_ALUNO, C.COD_EMPRESA, E.RAZAOSOCIAL"
									sql = sql & " )"
									sql = sql & " AND C.COD_SITUACAOALUNO = 1"
									sql = sql & " order by C.codigo desc"
									rsAux.open sql, cnn
									if rsAux.eof = false then
										LIBERADO = "N"
										mensagemAlocadoEmOutraUnidade = "Esse aluno já está ATIVO na unidade " & rsAux("UNIDADE") & ", não poderá ser alterada a situação!"
										msn = "&nbsp;&nbsp;<button type=""button"" class=""btn btn-warning waves-effect waves-themed"" data-template=""<div class=&quot;tooltip&quot; role=&quot;tooltip&quot;><div class=&quot;tooltip-inner bg-warning-500&quot;></div></div>"" data-toggle=""tooltip"" title="""" data-original-title=""" & mensagemAlocadoEmOutraUnidade & """>Ativo em outra unidade!</button>"
									end if
									rsAux.close
									
									%>
									 <tr style="cursor: pointer"  <%=corLinha%>>
										<td>
										
											<%if LIBERADO = "S" then %>
												<input type="checkbox"  <%=strBloqAltrExcl%>  id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>">
											<%end if%>
										
										</td>
										<td><%=cont%><%=situacaoAlunoTurma%></td>
										<td><%=strMatricula%></td>
										<td><%=rs("NOMEALUNO")%><%=msn%></td>
										<td>&nbsp;<%=strPendencias%></td>
										<td><%=rs("TURMAALUNO")%>&nbsp;&nbsp;<%=rs("NOMETURMA")%></td>
										<td><%=rs("Desc_SituacaoAluno")%></td>
									</tr>
									
									 <%
									 rs.movenext
								  wend
							  else
								 %>
								<tr>
									<td colspan="5" align="center"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
								</tr>
								 <%
							  end if
							  rs.close
								%>
								<tr>
									<td colspan="6">Total de Alunos:&nbsp;<%=cont%> </td>
								</tr>
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