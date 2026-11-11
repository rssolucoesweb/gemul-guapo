<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Diario de Frequencia
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
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
<!--#include file=../../includes/inc_aguarde.asp-->
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strMostraConteudo 		= Trim(Request.Form("mostraConteudo"))
	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))

	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodDisciplinaCurso	= Trim(Request.Form("cmbDisciplinaCurso"))
	
	intCodBimestre			= Trim(Request.Form("cmbBimestre"))
	strTipoRelatorioImpresso = "MENSAL"
	
	if intCodBimestre <> "0" then
		sql = "select descricao, periodo from sca_bimestre"
		sql = sql & " where codigo= " & intCodBimestre		
		sql = sql & " and ano_letivo= " & strAnoLetivo		
		sql = sql & " and semestre= " & intSemestre		
		sql = sql & " and cod_empresa= " & Session("CodEmpresa")
		rs.open sql, cnn
		if not rs.eof then 
			strDescBim = RS("descricao") & " - " & RS("periodo")
		end if
		rs.close
		strTipoRelatorioImpresso = "BIMESTRAL"
		FinalColuna = 55
		strTituloRelatorio  	= "DIÁRIO DE FREQUÊNCIA<br>" & strDescBim
	else
		strMes 					= Trim(Request.Form("cmbMes"))
		if strMes 		= "" then strMes = "0"
	
		strDescMes = ""
		if strMes <> "0" then
			strDescMes = "<strong>" & ucase(monthName(strMes)) & "/" & year(date) & "</strong>"
		end if
		strTituloRelatorio  	= "DIÁRIO DE FREQUÊNCIA<br>" & strDescMes
		FinalColuna = 26

	end if

	'lista todas as turmas do curso
	set rsCurso  	= Server.CreateObject("adodb.recordset")
	sql = "SELECT SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_CURSO.descricao as curso, SCA_PERIODO.descricao as periodo"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR on SCA_GRADECURRICULAR.cod_GRADECURRICULAR = SCA_TURMA.cod_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso"
	sql = sql & " Where SCA_TURMA.Cod_Empresa = " & session("CodEmpresa")
	if intCodTurma <> "0" then
		sql = sql & " and SCA_TURMA.Cod_Turma = " & intCodTurma
	end if
	sql = sql & " and SCA_PERIODO.Cod_Curso = " & intCodCurso
	sql = sql & " and SCA_TURMA.Cod_Semestre = " & intSemestre
	sql = sql & " Order By SCA_TURMA.NomeTurma"
	rsCurso.open sql, cnn
	if not rsCurso.eof then 
		controle = 0
		while not rsCurso.eof
			strInfoTurma =  "<strong>" & rsCurso("NomeTurma") & " - " & rsCurso("curso") & " - " &  rsCurso("periodo")  & "</strong>"
			intCodTurma	= rsCurso("cod_turma")
			

			if intCodTurma <> "0" then
				
				sql = "select COD_SEMESTRE from SCA_TURMA"
				sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa")
				sql = sql & " And Cod_Turma = " & intCodTurma
				rs1.open sql, cnn
				if rs1.eof = false then
					strSemestre = RS1("COD_SEMESTRE")
				end if
				rs1.close	
		
			end if
		
			if intCodCurso 		= "" then intCodCurso = "0"
			if intCodPeriodo 	= "" then intCodPeriodo = "0"
			if intSemestre 		= "" then intSemestre = "0"
			if intCodTurno 		= "" then intCodTurno = "0"
			if intCodTurma 		= "" then intCodTurma = "0"
			if intCodDisciplinaTurma 		= "" then intCodDisciplinaTurma = "0"
			
			if intCodDisciplinaTurma <> "0" or intCodDisciplinaCurso<> "0" then
				if intCodDisciplinaCurso = "0" then
					intCodDisciplina = intCodDisciplinaCurso
				else
					intCodDisciplina = intCodDisciplinaTurma
				end if

				SQL="SELECT SCA_DISCIPLINA.Desc_Disciplina, SCA_DISCIPLINA.Cod_Disciplina"
				SQL=SQL & " FROM         SCA_TURMA INNER JOIN"
				SQL=SQL & "                       SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN"
				SQL=SQL & "                       SCA_GRADECURRICULARDISCIPLINA ON "
				SQL=SQL & "                       SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular INNER JOIN"
				SQL=SQL & "                       SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
				SQL=SQL & " WHERE     (SCA_TURMA.Cod_Turma = " & intCodTurma & ")"
				SQL=SQL & " and     (SCA_DISCIPLINA.Cod_Disciplina= " & intCodDisciplina & ")"
				rs1.open sql, cnn
				if not rs1.eof then 
					strDisciplinaTurma = RS1("Desc_Disciplina")
					intCodDisciplinaTurma = RS1("Cod_Disciplina")
				end if
				rs1.close

			end if
			if cInt(controle) = 1 then
				response.Write("<pre>&nbsp;</pre>")
			end if
			controle = 1
			%>
			<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
			<BR>
			<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
			  <tr>
				<td width="8%" height="17" class="celula">TURMA : </td>
				<td width="38%" class="celula"><%=strInfoTurma%>&nbsp;</td>
				<td width="10%" class="celula">DISCIPLINA:</td>
				<td width="44%" class="celula"><strong><%=strDisciplinaTurma%></strong>&nbsp;</td>
			  </tr>
			</table>
			<table width="98%" border=0 align="center" cellpadding=0 cellspacing=0>
				<tr> 
					<td  valign=top><table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000">
					  <tr>
						<td width="2%" height="45" rowspan="2" align="center" class="celula">N&ordm;</td>
						<td width="28%" rowspan="2" align="center" class="celula">NOME DO ALUNO </td>
						<td width="4%" rowspan="2" align="center" class="celula">MATR.</td>
						<td width="4%" rowspan="2" align="center" class="celula">ACM. FAL.</td>
						<%for j=1 to FinalColuna%>
						<td rowspan="2" bordercolor="#000000" class="celula">&nbsp;</td>
						<%next%>
						<td width="4%" align="center" class="celula">ALT. FAL.</td>
					  </tr>
					  <tr>
						<td  bordercolor="#000000" class="celula">&nbsp;</td>
					  </tr>
					  
					  <%
						intPagina = 1
						ContAluno = 1
						if trim(strOpcaoRelatorio) = "T" then
							sql = "SELECT SCA_SITUACAOALUNO.Desc_SituacaoAluno, '' as SITUACAO, SCA_ALUNO_TURMA.SEQUENCIA, "
							sql = sql & " SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, "
							sql = sql & " SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, "
							sql = sql & " SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma"
							sql = sql & " FROM SCA_ALUNO_TURMA "
							sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
							sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO and SCA_SITUACAOALUNO.cod_empresa = SCA_ALUNO.cod_empresa "
							sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
							sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
							sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
							sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
							sql = sql & " and 	SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'ATIVO'"'SOMENTE ALUNOS ATIVOS
							sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
							sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & strSemestre & ")"
							
							if intCodCurso <> "0" then
								sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
							end if
							if intCodPeriodo <> "0" then
								sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
							end if
							if intCodTurno <> "0" then
								sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
							end if
							if intCodTurma <> "0" then
								sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
							end if
							sql = sql & " Order By 6"
						else
							sql = " SELECT SCA_SITUACAOALUNO.Desc_SituacaoAluno, "
							sql = sql & " SCA_ALUNO_DISCIPLINA.SITUACAO, "
							sql = sql & " '' AS SEQUENCIA, SCA_ALUNO.CODIGO, "
							sql = sql & " SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , "
							sql = sql & " SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_ALUNO_DISCIPLINA.COD_TURMA, '' AS NomeTurma "
							sql = sql & " FROM SCA_ALUNO"
							sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO and SCA_ALUNO_DISCIPLINA.cod_empresa = SCA_ALUNO.cod_empresa "
							sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO and SCA_SITUACAOALUNO.cod_empresa = SCA_ALUNO.cod_empresa "
							sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = SCA_ALUNO_DISCIPLINA.Cod_GradeCurricularDisciplina"
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular and SCA_GRADECURRICULAR.cod_empresa = SCA_ALUNO.cod_empresa "
							sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
							sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
							sql = sql & " WHERE	SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO = " & intCodTurma
							sql = sql & " AND	SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA	= " & intCodDisciplinaTurma
							sql = sql & " and 	SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'ATIVO'"'SOMENTE ALUNOS ATIVOS
							sql = sql & " Order By 6"
						end if
		
						rs1.open sql, cnn
						if not rs1.eof then 
							While not rs1.eof
							strSitAluno = "(" & rs1("Desc_SituacaoAluno") & ")"
							if ucase(trim(strSitAluno)) = "ATIVO" or trim(strSitAluno) = "()" then strSitAluno = ""
							strSitDisciplina = rs1("situacao")
							IF strSitDisciplina = "CR" THEN strSitDisciplina = "Curricular"
							IF strSitDisciplina = "DE" THEN strSitDisciplina = "Dependência"
							IF strSitDisciplina = "DI" THEN strSitDisciplina = "Dispensa"
		
							strSitDisciplina = "(" & strSitDisciplina & ")"
							if ucase(trim(rs1("situacao"))) = "CR" or trim(strSitDisciplina) = "()" then strSitDisciplina = ""
							if strSitAluno = "(ATIVO)" then strSitAluno = ""
							%>
							<tr>
							  <td align="center" class="celulaMenor"><%=ContAluno%></td>
							  <td class="celulaMenor">&nbsp;<%=rs1("NOMEALUNO")%>&nbsp;<%=strSitDisciplina%></td>
							  <td align="center" class="celulaMenor"><%=rs1("MATRICULA")%></td>
							  <td width="4%" class="celula">&nbsp;</td>
							  <%
							  if trim(strSitAluno) <> "" then
							  response.Write "<td bordercolor='#000000' class='celula' colspan='26' align='center'>" & strSitAluno & "</td>"
							  else
							  %>
							<%for j=1 to FinalColuna%>
							<td bordercolor="#000000" class="celula">&nbsp;</td>
							<%next%>
							  <%
							  end if
							  %>
							  <td width="2%"  bordercolor="#000000" class="celula">&nbsp;</td>
						  </tr>
							<%
								ContAluno = ContAluno + 1
								intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
								intCodTurma = RS1("COD_TURMA") 
								rs1.movenext
							wend
							strTemAluno = "SIM"
						else
							%>
							<tr>
							  <td height="100" align="center" class="celula" colspan="<%=FinalColuna+5%>">NÃO EXISTE ALUNO NESTA TURMA</td>
						  </tr>
						  <%
							strTemAluno = "NAO"
						end if
						rs1.close
					IF strTemAluno = "SIM" THEN
						sequencia = ContAluno - 1
						for i=1 to 3 
							sequencia = sequencia + 1
								%>
								<tr>
								  <td align="center" class="celulaMenor"><%=sequencia%></td>
								  <td class="celula">&nbsp;</td>
								  <td align="center" class="celula">&nbsp;</td>
								  <td width="4%" class="celula">&nbsp;</td>
								<%for j=1 to FinalColuna%>
								<td bordercolor="#000000" class="celula">&nbsp;</td>
								<%next%>
								  <td width="2%" bordercolor="#000000" class="celula">&nbsp;</td>
						  </tr>
						<%
						next
					END IF
					%>
					
					</table>
					</td>
				</tr>
			</table>
			<br>
			<table width="98%" align="center" class="tabela" border="1" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="30%" height="82" align="center" class="celula"><table width="93%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="24">LEGENDA: </td>
				  </tr>
				  <tr>
					<td width="23%" height="19">&quot;.&quot; (ponto) =Acad&ecirc;mico PRESENTE &agrave; aula </td>
				  </tr>
				  <tr>
					<td height="17">&quot;F&quot; (efe) = Acad&ecirc;mico AUSENTE &agrave; aula </td>
				  </tr>
				  <tr>
					<td height="19">&quot;ALT.FAL.&quot;=Justificativa de Falta  Prof&ordm;</td>
				  </tr>
				  <tr>
					<td height="76"><div align="justify">Observa&ccedil;&atilde;o: O documento deve ser preenchido à tinta (de cor azul), sendo expressamente proibidas rasuras de qualquer tipo.</div></td>
				  </tr>
				</table></td>
				<td width="33%" align="center" class="celula" valign="top">
				
				<table width="91%" border="0" cellspacing="0" cellpadding="0">
				  <tr valign="top">
					<td height="23" align="center">PARA USO DA SECRETARIA </td>
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
				</table></td>
				<td width="37%" align="center" class="celula" valign="top"><table width="91%" border="0" cellspacing="0" cellpadding="0">
				  <tr valign="top">
					<td height="23"></td>
				  </tr>
				  <tr>
					<td width="33%" height="17">AULAS PREVISTAS: _____________________ </td>
				  </tr>
				  <tr>
					<td height="17">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17">AULAS DADAS :  ________________________</td>
				  </tr>
				  <tr>
					<td height="17">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17">DATA:_________/_________/_________ </td>
				  </tr>
				</table></td>
			  </tr>
			</table>
			<%if strMostraConteudo = "S" then%>
			<pre></pre>				
			<!--#include file="Rel_DiarioFrequencia_Conteudo_rel.asp"-->
			<%end if%>
				<%
				rsCurso.movenext
			wend
		end if
		rsCurso.close
	%>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
