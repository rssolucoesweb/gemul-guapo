<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.Expires = -1
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%

Function HtmlAF(valor)
    If IsNull(valor) Then
        HtmlAF = ""
    Else
        HtmlAF = Server.HTMLEncode(CStr(valor))
    End If
End Function

strAcaoAF = LCase(Trim(Request.QueryString("acao")))

If strAcaoAF <> "resumo" And strAcaoAF <> "detalhes" Then
    Response.Status = "400 Bad Request"
    Response.Write "Ação inválida."
    Response.End
End If

strAnoLetivoAF = Trim("" & Session("strAnoLetivo"))

If strAnoLetivoAF = "" Or Not IsNumeric(strAnoLetivoAF) Then
    strAnoLetivoAF = Year(Date())
End If

intEmpresaAF = CLng(Session("CodEmpresa"))

'===============================================================================
' CTE BASE
'
' Regras:
'
' Educação Infantil até 5º ano:
'     DISTINCT aluno + data
'
' 6º ao 9º ano:
'     DISTINCT aluno + data + disciplina
'
' A expressão CHAVE_DISCIPLINA = 0 faz com que as séries até o 5º ano
' mantenham somente uma ocorrência por data.
'
' Para o 6º ao 9º ano, COD_DISCIPLINA passa a fazer parte da chave.
'===============================================================================

sqlBaseAF = ""

sqlBaseAF = sqlBaseAF & " WITH Matriculas AS ( "
sqlBaseAF = sqlBaseAF & "     SELECT DISTINCT "
sqlBaseAF = sqlBaseAF & "         AD.COD_ALUNO, "
sqlBaseAF = sqlBaseAF & "         AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA "
sqlBaseAF = sqlBaseAF & "     FROM SCA_ALUNO_DISCIPLINA AD "
sqlBaseAF = sqlBaseAF & "     INNER JOIN SCA_TURMA TU "
sqlBaseAF = sqlBaseAF & "         ON TU.COD_EMPRESA = AD.COD_EMPRESA "
sqlBaseAF = sqlBaseAF & "        AND TU.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO "
sqlBaseAF = sqlBaseAF & "     WHERE AD.COD_EMPRESA = " & intEmpresaAF
sqlBaseAF = sqlBaseAF & "       AND TU.ANOLETIVO = " & CLng(strAnoLetivoAF)
sqlBaseAF = sqlBaseAF & " ), "

sqlBaseAF = sqlBaseAF & " MatriculaAtual AS ( "
sqlBaseAF = sqlBaseAF & "     SELECT "
sqlBaseAF = sqlBaseAF & "         COD_ALUNO, "
sqlBaseAF = sqlBaseAF & "         COD_TURMA, "
sqlBaseAF = sqlBaseAF & "         ROW_NUMBER() OVER ( "
sqlBaseAF = sqlBaseAF & "             PARTITION BY COD_ALUNO "
sqlBaseAF = sqlBaseAF & "             ORDER BY COD_TURMA DESC "
sqlBaseAF = sqlBaseAF & "         ) AS RN "
sqlBaseAF = sqlBaseAF & "     FROM Matriculas "
sqlBaseAF = sqlBaseAF & " ), "

sqlBaseAF = sqlBaseAF & " DadosAluno AS ( "
sqlBaseAF = sqlBaseAF & "     SELECT "
sqlBaseAF = sqlBaseAF & "         A.CODIGO AS COD_ALUNO, "
sqlBaseAF = sqlBaseAF & "         A.MATRICULA, "
sqlBaseAF = sqlBaseAF & "         A.NOMEALUNO, "
sqlBaseAF = sqlBaseAF & "         TU.COD_TURMA, "
sqlBaseAF = sqlBaseAF & "         TU.NOMETURMA, "
sqlBaseAF = sqlBaseAF & "         TU.TURMAALUNO, "
sqlBaseAF = sqlBaseAF & "         P.COD_CURSO, "
sqlBaseAF = sqlBaseAF & "         P.DESCRICAO AS PERIODO, "
sqlBaseAF = sqlBaseAF & "         P.COD_PERIODO "
sqlBaseAF = sqlBaseAF & "     FROM MatriculaAtual MA "
sqlBaseAF = sqlBaseAF & "     INNER JOIN SCA_ALUNO A "
sqlBaseAF = sqlBaseAF & "         ON A.CODIGO = MA.COD_ALUNO "
sqlBaseAF = sqlBaseAF & "     INNER JOIN SCA_TURMA TU "
sqlBaseAF = sqlBaseAF & "         ON TU.COD_EMPRESA = " & intEmpresaAF
sqlBaseAF = sqlBaseAF & "        AND TU.COD_TURMA = MA.COD_TURMA "
sqlBaseAF = sqlBaseAF & "     INNER JOIN SCA_GRADECURRICULAR G "
sqlBaseAF = sqlBaseAF & "         ON G.COD_GRADECURRICULAR = TU.COD_GRADECURRICULAR "
sqlBaseAF = sqlBaseAF & "     INNER JOIN SCA_PERIODO P "
sqlBaseAF = sqlBaseAF & "         ON P.COD_PERIODO = G.COD_PERIODO "
sqlBaseAF = sqlBaseAF & "     WHERE MA.RN = 1 "
sqlBaseAF = sqlBaseAF & " ), "

