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
            GEMUL - Consulta Aluno
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
					pagina_atual = "/app/sca_aluno_con.asp"
					sistema = "GEMUL"
					modulo = "Acadêmico"
					pagina = "Consulta Aluno com cadastro incompleto"
					descricao_pagina = "Consulta de alunos com cadastro incompleto no sistema."
					mensagem_alerta_pagina = ""
					
					strAluno				= Trim(Request("txtAluno"))
					strMatricula			= Trim(Request("txtMatricula"))
					strcpf					= Trim(Request("txtcpf"))
					strConsultar			= Trim(Request("strConsultar"))
					strMostraTurmas			= Trim(Request.Form("MostraTurmas"))
					strConsultar = request("strConsultar")
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

						<%
						cont =0
						strCpf 		= replace(replace(strCpf,".",""),"-","")
                        strCamposObrigatorios = request("strCamposObrigatorios")
						
                        vetCamposObrigatorios = split(strCamposObrigatorios,",")

                            sql="select sa.*, sit.DESC_SITUACAOALUNO" 
                            sql=sql & " from sca_aluno_turma sat"
                            sql=sql & " inner join SCA_ALUNO sa on sat.COD_ALUNO = sa.CODIGO"
                            sql=sql & " inner join SCA_SITUACAOALUNO sit on sa.COD_SITUACAOALUNO = sit.Cod_SituacaoAluno"
                            sql=sql & " where sat.COD_EMPRESA =" & Session("CodEmpresa")
                            sql=sql & " and sat.ANO_LETIVO =" & Session("strAnoLetivo")
                            sql=sql & " and sat.SITUACAO = 'A'"
                            sql=sql & " and sit.Desc_SituacaoAluno = 'ATIVO'"
                            sql=sql & " and ("

                            for i = 0 to ubound(vetCamposObrigatorios)
                                if i > 0 then
                                    sql=sql & " or "
                                end if
								if vetCamposObrigatorios(i)="Ufnascimento" then
									sql=sql & " ((Rtrim(Ltrim(sa." & vetCamposObrigatorios(i) & ")) = '' or sa." & vetCamposObrigatorios(i) & " is null) and (sa.nacionalidade='BRASILEIRA'))"
								else
									sql=sql & " (Rtrim(Ltrim(sa." & vetCamposObrigatorios(i) & ")) = '' or sa." & vetCamposObrigatorios(i) & " is null) "
								end if
                            next
                            sql=sql & ")"
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
										<div class="panel-content">					
											<div class="panel-tag">
												<span class="fw-300">Para selecionar clique na linha abaixo.</span>
											</div>
											<div class="table-responsive-lg">	
												<table class="table table-bordered table-hover m-0">
													<thead class="thead-themed">
													  <tr>
														<th><strong>Matr&iacute;cula</strong></th>
														<th><strong>Nome do Aluno</strong></th>
														<th><strong>Campos Incompletos</strong></th>
													  
													</thead>
													<tbody>
														<%
														while not rs.eof														
															%>
															
															  <tr style="cursor: pointer"  onClick="return resultadoConsultaAluno('<%=rs("CODIGO")%>','<%=rs("MATRICULA")%>','<%=rs("NOMEALUNO")%>')">
																<td>&nbsp;<%=trim(rs("MATRICULA"))%></td>
																<td>&nbsp;<%=trim(rs("NOMEALUNO"))%></td>
																<td>
                                                                <%
                                                                    strIncompletos = ""
                                                                    for i = 0 to ubound(vetCamposObrigatorios)
                                                                        if isnull(rs(vetCamposObrigatorios(i))) or trim(rs(vetCamposObrigatorios(i))) = "" then
                                                                            if strIncompletos <> "" then
                                                                                strIncompletos = strIncompletos & ", "
                                                                            end if
                                                                            strIncompletos = strIncompletos & vetCamposObrigatorios(i)
                                                                        end if

                                                                    next     
                                                                    if strIncompletos <> "" then
                                                                        response.write strIncompletos
                                                                        cont = cont + 1                                                           
                                                                    end if
                                                                    
                                                                %>
                                                                </td>
															  </tr>
															<%				
														rs.movenext
														wend
														%>
														<tr> 
														<td height="21" colspan="4" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
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
			function resultadoConsultaAluno(intCodigo, strMatricula, Nome){
	
			window.opener.document.getElementById('txtCodAluno').value = intCodigo;
			window.opener.document.getElementById('txtMatricula').value =  strMatricula; 
			window.opener.document.getElementById('txtNomealuno').value =  Nome; 
			window.opener.document.getElementById('frm').submit();
			window.close();
	}
		</script>
	</body>
</html>		