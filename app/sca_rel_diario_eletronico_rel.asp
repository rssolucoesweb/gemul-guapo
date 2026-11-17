<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true 'OTIMIZADO: reduz envios fragmentados ao navegador
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Diário eletrônico</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_remanejamento.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->

<%
Function ConverteData(strData)
    Dim partes
    partes = Split(strData, "/")

    ConverteData = DateSerial( _
        CInt(partes(0)), _
        CInt(partes(1)), _
        CInt(partes(2)) _
    )
End Function

	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strQtdeFaltas = request("cmbQtdeFaltas")
	strMes		 		= Trim(Request("cmbMes"))	
    
	
	if strMes = "12" then
	   qtdeDiasMes  = "31"
	else   
		aux=Cdate("01/" & cInt(ZEROLEFT(strMes,2))+1 & "/" & cInt(strAnoLetivo)) - 1
	    qtdeDiasMes = day(aux)
	end if	
	
	'GRAVANDO NO ARQUIVO DE NOTAS
	strGravarOnde = "NOTA"
	msnHistorico  = ""
		
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	intCodTurmaTela				= intCodTurma
	intCodCurso	 				= Trim(Request("cmbCurso"))
	intCodPeriodo 				= Trim(Request("cmbPeriodo"))
	intSemestre 				= Trim(Request("cmbSemestre"))
	strMostraConteudo 		    = Trim(Request.Form("mostraConteudo"))
	intCodTurnoRH           	= Trim(Request("cmbTurnoRH")) 
	
	intCodTurno		 			= Trim(Request("cmbTurno"))
	strAlunos      				= Trim(Request("chkAluno"))
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""


	if intCodTurno = "" then

		sql="SELECT Cod_Turno FROM SCA_TURMA"
		sql=sql & " WHERE Cod_Turma =" & intCodTurma
		rs.open sql, cnn
			intCodTurno = rs("Cod_Turno")
		rs.close

	end if

    
	if intSemestre = "3" then 
	   msgSemestre = ""
	else   
	   msgSemestre = "/"& intSemestre
	end if   
	strTituloRelatorio ="Di&aacute;rio de Frequência <br> Referência: " &ucase(monthName(strMes)) & " - " & strAnoLetivo & msgSemestre

	
	strNomedisciplina = ""
	if intCodDisciplina<>"0" then
		sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
		sql = sql & " WHERE	COD_DISCIPLINA = " & intCodDisciplina
		rs.open sql, cnn
		if not rs.eof then
			strNomedisciplina = rs("DESC_DISCIPLINA")
		end if
		rs.close
	else
		SQL = "SELECT     SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina"
		SQL = SQL & " FROM         SCA_TURMA INNER JOIN"
		SQL = SQL & "                       SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN"
		SQL = SQL & "                       SCA_GRADECURRICULARDISCIPLINA ON "
		SQL = SQL & "                       SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular INNER JOIN"
		SQL = SQL & "                       SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
		SQL = SQL & " WHERE SCA_GRADECURRICULARDISCIPLINA.Omitir_Documentacao='N'"
		SQL = SQL & " AND (SCA_TURMA.Cod_Turma = " & intCodTurma & ") order by SCA_DISCIPLINA.DESC_Disciplina"
		rs.open sql, cnn
		if not rs.eof then
			while not rs.eof
				if strNomedisciplina = "" then
					strNomedisciplina = rs("DESC_DISCIPLINA")
				else
					strNomedisciplina = strNomedisciplina & " | " & rs("DESC_DISCIPLINA")
				end if
				rs.movenext
			wend
		end if
		rs.close
	end if
	
	sql = "SELECT DISTINCT SRH_COLABORADOR.CODIGO, SRH_COLABORADOR.NOME AS COLABORADOR, H.CodTurno"
	sql = sql & " FROM SCA_HORARIO_AULA"
	sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = SCA_HORARIO_AULA.COD_HORARIO"
	sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
	sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO=" & strAnoLetivo
	sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE=" & intSemestre
	sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA=" & intCodTurma
	if intCodDisciplinaTurma<>"0" then
		sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA=" & intCodDisciplinaTurma
	end if
	IF intCodTurnoRH<>"0" THEN
		sql = sql & " AND 		H.CodTurno =" & intCodTurnoRH
	END IF
	if session("usuarioWeb") = "SERGIO" then
		'response.write sql
		
	end if
	rs.open sql, cnn
	strProfessor = ""
	if not rs.eof then 
		while not rs.eof
			if strProfessor = "" then
				strProfessor = RS("COLABORADOR")
				intCodColaborador = rs("CODIGO")
				intCodTurnoProfessor = rs("CodTurno")
			else
				strProfessor = strProfessor & " | " & RS("COLABORADOR")
				intCodColaborador = intCodColaborador & "," & rs("CODIGO")
				intCodTurnoProfessor = intCodTurnoProfessor & "," & rs("CodTurno")
			end if
			
			rs.movenext
		wend
		rs.close
	else
		rs.close
		strProfessor = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
		%>
		<script>
			alert("Não foi encontrado professor para a turma e turno informado.\nVerifique se o horário de aula está lançado!");
			window.history.back();
		</script>		
		<%
		response.end
	end if
	