sqlBaseAF = sqlBaseAF & " FaltasContagem AS ( "
sqlBaseAF = sqlBaseAF & "     SELECT DISTINCT "
sqlBaseAF = sqlBaseAF & "         F.COD_EMPRESA, "
sqlBaseAF = sqlBaseAF & "         F.ANO_LETIVO, "
sqlBaseAF = sqlBaseAF & "         F.COD_ALUNO, "
sqlBaseAF = sqlBaseAF & "         CAST(F.DATA AS DATE) AS DATA_FALTA, "
sqlBaseAF = sqlBaseAF & "         CASE "
sqlBaseAF = sqlBaseAF & "             WHEN D.COD_PERIODO BETWEEN 6 AND 9 "
sqlBaseAF = sqlBaseAF & "                 THEN ISNULL(F.COD_DISCIPLINA, 0) "
sqlBaseAF = sqlBaseAF & "             ELSE 0 "
sqlBaseAF = sqlBaseAF & "         END AS CHAVE_DISCIPLINA "
sqlBaseAF = sqlBaseAF & "     FROM SCA_FALTAS_DIARIA F "
sqlBaseAF = sqlBaseAF & "     INNER JOIN DadosAluno D "
sqlBaseAF = sqlBaseAF & "         ON D.COD_ALUNO = F.COD_ALUNO "
sqlBaseAF = sqlBaseAF & "     WHERE F.COD_EMPRESA = " & intEmpresaAF
sqlBaseAF = sqlBaseAF & "       AND F.ANO_LETIVO = " & CLng(strAnoLetivoAF)
sqlBaseAF = sqlBaseAF & " ), "

sqlBaseAF = sqlBaseAF & " Totais AS ( "
sqlBaseAF = sqlBaseAF & "     SELECT "
sqlBaseAF = sqlBaseAF & "         COD_ALUNO, "
sqlBaseAF = sqlBaseAF & "         COUNT(*) AS TOTAL_FALTAS "
sqlBaseAF = sqlBaseAF & "     FROM FaltasContagem "
sqlBaseAF = sqlBaseAF & "     GROUP BY COD_ALUNO "
sqlBaseAF = sqlBaseAF & " ), "

sqlBaseAF = sqlBaseAF & " Classificados AS ( "
sqlBaseAF = sqlBaseAF & "     SELECT "
sqlBaseAF = sqlBaseAF & "         D.COD_ALUNO, "
sqlBaseAF = sqlBaseAF & "         D.MATRICULA, "
sqlBaseAF = sqlBaseAF & "         D.NOMEALUNO, "
sqlBaseAF = sqlBaseAF & "         D.COD_TURMA, "
sqlBaseAF = sqlBaseAF & "         D.NOMETURMA, "
sqlBaseAF = sqlBaseAF & "         D.TURMAALUNO, "
sqlBaseAF = sqlBaseAF & "         D.COD_CURSO, "
sqlBaseAF = sqlBaseAF & "         D.PERIODO, "
sqlBaseAF = sqlBaseAF & "         D.COD_PERIODO, "
sqlBaseAF = sqlBaseAF & "         T.TOTAL_FALTAS, "
sqlBaseAF = sqlBaseAF & "         CASE "
sqlBaseAF = sqlBaseAF & "             WHEN D.COD_CURSO = 1 "
sqlBaseAF = sqlBaseAF & "              AND T.TOTAL_FALTAS > 80 "
sqlBaseAF = sqlBaseAF & "                 THEN 'VERMELHO' "
sqlBaseAF = sqlBaseAF & "             WHEN D.COD_CURSO <> 1 "
sqlBaseAF = sqlBaseAF & "              AND D.COD_PERIODO BETWEEN 1 AND 5 "
sqlBaseAF = sqlBaseAF & "              AND T.TOTAL_FALTAS > 50 "
sqlBaseAF = sqlBaseAF & "                 THEN 'VERMELHO' "
sqlBaseAF = sqlBaseAF & "             WHEN D.COD_CURSO <> 1 "
sqlBaseAF = sqlBaseAF & "              AND D.COD_PERIODO BETWEEN 6 AND 9 "
sqlBaseAF = sqlBaseAF & "              AND T.TOTAL_FALTAS > 250 "
sqlBaseAF = sqlBaseAF & "                 THEN 'VERMELHO' "
sqlBaseAF = sqlBaseAF & "             WHEN D.COD_CURSO = 1 "
sqlBaseAF = sqlBaseAF & "              AND T.TOTAL_FALTAS BETWEEN 24 AND 80 "
sqlBaseAF = sqlBaseAF & "                 THEN 'AMARELO' "
sqlBaseAF = sqlBaseAF & "             WHEN D.COD_CURSO <> 1 "
sqlBaseAF = sqlBaseAF & "              AND D.COD_PERIODO BETWEEN 1 AND 5 "
sqlBaseAF = sqlBaseAF & "              AND T.TOTAL_FALTAS BETWEEN 15 AND 50 "
sqlBaseAF = sqlBaseAF & "                 THEN 'AMARELO' "
sqlBaseAF = sqlBaseAF & "             WHEN D.COD_CURSO <> 1 "
sqlBaseAF = sqlBaseAF & "              AND D.COD_PERIODO BETWEEN 6 AND 9 "
sqlBaseAF = sqlBaseAF & "              AND T.TOTAL_FALTAS BETWEEN 75 AND 250 "
sqlBaseAF = sqlBaseAF & "                 THEN 'AMARELO' "
sqlBaseAF = sqlBaseAF & "             ELSE '' "
sqlBaseAF = sqlBaseAF & "         END AS SITUACAO_ALERTA "
sqlBaseAF = sqlBaseAF & "     FROM DadosAluno D "
sqlBaseAF = sqlBaseAF & "     INNER JOIN Totais T "
sqlBaseAF = sqlBaseAF & "         ON T.COD_ALUNO = D.COD_ALUNO "
sqlBaseAF = sqlBaseAF & " ) "

