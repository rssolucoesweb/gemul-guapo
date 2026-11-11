<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Ficha Individual do Aluno
-->
<html>
<head>
<title><%=session("Titulo")%> - Notas por Disciplina</title>
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
<br>
<%
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")
	intCodSituacaoAluno		    = Trim(Request.Form("cmbSituacaoAluno"))	
    strSituacaoPromocao 		= Trim(Request("cmbSituacaoPromocao"))
	strAtivos              		= Trim(Request.Form("cmbativos"))

	buscaHistorico = "N"
	msnHistorico = ""
	if trim(intSemestreAtual) = "3" then
	   if trim(intAnoLetivoAtual) <> trim(session("strAnoLetivo"))  then
	      buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if
	else
	   if trim(intAnoLetivoAtual) <> trim(session("strAnoLetivo"))  or trim(intSemestreAtual) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if	   
    end if

    if strVerificaCategoria <> "Professor" then
	   
	end if	 


	dim intPagina
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual

	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "Notas por Disciplinas<br>" & msnHistorico

	sub mostraCabecalho()
	%>
    <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub	

	intCodCurso	 		= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 		= Trim(Request.Form("cmbPeriodo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	
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


	strCod_empresa 		= Session("CodEmpresa")
	strMostraResultadoFinal	= Trim(Request.Form("resultadoFinal"))
	strMostraResumoResultados	= Trim(Request.Form("ResumoResultados"))
	'Busca o nome do professor
	sql = "SELECT DISTINCT SRH_COLABORADOR.NOME AS COLABORADOR"
    sql = sql & " FROM SCA_HORARIO_AULA"
    sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
    sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO = " & intAnoLetivoAtual
    sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE = " & intSemestreAtual
    sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA = " & intCodTurma
    sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA = " & intCodDisciplina
    rs.open sql, cnn
    if not rs.eof then 
	  strProfessorAssinatura = rs("COLABORADOR")
    else
	  strProfessorAssinatura = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
    end if
    rs.close

	'DESCRICAO DO PERIODO	
	sql="SELECT P.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO "
	sql=sql & " FROM 	SCA_PERIODO P "
	sql=sql & " INNER 	JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA "
	sql=sql & " WHERE 	C.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND 	P.COD_PERIODO = " & intCodPeriodo
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoPeriodo  = rs("PERIODO")
		strDescricaoCurso 	 = rs("CURSO")
	end if
	rs.close	
	
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	strBimestreAtual 	= ""
	strBimestre1		= "1Bim"
	strBimestre2		= "2Bim"
	strBimestre3		= "3Bim"
	strBimestre4		= "4Bim"
	strExameFinal		= "5EF"
	strCC				= "6CC"
	strCodBimestre		= ""

	'BUSCA A AVALIACOES
	sql="SELECT TA.POSICAO, TA.DESCRICAO, TA.SIGLA, TA.BIMESTRE, CA.media_aprovacao, frequencia_minima_percentual"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO "
	sql=sql & " WHERE	CA.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		TA.BIMESTRE<>8"
	sql=sql & " ORDER BY TA.POSICAO"
	rs.open sql, cnn, 3, 1
	if rs.eof = false then
		intMediaAprovacao = rs("media_aprovacao")
		intFrequenciaMinimaPerc		= rs("frequencia_minima_percentual")
		intCont = 1
		redim vetTipoNota(rs.recordCount,2)
		strDescTipoNotaTitulo = ""
		while not rs.eof
			if strDescTipoNotaTitulo = "" then
				strDescTipoNotaTitulo = RS("BIMESTRE")
			else
				strDescTipoNotaTitulo = strDescTipoNotaTitulo & "," & RS("BIMESTRE")
			end if
			
			if isnull(RS("BIMESTRE")) or isnull(RS("POSICAO")) then
				rs.close
				cnn.close
				%>
				<script>
					alert("ATENÇÃO: Tipo de avaliação não foi informado corretamente, favor acessar o menu Cadastro/Tipo de Avaliação e fazer as correções.");
					window.history.back();
				</script>
				<%
				response.end			
			end if
			
			vetTipoNota(intCont,1) = ZeroLeft(RS("POSICAO"),2) & "_" & RS("BIMESTRE")
			vetTipoNota(intCont,2) = RS("SIGLA")
			intCont = intCont + 1
			rs.movenext
		wend
	end if
	rs.close	
	strCodAluno			= Trim(Request("chkAluno"))
	
		
	if strCodAluno <> "" then 
		contQuebra = 0		
		mostraCabecalho
		'regra para buscar dados de anos anteriores
			if buscaHistorico = "S" then
			'HISTORICO ESCOLAR
				sql = " SELECT DISTINCT A.CODIGO, "
				sql = sql & " 	A.MATRICULA, "
				sql = sql & " 	A.NOMEALUNO, "
				'sql = sql & " 	AT.SEQUENCIA, "
				sql = sql & " 	HED.COD_TURMA, "
				sql = sql & " 	T.NOMETURMA, "
				sql = sql & " 	G.Cod_Periodo, "
				sql = sql & " 	HED.MEDIA, "
			   	sql = sql & " 	(Isnull(HED.falta01,'0') + Isnull(HED.falta02,'0') + Isnull(HED.falta03,'0') + Isnull(HED.falta04,'0') + Isnull(HED.falta05,'0') + Isnull(HED.falta06,'0') + Isnull(HED.falta07,'0') + Isnull(HED.falta08,'0') + Isnull(HED.falta09,'0') + Isnull(HED.falta10,'0') + Isnull(HED.falta11,'0') + Isnull(HED.falta12,'0') + Isnull(HED.falta13,'0') + Isnull(HED.falta14,'0') + Isnull(HED.falta15,'0'))*100/HED.CARGA_HORARIA as percFaltas, "
				sql = sql & " 	HED.CARGA_HORARIA as CH_ANUAL,"
				for i=1 to ubound(vetTipoNota)
					strPos = left(vetTipoNota(i,1),2)
					sql = sql & " 	HED.NOTA"&strPos&", "
					sql = sql & " 	HED.FALTA"&strPos&", "
				next
				sql = sql & " 	D.DESC_DISCIPLINA,"
				sql = sql & " 	TU.DESC_TURNO,"
				'sql = sql & " 	SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
				sql = sql & " 	HED.CODIGO AS COD_NOTA, "
				sql = sql & " 	HED.SITUACAO"
				sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
				sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = HED.COD_TURMA AND T.ANOLETIVO = HED.Ano_Letivo AND T.COD_SEMESTRE = HED.SEMESTRE AND T.cod_empresa = HE.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular AND G.COD_EMPRESA = T.COD_EMPRESA"
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA = HE.COD_EMPRESA AND D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
				sql = sql & " WHERE A.COD_EMPRESA = " & strCod_empresa
				sql = sql & " AND HED.COD_TURMA = " & intCodTurma
				sql = sql & " AND A.CODIGO IN (" & strCodAluno & ")" 
				sql = sql & " AND HED.ANO_LETIVO =  " & intAnoLetivoAtual
				sql = sql & " AND HED.SEMESTRE = " & intSemestreAtual
				sql = sql & " AND D.COD_DISCIPLINA = " & intCodDisciplina
				if strSituacaoPromocao <> "0" then
					sql = sql & " AND HED.SITUACAO = '" & strSituacaoPromocao & "'"
				end if	
				sql = sql & " ORDER BY A.NOMEALUNO 	"

		else
		'NOTA ATUAL
			   'SELECIONA OS ALUNOS REGULARES CONFORME DISCIPLINA CADASTRADA
	           sql = " SELECT "
			   sql = sql & " AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
			   sql = sql & " AD.COD_ALUNO AS CODIGO,"
			   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
			   sql = sql & " T.NOMETURMA, "
			   sql = sql & " TU.DESC_TURNO,"
			   sql = sql & " AD.COD_DISCIPLINA, "
	    	   sql = sql & " DI.DESC_DISCIPLINA,"
     		   sql = sql & " A.NOMEALUNO, "
			   sql = sql & " A.MATRICULA, "
			   sql = sql & " '' AS SEQUENCIA, " 
			   sql = sql & " SA.DESC_SITUACAOALUNO, "
			   sql = sql & " GC.COD_PERIODO, "
			   sql = sql & " GCD.Ch_Anual, "
			   sql = sql & " NF.media, "    
			   sql = sql & " (Isnull(NF.falta01,'0') + Isnull(NF.falta02,'0') + Isnull(NF.falta03,'0') + Isnull(NF.falta04,'0') + Isnull(NF.falta05,'0') + Isnull(NF.falta06,'0') + Isnull(NF.falta07,'0') + Isnull(NF.falta08,'0') + Isnull(NF.falta09,'0') + Isnull(NF.falta10,'0') + Isnull(NF.falta11,'0') + Isnull(NF.falta12,'0') + Isnull(NF.falta13,'0') + Isnull(NF.falta14,'0') + Isnull(NF.falta15,'0'))*100/GCD.Ch_Anual as percFaltas, "
			   'sql = sql & " NF.nota" & strPosicao & " as NOTA, "
			   'sql = sql & " NF.falta" & strPosicao & " as FALTA, "  
			   for i=1 to ubound(vetTipoNota)
				   strPos = left(vetTipoNota(i,1),2)
				   sql = sql & " 	NF.NOTA"&strPos&", "
				   sql = sql & " 	NF.FALTA"&strPos&", "
			   next
                sql = sql & " NF.codigo AS COD_NOTA, "
		        sql = sql & " NF.situacao "
				sql = sql & "FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
 				sql = sql & "SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
				sql = sql & "SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO  AND AD.cod_empresa = T.cod_empresa INNER JOIN "
				sql = sql & "SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA INNER JOIN "
			    sql = sql & "SCA_DISCIPLINA DI ON DI.COD_EMPRESA = AD.COD_EMPRESA AND DI.COD_DISCIPLINA = AD.COD_DISCIPLINA INNER JOIN "
			    sql = sql & "SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
 				sql = sql & "SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA INNER JOIN "
 				sql = sql & "SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
 				sql = sql & "SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
 				sql = sql & "WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & "AND AD.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & "AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
				sql = sql & " AND A.CODIGO IN (" & strCodAluno & ")"
				'if intCodSituacaoAluno = "" or intCodSituacaoAluno = "0" then
				
				if strAtivos = "A" then	
				  sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				end if
				
				if intCodSituacaoAluno <> "" or intCodSituacaoAluno <> "0" then
				   'sql = sql & "AND SA.Cod_SituacaoAluno = " & intCodSituacaoAluno
				end if
				
				if strSituacaoPromocao <> "0" then
					sql = sql & " AND NF.situacao = '" & strSituacaoPromocao & "'"
				end if	

				'sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
 				sql = sql & "ORDER BY A.NOMEALUNO "
							
		end if
		'response.Write(sql) & "<br>"
		'response.Write(buscaHistorico)
		'response.End()
		
		rs.open sql, cnn
		if rs.eof = false then
			strNomeTurma 	 = rs("NOMETURMA")
			strDescricaoTurno= rs("DESC_TURNO")
			strDisciplina 	= rs("DESC_DISCIPLINA")
			%>
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			   <tr>
    		   <td width="8%">Curso:</td>
			   <td width="63%">&nbsp;<strong><%=strDescricaoCurso%></strong></td>
			   <td width="14%">Turma:</td>
			   <td width="15%">&nbsp;<strong><%=strNomeTurma%></strong></td>
			   </tr>
			   <tr>
			   <td>Per&iacute;odo:</td>
			   <td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
			   <td>Turno:</td>
			   <td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
			   </tr>
			   <tr>
			   <td colspan="4" class="TituloFormulario" align="center"><font size="+1"><%=UCASE(strDisciplina)%></font></td>
			   </tr>
			</table>
			<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
			<tr>
			<td width="8%" rowspan="2" align="center" class="celulaFonte9">Matr&iacute;cula</td>
			<td width="36%" rowspan="2" align="center" class="celulaFonte9">Nome do Aluno </td>
			<%
			strTipoNotaAprentadaAnterior = ""
			FOR I=1 TO UBOUND(vetTipoNota) 
    			if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) then
					strColspan = ""
	    			vet = split(strDescTipoNotaTitulo,right(vetTipoNota(I,1),1))
		    	if ubound(vet)>=1 then	
			       if cInt(right(vetTipoNota(I,1),1)) > 4  then
					  strColspan = "colspan='" & ubound(vet) & "'" 'quat de notas * 2 + 1 da coluna da falta
				   else
							strColspan = "colspan='" & ubound(vet)+1 & "'" 'quat de notas * 2 + 1 da coluna da falta
				   end if
				end if
				strBim = right(vetTipoNota(I,1),1) & "ºBimestre" 
				'5	Média Provisória 
				'6	Exame
				'7	Conselho de Classe
				'8	Media Final							
				if cInt(right(vetTipoNota(I,1),1)) > 4 then strBim = vetTipoNota(I,2)
				if cInt(right(vetTipoNota(I,1),1)) = 5 then strBim = "Média Provisória"
				if cInt(right(vetTipoNota(I,1),1)) = 6 then strBim = "Exame"
				if cInt(right(vetTipoNota(I,1),1)) = 7 then strBim = "Conselho de Classe"
				%>
				<td align="center" class="celulaFonte9" <%=strColspan%>><%=strBim%></td>
				<%
				end if
				strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
			NEXT %>
			<td width="8%" align="center" class="celulaFonte9" >Média</td>
			<td width="14%" align="center" class="celulaFonte9" >Faltas</td>
		 <%if strMostraResultadoFinal = "S" then%>
			     <td width="7%" align="center" class="celulaFonte9" >Resultado</td>
			<%END IF%>
			</tr>
			<tr>
			<%	strTipoNotaAprentadaAnterior = ""
				FOR I=1 TO UBOUND(vetTipoNota) 
					if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6" and trim(right(vetTipoNota(I,1),1)) <> "7" then
					%>
					<td align="center" class="celulaFonte9">Faltas</td>	
					<%
					end if
					%>
					<td align="center" class="celulaFonte9"><%=vetTipoNota(I,2)%></td>
					<%
					strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
				NEXT %>
				<td width="14%" align="center" class="celulaFonte9" >Final</td>
				<td width="7%" align="center" class="celulaFonte9" >Total</td>
		 <%if strMostraResultadoFinal = "S" then%>
				     <td width="8%" align="center" class="celulaFonte9" >Final</td>
				<%END IF%>
				</tr>
			<%
			intContTotalAluno = intContTotalAluno + 0
			intCotRN = 0
			intCotAP = 0
			while not rs.eof
				intContTotalAluno = intContTotalAluno + 1
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strTotalFalta 	= 0
				
				strMedia		= "---"
				strResultadoFinal 		= ""
				IF TRIM(RS("SITUACAO"))="RN" THEN
					strResultadoFinal = "<font color='#FF0000'>RN</font>"
				ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
					strResultadoFinal = "<font color='#0000FF'>AP</font>"
				END IF
						
				if not isnull(rs("MEDIA")) and rs("MEDIA")<>"" then
					
					strMedia = FORMATNUMBER(rs("MEDIA"),1)
					
					if cCur(strMedia) < cCur(intMediaAprovacao) then
						strResultadoFinal = "<font color='#FF0000'>RN</font>"
						intCotRN = intCotRN + 1
					else
						strResultadoFinal = "<font color='#0000FF'>AP</font>"
						intCotAP  = intCotAP + 1
					end if
					
				end if
				%>
				  <tr>
					<td align="left" class="celulaFonte9"><%=strMatricula%></td>
					<td align="left" class="celulaFonte9">&nbsp;<%=strNomeAluno%></td>
					<%	strTipoNotaAprentadaAnterior = ""
					    strFalta = 0
						FOR I=1 TO UBOUND(vetTipoNota) 
							strPos = left(vetTipoNota(i,1),2)
							strNota = "---"
							if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
								strNota = FORMATNUMBER(rs("NOTA" & strPos),2)
							end if
							if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
                                strTotalFalta = strTotalFalta  + rs("FALTA" & strPos)
								if trim(strTipoNotaAprentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaAprentadaAnterior = "" then
 									strFalta = rs("FALTA" & strPos)
							    end if
							end if
							if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6"  and trim(right(vetTipoNota(I,1),1)) <> "7"  then
								if strFalta <> 0 then
								   %>
								   <td width="6%" align="center" class="celulaFonte9">&nbsp;<%=strFalta%>&nbsp;</td>
								   <%
								else  
								   %>
								   <td width="6%" align="center" class="celulaFonte9">&nbsp;&nbsp;</td>
						   <% 
								End if   
								strFalta = rs("FALTA" & strPos)
							end if
							%>
							<td width="8%" align="center" class="celulaFonte9">&nbsp;<%=strNota%>&nbsp;</td>
							<%
							strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
						NEXT %>					
					<td width="14%" align="center" class="celulaFonte9">&nbsp;<%=strMedia%>&nbsp;</td>
					<%
					if strTotalFalta <> 0 then
					   %>
					   <td width="7%" align="center" class="celulaFonte9">&nbsp;<%=strTotalFalta%>&nbsp;</td>
					   <%
					else   
					   %>
					   <td width="7%" align="center" class="celulaFonte9">&nbsp;&nbsp;</td>
				     <%
					end if   
				    if strMostraResultadoFinal = "S" then%>
		              <td width="8%" align="center" class="celulaFonte9">&nbsp;<%=strResultadoFinal%></td>		    
				   <%end if%>
				  	</tr>
					<%
					strPercFaltas = rs("percFaltas")
					if strPercFaltas > intFrequenciaMinimaPerc then
						strQtdeDiscRep = strQtdeDiscRep + 1
					end if						
				contQuebra = contQuebra + 1
				if contQuebra >= 50 then
			       fimTabela  %>
				 
		     	   <table width="85%" border="0" cellspacing="0" cellpadding="0">
                     <tr>
	                 <td colspan="3" align="left"><strong><%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</strong></td>
                     <td align="left">&nbsp;</td>
                     </tr>
  
                     <tr>
                     <td align="center"></td>
                     <td align="center"></td>
                     <td align="center">&nbsp;</td>
                     <td align="center">&nbsp;</td>
                     </tr>
                     <tr>
                     <td align="center"></td>
                     <td align="center"></td>
                     <td align="center">&nbsp;</td>
                     <td align="center">&nbsp;</td>
                     </tr>
                     <tr>
                     <td width="9%" align="center"></td>
                     <td width="25%" align="center"><div align="right"><strong>Recebido 
        por:</strong></div></td>
	                 <td width="33%" align="center">________________________________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	                 <td width="33%" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;________________________________________</td>
                     </tr>
                     <tr>
                     <td align="center">&nbsp;</td>
                     <td align="center">&nbsp;</td>
                     <td align="center"><strong><%=session("NomeSecretariaEmpresaWeb")%></strong></td>
	                 <td align="center"><strong><%=strProfessorAssinatura%></strong></td>
                     </tr>
                     <tr>
                     <td align="center">&nbsp;</td>
                     <td align="center"><br /></td>
                     <td align="center">Secretaria Geral<br />____/____/________</td>
	                 <td align="center">Professor<br />____/____/________</td>
                     </tr>
                   </table>
    			   <pre></pre>			
				   <%	
				   mostraCabecalho	 
				   contQuebra = 0	
				   '
			       strNomeTurma 	 = rs("NOMETURMA")
				   strDescricaoTurno= rs("DESC_TURNO")
			       strDisciplina 	= rs("DESC_DISCIPLINA")
			       %>
			       <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			         <tr>
    		           <td width="8%">Curso:</td>
			           <td width="63%">&nbsp;<strong><%=strDescricaoCurso%></strong></td>
			           <td width="14%">Turma:</td>
			           <td width="15%">&nbsp;<strong><%=strNomeTurma%></strong></td>
			         </tr>
			         <tr>
			           <td>Per&iacute;odo:</td>
			           <td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
			           <td>Turno:</td>
			           <td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
			         </tr>
			         <tr>
			         <td colspan="4" class="TituloFormulario" align="center"><font size="+1"><%=UCASE(strDisciplina)%></font></td>
			         </tr>
			       </table>
			       <table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
			         <tr>
			         <td width="8%" rowspan="2" align="center" class="celulaFonte9">Matr&iacute;cula</td>
			         <td width="36%" rowspan="2" align="center" class="celulaFonte9">Nome do Aluno </td>
			         <%
			         strTipoNotaAprentadaAnterior = ""
			         FOR I=1 TO UBOUND(vetTipoNota) 
    			        if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) then
					       strColspan = ""
	    			       vet = split(strDescTipoNotaTitulo,right(vetTipoNota(I,1),1))
		    	        if ubound(vet)>=1 then	
			               if cInt(right(vetTipoNota(I,1),1)) > 4  then
					          strColspan = "colspan='" & ubound(vet) & "'" 'quat de notas * 2 + 1 da coluna da falta
				           else
						      strColspan = "colspan='" & ubound(vet)+1 & "'" 'quat de notas * 2 + 1 da coluna da falta
				           end if
				        end if
				        strBim = right(vetTipoNota(I,1),1) & "ºBimestre" 
				        '5	Média Provisória 
				        '6	Exame
				        '7	Conselho de Classe
				        '8	Media Final							
				        if cInt(right(vetTipoNota(I,1),1)) > 4 then strBim = vetTipoNota(I,2)
				        if cInt(right(vetTipoNota(I,1),1)) = 5 then strBim = "Média Provisória"
				        if cInt(right(vetTipoNota(I,1),1)) = 6 then strBim = "Exame"
				        if cInt(right(vetTipoNota(I,1),1)) = 7 then strBim = "Conselho de Classe"
				           %>
			        	   <td align="center" class="celulaFonte9" <%=strColspan%>><%=strBim%></td>
				           <%
				        end if
				        strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
			         NEXT %>
		          	 <td width="8%" align="center" class="celulaFonte9" >Média</td>
			         <td width="14%" align="center" class="celulaFonte9" >Faltas</td>
			         <%if strMostraResultadoFinal = "S" then%>
			              <td width="7%" align="center" class="celulaFonte9" >Resultado</td>
			         <%END IF%>
			      </tr>
			      <tr>
			    <%	strTipoNotaAprentadaAnterior = ""
				FOR I=1 TO UBOUND(vetTipoNota) 
					if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6" and trim(right(vetTipoNota(I,1),1)) <> "7" then
					%>
					<td align="center" class="celulaFonte9">Faltas</td>	
					<%
					end if
					%>
					<td align="center" class="celulaFonte9"><%=vetTipoNota(I,2)%></td>
					<%
					strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
				NEXT %>
				<td width="14%" align="center" class="celulaFonte9" >Final</td>
				<td width="7%" align="center" class="celulaFonte9" >Total</td>
    <%if strMostraResultadoFinal = "S" then%>
  				     <td width="8%" align="center" class="celulaFonte9" >Final</td>
				<%END IF%>
				</tr>
			    <%
	    	   end if			
			   rs.movenext
			wend 
			%></table>
<%
			'estatistica de aprovação/reprovação
		IF strMostraResumoResultados = "S" then
			IF buscaHistorico = "S" then
				sql = " SELECT "
				sql = sql & " 	Count(A.CODIGO) as qtdeAluno, 	"
				sql = sql & " 	HED.SITUACAO 	"
				sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA INNER JOIN SCA_TURMA T ON T.COD_TURMA = HED.COD_TURMA AND T.ANOLETIVO = HED.Ano_Letivo AND T.COD_SEMESTRE = HED.SEMESTRE AND T.cod_empresa = HE.cod_empresa INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular AND G.COD_EMPRESA = T.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA = HE.COD_EMPRESA AND D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
				sql = sql & " WHERE A.COD_EMPRESA = " & strCod_empresa
				sql = sql & " AND HED.COD_TURMA = " & intCodTurma
				sql = sql & " AND A.CODIGO IN (" & strCodAluno & ")" 
				sql = sql & " AND HED.ANO_LETIVO =  " & intAnoLetivoAtual
				sql = sql & " AND HED.SEMESTRE = " & intSemestreAtual
				sql = sql & " AND D.COD_DISCIPLINA = " & intCodDisciplina
				if strSituacaoPromocao <> "0" then
					sql = sql & " AND HED.SITUACAO = '" & strSituacaoPromocao & "'"
				end if	
				sql = sql & " group by HED.SITUACAO "
				sql = sql & " order by 2"	
			ELSE
				sql = " SELECT "
				sql = sql & " 	Count(A.CODIGO) as qtdeAluno, 	"
				sql = sql & " SA.Desc_SituacaoAluno "
				sql = sql & "FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
				sql = sql & "SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
				sql = sql & "SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO  AND AD.cod_empresa = T.cod_empresa INNER JOIN "
				sql = sql & "SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA INNER JOIN "
				sql = sql & "SCA_DISCIPLINA DI ON DI.COD_EMPRESA = AD.COD_EMPRESA AND DI.COD_DISCIPLINA = AD.COD_DISCIPLINA INNER JOIN "
				sql = sql & "SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
				sql = sql & "SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA INNER JOIN "
				sql = sql & "SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
				sql = sql & "SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
				sql = sql & "WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & "AND AD.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & "AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
				sql = sql & " AND A.CODIGO IN (" & strCodAluno & ")"
			
				if strAtivos = "A" then	
				  sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				end if
				
				if strSituacaoPromocao <> "0" then
					sql = sql & " AND NF.situacao = '" & strSituacaoPromocao & "'"
				end if	

				sql = sql & " group by SA.Desc_SituacaoAluno " 
				sql = sql & "ORDER BY SA.Desc_SituacaoAluno "	
							
			END IF
			rsAux.open sql, cnn
			if not rsAux.eof then
			%>
            <br>
            <table align="center" width="50%" border="0" cellspacing="0" cellpadding="0" class="tabela">
              <tr bgcolor="#CCCCCC">
                <td colspan="3" align="center" bgcolor="#E0E0E0" class="celulaFonte9" ><strong>RESUMO DOS RESULTADOS</strong></td>
              </tr>
              <tr bgcolor="#CCCCCC">
                <td align="center" class="celulaFonte9" ><strong>Situa&ccedil;&atilde;o</strong></td>
                <td align="center" class="celulaFonte9" ><strong>Quantidade de Alunos</strong></td>
                <td align="center" class="celulaFonte9" ><strong>Percentual</strong></td>
              </tr>
			<%	intQtdeRepFaltaTotal= 0
				while not rsAux.eof
					msn = ""
					'if trim(rsAux("situacao"))="RN" then	
					'	msn = "*"
					'end if
					%>              
					  <tr>
						<td class="celulaFonte9"  align="center"><%=rsAux("Desc_SituacaoAluno")%><%=msn%>&nbsp;</td>
						<td class="celulaFonte9"  align="center"><%=rsAux("qtdeAluno")%>&nbsp;</td>
						<td class="celulaFonte9" align="center" ><%=FormatNumber ( ( rsAux("qtdeAluno")*100 )/intContTotalAluno, 1 )%>%&nbsp;</td>
					  </tr>
					<%
					rsAux.movenext
				wend
				rsAux.close
				if strQtdeDiscRep>0 then
					%>              
					  <%if strMostraResultadoFinal = "S" then%>
                      <tr bgcolor="#FFEAEA">
					    <td class="celulaFonte9"  align="center">*RN Por Nota&nbsp;</td>
					    <td class="celulaFonte9"  align="center"><%=intCotRN%>  &nbsp;</td>
					    <td class="celulaFonte9" align="center" ><%=FormatNumber ( (intCotRN*100)/intContTotalAluno, 1 )%>%&nbsp;</td>
		      		</tr>
                    <%end if%>
					  <tr bgcolor="#FFEAEA">
						<td class="celulaFonte9"  align="center">*RF Por Faltas&nbsp;</td>
						<td class="celulaFonte9"  align="center"><%=strQtdeDiscRep%>&nbsp;</td>
						<td class="celulaFonte9" align="center" ><%=FormatNumber ( ( strQtdeDiscRep*100 )/intContTotalAluno, 1 )%>%&nbsp;</td>
					  </tr>
                <%
				end if
				%>
            </table>
            <%
			end if
		end if%>
<br>
					     	   <table width="85%" border="0" cellspacing="0" cellpadding="0">
                     <tr>
	                 <td colspan="3" align="left"><strong><%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</strong></td>
                     <td align="left">&nbsp;</td>
                     </tr>
  
                     <tr>
                     <td align="center"></td>
                     <td align="center"></td>
                     <td align="center">&nbsp;</td>
                     <td align="center">&nbsp;</td>
                     </tr>
                     <tr>
                     <td align="center"></td>
                     <td align="center"></td>
                     <td align="center">&nbsp;</td>
                     <td align="center">&nbsp;</td>
                     </tr>
                     <tr>
    
                     <td width="9%" align="center"></td>
                     <td width="25%" align="center"><div align="right"><strong>Recebido 
        por:</strong></div></td>
	                 <td width="33%" align="center">________________________________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	                 <td width="33%" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;________________________________________</td>
                     </tr>
                     <tr>
                     <td align="center">&nbsp;</td>
                     <td align="center">&nbsp;</td>
                     <td align="center"><strong><%=session("NomeSecretariaEmpresaWeb")%></strong></td>
	                 <td align="center"><strong><%=strProfessorAssinatura%></strong></td>
                     </tr>
                     <tr>
                     <td align="center">&nbsp;</td>
                     <td align="center"><br /></td>
                     <td align="center">Secretaria Geral<br />____/____/________</td>
	                 <td align="center">Professor<br />____/____/________</td>
                     </tr>
                   </table>
 
			<br>
			<%		
		end if
		rs.close
	else
		rs.close
		cnn.close
		%>
			<script>
			alert("Aluno não foi encontrato, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	%>
	<script>
		aguarde.style.display="none";
	</script>
</body>
</html>