'if lcase(session("usuarioWeb")) = "roberto" then
'	response.write intCodColaborador & "|" & intCodDisciplinaTurma
'end if	
	
	'==============================================================
	' OTIMIZACAO: intervalo do mes em formato YYYYMMDD.
	' Evita MONTH()/YEAR() sobre colunas de data e permite uso de indice.
	'==============================================================
	strDataIniMes = strAnoLetivo & Right("0" & strMes, 2) & "01"
	strDataFimMes = DateAdd("m", 1, CDate("01/" & Right("0" & strMes, 2) & "/" & strAnoLetivo))
	strDataFimMesSQL = Year(strDataFimMes) & Right("0" & Month(strDataFimMes), 2) & Right("0" & Day(strDataFimMes), 2)

	intQtdeAulasMinistradas = 0
	
	if cint(intCodCurso = 1) or cint(intCodCurso = 2) then
		sql = " select distinct cm.data_aula,0"
	else
		sql = " select distinct cm.data_aula, pp.numero_aula,0"
	end if
	sql = sql & " from dbo.SCA_CONTEUDO_MINISTRADO_PROFESSOR CM "
	sql = sql & " inner join SCA_PLANEJAMENTO_PROFESSOR pp on cm.cod_planejamento_professor = pp.cod_planejamento_professor "
	sql = sql & " where pp.Cod_turma = " & intCodTurma	 
	if intCodDisciplina<>"0" then
		sql = sql & " and pp.Cod_Disciplina = " & intCodDisciplina
	end if
	sql = sql & " and cm.data_aula >= '" & strDataIniMes & "'"
	sql = sql & " and cm.data_aula < '" & strDataFimMesSQL & "'"
	sql = sql & " and pp.data_aula_extra is null"
	sql = sql & " and pp.Cod_Empresa = " & Session("CodEmpresa") 
	sql = sql & " union all"
	if cint(intCodCurso = 1) or cint(intCodCurso = 2) then
		sql = sql & " select distinct cm.data_aula, e.Sequencia "
	else
		sql = sql & " select distinct 0, cm.data_aula, e.Sequencia "
	end if'
	sql = sql & " from dbo.SCA_CONTEUDO_MINISTRADO_PROFESSOR CM "
	sql = sql & " inner join SCA_PLANEJAMENTO_PROFESSOR pp on cm.cod_planejamento_professor = pp.cod_planejamento_professor "
	sql = sql & " inner join SCA_HORARIO_AULA_EXTRA e on e.DataLancamento = cm.data_aula and e.Cod_turma = pp.cod_turma and e.Cod_Disciplina = pp.cod_disciplina "'and e.Cod_Colaborador = pp.cod_colaborador"
	sql = sql & " where pp.Cod_turma = " & intCodTurma	 
	if intCodDisciplina<>"0" then
		sql = sql & " and pp.Cod_Disciplina = " & intCodDisciplina
	end if
	sql = sql & " and cm.data_aula >= '" & strDataIniMes & "'"
	sql = sql & " and cm.data_aula < '" & strDataFimMesSQL & "'"
	sql = sql & " and pp.data_aula_extra is not null"
	sql = sql & " and pp.Cod_Empresa = " & Session("CodEmpresa") 
	'if lcase(session("usuarioWeb")) = "roberto" then
	'	response.write sql
	'end if
	rsAux1.open sql, cnn, 3, 1
	if not rsAux1.eof then
		intQtdeAulasMinistradas = rsAux1.recordcount
	end if
	rsAux1.close
	
	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	strArquivoPlanejamentoEnviado = "N"
	existeLancamentoParaCriarCab = "N"
	if cInt(strMes)>=1 and cInt(strMes)<=6 and strAnoLetivo = 2026 then
		sql = " SELECT codigo"
		sql = sql & " FROM sca_planejamento_arquivo"
		sql = sql & " WHERE ano_letivo = " & cInt(strAnoLetivo)
		sql = sql & " and mes=" & cInt(strMes)
		sql = sql & " and cod_turma = " & intCodTurma	
		sql = sql & " and cod_disciplina = " & intCodDisciplina
		rsAux1.open sql, cnn
		if not rsAux1.eof then
			strArquivoPlanejamentoEnviado = "S"
		end if
		rsAux1.close
		
		if strArquivoPlanejamentoEnviado = "S" then
			sql = "SELECT distinct	d.dia_mes"
			sql = sql & " from sca_calendario_dia_ue d "
			sql = sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
			sql = sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
			sql = sql & " inner join SCA_HORARIO_AULA HA on ha.AnoLetivo = d.ano and ha.DiaSemana = d.dia_semana and HA.COD_EMPRESA = c.cod_empresa "
			sql = sql & " inner join SCA_HORARIO H ON H.codigo = HA.COD_HORARIO and h.cod_empresa = ha.Cod_Empresa "
			sql = sql & " inner join SCA_TURMA tu on tu.Cod_Turma = ha.Cod_turma "
			sql = sql & " inner join SCA_DISCIPLINA di on di.Cod_Disciplina = ha.Cod_Disciplina "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=Tu.COD_GRADECURRICULAR "
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO "
			sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO "
			sql = sql & " where c.cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " AND c.COD_CURSO = " & intCodCurso
			sql = sql & " AND HA.ANOLETIVO = " & cInt(strAnoLetivo)
			if intCodColaborador<>"" and intCodColaborador<>"0" then
				sql = sql & " and HA.Cod_Colaborador in (" & intCodColaborador & ")"
				sql = sql & " and h.CodTurno in (" & intCodTurnoProfessor & ")"
			end if
			sql = sql & " and e.letivo='S' "
			sql = sql & " and d.mes=" & cInt(strMes)
			sql = sql & " and cu.Cod_curso = " & intCodCurso
			sql = sql & " and ha.Cod_turma = " & intCodTurma	
			if intCodDisciplina<>"0" then
				sql = sql & " and ha.cod_disciplina = " & intCodDisciplina
			end if
			sql = sql & " order by d.dia_mes"
			rsAux1.open sql, cnn, 3, 3
			if not rsAux1.eof then
				vetAux1 = rsAux1.getRows
				existeLancamentoParaCriarCab = "S"
			end if
			rsAux1.close
		end if
	end if
	
	if strArquivoPlanejamentoEnviado = "N" then
		sql = " select distinct DAY(CM.data_aula), CM.data_aula from dbo.SCA_CONTEUDO_MINISTRADO_PROFESSOR CM" 
		sql = sql & " inner join SCA_PLANEJAMENTO_PROFESSOR pp on cm.cod_planejamento_professor = pp.cod_planejamento_professor"	
		sql = sql & " where pp.Cod_turma = " & intCodTurma	
		IF intCodDisciplina<>"0" THEN
			sql = sql & " and pp.Cod_Disciplina = " & intCodDisciplina
		end if
		sql = sql & " and cm.data_aula >= '" & strDataIniMes & "'"
		sql = sql & " and cm.data_aula < '" & strDataFimMesSQL & "'"
		sql = sql & " and pp.Cod_Empresa = " & Session("CodEmpresa")
		sql = sql & " order by DAY(cm.data_aula) "
		rsAux1.open sql, cnn, 3, 3
		if not rsAux1.eof then
			vetAux1 = rsAux1.getRows
			existeLancamentoParaCriarCab = "S"
		end if
		rsAux1.close
	end if
	
	if existeLancamentoParaCriarCab = "N" then
		sql = "SELECT distinct	d.dia_mes"
		sql = sql & " from sca_calendario_dia_ue d "
		sql = sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
		sql = sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
		sql = sql & " inner join SCA_HORARIO_AULA HA on ha.AnoLetivo = d.ano and ha.DiaSemana = d.dia_semana and HA.COD_EMPRESA = c.cod_empresa "
		sql = sql & " inner join SCA_HORARIO H ON H.codigo = HA.COD_HORARIO and h.cod_empresa = ha.Cod_Empresa "
		sql = sql & " inner join SCA_TURMA tu on tu.Cod_Turma = ha.Cod_turma "
		sql = sql & " inner join SCA_DISCIPLINA di on di.Cod_Disciplina = ha.Cod_Disciplina "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=Tu.COD_GRADECURRICULAR "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO "
		sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO "
		sql = sql & " where c.cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " AND c.COD_CURSO = " & intCodCurso
		sql = sql & " AND HA.ANOLETIVO = " & cInt(strAnoLetivo)
		if intCodColaborador<>"" and intCodColaborador<>"0" then
			sql = sql & " and HA.Cod_Colaborador in (" & intCodColaborador & ")"
			sql = sql & " and h.CodTurno in (" & intCodTurnoProfessor & ")"
		end if
		sql = sql & " and e.letivo='S' "
		sql = sql & " and d.mes=" & cInt(strMes)
		sql = sql & " and cu.Cod_curso = " & intCodCurso
		sql = sql & " and ha.Cod_turma = " & intCodTurma	
		IF intCodDisciplina<>"0" THEN
			sql = sql & " and ha.cod_disciplina = " & intCodDisciplina
		END IF
		sql = sql & " order by d.dia_mes"
		rsAux1.open sql, cnn, 3, 3
		if not rsAux1.eof then
			vetAux1 = rsAux1.getRows
			existeLancamentoParaCriarCab = "S"
		end if
		rsAux1.close
	end if
	
	 '------------------------------------------------------------------------------
	 '----------------------INICIO DA BUSCA DE AULAS PREVISTAS ---------------------
	 '------------------------------------------------------------------------------
	
	 function buscaAulasExtrasTurma(cod_disciplina, Cod_Turma, strAnoLetivo, intCodTurno, codCursoAux, cursoAux, codPeriodoAux, periodoAux, codDisciplinaAux, disciplinaAux, turmaAux)

		 '==============================================================
		 ' OTIMIZACAO: uma unica consulta para todas as aulas extras.
		 ' Antes: 1 SELECT para listar extras + 1 SELECT por aula extra.
		 ' Agora: COUNT sobre as aulas extras que possuem planejamento.
		 '==============================================================
		 sql = "SELECT COUNT(*) AS qtde"
		 sql = sql & " FROM ("
		 sql = sql & "   SELECT DISTINCT E.DataLancamento, E.Sequencia"
		 sql = sql & "   FROM SCA_HORARIO_AULA_EXTRA E"
		 sql = sql & "   WHERE E.DataLancamento >= '" & strDataIniMes & "'"
		 sql = sql & "     AND E.DataLancamento < '" & strDataFimMesSQL & "'"
		 sql = sql & "     AND E.Cod_Turma = " & Cod_Turma
		 if intCodDisciplina <> "0" then
			 sql = sql & " AND E.Cod_Disciplina = " & cod_disciplina
		 end if
		 sql = sql & "     AND E.Cod_Empresa = " & Session("CodEmpresa")
		 sql = sql & "     AND E.AnoLetivo = " & strAnoLetivo
		 sql = sql & "     AND EXISTS ("
		 sql = sql & "       SELECT 1"
		 sql = sql & "       FROM SCA_PLANEJAMENTO_PROFESSOR P"
		 sql = sql & "       WHERE P.numero_aula IS NULL"
		 sql = sql & "         AND P.cod_turma = E.Cod_Turma"
		 sql = sql & "         AND P.anoLetivo = E.AnoLetivo"
		 sql = sql & "         AND P.cod_turno = " & intCodTurno
		 sql = sql & "         AND P.data_aula_extra = E.DataLancamento"
		 if intCodDisciplina <> "0" then
			 sql = sql & " AND P.cod_disciplina = E.Cod_Disciplina"
		 end if
		 sql = sql & "     )"
		 sql = sql & " ) X"

		 rsAux.open sql, cnn, 3, 1
		 if not rsAux.eof then
			 if not IsNull(rsAux("qtde")) then
				 intQtdeAulasPrevista = intQtdeAulasPrevista + CLng(rsAux("qtde"))
			 end if
		 end if
		 rsAux.close

	 end function


	intQtdeAulasPrevista = 0
	
	if cint(intCodCurso)=1 or cint(intCodCurso)=2 then
		sql="SELECT MES, COUNT(*) AS QTDE"
		sql=sql & " from sca_calendario_dia_ue d"
		sql=sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue"
		sql=sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento"
		sql=sql & " where c.cod_empresa =" & Session("CodEmpresa")
		sql=sql & " and d.ano =" & strAnoLetivo
		sql=sql & " AND d.mes=" & CInt(strMes)
		sql=sql & " and e.letivo = 'S'"
		sql=sql & " and d.cod_calendario_ue IN ("
		sql=sql & " 	select cod_calendario_ue"
		sql=sql & " 	from sca_calendario_ue cue"
		sql=sql & " 	inner join sca_calendario c"
		sql=sql & " 		on cue.cod_calendario_geral = c.cod_calendario"
		sql=sql & " 		and cue.ano_letivo = c.ano_letivo"
		sql=sql & " 	where cue.cod_curso =" & intCodCurso
		sql=sql & " 	and cue.ano_letivo =" & strAnoLetivo
		sql=sql & " 	and cue.situacao = 'A'"
		sql=sql & " 	and cod_empresa =" & Session("CodEmpresa")
		sql=sql & ")"
		sql=sql & " GROUP BY MES"
		rs.open sql, cnn, 3, 1
		if rs.eof = false Then
			intQtdeAulasPrevista = rs("QTDE")
		end if
		rs.close
	else

		 '==============================================================
		 ' OTIMIZACAO: o banco retorna somente a quantidade de aulas
		 ' previstas para MES + TURMA + DISCIPLINA atuais.
		 ' Antes o ASP carregava e percorria o calendario de varias turmas,
		 ' disciplinas e meses apenas para efetuar essa contagem.
		 '==============================================================
		 sql = "SELECT COUNT(*) AS qtde_aulas_previstas"
		 sql = sql & " FROM sca_calendario_dia_ue d"
		 sql = sql & " INNER JOIN sca_calendario_ue c ON c.cod_calendario_ue = d.cod_calendario_ue"
		 sql = sql & " INNER JOIN sca_calendario_evento e ON e.cod_calendario_evento = d.cod_calendario_evento"
		 sql = sql & " INNER JOIN SCA_HORARIO_AULA HA ON ha.AnoLetivo = d.ano AND ha.DiaSemana = d.dia_semana AND HA.COD_EMPRESA = c.cod_empresa"
		 sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO AND h.cod_empresa = ha.Cod_Empresa"
		 sql = sql & " INNER JOIN SCA_TURMA tu ON tu.Cod_Turma = ha.Cod_turma"
		 sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = Tu.COD_GRADECURRICULAR"
		 sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = G.COD_PERIODO"
		 sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO = P.COD_CURSO"
		 sql = sql & " INNER JOIN SCA_DISCIPLINA DI ON DI.Cod_Disciplina = HA.Cod_Disciplina AND DI.documento_oficial = 'S'"
		 sql = sql & " WHERE c.cod_empresa = " & Session("CodEmpresa")
		 sql = sql & " AND c.COD_CURSO = " & intCodCurso
		 sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
		 sql = sql & " AND HA.SEMESTRE IN (" & intSemestre & ")"
		 sql = sql & " AND d.ano = " & strAnoLetivo
		 sql = sql & " AND d.mes = " & CInt(strMes)
		 sql = sql & " AND HA.Cod_Colaborador IN (" & intCodColaborador & ")"
		 sql = sql & " AND h.CodTurno = " & intCodTurno
		 sql = sql & " AND e.letivo = 'S'"
		 sql = sql & " AND HA.Cod_turma = " & intCodTurma
		 if intCodDisciplina <> "0" then
			 sql = sql & " AND HA.Cod_Disciplina = " & intCodDisciplina
		 end if
		'response.write sql
		 rs.open sql, cnn, 3, 1
		 if not rs.eof then
			 if not IsNull(rs("qtde_aulas_previstas")) then
				 intQtdeAulasPrevista = CLng(rs("qtde_aulas_previstas"))
			 end if
		 end if
		 rs.close

		 'Acrescenta as aulas extras da mesma turma/disciplina.
		 buscaAulasExtrasTurma intCodDisciplina, intCodTurma, strAnoLetivo, intCodTurno, 0, "", 0, "", intCodDisciplina, "", ""
	end if

	



	' '------------------------------------------------------------------------------
	' '----------------------FIM DA BUSCA DE AULAS PREVISTAS ------------------------
	' '------------------------------------------------------------------------------
	
	
	
	
	
	
	
