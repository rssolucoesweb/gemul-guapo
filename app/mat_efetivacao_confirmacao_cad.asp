<%
	Session("MatriculaInformatizada") 	=  "SIM"
		
	strRegraBolsaFamilia 	= "S"
	strBloqCampo			= "readonly"
	strClassCampo 			= "textDisabled"
	strMostraLinhaBolsa 	= "style='display:table-row'"
	
	strAlunoEncontrado		= ""
	paginaVolta				= "mat_efetivacao.asp"
	
	strCod_empresa 		= Session("CodEmpresa")
	intCodAluno			= Trim(Request("txtCodAluno"))
	IF intCodAluno = "" THEN intCodAluno = "0"
	
	sql = "SELECT m.nome as nomeAluno, M.CPF, tu.anoLetivo as ano_letivo, m.data_nascimento as dataNascimento, m.Mae, m.codigo, m.COD_TURMA, m.cod_empresa, isnull(m.bolsa_familia,'') as bolsa_familia, c.sigla, upper(t.Desc_Turno) as turno, e.CodTipoEmpresa "
	sql = sql & " FROM SCA_ALUNO a "
	sql = sql & " inner join mat_inscricao m on m.cod_aluno = a.codigo "
	sql = sql & " inner join sca_turma tu on tu.cod_turma = m.cod_turma"
	sql = sql & " inner join sca_periodo p on p.cod_periodo = m.cod_periodo and p.Matricula='S' "
	sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso "
	sql = sql & " inner join sca_turno t on t.cod_turno = m.cod_turno "
	sql = sql & " inner join seg_empresa e on e.codigo = m.cod_empresa	"	
	sql = sql & " Where m.cod_empresa = " & strCod_empresa
	sql = sql & " And 	a.CODIGO = " & intCodAluno
