<%
	acao = "IE"
	strUsuarioPortal 	= Trim(Request("txtUsuarioPortal"))
	strNomeUsuario = ""
	if strUsuarioPortal <> "" then
		sql = "select USUA_NOME_COMPLETO from SEG_USUARIOS_SISTEMA where usua_codg = '" & replace(strUsuarioPortal, "'", "''") & "'"
		rs.open sql, cnn
		if rs.eof = false then
			strNomeUsuario = Trim(rs("USUA_NOME_COMPLETO"))
		else
			strNomeUsuario = "Não encontrado!"
			acao = "E"
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
			<i class='subheader-icon fal fa-user-check'></i> <%=pagina%>
			<small><%=descricao_pagina%></small>
		</h1>
	</div>
	<form id="frm" name="frm" method="post" action="mat_libera_cadastro.asp">
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>Dados da liberação</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Usuário (login)</label>
									<input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" maxlength="30" onBlur="submit()">
								</div>
							</div>
							<div class="col-sm-9">
								<label class="form-label">&nbsp;</label>
								<div class="form-control-plaintext"><strong><%=strNomeUsuario%></strong></div>
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
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Liberações</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag">Para excluir, marque os usuários e clique em Excluir.</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover table-sm m-0">
								<thead class="thead-themed"><tr>
									<th class="text-center" style="width:40px"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></th>
									<th>Login</th><th>Usuário</th><th>Lotação</th>
								</tr></thead>
								<tbody>
								<%
								cont = 0
								SQL = " SELECT I.CODIGO_SEG_USUARIOS_SISTEMA, U.USUA_NOME_COMPLETO, E.RAZAOSOCIAL AS LOTACAO"
								SQL = SQL & " FROM SEG_USUARIOS_INCLUI_CADASTRO I "
								SQL = SQL & " INNER JOIN SEG_USUARIOS_SISTEMA U ON U.USUA_CODG = I.CODIGO_SEG_USUARIOS_SISTEMA"
								SQL = SQL & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO_SEG_USUARIOS_SISTEMA = I.CODIGO_SEG_USUARIOS_SISTEMA"
								SQL = SQL & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO"
								SQL = SQL & " where I.cod_grupo = '" & SESSION("CODGRUPO") & "'"
								SQL = SQL & " Order by U.USUA_NOME_COMPLETO, E.RAZAOSOCIAL"
								rs.open sql, cnn
								while not rs.eof
									cont = cont + 1%>
								<tr>
									<td class="text-center"><input name="chkEmp" type="checkbox" value="<%=rs("CODIGO_SEG_USUARIOS_SISTEMA")%>"></td>
									<td><%=trim(rs("CODIGO_SEG_USUARIOS_SISTEMA"))%></td>
									<td><%=trim(rs("USUA_NOME_COMPLETO"))%></td>
									<td><%=trim(rs("LOTACAO") & "")%></td>
								</tr>
								<%rs.movenext
								wend
								rs.close%>
								<tr><td colspan="4"><strong>Total de registros: <%=cont%></strong></td></tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</form>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
