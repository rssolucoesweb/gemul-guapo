<%
	acao = "I"
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	if trim(intCodigo) <> "" and isnumeric(intCodigo) then
		sql = "SELECT Codigo, Descricao FROM MAT_SETORES where Cod_grupo = " & Session("CodGrupo") & " and Codigo = " & clng(intCodigo)
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	 	= rs("CODIGO")
			strDescricao	= rs("DESCRICAO")
			acao = "AE"
		end if
		rs.close
	end if
%>
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
			<small><%=descricao_pagina%></small>
		</h1>
	</div>
	<form id="frm" name="frm" method="post" action="mat_setores.asp">
	<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2><%=pagina%></h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if Session("UsuarioMaster") = "S" then%>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Descrição</label>
									<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" maxlength="100" value="<%=strDescricao%>">
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
						<%else%>
						<div class="panel-tag">Somente o usuário master inclui ou altera setores. Abaixo, a relação dos setores cadastrados.</div>
						<%end if%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont = 0
	sql = "SELECT m.Codigo, m.Descricao FROM MAT_SETORES m where m.Cod_grupo = " & Session("CodGrupo") & " Order by m.Descricao"
	rs.open sql, cnn
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Setores cadastrados</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if Session("UsuarioMaster") = "S" then%><div class="panel-tag">Para editar clique na linha abaixo.</div><%end if%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed"><tr><th>Código</th><th>Descrição</th></tr></thead>
								<tbody>
								<%while not rs.eof
									cont = cont + 1%>
								<tr <%if Session("UsuarioMaster") = "S" then%>style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("Codigo")%>')"<%end if%>>
									<td><%=rs("Codigo")%></td>
									<td><%=trim(rs("Descricao"))%></td>
								</tr>
								<%rs.movenext
								wend%>
								<tr><td colspan="2"><strong>Total de registros: <%=cont%></strong></td></tr>
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
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
