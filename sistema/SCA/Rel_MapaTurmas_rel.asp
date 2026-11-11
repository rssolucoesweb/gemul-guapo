<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
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
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	strFiltro	 			= Trim(Request("f"))
	strGrade		 		= Trim(Request.Form("chkGrade"))
	strIngressantes			= Trim(Request.Form("chkIngressantes"))
	strProcessoSeletivo		= Trim(Request.Form("chkProcessoSeletivo"))
	intAnoLetivoAtual	 	= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 	= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strAgruparAtivosPrematriculas = Trim(Request.Form("chkAgruparAtivosPrematriculas"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strDataI 				= trim(request.Form("txtDataI"))
	strDataF 				= trim(request.Form("txtDataF"))
	strDataInicio 			= trim(request.Form("txtDataInicio"))
	strDataFim 				= trim(request.Form("txtDataFim"))
	strOrdenaCursoPeriodo	= trim(request.Form("chkOrdenaCursoPeriodo"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))

	if intCodSituacaoAluno = "" then intCodSituacaoAluno = "0"
	if intCodCurso = "" then intCodCurso = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
		
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"

	if strDataI <> "" and strDataF <> "" then
		strMensagemPeriodoAlocacao = "<br>Per&iacute;odo de Aloca&ccedil;&atilde;o/Matr&iacute;cula: " & strDataI & " a " & strDataF
	else
		strMensagemPeriodoAlocacao = ""
	end if
	if strDataInicio <> "" and strDataFim <> "" then
		strMensagemPeriodoIngresso = "<br>Per&iacute;odo de Ingresso: " & strDataInicio & " a " & strDataFim
	else
		strMensagemPeriodoIngresso = ""
	end if

	msgSituacaoAcademica = ""
	sql = "SELECT Desc_SituacaoAluno "
	sql = sql & " FROM SCA_SITUACAOALUNO "
	sql = sql & " where Cod_SituacaoAluno = " & intCodSituacaoAluno
	rs.open sql, cnn
	if rs.eof = false then
		msgSituacaoAcademica	= "<BR>( " & rs("Desc_SituacaoAluno") & " )"
	end if 
	rs.close

	if strAgruparAtivosPrematriculas = "S" then  msgSituacaoAcademica = "<BR>( ATIVOS / PRÉ-MATRÍCULA )"

	strTituloRelatorio  	= "MAPA TURMAS "
	IF strFiltro = "A" THEN 
		strTituloRelatorio = strTituloRelatorio & "ATIVAS" & msgSituacaoAcademica & strMensagemPeriodoAlocacao & strMensagemPeriodoIngresso
	else
		strTituloRelatorio = strTituloRelatorio & msgSituacaoAcademica & strMensagemPeriodoAlocacao & strMensagemPeriodoIngresso
	end if
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	if intSemestreAtual = "3" then
		strSemestreCab = "Anual"
	else 
		strSemestreCab = intSemestreAtual & "º Semestre"
	end if
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="95%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
		<td width="30%" height="38" class="<%=strclasse%>"><div align="center"><strong>Turma</strong></div></td>
		<td width="21%" class="<%=strclasse%>"><div align="center"><strong>Curso</strong></div></td>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Per&iacute;odo</strong></div></td>
		<td width="9%" class="<%=strclasse%>"><div align="center"><strong>Turno</strong></div></td>
		<td width="9%" class="<%=strclasse%>"><div align="center"><strong>Capacidade da Turma</strong></div></td>
		<td width="9%" class="<%=strclasse%>"><div align="center"><strong>Ocupa&ccedil;&atilde;o<br>(Total na Turma)</strong></div></td>
		<td width="12%" class="<%=strclasse%>"><div align="center"><strong>Vagas<br>Dispon&iacute;veis</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub quebraTurma() 
	if intCapacidade = "" then intCapacidade = 0
	if intOcupada = "" then intOcupada = 0
	%>
	  <tr bgcolor="#E2E2E2">
	    <td class="<%=strclasse%>"><div align="left"><%=strInfoTurma%>&nbsp;</div></td>
        <td class="<%=strclasse%>">&nbsp;&nbsp;&nbsp;<%=strInfoCurso%></td>
        <td class="<%=strclasse%>">&nbsp;&nbsp;&nbsp;<%=strInfoPeriodo%></td>
        <td class="<%=strclasse%>">&nbsp;&nbsp;&nbsp;<%=strTurno%></td>
        <td class="<%=strclasse%>"><div align="center"><%=intCapacidade%>&nbsp;</div></td>
        <td class="<%=strclasse%>"><div align="center"><%=intOcupada%>&nbsp;</div></td>
        <td class="<%=strclasse%>"><div align="center"><%=intCapacidade-intOcupada%>&nbsp;</div></td>
	  </tr>
	<%
	end Sub	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	function carregaDisciplinas(codCurso, codPeriodo, codTurma)
		sql = "SELECT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.DESC_Disciplina "
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR"
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
		sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
		sql = sql & " INNER JOIN SCA_TURMA ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GRADECURRICULAR and SCA_TURMA.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
		sql = sql & " WHERE SCA_DISCIPLINA.Cod_Empresa = " & session("CodEmpresa")
		sql = sql & " AND 	SCA_PERIODO.Cod_Curso = " & codCurso
		sql = sql & " AND 	SCA_PERIODO.Cod_periodo = " & codPeriodo
		sql = sql & " AND 	SCA_TURMA.Cod_turma = " & codTurma
		sql = sql & " AND 	SCA_PERIODO.Cod_Empresa = " & session("CodEmpresa")
		rsAux.open sql, cnn		
		if rsAux.eof = false then
			response.Write "<table width='100%' border='0' cellspacing='0' cellpadding='0' align='center'>"
			while not rsAux.eof
				response.Write "<tr>"
				response.Write "<td align='center'>" & rsAux("Cod_Disciplina") & "&nbsp;-&nbsp;</td>"
				response.Write "<td>" & rsAux("DESC_Disciplina") & "</td>"
				response.Write "</tr>"
				rsAux.movenext
			wend
			response.Write "<tr>"
			response.Write "<td>&nbsp;</td>"
			response.Write "<td>&nbsp;</td>"
			response.Write "</tr>"
			response.Write "</table>"
		end if
		rsAux.close
	
	end function
	
			
	strTipoModulacao = "0"
	sql = "select ISNULL(Tipo_Modulacao,'P') as Tipo_Modulacao from SCA_CURSO "
	sql = sql & " WHERE Cod_Curso = " & intCodCurso 
	rsaux.open sql, cnn,3,3
	if not rsaux.EOF then
	   strTipoModulacao = rsaux("Tipo_Modulacao")
	end if
	rsaux.close		
%>
<%
	intPagina = 1
	mostraCabecalho
	cont = 0
	intCodTurma = 0
	if strFiltro = "A" then
		sql = "SELECT distinct SCA_PERIODO.cod_Periodo, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_PERIODO.Sequencia, SCA_CURSO.Cod_curso, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURNO.DESC_TURNO AS TURNO, SCA_TURNO.Cod_TURNO, SCA_CURSO.Tipo_Modulacao, SCA_TURMA.TurmaAluno, SCA_TURMA.AnoLetivo, SCA_TURMA.Cod_Semestre " 
		sql = sql & " FROM SCA_ALUNO_TURMA "
		sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO.CODIGO = SCA_ALUNO_TURMA.COD_ALUNO "
	    sql = sql & " INNER JOIN SCA_TURMA ON (SELECT TOP 1 COD_TURMA FROM SCA_ALUNO_TURMA WHERE COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual & " and SCA_ALUNO_TURMA.Semestre in (" & intSemestreAtual & ") ORDER BY CODIGO DESC) = SCA_TURMA.Cod_Turma "
		sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO and SCA_TURNO.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
		if strProcessoSeletivo = "S" then
			sql = sql & " INNER JOIN SCA_VESTIBULAR_DADOS ON SCA_VESTIBULAR_DADOS.CODIGO = SCA_ALUNO.Cod_ProcessoSeletivo "
			sql = sql & " INNER JOIN SCA_VESTIBULAR ON SCA_VESTIBULAR.CODIGO = SCA_VESTIBULAR_DADOS.Cod_Vestibular and  SCA_VESTIBULAR.TipoProcesso = 1 and  SCA_VESTIBULAR.Ano_letivo = " & intAnoLetivoAtual & " and SCA_VESTIBULAR.Semestre in (" & intSemestreAtual & ")"
		end if
		sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
		if intAnoLetivoAtual <> "" then
	    	sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual
		end if
		if intSemestreAtual <> "" and intSemestreAtual <> "0" then
		    sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestreAtual     
		end if
		if intCodCurso <> "0" then
			sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
		end if
		if strIngressantes = "S" then
			sql = sql & " and SUBSTRING(SCA_TURMA.NomeTurma,3,1) = 1"
			sql = sql & " and len(SCA_TURMA.NomeTurma) = 9"
		end if
		if intCodPeriodo <> "0" then
			sql = sql & " and SCA_PERIODO.cod_Periodo = " & intCodPeriodo
		end if
		if intCodTurno <> "0" then
			sql = sql & " and SCA_TURNO.Cod_TURNO = " & intCodTurno
		end if
		if strDataI <> "" and strDataF <> "" then 'SCA_ALUNO.dataMatricula
			sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO_TURMA.DATA_SITUACAO, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
			sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO_TURMA.DATA_SITUACAO, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
		end if
		if strDataInicio <> "" and strDataFim <> "" then
			sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.dataIngresso, 103),103) >= convert(datetime, ' " & strDataInicio & " ',103) " 
			sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.dataIngresso, 103),103) <= convert(datetime, ' " & strDataFim & " ',103) "
		end if
		sql = sql & " and (case when SCA_CURSO.Tipo_Modulacao = 'T' then ISNULL(sca_turma.cod_turma_grupo,'0') else 0 end) = '0' "
		sql = sql & " and SCA_TURMA.Situacao <> 'I' "  
		if strOrdenaCursoPeriodo = "S" then 
			sql = sql & " Order By SCA_CURSO.Cod_curso, SCA_PERIODO.Sequencia, SCA_TURMA.NomeTurma "
		else
			sql = sql & " Order By SCA_PERIODO.Sequencia, SCA_TURMA.NomeTurma "
		end if
	else
		sql = "SELECT distinct SCA_PERIODO.cod_Periodo, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_PERIODO.Sequencia, SCA_CURSO.Cod_curso, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURNO.DESC_TURNO AS TURNO, SCA_TURNO.Cod_TURNO, SCA_CURSO.Tipo_Modulacao, SCA_TURMA.TurmaAluno, SCA_TURMA.AnoLetivo, SCA_TURMA.Cod_Semestre "
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO and SCA_TURNO.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
		sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
		if intAnoLetivoAtual <> "" then
	    	sql = sql & " and 	SCA_TURMA.AnoLetivo = " & intAnoLetivoAtual
		end if
		if intSemestreAtual <> "" and intSemestreAtual <> "0" then
		    sql = sql & " and 	SCA_TURMA.Cod_Semestre = " & intSemestreAtual
		end if
		if intCodCurso <> "0" then
			sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
		end if
		if strIngressantes = "S" then 
			sql = sql & " and SUBSTRING(SCA_TURMA.NomeTurma,3,1) = 1"
			sql = sql & " and len(SCA_TURMA.NomeTurma) = 9"
		end if
		if intCodPeriodo <> "0" then
			sql = sql & " and SCA_PERIODO.cod_Periodo = " & intCodPeriodo
		end if
		if intCodTurno <> "0" then
			sql = sql & " and SCA_TURNO.Cod_TURNO = " & intCodTurno
		end if
		sql = sql & " and (case when SCA_CURSO.Tipo_Modulacao = 'T' then ISNULL(sca_turma.cod_turma_grupo,'0') else 0 end) = '0' "
		sql = sql & " and SCA_TURMA.Situacao <> 'I' "  
		if strOrdenaCursoPeriodo = "S" then 
			sql = sql & " Order By SCA_CURSO.Cod_curso, SCA_PERIODO.Sequencia, SCA_TURMA.NomeTurma "
		else
			sql = sql & " Order By SCA_PERIODO.Sequencia, SCA_TURMA.NomeTurma "
		end if
	end if
	intCapacidadeTotal = 0
	intOcupadaTotal = 0
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			IF intCodTurma <> RS("COD_TURMA") THEN
				strInfoTurma	=  "<strong>" & RS("NomeTurma") & "</strong> - " & RS("TurmaAluno") 
				strInfoCurso 	=  RS("CURSO")
				if trim(RS("Tipo_Modulacao")) = "P" THEN
					strInfoPeriodo 	=  RS("PERIODO")
					strTurno	 	= RS("TURNO")
				else
					strInfoPeriodo 	= "<div align='center'>---------</div>" 
					strTurno 	= "<div align='center'>---------</div>" 
				end if
				intCapacidade = "0"
				'BUSCA CAPACIDADE DA TURMA	
				SQL = " select CAPACIDADE"
				SQL = SQL & " from SCA_TURMA"
				SQL = SQL & " where COD_TURMA = " & RS("COD_TURMA")
				RSAUX.OPEN SQL, CNN
				IF NOT RSAUX.EOF THEN
					intCapacidade = RSAUX("Capacidade")
				END IF
				RSAUX.CLOSE
				intOcupada = "0"
				'BUSCA QUANTIDADE DE ALUNOS MATRICULA NA TURMA	
				if strFiltro <> "C" then
					SQL = " select DISTINCT SCA_ALUNO.CODIGO"
					SQL = SQL & " from SCA_ALUNO_DISCIPLINA"
					sql = sql & " INNER JOIN SCA_TURMA ON SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO "  
					SQL = SQL & " INNER JOIN SCA_ALUNO ON SCA_ALUNO.CODIGO = SCA_ALUNO_DISCIPLINA.COD_ALUNO "
					SQL = SQL & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO " 
					SQL = SQL & " where SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO = " & RS("COD_TURMA")
					if strIngressantes = "S" then 
						sql = sql & " and SUBSTRING(SCA_TURMA.NomeTurma,3,1) = 1"
						sql = sql & " and len(SCA_TURMA.NomeTurma) = 9"
					end if
					if strDataInicio <> "" and strDataFim <> "" then
						sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.dataIngresso, 103),103) >= convert(datetime, ' " & strDataInicio & " ',103) " 
						sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.dataIngresso, 103),103) <= convert(datetime, ' " & strDataFim & " ',103) "
					end if
					if strAgruparAtivosPrematriculas = "S" then
						SQL = SQL & " and SCA_SITUACAOALUNO.Desc_SituacaoAluno IN ('ATIVO','PRÉ-MATRÍCULA')"
					else
						if intCodSituacaoAluno <> "0" then
							SQL = SQL & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
						end if
					end if
					RSAUX.OPEN SQL, CNN, 3, 1
					IF NOT RSAUX.EOF THEN
						intOcupada = RSAUX.RECORDCOUNT
					END IF
					RSAUX.CLOSE

				else
				
					sql = "SELECT DISTINCT SCA_ALUNO.CODIGO "
					sql = sql & " FROM SCA_ALUNO_TURMA AT"
					sql = sql & " INNER JOIN SCA_ALUNO ON AT.COD_ALUNO = SCA_ALUNO.CODIGO "
					sql = sql & " INNER JOIN SCA_TURMA ON (SELECT TOP 1 COD_TURMA FROM SCA_ALUNO_TURMA WHERE COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual & " and SCA_ALUNO_TURMA.Semestre in (" & intSemestreAtual & ") ORDER BY CODIGO DESC) = SCA_TURMA.Cod_Turma "
					sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
					sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
					sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
					if strProcessoSeletivo = "S" then
						sql = sql & " INNER JOIN SCA_VESTIBULAR_DADOS ON SCA_VESTIBULAR_DADOS.CODIGO = SCA_ALUNO.Cod_ProcessoSeletivo "
						sql = sql & " INNER JOIN SCA_VESTIBULAR ON SCA_VESTIBULAR.CODIGO = SCA_VESTIBULAR_DADOS.Cod_Vestibular and  SCA_VESTIBULAR.TipoProcesso = 1 and   SCA_VESTIBULAR.Ano_letivo = " & intAnoLetivoAtual & " and SCA_VESTIBULAR.Semestre in (" & intSemestreAtual & ")"
					end if
					SQL = SQL & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO " 
					sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
					sql = sql & " and SCA_CURSO.Cod_Curso = " & RS("Cod_curso")  
					sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & RS("cod_Periodo")
					sql = sql & " and SCA_TURMA.COD_TURNO = " & RS("Cod_TURNO")
					sql = sql & " and SCA_TURMA.COD_TURMA = " & RS("COD_TURMA")
					if strIngressantes = "S" then 
						sql = sql & " and SUBSTRING(SCA_TURMA.NomeTurma,3,1) = 1"
						sql = sql & " and len(SCA_TURMA.NomeTurma) = 9"
					end if
					if strDataI <> "" and strDataF <> "" then
						sql = sql & " and convert(datetime,convert(varchar, AT.DATA_SITUACAO, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
						sql = sql & " and convert(datetime,convert(varchar, AT.DATA_SITUACAO, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
					end if
					if strDataInicio <> "" and strDataFim <> "" then
						sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.dataIngresso, 103),103) >= convert(datetime, ' " & strDataInicio & " ',103) " 
						sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.dataIngresso, 103),103) <= convert(datetime, ' " & strDataFim & " ',103) "
					end if
					if strAgruparAtivosPrematriculas = "S" then
						SQL = SQL & " and SCA_SITUACAOALUNO.Desc_SituacaoAluno IN ('ATIVO','PRÉ-MATRÍCULA')"
					else
						if intCodSituacaoAluno <> "0" then
							SQL = SQL & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
						end if
					end if
					RSAUX.OPEN SQL, CNN, 3, 1
					IF NOT RSAUX.EOF THEN
						intOcupada = RSAUX.RECORDCOUNT
					END IF
					RSAUX.CLOSE
				end if
			END IF
			
			quebraTurma

			if trim(strGrade) = "S" then
			%>
			  <tr>
				<td colspan="7" align="left" class="<%=strclasse%>"><div align="center"><strong>Disciplinas</strong></div></td>
			  </tr>
			  <tr>
			    <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;<%=carregaDisciplinas(RS("Cod_curso"), RS("Cod_periodo"), RS("cod_Turma")) %></td>
      		  </tr>
			<%
			end if
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			intCodTurma = RS("COD_TURMA") 
			intCapacidadeTotal = intCapacidadeTotal + intCapacidade
			intOcupadaTotal = intOcupadaTotal + intOcupada
			
			intCapacidadeTotalUnidadePeriodo = intCapacidadeTotalUnidadePeriodo + intCapacidade
			intOcupadaTotalUnidadePeriodo = intOcupadaTotalUnidadePeriodo + intOcupada

			intCapacidadeTotalUnidadeCurso = intCapacidadeTotalUnidadeCurso + intCapacidade
			intOcupadaTotalUnidadeCurso = intOcupadaTotalUnidadeCurso + intOcupada
			
			strSomaPeriodo = trim(RS("PERIODO"))
			strSomaCurso = left(RS("NOMETURMA"),2)
			strTipoModulacao = RS("Tipo_Modulacao")
			
			rs.movenext
            if not rs.eof then
			   if strSomaPeriodo <>  trim(RS("PERIODO")) AND strTipoModulacao <> "T" then 
                     intVagasTotalUnidadePeriodo = intCapacidadeTotalUnidadePeriodo - intOcupadaTotalUnidadePeriodo
					 %>
                    <tr>
                      <td colspan="4" class="<%=strclasse%>"><div align="right"><strong>Total Per&iacute;odo....:</strong></div></td>
                      <td class="<%=strclasse%>" bgcolor="#E2E2E2"><div align="center"><strong><%=intCapacidadeTotalUnidadePeriodo%></strong>&nbsp;</div></td>
                      <td class="<%=strclasse%>" bgcolor="#E2E2E2"><div align="center"><strong><%=intOcupadaTotalUnidadePeriodo%></strong>&nbsp;</div></td>
                      <td class="<%=strclasse%>" bgcolor="#E2E2E2"><div align="center"><strong><%=intVagasTotalUnidadePeriodo%></strong>&nbsp;</div></td>
                    </tr>
                    <%
                   
                   intCapacidadeTotalUnidadePeriodo = 0 
				   intOcupadaTotalUnidadePeriodo = 0 
               end if
			   if strSomaCurso <>  left(RS("NOMETURMA"),2) then 
                     intVagasTotalUnidadeCurso = intCapacidadeTotalUnidadeCurso - intOcupadaTotalUnidadeCurso
					 %>
                        <tr bgcolor="#999999">
                          <td colspan="4" class="<%=strclasse%>"><div align="right"><strong>Total Curso....:</strong></div></td>
                          <td class="<%=strclasse%>"><div align="center"><strong><%=intCapacidadeTotalUnidadeCurso%>&nbsp;</strong></div></td>
                          <td class="<%=strclasse%>"><div align="center"><strong><%=intOcupadaTotalUnidadeCurso%>&nbsp;</strong></div></td>
                          <td class="<%=strclasse%>"><div align="center"><strong><%=intVagasTotalUnidadeCurso%>&nbsp;</strong></div></td>
                        </tr>
                    <%
                   
                   intCapacidadeTotalUnidadeCurso = 0 
				   intOcupadaTotalUnidadeCurso = 0 
               end if
			else
				if strTipoModulacao <> "T" then 
					%>
					<tr>
					  <td colspan="4" class="<%=strclasse%>"><div align="right">
						<div align="right"><strong>Total no Per&iacute;odo....:</strong></div>
					  </div></td>
					  <td class="<%=strclasse%>" bgcolor="#E2E2E2"><div align="center"><strong><%=intCapacidadeTotalUnidadePeriodo%></strong></div></td>
					  <td class="<%=strclasse%>" bgcolor="#E2E2E2"><div align="center"><strong><%=intOcupadaTotalUnidadePeriodo%></strong></div></td>
					  <td class="<%=strclasse%>" bgcolor="#E2E2E2"><div align="center"><strong><%=intVagasTotalUnidadePeriodo%></strong></div></td>
					</tr>
					<%
				end if
			    intCapacidadeTotalUnidadePeriodo = 0 
			    intOcupadaTotalUnidadePeriodo = 0 
				intVagasTotalUnidadeCurso = intCapacidadeTotalUnidadeCurso - intOcupadaTotalUnidadeCurso
			    %>
                <tr bgcolor="#999999">
                  <td colspan="4" class="<%=strclasse%>"><div align="right"><strong>Total Curso....:</strong></div></td>
                  <td class="<%=strclasse%>"><div align="center"><strong><%=intCapacidadeTotalUnidadeCurso%>&nbsp;</strong></div></td>
                  <td class="<%=strclasse%>"><div align="center"><strong><%=intOcupadaTotalUnidadeCurso%>&nbsp;</strong></div></td>
                  <td class="<%=strclasse%>"><div align="center"><strong><%=intVagasTotalUnidadeCurso%>&nbsp;</strong></div></td>
                </tr>
				<%
				intCapacidadeTotalUnidade = 0
				intOcupadaTotalUnidade = 0
			end if
		wend
		%>

          <tr>
			<td colspan="7" class="<%=strclasse%>">&nbsp;</td>
		  </tr>
		  <tr bgcolor="#999999">
			<td align="left" class="<%=strclasse%>"><strong>Quantidade de Turmas: <%=cont%></strong></td>
			<td align="left" class="<%=strclasse%>">&nbsp;</td>
			<td align="left" class="<%=strclasse%>">&nbsp;</td>
			<td align="left" class="<%=strclasse%>"><div align="right"><strong>Total Geral....:</strong></div></td>
			<td align="left" class="<%=strclasse%>"><div align="center"><strong><%=intCapacidadeTotal%></strong></div></td>
			<td align="left" class="<%=strclasse%>"><div align="center"><strong><%=intOcupadaTotal%></strong></div></td>
			<td align="left" class="<%=strclasse%>"><div align="center"><strong><%=intCapacidadeTotal-intOcupadaTotal%></strong></div></td>
		  </tr>
		  <tr>
			<td colspan="7" class="<%=strclasse%>">&nbsp;</td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="7" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
