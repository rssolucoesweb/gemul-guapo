<%
	strCodigo 					= Session("CodEmpresa")  
	strAutorizacao 				= Trim(Request.Form("txtAutorizacao"))
	strSecretaria				= Trim(Request.Form("txtSecretaria"))
	strContato					= Trim(Request.Form("txtContato"))
	strContato1					= Trim(Request.Form("txtContato1"))
	strContato2					= Trim(Request.Form("txtContato2"))
	strEndereco					= Trim(Request.Form("txtEndereco"))
	strBairro					= Trim(Request.Form("txtBairro"))
	strMunicipio				= Trim(Request.Form("txtMunicipio"))
	strUF						= Trim(Request.Form("txtUF"))
	strCep						= Trim(Request.Form("txtCep"))
	strTelefone					= Trim(Request.Form("txtTelefone"))
	strCodigoCenso				= Trim(Request.Form("txtCodigoCenso"))
	strCodigoSetransp			= Trim(Request.Form("txtCodigoSetransp"))
	strNomeCaixa				= Trim(Request.Form("txtNomeCaixa"))
	strPresidente				= Trim(Request.Form("txtPresidente"))
	strDataInicio				= FORMATADATAAP(Trim(Request.Form("txtDataInicio")))
	strDataFim					= FORMATADATAAP(Trim(Request.Form("txtDataFim")))
	if strCodigo <> "" then
		
		sql = "SELECT * "
		sql = sql & " FROM SEG_EMPRESA"
		sql = sql & " WHERE CODIGO = " & strCodigo
		
		rs.open sql, cnn
		if rs.eof = false then
			strCodigo  					= Trim(RS("CODIGO"))
			strAutorizacao 				= Trim(RS("Autorizacao"))
			strDiretor					= Trim(RS("Diretor"))
			strSecretaria				= Trim(RS("Secretaria"))
			strContato					= Trim(RS("Contato"))
			strContato1					= Trim(RS("Contato1"))
			strContato2					= Trim(RS("Contato2"))
			strEndereco					= Trim(RS("Endereco"))
			strBairro					= Trim(RS("Bairro"))
			strMunicipio				= Trim(RS("Municipio"))
			strUF						= Trim(RS("UF"))
			strCep						= Trim(RS("Cep"))
			strTelefone					= Trim(RS("Telefone"))
			strNomeLogo					= Trim(RS("LOGOMARCA"))	
			strLogoConvenio				= Trim(RS("LogoConvenio"))	
			strNotificacao				= Trim(RS("NOTIFICACAO"))
			strCodigoCenso				= Trim(RS("CODIGO_CENSO"))
			strCodigoSetransp			= Trim(RS("CODIGO_SETRANSP"))
			strNomeCaixa				= Trim(RS("NomeCaixa"))
			strPresidente				= Trim(RS("Presidente"))
			strDataInicio				= FORMATADATAAP(Trim(RS("DataInicio")))
			strDataFim					= FORMATADATAAP(Trim(RS("DataFim")))
			acao = "A"
		end if 
		rs.close
	end if 
	
	IF strNomeLogo <> "" then
		strImagem = "<img src='..\..\LogoMarcas\" & strNomeLogo & "\" & strCodigo & "' border='1' width='85' height='113'>"
	else
		strImagem = "<font color='#CCCCCC'>  LOGO </font>"
	end if
	
	IF strLogoConvenio <> "" then
		strImagem = "<img src='..\..\LogoConvenio\" & intCodGrupo & "\" & strLogoConvenio & "' border='1' width='85' height='113'>"
	else
		strImagem = "<font color='#CCCCCC'>  LOGO </font>"
	end if
