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
    <body class="nav-function-top header-function-fixed" style="">
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                <div class="page-content-wrapper">
					<%
					pagina_inicial_do_modulo = "academico.asp"
					pagina_atual = "/app/sca_matriz_curricular_disciplina.asp"
					sistema = "GEMUL"
					sistema_sigla = "SCA"
					modulo = "SCA"
					pagina = "Matriz Curricular - Disciplina"
					descricao_pagina = "Disciplina da Matriz Curricular"
					mensagem_alerta_pagina = ""
					
					strExecutarDisciplinaGrade = "S"
					strRetiraBotaolimparTela = "S"

					intCodEmpresa 				= Session("CodEmpresa")
					intCodGrade					= Trim(Request.QueryString("CodGrade"))
					if Trim(Request.form("cmbDisciplinaGrade")) = ""  then
						intCodCurricularDisciplina	= Trim(Request.QueryString("GradeCurricularDisciplina"))
						intDisciplinaPreRequisito   = Trim(Request.form("cmbDisciplinaPreRequisito"))
					else	
						intCodCurricularDisciplina	= Trim(Request.form("cmbDisciplinaGrade"))
					end if	
					
					if intCodGrade <> 0 then 
						
						sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
						sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
						sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, SCA_GRADECURRICULARDISCIPLINA.Ch_Pratica, SCA_GRADECURRICULARDISCIPLINA.Ch_Teorica, "
						sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina_Equivalente, "
						sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular_Equivalente,"
						sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina_Equivalente, "
						sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual, "
						sql = sql & " ISNULL(SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,'N') as Omitir_Criterio "
						sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA INNER JOIN SCA_DISCIPLINA "
						sql = sql & " ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
						sql = sql & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodGrade
						sql = sql & " And SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = " &  intCodCurricularDisciplina
						rs.open sql, cnn		
					
						if rs.eof = false then
							strDESCDisciplina 	= trim(rs("DESC_Disciplina"))
							strCh_Semanal 		= trim(rs("Ch_Semanal"))
							strCh_Mensal 		= trim(rs("Ch_Mensal"))
							strCh_Anual 		= trim(rs("Ch_Anual"))
							strCh_Pratica 		= trim(rs("Ch_Pratica"))
							strCh_Teorica 		= trim(rs("Ch_Teorica"))
							strOmitirCriterio 	= trim(rs("Omitir_Criterio"))
							
							acao = "A"

						end if
						rs.close
						
					else
						
						acao = "A"
						
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
												<input name="txtCodGrade" type="hidden" id="txtCodGrade" value="<%=intCodGrade%>">
												<input name="txtCodCurricularDisciplina" type="hidden" id="txtCodCurricularDisciplina" value="<%=intCodCurricularDisciplina%>">
												<input name="txtDescDisciplina" type="hidden" id="txtDescDisciplina" value="<%=strDESCDisciplina%>" >
												<div class="row">
													<div class="col-sm-4">	
														<div class="form-group">
															<label class="form-label">Selecionar Disciplina</label>
															<!--#include file="includes/inc_cmdDisciplinaGradeAlteracao.asp"-->
														</div>
													</div>	
													
												</div>	
												
												<br>
												<strong>Dados da carga horária</strong>
												<div class="row">
													<div class="col-sm-12">	
														<table class="table table-bordered table-hover m-0">
															  <tr bgcolor="#D3D3D3">
																<td colspan="3" align="center" class="celula"><strong>Aulas</strong></td>
																<td colspan="2" align="center" class="celula"><strong>Horas</strong></td>
																<td colspan="2" align="center" class="celula"><strong>Horas - (Opcional)</strong></td>
																<td width="13%" colspan="2" rowspan="2" align="center" class="celula"><strong>Omitir Crit&eacute;rio de Avalia&ccedil;&atilde;o</strong></td>
															  </tr>
															  <tr bgcolor="#D3D3D3">
																<td width="13%" align="center" class="celula"><strong>C.H. Semanal </strong></td>
																<td width="11%" align="center" class="celula"><strong>C.H. Mensal </strong></td>
																<td width="10%" align="center" class="celula"><strong>C.H. Total</strong></td>
																<td width="13%" align="center" class="celula"><strong>Hora Rel&oacute;gio</strong></td>
																<td width="13%" align="center" class="celula"><strong>C.H. Total</strong></td>
																<td width="13%" align="center" class="celula"><strong>C.H. Pr&aacute;tica</strong></td>
																<td width="13%" align="center" class="celula"><strong>C.H. Te&oacute;rica</strong></td>
															  </tr>
																  <tr bgcolor="#F3F3F3">
																<td class="celula" align="center"><input name="txtChSemanal" type="text" class="form-control" id="txtChSemanal" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Semanal%>" size="5" maxlength="8"></td>
																<td class="celula" align="center"><input name="txtChMensal" type="text" class="form-control" id="txtChMensal" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Mensal%>" size="5" maxlength="8"></td>
																<td align="center" class="celula"><input name="txtChAnual" type="text" class="form-control" id="txtChAnual" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Anual%>" size="5" maxlength="8"></td>
																<td align="center" class="celula"><input name="txtChHorasRelogio" type="text" class="form-control" id="txtChHorasRelogio" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_HoraRelogio%>" size="5" maxlength="8"></td>
																<td align="center" class="celula"><input name="txtChHoras" type="text" class="form-control" id="txtChHoras" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Horas%>" size="5" maxlength="8"></td>
																<td align="center" class="celula"><input name="txtChPratica" type="text" class="form-control" id="txtChPratica" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Pratica%>" size="5" maxlength="8"></td>
																<td align="center" class="celula"><input name="txtChTeorica" type="text" class="form-control" id="txtChTeorica" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Teorica%>" size="5" maxlength="8"></td>
																<td align="center" class="celula"><select name="cmbOmitirCriterio" class="form-control" id="cmbOmitirCriterio"  style="width:50pt" onchange='' >
																  <option value="N" <%if strOmitirCriterio = "N" then response.Write("selected") %>>NAO</option>
																  <option value="S" <%if strOmitirCriterio = "S" then response.Write("selected") %>>SIM</option>
																</select>
																</td>
															  </tr>
														</table>                  
			  
													</div>
													
													
												</div>
												<br>
												<div class="frame-wrap">
													<!--#include file="includes/inc_botoes_cadastroPopap.asp"-->
												</div>
											</form>
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
				
				if (frm1.txtCodGrade.value == ""){
					alert("A Grade deve ser informada.");
					frm1.txtCodGrade.focus();
					return false;
				}
				
				if (frm1.txtCodCurricularDisciplina.value == "") {
					alert("A Disciplina deve ser informada !");
					frm1.txtCodCurricularDisciplina.focus();
					return false;
				}

				if (frm1.txtChSemanal.value == "") {
					alert("A Carga Horaria semanal deve ser informada !");
					frm1.txtChSemanal.focus();
					return false;
				}

				if (frm1.txtChMensal.value == "") {
					alert("A Carga Horaria Mensal deve ser informada !");
					frm1.txtChMensal.focus();
					return false;
				}

				if (frm1.txtChAnual.value == "") {
					alert("A Carga Horaria Anual em numero de Aulas, deve ser informada !");
					frm1.txtChAnual.focus();
					return false;
				}

				
				frm1.action="sca_matriz_curricular_disciplina_cod.asp?acao=" + acao;
				frm1.submit();
				return true;
			}
		</script>
	</body>
</html>		