%>
<table width="98%" align="center" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		<input type="hidden" name="txtPosicao" value="<%=strPosicao%>">
        <input type="hidden" name="cmbQtdeFaltas" value="<%=strQtdeFaltas%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
		<input type="HIDDEN" name="txtData" value="<%=strData%>">
		           <!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
		  <%
			sql = "SELECT TU.NOMETURMA, TU.TURMAALUNO, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO, P.DESCRICAO AS PERIODO "
			sql = sql & " FROM SCA_TURMA TU"
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = TU.COD_PERIODO"
			sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO "
			sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
			rs.open sql, cnn
			if not rs.eof then
				strDescTurno = RS("DESC_TURNO")
				strDescPeriodo = rs("periodo")
				strDescTurmaAluno = rs("TURMAALUNO")
				strDescTurma = rs("NOMETURMA")
				
		  %>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#E5E5E5">
              <td width="3%" height="24" class="celula">&nbsp;<strong>Turma:</strong></td>
          	  <td width="13%" class="celula">&nbsp;<strong><%=rs("periodo")%>&nbsp;-&nbsp;<%=rs("TURMAALUNO")%>&nbsp;&nbsp;<%=rs("NOMETURMA")%></strong></td>
              <td width="7%" class="celula">&nbsp;<strong>Disciplina:</strong></td>
              <td width="77%" class="celula">&nbsp;<%if strNomedisciplina="" then%>Todas do Hor&aacute;rio<%else%><%=strNomedisciplina%><%end if%>&nbsp;</td>
            </tr>
			<tr bgcolor="#E5E5E5">
              <td width="3%" height="24"  class="celula">&nbsp;<strong>Turno:</strong></td>
              <td width="13%" class="celula">&nbsp;<%=RS("DESC_TURNO")%></td>
              <td width="7%" class="celula">&nbsp;<strong>Professor(a):</strong></td>
              <td width="77%" class="celula">&nbsp;<%=strProfessor%></td>
            </tr>
          </table>
		  <%
		  end if
		  rs.close
			'**** SELECIONA OS ALUNOS REGULARES E NOTAS E FALTAS
			buscaHistorico = "N"
			if trim(intSemestre) = "3" then
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
				  buscaHistorico = "S"
			   end if
			else
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
				  buscaHistorico = "S"
			   end if	   
			end if

			if buscaHistorico = "N" then
				sql = " SELECT distinct "
				sql = sql & " AD.COD_ALUNO AS CODIGO, " 
				sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
				sql = sql & " A.NOMEALUNO, "
				sql = sql & " A.MATRICULA, "
				sql = sql & " SIT.DESC_SITUACAOALUNO, SIT.DATA_SITUACAO "
				sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD " 
				sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO "

				'--------------------------------------------------------
				'-- Recupera apenas a última situação do aluno
				'--------------------------------------------------------
				sql = sql & " OUTER APPLY"
				sql = sql & " ("
				sql = sql & " 	SELECT TOP 1"
				sql = sql & " 		SS.Desc_SituacaoAluno, CS.DATA_SITUACAO"
				sql = sql & " 	FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
				sql = sql & " 	INNER JOIN SCA_SITUACAOALUNO SS"
				sql = sql & " 		ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
				sql = sql & " 	WHERE CS.COD_EMPRESA = AD.COD_EMPRESA"
				sql = sql & " 		AND CS.COD_ALUNO   = AD.COD_ALUNO"
				sql = sql & " 		AND CS.ANO_LETIVO  = " & strAnoLetivo
				sql = sql & " 	ORDER BY CS.CODIGO DESC"
				sql = sql & " ) SIT"
				sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
				'Inclui os alunos remanejados desta turma (marcação "rem. p/ ...")
				sql = sql & " AND " & remFiltroTurmaAD("AD", intCodTurma)
				sql = sql & " AND AD.COD_ALUNO in (" & strAlunos & ") "
				sql = sql & " ORDER BY A.NOMEALUNO "

			else   
			   'seleciona os alunos pelo ano e semestres do histórico 			
			   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO, '' AS DATA_SITUACAO "
			   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
			   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
			   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO" 'AND A.COD_EMPRESA = HE.COD_EMPRESA "
			   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO" 'AND SA.COD_EMPRESA = A.COD_EMPRESA " 
			   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO" 'AND AT.COD_EMPRESA = A.COD_EMPRESA "
			   'sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
			   sql = sql & " WHERE AT.COD_TURMA = " & intCodTurma	
			   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
			   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
			   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
			   sql = sql & " AND A.CODIGO in (" & strAlunos & ") "
			   sql = sql & " ORDER BY NOMEALUNO "
			end if
			
			'response.write sql
			'==============================================================
			' OTIMIZACAO: carrega todas as faltas do mes em memoria
			' Evita uma consulta SQL para cada ALUNO x DIA.
			'==============================================================
			sqlAlunos = sql
			Set dicFaltas = Server.CreateObject("Scripting.Dictionary")
			Set dicFaltasQtd = Server.CreateObject("Scripting.Dictionary")

			strDataIniFaltas = strAnoLetivo & Right("0" & strMes, 2) & "01"
			sql = " SELECT DISTINCT cod_aluno, data, falta"
			sql = sql & " FROM SCA_FALTAS_DIARIA"
			sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
			sql = sql & " AND cod_aluno IN (" & strAlunos & ")"
			sql = sql & " AND data >= '" & strDataIniFaltas & "'"
			sql = sql & " AND data < DATEADD(MONTH, 1, '" & strDataIniFaltas & "')"
			if intCodDisciplina <> "0" then
				sql = sql & " AND cod_disciplina = " & intCodDisciplina
			end if

			rsAux.open sql, cnn
			do while not rsAux.eof
				chaveFalta = CStr(rsAux("cod_aluno")) & "|" & _
					Year(rsAux("data")) & Right("0" & Month(rsAux("data")), 2) & Right("0" & Day(rsAux("data")), 2)
				valorFalta = 0
				if not isNull(rsAux("falta")) then valorFalta = CDbl(rsAux("falta"))
				if dicFaltas.Exists(chaveFalta) then
					dicFaltas(chaveFalta) = dicFaltas(chaveFalta) + valorFalta
					dicFaltasQtd(chaveFalta) = dicFaltasQtd(chaveFalta) + 1
				else
					dicFaltas.Add chaveFalta, valorFalta
					dicFaltasQtd.Add chaveFalta, 1
				end if
				rsAux.movenext
			loop
			rsAux.close

			'==============================================================
			' JUSTIFICATIVAS DE FALTAS - carregadas uma unica vez em memoria
			' Periodos 6 a 9: ALUNO + DATA + DISCIPLINA
			' Demais periodos: ALUNO + DATA
			' Somente considera justificativa quando existe falta real.
			'==============================================================
			Set dicFaltasJustificadas = Server.CreateObject("Scripting.Dictionary")

			'Dias com falta real usados para validar a justificativa:
			'	periodos 6 a 9: os da disciplina (dicFaltas, ja filtrado pela disciplina)
			'	demais periodos: qualquer falta do aluno no dia (qualquer disciplina)
			if CInt(intCodPeriodo) >= 6 and CInt(intCodPeriodo) <= 9 then
				Set dicDiaComFalta = dicFaltas
			else
				Set dicDiaComFalta = Server.CreateObject("Scripting.Dictionary")
				sql = " SELECT DISTINCT cod_aluno, data"
				sql = sql & " FROM SCA_FALTAS_DIARIA"
				sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
				sql = sql & " AND cod_aluno IN (" & strAlunos & ")"
				sql = sql & " AND data >= '" & strDataIniFaltas & "'"
				sql = sql & " AND data < DATEADD(MONTH, 1, '" & strDataIniFaltas & "')"
				rsAux.open sql, cnn
				do while not rsAux.eof
					chaveDia = CStr(rsAux("cod_aluno")) & "|" & Year(rsAux("data")) & Right("0" & Month(rsAux("data")), 2) & Right("0" & Day(rsAux("data")), 2)
					if not dicDiaComFalta.Exists(chaveDia) then dicDiaComFalta.Add chaveDia, True
					rsAux.movenext
				loop
				rsAux.close
			end if

			'OTIMIZACAO: a "falta real" é conferida em memória (dicDiaComFalta),
			'sem o JOIN com SCA_FALTAS_DIARIA por CAST(data), que estourava o tempo em turmas grandes
			sql = " SELECT DISTINCT J.cod_aluno, CAST(D.DataFalta AS DATE) AS DataFalta"
			sql = sql & " FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS J"
			sql = sql & " INNER JOIN SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA D ON D.cod_aluno_justificativa_faltas = J.codigo"
			sql = sql & " WHERE J.cod_empresa = " & Session("CodEmpresa")
			sql = sql & " AND J.ano_letivo = " & strAnoLetivo
			sql = sql & " AND J.Cod_turma = " & intCodTurma
			sql = sql & " AND J.cod_aluno IN (" & strAlunos & ")"
			sql = sql & " AND D.DataFalta >= '" & strDataIniFaltas & "'"
			sql = sql & " AND D.DataFalta < DATEADD(MONTH, 1, '" & strDataIniFaltas & "')"
			if CInt(intCodPeriodo) >= 6 and CInt(intCodPeriodo) <= 9 and intCodDisciplina <> "0" then
				sql = sql & " AND ISNULL(D.cod_disciplina,0) = " & intCodDisciplina
			end if
			rsAux.open sql, cnn
			do while not rsAux.eof
				chaveJustificada = CStr(rsAux("cod_aluno")) & "|" & Year(rsAux("DataFalta")) & Right("0" & Month(rsAux("DataFalta")), 2) & Right("0" & Day(rsAux("DataFalta")), 2)
				'Somente considera justificativa quando existe falta real (lançada em SCA_FALTAS_DIARIA no mês)
				if dicDiaComFalta.Exists(chaveJustificada) and not dicFaltasJustificadas.Exists(chaveJustificada) then dicFaltasJustificadas.Add chaveJustificada, True
				rsAux.movenext
			loop
			rsAux.close

			'Remanejamentos da turma (origem: "rem. p/ ..." | destino: "rem. de ...")
			set dicRemanejamento = remCarregaTurma(intCodTurma, strAnoLetivo)

			sql = sqlAlunos
			rs.open sql, cnn
			%>		  
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td colspan="2" rowspan="2" align="center" class="celula"><strong><%=ucase(monthName(strMes))%></strong></td>
            <td height="24"  colspan="32" align="center" class="celula"><strong><%=ucase(strNomeTipoBimestre)%></strong></td>
            </tr>
          <tr bgcolor="#E5E5E5">
            <td height="24" colspan="32" align="center" class="celula"><strong>FALTA&nbsp;<%=strNomeNota%></strong></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="19" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td class="celula"><div align="center"><strong>Nome do Aluno </strong></div></td>
            
			<%
			if isArray(vetAux1) then
				for j=0 to ubound(vetAux1,2)
				   diaConteudo = vetAux1(0,j) 
				   %>
                   <td class="celula" align="center"><strong><%=ZeroLeft(diaConteudo,2)%></strong></td>
                   <%
				next	

				%>
            	<td class="celula" align="center"><strong>Jus.</strong></td>
            	<td class="celula" align="center"><strong>Fal.</strong></td>
            	</tr>
		  		<%

			end if	
		  contLanc = 0
		  while not rs.eof
		  		contLanc = contLanc + 1
				strCodAluno = RS("CODIGO")
				DESC_SITUACAOALUNO = "&nbsp;<span style='font-size: 9px; color: red;'>" & RS("DESC_SITUACAOALUNO") & "&nbsp;" & FORMATADATAAP(RS("DATA_SITUACAO")) & "</span>"
				strDataSituacaoAluno = RS("DATA_SITUACAO")
				IF RS("DESC_SITUACAOALUNO")="ATIVO" THEN DESC_SITUACAOALUNO = ""
				  %>
				  <tr>
					<td class="celula" width="6%"><div align="center"><%=rs("MATRICULA")%>
					    <input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>">
			        </div></td>
					<td class="celula" width="67%">&nbsp;<%=rs("NOMEALUNO") %><%=DESC_SITUACAOALUNO%><%=remMarcacaoHtml(dicRemanejamento, strCodAluno)%></td>
                    <%
					AcumuladaFalta = 0
					AcumuladaFaltaJustificada = 0
					if isArray(vetAux1) then
						for j=0 to ubound(vetAux1,2)
							
							diaConteudo = vetAux1(0,j) 
							strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(diaConteudo,0)
                            diaSemana = weekday(strData)
							strCorPodeFazerAvaliacao = ""
							strStyleJustificativa = ""
							bolFalta = false
							selecionado = "0"
							mostraPresenca = "S"
							
							if strDataSituacaoAluno<>"" and DESC_SITUACAOALUNO<>"" then
							'verifica o dia da transferencia para não mostrar "." no Diário
								'if session("usuarioWeb") = "SERGIO" then
								'response.write "<br>strData:" & ConverteData(formataDataBD(strData))
								'response.write "<br>strDataSituacaoAluno:" & ConverteData(formataDataBD(strDataSituacaoAluno))
								'end if
							
								If ConverteData(formataDataBD(strData)) > ConverteData(formataDataBD(strDataSituacaoAluno)) Then
									mostraPresenca = "N"
								end if
							end if

							'Remanejamento: na origem não mostra os dias a partir da data; no destino, os dias anteriores
							if remDiaForaDaTurma(dicRemanejamento, strCodAluno, strData) then
								mostraPresenca = "N"
							end if
							
							IF mostraPresenca = "S" THEN
								'OTIMIZADO: faltas carregadas previamente em memória.
								chaveFalta = CStr(strCodAluno) & "|" & strAnoLetivo & Right("0" & strMes, 2) & Right("0" & diaConteudo, 2)
								if dicFaltas.Exists(chaveFalta) then
									bolFalta = true

									'Na versão atual do relatório, qualquer falta é exibida como "F".
									selecionado = "F"

									'Preserva exatamente a regra atual de totalização:
									'INTERDISCIPLINAR conta 1 para cada registro distinto encontrado;
									'nas demais disciplinas soma o campo falta.
									if strNomedisciplina = "INTERDISCIPLINAR" then
										AcumuladaFalta = AcumuladaFalta + dicFaltasQtd(chaveFalta)
									else
										AcumuladaFalta = AcumuladaFalta + dicFaltas(chaveFalta)
									end if

									'Fundo verde e total de justificadas somente quando ha falta real neste dia.
									if dicFaltasJustificadas.Exists(chaveFalta) then
										AcumuladaFaltaJustificada = AcumuladaFaltaJustificada + 1
										strStyleJustificativa = " style=""background-color:#d9ead3;"""
									end if
								else
									if diaSemana = 7 then
										selecionado = "S.L."
									else
										selecionado = "."
									end if
								end if
							ELSE
								selecionado = "&nbsp;"
							END IF
							%>
							<td class="celula" width="1%" align="center"<%=strStyleJustificativa%>><%=selecionado%></td>
							<%
						next
					end if	
					if AcumuladaFaltaJustificada = 0 then AcumuladaFaltaJustificada = ""
					if AcumuladaFalta = 0 then AcumuladaFalta = ""
					%>
 					<td class="celula" width="1%" align="center"><%=AcumuladaFaltaJustificada%>&nbsp;</td>
 					<td class="celula" width="1%" align="center"><%=AcumuladaFalta%>&nbsp;</td>
                </tr>
			  <%
		  		rs.movenext
		  wend
		  rs.close
		  
		  %>
        </table>
		<input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
		<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
		<input type="hidden" name="cmbDisciplinaTurma" value="<%=intCodDisciplina%>">
		<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>">
		<input type="hidden" name="cmbTurno" value="<%=intCodTurno%>">
		<input type="hidden" name="chkAluno" value="<%=strAlunos%>">
		<input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">

		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacao" value="<%=intMediaAprovacao%>"> 
		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacaoFinal" value="<%=intMediaAprovacaoFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenTipoFormulaFinal" value="<%=strTipoFormulaFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenFreqMinima" value="<%=intFreqMinima%>"> 
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenRecuperacao" value="<%=strRecuperacao%>">	
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenConselho" value="<%=strConselho%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de recuperação-->
        <input type="hidden" name="txtHiddenNumDisciplinaRec" value="<%=intNumDisciplinaRec%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de prog. parcial-->
        <input type="hidden" name="txtHiddenNumDisciplinaProgParcial" value="<%=intNumDisciplinaProgParcial%>"> 
        <!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenReprovacaoFaltaProgParcial" value="<%=strReprovacaoFaltaProgParcial%>"> 
		<!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenNotaDoTipoEF" value="<%=strNotaDoTipoEF%>">
        <input type="hidden" name="txtQtdeDias" value="<%=qtdeDiasMes%>">
        <input type="hidden" name="cmbMes" value="<%=strMes%>">	
		
		<div align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
		  <input type="hidden" name="txtAnoLetivo" value="<%=strAnoLetivo%>">
		  <input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
          <input type="hidden" name="txtPaginaRetorno" value="FALTASPROF">
		</form>

			<table width="100%" align="center" class="tabela" border="1" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="30%" height="135" align="center" class="celula">
				<table width="93%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="2" height="24">&nbsp;LEGENDA: </td>
				  </tr>
				  <tr>
					<td colspan="2" width="23%" height="19">&nbsp;&quot;.&quot; (ponto) = Presente na aula do dia;</td>
				  </tr>
				  <tr>
					<td colspan="2" height="19">&nbsp;&quot;F&quot; = Falta;</td>
				  </tr>
				  <tr>
					<td colspan="2" height="19">&nbsp;&quot;S.L.&quot; = Sábado letivo;</td>
				  </tr>
				  <tr>
					<td width="1%" height="19" style="background-color:#d9ead3;">&nbsp;&quot;F&quot;</td>
					<td height="19" > =&nbsp;Falta justificada</td>
				  </tr>
				</table></td>
				<td width="33%" align="center" class="celula" valign="top">
				<!--
				<table width="91%" border="0" cellspacing="0" cellpadding="0">
				  <tr valign="top">
					<td height="23" align="center">PARA USO DA COORDENAÇÃO </td>
				  </tr>
				  <tr>
					<td width="33%" height="17">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">____________________________</td>
				  </tr>
				  <tr>
					<td height="17" align="center">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">_________/_________/_________</td>
				  </tr>
				</table>
				-->
				
				<table width="91%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="2" height="40">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="50%" height="23" align="center">
					  ____________________________
					</td>
					<td width="50%" height="23" align="center">
					  ____________________________
					</td>
				  </tr>
				  <tr>
					<td height="23" align="center">COORDENAÇÃO GERAL</td>
					<td height="23" align="center">COORDENAÇÃO PEDAGÓGICA</td>
				  </tr>
				</table>				
				
				</td>
				<td width="37%" align="center" class="celula" valign="top">
					<!--
					<table width="91%" border="0" cellspacing="0" cellpadding="0">
					  <tr valign="top">
						<td height="23">AULAS PREVISTAS: <%=intQtdeAulasPrevista%> </td>
					  </tr>
					  <tr>
						<td width="33%" height="23">AULAS MINISTRADAS:  <%=intQtdeAulasMinistradas%></td>
					  </tr>
					  <tr>
						<td height="30">DATA:_________/_________/_________ </td>
					  </tr>
					  <tr>
						<td height="17">&nbsp;</td>
					  </tr>
					  <tr>
						<td height="23"><div align="center">____________________________________</div></td>
					  </tr>
					  <tr>
							<td height="17"><div align="center">ASSINATURA DO PROFESSOR</div></td>
					  </tr>
					</table>
				    -->
					
					<table width="91%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td height="23">AULAS PREVISTAS: <%=intQtdeAulasPrevista%></td>
					  </tr>
					  <tr>
						<td height="23">AULAS MINISTRADAS: <%=intQtdeAulasMinistradas%></td>
					  </tr>
					  <tr>
						<td height="30">DATA:_________/_________/_________</td>
					  </tr>
					  <tr>
						<td height="35">&nbsp;</td>
					  </tr>
					  <tr>
						<td>
						  <%
						  Dim arrProfessores, nomeProfessor, iProfessor
						  Dim dicProfessores, chaveProfessor

						  Set dicProfessores = Server.CreateObject("Scripting.Dictionary")
						  dicProfessores.CompareMode = 1 ' Ignora maiúsculas/minúsculas

						  If Not IsNull(strProfessor) Then
							arrProfessores = Split(strProfessor, "|")

							For iProfessor = 0 To UBound(arrProfessores)
							  nomeProfessor = Trim(arrProfessores(iProfessor))

							  If nomeProfessor <> "" Then
								If Not dicProfessores.Exists(nomeProfessor) Then
								  dicProfessores.Add nomeProfessor, nomeProfessor
								End If
							  End If
							Next
						  End If

						  If dicProfessores.Count > 0 Then
						  %>
						  <table width="100%" border="0" cellspacing="0" cellpadding="0"
								 style="table-layout: fixed;">
							<tr valign="top">
							  <%
							  For Each chaveProfessor In dicProfessores.Keys
							  %>
							  <td align="center" style="padding: 0 10px;">
								<div style="width: 90%; border-top: 1px solid #000;
											padding-top: 5px; overflow-wrap: break-word;">
								  <%=Server.HTMLEncode(dicProfessores(chaveProfessor))%>
								</div>
							  </td>
							  <%
							  Next
							  %>
							</tr>
						  </table>
						  <%
						  End If

						  Set dicProfessores = Nothing
						  %>
						</td>
					  </tr>
					</table>

					
				</td>
			  </tr>
			</table>

		</td>
      </tr>
    </table>
    
	</td>
  </tr>
