<%
	acao = "I"
	pagina_anterior		= "sca_aluno.asp"
	strCod_empresa 		= Session("CodEmpresa")

	strAluno 			= Trim(Request.Form("txtAluno"))
	strDataNascimento 	= formatadataAP(Trim(Request.Form("txtDataNascimento")))
	strMae 				= Trim(Request.Form("txtMae"))
	strCPF 				= Trim(Request.Form("txtCPF"))
	
	consultar			= Trim(Request.Form("consultar"))
	
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></span></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>
	
	<%
	msnaluno=""
	msnnasc=""
	msnmae=""
	if consultar<>"" then
		if strAluno="" then msnaluno = "<font color='red'>nome do aluno deve ser informado</font>"
		if strDataNascimento="" then msnnasc = "<font color='red'>data de nascimento deve ser informado</font>"
		if strMae="" then msnmae = "<font color='red'>nome da mãe deve ser informado</font>"
	
		intPagina = 1
		intQtdeRegistroPorPagina = 1
		cont = 0
		
		sql = "select e.RAZAOSOCIAL as escola, a.MATRICULA, a.NOMEALUNO, aa.ANO_LETIVO, a.DATANASCIMENTO, a.MAE, a.codigo, aa.COD_EMPRESA, s.desc_situacaoaluno as situacao"
		sql = sql & " from SCA_ALUNO a"
		sql = sql & " inner join SCA_ALUNO_ANO_LETIVO aa on aa.COD_ALUNO = a.CODIGO "'and aa.ANO_LETIVO = " & session("strAnoLetivo") & " and aa.SITUACAO = 'A'"
		sql = sql & " INNER JOIN SEG_EMPRESA e on e.CODIGO = aa.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_SITUACAOALUNO s on s.cod_situacaoaluno = a.cod_situacaoaluno"
		sql = sql & " where 1=1"
		'sql = sql & " and (aa.ANO_LETIVO is null or aa.ANO_LETIVO = " & session("strAnoLetivo") & ")"
		if strCPF<>"" then
			sql = sql & " And  a.cpf = '" & trim(formataCPFbd(strCPF)) & "'"
		else
			sql = sql & " And  a.NOMEALUNO = '" & trim(strAluno) & "'"
			sql = sql & " And  a.DATANASCIMENTO = '" & formatadataBD(strDataNascimento) & "'"
			sql = sql & " And  a.mae = '" & trim(strMae) & "'"
		end if
		achou="N"
		sql = sql & " ORDER BY a.NOMEALUNO, aa.ANO_LETIVO desc, AA.CODIGO DESC"
		
		rs.open sql, cnn
		if not rs.eof then 
			achou="S"
			escola = rs("escola")
			matricula = rs("matricula")
			aluno = rs("NOMEALUNO")
			data_nascimento = formatadataAP(rs("DATANASCIMENTO"))
			mae = rs("mae")
			situacao = rs("situacao")
			ano_letivo = rs("ano_letivo")
			codigo = rs("codigo")
			cod_empresa = rs("cod_empresa")
			
			strAluno 	 = aluno	
			strDataNascimento  = data_nascimento
			strMae 		 = mae	
			
			msnaluno=""
			msnnasc=""
			msnmae=""
			if strAluno="" then msnaluno = "<font color='red'>nome do aluno deve ser informado</font>"
			if strDataNascimento="" then msnnasc = "<font color='red'>data de nascimento deve ser informado</font>"
			if strMae="" then msnmae = "<font color='red'>nome da mãe deve ser informado</font>"
		end if
		rs.close
	end if
	IF consultar <> "" and (strAluno="" or strDataNascimento="" or strMae="") and achou="N" then
		if strCPF="" then
		%>
		<div class="alert alert-danger  alert-dismissible fade show" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
			<strong>Atenção: </strong> Para incluir um novo aluno, informe o CPF ou os campos nome do aluno, data de nascimento e nome da mãe deverem ser informados! 
		</div>
		<%
		end if
	end if
	
	IF consultar <> "" and strCPF<>"" and achou="N" then
		%>
		<div class="alert alert-danger  alert-dismissible fade show" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
			<strong>Atenção: </strong> CPF não foi encontrado, informe os campos nome do aluno, data de nascimento e nome da mãe! 
		</div>
		<%
	end if
	%>
	
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
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
						<form id="frm" name="frm" method="post">
							<input name="consultar" type="hidden" id="consultar" value="S">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<div class="form-group">
								<label class="form-label">CPF do Aluno *</label>
								<input name="txtCPF" type="text" class="form-control" id="txtCPF" size="50" maxlength="50" value="<%=strCPF%>"  onKeyPress="return formataCampo(this,5,14)" onBlur="return validaCPFAluno(this)">
								<%=msncpf%>
							</div>
							
							<div class="form-group">
								<label class="form-label">ou</label>
							</div>
							
							<div class="form-group">
								<label class="form-label">Nome do Aluno *</label>
								<input name="txtAluno" type="text" class="form-control" id="txtAluno" size="50" maxlength="50" value="<%=strAluno%>"  onKeyPress="return formataCampo(this, 1, 100)">
								<%=msnaluno%>
							</div>
							
							<div class="form-group">
								<label class="form-label">Data de Nascimento *</label>
								<input name="txtDataNascimento" type="text" class="form-control" id="txtDataNascimento" value="<%=strDataNascimento%>" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" >
								<%=msnnasc%>
							</div>
							
							<div class="form-group">
								<label class="form-label">Nome da Mãe *</label>
								<input name="txtMae" type="text" class="form-control" id="txtMae" size="50" maxlength="50" value="<%=strMae%>"  onKeyPress="return formataCampo(this, 1, 100)">
								<%=msnmae%>
							</div>
							
							
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_consulta_novo.asp"-->
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	IF consultar <> "" and ((strAluno<>"" and strDataNascimento <> "" and strMae <> "") or (strCPF<>"")) then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> Novo
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">					
						
						<div class="table-responsive-lg">
							<%if achou="S" then%>
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Escola</strong></th>
									<th><strong>Matrícula</strong></th>
									<th><strong>Aluno</strong></th>
									<th><strong>Data Nasc.</strong></th>
									<th><strong>M&atilde;e</strong></th>
									<th><strong>Situação</strong></th>
									<th><strong>Incluir Aluno</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							
							
								bloq = ""
								if situacao = "ATIVO" then
									bloq = "S"
									msn="<br><font color='red' sige='-1'>Unidade " & escola & " for dirigir a unidade para solicitar a transfêrencia</font>"
								end if
								%>
								  <tr>
									<td class="celula"><%=escola%></td>
									<td height="20" class="celula"><%=matricula%></td>
									<td height="20" class="celula"><%=aluno%></td>
									<td height="20" class="celula"><%=DATA_NASCIMENTO%></td>
									<td height="20" class="celula"><%=mae%></td>
									<td height="20" class="celula"><%=situacao%> - <%=ANO_LETIVO%><%=msn%></td>
									<td height="20" class="celula">
										<%if bloq="" then%>
											<div class="input-group-append">
												<button class="btn btn-primary" type="button" id="button-addon5" onClick="return receber('<%=codigo%>','<%=COD_EMPRESA%>')" >Incluir</button>
											</div>
										<%end if%>
									</td>
								  </tr>
								
								</tbody>
							</table>
							<%
							end if
							%>
							
							<%				
							if achou = "N" then
							%>
							
							<strong>Nenhum aluno foi encontrado, verifique se a trica acima foi informada corretamente.</strong>
							<br>
							<br>
							<button class="btn btn-primary" type="button" id="button-addon5" onClick="return incluir_aluno_novo()" >Incluir Aluno Novo</button>
							<%
							end if
							
							%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> 
	<%
	end if
	
	  
	%>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>