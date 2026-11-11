<%
'::	Transporte > Vincula aluno a rota - REDE ESTADUAL (incluído por ste_vincula_aluno_individual_con.asp)
'::	Aluno estadual não tem cadastro no SCA: fica só em ste_solicitacao_transporte
'::	(cod_aluno NULL, codigo_escola_estadual, turno_estadual, cod_rota). Gravação por AJAX em ste_vincula_aluno_estadual_cod.asp.
'::	A lista mostra, da escola + turno escolhidos: os alunos já vinculados à rota (situação D) e as
'::	solicitações pendentes do site (situação R, sem rota), que podem ser vinculadas com um clique.

	function veSituacao(ByVal s)
		select case trim(s & "")
			case "D" : veSituacao = "Vinculado"
			case "R" : veSituacao = "Solicitado (site)"
			case else : veSituacao = trim(s & "")
		end select
	end function

	function veCpf(ByVal c)
		c = trim(c & "")
		if len(c) = 11 then veCpf = left(c, 3) & "." & mid(c, 4, 3) & "." & mid(c, 7, 3) & "-" & right(c, 2) else veCpf = c
	end function

	if rede = "E" then
	intCodEscolaEstadual = trim(Request("cmbEscolaEstadual"))
	if intCodEscolaEstadual = "" or not isnumeric(intCodEscolaEstadual) then intCodEscolaEstadual = "0"
	strTurnoEstadual = ucase(trim(Request("cmbTurnoEstadual")))
	if instr("|MATUTINO|VESPERTINO|NOTURNO|INTEGRAL|", "|" & strTurnoEstadual & "|") = 0 then strTurnoEstadual = ""
	intCodRotaEstadual = trim(Request("cmbRotaEstadual"))
	if intCodRotaEstadual = "" or not isnumeric(intCodRotaEstadual) then intCodRotaEstadual = "0"
	strNomeRotaEstadual = ""
	intQtdRotasEstadual = 0

