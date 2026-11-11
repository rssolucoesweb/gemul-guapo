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
<title><%=session("Titulo")%> - Extrato de Notas e Faltas</title>
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
<!--#include file="../../includes/aguarde.asp"-->
<%

	'insere registro

	strAnoLetivo 			= Trim(Request.Querystring("Ano"))
	intSemestre 			= Trim(Request.Querystring("Semestre"))
	
    strMostraPercFaltas = "S"
	strMostraCH = "S"
	
	dim intPagina
	
	redim vetTipoAvaliacao(0,2)

	if intSemestre = "3" then
		strTituloRelatorio  	= "Boletim de Notas e Faltas<br>Referência: "+strAnoLetivo
	else	
		strTituloRelatorio  	= "Boletim de Notas e Faltas<br>Referência: "+strAnoLetivo+"/"+intSemestre
	end if	

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub	
	
	sql = " SELECT SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.cod_Semestre, "
	sql = sql & " SCA_TURMA.cod_turma, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, "
	sql = sql & " SCA_PERIODO.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO "
	sql = sql & " FROM SCA_ALUNO_DISCIPLINA  "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.Cod_Turma  "
	sql = sql & " AND SCA_TURMA.Cod_Empresa = SCA_ALUNO_DISCIPLINA.Cod_Empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = SCA_PERIODO.COD_CURSO AND C.COD_EMPRESA = SCA_PERIODO.COD_EMPRESA"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & trim(Session("CodEmpresa"))
	sql = sql & " AND SCA_ALUNO_DISCIPLINA.Cod_aluno = " & trim(Session("CodSeguranca"))
	'sql = sql & " AND SCA_TURMA.cod_semestre = " & intSemestre
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		intCodCurso 			= rs("cod_curso")
		strDescricaoPeriodo  	= rs("PERIODO")
		strDescricaoCurso 	 	= rs("CURSO")
	else
		intCodCurso 			= 0
		strDescricaoPeriodo  	= 0
		strDescricaoCurso 	 	= 0
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
	sql = "SELECT distinct TA.POSICAO, TA.DESCRICAO, TA.SIGLA, TA.BIMESTRE, CA.media_aprovacao"
	sql = sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql = sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql = sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO "
	sql = sql & " WHERE	CA.COD_EMPRESA = " & trim(Session("CodEmpresa"))
	sql = sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql = sql & " AND		TA.BIMESTRE<>8"
	sql = sql & " ORDER BY TA.POSICAO"
	
	rs.open sql, cnn, 3, 1
	if rs.eof then
		rs.close
		%>
		<script>
           var men = 'ATENÇÃO: \nNão foi encontrado critério de avaliação para o curso desse Aluno, por favor verifique!';
            if (confirm(men)) {
                window.close();
            } else {
                window.close();
            }
        </script>
		<%
		response.end
	else
		intMediaAprovacao = rs("media_aprovacao")
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
	
	strCodAluno			= trim(Session("CodSeguranca"))
	
	if strCodAluno <> "" then 
		contQuebra = 0		
	
		  mostraCabecalho
			
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
			   sql = sql & " GCd.ch_anual, "
			   sql = sql & " NF.media, "    
			  
			   for i=1 to ubound(vetTipoNota)
				   strPos = left(vetTipoNota(i,1),2)
				   sql = sql & " 	NF.NOTA"&strPos&", "
				   sql = sql & " 	NF.FALTA"&strPos&", "
			   next
			   
				sql = sql & " NF.codigo AS COD_NOTA, "
				sql = sql & " NF.situacao "
				sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
				sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
				sql = sql & " SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO  AND AD.cod_empresa = T.cod_empresa INNER JOIN "
				sql = sql & " SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA INNER JOIN "
				sql = sql & " SCA_DISCIPLINA DI ON DI.COD_EMPRESA = AD.COD_EMPRESA AND DI.COD_DISCIPLINA = AD.COD_DISCIPLINA INNER JOIN "
				sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA INNER JOIN "
				sql = sql & " SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
				sql = sql & " SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
				sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & " AND AD.COD_ALUNO = " & trim(Session("CodSeguranca"))
				sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				sql = sql & " ORDER BY A.NOMEALUNO "
			else
			   'HISTORICO ESCOLAR
				sql = " select distinct A.CODIGO, "
				sql = sql & " A.MATRICULA, "
				sql = sql & " A.NOMEALUNO, "
				sql = sql & " AT.COD_TURMA, "
				sql = sql & " HED.CARGA_HORARIA as CH_ANUAL, "
			    sql = sql & " '' AS SEQUENCIA, " 
				sql = sql & " AT.COD_TURMA, "
				sql = sql & " T.NOMETURMA, "
				sql = sql & " G.Cod_Periodo, "
				sql = sql & " HED.MEDIA, "
				for i=1 to ubound(vetTipoNota)
					strPos = left(vetTipoNota(i,1),2)
					sql = sql & " HED.NOTA"&strPos&", "
					sql = sql & " HED.FALTA"&strPos&", "
				next
				
				sql = sql & " D.DESC_DISCIPLINA, "
				sql = sql & " TU.DESC_TURNO, "
				sql = sql & " HED.CODIGO AS COD_NOTA, "
			    sql = sql & " SA.DESC_SITUACAOALUNO, "
				sql = sql & " HED.SITUACAO, "
				sql = sql & " HE.SERIE "
				sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
				sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.ANOLETIVO = AT.Ano_Letivo AND T.COD_SEMESTRE = AT.SEMESTRE AND T.cod_empresa = AT.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular AND G.COD_EMPRESA = T.COD_EMPRESA"
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA = HE.COD_EMPRESA AND D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
				sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
				'sql = sql & " AND AT.COD_TURMA = " & intCodTurma
				sql = sql & " AND A.CODIGO = " & trim(Session("CodSeguranca"))
				sql = sql & " AND HED.ANO_LETIVO = " & strAnoLetivo
				sql = sql & " AND HED.SEMESTRE = " & intSemestre
				sql = sql & " AND AT.SITUACAO='A' "
				sql = sql & " ORDER BY A.NOMEALUNO, D.DESC_DISCIPLINA "
			end if
			rs.open sql, cnn
			
			if rs.eof = false then
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("NOMETURMA")
				strDescricaoTurno= rs("DESC_TURNO")
				if buscaHistorico = "S" then
				   strDescricaoPeriodo = rs("serie")
				end if   
				%>
					<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
					  <tr>
						<td width="8%">Aluno(a):</td>
						<td width="63%">&nbsp;<strong><%=strNomeAluno%></strong></td>
						<td width="14%">Matr&iacute;cula:</td>
						<td width="15%">&nbsp;<strong><%=strMatricula%></strong></td>
					  </tr>
					  <tr>
						<td>Curso:</td>
						<td>&nbsp;<strong><%=strDescricaoCurso%></strong></td>
						<td>Turno:</td>
						<td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
					  </tr>
					  <tr>
					    <td>Per&iacute;odo:</td>
					    <td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
					    <td>&nbsp;</td>
					    <td>&nbsp;</td>
				      </tr>
					</table>
