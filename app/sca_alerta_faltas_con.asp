<%
'===============================================================================
' ALERTA DE FALTAS
' Tela de consulta e seleção dos alunos.
'
' Regras:
' Educação Infantil:
'   Verde: < 24
'   Amarelo: 24 a 80
'   Vermelho: > 80 (somente alerta visual)
'
' Ensino Fundamental 1º e 2º:
'   Verde: < 15
'   Amarelo: 15 a 50
'   Vermelho: > 50 (somente alerta visual)
'
' Ensino Fundamental 3º ao 5º:
'   Verde: < 15
'   Amarelo: 15 a 50
'   Vermelho: > 50 (reprovado por faltas)
'
' Ensino Fundamental 6º ao 9º:
'   Verde: < 75
'   Amarelo: 75 a 250
'   Vermelho: > 250 (reprovado por faltas)
'
' Observação:
' Faltas justificadas continuam compondo o total geral e são discriminadas
' separadamente, conforme a solicitação.
'===============================================================================

Function Html(valor)
    If IsNull(valor) Then
        Html = ""
    Else
        Html = Server.HTMLEncode(CStr(valor))
    End If
End Function

strAnoLetivo = Trim(Request("txtAnoLetivo"))
strAnoLetivo = session("strAnoLetivo")	'ano letivo vem da sessão (Trocar Ano Letivo)
If strAnoLetivo = "" Then strAnoLetivo = Session("strAnoLetivo")

strSemestre = Trim(Request("cmbSemestre"))
If strSemestre = "" Then strSemestre = Session("strSemestre")

intCodTurma = Trim(Request("cmbTurma"))
If intCodTurma = "" Then intCodTurma = "0"

intCodCurso = 0
intCodPeriodo = 0
intCodTurno = 0
intAnoTurma = 0
strPeriodo = ""
strNomeTurma = ""
strTurmaAluno = ""

If CLng(intCodTurma) > 0 Then

    sql = " SELECT TU.Cod_Turma, TU.Cod_Semestre, TU.Cod_Turno, TU.NomeTurma, " & _
          "        TU.TurmaAluno, TU.Anoletivo, P.Cod_Curso, P.Cod_Periodo, " & _
          "        P.Descricao AS Periodo " & _
          " FROM SCA_TURMA TU " & _
          " INNER JOIN SCA_GRADECURRICULAR G " & _
          "     ON G.Cod_GradeCurricular = TU.Cod_GradeCurricular " & _
          " INNER JOIN SCA_PERIODO P " & _
          "     ON P.Cod_Periodo = G.Cod_Periodo " & _
          " WHERE TU.Cod_Empresa = " & CLng(Session("CodEmpresa")) & _
          "   AND TU.Cod_Turma = " & CLng(intCodTurma)

    rs.Open sql, cnn

    If Not rs.EOF Then
        intCodCurso = CLng(rs("Cod_Curso"))
        intCodPeriodo = CLng(rs("Cod_Periodo"))
        intCodTurno = CLng(rs("Cod_Turno"))
        strPeriodo = Trim("" & rs("Periodo"))
        strNomeTurma = Trim("" & rs("NomeTurma"))
        strTurmaAluno = Trim("" & rs("TurmaAluno"))

        If Not IsNull(rs("Anoletivo")) Then
            If IsNumeric(rs("Anoletivo")) Then intAnoTurma = CInt(rs("Anoletivo"))
        End If
    End If

    rs.Close

End If

strExecutarSubmitCurso = "S"
strExecutarSubmitPeriodo = "S"
strExecutarSubmitSemestre = "S"
strExecutarSubmitTurno = "S"
strExecutarSubmitTurma = "S"
%>

<main id="js-page-content" role="main" class="page-content">

