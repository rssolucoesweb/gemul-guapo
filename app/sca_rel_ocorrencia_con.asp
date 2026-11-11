<%

	strPaginaTitulo 		= "Rel_Ocorrencia_con.asp"
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	dataInicial				= Trim(Request.Form("txtDataInicial"))
	dataFinal				= Trim(Request.Form("txtDataFinal"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strMatricula 			= Trim(Request("txtMatricula"))
	strNomealuno 			= Trim(Request("txtNomealuno"))
	intCodModeloDocumento	= Trim(Request.form("cmbModeloDocumento"))

	if strMatricula <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula, dataNascimento from sca_aluno"
		sql = sql & " where  matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			strDataNascimento	= Trim(rs("dataNascimento"))
		end if
		rs.close	
	else
		strCodAluno		= ""
		strMatricula 	= ""
		strNomealuno 	= ""
	end if

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_ocorrenciaCon.asp">
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
						
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group"><strong>Matrícula do Aluno</strong></label>
									<div class="input-group">
										<input type="text" class="form-control" value="<%=strMatricula%>" name="txtMatricula" id="txtMatricula" placeholder="" aria-label="" aria-describedby="button-addon5" onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
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
									<label class="form-label">Período Inicial:</label>
									<input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=dataInicial%>">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Período Final:</label>
									 <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=DataFinal%>">
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
	
	<%
	if intCodTurma    = "" then intCodTurma="0"
	if intCodPeriodo = "" then intCodPeriodo="0"

	if intCodTurma<>"0" then%>

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
									<th><input name="chkTodos" type="checkbox" value="" onClick="return MarcaTodosAlunos(this.checked)"></th>
									<th><strong>Ordem</strong></th>
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
								  if buscaHistorico = "N" then
									'seleciona os alunos do ano e semestre corrente 			
									sql = " SELECT DISTINCT "
									sql = sql & " AD.COD_ALUNO AS CODIGO, " 
									sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
									sql = sql & " A.NOMEALUNO, "
									sql = sql & " A.MATRICULA, "
									sql = sql & " SA.DESC_SITUACAOALUNO, TC.DESCRICAO AS TIPO_CRITERIO  "
									sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD  " 
									sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
									sql = sql & " INNER JOIN SCA_TURMA TUR ON TUR.COD_TURMA = AD.COD_TURMA"
									sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
									sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AD.COD_ALUNO AND TAI.ANO_LETIVO = TUR.ANOLETIVO"
									sql = sql & " LEFT JOIN SCA_TIPO_CRITERIO TC ON TC.codigo = TAI.cod_tipo_criterio"
									sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
									'sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplina
									sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
									if intCodSituacaoAluno = "" or intCodSituacaoAluno = "0" then
									   'sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
									else
									   sql = sql & "AND SA.Cod_SituacaoAluno = " & intCodSituacaoAluno
									end if
									if strMatriculaAluno <> "" then
										sql = sql & "AND A.MATRICULA = '" & strMatriculaAluno & "'"
									end if	
									sql = sql & " ORDER BY A.NOMEALUNO "
								else			
									'seleciona os alunos pelo ano e semestres do histórico 			
									sql = " select DISTINCT A.CODIGO, HED.COD_TURMA, A.NOMEALUNO, A.MATRICULA, SA.DESC_SITUACAOALUNO , TC.DESCRICAO AS TIPO_CRITERIO "
									sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
									sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
									sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
									sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
									sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
									sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AT.COD_ALUNO AND AT.ANO_LETIVO = TAI.ANO_LETIVO"
									sql = sql & " LEFT JOIN SCA_TIPO_CRITERIO TC ON TC.codigo = TAI.cod_tipo_criterio"
									sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
									sql = sql & " AND HED.COD_TURMA = " & intCodTurma	
									sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
									sql = sql & " AND HE.SEMESTRE = " & intSemestre 
									if intCodSituacaoAluno <> "" and intCodSituacaoAluno <> "0" then
									   sql = sql & "AND SA.Cod_SituacaoAluno = " & intCodSituacaoAluno
									end if   
									if strMatriculaAluno <> "" then
										sql = sql & "AND A.MATRICULA = '" & strMatriculaAluno & "'"
									end if	
									sql = sql & " ORDER BY NOMEALUNO "
								 end if
								 rs.open sql, cnn
								cont  = 0
								'Armazena o código de todos os alunos da turma'
								strAlunosTurma=""
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1
										strCodigoAluno        = rs("codigo")
										strMatricula		  = rs("MATRICULA")
										tipo_criterio = rs("tipo_criterio")
										if not isnull(tipo_criterio) then
											tipo_criterio = "<font color='blue'>&nbsp;(" & rs("tipo_criterio") & ")</font>"
										end if
										
										%>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO")%><%=tipo_criterio%></td>
											<td><%=rs("DESC_SITUACAOALUNO")%></td>
										</tr>
										 <%
										 rs.movenext
									  wend
									  %>
									   <tr>
										<td colspan="4" align="left"><strong>Quantidade de alunos: <%=cont%></strong></td>
									  </tr>
									  <%
								  else
									 %>
									 <tr> 
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
		<input type="hidden" name="txtHiddenAlunosTurma" value="<%=strAlunosTurma%>">
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>