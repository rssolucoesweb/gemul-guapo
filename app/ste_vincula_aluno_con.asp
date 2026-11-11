<%
	intCodEmpresaGrupo = request("cmbEmpresaGrupo")
	intCodRota = request("cmbRota")
	if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = "0"
	if intCodRota = "" then intCodRota = "0"
	
	intCodTurno = request("cmbTurno")
	if intCodTurno = "" then intCodTurno = "0"
	
	strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	
	sql = "select listar_Alunos, ano_letivo from STE_configura_alunos "
	rs.open sql, cnn
	if rs.eof = false then
		filtro = rs("listar_Alunos")
		strAnoLetivo = rs("ano_letivo")
		if rs("listar_Alunos") = "TELA_CONFIRMA_MATRICULA" then mensagem_alerta_pagina = "Serão listados aluno da renovação de matrícula do Ensino Fundamental"
		if rs("listar_Alunos") = "ALUNOS_ATIVOS" then mensagem_alerta_pagina = "Serão listados aluno ativos em turma do Ensino Fundamental"
											
	end if
	rs.close
	strEmpresaGrupo_submit = "S"
	strExecutarSubmitRotaTransporteescolar = "S"
	strExecutarSubmitTurno = "S"
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="ste_vincula_alunoCon.asp">
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
									<label class="form-label">Ano Letivo</label>
									<input readonly name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Unidade</label>
									 <!--#include file="includes/inc_cmbEmpresaGrupo.asp" -->
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Turno</label>
									 <!--#include file="includes/inc_cmdTurno.asp" -->
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Rota</label>
									 <!--#include file="includes/inc_cmdRotaUnidade.asp" -->
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

if session("usuarioWeb") = "SERGIO" THEN
	RESPONSE.WRITE intCodRota & "<hr>"
	RESPONSE.WRITE intCodEmpresaGrupo & "<hr>"
	RESPONSE.WRITE intCodTurno & "<hr>"
