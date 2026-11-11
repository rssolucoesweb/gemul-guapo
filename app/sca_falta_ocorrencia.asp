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
            GEMUL - Ocorrencias Aluno
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<script src="js/configuracoes_pagina.js"></script>
    </head>
    <body class="nav-function-top header-function-fixed" style="">
	
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                <div class="page-content-wrapper">
					<%
					pagina_inicial_do_modulo = "academico.asp"
					pagina_atual = "/app/sca_falta_ocorrencia.asp"
					sistema = "GEMUL"
					sistema_sigla = "SCA"
					modulo = "SCA"
					pagina = "Ocorrência do Aluno"
					descricao_pagina = "Cadastro/consulta ocorrência de alunos"
					mensagem_alerta_pagina = ""
					strBotaoLimparTela 		= "N"
					intCodAluno				= Trim(Request("txtCodAluno"))
					strAluno				= Trim(Request("txtAluno"))
					intCodigo	 			= Trim(Request.Form("txtCodigo"))
					acao = "I"
					
					if trim(intCodigo) <> "" then
	
						sql = "SELECT OCORRENCIA "
						sql = sql & " FROM SCA_OCORRENCIA_FALTAS"
						sql = sql & " Where COD_OCORRENCIA_FALTAS = " & intCodigo
						
						rs.open sql, cnn
						
						if rs.eof = false then
							
							strOcorrencia			= rs("OCORRENCIA")
							
							acao = "AE"

						end if 
						rs.close

					end if 
					
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
							<div class="col-xl-8">
								<div id="panel-1" class="panel">
									<div class="panel-hdr">
										<h2>
											<%=pagina%> - <%=strAluno%><span class="fw-300"><i></i></span>
										</h2>
									</div>	
									<div class="panel-container show">
										<div class="panel-content">
											<%if mensagem_alerta_pagina<>"" then%>
											<div class="panel-tag">
												<%=mensagem_alerta_pagina%>
											</div>
											<%end if%>
											<form id="frm" name="frm" method="post">
												<input name="strConsultar" type="hidden" value="S">
												<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=intCodAluno%>">
												<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							
												<div class="form-group">
													<label class="form-label">Ocorrência</label>
													<textarea name="txtOcorrencia" cols="60" rows="5" class="form-control" id="txtOcorrencia"><%=strOcorrencia%></textarea>
												</div>
												<div class="frame-wrap">
													<!--#include file="includes/inc_botoes_cadastro.asp"-->
												</div>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
						<%
						cont =0
						strCpf 		= replace(replace(strCpf,".",""),"-","")

						if intCodAluno <> "" then
							sql = "SELECT O.COD_OCORRENCIA_FALTAS, O.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, O.DATAOCORRENCIA ,O.OCORRENCIA, O.USUARIO_INCL, O.DATA_HORA_INCL"
							 sql = sql & " FROM SCA_OCORRENCIA_FALTAS O"
							 sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = O.COD_ALUNO"
							 sql = sql & " where O.cod_empresa = " & Session("CodEmpresa")			
							 sql = sql & " and O.COD_ALUNO = " & intCodAluno
							 sql = sql & " and O.ANO_LETIVO = " & SESSION("strAnoLetivo")
							 sql = sql & " and O.SEMESTRE = " & session("strSemestre")
							 sql = sql & " order by O.DATAOCORRENCIA DESC"
						
							rs.open sql, cnn
							if rs.eof = false then
											%>
						<div class="row">
							<div class="col-xl-8">
								<div id="panel-1" class="panel">
									<div class="panel-hdr">
										<h2>
											<%=pagina%> cadastrados
										</h2>
									</div>	
									
									<div class="panel-container show">
										
										<div class="panel-tag">
											<span class="fw-300">Para editar/excluir clique na linha abaixo.</span>
										</div>
										<div class="panel-content">					
											<div class="table-responsive-lg">	
												<table class="table table-bordered table-hover m-0">
													<thead class="thead-themed">
													  <tr>
														<th><strong>Ocorrência</strong></th>
														<th><strong>Usuário inclusão</strong></th>
														<th><strong>Data inclusão</strong></th>
													</thead>
													<tbody>
														<%
														while not rs.eof
															cont = cont + 1	
															%>
															  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("COD_OCORRENCIA_FALTAS")%>')">
																<td><%=trim(rs("OCORRENCIA"))%></td>
																<td><%=trim(rs("USUARIO_INCL"))%></td>
																<td><%=trim(rs("DATA_HORA_INCL"))%></td>
															  </tr>
															<%				
														rs.movenext
														wend
														%>
														<tr> 
														<td height="21" colspan="3" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
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
						end if
						%>
					</main>
				</div>
			</div>
		</div> 
		<!-- this overlay is activated only when mobile menu is triggered -->
		<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
		
		<script src="js_app/sca_falta_ocorrencia.js"></script>
	</body>
</html>		