<form id="frm" method="post" action="sca_alerta_faltasCon.asp">

    <ol class="breadcrumb page-breadcrumb">
        <li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
        <li class="breadcrumb-item"><%=modulo%></li>
        <li class="breadcrumb-item active"><%=pagina%></li>
        <li class="position-absolute pos-top pos-right d-none d-sm-block"><%=Session("data_hoje")%></li>
    </ol>

    <div class="subheader">
        <h1 class="subheader-title">
            <i class="subheader-icon fal fa-exclamation-triangle"></i>
            <%=pagina%>
            <small><%=descricao_pagina%></small>
			<%'Guapó: sem vídeo tutorial%>	
        </h1>
	</div>
	
    <div class="row">
        <div class="col-xl-12">
            <div class="panel">

                <div class="panel-hdr">
                    <h2>Filtros</h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel ni ni-chevron-down"
                                data-action="panel-collapse"
                                data-toggle="tooltip"
                                data-original-title="Recolher"></button>
                        <button class="btn btn-panel ni ni-size-fullscreen"
                                data-action="panel-fullscreen"
                                data-toggle="tooltip"
                                data-original-title="Tela cheia"></button>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">

                        <div class="row">

                            <div class="col-sm-2">
                                <div class="form-group">
                                    <label class="form-label">Ano Letivo:</label>
                                    <input
                                        name="txtAnoLetivo"
                                        id="txtAnoLetivo"
                                        type="text"
                                        class="form-control"
                                        value="<%=strAnoLetivo%>"
                                        maxlength="4" readonly>
                                </div>
                            </div>

                            <div class="col-sm-2">
                                <div class="form-group">
                                    <label class="form-label">Semestre:</label>
                                    <!--#include file="includes/inc_cmdSemestre.asp" -->
                                </div>
                            </div>

                            <div class="col-sm-4">
                                <div class="form-group">
                                    <label class="form-label">Turma:</label>
                                    <!--#include file="includes/inc_cmdTurma.asp" -->
                                </div>
                            </div>

                        </div>

                        <% If CLng(intCodTurma) > 0 Then %>
						<br>
                            <div class="alert alert-info mb-0">
                                <strong>Turma:</strong>
                                <%=Html(strPeriodo)%>
                                <% If strTurmaAluno <> "" Then %> - <%=Html(strTurmaAluno)%><% End If %>
                                <% If strNomeTurma <> "" Then %> - <%=Html(strNomeTurma)%><% End If %>
                            </div>
                        <% End If %>


						<br>
						<div class="frame-wrap">
							<%strTextoBotaoRel="Gerar alerta de faltas"%>
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
						</div>
                    </div>
					
					
                </div>
            </div>
        </div>
    </div>

<%
If CLng(intCodTurma) > 0 Then

    '---------------------------------------------------------------------------
    ' 1) Busca os alunos da turma seguindo a mesma função já utilizada
    '    pelo Diário Eletrônico.
    '---------------------------------------------------------------------------

    sqlAlunos = sqlAlunoTurma(intCodTurma, "")
