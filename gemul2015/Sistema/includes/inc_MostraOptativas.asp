<!--
	::	Data de Criação...: 07/10/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cabeçalhos do relatório Processo Seletivo
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
    <%
  
	'AnoLetivoMostraOptativa = 
	'SemestreMostraOptativa =
	'CursoMostraOptativa = 
	'PeriodoMostraOptativa = 
	'TurnoMostraOptativa = 
	'DisciplinaMostraOptativa = 
	'CodigoAlunoMostraOptativa = 
	' Mensagem Carrega em: - (MsgOptativa)
	
	if AnoLetivoMostraOptativa = "" then AnoLetivoMostraOptativa = "0"
	if SemestreMostraOptativa = "" then SemestreMostraOptativa = "0"
	if CursoMostraOptativa = "" then CursoMostraOptativa = "0"
	if PeriodoMostraOptativa = "" then PeriodoMostraOptativa = "0"
	if TurnoMostraOptativa = "" then TurnoMostraOptativa = "0"
	if DisciplinaMostraOptativa = "" then DisciplinaMostraOptativa = "0"
	if CodigoAlunoMostraOptativa = "" then CodigoAlunoMostraOptativa = "0"

    if trim(CursoMostraOptativa) = "" or isnull(CursoMostraOptativa) or trim(PeriodoMostraOptativa) = "" or isnull(PeriodoMostraOptativa) then
		BuscaOptativa="no"
	else	
		BuscaOptativa="yes"
	end if	
	
	if BuscaOptativa="yes" then
		MsgOptativa = ""
		flagOptativa = ""
		sql = " select dop.desc_Historico as Optativa from SCA_OPTATIVAS op "
		sql = sql & " left JOIN sca_disciplina dop ON dop.cod_disciplina = op.cod_disciplina_equivalente "
		sql = sql & " where op.cod_empresa = " & session("CodEmpresa")
		sql = sql & " and op.Ano_Letivo = " & trim(AnoLetivoMostraOptativa) 
		sql = sql & " and op.Semestre_Letivo = " & trim(SemestreMostraOptativa)
		sql = sql & " and op.cod_curso = " & trim(CursoMostraOptativa)
		sql = sql & " and op.cod_periodo = " & trim(PeriodoMostraOptativa)
		sql = sql & " and op.Cod_turno = (case when op.Cod_turno = 0 then 0 else " & trim(TurnoMostraOptativa) & " end) "
		sql = sql & " and op.Cod_Disciplina = " & trim(DisciplinaMostraOptativa)
		sql = sql & " and op.cod_aluno = " & CodigoAlunoMostraOptativa 
		rs1.open sql, cnn
		if not rs1.eof then 
			MsgOptativa = " - ( " & rs1("Optativa") & " )"
			flagOptativa = "ok"
		else
			MsgOptativa = ""
			flagOptativa = "no"
		end if
		rs1.close
		
		if flagOptativa = "no" then
			sql = " select dop.desc_Historico as Optativa from SCA_OPTATIVAS op "
			sql = sql & " left JOIN sca_disciplina dop ON dop.cod_disciplina = op.cod_disciplina_equivalente "
			sql = sql & " where op.cod_empresa = " & session("CodEmpresa")
			sql = sql & " and op.Ano_Letivo = " & trim(AnoLetivoMostraOptativa) 
			sql = sql & " and op.Semestre_Letivo = " & trim(SemestreMostraOptativa)
			sql = sql & " and op.cod_curso = " & trim(CursoMostraOptativa)
			sql = sql & " and op.cod_periodo = " & trim(PeriodoMostraOptativa)
			sql = sql & " and op.Cod_turno = (case when op.Cod_turno = 0 then 0 else " & trim(TurnoMostraOptativa) & " end) "
			sql = sql & " and op.Cod_Disciplina = " & trim(DisciplinaMostraOptativa)
			'sql = sql & " and op.cod_aluno = " & CodigoAlunoMostraOptativa 
			sql = sql & " and isnull(op.cod_aluno,'0') = '0' "
			rs1.open sql, cnn
			if not rs1.eof then 
				MsgOptativa = " - ( " & rs1("Optativa") & " )"
			else
				MsgOptativa = ""
			end if
			rs1.close
		end if
	end if

	%>  
