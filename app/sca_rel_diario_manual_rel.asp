<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Diário manual</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strMostraConteudo 		    = Trim(Request.Form("mostraConteudo"))
	stromiteDadosdoDiario 		= Trim(Request.Form("omiteDadosdoDiario"))
	strOmiteDataImpressao 		= Trim(Request.Form("omiteDataImpressao"))
	strOmiteAcumuladoFalta 		= Trim(Request.Form("omiteAcumuladoFalta"))
	
	if strOmiteAcumuladoFalta = "" then strOmiteAcumuladoFalta = "N" 

	strVisualizacao				= Trim(Request.Form("cmbVisualizacao"))
	strlpp 					    = Trim(Request.Form("cmblpp"))
	if strVisualizacao = "P" then
		intQtdeRegistroPorPagina = 26
	else
		intQtdeRegistroPorPagina = 46
	end if			
	if strlpp <> "" and  strlpp <> "0" then intQtdeRegistroPorPagina = strlpp

	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strTipoDisciplina     	= Trim(Request.Form("cmbTipoDisciplina"))

	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))

	intCodDisciplinaCurso	= Trim(Request.Form("cmbDisciplinaCurso"))
	
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

	
	intCodBimestre			= Trim(Request.Form("cmbBimestre"))
	strTipoRelatorioImpresso = "MENSAL"
	
	strclasse=Trim(Request.Form("cmbTamanhoFonteArial"))
	
	strColunas	= Trim(Request.Form("cmbColunas"))

  

	if intCodBimestre <> "0" then
		sql = "select descricao, periodo from sca_bimestre"
		sql = sql & " where codigo= " & intCodBimestre		
		sql = sql & " and ano_letivo= " & strAnoLetivo		
		sql = sql & " and semestre= " & intSemestre		
		rs.open sql, cnn
		if not rs.eof then 
			strDescBim = RS("descricao") & " - " & RS("periodo")
		end if
		rs.close
		strTipoRelatorioImpresso = "BIMESTRAL"
		FinalColuna 			 = strColunas
		strTituloRelatorio  	 = "DIÁRIO DE FREQUÊNCIA<br>" & strDescBim
	else
		strMes 					= Trim(Request.Form("cmbMes"))
		if strMes 		= "" then strMes = "0"
	
		strDescMes = ""
		if strMes <> "0" then
			strDescMes = "<strong>" & ucase(monthName(strMes)) & "/" & year(date) & "</strong>"
		end if
		strTituloRelatorio  	= "DIÁRIO DE FREQUÊNCIA<br>" & strDescMes
		FinalColuna 			= strColunas

	end if

	'lista todas as turmas do curso
	set rsCurso  	= Server.CreateObject("adodb.recordset")
	
	sql = "SELECT SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURMA.Turmaaluno, SCA_CURSO.descricao as curso, SCA_PERIODO.descricao as periodo"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR on SCA_GRADECURRICULAR.cod_GRADECURRICULAR = SCA_TURMA.cod_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso"
	sql = sql & " Where SCA_TURMA.Cod_Empresa = " & session("CodEmpresa")
	sql = sql & " and SCA_TURMA.anoLetivo = " & strAnoLetivo
	
	if intCodTurma <> "0" then
		sql = sql & " and SCA_TURMA.Cod_Turma = " & intCodTurma
	end if
	
	sql = sql & " and SCA_PERIODO.Cod_Curso = " & intCodCurso
	sql = sql & " and SCA_TURMA.Cod_Semestre = " & intSemestre
	
	if intCodPeriodo <> "0" then
		sql = sql & " and SCA_PERIODO.Cod_Periodo = " & intCodPeriodo
	end if
	
	if intCodTurno <> "0" then
		sql = sql & " and SCA_TURMA.Cod_Turno = " & intCodTurno
	end if
	
	sql = sql & " Order By SCA_TURMA.NomeTurma"
	rsCurso.open sql, cnn
	if not rsCurso.eof then 
		controle = 0
		while not rsCurso.eof
			strInfoTurma =  "<strong>" & rsCurso("NomeTurma") & " - " & rsCurso("curso") & " - " &  rsCurso("turmaaluno")  & "</strong>"
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
						
				sql = "SELECT DISTINCT SRH_COLABORADOR.NOME AS COLABORADOR"
				sql = sql & " FROM SCA_HORARIO_AULA"
				sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
				sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO=" & strAnoLetivo
				sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE=" & intSemestre
				sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA=" & intCodTurma
				sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA=" & intCodDisciplinaTurma
				rsaux.open sql, cnn
				if not rsaux.eof then 
					strProfessor = rsaux("COLABORADOR")
				else
					strProfessor = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
				end if
				rsaux.close
			end if
			
			if cInt(controle) = 1 then
				response.Write("<pre>&nbsp;</pre>")
			end if
			controle = 1
			intPagina = 1
			%>
			<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
			<BR>
			<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
			  <tr>
			    <td height="17" class="<%=strclasse%>">TURMA:</td>
			    <td width="32%" class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
			    <td width="10%" class="<%=strclasse%>">DISCIPLINA:</td>
			    <td width="44%" class="<%=strclasse%>"><strong><%=strDisciplinaTurma%>&nbsp;</strong></td>
		      </tr>
			  <%
			  if intCodDisciplina <> "0" then
			    
					 %>
					 <tr>
					 <td width="14%" height="17" class="<%=strclasse%>">PROFESSOR:</td>
					 <td colspan="3" class="<%=strclasse%>"><%=strProfessor%>&nbsp;</td>
					 </tr>
					 <%
				
			  end if
			  %>	 
			</table>
