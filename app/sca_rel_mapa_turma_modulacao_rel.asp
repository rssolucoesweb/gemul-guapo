<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Mapa Turma Modulação</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
<br>
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	''strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodCurso	 				= Trim(Request.Form("cmbCurso"))
	if intCodCurso	= "" then intCodCurso = "0"
	strCodTurno		 			= Trim(Request.Form("cmbTurno"))
	curso		 			= Trim(Request.Form("cmbTipoCurso"))
	
	
	strFiltro	 				= Trim(Request("f"))
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno			= Trim(Request.Form("cmbSituacaoAluno"))
	intCodEmpresaGrupo			= Trim(Request.Form("cmbEmpresaGrupo"))
	strSexo						= Trim(Request.Form("cmbSexo"))
	strIntervaloIdadeInicial 	= Trim(Request.Form("txtIntervaloIdadeInicial"))
	strIntervaloIdadeFinal  	= Trim(Request.Form("txtIntervaloIdadeFinal"))
	strSomentoIncosistecia		= Trim(Request.Form("SomentoIncosistecia"))
	strPromoverAnoLetivo		= Trim(Request.Form("PromoverAnoLetivo"))
	
	
	if intCodSituacaoAluno <> "" then
	
		sql = "SELECT COD_SITUACAOALUNO, DESC_SITUACAOALUNO"
		sql = sql & " FROM SCA_SITUACAOALUNO"
		sql = sql & " WHERE COD_SITUACAOALUNO=" & intCodSituacaoAluno
		rs.open sql, cnn
		if rs.eof = false then
			strSITUACAOALUNO 		= Trim(rs("DESC_SITUACAOALUNO"))
		end if
		rs.close
	end if
	
	if intCodSituacaoAluno 	= "" then intCodSituacaoAluno = "0"
	if session("usuarioWEB") = "USUARIO.TESTE" then
       intCodEmpresaGrupo = session("codEmpresa")
	end if
	
	strFiltroSerie = "0"
	strFiltroTurno = "0"
	intVagasPositivoTotal = 0

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "MAPA DE TURMAS - Modulação "
	if strPromoverAnoLetivo = "S" then strTituloRelatorio = strTituloRelatorio & intAnoLetivoAtual + 1
	IF strFiltro = "A" THEN strTituloRelatorio = strTituloRelatorio & "ATIVAS"
	IF strSexo = "F" THEN strTituloRelatorio = strTituloRelatorio & "<BR>SEXO: FEMININO"
	IF strSexo = "M" THEN strTituloRelatorio = strTituloRelatorio & "<BR>SEXO: MASCULINO"
	if strIntervaloIdadeInicial <> "" and  strIntervaloIdadeFinal <> "" then
		if strIntervaloIdadeInicial  <>  strIntervaloIdadeFinal then
	   		strTituloRelatorio = strTituloRelatorio & "<BR>IDADE: " & strIntervaloIdadeInicial & " a " & strIntervaloIdadeFinal & " anos"
		else
	   		strTituloRelatorio = strTituloRelatorio & "<BR>IDADE: " & strIntervaloIdadeInicial & " anos"
		end if
	end if
	
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
		
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorioGrupo.asp"-->
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="28%" class="celula"><strong>Empresa</strong></td>
		<td width="30%" class="celula"><div align="center"><strong>Turma</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Turno</strong></div></td>
	    <td width="9%" class="celula"><div align="center"><strong>Hor&aacute;rio</strong></div></td>
	    <td width="9%" class="celula"><div align="center"><strong>Matriz</strong></div></td>
	    <td width="5%" class="celula"><div align="center"><strong>Capacidade</strong></div></td>
	    <td width="5%" class="celula"><div align="center"><strong>Ocupa&ccedil;&atilde;o</strong></div></td>
	    <td width="5%" class="celula"><div align="center"><strong>Vagas</strong></div></td>
	  </tr>
	<%
	end Sub
	
	intPagina = 1
	mostraCabecalho
	cont = 0
	contCurso = 0
	contTurmaUnidade = 0
	intCodTurma = 0
	
	if strFiltro = "A" then
	
		sql = "SELECT distinct SCA_PERIODO.cod_Periodo, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.Cod_curso, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURNO.DESC_TURNO AS TURNO, SEG_EMPRESA.RAZAOSOCIAL as empresa, SEG_EMPRESA.Codigo  as CodigoEmpresa,"
		
		sql = sql & " (SELECT count(cod_turma) from SCA_HORARIO_AULA "
		sql = sql & " where cod_empresa =  SEG_EMPRESA.Codigo "
		sql = sql & " and cod_turma = SCA_TURMA.COD_TURMA "
		sql = sql & " and anoLetivo = SCA_TURMA.AnoLetivo "
		sql = sql & " and semestre = SCA_TURMA.cod_semestre ) as HORARIO, "

		sql = sql & " ( SELECT distinct SUM(GD.Ch_Semanal) "
		sql = sql & " FROM SCA_TURMA T " 
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.SITUACAO = 'A' "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR "
		sql = sql & " WHERE T.COD_EMPRESA = SEG_EMPRESA.Codigo "
		sql = sql & " AND COD_TURMA = SCA_TURMA.COD_TURMA ) as matriz, "
		
		sql = sql & " (select CAPACIDADE from SCA_TURMA T where T.COD_TURMA = SCA_TURMA.COD_TURMA ) AS CAPACIDADE, "

		sql = sql & " (select count(*) as alunos from sca_aluno a"
		sql = sql & " inner join sca_aluno_turma at on at.cod_aluno = a.codigo"
		sql = sql & " inner join sca_turma t on t.cod_turma = at.cod_turma"
		sql = sql & " inner join sca_periodo p on t.cod_periodo = p.cod_periodo"
		sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
		sql = sql & " inner join seg_empresa e on e.codigo = t.cod_empresa"
		sql = sql & " inner join sca_situacaoaluno s on s.cod_situacaoaluno = a.cod_situacaoaluno"
		sql = sql & " where  T.COD_EMPRESA = SEG_EMPRESA.Codigo and t.cod_turma= SCA_TURMA.COD_TURMA and t.anoletivo = " & intAnoLetivoAtual
		sql = sql & " and e.cod_grupo = " & session("CodGrupo")	
		sql = sql & " and e.bloqueio = 'N'"
		sql = sql & " and at.SITUACAO = 'A'"
		sql = sql & " and t.SITUACAO = 'A'"
		if curso <> "0" and curso<>"" then
			sql = sql & " and c.descricao = '" & curso & "'"
		end if
		if intCodSituacaoAluno = "0" then
			SQL = SQL & " and s.Desc_SituacaoAluno IN ('ATIVO','PRÉ-MATRÍCULA')"
		else
			'SQL = SQL & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
			SQL = SQL & " and s.Desc_SituacaoAluno = '" & trim(strSITUACAOALUNO) & "'"
		end if
		
		if strSexo <> "0" then
			sql = sql & " and a.SEXOALUNO = '" & strSexo & "'"
		end if
		
		if strIntervaloIdadeInicial <> ""  then
			sql = sql & " AND FLOOR(DATEDIFF(DAY, a.datanascimento, GETDATE()) / 365.25) >= " & strIntervaloIdadeInicial 
		end if	
		
		if strIntervaloIdadeFinal <> "" then
			sql = sql & " AND FLOOR(DATEDIFF(DAY, a.datanascimento, GETDATE()) / 365.25) <= " & strIntervaloIdadeFinal 
		end if	
		
		sql = sql & ") as intOcupada, SCA_TURMA.TurmaAluno  "

		sql = sql & " FROM SCA_ALUNO_TURMA "
		sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
		sql = sql & " INNER JOIN SCA_TURMA ON (SELECT TOP 1 COD_TURMA FROM SCA_ALUNO_TURMA WHERE COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual & " and SCA_ALUNO_TURMA.Semestre in (" & intSemestreAtual & ") ORDER BY CODIGO DESC) = SCA_TURMA.Cod_Turma  "
		sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
		sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SCA_TURMA.cod_empresa "
		sql = sql & " where 1=1"
		sql = sql & " and SCA_TURMA.SITUACAO = 'A'"
		if curso <> "0" and curso<>"" then
			sql = sql & " and SCA_CURSO.descricao = '" & curso & "'"
		end if
		if intCodEmpresaGrupo <> "" and intCodEmpresaGrupo <> "0" then
			sql = sql & " And SCA_TURMA.cod_empresa = " & intCodEmpresaGrupo
		else
		 	sql = sql & " And SEG_EMPRESA.cod_grupo  = " & session("CodGrupo")	
		end if
		sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
		sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual
		if intSemestreAtual <> "" and intSemestreAtual <> "0" then
			sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestreAtual
		end if
		if intCodCurso <> "0" then
			sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
		end if
		if strCodTurno <> "0" then
			sql = sql & " and substring(SCA_TURMA.Nometurma,6,1) = '" & strCodTurno & "'"
		end if
	'response.write sql
	else
		sql = "SELECT distinct SCA_PERIODO.cod_Periodo, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.Cod_curso, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURNO.DESC_TURNO AS TURNO, "
		sql = sql & "		SEG_EMPRESA.RAZAOSOCIAL as empresa, "
		sql = sql & " 		SEG_EMPRESA.Codigo  as CodigoEmpresa, "
		sql = sql & " (SELECT count(cod_turma) from SCA_HORARIO_AULA "
		sql = sql & " where cod_empresa =  SEG_EMPRESA.Codigo "
		sql = sql & " and cod_turma = SCA_TURMA.COD_TURMA "
		sql = sql & " and anoLetivo = SCA_TURMA.AnoLetivo "
		sql = sql & " and semestre = SCA_TURMA.cod_semestre ) as HORARIO, "

		sql = sql & " ( SELECT distinct SUM(GD.Ch_Semanal) "
		sql = sql & " FROM SCA_TURMA T " 
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.SITUACAO = 'A' "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR "
		sql = sql & " WHERE T.COD_EMPRESA = SEG_EMPRESA.Codigo "
		sql = sql & " AND COD_TURMA = SCA_TURMA.COD_TURMA ) as matriz, "
		
		sql = sql & " (select CAPACIDADE from SCA_TURMA T where T.COD_TURMA = SCA_TURMA.COD_TURMA ) AS CAPACIDADE, "

		sql = sql & " (select count(*) as alunos from sca_aluno a"
		sql = sql & " inner join sca_aluno_turma at on at.cod_aluno = a.codigo"
		sql = sql & " inner join sca_turma t on t.cod_turma = at.cod_turma"
		sql = sql & " inner join sca_periodo p on t.cod_periodo = p.cod_periodo"
		sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
		
		sql = sql & " inner join seg_empresa e on e.codigo = t.cod_empresa"
		sql = sql & " inner join sca_situacaoaluno s on s.cod_situacaoaluno = a.cod_situacaoaluno"
		sql = sql & " where  T.COD_EMPRESA = SEG_EMPRESA.Codigo and t.cod_turma= SCA_TURMA.COD_TURMA "
		sql = sql & " and t.anoletivo = " & intAnoLetivoAtual
		sql = sql & " and e.cod_grupo = " & session("CodGrupo")	
		sql = sql & " and e.bloqueio = 'N'"
		sql = sql & " and at.SITUACAO = 'A'"
		sql = sql & " and t.SITUACAO = 'A'"
		if curso <> "0" and curso<>"" then
			sql = sql & " and c.descricao = '" & curso & "'"
		end if
		if intCodSituacaoAluno = "0" then
			SQL = SQL & " and s.Desc_SituacaoAluno IN ('ATIVO','PRÉ-MATRÍCULA')"
		else
			'SQL = SQL & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
			SQL = SQL & " and s.Desc_SituacaoAluno = '" & trim(strSITUACAOALUNO) & "'"
		end if
		
		if strSexo <> "0" then
			sql = sql & " and a.SEXOALUNO = '" & strSexo & "'"
		end if
		
		if strIntervaloIdadeInicial <> ""  then
			sql = sql & " AND FLOOR(DATEDIFF(DAY, a.datanascimento, GETDATE()) / 365.25) >= " & strIntervaloIdadeInicial 
		end if	
		
		if strIntervaloIdadeFinal <> "" then
			sql = sql & " AND FLOOR(DATEDIFF(DAY, a.datanascimento, GETDATE()) / 365.25) <= " & strIntervaloIdadeFinal 
		end if	
		
		sql = sql & ") as intOcupada, SCA_TURMA.TurmaAluno  "
				
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
		sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SCA_TURMA.cod_empresa "
		sql = sql & " where 1=1  and SEG_EMPRESA.bloqueio = 'N' " 
		sql = sql & " and 	SCA_TURMA.AnoLetivo = " & intAnoLetivoAtual 
		sql = sql & " and 	SCA_TURMA.cod_semestre = " & intSemestreAtual
		sql = sql & " and 	SCA_TURMA.SITUACAO = 'A'"
		if curso <> "0" and curso<>"" then
			sql = sql & " and SCA_CURSO.descricao = '" & curso & "'"
		end if
		if intCodCurso <> "0" then
			sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
		end if
		
		if strSomentoIncosistecia = "S" then

			sql = sql & " and (isnull(( SELECT distinct SUM(GD.Ch_Semanal) FROM SCA_TURMA T INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.SITUACAO = 'A' INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR WHERE T.COD_EMPRESA = SEG_EMPRESA.Codigo AND COD_TURMA = SCA_TURMA.COD_TURMA ),'0')='0' "
			sql = sql & " or isnull((SELECT count(cod_turma) from SCA_HORARIO_AULA where cod_empresa = SEG_EMPRESA.Codigo and cod_turma = SCA_TURMA.COD_TURMA and anoLetivo = SCA_TURMA.AnoLetivo and semestre = SCA_TURMA.cod_semestre ),'0')='0') "

			sql = sql & " or ( SELECT distinct SUM(GD.Ch_Semanal) FROM SCA_TURMA T INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.SITUACAO = 'A' INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR WHERE T.COD_EMPRESA = SEG_EMPRESA.Codigo AND COD_TURMA = SCA_TURMA.COD_TURMA ) "
			sql = sql & " <> (SELECT count(cod_turma) from SCA_HORARIO_AULA where cod_empresa = SEG_EMPRESA.Codigo and cod_turma = SCA_TURMA.COD_TURMA and anoLetivo = SCA_TURMA.AnoLetivo and semestre = SCA_TURMA.cod_semestre ) "

		end if
		if intCodEmpresaGrupo <> "" and intCodEmpresaGrupo <> "0" then
			sql = sql & " And SCA_TURMA.cod_empresa = " & intCodEmpresaGrupo
		else
		 	sql = sql & " And SEG_EMPRESA.cod_grupo  = " & session("CodGrupo")	
		end if
		if strCodTurno <> "0" then
			sql = sql & " and substring(SCA_TURMA.Nometurma,6,1) = '" & strCodTurno & "'"
		end if
		
	end if
	sql = sql & " Order By SEG_EMPRESA.RAZAOSOCIAL, SCA_CURSO.DESCRICAO, SCA_PERIODO.DESCRICAO, SCA_TURNO.DESC_TURNO, SCA_TURMA.NomeTurma"
	
	
	intCapacidadeTotalUnidade = 0
	intOcupadaTotalUnidade = 0
	intCapacidadeTotal = 0
	intOcupadaTotal = 0
    strMarcaEmpresa = ""
	intVagasPositivo = 0
	controle = 0
	
	rs.open sql, cnn
	if not rs.eof then
		While not rs.eof
		
			if strEmpresa <> trim(RS("empresa")) then
				if controle = 1 then
					%>
					<tr >
						<td align="center" class="celula"><div align="right"><strong>Sub-Totais: &nbsp;</strong></div></td>
						<td align="center" class="celula"><strong>Quantidade de Turmas na unidade: <%=contTurmaUnidade%>&nbsp;</strong></td>
						<td align="center" class="celula">&nbsp;</td>
						<td align="center" class="celula">&nbsp;</td>
						<td align="center" class="celula">&nbsp;</td>
						<td align="center" class="celula"><strong><%=intCapacidadeTotalUnidadeCurso%></strong></td>
						<td align="center" class="celula"><strong><%=intOcupadaTotalUnidadeCurso%></strong></td>
						<td align="center" class="celula"><strong><%=intVagasPositivo%></strong></td>
					</tr> 
					<%
					contTurmaUnidade = 0 
					intCapacidadeTotalUnidadeCurso = 0 
					intOcupadaTotalUnidadeCurso = 0 
					intVagasPositivo = 0
				end if
			end if   
			strInfoEmpresa =  "<strong>" & RS("empresa") & "</strong>"
			strInfoTurma =  rs("curso") & " - " & rs("PERIODO") & " | " & "<strong>" & rs("nometurma") & " " & rs("TurmaAluno") & "</strong>"
			strTurno	 = RS("TURNO")
			'BUSCA SE A TURMA POSSUI HORÁRIO CADASTRADO
			if isnull(RS("HORARIO")) then
				Horario = "NÃO"
			else
				Horario = "SIM - "& RS("HORARIO") & " Aula(s)" 
			end if   

			'BUSCA SE A MATRIZ ESTÁ CADASTRADA.
			if isnull(RS("matriz")) then
				Matriz = "NÃO"
			else
				Matriz = "SIM - "& RS("matriz") & " Aula(s)" 
			end if   
			intCapacidade = RS("Capacidade")
			if isnull(intCapacidade) or intCapacidade = "" then intCapacidade = "0"

			'BUSCA QUANTIDADE DE ALUNOS MATRICULA NA TURMA	
			intOcupada = RS("intOcupada")
			if isnull(intOcupada) or intOcupada = "" then intOcupada = "0"
			intVagas = intCapacidade-intOcupada
			
			 if intVagas > 0 then 
				intVagasPositivo = intVagasPositivo + intVagas
				intVagasPositivoTotal  = intVagasPositivoTotal + intVagas
				intVagasPositivoSubtotal  = intVagasPositivoSubtotal + intVagas
			 end if
			%>
			  <tr <%=strCorLinhaNaoOferece%>>
				<td class="celula"><%=strInfoEmpresa%>&nbsp;</td>
				<td class="celula"><%=strInfoTurma%>&nbsp;<%'=strMsnOferece%></td>
				<td class="celula"><div align="center"><%=strTurno%>&nbsp;</div></td>
				<td class="celula"><div align="center">&nbsp;<%=Horario%></div></td>
				<td class="celula" align="center">&nbsp;<%=Matriz%></td>
				<td class="celula"><div align="center"><%=intCapacidade%>&nbsp;</div></td>
				<td class="celula"><div align="center"><%=intOcupada%></div></td>
				<td class="celula"><div align="center"><%=intVagas%>&nbsp;</div></td>
			  </tr>
			<%
			
			intCapacidadeTotalUnidadeCurso = intCapacidadeTotalUnidadeCurso + intCapacidade
			intOcupadaTotalUnidadeCurso = intOcupadaTotalUnidadeCurso + intOcupada
			
			intOcupadaTotalUnidade = intOcupadaTotalUnidade + intCapacidade
			intCapacidadeTotalUnidade = intCapacidadeTotalUnidade + intOcupada
			
			contTurmaUnidade = contTurmaUnidade + 1
			contTurmaUnidadeTotal = contTurmaUnidadeTotal + 1
			controle  = 1
			strEmpresa = trim(RS("empresa"))
			rs.movenext
            
		wend
			%>
			<tr>
				<td align="center" class="celula"><div align="right"><strong>Sub-Totais: &nbsp;</strong></div></td>
				<td align="center" class="celula"><strong>Quantidade de Turmas na unidade: <%=contTurmaUnidade%>&nbsp;</strong></td>
				<td align="center" class="celula">&nbsp;</td>
				<td align="center" class="celula">&nbsp;</td>
				<td align="center" class="celula">&nbsp;</td>
				<td align="center" class="celula"><strong><%=intCapacidadeTotalUnidadeCurso%></strong></td>
				<td align="center" class="celula"><strong><%=intOcupadaTotalUnidadeCurso%></strong></td>
				<td align="center" class="celula"><strong><%=intVagasPositivo%></strong></td>
			</tr>
			<tr>
			<td align="left" class="celula"><div align="right"><strong>Totais: &nbsp;</strong></div></td>
			<td align="left" class="celula"><div align="center"><strong>&nbsp;Turmas Existentes:&nbsp;<%=contTurmaUnidadeTotal%> </strong></div></td>
			<td align="left" class="celula">&nbsp;</td>
			<td align="left" class="celula">&nbsp;</td>
			<td align="left" class="celula">&nbsp;</td>
			<td align="left" class="celula"><div align="center"><strong><%=intCapacidadeTotalUnidade%>&nbsp;</strong></div></td>
			<td align="left" class="celula"><div align="center"><strong><%=intOcupadaTotalUnidade%></strong></div></td>
			<td align="left" class="celula"><div align="center"><strong><%=intVagasPositivoTotal%>&nbsp;</strong></div></td>
			</tr>
			<%
	else
		%>
		  <tr>
			<td colspan="8" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
