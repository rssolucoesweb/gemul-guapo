<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "application/json"
response.Expires = -1
response.CacheControl = "no-cache"
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
'::	Transporte > Vincula aluno a rota - REDE ESTADUAL (AJAX, resposta JSON)
'::	CPF      : procura a solicitação do CPF no ano letivo e devolve os dados
'::	BUSCAR   : devolve os dados de uma solicitação pelo código (botão Editar)
'::	GRAVAR   : inclui ou altera o aluno estadual e já vincula à rota (situação D)
'::	VINCULAR : solicitação do site (R, sem rota) passa para a rota escolhida (D)
'::	EXCLUIR  : tira da rota. Pedido do site (usuario_incl INTERNET) volta a ser solicitação (R);
'::	           cadastro feito pelo GEMUL é apagado (igual ao Excluir do aluno municipal)

	acao = ucase(trim(Request.QueryString("acao")))
	strUsuario = left(replace(trim(Session("usuarioWeb") & ""), "'", ""), 50)
	strAno = trim(Request.Form("txtAnoLetivo"))
	if strAno = "" then strAno = Session("strAnoLetivo") & ""

	function veJs(ByVal t)
		dim i, c, r
		r = ""
		t = t & ""
		for i = 1 to len(t)
			c = mid(t, i, 1)
			if c = "\" then
				r = r & "\\"
			elseif c = """" then
				r = r & "\"""
			elseif AscW(c) < 32 then
				r = r & " "
			elseif AscW(c) > 126 or AscW(c) < 0 then
				r = r & "\u" & right("000" & lcase(hex(AscW(c) and &HFFFF&)), 4)
			else
				r = r & c
			end if
		next
		veJs = r
	end function

	sub veFim(ByVal ok, ByVal mensagem, ByVal extra)
		dim strOk
		if ok then strOk = "true" else strOk = "false"
		Response.Clear
		Response.Write "{""ok"":" & strOk & ",""mensagem"":""" & veJs(mensagem) & """" & extra & "}"
		Response.End
	end sub

	function veSql(ByVal v)
		v = trim(v & "")
		if v = "" then veSql = "NULL" else veSql = "'" & replace(v, "'", "''") & "'"
	end function

	function veDigitos(ByVal s)
		dim i, c, r
		r = ""
		for i = 1 to len(s & "")
			c = mid(s, i, 1)
			if instr("0123456789", c) > 0 then r = r & c
		next
		veDigitos = r
	end function

	function veCpfValido(ByVal c)
		dim i, s, d1, d2
		veCpfValido = false
		if len(c) <> 11 then exit function
		if c = string(11, left(c, 1)) then exit function
		s = 0
		for i = 1 to 9 : s = s + clng(mid(c, i, 1)) * (11 - i) : next
		d1 = (s * 10) mod 11 : if d1 = 10 then d1 = 0
		s = 0
		for i = 1 to 10 : s = s + clng(mid(c, i, 1)) * (12 - i) : next
		d2 = (s * 10) mod 11 : if d2 = 10 then d2 = 0
		veCpfValido = (d1 = clng(mid(c, 10, 1)) and d2 = clng(mid(c, 11, 1)))
	end function

	'Dados de uma solicitação em JSON (para preencher o formulário)
	function veDados(ByVal sqlWhere)
		dim r, d, nasc
		veDados = ""
		set r = cnn.Execute("SELECT TOP 1 S.*, R.Descricao AS rota_desc, EE.nome AS escola_desc FROM ste_solicitacao_transporte S" & _
			" LEFT JOIN ste_rota R ON R.Cod_Rota = S.cod_rota LEFT JOIN ste_escola_estadual EE ON EE.codigo_escola_estadual = S.codigo_escola_estadual" & _
			" WHERE " & sqlWhere & " AND ISNULL(S.excluido, 'N') <> 'S' ORDER BY S.codigo DESC")
		if not r.eof then
			nasc = ""
			if isdate(r("data_nascimento")) then d = cdate(r("data_nascimento")) : nasc = right("0" & day(d), 2) & "/" & right("0" & month(d), 2) & "/" & year(d)
			veDados = ",""dados"":{""codigo"":""" & r("codigo") & """,""cod_aluno"":""" & veJs(r("cod_aluno")) & """,""nome"":""" & veJs(trim(r("nome") & "")) & """" & _
				",""cpf"":""" & veJs(trim(r("cpf") & "")) & """,""nascimento"":""" & nasc & """,""mae"":""" & veJs(trim(r("mae") & "")) & """,""sexo"":""" & veJs(trim(r("sexo") & "")) & """" & _
				",""cep"":""" & veJs(trim(r("cep") & "")) & """,""logradouro"":""" & veJs(trim(r("Logradouro") & "")) & """,""numero"":""" & veJs(trim(r("NumeroEndereco") & "")) & """" & _
				",""complemento"":""" & veJs(trim(r("ComplementoEndereco") & "")) & """,""bairro"":""" & veJs(trim(r("bairro") & "")) & """,""cidade"":""" & veJs(trim(r("cidade") & "")) & """" & _
				",""uf"":""" & veJs(trim(r("uf") & "")) & """,""email"":""" & veJs(trim(r("email") & "")) & """,""contato"":""" & veJs(trim(r("Contato") & "")) & """" & _
				",""celular"":""" & veJs(trim(r("Celular") & "")) & """,""fonepai"":""" & veJs(trim(r("FonePai") & "")) & """,""fonemae"":""" & veJs(trim(r("FoneMae") & "")) & """" & _
				",""unidade_consumidora"":""" & veJs(trim(r("unidade_consumidora_energia") & "")) & """,""situacao"":""" & veJs(trim(r("Situacao") & "")) & """" & _
				",""escola"":""" & veJs(trim(r("codigo_escola_estadual") & "")) & """,""escola_desc"":""" & veJs(trim(r("escola_desc") & "")) & """" & _
				",""turno"":""" & veJs(trim(r("turno_estadual") & "")) & """,""rota"":""" & veJs(trim(r("cod_rota") & "")) & """,""rota_desc"":""" & veJs(trim(r("rota_desc") & "")) & """}"
		end if
		r.close
	end function

	if not isnumeric(strAno) or strAno = "" then veFim false, "Ano letivo não identificado. Atualize a tela.", ""
	intAno = clng(strAno)

	select case acao

	'=====================================================================
	case "CPF"
		strCpf = veDigitos(Request.Form("txtCpfEst"))
		if not veCpfValido(strCpf) then veFim false, "CPF inválido.", ""
		strDados = veDados("S.cpf = '" & strCpf & "' AND S.ano_letivo = " & intAno)
		if strDados = "" then veFim true, "", ",""existe"":false"
		veFim true, "", ",""existe"":true" & strDados

	'=====================================================================
	case "BUSCAR"
		intCod = trim(Request.Form("codigo"))
		if not isnumeric(intCod) or intCod = "" then veFim false, "Solicitação inválida.", ""
		strDados = veDados("S.codigo = " & clng(intCod))
		if strDados = "" then veFim false, "Solicitação não encontrada. Atualize a tela.", ""
		veFim true, "", ",""existe"":true" & strDados

	'=====================================================================
	case "GRAVAR", "VINCULAR"
		intEscola = trim(Request.Form("cmbEscolaEstadual"))
		strTurno = ucase(trim(Request.Form("cmbTurnoEstadual")))
		intRota = trim(Request.Form("cmbRotaEstadual"))
		if not isnumeric(intEscola) or intEscola = "" or intEscola = "0" then veFim false, "Selecione a escola estadual.", ""
		if instr("|MATUTINO|VESPERTINO|NOTURNO|INTEGRAL|", "|" & strTurno & "|") = 0 then veFim false, "Selecione o turno.", ""
		if not isnumeric(intRota) or intRota = "" or intRota = "0" then veFim false, "Selecione a rota.", ""
		intEscola = clng(intEscola) : intRota = clng(intRota)

		if acao = "VINCULAR" then
			intCod = trim(Request.Form("codigo"))
			if not isnumeric(intCod) or intCod = "" then veFim false, "Solicitação inválida.", ""
			sql = "UPDATE ste_solicitacao_transporte SET cod_rota = " & intRota & ", Situacao = 'D', codigo_escola_estadual = " & intEscola & ", turno_estadual = '" & strTurno & "'," & _
				" data_efetivacao = GETDATE(), usuario_efetivacao = '" & strUsuario & "', ano_letivo = ISNULL(ano_letivo, " & intAno & ")" & _
				" WHERE codigo = " & clng(intCod) & " AND cod_aluno IS NULL AND ISNULL(excluido, 'N') <> 'S'"
			set rsQ = cnn.Execute("SET NOCOUNT ON; " & sql & "; SELECT @@ROWCOUNT")
			intQtd = clng(rsQ(0).Value)
			rsQ.close
			if intQtd = 0 then veFim false, "Solicitação não encontrada. Atualize a tela.", ""
			GravarLog sql
			veFim true, "Aluno vinculado à rota.", ",""codigo"":""" & clng(intCod) & """"
		end if

		'---- GRAVAR (inclusão ou alteração)
		intCod = trim(Request.Form("txtCodSolicitacaoEst"))
		strCpf = veDigitos(Request.Form("txtCpfEst"))
		strNome = ucase(trim(Request.Form("txtNomeEst")))
		strNasc = trim(Request.Form("txtNascimentoEst"))
		strMae = ucase(trim(Request.Form("txtMaeEst")))
		strSexo = ucase(trim(Request.Form("cmbSexoEst")))
		strContato = trim(Request.Form("txtContatoEst"))
		strCelular = trim(Request.Form("txtCelularEst"))
		strFoneMae = trim(Request.Form("txtFoneMaeEst"))
		strFonePai = trim(Request.Form("txtFonePaiEst"))
		strEmail = ucase(trim(Request.Form("txtEmailEst")))
		strCep = veDigitos(Request.Form("txtCepEst"))
		strLogradouro = ucase(trim(Request.Form("txtLogradouroEst")))
		strNumero = ucase(trim(Request.Form("txtNumeroEst")))
		strComplemento = ucase(trim(Request.Form("txtComplementoEst")))
		strBairro = ucase(trim(Request.Form("txtBairroEst")))
		strCidade = ucase(trim(Request.Form("txtCidadeEst")))
		strUf = ucase(trim(Request.Form("txtUfEst")))
		strUnidade = trim(Request.Form("txtUnidadeConsumidoraEst"))

		if not veCpfValido(strCpf) then veFim false, "CPF inválido.", ""
		if strNome = "" then veFim false, "Informe o nome do aluno.", ""
		'dd/mm/aaaa montada à mão (não depende do idioma do servidor)
		if len(strNasc) <> 10 or len(veDigitos(strNasc)) <> 8 or mid(strNasc, 3, 1) <> "/" or mid(strNasc, 6, 1) <> "/" then veFim false, "Informe a data de nascimento (dd/mm/aaaa).", ""
		intDia = clng(left(strNasc, 2)) : intMes = clng(mid(strNasc, 4, 2)) : intAnoNasc = clng(right(strNasc, 4))
		if intMes < 1 or intMes > 12 or intDia < 1 or intDia > 31 then veFim false, "Data de nascimento inválida.", ""
		dtNasc = DateSerial(intAnoNasc, intMes, intDia)
		if day(dtNasc) <> intDia then veFim false, "Data de nascimento inválida.", ""
		if dtNasc > date() or year(dtNasc) < 1950 then veFim false, "Data de nascimento inválida.", ""
		strNascIso = year(dtNasc) & "-" & right("0" & month(dtNasc), 2) & "-" & right("0" & day(dtNasc), 2)
		if strMae = "" then veFim false, "Informe o nome da mãe.", ""
		if strSexo <> "M" and strSexo <> "F" then veFim false, "Informe o sexo.", ""
		if len(veDigitos(strContato)) < 10 then veFim false, "Informe o telefone de contato com DDD.", ""
		if len(strCep) <> 8 then veFim false, "Informe o CEP com 8 números.", ""
		strCep = left(strCep, 5) & "-" & right(strCep, 3)
		if strLogradouro = "" then veFim false, "Informe o endereço.", ""
		if strBairro = "" then veFim false, "Informe o bairro.", ""
		if strCidade = "" then veFim false, "Informe o município.", ""
		if len(strUf) <> 2 then veFim false, "Informe a UF.", ""
		if strUnidade = "" then veFim false, "Informe a unidade consumidora (energia).", ""

		'CPF já usado no ano por outra solicitação
		set rsQ = cnn.Execute("SELECT TOP 1 codigo, cod_aluno FROM ste_solicitacao_transporte WHERE cpf = '" & strCpf & "' AND ano_letivo = " & intAno & " AND ISNULL(excluido, 'N') <> 'S' ORDER BY codigo DESC")
		intCodExistente = "" : blnMunicipal = false
		if not rsQ.eof then intCodExistente = cstr(rsQ("codigo")) : blnMunicipal = not isnull(rsQ("cod_aluno"))
		rsQ.close
		if blnMunicipal then veFim false, "Este CPF é de aluno da rede municipal com transporte em " & intAno & ". Use a rede Municipal.", ""
		if intCod = "" and intCodExistente <> "" then veFim false, "Este CPF já tem solicitação em " & intAno & ". Clique na lupa do CPF para carregar os dados.", ""
		if intCod <> "" then
			if not isnumeric(intCod) then veFim false, "Solicitação inválida.", ""
			if intCodExistente <> "" and intCodExistente <> cstr(clng(intCod)) then veFim false, "Este CPF já está em outra solicitação de " & intAno & ".", ""
		end if

		if intCod = "" then
			sql = "SET NOCOUNT ON; INSERT INTO ste_solicitacao_transporte (ano_letivo, chave, cod_aluno, nome, cpf, data_nascimento, mae, sexo, cep, Logradouro, NumeroEndereco, ComplementoEndereco," & _
				" bairro, cidade, uf, email, Contato, Celular, FonePai, FoneMae, Cod_empresa, Cod_turma, Situacao, usuario_incl, data_hora_incl, data_efetivacao, usuario_efetivacao," & _
				" cod_rota, codigo_escola_estadual, turno_estadual, unidade_consumidora_energia) VALUES (" & _
				intAno & ", CAST(NEWID() AS VARCHAR(50)), NULL, " & veSql(left(strNome, 100)) & ", '" & strCpf & "', '" & strNascIso & "', " & veSql(left(strMae, 100)) & ", '" & strSexo & "', " & _
				veSql(strCep) & ", " & veSql(left(strLogradouro, 100)) & ", " & veSql(left(strNumero, 50)) & ", " & veSql(left(strComplemento, 100)) & ", " & _
				veSql(left(strBairro, 100)) & ", " & veSql(left(strCidade, 100)) & ", " & veSql(strUf) & ", " & veSql(left(strEmail, 200)) & ", " & _
				veSql(left(strContato, 30)) & ", " & veSql(left(strCelular, 30)) & ", " & veSql(left(strFonePai, 30)) & ", " & veSql(left(strFoneMae, 30)) & ", NULL, NULL, 'D', '" & strUsuario & "', GETDATE(), GETDATE(), '" & strUsuario & "', " & _
				intRota & ", " & intEscola & ", '" & strTurno & "', " & veSql(left(strUnidade, 50)) & "); SELECT SCOPE_IDENTITY()"
			set rsQ = cnn.Execute(sql)
			intNovo = clng(rsQ(0).Value)
			rsQ.close
			GravarLog sql
			veFim true, "Aluno estadual cadastrado e vinculado à rota.", ",""codigo"":""" & intNovo & """,""novo"":true"
		else
			sql = "UPDATE ste_solicitacao_transporte SET nome = " & veSql(left(strNome, 100)) & ", cpf = '" & strCpf & "', data_nascimento = '" & strNascIso & "', mae = " & veSql(left(strMae, 100)) & _
				", sexo = '" & strSexo & "', cep = " & veSql(strCep) & ", Logradouro = " & veSql(left(strLogradouro, 100)) & ", NumeroEndereco = " & veSql(left(strNumero, 50)) & _
				", ComplementoEndereco = " & veSql(left(strComplemento, 100)) & ", bairro = " & veSql(left(strBairro, 100)) & ", cidade = " & veSql(left(strCidade, 100)) & ", uf = " & veSql(strUf) & _
				", email = " & veSql(left(strEmail, 200)) & ", Contato = " & veSql(left(strContato, 30)) & ", Celular = " & veSql(left(strCelular, 30)) & ", FonePai = " & veSql(left(strFonePai, 30)) & _
				", FoneMae = " & veSql(left(strFoneMae, 30)) & ", unidade_consumidora_energia = " & veSql(left(strUnidade, 50)) & _
				", codigo_escola_estadual = " & intEscola & ", turno_estadual = '" & strTurno & "', cod_rota = " & intRota & ", Situacao = 'D'" & _
				", data_efetivacao = GETDATE(), usuario_efetivacao = '" & strUsuario & "', ano_letivo = ISNULL(ano_letivo, " & intAno & ")" & _
				" WHERE codigo = " & clng(intCod) & " AND cod_aluno IS NULL"
			cnn.Execute sql
			GravarLog sql
			veFim true, "Dados do aluno estadual alterados e vinculados à rota.", ",""codigo"":""" & clng(intCod) & """,""novo"":false"
		end if

	'=====================================================================
	case "EXCLUIR"
		intCod = trim(Request.Form("codigo"))
		if not isnumeric(intCod) or intCod = "" then veFim false, "Solicitação inválida.", ""
		set rsQ = cnn.Execute("SELECT usuario_incl FROM ste_solicitacao_transporte WHERE codigo = " & clng(intCod) & " AND cod_aluno IS NULL")
		if rsQ.eof then
			rsQ.close
			veFim false, "Solicitação não encontrada. Atualize a tela.", ""
		end if
		strIncl = ucase(trim(rsQ("usuario_incl") & ""))
		rsQ.close
		cnn.Execute "DELETE FROM SCA_ROTA_VICULA_ALUNO WHERE cod_solicitacao_transporte = " & clng(intCod)
		if strIncl = "INTERNET" then
			sql = "UPDATE ste_solicitacao_transporte SET cod_rota = NULL, Situacao = 'R', data_efetivacao = NULL, usuario_efetivacao = NULL WHERE codigo = " & clng(intCod)
			cnn.Execute sql
			GravarLog sql
			veFim true, "Aluno retirado da rota. O pedido do site voltou para Solicitado.", ",""voltou_solicitado"":true"
		else
			sql = "DELETE FROM ste_solicitacao_transporte WHERE codigo = " & clng(intCod)
			cnn.Execute sql
			GravarLog sql
			veFim true, "Aluno estadual excluído do transporte escolar.", ",""voltou_solicitado"":false"
		end if

	case else
		veFim false, "Ação inválida.", ""
	end select
%>
