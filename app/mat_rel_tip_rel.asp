<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
if request("exportar") = "" then
	Response.Buffer = false
end if
'	::	Relatório de TIP (transferência por interesse próprio) - filtros em mat_rel_tip_cad.asp

strCodEmpresaPadrao		= Session("strCodEmpresaPadrao")  'é carregado na pasta login/selecionar_escola.asp

intAnoLetivo 			= trim(request("txtAnoLetivo"))
intCodEmpresa			= trim(request("cmbEmpresaGrupo"))
strParticipacao			= trim(request("cmbParticipacao"))
strSituacaoFiltro		= ucase(trim(request("cmbSituacao")))

if not isnumeric(intAnoLetivo) or intAnoLetivo = "" then intAnoLetivo = Session("strAnoLetivo")
if not isnumeric(intCodEmpresa) or intCodEmpresa = "" then intCodEmpresa = "0"
if strParticipacao <> "O" and strParticipacao <> "D" then strParticipacao = "A"
if strSituacaoFiltro <> "P" and strSituacaoFiltro <> "E" and strSituacaoFiltro <> "C" then strSituacaoFiltro = ""

strParametros = "&txtAnoLetivo=" & intAnoLetivo & "&cmbEmpresaGrupo=" & intCodEmpresa & "&cmbParticipacao=" & strParticipacao & "&cmbSituacao=" & strSituacaoFiltro
strExportarWord 	= paginaatual & "?exportar=w" & strParametros
strExportarExcel 	= paginaatual & "?exportar=e" & strParametros
%>
<html>
<head>
<title>GEMUL - Relatório de TIP</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
if request("exportar") = "" then 
    %>
	<!--#include file="includes/inc_Botoes_relatorio_word_excel.asp"-->
	<!--#include file="includes/inc_aguarde.asp"-->
	<%
