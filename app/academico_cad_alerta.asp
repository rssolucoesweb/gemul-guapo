<%
'===============================================================================
' ALERTA DE FREQUÊNCIA - INÍCIO DO MÓDULO ACADÊMICO
'
' Regras de contagem:
' - Educação Infantil e 1º ao 5º ano:
'     uma falta por aluno/data.
' - 6º ao 9º ano:
'     uma falta por aluno/data/disciplina.
'
' Alertas exibidos:
' - VERMELHO: somente alunos reprovados por faltas
'     3º ao 5º: > 50
'     6º ao 9º: > 250
' - AMARELO:
'     Educação Infantil: 24 a 80
'     1º ao 5º: 15 a 50
'     6º ao 9º: 75 a 250
'===============================================================================

Function HtmlAlerta(valor)
    If IsNull(valor) Then
        HtmlAlerta = ""
    Else
        HtmlAlerta = Server.HTMLEncode(CStr(valor))
    End If
End Function

strAnoLetivoAlerta = Trim("" & Session("strAnoLetivo"))
If strAnoLetivoAlerta = "" Or Not IsNumeric(strAnoLetivoAlerta) Then
    strAnoLetivoAlerta = Year(Date())
End If

intEmpresaAlerta = CLng(Session("CodEmpresa"))

Set dicQtdAlerta = Server.CreateObject("Scripting.Dictionary")
dicQtdAlerta("VERMELHO") = 0
dicQtdAlerta("AMARELO") = 0

bolTemAlertaFrequencia = False

