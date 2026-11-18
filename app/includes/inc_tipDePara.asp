<%
	'---------------------------------------------------------------------
	' TIP - de/para do curso e período (tabela MAT_TIP_DE_PARA, por grupo)
	' Período da turma de ORIGEM (ano atual) -> curso | período de DESTINO (ano seguinte)
	' Período sem linha na tabela (ex.: 5º ano, 6º a 9º ano) = sem destino na rede -> TIP bloqueada
	' tipDePara(período de origem) = array(cod_curso, cod_periodo) do destino | "" = sem TIP
	' Carga inicial: banco/scripts/2026-11-04_MAT_TIP_DE_PARA.sql
	'---------------------------------------------------------------------
	function tipDePara(ByVal codPeriodoOrigem)
		dim rsDp, s, codGrupo
		tipDePara = ""
		codPeriodoOrigem = trim(codPeriodoOrigem & "")
		if codPeriodoOrigem = "" or not isnumeric(codPeriodoOrigem) then exit function
		codGrupo = 0
		if isnumeric(Session("CodGrupo") & "") and trim(Session("CodGrupo") & "") <> "" then codGrupo = clng(Session("CodGrupo"))
		s = "SELECT TOP 1 COD_CURSO_DESTINO, COD_PERIODO_DESTINO FROM MAT_TIP_DE_PARA"
		s = s & " WHERE COD_GRUPO = " & codGrupo & " AND COD_PERIODO_ORIGEM = " & clng(codPeriodoOrigem) & " AND SITUACAO = 'A'"
		set rsDp = Server.CreateObject("adodb.recordset")
		rsDp.open s, cnn
		if not rsDp.eof then tipDePara = array(clng(rsDp("COD_CURSO_DESTINO")), clng(rsDp("COD_PERIODO_DESTINO")))
		rsDp.close
		set rsDp = nothing
	end function

	'---------------------------------------------------------------------
	' RENOVAÇÃO - série seguinte: primeiro MAT_RENOVACAO_DE_PARA (só renovação, ex.: 5º ANO -> 6º ANO,
	' que a TIP não permite); se não houver, usa o de/para da TIP (MAT_TIP_DE_PARA).
	' renDePara(período de origem) = array(cod_curso, cod_periodo) | "" = sem de/para
	'---------------------------------------------------------------------
	function renDePara(ByVal codPeriodoOrigem)
		dim rsDp, codGrupo
		renDePara = ""
		codPeriodoOrigem = trim(codPeriodoOrigem & "")
		if codPeriodoOrigem = "" or not isnumeric(codPeriodoOrigem) then exit function
		codGrupo = 0
		if isnumeric(Session("CodGrupo") & "") and trim(Session("CodGrupo") & "") <> "" then codGrupo = clng(Session("CodGrupo"))
		set rsDp = Server.CreateObject("adodb.recordset")
		rsDp.open "IF OBJECT_ID('dbo.MAT_RENOVACAO_DE_PARA') IS NOT NULL SELECT TOP 1 COD_CURSO_DESTINO, COD_PERIODO_DESTINO FROM dbo.MAT_RENOVACAO_DE_PARA" & _
			" WHERE COD_GRUPO = " & codGrupo & " AND COD_PERIODO_ORIGEM = " & clng(codPeriodoOrigem) & " AND SITUACAO = 'A'" & _
			" ELSE SELECT TOP 0 1 AS COD_CURSO_DESTINO, 1 AS COD_PERIODO_DESTINO", cnn
		if not rsDp.eof then renDePara = array(clng(rsDp("COD_CURSO_DESTINO")), clng(rsDp("COD_PERIODO_DESTINO")))
		rsDp.close
		set rsDp = nothing
		if not isArray(renDePara) then renDePara = tipDePara(codPeriodoOrigem)
	end function

	function tipDescPeriodo(ByVal codPeriodo)
		dim rsDp
		tipDescPeriodo = ""
		codPeriodo = trim(codPeriodo & "")
		if codPeriodo = "" or not isnumeric(codPeriodo) then exit function
		set rsDp = Server.CreateObject("adodb.recordset")
		rsDp.open "SELECT Descricao FROM SCA_PERIODO WHERE Cod_Periodo = " & clng(codPeriodo), cnn
		if not rsDp.eof then tipDescPeriodo = trim(rsDp("Descricao") & "")
		rsDp.close
		set rsDp = nothing
	end function

	'---------------------------------------------------------------------
	' TIP sem renovação - TERMINALIDADE (ex.: INFANTIL V numa escola que não tem o 1º ANO):
	' o período de destino do de/para é de OUTRO curso e a unidade NÃO tem turma ativa desse período
	' no ano de destino -> o aluno não tem como ser renovado na origem e pode fazer TIP sem renovação.
	' Devolve a descrição do período de destino (ex.: "1º ANO") | "" = não é terminalidade
	'---------------------------------------------------------------------
	function tipTerminalidadeSemRenovacao(ByVal codAluno, ByVal codEmpresa, ByVal ano, ByVal anoDestino)
		dim rsTt, s, perOrigem, cursoOrigem, vetTt
		tipTerminalidadeSemRenovacao = ""
		if trim(codAluno & "") = "" or trim(codEmpresa & "") = "" or trim(ano & "") = "" then exit function
		s = "SELECT TOP 1 T.Cod_periodo, P.Cod_Curso FROM SCA_ALUNO_TURMA AT"
		s = s & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.COD_TURMA INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = T.Cod_periodo"
		s = s & " WHERE AT.COD_ALUNO = " & clng(codAluno) & " AND AT.COD_EMPRESA = " & clng(codEmpresa)
		s = s & " AND AT.ANO_LETIVO = " & clng(ano) & " AND AT.SITUACAO = 'A' ORDER BY AT.CODIGO DESC"
		set rsTt = Server.CreateObject("adodb.recordset")
		rsTt.open s, cnn
		perOrigem = "" : cursoOrigem = ""
		if not rsTt.eof then perOrigem = rsTt("Cod_periodo") : cursoOrigem = rsTt("Cod_Curso")
		rsTt.close
		if perOrigem = "" then exit function
		vetTt = tipDePara(perOrigem)
		if not isArray(vetTt) then exit function
		if clng(vetTt(0)) = clng(cursoOrigem) then exit function	'mesmo curso: não é terminalidade
		s = "SELECT COUNT(*) FROM SCA_TURMA WHERE Cod_empresa = " & clng(codEmpresa) & " AND AnoLetivo = " & clng(anoDestino)
		s = s & " AND Cod_periodo = " & clng(vetTt(1)) & " AND Situacao = 'A'"
		rsTt.open s, cnn
		if clng(rsTt(0)) = 0 then
			rsTt.close
			rsTt.open "SELECT Descricao FROM SCA_PERIODO WHERE Cod_Periodo = " & clng(vetTt(1)), cnn
			if not rsTt.eof then tipTerminalidadeSemRenovacao = trim(rsTt("Descricao") & "")
			if tipTerminalidadeSemRenovacao = "" then tipTerminalidadeSemRenovacao = "período seguinte"
		end if
		rsTt.close
		set rsTt = nothing
	end function
%>
