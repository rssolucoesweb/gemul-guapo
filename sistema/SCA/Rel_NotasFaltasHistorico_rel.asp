<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/08/2012
	::	Desenvolvedores...: Sergio Borges - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Notas Faltas Historico
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
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	
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
	
	
	intIntervaloPercFaltaInicial	= Trim(Request.Form("txtIntervaloPercFaltaInicial"))
	intIntervaloPercFaltaFinal		= Trim(Request.Form("txtIntervaloPercFaltaFinal"))
	intIntervaloMediaInicial		= Trim(Request.Form("txtIntervaloMediaInicial"))
	intIntervaloMediaFinal			= Trim(Request.Form("txtIntervaloMediaFinal"))
	intTotalExtrato					= Trim(Request.Form("cmbTotalExtrato"))
	FiltroTotalFaltas				= Trim(Request.Form("cmbFiltroTotalFaltas"))
	strclasse               		= Trim(Request.Form("cmbTamanhoFonteArial"))

	intIntervaloPercFaltaInicial	= ""
	intIntervaloPercFaltaFinal		= ""
	intIntervaloMediaInicial		= ""
	intIntervaloMediaFinal			= ""

	dim intPagina
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "Acumulada de Notas e Faltas - Histórico<br>" & msnHistorico
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub	
	intColunas = 0

	strMostraResultadoFinal	= Trim(Request.Form("resultadoFinal"))
	if strMostraResultadoFinal = "S" then intColunas = intColunas + 1
	
	'strMostraCH			= Trim(Request.Form("CH"))
	strMostraCH			= "S"
	if strMostraCH = "S" then intColunas = intColunas + 1
	'strMostraPercFaltas = Trim(Request.Form("PercFaltas"))
	strMostraPercFaltas = "S"
	if strMostraPercFaltas = "S" then intColunas = intColunas + 1
	intCodCurso			= Trim(Request.Form("cmbCurso"))
	strCod_empresa 		= Session("CodEmpresa")
	
	intMaisSpan = 0
	if strMostraResultadoFinal = "S" then intMaisSpan = intMaisSpan + 1
	if strMostraCH = "S" then intMaisSpan = intMaisSpan + 1
	if strMostraPercFaltas = "S" then intMaisSpan = intMaisSpan + 1	

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
	sql="SELECT distinct TA.POSICAO, TA.DESCRICAO, TA.SIGLA, TA.BIMESTRE, CA.media_aprovacao"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO "
	sql=sql & " WHERE	CA.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		TA.BIMESTRE<>8"
	sql=sql & " ORDER BY TA.POSICAO"
	rs.open sql, cnn
	if not rs.eof then
		while not rs.eof
			if cInt(rs("bimestre")) < 5 then
				intColunas = intColunas + 2
			else
				intColunas = intColunas + 1
			end if
			rs.movenext
		wend
	end if
	rs.close
	'adiciona 1 para disciplina
	intColunas = intColunas + 1
	'adiciona 1 para media
	intColunas = intColunas + 1
	
	
	sql="SELECT distinct TA.POSICAO, TA.DESCRICAO, TA.SIGLA, TA.BIMESTRE, CA.media_aprovacao, CA.num_disciplina_recuperacao, ca.num_disciplina_prog_parcial, ca.tipoFormulaFinal, ca.frequencia_minima_percentual"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO "
	sql=sql & " WHERE	CA.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		TA.BIMESTRE<>8"
	sql=sql & " ORDER BY TA.POSICAO"
	rs.open sql, cnn, 3, 1
	if rs.eof then
		rs.close
		%>
			<script>
					var men = 'ATENÇÃO: \nNão foi encontrado critério de avaliação para o curso <%=strDescricaoCurso%> dessa turma. Deseja cadastrar o critério desse curso?';
					if (confirm(men)) {
						window.location="Avaliacao_cad.asp?intCodCurso=<%=intCodCurso%>";
					} else {
						window.history.back();
					}
			</script>
		<%
		response.end
	else
		
		intMediaAprovacao 			= rs("media_aprovacao")
		intQtdeDisciplinaRecuperacao= rs("num_disciplina_recuperacao")
		intQtdeDisciplinaDependencia= rs("num_disciplina_prog_parcial")
		strTipoFormulaFinal 		= rs("tipoFormulaFinal")
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
		vetAluno	=	split(Trim(Request.form("chkAluno")),",")
	end if
	bolLinhaTilulo = true
	

	mostraCabecalho
	if strCodAluno <> "" then 

		contQuebraPagina = 0		
		for j=0 to ubound(vetAluno)

			if intCodTurma = "0" then
				'aluno na turma
				sql = "select TOP 1 COD_TURMA"
				sql = sql & " from SCA_ALUNO_TURMA"
				sql = sql & " where COD_EMPRESA = " &  strCod_empresa
				sql = sql & " and COD_ALUNO = " &  vetAluno(j)
				sql = sql & " and ANO_LETIVO = " &  intAnoLetivoAtual
				sql = sql & " and SEMESTRE IN (" &  intSemestreAtual & ")"
				sql = sql & " and SITUACAO = 'A' ORDER BY CODIGO DESC"'ATIVA
				RS.OPEN SQL, CNN
				if not rs.eof then
					intCodTurma = rs("cod_Turma")
				end if
				rs.close
			end if
	
			if intCodTurma <> "0" then
			
				sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.DesvincularCriterioAvaliacao, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO"
				sql = sql & " FROM SCA_TURMA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
				sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
				sql = sql & " INNER 	JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.COD_CURSO AND SCA_CURSO.COD_EMPRESA = SCA_PERIODO.COD_EMPRESA "
				SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
				sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
				RS.OPEN SQL, CNN
				IF not RS.EOF THEN
					intCodCurso 					= rs("cod_curso")
					intCodPeriodo 					= rs("cod_periodo")
					intCodTurno 					= rs("cod_turno")
					intSemestre						= rs("cod_Semestre")
					strDesvincularCriterioAvaliacao	= rs("DesvincularCriterioAvaliacao")
					strDescricaoPeriodo  			= rs("PERIODO")
					strDescricaoCurso 	 			= rs("CURSO")
				END IF
				rs.close
				
					
				'HISTORICO ESCOLAR
				sql = " SELECT A.CODIGO, "
				sql = sql & " 	A.MATRICULA, "
				sql = sql & " 	A.NOMEALUNO, "
				sql = sql & " 	A.DATAMATRICULA, "					
				sql = sql & " 	A.DATAFASTAMENTO, "
				sql = sql & " 	HED.COD_TURMA, "
				sql = sql & " 	T.NOMETURMA, "
				sql = sql & " 	T.COD_TURMA, "
				sql = sql & " 	G.Cod_Periodo, "
				sql = sql & " 	Isnull(HED.MEDIA,'0') AS MEDIA, "
				sql = sql & " 	(Isnull(HED.falta01,'0') + Isnull(HED.falta02,'0') + "
				sql = sql & " 	Isnull(HED.falta03,'0') + Isnull(HED.falta04,'0') + Isnull(HED.falta05,'0') + "
				sql = sql & " 	Isnull(HED.falta06,'0') + Isnull(HED.falta07,'0') + Isnull(HED.falta08,'0') + "
				sql = sql & " 	Isnull(HED.falta09,'0') + Isnull(HED.falta10,'0') + Isnull(HED.falta11,'0') + Isnull(HED.falta12,'0') + "
				sql = sql & " 	Isnull(HED.falta13,'0') + Isnull(HED.falta14,'0') + Isnull(HED.falta15,'0'))*100/case when HED.CARGA_HORARIA = 0 then 1 else Isnull(HED.CARGA_HORARIA,'1')end as percFaltas,"
				sql = sql & " 	HED.CARGA_HORARIA as CH_ANUAL,"
				for i=1 to ubound(vetTipoNota)
					strPos = left(vetTipoNota(i,1),2)
					sql = sql & " 	HED.NOTA"&strPos&", "
					sql = sql & " 	HED.FALTA"&strPos&", "
				next
				sql = sql & " 	D.DESC_DISCIPLINA,"
				sql = sql & " 	TU.DESC_TURNO,"
				sql = sql & " 	HED.CODIGO AS COD_NOTA, "
				sql = sql & " 	SA.DESC_SITUACAOALUNO, "
				sql = sql & " 	HED.SITUACAO"
				sql = sql & "  	From SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
				sql = sql & " 	INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
				sql = sql & " 	INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
				sql = sql & " 	INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA "
				sql = sql & " 	INNER JOIN SCA_TURMA T ON T.COD_TURMA = HED.COD_TURMA AND T.ANOLETIVO = HED.Ano_Letivo AND T.COD_SEMESTRE = HED.SEMESTRE AND T.cod_empresa = HE.cod_empresa "
				sql = sql & " 	INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular AND G.COD_EMPRESA = T.COD_EMPRESA"
				sql = sql & " 	INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA = HE.COD_EMPRESA AND D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
				sql = sql & " 	INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
				sql = sql & " 	WHERE A.COD_EMPRESA = " & strCod_empresa
				'sql = sql & " AND HED.COD_TURMA = " & intCodTurma
				sql = sql & " AND A.CODIGO = " & vetAluno(j)
				'sql = sql & " AND HED.ANO_LETIVO =  " & intAnoLetivoAtual
				'sql = sql & " AND HED.SEMESTRE = " & intSemestreAtual
				if FiltroTotalFaltas <> "0" then 
					sql = sql & " 	and (Isnull(HED.falta01,'0') + Isnull(HED.falta02,'0') + "
					sql = sql & " 	Isnull(HED.falta03,'0') + Isnull(HED.falta04,'0') + Isnull(HED.falta05,'0') + "
					sql = sql & " 	Isnull(HED.falta06,'0') + Isnull(HED.falta07,'0') + Isnull(HED.falta08,'0') + "
					sql = sql & " 	Isnull(HED.falta09,'0') + Isnull(HED.falta10,'0') + Isnull(HED.falta11,'0') + Isnull(HED.falta12,'0') + "
					sql = sql & " 	Isnull(HED.falta13,'0') + Isnull(HED.falta14,'0') + Isnull(HED.falta15,'0')) >= " & FiltroTotalFaltas
				end if
				sql = sql & " ORDER BY A.NOMEALUNO, T.NomeTurma, D.DESC_DISCIPLINA "	
				rs.open sql, cnn
				
				if rs.eof = false then
				
					strNomeAluno 	  = rs("NOMEALUNO")
					strMatricula 	  = rs("MATRICULA")
					strNomeTurma 	  = rs("NOMETURMA")
					strDescricaoTurno = rs("DESC_TURNO")
					strSituacaoaluno  = rs("DESC_SITUACAOALUNO")
					strDataMatricula  = formatadataAP(rs("DATAMATRICULA"))
					strDatafastamento = formatadataAP(rs("DATAFASTAMENTO"))
					
					intBuscaTurma = rs("COD_TURMA")
					if isnull(intBuscaTurma) or intBuscaTurma = "" then intBuscaTurma = "0"
					
					
					if bolLinhaTilulo then
					contQuebraPagina = contQuebraPagina + 1
					%>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
					  <tr>
						<td width="16%" rowspan="2" align="center" class="<%=strclasse%>">Disciplinas</td>
						<%
						strValidacaoEmpresa1 = "5"
						strValidacaoEmpresa2 = "6"
						if trim(session("codEmpresa")) = "8" then
							strValidacaoEmpresa1 = "5"
							strValidacaoEmpresa2 = ""
						end if
						strTipoNotaApresentadaAnterior = ""
						FOR I=1 TO UBOUND(vetTipoNota) 
							if trim(strTipoNotaApresentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) then
								strColspan = ""
								vet = split(strDescTipoNotaTitulo,right(vetTipoNota(I,1),1))
								if ubound(vet)>=1 then	
									if cInt(right(vetTipoNota(I,1),1)) > 4  then	
										if trim(right(vetTipoNota(I,1),1)) = strValidacaoEmpresa1 or trim(right(vetTipoNota(I,1),1)) = strValidacaoEmpresa2 then
											strColspan = "colspan='" & ubound(vet)+1 & "'" 'quat de notas * 2 + 1 da coluna da falta
										else
											strColspan = "colspan='" & ubound(vet) & "'" 'quat de notas * 2 + 1 da coluna da falta
										end if
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
								<td  align="center" class="<%=strclasse%>" <%=strColspan%>>&nbsp;<%=strBim%></td>
								<%
							end if
							strTipoNotaApresentadaAnterior = right(vetTipoNota(I,1),1)
						NEXT
					
					 %>
						<td align="center" class="<%=strclasse%>" >Média</td>
						<%if strMostraResultadoFinal = "S" then%>
                        <td align="center" class="<%=strclasse%>" >Resultado</td>
                        <%end if%>
                        <%if strMostraCH = "S" then%>
                        <td align="center" class="<%=strclasse%>" >Carga</td>
                        <%end if%>
                        <%if strMostraPercFaltas = "S" then%>
                        <td align="center" class="<%=strclasse%>" >Faltas</td>
                        <%end if%>
					  </tr>
                      <%contQuebraPagina = contQuebraPagina + 1%>
					  <tr>
						<%	strTipoNotaApresentadaAnterior = ""
							strValidacaoEmpresa1 = ""
							strValidacaoEmpresa2 = "7"
							strValidacaoEmpresa3 = ""
							if trim(session("codEmpresa")) = "8" then
								strValidacaoEmpresa1 = "6"
								strValidacaoEmpresa2 = "7"
								strValidacaoEmpresa3 = "8"
							end if
							bolImprimiu5 = false
							FOR I=1 TO UBOUND(vetTipoNota) 
								%>
								<td align="center" class="<%=strclasse%>"><%=vetTipoNota(I,2)%></td>
								<%
								if trim(right(vetTipoNota(I,1),1))="5" and bolImprimiu5 = false then
									%>
									<td align="center" class="<%=strclasse%>">Acum. Faltas</td>	
									<%
									
								else
									if trim(strTipoNotaApresentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa1  and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa2  and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa3 then
									%>
									<td align="center" class="<%=strclasse%>">Faltas</td>	
									<%
									end if
								end if
								
								strTipoNotaApresentadaAnterior = right(vetTipoNota(I,1),1)
							NEXT %>
						<td align="center" class="<%=strclasse%>" >Final</td>
						<%if strMostraResultadoFinal = "S" then%>
                        <td align="center" class="<%=strclasse%>" >Final</td> <!-- resultado final -->
                        <%end if%>
                        <%if strMostraCH = "S" then%>
                        <td align="center" class="<%=strclasse%>" >Horaria</td>
                        <%end if%>
                        <%if strMostraPercFaltas = "S" then%>
                        <td align="center" class="<%=strclasse%>" >(%)</td>
                        <%end if%>
						</tr>
					<% bolLinhaTilulo = false
					end if
					if trim(strNomeTurma) <> trim(strNomeTurmaAnt) then
					%>
                     <%contQuebraPagina = contQuebraPagina + 1%>
					  <tr bgcolor="#EFEFEF">
						<td colspan="<%=intColunas+intMaisSpan%>" align="center" class="celula"><strong><%=strDescricaoCurso%></strong></td>
						</tr>
					  <tr>
					<%
					end if
					strNomeTurmaAnt = strNomeTurma
					mostrouresultadoFinal = false
					if buscaHistorico = "S" then
					   msgSituacaoAluno = " - Matriculado em : " & strDataMatricula
                    else
					
					   msgSituacaoAluno = " - " & " (" & strSituacaoaluno & ") - Matriculado em: " & strDataMatricula
                    end if   
					%>
                     <%contQuebraPagina = contQuebraPagina + 1%>
					  <tr>
						<td colspan="<%=intColunas+intMaisSpan%>" align="left" class="celula">&nbsp;&nbsp;&nbsp;&nbsp;<strong>&nbsp;<%=strMatricula%> - <%=strNomeAluno%> <%=msgSituacaoAluno%> </strong></td>
					  </tr>
					 <%contQuebraPagina = contQuebraPagina + 1%>
                      <tr>
                      <%
					  
					sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.DesvincularCriterioAvaliacao, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO"
					sql = sql & " FROM SCA_TURMA "
					sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
					sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
					sql = sql & " INNER 	JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.COD_CURSO AND SCA_CURSO.COD_EMPRESA = SCA_PERIODO.COD_EMPRESA "
					SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
					sql = sql & " AND SCA_TURMA.Cod_Turma= " & intBuscaTurma
					RS1.OPEN SQL, CNN
					IF not RS1.EOF THEN
						strDescricaoPeriodo  			= rs1("PERIODO")
						strDescricaoCurso 	 			= rs1("CURSO")
					else
						strDescricaoPeriodo  			= " - Erro Período "
						strDescricaoCurso 	 			= " - Erro Curso "
					END IF
					rs1.close
					%>
                    <tr>
                        <td colspan="<%=intColunas+intMaisSpan%>" align="center" class="celula"><strong><%=rs("NomeTurma")%> - <%=strDescricaoPeriodo%> </strong></td>
                    </tr>
					<%		 	
				
					strTotalFaltas = 0
					strQtdeDiscRep = 0
					strTipoNotaApresentadaAnterior = ""
					strValidacaoEmpresa1 = ""
					strValidacaoEmpresa2 = ""
					strValidacaoEmpresa3 = ""
					if trim(session("codEmpresa")) = "8" then
						strValidacaoEmpresa1 = "6"
						strValidacaoEmpresa2 = "7"
						strValidacaoEmpresa3 = "8"
					end if
					strResultadoFinalComparativo = "RN"
					while not rs.eof	
						strTotalFalta 	= 0
						strDisciplina 	= rs("DESC_DISCIPLINA")
						strMedia		= "---"
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
									if trim(strTipoNotaApresentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaApresentadaAnterior = "" then
										strFalta = strFalta  + rs("FALTA" & strPos)
									end if
								end if
								if trim(strTipoNotaApresentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa1 and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa2 and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa3  then
									if not isnull(strFalta) then strTotalFaltas = strTotalFaltas + strFalta
									strFalta = rs("FALTA" & strPos)
								end if
								strTipoNotaApresentadaAnterior = right(vetTipoNota(I,1),1)
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
						
							
							IF TRIM(RS("SITUACAO"))="RN" OR TRIM(RS("SITUACAO"))="" THEN
								strResultadoFinal = "<font color='#FF0000'>RN</font>"
								strResultadoFinalComparativo = "RN"
							ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
								strResultadoFinalComparativo = "AP"
								strResultadoFinal = "<font color='#0000FF'>AP</font>"
							END IF
								%>
								<td width="16%" align="left" class="<%=strclasse%>">&nbsp;<%=strDisciplina%> </td>
								<%	
								strTipoNotaApresentadaAnterior = ""
								strFalta = 0
	
								strValidacaoEmpresa1 = ""
								strValidacaoEmpresa2 = "7"
								strValidacaoEmpresa3 = ""
								if trim(session("codEmpresa")) = "8" then
									strValidacaoEmpresa1 = "6"
									strValidacaoEmpresa2 = "7"
									strValidacaoEmpresa3 = "8"
								end if
								bolImprimiu5 = false
								
								FOR I=1 TO UBOUND(vetTipoNota) 
									strPos = left(vetTipoNota(i,1),2)
									
									strNota = "---"
									if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
										strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
									end if
									strFalta = ""
									strFaltaCal = 0
									if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
										'if trim(strTipoNotaApresentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaApresentadaAnterior = "" then
											strFalta = rs("FALTA" & strPos)
											strFaltaCal = rs("FALTA" & strPos)
										'end if
									end if
									
									%>
									<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strNota%>&nbsp;</td>
									<%
									if trim(right(vetTipoNota(I,1),1))="5" and bolImprimiu5 = false then
										%>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strTotalFaltas%>&nbsp;</td>
										<%
										bolImprimiu5 = true
									else
										if trim(strTipoNotaApresentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa1  and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa2  and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa3 then
											%>
											<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strFalta%>&nbsp;</td>
											<%
											if not isnull(strFaltaCal) then strTotalFaltas = strTotalFaltas + strFaltaCal
											'strFalta = rs("FALTA" & strPos)
										end if									
									end if							
									strTipoNotaApresentadaAnterior = right(vetTipoNota(I,1),1)
								NEXT 
								
								if isnull(strCHDisciplina) then
									strPercFaltas = 0
								else
								    if strCHDisciplina <> "" and strCHDisciplina <> "0" then
										strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
									else
										strPercFaltas = "0"
									end if	
								end if
								if strPercFaltas > intFrequenciaMinimaPerc then
									strQtdeDiscRep = strQtdeDiscRep + 1
								else
									if strResultadoFinalComparativo = "RN" then
										strQtdeDiscRep = strQtdeDiscRep + 1
									end if
								end if
								
								%>
								<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strMedia%>&nbsp;</td>
								<%if strMostraResultadoFinal = "S" then
									if clng(strPercFaltas) > clng(intFrequenciaMinimaPerc) then 
										strResultadoFinal = "<font color='#FF0000'>RF</font>"
									end if 
                                    if strDesvincularCriterioAvaliacao = "S" then
										strResultadoFinal = "<font color='#0000FF'>------</font>"
									end if %>
									<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
								<%end if%>
								<%if strMostraCH = "S" then%>
									<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
								<%end if%>
								<%if strMostraPercFaltas = "S" then%>
									<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%if strPercFaltas<>0 then response.Write formatNumber(strPercFaltas,1) %>&nbsp;</td>
								<%end if%>
					  </tr>
								<%
							end if 
							strTotalFaltas = 0
							if intContadorExtrato >= clng(intTotalExtrato) then
								
								intContadorExtrato = 0
								
								contQuebraPagina = 0
								'linha titulo novamente
								
								contQuebraPagina = contQuebraPagina + 1
								%>
								</table>
                                <br style="PAGE-BREAK-BEFORE: always;">&nbsp;
								<% mostraCabecalho %>
                                <table width="100%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
								  <tr>
									<td width="16%" rowspan="2" align="center" class="<%=strclasse%>">Disciplinas</td>
									<%
									strValidacaoEmpresa1 = "5"
									strValidacaoEmpresa2 = "6"
									if trim(session("codEmpresa")) = "8" then
										strValidacaoEmpresa1 = "5"
										strValidacaoEmpresa2 = ""
									end if
									strTipoNotaApresentadaAnterior = ""
									FOR I=1 TO UBOUND(vetTipoNota) 
										if trim(strTipoNotaApresentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) then
											strColspan = ""
											vet = split(strDescTipoNotaTitulo,right(vetTipoNota(I,1),1))
											if ubound(vet)>=1 then	
												if cInt(right(vetTipoNota(I,1),1)) > 4  then	
													if trim(right(vetTipoNota(I,1),1)) = strValidacaoEmpresa1 or trim(right(vetTipoNota(I,1),1)) = strValidacaoEmpresa2 then
														strColspan = "colspan='" & ubound(vet)+1 & "'" 'quat de notas * 2 + 1 da coluna da falta
													else
														strColspan = "colspan='" & ubound(vet) & "'" 'quat de notas * 2 + 1 da coluna da falta
													end if
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
											<td  align="center" class="<%=strclasse%>" <%=strColspan%>>&nbsp;<%=strBim%></td>
											<%
										end if
										strTipoNotaApresentadaAnterior = right(vetTipoNota(I,1),1)
									NEXT
								

								 %>
									<td align="center" class="<%=strclasse%>" >Média</td>
									<%if strMostraResultadoFinal = "S" then%>
									<td align="center" class="<%=strclasse%>" >Resultado</td>
									<%end if%>
									<%if strMostraCH = "S" then%>
									<td align="center" class="<%=strclasse%>" >Carga</td>
									<%end if%>
									<%if strMostraPercFaltas = "S" then%>
									<td align="center" class="<%=strclasse%>" >Faltas</td>
									<%end if%>
								  </tr>
								  <%contQuebraPagina = contQuebraPagina + 1%>
								  <tr>
									<%	strTipoNotaApresentadaAnterior = ""
										strValidacaoEmpresa1 = ""
										strValidacaoEmpresa2 = "7"
										strValidacaoEmpresa3 = ""
										if trim(session("codEmpresa")) = "8" then
											strValidacaoEmpresa1 = "6"
											strValidacaoEmpresa2 = "7"
											strValidacaoEmpresa3 = "8"
										end if
										bolImprimiu5 = false
										FOR I=1 TO UBOUND(vetTipoNota) 
											%>
											<td align="center" class="<%=strclasse%>"><%=vetTipoNota(I,2)%></td>
											<%
											if trim(right(vetTipoNota(I,1),1))="5" and bolImprimiu5 = false then
												%>
												<td align="center" class="<%=strclasse%>">Acum. Faltas</td>	
												<%
												
											else
												if trim(strTipoNotaApresentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa1  and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa2  and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa3 then
												%>
												<td align="center" class="<%=strclasse%>">Faltas</td>	
												<%
												end if
											end if
											
											strTipoNotaApresentadaAnterior = right(vetTipoNota(I,1),1)
										NEXT %>
									<td align="center" class="<%=strclasse%>" >Final</td>
									<%if strMostraResultadoFinal = "S" then%>
									<td align="center" class="<%=strclasse%>" >Final</td> <!-- resultado final -->
									<%end if%>
									<%if strMostraCH = "S" then%>
									<td align="center" class="<%=strclasse%>" >Horaria</td>
									<%end if%>
									<%if strMostraPercFaltas = "S" then%>
									<td align="center" class="<%=strclasse%>" >(%)</td>
									<%end if%>
								  </tr>
								<% 
										
							end if	
							
							strChaveNometurma = rs("NomeTurma")						
							
						rs.movenext
						

					    if rs.eof = false then
						
							intBuscaTurma = rs("COD_TURMA")
							if isnull(intBuscaTurma) or intBuscaTurma = "" then intBuscaTurma = "0"
							
							if strChaveNometurma <> rs("NomeTurma") then
							   sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.DesvincularCriterioAvaliacao, SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO"
								sql = sql & " FROM SCA_TURMA "
								sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
								sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
								sql = sql & " INNER 	JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.COD_CURSO AND SCA_CURSO.COD_EMPRESA = SCA_PERIODO.COD_EMPRESA "
								SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
								sql = sql & " AND SCA_TURMA.Cod_Turma= " & intBuscaTurma
								RS1.OPEN SQL, CNN
								IF not RS1.EOF THEN
									strDescricaoPeriodo  			= rs1("PERIODO")
									strDescricaoCurso 	 			= rs1("CURSO")
								else
									strDescricaoPeriodo  			= " - Erro Período "
									strDescricaoCurso 	 			= " - Erro Curso "
								END IF
								rs1.close

							 	%>
                                <tr>
                                	<td colspan="<%=intColunas+intMaisSpan%>" align="center" class="celula"><strong><%=rs("NomeTurma")%> - <%=strDescricaoPeriodo%> </strong></td>
                                </tr>
                                <%
                			end if
						end if	
 
 					wend
					
								 
			 		intContadorExtrato = intContadorExtrato + 1

				else
					mostrouresultadoFinal=true
				end if
				if rs.eof = false then
				   strUltimoCabecalho = "S"
				else
				   strUltimoCabecalho = "N"
				end if   
				
				rs.close
							
				
             
				 contQuebraPagina = contQuebraPagina + 1

				%>
				<tr>
				<%
				
				strTotalFaltas = 0
				if intContadorExtrato >= clng(intTotalExtrato) then
					
					intContadorExtrato = 0
					
					contQuebraPagina = 0
					'linha titulo novamente
					
					contQuebraPagina = contQuebraPagina + 1
					%>
					</table>
					<br style="PAGE-BREAK-BEFORE: always;">&nbsp;
					<% mostraCabecalho %>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
					  <tr>
						<td width="16%" rowspan="2" align="center" class="<%=strclasse%>">Disciplinas</td>
						<%
						strValidacaoEmpresa1 = "5"
						strValidacaoEmpresa2 = "6"
						if trim(session("codEmpresa")) = "8" then
							strValidacaoEmpresa1 = "5"
							strValidacaoEmpresa2 = ""
						end if
						strTipoNotaApresentadaAnterior = ""
						FOR I=1 TO UBOUND(vetTipoNota) 
							if trim(strTipoNotaApresentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) then
								strColspan = ""
								vet = split(strDescTipoNotaTitulo,right(vetTipoNota(I,1),1))
								if ubound(vet)>=1 then	
									if cInt(right(vetTipoNota(I,1),1)) > 4  then	
										if trim(right(vetTipoNota(I,1),1)) = strValidacaoEmpresa1 or trim(right(vetTipoNota(I,1),1)) = strValidacaoEmpresa2 then
											strColspan = "colspan='" & ubound(vet)+1 & "'" 'quat de notas * 2 + 1 da coluna da falta
										else
											strColspan = "colspan='" & ubound(vet) & "'" 'quat de notas * 2 + 1 da coluna da falta
										end if
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
								<td  align="center" class="<%=strclasse%>" <%=strColspan%>>&nbsp;<%=strBim%></td>
								<%
							end if
							strTipoNotaApresentadaAnterior = right(vetTipoNota(I,1),1)
						NEXT
					

					 %>
						<td align="center" class="<%=strclasse%>" >Média</td>
						<%if strMostraResultadoFinal = "S" then%>
						<td align="center" class="<%=strclasse%>" >Resultado</td>
						<%end if%>
						<%if strMostraCH = "S" then%>
						<td align="center" class="<%=strclasse%>" >Carga</td>
						<%end if%>
						<%if strMostraPercFaltas = "S" then%>
						<td align="center" class="<%=strclasse%>" >Faltas</td>
						<%end if%>
					  </tr>
					  <%contQuebraPagina = contQuebraPagina + 1%>
					  <tr>
						<%	strTipoNotaApresentadaAnterior = ""
							strValidacaoEmpresa1 = ""
							strValidacaoEmpresa2 = "7"
							strValidacaoEmpresa3 = ""
							if trim(session("codEmpresa")) = "8" then
								strValidacaoEmpresa1 = "6"
								strValidacaoEmpresa2 = "7"
								strValidacaoEmpresa3 = "8"
							end if
							bolImprimiu5 = false
							FOR I=1 TO UBOUND(vetTipoNota) 
								%>
								<td align="center" class="<%=strclasse%>"><%=vetTipoNota(I,2)%></td>
								<%
								if trim(right(vetTipoNota(I,1),1))="5" and bolImprimiu5 = false then
									%>
									<td align="center" class="<%=strclasse%>">Acum. Faltas</td>	
									<%
									
								else
									if trim(strTipoNotaApresentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa1  and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa2  and trim(right(vetTipoNota(I,1),1)) <> strValidacaoEmpresa3 then
									%>
									<td align="center" class="<%=strclasse%>">Faltas</td>	
									<%
									end if
								end if
								
								strTipoNotaApresentadaAnterior = right(vetTipoNota(I,1),1)
							NEXT %>
						<td align="center" class="<%=strclasse%>" >Final</td>
						<%if strMostraResultadoFinal = "S" then%>
						<td align="center" class="<%=strclasse%>" >Final</td> <!-- resultado final -->
						<%end if%>
						<%if strMostraCH = "S" then%>
						<td align="center" class="<%=strclasse%>" >Horaria</td>
						<%end if%>
						<%if strMostraPercFaltas = "S" then%>
						<td align="center" class="<%=strclasse%>" >(%)</td>
						<%end if%>
					  </tr>
					<% 
							
				end if								
				
				
				
				
				
			end if

		next
		%></table>
<%		
		'next aluno		
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