sqlAlertaFrequencia = ""
sqlAlertaFrequencia = sqlAlertaFrequencia & " WITH Matriculas AS ( "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     SELECT DISTINCT AD.COD_ALUNO, AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     FROM SCA_ALUNO_DISCIPLINA AD "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     INNER JOIN SCA_TURMA TU "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         ON TU.COD_EMPRESA = AD.COD_EMPRESA "
sqlAlertaFrequencia = sqlAlertaFrequencia & "        AND TU.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     WHERE AD.COD_EMPRESA = " & intEmpresaAlerta
sqlAlertaFrequencia = sqlAlertaFrequencia & "       AND TU.ANOLETIVO = " & CLng(strAnoLetivoAlerta)
sqlAlertaFrequencia = sqlAlertaFrequencia & " ), "
sqlAlertaFrequencia = sqlAlertaFrequencia & " MatriculaAtual AS ( "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     SELECT COD_ALUNO, COD_TURMA, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "            ROW_NUMBER() OVER (PARTITION BY COD_ALUNO ORDER BY COD_TURMA DESC) AS RN "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     FROM Matriculas "
sqlAlertaFrequencia = sqlAlertaFrequencia & " ), "
sqlAlertaFrequencia = sqlAlertaFrequencia & " DadosAluno AS ( "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     SELECT "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         A.CODIGO AS COD_ALUNO, A.MATRICULA, A.NOMEALUNO, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         TU.COD_TURMA, TU.NOMETURMA, TU.TURMAALUNO, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         P.COD_CURSO, P.DESCRICAO AS PERIODO, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         CASE "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN ISNULL(TU.ANO,0) BETWEEN 1 AND 9 THEN TU.ANO "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '1%' THEN 1 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '2%' THEN 2 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '3%' THEN 3 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '4%' THEN 4 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '5%' THEN 5 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '6%' THEN 6 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '7%' THEN 7 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '8%' THEN 8 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN LTRIM(P.DESCRICAO) LIKE '9%' THEN 9 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             ELSE 0 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         END AS ANO_SERIE "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     FROM MatriculaAtual MA "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     INNER JOIN SCA_ALUNO A ON A.CODIGO = MA.COD_ALUNO "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     INNER JOIN SCA_TURMA TU "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         ON TU.COD_EMPRESA = " & intEmpresaAlerta
sqlAlertaFrequencia = sqlAlertaFrequencia & "        AND TU.COD_TURMA = MA.COD_TURMA "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     INNER JOIN SCA_GRADECURRICULAR G "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         ON G.COD_GRADECURRICULAR = TU.COD_GRADECURRICULAR "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     INNER JOIN SCA_PERIODO P "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         ON P.COD_PERIODO = G.COD_PERIODO "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     WHERE MA.RN = 1 "
sqlAlertaFrequencia = sqlAlertaFrequencia & " ), "
sqlAlertaFrequencia = sqlAlertaFrequencia & " FaltasContagem AS ( "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     SELECT DISTINCT "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         F.COD_EMPRESA, F.ANO_LETIVO, F.COD_ALUNO, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         CAST(F.DATA AS DATE) AS DATA_FALTA, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         CASE WHEN D.ANO_SERIE BETWEEN 6 AND 9 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "              THEN ISNULL(F.COD_DISCIPLINA,0) ELSE 0 END AS CHAVE_DISCIPLINA "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     FROM SCA_FALTAS_DIARIA F "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     INNER JOIN DadosAluno D ON D.COD_ALUNO = F.COD_ALUNO "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     WHERE F.COD_EMPRESA = " & intEmpresaAlerta
sqlAlertaFrequencia = sqlAlertaFrequencia & "       AND F.ANO_LETIVO = " & CLng(strAnoLetivoAlerta)
sqlAlertaFrequencia = sqlAlertaFrequencia & " ), "
sqlAlertaFrequencia = sqlAlertaFrequencia & " Totais AS ( "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     SELECT "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         F.COD_ALUNO, COUNT(*) AS TOTAL_FALTAS, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         SUM(CASE WHEN JF.JUSTIFICADA = 1 THEN 1 ELSE 0 END) AS FALTAS_JUSTIFICADAS "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     FROM FaltasContagem F "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     OUTER APPLY ( "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         SELECT TOP (1) 1 AS JUSTIFICADA "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS J "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         WHERE J.COD_EMPRESA = F.COD_EMPRESA "
sqlAlertaFrequencia = sqlAlertaFrequencia & "           AND J.COD_ALUNO = F.COD_ALUNO "
sqlAlertaFrequencia = sqlAlertaFrequencia & "           AND J.ANO_LETIVO = F.ANO_LETIVO "
sqlAlertaFrequencia = sqlAlertaFrequencia & "           AND F.DATA_FALTA >= CAST(J.DATAINICIAL AS DATE) "
sqlAlertaFrequencia = sqlAlertaFrequencia & "           AND F.DATA_FALTA <= CAST(ISNULL(J.DATAFINAL,J.DATAINICIAL) AS DATE) "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     ) JF "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     GROUP BY F.COD_ALUNO "
sqlAlertaFrequencia = sqlAlertaFrequencia & " ), "
sqlAlertaFrequencia = sqlAlertaFrequencia & " Classificados AS ( "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     SELECT "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         D.COD_ALUNO, D.MATRICULA, D.NOMEALUNO, D.COD_TURMA, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         D.NOMETURMA, D.TURMAALUNO, D.PERIODO, D.COD_CURSO, D.ANO_SERIE, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         T.TOTAL_FALTAS, T.FALTAS_JUSTIFICADAS, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         CASE "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN D.COD_CURSO <> 1 AND D.ANO_SERIE BETWEEN 3 AND 5 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "                  AND T.TOTAL_FALTAS > 50 THEN 'VERMELHO' "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN D.COD_CURSO <> 1 AND D.ANO_SERIE BETWEEN 6 AND 9 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "                  AND T.TOTAL_FALTAS > 250 THEN 'VERMELHO' "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN D.COD_CURSO = 1 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "                  AND T.TOTAL_FALTAS BETWEEN 24 AND 80 THEN 'AMARELO' "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN D.COD_CURSO <> 1 AND D.ANO_SERIE BETWEEN 1 AND 5 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "                  AND T.TOTAL_FALTAS BETWEEN 15 AND 50 THEN 'AMARELO' "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             WHEN D.COD_CURSO <> 1 AND D.ANO_SERIE BETWEEN 6 AND 9 "
sqlAlertaFrequencia = sqlAlertaFrequencia & "                  AND T.TOTAL_FALTAS BETWEEN 75 AND 250 THEN 'AMARELO' "
sqlAlertaFrequencia = sqlAlertaFrequencia & "             ELSE '' "
sqlAlertaFrequencia = sqlAlertaFrequencia & "         END AS SITUACAO_ALERTA "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     FROM DadosAluno D "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     INNER JOIN Totais T ON T.COD_ALUNO = D.COD_ALUNO "
sqlAlertaFrequencia = sqlAlertaFrequencia & " ) "
sqlAlertaFrequencia = sqlAlertaFrequencia & " SELECT "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     COD_ALUNO, MATRICULA, NOMEALUNO, COD_TURMA, NOMETURMA, TURMAALUNO, "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     PERIODO, ANO_SERIE, TOTAL_FALTAS, FALTAS_JUSTIFICADAS, SITUACAO_ALERTA "
sqlAlertaFrequencia = sqlAlertaFrequencia & " FROM Classificados "
sqlAlertaFrequencia = sqlAlertaFrequencia & " WHERE SITUACAO_ALERTA IN ('VERMELHO','AMARELO') "
sqlAlertaFrequencia = sqlAlertaFrequencia & " ORDER BY "
sqlAlertaFrequencia = sqlAlertaFrequencia & "     CASE WHEN SITUACAO_ALERTA = 'VERMELHO' THEN 1 ELSE 2 END, NOMEALUNO "

