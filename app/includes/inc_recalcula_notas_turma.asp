<%
' ============================================================
' RECALCULO CENTRALIZADO DE NOTAS DA TURMA / DISCIPLINA
' Usa SCA_CALCULO em ordem de POSICAO e respeita
' SCA_ALUNO_MEDIA_ESPECIAL.
'
' IMPORTANTE:
' - Recalcula somente campos com DIGITAR = 'N'.
' - Nunca sobrescreve campos digitados manualmente.
' - A rotina deve ser chamada DEPOIS de salvar as notas e ANTES do COMMIT.
' ============================================================

Function RNT_FormulaMediaEspecial(strFormulaOriginal, bolME1, bolME2, bolME3, bolME4)
    Dim strSomaME, intQtdME, strMediaME, strFormulaME
    strSomaME = ""
    intQtdME = 0

    If Not bolME1 Then strSomaME = "C1": intQtdME = intQtdME + 1
    If Not bolME2 Then
        If strSomaME <> "" Then strSomaME = strSomaME & "+"
        strSomaME = strSomaME & "C2": intQtdME = intQtdME + 1
    End If
    If Not bolME3 Then
        If strSomaME <> "" Then strSomaME = strSomaME & "+"
        strSomaME = strSomaME & "C3": intQtdME = intQtdME + 1
    End If
    If Not bolME4 Then
        If strSomaME <> "" Then strSomaME = strSomaME & "+"
        strSomaME = strSomaME & "C4": intQtdME = intQtdME + 1
    End If

    strFormulaME = RNT_Texto(strFormulaOriginal)
    If intQtdME > 0 And intQtdME < 4 Then
        strMediaME = "(" & strSomaME & ")/" & intQtdME
        strFormulaME = Replace(strFormulaME, "(C1+C2+C3+C4)/4", strMediaME, 1, -1, 1)
    End If

    RNT_FormulaMediaEspecial = strFormulaME
End Function

Function RNT_CampoNota(intPosicao)
    If CInt(intPosicao) < 10 Then
        RNT_CampoNota = "nota0" & CInt(intPosicao)
    Else
        RNT_CampoNota = "nota" & CInt(intPosicao)
    End If
End Function

Function RNT_Texto(v)
    If IsNull(v) Then
        RNT_Texto = ""
        Exit Function
    End If
    If IsEmpty(v) Then
        RNT_Texto = ""
        Exit Function
    End If
    RNT_Texto = CStr(v)
End Function

Function RNT_TemValor(v)
    If IsNull(v) Then
        RNT_TemValor = False
        Exit Function
    End If
    If IsEmpty(v) Then
        RNT_TemValor = False
        Exit Function
    End If
    RNT_TemValor = (Trim(CStr(v)) <> "")
End Function

Function RNT_ValorNumero(v)
    If IsNull(v) Then
        RNT_ValorNumero = 0
        Exit Function
    End If

    If IsEmpty(v) Then
        RNT_ValorNumero = 0
        Exit Function
    End If

    If Trim(CStr(v)) = "" Then
        RNT_ValorNumero = 0
        Exit Function
    End If

    If IsNumeric(v) Then
        RNT_ValorNumero = CDbl(v)
    Else
        RNT_ValorNumero = 0
    End If
End Function


Function RNT_SomenteNumerosCSV(strLista)
    Dim arrRNT, itemRNT, saidaRNT, valorItemRNT
    saidaRNT = ""
    strLista = Replace(RNT_Texto(strLista), " ", "")
    If strLista = "" Then
        RNT_SomenteNumerosCSV = ""
        Exit Function
    End If

    arrRNT = Split(strLista, ",")
    For Each itemRNT In arrRNT
        valorItemRNT = Trim(RNT_Texto(itemRNT))
        If valorItemRNT <> "" Then
            If IsNumeric(valorItemRNT) Then
                If CLng(valorItemRNT) > 0 Then
                    If saidaRNT <> "" Then saidaRNT = saidaRNT & ","
                    saidaRNT = saidaRNT & CLng(valorItemRNT)
                End If
            End If
        End If
    Next
    RNT_SomenteNumerosCSV = saidaRNT
End Function

