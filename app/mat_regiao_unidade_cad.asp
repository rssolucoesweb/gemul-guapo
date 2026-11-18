<%
	acao = "A"
	strBotaoLimparTela = "N"
	strBotaoVoltaTelaAnterior = "S"
	pagina_anterior = "mat_regiao.asp"
	intCodRegiao	= Trim(Request.Form("txtCodigo"))
	strRegiao 		= Trim(Request.Form("txtRegiao"))
	if not isnumeric(intCodRegiao & "") or trim(intCodRegiao & "") = "" then response.redirect "mat_regiao.asp"
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
	<form id="frm" name="frm" method="post">
	<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodRegiao%>">
	<input name="txtRegiao" type="hidden" id="txtRegiao" value="<%=strRegiao%>">
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>Região: <strong><%=strRegiao%></strong></h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag">Marque os itens vinculados à região e clique em Alterar.</div>
						<%
						cont = 0
						sql = " SELECT distinct E.RAZAOSOCIAL as descricao, r.cod_regiao, E.CODIGO AS COD_EMPRESA"
						sql = sql & " FROM SEG_EMPRESA E"
						sql = sql & " LEFT JOIN MAT_regiao_empresa R ON R.COD_empresa = E.codigo and r.cod_regiao = " & clng(intCodRegiao)
						sql = sql & " WHERE E.BLOQUEIO = 'N' AND E.COD_GRUPO = " & Session("CodGrupo")
						sql = sql & " Order by E.RAZAOSOCIAL"
						rs.open sql, cnn
						if rs.eof = false then
						%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover table-sm m-0">
								<thead class="thead-themed"><tr>
									<th class="text-center" style="width:40px"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></th>
									<th>Unidade escolar</th>
								</tr></thead>
								<tbody>
								<%while not rs.eof
									cont = cont + 1
									strMarca = ""
									if trim(intCodRegiao) = trim(rs("cod_regiao") & "") then strMarca = "checked"%>
								<tr>
									<td class="text-center"><input name="chkEmp" type="checkbox" value="<%=rs("COD_EMPRESA")%>" <%=strMarca%>></td>
									<td><%=trim(rs("descricao"))%></td>
								</tr>
								<%rs.movenext
								wend%>
								<tr><td colspan="2"><strong>Total de registros: <%=cont%></strong></td></tr>
								</tbody>
							</table>
						</div>
						<%
						end if
						rs.close
						%>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</form>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
