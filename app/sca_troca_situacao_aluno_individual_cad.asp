<%
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	if trim(strMatricula) <> "" then
	
		
		sql = "Select a.Codigo, a.NomeAluno, a.matricula, cs.data_situacao as DATAFASTAMENTO, a.DATAMATRICULA, S.Desc_SituacaoAluno AS SITUACAO"
		sql = sql & " from sca_aluno A "
		sql = sql & " LEFT JOIN SCA_CONTROLE_SITUACAO_ALUNO CS ON CS.COD_ALUNO = A.CODIGO"
		sql = sql & " left join sca_situacaoaluno s on S.cod_situacaoaluno = CS.cod_situacaoaluno "
		sql = sql & " where a.matricula = " & strMatricula & " and CS.cod_empresa = " & session("codEmpresa")
		sql = sql & " order by CS.codigo desc"

		'sql = "Select top 1 a.Codigo, a.NomeAluno, a.matricula, a.DATAFASTAMENTO, a.DATAMATRICULA, at.SITUACAO"
		'sql = sql & " from sca_aluno A"
		'sql = sql & " left join sca_aluno_turma at on at.cod_aluno = a.codigo"
		'sql = sql & " left join sca_situacaoaluno s on s.cod_situacaoaluno = a.cod_situacaoaluno"
		'sql = sql & " where a.matricula = " & strMatricula
		'sql = sql & " and at.cod_empresa = " & session("codEmpresa")
		'sql = sql & " order by at.codigo desc"
		
		if ucase(session("usuarioweb")) = "SERGIO" then
		
			'response.write sql
		
		end if
		
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			
			
			strDatamatricula 	= FORMATADATAap(Trim(rs("DATAMATRICULA")))
			strSituacao			= Trim(rs("SITUACAO"))
			strSituacaoAtual			= Trim(rs("SITUACAO"))
			COR = "blue"
			if trim(strSituacao) = "TRANSFERIDO" then 
				COR = "green"
			end if
			if trim(strSituacao) <> "ATIVO" then 
				strDatafastamento 	= FORMATADATAap(Trim(rs("DATAFASTAMENTO")))
			end if
			rs.close
		else
			rs.close
			
			sql = "Select a.Codigo, a.NomeAluno, a.matricula, a.DATAMATRICULA"
			sql = sql & " from sca_aluno A "
			sql = sql & " where a.matricula = " & strMatricula 

			
			rs.open sql, cnn
			if rs.eof = false then
				strCodAluno			= Trim(rs("codigo"))
				strMatricula 		= Trim(rs("Matricula"))
				strNomealuno 		= Trim(rs("Nomealuno"))
				strDatamatricula 	= FORMATADATAap(Trim(rs("DATAMATRICULA")))
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
		end if
		
	
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if

	acao="I"
	
	if strCodAluno <> "" then
		sql = "select efetivacao, data_exc, codigo as codInscricao from mat_inscricao where cod_aluno = " & strCodAluno
		sql=sql & " order by codInscricao desc"
		rsAux.open sql, cnn
		if not rsAux.eof then
			strEfetivacao		  = rsAux("EFETIVACAO")
			data_exc		  = rsAux("data_exc")
			if not isnull(rsAux("codInscricao")) then
				if strEfetivacao = "S" then
					strBloqAltrExcl = ""
				else
					strBloqAltrExcl = "disabled"
					retira_incluir="S"
					strMensagemEfetivacao = "Aluno não está efetivado!<br>Ele deverá ser efetivado no módulo da Matrícula!"
				end if
				if not isnull(data_exc) then
					strBloqAltrExcl = "disabled"
					retira_incluir="S"
					strMensagemEfetivacao = "Matrícula do aluno foi cancelada!"
				end if
			end if			
		end if
		rsAux.close
	end if


%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_troca_situacao_aluno_individual.asp">

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
	
	<%
	IF strCodAluno <> "" then

		sql = "SELECT C.COD_ALUNO, C.COD_EMPRESA, E.RAZAOSOCIAL AS UNIDADE, C.COD_SITUACAOALUNO "
		sql = sql & " FROM SCA_CONTROLE_SITUACAO_ALUNO C"
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA "
		sql = sql & " where C.COD_ALUNO = " & strCodAluno 
		sql = sql & " AND C.COD_EMPRESA <> " & SESSION("CODEMPRESA") 
		sql = sql & " AND C.ANO_LETIVO = " & SESSION("strAnoLetivo") 
		sql = sql & " AND C.CODIGO IN ("
		sql = sql & " 				SELECT MAX(C.codigo)"
		sql = sql & " 				FROM SCA_CONTROLE_SITUACAO_ALUNO C"
		sql = sql & " 				INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA "
		sql = sql & " 				where C.COD_ALUNO = " & strCodAluno 
		sql = sql & " 				AND C.COD_EMPRESA <> " & SESSION("CODEMPRESA") 
		sql = sql & " 				AND C.ANO_LETIVO = " & SESSION("strAnoLetivo") 
		sql = sql & " 				GROUP BY  C.COD_ALUNO, C.COD_EMPRESA, E.RAZAOSOCIAL"
		sql = sql & " )"
		sql = sql & " AND C.COD_SITUACAOALUNO = 1"
		sql = sql & " order by C.codigo desc"
		rs.open sql, cnn
		if rs.eof = false then
				'if session("NivelPermissao") <> "A" then
					acao = "" 
					retira_incluir="S"
				'end if
				%>
				<div class="alert alert-danger  alert-dismissible fade show" role="alert">
					<button type="button" class="close" data-dismiss="alert" aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
					<strong>Atenção: </strong> Esse aluno já está ATIVO na unidade <%=rs("UNIDADE")%>, não poderá ser alterada a situação!
					<% if session("NivelPermissao") = "A" then %>
					<!--br><strong>Inclusão liberada somente para perfil gestor</strong-->
					<% end if %>
				</div>
				<%
		end if
		rs.close
	end if
	%>
	
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
						<input name="txtSituacaoAlunoAnterior" type="hidden" id="txtSituacaoAlunoAnterior" value="<%=strSituacaoAtual%>">
						
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
									<strong><font color="<%=COR%>"><%=strSituacaoAtual%></font></strong>&nbsp;
								</div>
							</div>
						</div>
						<% if strBloqAltrExcl = "" then %>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Trocar Situa&ccedil;&atilde;o para</label>
									<%strRetiraPre = "S"%>
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
						<% end if %>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
					</div>
					<%if strMensagemEfetivacao<>"" then%>
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
									<%=strMensagemEfetivacao%>
								</div>
							</div>
						</div>
					<%end if%>
				</div>
			</div>
		</div>
	</div>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>