<table width="98%" border=0 align="center" cellpadding=0 cellspacing=0>
				<tr> 
					<td  valign=top>
                    
                    <table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000">
                    <tr> 
                      <td width="2%" height="23" align="center" class="<%=strclasse%>">N&ordm;</td>
                      <td width="28%" align="center" class="<%=strclasse%>">NOME DO ALUNO </td>
                      <td width="4%" align="center" class="<%=strclasse%>">MATR.</td>
                      <%if strOmiteAcumuladoFalta = "N" then %>
                      <td width="4%" align="center" class="<%=strclasse%>">ACM. FAL.</td>
                      <%end if%>
                      <%for j=1 to FinalColuna%>
                      <td bordercolor="#000000" class="<%=strclasse%>">&nbsp;</td>
                      <%next%>
                      <td width="4%" align="center" class="<%=strclasse%>">ALT.FAL</td>
                    </tr>
        			<%
						intPagina = 1
						ContAluno = 1
						if trim(strOpcaoRelatorio) = "T" then
							sql = "SELECT DISTINCT SIT.Desc_SituacaoAluno, '' as SITUACAO,  "
							sql = sql & " SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, "
							sql = sql & " SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, "
							sql = sql & " SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma"
							sql = sql & " FROM SCA_ALUNO_TURMA "
							sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
							sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
							sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso"
							
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
							sql = sql & " 	WHERE CS.COD_EMPRESA = SCA_TURMA.cod_empresa"
							sql = sql & " 		AND CS.COD_ALUNO   = SCA_ALUNO.CODIGO"
							sql = sql & " 		AND CS.ANO_LETIVO  = " & strAnoLetivo
							sql = sql & " 	ORDER BY CS.CODIGO DESC"
							sql = sql & " ) SIT"
							
						   sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
				            if trim(strAnoLetivo) = trim(session("strAnoLetivo")) and trim(intSemestre) =  trim(session("strSemestre")) then
								sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
								SQL = SQL & " AND SIT.Desc_SituacaoAluno = 'ATIVO'"
							end if	
							sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
							sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
							
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
							sql = sql & " Order By SCA_ALUNO.NOMEALUNO"
							
						else
							sql = " SELECT SIT.Desc_SituacaoAluno, "
							sql = sql & " SCA_ALUNO_DISCIPLINA.SITUACAO, "
							sql = sql & " '' AS SEQUENCIA, SCA_ALUNO.CODIGO, "
							sql = sql & " SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , "
							sql = sql & " SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_ALUNO_DISCIPLINA.COD_TURMA, '' AS NomeTurma "
							sql = sql & " FROM SCA_ALUNO"
							sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO "
							sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = SCA_ALUNO_DISCIPLINA.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular  "
							sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo  "
							sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
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
							sql = sql & " 	WHERE CS.COD_EMPRESA = SCA_CURSO.cod_empresa"
							sql = sql & " 		AND CS.COD_ALUNO   = SCA_ALUNO.CODIGO"
							sql = sql & " 		AND CS.ANO_LETIVO  = " & strAnoLetivo
							sql = sql & " 	ORDER BY CS.CODIGO DESC"
							sql = sql & " ) SIT"							
							sql = sql & " WHERE	SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO = " & intCodTurma
							if strTipoDisciplina <> "CD" and strTipoDisciplina <> "" then
							 	sql = sql & " AND SCA_ALUNO_DISCIPLINA.Situacao = '" & strTipoDisciplina & "'"
							end if
							sql = sql & " AND	SCA_GRADECURRICULARDISCIPLINA.COD_DISCIPLINA	= " & intCodDisciplinaTurma
							SQL = SQL & " AND 	SIT.Desc_SituacaoAluno = 'ATIVO'"
							sql = sql & " Order By 6"
						end if
						rs1.open sql, cnn
						if not rs1.eof then 
							While not rs1.eof
     				            if trim(strAnoLetivo) = trim(session("strAnoLetivo")) and trim(intSemestre) =  trim(session("strSemestre")) then
							       strSitAluno = "(" & rs1("Desc_SituacaoAluno") & ")"
								end if   
								if ucase(trim(strSitAluno)) = "ATIVO" or trim(strSitAluno) = "()" then strSitAluno = ""
								strSitDisciplina = rs1("situacao")
								IF strSitDisciplina = "CR" THEN strSitDisciplina = "Curricular"
								IF strSitDisciplina = "DE" THEN strSitDisciplina = "Dependência"
								IF strSitDisciplina = "DI" THEN strSitDisciplina = "Dispensa"
			
								strSitDisciplina = "(" & strSitDisciplina & ")"
								if ucase(trim(rs1("situacao"))) = "CR" or trim(strSitDisciplina) = "()" then strSitDisciplina = ""
								if strSitAluno = "(ATIVO)" OR strSitAluno = "(PRÉ-MATRÍCULA)" then strSitAluno = ""
								   if stromiteDadosdoDiario <> "S" then
	 							      %>
								      <tr> 
								      <td align="center" class="<%=strclasse%>"><%=ContAluno%></td>
								      <td class="<%=strclasse%>">&nbsp;<%=rs1("NOMEALUNO")%>&nbsp;<%=strSitDisciplina%></td>
								      <td align="center" class="<%=strclasse%>"><%=rs1("MATRICULA")%></td>
                                      <%if strOmiteAcumuladoFalta = "N" then %>
                                      <td align="center" class="<%=strclasse%>">&nbsp;</td>
                                      <%end if%>
								      <%
								  else
	 							      %>
								      <tr> 
								      <td align="center" class="<%=strclasse%>">&nbsp;</td>
								      <td class="<%=strclasse%>">&nbsp;</td>
								      <td align="center" class="<%=strclasse%>">&nbsp;</td>
								      <td width="4%" class="<%=strclasse%>">&nbsp;</td>
								      <%
                                  end if								  
								  if trim(strSitAluno) <> "" then
								     response.Write "<td bordercolor='#000000' class='celulaarial8' colspan='26' align='center'>" & strSitAluno & "</td>"
								  else
								  %>
									  <%for j=1 to FinalColuna%>
                                      <td bordercolor="#000000" class="<%=strclasse%>">&nbsp;</td>
                                      <%next%>
                                      <%
								  end if
								  %>
          <td width="4%"  bordercolor="#000000" class="<%=strclasse%>">&nbsp;</td>
        </tr>
        <%
								if cInt(intQtdeRegistro) >= cInt(intQtdeRegistroPorPagina) - 1 then
									 intPagina = intPagina + 1
									 intQtdeRegistro = 1
									 response.Write("</table></td></tr></table>")
									%>
        <pre>&nbsp;</pre>
        <!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
        <%
									response.Write "			<BR>"
									response.Write "			<table align='center' width='98%' border='0' cellspacing='0' cellpadding='0' class='tabela'>"
									response.Write "			  <tr>"
									response.Write "				<td width='8%' height='17' class='celulaarial8'>TURMA : </td>"
									response.Write "				<td width='38%' class='celulaarial8'>" & strInfoTurma & "&nbsp;</td>"
									response.Write "				<td width='10%' class='celulaarial8'>DISCIPLINA:</td>"
									response.Write "				<td width='44%' class='celulaarial8'><strong>" & strDisciplinaTurma & "</strong>&nbsp;</td>"
									response.Write "			  </tr>"
									response.Write "			</table>"
									response.Write "			<table width='98%' border=0 align='center' cellpadding=0 cellspacing=0>"
									response.Write "				<tr> "
									response.Write "					<td  valign=top>"

									'cabeçalho			
									response.Write "								 <table class='tabela' border='1' cellspacing='0' width='100%' bordercolor='#000000'>"
									response.Write "								  <tr>"
									response.Write "									<td width='2%' height='45' rowspan='2' align='center' class='celulaarial8'>N&ordm;</td>"
									response.Write "									<td width='28%' rowspan='2' align='center' class='celulaarial8'>NOME DO ALUNO </td>"
									response.Write "									<td width='4%' rowspan='2' align='center' class='celulaarial8'>MATR.</td>"
									if strOmiteAcumuladoFalta = "N" then 
										response.Write "								<td width='4%' rowspan='2' align='center' class='celulaarial8'>ACM. FAL.</td>"
									end if
																		for j=1 to FinalColuna
									response.Write "									<td rowspan='2' bordercolor='#000000' class='celulaarial8'>&nbsp;</td>"
																		next
									response.Write "									<td width='4%' align='center' class='celulaarial8'>ALT. FAL.</td>"
									response.Write "								  </tr>"
									response.Write "								  <tr>"
									response.Write "									<td  bordercolor='#000000' class='celulaarial8'>&nbsp;</td>"
									response.Write "								  </tr>"
								end if	
								intQtdeRegistro = intQtdeRegistro + 1
								ContAluno = ContAluno + 1
								
								intCodTurma = RS1("COD_TURMA") 
								rs1.movenext
							wend
							strTemAluno = "SIM"
						else
							%>
        <tr> 
          <td height="100" align="center" class="<%=strclasse%>" colspan="<%=FinalColuna+5%>">NÃO 
            EXISTE ALUNO NESTA TURMA</td>
        </tr>
        <%
							strTemAluno = "NAO"
						end if
						rs1.close
						if stromiteDadosdoDiario = "S" then
						   strTemAluno = "NAO"
						end if   
					IF strTemAluno = "SIM" THEN
						sequencia = ContAluno - 1
						for i=1 to 3 
							sequencia = sequencia + 1
								%>
        <tr> 
          <td align="center" class="<%=strclasse%>"><%=sequencia%></td>
          <td class="<%=strclasse%>">&nbsp;</td>
          <td align="center" class="<%=strclasse%>">&nbsp;</td>
          <%if strOmiteAcumuladoFalta = "N" then %>
          <td align="center" class="<%=strclasse%>">&nbsp;</td>
          <%end if%>
          <%for j=1 to FinalColuna%>
          <td bordercolor="#000000" class="<%=strclasse%>">&nbsp;</td>
          <%next%>
          <td width="4%" bordercolor="#000000" class="<%=strclasse%>">&nbsp;</td>
        </tr>
        <%
						next
					END IF
					%>
      </table>
					</td>
				</tr>
			</table>
			<table width="98%" align="center" class="tabela" border="1" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="24%" align="center" class="<%=strclasse%>"><table width="94%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td height="19"><strong>LEGENDA: </strong></td>
                  </tr>
                  <tr>
                    <td width="23%" height="19">&quot;.&quot; (ponto) = PRESENTE &agrave; aula </td>
                  </tr>
                  <tr>
                    <td height="17">&quot;F&quot; (efe) = AUSENTE &agrave; aula </td>
                  </tr>
                  <tr>
                    <td height="19">&quot;ALT.FAL.&quot;=Justif.  Falta pelo Professor</td>
                  </tr>
                  
                </table></td>
				<td width="30%" height="82" align="center" class="<%=strclasse%>"><table width="98%" border="0" cellspacing="0" cellpadding="0">
                  
                  
                  <tr>
                    <td width="23%" height="57"><div align="justify"><strong>OBSERVA&Ccedil;&Atilde;O:</strong> O documento deve ser preenchido &agrave; tinta (de cor preta), sendo expressamente proibidas rasuras de qualquer tipo.</div></td>
                  </tr>
                </table></td>
				<td width="23%" align="center" class="<%=strclasse%>" valign="top">
				
				<table width="95%" border="0" cellspacing="0" cellpadding="0">
				  <tr valign="top">
				    <td height="19" align="center">&nbsp;</td>
			      </tr>
				  <tr valign="top">
					<td width="33%" height="19" align="center"><div align="left"></div></td>
				  </tr>
				  <tr>
					<td height="17" align="center"><p>____________________________</p>				    </td>
				  </tr>
				  <tr>
					<td height="17" align="center">Coordenador(a) Geral</td>
				  </tr>
				  <tr>
					<td height="17" align="center">_________/_________/_________</td>
				  </tr>
				</table></td>
				<td width="23%" align="center" class="<%=strclasse%>" valign="top"><table width="96%" border="0" cellspacing="0" cellpadding="0">
				  
				  <tr>
				    <td height="17"><strong>AULAS PREVISTAS:</strong> ______</td>
			      </tr>
				  <tr>
					<td width="33%" height="17"><strong>AULAS MINISTRADAS:</strong>  ______</td>
				  </tr>
				  <tr>
					<td height="17"><div align="center">______________________________</div></td>
				  </tr>
				  <tr>
					<td height="17"><div align="center">Professor(a)</div></td>
				  </tr>
				  <tr>
				    <td height="17"><div align="center">_________/_________/_________ </div></td>
			      </tr>
				  
				</table></td>
			  </tr>
			</table>
			<%if strMostraConteudo = "S" then
				intPagina = intPagina + 1
			%>
			<pre>&nbsp;</pre>				
			<!--#include file="sca_rel_diario_manual_conteudo_rel.asp"-->
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
