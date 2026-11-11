<%
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
		    intCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		else
			strCodAluno			= 0
		    intCodAluno			= ""
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close	
	
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if

	acao="I"


%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_documentacao_aluno.asp">

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
										
						<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
						
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group"><strong>Matrícula do Aluno</strong></label>
									<div class="input-group">
										<input type="text" class="form-control" value="<%=strMatricula%>" name="txtMatricula" id="txtMatricula" placeholder="" aria-label="" aria-describedby="button-addon5" onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
										<div class="input-group-append">
											<button class="btn btn-primary waves-effect waves-themed" type="button" id="button-addon5" onClick="return abreConsulta('sca_aluno_con.asp')" ><i class="fal fa-search"></i></button>
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
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Dados escolares</label>
									<strong><!--#include file="includes/inc_sqlDadosEscolaresAluno.asp" --></strong>&nbsp;
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
<%
if strMatricula <> "" and strCodAluno <> "" and strCodAluno <> "0" then	
%> 
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Documentos Exigidos ao Aluno
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
									<th align="center">&nbsp;</th>
									<th><strong>Descri&ccedil;&atilde;o</strong></th>
									<th><strong>Data Prorrogação</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
							sql = "SELECT Codigo, Descricao"
							sql = sql & " FROM SCA_DOCUMENTACOES"
							sql = sql & " Order by Codigo"
							rs.open sql, cnn
					
							if rs.eof = false then
								
								while not rs.eof
									
									sql = "Select Cod_aluno, Cod_documentacoes, data_prorrogacao, situacao "
									sql = sql & " From SCA_ALUNO_DOCUMENTACOES "
									sql = sql & " Where Cod_documentacoes = " & trim(rs("Codigo"))
									sql = sql & " and Cod_aluno = " & strCodAluno
									rsAux.open sql, cnn
									if rsAux.eof = false then
										if trim(rsAux("situacao")) = "R" then
											strChecked			= "checked"
											strBloqData			= "disabled"
										else
											strChecked			= ""
											strBloqData			= ""
										end if
										strDataProrrogacao 	= formatadataAP(rsAux("data_prorrogacao"))
									else
										strBloqData			= ""
										strChecked  		= ""
										strDataProrrogacao 	= ""
									end if
									rsAux.close	
									
									 %>
									 
									 <tr>
										<td align="center"><input name="chkDocumentacoes<%=rs("Codigo")%>" type="checkbox" id="chkDocumentacoes<%=rs("Codigo")%>" value="S" <%=strChecked%> onClick="return validaDocumentoData(this.checked,'<%=rs("Codigo")%>')"></td>
										<td><%=trim(rs("DESCRICAO"))%><input name="txtCodDocumento<%=rs("Codigo")%>" type="hidden" id="txtCodDocumento<%=rs("Codigo")%>" value="<%=rs("Codigo")%>"></td>
										<td><input <%=strBloqData%> name="txtDataProrrogacao<%=rs("Codigo")%>" type="text" class="text" id="txtDataProrrogacao<%=rs("Codigo")%>" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataProrrogacao%>"></td>
									</tr>
									 <%
									 rs.movenext
								  wend
									  
							  else
								 %>
								 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
								 <td colspan="3" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
								 </tr>
								 <%
							  end if
							  rs.close
							%>
								</tbody>
							</table>
							
							<br><br>
							<%if strMatricula <> "" and strCodAluno <> "" and strCodAluno <> "0" then	%> 
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Legenda</strong></th>
								  </tr>
							  </thead>
								<tbody>
								  <tr>
									<td class="celula">
									  <input disabled="disabled" type="checkbox" name="chk" checked="checked">
									  Documenta&ccedil;&atilde;o Regular.			</td>
								  </tr>
								  <tr>
									<td class="celula">
									  <input disabled="disabled" type="checkbox" name="chk2">
						Documenta&ccedil;&atilde;o Irregular. </td>
									</tr>
								</tbody>
							</table>
							<%end if%>
					<br>
					<br>
						</div>	
					</div>
				</div>
			</div>
		</div>
	</div>
<%
end if
%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>