Set rsAlertaFrequencia = Server.CreateObject("ADODB.Recordset")
rsAlertaFrequencia.Open sqlAlertaFrequencia, cnn

If Not rsAlertaFrequencia.EOF Then

    vetAlertaFrequencia = rsAlertaFrequencia.GetRows()

    idxAF_CodAluno = -1
    idxAF_Matricula = -1
    idxAF_NomeAluno = -1
    idxAF_CodTurma = -1
    idxAF_NomeTurma = -1
    idxAF_TurmaAluno = -1
    idxAF_Periodo = -1
    idxAF_Total = -1
    idxAF_Justificadas = -1
    idxAF_Situacao = -1

    For iAF = 0 To rsAlertaFrequencia.Fields.Count - 1
        Select Case UCase(rsAlertaFrequencia.Fields(iAF).Name)
            Case "COD_ALUNO": idxAF_CodAluno = iAF
            Case "MATRICULA": idxAF_Matricula = iAF
            Case "NOMEALUNO": idxAF_NomeAluno = iAF
            Case "COD_TURMA": idxAF_CodTurma = iAF
            Case "NOMETURMA": idxAF_NomeTurma = iAF
            Case "TURMAALUNO": idxAF_TurmaAluno = iAF
            Case "PERIODO": idxAF_Periodo = iAF
            Case "TOTAL_FALTAS": idxAF_Total = iAF
            Case "FALTAS_JUSTIFICADAS": idxAF_Justificadas = iAF
            Case "SITUACAO_ALERTA": idxAF_Situacao = iAF
        End Select
    Next

    rsAlertaFrequencia.Close

    For iAF = 0 To UBound(vetAlertaFrequencia, 2)
        strSituacaoAF = UCase(Trim("" & vetAlertaFrequencia(idxAF_Situacao, iAF)))
        If dicQtdAlerta.Exists(strSituacaoAF) Then
            dicQtdAlerta(strSituacaoAF) = CLng(dicQtdAlerta(strSituacaoAF)) + 1
        End If
    Next

    bolTemAlertaFrequencia = True

Else
    rsAlertaFrequencia.Close
End If