end if

	'*************************************
	'REGRA PRA O CABEÇARIO DO RELATORIO
	strEmpresa = ""
	if intCodEmpresa = "0" then
		sql = "select razaosocial as empresa from seg_empresa where codigo = " & clng("0" & strCodEmpresaPadrao)
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strEmpresaWeb 		= rs("empresa")
			strMostraDadosSession="N"
			mostraEndereco = "N"
		END IF
		rs.close
	else
		sql = "select razaosocial as empresa, ENDERECO, MUNICIPIO, BAIRRO, UF, CEP, TELEFONE, DIRETOR, SECRETARIA from seg_empresa where codigo = " & clng(intCodEmpresa)
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strEmpresaWeb 				= rs("empresa")
			EnderecoEmpresaWeb			= Rs("ENDERECO")
			CidadeEmpresaWeb			= Rs("MUNICIPIO")
			BairroEmpresaWeb			= Rs("BAIRRO")
			UFEmpresaWeb				= Rs("UF")
			CepEmpresaWeb				= Rs("CEP")
			TelefoneEmpresaWeb			= Rs("TELEFONE")
			NomeDiretorEmpresaWeb		= Rs("DIRETOR")
			NomeSecretariaEmpresaWeb	= Rs("SECRETARIA")
			strMostraDadosSession="N"
		END IF
		rs.close
	end if
	'*************************************

	select case strSituacaoFiltro
		case "P" : strDescSituacao = " - aguardando efetivação"
		case "E" : strDescSituacao = " - efetivadas"
		case "C" : strDescSituacao = " - canceladas"
		case else : strDescSituacao = ""
	end select
	strTituloRelatorio = "TIP - Transferência por Interesse Próprio<br>ano letivo " & intAnoLetivo & " (solicitadas em " & intAnoLetivo & " ou com a nova escola em " & intAnoLetivo & ")" & strDescSituacao

	if request("exportar") = "" then
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end if

	'Unidades: a escolhida ou todas as que o usuário acessa (SEG_USUARIOS_EMPRESA)
	if intCodEmpresa <> "0" then
		strUnidades = clng(intCodEmpresa)
	else
		strUnidades = "SELECT UE.COD_EMPRESA FROM SEG_USUARIOS_EMPRESA UE INNER JOIN SEG_EMPRESA E2 ON E2.CODIGO = UE.COD_EMPRESA"
		strUnidades = strUnidades & " WHERE UE.CODIGO_SEG_USUARIOS_SISTEMA = '" & replace(Session("UsuarioWeb") & "", "'", "''") & "' AND E2.COD_GRUPO = " & clng("0" & Session("CodGrupo"))
	end if

	sql = "SELECT TIP.CODIGO, A.MATRICULA, A.NOMEALUNO,"
	sql = sql & " EO.RAZAOSOCIAL AS UNIDADE_ORIGEM,"
	sql = sql & " LTRIM(RTRIM(ISNULL(PO.Descricao,'') + ' ' + ISNULL(TOR.TurmaAluno,'') + ' ' + ISNULL(TOR.NomeTurma,''))) AS TURMA_ORIGEM,"
	sql = sql & " ED.RAZAOSOCIAL AS UNIDADE_DESTINO,"
	sql = sql & " LTRIM(RTRIM(ISNULL(PD.Descricao,'') + ' ' + ISNULL(TDE.TurmaAluno,'') + ' ' + ISNULL(TDE.NomeTurma,''))) AS TURMA_DESTINO,"
	sql = sql & " TUD.Desc_Turno AS TURNO_DESTINO, TIP.ANO_LETIVO, ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO + 1) AS ANO_DESTINO,"
	sql = sql & " ISNULL(TIP.SITUACAO, 'E') AS SITUACAO, TIP.USUARIO_INCL, TIP.DATA_HORA_INCL,"
	sql = sql & " TIP.USUARIO_EFETIVACAO, TIP.DATA_HORA_EFETIVACAO, TIP.DATA_HORA_CANCELAMENTO, TIP.MOTIVO_CANCELAMENTO,"
	sql = sql & " CASE WHEN ISNULL(TIP.SITUACAO, 'E') = 'P' THEN dbo.FN_MAT_TipPrazoConfirmacao(TIP.CODIGO) END AS PRAZO"
	sql = sql & " FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP"
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = TIP.COD_ALUNO"
	sql = sql & " LEFT JOIN SEG_EMPRESA EO ON EO.CODIGO = TIP.COD_EMPRESA"
	sql = sql & " LEFT JOIN SEG_EMPRESA ED ON ED.CODIGO = TIP.COD_EMPRESA_DESTINO"
	sql = sql & " LEFT JOIN SCA_TURMA TOR ON TOR.Cod_Turma = TIP.COD_TURMA"
	sql = sql & " LEFT JOIN SCA_PERIODO PO ON PO.Cod_Periodo = TOR.Cod_periodo"
	sql = sql & " LEFT JOIN SCA_TURMA TDE ON TDE.Cod_Turma = TIP.COD_TURMA_DESTINO"
	sql = sql & " LEFT JOIN SCA_PERIODO PD ON PD.Cod_Periodo = TDE.Cod_periodo"
	sql = sql & " LEFT JOIN SCA_TURNO TUD ON TUD.Cod_Turno = TIP.COD_TURNO_DESTINO"
	'TIP do ano letivo selecionado: solicitadas nele (origem) ou que levam o aluno para a nova escola nele (destino).
	'Ex.: no topo 2026 aparecem as solicitadas em 2026; no topo 2027 aparecem as mesmas, pois o destino é 2027.
	sql = sql & " WHERE (TIP.ANO_LETIVO = " & clng(intAnoLetivo) & " OR ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO + 1) = " & clng(intAnoLetivo) & ")"
	select case strParticipacao
		case "O" : sql = sql & " AND TIP.COD_EMPRESA IN (" & strUnidades & ")"
		case "D" : sql = sql & " AND TIP.COD_EMPRESA_DESTINO IN (" & strUnidades & ")"
		case else : sql = sql & " AND (TIP.COD_EMPRESA IN (" & strUnidades & ") OR TIP.COD_EMPRESA_DESTINO IN (" & strUnidades & "))"
	end select
	if strSituacaoFiltro <> "" then sql = sql & " AND ISNULL(TIP.SITUACAO, 'E') = '" & strSituacaoFiltro & "'"
	sql = sql & " ORDER BY EO.RAZAOSOCIAL, A.NOMEALUNO"

	cont = 0 : qtdP = 0 : qtdE = 0 : qtdC = 0
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
  <tr bgcolor="#CCCCCC">
	<td width="3%" class="celula"><strong>Nº</strong></td>
	<td width="7%" class="celula"><strong>Matrícula</strong></td>
	<td width="15%" class="celula"><strong>Aluno</strong></td>
	<td width="14%" class="celula"><strong>Unidade de origem</strong></td>
	<td width="9%" class="celula"><strong>Turma de origem</strong></td>
	<td width="14%" class="celula"><strong>Unidade de destino</strong></td>
	<td width="10%" class="celula"><strong>Turma de destino</strong></td>
	<td width="9%" class="celula"><strong>Incluída por / em</strong></td>
	<td width="9%" class="celula"><strong>Situação</strong></td>
	<td width="10%" class="celula"><strong>Efetivada / cancelada em</strong></td>
  </tr>
