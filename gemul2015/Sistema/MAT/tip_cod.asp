<%
response.ContentType = "text/html"
Server.ScriptTimeout = 600
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo..........: TIP - Transferência por Interesse Próprio (um aluno)
	::	                    I = transferir para a turma de outra unidade da rede
	::	                    E = desfazer a TIP (SP_MAT_TipDesfaz)
	::	Mesma lógica da renovação (mat_renovacao_cod.asp), para o ANO SEGUINTE em OUTRA unidade:
	::	vínculo da origem (ano atual) passa a 'R'; o aluno entra na turma de destino (ano + 1)
	::	da outra unidade, com SCA_ALUNO_ANO_LETIVO do ano seguinte nessa unidade.
	::	Notas e faltas do ano cursado ficam na origem. Histórico escolar, observações e
	::	ocorrências são levados para a nova unidade (SP_MAT_TipCopiaHistorico).
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'---------------------------------------------------------------------
	' Controle de erros: a primeira falha interrompe as gravações seguintes
	' e, no final, toda a transação é desfeita.
	'---------------------------------------------------------------------
	blnErro = false
	strErro = ""

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
			if not rsId.eof then insereComCodigo = tipNumero(rsId("ID"))
			rsId.close
		end if
		set rsId = nothing
		on error goto 0
		if not blnErro then GravarLog comando
	end function

	function tipNumero(ByVal valor)
		tipNumero = 0
		if isnull(valor) then exit function
		valor = trim(cstr(valor))
		if valor <> "" and isnumeric(valor) then tipNumero = clng(valor)
	end function

	function sqlTexto(ByVal valor)
		sqlTexto = "'" & replace(trim(valor & ""), "'", "''") & "'"
	end function

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

	'Executa o aproveitamento de notas (mesma SP do recebimento por transferência).
	'A SP devolve Sucesso/Mensagem em vez de gerar erro.
	'Sucesso vem como BIT: o ADO entrega True/False (e não 1/0)
	function apSucesso(ByVal valor)
		apSucesso = false
		if isnull(valor) then exit function
		select case lcase(trim(cstr(valor)))
			case "true", "1", "-1", "verdadeiro" : apSucesso = true
		end select
	end function

	sub executaAproveitamento(ByVal comando)
		dim rsAp, strMsg
		if blnErro then exit sub
		strMsg = ""
		on error resume next
		set rsAp = Server.CreateObject("adodb.recordset")
		rsAp.open comando, cnn
		if err.number <> 0 then
			strMsg = err.description
			err.clear
		elseif rsAp.state = 0 then
			strMsg = "A SP de aproveitamento de notas não retornou resultado."
		elseif rsAp.eof then
			strMsg = "A SP de aproveitamento de notas não retornou informações."
		elseif not apSucesso(rsAp("Sucesso")) then
			strMsg = trim(rsAp("Mensagem") & "") & " (etapa: " & trim(rsAp("Etapa") & "") & ")"
		end if
		if rsAp.state <> 0 then rsAp.close
		set rsAp = nothing
		on error goto 0
		if strMsg <> "" then
			registraErro "Erro ao aproveitar as notas da unidade de origem: " & strMsg
		else
			GravarLog comando
		end if
	end sub

	sub gravaOcorrenciaEm(ByVal codEmpresa, ByVal ano, ByVal semestre, ByVal texto)
		dim s
		s = "INSERT INTO SCA_OCORRENCIA (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)"
		s = s & " VALUES (" & codEmpresa & ", " & intCodAluno & ", " & ano & ", " & semestre & ", getdate(), null, " & sqlTexto(texto) & ", " & sqlTexto(strUsuario) & ")"
		executa s
	end sub

	'Inclui o controle de situação e guarda o código para o Excluir apagar depois
	sub gravaControleSituacao(ByVal codTip, ByVal codEmpresa, ByVal ano, ByVal semestre, ByVal codSituacao)
		dim s, codControle
		s = "INSERT INTO SCA_CONTROLE_SITUACAO_ALUNO (COD_ALUNO, COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO, USUARIO_INCL)"
		s = s & " VALUES (" & intCodAluno & ", " & codEmpresa & ", " & ano & ", " & semestre & ", " & codSituacao & ", getdate(), " & sqlTexto(strUsuario) & ")"
		codControle = insereComCodigo(s)
		if not blnErro and codControle > 0 then
			executa "INSERT INTO MAT_TIP_BKP_CONTROLE (COD_TIP, CODIGO) VALUES (" & codTip & ", " & codControle & ")"
		end if
	end sub

	'---------------------------------------------------------------------
	' Dados recebidos
	'---------------------------------------------------------------------
	acao			= ucase(Trim(Request.QueryString("acao")))
	intCodEmp		= tipNumero(Session("CodEmpresa"))		'unidade atual (origem)
	intAnoLetivo	= tipNumero(Session("strAnoLetivo"))
	'TIP é para o ANO SEGUINTE: origem = ano letivo atual, destino = ano letivo + 1
	intAnoLetivoDestino	= tipNumero(Request.Form("txtAnoLetivoDestino"))
	if intAnoLetivo > 0 and intAnoLetivoDestino <> intAnoLetivo + 1 then intAnoLetivoDestino = intAnoLetivo + 1
	strUsuario		= trim(session("usuarioWeb") & "")
	intCodAluno		= tipNumero(Request.Form("txtCodAluno"))
	strMatricula	= Trim(Request.Form("txtMatricula"))
	intEmpDestino	= tipNumero(Request.Form("cmbEmpresaTip"))
	intTurmaDestino	= tipNumero(Request.Form("cmbTurmaTip"))

	if acao <> "I" and acao <> "E" then registraErro "Ação inválida."
	if intCodEmp = 0 or intAnoLetivo = 0 then registraErro "Unidade ou ano letivo não informado."

	cnn.begintrans

	'=====================================================================
	' I - TIP: transfere o aluno para a turma de destino da outra unidade
	'=====================================================================
	if acao = "I" and not blnErro then

		if intCodAluno = 0 then registraErro "Informe o aluno."
		if intEmpDestino = 0 then registraErro "Selecione a unidade escolar de destino."
		if intTurmaDestino = 0 then registraErro "Selecione a turma de destino."
		if not blnErro and intEmpDestino = intCodEmp then registraErro "A unidade de destino deve ser diferente da unidade atual."

		if not blnErro then
			strNomeAluno = primeiroValor("SELECT NOMEALUNO FROM SCA_ALUNO WHERE CODIGO = " & intCodAluno) & ""
			if strNomeAluno = "" then registraErro "Aluno não encontrado."
		end if

		'Uma TIP por aluno no ano
		if not blnErro then
			if tipNumero(primeiroValor("SELECT COUNT(*) FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivo)) > 0 then
				registraErro "O aluno " & strNomeAluno & " já tem uma TIP em " & intAnoLetivo & ". Para fazer outra, exclua a TIP atual."
			end if
		end if

		'Aluno com renovação de matrícula feita a partir deste ano não pode fazer TIP
		if not blnErro then
			if tipNumero(primeiroValor("SELECT COUNT(*) FROM SCA_ALUNO_RENOVACAO WHERE COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivo)) > 0 then
				registraErro "O aluno " & strNomeAluno & " já tem renovação de matrícula a partir de " & intAnoLetivo & " e não pode fazer TIP. Para fazer a TIP, exclua a renovação."
			end if
		end if

		'Turma atual: vínculo ATIVO mais recente na unidade atual
		if not blnErro then
			sql = "SELECT TOP 1 AT.COD_TURMA, T.Cod_Turno, ISNULL(T.Cod_Semestre, 3) AS Cod_Semestre"
			sql = sql & " FROM SCA_ALUNO_TURMA AT INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.COD_TURMA"
			sql = sql & " WHERE AT.COD_EMPRESA = " & intCodEmp & " AND AT.COD_ALUNO = " & intCodAluno
			sql = sql & " AND AT.ANO_LETIVO = " & intAnoLetivo & " AND AT.SITUACAO = 'A'"
			sql = sql & " ORDER BY AT.CODIGO DESC"
			rs.open sql, cnn
			if not rs.eof then
				intTurmaOrigem		= tipNumero(rs("COD_TURMA"))
				intTurnoOrigem		= tipNumero(rs("Cod_Turno"))
				intSemestreOrigem	= tipNumero(rs("Cod_Semestre"))
			end if
			rs.close

			intSitAluno = tipNumero(primeiroValor("SELECT TOP 1 COD_SITUACAOALUNO FROM SCA_CONTROLE_SITUACAO_ALUNO WHERE COD_EMPRESA = " & intCodEmp & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivo & " ORDER BY CODIGO DESC"))
			if intSitAluno = 0 then intSitAluno = 1
			if intTurmaOrigem = 0 or intSitAluno <> 1 then
				registraErro "O aluno " & strNomeAluno & " não está ativo em uma turma desta unidade em " & intAnoLetivo & ". Somente alunos ativos podem fazer TIP."
			end if
		end if

		'Turma de destino: da unidade escolhida, do ano letivo e ativa
		if not blnErro then
			sql = "SELECT T.Cod_Turno, ISNULL(T.Cod_Semestre, 3) AS Cod_Semestre FROM SCA_TURMA T"
			sql = sql & " WHERE T.Cod_Turma = " & intTurmaDestino & " AND T.Cod_Empresa = " & intEmpDestino
			sql = sql & " AND T.AnoLetivo = " & intAnoLetivoDestino & " AND T.Situacao = 'A'"
			rs.open sql, cnn
			if not rs.eof then
				intTurnoDestino		= tipNumero(rs("Cod_Turno"))
				intSemestreDestino	= tipNumero(rs("Cod_Semestre"))
			else
				registraErro "A turma de destino não pertence à unidade escolhida ou não está ativa em " & intAnoLetivoDestino & "."
			end if
			rs.close
		end if

		'Não pode já ter disciplinas na turma de destino (evita misturar com lançamentos antigos)
		if not blnErro then
			if tipNumero(primeiroValor("SELECT COUNT(*) FROM SCA_ALUNO_DISCIPLINA WHERE COD_ALUNO = " & intCodAluno & " AND COD_TURMA = " & intTurmaDestino)) > 0 then
				registraErro "O aluno " & strNomeAluno & " já tem disciplinas na turma de destino. Verifique antes de fazer a TIP."
			end if
		end if

		if not blnErro then
			strUnidadeOrigem = primeiroValor("SELECT RAZAOSOCIAL FROM SEG_EMPRESA WHERE CODIGO = " & intCodEmp) & ""
			strUnidadeDestino = primeiroValor("SELECT RAZAOSOCIAL FROM SEG_EMPRESA WHERE CODIGO = " & intEmpDestino) & ""
			intSequencia = tipNumero(primeiroValor("SELECT MAX(SEQUENCIA) FROM SCA_ALUNO_TURMA WHERE COD_TURMA = " & intTurmaDestino & " AND COD_EMPRESA = " & intEmpDestino)) + 1

			'Registro da TIP (primeiro, para ter o código usado no backup)
			sql = "INSERT INTO SCA_TRANSFERENCIA_INTERESSE_PROPRIO (ANO_LETIVO, ANO_LETIVO_DESTINO, SEMESTRE, COD_ALUNO, COD_EMPRESA, COD_EMPRESA_DESTINO,"
			sql = sql & " COD_TURMA, COD_TURMA_DESTINO, COD_TURNO, COD_TURNO_DESTINO, USUARIO_INCL, DATA_HORA_INCL)"
			sql = sql & " VALUES (" & intAnoLetivo & ", " & intAnoLetivoDestino & ", " & intSemestreOrigem & ", " & intCodAluno & ", " & intCodEmp & ", " & intEmpDestino & ","
			sql = sql & " " & intTurmaOrigem & ", " & intTurmaDestino & ", " & intTurnoOrigem & ", " & intTurnoDestino & ", " & sqlTexto(strUsuario) & ", getdate())"
			intCodTip = insereComCodigo(sql)
			if not blnErro and intCodTip = 0 then registraErro "Não foi possível obter o código da TIP."

			'Cópia do que será alterado (usada pelo Excluir para desfazer)
			executaSP "EXEC SP_MAT_TipBackup " & intCodTip

			'--- ORIGEM (ano atual): igual à renovação, o vínculo ativo passa a 'R'.
			'    O ano que o aluno cursou na origem NÃO vira "Transferido" (não altera ata/resultado);
			'    notas e faltas desse ano ficam na origem.
			executa "UPDATE SCA_ALUNO_TURMA SET SITUACAO = 'R', DATA_SITUACAO = getdate() WHERE COD_EMPRESA = " & intCodEmp & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivo & " AND SITUACAO = 'A'"
			gravaOcorrenciaEm intCodEmp, intAnoLetivo, intSemestreOrigem, "TIP - transferência por interesse próprio para " & strUnidadeDestino & " em " & intAnoLetivoDestino

			'--- Vaga na turma de destino
			executa "UPDATE SCA_TURMA SET VagasMatriculasUtilizadas = ISNULL(VagasMatriculasUtilizadas, 0) + 1 WHERE Cod_Turma = " & intTurmaDestino

			'--- DESTINO: aluno entra na turma da outra unidade

			sql = "INSERT INTO SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO)"
			sql = sql & " VALUES (" & intEmpDestino & ", " & intCodAluno & ", " & intTurmaDestino & ", " & intSequencia & ", " & intAnoLetivoDestino & ", " & intSemestreDestino & ", 'A', getdate())"
			executa sql

			sql = "INSERT INTO SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO)"
			sql = sql & " VALUES (" & intEmpDestino & ", " & intAnoLetivoDestino & ", " & intSemestreDestino & ", " & intCodAluno & ", " & intTurmaDestino & ", 1, getdate())"	'1 = ATIVO
			executa sql

			gravaOcorrenciaEm intEmpDestino, intAnoLetivoDestino, intSemestreDestino, "Aluno recebido por transferência (TIP - transferência por interesse próprio) - origem: " & strUnidadeOrigem

			sql = "INSERT INTO SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA,"
			sql = sql & " COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO)"
			sql = sql & " SELECT T.COD_EMPRESA, " & intCodAluno & ", T.COD_TURMA, T.COD_TURMA, GD.COD_GRADECURRICULARDISCIPLINA,"
			sql = sql & " GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA, 'CR'"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " WHERE T.COD_TURMA = " & intTurmaDestino
			sql = sql & " AND T.COD_EMPRESA = " & intEmpDestino
			sql = sql & " AND G.SITUACAO = 'A'"
			sql = sql & " AND NOT EXISTS (SELECT 1 FROM SCA_ALUNO_DISCIPLINA AD WHERE AD.COD_ALUNO = " & intCodAluno & " AND AD.COD_TURMA = T.COD_TURMA AND AD.COD_DISCIPLINA = GD.COD_DISCIPLINA)"
			executa sql

			'--- HISTÓRICO: leva para a nova unidade (a origem não é alterada)
			'Notas e faltas do ano cursado ficam na origem (o destino é o ano seguinte): sem aproveitamento.
			'Foto da turma de destino: o Excluir só é liberado se nada for lançado nela depois da TIP
			executaSP "EXEC SP_MAT_TipFotoDestino " & intCodTip
			'Histórico escolar, observações do histórico e ocorrências lançadas por usuário
			executaSP "EXEC SP_MAT_TipCopiaHistorico " & intCodTip

			gravaControleSituacao intCodTip, intEmpDestino, intAnoLetivoDestino, intSemestreDestino, 1	'1 = ATIVO

			'Ano letivo no destino (ano seguinte): reativa se já existir, senão cria com o endereço
			if tipNumero(primeiroValor("SELECT COUNT(*) FROM SCA_ALUNO_ANO_LETIVO WHERE COD_EMPRESA = " & intEmpDestino & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivoDestino)) > 0 then
				executa "UPDATE SCA_ALUNO_ANO_LETIVO SET SITUACAO = 'A', COD_SITUACAOALUNO = 1, DATA_SITUACAO = getdate(), DATAFASTAMENTO = NULL, DATAMATRICULA = CAST(GETDATE() AS DATE) WHERE COD_EMPRESA = " & intEmpDestino & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivoDestino
			elseif not blnErro then
				sql = "SELECT ISNULL(Logradouro,'') AS Logradouro, ISNULL(Numero_endereco,'') AS Numero_endereco, ISNULL(Comp_endereco,'') AS Comp_endereco,"
				sql = sql & " ISNULL(Bairroaluno,'') AS Bairroaluno, ISNULL(Cidaderesidencia,'') AS Cidaderesidencia, ISNULL(Ufresidencia,'') AS Ufresidencia, ISNULL(Cepresidencia,'') AS Cepresidencia"
				sql = sql & " FROM SCA_ALUNO WHERE CODIGO = " & intCodAluno
				rs.open sql, cnn
				sql = "INSERT INTO SCA_ALUNO_ANO_LETIVO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAMATRICULA, COD_SITUACAOALUNO, SITUACAO, DATA_SITUACAO,"
				sql = sql & " LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, BAIRROALUNO, CIDADERESIDENCIA, UFRESIDENCIA, CEPRESIDENCIA, USUARIO_INCL, DATA_HORA_INCL) VALUES ("
				sql = sql & intEmpDestino & ", " & intCodAluno & ", " & intAnoLetivoDestino & ", " & intSemestreDestino & ", CAST(GETDATE() AS DATE), 1, 'A', getdate(), "
				sql = sql & sqlTextoOuNulo(rs("Logradouro")) & ", " & sqlTextoOuNulo(rs("Numero_endereco")) & ", " & sqlTextoOuNulo(rs("Comp_endereco")) & ", "
				sql = sql & sqlTextoOuNulo(rs("Bairroaluno")) & ", " & sqlTextoOuNulo(rs("Cidaderesidencia")) & ", " & sqlTextoOuNulo(rs("Ufresidencia")) & ", "
				sql = sql & sqlTextoOuNulo(rs("Cepresidencia")) & ", " & sqlTexto(strUsuario) & ", getdate())"
				rs.close
				executa sql
			end if

			'Situação do aluno (a unidade do aluno no ano é o SCA_ALUNO_ANO_LETIVO do destino, gravado acima)
			executa "UPDATE SCA_ALUNO SET COD_SITUACAOALUNO = 1 WHERE CODIGO = " & intCodAluno

			strMensagem = "TIP do aluno " & strNomeAluno & " gravada com sucesso!"
		end if

	'=====================================================================
	' E - DESFAZER A TIP (SP_MAT_TipDesfaz)
	'	Bloqueado se já houver nota, falta ou avaliação na turma de destino.
	'=====================================================================
	elseif acao = "E" and not blnErro then

		intCodTip = tipNumero(Request.Form("txtCodTip"))
		if intCodTip = 0 then
			registraErro "TIP inválida."
		else
			'Dados da TIP antes de excluir (para a ocorrência)
			sql = "SELECT TIP.COD_ALUNO, TIP.COD_EMPRESA, TIP.COD_EMPRESA_DESTINO, TIP.ANO_LETIVO, ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO) AS ANO_LETIVO_DESTINO, ISNULL(TIP.SEMESTRE, 3) AS SEMESTRE, ED.RAZAOSOCIAL AS UNIDADE_DESTINO"
			sql = sql & " FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP LEFT JOIN SEG_EMPRESA ED ON ED.CODIGO = TIP.COD_EMPRESA_DESTINO"
			sql = sql & " WHERE TIP.CODIGO = " & intCodTip
			rs.open sql, cnn
			if not rs.eof then
				intAlunoTip		= tipNumero(rs("COD_ALUNO"))
				intEmpOrigemTip	= tipNumero(rs("COD_EMPRESA"))
				intAnoTip		= tipNumero(rs("ANO_LETIVO"))
				intAnoDestinoTip = tipNumero(rs("ANO_LETIVO_DESTINO"))
				intSemestreTip	= tipNumero(rs("SEMESTRE"))
				intEmpDestinoTip = tipNumero(rs("COD_EMPRESA_DESTINO"))
				strDestinoTip	= trim(rs("UNIDADE_DESTINO") & "")
			end if
			rs.close

			executaSP "EXEC SP_MAT_TipDesfaz " & intCodTip

			'Registra a exclusão como ocorrência nas DUAS unidades (origem, para onde o aluno voltou, e destino)
			if not blnErro and intAlunoTip > 0 then
				for each intEmpOcorrencia in Array(intEmpOrigemTip, intEmpDestinoTip)
					if intEmpOcorrencia > 0 then
						intAnoOcorrencia = intAnoTip
						if intEmpOcorrencia = intEmpDestinoTip then intAnoOcorrencia = intAnoDestinoTip
						sql = "INSERT INTO SCA_OCORRENCIA (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)"
						sql = sql & " VALUES (" & intEmpOcorrencia & ", " & intAlunoTip & ", " & intAnoOcorrencia & ", " & intSemestreTip & ", getdate(), null, "
						sql = sql & sqlTexto("TIP removida (transferência por interesse próprio para " & strDestinoTip & ") - aluno retornou à turma de origem") & ", " & sqlTexto(strUsuario) & ")"
						executa sql
					end if
				next
			end if
		end if
		strMensagem = "TIP excluída com sucesso. O aluno voltou para a turma de origem."
	end if

	'---------------------------------------------------------------------
	' Finaliza a transação
	'---------------------------------------------------------------------
	if blnErro then
		'a SP de aproveitamento pode ter desfeito a transação ao falhar
		on error resume next
		cnn.rollbackTrans
		err.clear
		on error goto 0
		%>
		<script>
			alert("ATENÇÃO: nenhuma alteração foi gravada.\n\n<%=jsTexto(strErro)%>");
			window.history.back();
		</script>
		<%
		response.end
	end if

	cnn.commitTrans
%>
<!-- Volta para a tela com o mesmo aluno -->
<form id="frmRetorno" name="frmRetorno" method="post" action="mat_tip.asp">
	<input type="hidden" name="txtMatricula" value="<%=server.htmlEncode(strMatricula)%>">
</form>
<script>
	alert("<%=jsTexto(strMensagem)%>");
	document.getElementById("frmRetorno").submit();
</script>
