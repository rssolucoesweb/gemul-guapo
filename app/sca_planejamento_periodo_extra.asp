<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!DOCTYPE html>
<!-- 
GEMUL 
Version: 20.1.0
Desenvolvedor: Sérgio Borges
Website: http://gemul.com.br
Contato: sergio@rssolucoesweb.com.br
-->
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            GEMUL - Matriz Curricular Disciplina
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
    </head>
    <body class="mod-bg-1 ">
	
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                <div class="page-content-wrapper">
					<%
					
					acao="I"
					strExecutarDisciplinaGrade = "S"
					strRetiraBotaolimparTela = "S"

					cod_planejamento_periodo	= Trim(Request("cod_planejamento_periodo"))
					quinzena					= Trim(Request("quinzena"))
					intCodEmpresaGrupo			= Trim(Request.form("cmbEmpresaGrupo"))
					data_expira					= Trim(Request.form("data_expira"))
					motivo						= Trim(Request.form("motivo"))
					
					if cod_planejamento_periodo <> "" then 
						sql = " select ano_letivo, mes from SCA_PLANEJAMENTO_PERIODO where cod_planejamento_periodo=" & cod_planejamento_periodo
						rs.open sql, cnn		
					
						if rs.eof = false then
							strAnoLeticoMes 	= monthName(trim(rs("mes"))) & "/" & trim(rs("ano_letivo"))
							strAnoLetivo 	= trim(rs("ano_letivo"))
							strMesLetivo 	= trim(rs("mes"))
							strDescQuinzena 	= ""
						end if
						rs.close
					end if 
					
					pagina_inicial_do_modulo = "academico.asp"
					pagina_atual = "/app/sca_planejamento_periodo_extra.asp"
					sistema = "GEMUL"
					sistema_sigla = "PLA"
					modulo = "PLA"
					
					pagina = "Liberação Extra do Planejamento - " & strAnoLeticoMes
					descricao_pagina = "Liberação extra por colaborador"
					mensagem_alerta_pagina = ""
					
					%>
					<!-- the #js-page-content id is needed for some plugins to initialize -->
					<main id="js-page-content" role="main" class="page-content">
						
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
								<div id="panel-1" class="panel">
									<div class="panel-hdr">
										<h2>
											<%=pagina%> <span class="fw-300"><i></i></span>
										</h2>
									</div>	
									<div class="panel-container show">
										<div class="panel-content">
											<%if mensagem_alerta_pagina<>"" then%>
											<div class="panel-tag">
												<%=mensagem_alerta_pagina%>
											</div>
											<%end if%>
											<form id="frm1" name="frm1" method="post">
												<input name="strConsultar" type="hidden" value="S">
												<input name="cod_planejamento_periodo" type="hidden" id="cod_planejamento_periodo" value="<%=cod_planejamento_periodo%>">
												<input name="quinzena" type="hidden" id="quinzena" value="<%=quinzena%>">
												
												<div class="row">
													<div class="col-sm-12">	
														<div class="form-group">
															<label class="form-label">Unidade</label>
															<%strEmpresaGrupo_submit="s"%>
															<!--#include file="includes/inc_cmbEmpresaGrupo.asp" -->
														</div>
													</div>	
													
												</div>	
												<br>
												<div class="row">
													<div class="col-sm-12">	
														<div class="form-group">
															<label class="form-label">Colaborador</label>
															<%strEmpresaGrupo_submit="s"%>
															<!--#include file="includes/inc_cmbColaboradorEmpresaLista.asp" -->
														</div>
													</div>	
												</div>
												<br>
												<div class="row">
													<div class="col-sm-12">	
														<div class="form-group">
															<label class="form-label">Motivo</label>
															<textarea name="motivo" cols="55" rows="3" class="form-control" id="motivo"><%=motivo%></textarea>

															
														</div>
													</div>	
												</div>
												<br>
												<div class="row">
													<div class="col-sm-4">	
														<div class="form-group">
															<label class="form-label">Liberação expira em</label>
															<input  name="data_expira" type="text" class="form-control" id="data_expira" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=data_expira%>">
														</div>
													</div>	
												</div>
												<br>
												<div class="frame-wrap">
													<!--#include file="includes/inc_botoes_cadastroPopap.asp"-->
												</div>
												
												<%if intCodEmpresaGrupo<>"0" then%>
												<div class="row">
													<div class="col-xl-12">
														<div id="panel-1" class="panel">
															<div class="panel-hdr">
																<h2>
																	Lista de liberações extras
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
																				<th><strong>Colaborador</strong></th>
																				<th><strong>Quinzena/Mês</strong></th>
																				<th><strong>Motivo</strong></th>
																				<th><strong>Situa&ccedil;&atilde;o</strong></th>
																				<th><strong>Ação</strong></th>
																			  </tr>
																			</thead>
																			<tbody>
																			<%	cont = 0
																			sql = "select l.cod_planejamento_periodo_extra, c.nome, c.codFuncional, l.quinzena, l.motivo, l.data_expira, "
																			sql = sql & " case when l.data_hora_altr is null or l.usuario_altr = 'sistema' then "
																			sql = sql & " 			l.data_hora_incl "
																			sql = sql & " else l.data_hora_altr "
																			sql = sql & " end as data_hora, "
																			sql = sql & " case when l.usuario_altr is null or l.usuario_altr = 'sistema' then "
																			sql = sql & " 			u1.USUA_NOME_COMPLETO "
																			sql = sql & " else u2.USUA_NOME_COMPLETO "
																			sql = sql & " end as usuario, "
																			sql = sql & " case when l.situacao = 'A' then 'Ativa' else 'Inativa' end as situacao, p.ano_letivo, p.mes, e.razaosocial "
																			sql = sql & " from SCA_PLANEJAMENTO_PERIODO_EXTRA l"
																			sql = sql & " inner join SRH_COLABORADOR c on c.codigo = l.cod_colaborador"
																			sql = sql & " left join SEG_EMPRESA e on e.codigo = l.cod_empresa"
																			sql = sql & " left join SEG_USUARIOS_SISTEMA u1 on u1.USUA_CODG = l.usuario_incl"
																			sql = sql & " left join SEG_USUARIOS_SISTEMA u2 on u2.USUA_CODG = l.usuario_altr"	
																			sql = sql & " left join SCA_PLANEJAMENTO_PERIODO p on p.cod_planejamento_periodo = l.cod_planejamento_periodo where 1=1"
																			sql = sql & " and l.cod_empresa = " & intCodEmpresaGrupo
																			sql = sql & " and l.quinzena = " & quinzena
																			sql = sql & " and l.cod_planejamento_periodo = " & cod_planejamento_periodo
																			sql = sql & " and YEAR(l.data_hora_incl) = " & strAnoLetivo
																			sql = sql & " order by l.data_hora_incl"
																			corLinha = "bgcolor='#CCCCCC'"

																			rs.open sql, cnn
																			if rs.eof = false then
																				while not rs.eof
																					periodo = ""
																					if not isnull(rs("mes")) then
																						periodo = ucase(MonthName(rs("mes"))) & "/" & rs("ano_letivo")
																					end if
																					if trim(rs("razaosocial")) <> trim(escola) then
																						%>
																						<tr>
																						<td class="<%=strclasse%>" colspan="7" align="center"><strong><%=rs("razaosocial")%></strong></td>
																					  </tr>
																						<%
																					end if
																					%>
																					<tr>
																						  <td><%=RS("nome")%>&nbsp;(<%=RS("codFuncional")%>)</td>
																						  <td><%=RS("quinzena")%>ª&nbsp;<%=periodo%></td>
																						  <td><%=RS("motivo")%>&nbsp;</td>
																						  <td><%=RS("situacao")%>&nbsp;</td>
																						  <td><button onClick="excluirLancamento('<%=rs("cod_planejamento_periodo_extra")%>','<%=cod_planejamento_periodo%>','<%=quinzena%>')" type="button" class="btn btn-outline-danger  btn-sm">Excluir</button>
																					  </tr>
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
												<%end if%>
											</form>
											
											
											
										</div>
											
											
										</div>
									</div>
								</div>
							</div>
						</div>
						
					</main>
				</div>
			</div>
		</div> 
		<!-- this overlay is activated only when mobile menu is triggered -->
		<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
		<script src="js/js_funcoes_gerais.js"></script>
		<script>
			function Fechar(){
				window.opener.frm1.submit();
				window.close();	
			}	
			
			function salvar(acao){
				
				var frm1 = document.getElementById("frm1");
				
				if (frm1.cmbEmpresaGrupo.value == "0"){
					alert("A Unidade deve ser selecionada!");
					frm1.cmbEmpresaGrupo.focus();
					return false;
				}
				
				if (frm1.cmdColaboradorUsuario.value == "0" || frm1.cmdColaboradorUsuario.value == "") {
					alert("O(s) Colaborador(es) deve(m) ser selecionado(s)!");
					frm1.cmdColaboradorUsuario.focus();
					return false;
				}

				if (frm1.motivo.value == "") {
					alert("O motivo deve ser informado!");
					frm1.motivo.focus();
					return false;
				}

				if (frm1.data_expira.value == "") {
					alert("A data de expiração deve ser informada!");
					frm1.data_expira.focus();
					return false;
				}

				frm1.action="sca_planejamento_periodo_extra_cod.asp?acao=I";
				frm1.submit();
				return true;
			}
			
			function excluirLancamento(cod_planejamento_periodo_extra,cod_planejamento_periodo,quizena){
				
				var frm1 = document.getElementById("frm1");
				
				frm1.action="sca_planejamento_periodo_extra_cod.asp?acao=E&cod_planejamento_periodo_extra="+cod_planejamento_periodo_extra+"&cod_planejamento_periodo="+cod_planejamento_periodo+"&quizena="+quizena;
				frm1.submit();
				return true;
			}
		</script>
	</body>
</html>		