'===============================================================================
' RESUMO
'
' Importante:
' não consulta justificativas e não retorna os alunos.
' Apenas contabiliza as situações.
'===============================================================================

If strAcaoAF = "resumo" Then

    Response.ContentType = "application/json"

    sqlAF = sqlBaseAF
    sqlAF = sqlAF & " SELECT "
    sqlAF = sqlAF & "     SUM(CASE WHEN SITUACAO_ALERTA = 'VERMELHO' THEN 1 ELSE 0 END) AS QTD_VERMELHO, "
    sqlAF = sqlAF & "     SUM(CASE WHEN SITUACAO_ALERTA = 'AMARELO' THEN 1 ELSE 0 END) AS QTD_AMARELO "
    sqlAF = sqlAF & " FROM Classificados "
    sqlAF = sqlAF & " WHERE SITUACAO_ALERTA IN ('VERMELHO', 'AMARELO') "

    Set rsAF = Server.CreateObject("ADODB.Recordset")
    rsAF.Open sqlAF, cnn

    qtdVermelhoAF = 0
    qtdAmareloAF = 0

    If Not rsAF.EOF Then
        If Not IsNull(rsAF("QTD_VERMELHO")) Then qtdVermelhoAF = CLng(rsAF("QTD_VERMELHO"))
        If Not IsNull(rsAF("QTD_AMARELO")) Then qtdAmareloAF = CLng(rsAF("QTD_AMARELO"))
    End If

    rsAF.Close
    Set rsAF = Nothing

    Response.Write "{"
    Response.Write """vermelho"":" & qtdVermelhoAF & ","
    Response.Write """amarelo"":" & qtdAmareloAF
    Response.Write "}"

    Response.End

End If

'===============================================================================
' DETALHES - VERSÃO COM TABELAS TEMPORÁRIAS
'
' Motivo:
'   A CTE FaltasContagem era reutilizada várias vezes no mesmo SELECT.
'   No SQL Server, CTE não é materializada; portanto o otimizador podia reler
'   SCA_FALTAS_DIARIA diversas vezes e estourar o timeout.
'
' Nesta versão:
'   1. materializamos os alunos atuais em #DadosAluno;
'   2. materializamos as faltas já deduplicadas em #FaltasContagem;
'   3. calculamos #AlunosAlerta somente uma vez;
'   4. normalizamos SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA em #Justificativas;
'   5. calculamos a situação mais recente somente dos alunos em alerta.
'
' Regras mantidas:
'   - até 5º ano: 1 falta por aluno/data;
'   - 6º ao 9º: 1 falta por aluno/data/disciplina.
'===============================================================================

sqlAF = " SET NOCOUNT ON; "

'------------------------------------------------------------------------------
' Limpeza defensiva das temporárias da mesma conexão.
'------------------------------------------------------------------------------
sqlAF = sqlAF & " IF OBJECT_ID('tempdb..#DadosAluno') IS NOT NULL DROP TABLE #DadosAluno; "
sqlAF = sqlAF & " IF OBJECT_ID('tempdb..#FaltasContagem') IS NOT NULL DROP TABLE #FaltasContagem; "
sqlAF = sqlAF & " IF OBJECT_ID('tempdb..#AlunosAlerta') IS NOT NULL DROP TABLE #AlunosAlerta; "
sqlAF = sqlAF & " IF OBJECT_ID('tempdb..#Justificativas') IS NOT NULL DROP TABLE #Justificativas; "