'if session("usuarioweb") = "SERGIO" Then
'	response.write sqlAlunos
'end if
    rs.Open sqlAlunos, cnn

    If Not rs.EOF Then

        vetAlunos = rs.GetRows()

        idxCodigo = -1
        idxMatricula = -1
        idxNome = -1
        idxSituacao = -1
        idxDataSituacao = -1

        For i = 0 To rs.Fields.Count - 1
            Select Case UCase(rs.Fields(i).Name)
                Case "CODIGO"
                    idxCodigo = i
                Case "MATRICULA"
                    idxMatricula = i
                Case "NOMEALUNO"
                    idxNome = i
                Case "DESC_SITUACAOALUNO"
                    idxSituacao = i
                Case "DATA_SITUACAOALUNO"
                    idxDataSituacao = i
            End Select
        Next

        rs.Close

        strIdsAlunos = ""

        For i = 0 To UBound(vetAlunos, 2)
            If strIdsAlunos <> "" Then strIdsAlunos = strIdsAlunos & ","
            strIdsAlunos = strIdsAlunos & CLng(vetAlunos(idxCodigo, i))
        Next

        '-----------------------------------------------------------------------
		'------------------------------------------------------------------------------
		' Regra de contagem por etapa:
		'   - Educação Infantil ao 5º ano: 1 falta por aluno/data.
		'   - 6º ao 9º ano: 1 falta por aluno/data/disciplina.
		' Justificativa:
		'   - Utiliza SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA.
		'   - Até o 5º ano: considera aluno + DataFalta.
		'   - 6º ao 9º ano: considera aluno + DataFalta + cod_disciplina.
		'------------------------------------------------------------------------------

        ' 2) Carrega o total anual das faltas de todos os alunos em uma única
        '    consulta.
        '
        ' EXISTS evita duplicação do valor da falta caso existam duas
        ' justificativas sobrepostas para o mesmo aluno/data.
        '-----------------------------------------------------------------------

        Set dicTotalFaltas = Server.CreateObject("Scripting.Dictionary")
		Set dicJustificadas = Server.CreateObject("Scripting.Dictionary")

		Dim snContaPorDisciplina
		snContaPorDisciplina = False

		If intCodPeriodo >= 6 And intCodPeriodo <= 9 Then
			snContaPorDisciplina = True
		End If

		If snContaPorDisciplina Then

			' ============================================================
			' 6º AO 9º ANO
			' FALTA = ALUNO + DATA + DISCIPLINA
			' JUSTIFICADA = ALUNO + DATA + DISCIPLINA
			' ============================================================

			sql = " WITH FaltasContagem AS ( " & _
				  "     SELECT DISTINCT " & _
				  "         F.cod_empresa, " & _
				  "         F.ano_letivo, " & _
				  "         F.cod_aluno, " & _
				  "         CAST(F.data AS DATE) AS data_falta, " & _
				  "         ISNULL(F.cod_disciplina, 0) AS cod_disciplina " & _
				  "     FROM SCA_FALTAS_DIARIA F " & _
				  "     WHERE F.cod_empresa = " & CLng(Session("CodEmpresa")) & _
				  "       AND F.ano_letivo = " & CLng(strAnoLetivo) & _
				  "       AND F.cod_aluno IN (" & strIdsAlunos & ") " & _
				  " ), " & _
				  " Justificadas AS ( " & _
				  "     SELECT DISTINCT " & _
				  "         j.cod_aluno, " & _
				  "         CAST(d.DataFalta AS DATE) AS data_falta, " & _
				  "         ISNULL(d.cod_disciplina, 0) AS cod_disciplina " & _
				  "     FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS j " & _
				  "     INNER JOIN SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA d " & _
				  "         ON d.cod_aluno_justificativa_faltas = j.codigo " & _
				  "     INNER JOIN SCA_TURMA tu " & _
				  "         ON tu.Cod_Turma = j.Cod_turma " & _
				  "     INNER JOIN SCA_PERIODO p " & _
				  "         ON p.Cod_Periodo = tu.Cod_Periodo " & _
				  "     WHERE j.cod_empresa = " & CLng(Session("CodEmpresa")) & _
				  "       AND j.ano_letivo = " & CLng(strAnoLetivo) & _
				  "       AND j.cod_aluno IN (" & strIdsAlunos & ") " & _
				  "       AND p.Cod_Periodo BETWEEN 6 AND 9 " & _
				  " ) " & _
				  " SELECT " & _
				  "     F.cod_aluno, " & _
				  "     COUNT(*) AS TotalFaltas, " & _
				  "     COUNT(J.cod_aluno) AS FaltasJustificadas " & _
				  " FROM FaltasContagem F " & _
				  " LEFT JOIN Justificadas J " & _
				  "     ON J.cod_aluno = F.cod_aluno " & _
				  "    AND J.data_falta = F.data_falta " & _
				  "    AND J.cod_disciplina = F.cod_disciplina " & _
				  " GROUP BY F.cod_aluno "

		Else

			' ============================================================
			' DEMAIS PERÍODOS
			' FALTA = ALUNO + DATA
			' JUSTIFICADA = ALUNO + DATA
			' ============================================================

			sql = " WITH FaltasContagem AS ( " & _
				  "     SELECT DISTINCT " & _
				  "         F.cod_empresa, " & _
				  "         F.ano_letivo, " & _
				  "         F.cod_aluno, " & _
				  "         CAST(F.data AS DATE) AS data_falta " & _
				  "     FROM SCA_FALTAS_DIARIA F " & _
				  "     WHERE F.cod_empresa = " & CLng(Session("CodEmpresa")) & _
				  "       AND F.ano_letivo = " & CLng(strAnoLetivo) & _
				  "       AND F.cod_aluno IN (" & strIdsAlunos & ") " & _
				  " ), " & _
				  " Justificadas AS ( " & _
				  "     SELECT DISTINCT " & _
				  "         j.cod_aluno, " & _
				  "         CAST(d.DataFalta AS DATE) AS data_falta " & _
				  "     FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS j " & _
				  "     INNER JOIN SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA d " & _
				  "         ON d.cod_aluno_justificativa_faltas = j.codigo " & _
				  "     INNER JOIN SCA_TURMA tu " & _
				  "         ON tu.Cod_Turma = j.Cod_turma " & _
				  "     INNER JOIN SCA_PERIODO p " & _
				  "         ON p.Cod_Periodo = tu.Cod_Periodo " & _
				  "     WHERE j.cod_empresa = " & CLng(Session("CodEmpresa")) & _
				  "       AND j.ano_letivo = " & CLng(strAnoLetivo) & _
				  "       AND j.cod_aluno IN (" & strIdsAlunos & ") " & _
				  "       AND p.Cod_Periodo NOT BETWEEN 6 AND 9 " & _
				  " ) " & _
				  " SELECT " & _
				  "     F.cod_aluno, " & _
				  "     COUNT(*) AS TotalFaltas, " & _
				  "     COUNT(J.cod_aluno) AS FaltasJustificadas " & _
				  " FROM FaltasContagem F " & _
				  " LEFT JOIN Justificadas J " & _
				  "     ON J.cod_aluno = F.cod_aluno " & _
				  "    AND J.data_falta = F.data_falta " & _
				  " GROUP BY F.cod_aluno "

		End If
		rs.Open sql, cnn

		Do While Not rs.EOF

			' O relatório exibe uma linha por aluno.
			' A regra de data+disciplina para 6º ao 9º já foi aplicada
			' dentro da CTE FaltasContagem antes desta consolidação.
			chaveFalta = CStr(rs("cod_aluno"))

			dicTotalFaltas(chaveFalta) = CLng(rs("TotalFaltas"))
			dicJustificadas(chaveFalta) = CLng(rs("FaltasJustificadas"))

			rs.MoveNext
		Loop

		rs.Close