%>

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
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
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
							<input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa" value="<%=strCodigo%>">
							<label class="form-label">Informações administrativas</label>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Nome do Caixa escolar ou Conselho</label>
										<input type="text" id="txtNomeCaixa" name="txtNomeCaixa" class="form-control" value="<%=strNomeCaixa%>" maxlength="100">
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Presidente</label>
										<input type="text" id="txtPresidente" name="txtPresidente" class="form-control" value="<%=strPresidente%>" maxlength="100">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Início vigência</label>
										<input  name="txtDataInicio" type="text" class="form-control" id="txtDataInicio" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicio%>">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Fim vigência</label>
										<input  name="txtDataFim" type="text" class="form-control" id="txtDataFim" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFim%>">
									</div>
								</div>
								
							</div>
							<br>
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<label class="form-label">Autorização</label>
										<textarea class="form-control" aria-label="With textarea" name="txtAutorizacao" id="txtAutorizacao"><%=strAutorizacao%></textarea>
										
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Diretor(a)</label>
										<input type="text" id="txtDiretor" name="txtDiretor" class="form-control" value="<%=strDiretor%>" maxlength="50">
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Secretario(a)</label>
										<input type="text" id="txtSecretaria" name="txtSecretaria" class="form-control" value="<%=strSecretaria%>" maxlength="50">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">1º Contato</label>
										<input type="text" id="txtContato" name="txtContato" class="form-control" value="<%=strContato%>" maxlength="50">
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">2º Contato</label>
										<input type="text" id="txtContato1" name="txtContato1" class="form-control" value="<%=strContato1%>" maxlength="50">
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">3º Contato</label>
										<input type="text" id="txtContato2" name="txtContato2" class="form-control" value="<%=strContato2%>" maxlength="50">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Endereço</label>
										<input type="text" id="txtEndereco" name="txtEndereco" class="form-control" value="<%=strEndereco%>" maxlength="50">
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Bairro</label>
										<input type="text" id="txtBairro" name="txtBairro" class="form-control" value="<%=strBairro%>" maxlength="30">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Município</label>
										<input type="text" id="txtMunicipio" name="txtMunicipio" class="form-control" value="<%=strMunicipio%>" maxlength="50">
									</div>
								</div>
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Estado</label>
										<input type="text" id="txtUF" name="txtUF" class="form-control" value="<%=strUF%>" maxlength="2" onKeyPress="return formataCampo(this, 1, 2)">
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Cep</label>
										<input type="text" id="txtCep" name="txtCep" class="form-control" onKeyPress="return formataCampo(this,2,8)" value="<%=strCep%>" maxlength="10">
									</div>
								</div>									
							</div>	
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Código Inep</label>
										<input type="text" id="txtCodigoCenso" name="txtCodigoCenso" onKeyPress="return formataCampo(this,2,8)"  class="form-control" value="<%=strCodigoCenso%>" maxlength="10">
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Código Setransp</label>
										<input type="text" id="txtCodigoSetransp" name="txtCodigoSetransp" onKeyPress="return formataCampo(this,2,8)"  class="form-control" value="<%=strCodigoSetransp%>" maxlength="50">
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Telefone Unidade</label>
										<input type="text" id="txtTelefone" name="txtTelefone" class="form-control"  onKeyPress="mascara(this,telefone)" value="<%=strTelefone%>" maxlength="14">
									</div>
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
	cont =0
	sql = "SELECT SEG_EMPRESA.Codigo, Cnpj, RazaoSocial, LOGOMARCA, SEG_GRUPO.DESCRICAO AS GRUPO, LogoConvenio, COD_GRUPO"
	sql = sql & " FROM SEG_EMPRESA "  
	sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
	sql = sql & " WHERE  1=1" 
	sql = sql & "and SEG_EMPRESA.CODIGO = " & Session("CodEmpresa")  
	sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RazaoSocial"
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
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>C&oacute;digo</strong></th>
									<th><strong>CNPJ</strong></th>
									<th><strong>Raz&atilde;o Social</strong></th>
									<th><strong>Logomarca</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									while not rs.eof
										cont = cont + 1	
							
										if isnull(rs("LOGOMARCA")) or rs("LOGOMARCA") = "" then
											caminhoLogo = "../../LogoMarcas/LogoEmpresa.gif"
										else
											caminhoLogo = "../../LogoMarcas/" & rs("Codigo") & "/" & rs("LOGOMARCA")
										end if
										
										if isnull(rs("LogoConvenio")) or rs("LogoConvenio") = "" then
											caminhoLogoConvenio = "../../LogoConvenio/LogoEmpresa.gif"
										else
											caminhoLogoConvenio = "../../LogoConvenio/" & Session("CodEmpresa") & "/" & rs("LogoConvenio")
										end if
										%>
										  <tr>
											<td class="celula"><%=rs("codigo")%></td>
											<td height="20" class="celula"><%=formataCnpjAP(rs("Cnpj"))%></td>
											<td height="20" class="celula"><%=ucase(rs("RazaoSocial"))%></td>
											<td height="20" class="celula"><img src="<%=caminhoLogo%>" width="47" height="50"></td>
										  </tr>
										  <%				
										rs.movenext
									wend
									%>
									<tr>
										<td height="21" colspan="4 class="celula">Total Registros : <%=cont%></td>
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
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>