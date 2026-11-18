<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "text/html"
response.Expires = -1
response.CacheControl = "no-cache"

'A replicação de todas as unidades pode demorar
Server.ScriptTimeout = 5000
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/10/2026 (versão nova de sistema/MAT/promoverTurmaGrade_cod.asp)
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo..........: Replicação de grades (matrizes) e turmas para o ano letivo seguinte
	::	                    I = replicar (SP_SCA_PromoveTurmaGrade) | E = cancelar a replicação
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
	'---------------------------------------------------------------------
	' Funções auxiliares
	'---------------------------------------------------------------------
	function repNumero(ByVal valor)
		repNumero = 0
		if isnull(valor) then exit function
		valor = trim(cstr(valor))
		if valor <> "" and isnumeric(valor) then repNumero = clng(valor)
	end function

	function jsTexto(ByVal texto)
		texto = replace(texto & "", "\", "\\")
		texto = replace(texto, """", "\""")
		texto = replace(texto, vbcrlf, "\n")
		texto = replace(texto, vbcr, "\n")
		texto = replace(texto, vblf, "\n")
		jsTexto = texto
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

	'Volta para a tela com a mensagem, mantendo os anos informados
	sub retorna(ByVal mensagem)
		%>
		<form id="frmRetorno" name="frmRetorno" method="post" action="mat_replica_turma_grade.asp">
			<input type="hidden" name="txtAnoLetivo" value="<%=intAnoLetivo%>">
			<input type="hidden" name="txtAnoLetivoReplicacao" value="<%=intAnoReplicacao%>">
			<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
			<input type="hidden" name="cmbTipoEmpresa" value="<%=intCodTipoEmpresa%>">
			<input type="hidden" name="cmbEmpresaGrupo" value="<%=intCodEmpresa%>">
		</form>
		<script>
			alert("<%=jsTexto(mensagem)%>");
			document.getElementById("frmRetorno").submit();
		</script>
		<%
		response.end
	end sub

	'---------------------------------------------------------------------
	' Dados recebidos
	'---------------------------------------------------------------------
	acao				= ucase(Trim(Request.QueryString("acao")))
	intAnoLetivo		= repNumero(Request.Form("txtAnoLetivo"))
	intAnoReplicacao	= repNumero(Request.Form("txtAnoLetivoReplicacao"))
	intSemestre			= repNumero(Request.Form("cmbSemestre"))
	intCodEmpresa		= repNumero(Request.Form("cmbEmpresaGrupo"))	'0 = todas as unidades do grupo
	intCodTipoEmpresa	= repNumero(Request.Form("cmbTipoEmpresa"))	'0 = todos os tipos (usado só quando intCodEmpresa = 0)
	intIdReplicacao		= repNumero(Request.Form("txtIdReplicacao"))
	strUsuario			= trim(session("usuarioWeb") & "")
	if intSemestre = 0 then intSemestre = 3

	'=====================================================================
	' I - REPLICAR
	'=====================================================================
	if acao = "I" then

		if intAnoLetivo < 2000 or intAnoReplicacao < 2000 then retorna "Informe o ano letivo atual e o ano letivo da replicação."
		if intAnoReplicacao <= intAnoLetivo then retorna "O ano letivo da replicação deve ser maior que o ano letivo atual."
		if repNumero(session("codGrupo")) = 0 then retorna "Grupo do usuário não identificado. Entre novamente no sistema."

		sql = "exec SP_SCA_PromoveTurmaGrade " & repNumero(session("codGrupo")) & "," & intCodEmpresa & ",''," & intAnoLetivo & "," & intAnoReplicacao & "," & intSemestre & "," & intCodTipoEmpresa & ",'" & replace(strUsuario, "'", "''") & "'"

		'Data/hora do banco antes de processar (formato ISO, independe do idioma do servidor):
		'identifica o registro de histórico criado pela SP
		strInicio = primeiroValor("SELECT CONVERT(VARCHAR(23), GETDATE(), 126)") & ""

		strRetorno = ""
		cnn.CommandTimeout = 3600
		on error resume next
		rs.open sql, cnn
		if err.number <> 0 then
			strRetorno = "ERRO: " & err.description
			err.clear
		elseif not rs.eof then
			strRetorno = trim(rs("retorno") & "")
			'Versão nova da SP também informa quantas unidades foram processadas/ignoradas
			intUnidadesProcessadas = -1
			intUnidadesIgnoradas = -1
			if rs.fields.count >= 3 then
				intUnidadesProcessadas = repNumero(rs("unidades_processadas"))
				intUnidadesIgnoradas = repNumero(rs("unidades_ignoradas"))
			end if
		end if
		if rs.state = 1 then rs.close
		on error goto 0

		GravarLog sql

		'Grava o tipo de unidade no histórico (replicação de todas as unidades de um tipo)
		if intCodEmpresa = 0 and intCodTipoEmpresa > 0 and (strRetorno = "FINALIZADO" or strRetorno = "NAO_FINALIZADO") then
			sql = "UPDATE MAT_aut_grade_turma_historico SET cod_tipo_empresa = " & intCodTipoEmpresa
			sql = sql & " WHERE id_aut_grade_turma_historico = ("
			sql = sql & " SELECT MAX(id_aut_grade_turma_historico) FROM MAT_aut_grade_turma_historico"
			sql = sql & " WHERE usuario_incl = '" & replace(strUsuario, "'", "''") & "'"
			sql = sql & " AND data_hora_incl >= '" & strInicio & "'"
			sql = sql & " AND cod_empresa = 0)"
			on error resume next
			cnn.execute sql
			err.clear
			on error goto 0
		end if

		if strRetorno = "FINALIZADO" then
			'Guapó (igual tela antiga): recalcula as vagas das turmas do ano da replicação
			on error resume next
			cnn.execute "EXEC SP_MAT_AtualizaTurmaVagaMatricula " & clng(intAnoReplicacao) & ", " & clng(session("codGrupo"))
			err.clear
			on error goto 0
			strResumo = ""
			if intUnidadesProcessadas >= 0 then
				strResumo = vbcrlf & vbcrlf & "Unidades processadas: " & intUnidadesProcessadas
				if intUnidadesIgnoradas > 0 then strResumo = strResumo & vbcrlf & "Unidades ignoradas (já tinham turmas em " & intAnoReplicacao & "): " & intUnidadesIgnoradas
			end if
			retorna "Processamento finalizado com sucesso!" & strResumo
		elseif strRetorno = "NAO_FINALIZADO" then
			strResumo = ""
			if intUnidadesIgnoradas > 0 then strResumo = vbcrlf & vbcrlf & "Unidades ignoradas (já tinham turmas em " & intAnoReplicacao & "): " & intUnidadesIgnoradas
			retorna "Processamento NÃO FOI FINALIZADO: nenhuma turma para replicar. Verifique se esse procedimento já foi executado anteriormente para esta unidade e ano." & strResumo
		else
			retorna "ATENÇÃO: o processamento não foi finalizado. Verifique com o suporte do GEMUL." & vbcrlf & vbcrlf & strRetorno
		end if

	'=====================================================================
	' E - CANCELAR A REPLICAÇÃO
	'	Só é permitido enquanto as turmas e grades criadas não tiverem alunos.
	'=====================================================================
	elseif acao = "E" then

		if intIdReplicacao = 0 then retorna "Replicação não informada."

		strSituacao = trim(primeiroValor("SELECT situacao FROM MAT_aut_grade_turma_historico WHERE id_aut_grade_turma_historico = " & intIdReplicacao) & "")
		if strSituacao = "" then retorna "Replicação não encontrada. Atualize a tela e tente novamente."
		if strSituacao <> "A" then retorna "Esta replicação já foi cancelada ou não foi processada."

		strTurmas = "SELECT cod_turma_nova FROM MAT_aut_turma_historico WHERE id_aut_grade_turma_historico = " & intIdReplicacao
		strGrades = "SELECT cod_gradecurricular_nova FROM MAT_aut_grade_historico WHERE id_aut_grade_turma_historico = " & intIdReplicacao

		'----- verifica movimentação nas turmas e grades criadas
		intQtdeAlunosTurma = repNumero(primeiroValor("SELECT COUNT(*) FROM SCA_ALUNO_TURMA WHERE COD_TURMA IN (" & strTurmas & ")"))

		sql = "SELECT COUNT(*) FROM SCA_ALUNO_DISCIPLINA WHERE COD_TURMA IN (" & strTurmas & ")"
		sql = sql & " OR COD_TURMA_REMANEJAMENTO IN (" & strTurmas & ")"
		sql = sql & " OR COD_GRADECURRICULARDISCIPLINA IN (SELECT Cod_GradeCurricularDisciplina FROM SCA_GRADECURRICULARDISCIPLINA WHERE Cod_GradeCurricular IN (" & strGrades & "))"
		sql = sql & " OR COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO IN (SELECT Cod_GradeCurricularDisciplina FROM SCA_GRADECURRICULARDISCIPLINA WHERE Cod_GradeCurricular IN (" & strGrades & "))"
		intQtdeAlunosDisciplina = repNumero(primeiroValor(sql))

		'Grades criadas nesta replicação e usadas por turmas de OUTRA replicação/cadastro
		'(acontece quando outra unidade foi replicada depois e aproveitou as mesmas grades)
		intQtdeTurmasOutras = repNumero(primeiroValor("SELECT COUNT(*) FROM SCA_TURMA WHERE Cod_GradeCurricular IN (" & strGrades & ") AND Cod_Turma NOT IN (" & strTurmas & ")"))
		if intQtdeTurmasOutras > 0 then
			retorna "A replicação NÃO pode ser cancelada: as grades criadas por ela já são usadas por " & intQtdeTurmasOutras & " turma(s) de outras replicações ou cadastros." & vbcrlf & vbcrlf & _
				"Cancele primeiro as replicações feitas depois desta."
		end if

		if intQtdeAlunosTurma > 0 or intQtdeAlunosDisciplina > 0 then
			retorna "A replicação NÃO pode ser cancelada: as turmas e grades criadas já têm movimentação." & vbcrlf & vbcrlf & _
				"Alunos nas turmas: " & intQtdeAlunosTurma & vbcrlf & _
				"Disciplinas de alunos: " & intQtdeAlunosDisciplina
		end if

		'----- cancela (tudo ou nada)
		strErro = ""
		cnn.begintrans
		on error resume next

		comandos = Array( _
			"UPDATE MAT_aut_grade_turma_historico SET situacao = 'C' WHERE id_aut_grade_turma_historico = " & intIdReplicacao, _
			"DELETE FROM SCA_TURMA WHERE Cod_Turma IN (" & strTurmas & ")", _
			"DELETE FROM SCA_GRADECURRICULARDISCIPLINA WHERE Cod_GradeCurricular IN (" & strGrades & ")", _
			"DELETE FROM SCA_GRADECURRICULAR WHERE Cod_GradeCurricular IN (" & strGrades & ")" _
		)
		for each comando in comandos
			cnn.execute comando
			if err.number <> 0 then
				strErro = err.description
				err.clear
				exit for
			end if
		next
		on error goto 0

		if strErro <> "" then
			cnn.rollbackTrans
			retorna "ATENÇÃO: o cancelamento não foi feito e nada foi alterado. Provavelmente as turmas ou grades já são usadas em outros cadastros (horário, modulação etc.)." & vbcrlf & vbcrlf & strErro
		end if

		cnn.commitTrans
		for each comando in comandos
			GravarLog comando
		next

		retorna "A replicação foi CANCELADA com sucesso. As grades e turmas criadas foram removidas."

	else
		retorna "Ação inválida."
	end if
%>
