<!--#include file="includes/inc_cursosAtendimento.asp"-->
<%
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	strTipoAtendimento	= Trim(Request("cmbTipoAtendimento"))
	if strTipoAtendimento="" then strTipoAtendimento ="0"
	
	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula, cod_situacaoaluno from sca_aluno"
		sql = sql & " where matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
		    intCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			intCodSituacaoAluno = Trim(rs("cod_situacaoaluno"))
		else
			strCodAluno			= 0
		    intCodAluno			= ""
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close	
	
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if

	acao="I"


%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_alocar_tipo_atendimento.asp">
<input type="hidden" name="txtCodSituacaoAluno" value="<%=intCodSituacaoAluno%>">
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
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Dados escolares</label>
									<strong><!--#include file="includes/inc_sqlDadosAluno.asp" --></strong>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-3">	
								<div class="form-group">
									<label class="form-label">Tipo Atendimento</label>
									<!--#include file="includes/inc_cmbTipoAtendimento.asp"-->
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
if strMatricula <> "" and strCodAluno <> "" and strCodAluno <> "0" and strTipoAtendimento<>"0" then	
%> 
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%if strTipoAtendimento = "ATC" then%>
						Turmas disponiveis para Atividade Complementar
						<%end if%>
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
									<th align="center">&nbsp;</th>
									<th><strong>Turma</strong></th>
									<th><strong>Turno</strong></th>
									<th><strong>Data Ingresso</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
							sql = "select t.Cod_Turma, t.NomeTurma, t.TurmaAluno, tu.Desc_Turno as turno, ta.data_ingresso, ta.codigo"
							sql = sql & " from sca_turma t"
							sql = sql & " inner join SCA_TURNO tu on tu.Cod_Turno = t.Cod_Turno"
							sql = sql & " left join SCA_ALUNO_TIPO_ATENDIMENTO ta on ta.cod_turma = t.cod_turma and ta.cod_aluno = " & intCodAluno
							sql = sql & " where t.anoletivo = " & Session("strAnoLetivo")
							sql = sql & " and t.Cod_periodo = " & clng(intCodPeriodoATC)	'--ATC (Guapó: período achado pela sigla do curso)
							sql = sql & " and t.Cod_Empresa = " & Session("CodEmpresa")
							sql = sql & " order by t.NomeTurma"
							rs.open sql, cnn
					
							if rs.eof = false then
								
								while not rs.eof
									
									strDataIngresso 	= formatadataAP(rs("data_ingresso"))
									strChecked = ""
									if not isnull(rs("codigo")) then
										strChecked = " checked "
									end if
									 %>
									 
									 <tr>
										<td align="center"><input name="chkTurma<%=rs("Cod_Turma")%>" type="checkbox" id="chkTurma<%=rs("Cod_Turma")%>" value="<%=rs("Cod_Turma")%>" <%=strChecked%>></td>
										<td><%=trim(rs("NomeTurma"))%>&nbsp<%=trim(rs("TurmaAluno"))%></td>
										<td><%=trim(rs("turno"))%></td>
										<td><input name="txtDataIngresso<%=rs("Cod_Turma")%>" type="text" class="text" id="txtDataIngresso<%=rs("Cod_Turma")%>" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataIngresso%>"></td>
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
							
					<br>
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