<%
	rs.open sql, cnn
	if not rs.eof then
		while not rs.eof
			cont = cont + 1
			strSit = trim(rs("SITUACAO") & "")
			select case strSit
				case "P"
					qtdP = qtdP + 1
					strDescSit = "Aguardando efetivação"
					if isdate(rs("PRAZO")) then strDescSit = strDescSit & "<br><small>prazo: " & formatadataAP(rs("PRAZO")) & "</small>"
					strQuando = ""
				case "C"
					qtdC = qtdC + 1
					strDescSit = "<font color=""#b00020"">Cancelada</font>"
					strQuando = rs("DATA_HORA_CANCELAMENTO") & ""
					if trim(rs("MOTIVO_CANCELAMENTO") & "") <> "" then strQuando = strQuando & "<br><small>" & server.htmlEncode(rs("MOTIVO_CANCELAMENTO") & "") & "</small>"
				case else
					qtdE = qtdE + 1
					strDescSit = "<font color=""#1e7e34"">Efetivada</font>"
					strQuando = trim(rs("USUARIO_EFETIVACAO") & "")
					if strQuando <> "" then strQuando = strQuando & "<br>"
					strQuando = strQuando & "<small>" & rs("DATA_HORA_EFETIVACAO") & "</small>"
			end select
			strTurnoDestino = trim(rs("TURNO_DESTINO") & "")
%>
  <tr>
	<td class="celula"><%=rs("CODIGO")%></td>
	<td class="celula"><%=rs("MATRICULA")%></td>
	<td class="celula"><%=rs("NOMEALUNO")%></td>
	<td class="celula"><%=rs("UNIDADE_ORIGEM")%></td>
	<td class="celula"><%=rs("TURMA_ORIGEM")%><br><small>ano <%=rs("ANO_LETIVO")%></small></td>
	<td class="celula"><%=rs("UNIDADE_DESTINO")%></td>
	<td class="celula"><%=rs("TURMA_DESTINO")%><br><small>ano <%=rs("ANO_DESTINO")%><%if strTurnoDestino <> "" then%> - <%=strTurnoDestino%><%end if%></small></td>
	<td class="celula"><%=rs("USUARIO_INCL")%><br><small><%=rs("DATA_HORA_INCL")%></small></td>
	<td class="celula"><%=strDescSit%></td>
	<td class="celula"><%=strQuando%></td>
  </tr>
<%
			rs.movenext
		wend
%>
  <tr>
	<td align="left" colspan="10" class="celula">
		► <strong>Total de TIP: <%=cont%></strong>
		&nbsp;&nbsp;|&nbsp;&nbsp; Aguardando efetivação: <strong><%=qtdP%></strong>
		&nbsp;&nbsp;|&nbsp;&nbsp; Efetivadas: <strong><%=qtdE%></strong>
		&nbsp;&nbsp;|&nbsp;&nbsp; Canceladas: <strong><%=qtdC%></strong>
	</td>
  </tr>
<%
	else
%>
  <tr>
	<td height="48" colspan="10" align="center" class="celula"><br><br>
		<font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font>
		<%if trim(session("strMensagemRelatorioNaoEncontrado") & "") = "" then%><font color="#993300">Nenhuma TIP encontrada para os filtros informados.</font><%end if%>
		<br><br>
	</td>
  </tr>
<%
	end if
	rs.close
%>
</table>
<%if request("exportar") = "" then %>
<script>
	aguarde.style.display="none";
</script>
<%end if %>
<%
if request("exportar") = "w" then 
	Response.ContentType = "application/vnd.ms-word"
	Response.AddHeader "content-disposition","attachment;filename=relatorioTIP.doc"
elseif request("exportar") = "e" then 
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "content-disposition","attachment;filename=relatorioTIP.xls"
end if
%>	
</body>
</html>
