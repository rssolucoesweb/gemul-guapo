<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "text/html"
%>
<!--
	::	Transporte > Cadastro > Escola estadual - inclusão, alteração e exclusão (ste_escola_estadual)
	::	I: código informado (não é IDENTITY), não pode repetir
	::	A: altera nome, endereço, bairro, município e CEP (o código não muda)
	::	E: só exclui se a escola não estiver em ste_solicitacao_transporte nem em STE_ROTA_VINCULA_UNIDADE_SETORES
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
	acao			= ucase(Trim(Request.QueryString("acao")))
	strCodigo		= Trim(Request.Form("txtCodigo"))
	if acao = "I" then strCodigo = Trim(Request.Form("txtCodigoNovo"))
	strNome			= ucase(Trim(Request.Form("txtNome")))
	strEndereco		= ucase(Trim(Request.Form("txtEndereco")))
	strBairro		= ucase(Trim(Request.Form("txtBairro")))
	strMunicipio	= ucase(Trim(Request.Form("txtMunicipio")))
	strCep			= replace(replace(replace(Trim(Request.Form("txtCep")), "-", ""), ".", ""), " ", "")

	function eeSoDigitos(ByVal s)
		dim i
		eeSoDigitos = (len(s) > 0)
		for i = 1 to len(s)
			if instr("0123456789", mid(s, i, 1)) = 0 then eeSoDigitos = false
		next
	end function

	function eeSql(ByVal v)
		eeSql = "'" & replace(v & "", "'", "''") & "'"
	end function

	function eeJs(ByVal t)
		t = replace(t & "", "\", "\\")
		t = replace(t, """", "\""")
		t = replace(t, vbCrLf, "\n")
		eeJs = replace(t, vbLf, "\n")
	end function

	sub eeVolta(ByVal mensagem)
		%>
		<script>
			alert("<%=eeJs(mensagem)%>");
			window.history.back();
		</script>
		<%
		response.end
	end sub

	'Validações
	if acao <> "I" and acao <> "A" and acao <> "E" then eeVolta "Ação inválida."
	if not eeSoDigitos(strCodigo) or len(strCodigo) > 10 then eeVolta "Informe o código da escola (somente números)."
	if cdbl(strCodigo) > 2147483647 or cdbl(strCodigo) < 1 then eeVolta "Código inválido."
	intCodigo = clng(strCodigo)

	if acao <> "E" then
		if strNome = "" then eeVolta "Informe o nome da escola."
		if strEndereco = "" then eeVolta "Informe o endereço."
		if strBairro = "" then eeVolta "Informe o bairro."
		if strMunicipio = "" then eeVolta "Informe o município."
		if not eeSoDigitos(strCep) or len(strCep) <> 8 then eeVolta "Informe o CEP com 8 números."
		strNome = left(strNome, 100) : strEndereco = left(strEndereco, 50) : strBairro = left(strBairro, 50) : strMunicipio = left(strMunicipio, 50)
	end if

	function eeConta(ByVal s)
		dim r
		set r = cnn.Execute(s)
		eeConta = clng(r(0).Value)
		r.close
	end function

	blnExiste = (eeConta("SELECT COUNT(*) FROM ste_escola_estadual WHERE codigo_escola_estadual = " & intCodigo) > 0)

	if acao = "I" then
		if blnExiste then eeVolta "Já existe escola estadual com o código " & intCodigo & "."
		if eeConta("SELECT COUNT(*) FROM ste_escola_estadual WHERE nome = " & eeSql(strNome)) > 0 then eeVolta "Já existe escola estadual com o nome " & strNome & "."
		sql = "INSERT INTO ste_escola_estadual (codigo_escola_estadual, nome, endereco, municipio, bairro, cep) VALUES ("
		sql = sql & intCodigo & ", " & eeSql(strNome) & ", " & eeSql(strEndereco) & ", " & eeSql(strMunicipio) & ", " & eeSql(strBairro) & ", " & eeSql(strCep) & ")"
		strMensagem = "Escola estadual incluída com sucesso."

	elseif acao = "A" then
		if not blnExiste then eeVolta "Escola estadual não encontrada. Atualize a tela."
		if eeConta("SELECT COUNT(*) FROM ste_escola_estadual WHERE nome = " & eeSql(strNome) & " AND codigo_escola_estadual <> " & intCodigo) > 0 then eeVolta "Já existe outra escola estadual com o nome " & strNome & "."
		sql = "UPDATE ste_escola_estadual SET nome = " & eeSql(strNome) & ", endereco = " & eeSql(strEndereco) & ", municipio = " & eeSql(strMunicipio)
		sql = sql & ", bairro = " & eeSql(strBairro) & ", cep = " & eeSql(strCep) & " WHERE codigo_escola_estadual = " & intCodigo
		strMensagem = "Escola estadual alterada com sucesso."

	else
		if not blnExiste then eeVolta "Escola estadual não encontrada. Atualize a tela."
		intSolic = eeConta("SELECT COUNT(*) FROM ste_solicitacao_transporte WHERE codigo_escola_estadual = " & intCodigo)
		intSetor = eeConta("SELECT COUNT(*) FROM STE_ROTA_VINCULA_UNIDADE_SETORES WHERE codigo_escola_estadual = " & intCodigo)
		if intSolic > 0 or intSetor > 0 then
			eeVolta "Esta escola não pode ser excluída: está em " & intSolic & " solicitação(ões) de transporte e vinculada a " & intSetor & " setor(es)/rota(s)."
		end if
		sql = "DELETE FROM ste_escola_estadual WHERE codigo_escola_estadual = " & intCodigo
		strMensagem = "Escola estadual excluída com sucesso."
	end if

	on error resume next
	cnn.Execute sql
	strErro = ""
	if err.number <> 0 then strErro = err.description
	err.clear
	on error goto 0
	if strErro <> "" then eeVolta "Não foi possível gravar." & vbCrLf & strErro
	GravarLog sql
%>
<script>
	alert("<%=eeJs(strMensagem)%>");
	window.location = "ste_escola_estadual.asp";
</script>
