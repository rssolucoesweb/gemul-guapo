<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
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

	intAnoLetivoAtual	 	= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 	= Trim(Request.Form("cmbSemestre"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodSituacaoAluno     = Trim(Request.Form("cmbSituacaoAluno"))
	strDataInicial  		= formatadataBD(Trim(Request.Form("txtDataInicial")))
	strDataFinal  			= formatadataBD(Trim(Request.Form("txtDataFinal")))
	strDataInicialAP 		= formatadataAP(Trim(Request.Form("txtDataInicial")))
	strDataFinalAP  		= formatadataAP(Trim(Request.Form("txtDataFinal")))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	intCodTipoNota			= Trim(Request("chkTipoNota"))


	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = "SELECT DISTINCT SCA_ALUNO.CODIGO, SCA_TURMA.NomeTurma "
		sql = sql & " FROM SCA_ALUNO_TURMA "
		sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
		sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
		if intCodSituacaoAluno <> "0" then
			sql = sql & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
		end if 
		rsAux1.open sql, cnn, 3, 3
		if not rsAux1.eof then
			vetAux1 = rsAux1.getRows
		end if
		rsAux1.close
		
		if isArray(vetAux1) then
		     vetNomeTurma = " / Turma: " & vetAux1(1,1) 
			for j=0 to ubound(vetAux1,2)
				vetAlunos = vetAlunos & vetAux1(0,j) & ","
			next
		else	
			vetAlunos = 0		
		end if		
	end if	


	strTituloRelatorio  	= "MAPA RENDIMENTO<BR>Período: " & strDataInicialAP & " a " & strDataFinalAP & vetNomeTurma
	
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="22%" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Curso</strong></div></td>
	    <td width="12%" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Per&iacute;odo</strong></div></td>
	    <td colspan="4" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Disciplina(s)</strong></div></td>
	    <td width="7%" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Total de alunos na disciplina</strong></div></td>
	    <td colspan="2" class="<%=strclasse%>"><div align="center"><strong>Aprovados</strong></div></td>
	    <td colspan="2" class="<%=strclasse%>"><div align="center"><strong>Reprovados</strong>
	      </div>
        <div align="center"></div></td>
        <td colspan="2" class="<%=strclasse%>"><div align="center"><strong>Falta Lan&ccedil;amento</strong></div></td>
	  </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="5%" class="<%=strclasse%>"><div align="center"><strong>Total</strong></div></td>
		<td width="5%" class="<%=strclasse%>"><div align="center"><strong>(%)</strong></div></td>
		<td width="6%" class="<%=strclasse%>"><div align="center"><strong>Total</strong></div></td>
	    <td width="6%" class="<%=strclasse%>"><div align="center"><strong>(%)</strong></div></td>
	    <td width="6%" class="<%=strclasse%>"><div align="center"><strong>Total</strong></div></td>
	    <td width="6%" class="<%=strclasse%>"><div align="center"><strong>(%)</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	intPagina = 1
	mostraCabecalho


	sql="SELECT CODIGO, DESCRICAO, POSICAO, BIMESTRE"
	sql=sql & " FROM  SCA_TIPO_AVALIACAO"
	sql=sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql=sql & " AND		CODIGO = " & intCodTipoNota
	rs.open sql, cnn
	if rs.eof = false then
		strNomeNota			 	= rs("DESCRICAO")
		strPosicao 				= ZeroLeft(rs("POSICAO"),2)
	end if
	rs.close

	sql = " SELECT "
	sql = sql & " SCA_CURSO.Desc_Abreviada, "
	sql = sql & " SCA_PERIODO.Cod_Periodo, "
	sql = sql & " SCA_PERIODO.Descricao, "
	sql = sql & " SCA_DISCIPLINA.Cod_Disciplina, "
	sql = sql & " SCA_DISCIPLINA.Desc_Disciplina, "
	sql = sql & " Count(SCA_NOTAS_FALTAS.CODIGO) TOTALGERAL, "
	
	sql = sql & " (SELECT COUNT(SCA_NOTAS_FALTAS.CODIGO) "
	sql = sql & " FROM SCA_NOTAS_FALTAS  "
	sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and ano_letivo = " & intAnoLetivoAtual
	sql = sql & " and semestre = " & intSemestreAtual
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and COD_ALUNO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & " and cod_disciplina = SCA_DISCIPLINA.Cod_Disciplina "
	sql = sql & " and cod_periodo = SCA_PERIODO.Cod_Periodo) as TOTAIS, "

	sql = sql & " (SELECT COUNT(SCA_NOTAS_FALTAS.CODIGO) "
	sql = sql & " FROM SCA_NOTAS_FALTAS  "
	sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and ano_letivo = " & intAnoLetivoAtual
	sql = sql & " and semestre = " & intSemestreAtual
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and COD_ALUNO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & " and cod_disciplina = SCA_DISCIPLINA.Cod_Disciplina "
	sql = sql & " and cod_periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " AND nota"& strPosicao &" >= 6 ) AS APROVADOS, "
	
	sql = sql & " CONVERT(DECIMAL(5,2),(SELECT COUNT(SCA_NOTAS_FALTAS.CODIGO) "
	sql = sql & " FROM SCA_NOTAS_FALTAS  "
	sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and ano_letivo = " & intAnoLetivoAtual
	sql = sql & " and semestre = " & intSemestreAtual
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and COD_ALUNO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & " and cod_disciplina = SCA_DISCIPLINA.Cod_Disciplina "
	sql = sql & " and cod_periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " AND nota"& strPosicao &" >= 6 ) * 100.0 / Count(SCA_NOTAS_FALTAS.CODIGO),2) AS PERCENTUAL_APROVADOS, "
	
	sql = sql & " (SELECT COUNT(SCA_NOTAS_FALTAS.CODIGO) "
	sql = sql & " FROM SCA_NOTAS_FALTAS "
	sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and ano_letivo = " & intAnoLetivoAtual
	sql = sql & " and semestre = " & intSemestreAtual
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and COD_ALUNO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & " and cod_disciplina = SCA_DISCIPLINA.Cod_Disciplina "
	sql = sql & " and cod_periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " AND nota"& strPosicao &" < 6 ) AS REPROVADOS, "

	sql = sql & " CONVERT(DECIMAL(5,2),(SELECT COUNT(SCA_NOTAS_FALTAS.CODIGO) "
	sql = sql & " FROM SCA_NOTAS_FALTAS  "
	sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and ano_letivo = " & intAnoLetivoAtual
	sql = sql & " and semestre = " & intSemestreAtual
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and COD_ALUNO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & " and cod_disciplina = SCA_DISCIPLINA.Cod_Disciplina "
	sql = sql & " and cod_periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " AND nota"& strPosicao &" < 6 ) * 100.0 / Count(SCA_NOTAS_FALTAS.CODIGO)) AS PERCENTUAL_REPROVADOS, "
	
	sql = sql & " (SELECT COUNT(SCA_NOTAS_FALTAS.CODIGO) "
	sql = sql & " FROM SCA_NOTAS_FALTAS "
	sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and ano_letivo = " & intAnoLetivoAtual
	sql = sql & " and semestre = " & intSemestreAtual
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and COD_ALUNO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & " and cod_disciplina = SCA_DISCIPLINA.Cod_Disciplina "
	sql = sql & " and cod_periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " AND ISNULL(nota"& strPosicao &" ,'0')='0') AS SEMLANCAMENTO, "

	sql = sql & " CONVERT(DECIMAL(5,2),(SELECT COUNT(SCA_NOTAS_FALTAS.CODIGO) "
	sql = sql & " FROM SCA_NOTAS_FALTAS "
	sql = sql & " WHERE cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and ano_letivo = " & intAnoLetivoAtual
	sql = sql & " and semestre = " & intSemestreAtual
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and COD_ALUNO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & " and cod_disciplina = SCA_DISCIPLINA.Cod_Disciplina "
	sql = sql & " and cod_periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " AND ISNULL(nota"& strPosicao &" ,'0')='0') * 100.0 / Count(SCA_NOTAS_FALTAS.CODIGO)) AS PERCENTUAL_SEMLANCAMENTO "
	
	sql = sql & " FROM SCA_NOTAS_FALTAS "
	sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.Cod_Disciplina= SCA_NOTAS_FALTAS.cod_disciplina "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_NOTAS_FALTAS.cod_periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso "
	sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.CODIGO = SCA_NOTAS_FALTAS.cod_aluno_disciplina "
	sql = sql & " WHERE SCA_NOTAS_FALTAS.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and ano_letivo = " & intAnoLetivoAtual
	sql = sql & " and semestre = " & intSemestreAtual
	sql = sql & " and SCA_CURSO.Cod_curso = " & intCodCurso
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and SCA_NOTAS_FALTAS.COD_ALUNO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
		sql = sql & " and SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO = " & intCodTurma
	end if	
	sql = sql & " GROUP BY SCA_CURSO.Desc_Abreviada, SCA_PERIODO.Cod_Periodo, SCA_PERIODO.Descricao, SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina "
	sql = sql & " ORDER BY SCA_CURSO.Desc_Abreviada, SCA_PERIODO.Descricao, SCA_DISCIPLINA.Desc_Disciplina "
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  
			  <tr>
			    <td align="left" class="<%=strclasse%>"><%=rs("Desc_Abreviada")%></td>
      		    <td align="left" class="<%=strclasse%>"><%=rs("Descricao")%></td>
      		    <td colspan="4" align="left" class="<%=strclasse%>"><%=rs("Desc_Disciplina")%></td>
      		    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("TOTAIS")%></div></td>
      		    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("APROVADOS")%></div></td>
      		    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("PERCENTUAL_APROVADOS")%>%</div></td>
      		    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("REPROVADOS")%></div></td>
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("PERCENTUAL_REPROVADOS")%>%</div></td>
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("SEMLANCAMENTO")%></div></td>
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("PERCENTUAL_SEMLANCAMENTO")%>%</div></td>
			  </tr>
			<%
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
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="13" class="<%=strclasse%>" align="center"><p>&nbsp;</p>
			  <p><br>
			        <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
		  </tr>
		<%
	end if
	rs.close

	strMatriculaInicial = 0 
	strMatriculaAposMaio = 0 
	strMatriculaTotal = 0 
	strMatriculaIngressantes = 0

	strDataMatriculaInicial = intAnoLetivoAtual & "-05-31"


	sql = " SELECT "
	sql = sql & " S.Desc_SituacaoAluno, "
	sql = sql & " COUNT(CODIGO) TOTAL, "

	sql = sql & " (SELECT COUNT(CODIGO) "
	sql = sql & "      FROM SCA_ALUNO A "
	sql = sql & "      INNER JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO=A.COD_SITUACAOALUNO "
	sql = sql & "      WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and CODIGO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & "      AND DATAMATRICULA >= '"& strDataInicial & "'" 
	sql = sql & "      AND DATAMATRICULA <= '"& strDataMatriculaInicial & "') AS MATRICULA_INICIAL, "

	sql = sql & " (SELECT COUNT(CODIGO) "
	sql = sql & "      FROM SCA_ALUNO A "
	sql = sql & "      INNER JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO=A.COD_SITUACAOALUNO "
	sql = sql & "      WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and CODIGO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & "      AND DATAMATRICULA >= '"& strDataMatriculaInicial & "'" 
	sql = sql & "      AND DATAMATRICULA <= '"& strDataFinal & "') AS MATRICULA_POS_MAIO, "

	sql = sql & " (SELECT COUNT(CODIGO) "
	sql = sql & "      FROM SCA_ALUNO A "
	sql = sql & "      INNER JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO=A.COD_SITUACAOALUNO "
	sql = sql & "      WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and CODIGO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & "      AND DATAMATRICULA >= '"& strDataInicial & "'" 
	sql = sql & "      AND DATAMATRICULA <= '"& strDataFinal & "') AS MATRICULA_TOTAL, "
	
	sql = sql & " CONVERT(DECIMAL(5,2),(COUNT(CODIGO) * 100.0)/ "
	sql = sql & " (SELECT COUNT(CODIGO) "
	sql = sql & "      FROM SCA_ALUNO A "
	sql = sql & "      INNER JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO=A.COD_SITUACAOALUNO "
	sql = sql & "      WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and CODIGO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & "      AND DATAMATRICULA >= '"& strDataInicial & "' "
	sql = sql & "      AND DATAMATRICULA <= '"& strDataFinal & "')) AS PERCENTUAL, "
		
	sql = sql & " S.Desc_SituacaoAluno, "
	sql = sql & " COUNT(CODIGO) TOTAL, "
	sql = sql & " (SELECT COUNT(CODIGO) "
	sql = sql & "      FROM SCA_ALUNO A "
	sql = sql & "      INNER JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO=A.COD_SITUACAOALUNO "
	sql = sql & "      WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and CODIGO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & "      AND DATAINGRESSO >= '"& strDataInicial & "'" 
	sql = sql & "      AND DATAINGRESSO <= '"& strDataFinal & "') AS MATRICULAINICIAL_TOTAL "
	
	sql = sql & " FROM SCA_ALUNO A "
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO=A.COD_SITUACAOALUNO "
	sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND DATAMATRICULA >= '"& strDataInicial & "'" 
	sql = sql & " AND DATAMATRICULA <= '"& strDataFinal & "'"
	IF intCodTurma <> "" and intCodTurma <> "0" then
		sql = sql & " and CODIGO IN (" & left(vetAlunos, len(vetAlunos)-1) &")"
	end if	
	sql = sql & " GROUP BY Desc_SituacaoAluno "	
	sql = sql & " ORDER BY S.Desc_SituacaoAluno DESC"	
	rs.open sql, cnn
	if not rs.eof then
 		%>
      <tr>
        <td align="left" class="<%=strclasse%>">&nbsp;</td>
        <td colspan="3" align="left" bgcolor="#CCCCCC" class="<%=strclasse%>"><div align="center"><strong>Situa&ccedil;&otilde;es Acad&ecirc;micas</strong></div>			      <div align="center"></div></td>
        <td width="9%" align="left" bgcolor="#CCCCCC" class="<%=strclasse%>"><div align="center"><strong>Total</strong></div></td>
        <td width="10%" align="left" bgcolor="#CCCCCC" class="<%=strclasse%>"><div align="center"><strong>(%)Percentual</strong></div></td>
        <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
      </tr>
      <tr>
        <td align="left" class="<%=strclasse%>">&nbsp;</td>
        <td colspan="3" align="left" class="<%=strclasse%>">MATR&Iacute;CULA INICIAL:</td>
        <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("MATRICULA_INICIAL")%></div></td>
        <td align="left" class="<%=strclasse%>"><div align="center">----------</div></td>
        <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
      </tr>
      <tr>
        <td align="left" class="<%=strclasse%>">&nbsp;</td>
        <td colspan="3" align="left" class="<%=strclasse%>">MATR&Iacute;CULA AP&Oacute;S MAIO:</td>
        <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("MATRICULA_POS_MAIO")%></div></td>
        <td align="left" class="<%=strclasse%>"><div align="center">----------</div></td>
        <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
      </tr>
       <tr>
        <td align="left" class="<%=strclasse%>">&nbsp;</td>
        <td colspan="3" align="left" class="<%=strclasse%>">MATR&Iacute;CULA TOTAL:</td>
        <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("MATRICULA_TOTAL")%></div></td>
        <td align="left" class="<%=strclasse%>"><div align="center">----------</div></td>
        <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
      </tr>
       <%
	   totalAbandono = 0
		While not rs.eof
			
			strMatriculaIngressantes = strMatriculaIngressantes + rs("MATRICULAINICIAL_TOTAL")
			strSituacaoAluno = trim(ucase(rs("Desc_SituacaoAluno")))
			if trim(ucase(rs("Desc_SituacaoAluno"))) = "ATIVO" then 
				strMatriculaTotal = strMatriculaTotal + rs("TOTAL")
			   	strSituacaoAluno = "FREQUENTES"
			end if   

			if trim(ucase(rs("Desc_SituacaoAluno"))) <> "ATIVO" and trim(ucase(rs("Desc_SituacaoAluno"))) <> "TRANSFERIDO(A)" then 
			   totalAbandono = totalAbandono + rs("TOTAL")
			end if   
			
			%>
			  
              <tr>
                <td align="left" class="<%=strclasse%>">&nbsp;</td>
                <td colspan="3" align="left" class="<%=strclasse%>"><%=strSituacaoAluno%><div align="center"></div></td>
                <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("TOTAL")%></div></td>
                <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("PERCENTUAL")%>%</div></td>
                <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
             </tr>
			  
			<%
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
			rs.movenext
		wend
		%>
          <tr>
            <td align="left" class="<%=strclasse%>">&nbsp;</td>
            <td colspan="3" align="left" class="<%=strclasse%>"><div align="right"><strong>X = &nbsp;&nbsp;</strong></div></td>
            <td colspan="2" align="left" class="<%=strclasse%>"><div align="center"><%=int(strMatriculaTotal)+int(totalAbandono)%></div></td>
            <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
          </tr>
            <tr>
              <td height="183" colspan="13" align="left" class="<%=strclasse%>"><p>&nbsp;</p>
              <p align="center">&nbsp;</p>
              <p align="center">________________________________________________<br>
              Visto do(a) GDE</p><br><br><br></td>
            </tr>
        <%  
	else
		%>
		  <tr>
			<td colspan="13" class="<%=strclasse%>" align="center"><p>&nbsp;</p>
			  <p><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
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