</table>

<%if strMostraConteudo = "S" then %>

	<pre></pre>

	<%
	
	dataInicio = "01/" & strMes & "/" & strAnoLetivo
	dataFim = dateadd("d","-1", dateAdd("m",1,dataInicio))	
	
	
		sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	
    <table width="100%" cellspacing="0" cellpadding="0" class="tabela">
	  <tr>
		<!--td width="100px" align="left" class="celula"><strong>Curso:</strong> <%=strCurso%></td>
		<td width="100px" align="left" class="celula"><strong>Período:</strong> <%=strPeriodo%></td-->
		<td width="100px" align="left" class="celula"><strong>Turma:</strong> <%=strDescPeriodo%>&nbsp;-&nbsp;<%=strDescTurmaAluno%>&nbsp;&nbsp;<%=strDescTurma%></td>
		<%if strDescTurno<>"" then%>
		<td width="100px" align="left" class="celula"><strong>Turno:</strong> <%=strDescTurno%></td>
		<%end if%>		
		<td width="100px" align="left" class="celula"><strong>Componente curricular:</strong> <%if strNomedisciplina="" then%>Todas do Hor&aacute;rio<%else%><%=strNomedisciplina%><%end if%></td>
		<td width="100px" align="left" class="celula"><strong>Professor(a):</strong> <%=strProfessor%></td>
	  </tr>
	</table>
	
	<br>
	<table width="100%" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="70px" align="center" class="celula"><strong>Data</strong></td>
		<!--td width="100px" align="center" class="celula"><strong>Professor(a)</strong></td-->
		<td width="20px" class="celula"><strong>Aula</strong></td>
		<td class="celula"><strong>Conteúdo Ministrado</strong></td>
		<td width="150px" class="celula"><strong>ConteúdoComplementar</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

    ' Regra de agrupamento: Infantil I/II/III integral ou Fundamental 1o ao 5o ano.
    ' Identificacao pelo periodo e turno efetivamente cadastrados na turma.
    agruparConteudoDia = False
    sqlRegra = "SELECT TU.COD_PERIODO, TU.COD_TURNO, ISNULL(TN.DESC_TURNO,'') AS DESC_TURNO " & _
               "FROM SCA_TURMA TU " & _
               "LEFT JOIN SCA_TURNO TN ON TN.COD_TURNO = TU.COD_TURNO " & _
               "WHERE TU.COD_EMPRESA = " & CLng(Session("CodEmpresa")) & _
               " AND TU.COD_TURMA = " & CLng(intCodTurma)
    Set rsRegra = cnn.Execute(sqlRegra)
    If Not rsRegra.EOF Then
        codPeriodoRegra = CLng(rsRegra("COD_PERIODO"))
        codTurnoRegra = CLng(rsRegra("COD_TURNO"))
        ' Guapó: Agrupamentos I a V = períodos 10 a 14; integral pela descrição do turno
        agruparConteudoDia = ((codPeriodoRegra >= 1 And codPeriodoRegra <= 5) Or _
                             ((codPeriodoRegra >= 10 And codPeriodoRegra <= 14) And InStr(UCase(rsRegra("DESC_TURNO") & ""), "INTEGRAL") > 0))
    End If
    rsRegra.Close
    Set rsRegra = Nothing
	intQtdeRegistroPorPagina = 0
	intPagina = 1
	mostraCabecalho
	contExtra = 0
	contAula = 0
	contGeral = 0
	disciplina = ""
	textSabadoAnterior = ""
	sql="SP_rel_conteudo_ministrado 0," & intCodTurma & "," & intCodTurnoRH & "," & intCodDisciplina & ",'" & formatadataBD(dataInicio) & "', '" & formatadataBD(dataFim) & "'"
		'if session("usuarioWeb") = "ROBERTO" THEN
		'	RESPONSE.WRITE SQL & "<hr>"
		'end if
	rs.open sql, cnn
	if not rs.eof then
        If agruparConteudoDia Then
            ' Agrupamento global por data, mesmo quando a procedure ordena por disciplina.
            Set diasAgrupados = Server.CreateObject("Scripting.Dictionary")
            Set textosPorDia = Server.CreateObject("Scripting.Dictionary")
            Set aulasPorDia = Server.CreateObject("Scripting.Dictionary")
            Set professoresPorDia = Server.CreateObject("Scripting.Dictionary")
            Set complementosPorDia = Server.CreateObject("Scripting.Dictionary")
            contAula = 0
            contExtra = 0
            Do While Not rs.EOF
                If Not IsNull(rs("data_aula")) Then
                    chaveDia = Right("0000" & Year(CDate(rs("data_aula"))), 4) & Right("0" & Month(CDate(rs("data_aula"))), 2) & Right("0" & Day(CDate(rs("data_aula"))), 2)
                    If Not diasAgrupados.Exists(chaveDia) Then
                        diasAgrupados.Add chaveDia, Day(CDate(rs("data_aula"))) & "/" & Right("0" & Month(CDate(rs("data_aula"))), 2) & "/" & Year(CDate(rs("data_aula")))
                        Set itensDia = Server.CreateObject("Scripting.Dictionary")
                        itensDia.CompareMode = 1
                        textosPorDia.Add chaveDia, itensDia
                        Set itensAula = Server.CreateObject("Scripting.Dictionary")
                        aulasPorDia.Add chaveDia, itensAula
                        Set itensProf = Server.CreateObject("Scripting.Dictionary")
                        itensProf.CompareMode = 1
                        professoresPorDia.Add chaveDia, itensProf
                        Set itensComplemento = Server.CreateObject("Scripting.Dictionary")
                        itensComplemento.CompareMode = 1
                        complementosPorDia.Add chaveDia, itensComplemento
                    End If
                    Set itensDia = textosPorDia(chaveDia)
                    If Not IsNull(rs("desc_conteudo_ministrado")) Then
                        partesConteudo = Split(CStr(rs("desc_conteudo_ministrado")), "|")
                        For Each parteConteudo In partesConteudo
                            textoLimpo = Trim(CStr(parteConteudo))
                            If Len(textoLimpo) > 0 Then
                                If Not itensDia.Exists(textoLimpo) Then itensDia.Add textoLimpo, textoLimpo
                            End If
                        Next
                    End If
                    Set itensAula = aulasPorDia(chaveDia)
                    If Not IsNull(rs("numero_aula")) Then
                        numeroAtual = Trim(CStr(rs("numero_aula")))
                        If Len(numeroAtual) > 0 Then
                            If Not itensAula.Exists(numeroAtual) Then itensAula.Add numeroAtual, numeroAtual
                        End If
                        contAula = contAula + 1
                    Else
                        ' Preserva a contagem de sabados letivos do relatorio original.
                        If Not IsNull(rs("desc_conteudo_ministrado")) Then
                            partesExtra = Split(CStr(rs("desc_conteudo_ministrado")), "|")
                            textoSabadoAnteriorGrupo = ""
                            For idxExtra = 0 To UBound(partesExtra) - 1
                                campoSabadoGrupo = Left(partesExtra(idxExtra), 16)
                                If Trim(campoSabadoGrupo) <> Trim(textoSabadoAnteriorGrupo) Then contExtra = contExtra + 1
                                textoSabadoAnteriorGrupo = campoSabadoGrupo
                            Next
                        End If
                    End If
                    Set itensProf = professoresPorDia(chaveDia)
                    If Not IsNull(rs("professor")) Then
                        valorProf = Trim(CStr(rs("professor")))
                        If Len(valorProf) > 0 Then
                            If Not itensProf.Exists(valorProf) Then itensProf.Add valorProf, valorProf
                        End If
                    End If
                    Set itensComplemento = complementosPorDia(chaveDia)
                    If Not IsNull(rs("desc_conteudo_complementar")) Then
                        valorComplemento = Trim(CStr(rs("desc_conteudo_complementar")))
                        If Len(valorComplemento) > 0 Then
                            If Not itensComplemento.Exists(valorComplemento) Then itensComplemento.Add valorComplemento, valorComplemento
                        End If
                    End If
                End If
                rs.MoveNext
            Loop
            chavesDias = diasAgrupados.Keys
            ' Ordena datas crescentes (YYYYMMDD).
            For ix = 0 To UBound(chavesDias)
                For jx = ix + 1 To UBound(chavesDias)
                    If chavesDias(jx) < chavesDias(ix) Then
                        tmpDia = chavesDias(ix)
                        chavesDias(ix) = chavesDias(jx)
                        chavesDias(jx) = tmpDia
                    End If
                Next
            Next
            For Each chaveDia In chavesDias
                Set itensDia = textosPorDia(chaveDia)
                Set itensAula = aulasPorDia(chaveDia)
                Set itensProf = professoresPorDia(chaveDia)
                Set itensComplemento = complementosPorDia(chaveDia)
                Response.Write "<tr bgcolor='#FFFFFF'>"
                Response.Write "<td class='celula'>" & formatadataAP(Server.HTMLEncode(diasAgrupados(chaveDia))) & "</td>"
                'Response.Write "<td class='celula'>" & Server.HTMLEncode(Join(itensProf.Keys, ", ")) & "</td>"
                Response.Write "<td class='celula'>" & Server.HTMLEncode(Join(itensAula.Keys, ", ")) & "</td>"
                Response.Write "<td class='celula'>" & Replace(Server.HTMLEncode(Join(itensDia.Keys, vbLf)), vbLf, "<br>") & "</td>"
                Response.Write "<td class='celula'>" & Replace(Server.HTMLEncode(Join(itensComplemento.Keys, vbLf)), vbLf, "<br>") & "</td>"
                Response.Write "</tr>"
                intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
            Next
            Set diasAgrupados = Nothing
            Set textosPorDia = Nothing
            Set aulasPorDia = Nothing
            Set professoresPorDia = Nothing
            Set complementosPorDia = Nothing
        Else
		%>
		  <tr>
			<td colspan="6" class="celula font14">Componente curricular: <strong><%=rs("disciplina")%></strong></td>
		  </tr>
		<%
		While not rs.eof
			
			
			if not isnull(rs("desc_conteudo_ministrado")) then
	  			strDescContMin = rs("desc_conteudo_ministrado")
				if isnull(rs("numero_aula")) then
					ArrayExtra = split(strDescContMin,"|")
					
					for i=0 to UBound(ArrayExtra)-1
						campoSabadoAtual = left(ArrayExtra(i),16)
						
						if trim(campoSabadoAtual) <> trim(textSabadoAnterior) then
							contGeral = contGeral + 1
							contExtra = contExtra + 1
						end if
						textSabadoAnterior = left(ArrayExtra(i),16)
					next
					
					fundoLinha = " bgcolor='#fcfedb' "
				else
					contAula = contAula + 1
					contGeral = contGeral + 1
					fundoLinha = " bgcolor='#FFFFFF' "
				end if
			else
				strDescContMin = ""
			end if
			
			%>
			  <tr <%=fundoLinha%> >
				<td class="celula"><%=rs("data_aula")%></td>
				<!--td class="celula"><%=rs("professor")%> </td-->
				<td class="celula"><%=rs("numero_aula")%></td>
				<td class="celula"><%=replace(strDescContMin,"|","<br>")%></td>
				<td class="celula"><%=rs("desc_conteudo_complementar")%></td>
			  </tr>
			<%

			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			textSabadoAnterior = ""
			rs.movenext
		wend
        End If
		
		%>
		  <tr>
			<!--td colspan="4" class="celula">Quantidade de aula: <%=contAula%> | Quantidade de aula sábado letivo: <%=contExtra%> | Total: <%=contAula+contExtra%></td-->
			<td colspan="4" class="celula">Total de aulas ministradas: <%=intQtdeAulasMinistradas%></td>
		  </tr>
		  
		  <%if strAssinatura="S" then%>
		  <tr height="28">
				<td colspan="4">
					<br>
					<br>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="50%" align="center">______________________________________</td>
						<td width="50%" align="center">______________________________________</td>
					  </tr>
					  <tr>
						<td align="center" valign="top">Coordenador(a)</td>
						<td align="center" valign="top">Professor(a)</td>
					  </tr>
					</table>					
					<br>
				</td>
			</tr>
			<%end if%>
		 <%
		else
			if strArquivoPlanejamentoEnviado = "S" then
		%>
			<tr>
				<td height="13" colspan="4" align="center" class="celula"><font color="#26bd34"><strong>Planejamento/Conteúdo Ministrado em anexo.</strong></font></td>
			</tr>
		<%
			else
		%>
			<tr>
				<td height="13" colspan="4" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
			</tr>
		<%
			end if
	end if
	rs.close
%>
</table>


<% end if 

sql = "select observacao from SCA_OBSERVACAO_DIARIO_TURMA"
sql=sql & " where cod_turma=" & intCodTurma
sql=sql & " and month(data) = " & strMes
sql=sql & " and year(data) = " & strAnoLetivo
rs.open sql, cnn
if not rs.eof then
	strObservacao = rs("observacao")
end if
rs.Close

if trim(strObservacao) <> "" then
%>
		<br><table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
			<tr>
				<td class="celula"><strong>Observação:</strong> <br><%=strObservacao%></td>
			</tr>
		</table>
		
<%
		end if
%>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>