%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-est-1" class="panel">
				<div class="panel-hdr">
					<h2>Rede estadual <span class="fw-300"><i>escola, turno e rota</i></span></h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag">
							Selecione a <strong>escola estadual</strong>, o <strong>turno</strong> e a <strong>rota</strong>. Depois, cadastre o aluno pelo CPF
							(se o CPF já tiver solicitação no ano, os dados são carregados) ou vincule as solicitações feitas pelo site, na lista abaixo.<br>
							<strong>Importante:</strong> todo aluno vinculado à rota por esta tela entra como <strong>Deferido (D)</strong>.
						</div>
						<div class="row">
							<div class="col-sm-5">
								<div class="form-group">
									<label class="form-label">Escola estadual</label>
									<select name="cmbEscolaEstadual" id="cmbEscolaEstadual" class="form-control" onchange="submit()">
										<option value="0">Selecione...</option>
									<%
									err.clear
									set rsEE = cnn.Execute("SELECT codigo_escola_estadual, nome FROM ste_escola_estadual ORDER BY nome")
									if err.number <> 0 then response.write "<option value=""0"">ERRO: " & server.htmlEncode(err.description) & "</option>" : err.clear
									do while not rsEE.eof
										strSel = ""
										if cstr(intCodEscolaEstadual) = cstr(rsEE("codigo_escola_estadual")) then strSel = " selected"
										response.write "<option value=""" & rsEE("codigo_escola_estadual") & """" & strSel & ">" & server.htmlEncode(trim(rsEE("nome") & "")) & "</option>" & vbcrlf
										rsEE.movenext
									loop
									rsEE.close
									%>
									</select>
									<small class="form-text text-muted">Escola que falta na lista: Transporte &gt; Cadastro &gt; Escola estadual.</small>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Turno</label>
									<select name="cmbTurnoEstadual" id="cmbTurnoEstadual" class="form-control" onchange="submit()">
										<option value="">Selecione...</option>
										<%for each t in array("MATUTINO", "VESPERTINO", "NOTURNO", "INTEGRAL")%>
										<option value="<%=t%>"<%if strTurnoEstadual = t then response.write " selected"%>><%=t%></option>
										<%next%>
									</select>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Rota</label>
									<select name="cmbRotaEstadual" id="cmbRotaEstadual" class="form-control" onchange="submit()">
										<option value="0">Selecione...</option>
									<%
									if intCodEscolaEstadual <> "0" then
										'rotas cujo setor está vinculado à escola estadual (ou rota sem setor nenhum)
										sql = "SELECT DISTINCT R.Cod_Rota, R.Descricao FROM ste_rota R"
										sql = sql & " LEFT JOIN STE_ROTA_VINCULA_SETORES VS ON VS.cod_rota = R.Cod_Rota"
										sql = sql & " LEFT JOIN STE_ROTA_VINCULA_UNIDADE_SETORES RV ON RV.Cod_setores = VS.Cod_setores"
										sql = sql & " WHERE RV.codigo_escola_estadual = " & clng(intCodEscolaEstadual) & " OR VS.cod_rota IS NULL"
										sql = sql & " ORDER BY R.Descricao"
										set rsEE = cnn.Execute(sql)
										do while not rsEE.eof
											intQtdRotasEstadual = intQtdRotasEstadual + 1
											strSel = ""
											if cstr(intCodRotaEstadual) = cstr(rsEE("Cod_Rota")) then strSel = " selected" : strNomeRotaEstadual = trim(rsEE("Descricao") & "")
											response.write "<option value=""" & rsEE("Cod_Rota") & """" & strSel & ">" & server.htmlEncode(trim(rsEE("Descricao") & "")) & "</option>" & vbcrlf
											rsEE.movenext
										loop
										rsEE.close
									end if
									if strNomeRotaEstadual = "" then intCodRotaEstadual = "0"
									%>
									</select>
									<%if intCodEscolaEstadual <> "0" and intQtdRotasEstadual = 0 then%>
									<small class="form-text text-danger">Nenhuma rota vinculada a esta escola. Vincule a escola ao setor de uma rota.</small>
									<%end if%>
								</div>
							</div>
						</div>
						<div class="frame-wrap">
							<button onClick="window.location='ste_vincula_aluno_individualCon.asp?rede=E'" type="button" class="btn btn-outline-warning">Limpar tela</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<%
	strFaltaEst = ""
	if intCodEscolaEstadual = "0" then strFaltaEst = strFaltaEst & ", <strong>Escola estadual</strong>"
	if strTurnoEstadual = "" then strFaltaEst = strFaltaEst & ", <strong>Turno</strong>"
	if intCodRotaEstadual = "0" then strFaltaEst = strFaltaEst & ", <strong>Rota</strong>"
	if strFaltaEst <> "" then
%>
	<div class="alert alert-info">
		<strong>Atenção:</strong> para cadastrar e listar os alunos estaduais, selecione: <%=mid(strFaltaEst, 3)%>.
	</div>
<%
	else
%>
	<input type="hidden" id="txtNomeRotaEstadual" value="<%=server.htmlEncode(strNomeRotaEstadual)%>">
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-est-2" class="panel">
				<div class="panel-hdr">
					<h2>Cadastrar aluno estadual <span class="fw-300"><i>e vincular à rota <%=server.htmlEncode(strNomeRotaEstadual)%></i></span></h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<input type="hidden" id="txtCodSolicitacaoEst" name="txtCodSolicitacaoEst" value="">
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> CPF do aluno</label>
									<div class="input-group">
										<input type="text" id="txtCpfEst" name="txtCpfEst" class="form-control" maxlength="14" placeholder="000.000.000-00" onkeyup="veMascaraCpf(this)" onkeydown="if (event.keyCode == 13) { veBuscarCpf(); return false; }">
										<div class="input-group-append">
											<button type="button" class="btn btn-primary" onclick="veBuscarCpf()" title="Buscar CPF"><i class="fal fa-search"></i></button>
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-9">
								<div id="veAvisoCpf" class="mt-4"></div>
							</div>
						</div>
						<fieldset id="veCampos" disabled>
						<h5 class="mt-2">Dados pessoais do aluno</h5>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Nome do aluno</label>
									<input type="text" id="txtNomeEst" name="txtNomeEst" class="form-control" maxlength="100">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Data de nascimento</label>
									<input type="text" id="txtNascimentoEst" name="txtNascimentoEst" class="form-control" maxlength="10" placeholder="dd/mm/aaaa" onkeyup="veMascaraData(this)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Sexo</label>
									<select id="cmbSexoEst" name="cmbSexoEst" class="form-control">
										<option value="">Selecione...</option>
										<option value="M">Masculino</option>
										<option value="F">Feminino</option>
									</select>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Nome da mãe</label>
									<input type="text" id="txtMaeEst" name="txtMaeEst" class="form-control" maxlength="100">
								</div>
							</div>
						</div>
						<h5 class="mt-2">Dados de contato</h5>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Telefone de contato</label>
									<input type="text" id="txtContatoEst" name="txtContatoEst" class="form-control" maxlength="15" onkeyup="veMascaraFone(this)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Celular do responsável</label>
									<input type="text" id="txtCelularEst" name="txtCelularEst" class="form-control" maxlength="15" onkeyup="veMascaraFone(this)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Celular da mãe</label>
									<input type="text" id="txtFoneMaeEst" name="txtFoneMaeEst" class="form-control" maxlength="15" onkeyup="veMascaraFone(this)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Celular do pai</label>
									<input type="text" id="txtFonePaiEst" name="txtFonePaiEst" class="form-control" maxlength="15" onkeyup="veMascaraFone(this)">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">E-mail</label>
									<input type="email" id="txtEmailEst" name="txtEmailEst" class="form-control" maxlength="200">
								</div>
							</div>
						</div>
						<h5 class="mt-2">Dados de endereço</h5>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> CEP</label>
									<input type="text" id="txtCepEst" name="txtCepEst" class="form-control" maxlength="9" placeholder="00000-000" onkeyup="veMascaraCep(this)">
								</div>
							</div>
							<div class="col-sm-9">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Endereço</label>
									<input type="text" id="txtLogradouroEst" name="txtLogradouroEst" class="form-control" maxlength="100">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Número</label>
									<input type="text" id="txtNumeroEst" name="txtNumeroEst" class="form-control" maxlength="50">
								</div>
							</div>
							<div class="col-sm-5">
								<div class="form-group">
									<label class="form-label">Complemento</label>
									<input type="text" id="txtComplementoEst" name="txtComplementoEst" class="form-control" maxlength="100">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Bairro</label>
									<input type="text" id="txtBairroEst" name="txtBairroEst" class="form-control" maxlength="100">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> UF</label>
									<input type="text" id="txtUfEst" name="txtUfEst" class="form-control" maxlength="2" value="GO">
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Município</label>
									<input type="text" id="txtCidadeEst" name="txtCidadeEst" class="form-control" maxlength="100">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label"><span class="text-danger">*</span> Unidade consumidora (energia)</label>
									<input type="text" id="txtUnidadeConsumidoraEst" name="txtUnidadeConsumidoraEst" class="form-control" maxlength="20">
								</div>
							</div>
						</div>
						<div class="frame-wrap">
							<button type="button" id="btnGravarEst" class="btn btn-outline-success" onclick="veGravar(this)">Gravar e vincular à rota</button>
							<button type="button" class="btn btn-outline-secondary" onclick="veLimparForm()">Novo aluno</button>
						</div>
						</fieldset>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-est-3" class="panel">
				<div class="panel-hdr">
					<h2>Alunos estaduais <span class="fw-300"><i>da escola e turno escolhidos</i></span></h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag">
							<strong>Vinculado</strong>: aluno nesta rota. <strong>Solicitado (site)</strong>: pedido feito pelo site, ainda sem rota; use <strong>Vincular</strong> para colocar nesta rota.
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0" id="veTabela">
								<thead class="thead-themed">
									<tr>
										<th><strong>Aluno</strong></th>
										<th><strong>CPF</strong></th>
										<th><strong>Nascimento</strong></th>
										<th><strong>Situa&ccedil;&atilde;o</strong></th>
										<th><strong>Rota</strong></th>
										<th><strong>Comprovante</strong></th>
										<th><strong>A&ccedil;&atilde;o</strong></th>
									</tr>
								</thead>
								<tbody>
								<%
								intContEst = 0 : intContEstVinc = 0
								sql = "SELECT S.codigo, S.nome, S.cpf, S.data_nascimento, S.Situacao, S.cod_rota, R.Descricao AS rota"
								sql = sql & " FROM ste_solicitacao_transporte S LEFT JOIN ste_rota R ON R.Cod_Rota = S.cod_rota"
								sql = sql & " WHERE S.codigo_escola_estadual = " & clng(intCodEscolaEstadual)
								sql = sql & " AND S.ano_letivo = " & clng(strAnoLetivo)
								sql = sql & " AND S.turno_estadual = '" & strTurnoEstadual & "'"
								sql = sql & " AND ISNULL(S.excluido, 'N') <> 'S'"
								sql = sql & " AND ((S.Situacao = 'D' AND S.cod_rota = " & clng(intCodRotaEstadual) & ") OR (S.Situacao = 'R' AND S.cod_rota IS NULL))"
								sql = sql & " ORDER BY CASE WHEN S.Situacao = 'R' THEN 0 ELSE 1 END, S.nome"
								set rsEE = cnn.Execute(sql)
								if rsEE.eof then
								%>
									<tr id="veLinhaVazia"><td colspan="7" class="text-center">Nenhum aluno estadual vinculado ou solicitado para esta escola e turno.</td></tr>
								<%
								end if
								while not rsEE.eof
									intContEst = intContEst + 1
									blnVinc = (trim(rsEE("Situacao") & "") = "D")
									if blnVinc then intContEstVinc = intContEstVinc + 1
								%>
									<tr id="veLinha_<%=rsEE("codigo")%>"<%if blnVinc then%> class="table-success"<%end if%>>
										<td><%=server.htmlEncode(trim(rsEE("nome") & ""))%></td>
										<td><%=veCpf(rsEE("cpf"))%></td>
										<td><%if isdate(rsEE("data_nascimento")) then response.write right("0" & day(rsEE("data_nascimento")), 2) & "/" & right("0" & month(rsEE("data_nascimento")), 2) & "/" & year(rsEE("data_nascimento"))%></td>
										<td class="ve-situacao"><%=veSituacao(rsEE("Situacao"))%></td>
										<td class="ve-rota"><%=server.htmlEncode(trim(rsEE("rota") & ""))%></td>
										<td class="ve-comprovante"><%if blnVinc then%><img style="cursor:pointer" onclick="return gerarImpressaoComprovante('<%=rsEE("codigo")%>')" src="../../images/impressora_on.gif" width="26" height="26"><%end if%></td>
										<td class="ve-acao">
											<button type="button" class="btn btn-outline-info btn-sm" onclick="veEditar('<%=rsEE("codigo")%>')">Editar</button>
											<%if blnVinc then%>
											<button type="button" class="btn btn-outline-danger btn-sm" onclick="veExcluir(this, '<%=rsEE("codigo")%>')">Excluir</button>
											<%else%>
											<button type="button" class="btn btn-outline-success btn-sm" onclick="veVincular(this, '<%=rsEE("codigo")%>')">Vincular</button>
											<%end if%>
										</td>
									</tr>
								<%
									rsEE.movenext
								wend
								rsEE.close
								%>
									<tr>
										<td colspan="7"><strong><span id="veContVinculado"><%=intContEstVinc%></span> aluno(s) vinculados à rota</strong></td>
									</tr>
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
<%
	end if
%>