Set rsAlertaFrequencia = Nothing
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
    <ol class="breadcrumb page-breadcrumb">
        <li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
        <li class="breadcrumb-item"><%=modulo%></li>
        <li class="breadcrumb-item active"><%=pagina%></li>
        <li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
    </ol>

    <div class="subheader">
        <h1 class="subheader-title">
            <i class='subheader-icon fal fa-edit'></i> <%=pagina%>
            <small><%=descricao_pagina%></small>
        </h1>
    </div>

    <div class="row">
        <div class="col-xl-12">

            <div class="panel">
                <div class="panel-hdr">
                    <h2>
                        <i class="fal fa-exclamation-triangle mr-2"></i>
                        Alerta de frequência
                    </h2>

                    <div class="panel-toolbar">
                        <span class="badge badge-danger p-2 mr-2">
                            <%=dicQtdAlerta("VERMELHO")%> reprovado(s) por faltas
                        </span>
                        <span class="badge badge-warning p-2">
                            <%=dicQtdAlerta("AMARELO")%> aluno(s) em alerta
                        </span>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">

                        <% If bolTemAlertaFrequencia Then %>

                            <div id="accordionAlertaFrequencia">

                                <div class="card mb-2">
                                    <div class="card-header"
                                         id="headingAlertaVermelho"
                                         style="cursor:pointer;"
                                         data-toggle="collapse"
                                         data-target="#collapseAlertaVermelho"
                                         aria-expanded="false"
                                         aria-controls="collapseAlertaVermelho">

                                        <div class="d-flex align-items-center">
                                            <div class="flex-1">
                                                <strong class="text-danger">
                                                    <i class="fal fa-user-times mr-2"></i>
                                                    Vermelho - Reprovado por faltas
                                                </strong>
                                            </div>
                                            <span class="badge badge-danger"><%=dicQtdAlerta("VERMELHO")%></span>
                                            <i class="fal fa-chevron-down ml-3"></i>
                                        </div>
                                    </div>

                                    <div id="collapseAlertaVermelho"
                                         class="collapse"
                                         aria-labelledby="headingAlertaVermelho"
                                         data-parent="#accordionAlertaFrequencia">
                                        <div class="card-body p-0">

                                            <% If CLng(dicQtdAlerta("VERMELHO")) > 0 Then %>
                                                <div class="table-responsive">
                                                    <table class="table table-bordered table-hover table-sm mb-0">
                                                        <thead class="thead-light">
                                                            <tr>
                                                                <th width="120">Matrícula</th>
                                                                <th>Aluno</th>
                                                                <th width="230">Série / Turma</th>
                                                                <th width="90" class="text-center">Faltas</th>
                                                                <th width="110" class="text-center">Justificadas</th>
                                                                <th width="75" class="text-center">Ação</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        <%
                                                        For iAF = 0 To UBound(vetAlertaFrequencia, 2)
                                                            If UCase(Trim("" & vetAlertaFrequencia(idxAF_Situacao, iAF))) = "VERMELHO" Then

                                                                strSerieTurmaAF = Trim("" & vetAlertaFrequencia(idxAF_Periodo, iAF))

                                                                If Trim("" & vetAlertaFrequencia(idxAF_TurmaAluno, iAF)) <> "" Then
                                                                    If strSerieTurmaAF <> "" Then strSerieTurmaAF = strSerieTurmaAF & " - "
                                                                    strSerieTurmaAF = strSerieTurmaAF & Trim("" & vetAlertaFrequencia(idxAF_TurmaAluno, iAF))
                                                                End If

                                                                If Trim("" & vetAlertaFrequencia(idxAF_NomeTurma, iAF)) <> "" Then
                                                                    If strSerieTurmaAF <> "" Then strSerieTurmaAF = strSerieTurmaAF & " - "
                                                                    strSerieTurmaAF = strSerieTurmaAF & Trim("" & vetAlertaFrequencia(idxAF_NomeTurma, iAF))
                                                                End If
                                                        %>
                                                            <tr>
                                                                <td><%=HtmlAlerta(vetAlertaFrequencia(idxAF_Matricula, iAF))%></td>
                                                                <td><strong><%=HtmlAlerta(vetAlertaFrequencia(idxAF_NomeAluno, iAF))%></strong></td>
                                                                <td><%=HtmlAlerta(strSerieTurmaAF)%></td>
                                                                <td class="text-center">
                                                                    <span class="badge badge-danger"><%=CLng(vetAlertaFrequencia(idxAF_Total, iAF))%></span>
                                                                </td>
                                                                <td class="text-center"><%=CLng(vetAlertaFrequencia(idxAF_Justificadas, iAF))%></td>
                                                                <td class="text-center">
                                                                    <a href="sca_alerta_faltasCon.asp?txtAnoLetivo=<%=Server.URLEncode(strAnoLetivoAlerta)%>&cmbTurma=<%=CLng(vetAlertaFrequencia(idxAF_CodTurma, iAF))%>"
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
                                            <% Else %>
                                                <div class="alert alert-success m-3">
                                                    Nenhum aluno reprovado por faltas.
                                                </div>
                                            <% End If %>

                                        </div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-header"
                                         id="headingAlertaAmarelo"
                                         style="cursor:pointer;"
                                         data-toggle="collapse"
                                         data-target="#collapseAlertaAmarelo"
                                         aria-expanded="false"
                                         aria-controls="collapseAlertaAmarelo">

                                        <div class="d-flex align-items-center">
                                            <div class="flex-1">
                                                <strong class="text-warning">
                                                    <i class="fal fa-exclamation-circle mr-2"></i>
                                                    Amarelo - Faixa de alerta
                                                </strong>
                                            </div>
                                            <span class="badge badge-warning"><%=dicQtdAlerta("AMARELO")%></span>
                                            <i class="fal fa-chevron-down ml-3"></i>
                                        </div>
                                    </div>

                                    <div id="collapseAlertaAmarelo"
                                         class="collapse"
                                         aria-labelledby="headingAlertaAmarelo"
                                         data-parent="#accordionAlertaFrequencia">
                                        <div class="card-body p-0">

                                            <% If CLng(dicQtdAlerta("AMARELO")) > 0 Then %>
                                                <div class="table-responsive">
                                                    <table class="table table-bordered table-hover table-sm mb-0">
                                                        <thead class="thead-light">
                                                            <tr>
                                                                <th width="120">Matrícula</th>
                                                                <th>Aluno</th>
                                                                <th width="230">Série / Turma</th>
                                                                <th width="90" class="text-center">Faltas</th>
                                                                <th width="110" class="text-center">Justificadas</th>
                                                                <th width="75" class="text-center">Ação</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        <%
                                                        For iAF = 0 To UBound(vetAlertaFrequencia, 2)
                                                            If UCase(Trim("" & vetAlertaFrequencia(idxAF_Situacao, iAF))) = "AMARELO" Then

                                                                strSerieTurmaAF = Trim("" & vetAlertaFrequencia(idxAF_Periodo, iAF))

                                                                If Trim("" & vetAlertaFrequencia(idxAF_TurmaAluno, iAF)) <> "" Then
                                                                    If strSerieTurmaAF <> "" Then strSerieTurmaAF = strSerieTurmaAF & " - "
                                                                    strSerieTurmaAF = strSerieTurmaAF & Trim("" & vetAlertaFrequencia(idxAF_TurmaAluno, iAF))
                                                                End If

                                                                If Trim("" & vetAlertaFrequencia(idxAF_NomeTurma, iAF)) <> "" Then
                                                                    If strSerieTurmaAF <> "" Then strSerieTurmaAF = strSerieTurmaAF & " - "
                                                                    strSerieTurmaAF = strSerieTurmaAF & Trim("" & vetAlertaFrequencia(idxAF_NomeTurma, iAF))
                                                                End If
                                                        %>
                                                            <tr>
                                                                <td><%=HtmlAlerta(vetAlertaFrequencia(idxAF_Matricula, iAF))%></td>
                                                                <td><strong><%=HtmlAlerta(vetAlertaFrequencia(idxAF_NomeAluno, iAF))%></strong></td>
                                                                <td><%=HtmlAlerta(strSerieTurmaAF)%></td>
                                                                <td class="text-center">
                                                                    <span class="badge badge-warning"><%=CLng(vetAlertaFrequencia(idxAF_Total, iAF))%></span>
                                                                </td>
                                                                <td class="text-center"><%=CLng(vetAlertaFrequencia(idxAF_Justificadas, iAF))%></td>
                                                                <td class="text-center">
                                                                    <a href="sca_alerta_faltasCon.asp?txtAnoLetivo=<%=Server.URLEncode(strAnoLetivoAlerta)%>&cmbTurma=<%=CLng(vetAlertaFrequencia(idxAF_CodTurma, iAF))%>"
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
                                            <% Else %>
                                                <div class="alert alert-success m-3">
                                                    Nenhum aluno na faixa amarela.
                                                </div>
                                            <% End If %>

                                        </div>
                                    </div>
                                </div>

                            </div>

                        <% Else %>

                            <div class="alert alert-success mb-0">
                                <i class="fal fa-check-circle mr-2"></i>
                                Nenhum alerta de frequência encontrado para o ano letivo
                                <strong><%=HtmlAlerta(strAnoLetivoAlerta)%></strong>.
                            </div>

                        <% End If %>

                    </div>
                </div>
            </div>

        </div>
    </div>
</main>

<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
