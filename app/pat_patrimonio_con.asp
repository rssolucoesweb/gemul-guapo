<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>GEMUL - Consulta Bem Patrimonial</title>
	<!--#include file=inc_meta.asp-->
	<!--#include file=inc_css.asp-->
	<!--#include file=inc_ico.asp-->
</head>
<body>
<%
	strNumero			= Trim(Request.QueryString("numero"))
	strDescricao		= Trim(Request.QueryString("descricao"))
	intCodEmpresa		= Trim(Request.QueryString("cmbEmpresa"))
	intCodCategoria		= Trim(Request.QueryString("cmbCategoria"))
	intCodTipoBem		= Trim(Request.QueryString("cmbTipoBem"))
	intCodSituacao		= Trim(Request.QueryString("cmbSituacao"))
	intCodEstado		= Trim(Request.QueryString("cmbEstadoConservacao"))
	blnConsultou		= (Trim(Request.QueryString("consultou")) = "1")
%>
<div class="container-fluid p-4">
	<h4><i class='fal fa-search'></i> Consulta Bem Patrimonial</h4>
	<p class="text-muted">Use os filtros abaixo e clique em Consultar. Depois clique no bem desejado para selecioná-lo.</p>

	<div class="card mb-3">
		<div class="card-body">
			<form id="frmConsulta" name="frmConsulta" method="get">
				<input type="hidden" name="consultou" value="1">
				<div class="row">
					<div class="col-md-3">
						<div class="form-group">
							<label class="form-label">Número do Patrimônio</label>
							<input type="text" id="txtNumero" name="numero" class="form-control" value="<%=strNumero%>">
						</div>
					</div>
					<div class="col-md-4">
						<div class="form-group">
							<label class="form-label">Descrição</label>
							<input type="text" id="txtDescricao" name="descricao" class="form-control" value="<%=strDescricao%>">
						</div>
					</div>
					<div class="col-md-5">
						<div class="form-group">
							<label class="form-label">Unidade</label>
							<%
							strCmbId = "cmbEmpresa"
							strCmbName = "cmbEmpresa"
							strCmbSelecionado = intCodEmpresa
							strCmbAtributos = ""
							%>
							<!--#include file="includes/inc_cmbEmpresaPat.asp"-->
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-3">
						<div class="form-group">
							<label class="form-label">Categoria</label>
							<%
							strCmbId = "cmbCategoria"
							strCmbName = "cmbCategoria"
							strCmbSelecionado = intCodCategoria
							strCmbAtributos = ""
							%>
							<!--#include file="includes/inc_cmbCategoriaPat.asp"-->
						</div>
					</div>
					<div class="col-md-3">
						<div class="form-group">
							<label class="form-label">Tipo de Bem</label>
							<select id="cmbTipoBem" name="cmbTipoBem" class="form-control">
								<option value="">Todos...</option>
								<%
								' Aqui o Tipo de Bem fica independente da Categoria (busca livre)
								sqlConTB = "SELECT codigo, descricao FROM PAT_TIPO_BEM WHERE situacao = 'A' ORDER BY descricao"
								Set rsConTB = Server.CreateObject("ADODB.Recordset")
								rsConTB.open sqlConTB, cnn
								while not rsConTB.eof
									strSelTB = ""
									if CStr(rsConTB("codigo")) = CStr(intCodTipoBem) then strSelTB = "selected"
									%>
									<option value="<%=rsConTB("codigo")%>" <%=strSelTB%>><%=rsConTB("descricao")%></option>
									<%
									rsConTB.movenext
								wend
								rsConTB.close
								Set rsConTB = Nothing
								%>
							</select>
						</div>
					</div>
					<div class="col-md-3">
						<div class="form-group">
							<label class="form-label">Situação</label>
							<%
							strCmbId = "cmbSituacao"
							strCmbName = "cmbSituacao"
							strCmbSelecionado = intCodSituacao
							strCmbAtributos = ""
							%>
							<!--#include file="includes/inc_cmbSituacaoPat.asp"-->
						</div>
					</div>
					<div class="col-md-3">
						<div class="form-group">
							<label class="form-label">Estado de Conservação</label>
							<%
							strCmbId = "cmbEstadoConservacao"
							strCmbName = "cmbEstadoConservacao"
							strCmbSelecionado = intCodEstado
							strCmbAtributos = ""
							%>
							<!--#include file="includes/inc_cmbEstadoConservacaoPat.asp"-->
						</div>
					</div>
				</div>
				<div class="frame-wrap">
					<button type="submit" class="btn btn-success">Consultar</button>
					<button type="button" class="btn btn-danger" onclick="window.close()">Fechar</button>
				</div>
			</form>
		</div>
	</div>

	<%if blnConsultou then%>
	<%
		sql = "SELECT p.codigo, p.numero_patrimonio, p.descricao, e.RAZAOSOCIAL as nome_empresa,"
		sql = sql & " s.descricao as descricao_situacao, ec.descricao as descricao_estado"
		sql = sql & " FROM PAT_PATRIMONIO p"
		sql = sql & " INNER JOIN SEG_EMPRESA e ON e.CODIGO = p.cod_empresa"
		sql = sql & " INNER JOIN PAT_SITUACAO s ON s.codigo = p.cod_situacao"
		sql = sql & " INNER JOIN PAT_TIPO_BEM tb ON tb.codigo = p.cod_tipo_bem"
		sql = sql & " LEFT JOIN PAT_ESTADO_CONSERVACAO ec ON ec.codigo = p.cod_estado_conservacao"
		sql = sql & " WHERE 1=1"
		if strNumero <> "" then sql = sql & " AND p.numero_patrimonio LIKE '%" & Replace(strNumero, "'", "''") & "%'"
		if strDescricao <> "" then sql = sql & " AND p.descricao LIKE '%" & Replace(strDescricao, "'", "''") & "%'"
		if intCodEmpresa <> "" then sql = sql & " AND p.cod_empresa = " & intCodEmpresa
		if intCodCategoria <> "" then sql = sql & " AND tb.cod_categoria = " & intCodCategoria
		if intCodTipoBem <> "" then sql = sql & " AND p.cod_tipo_bem = " & intCodTipoBem
		if intCodSituacao <> "" then sql = sql & " AND p.cod_situacao = " & intCodSituacao
		if intCodEstado <> "" then sql = sql & " AND p.cod_estado_conservacao = " & intCodEstado
		sql = sql & " ORDER BY p.numero_patrimonio DESC"

		rs.open sql, cnn
	%>
	<div class="card">
		<div class="card-body">
			<div class="table-responsive-lg">
				<table class="table table-bordered table-hover m-0">
					<thead class="thead-themed">
					  <tr>
						<th>Nº Patrimônio</th>
						<th>Descrição</th>
						<th>Unidade</th>
						<th>Situação</th>
						<th>Estado</th>
					  </tr>
					</thead>
					<tbody>
					<%
					cont = 0
					while not rs.eof
						cont = cont + 1
						%>
						<tr style="cursor: pointer" onclick="return selecionarBem('<%=rs("numero_patrimonio")%>')">
							<td><%=rs("numero_patrimonio")%></td>
							<td><%=trim(rs("descricao"))%></td>
							<td><%=trim(rs("nome_empresa"))%></td>
							<td><%=trim(rs("descricao_situacao"))%></td>
							<td><%=trim(rs("descricao_estado"))%></td>
						</tr>
						<%
						rs.movenext
					wend
					%>
						<tr>
							<td colspan="5">Total encontrado: <%=cont%></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<%
	rs.close
	%>
	<%end if%>
</div>

<script src="js/vendors.bundle.js"></script>
<script>
	function selecionarBem(numeroPatrimonio){

		if (window.opener && !window.opener.closed) {
			var campo = window.opener.document.getElementById('txtNumeroPatrimonio');
			if (campo) {
				campo.value = numeroPatrimonio;
			}
		}
		window.close();
		return false;
	}
</script>
</body>
</html>
