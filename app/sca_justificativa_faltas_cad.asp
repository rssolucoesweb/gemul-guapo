<%
	Function IsDateInRange(testDate, startDate, endDate)
		' Convert the dates to a common format (dd/mm/yyyy) if necessary
		testDate = CDate(testDate)
		startDate = CDate(startDate)
		endDate = CDate(endDate)
		
		' Check if the test date is between the start and end dates, inclusive
		If testDate >= startDate And testDate <= endDate Then
			IsDateInRange = True
		Else
			IsDateInRange = False
		End If
	End Function

	Function validaDataMenor(DateI, DateF)
		dataIni = CDate(DateI)
		dataFin = CDate(DateF)
		
		' Check if the test date is between the start and end dates, inclusive
		If dataIni <= dataFin Then
			validaDataMenor = True
		Else
			validaDataMenor = False
		End If
	End Function
	acao = "I"
	strExecutarSubmitTurma = "S"
	strExecutarSubmitSemestre = "S"
	intSemestre 			= Trim(Request("cmbSemestre"))
	strSemestre 			= Trim(Request("cmbSemestre"))

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	intCodigo = Trim(Request.form("txtCodigo"))
	
	intCodTipoJustificativa = Trim(Request.form("cmbTipoJustificativa"))
	if intCodTipoJustificativa = "" then intCodTipoJustificativa = "0"

	intCodBimestre = Trim(Request("cmbBimestre"))
	if intCodBimestre = "" then intCodBimestre = "0"
	
	intCodAluno = Trim(Request.form("cmbAluno"))
	intCodTurma = Trim(Request("cmbTurma"))
	if intCodTurma = "" then intCodTurma = "0"
	
	strDataInicial = Trim(Request.Form("txtDataInicial"))
	strDataFinal = Trim(Request.Form("txtDataFinal"))
	strJustificativa = Trim(Request.Form("txtJustificativa"))
	
	if trim(intCodigo) <> "" then
		sql = "SELECT F.*, I.IMAGEM"
		sql = sql & " FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS F"
		sql = sql & " LEFT JOIN SCA_ALUNO_JUSTIFICATIVA_FALTAS_IMAGEM I ON F.CODIGO = I.COD_ALUNO_JUSTIFICATIVA_FALTAS"
		sql = sql & " Where F.CODIGO = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			intCodTipoJustificativa	= rs("COD_TIPO_JUSTIFICATIVA_FALTAS")
			intCodBimestre			= rs("COD_BIMESTRE")
			intCodAluno				= rs("COD_ALUNO")
			intCodTurma 			= rs("COD_TURMA")
			strDataInicial 			= FORMATADATAAP(rs("DATAINICIAL"))
			strDataFinal 			= FORMATADATAAP(rs("DATAFINAL"))
			strJustificativa 		= rs("Justificativa")
			strImagem		 		= rs("imagem")
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
						<form id="frm" name="frm" method="post" action="sca_justificativa_faltas.asp">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=intCodAluno%>">
							
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Semestre</label>
										 <!--#include file="includes/inc_cmdSemestre.asp" -->
									</div>
								</div>
							
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Tabela bimestral:</label>
										<!--#include file="includes/inc_cmdBimestre.asp"-->
									</div>
								</div>
								
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Tipo de Justificativa:</label>
										<!--#include file="includes/inc_cmbTipoJustificativa.asp"-->
									</div>
								</div>
								
							</div>
							<br>
							
							<div class="row">
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Turma:</label>
										<!--#include file="includes/inc_cmdTurma.asp"-->
									</div>
								</div>
								<div class="col-sm-5">
									<div class="form-group">
										<label class="form-label">Aluno:</label>
										<!--#include file="includes/inc_cmbAluno.asp"-->
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Data Inicial:</label>
										 <input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onblur="validaDataNaTela(this);"  onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Data Final:</label>
										 <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onblur="validaDataNaTela(this);"  onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>">
									</div>
								</div>
							</div>
							
							<%
							
							'response.write "<br>strDataInicial" & strDataInicial
							'response.write "<br>strDataFinal" & strDataFinal
							'response.write "<br>strDataInicioBimestre" & strDataInicioBimestre
							'response.write "<br>strDataFimBimestre" & strDataFimBimestre
							
							
							'valida data digitada se está dentro do periodo do bimestre
							if intCodBimestre<>"0" and intCodigo = "" and (strDataInicial<>"" or strDataFinal<>"") then
								if strDataInicial<>"" then
									If not IsDateInRange(strDataInicial, strDataInicioBimestre, strDataFimBimestre) Then
										%>
											<br>
											<div class="alert alert-danger" role="alert">
												A <strong>data inicial</strong> está fora do período tabela bimestral. <%=strDescricaoBimestre%> - <%=strDataInicioBimestre%> a <%=strDataFimBimestre%>
											</div>
										<%
										acao = "_"
									End If
								end if
								
								if strDataInicial<>"" and strDataFinal<>"" then
									If not validaDataMenor(strDataInicial, strDataFinal) Then
										%>
										<br>
											<div class="alert alert-danger" role="alert">
												A <strong>data final</strong> está menor que a data inicial.
											</div>
										<%
										acao = "_"
									End If
								end if
								
							end if
							%>
							<br>
							<div class="form-group">
								<label class="form-label">Ocorrência</label>
								<textarea class="form-control" aria-label="With textarea" name="txtJustificativa" id="txtJustificativa"><%=strJustificativa%></textarea>
							</div>
							<div>
								<label class="form-label">Imagem do documento <em>(Tipo: JPG e PNG) (máximo de 2MB)</em></label>
								<input type="hidden" name="txtTexto" id="txtTexto">
								<div class="btn-toolbar" data-role="editor-toolbar" data-target="#editor">
									<div class="btn-group">
										<a class="btn" title="Inserir imagem" id="pictureBtn">
											<i class="fal fa-plus-circle"></i>
											&nbsp;<i class="fal fa-arrow-left"></i>&nbsp;<%if acao = "AE" then%><font color=red><strong>Importante:</strong></font> <strong>Selecione a imagem</strong> que será alterada e após clique aqui para inserir a nova imagem<%else%>Clique aqui para inserir a imagem (ou simplesmente arrastar e soltar)<%end if%>
										</a>
										<input type="file" data-role="magic-overlay" data-target="#pictureBtn" data-edit="insertImage" />
									</div>
									<input type="text" data-edit="inserttext" id="voiceBtn" x-webkit-speech="">
								</div>
								
								<div id="editor">
								<%=strimagem%>
								</div> 
							</div>
							<br>
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
	if intCodTurma<>"0" and intCodBimestre<>"0" then
	cont =0
	
	
	sql = "select f.codigo, f.usuario_incl, f.data_hora_incl, a.NOMEALUNO as aluno, (SELECT DATEDIFF(day, f.dataInicial, f.dataFinal)+1) AS NUMERO_JUSTIFICATIVAS, f.dataInicial, f.dataFinal "
	sql = sql & " from [dbo].SCA_ALUNO_JUSTIFICATIVA_FALTAS f"
	sql = sql & " inner join SCA_ALUNO a on a.CODIGO = f.cod_aluno"
	sql = sql & " where f.cod_turma = " & intCodTurma
	sql = sql & " and f.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and f.cod_bimestre = " & intCodBimestre
	sql = sql & " order by f.codigo desc	"
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
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">	
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Editar</strong></th>
									<th><strong>Lançamento</strong></th>
									<th><strong>Aluno</strong></th>
									<th><strong>Dias</strong></th>
									<th><strong>Período</strong></th>
									<th><strong>Imagem</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									while not rs.eof
										cont = cont + 1	
										periodo = formatadataAP(rs("dataInicial")) & " a " & formatadataAP(rs("dataFinal"))
										%>
										  <tr >
										    <td width="5%" onClick="return resultadoConsulta('<%=rs("codigo")%>')"><button type="button" class="btn btn-sm btn-success waves-effect waves-themed"><i class="fal fa-edit"></i></button></button></td>
											<td width="15%">&nbsp;<%=trim(rs("data_hora_incl"))%></td>
											<td width="40%">&nbsp;<%=trim(rs("aluno"))%></td>
											<td width="1%">&nbsp;<%=trim(rs("NUMERO_JUSTIFICATIVAS"))%></td>
											<td><%=trim(periodo)%></td>
											<td width="10%" onClick="return abreConsultaImagem('sca_justificativa_faltas_img.asp?codigo=<%=rs("codigo")%>')"><button type="button" class="btn btn-sm btn-info waves-effect waves-themed"><i class="fal fa-search"></i></button></button></td>
										  </tr>
										<%				
										rs.movenext
									wend
									%>
									<tr> 
										<td height="21" colspan="6" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
									</tr<
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