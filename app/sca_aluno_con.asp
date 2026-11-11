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
					pagina = "Consulta Aluno"
					descricao_pagina = "Consulta de alunos"
					mensagem_alerta_pagina = ""
					
					strAluno				= Trim(Request("txtAluno"))
					strMatricula			= Trim(Request("txtMatricula"))
					strcpf					= Trim(Request("txtcpf"))
					strConsultar			= Trim(Request("strConsultar"))
					strFiltro				= Trim(Request.Form("cmbFiltro"))
					if strFiltro="" then strFiltro = "A"
					
					strAcessoPerfil = ""
					'VERIFICA SE O USUARIO TEM ACESSO AO PERFIL DE ADMINISTRADOR SCA
					strCodPefilAcesso = "2" 
					SQL = "SELECT ACES_PERF_CODG"
					SQL = SQL & " FROM SEG_ACESSOS_USUARIO"
					SQL = SQL & " WHERE ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
					SQL = SQL & " AND ACES_PERF_CODG in (" & strCodPefilAcesso & ")"
					'response.write sql
					rs.open sql, cnn
					if not rs.EOF then	
						strAcessoPerfil = "ADMINISTRADOR"
					end if
					rs.close
					
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
												<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
												<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">

												<div class="form-group">
													<label class="form-label">Matrícula</label>
													<input type="text" name="txtMatricula" id="txtMatricula" class="form-control" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)">
												</div>
												<div class="form-group">
													<label class="form-label">Nome</label>
													<input type="text" name="txtAluno" id="txtAluno" class="form-control" value="<%=strAluno%>">
												</div>
												<div class="form-group">
													<label class="form-label">CPF</label>
													<input type="text" name="txtcpf" id="txtcpf" class="form-control" value="<%=strcpf%>"  onKeyPress="return formataCampo(this, 5, 15)">
												</div>
												<%IF session("codEmpresa") = "12" THEN%>
													<input name="cmbFiltro" type="hidden" id="cmbFiltro" value="T">
												<%else%>
													<%IF strAcessoPerfil = "ADMINISTRADOR" THEN%>
													<div class="form-group">
														<label class="form-label">Filtro de unidade</label>
														<select name="cmbFiltro" class="form-control" id="cmbFiltro">
														  <option value="A" <%if strFiltro = "A" then response.write "selected"%>>Somente da unidade atual</option>
														  <option value="T" <%if strFiltro = "T" then response.write "selected"%>>De todas unidades</option>
														</select>
													</div>
													<%END IF%>
												<%END IF%>
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
					strCpf 		= replace(replace(strCpf,".",""),"-","")

					if strConsultar <> "" then
					
						'sql = "SELECT A.CODIGO, A.MATRICULA, A.NOMEALUNO,AA.COD_EMPRESA, a.DATAMATRICULA, SA.DESC_SITUACAOALUNO, A.DATAFASTAMENTO, E.RAZAOSOCIAL AS UNIDADE, aa.ano_letivo "
						'sql = sql & " FROM SCA_ALUNO A "
						'sql = sql & " INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.Cod_ALUNO = A.CODIGO "
						'sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO "
						'sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = AA.COD_EMPRESA "
						'sql = sql & " where AA.cod_empresa = " & Session("CodEmpresa")			
						'sql = sql & " and AA.ano_letivo = " & trim(session("strAnoLetivo"))
						'if strMatricula <> "" then
						'	sql = sql & " and A.MATRICULA = '" & strMatricula & "'"
						'end if
						'if strcpf <> "" then
						'	sql = sql & " and A.CPFALUNO = '" & strcpf & "'"
						'end if
						'if strAluno <> "" then
						'	sql = sql & " and A.NOMEALUNO LIKE '%" & strAluno & "%'"
						'end if
						''response.write sql
						'sql = sql & " union"
						'sql = sql & " SELECT A.CODIGO, A.MATRICULA, A.NOMEALUNO,AA.COD_EMPRESA, a.DATAMATRICULA, SA.DESC_SITUACAOALUNO, A.DATAFASTAMENTO, E.RAZAOSOCIAL AS UNIDADE, max(aa.ano_letivo) as ano_letivo "
						'sql = sql & " FROM SCA_ALUNO A INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.Cod_ALUNO = A.CODIGO INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN SEG_EMPRESA E ON E.CODIGO = AA.COD_EMPRESA "
						'sql = sql & " where AA.cod_empresa = " & Session("CodEmpresa")			
						'sql = sql & " and AA.ano_letivo <> " & trim(session("strAnoLetivo"))
						'if strMatricula <> "" then
						'	sql = sql & " and A.MATRICULA = '" & strMatricula & "'"
						'end if
						'if strcpf <> "" then
						'	sql = sql & " and A.CPFALUNO = '" & strcpf & "'"
						'end if
						'if strAluno <> "" then
						'	sql = sql & " and A.NOMEALUNO LIKE '" & strAluno & "%'"
						'end if
						'sql = sql & " and a.codigo not in ("
						'sql = sql & " SELECT A.CODIGO"
						'sql = sql & " FROM SCA_ALUNO A INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.Cod_ALUNO = A.CODIGO INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN SEG_EMPRESA E ON E.CODIGO = AA.COD_EMPRESA "
						'sql = sql & " where AA.cod_empresa = " & Session("CodEmpresa")			
						'sql = sql & " and AA.ano_letivo = " & trim(session("strAnoLetivo"))
						'if strMatricula <> "" then
						'	sql = sql & " and A.MATRICULA = '" & strMatricula & "'"
						'end if
						'if strcpf <> "" then
						'	sql = sql & " and A.CPFALUNO = '" & strcpf & "'"
						'end if
						'if strAluno <> "" then
						'	sql = sql & " and A.NOMEALUNO LIKE '%" & strAluno & "%'"
						'end if
						'
						'sql = sql & " )"
						'sql = sql & " group by A.CODIGO, A.MATRICULA, A.NOMEALUNO,AA.COD_EMPRESA, a.DATAMATRICULA, SA.DESC_SITUACAOALUNO, A.DATAFASTAMENTO, E.RAZAOSOCIAL "
						'sql = sql & " order by A.NOMEALUNO, aa.ano_letivo, SA.DESC_SITUACAOALUNO"
						
							
						sql = "SELECT "
						sql = sql & "     A.CODIGO,"
						sql = sql & "     A.MATRICULA,"
						sql = sql & "     A.NOMEALUNO,"
						sql = sql & "     CC.COD_EMPRESA,"
						sql = sql & "     A.DATAMATRICULA,"
						sql = sql & "     SA.DESC_SITUACAOALUNO,"
						sql = sql & "     CC.ANO_LETIVO,"
						sql = sql & "     A.DATAFASTAMENTO,"
						sql = sql & "     CC.UNIDADE"
						sql = sql & " FROM SCA_ALUNO A"
						sql = sql & " OUTER APPLY ("
						sql = sql & "     SELECT TOP 1"
						sql = sql & "         C.COD_EMPRESA,"
						sql = sql & "         C.COD_SITUACAOALUNO,"
						sql = sql & "         E.RAZAOSOCIAL AS UNIDADE, C.ANO_LETIVO"
						sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C"
						sql = sql & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
						sql = sql & "     WHERE "
						sql = sql & "         C.COD_ALUNO = A.CODIGO"
						sql = sql & "         AND C.ANO_LETIVO <= " & trim(session("strAnoLetivo"))
						IF strFiltro = "A" THEN
							sql = sql & "         AND C.COD_EMPRESA = " & trim(Session("CodEmpresa"))
						END IF
						sql = sql & "     ORDER BY C.CODIGO DESC"
						sql = sql & " ) CC"
						sql = sql & " left JOIN SCA_SITUACAOALUNO SA "
						sql = sql & "     ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
						sql = sql & " where 1=1"
						IF strFiltro = "A" THEN
							sql = sql & "         AND CC.COD_EMPRESA = " & trim(Session("CodEmpresa"))
						END IF
						if strMatricula <> "" then
							sql = sql & " and A.MATRICULA = '" & strMatricula & "'"
						end if
						if strcpf <> "" then
							sql = sql & " and A.CPF = '" & strcpf & "'"
						end if
						if strAluno <> "" then
							sql = sql & " and A.NOMEALUNO COLLATE Latin1_General_CI_AI  LIKE '%" & strAluno & "%'"
						end if
						sql = sql & " order by A.NOMEALUNO "
