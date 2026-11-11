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
	
	<form id="frm" name="frm" method="post" action="ste_transporte_acompanhamento.asp">
	<%
	cont =0
	strAnoLetivo = session("strAnoletivo")
	
	ssql = "select t.codigo, t.cod_aluno, t.cod_turma, t.turno_estadual, t.codigo_escola_estadual, t.cod_empresa, t.nome, t.obs, t.obs_dda, r.Descricao as rota, t.bairro as setor, em.RAZAOSOCIAL as escola, "
	ssql = ssql & " 	t.Situacao as cod_sit, "
	ssql = ssql & " 	case"
	ssql = ssql & " 		when t.Situacao='A' then 'Análise'"
	ssql = ssql & " 		when t.Situacao='R' then 'Cadastro de Reserva'"
	ssql = ssql & " 		when t.Situacao='S' then 'Solicitação'"
	ssql = ssql & " 		when t.Situacao='D' then '<strong><span class=""verde"">Deferido</span></strong>'"
	ssql = ssql & " 		when t.Situacao='E' then 'Encaminhado ao DDA'"
	ssql = ssql & " 		when t.Situacao='I' then '<strong><span class=""vermelho"">Indeferido</span></strong>'"
	ssql = ssql & " 		when t.Situacao='T' then 'Devolvido ao Transporte'"
	ssql = ssql & " 		end as situacao,"
	ssql = ssql & " 	case"
	ssql = ssql & " 		when t.Situacao_DDA='A' then 'Análise'"
	ssql = ssql & " 		when t.Situacao_DDA='R' then 'Cadastro de Reserva'"
	ssql = ssql & " 		when t.Situacao_DDA='S' then 'Solicitação'"
	ssql = ssql & " 		when t.Situacao_DDA='D' then '<strong><span class=""verde"">Deferido</span></strong>'"
	ssql = ssql & " 		when t.Situacao_DDA='E' then 'Em Análise'"
	ssql = ssql & " 		when t.Situacao_DDA='I' then '<strong><span class=""vermelho"">Indeferido</span></strong>'"
	ssql = ssql & " 		when t.Situacao_DDA='T' then '<strong>Devolvido ao Transporte</strong>'"
	ssql = ssql & " 		when t.Situacao='E' and t.Situacao_DDA is null then 'Em Análise'"
	ssql = ssql & " 		end as situacaoDDA,"
	ssql = ssql & " 	t.situacao_DDA as cod_sit_dda, t.cod_rota,"
	ssql = ssql & " 	t.data_hora_incl, ee.nome as escola_estadual,"
	ssql = ssql & " 	t.data_efetivacao, us.USUA_NOME_COMPLETO as usuario_efetivacao, tu.TurmaAluno, tur.desc_turno"
	ssql = ssql & " 	from ste_solicitacao_transporte t "
	ssql = ssql & " 	left join SEG_EMPRESA em on em.codigo = t.Cod_empresa "
	ssql = ssql & " 	left join ste_escola_estadual ee on ee.codigo_escola_estadual = t.codigo_escola_estadual "
	ssql = ssql & " 	left join SEG_USUARIOS_SISTEMA us on us.USUA_CODG = t.usuario_efetivacao"
	ssql = ssql & " 	left join MAT_setores se on se.descricao = t.bairro"
	ssql = ssql & " 	left join STE_ROTA r on r.Cod_rota = t.cod_rota"
	ssql = ssql & " 	left join sca_turma tu on tu.cod_turma = t.cod_turma"
	ssql = ssql & " 	left join sca_turno tur on tur.Cod_Turno = tu.Cod_Turno"
	ssql = ssql & " 	where t.ano_letivo = " & strAnoLetivo
	if strSituacao <> "0" then
		ssql = ssql & " and t.Situacao = '" & strSituacao & "'"
	end if
	if intCodSetor <> "0" then
		ssql = ssql & " and se.codigo = " & intCodSetor
	end if
	if strRede <> "0" then
		if strRede = "E" then
			ssql = ssql & " and ee.codigo_escola_estadual is not null"
			if intCodEscolaEstadual<>"0" then
				ssql = ssql & " and ee.codigo_escola_estadual = '" & intCodEscolaEstadual & "'"
			end if
		else
			ssql = ssql & " and ee.codigo_escola_estadual is null"
			if intCodEmpresa<>"0" then
				ssql = ssql & " and t.Cod_empresa = " & intCodEmpresa
			end if
		end if
	end if
	if intCodTurno <> "0" and strTurno<>"" then
		ssql = ssql & " and (tur.desc_turno = '" & strTurno & "' or t.turno_estadual = '" & strTurno & "')"
	end if
	
	ssql = ssql & " order by t.data_hora_incl	"
	if ucase(session("usuarioweb")) = "SERGIO" then
		'response.write ssql
		'response.end
	end if
	rsAux.open ssql, cnn
	
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
						<div class="panel-tag">
							<span class="fw-300">
							<div class="filtro">
								<div class="item">Ano Letivo <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" onblur="submit()"></div>
								<div class="item">Rede <!--#include file=includes/inc_cmdRede.asp--></div>
								<div <%=strMostraComboEscolaMunicipal%> class="item">Unidade <!--#include file="includes/inc_cmbEmpresas.asp" --></div>
								<div <%=strMostraComboEscolaEstadual%> class="item">Unidade <!--#include file="includes/inc_cmbEscolaEstadual.asp" --></div>
								<div class="item">Situação <%strExecutarSubmitSituacaoTransporte="S"%><!--#include file=includes/inc_cmdSituacaoTransporte.asp--></div>
								<div class="item">Setor <%strExecutarSubmitSetor="S"%><!--#include file=includes/inc_cmdSetor.asp--></div>
								<div class="item">Turno <%strExecutarSubmitTurno="S"%><!--#include file="includes/inc_cmdTurno.asp" --></div>
							</div>
							</span>
						</div>
						<%
						
						if rsAux.eof = false then
						%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Rede</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Ficha</strong></th>
									<th><strong>Setor</strong></th>
									<th><strong>Escola<br>Turma - Turno</strong></th>
									<th><strong>Data</strong></th>
									<th><strong>Situação</strong></th>
									<th><strong>DDA</strong></th>
									<th><strong>Rota</strong></th>
									<th><strong>Execução</strong></th>
									<th class="colunaMaior"><strong>Ação/Obs</strong></th>
									<th><strong>Obs. DDA</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rsAux.eof
								cont = cont + 1	
								rede = "Municipal"
								if not isnull(rsAux("codigo_escola_estadual")) then
									rede = "Estadual"
								end if
								rota = "<strong><font color='green'>---</font></strong>"
								mostraComprovante = "N"
								if not isnull(rsAux("rota")) then
									rota = "<strong><font color='blue'>" & rsAux("rota") & "</font></strong>"
									mostraComprovante = "S"
								end if
								
								'A - Análise
								'R - Cadastro de Reserva
								'S - Solicitação
								'D - Deferido
								'E - Encaminhado ao DDA'"
								'I - Indeferido
								'T - Devolvido ao Transporte
								botao = ""
								if TRIM(rsAux("cod_sit")) = "D" or TRIM(rsAux("cod_sit")) = "I" then
									'libera para cancela a situacao e volta pra cadastro de reserva
									botao = botao & "	<button onClick='cancelaSituacao(" & rsAux("codigo") & ")'  type='button' class='btn btn-outline-warning btn-sm'>Cancelar</button>"
								elseif TRIM(rsAux("cod_sit")) = "S" or TRIM(rsAux("cod_sit")) = "R" or TRIM(rsAux("cod_sit")) = "A"  or TRIM(rsAux("cod_sit")) = "E" then
								'libera para excluir o cadastro
									botao = botao & "	<button onClick='excluirCadastro(" & rsAux("codigo") & ")'  type='button' class='btn btn-outline-danger btn-sm'>Excluir</button>"
								else
									botao = ""
								end if
								%>
								  <tr>
									<td class="celula"><%=rede%></td>
									<td class="celula"><%=rsAux("nome")%></td>
									<td>
									<%IF rede = "Municipal" THEN%>	
										<img style="cursor:pointer" onclick="return gerarImpressao('<%=rsAux("cod_aluno")%>','<%=strAnoLetivo%>','<%=rsAux("cod_turma")%>','<%=rsAux("cod_empresa")%>','<%=Cod_Semestre%>')" src="../../images/impressora_on.gif" width="26" height="26">
									<%END IF%>	
									</td>
									<td class="celula"><%=rsAux("setor")%></td>
									<%IF rede = "Municipal" THEN%>
									<td class="celula"><%=rsAux("escola")%><br><%=rsAux("TurmaAluno")%> - <%=rsAux("desc_turno")%></td>
									<%else%>
									<td class="celula"><%=rsAux("escola_estadual")%> - <%=rsAux("turno_estadual")%></td>
									<%end if%>
									<td class="celula"><%=formatadataAP(rsAux("data_hora_incl"))%></td>
									<td class="celula"><%=rsAux("situacao")%><br><span class="fonteCodigo"><%=rsAux("codigo")%></span>
									
									<%if mostraComprovante = "S" then%><img style="cursor:pointer" onclick="return gerarImpressaoComprovante('<%=rsAux("codigo")%>')" src="../../images/impressora_on.gif" width="26" height="26"><%end if%>
										
									</td>
									<td class="celula"><%=rsAux("situacaoDDA")%></td>
									<td class="celula"><%=rota%></td>
									<td class="celula"><%=rsAux("usuario_efetivacao")%><br><%=rsAux("data_efetivacao")%></td>
									<td height="20" class="celula">
										<%
										
										if (rsAux("cod_sit")="D" or rsAux("cod_sit")="R") and rede = "Estadual" then
											%>
											<br>
											<button onClick="return abreModalAlteracao('<%=rsAux("CODIGO")%>')" type="button" class="btn btn-outline-primary btn-sm">Alterar</button>
											<%
										end if
										
										if rsAux("cod_sit_dda")="I" or rsAux("cod_sit_dda")="D" or rsAux("cod_sit")="I" or rsAux("cod_sit")="D" then
											response.write rsAux("obs")
										else
											if rsAux("cod_sit_dda")="T" then
												response.write rsAux("obs")
												%>
												<br>
												<button onClick="return abreModalEncaminhamento('<%=rsAux("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Encaminhamento</button>
												<%
											else
												if rsAux("cod_sit")="S" or rsAux("cod_sit")="R" or rsAux("cod_sit")="A" or rsAux("cod_sit")="E" then
												%>
												<button onClick="return abreModalEncaminhamento('<%=rsAux("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Encaminhamento</button>
												<%
												else
													response.write rsAux("obs")
												end if
											end if
										end if
										
										%>
										<%=botao%>
									</td>
									<td class="celula"><%=rsAux("obs_DDA")%></td>
								  </tr>
								  <%				
								rsAux.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="7" class="celula">Total Registros : <%=cont%></td>
									</tr>
								</tbody>
							</table>
						</div>
						<%
						else
						%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Nome</strong></th>
									<th><strong>Rota</strong></th>
									<th><strong>Setor</strong></th>
									<th><strong>Escola</strong></th>
									<th><strong>Data</strong></th>
									<th><strong>Ação</strong></th>
								  </tr>
								</thead>
								<tbody>
									<tr>
										<td height="21" colspan="6" class="celula">Não foi encontrado registros com essa situação!</td>
									</tr>
								</tbody>
							</table>
						</div>
						<%
						
						end if
						rsAux.close
						  
						%>
					</div>
				</div>
			</div>
		</div>
	</div> 
	
	
	<div class="modal fade" id="modalEncaminhamento" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Encaminhamento da solicitação</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true"><i class="fal fa-times"></i></span>
					</button>
				</div>
				
				<div class="modal-body">
					<div id="divListaSolicitacao"></div>	
				</div>	
				
			</div>
		</div>

	</div>
	
	
	<div class="modal fade" id="modalAlteracao" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Alteração da solicitação</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true"><i class="fal fa-times"></i></span>
					</button>
				</div>
				
				<div class="modal-body">
					<div id="divListaAlteracao"></div>	
				</div>	
				
			</div>
		</div>

	</div>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
