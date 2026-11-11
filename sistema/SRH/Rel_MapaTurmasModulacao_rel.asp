<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Mapa Semestral de Turmas</title>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
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
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
		sql = sql & " And COD_SITUACAOALUNO=" & intCodSituacaoAluno
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
	<!--#include file="../../includes/inc_cabecalhoRelatorioGrupo.asp"-->
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="25%" class="celula"><strong>Empresa</strong></td>
		<td width="34%" class="celula"><div align="center"><strong>Turma</strong></div></td>
		<td width="9%" class="celula"><div align="center"><strong>Turno</strong></div></td>
	    <td width="9%" class="celula"><div align="center"><strong>Hor&aacute;rio</strong></div></td>
	    <td width="9%" class="celula"><div align="center"><strong>Matriz</strong></div></td>
	    <td width="8%" class="celula"><div align="center"><strong>Capacidade</strong></div></td>
	    <td width="6%" class="celula"><strong>Ocupa&ccedil;&atilde;o</strong></td>
	    <td width="6%" class="celula"><div align="center"><strong>Vagas</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub quebraTurma()
	   
	   if strPromoverAnoLetivo = "S" and intVagas < 0 then 
	   		intVagas = 0
	   else
		   if intCapacidade-intOcupada < 0  then intVagas = "<font color='#FF0000'>" & intCapacidade-intOcupada & "</font>"
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
	end Sub	
	
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	intPagina = 1
	mostraCabecalho
	cont = 0
	contCurso = 0
	contTurmaUnidade = 0
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
		sql = sql & " inner join seg_empresa e on e.codigo = t.cod_empresa"
		sql = sql & " inner join sca_situacaoaluno s on s.cod_situacaoaluno = a.cod_situacaoaluno"
		sql = sql & " where  T.COD_EMPRESA = SEG_EMPRESA.Codigo and t.cod_turma= SCA_TURMA.COD_TURMA and t.anoletivo = " & intAnoLetivoAtual
		sql = sql & " and e.cod_grupo = " & session("CodGrupo")	
		sql = sql & " and e.bloqueio = 'N'"
		sql = sql & " and at.SITUACAO = 'A'"
		
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
		
		sql = sql & ") as intOcupada "

		sql = sql & " FROM SCA_ALUNO_TURMA "
		sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
		sql = sql & " INNER JOIN SCA_TURMA ON (SELECT TOP 1 COD_TURMA FROM SCA_ALUNO_TURMA WHERE COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual & " and SCA_ALUNO_TURMA.Semestre in (" & intSemestreAtual & ") ORDER BY CODIGO DESC) = SCA_TURMA.Cod_Turma  "
		sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO and SCA_TURNO.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
		sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SCA_TURMA.cod_empresa "
		sql = sql & " where 1=1"
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
	
	else
		sql = "SELECT distinct SCA_PERIODO.cod_Periodo, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.Cod_curso, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURNO.DESC_TURNO AS TURNO, "
		if ucase(Session("UsuarioWeb")) = "USUARIO.TESTE" then
			sql = sql & "		'"&session("EmpresaWeb")&"' as empresa, "
			sql = sql & "		SEG_EMPRESA.RAZAOSOCIAL as RAZAOSOCIAL1,"
		else
			sql = sql & "		SEG_EMPRESA.RAZAOSOCIAL as empresa, "
		end if
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
		sql = sql & " inner join seg_empresa e on e.codigo = t.cod_empresa"
		sql = sql & " inner join sca_situacaoaluno s on s.cod_situacaoaluno = a.cod_situacaoaluno"
		sql = sql & " where  T.COD_EMPRESA = SEG_EMPRESA.Codigo and t.cod_turma= SCA_TURMA.COD_TURMA "
		sql = sql & " and t.anoletivo = " & intAnoLetivoAtual
		sql = sql & " and e.cod_grupo = " & session("CodGrupo")	
		sql = sql & " and e.bloqueio = 'N'"
		sql = sql & " and at.SITUACAO = 'A'"
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
		
		sql = sql & ") as intOcupada "
				
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO and SCA_TURNO.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
		sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SCA_TURMA.cod_empresa "
		sql = sql & " where 1=1  and SEG_EMPRESA.bloqueio = 'N' " 
		sql = sql & " and 	SCA_TURMA.AnoLetivo = " & intAnoLetivoAtual 
		sql = sql & " and 	SCA_TURMA.cod_semestre = " & intSemestreAtual
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
		
	end if
	sql = sql & " Order By SEG_EMPRESA.RAZAOSOCIAL, SCA_TURMA.NomeTurma"
	intCapacidadeTotalUnidade = 0
	intOcupadaTotalUnidade = 0
	intCapacidadeTotal = 0
	intOcupadaTotal = 0
    strMarcaEmpresa = ""
	intVagasPositivo = 0
	rs.open sql, cnn
	if not rs.eof then
		While not rs.eof
			strCorLinhaNaoOferece = ""
			strMsnOferece = ""
			IF intCodTurma <> RS("COD_TURMA") then
				
				if strPromoverAnoLetivo = "S" and strSomentoIncosistecia = "" then
					sql = "SELECT P.SEQUENCIA, T.capacidade, p.cod_curso "
					sql = sql & " FROM	SCA_GRADECURRICULAR G"
					sql = sql & " INNER	JOIN SCA_TURMA T 	ON T.COD_GRADECURRICULAR = G.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
					sql = sql & " INNER	JOIN SCA_PERIODO P 	ON P.COD_PERIODO = G.COD_PERIODO AND P.COD_EMPRESA = G.COD_EMPRESA"
					sql = sql & " WHERE	T.COD_TURMA		= " & RS("COD_TURMA")
					sql = sql & " AND	T.COD_EMPRESA	= " & intCodEmpresaGrupo
					rsAux.open sql, cnn, 3, 3
					if not rsAux.EOF then	
						strSequenciaOrigem			= rsAux("SEQUENCIA")
						strSequenciaDestino			= rsAux("SEQUENCIA")+1
						strCapacidadeOrigem			= rsAux("capacidade")
						intCodCursoAtual			= rsAux("cod_curso")
					end if
					rsAux.close
					
					intTotalPeriodos = 0
					sql = "select max(sequencia) as maximo"
					sql = sql & " from SCA_PERIODO p"
					sql = sql & " inner join SCA_CURSO c on c.cod_curso = p.cod_curso"
					sql = sql & " where p.cod_empresa = " & intCodEmpresaGrupo
					sql = sql & " and p.Cod_Curso = " & intCodCursoAtual
					rsAux.open sql, cnn, 3, 3
					if not rsAux.EOF then	
						intTotalPeriodos = rsAux("maximo")
					end if
					rsAux.close
					
					strNaoImprimeLinha = ""
					if strSequenciaDestino > intTotalPeriodos then
						strNaoImprimeLinha = "N"
					end if
					
					sql = "select distinct p.Sequencia, t.Capacidade, p.Descricao as periodoDestino, c.Descricao as Curso"
					sql = sql & " from sca_turma t"
					sql = sql & " inner join SCA_GRADECURRICULAR g on g.cod_gradeCurricular = t.cod_gradeCurricular"
					sql = sql & " inner join SCA_PERIODO p on p.cod_periodo = g.Cod_Periodo"
					sql = sql & " inner join SCA_CURSO c on c.cod_curso = p.cod_curso"
					sql = sql & " where p.Sequencia = " & strSequenciaDestino
					sql = sql & " and t.cod_empresa = " & intCodEmpresaGrupo
					sql = sql & " and p.Cod_Curso = " & intCodCursoAtual
					sql = sql & " and t.AnoLetivo = " & intAnoLetivoAtual
					sql = sql & " and t.Cod_Semestre = " & intSemestreAtual
					rsAux.open sql, cnn, 3, 3
					if not rsAux.EOF then	
						strCapacidadeDestino = rsAux("capacidade")
						strNomePeriodo = rsAux("periodoDestino")
						strNomeCurso = rsAux("CURSO")
					else
						rsAux.close
						sql = "select distinct p.Descricao as periodoDestino, c.Descricao as Curso"
						sql = sql & " from SCA_PERIODO p "
						sql = sql & " inner join SCA_CURSO c on c.cod_curso = p.cod_curso"
						sql = sql & " where p.Sequencia = " & strSequenciaDestino
						sql = sql & " and p.cod_empresa = " & intCodEmpresaGrupo
						sql = sql & " and p.Cod_Curso = " & intCodCursoAtual
						rsAux.open sql, cnn, 3, 3
						if not rsAux.EOF then	
							strCapacidadeDestino = 0
							strNomePeriodo = rsAux("periodoDestino")
							strNomeCurso = rsAux("CURSO")
							strCorLinhaNaoOferece = "bgcolor='#FFC68C'"
							strMsnOferece = "( Turma Não Oferecida )"
						end if
					end if
					rsAux.close
					
					strNomeTurma = left(RS("NomeTurma"),2) & strSequenciaDestino & right(RS("NomeTurma"),6)		
				else
					strNomeTurma = RS("NomeTurma")
					strNomePeriodo = RS("PERIODO")
					strNomeCurso = RS("CURSO")
				end if
				
			    if strMarcaEmpresa <>  trim(RS("empresa")) then
				   strInfoEmpresa =  "<strong>" & RS("empresa") & "</strong>"
				else   
				   strInfoEmpresa = ""
				end if   
				strInfoTurma =  "<strong>" & strNomeTurma & "</strong> - " & strNomeCurso & " - " & strNomePeriodo
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
								
				if strNaoImprimeLinha = "" then
				
					if strPromoverAnoLetivo = "S" and strSomentoIncosistecia = "" then
						'BUSCA CAPACIDADE DA TURMA	
						intCapacidade = strCapacidadeDestino
						if isnull(intCapacidade) or intCapacidade = "" then intCapacidade = "0"
	
						'BUSCA QUANTIDADE DE ALUNOS MATRICULA NA TURMA	
						intOcupada = strCapacidadeDestino - RS("intOcupada")
						intVagas = strCapacidadeDestino - RS("intOcupada")
						if isnull(intOcupada) or intOcupada = "" then intOcupada = "0"
						intOcupada = intCapacidade-intOcupada
					else
						'BUSCA CAPACIDADE DA TURMA	
						intCapacidade = RS("Capacidade")
						if isnull(intCapacidade) or intCapacidade = "" then intCapacidade = "0"
	
						'BUSCA QUANTIDADE DE ALUNOS MATRICULA NA TURMA	
						intOcupada = RS("intOcupada")
						if isnull(intOcupada) or intOcupada = "" then intOcupada = "0"
						intVagas = intCapacidade-intOcupada
					end if
					
					
					 if intVagas > 0 then 
						intVagasPositivo = intVagasPositivo + intVagas
						intVagasPositivoTotal  = intVagasPositivoTotal + intVagas
					 end if
					 
		   			if strCorLinhaNaoOferece <> "" then
						intCapacidade = 0
						'intOcupada = 0
						intVagas = 0
						Matriz = "-----"
						Horario = "-----"
					end if
					quebraTurma
				end if	
			END IF
			if strNaoImprimeLinha = "" then
				contTurmaUnidadeTotal = contTurmaUnidadeTotal + 1
				'quantidade de registros da página
				if intQtdeRegistroPorPagina = 50 then
					 intPagina = intPagina + 1
					 intQtdeRegistroPorPagina = 1
					 fimTabela
					%>
					<pre></pre>				
					<%			
					mostraCabecalho
				end if	
				cont = cint(cont) + 1
				contTurmaUnidade = contTurmaUnidade + 1
				contTurmaUnidadeCurso = contTurmaUnidade + 1
				intCapacidadeTotalUnidade = intCapacidadeTotalUnidade + intCapacidade
				intCapacidadeTotalUnidadeCurso = intCapacidadeTotalUnidadeCurso + intCapacidade
				intOcupadaTotalUnidade = intOcupadaTotalUnidade + intOcupada
				intOcupadaTotalUnidadeCurso = intOcupadaTotalUnidadeCurso + intOcupada
	
				intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
				intCodTurma = RS("COD_TURMA") 
				intCapacidadeTotal = intCapacidadeTotal + intCapacidade
				intOcupadaTotal = intOcupadaTotal + intOcupada
				strMarcaEmpresa = RS("empresa")
				strSomaCurso = left(RS("NOMETURMA"),2)
			end if
			rs.movenext
            if not rs.eof then
				   if strSomaCurso <>  left(RS("NOMETURMA"),2) then %>
						<tr >
							<td align="center" class="celula"><div align="right"><strong>Sub-Totais: &nbsp;</strong></div></td>
							<td align="center" class="celula">Quantidade de Turmas / Cursos: <%=contTurmaUnidade%>&nbsp;</td>
							<td align="center" class="celula">&nbsp;</td>
							<td align="center" class="celula">&nbsp;</td>
							<td align="center" class="celula">&nbsp;</td>
							<td align="center" class="celula"><%=intCapacidadeTotalUnidadeCurso%></td>
							<td align="center" class="celula"><%=intOcupadaTotalUnidadeCurso%></td>
							<td align="center" class="celula"><%=intVagasPositivo%></td>
						</tr> <%
					   contTurmaUnidade = 0 
					   intCapacidadeTotalUnidadeCurso = 0 
					   intOcupadaTotalUnidadeCurso = 0 
					   intVagasPositivo = 0
				   end if
					
					' intCapacidadeTotalUnidade-intOcupadaTotalUnidade
					' A Sercritaria da Educação quer o somatorio das vagas disponiveis. para trazer o reultador anterior usava a varialve acima no lugar da intVagasPositivo
					
				   if strMarcaEmpresa <>  trim(RS("empresa")) then %>
						<!--<tr>
						<td align="left" class="celula"><div align="right"><strong>Totais: &nbsp;</strong></div></td>
						<td align="left" class="celula"><div align="center"><strong>&nbsp;Turmas Existentes:&nbsp;<%=contTurmaUnidadeTotal%> </strong></div></td>
						<td align="left" class="celula">&nbsp;</td>
						<td align="left" class="celula">&nbsp;</td>
						<td align="left" class="celula">&nbsp;</td>
						<td align="left" class="celula"><div align="center"><strong><%=intCapacidadeTotalUnidade%></strong>&nbsp;</div></td>
						<td align="left" class="celula"><div align="center"><strong><%=intOcupadaTotalUnidade%></strong></div></td>
						<td align="left" class="celula"><div align="center"><strong><%=intVagasPositivoTotal%>&nbsp;</strong></div></td>
						</tr>
                        <-->
						<%
						contTurmaUnidade = 0
						intVagasPositivo = 0
					end if
				else
					
					%>
					<tr>
						<td align="center" class="celula"><div align="right"><strong>Sub-Totais: &nbsp;</strong></div></td>
						<td align="center" class="celula">Quantidade de Turmas  / Cursos: <%=contTurmaUnidade%>&nbsp;</td>
						<td align="center" class="celula">&nbsp;</td>
						<td align="center" class="celula">&nbsp;</td>
						<td align="center" class="celula">&nbsp;</td>
						<td align="center" class="celula"><%=intCapacidadeTotalUnidadeCurso%></td>
						<td align="center" class="celula"><%=intOcupadaTotalUnidadeCurso%></td>
						<td align="center" class="celula"><%=intVagasPositivo%></td>
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
					contTurmaUnidade = 0
					intCapacidadeTotalUnidade = 0
					intOcupadaTotalUnidade = 0
					intVagasPositivo = 0
					intVagasPositivoTotal = 0
				end if
		wend
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