end if	
if intCodRota<>"0" and intCodEmpresaGrupo<>"0" and intCodTurno<>"0" then
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
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Aluno</strong></th>
									<th><strong>Ficha</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
									<th><strong>Rota Vinculada</strong></th>
									<th><strong>Comprovante</strong></th>
									<th><strong>A&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							<%
							if filtro = "ALUNOS_ATIVOS" then
								sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA,SCA_TURMA.Cod_Semestre, SCA_TURMA.cod_turno, SCA_TURMA.Cod_Turma, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva, SCA_PERIODO.sequencia "
								sql = sql & " FROM SCA_ALUNO_TURMA "
								sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
								sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma and SCA_TURMA.cod_empresa = sca_aluno.cod_empresa "
								sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO and SCA_PERIODO.cod_empresa = SCA_TURMA.cod_empresa "
								sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.Cod_CURSO"
								sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
								sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
								sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & intCodEmpresaGrupo
								sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A' "
								sql = sql & " and SCA_ALUNO_TURMA.ano_letivo = " & strAnoLetivo
								sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
								sql = sql & " and SCA_TURMA.cod_turno = " & intCodTurno
								sql = sql & " and SCA_SITUACAOALUNO.desc_SituacaoAluno = 'ATIVO'"
								sql = sql & " and SCA_CURSO.descricao not in ('EDUCAÇÃO INFANTIL')"
								sql = sql & " order by SCA_ALUNO.NOMEALUNO"
								
							elseif filtro = "TELA_CONFIRMA_MATRICULA" then
								sql = " SELECT SCA_ALUNO_RENOVACAO.CODIGO AS CODALUNOTURMA,SCA_TURMA.Cod_Semestre, SCA_TURMA.cod_turno, SCA_TURMA.Cod_Turma, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, '0' as SEQUENCIA, SCA_ALUNO_RENOVACAO.COD_TURMA, SCA_TURMA.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno "
								sql = sql & " from SCA_ALUNO_RENOVACAO"
								sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_RENOVACAO.COD_ALUNO = SCA_ALUNO.CODIGO"
								sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_RENOVACAO.COD_TURMA_RENOVACAO = SCA_TURMA.Cod_Turma "
								sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO"
								sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.Cod_CURSO"
								sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
								sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
								sql = sql & " where SCA_ALUNO_RENOVACAO.cod_empresa = " & intCodEmpresaGrupo
								sql = sql & " and SCA_TURMA.anoLetivo = " & strAnoLetivo
								sql = sql & " and SCA_TURMA.cod_turno = " & intCodTurno
								'sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
								'sql = sql & " and SCA_ALUNO_RENOVACAO.EFETIVADO = 'S' "
								sql = sql & " and SCA_SITUACAOALUNO.desc_SituacaoAluno = 'ATIVO'"
								sql = sql & " and SCA_CURSO.descricao not in ('EDUCAÇÃO INFANTIL')"
								sql = sql & " order by SCA_ALUNO.NOMEALUNO"
							end if
							'response.write filtro & "<br>"
							'response.write sql
							cont = 0
							contVinculado = 0
							if session("usuarioWeb") = "SERGIO" THEN
								RESPONSE.WRITE SQL & "<hr>"
							end if		
							rs.open sql, cnn
							
							if rs.eof = false then
							
								while not rs.eof
									strMarca  				= ""
									strRota					= ""
									strCodigoAluno        	= rs("codigo")
									Cod_Turma        	= rs("Cod_Turma")
									Cod_Semestre        	= rs("Cod_Semestre")
									strMatricula		  	= rs("MATRICULA")
									cont = cont + 1
									
									if intCodRota<>"0" and intCodRota<>"" then
										sql = "SELECT r.descricao "
										sql = sql & " FROM SCA_ROTA_VICULA_ALUNO v inner join ste_rota r on r.cod_Rota = v.cod_rota"
										sql = sql & " WHERE v.cod_aluno = " & strCodigoAluno
										sql = sql & " and v.cod_rota = " & intCodRota
										sql = sql & " and v.cod_empresa = " & intCodEmpresaGrupo
										sql = sql & " and v.ano_letivo = " & strAnoLetivo
										RsAux.open sql, cnn
										 
										if RsAux.eof = false then
											strMarca = "checked"
											strRota = RsAux("descricao")
											contVinculado = contVinculado + 1
										end if
										RsAux.close
									end if
									 %>
									 <tr>
										<td><input type="checkbox" id="chkAluno" name="chkAluno" <%=strMarca%> value="<%=rs("codigo")%>"></td>
										<td><%=strMatricula%></td>
										<td><%=trim(rs("NOMEALUNO"))%></td>
										<td>
											
										<img style="cursor:pointer" onclick="return gerarImpressao('<%=strCodigoAluno%>','<%=strAnoLetivo%>','<%=Cod_Turma%>','<%=intCodEmpresaGrupo%>','<%=Cod_Semestre%>')" src="../../images/impressora_on.gif" width="26" height="26">
						   
										</td>
										<td><%=trim(rs("TURMAALUNO"))%>&nbsp;<%=rs("NOMETURMA")%>&nbsp;<input type="hidden" id="txtTurma_<%=rs("codigo")%>" name="txtTurma_<%=rs("codigo")%>" value="<%=rs("COD_TURMA")%>"></td>
										<td><%=trim(rs("DESC_SITUACAOALUNO"))%></td>
										<td><%=strRota%></td>
										<td><%if strRota <> "" then%><img style="cursor:pointer" onclick="return gerarImpressaoComprovante('<%=strCodigoAluno%>','<%=strAnoLetivo%>','<%=Cod_Turma%>','<%=intCodEmpresaGrupo%>','<%=Cod_Semestre%>','<%=intCodRota%>')" src="../../images/impressora_on.gif" width="26" height="26"><%end if%></td>
										<td>
										<%if strMarca<>"" then%>
										<button onClick="Excluir('E','<%=strCodigoAluno%>','<%=intCodRota%>')" type="button" class="btn btn-outline-danger btn-sm">Excluir</button>
										<%end if%>
										</td>
									</tr>
									 <%
									rs.movenext
								wend
								%>
								 <tr>
									<td colspan="3"><strong><%=cont%> aluno(s) na unidade</strong></td>
									<td colspan="4"><strong><%=contVinculado%> aluno(s) viculados a rota</strong></td>
								</tr>
								 <%  
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