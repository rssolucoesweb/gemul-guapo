<%
	acao = "I"

	intCodOcorrencia 		= Trim(Request.Form("txtCodigo"))
	strCodAluno 			= Trim(Request.Form("txtCodAluno"))
	strMatricula 			= Trim(Request.Form("txtMatricula"))
	strNomealuno 			= Trim(Request.Form("txtNomealuno"))
	strDataOcorrencia 		= Trim(Request.Form("txtDataOcorrencia"))
	IF strDataOcorrencia = "" THEN strDataOcorrencia = formatadataAP(date)
	strDataValidade 		= Trim(Request.Form("txtDataValidade"))
	strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
	
	if trim(strMatricula) <> "" then
	   sql = "SELECT codigo from sca_aluno "
	   sql = sql & " Where matricula = '" & strMatricula & "'"
	   rs.open sql, cnn
  	   if rs.eof = false then
	      strCodAluno				= rs("codigo")
	   end if
	   rs.close	  
	end if   
	
	if trim(intCodOcorrencia) <> "" then
	
		sql = "SELECT O.COD_OCORRENCIA, O.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, O.DATAOCORRENCIA, O.DATAVALIDADE, O.OCORRENCIA"
		sql = sql & " FROM SCA_OCORRENCIA O"
		sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = O.COD_ALUNO"
		sql = sql & " Where O.COD_OCORRENCIA = " & intCodOcorrencia
		sql = sql & " And O.cod_empresa = " & Session("CodEmpresa")			
		
		rs.open sql, cnn
		
		if rs.eof = false then
			strCodAluno				= rs("COD_ALUNO")
			intCodOcorrencia 		= rs("COD_OCORRENCIA")
			strMatricula 			= rs("MATRICULA")
			strNomeAluno 			= rs("NOMEALUNO")
			strDataOcorrencia 		= FORMATADATAAP(rs("DATAOCORRENCIA"))
			strDataValidade 		= FORMATADATAAP(rs("DATAVALIDADE"))
			strOcorrencia 			= rs("OCORRENCIA")

			acao = "AE"

		end if 
		rs.close
	end if
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
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
		<div class="col-xl-10">
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
						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodOcorrencia%>">
							<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group"><strong>Matrícula do Aluno</strong></label>
										<div class="input-group">
											<input type="text" class="form-control" value="<%=strMatricula%>" name="txtMatricula" id="txtMatricula" placeholder="" aria-label="" aria-describedby="button-addon5" onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
											<div class="input-group-append">
												<button class="btn btn-primary waves-effect waves-themed" type="button" id="button-addon5" onClick="return abreConsultaOcorrencia('sca_aluno_con.asp')" ><i class="fal fa-search"></i></button>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-9">
									<div class="form-group">
										<label class="form-label"></label>
										<input type="text" name="txtNomealuno" readonly id="txtNomealuno" class="form-control" value="<%=strNomeAluno%>">
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Tipo de Ocorr&ecirc;ncia:</label>
										<select name="cmbTipoOcorrencia" id="cmbTipoOcorrencia" class="form-control">
										   <option <%if strTipoOcorrencia = "D" then%> selected <%end if%> value="D">Disciplinar (Visualizada no portal do Aluno)</option>
										   <option <%if strTipoOcorrencia = "A" then%> selected <%end if%> value="A">Administrativa</option>
										 </select>
									</div>
								</div>
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Data Ocorr&ecirc;ncia:</label>
										 <input name="txtDataOcorrencia" type="text" class="form-control" id="txtDataOcorrencia" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataOcorrencia%>">
									</div>
								</div>
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Data Validade:</label>
										 <input name="txtDataValidade" type="text" class="form-control" id="txtDataValidade" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataValidade%>">
									</div>
								</div>
							</div>
							
							<div class="form-group">
								<label class="form-label">Ocorrência</label>
								<textarea class="form-control" aria-label="With textarea" name="txtOcorrencia" id="txtOcorrencia"><%=strOcorrencia%></textarea>
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
	if strCodAluno<>"" then
	cont =0
	
	sql = "SELECT O.COD_OCORRENCIA, O.OCORRENCIA, O.COD_DEPARTAMENTO, O.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, O.DATAOCORRENCIA"
	sql = sql & " FROM SCA_OCORRENCIA O"
	sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = O.COD_ALUNO"
	sql = sql & " where O.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and O.ano_letivo = " & Session("strAnoLetivo")
	sql = sql & " and O.INCLUSAO <> 'SISTEMA'"
	sql = sql & " AND O.COD_ALUNO = " & strCodAluno
	sql = sql & " order by O.DATAOCORRENCIA DESC"
	rs.open sql, cnn
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-10">
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
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">	
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Aluno</strong></th>
									<th><strong>Data Ocorr&ecirc;ncia</strong></th>
									<th><strong>Ocorrência</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									while not rs.eof
										cont = cont + 1	
										%>
										  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("COD_OCORRENCIA")%>')">
											<td width="1%">&nbsp;<%=trim(rs("MATRICULA"))%></td>
											<td width="30%">&nbsp;<%=trim(rs("NOMEALUNO"))%></td>
											<td width="20%">&nbsp;<%=trim(rs("DATAOCORRENCIA"))%></td>
											<td><%=trim(rs("OCORRENCIA"))%></td>
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
	end if
	%>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>