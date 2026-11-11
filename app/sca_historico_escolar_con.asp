<%
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strSemestre 		= session("strSemestre")
	strAnoLetivo 		= session("strAnoLetivo")
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	
	if trim(strMatricula) <> "" then
	
		sql = "Select sca_aluno.Codigo, sca_aluno.NomeAluno, sca_aluno.matricula, sca_situacaoaluno.Desc_SituacaoAluno "
		sql = sql & " from sca_aluno"
		sql = sql & " left join sca_situacaoaluno on sca_situacaoaluno.Cod_SituacaoAluno = sca_aluno.cod_situacaoaluno "
		sql = sql & " where sca_aluno.matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			strSituacaoAtual	= ucase(Trim(rs("Desc_SituacaoAluno")))
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
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if

	acao="I"
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_historico_escolarCon.asp">

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
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Situa&ccedil;&atilde;o Atual</label>
									<strong><font color="blue"><%=strSituacaoAtual%></font></strong>&nbsp;
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
	if strCodAluno<>"" then%> 

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Estudos Realizados cadastrados
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
									<th><strong>Ano</strong></th>
									<th><strong>Semestre</strong></th>
									<th><strong>Escola</strong></th>
									<th><strong>Curso</strong></th>
									<th><strong>Per&iacute;odo/S&eacute;rie</strong></th>
									<th><strong>Ação</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								cont = 0
								sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
								sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
								sql = sql & " AND	COD_ALUNO = " & strCodAluno
								sql = sql & " order by ano_letivo, semestre, serie "
								rs.open sql, cnn
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1	
										%>
										 <tr>
											<td><%=rs("ano_letivo")%></td>
											<td><%=rs("semestre")%></td>
											<td><%=trim(rs("escola"))%></td>
											<td><%=trim(rs("curso"))%></td>
											<td><%=trim(rs("serie"))%></td>
											<td>
												<button onClick="return resultadoConsulta('<%=rs("CODIGO")%>','<%=strMatricula%>')" type="button" class="btn btn-outline-success btn-sm">Editar</button>
												&nbsp;
												<button onClick="return limpaHistorico('<%=rs("CODIGO")%>','<%=strCodAluno%>','<%=strMatricula%>')"  type="button" class="btn btn-outline-danger btn-sm">Excluir</button>
											</td>
										</tr>
										<%
										rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
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