'if session("usuarioWeb") = "sergio" or session("usuarioWeb") = "SERGIO" then'
'	response.write sql
'	response.End()
'end if
	
	rs.open sql, cnn
	if rs.eof = false then
		strAlunoEncontrado				= "S"
		strNomealuno 					= TRIM(rs("Nomealuno"))
		strAnoLetivo 					= TRIM(rs("ano_letivo"))
		strCPFAluno 					= TRIM(rs("cpf"))
		strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
		strMae 							= TRIM(rs("Mae"))
		intCodInscricao					= TRIM(rs("codigo"))
		intCodTurma						= TRIM(rs("COD_TURMA"))
		intCodEmpresa					= TRIM(rs("cod_empresa"))
		strBolsaFamilia					= TRIM(rs("bolsa_familia"))
		strTurnoAluno					= TRIM(rs("turno"))
		if (TRIM(rs("CodTipoEmpresa")) <> "1" or strBolsaFamilia = "") and (trim(rs("sigla"))<>"EI") then
			'response.write "Ok"
			strRegraBolsaFamilia 	= "N"
				strBloqCampo 			= ""
				strClassCampo 			= "text"
				strMostraLinhaBolsa 	= "style='display:none'"
		end if
		if strTurnoAluno <> "INTEGRAL" then
			strMostraLinhaBolsa = "style='display:none'"
		end if
		strAlunoCarregado = "S"
	end if
	rs.close
	
	if strAlunoEncontrado = "" then
		%>
		<script>
			alert("Aluno não foi encontrado.");
			window.location='mat_efetivacao.asp';
		</script>
		<%
		response.End()
	end if

	'if strTurnoAluno = "INTEGRAL" then
	'	strUsuarioLiberadoParaMatricularDireto = ""
	'	sql = "SELECT CODIGO_SEG_USUARIOS_SISTEMA"
	'	sql = sql & " FROM SEG_USUARIOS_INCLUI_CADASTRO"
	'	sql = sql & " Where cod_grupo = " & Session("CodGrupo")
	'	sql = sql & " and upper(CODIGO_SEG_USUARIOS_SISTEMA) = '" & ucase(trim(session("usuarioWeb"))) & "'"
	'	rs.open sql, cnn
	'	if rs.eof = false then
	'		strUsuarioLiberadoParaMatricularDireto = ucase(trim(session("usuarioWeb")))
	'	end if 
	'	rs.close
	'
	'	if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
			%>
			<!--script>
				//alert("ATENÇÃO: Para efetivação do aluno, junte a documentação necessária e compareça na SEMECT!");
				//window.location='EfetivacaoAluno_con.asp';
			</script-->
			<%
	
	'		response.end
	'	end if	
	'end if
	

	if request.Form("txtAlunoCarregado") <> "" then
		strNomealuno 			= request.Form("txtNomealuno")
		strDatanascimento 		= request.Form("txtDatanascimento")
		strBolsaFamilia 		= request.Form("txtBolsaFamilia")
	end if
	
	msnBolsa = ""
	'verifica se o aluno esta cadastrado no bolsa
	if strRegraBolsaFamilia 	= "S" then
		'sql = "SELECT codigo_bolsa as numero "
		'sql = sql & " FROM mat_bolsa_familia "
		'sql = sql & " Where data_nascimento = '" & formatadataBD(strDatanascimento) & "'"
		'sql = sql & " And 	nome = '" & strNomealuno & "'"
		'sql = sql & " And 	codigo_bolsa = '" & strBolsaFamilia & "'"
		'rs.open sql, cnn
		'if not rs.eof then
		'	msnBolsa = "Bolsa família válida!"
		'	classBolsa = "textVerde"
		'else
		'	msnBolsa = "Bolsa família não foi encontrado na base de dados!"
		'	classBolsa = "textVermelho"
		'end if
		'rs.close
	end if
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_efetivacao_confirmacao.asp?txtCodAluno=<%=intCodAluno%>">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> Matrícula <%=Session("MatriculaInformatizadaAnoEfetivacao")%> - Confirmação e correção de dados
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
						Dados do aluno <span class="fw-300"><i></i></span>
					</h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="alert alert-danger">
							<i class="fal fa-exclamation-triangle mr-1"></i>
							<strong>Atenção:</strong> não será permitida alteração de nome durante a efetivação. O nome poderá ser apenas corrigido.
						</div>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">CPF do aluno</label>
									<input disabled name="txtCPF" type="text" class="form-control" id="txtCPF" value="<%=formatacpfAP(strCPFAluno)%>">
								</div>
							</div>
							<div class="col-sm-9">
								<div class="form-group">
									<label class="form-label">Nome completo do aluno</label>
									<input name="txtNomealuno" type="text" class="form-control" id="txtNomealuno" maxlength="50" value="<%=strNomealuno%>" onKeyPress="return formataCampo(this, 1, 50)" onBlur="submit()">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Data de nascimento do aluno</label>
									<input name="txtDatanascimento" <%=strBloqCampo%> type="text" class="form-control" id="txtDatanascimento" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=strDatanascimento%>">
								</div>
							</div>
							<div class="col-sm-9">
								<div class="form-group">
									<label class="form-label">Nome completo da mãe</label>
									<input name="txtMae" type="text" class="form-control" id="txtMae" maxlength="50" value="<%=strMae%>" onKeyPress="return formataCampo(this, 1, 50)">
								</div>
							</div>
						</div>
						<div class="row" <%=replace(strMostraLinhaBolsa, "table-row", "flex")%>>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Número da Bolsa Família</label>
									<input name="txtBolsaFamilia" type="text" class="form-control" id="txtBolsaFamilia" maxlength="11" value="<%=strBolsaFamilia%>" onKeyPress="return formataCampo(this, 2, 11)" onBlur="submit()">
									<%if msnBolsa <> "" then%><small class="<%=classBolsa%>"><%=msnBolsa%></small><%end if%>
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<button type="button" name="cmdConfirmar" id="cmdConfirmar" class="btn btn-success waves-effect waves-themed" onClick="return DadosDoAluno()"><i class="fal fa-check mr-1"></i> Confirmar dados para efetivação</button>
							<button type="button" name="cmdCancelarInscricao" id="cmdCancelarInscricao" class="btn btn-danger waves-effect waves-themed" onClick="return cancelarSolicitacao()"><i class="fal fa-times mr-1"></i> Cancelar inscrição</button>
							<button type="button" name="cmdVoltar" class="btn btn-secondary waves-effect waves-themed" onClick="window.location='mat_efetivacao.asp'"><i class="fal fa-arrow-left mr-1"></i> Voltar</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<input name="txtCodAluno" 			type="hidden" id="txtCodAluno" 			value="<%=intCodAluno%>">
	<input name="txtCPFAluno" 			type="hidden" id="txtCPFAluno" 			value="<%=strCPFAluno%>">
	<input name="txtCodigoInscricao" 	type="hidden" id="txtCodigoInscricao" 	value="<%=intCodInscricao%>">
	<input name="txtCodigoTurma" 		type="hidden" id="txtCodigoTurma" 		value="<%=intCodTurma%>">
	<input name="txtCodigoEmpresa" 		type="hidden" id="txtCodigoEmpresa" 	value="<%=intCodEmpresa%>">
	<input name="txtAnoLetivo" 			type="hidden" id="txtAnoLetivo" 		value="<%=strAnoLetivo%>">
	<input name="txtRegraBolsaFamilia" 	type="hidden" id="txtRegraBolsaFamilia" value="<%=strRegraBolsaFamilia%>">
	<input name="txtAlunoCarregado" 	type="hidden" id="txtAlunoCarregado" 	value="<%=strAlunoCarregado%>">
</form>
</main>