Sub RNT_RecalcularNotasTurmaCore(intEmpresaRNT, intTurmaRNT, intCursoRNT, intPeriodoRNT, intAnoRNT, intSemestreRNT, intDisciplinaRNT, strAlunosRNT)
    Dim rsAlunoRNT, rsCalcRNT, rsMERNT, rsNotaRNT
    Dim sqlRNT, vetCalcRNT, posRNT, campoRNT, formulaRNT, valorRNT
    Dim codAlunoRNT, codNotaRNT, codDisciplinaAtualRNT, temNotaRNT, ultimaMediaRNT
    Dim bolME1RNT, bolME2RNT, bolME3RNT, bolME4RNT, bolPossuiMERNT
    Dim C(15), C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15
    Dim kRNT, sqlUpdateRNT, valorCalcRNT
    Dim vetAlunoRNT, iAlunoRNT

    Set rsAlunoRNT = Server.CreateObject("ADODB.Recordset")
    Set rsCalcRNT  = Server.CreateObject("ADODB.Recordset")
    Set rsMERNT    = Server.CreateObject("ADODB.Recordset")
    Set rsNotaRNT  = Server.CreateObject("ADODB.Recordset")

    ' Somente alunos que realmente possuem registro de nota na disciplina/turma.
    sqlRNT = " SELECT DISTINCT AD.COD_ALUNO, AD.COD_DISCIPLINA, NF.CODIGO AS COD_NOTA "
    sqlRNT = sqlRNT & " FROM SCA_ALUNO_DISCIPLINA AD "
    sqlRNT = sqlRNT & " INNER JOIN SCA_NOTAS_FALTAS NF ON NF.COD_ALUNO_DISCIPLINA = AD.CODIGO "
    sqlRNT = sqlRNT & " WHERE AD.COD_EMPRESA = " & CLng(intEmpresaRNT)
    sqlRNT = sqlRNT & " AND AD.COD_TURMA_REMANEJAMENTO = " & CLng(intTurmaRNT)
    ' intDisciplinaRNT > 0 = somente a disciplina informada
    ' intDisciplinaRNT = 0 = todas as disciplinas da turma
    If CLng(intDisciplinaRNT) > 0 Then
        sqlRNT = sqlRNT & " AND AD.COD_DISCIPLINA = " & CLng(intDisciplinaRNT)
    End If
    If Trim(RNT_Texto(strAlunosRNT)) <> "" Then
        sqlRNT = sqlRNT & " AND AD.COD_ALUNO IN (" & RNT_SomenteNumerosCSV(strAlunosRNT) & ")"
    End If
    sqlRNT = sqlRNT & " AND NF.ANO_LETIVO = " & CLng(intAnoRNT)
    sqlRNT = sqlRNT & " AND NF.SEMESTRE = " & CLng(intSemestreRNT)
    sqlRNT = sqlRNT & " AND NF.COD_PERIODO = " & CLng(intPeriodoRNT)

    rsAlunoRNT.Open sqlRNT, cnn

    ' IMPORTANTE: durante uma transacao manual, nao mantemos um Recordset aberto
    ' enquanto abrimos outros Recordsets na mesma conexao. Materializamos os
    ' alunos/disciplinas em memoria e fechamos o Recordset antes do recalculo.
    If Not rsAlunoRNT.EOF Then
        vetAlunoRNT = rsAlunoRNT.GetRows()
    Else
        vetAlunoRNT = Null
    End If
    rsAlunoRNT.Close

    If IsArray(vetAlunoRNT) Then
        For iAlunoRNT = 0 To UBound(vetAlunoRNT, 2)
            codAlunoRNT = CLng(vetAlunoRNT(0, iAlunoRNT))
            codDisciplinaAtualRNT = CLng(vetAlunoRNT(1, iAlunoRNT))
            codNotaRNT = CLng(vetAlunoRNT(2, iAlunoRNT))

        ' Mesmo critério do lançamento: cálculo individual do aluno tem precedência.
        sqlRNT = " SELECT CA.POSICAO, CA.FORMULA, CA.DIGITAR, CA.COD_TIPO_LANCAMENTO AS TIPO "
        sqlRNT = sqlRNT & " FROM SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO II "
        sqlRNT = sqlRNT & " INNER JOIN SCA_CALCULO CA ON CA.COD_TIPO_CALCULO = II.COD_TIPO_CALCULO "
        sqlRNT = sqlRNT & " WHERE II.ANO_LETIVO = " & CLng(intAnoRNT)
        sqlRNT = sqlRNT & " AND II.COD_ALUNO = " & codAlunoRNT
        sqlRNT = sqlRNT & " UNION "
        sqlRNT = sqlRNT & " SELECT C.POSICAO, C.FORMULA, C.DIGITAR, C.COD_TIPO_LANCAMENTO AS TIPO "
        sqlRNT = sqlRNT & " FROM SCA_CRITERIO_AVALIACAO CA "
        sqlRNT = sqlRNT & " INNER JOIN SCA_CALCULO C ON C.COD_TIPO_CALCULO = CA.COD_TIPO_CALCULO "
        sqlRNT = sqlRNT & " WHERE CA.ANO_LETIVO = " & CLng(intAnoRNT)
        sqlRNT = sqlRNT & " AND CA.COD_CURSO = " & CLng(intCursoRNT)
        sqlRNT = sqlRNT & " AND NOT EXISTS (SELECT 1 FROM SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO II2 "
        sqlRNT = sqlRNT & " WHERE II2.ANO_LETIVO = " & CLng(intAnoRNT)
        sqlRNT = sqlRNT & " AND II2.COD_ALUNO = " & codAlunoRNT & ") "
        sqlRNT = sqlRNT & " ORDER BY POSICAO "

        rsCalcRNT.Open sqlRNT, cnn
        If Not rsCalcRNT.EOF Then vetCalcRNT = rsCalcRNT.GetRows Else vetCalcRNT = Null
        rsCalcRNT.Close

        If IsArray(vetCalcRNT) Then
            ' Carrega as notas atuais do banco. Os campos manuais serão somente lidos.
            sqlRNT = "SELECT nota01,nota02,nota03,nota04,nota05,nota06,nota07,nota08,nota09,nota10,nota11,nota12,nota13,nota14,nota15 "
            sqlRNT = sqlRNT & " FROM SCA_NOTAS_FALTAS WHERE CODIGO = " & codNotaRNT
            rsNotaRNT.Open sqlRNT, cnn

            temNotaRNT = False
            For kRNT = 1 To 15
                C(kRNT) = RNT_ValorNumero(rsNotaRNT(RNT_CampoNota(kRNT)))
                If RNT_TemValor(rsNotaRNT(RNT_CampoNota(kRNT))) Then
                    temNotaRNT = True
                End If
            Next
            rsNotaRNT.Close

            C1=C(1): C2=C(2): C3=C(3): C4=C(4): C5=C(5): C6=C(6): C7=C(7): C8=C(8)
            C9=C(9): C10=C(10): C11=C(11): C12=C(12): C13=C(13): C14=C(14): C15=C(15)

            bolME1RNT=False: bolME2RNT=False: bolME3RNT=False: bolME4RNT=False: bolPossuiMERNT=False
            sqlRNT = "SELECT DISTINCT C.POSICAO FROM SCA_ALUNO_MEDIA_ESPECIAL ME "
            sqlRNT = sqlRNT & " INNER JOIN SCA_CALCULO C ON C.CODIGO = ME.COD_CALCULO "
            sqlRNT = sqlRNT & " WHERE ME.COD_EMPRESA = " & CLng(intEmpresaRNT)
            sqlRNT = sqlRNT & " AND ME.COD_ALUNO = " & codAlunoRNT
            sqlRNT = sqlRNT & " AND ME.ANO_LETIVO = " & CLng(intAnoRNT)
            sqlRNT = sqlRNT & " AND ME.SEMESTRE = " & CLng(intSemestreRNT)
            sqlRNT = sqlRNT & " AND ME.COD_PERIODO = " & CLng(intPeriodoRNT)
            sqlRNT = sqlRNT & " AND ME.COD_DISCIPLINA = " & codDisciplinaAtualRNT
            sqlRNT = sqlRNT & " AND C.COD_TIPO_LANCAMENTO IN (1,2,3,4) "
            rsMERNT.Open sqlRNT, cnn
            Do While Not rsMERNT.EOF
                bolPossuiMERNT=True
                Select Case CInt(rsMERNT("POSICAO"))
                    Case 1: bolME1RNT=True
                    Case 2: bolME2RNT=True
                    Case 3: bolME3RNT=True
                    Case 4: bolME4RNT=True
                End Select
                rsMERNT.MoveNext
            Loop
            rsMERNT.Close

            sqlUpdateRNT = ""
            ultimaMediaRNT = Null

            ' Executa na ordem das posições para permitir fórmulas dependentes de C anteriores.
            For kRNT = 0 To UBound(vetCalcRNT,2)
                posRNT = CInt(vetCalcRNT(0,kRNT))
                formulaRNT = RNT_Texto(vetCalcRNT(1,kRNT))

                If UCase(Trim(RNT_Texto(vetCalcRNT(2,kRNT)))) = "N" Then
                    If Trim(formulaRNT) <> "" Then
                    If bolPossuiMERNT Then
                        formulaRNT = RNT_FormulaMediaEspecial(formulaRNT, bolME1RNT, bolME2RNT, bolME3RNT, bolME4RNT)
                    End If

                    If temNotaRNT Then
                        valorCalcRNT = Round(Eval(formulaRNT),1)
                        C(posRNT) = valorCalcRNT
                        Select Case posRNT
                            Case 1: C1=valorCalcRNT
                            Case 2: C2=valorCalcRNT
                            Case 3: C3=valorCalcRNT
                            Case 4: C4=valorCalcRNT
                            Case 5: C5=valorCalcRNT
                            Case 6: C6=valorCalcRNT
                            Case 7: C7=valorCalcRNT
                            Case 8: C8=valorCalcRNT
                            Case 9: C9=valorCalcRNT
                            Case 10: C10=valorCalcRNT
                            Case 11: C11=valorCalcRNT
                            Case 12: C12=valorCalcRNT
                            Case 13: C13=valorCalcRNT
                            Case 14: C14=valorCalcRNT
                            Case 15: C15=valorCalcRNT
                        End Select
                        campoRNT = RNT_CampoNota(posRNT)
                        sqlUpdateRNT = sqlUpdateRNT & campoRNT & "=" & Replace(CStr(valorCalcRNT),",",".") & ","
                        ultimaMediaRNT = valorCalcRNT
                    Else
                        campoRNT = RNT_CampoNota(posRNT)
                        sqlUpdateRNT = sqlUpdateRNT & campoRNT & "=NULL,"
                    End If
                    End If
                End If
            Next

            If sqlUpdateRNT <> "" Then
                If temNotaRNT Then
                    If Not IsNull(ultimaMediaRNT) Then
                        sqlUpdateRNT = sqlUpdateRNT & "media=" & Replace(CStr(ultimaMediaRNT),",",".")
                    Else
                        sqlUpdateRNT = sqlUpdateRNT & "media=NULL"
                    End If
                Else
                    sqlUpdateRNT = sqlUpdateRNT & "media=NULL"
                End If
                sqlRNT = "UPDATE SCA_NOTAS_FALTAS SET " & sqlUpdateRNT & " WHERE CODIGO=" & codNotaRNT
                cnn.Execute sqlRNT
                GravarLog sqlRNT
                GravarLog "RECALCULO AUTOMATICO - COD_ALUNO=" & codAlunoRNT & "; COD_NOTA=" & codNotaRNT & "; COD_DISCIPLINA=" & codDisciplinaAtualRNT
            End If
        End If

        Next
    End If

    Set rsNotaRNT = Nothing
    Set rsMERNT = Nothing
    Set rsCalcRNT = Nothing
    Set rsAlunoRNT = Nothing
