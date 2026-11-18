<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "text/html"
Server.ScriptTimeout = 1200
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo..........: Gravação da renovação de matrícula
	::	                    I = renovar | E = desfazer a renovação
	::	Atualização 28/10/2026: mesmas regras de gravação da versão anterior, agora numa
	::	transação única (erro em qualquer aluno desfaz tudo), validação de aluno ativo
	::	e opção para desfazer a renovação.
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_tipDePara.asp"-->
<!--#include file="includes/inc_inscricaoSite.asp"-->
<!--#include file="../includes/inc_periodoFuncionalidade.asp"-->
<%
	'Fora do período de funcionamento (Matrícula > Configurações): não grava
	periodoBloqueiaGravacao "RENOVACAO"
%>
<%
	'---------------------------------------------------------------------
	' Controle de erros: a primeira falha interrompe as gravações seguintes
	' e, no final, toda a transação é desfeita.
	'---------------------------------------------------------------------
	blnErro = false
	strErro = ""

	function primeiroValorSemErro(ByVal s)
		dim r
		primeiroValorSemErro = ""
		on error resume next
		set r = cnn.Execute(s)
		if err.number = 0 then
			if not r.eof then primeiroValorSemErro = trim(r(0) & "")
			r.close
		end if
		err.clear
		on error goto 0
	end function

	sub registraErro(ByVal mensagem)
		if not blnErro then
			blnErro = true
			strErro = mensagem
		end if
	end sub

	sub executa(ByVal comando)
		if blnErro then exit sub
		on error resume next
		cnn.execute comando
		if err.number <> 0 then
			registraErro "Erro ao gravar no banco de dados: " & err.description
			err.clear
		end if
		on error goto 0
		if not blnErro then GravarLog comando
	end sub

	'Executa uma procedure: a mensagem de erro (RAISERROR) vai direto para o usuário
	sub executaSP(ByVal comando)
		dim strMsg
		if blnErro then exit sub
		on error resume next
		cnn.execute comando
		if err.number <> 0 then
			strMsg = err.description
			'remove prefixos do provedor, ex.: [Microsoft][ODBC SQL Server Driver][SQL Server]
			do while left(strMsg, 1) = "["
				if instr(strMsg, "]") = 0 then exit do
				strMsg = mid(strMsg, instr(strMsg, "]") + 1)
			loop
			registraErro strMsg
			err.clear
		end if
		on error goto 0
		if not blnErro then GravarLog comando
	end sub

	'Executa um INSERT e devolve o código gerado (SCOPE_IDENTITY)
	function insereComCodigo(ByVal comando)
		dim rsId
		insereComCodigo = 0
		if blnErro then exit function
		on error resume next
		set rsId = Server.CreateObject("adodb.recordset")
		rsId.open "SET NOCOUNT ON; " & comando & "; SELECT CAST(SCOPE_IDENTITY() AS INT) AS ID", cnn
		if err.number <> 0 then
			registraErro "Erro ao gravar no banco de dados: " & err.description
			err.clear
		else
			if not rsId.eof then insereComCodigo = renNumero(rsId("ID"))
			rsId.close
		end if
		set rsId = nothing
		on error goto 0
		if not blnErro then GravarLog comando
	end function

	function renNumero(ByVal valor)
		renNumero = 0
		if isnull(valor) then exit function
		valor = trim(cstr(valor))
		if valor <> "" and isnumeric(valor) then renNumero = clng(valor)
	end function

	function sqlTexto(ByVal valor)
		sqlTexto = "'" & replace(trim(valor & ""), "'", "''") & "'"
	end function

	'Texto ou NULL para o SQL
	function sqlTextoOuNulo(ByVal valor)
		valor = replace(trim(valor & ""), "'", "")
		if valor = "" or valor = "0" then
			sqlTextoOuNulo = "NULL"
		else
			sqlTextoOuNulo = "'" & valor & "'"
		end if
	end function

	function primeiroValor(ByVal consulta)
		dim rsValor
		primeiroValor = null
		set rsValor = Server.CreateObject("adodb.recordset")
		rsValor.open consulta, cnn
		if not rsValor.eof then primeiroValor = rsValor(0)
		rsValor.close
		set rsValor = nothing
	end function

	function jsTexto(ByVal texto)
		texto = replace(texto & "", "\", "\\")
		texto = replace(texto, """", "\""")
		texto = replace(texto, vbcrlf, "\n")
		texto = replace(texto, vbcr, "\n")
		texto = replace(texto, vblf, "\n")
		jsTexto = texto
	end function

	sub gravaOcorrencia(ByVal codAluno, ByVal anoLetivo, ByVal semestre, ByVal texto)
		dim s
		s = "INSERT INTO SCA_OCORRENCIA (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)"
		s = s & " VALUES (" & intCodEmp & ", " & codAluno & ", " & anoLetivo & ", " & semestre & ", getdate(), null, " & sqlTexto(texto) & ", " & sqlTexto(strUsuario) & ")"
		executa s
	end sub

	'---------------------------------------------------------------------
	' Dados recebidos
	'---------------------------------------------------------------------
	acao			= ucase(Trim(Request.QueryString("acao")))
	if acao = "" then acao = "I"	'a tela de renovação posta sem ?acao (Incluir)
	intCodEmp		= renNumero(Session("CodEmpresa"))
	strUsuario		= trim(session("usuarioWeb") & "")
	'Anos: campos da tela de renovação (txtAnoLetivoAnterior / txtAnoLetivoLocacao)
	intAnoOrigem	= renNumero(Request.Form("txtAnoLetivoAnterior"))
	if intAnoOrigem = 0 then intAnoOrigem = renNumero(Request.Form("txtAnoOrigem"))
	intAnoDestino	= renNumero(Request.Form("txtAnoLetivoLocacao"))
	if intAnoDestino = 0 then intAnoDestino = renNumero(Request.Form("txtAnoDestino"))
	intTurmaOrigem	= renNumero(Request.Form("cmbTurma"))
	intTurmaDestino	= renNumero(Request.Form("cmbTurmaRenovacao"))
	intQtde			= 0

	if acao <> "I" and acao <> "E" then registraErro "Ação inválida."
	if intCodEmp = 0 or intAnoOrigem = 0 or intAnoDestino = 0 then registraErro "Unidade ou ano letivo não informado."
	if intTurmaOrigem = 0 then registraErro "Selecione a turma de origem."

	'---------------------------------------------------------------------
	' Cada aluno (ou cada renovação, no Excluir) é gravado na SUA PRÓPRIA transação:
	' as tabelas ficam presas só pelo tempo de um aluno (menos bloqueio/deadlock com várias
	' escolas renovando ao mesmo tempo). Deadlock em um aluno: tenta de novo esse aluno (até 3x).
	' Um aluno com problema não impede os outros; a mensagem final lista os que não foram gravados.
	'---------------------------------------------------------------------
	strFalhas = ""
	intFalhas = 0

	sub abreAluno()
		blnErro = false
		strErro = ""
		cnn.begintrans
	end sub

	'fecha a transação do aluno; devolve true se deve tentar de novo (deadlock)
	function fechaAluno(ByVal tentativa)
		fechaAluno = false
		if blnErro then
			on error resume next
			cnn.rollbackTrans
			err.clear
			on error goto 0
			if instr(1, strErro, "deadlock", vbTextCompare) > 0 and tentativa < 3 then fechaAluno = true
		else
			cnn.commitTrans
		end if
	end function

	sub registraFalha(ByVal quem)
		intFalhas = intFalhas + 1
		strFalhas = strFalhas & vbLf & "- " & quem & ": " & strErro
	end sub

	sub mostraErroGeral()
		%>
		<script>
			alert("ATENÇÃO: nenhuma alteração foi gravada.\n\n<%=jsTexto(strErro)%>");
			window.history.back();
		</script>
		<%
		response.end
	end sub

	'=====================================================================
	' I - RENOVAR (mesmas regras da versão anterior da tela)
	'=====================================================================
	if acao = "I" and not blnErro then

		if intTurmaDestino = 0 then registraErro "Selecione a turma de destino."

		'Dados das turmas
		if not blnErro then
			sql = "SELECT T.Cod_Turma, T.AnoLetivo, ISNULL(T.Cod_Semestre, 3) AS Cod_Semestre, T.Cod_Turno, T.Cod_periodo, P.Cod_Curso"
			sql = sql & " FROM SCA_TURMA T INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = T.Cod_periodo"
			sql = sql & " WHERE T.Cod_Empresa = " & intCodEmp & " AND T.Cod_Turma IN (" & intTurmaOrigem & ", " & intTurmaDestino & ")"
			rs.open sql, cnn
			while not rs.eof
				if renNumero(rs("Cod_Turma")) = intTurmaOrigem then
					intAnoTurmaOrigem	= renNumero(rs("AnoLetivo"))
					intSemestreOrigem	= renNumero(rs("Cod_Semestre"))
					intCursoOrigem		= renNumero(rs("Cod_Curso"))
					intPeriodoOrigem	= renNumero(rs("Cod_periodo"))
					intTurnoOrigem		= renNumero(rs("Cod_Turno"))
				else
					intAnoTurmaDestino	= renNumero(rs("AnoLetivo"))
					intSemestreDestino	= renNumero(rs("Cod_Semestre"))
				end if
				rs.movenext
			wend
			rs.close
			if intAnoTurmaOrigem <> intAnoOrigem then registraErro "A turma de origem não é do ano letivo " & intAnoOrigem & "."
			if intAnoTurmaDestino <> intAnoDestino then registraErro "A turma de destino não é do ano letivo " & intAnoDestino & "."
		end if

		'Turma de destino: mesmo período (retido) ou o seguinte pelo de/para (MAT_TIP_DE_PARA); sem de/para, mesmo curso e período + 1
		if not blnErro then
			intCursoDestino = 0 : intPeriodoDestino = 0
			rs.open "SELECT T.Cod_periodo, P.Cod_Curso FROM SCA_TURMA T INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = T.Cod_periodo WHERE T.Cod_Turma = " & intTurmaDestino, cnn
			if not rs.eof then intCursoDestino = renNumero(rs("Cod_Curso")) : intPeriodoDestino = renNumero(rs("Cod_periodo"))
			rs.close
			blnDestinoOk = (intCursoDestino = intCursoOrigem and intPeriodoDestino = intPeriodoOrigem)
			vetDeParaRen = renDePara(intPeriodoOrigem)
			if isArray(vetDeParaRen) then
				if intCursoDestino = vetDeParaRen(0) and intPeriodoDestino = vetDeParaRen(1) then blnDestinoOk = true
			else
				if intCursoDestino = intCursoOrigem and intPeriodoDestino = intPeriodoOrigem + 1 then blnDestinoOk = true
			end if
			if not blnDestinoOk then registraErro "A turma de destino não é da mesma série nem da série seguinte (de/para) da turma de origem."
		end if

		vetAlunos = split(Request.Form("chkAluno"), ",")
		if ubound(vetAlunos) < 0 then registraErro "Nenhum aluno foi marcado."
		if blnErro then mostraErroGeral

		for each item in vetAlunos
		  intTentativa = 0
		  do
			intTentativa = intTentativa + 1
			abreAluno
			strNomeAluno = ""

			intCodAluno = renNumero(item)
			strNomeAluno = primeiroValor("SELECT NOMEALUNO FROM SCA_ALUNO WHERE CODIGO = " & intCodAluno) & ""
			if intCodAluno = 0 or strNomeAluno = "" then registraErro "Aluno inválido."

			'Só alunos ATIVOS: vínculo mais recente na turma de origem = 'A' e situação ativa no ano
			if not blnErro then
				strSitTurma = trim(primeiroValor("SELECT TOP 1 SITUACAO FROM SCA_ALUNO_TURMA WHERE COD_EMPRESA = " & intCodEmp & " AND COD_ALUNO = " & intCodAluno & " AND COD_TURMA = " & intTurmaOrigem & " ORDER BY CODIGO DESC") & "")
				intSitAluno = renNumero(primeiroValor("SELECT TOP 1 COD_SITUACAOALUNO FROM SCA_CONTROLE_SITUACAO_ALUNO WHERE COD_EMPRESA = " & intCodEmp & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoOrigem & " ORDER BY CODIGO DESC"))
				if intSitAluno = 0 then intSitAluno = 1
				if strSitTurma <> "A" or intSitAluno <> 1 then
					registraErro "O aluno " & strNomeAluno & " não está ativo na turma de origem. Somente alunos ativos podem ser renovados."
				end if
			end if

			'Aluno com TIP no ano não pode ser renovado
			if not blnErro then
				if renNumero(primeiroValor("SELECT COUNT(*) FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoOrigem & " AND ISNULL(SITUACAO, 'E') <> 'C'")) > 0 then
					registraErro "O aluno " & strNomeAluno & " tem TIP em " & intAnoOrigem & " e não pode ser renovado. Para renovar, exclua a TIP."
				end if
			end if

			'Aluno com solicitação de matrícula pelo site para o ano de destino não pode ser renovado
			if not blnErro then
				strInscricaoSite = inscricaoSiteDoAluno(intCodAluno, intAnoDestino)
				if strInscricaoSite <> "" then registraErro "já tem solicitação de matrícula pelo site para " & intAnoDestino & " (" & strInscricaoSite & ") e não pode ser renovado"
			end if

			'Ainda não renovado para o ano de destino
			if not blnErro then
				if renNumero(primeiroValor("SELECT COUNT(*) FROM SCA_ALUNO_RENOVACAO WHERE COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO_RENOVACAO = " & intAnoDestino)) > 0 then
					registraErro "O aluno " & strNomeAluno & " já foi renovado para " & intAnoDestino & ". Atualize a tela."
				end if
			end if

			if not blnErro then
				intSequencia = renNumero(primeiroValor("SELECT MAX(SEQUENCIA) FROM SCA_ALUNO_TURMA WHERE COD_TURMA = " & intTurmaDestino & " AND COD_EMPRESA = " & intCodEmp)) + 1

				'Registro da renovação (primeiro, para ter o código usado no backup)
				sql = "INSERT INTO SCA_ALUNO_RENOVACAO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_CURSO, COD_PERIODO, COD_TURNO, COD_TURMA,"
				sql = sql & " COD_TURMA_RENOVACAO, ANO_LETIVO_RENOVACAO, USUARIO_INCL, DATA_HORA_INCL, EFETIVADO, USUARIO_EFETIVACAO, DATA_HORA_EFETIVACAO)"
				sql = sql & " VALUES (" & intCodEmp & ", " & intCodAluno & ", " & intAnoOrigem & ", " & intSemestreOrigem & ", " & intCursoOrigem & ", " & intPeriodoOrigem & ", " & intTurnoOrigem & ", " & intTurmaOrigem & ","
				sql = sql & " " & intTurmaDestino & ", " & intAnoDestino & ", " & sqlTexto(strUsuario) & ", getdate(), 'S', " & sqlTexto(strUsuario) & ", getdate())"
				intCodRenovacao = insereComCodigo(sql)
				if not blnErro and intCodRenovacao = 0 then registraErro "Não foi possível obter o código da renovação do aluno " & strNomeAluno & "."

				'Cópia de tudo o que será apagado/alterado (usada pelo Excluir para desfazer)
				executaSP "EXEC SP_MAT_RenovacaoBackup " & intCodRenovacao & ", " & intCodAluno & ", " & intCodEmp & ", " & intAnoDestino

				'Vínculo atual passa a 'R' e o aluno entra na turma de destino
				'foi retirado pq na turma de origem ele vai ficar na turma para historico, caso precisa acessar o ano anterior poderá ter acesso ao aluno na turma
				'executa "UPDATE SCA_ALUNO_TURMA SET SITUACAO = 'R', DATA_SITUACAO = getdate() WHERE COD_EMPRESA = " & intCodEmp & " AND COD_ALUNO = " & intCodAluno & " AND SITUACAO = 'A'"
				executa "UPDATE SCA_TURMA SET VagasMatriculasUtilizadas = ISNULL(VagasMatriculasUtilizadas, 0) + 1 WHERE Cod_Turma = " & intTurmaDestino

				sql = "INSERT INTO SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO)"
				sql = sql & " VALUES (" & intCodEmp & ", " & intCodAluno & ", " & intTurmaDestino & ", " & intSequencia & ", " & intAnoDestino & ", " & intSemestreDestino & ", 'A', getdate())"
				executa sql

				sql = "INSERT INTO SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO)"
				sql = sql & " VALUES (" & intCodEmp & ", " & intAnoDestino & ", " & intSemestreDestino & ", " & intCodAluno & ", " & intTurmaDestino & ", 1, getdate())"	'1 = ATIVO (igual ao recebimento por transferência)
				executa sql

				'Limpa SOMENTE o que o aluno já tiver na TURMA DE DESTINO (ano de destino).
				'O histórico do ano de origem (disciplinas, notas e faltas) NÃO é apagado.
				'Notas e faltas antes das disciplinas, por causa da FK_SCA_NOTAS_FALTAS_SCA_ALUNO_DISCIPLINA.
				strADDestino = "SELECT AD.CODIGO FROM SCA_ALUNO_DISCIPLINA AD WHERE AD.COD_ALUNO = " & intCodAluno & " AND AD.COD_TURMA = " & intTurmaDestino
				executa "DELETE FROM SCA_FALTAS_DIARIA WHERE COD_ALUNO = " & intCodAluno & " AND COD_ALUNO_DISCIPLINA IN (" & strADDestino & ")"
				executa "DELETE FROM SCA_NOTAS_FALTAS WHERE COD_ALUNO = " & intCodAluno & " AND (ANO_LETIVO = " & intAnoDestino & " OR COD_ALUNO_DISCIPLINA IN (" & strADDestino & "))"
				executa "DELETE FROM SCA_ALUNO_DISCIPLINA WHERE COD_ALUNO = " & intCodAluno & " AND COD_TURMA = " & intTurmaDestino

				gravaOcorrencia intCodAluno, intAnoDestino, intSemestreDestino, "Renovação de matrícula"

				sql = "INSERT INTO SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA,"
				sql = sql & " COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO, usuario_incl, data_hora_incl, tela)"
				sql = sql & " SELECT T.COD_EMPRESA, " & intCodAluno & ", T.COD_TURMA, T.COD_TURMA, GD.COD_GRADECURRICULARDISCIPLINA,"
				sql = sql & " GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA, 'CR', " & sqlTexto(strUsuario) & ", GETDATE(), 'mat_renovacao_cod.asp'"
				sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
				sql = sql & " JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
				sql = sql & " JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
				sql = sql & " WHERE T.COD_TURMA = " & intTurmaDestino
				sql = sql & " AND T.COD_EMPRESA = " & intCodEmp
				sql = sql & " AND G.SITUACAO = 'A'"
				sql = sql & " AND GD.Omitir_Documentacao = 'N'"
				sql = sql & " AND NOT EXISTS (SELECT 1 FROM SCA_ALUNO_DISCIPLINA AD WHERE AD.COD_ALUNO = " & intCodAluno & " AND AD.COD_TURMA = T.COD_TURMA AND AD.COD_DISCIPLINA = GD.COD_DISCIPLINA)"
				executa sql

				sql = "INSERT INTO SCA_CONTROLE_SITUACAO_ALUNO (COD_ALUNO, COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO, USUARIO_INCL)"
				sql = sql & " VALUES (" & intCodAluno & ", " & intCodEmp & ", " & intAnoDestino & ", " & intSemestreDestino & ", 1, getdate(), " & sqlTexto(strUsuario) & ")"
				executa sql

				'Endereço do aluno no ano letivo
				executa "DELETE FROM SCA_ALUNO_ANO_LETIVO WHERE COD_ALUNO = " & intCodAluno & " AND COD_EMPRESA = " & intCodEmp & " AND ANO_LETIVO = " & intAnoDestino

				if not blnErro then
					sql = "SELECT ISNULL(Logradouro,'') AS Logradouro, ISNULL(Numero_endereco,'') AS Numero_endereco, ISNULL(Comp_endereco,'') AS Comp_endereco,"
					sql = sql & " ISNULL(Bairroaluno,'') AS Bairroaluno, ISNULL(Cidaderesidencia,'') AS Cidaderesidencia, ISNULL(Ufresidencia,'') AS Ufresidencia, ISNULL(Cepresidencia,'') AS Cepresidencia"
					sql = sql & " FROM SCA_ALUNO WHERE CODIGO = " & intCodAluno
					rs.open sql, cnn
					sql = "INSERT INTO SCA_ALUNO_ANO_LETIVO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAMATRICULA, COD_SITUACAOALUNO, SITUACAO, DATA_SITUACAO,"
					sql = sql & " LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, BAIRROALUNO, CIDADERESIDENCIA, UFRESIDENCIA, CEPRESIDENCIA, USUARIO_INCL, DATA_HORA_INCL) VALUES ("
					sql = sql & intCodEmp & ", " & intCodAluno & ", " & intAnoDestino & ", " & intSemestreDestino & ", CAST(GETDATE() AS DATE), 1, 'A', getdate(), "
					sql = sql & sqlTextoOuNulo(rs("Logradouro")) & ", " & sqlTextoOuNulo(rs("Numero_endereco")) & ", " & sqlTextoOuNulo(rs("Comp_endereco")) & ", "
					sql = sql & sqlTextoOuNulo(rs("Bairroaluno")) & ", " & sqlTextoOuNulo(rs("Cidaderesidencia")) & ", " & sqlTextoOuNulo(rs("Ufresidencia")) & ", "
					sql = sql & sqlTextoOuNulo(rs("Cepresidencia")) & ", " & sqlTexto(strUsuario) & ", getdate())"
					rs.close
					executa sql
				end if

				executa "UPDATE SCA_ALUNO SET COD_SITUACAOALUNO = 1 WHERE CODIGO = " & intCodAluno
			end if

			if not fechaAluno(intTentativa) then exit do
		  loop
			if blnErro then
				if strNomeAluno = "" then strNomeAluno = "aluno " & trim(item)
				registraFalha strNomeAluno
			else
				intQtde = intQtde + 1
			end if
		next

		strMensagem = intQtde & " aluno(s) renovado(s) com sucesso!"

	'=====================================================================
	' E - DESFAZER A RENOVAÇÃO (SP_MAT_RenovacaoDesfaz)
	'	Desfaz todas as inclusões/alterações da renovação e restaura o backup.
	'	Bloqueado se já houver nota, falta ou avaliação lançada no ano novo.
	'=====================================================================
	elseif acao = "E" and not blnErro then

		strCodigos = Trim(Request.Form("txtCodRenovacao"))
		if strCodigos = "" then strCodigos = Trim(Request.Form("chkRenovacao"))
		vetRen = split(strCodigos, ",")
		if ubound(vetRen) < 0 then registraErro "Nenhuma renovação foi marcada."
		if blnErro then mostraErroGeral

		for each item in vetRen
		  intTentativa = 0
		  do
			intTentativa = intTentativa + 1
			abreAluno
			intCodRen = renNumero(item)
			if intCodRen = 0 then
				registraErro "Renovação inválida."
			else
				'Renovação de aluno com TIP PENDENTE: é a vaga garantida dele se a TIP não for efetivada
				if renNumero(primeiroValorSemErro("SELECT COUNT(*) FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP INNER JOIN SCA_ALUNO_RENOVACAO R ON R.COD_ALUNO = TIP.COD_ALUNO AND R.ANO_LETIVO = TIP.ANO_LETIVO WHERE R.CODIGO = " & intCodRen & " AND TIP.SITUACAO = 'P'")) > 0 then
					registraErro "O aluno tem TIP pendente: a renovação é a vaga garantida dele se a TIP não for efetivada. Para excluir a renovação, exclua antes a TIP na tela de TIP."
				end if
				'Confere bloqueios (nota, falta ou avaliação no ano novo), apaga o que a renovação
				'inseriu e restaura o backup - na transação desta renovação
				executaSP "EXEC SP_MAT_RenovacaoDesfaz " & intCodRen
			end if
			if not fechaAluno(intTentativa) then exit do
		  loop
			if blnErro then
				strNomeRen = primeiroValorSemErro("SELECT A.NOMEALUNO FROM SCA_ALUNO_RENOVACAO R INNER JOIN SCA_ALUNO A ON A.CODIGO = R.COD_ALUNO WHERE R.CODIGO = " & renNumero(item))
				if strNomeRen = "" then strNomeRen = "renovação " & trim(item)
				registraFalha strNomeRen
			else
				intQtde = intQtde + 1
			end if
		next

		strMensagem = intQtde & " renovação(ões) desfeita(s) com sucesso."
	end if

	'---------------------------------------------------------------------
	' Finaliza a transação
	'---------------------------------------------------------------------
	'nenhum gravado: mostra os motivos e volta
	if intQtde = 0 then
		if intFalhas > 0 then strErro = mid(strFalhas, 2)
		if strErro = "" then strErro = "Nada foi gravado."
		mostraErroGeral
	end if
	if intFalhas > 0 then strMensagem = strMensagem & vbLf & vbLf & "ATENÇÃO: " & intFalhas & " não gravado(s):" & strFalhas
%>
<!-- Volta para a tela mantendo os filtros -->
<form id="frmRetorno" name="frmRetorno" method="post" action="mat_renovacao.asp">
	<%
	for each campo in Array("cmbSemestre", "cmbSemestreAlocacao", "cmbCurso", "cmbPeriodo", "cmbTurno", "cmbTurma", "cmbTurmaAlocacao", "cmbTurmaRenovacao")
		response.write "<input type=""hidden"" name=""" & campo & """ value=""" & server.htmlEncode(Request.Form(campo) & "") & """>" & vbcrlf
	next
	%>
</form>
<script>
	alert("<%=jsTexto(strMensagem)%>");
	document.getElementById("frmRetorno").submit();
</script>