%>

    <div class="row">
        <div class="col-xl-12">
            <div class="panel">

                <div class="panel-hdr">
                    <h2>Alunos / Alertas de frequência</h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel ni ni-chevron-down"
                                data-action="panel-collapse"
                                data-toggle="tooltip"
                                data-original-title="Recolher"></button>
                        <button class="btn btn-panel ni ni-size-fullscreen"
                                data-action="panel-fullscreen"
                                data-toggle="tooltip"
                                data-original-title="Tela cheia"></button>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">

                        <div class="mb-3">
                            <span class="badge badge-success">VERDE</span>
                            abaixo de 30% do limite
                            &nbsp;&nbsp;

                            <span class="badge badge-warning">AMARELO</span>
                            faixa de alerta
                            &nbsp;&nbsp;

                            <span class="badge badge-danger">VERMELHO</span>
                            limite excedido
                        </div>

                        <div class="table-responsive-lg">
                            <table class="table table-bordered table-hover m-0">
                                <thead class="thead-themed">
                                    <tr>
                                        <th width="35">
                                            <input
                                                name="chkTodos"
                                                type="checkbox"
                                                onclick="MarcaTodosAlunos(this.checked)">
                                        </th>
                                        <th width="60">Ordem</th>
                                        <th width="130">Matrícula</th>
                                        <th>Aluno</th>
                                        <th width="110" class="text-center">Faltas</th>
                                        <th width="130" class="text-center">Justificadas</th>
                                        <th width="130" class="text-center">Não justificadas</th>
                                        <th width="110" class="text-center">% limite</th>
                                        <th width="190">Situação</th>
                                    </tr>
                                </thead>

                                <tbody>