End Sub
' Mantem compatibilidade com as chamadas existentes.
Sub RecalcularNotasTurma(intEmpresaRNT, intTurmaRNT, intCursoRNT, intPeriodoRNT, intAnoRNT, intSemestreRNT, intDisciplinaRNT)
    Call RNT_RecalcularNotasTurmaCore(intEmpresaRNT, intTurmaRNT, intCursoRNT, intPeriodoRNT, intAnoRNT, intSemestreRNT, intDisciplinaRNT, "")
End Sub

' Nova chamada para a tela administrativa.
' strAlunosRNT = lista CSV dos COD_ALUNO selecionados.
' intDisciplinaRNT > 0 = somente uma disciplina.
' intDisciplinaRNT = 0 = todas as disciplinas dos alunos selecionados.
Sub RecalcularNotasTurmaAlunos(intEmpresaRNT, intTurmaRNT, intCursoRNT, intPeriodoRNT, intAnoRNT, intSemestreRNT, intDisciplinaRNT, strAlunosRNT)
    Dim listaSeguraRNT
    listaSeguraRNT = RNT_SomenteNumerosCSV(strAlunosRNT)
    If listaSeguraRNT <> "" Then
        Call RNT_RecalcularNotasTurmaCore(intEmpresaRNT, intTurmaRNT, intCursoRNT, intPeriodoRNT, intAnoRNT, intSemestreRNT, intDisciplinaRNT, listaSeguraRNT)
    End If
End Sub

%>