<%
	intCodigo							= Trim(Request.Form("txtCodigo"))
	strSemestre 						= session("strSemestre")
	intSemestre 						= session("strSemestre")
	strAnoLetivo 						= session("strAnoLetivo")
	
	strCodAluno							= Trim(Request("txtCodAluno"))
	strMatricula 						= Trim(Request("txtMatricula"))
	strNomealuno 						= Trim(Request("txtNomealuno"))
	strDesabilitaIncluir				= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 				= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir				= "disabled" 'Desabilita o botão Excluir

	strAnoLetivoAlocacao 				= Trim(Request("txtAnoLetivoAlocacao"))
	strSemestreAlocacao 				= Trim(Request("cmbSemestreAlocacao"))
	strSituacaoAlocacao 				= Trim(Request("cmbSituacaoAlocacao"))

	if intCodigo <> "" then
		sql = " select " 
		sql = sql & " SCA_ALUNO_TURMA.CODIGO, "
		sql = sql & " SCA_ALUNO_TURMA.ANO_LETIVO, "
		sql = sql & " SCA_ALUNO_TURMA.SEMESTRE, "
		sql = sql & " SCA_ALUNO_TURMA.SITUACAO, "
		sql = sql & " SCA_ALUNO.MATRICULA, "
		sql = sql & " SCA_ALUNO.NOMEALUNO, "
		sql = sql & " SCA_ALUNO.CODIGO as CODIGO_ALUNO "
		sql = sql & " from SCA_ALUNO_TURMA "
		sql = sql & " inner join SCA_ALUNO ON SCA_ALUNO.CODIGO = SCA_ALUNO_TURMA.COD_ALUNO "
		sql = sql & " WHERE SCA_ALUNO_TURMA.CODIGO = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodigo				= Trim(rs("CODIGO"))
			strAnoLetivoAlocacao	= Trim(rs("ANO_LETIVO"))
			strSemestreAlocacao		= Trim(rs("SEMESTRE"))
			strSituacaoAlocacao		= Trim(rs("SITUACAO"))
			
			strCodAluno				= Trim(rs("CODIGO_ALUNO"))
			strMatricula 			= Trim(rs("MATRICULA"))
			strNomealuno 			= Trim(rs("NOMEALUNO"))

			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			
		end if
		rs.close	
		
	end if
	
	if strMatricula <> "" then
	
		sql = "SELECT TOP 1 A.CODIGO, A.MATRICULA, A.NOMEALUNO, AT.COD_TURMA AS TURMA_ATUAL, T.cod_gradecurricular, AT.COD_EMPRESA "
		sql = sql & " FROM SCA_ALUNO A "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
		sql = sql & " LEFT JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO"
		sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " WHERE A.MATRICULA = " & strMatricula 
		sql = sql & " AND AT.cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " Order BY AT.CODIGO DESC"

		rs.open sql, cnn
		
		if rs.eof = false then
			strCodAluno				= Trim(rs("CODIGO"))
			strMatricula 			= Trim(rs("Matricula"))
			strNomealuno 			= Trim(rs("Nomealuno"))
		end if
		rs.close	
		
	end if


	if session("NivelPermissao") <> "A" then
		%>
		<script>
			alert("Atenção! Procedimento não autorizado para esse perfil.");
			window.location = 'sca_gerenciar_alocacao_aluno_cad.asp';
		</script>
		<%
		response.end
    end if
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_gerenciar_alocacao_aluno.asp">

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
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input  name="txtAnoLetivoAlocacao" type="text" class="form-control" id="txtAnoLetivoAlocacao" onBlur="submit()"  value="<%=strAnoLetivoAlocacao%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									<select name="cmbSemestreAlocacao" class="form-control" id="cmbSemestreAlocacao">
										<option value="1" <%if strSemestreAlocacao = "1" then response.Write("selected") %>>1. Semestre</option>
										<option value="2" <%if strSemestreAlocacao = "2" then response.Write("selected") %>>2. Semestre</option>
										<option value="3" <%if strSemestreAlocacao = "3" then response.Write("selected") %>>Anual</option>
									</select>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Situação</label>
									<select name="cmbSituacaoAlocacao" class="form-control" id="cmbSituacaoAlocacao">
										<option value="A" <%if strSituacaoAlocacao = "A" then response.Write("selected") %>>Aloca&ccedil;&atilde;o Ativa</option>
										<option value="R" <%if strSituacaoAlocacao = "R" then response.Write("selected") %>>Remanejado</option>
									</select>
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
if strCodAluno <> "" then%>
				
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
						<%              
						mostraBotaoExcluir = "S"
						sql = " select cod_aluno from mat_inscricao where  cod_aluno = " & strCodAluno & " and isnull(efetivacao,'N') = 'N'"
						rs.open sql, cnn		
						if not rs.eof then
							mostraBotaoExcluir = "N"
						end if
						rs.close
					
						sql = " select AT.CODIGO, AT.COD_ALUNO, AT.COD_TURMA, AT.ANO_LETIVO, AT.SEMESTRE, AT.SITUACAO, AT.DATA_SITUACAO, T.NomeTurma, T.TurmaAluno " 
						sql = sql & " from SCA_ALUNO_TURMA AT "
						sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA "
						sql = sql & " where	AT.COD_EMPRESA = " & Session("CodEmpresa")  & " AND AT.COD_ALUNO = " & strCodAluno
						sql = sql & " order by AT.CODIGO DESC"
						rs.open sql, cnn		
						if not rs.eof then
							%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th align="center">&nbsp;</th>
									<th><strong>Turma</strong></th>
									<th><strong>Ano Letivo</strong></th>
									<th><strong>Semestre</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
									<th><strong>Data Aloca&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								
								<%
								id = 0
								while not rs.eof 
									strSituacao = ""
									if trim(rs("SITUACAO")) = "A" then 
										strSituacao = "ATIVA"
									end if
									
									if trim(rs("SITUACAO")) = "R" then 
										strSituacao = "REMANEJADO"
									end if
									
									if trim(rs("SITUACAO")) = "T" then 
										strSituacao = "TRANSFERIDO"
									end if

									%>
									 
									 <tr>
										<td class="celula" align="center"  style="cursor: pointer">
                            
										<%if mostraBotaoExcluir = "N" then%>
											<strong><font color="#FF0000">Aluno n&atilde;o Efetivado</font></strong>
										<%else%>
											<button <%if trim(strBotaoAlterar) = "" then%> onClick="ExcluirDisciplina('<%=rs("codigo")%>','<%=strMatricula%>')" <%else%> disabled <%end if%>  type="button" class="btn btn-outline-danger btn-sm">Excluir</button>
										<%end if%>                            
										
										</td>
										<td  style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')"><div align="left"><strong><%=rs("TurmaAluno")%>&nbsp;&nbsp;<%=rs("nometurma")%></strong></div></td>
										<td class="celula"><div align="center"><strong><strong>&nbsp;<%=rs("Ano_Letivo")%></strong></strong></div></td>
										<td class="celula"><div align="center"><strong>&nbsp;<%=rs("SEMESTRE")%></strong></div></td>
										<td class="celula"><div align="center">&nbsp;<%=strSituacao%></div></td>
										<td class="celula"><div align="center"><strong>&nbsp;</strong>&nbsp;<%=rs("DATA_SITUACAO")%></div></td>
									
									</tr>
									 <%
									 rs.movenext
								  wend
									  
							  else
								 %>
								 <tr> 
								 <td colspan="6" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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