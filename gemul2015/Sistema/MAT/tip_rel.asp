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
<link type="text/css" rel="stylesheet" href="../../estilo/Estilo_Impressao.css">
<style>
	.tip-tabela { width: 98%; margin: 0 auto; border-collapse: collapse; font-family: Verdana, Arial, sans-serif; font-size: 11px; }
	.tip-tabela td { padding: 3px 4px; border-bottom: 1px dotted #bbbbbb; vertical-align: top; }
	.tip-secao { font-weight: bold; padding-top: 10px !important; }
	.tip-rotulo { color: #333333; white-space: nowrap; width: 1%; padding-left: 24px !important; }
	.tip-valor { font-weight: bold; }
	.tip-assinatura { width: 98%; margin: 50px auto 0 auto; font-family: Verdana, Arial, sans-serif; font-size: 11px; }
	.tip-assinatura td { text-align: center; padding: 0 30px; }
	.tip-linha { border-top: 1px solid #000000; padding-top: 4px; }
	.tip-obs { width: 98%; margin: 25px auto 0 auto; font-family: Verdana, Arial, sans-serif; font-size: 11px; line-height: 1.5; }
	@media print { .tip-nao-imprime { display: none; } }
</style>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
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
	if intCodTip > 0 then
		sql = "SELECT TIP.CODIGO, TIP.ANO_LETIVO, TIP.DATA_HORA_INCL, TIP.USUARIO_INCL,"
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
			strUnidadeOrigem	= rs("UNIDADE_ORIGEM")
			strTurmaOrigem		= rs("TURMA_ORIGEM")
			strTurnoOrigem		= rs("TURNO_ORIGEM")
			strUnidadeDestino	= rs("UNIDADE_DESTINO")
			strBairroDestino	= rs("BAIRRO_DESTINO")
			strTurmaDestino		= rs("TURMA_DESTINO")
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

	strTituloRelatorio = "Comprovante de TIP<br>Transferência por Interesse Próprio"
%>
<div class="tip-nao-imprime" align="center" style="margin: 8px;">
	<button type="button" onClick="window.print()">Imprimir</button>
	<button type="button" onClick="window.close()">Fechar</button>
</div>

<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->

<%if not blnAchou then%>
	<p align="center"><strong>TIP não encontrada.</strong></p>
<%else%>
<table class="tip-tabela">
	<tr><td colspan="4" class="tip-secao">Nº DA TIP: <%=intCodTip%> &nbsp;&nbsp;&nbsp; Data: <%=tipTexto(strDataTip)%></td></tr>
	<tr>
		<td class="tip-rotulo">Origem:</td>
		<td colspan="3" class="tip-valor"><%=tipTexto(strUnidadeOrigem)%> &nbsp;-&nbsp; Turma: <%=tipTexto(strTurmaOrigem)%><%if trim(strTurnoOrigem & "") <> "" then%> (<%=tipTexto(strTurnoOrigem)%>)<%end if%></td>
	</tr>

	<tr><td colspan="4" class="tip-secao">MATRÍCULA DO ALUNO: <%=tipTexto(strMatricula)%></td></tr>

	<tr><td colspan="4" class="tip-secao">DADOS PESSOAIS:</td></tr>
	<tr>
		<td class="tip-rotulo">Nome:</td><td class="tip-valor"><%=tipTexto(strNomeAluno)%></td>
		<td class="tip-rotulo">Data de nascimento:</td><td class="tip-valor"><%=tipTexto(strNascimento)%></td>
	</tr>
	<tr>
		<td class="tip-rotulo">Nome da mãe:</td><td class="tip-valor"><%=tipTexto(strMae)%></td>
		<td class="tip-rotulo">Nome do responsável:</td><td class="tip-valor"><%=tipTexto(strResponsavel)%></td>
	</tr>
	<tr>
		<td class="tip-rotulo">Sexo:</td><td class="tip-valor"><%=tipTexto(strSexo)%></td>
		<td class="tip-rotulo">Telefone para contato:</td><td class="tip-valor"><%=tipTexto(strTelefone)%></td>
	</tr>

	<tr><td colspan="4" class="tip-secao">DADOS DO ENDEREÇO:</td></tr>
	<tr>
		<td class="tip-rotulo">Endereço:</td><td class="tip-valor"><%=tipTexto(strLogradouro)%></td>
		<td class="tip-rotulo">Número:</td><td class="tip-valor"><%=tipTexto(strNumero)%></td>
	</tr>
	<tr>
		<td class="tip-rotulo">Bairro:</td><td class="tip-valor"><%=tipTexto(strBairro)%></td>
		<td class="tip-rotulo">Complemento:</td><td class="tip-valor"><%=tipTexto(strComplemento)%></td>
	</tr>
	<tr>
		<td class="tip-rotulo">Município:</td><td class="tip-valor"><%=tipTexto(strCidade)%><%if trim(strUF & "") <> "" then%> - <%=tipTexto(strUF)%><%end if%></td>
		<td class="tip-rotulo">CEP:</td><td class="tip-valor"><%=tipTexto(strCep)%></td>
	</tr>

	<tr><td colspan="4" class="tip-secao">UNIDADE ESCOLAR DE DESTINO:</td></tr>
	<tr>
		<td class="tip-rotulo">Unidade:</td>
		<td colspan="3" class="tip-valor"><%=tipTexto(strUnidadeDestino)%><%if trim(strBairroDestino & "") <> "" then%> (<%=tipTexto(strBairroDestino)%>)<%end if%></td>
	</tr>
	<tr>
		<td class="tip-rotulo">Turma:</td><td class="tip-valor"><%=tipTexto(strTurmaDestino)%></td>
		<td class="tip-rotulo">Turno:</td><td class="tip-valor"><%=tipTexto(strTurnoDestino)%></td>
	</tr>
</table>

<table class="tip-assinatura">
	<tr>
		<td width="50%"><div class="tip-linha">Assinatura do aluno ou responsável</div></td>
		<td width="50%"><div class="tip-linha">Responsável da escola pelo preenchimento<br><small><%=tipTexto(strUsuarioTip)%></small></div></td>
	</tr>
</table>

<div class="tip-obs">
	<strong>Observações Importantes</strong><br><br>
	A TIP (Transferência por Interesse Próprio) foi <strong>efetivada</strong>: o aluno já está matriculado na
	<strong>unidade escolar de destino</strong> informada acima, na turma e turno indicados.<br>
	O aluno ou seu responsável deverá comparecer à unidade escolar de destino com os seguintes documentos:
	RG ou certidão de nascimento ou de casamento, comprovante de endereço e documento que comprove a sua escolaridade,
	como declaração de transferência ou histórico escolar.<br>
</div>
<%end if%>
</body>
</html>
