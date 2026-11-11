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
            GEMUL - Consulta Matriz Curricular
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
					pagina_atual = "/app/sca_matriz_curricular_con.asp"
					sistema = "GEMUL"
					modulo = "Acadêmico"
					pagina = "Consulta Matriz Curricular"
					descricao_pagina = "Consulta de Matriz Curricular"
					mensagem_alerta_pagina = ""
					
					strAnoLetivo 	= request("txtAnoLetivo")
					intSemestre 	= request("cmbSemestre")
					if intSemestre = "" then intSemestre = 0
					strSituacao 	= request("cmbSituacao")
					if strSituacao = "" then strSituacao = "A"

					if strAnoLetivo = "" then strAnoLetivo = year(date)

					strConsultar			= Trim(Request("strConsultar"))

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
											<form id="frm" name="frm" method="post">
												<input name="strConsultar" type="hidden" value="S">

												<div class="row">
													<div class="col-sm-4">
														<div class="form-group">
															<label class="form-label">Ano</label>
															<input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
														</div>
													</div>	
													<div class="col-sm-4">	
														<div class="form-group">
															<label class="form-label">Semestre</label>
															<!--#include file="includes/inc_cmdSemestre.asp"-->
														</div>
													</div>	
													<div class="col-sm-4">
														<div class="form-group">
															<label class="form-label">Situação</label>
															<select name="cmbSituacao" id="cmbSituacao" class="form-control" >
																<option <% if strSituacao = "A" then response.write "selected"%> value="A">Ativo</option>
																<option <% if strSituacao = "I" then response.write "selected"%> value="I">Inativo</option>
															</select>
														</div>
													</div>	
												</div>	
												<br>
												
												<div class="frame-wrap">
													<!--#include file="includes/inc_botoes_consultaPopap.asp"-->
												</div>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
						<%
						cont =0

						sql = "SELECT     	SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_GRADECURRICULAR.diferenciada, SCA_PERIODO.Cod_Curso, "
						sql = sql & "     	SCA_CURSO.Descricao as descCurso, SCA_GRADECURRICULAR.Cod_Periodo, SCA_PERIODO.Descricao, "
						sql = sql & " 	  	SCA_GRADECURRICULAR.AnoReferencia, SCA_GRADECURRICULAR.SemestreReferencia, SCA_GRADECURRICULAR.Situacao"
						sql = sql & " FROM  SCA_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
						sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso			"
						sql = sql & " where 1=1"
						if strAnoLetivo <> "0" and strAnoLetivo <> ""  then
							sql = sql & " and SCA_GRADECURRICULAR.AnoReferencia = " & strAnoLetivo
						end if
						if intSemestre <> "0" and intSemestre <> "" then
							sql = sql & " and SCA_GRADECURRICULAR.SemestreReferencia = " & intSemestre
						end if
						if strSituacao <> "" then
							sql = sql & " and SCA_GRADECURRICULAR.situacao = '" & strSituacao & "'"
						end if
						sql = sql & " ORDER BY SCA_PERIODO.Cod_Curso, 	SCA_PERIODO.Descricao"	
						rs.open sql, cnn
							
						if rs.eof = false then

				
											%>
						<div class="row">
							<div class="col-xl-8">
								<div id="panel-1" class="panel">
									<div class="panel-hdr">
										<h2>
											<%=pagina%> cadastradas
										</h2>
									</div>	
									
									<div class="panel-container show">
										<div class="panel-content">					
											<div class="panel-tag">
												<span class="fw-300">Para selecionar clique na linha abaixo.</span>
											</div>
											<div class="table-responsive-lg">	
												<table class="table table-bordered table-hover m-0">
													<thead class="thead-themed">
													  <tr>
														<th><strong>Código</strong></th>
														<th><strong>Curso</strong></th>
														<th><strong>Período</strong></th>
														<th><strong>Ano</strong></th>
														<th><strong>Semestre</strong></th>
														<th><strong>Matriz</strong></th>
													</thead>
													<tbody>
														
														
														<%
														while not rs.eof
															cont = cont + 1	
															Semestre = rs("SemestreReferencia")
															
															if Semestre = "1" then Semestre = "1º Semestre"
															if Semestre = "2" then Semestre = "2º Semestre"
															if Semestre = "3" then Semestre = "Anual"
															
															if trim(rs("Situacao")) = "A" then
																strSituacao = "Ativo"
															else
																strSituacao = "Inativo"
															end if
															matriz = rs("descCurso") & " - " & rs("descricao")
															diferenciada=""
															corFundo = ""
															if rs("diferenciada") = "S" then 
																diferenciada = "<strong><font color=blue>Diferenciada</font></strong>"
																corFundo = "bgcolor='#c1dff3'"
															end if
															
															%>
															
															  <tr <%=corFundo%> style="cursor: pointer"  onClick="return resultadoConsultaMatriz('<%=rs("Cod_GradeCurricular")%>','<%=matriz%>')">
																<td>&nbsp;<%=trim(rs("Cod_GradeCurricular"))%></td>
																<td>&nbsp;<%=trim(rs("descCurso"))%></td>
																<td>&nbsp;<%=trim(rs("descricao"))%></td>
																<td>&nbsp;<%=trim(rs("AnoReferencia"))%></td>
																<td>&nbsp;<%=trim(Semestre)%></td>
																<td>&nbsp;<%=trim(diferenciada)%></td>
															  </tr>
															<%				
														rs.movenext
														wend
														%>
														<tr> 
														<td height="21" colspan="6" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
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
					</main>
				</div>
			</div>
		</div> 
		<!-- this overlay is activated only when mobile menu is triggered -->
		<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
		<script src="js/js_funcoes_gerais.js"></script>
		<script>
			function resultadoConsultaMatriz(intCodigo, strMatriz){

			window.opener.document.getElementById('txtCodigo').value = intCodigo;
			window.opener.document.getElementById('txtNomeMatriz').value =  strMatriz; 
			window.opener.document.getElementById('frm').submit();
			window.close();
	}
		</script>
	</body>
</html>		