'------------------------------------------------------------------------------
' 1) Aluno + turma atual.
'------------------------------------------------------------------------------
sqlAF = sqlAF & " ;WITH Matriculas AS ( "
sqlAF = sqlAF & "     SELECT DISTINCT "
sqlAF = sqlAF & "         AD.COD_ALUNO, "
sqlAF = sqlAF & "         AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA "
sqlAF = sqlAF & "     FROM SCA_ALUNO_DISCIPLINA AD "
sqlAF = sqlAF & "     INNER JOIN SCA_TURMA TU "
sqlAF = sqlAF & "         ON TU.COD_EMPRESA = AD.COD_EMPRESA "
sqlAF = sqlAF & "        AND TU.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO "
sqlAF = sqlAF & "     WHERE AD.COD_EMPRESA = " & intEmpresaAF
sqlAF = sqlAF & "       AND TU.ANOLETIVO = " & CLng(strAnoLetivoAF)
sqlAF = sqlAF & " ), "
sqlAF = sqlAF & " MatriculaAtual AS ( "
sqlAF = sqlAF & "     SELECT "
sqlAF = sqlAF & "         COD_ALUNO, COD_TURMA, "
sqlAF = sqlAF & "         ROW_NUMBER() OVER (PARTITION BY COD_ALUNO ORDER BY COD_TURMA DESC) AS RN "
sqlAF = sqlAF & "     FROM Matriculas "
sqlAF = sqlAF & " ) "
sqlAF = sqlAF & " SELECT "
sqlAF = sqlAF & "     A.CODIGO AS COD_ALUNO, "
sqlAF = sqlAF & "     A.MATRICULA, "
sqlAF = sqlAF & "     A.NOMEALUNO, "
sqlAF = sqlAF & "     TU.COD_TURMA, "
sqlAF = sqlAF & "     TU.NOMETURMA, "
sqlAF = sqlAF & "     TU.TURMAALUNO, "
sqlAF = sqlAF & "     P.COD_CURSO, "
sqlAF = sqlAF & "     P.DESCRICAO AS PERIODO, "
sqlAF = sqlAF & "     P.COD_PERIODO "
sqlAF = sqlAF & " INTO #DadosAluno "
sqlAF = sqlAF & " FROM MatriculaAtual MA "
sqlAF = sqlAF & " INNER JOIN SCA_ALUNO A "
sqlAF = sqlAF & "     ON A.CODIGO = MA.COD_ALUNO "
sqlAF = sqlAF & " INNER JOIN SCA_TURMA TU "
sqlAF = sqlAF & "     ON TU.COD_EMPRESA = " & intEmpresaAF
sqlAF = sqlAF & "    AND TU.COD_TURMA = MA.COD_TURMA "
sqlAF = sqlAF & " INNER JOIN SCA_GRADECURRICULAR G "
sqlAF = sqlAF & "     ON G.COD_GRADECURRICULAR = TU.COD_GRADECURRICULAR "
sqlAF = sqlAF & " INNER JOIN SCA_PERIODO P "
sqlAF = sqlAF & "     ON P.COD_PERIODO = G.COD_PERIODO "
sqlAF = sqlAF & " WHERE MA.RN = 1; "

sqlAF = sqlAF & " CREATE UNIQUE CLUSTERED INDEX IX_TMP_DadosAluno "
sqlAF = sqlAF & " ON #DadosAluno(COD_ALUNO); "

'------------------------------------------------------------------------------
' 2) Faltas materializadas e deduplicadas.
'------------------------------------------------------------------------------
sqlAF = sqlAF & " SELECT "
sqlAF = sqlAF & "     F.COD_ALUNO, "
sqlAF = sqlAF & "     CAST(F.DATA AS DATE) AS DATA_FALTA, "
sqlAF = sqlAF & "     CASE "
sqlAF = sqlAF & "         WHEN D.COD_PERIODO BETWEEN 6 AND 9 "
sqlAF = sqlAF & "             THEN ISNULL(F.COD_DISCIPLINA, 0) "
sqlAF = sqlAF & "         ELSE 0 "
sqlAF = sqlAF & "     END AS CHAVE_DISCIPLINA "
sqlAF = sqlAF & " INTO #FaltasContagem "
sqlAF = sqlAF & " FROM SCA_FALTAS_DIARIA F "
sqlAF = sqlAF & " INNER JOIN #DadosAluno D "
sqlAF = sqlAF & "     ON D.COD_ALUNO = F.COD_ALUNO "
sqlAF = sqlAF & " WHERE F.COD_EMPRESA = " & intEmpresaAF
sqlAF = sqlAF & "   AND F.ANO_LETIVO = " & CLng(strAnoLetivoAF)
sqlAF = sqlAF & " GROUP BY "
sqlAF = sqlAF & "     F.COD_ALUNO, "
sqlAF = sqlAF & "     CAST(F.DATA AS DATE), "
sqlAF = sqlAF & "     CASE "
sqlAF = sqlAF & "         WHEN D.COD_PERIODO BETWEEN 6 AND 9 "
sqlAF = sqlAF & "             THEN ISNULL(F.COD_DISCIPLINA, 0) "
sqlAF = sqlAF & "         ELSE 0 "
sqlAF = sqlAF & "     END; "

sqlAF = sqlAF & " CREATE UNIQUE CLUSTERED INDEX IX_TMP_FaltasContagem "
sqlAF = sqlAF & " ON #FaltasContagem(COD_ALUNO, DATA_FALTA, CHAVE_DISCIPLINA); "