'f ucase(session("usuarioWeb"))="SERGIO" then
'	response.write sql
'nd if
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
														<th><strong>Situa&ccedil;&atilde;o</strong></th>
														<th><strong>Ano Letivo</strong></th>
														<%IF strFiltro = "T" THEN%>
													    <th><strong>Unidade Escolar</strong></th>
														<%end if%>
													</thead>
													<tbody>
														<%
														while not rs.eof
															cont = cont + 1	
															%>
															
															  <tr style="cursor: pointer"  onClick="return resultadoConsultaAluno('<%=rs("CODIGO")%>','<%=rs("MATRICULA")%>','<%=rs("NOMEALUNO")%>')">
																<td>&nbsp;<%=trim(rs("MATRICULA"))%></td>
																<td>&nbsp;<%=trim(rs("NOMEALUNO"))%></td>
																<%if strMostraTurmas = "S" then %>
																	 <td><%=strNometurma%>&nbsp;</td>
																<%end if%>
																<td>&nbsp;<%=trim(rs("DESC_SITUACAOALUNO"))%></td>
																<td>&nbsp;<%=trim(rs("ANO_LETIVO"))%></td>
																<%IF strFiltro = "T" THEN%>
																<td>&nbsp;<%=trim(rs("UNIDADE"))%></td>
																<%end if%>
															  </tr>
															<%				
														rs.movenext
														wend
														%>
														<tr> 
														<td height="21" colspan="7" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
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