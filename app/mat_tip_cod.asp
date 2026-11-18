<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "text/html"
Server.ScriptTimeout = 600
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo..........: TIP - Transferência por Interesse Próprio (um aluno)
	::	                    I = incluir (origem): TIP pendente (reserva a vaga como 'alocado aguardando efetivação')
	::	                    E = excluir TIP pendente (origem)
	::	                    F = efetivar (destino, mat_efetivacao.asp): faz a transferência abaixo
	::	                    D = desfazer TIP efetivada (destino): SP_MAT_TipDesfaz
	::	Efetivação: mesma lógica da renovação (mat_renovacao_cod.asp), para o ANO SEGUINTE em OUTRA unidade:
	::	vínculo da origem (ano atual) passa a 'R'; o aluno entra na turma de destino (ano + 1)
	::	da outra unidade, com SCA_ALUNO_ANO_LETIVO do ano seguinte nessa unidade.
	::	Notas e faltas do ano cursado ficam na origem. Histórico escolar, observações e
	::	ocorrências são levados para a nova unidade (SP_MAT_TipCopiaHistorico).
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_tipDePara.asp"-->
<!--#include file="includes/inc_inscricaoSite.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_periodoFuncionalidade.asp"-->
<%
	acao = ucase(Trim(Request.QueryString("acao")))
	'Fora do período de funcionamento (Matrícula > Configurações): não grava
	'inclusão/exclusão = período da TIP | efetivar/desfazer (tela de efetivação) = período da efetivação
	if acao = "F" or acao = "D" then
		periodoBloqueiaGravacao "EFETIVACAO"
	else
		periodoBloqueiaGravacao "TIP"
	end if
