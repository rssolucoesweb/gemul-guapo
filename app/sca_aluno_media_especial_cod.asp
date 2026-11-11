<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/inc_cnn.asp"-->
<%

Function NumeroSeguro(valor, padrao)
    If IsNumeric(valor) Then
        NumeroSeguro = CLng(valor)
    Else
        NumeroSeguro = CLng(padrao)
    End If
End Function

Function SqlTexto(valor)
    SqlTexto = Replace(CStr(valor), "'", "''")
End Function

Dim codEmpresa, codAluno, codTurma, anoLetivo, semestre, codPeriodo
Dim usuario, sql, i, valor, partes, codDisciplina, codCalculo
Dim rsValida, rsExiste, rsCalcLimpa, posicaoBimestre, posicaoCalc, campoNota, setLimpeza, configuracaoJaExiste

codEmpresa = NumeroSeguro(Session("CodEmpresa"), 0)
codAluno   = NumeroSeguro(Request.Form("codAluno"), 0)
codTurma   = NumeroSeguro(Request.Form("codTurma"), 0)
anoLetivo  = NumeroSeguro(Request.Form("anoLetivo"), 0)
semestre   = NumeroSeguro(Request.Form("semestre"), 0)
codPeriodo = NumeroSeguro(Request.Form("codPeriodo"), 0)
usuario    = SqlTexto(Session("usuarioWeb"))

If codEmpresa = 0 Or codAluno = 0 Or codTurma = 0 Or anoLetivo = 0 Or semestre = 0 Or codPeriodo = 0 Then
    Response.Write "<script>alert('Parâmetros inválidos. A configuração não foi salva.');history.back();</script>"
    Response.End
End If

On Error Resume Next
cnn.BeginTrans

'Exclui somente as configurações de bimestre (tipo de cálculo 1 / lançamentos 1 a 4)
'deste aluno, ano, semestre e período. Outros tipos de média especial são preservados.
sql = " DELETE ME FROM SCA_ALUNO_MEDIA_ESPECIAL ME " & _
      " INNER JOIN SCA_CALCULO C ON C.codigo = ME.COD_CALCULO " & _
      " WHERE ME.COD_EMPRESA = " & codEmpresa & _
      " AND ME.COD_ALUNO = " & codAluno & _
      " AND ME.ANO_LETIVO = " & anoLetivo & _
      " AND ME.SEMESTRE = " & semestre & _
      " AND ME.COD_PERIODO = " & codPeriodo & _
      " AND C.cod_tipo_calculo = 1 " & _
      " AND C.cod_tipo_lancamento IN (1,2,3,4) "
cnn.Execute sql

