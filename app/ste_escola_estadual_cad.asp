<%
	'::	Transporte > Cadastro > Escola estadual (tabela ste_escola_estadual)
	'::	O código é o da escola (ex.: INEP), informado pelo usuário: a tabela não tem IDENTITY.
	acao = "I"

	intCodigo		= Trim(Request.Form("txtCodigo"))
	strNome			= ""
	strEndereco		= ""
	strBairro		= ""
	strMunicipio	= "ANÁPOLIS"
	strCep			= ""
	strBusca		= Trim(Request.Form("txtBusca"))

	blnCodigoOk = false
	if eeSoDigitos(intCodigo) and len(intCodigo) <= 10 then blnCodigoOk = (cdbl(intCodigo) <= 2147483647)
	if blnCodigoOk then
		sql = "SELECT codigo_escola_estadual, nome, endereco, municipio, bairro, cep"
		sql = sql & " FROM ste_escola_estadual"
		sql = sql & " WHERE codigo_escola_estadual = " & clng(intCodigo)
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo		= rs("codigo_escola_estadual")
			strNome			= trim(rs("nome") & "")
			strEndereco		= trim(rs("endereco") & "")
			strMunicipio	= trim(rs("municipio") & "")
			strBairro		= trim(rs("bairro") & "")
			strCep			= trim(rs("cep") & "")
			acao			= "AE"
		else
			intCodigo = ""
		end if
		rs.close
	else
		intCodigo = ""
	end if

	function eeSoDigitos(ByVal s)
		dim i
		eeSoDigitos = (len(s) > 0)
		for i = 1 to len(s)
			if instr("0123456789", mid(s, i, 1)) = 0 then eeSoDigitos = false
		next
	end function

	function eeCep(ByVal c)
		c = trim(c & "")
		if len(c) = 8 then eeCep = left(c, 5) & "-" & right(c, 3) else eeCep = c
	end function
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
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
	<form id="frm" name="frm" method="post" action="ste_escola_estadual.asp">
	<div class="row">
		<div class="col-xl-8">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> <span class="fw-300"><i><%if acao = "AE" then%>alteração<%else%>nova<%end if%></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag">
							O <strong>código</strong> é o código da escola (ex.: INEP) e não pode ser alterado depois de gravado.
							Escola usada em solicitação de transporte ou vinculada a setor/rota não pode ser excluída.
						</div>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label" for="txtCodigoNovo"><span class="text-danger">*</span> Código</label>
									<%if acao = "AE" then%>
									<input type="hidden" id="txtCodigo" name="txtCodigo" value="<%=intCodigo%>">
									<input type="text" id="txtCodigoNovo" name="txtCodigoNovo" class="form-control" value="<%=intCodigo%>" readonly>
									<%else%>
									<input type="hidden" id="txtCodigo" name="txtCodigo" value="">
									<input type="text" id="txtCodigoNovo" name="txtCodigoNovo" class="form-control" value="" maxlength="10" inputmode="numeric" onkeypress="return eeSoNumero(event)">
									<%end if%>
								</div>
							</div>
							<div class="col-sm-9">
								<div class="form-group">
									<label class="form-label" for="txtNome"><span class="text-danger">*</span> Nome da escola</label>
									<input type="text" id="txtNome" name="txtNome" class="form-control" maxlength="100" value="<%=server.htmlEncode(strNome)%>">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-8">
								<div class="form-group">
									<label class="form-label" for="txtEndereco"><span class="text-danger">*</span> Endereço</label>
									<input type="text" id="txtEndereco" name="txtEndereco" class="form-control" maxlength="50" value="<%=server.htmlEncode(strEndereco)%>">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label" for="txtBairro"><span class="text-danger">*</span> Bairro</label>
									<input type="text" id="txtBairro" name="txtBairro" class="form-control" maxlength="50" value="<%=server.htmlEncode(strBairro)%>">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-8">
								<div class="form-group">
									<label class="form-label" for="txtMunicipio"><span class="text-danger">*</span> Município</label>
									<input type="text" id="txtMunicipio" name="txtMunicipio" class="form-control" maxlength="50" value="<%=server.htmlEncode(strMunicipio)%>">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label" for="txtCep"><span class="text-danger">*</span> CEP</label>
									<input type="text" id="txtCep" name="txtCep" class="form-control" maxlength="9" placeholder="00000-000" value="<%=eeCep(strCep)%>" onkeyup="eeMascaraCep(this)">
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
	cont = 0
	sql = "SELECT E.codigo_escola_estadual, E.nome, E.bairro, E.municipio, E.cep,"
	sql = sql & " (SELECT COUNT(*) FROM ste_solicitacao_transporte S WHERE S.codigo_escola_estadual = E.codigo_escola_estadual) AS qtd_solicitacoes"
	sql = sql & " FROM ste_escola_estadual E"
	if strBusca <> "" then
		sql = sql & " WHERE E.nome LIKE '%" & replace(replace(strBusca, "'", "''"), "[", "[[]") & "%'"
		if eeSoDigitos(strBusca) and len(strBusca) <= 9 then sql = sql & " OR E.codigo_escola_estadual = " & clng(strBusca)
	end if
	sql = sql & " ORDER BY E.nome"
	rs.open sql, cnn
	%>
	<div class="row">
		<div class="col-xl-8">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>
						Escolas estaduais cadastradas
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row">
							<div class="col-sm-8">
								<div class="input-group mb-3">
									<input type="text" id="txtBusca" name="txtBusca" class="form-control" placeholder="Buscar por nome ou código" value="<%=server.htmlEncode(strBusca)%>" onkeydown="if (event.keyCode == 13) { eeBuscar(); return false; }">
									<div class="input-group-append">
										<button type="button" class="btn btn-primary" onclick="eeBuscar()"><i class="fal fa-search"></i></button>
									</div>
								</div>
							</div>
						</div>
						<div class="panel-tag">
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
									<tr>
										<th><strong>C&oacute;digo</strong></th>
										<th><strong>Nome</strong></th>
										<th><strong>Bairro</strong></th>
										<th><strong>Munic&iacute;pio</strong></th>
										<th><strong>CEP</strong></th>
										<th><strong>Solicita&ccedil;&otilde;es</strong></th>
									</tr>
								</thead>
								<tbody>
								<%
								if rs.eof then
								%>
									<tr><td colspan="6" class="text-center">Nenhuma escola estadual encontrada.</td></tr>
								<%
								end if
								while not rs.eof
									cont = cont + 1
								%>
									<tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo_escola_estadual")%>')">
										<td><%=rs("codigo_escola_estadual")%></td>
										<td><%=server.htmlEncode(trim(rs("nome") & ""))%></td>
										<td><%=server.htmlEncode(trim(rs("bairro") & ""))%></td>
										<td><%=server.htmlEncode(trim(rs("municipio") & ""))%></td>
										<td><%=eeCep(rs("cep"))%></td>
										<td><%=rs("qtd_solicitacoes")%></td>
									</tr>
								<%
									rs.movenext
								wend
								rs.close
								%>
									<tr>
										<td colspan="6">Total de registros: <%=cont%></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