%>
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

	'Variáveis compartilhadas com as subs abaixo: precisam ser declaradas aqui.
	'(no VBScript, variável não declarada que só é preenchida dentro de uma sub vira LOCAL da sub
	' e o valor se perde ao sair dela)
	Dim intCodTip, intCodAluno, strNomeAluno, intEmpOrigem, intEmpDestino, intAnoLetivo, intAnoLetivoDestino
	Dim intTurmaOrigem, intTurnoOrigem, intSemestreOrigem, intSitAluno, intTurmaTipOrigem
	Dim intTurmaDestino, intTurnoDestino, intSemestreDestino, intSemestreTip, intSequencia
	Dim strSituacaoTip, strUnidadeOrigem, strUnidadeDestino, intCodRenovacaoTip, strMotivoRen

	'---------------------------------------------------------------------
	' Transferência do aluno (o que a inclusão fazia antes): usada na EFETIVAÇÃO
	' Variáveis: intCodTip, intCodAluno, strNomeAluno, intEmpOrigem, intAnoLetivo, intTurmaOrigem,
	'            intSemestreOrigem, intEmpDestino, intAnoLetivoDestino, intTurmaDestino, intSemestreDestino
	'---------------------------------------------------------------------
	sub processaTransferenciaTip()
		dim s
		if blnErro then exit sub
		strUnidadeOrigem = primeiroValor("SELECT RAZAOSOCIAL FROM SEG_EMPRESA WHERE CODIGO = " & intEmpOrigem) & ""
		strUnidadeDestino = primeiroValor("SELECT RAZAOSOCIAL FROM SEG_EMPRESA WHERE CODIGO = " & intEmpDestino) & ""
		intSequencia = tipNumero(primeiroValor("SELECT MAX(SEQUENCIA) FROM SCA_ALUNO_TURMA WHERE COD_TURMA = " & intTurmaDestino & " AND COD_EMPRESA = " & intEmpDestino)) + 1

		'Cópia do que será alterado (usada pelo Desfazer)
		executaSP "EXEC SP_MAT_TipBackup " & intCodTip

		'--- ORIGEM (ano atual): igual à renovação, o aluno CONTINUA ATIVO na turma de origem até o fim do ano
		'    (aparece no diário, notas, faltas, boletim, ata e relatórios do ano de origem). A TIP vale para o
		'    ANO SEGUINTE na outra unidade; a vaga da origem para o ano seguinte não é afetada.
		'    Só numa TIP do MESMO ano (ano destino = ano origem) o vínculo da origem passa a 'R'.
		if intAnoLetivoDestino = intAnoLetivo then
			executa "UPDATE SCA_ALUNO_TURMA SET SITUACAO = 'R', DATA_SITUACAO = getdate() WHERE COD_EMPRESA = " & intEmpOrigem & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivo & " AND SITUACAO = 'A'"
		end if
		gravaOcorrenciaEm intEmpOrigem, intAnoLetivo, intSemestreOrigem, "TIP - transferência por interesse próprio para " & strUnidadeDestino & " em " & intAnoLetivoDestino & " (efetivada pela unidade de destino)"

		'--- Vaga na turma de destino: o aluno passa a contar em "Aluno em turma" (VagasMatriculasUtilizadas).
		'    Enquanto pendente, a TIP conta em "Alocados aguardando efetivação" (mat_turmas_con.asp).
		executa "UPDATE SCA_TURMA SET VagasMatriculasUtilizadas = ISNULL(VagasMatriculasUtilizadas, 0) + 1 WHERE Cod_Turma = " & intTurmaDestino

		'--- DESTINO: aluno entra na turma da outra unidade
		s = "INSERT INTO SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO)"
		s = s & " VALUES (" & intEmpDestino & ", " & intCodAluno & ", " & intTurmaDestino & ", " & intSequencia & ", " & intAnoLetivoDestino & ", " & intSemestreDestino & ", 'A', getdate())"
		executa s

		s = "INSERT INTO SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO)"
		s = s & " VALUES (" & intEmpDestino & ", " & intAnoLetivoDestino & ", " & intSemestreDestino & ", " & intCodAluno & ", " & intTurmaDestino & ", 1, getdate())"	'1 = ATIVO
		executa s

		gravaOcorrenciaEm intEmpDestino, intAnoLetivoDestino, intSemestreDestino, "Aluno recebido por transferência (TIP - transferência por interesse próprio) - origem: " & strUnidadeOrigem

		s = "INSERT INTO SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA,"
		s = s & " COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO, usuario_incl, data_hora_incl, tela)"
		s = s & " SELECT T.COD_EMPRESA, " & intCodAluno & ", T.COD_TURMA, T.COD_TURMA, GD.COD_GRADECURRICULARDISCIPLINA,"
		s = s & " GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA, 'CR', " & sqlTexto(strUsuario) & ", GETDATE(), 'mat_tip_cod.asp'"
		s = s & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
		s = s & " JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
		s = s & " JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
		s = s & " WHERE T.COD_TURMA = " & intTurmaDestino
		s = s & " AND T.COD_EMPRESA = " & intEmpDestino
		s = s & " AND G.SITUACAO = 'A'"
		s = s & " AND GD.Omitir_Documentacao = 'N'"
		s = s & " AND NOT EXISTS (SELECT 1 FROM SCA_ALUNO_DISCIPLINA AD WHERE AD.COD_ALUNO = " & intCodAluno & " AND AD.COD_TURMA = T.COD_TURMA AND AD.COD_DISCIPLINA = GD.COD_DISCIPLINA)"
		executa s

		'--- HISTÓRICO: leva para a nova unidade (a origem não é alterada)
		'Foto da turma de destino: o Desfazer só é liberado se nada for lançado nela depois da efetivação
		executaSP "EXEC SP_MAT_TipFotoDestino " & intCodTip
		'Histórico escolar, observações do histórico e ocorrências lançadas por usuário
		executaSP "EXEC SP_MAT_TipCopiaHistorico " & intCodTip

		gravaControleSituacao intCodTip, intEmpDestino, intAnoLetivoDestino, intSemestreDestino, 1	'1 = ATIVO

		'Ano letivo no destino (ano seguinte): reativa se já existir, senão cria com o endereço
		if tipNumero(primeiroValor("SELECT COUNT(*) FROM SCA_ALUNO_ANO_LETIVO WHERE COD_EMPRESA = " & intEmpDestino & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivoDestino)) > 0 then
			executa "UPDATE SCA_ALUNO_ANO_LETIVO SET SITUACAO = 'A', COD_SITUACAOALUNO = 1, DATA_SITUACAO = getdate(), DATAFASTAMENTO = NULL, DATAMATRICULA = CAST(GETDATE() AS DATE) WHERE COD_EMPRESA = " & intEmpDestino & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivoDestino
		elseif not blnErro then
			s = "SELECT ISNULL(Logradouro,'') AS Logradouro, ISNULL(Numero_endereco,'') AS Numero_endereco, ISNULL(Comp_endereco,'') AS Comp_endereco,"
			s = s & " ISNULL(Bairroaluno,'') AS Bairroaluno, ISNULL(Cidaderesidencia,'') AS Cidaderesidencia, ISNULL(Ufresidencia,'') AS Ufresidencia, ISNULL(Cepresidencia,'') AS Cepresidencia"
			s = s & " FROM SCA_ALUNO WHERE CODIGO = " & intCodAluno
			rs.open s, cnn
			s = "INSERT INTO SCA_ALUNO_ANO_LETIVO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAMATRICULA, COD_SITUACAOALUNO, SITUACAO, DATA_SITUACAO,"
			s = s & " LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, BAIRROALUNO, CIDADERESIDENCIA, UFRESIDENCIA, CEPRESIDENCIA, USUARIO_INCL, DATA_HORA_INCL) VALUES ("
			s = s & intEmpDestino & ", " & intCodAluno & ", " & intAnoLetivoDestino & ", " & intSemestreDestino & ", CAST(GETDATE() AS DATE), 1, 'A', getdate(), "
			s = s & sqlTextoOuNulo(rs("Logradouro")) & ", " & sqlTextoOuNulo(rs("Numero_endereco")) & ", " & sqlTextoOuNulo(rs("Comp_endereco")) & ", "
			s = s & sqlTextoOuNulo(rs("Bairroaluno")) & ", " & sqlTextoOuNulo(rs("Cidaderesidencia")) & ", " & sqlTextoOuNulo(rs("Ufresidencia")) & ", "
			s = s & sqlTextoOuNulo(rs("Cepresidencia")) & ", " & sqlTexto(strUsuario) & ", getdate())"
			rs.close
			executa s
		end if

		'Situação do aluno (a unidade do aluno no ano é o SCA_ALUNO_ANO_LETIVO do destino, gravado acima)
		executa "UPDATE SCA_ALUNO SET COD_SITUACAOALUNO = 1 WHERE CODIGO = " & intCodAluno

		'TIP efetivada
		executa "UPDATE SCA_TRANSFERENCIA_INTERESSE_PROPRIO SET SITUACAO = 'E', DATA_HORA_EFETIVACAO = getdate(), USUARIO_EFETIVACAO = " & sqlTexto(strUsuario) & " WHERE CODIGO = " & intCodTip
	end sub

	'Renovação do aluno na unidade de origem, do ano da TIP para o ano de destino (0 = não tem)
	function renovacaoDaOrigem()
		renovacaoDaOrigem = tipNumero(primeiroValor("SELECT TOP 1 CODIGO FROM SCA_ALUNO_RENOVACAO WHERE COD_ALUNO = " & intCodAluno & " AND COD_EMPRESA = " & intEmpOrigem & " AND ANO_LETIVO = " & intAnoLetivo & " AND ANO_LETIVO_RENOVACAO = " & intAnoLetivoDestino & " ORDER BY CODIGO DESC"))
	end function

	'Aluno ativo na turma de origem (vínculo ativo mais recente na unidade/ano)
	sub carregaOrigemAtiva(ByVal codEmpresa, ByVal ano)
		dim s
		intTurmaOrigem = 0 : intTurnoOrigem = 0 : intSemestreOrigem = 0
		s = "SELECT TOP 1 AT.COD_TURMA, T.Cod_Turno, ISNULL(T.Cod_Semestre, 3) AS Cod_Semestre"
		s = s & " FROM SCA_ALUNO_TURMA AT INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.COD_TURMA"
		s = s & " WHERE AT.COD_EMPRESA = " & codEmpresa & " AND AT.COD_ALUNO = " & intCodAluno
		s = s & " AND AT.ANO_LETIVO = " & ano & " AND AT.SITUACAO = 'A'"
		s = s & " ORDER BY AT.CODIGO DESC"
		rs.open s, cnn
		if not rs.eof then
			intTurmaOrigem		= tipNumero(rs("COD_TURMA"))
			intTurnoOrigem		= tipNumero(rs("Cod_Turno"))
			intSemestreOrigem	= tipNumero(rs("Cod_Semestre"))
		end if
		rs.close
		intSitAluno = tipNumero(primeiroValor("SELECT TOP 1 COD_SITUACAOALUNO FROM SCA_CONTROLE_SITUACAO_ALUNO WHERE COD_EMPRESA = " & codEmpresa & " AND COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & ano & " ORDER BY CODIGO DESC"))
		if intSitAluno = 0 then intSitAluno = 1
	end sub

	'Turma de destino: da unidade, do ano letivo e ativa
	sub carregaTurmaDestino()
		dim s
		s = "SELECT T.Cod_Turno, ISNULL(T.Cod_Semestre, 3) AS Cod_Semestre FROM SCA_TURMA T"
		s = s & " WHERE T.Cod_Turma = " & intTurmaDestino & " AND T.Cod_Empresa = " & intEmpDestino
		s = s & " AND T.AnoLetivo = " & intAnoLetivoDestino & " AND T.Situacao = 'A'"
		rs.open s, cnn
		if not rs.eof then
			intTurnoDestino		= tipNumero(rs("Cod_Turno"))
			intSemestreDestino	= tipNumero(rs("Cod_Semestre"))
		else
			registraErro "A turma de destino não pertence à unidade escolhida ou não está ativa em " & intAnoLetivoDestino & "."
		end if
		rs.close
		if not blnErro then
			if tipNumero(primeiroValor("SELECT COUNT(*) FROM SCA_ALUNO_DISCIPLINA WHERE COD_ALUNO = " & intCodAluno & " AND COD_TURMA = " & intTurmaDestino)) > 0 then
				registraErro "O aluno " & strNomeAluno & " já tem disciplinas na turma de destino. Verifique antes de continuar."
			end if
		end if
	end sub

	'Dados de uma TIP gravada
	sub carregaTip(ByVal codigo)
		dim s
		strSituacaoTip = ""
		s = "SELECT TIP.COD_ALUNO, TIP.COD_EMPRESA, TIP.COD_EMPRESA_DESTINO, TIP.ANO_LETIVO, ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO + 1) AS ANO_LETIVO_DESTINO,"
		s = s & " ISNULL(TIP.SEMESTRE, 3) AS SEMESTRE, TIP.COD_TURMA, TIP.COD_TURMA_DESTINO, ISNULL(TIP.SITUACAO, 'E') AS SITUACAO,"
		s = s & " EO.RAZAOSOCIAL AS UNIDADE_ORIGEM, ED.RAZAOSOCIAL AS UNIDADE_DESTINO, A.NOMEALUNO"
		s = s & " FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP"
		s = s & " INNER JOIN SCA_ALUNO A ON A.CODIGO = TIP.COD_ALUNO"
		s = s & " LEFT JOIN SEG_EMPRESA EO ON EO.CODIGO = TIP.COD_EMPRESA"
		s = s & " LEFT JOIN SEG_EMPRESA ED ON ED.CODIGO = TIP.COD_EMPRESA_DESTINO"
		s = s & " WHERE TIP.CODIGO = " & codigo
		rs.open s, cnn
		if not rs.eof then
			intCodAluno			= tipNumero(rs("COD_ALUNO"))
			intEmpOrigem		= tipNumero(rs("COD_EMPRESA"))
			intEmpDestino		= tipNumero(rs("COD_EMPRESA_DESTINO"))
			intAnoLetivo		= tipNumero(rs("ANO_LETIVO"))
			intAnoLetivoDestino	= tipNumero(rs("ANO_LETIVO_DESTINO"))
			intSemestreTip		= tipNumero(rs("SEMESTRE"))
			intTurmaTipOrigem	= tipNumero(rs("COD_TURMA"))
			intTurmaDestino		= tipNumero(rs("COD_TURMA_DESTINO"))
			strSituacaoTip		= trim(rs("SITUACAO") & "")
			strUnidadeOrigem	= trim(rs("UNIDADE_ORIGEM") & "")
			strUnidadeDestino	= trim(rs("UNIDADE_DESTINO") & "")
			strNomeAluno		= trim(rs("NOMEALUNO") & "")
		end if
		rs.close
		if strSituacaoTip = "" then registraErro "TIP não encontrada. Atualize a tela e tente novamente."
	end sub

	sub gravaOcorrenciaExclusao(ByVal codEmpresa, ByVal ano, ByVal texto)
		dim s
		s = "INSERT INTO SCA_OCORRENCIA (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)"
		s = s & " VALUES (" & codEmpresa & ", " & intCodAluno & ", " & ano & ", " & intSemestreTip & ", getdate(), null, " & sqlTexto(texto) & ", " & sqlTexto(strUsuario) & ")"
		executa s
	end sub

	'---------------------------------------------------------------------
	' Dados recebidos
	'	I = incluir TIP (origem): fica PENDENTE e reserva a vaga
	'	E = excluir TIP pendente (origem): devolve a vaga
	'	F = efetivar TIP (destino, tela de efetivação): transfere o aluno
	'	D = desfazer TIP efetivada (destino, tela de efetivação): SP_MAT_TipDesfaz
	'---------------------------------------------------------------------
	intCodEmp		= tipNumero(Session("CodEmpresa"))		'unidade da sessão
	strUsuario		= trim(session("usuarioWeb") & "")
	strMatricula	= Trim(Request.Form("txtMatricula"))

	if acao <> "I" and acao <> "E" and acao <> "F" and acao <> "D" then registraErro "Ação inválida."
	if intCodEmp = 0 then registraErro "Unidade não informada. Entre novamente no sistema."

	cnn.begintrans

	'=====================================================================
	' I - TIP: grava PENDENTE e reserva a vaga na turma de destino
	'=====================================================================
	if acao = "I" and not blnErro then

		intEmpOrigem	= intCodEmp
		intAnoLetivo	= tipNumero(Session("strAnoLetivo"))
		'TIP é para o ANO SEGUINTE: origem = ano letivo atual, destino = ano letivo + 1
		intAnoLetivoDestino	= intAnoLetivo + 1
		intCodAluno		= tipNumero(Request.Form("txtCodAluno"))
		intEmpDestino	= tipNumero(Request.Form("cmbEmpresa"))
		intTurmaDestino	= tipNumero(Request.Form("cmbTurma"))

		if intAnoLetivo = 0 then registraErro "Ano letivo não informado."
		if intCodAluno = 0 then registraErro "Informe o aluno."
		if intEmpDestino = 0 then registraErro "Selecione a unidade escolar de destino."
		if intTurmaDestino = 0 then registraErro "Selecione a turma de destino."

		'Aluno com solicitação de matrícula pelo site para o ano de destino: não pode ter TIP
		if not blnErro then
			strInscricaoSite = inscricaoSiteDoAluno(intCodAluno, intAnoLetivoDestino)
			if strInscricaoSite <> "" then registraErro "Este aluno já tem solicitação de matrícula pelo site para " & intAnoLetivoDestino & " (" & strInscricaoSite & "). A TIP não pode ser feita."
		end if
		if not blnErro and intEmpDestino = intEmpOrigem then registraErro "A unidade de destino deve ser diferente da unidade atual."

		if not blnErro then
			strNomeAluno = primeiroValor("SELECT NOMEALUNO FROM SCA_ALUNO WHERE CODIGO = " & intCodAluno) & ""
			if strNomeAluno = "" then registraErro "Aluno não encontrado."
		end if

		'Uma TIP por aluno no ano
		if not blnErro then
			if tipNumero(primeiroValor("SELECT COUNT(*) FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE COD_ALUNO = " & intCodAluno & " AND ANO_LETIVO = " & intAnoLetivo & " AND ISNULL(SITUACAO, 'E') <> 'C'")) > 0 then
				registraErro "O aluno " & strNomeAluno & " já tem uma TIP em " & intAnoLetivo & ". Para fazer outra, exclua a TIP atual."
			end if
		end if

		'TIP exige RENOVAÇÃO nesta unidade para o ano de destino: é a vaga garantida na origem.
		'Se a TIP não for efetivada (excluída ou cancelada no prazo), o aluno continua na turma renovada.
		'Na efetivação, a renovação é desfeita (SP_MAT_RenovacaoDesfaz) e a vaga da origem é liberada.
		if not blnErro then
			intCodRenovacaoTip = renovacaoDaOrigem()
			'Exceção: terminalidade (ex.: INFANTIL V sem 1º ANO nesta unidade) pode fazer TIP sem renovação
			if intCodRenovacaoTip = 0 and tipTerminalidadeSemRenovacao(intCodAluno, intEmpOrigem, intAnoLetivo, intAnoLetivoDestino) <> "" then
				'segue sem renovação
			elseif intCodRenovacaoTip = 0 then
				registraErro "O aluno " & strNomeAluno & " precisa estar renovado para " & intAnoLetivoDestino & " nesta unidade antes da TIP (Matrícula > Renovação). A renovação garante a vaga dele aqui se a TIP não for efetivada."
			else
				strMotivoRen = primeiroValor("EXEC SP_MAT_RenovacaoDesfaz " & intCodRenovacaoTip & ", 1") & ""
				if strMotivoRen <> "" then registraErro "A TIP não pode ser feita: na efetivação a renovação do aluno nesta unidade será desfeita, e hoje isso não é possível. " & strMotivoRen
			end if
		end if

		if not blnErro then
			carregaOrigemAtiva intEmpOrigem, intAnoLetivo
			if intTurmaOrigem = 0 or intSitAluno <> 1 then
				registraErro "O aluno " & strNomeAluno & " não está ativo em uma turma desta unidade em " & intAnoLetivo & ". Somente alunos ativos podem fazer TIP."
			end if
		end if

		if not blnErro then carregaTurmaDestino

		'Vaga na turma de destino (mesma conta da combo de turma): evita duas TIP na última vaga
		if not blnErro then
			sqlVaga = "SELECT isnull(t.capacidade,0) - isnull(t.VagasReservadas,0)"
			sqlVaga = sqlVaga & " - (select count(*) from sca_aluno_turma at where at.ano_letivo = " & intAnoLetivoDestino & " and at.cod_turma = t.cod_turma and at.situacao = 'A')"
			sqlVaga = sqlVaga & " - (select count(*) from SCA_TRANSFERENCIA_INTERESSE_PROPRIO tip where tip.COD_TURMA_DESTINO = t.cod_turma and tip.SITUACAO = 'P')"
			sqlVaga = sqlVaga & " - (select count(*) from MAT_reserva r where r.data_exc_cadastro is null and r.ano = t.AnoLetivo and r.cod_empresa_efetivado is not null and r.cod_aluno is null and r.Cod_turma_efetivado = t.cod_turma)"
			sqlVaga = sqlVaga & " FROM SCA_TURMA t WITH (UPDLOCK) WHERE t.Cod_Turma = " & intTurmaDestino
			if tipNumero(primeiroValor(sqlVaga)) <= 0 then registraErro "A turma de destino não tem mais vaga disponível. Atualize a tela e escolha outra turma."
		end if

		'De/para (MAT_TIP_DE_PARA): a turma de destino tem de ser do curso/período seguinte ao da turma atual
		if not blnErro then
			intPeriodoOrigemDp = tipNumero(primeiroValor("SELECT Cod_periodo FROM SCA_TURMA WHERE Cod_Turma = " & intTurmaOrigem))
			vetDp = tipDePara(intPeriodoOrigemDp)
			if not isArray(vetDp) then
				registraErro "Não há TIP para o período atual do aluno (" & tipDescPeriodo(intPeriodoOrigemDp) & ")."
			else
				intPeriodoDestinoDp = tipNumero(primeiroValor("SELECT Cod_periodo FROM SCA_TURMA WHERE Cod_Turma = " & intTurmaDestino))
				if intPeriodoDestinoDp <> clng(vetDp(1)) then
					registraErro "A turma de destino deve ser do período " & tipDescPeriodo(vetDp(1)) & " (de/para da TIP para quem está no " & tipDescPeriodo(intPeriodoOrigemDp) & ")."
				end if
			end if
		end if

		if not blnErro then
			strUnidadeDestino = primeiroValor("SELECT RAZAOSOCIAL FROM SEG_EMPRESA WHERE CODIGO = " & intEmpDestino) & ""

			sql = "INSERT INTO SCA_TRANSFERENCIA_INTERESSE_PROPRIO (ANO_LETIVO, ANO_LETIVO_DESTINO, SEMESTRE, COD_ALUNO, COD_EMPRESA, COD_EMPRESA_DESTINO,"
			sql = sql & " COD_TURMA, COD_TURMA_DESTINO, COD_TURNO, COD_TURNO_DESTINO, SITUACAO, USUARIO_INCL, DATA_HORA_INCL)"
			sql = sql & " VALUES (" & intAnoLetivo & ", " & intAnoLetivoDestino & ", " & intSemestreOrigem & ", " & intCodAluno & ", " & intEmpOrigem & ", " & intEmpDestino & ","
			sql = sql & " " & intTurmaOrigem & ", " & intTurmaDestino & ", " & intTurnoOrigem & ", " & intTurnoDestino & ", 'P', " & sqlTexto(strUsuario) & ", getdate())"
			intCodTip = insereComCodigo(sql)
			if not blnErro and intCodTip = 0 then registraErro "Não foi possível obter o código da TIP."

			'A vaga fica reservada pela própria TIP pendente (conta em "Alocados aguardando efetivação" e
			'é descontada nas combos de vaga); o contador da turma só muda na efetivação

			gravaOcorrenciaEm intEmpOrigem, intAnoLetivo, intSemestreOrigem, "TIP - transferência por interesse próprio solicitada para " & strUnidadeDestino & " em " & intAnoLetivoDestino & " (aguardando efetivação pela unidade de destino)"

			strMensagem = "TIP do aluno " & strNomeAluno & " gravada com sucesso!"
		end if

	'=====================================================================
	' E - EXCLUIR TIP PENDENTE (origem): devolve a vaga
	'=====================================================================
	elseif acao = "E" and not blnErro then

		intCodTip = tipNumero(Request.Form("txtCodTip"))
		if intCodTip = 0 then registraErro "TIP inválida."
		if not blnErro then carregaTip intCodTip
		if not blnErro and intEmpOrigem <> intCodEmp then registraErro "Somente a unidade de origem pode excluir esta TIP."
		if not blnErro and strSituacaoTip = "C" then registraErro "A TIP do aluno " & strNomeAluno & " já está cancelada."
		if not blnErro and strSituacaoTip <> "P" then
			registraErro "A TIP do aluno " & strNomeAluno & " já foi efetivada pela unidade de destino (" & strUnidadeDestino & "). Somente a unidade de destino pode desfazê-la, na tela de Efetivação (filtro TIP)."
		end if

		if not blnErro then
			executa "DELETE FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE CODIGO = " & intCodTip & " AND SITUACAO = 'P'"
			'TIP pendente não mexeu no contador da turma: nada a devolver
			gravaOcorrenciaExclusao intEmpOrigem, intAnoLetivo, "TIP removida (transferência por interesse próprio para " & strUnidadeDestino & ") antes da efetivação - aluno continua nesta unidade"
			strMensagem = "TIP excluída com sucesso. O aluno continua nesta unidade e a vaga na turma de destino foi liberada."
		end if

	'=====================================================================
	' F - EFETIVAR TIP (destino): transfere o aluno
	'=====================================================================
	elseif acao = "F" and not blnErro then

		intCodTip = tipNumero(Request.Form("txtCodTip"))
		if intCodTip = 0 then registraErro "TIP inválida."
		if not blnErro then carregaTip intCodTip
		if not blnErro and intEmpDestino <> intCodEmp then registraErro "Somente a unidade de destino pode efetivar esta TIP."
		if not blnErro and strSituacaoTip = "C" then registraErro "A TIP do aluno " & strNomeAluno & " foi cancelada (matrícula não confirmada no prazo). A unidade de origem pode fazer uma nova TIP."
		if not blnErro and strSituacaoTip <> "P" then registraErro "A TIP do aluno " & strNomeAluno & " já foi efetivada."

		'Continua ativo na turma de origem informada na TIP
		if not blnErro then
			carregaOrigemAtiva intEmpOrigem, intAnoLetivo
			if intTurmaOrigem = 0 or intSitAluno <> 1 then
				registraErro "O aluno " & strNomeAluno & " não está mais ativo na unidade de origem (" & strUnidadeOrigem & ") em " & intAnoLetivo & ". A TIP não pode ser efetivada; a unidade de origem deve verificar e, se for o caso, excluir a TIP."
			elseif intTurmaOrigem <> intTurmaTipOrigem then
				registraErro "O aluno " & strNomeAluno & " mudou de turma na unidade de origem depois da TIP. A unidade de origem deve excluir a TIP e fazer uma nova."
			end if
		end if

		if not blnErro then carregaTurmaDestino

		'Libera a vaga da origem no ano de destino: desfaz a renovação do aluno na unidade de origem
		'(a TIP exige a renovação; TIP antiga sem renovação segue sem este passo)
		if not blnErro then
			intCodRenovacaoTip = renovacaoDaOrigem()
			if intCodRenovacaoTip > 0 then executaSP "EXEC SP_MAT_RenovacaoDesfaz " & intCodRenovacaoTip
		end if

		if not blnErro then processaTransferenciaTip

		if not blnErro then strMensagem = "TIP do aluno " & strNomeAluno & " efetivada com sucesso! O aluno foi transferido para esta unidade em " & intAnoLetivoDestino & " e a vaga dele na unidade de origem foi liberada."

	'=====================================================================
	' D - DESFAZER TIP EFETIVADA (destino) - SP_MAT_TipDesfaz
	'	Bloqueado se já houver nota, falta ou avaliação na turma de destino.
	'=====================================================================
	elseif acao = "D" and not blnErro then

		intCodTip = tipNumero(Request.Form("txtCodTip"))
		if intCodTip = 0 then registraErro "TIP inválida."
		if not blnErro then carregaTip intCodTip
		if not blnErro and intEmpDestino <> intCodEmp then registraErro "Somente a unidade de destino pode desfazer esta TIP."
		if not blnErro and strSituacaoTip <> "E" then registraErro "A TIP do aluno " & strNomeAluno & " ainda não foi efetivada."

		executaSP "EXEC SP_MAT_TipDesfaz " & intCodTip

		'Registra como ocorrência nas DUAS unidades (origem, para onde o aluno voltou, e destino)
		if not blnErro then
			gravaOcorrenciaExclusao intEmpOrigem, intAnoLetivo, "TIP removida (transferência por interesse próprio para " & strUnidadeDestino & ") - efetivação desfeita pela unidade de destino; aluno retornou à turma de origem"
			gravaOcorrenciaExclusao intEmpDestino, intAnoLetivoDestino, "TIP removida (transferência por interesse próprio de " & strUnidadeOrigem & ") - efetivação desfeita; aluno retornou à unidade de origem"
		end if
		strMensagem = "Efetivação da TIP desfeita. O aluno voltou para a turma de origem e a vaga foi liberada." & vbCrLf & vbCrLf & "ATENÇÃO: a renovação do aluno na unidade de origem (" & strUnidadeOrigem & ") foi desfeita na efetivação. A unidade de origem precisa renovar o aluno novamente para " & intAnoLetivoDestino & "."
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
<%if acao = "F" or acao = "D" then%>
<!-- Volta para a tela de efetivação (filtro TIP) -->
<form id="frmRetorno" name="frmRetorno" method="post" action="mat_efetivacao.asp">
	<input type="hidden" name="cmbFuncao" value="TIP">
	<input type="hidden" name="cmbTipo" value="<%if acao = "F" then response.write "2" else response.write "1"%>">
</form>
<%else%>
<!-- Volta para a tela com o mesmo aluno -->
<form id="frmRetorno" name="frmRetorno" method="post" action="mat_tip.asp">
	<input type="hidden" name="txtMatricula" value="<%=server.htmlEncode(strMatricula)%>">
</form>
<%end if%>
<script>
	alert("<%=jsTexto(strMensagem)%>");
	document.getElementById("frmRetorno").submit();
</script>