If Err.Number = 0 Then
    For i = 1 To Request.Form("chkMedia").Count
        valor = Request.Form("chkMedia")(i)
        partes = Split(valor, "|")
        If UBound(partes) = 1 Then
            codDisciplina = NumeroSeguro(partes(0), 0)
            codCalculo = NumeroSeguro(partes(1), 0)

            If codDisciplina > 0 And codCalculo > 0 Then
                'Valida disciplina do aluno/turma e cálculo permitido antes de inserir.
                Set rsValida = Server.CreateObject("ADODB.Recordset")
                sql = " SELECT TOP 1 AD.CODIGO " & _
                      " FROM SCA_ALUNO_DISCIPLINA AD " & _
                      " INNER JOIN SCA_CALCULO C ON C.codigo = " & codCalculo & _
                      " WHERE AD.COD_EMPRESA = " & codEmpresa & _
                      " AND AD.COD_ALUNO = " & codAluno & _
                      " AND AD.COD_DISCIPLINA = " & codDisciplina & _
                      " AND (AD.COD_TURMA = " & codTurma & " OR AD.COD_TURMA_REMANEJAMENTO = " & codTurma & ") " & _
                      " AND C.cod_tipo_calculo = 1 " & _
                      " AND C.cod_tipo_lancamento IN (1,2,3,4) "
                rsValida.Open sql, cnn
                If Not rsValida.EOF Then
                    'Verifica se esta configuracao ja existia antes do salvamento.
                    'A limpeza das notas deve ocorrer somente para novas marcacoes.
                    configuracaoJaExiste = False
                    Set rsExiste = Server.CreateObject("ADODB.Recordset")
                    sql = " SELECT TOP 1 ME.CODIGO " & _
                          " FROM SCA_ALUNO_MEDIA_ESPECIAL ME " & _
                          " WHERE ME.COD_EMPRESA = " & codEmpresa & _
                          " AND ME.COD_ALUNO = " & codAluno & _
                          " AND ME.ANO_LETIVO = " & anoLetivo & _
                          " AND ME.SEMESTRE = " & semestre & _
                          " AND ME.COD_PERIODO = " & codPeriodo & _
                          " AND ME.COD_DISCIPLINA = " & codDisciplina & _
                          " AND ME.COD_CALCULO = " & codCalculo
                    rsExiste.Open sql, cnn
                    If Not rsExiste.EOF Then configuracaoJaExiste = True
                    rsExiste.Close
                    Set rsExiste = Nothing

                    'IMPORTANTE: como as configuracoes antigas foram excluidas no inicio da transacao,
                    'a verificacao acima precisa considerar o estado anterior. Para isso, usamos a
                    'lista enviada pela tela em conjunto com um marcador hidden de configuracoes originais.
                    configuracaoJaExiste = (InStr(1, "," & Request.Form("configOriginais") & ",", "," & codDisciplina & "|" & codCalculo & ",", vbTextCompare) > 0)

                    If Not configuracaoJaExiste Then
                        'Descobre dinamicamente a posicao do bimestre marcado (ex.: 54 -> posicao 3 -> nota03).
                        posicaoBimestre = 0
                        Set rsCalcLimpa = Server.CreateObject("ADODB.Recordset")
                        sql = " SELECT TOP 1 posicao FROM SCA_CALCULO " & _
                              " WHERE codigo = " & codCalculo & _
                              " AND cod_tipo_calculo = 1 " & _
                              " AND cod_tipo_lancamento IN (1,2,3,4) "
                        rsCalcLimpa.Open sql, cnn
                        If Not rsCalcLimpa.EOF Then posicaoBimestre = NumeroSeguro(rsCalcLimpa("posicao"), 0)
                        rsCalcLimpa.Close

                        setLimpeza = ""
                        If posicaoBimestre > 0 And posicaoBimestre <= 15 Then
                            campoNota = "nota" & Right("0" & CStr(posicaoBimestre), 2)
                            setLimpeza = campoNota & " = NULL"
                        End If

                        'Limpa tambem todas as posicoes calculadas dinamicamente (digitar=N e com formula).
                        sql = " SELECT DISTINCT posicao FROM SCA_CALCULO " & _
                              " WHERE cod_tipo_calculo = 1 " & _
                              " AND digitar = 'N' " & _
                              " AND ISNULL(LTRIM(RTRIM(formula)),'') <> '' " & _
                              " AND posicao IS NOT NULL " & _
                              " ORDER BY posicao "
                        rsCalcLimpa.Open sql, cnn
                        Do While Not rsCalcLimpa.EOF
                            posicaoCalc = NumeroSeguro(rsCalcLimpa("posicao"), 0)
                            If posicaoCalc > 0 And posicaoCalc <= 15 Then
                                campoNota = "nota" & Right("0" & CStr(posicaoCalc), 2)
                                If InStr(1, "," & Replace(setLimpeza, " = NULL", "") & ",", "," & campoNota & ",", vbTextCompare) = 0 Then
                                    If setLimpeza <> "" Then setLimpeza = setLimpeza & ", "
                                    setLimpeza = setLimpeza & campoNota & " = NULL"
                                End If
                            End If
                            rsCalcLimpa.MoveNext
                        Loop
                        rsCalcLimpa.Close
                        Set rsCalcLimpa = Nothing

                        'O campo MEDIA tambem fica invalido quando a composicao dos bimestres muda.
                        If setLimpeza <> "" Then setLimpeza = setLimpeza & ", "
                        setLimpeza = setLimpeza & "media = NULL"

                        sql = " UPDATE SCA_NOTAS_FALTAS SET " & setLimpeza & _
                              " WHERE cod_empresa = " & codEmpresa & _
                              " AND cod_aluno = " & codAluno & _
                              " AND ano_letivo = " & anoLetivo & _
                              " AND semestre = " & semestre & _
                              " AND cod_periodo = " & codPeriodo & _
                              " AND cod_disciplina = " & codDisciplina
                        cnn.Execute sql
                    End If

                    sql = " INSERT INTO SCA_ALUNO_MEDIA_ESPECIAL " & _
                          " (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,COD_PERIODO,COD_DISCIPLINA,COD_CALCULO,usuario_incl,data_hora_incl) VALUES (" & _
                          codEmpresa & "," & codAluno & "," & anoLetivo & "," & semestre & "," & codPeriodo & "," & codDisciplina & "," & codCalculo & ",'" & usuario & "',GETDATE())"
                    cnn.Execute sql
                End If
                rsValida.Close
                Set rsValida = Nothing
            End If
        End If
        If Err.Number <> 0 Then Exit For
    Next
End If

If Err.Number <> 0 Then
    Dim msgErro
    msgErro = Replace(Err.Description, "'", "")
    cnn.RollbackTrans
    On Error GoTo 0
    Response.Write "<script>alert('Erro ao salvar a configuração: " & Replace(msgErro, "\", "") & "');history.back();</script>"
    Response.End
Else
    cnn.CommitTrans
End If
On Error GoTo 0

Response.Redirect "sca_aluno_media_especial_con.asp?codAluno=" & codAluno & _
                  "&codTurma=" & codTurma & _
                  "&anoLetivo=" & anoLetivo & _
                  "&semestre=" & semestre & _
                  "&codPeriodo=" & codPeriodo & _
                  "&salvo=S"
%>