'------------------------------------------------------------------------------
' 3) Classifica somente uma vez os alunos que realmente entram no alerta.
'------------------------------------------------------------------------------
sqlAF = sqlAF & " ;WITH Totais AS ( "
sqlAF = sqlAF & "     SELECT COD_ALUNO, COUNT(*) AS TOTAL_FALTAS "
sqlAF = sqlAF & "     FROM #FaltasContagem "
sqlAF = sqlAF & "     GROUP BY COD_ALUNO "
sqlAF = sqlAF & " ), Classificados AS ( "
sqlAF = sqlAF & "     SELECT "
sqlAF = sqlAF & "         D.COD_ALUNO, D.MATRICULA, D.NOMEALUNO, "
sqlAF = sqlAF & "         D.COD_TURMA, D.NOMETURMA, D.TURMAALUNO, "
sqlAF = sqlAF & "         D.COD_CURSO, D.PERIODO, D.COD_PERIODO, "
sqlAF = sqlAF & "         T.TOTAL_FALTAS, "
sqlAF = sqlAF & "         CASE "
sqlAF = sqlAF & "             WHEN D.COD_CURSO = 1 "
sqlAF = sqlAF & "              AND T.TOTAL_FALTAS > 80 THEN 'VERMELHO' "
sqlAF = sqlAF & "             WHEN D.COD_CURSO <> 1 "
sqlAF = sqlAF & "              AND D.COD_PERIODO BETWEEN 1 AND 5 "
sqlAF = sqlAF & "              AND T.TOTAL_FALTAS > 50 THEN 'VERMELHO' "
sqlAF = sqlAF & "             WHEN D.COD_CURSO <> 1 "
sqlAF = sqlAF & "              AND D.COD_PERIODO BETWEEN 6 AND 9 "
sqlAF = sqlAF & "              AND T.TOTAL_FALTAS > 250 THEN 'VERMELHO' "
sqlAF = sqlAF & "             WHEN D.COD_CURSO = 1 "
sqlAF = sqlAF & "              AND T.TOTAL_FALTAS BETWEEN 24 AND 80 THEN 'AMARELO' "
sqlAF = sqlAF & "             WHEN D.COD_CURSO <> 1 "
sqlAF = sqlAF & "              AND D.COD_PERIODO BETWEEN 1 AND 5 "
sqlAF = sqlAF & "              AND T.TOTAL_FALTAS BETWEEN 15 AND 50 THEN 'AMARELO' "
sqlAF = sqlAF & "             WHEN D.COD_CURSO <> 1 "
sqlAF = sqlAF & "              AND D.COD_PERIODO BETWEEN 6 AND 9 "
sqlAF = sqlAF & "              AND T.TOTAL_FALTAS BETWEEN 75 AND 250 THEN 'AMARELO' "
sqlAF = sqlAF & "             ELSE '' "
sqlAF = sqlAF & "         END AS SITUACAO_ALERTA "
sqlAF = sqlAF & "     FROM #DadosAluno D "
sqlAF = sqlAF & "     INNER JOIN Totais T ON T.COD_ALUNO = D.COD_ALUNO "
sqlAF = sqlAF & " ) "
sqlAF = sqlAF & " SELECT * "
sqlAF = sqlAF & " INTO #AlunosAlerta "
sqlAF = sqlAF & " FROM Classificados "
sqlAF = sqlAF & " WHERE SITUACAO_ALERTA IN ('VERMELHO', 'AMARELO'); "

sqlAF = sqlAF & " CREATE UNIQUE CLUSTERED INDEX IX_TMP_AlunosAlerta "
sqlAF = sqlAF & " ON #AlunosAlerta(COD_ALUNO); "

'------------------------------------------------------------------------------
' 4) Justificativas diárias.
'
' Filtra primeiro pelos alunos em alerta e normaliza a chave:
' até o 5º = aluno/data; 6º ao 9º = aluno/data/disciplina.
'------------------------------------------------------------------------------
sqlAF = sqlAF & " SELECT DISTINCT "
sqlAF = sqlAF & "     J.COD_ALUNO, "
sqlAF = sqlAF & "     J.DATAFALTA, "
sqlAF = sqlAF & "     CASE "
sqlAF = sqlAF & "         WHEN A.COD_PERIODO BETWEEN 6 AND 9 "
sqlAF = sqlAF & "             THEN ISNULL(J.COD_DISCIPLINA, 0) "
sqlAF = sqlAF & "         ELSE 0 "
sqlAF = sqlAF & "     END AS CHAVE_DISCIPLINA "
sqlAF = sqlAF & " INTO #Justificativas "
sqlAF = sqlAF & " FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA J "
sqlAF = sqlAF & " INNER JOIN #AlunosAlerta A "
sqlAF = sqlAF & "     ON A.COD_ALUNO = J.COD_ALUNO; "

sqlAF = sqlAF & " CREATE UNIQUE CLUSTERED INDEX IX_TMP_Justificativas "
sqlAF = sqlAF & " ON #Justificativas(COD_ALUNO, DATAFALTA, CHAVE_DISCIPLINA); "

