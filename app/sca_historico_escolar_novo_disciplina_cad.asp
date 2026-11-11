<%
    strExecutarSubmitCurso              = ""
    strExecutarSubmitSemestre			= ""
	strExecutarSubmitDisciplina	        = ""
	strBotaoLimparTela 					= "N"
	strBotaoVoltaTelaAnterior 			= "S"
	
	
	
	intCodEmpresa 						= Session("CodEmpresa")
	intCodAluno							= Trim(Request("txtCodAluno"))
	strMatricula						= Trim(Request("txtMatricula"))
	codHistoricoEscolar					= Trim(Request("codHistoricoEscolar"))

	strExpandirHistorico				= Trim(Request("txtExpandirHistorico"))
	strEscola							= Trim(Request("txtEscola"))
	strCidade							= Trim(Request("txtCidade"))
	strUfResidencia						= Trim(Request("cmbUFResidencia"))
	
	intCodPeriodo 						= Trim(Request("cmbPeriodo"))
	intCodCurso	            			= Trim(Request("cmbCurso"))
	
	'response.write "intCodCurso:" & intCodCurso
	
	intCodDisciplina					= Trim(Request("cmbDisciplina"))
	intCodTurmaHistorico				= Trim(Request("cmbTurmaHistorico"))
	strCH 								= Trim(Request("txtCH"))
	strMedia 							= Trim(Request("txtMedia"))
	strSituacaoPromocao 				= Trim(Request("cmbSituacaoPromocao"))
	strObservacao		   	 			= Trim(Request.Form("txtObservacao"))
	strSimouNao         				= Trim(Request("cmbSimouNao"))
	
	'bloqueia historico disciplina
	strPeriodo_Disabled = "" 
	strDisciplina_Disabled = ""  
	strAno_Disabled = "" 
	strSemestre_Disabled = "" 
	strCH_Disabled = "" 
	strSituacaoPromocao_Disabled = "" 
	strMedia_Disabled = "" 
	
	strExecutarSubmitPeriodo = "S"
	strFuncaoSitPromocao = "S"
	
	acao="I"
	
	if codHistoricoEscolar <> "" then
		sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
		sql = sql & " WHERE	CODIGO = " & codHistoricoEscolar
		'response.Write(sql)
		rs.open sql, cnn
		if not rs.eof then
			'DADOS DO HISTORICO 
			strAnoHistorico		= Trim(Rs("ano_letivo"))
			intSemestreHistorico= Trim(Rs("semestre"))
			strCurso			= Trim(Rs("curso"))
			strSerie			= Trim(Rs("serie"))
		    intCodAluno      	= Trim(rs("cod_aluno"))
			intCodCurso			= Trim(Rs("cod_curso"))
			intCodPeriodo		= Trim(Rs("cod_periodo"))
		end if
		rs.close
	end if
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_historico_escolar.asp">

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
						<%
						strMatricula = ""
						strDataNascimento = ""
						strNomeCompleto = ""
						if intSemestreHistorico = "" then intSemestreHistorico = "0"
						sql = "SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO,"
						sql = sql & " SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATACOLACAO,SCA_ALUNO.ANOCONCLUSAO,SCA_ALUNO.MAE "
						sql = sql & " FROM SCA_ALUNO "
						sql = sql & " where SCA_ALUNO.CODIGO = " & intCodAluno
						
						rs.open sql, cnn
						if not rs.eof then
							strMatricula = rs("MATRICULA")
							strDataNascimento = formatadataap(rs("DATANASCIMENTO"))
							strNomeCompleto = rs("NOMEALUNO") 
							
							%>
							<div class="table-responsive-lg">
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										<th><strong>Matr&iacute;cula:</strong></th>
										<th><strong><%=strMatricula%></strong></th>
										<th><strong>Aluno:</strong></th>
										<th><strong><%=strNomeCompleto%></strong></th>
										<th><strong>Data Nasc.:</strong></th>
										<th><strong><%=strDataNascimento%></strong></th>
									  </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
							<%
						else
						   %>
							<script>
							   alert("ATENÇÃO: O Aluno não encontrado, verifique!");
							   window.history.back();
							</script>
						   <%
						end if
						rs.close
					  %>
					 <%		
			strMediaAprovacao = 0
			
			if intCodCurso = "" then intCodCurso = 0
			if isnull(intCodCurso) then intCodCurso = 0
			if intCodCurso<>"0" then
				sql	=	"select media_aprovacao as resultado_aprovacao_final from SCA_CRITERIO_AVALIACAO"
				sql	=	sql & " where cod_curso=" & intCodCurso
				rs.open sql, cnn
				if rs.eof = false then
					strMediaAprovacao           = trim(rs("resultado_aprovacao_final"))
				end if
				rs.close
			end if
			sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
			sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	COD_ALUNO = " & intCodAluno
			sql = sql & " AND	CODIGO = " & codHistoricoEscolar
			rs.open sql, cnn
			if not rs.eof then	%>
			<div class="table-responsive-lg">
				<table class="table table-bordered table-hover m-0">
					<thead class="thead-themed">
					  <tr>
						<th><strong>Ano</strong></th>
						<th><strong>Semestre</strong></th>
						<th><strong>Escola</strong></th>
						<th><strong>Curso</strong></th>
						<th><strong>Per&iacute;odo/S&eacute;rie</strong></th>
						<th><strong>Mostrar</strong></th>
					  </tr>
					</thead>
					<tbody>
					 <tr bgcolor="#e8fbec">
						<td><%=rs("ano_letivo")%></td>
						<td><%=trim(rs("semestre"))%></td>
						<td><%=trim(rs("escola"))%></td>
						<td><%=trim(rs("curso"))%></td>
						<td><%=trim(rs("serie"))%></td>
						<td align="center">&nbsp;<%if trim(rs("mostrar_historico_rel")) = "S" then%>Sim<%else%>Não<%end if%></td>
					</tr>
              </table>
				<%
			end if
			rs.close
			
		  %>
		
			<div id="card_dados_familiares" class="card border">
				<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_dados_familiares > .card-dados_familiares" aria-expanded="true">
						<span class="collapsed-hidden"><strong>Disciplinas do Histórico&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
						<span class="collapsed-reveal"><strong>Disciplinas do Histórico&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
				</div>
				<div class="card-dados_familiares p-0 collapse show" style="">
					<!-- notice we place the padding inside another div and remove the padding from the card body -->
					<div class="p-4">
						<%
						sqlDisc = "SELECT DD.* FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA DD INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = DD.COD_DISCIPLINA"
						sqlDisc = sqlDisc & " WHERE DD.cod_historico_escolar = " & codHistoricoEscolar
						sqlDisc = sqlDisc & " order by D.DESC_DISCIPLINA"

						rsAux1.open sqlDisc, cnn
						%>
						<table class="table table-bordered" id="tblDisciplinas">
							<thead>
								<tr>
									<th>Disciplina</th>
									<th>CH</th>
									<th>Situação</th>
									<th>Média</th>
									<th>Omitir</th>
									<th>Ação</th>
								</tr>
							</thead>
							<tbody id="tbodyDisciplinas">

								<%
								do while not rsAux1.eof
								%>

								<tr data-id="<%=rsAux1("codigo")%>">
									
									<!-- DISCIPLINA -->
									<td>
										<!--#include file="includes/inc_cmdDisciplina.asp" -->
										<script>
											document.currentScript.previousElementSibling.value = "<%=rsAux1("cod_disciplina")%>";
										</script>
									</td>

									<!-- CH -->
									<td>
										<input type="text" name="txtCH" class="form-control" value="<%=rsAux1("carga_horaria")%>">
									</td>

									<!-- SITUAÇÃO -->
									<td>
										<!--#include file="includes/inc_cmdSituacaoPromocao.asp" -->
										<script>
											document.currentScript.previousElementSibling.value = "<%=rsAux1("situacao")%>";
										</script>
									</td>

									<!-- MÉDIA -->
									<td>
										<input type="text" name="txtMedia" class="form-control" value="<%=rsAux1("media")%>">
									</td>

									<!-- OMITIR -->
									<td align="center">
										<input type="checkbox" name="txtMostraNota" value="N"
										<% if rsAux1("mostraNota") = "N" then %> checked <% end if %>>
									</td>

									<!-- AÇÕES -->
									<td>
										<button type="button" class="btn btn-success btn-sm" onclick="salvarLinha(this)">Salvar</button>
										<button type="button" class="btn btn-danger btn-sm" onclick="removerLinha(this)">Excluir</button>
									</td>

								</tr>

								<%
									rsAux1.movenext
								loop

								rsAux1.close
								%>

								</tbody>
						</table>

						<button type="button"  class="btn btn-outline-warning" onclick="adicionarLinha()">+ Nova Disciplina</button>
						<button type="button"  class="btn btn-outline-success" onclick="adicionarMatriz('<%=codHistoricoEscolar%>')">+ Incluir Matriz Atual</button>
						
						
						
					</div>
				</div>
			</div>
			<%
			pagina_anterior						= "sca_historico_escolar_novoCon.asp?txtMatricula=" & strMatricula
			retira_incluir = "S"
			%>
			<br>
			<div class="frame-wrap">
				<!--#include file="includes/inc_botoes_cadastro.asp"-->
			</div>
					
		</div>
	</div>
		<input type="hidden" name="txtCodAluno"  value="<%=intCodAluno%>">
		<input type="hidden" name="txtMatricula"  value="<%=strMatricula%>">
		<input type="hidden" name="codHistoricoEscolar"  value="<%=codHistoricoEscolar%>">
		<input type="hidden" name="txtCodCurso"  value="<%=intCodCurso%>">
		<input type="hidden" name="txtCodPeriodo"  value="<%=intCodPeriodo%>">
		<input type="hidden" name="txtAnoHistorico"  value="<%=strAnoHistorico%>">
		<input type="hidden" name="txtSemestreHistorico"  value="<%=intSemestreHistorico%>">
		<input type="hidden" name="txtExpandirHistorico" value="<%=strExpandirHistorico%>">
		
		
	  <script type="text/template" id="linhaTemplate">
		<tr data-id="">
			<td><!--#include file="includes/inc_cmdDisciplina.asp" --></td>
			<td><input type="text" name="txtCH" class="form-control"></td>
			<td><!--#include file="includes/inc_cmdSituacaoPromocao.asp" --></td>
			<td><input type="text" name="txtMedia" class="form-control"></td>
			<td style="text-align:center">
				<input type="checkbox" name="txtMostraNota" value="N">
			</td>
			<td>
				<button type="button" class="btn btn-success btn-sm" onclick="salvarLinha(this)">Salvar</button>
				<button type="button" class="btn btn-danger btn-sm" onclick="removerLinha(this)">Excluir</button>
			</td>
		</tr>
		</script>
		
		<script>
		
			function adicionarLinha() {
				var template = document.getElementById("linhaTemplate").innerHTML;
				document.getElementById("tbodyDisciplinas").insertAdjacentHTML("beforeend", template);
			}


			function adicionarMatriz(id_historico) {
				if (!confirm("Deseja incluir todas disciplinas da matriz?")) return;
				
				frm.action="sca_historico_escolar_novo_disciplina_matriz_cod.asp?id_historico=" + id_historico;
				frm.submit();
				return true;
			}
			
			// EXCLUIR LINHA
			function removerLinha(btn) {
				var linha = btn.closest("tr");
				var id = linha.getAttribute("data-id");

				// Se não foi salvo ainda
				if (!id) {
					linha.remove();
					return;
				}

				if (!confirm("Deseja excluir esta disciplina?")) return;

				var xhr = new XMLHttpRequest();
				xhr.open("POST", "sca_historico_escolar_novo_disciplina_excluir_cod.asp", true);
				xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

				xhr.onreadystatechange = function () {
					if (xhr.readyState === 4) {
						if (xhr.responseText.trim() === "OK") {
							linha.remove();
						} else {
							alert("Erro ao excluir!");
						}
					}
				};

				xhr.send("id=" + id);
			}

			// SALVAR LINHA
			function salvarLinha(btn) {
				var linha = btn.closest("tr");

				var disciplina = linha.querySelector("[name='cmbDisciplina']").value;
				var ch = linha.querySelector("[name='txtCH']").value;
				var situacao = linha.querySelector("[name='cmbSituacaoPromocao']").value;
				var media = linha.querySelector("[name='txtMedia']").value;
				var omitir = linha.querySelector("[name='txtMostraNota']").checked ? "N" : "S";

				var codCurso = document.querySelector("[name='txtCodCurso']").value;
				var codPeriodo = document.querySelector("[name='txtCodPeriodo']").value;
				var anoHistorico = document.querySelector("[name='txtAnoHistorico']").value;
				var semestreHistorico = document.querySelector("[name='txtSemestreHistorico']").value;
				var codHistoricoEscolar = document.querySelector("[name='codHistoricoEscolar']").value;
				
				if (disciplina == "0"){
					alert("A disciplina não foi selecionada!")
					return false
				}
				// valida duplicidade
				if (disciplinaJaExiste(linha, disciplina)) {
					marcarDuplicadas(linha, disciplina);
					alert("Esta disciplina já foi adicionada!");
					return;
				}
				

				if (situacao == "0" || situacao ==""){
					alert("A situação não foi selecionada!")
					return false
				}
				
				var xhr = new XMLHttpRequest();
				xhr.open("POST", "sca_historico_escolar_novo_disciplina_cod.asp", true);
				xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

				xhr.onreadystatechange = function () {
					if (xhr.readyState === 4) {
						var retorno = xhr.responseText.trim();

						if (retorno.indexOf("ERRO") === -1) {
							// salva ID na linha
							linha.setAttribute("data-id", retorno);
							alert("Salvo com sucesso!");
						} else {
							alert(retorno);
						}
					}
				};

				var params =
					"codHistoricoEscolar=" + codHistoricoEscolar +
					"&codCurso=" + codCurso +
					"&codPeriodo=" + codPeriodo +
					"&anoHistorico=" + anoHistorico +
					"&semestreHistorico=" + semestreHistorico +
					"&disciplina=" + disciplina +
					"&ch=" + ch +
					"&situacao=" + situacao +
					"&media=" + media +
					"&omitir=" + omitir;

				xhr.send(params);
			}
			
			function disciplinaJaExiste(linhaAtual, disciplinaSelecionada) {
				var linhas = document.querySelectorAll("#tbodyDisciplinas tr");

				for (var i = 0; i < linhas.length; i++) {
					var linha = linhas[i];

					// ignora a própria linha
					if (linha === linhaAtual) continue;

					var select = linha.querySelector("[name='cmbDisciplina']");
					if (select && select.value === disciplinaSelecionada) {
						return true;
					}
				}
				return false;
			}
			
			function marcarDuplicadas(linhaAtual, disciplinaSelecionada) {
				var linhas = document.querySelectorAll("#tbodyDisciplinas tr");

				linhas.forEach(function(linha) {
					linha.classList.remove("linha-duplicada");
				});

				linhas.forEach(function(linha) {
					var select = linha.querySelector("[name='cmbDisciplina']");
					if (!select) return;

					if (select.value === disciplinaSelecionada) {
						linha.classList.add("linha-duplicada");
					}
				});
			}

			function destacarDuplicadas() {
				var linhas = document.querySelectorAll("#tbodyDisciplinas tr");

				// limpa todas primeiro
				linhas.forEach(l => l.classList.remove("linha-duplicada"));

				var mapa = {};

				linhas.forEach(function(linha) {
					var select = linha.querySelector("[name='cmbDisciplina']");
					if (!select) return;

					var valor = select.value;

					if (valor === "0") return;

					if (!mapa[valor]) {
						mapa[valor] = [];
					}

					mapa[valor].push(linha);
				});

				// pinta duplicadas
				for (var key in mapa) {
					if (mapa[key].length > 1) {
						mapa[key].forEach(function(linha) {
							linha.classList.add("linha-duplicada");
						});
					}
				}
			}
			
			document.addEventListener("change", function(e) {
				if (e.target && e.target.name === "cmbDisciplina") {
					destacarDuplicadas();
				}
			});
</script>
		
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>