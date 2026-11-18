<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "text/html"
response.Expires = 0
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Comprovante da TIP - Transferência por Interesse Próprio
	::	Chamada...........: mat_tip_cad.asp (coluna Imprimir) -> mat_tip_rel.asp?txtCodTip=
-->
<html>
<head>
<title>GEMUL - Comprovante de TIP</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<style>
	.tip-caixa { width: 96%; margin: 18px auto 0 auto; border: 2px solid #333333; padding: 18px 26px 22px 26px;
		font-family: Arial, Helvetica, sans-serif; font-size: 14px; line-height: 2; color: #000000; box-sizing: border-box; }
	.tip-titulo { text-align: center; font-weight: bold; font-size: 16px; margin-bottom: 6px; line-height: 1.4; }
	.tip-paragrafo { text-align: justify; text-indent: 3em; margin: 0; }
	.tip-aviso { text-align: center; font-weight: bold; margin: 26px 0 26px 0; }
	.tip-data { margin: 0 0 34px 0; }
	.tip-assinaturas { width: 100%; border-collapse: collapse; }
	.tip-assinaturas td { width: 50%; vertical-align: bottom; padding: 0; }
	.tip-ass-bloco { display: inline-block; width: 300px; text-align: left; }
	.tip-ass-x { font-size: 28px; line-height: 1; display: block; margin-bottom: 2px; padding-left: 4px; }
	.tip-ass { border-top: 2px solid #000000; padding-top: 2px; font-size: 9px; line-height: 1.3; }
	.tip-ref { width: 96%; margin: 6px auto 0 auto; font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #555555; text-align: right; }
	@media print { .tip-nao-imprime { display: none; } }
</style>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	function tipNumero(ByVal valor)
		tipNumero = 0
		if isnull(valor) then exit function
		valor = trim(cstr(valor))
		if valor <> "" and isnumeric(valor) then tipNumero = clng(valor)
	end function

	function tipTexto(ByVal valor)
		tipTexto = server.htmlEncode(trim(valor & ""))
	end function

	intCodTip = tipNumero(Request("txtCodTip"))

	blnAchou = false
	'1ª emissão do comprovante de TIP pendente: início do prazo de 02 dias úteis (FN_MAT_TipPrazoConfirmacao)
	if intCodTip > 0 then
		cnn.execute "UPDATE SCA_TRANSFERENCIA_INTERESSE_PROPRIO SET DATA_EMISSAO_COMPROVANTE = GETDATE() WHERE CODIGO = " & intCodTip & " AND SITUACAO = 'P' AND DATA_EMISSAO_COMPROVANTE IS NULL"
	end if
	if intCodTip > 0 then
		sql = "SELECT TIP.CODIGO, TIP.ANO_LETIVO, ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO + 1) AS ANO_LETIVO_DESTINO, PD.Descricao AS PERIODO_DESTINO, TIP.DATA_HORA_INCL, TIP.USUARIO_INCL, ISNULL(TIP.SITUACAO, 'E') AS SITUACAO_TIP, TIP.DATA_HORA_EFETIVACAO, ISNULL(TIP.DATA_EMISSAO_COMPROVANTE, TIP.DATA_HORA_INCL) AS DATA_EMISSAO, dbo.FN_MAT_TipPrazoConfirmacao(TIP.CODIGO) AS PRAZO_CONFIRMACAO, TIP.DATA_HORA_CANCELAMENTO, TIP.MOTIVO_CANCELAMENTO,"
		sql = sql & " EO.RAZAOSOCIAL AS UNIDADE_ORIGEM,"
		sql = sql & " LTRIM(RTRIM(ISNULL(PO.Descricao,'') + ' ' + ISNULL(TOR.TurmaAluno,'') + ' ' + ISNULL(TOR.NomeTurma,''))) AS TURMA_ORIGEM, TUO.Desc_Turno AS TURNO_ORIGEM,"
		sql = sql & " ED.RAZAOSOCIAL AS UNIDADE_DESTINO, ED.BAIRRO AS BAIRRO_DESTINO,"
		sql = sql & " LTRIM(RTRIM(ISNULL(PD.Descricao,'') + ' ' + ISNULL(TDE.TurmaAluno,'') + ' ' + ISNULL(TDE.NomeTurma,''))) AS TURMA_DESTINO, TUD.Desc_Turno AS TURNO_DESTINO,"
		sql = sql & " A.MATRICULA, A.NOMEALUNO, A.DATANASCIMENTO, A.MAE, A.RESPONSAVEL, A.SexoAluno,"
		sql = sql & " A.FONECELULAR, A.FONERESIDENCIAL,"
		sql = sql & " A.LOGRADOURO, A.NUMERO_ENDERECO, A.COMP_ENDERECO, A.BAIRROALUNO, A.CIDADERESIDENCIA, UFR.SIGLA AS UF_RESIDENCIA, A.CEPRESIDENCIA"
		sql = sql & " FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP"
		sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = TIP.COD_ALUNO"
		sql = sql & " LEFT JOIN SCF_UF UFR ON CAST(UFR.CODIGO AS VARCHAR(10)) = CAST(A.UFRESIDENCIA AS VARCHAR(10)) OR UFR.SIGLA = CAST(A.UFRESIDENCIA AS VARCHAR(10))"
		sql = sql & " LEFT JOIN SEG_EMPRESA EO ON EO.CODIGO = TIP.COD_EMPRESA"
		sql = sql & " LEFT JOIN SEG_EMPRESA ED ON ED.CODIGO = TIP.COD_EMPRESA_DESTINO"
		sql = sql & " LEFT JOIN SCA_TURMA TOR ON TOR.Cod_Turma = TIP.COD_TURMA"
		sql = sql & " LEFT JOIN SCA_PERIODO PO ON PO.Cod_Periodo = TOR.Cod_periodo"
		sql = sql & " LEFT JOIN SCA_TURNO TUO ON TUO.Cod_Turno = TIP.COD_TURNO"
		sql = sql & " LEFT JOIN SCA_TURMA TDE ON TDE.Cod_Turma = TIP.COD_TURMA_DESTINO"
		sql = sql & " LEFT JOIN SCA_PERIODO PD ON PD.Cod_Periodo = TDE.Cod_periodo"
		sql = sql & " LEFT JOIN SCA_TURNO TUD ON TUD.Cod_Turno = TIP.COD_TURNO_DESTINO"
		sql = sql & " WHERE TIP.CODIGO = " & intCodTip
		rs.open sql, cnn
		if not rs.eof then
			blnAchou = true
			strAnoCab			= rs("ANO_LETIVO")
			strDataTip			= rs("DATA_HORA_INCL")
			strUsuarioTip		= rs("USUARIO_INCL")
			strSituacaoTip		= trim(rs("SITUACAO_TIP") & "")
			dtEmissao			= rs("DATA_EMISSAO")
			dtPrazo				= rs("PRAZO_CONFIRMACAO")
			strDataCancelamento	= rs("DATA_HORA_CANCELAMENTO")
			strMotivoCancelamento = trim(rs("MOTIVO_CANCELAMENTO") & "")
			strDataEfetivacao	= rs("DATA_HORA_EFETIVACAO")
			strUnidadeOrigem	= rs("UNIDADE_ORIGEM")
			strTurmaOrigem		= rs("TURMA_ORIGEM")
			strTurnoOrigem		= rs("TURNO_ORIGEM")
			strUnidadeDestino	= rs("UNIDADE_DESTINO")
			strBairroDestino	= rs("BAIRRO_DESTINO")
			strTurmaDestino		= rs("TURMA_DESTINO")
			strPeriodoDestino	= rs("PERIODO_DESTINO")
			strAnoDestino		= rs("ANO_LETIVO_DESTINO")
			strTurnoDestino		= rs("TURNO_DESTINO")
			strMatricula		= rs("MATRICULA")
			strNomeAluno		= rs("NOMEALUNO")
			strNascimento		= ""
			if isdate(rs("DATANASCIMENTO")) then strNascimento = FormataDataAp(rs("DATANASCIMENTO"))
			strMae				= rs("MAE")
			strResponsavel		= rs("RESPONSAVEL")
			select case ucase(trim(rs("SexoAluno") & ""))
				case "M" : strSexo = "Masculino"
				case "F" : strSexo = "Feminino"
				case else : strSexo = trim(rs("SexoAluno") & "")
			end select
			strTelefone = trim(rs("FONECELULAR") & "")
			if trim(rs("FONERESIDENCIAL") & "") <> "" then
				if strTelefone <> "" then strTelefone = strTelefone & " / "
				strTelefone = strTelefone & trim(rs("FONERESIDENCIAL") & "")
			end if
			strLogradouro		= rs("LOGRADOURO")
			strNumero			= rs("NUMERO_ENDERECO")
			strComplemento		= rs("COMP_ENDERECO")
			strBairro			= rs("BAIRROALUNO")
			strCidade			= rs("CIDADERESIDENCIA")
			strUF				= rs("UF_RESIDENCIA")
			strCep				= rs("CEPRESIDENCIA")
		end if
		rs.close
	end if

	strTituloRelatorio = "Transferência por Interesse Próprio"
%>
<div class="tip-nao-imprime" align="center" style="margin: 8px;">
	<button type="button" onClick="window.print()">Imprimir</button>
	<button type="button" onClick="window.close()">Fechar</button>
</div>

<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->

<%if not blnAchou then%>
	<p align="center"><strong>TIP não encontrada.</strong></p>
<%else%>
<%
	'Gênero pelo sexo do aluno: O estudante ... contemplado | A estudante ... contemplada
	strArtigo = "O(a)" : strContemplado = "contemplado(a)"
	if strSexo = "Masculino" then strArtigo = "O" : strContemplado = "contemplado"
	if strSexo = "Feminino" then strArtigo = "A" : strContemplado = "contemplada"

	'Série/ano solicitado: período da turma de destino (ex.: 5º ANO), turma, turno e unidade
	strSerieDestino = trim(strPeriodoDestino & "")
	if strSerieDestino = "" then strSerieDestino = trim(strTurmaDestino & "")

	vetMeses = array("janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro")
	'data da 1ª emissão (reimpressões mantêm a mesma data e o mesmo prazo)
	dtEmissaoComprovante = date()
	if isdate(dtEmissao) then dtEmissaoComprovante = cdate(dtEmissao)
	strDataEmissao = right("0" & day(dtEmissaoComprovante), 2) & " de " & vetMeses(month(dtEmissaoComprovante) - 1) & " de " & year(dtEmissaoComprovante)
	strPrazo = ""
	if isdate(dtPrazo) then strPrazo = right("0" & day(dtPrazo), 2) & "/" & right("0" & month(dtPrazo), 2) & "/" & year(dtPrazo)
%>
<%if strSituacaoTip = "C" then%>
<div class="tip-caixa" style="border-color:#b00020; color:#b00020; text-align:center; line-height:1.6;">
	<strong>TIP CANCELADA</strong><br>
	<%=tipTexto(strMotivoCancelamento)%><%if not isnull(strDataCancelamento) then%> - cancelada em <%=tipTexto(strDataCancelamento)%><%end if%>
</div>
<%end if%>
<div class="tip-caixa"<%if strSituacaoTip = "C" then%> style="opacity:0.45;"<%end if%>>
	<div class="tip-titulo">COMPROVANTE DE CONTEMPLAÇÃO DE VAGA - TRANSFERÊNCIA POR INTERESSE PRÓPRIO</div>
	<p class="tip-paragrafo">
		<%=strArtigo%> estudante <strong><%=tipTexto(strNomeAluno)%></strong>, foi <%=strContemplado%> com a vaga solicitada para o
		<strong><%=tipTexto(strSerieDestino)%></strong>
		(turma <%=tipTexto(strTurmaDestino)%><%if trim(strTurnoDestino & "") <> "" then%>, turno <%=tipTexto(strTurnoDestino)%><%end if%>,
		ano letivo <%=tipTexto(strAnoDestino)%>) na unidade escolar <strong><%=tipTexto(strUnidadeDestino)%></strong>,
		através do processo de <strong>TIP - Transferência por Interesse Próprio</strong>.
	</p>
	<p class="tip-paragrafo">
		Informamos que o(a) responsável terá o prazo de <strong>02 (dois) dias úteis</strong>, a contar da data de emissão deste
		comprovante, para efetuar a confirmação da matrícula junto à secretaria da Unidade Escolar<%if strPrazo <> "" and strSituacaoTip = "P" then%>
		(<strong>até <%=strPrazo%></strong>)<%end if%>.
	</p>
	<div class="tip-aviso">O não comparecimento no prazo implicará na perda da vaga.</div>
	<div class="tip-data">Anápolis, <%=strDataEmissao%>.</div>
	<br>
	<table class="tip-assinaturas">
		<tr>
			<td align="left"><div class="tip-ass-bloco"><div class="tip-ass">Ass. Secretaria da Unidade Escolar</div></div></td>
			<td align="right"><div class="tip-ass-bloco"><div class="tip-ass">Ass. Pai/Responsável</div></div></td>
		</tr>
	</table>
</div>
<div class="tip-ref">
	TIP nº <%=intCodTip%> &nbsp;|&nbsp; Matrícula: <%=tipTexto(strMatricula)%> &nbsp;|&nbsp; Origem: <%=tipTexto(strUnidadeOrigem)%>
	&nbsp;|&nbsp; <%if strSituacaoTip = "P" then%>Aguardando efetivação<%elseif strSituacaoTip = "C" then%>Cancelada<%else%>Efetivada<%if not isnull(strDataEfetivacao) then%> em <%=tipTexto(strDataEfetivacao)%><%end if%><%end if%>
</div>
<%end if%>
</body>
</html>