'------------------------------------------------------------------------------
' 5) Resultado final.
'------------------------------------------------------------------------------
sqlAF = sqlAF & " ;WITH Justificadas AS ( "
sqlAF = sqlAF & "     SELECT "
sqlAF = sqlAF & "         F.COD_ALUNO, "
sqlAF = sqlAF & "         COUNT(*) AS FALTAS_JUSTIFICADAS "
sqlAF = sqlAF & "     FROM #FaltasContagem F "
sqlAF = sqlAF & "     INNER JOIN #Justificativas J "
sqlAF = sqlAF & "         ON J.COD_ALUNO = F.COD_ALUNO "
sqlAF = sqlAF & "        AND J.DATAFALTA = F.DATA_FALTA "
sqlAF = sqlAF & "        AND J.CHAVE_DISCIPLINA = F.CHAVE_DISCIPLINA "
sqlAF = sqlAF & "     GROUP BY F.COD_ALUNO "
sqlAF = sqlAF & " ), SituacaoAtual AS ( "
sqlAF = sqlAF & "     SELECT "
sqlAF = sqlAF & "         CS.COD_ALUNO, "
sqlAF = sqlAF & "         SS.DESC_SITUACAOALUNO, "
sqlAF = sqlAF & "         CS.DATA_SITUACAO, "
sqlAF = sqlAF & "         ROW_NUMBER() OVER ( "
sqlAF = sqlAF & "             PARTITION BY CS.COD_ALUNO "
sqlAF = sqlAF & "             ORDER BY CS.CODIGO DESC "
sqlAF = sqlAF & "         ) AS RN "
sqlAF = sqlAF & "     FROM SCA_CONTROLE_SITUACAO_ALUNO CS "
sqlAF = sqlAF & "     INNER JOIN #AlunosAlerta A "
sqlAF = sqlAF & "         ON A.COD_ALUNO = CS.COD_ALUNO "
sqlAF = sqlAF & "     INNER JOIN SCA_SITUACAOALUNO SS "
sqlAF = sqlAF & "         ON SS.COD_SITUACAOALUNO = CS.COD_SITUACAOALUNO "
sqlAF = sqlAF & "     WHERE CS.COD_EMPRESA = " & intEmpresaAF
sqlAF = sqlAF & "       AND CS.ANO_LETIVO = " & CLng(strAnoLetivoAF)
sqlAF = sqlAF & " ) "
sqlAF = sqlAF & " SELECT "
sqlAF = sqlAF & "     A.COD_ALUNO, "
sqlAF = sqlAF & "     A.MATRICULA, "
sqlAF = sqlAF & "     A.NOMEALUNO, "
sqlAF = sqlAF & "     A.COD_TURMA, "
sqlAF = sqlAF & "     A.NOMETURMA, "
sqlAF = sqlAF & "     A.TURMAALUNO, "
sqlAF = sqlAF & "     A.PERIODO, "
sqlAF = sqlAF & "     A.COD_PERIODO, "
sqlAF = sqlAF & "     A.TOTAL_FALTAS, "
sqlAF = sqlAF & "     A.SITUACAO_ALERTA, "
sqlAF = sqlAF & "     ISNULL(J.FALTAS_JUSTIFICADAS, 0) AS FALTAS_JUSTIFICADAS, "
sqlAF = sqlAF & "     S.DESC_SITUACAOALUNO AS SITUACAO_ALUNO, "
sqlAF = sqlAF & "     S.DATA_SITUACAO "
sqlAF = sqlAF & " FROM #AlunosAlerta A "
sqlAF = sqlAF & " LEFT JOIN Justificadas J "
sqlAF = sqlAF & "     ON J.COD_ALUNO = A.COD_ALUNO "
sqlAF = sqlAF & " LEFT JOIN SituacaoAtual S "
sqlAF = sqlAF & "     ON S.COD_ALUNO = A.COD_ALUNO "
sqlAF = sqlAF & "    AND S.RN = 1 "
sqlAF = sqlAF & " ORDER BY "
sqlAF = sqlAF & "     CASE WHEN A.SITUACAO_ALERTA = 'VERMELHO' THEN 1 ELSE 2 END, "
sqlAF = sqlAF & "     A.NOMEALUNO; "

Set rsAF = Server.CreateObject("ADODB.Recordset")
rsAF.CursorLocation = 3
rsAF.Open sqlAF, cnn, 0, 1

If rsAF.EOF Then
%>

<div class="alert alert-success mb-0">
    <i class="fal fa-check-circle mr-2"></i>
    Nenhum aluno com alerta de frequência no ano letivo
    <strong><%=HtmlAF(strAnoLetivoAF)%></strong>.
</div>

<%
    rsAF.Close
    Set rsAF = Nothing
    Response.End
End If

vetAF = rsAF.GetRows()

idxCodAlunoAF = -1
idxMatriculaAF = -1
idxNomeAF = -1
idxCodTurmaAF = -1
idxNomeTurmaAF = -1
idxTurmaAlunoAF = -1
idxPeriodoAF = -1
idxTotalAF = -1
idxJustificadasAF = -1
idxSituacaoAF = -1
idxSituacaoAlunoAF = -1
idxDataSituacaoAF = -1

