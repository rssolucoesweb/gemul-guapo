<%
	
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")	
		
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	
	if intCodCurso = "" then intCodCurso = "0"
		
	acao = "A"


%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_turma_descricao.asp">
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
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
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
								
									<label class="form-label">Curso</label>
									<!--#include file="includes/inc_cmdCurso.asp"-->
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
if intCodCurso<>"0" then
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
						
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Código</strong></th>
									<th><strong>Nome da Turma</strong></th>
									<th><strong>Descri&ccedil;&atilde;o F&iacute;sica da Turma</strong></th>
									<th><strong>Capacidade</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
							cont =0
							if intSemestre = "" then intSemestre = 0
							
							sql = "SELECT T.Cod_Turma, T.nomeTurma, G.diferenciada, T.TurmaAluno, T.AnoLetivo, T.Capacidade, t.TurmaAlunoComplemento, P.DESCRICAO, TU.DESC_TURNO, c.descricao as curso "
							sql = sql & " FROM SCA_TURMA T"
							sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
							sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
							sql = sql & " LEFT JOIN SCA_CURSO C ON P.Cod_curso = C.Cod_curso "
							sql = sql & " LEFT JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO"
							sql = sql & " where T.cod_empresa = " & Session("CodEmpresa")			
							sql = sql & " and T.AnoLetivo = " & strAnoLetivo
							sql = sql & " and T.Cod_Semestre = " & intSemestre
							sql = sql & " and P.Cod_Curso = " & intCodCurso
							sql = sql & " and ISNULL(T.cod_turma_grupo,'0')=0 "
							sql = sql & " Order by T.AnoLetivo, P.sequencia, TU.DESC_TURNO, T.Nometurma"
							rs.open sql, cnn
							if rs.eof = false then
								selecionado = "checked"
								while not rs.eof

									cont = cont + 1	
					
									strPeriodo = trim(rs("DESCRICAO"))
									
									strTurmaAluno = trim(rs("TurmaAluno")) 
									
									strTurmaAluno = right(strTurmaAluno,len(strTurmaAluno)-len(strPeriodo))
									
									strTurmaAlunoComplemento = trim(rs("TurmaAlunoComplemento")) 
									diferenciada = ""
									if trim(rs("diferenciada")) = "S" then diferenciada = " <strong><font color=blue>(Matriz Diferenciada)</font></strong>"
									 %>
									 <input name="txtCodTurma_<%=trim(rs("cod_turma"))%>" type="hidden" value="<%=trim(rs("cod_turma"))%>" >
									 <tr style="cursor: pointer"  onClick="return resultadoConsulta('<%=rs("Cod_Turma")%>')">
										<td><%=trim(rs("cod_turma"))%></td>
										<td><%=trim(rs("NomeTurma"))%> <%=diferenciada%></td>
										<td><%=trim(rs("DESCRICAO"))%>&nbsp;<input name="txtTurmaAluno_<%=trim(rs("cod_turma"))%>" type="text" class="text" id="txtTurmaAluno_<%=trim(rs("cod_turma"))%>"  value="<%=strTurmaAluno%>" size="2" maxlength="2" >
										<%if trim(rs("curso")) = "EJA" then%>
										/<input name="txtTurmaAlunoComplemento_<%=trim(rs("cod_turma"))%>" type="text" class="text" id="txtTurmaAlunoComplemento_<%=trim(rs("cod_turma"))%>"  value="<%=strTurmaAlunoComplemento%>" size="2" maxlength="5" >
										<%end if%>
										</td>
										<td><input readonly name="txtCapacidade_<%=trim(rs("cod_turma"))%>" type="text" class="text" id="txtCapacidade_<%=trim(rs("cod_turma"))%>"  value="<%=rs("Capacidade")%>" size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)"></td>
									</tr>
									 <%
									 rs.movenext
								  wend
									  
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
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>