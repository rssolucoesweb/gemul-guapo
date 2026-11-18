<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "text/html"
response.Expires = -1
response.CacheControl = "no-cache"
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 30/10/2026
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo..........: Grava os períodos de funcionamento (MAT_CONFIGURACAO_PERIODO) do grupo
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_periodoFuncionalidade.asp"-->
<%
	function jsTexto(ByVal texto)
		texto = replace(texto & "", "\", "\\")
		texto = replace(texto, """", "\""")
		texto = replace(texto, vbcrlf, "\n")
		jsTexto = texto
	end function

	sub retorna(ByVal mensagem)
		%>
		<script>
			alert("<%=jsTexto(mensagem)%>");
			window.location = "mat_configuracao.asp";
		</script>
		<%
		response.end
	end sub

	'aaaa-mm-ddThh:mm  ->  "CONVERT(DATETIME, 'aaaa-mm-ddThh:mm:00', 126)" | "NULL" | "" (inválido)
	function cfgDataSql(ByVal valor)
		dim re
		valor = trim(valor & "")
		if valor = "" then
			cfgDataSql = "NULL"
			exit function
		end if
		set re = New RegExp
		re.Pattern = "^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(:\d{2})?$"
		cfgDataSql = ""
		if re.Test(valor) then
			if len(valor) = 16 then valor = valor & ":00"
			if isdate(replace(left(valor, 10), "-", "/")) then cfgDataSql = "CONVERT(DATETIME, '" & valor & "', 126)"
		end if
	end function

	intCodGrupo = 0
	if isnumeric(Session("CodGrupo") & "") and trim(Session("CodGrupo") & "") <> "" then intCodGrupo = clng(Session("CodGrupo"))
	if intCodGrupo = 0 then retorna "Grupo não identificado na sessão. Entre novamente no sistema."

	strUsuario = left(replace(trim(session("usuarioWeb") & ""), "'", ""), 50)

	vetFunc = periodoFuncionalidades()
	'coluna PERFIS_LIBERADOS existe?
	set rsCol = Server.CreateObject("adodb.recordset")
	rsCol.open "SELECT COL_LENGTH('dbo.MAT_CONFIGURACAO_PERIODO', 'PERFIS_LIBERADOS')", cnn
	blnColunaPerfis = not isnull(rsCol(0))
	rsCol.close
	set rsCol = nothing
	strSql = ""
	for i = 0 to ubound(vetFunc)
		strCod = vetFunc(i)(0)
		strDesc = replace(vetFunc(i)(1), "'", "''")
		strIniForm = trim(Request.Form("txtInicio_" & strCod))
		strFimForm = trim(Request.Form("txtFim_" & strCod))
		sqlIni = cfgDataSql(strIniForm)
		sqlFim = cfgDataSql(strFimForm)
		if sqlIni = "" or sqlFim = "" then retorna vetFunc(i)(1) & ": data inválida. Nada foi gravado."
		if strIniForm <> "" and strFimForm <> "" and strFimForm < strIniForm then retorna vetFunc(i)(1) & ": a data de fim deve ser maior ou igual à de início. Nada foi gravado."

		'perfis liberados fora do período (o site não tem login)
		strPerfisSql = "NULL"
		if strCod <> "SITE_MATRICULA" then
			strPerfis = periodoListaPerfis(Request.Form("cmbPerfis_" & strCod))
			if strPerfis <> "" then strPerfisSql = "'" & left(strPerfis, 200) & "'"
		end if
		if blnColunaPerfis then strSql = strSql & "UPDATE MAT_CONFIGURACAO_PERIODO SET PERFIS_LIBERADOS = " & strPerfisSql & " WHERE COD_GRUPO = " & intCodGrupo & " AND FUNCIONALIDADE = '" & strCod & "' AND ISNULL(PERFIS_LIBERADOS, '') <> ISNULL(" & strPerfisSql & ", '')" & vbcrlf

		strSql = strSql & "IF EXISTS (SELECT 1 FROM MAT_CONFIGURACAO_PERIODO WHERE COD_GRUPO = " & intCodGrupo & " AND FUNCIONALIDADE = '" & strCod & "')" & vbcrlf
		strSql = strSql & "	UPDATE MAT_CONFIGURACAO_PERIODO SET DATA_INICIO = " & sqlIni & ", DATA_FIM = " & sqlFim & ", USUARIO_ALTR = '" & strUsuario & "', DATA_HORA_ALTR = GETDATE()"
		strSql = strSql & " WHERE COD_GRUPO = " & intCodGrupo & " AND FUNCIONALIDADE = '" & strCod & "'" & vbcrlf
		strSql = strSql & "	AND (ISNULL(DATA_INICIO, '19000101') <> ISNULL(" & sqlIni & ", '19000101') OR ISNULL(DATA_FIM, '19000101') <> ISNULL(" & sqlFim & ", '19000101'))" & vbcrlf
		strSql = strSql & "ELSE" & vbcrlf
		strSql = strSql & "	INSERT INTO MAT_CONFIGURACAO_PERIODO (COD_GRUPO, FUNCIONALIDADE, DESCRICAO, DATA_INICIO, DATA_FIM, USUARIO_ALTR) VALUES ("
		strSql = strSql & intCodGrupo & ", '" & strCod & "', '" & strDesc & "', " & sqlIni & ", " & sqlFim & ", '" & strUsuario & "')" & vbcrlf
	next

	on error resume next
	cnn.BeginTrans
	cnn.Execute "SET NOCOUNT ON;" & vbcrlf & strSql
	if err.number <> 0 then
		strErro = err.description
		err.clear
		cnn.RollbackTrans
		on error goto 0
		retorna "Erro ao gravar: " & strErro
	end if
	cnn.CommitTrans
	on error goto 0

	retorna "Períodos de funcionamento gravados."
%>
