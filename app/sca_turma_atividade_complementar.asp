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
            GEMUL - Atividade Complementar
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
					pagina_inicial_do_modulo = "academico.asp"
					pagina_atual = "/app/sca_turma_atividade_complementar.asp"
					sistema = "GEMUL"
					sistema_sigla = "SCA"
					modulo = "SCA"
					pagina = "Atividade Complementar - Vincular"
					descricao_pagina = "Vincular Atividade Complementar na Turma"
					mensagem_alerta_pagina = ""
					
					strExecutarSubmitArea = "S"
					strRetiraBotaolimparTela = "S"
					strBotaoVincular = "S"
					strBotaoConsultar = "S"
					strDescricao = request.Form("txtDescricaoAtivCompl")

					intCodigoAreaAC = request.Form("cmbAreaAC")  
					intCodigoSubAreaAC = request.Form("cmbSubAreaAC")      

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
							<div class="col-xl-10">
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
											<form id="frm" name="frm" method="post" action="sca_turma_atividade_complementar.asp">
												<input name="strConsultar" type="hidden" value="S">
												<div class="row">
													<div class="col-sm-12">	
														<div class="form-group">
															<label class="form-label">Área</label>
															<!--#include file="includes/inc_cmbAreaAtividadeComplementar.asp"-->
														</div>
													</div>	
												</div>	
												<br>
												<div class="row">
													<div class="col-sm-12">	
														<div class="form-group">
															<label class="form-label">Área</label>
															<!--#include file="includes/inc_cmbSubAreaAtividadeComplementar.asp"-->
														</div>
													</div>	
												</div>
												<br>
												<div class="row">
													<div class="col-sm-12">	
														<div class="form-group">
															<label class="form-label">Descrição</label>
															<input type="text" class="form-control" value="<%=strDescricao%>" name="txtDescricaoAtivCompl" id="txtDescricaoAtivCompl" size="80" /></td>
														</div>
													</div>	
												</div>
												<br>
												<div class="frame-wrap">
													<!--#include file="includes/inc_botoes_cadastroPopap.asp"-->
												</div>
												
												<%
												cont =0
												sql = " select ar.descricao as area,sb.descricao as subarea, at.id, at.descricao as atividade_complementar "
												sql = sql & " from sca_atividade_complementar at "
												sql = sql & " inner join sca_atividade_complementar_subArea sb on at.subarea_id = sb.id "
												sql = sql & " inner join sca_atividade_complementar_area ar on ar.id = sb.area_id "
												if strDescricao <> "" then 
													sql = sql & " where at.descricao like '%" & trim(strDescricao) & "%'"
												end if

												if intCodigoAreaAC <> "0" and intCodigoAreaAC <> "" then
													sql = sql & " and sb.id = " & intCodigoAreaAC
													
													if intCodigoSubAreaAC <> "0" and intCodigoSubAreaAC <> "" then 
														 sql = sql & " and sb.id = " & intCodigoSubAreaAC                            
													end if
												end if   
												sql = sql & " and sb.ativo = 1 " 'ativo
												sql = sql & " order by ar.codigo,sb.codigo "
													
													
												rs.open sql, cnn
														
												if rs.eof = false then
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
																		<span class="fw-300">Para vincular selecionar abaixo as atividaees e clique no botão vincular.</span>
																	</div>
																	<div class="table-responsive-lg">
																		<table class="table table-bordered table-hover m-0">
																			<thead class="thead-themed">
																			  <tr>
																				<th><strong></strong></th>
																				<th><strong>Descri&ccedil;&atilde;o</strong></th>
																				<th><strong>Área</strong></th>
																				<th><strong>SubÁrea</strong></th>
																			  </tr>
																			</thead>
																			<tbody>
																				<%
																				while not rs.eof
																					cont = cont + 1	
																					%>
																					  <tr>
																							<td class="celula" align="center"><input type="checkbox" id="chkTipoAtivCompl" name="chkTipoAtivCompl" value="<%=rs("id")%>"></td>
																							<td class="celula">&nbsp;<%=trim(rs("atividade_complementar"))%></td>
																							<td class="celula">&nbsp;<%=trim(rs("area"))%></td>
																							<td class="celula">&nbsp;<%=trim(rs("subArea"))%></td>                            
																					   </tr>  
																					  <%				
																					rs.movenext
																				wend
																				%>
																				<tr>
																					<td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
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
												rs.close
												%>
												
											</form>	
										</div>
									</div>
								</div>
							</div>
						</div>
					</div> 
					
					
				</div>
			</div>
		</div> 
		<!-- this overlay is activated only when mobile menu is triggered -->
		<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
		<script src="js/js_funcoes_gerais.js"></script>
		<script>
			function Fechar(){
				window.close();	
			}	
						
			function vincular() {

				var form = document.forms[0];

				// pega os códigos já vinculados na tela principal
				var existentes = window.opener.document.getElementById("txtHiddenCodigoAtivCompl").value;

				var arrExistentes = [];

				if (existentes != "") {
					arrExistentes = existentes.split(",");
				}

				var arrNovos = [];

				for (var i = 0; i < form.elements.length; i++) {

					if (
						form.elements[i].type == "checkbox" &&
						form.elements[i].name == "chkTipoAtivCompl" &&
						form.elements[i].checked &&
						!form.elements[i].disabled
					) {

						var codigo = form.elements[i].value;

						// somente adiciona se ainda não existir
						if (arrExistentes.indexOf(codigo) == -1) {
							arrNovos.push(codigo);
						}
					}
				}

				if ((arrExistentes.length + arrNovos.length) > 6) {
					alert("Somente pode ser vinculado até 6 tipos de atividade complementar!");
					return false;
				}

				var resultado = existentes;

				if (resultado != "" && arrNovos.length > 0) {
					resultado += ",";
				}

				resultado += arrNovos.join(",");

				window.opener.carregaTiposAtivCompl(resultado);
				window.close();
			}
			
		</script>
	</body>
</html>		