For iAF = 0 To rsAF.Fields.Count - 1

    Select Case UCase(rsAF.Fields(iAF).Name)

        Case "COD_ALUNO"
            idxCodAlunoAF = iAF

        Case "MATRICULA"
            idxMatriculaAF = iAF

        Case "NOMEALUNO"
            idxNomeAF = iAF

        Case "COD_TURMA"
            idxCodTurmaAF = iAF

        Case "NOMETURMA"
            idxNomeTurmaAF = iAF

        Case "TURMAALUNO"
            idxTurmaAlunoAF = iAF

        Case "PERIODO"
            idxPeriodoAF = iAF

        Case "TOTAL_FALTAS"
            idxTotalAF = iAF

        Case "FALTAS_JUSTIFICADAS"
            idxJustificadasAF = iAF

        Case "SITUACAO_ALERTA"
            idxSituacaoAF = iAF

        Case "SITUACAO_ALUNO"
            idxSituacaoAlunoAF = iAF

        Case "DATA_SITUACAO"
            idxDataSituacaoAF = iAF

    End Select

Next

rsAF.Close
Set rsAF = Nothing

qtdVermelhoDetalheAF = 0
qtdAmareloDetalheAF = 0

For iAF = 0 To UBound(vetAF, 2)

    If UCase(Trim("" & vetAF(idxSituacaoAF, iAF))) = "VERMELHO" Then
        qtdVermelhoDetalheAF = qtdVermelhoDetalheAF + 1
    ElseIf UCase(Trim("" & vetAF(idxSituacaoAF, iAF))) = "AMARELO" Then
        qtdAmareloDetalheAF = qtdAmareloDetalheAF + 1
    End If

Next
%>