<%
        For i = 0 To UBound(vetAlunos, 2)

            codAluno = CLng(vetAlunos(idxCodigo, i))
            strChaveAluno = CStr(codAluno)

            totalFaltas = 0
            faltasJustificadas = 0

            If dicTotalFaltas.Exists(strChaveAluno) Then
                totalFaltas = CLng(dicTotalFaltas(strChaveAluno))
            End If

            If dicJustificadas.Exists(strChaveAluno) Then
                faltasJustificadas = CLng(dicJustificadas(strChaveAluno))
            End If

            faltasNaoJustificadas = totalFaltas - faltasJustificadas
            If faltasNaoJustificadas < 0 Then faltasNaoJustificadas = 0

            limiteMaximo = 0
            limiteAmarelo = 0
            strGrupo = ""
            strSituacaoAlerta = ""
            strClasse = ""
            bolReprovaPorFalta = False

            ' Educação Infantil.
            ' O próprio relatório atual identifica Cod_Curso = 1 como Educação Infantil.
            If intCodCurso = 1 Then

                limiteMaximo = 80
                limiteAmarelo = 24
                strGrupo = "Educação Infantil"

            Else

                ' Para o Ensino Fundamental, prioriza TU.ANO e usa a descrição
                ' do período como fallback.
                serieAluno = intCodPeriodo

                If serieAluno >= 1 And serieAluno <= 2 Then
                    limiteMaximo = 50
                    limiteAmarelo = 15
                    strGrupo = "Ensino Fundamental - 1º e 2º anos"

                ElseIf serieAluno >= 3 And serieAluno <= 5 Then
                    limiteMaximo = 50
                    limiteAmarelo = 15
                    strGrupo = "Ensino Fundamental - 3º ao 5º anos"
                    bolReprovaPorFalta = True

                ElseIf serieAluno >= 6 And serieAluno <= 9 Then
                    limiteMaximo = 250
                    limiteAmarelo = 75
                    strGrupo = "Ensino Fundamental - 6º ao 9º anos"
                    bolReprovaPorFalta = True

                Else
                    limiteMaximo = 0
                    limiteAmarelo = 0
                    strGrupo = "Curso/série não classificada"
                End If

            End If

            percentualLimite = 0

            If limiteMaximo > 0 Then

                ' IMPORTANTE:
                ' O percentual e a situação do alerta são calculados somente
                ' sobre as faltas NÃO justificadas.
                percentualLimite = Round((CDbl(faltasNaoJustificadas) / CDbl(limiteMaximo)) * 100, 1)

                If faltasNaoJustificadas > limiteMaximo Then
                    strClasse = "table-danger"

                    If bolReprovaPorFalta Then
                        strSituacaoAlerta = "REPROVADO POR FALTAS"
                    Else
                        strSituacaoAlerta = "LIMITE EXCEDIDO"
                    End If

                ElseIf faltasNaoJustificadas >= limiteAmarelo Then
                    strClasse = "table-warning"
                    strSituacaoAlerta = "ALERTA"

                Else
                    strClasse = "table-success"
                    strSituacaoAlerta = "NORMAL"
                End If

            Else
                strClasse = ""
                strSituacaoAlerta = "NÃO CLASSIFICADO"
            End If
			
			' A consulta dos alunos nem sempre traz a data da situação: só mostra o que existir
			situacaoAluno = ""
			if idxSituacao >= 0 then situacaoAluno = Trim("" & vetAlunos(idxSituacao, i))
			if situacaoAluno = "" or UCase(situacaoAluno) = "ATIVO" Then
				situacaoAluno = ""
			Else
				strDataSituacaoAluno = ""
				if idxDataSituacao >= 0 then strDataSituacaoAluno = " " & vetAlunos(idxDataSituacao, i)
				situacaoAluno = "<font size=1 color='red'><br>(" & Html(situacaoAluno) & strDataSituacaoAluno & ")</font>"
			end if
%>

                                    <tr class="<%=strClasse%>">
                                        <td>
                                            <input
                                                type="checkbox"
                                                id="chkAluno_<%=codAluno%>"
                                                name="chkAluno"
                                                value="<%=codAluno%>">
                                        </td>

                                        <td><%=Right("00" & CStr(i + 1), 2)%></td>

                                        <td>
                                            <% If idxMatricula >= 0 Then %>
                                                <%=Html(vetAlunos(idxMatricula, i))%>
                                            <% End If %>
                                        </td>

                                        <td>
                                            <% If idxNome >= 0 Then %>
                                                <%=Html(vetAlunos(idxNome, i))%> <%=situacaoAluno%>
                                            <% End If %>
                                        </td>

                                        <td class="text-center">
                                            <strong><%=totalFaltas%></strong>
                                        </td>

                                        <td class="text-center">
                                            <%=faltasJustificadas%>
                                        </td>

                                        <td class="text-center">
                                            <%=faltasNaoJustificadas%>
                                        </td>

                                        <td class="text-center">
                                            <% If limiteMaximo > 0 Then %>
                                                <%=Replace(FormatNumber(percentualLimite, 1), ",00", "")%>%
                                            <% Else %>
                                                -
                                            <% End If %>
                                        </td>

                                        <td>
                                            <strong><%=strSituacaoAlerta%></strong>
                                        </td>
                                    </tr>

<%
        Next
%>

                                </tbody>
                            </table>
                        </div>


						<br>
						<div class="frame-wrap">
							<%strTextoBotaoRel="Gerar alerta de faltas"%>
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
						</div>

                        
                        <input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">
                        <input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
                        <input type="hidden" name="txtAnoTurma" value="<%=intAnoTurma%>">
                        <input type="hidden" name="txtPeriodo" value="<%=Html(strPeriodo)%>">
                        <input type="hidden" name="txtNomeTurma" value="<%=Html(strNomeTurma)%>">

                    </div>
                </div>
            </div>
        </div>
    </div>

<%
    Else
        rs.Close
%>

    <div class="alert alert-warning">
        Nenhum aluno encontrado para a turma selecionada.
    </div>

<%
    End If

End If
%>

</form>
</main>

<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
