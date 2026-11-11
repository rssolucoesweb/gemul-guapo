<%
	intCodInventario = Trim(Request.QueryString("cod"))

	sql = "SELECT i.codigo, i.numero_inventario, i.situacao, e.RAZAOSOCIAL as nome_empresa"
	sql = sql & " FROM PAT_INVENTARIO i"
	sql = sql & " INNER JOIN SEG_EMPRESA e ON e.CODIGO = i.cod_empresa"
	sql = sql & " WHERE i.codigo = " & intCodInventario
	rs.open sql, cnn
	if rs.eof then
		Response.Write "Inventário não encontrado."
		Response.End
	end if
	strNumeroInventario = rs("numero_inventario")
	strSituacaoInvent = rs("situacao")
	strNomeEmpresa = rs("nome_empresa")
	rs.close

	blnEmAndamento = (strSituacaoInvent = "EM_ANDAMENTO")
%>

<main id="js-page-content" role="main" class="page-content">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><a href="pat_inventario.asp"><%=modulo%></a></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></span></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small>Inventário <%=strNumeroInventario%> - <%=strNomeEmpresa%></small>
		</h1>
	</div>

	<%if blnEmAndamento then%>
	<div class="row">
		<div class="col-xl-10">
			<div id="panel-0" class="panel">
				<div class="panel-hdr">
					<h2>Bem encontrado sem etiqueta / não cadastrado</h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<form id="frmNaoCadastrado" name="frmNaoCadastrado" method="post" action="pat_inventario_itens_cod.asp?acao=AdicionarNaoCadastrado">
							<input type="hidden" name="cod_inventario" value="<%=intCodInventario%>">
							<div class="row">
								<div class="col-md-3">
									<input type="text" name="numero_identificacao" class="form-control" placeholder="Número/etiqueta encontrada (se houver)">
								</div>
								<div class="col-md-5">
									<input type="text" name="descricao_encontrado" class="form-control" placeholder="Descrição do item encontrado">
								</div>
								<div class="col-md-2">
									<button type="button" class="btn btn-warning btn-block" onclick="return adicionarNaoCadastrado()">Registrar</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%end if%>

	<div class="row">
		<div class="col-xl-10">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>Itens do Inventário</h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>N&ordm; Patrim&ocirc;nio</strong></th>
									<th><strong>Descri&ccedil;&atilde;o</strong></th>
									<th><strong>Local Esperado</strong></th>
									<th><strong>Status</strong></th>
									<%if blnEmAndamento then%><th>A&ccedil;&otilde;es</th><%end if%>
								  </tr>
								</thead>
								<tbody>
							  <%
							sql = "SELECT it.codigo, it.cod_patrimonio, it.tipo_item, it.status_conferencia,"
							sql = sql & " it.numero_identificacao_encontrado, it.descricao_item_encontrado,"
							sql = sql & " p.numero_patrimonio, p.descricao as descricao_bem,"
							sql = sql & " lo.descricao as local_esperado"
							sql = sql & " FROM PAT_INVENTARIO_ITEM it"
							sql = sql & " LEFT JOIN PAT_PATRIMONIO p ON p.codigo = it.cod_patrimonio"
							sql = sql & " LEFT JOIN PAT_LOCAL lo ON lo.codigo = it.cod_local_esperado"
							sql = sql & " WHERE it.cod_inventario = " & intCodInventario
							sql = sql & " ORDER BY it.status_conferencia, p.numero_patrimonio"

							rs.open sql, cnn
							cont = 0
							while not rs.eof
								cont = cont + 1

								strNumero = rs("numero_patrimonio")
								strDescricao = rs("descricao_bem")
								if rs("tipo_item") = "NAO_CADASTRADO" then
									strNumero = "(não cadastrado)"
									strDescricao = rs("descricao_item_encontrado") & " [" & rs("numero_identificacao_encontrado") & "]"
								end if

								statusLabel = rs("status_conferencia")
								Select Case rs("status_conferencia")
									Case "AGUARDANDO_CONFERENCIA" statusLabel = "Aguardando Conferência"
									Case "LOCALIZADO" statusLabel = "Localizado"
									Case "NAO_LOCALIZADO" statusLabel = "Não Localizado"
									Case "BEM_NAO_CADASTRADO" statusLabel = "Bem Não Cadastrado (encontrado)"
									Case Else statusLabel = "Divergência: " & rs("status_conferencia")
								End Select
								%>
								<tr>
									<td class="celula"><%=strNumero%></td>
									<td height="20" class="celula"><%=trim(strDescricao)%></td>
									<td height="20" class="celula"><%=trim(rs("local_esperado"))%></td>
									<td height="20" class="celula"><%=statusLabel%></td>
									<%if blnEmAndamento then%>
									<td height="20" class="celula">
										<%if rs("status_conferencia") = "AGUARDANDO_CONFERENCIA" then%>
										<a href="javascript:void(0);" onclick="return conferirLocalizado('<%=rs("codigo")%>')">Localizado</a> |
										<a href="javascript:void(0);" onclick="return conferirNaoLocalizado('<%=rs("codigo")%>')">Não Localizado</a> |
										<a href="javascript:void(0);" onclick="return conferirDivergencia('<%=rs("codigo")%>')">Divergência...</a>
										<%end if%>
									</td>
									<%end if%>
								</tr>
								<%
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="5" class="celula">Total de Itens : <%=cont%></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
<%
rs.close
%>