<div id="accordionDetalheFrequencia">

    <div class="card mb-2">

        <div class="card-header bg-danger-50"
             id="headingDetalheVermelho"
             style="cursor:pointer;"
             data-toggle="collapse"
             data-target="#collapseDetalheVermelho">

            <div class="d-flex align-items-center">
                <div class="flex-1">
                    <strong class="text-danger">
                        <i class="fal fa-user-times mr-2"></i>
                        Vermelho - Limite excedido
                    </strong>
                </div>

                <span class="badge badge-danger"><%=qtdVermelhoDetalheAF%></span>
                <i class="fal fa-chevron-down ml-3"></i>
            </div>
        </div>

        <div id="collapseDetalheVermelho"
             class="collapse"
             data-parent="#accordionDetalheFrequencia">

            <div class="card-body p-0">

                <% If qtdVermelhoDetalheAF = 0 Then %>

                    <div class="alert alert-success m-3">
                        Nenhum aluno com limite excedido.
                    </div>

                <% Else %>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover table-sm mb-0">

                            <thead class="thead-light">
                                <tr>
                                    <th width="120">Matrícula</th>
                                    <th>Aluno</th>
                                    <th width="220">Série / Turma</th>
                                    <th width="90" class="text-center">Faltas</th>
                                    <th width="110" class="text-center">Justificadas</th>
                                    <th width="80" class="text-center">Ação</th>
                                </tr>
                            </thead>

                            <tbody>

                            <%
                            For iAF = 0 To UBound(vetAF, 2)

                                If UCase(Trim("" & vetAF(idxSituacaoAF, iAF))) = "VERMELHO" Then

                                    strSerieTurmaAF = Trim("" & vetAF(idxPeriodoAF, iAF))

                                    If Trim("" & vetAF(idxTurmaAlunoAF, iAF)) <> "" Then
                                        If strSerieTurmaAF <> "" Then strSerieTurmaAF = strSerieTurmaAF & " - "
                                        strSerieTurmaAF = strSerieTurmaAF & Trim("" & vetAF(idxTurmaAlunoAF, iAF))
                                    End If

                                    If Trim("" & vetAF(idxNomeTurmaAF, iAF)) <> "" Then
                                        If strSerieTurmaAF <> "" Then strSerieTurmaAF = strSerieTurmaAF & " - "
                                        strSerieTurmaAF = strSerieTurmaAF & Trim("" & vetAF(idxNomeTurmaAF, iAF))
                                    End If
                            %>

                                <tr>
                                    <td><%=HtmlAF(vetAF(idxMatriculaAF, iAF))%></td>
                                    <td>
                                        <strong><%=HtmlAF(vetAF(idxNomeAF, iAF))%></strong>
                                        <%
                                        strSituacaoAlunoAF = Trim("" & vetAF(idxSituacaoAlunoAF, iAF))

                                        If strSituacaoAlunoAF <> "" And UCase(strSituacaoAlunoAF) <> "ATIVO" Then
                                        %>
                                            <span class="text-muted ml-1">
                                                - <%=HtmlAF(strSituacaoAlunoAF)%>
                                                <% If Not IsNull(vetAF(idxDataSituacaoAF, iAF)) And Trim("" & vetAF(idxDataSituacaoAF, iAF)) <> "" Then %>
                                                    em <%=Right("0" & Day(vetAF(idxDataSituacaoAF, iAF)), 2)%>/<%=Right("0" & Month(vetAF(idxDataSituacaoAF, iAF)), 2)%>/<%=Year(vetAF(idxDataSituacaoAF, iAF))%>
                                                <% End If %>
                                            </span>
                                        <% End If %>
                                    </td>
                                    <td><%=HtmlAF(strSerieTurmaAF)%></td>

                                    <td class="text-center">
                                        <span class="badge badge-danger">
                                            <%=CLng(vetAF(idxTotalAF, iAF))%>
                                        </span>
                                    </td>

                                    <td class="text-center">
                                        <%=CLng(vetAF(idxJustificadasAF, iAF))%>
                                    </td>

                                    <td class="text-center">
                                        <a href="sca_alerta_faltasCon.asp?txtAnoLetivo=<%=Server.URLEncode(strAnoLetivoAF)%>&cmbTurma=<%=CLng(vetAF(idxCodTurmaAF, iAF))%>"
                                           class="btn btn-xs btn-outline-primary"
                                           title="Abrir alerta de faltas">
                                            <i class="fal fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>

                            <%
                                End If

                            Next
                            %>

                            </tbody>
                        </table>
                    </div>

                <% End If %>

            </div>
        </div>
    </div>

    <div class="card">

        <div class="card-header bg-warning-50"
             id="headingDetalheAmarelo"
             style="cursor:pointer;"
             data-toggle="collapse"
             data-target="#collapseDetalheAmarelo">

            <div class="d-flex align-items-center">
                <div class="flex-1">
                    <strong class="text-warning">
                        <i class="fal fa-exclamation-circle mr-2"></i>
                        Amarelo - Faixa de alerta
                    </strong>
                </div>

                <span class="badge badge-warning"><%=qtdAmareloDetalheAF%></span>
                <i class="fal fa-chevron-down ml-3"></i>
            </div>
        </div>

        <div id="collapseDetalheAmarelo"
             class="collapse"
             data-parent="#accordionDetalheFrequencia">

            <div class="card-body p-0">

                <% If qtdAmareloDetalheAF = 0 Then %>

                    <div class="alert alert-success m-3">
                        Nenhum aluno na faixa amarela.
                    </div>

                <% Else %>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover table-sm mb-0">

                            <thead class="thead-light">
                                <tr>
                                    <th width="120">Matrícula</th>
                                    <th>Aluno</th>
                                    <th width="220">Série / Turma</th>
                                    <th width="90" class="text-center">Faltas</th>
                                    <th width="110" class="text-center">Justificadas</th>
                                    <th width="80" class="text-center">Ação</th>
                                </tr>
                            </thead>

                            <tbody>

                            <%
                            For iAF = 0 To UBound(vetAF, 2)

                                If UCase(Trim("" & vetAF(idxSituacaoAF, iAF))) = "AMARELO" Then

                                    strSerieTurmaAF = Trim("" & vetAF(idxPeriodoAF, iAF))

                                    If Trim("" & vetAF(idxTurmaAlunoAF, iAF)) <> "" Then
                                        If strSerieTurmaAF <> "" Then strSerieTurmaAF = strSerieTurmaAF & " - "
                                        strSerieTurmaAF = strSerieTurmaAF & Trim("" & vetAF(idxTurmaAlunoAF, iAF))
                                    End If

                                    If Trim("" & vetAF(idxNomeTurmaAF, iAF)) <> "" Then
                                        If strSerieTurmaAF <> "" Then strSerieTurmaAF = strSerieTurmaAF & " - "
                                        strSerieTurmaAF = strSerieTurmaAF & Trim("" & vetAF(idxNomeTurmaAF, iAF))
                                    End If
                            %>

                                <tr>
                                    <td><%=HtmlAF(vetAF(idxMatriculaAF, iAF))%></td>
                                    <td>
                                        <strong><%=HtmlAF(vetAF(idxNomeAF, iAF))%></strong>
                                        <%
                                        strSituacaoAlunoAF = Trim("" & vetAF(idxSituacaoAlunoAF, iAF))

                                        If strSituacaoAlunoAF <> "" And UCase(strSituacaoAlunoAF) <> "ATIVO" Then
                                        %>
                                            <span class="text-muted ml-1">
                                                - <%=HtmlAF(strSituacaoAlunoAF)%>
                                                <% If Not IsNull(vetAF(idxDataSituacaoAF, iAF)) And Trim("" & vetAF(idxDataSituacaoAF, iAF)) <> "" Then %>
                                                    em <%=Right("0" & Day(vetAF(idxDataSituacaoAF, iAF)), 2)%>/<%=Right("0" & Month(vetAF(idxDataSituacaoAF, iAF)), 2)%>/<%=Year(vetAF(idxDataSituacaoAF, iAF))%>
                                                <% End If %>
                                            </span>
                                        <% End If %>
                                    </td>
                                    <td><%=HtmlAF(strSerieTurmaAF)%></td>

                                    <td class="text-center">
                                        <span class="badge badge-warning">
                                            <%=CLng(vetAF(idxTotalAF, iAF))%>
                                        </span>
                                    </td>

                                    <td class="text-center">
                                        <%=CLng(vetAF(idxJustificadasAF, iAF))%>
                                    </td>

                                    <td class="text-center">
                                        <a href="sca_alerta_faltasCon.asp?txtAnoLetivo=<%=Server.URLEncode(strAnoLetivoAF)%>&cmbTurma=<%=CLng(vetAF(idxCodTurmaAF, iAF))%>"
                                           class="btn btn-xs btn-outline-primary"
                                           title="Abrir alerta de faltas">
                                            <i class="fal fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>

                            <%
                                End If

                            Next
                            %>

                            </tbody>
                        </table>
                    </div>

                <% End If %>

            </div>
        </div>
    </div>

</div>