<br>
					<table width="90%" border="1" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<td width="16%" rowspan="2" align="center" class="celulaextrato">Disciplinas</td>
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
							<td            align="center" class="celulaextrato" <%=strColspan%>><%=strBim%></td>
							<%
						end if
						strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
					NEXT %>
					<td align="center" class="celulaextrato" >Média</td>
					<%if strMostraResultadoFinal = "S" then%>
					<td align="center" class="celulaextrato" >Resultado</td>
					<%end if%>
					<%if strMostraCH = "S" then%>
					<td align="center" class="celulaextrato" >Carga</td>
					<%end if%>
					<%if strMostraPercFaltas = "S" then%>
						<td align="center" class="celulaextrato" >Faltas</td>
					<%end if%>
					</tr>
				  <tr>
				    <%	strTipoNotaAprentadaAnterior = ""
						FOR I=1 TO UBOUND(vetTipoNota) 
							if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6"  and trim(right(vetTipoNota(I,1),1)) <> "7"  and trim(right(vetTipoNota(I,1),1)) <> "8"  then
							%>
							<td align="center" class="celulaextrato">Faltas</td>	
							<%
							end if
							%>
							<td align="center" class="celulaextrato"><%=vetTipoNota(I,2)%></td>
							<%
							strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
						NEXT %>
					<td align="center" class="celulaextrato" >Final</td>
					<%if strMostraResultadoFinal = "S" then%>
					<td align="center" class="celulaextrato" >Final</td>
					<%end if%>
					<%if strMostraCH = "S" then%>
					<td align="center" class="celulaextrato" >Horaria</td>
					<%end if%>
					<%if strMostraPercFaltas = "S" then%>
					<td align="center" class="celulaextrato" >(%)</td>
					<%end if%>
					</tr>
				  <tr>
				<%
				strTotalFaltas = 0
				while not rs.eof
					
					strTotalFalta 		= 0
					strDisciplina 		= rs("DESC_DISCIPLINA")
					strMedia			= "---"
					strResultadoFinal 	= ""
					strCHDisciplina		= RS("Ch_Anual")
					
                    bolMostraLinha = true
                    strFalta = 0
						
					'utilizado somente quando for utilizado o filtro de percentual de faltas
                    if intIntervaloPercFaltaInicial <> "" and intIntervaloPercFaltaFinal <> "" then
                       FOR I=1 TO UBOUND(vetTipoNota) 
							strPos = left(vetTipoNota(i,1),2)
							if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
								strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
							end if
							if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
								if trim(strTipoNotaAprentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaAprentadaAnterior = "" then
									strFalta = strFalta  + rs("FALTA" & strPos)
								end if
							end if
							if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6" and trim(right(vetTipoNota(I,1),1)) <> "7" and trim(right(vetTipoNota(I,1),1)) <> "8"  then
								if not isnull(strFalta) then strTotalFaltas = strTotalFaltas + strFalta
								strFalta = rs("FALTA" & strPos)
							end if
							strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
			           NEXT 
					
                       if isnull(strCHDisciplina) then
                        	strPercFaltas = 0
                        	bolMostraLinha = false
                       else
                        	strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
                            if strPercFaltas >= intIntervaloPercFaltaInicial and strPercFaltas <= intIntervaloPercFaltaFinal then
                               bolMostraLinha = true
                            else
                               bolMostraLinha = false
                            end if					
                       end if
                        
					end if
					
                    if not isnull(rs("MEDIA")) and rs("MEDIA")<>"" then
					
						strMedia = FORMATNUMBER(rs("MEDIA"),1)
						if cCur(strMedia) < cCur(intMediaAprovacao) then
							strResultadoFinal = "<font color='#FF0000'>RN</font>"
						else
							strResultadoFinal = "<font color='#0000FF'>AP</font>"
						end if
                        if intIntervaloMediaInicial <> "" and intIntervaloMediaFinal <> "" then
                            if rs("MEDIA") >= intIntervaloMediaInicial and rs("MEDIA") <= intIntervaloMediaFinal then
                               bolMostraLinha = true
                            else
                               bolMostraLinha = false
                            end if
                        end if
                    else
                    
                        if intIntervaloMediaInicial <> "" and intIntervaloMediaFinal <> "" then
                            bolMostraLinha = false
                        end if                    
                    end if
					
					if bolMostraLinha then
					
    					
    					IF TRIM(RS("SITUACAO"))="RN" THEN
    						strResultadoFinal = "<font color='#FF0000'>RN</font>"
    					ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
    						strResultadoFinal = "<font color='#0000FF'>AP</font>"
    					END IF
    						%>
    						<td width="16%" align="left" class="celulaextrato">&nbsp;<%=strDisciplina%></td>
<%	
                            strTipoNotaAprentadaAnterior = ""
    						strFalta = 0
                            
                            FOR I=1 TO UBOUND(vetTipoNota) 
    							strPos = left(vetTipoNota(i,1),2)
    							strNota = "---"
    							if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
    								strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
    							end if
    							if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
    								if trim(strTipoNotaAprentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaAprentadaAnterior = "" then
    									strFalta = strFalta  + rs("FALTA" & strPos)
    								end if
    							end if
    							if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6"  and trim(right(vetTipoNota(I,1),1)) <> "7"  then
    								%>
    								<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strFalta%>&nbsp;</td>
    								<%
    								if not isnull(strFalta) then strTotalFaltas = strTotalFaltas + strFalta
    								strFalta = rs("FALTA" & strPos)
    							end if
    							%>
    							<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strNota%>&nbsp;</td>
    							<%
    							strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
    						NEXT 
    						
    						
    						if isnull(strCHDisciplina) then
    							strPercFaltas = 0
    						else
    							strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
    						end if
    						%>
    						<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strMedia%>&nbsp;</td>
    						<%if strMostraResultadoFinal = "S" then%>
    						<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
    						<%end if%>
    						<%if strMostraCH = "S" then%>
    						<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
    						<%end if%>
    						<%if strMostraPercFaltas = "S" then%>
    						<td width="5%" align="center" class="celulaextrato">&nbsp;<%if strPercFaltas<>0 then response.Write formatNumber(strPercFaltas,1) %>&nbsp;</td>
<%end if%>
    					  </tr>
    						<%
						end if 
                        strTotalFaltas = 0
					rs.movenext
				wend 
				%>
                </table>
				    <p>
				      <%	
			else
				%>
				            <script>
					alert("ATENÇÃO: Grade Curricular indisponível, aguarde lançamentos de Notas e Faltas.");
					window.close();
				      </script>
				            <%
				response.end			
			end if
			rs.close
			contQuebra = contQuebra + 1
			'A contQuebra tem que ser igual Qtde. Quebra informado na tela pelo usuario 
			if j <> strCodAluno and contQuebra = intQtdeQuebraExtrato then
				%>
<%	
				contQuebra = 0		
			end if			
		
		else
			%>
				                <script>
				alert("Aluno não foi encontrato, verifique.");
				window.history.back();
			          </script>
				                <%
			response.end
	end if 
	%>
</p>
				    <p align="center">
				      <input type="button" name="cmdPrincipal"  value="Fechar Boletim"  class="botao" <%=strDesabilitaPrincipal%> onClick="window.close()">
                    </p>
				    <p>&nbsp;                    </p>
                    <script>
		aguarde.style.display="none";
	                  </script>
</body>
</html>
