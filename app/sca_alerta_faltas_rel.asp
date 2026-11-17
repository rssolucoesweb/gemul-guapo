<%
Response.Expires = 0
Response.Buffer = True
Session.Timeout = 1200
Server.ScriptTimeout = 1200

Function SomenteNumerosSerie(valor)
    Dim texto, i, ch
    texto = UCase(Trim(CStr(valor)))

    For i = 1 To Len(texto)
        ch = Mid(texto, i, 1)
        If ch >= "0" And ch <= "9" Then
            SomenteNumerosSerie = CInt(ch)
            Exit Function
        End If
    Next

    SomenteNumerosSerie = 0
End Function

%>

<html>
<head>
    <title>GEMUL - Alerta de faltas</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">

    <style type="text/css">
        body {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 11px;
            color: #000;
        }

        .documento-alerta {
            width: 98%;
            margin: 0 auto;
        }

        .titulo-alerta {
            font-size: 15px;
            font-weight: bold;
            text-align: center;
            margin: 10px 0 18px 0;
        }

        .dados-alerta {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 18px;
        }

        .dados-alerta td {
            border: 1px solid #999;
            padding: 6px;
        }

        .texto-alerta {
            font-size: 12px;
            line-height: 1.65;
            text-align: justify;
            margin: 20px 5px;
        }

        .comprovante {
            margin-top: 40px;
            border-top: 1px solid #999;
            padding-top: 14px;
        }

        .assinatura {
            width: 320px;
            border-top: 1px solid #000;
            text-align: center;
            margin: 70px 0 0 auto;
            padding-top: 4px;
        }

        .quebra-pagina {
            page-break-after: always;
        }

        @media print {
            .nao-imprimir {
                display: none !important;
            }
        }
    </style>

    <script src="js/js_funcoes_gerais.js"></script>
</head>

<body>
<% 
strPaginaDestino = "Fechar" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->

<%
Function Html(valor)
    If IsNull(valor) Then
        Html = ""
    Else
        Html = Server.HTMLEncode(CStr(valor))
    End If
End Function

Function PrimeiroNumero(valor)
    Dim texto, i, ch
    texto = UCase(Trim(CStr(valor)))

    For i = 1 To Len(texto)
        ch = Mid(texto, i, 1)
        If ch >= "0" And ch <= "9" Then
            PrimeiroNumero = CInt(ch)
            Exit Function
        End If
    Next

    PrimeiroNumero = 0
End Function

strAnoLetivo = Trim(Request("txtAnoLetivo"))
If strAnoLetivo = "" Then strAnoLetivo = Session("strAnoLetivo")

intCodTurma = Trim(Request("cmbTurma"))
If intCodTurma = "" Then intCodTurma = "0"

intCodCurso = Trim(Request("cmbCurso"))
If intCodCurso = "" Then intCodCurso = "0"

strAlunos = Trim(Request("chkAluno"))

If strAlunos = "" Then
%>
    <script>
        alert("Nenhum aluno foi selecionado.");
        window.close();
    </script>
<%
    Response.End
End If

' Segurança básica: mantém somente números e vírgulas.
For i = 1 To Len(strAlunos)
    ch = Mid(strAlunos, i, 1)
    If Not ((ch >= "0" And ch <= "9") Or ch = "," Or ch = " ") Then
        Response.Write("Parâmetro de aluno inválido.")
        Response.End
    End If
Next

'------------------------------------------------------------------------------
' Dados da turma / série.
'------------------------------------------------------------------------------

strPeriodo = ""
strNomeTurma = ""
strTurmaAluno = ""
strDescTurno = ""
intAnoTurma = 0

sql = " SELECT TU.NomeTurma, TU.TurmaAluno, TU.AnoLetivo, TU.AnoLetivo, " & _
      "        T.Desc_Turno, P.Descricao AS Periodo, P.Cod_Curso " & _
      " FROM SCA_TURMA TU " & _
      " INNER JOIN SCA_GRADECURRICULAR G " & _
      "     ON G.Cod_GradeCurricular = TU.Cod_GradeCurricular " & _
      " INNER JOIN SCA_PERIODO P " & _
      "     ON P.Cod_Periodo = G.Cod_Periodo " & _
      " INNER JOIN SCA_TURNO T " & _
      "     ON T.Cod_Turno = TU.Cod_Turno " & _
      " WHERE TU.Cod_Empresa = " & CLng(Session("CodEmpresa")) & _
      "   AND TU.Cod_Turma = " & CLng(intCodTurma)

rs.Open sql, cnn

If Not rs.EOF Then
    strPeriodo = Trim("" & rs("Periodo"))
    strNomeTurma = Trim("" & rs("NomeTurma"))
    strTurmaAluno = Trim("" & rs("TurmaAluno"))
    strDescTurno = Trim("" & rs("Desc_Turno"))
    intCodCurso = CLng(rs("Cod_Curso"))

    If Not IsNull(rs("AnoLetivo")) Then
        If IsNumeric(rs("AnoLetivo")) Then intAnoTurma = CInt(rs("AnoLetivo"))
    End If
End If

rs.Close

'------------------------------------------------------------------------------
' Busca os alunos selecionados.
'------------------------------------------------------------------------------

sql = " SELECT A.Codigo, A.Matricula, A.NomeAluno " & _
      " FROM SCA_ALUNO A " & _
      " WHERE A.Codigo IN (" & strAlunos & ") " & _
      " ORDER BY A.NomeAluno "

rs.Open sql, cnn

If rs.EOF Then
    rs.Close
    Response.Write("Nenhum aluno encontrado.")
    Response.End
End If

vetAlunos = rs.GetRows()
rs.Close

'------------------------------------------------------------------------------
' Regra de contagem por etapa:
'   - Educação Infantil ao 5º ano: 1 falta por aluno/data.
'   - 6º ao 9º ano: 1 falta por aluno/data/disciplina.
' Justificativa:
'   - Utiliza SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA.
'   - Até o 5º ano: considera aluno + DataFalta.
'   - 6º ao 9º ano: considera aluno + DataFalta + cod_disciplina.
'------------------------------------------------------------------------------
serieContagemFaltas = SomenteNumerosSerie(strPeriodo)
If CLng(intCodCurso) = 4 Then serieContagemFaltas = 0	'Guapó: curso 4 = EJA ("1º ANO EJA" não é 1º ano do fundamental)

'------------------------------------------------------------------------------
' Carrega os totais anuais de faltas de todos os alunos selecionados.
'------------------------------------------------------------------------------

Set dicTotalFaltas = Server.CreateObject("Scripting.Dictionary")
Set dicJustificadas = Server.CreateObject("Scripting.Dictionary")


strChaveDisciplinaFalta = "0"
If serieContagemFaltas >= 6 And serieContagemFaltas <= 9 Then
    strChaveDisciplinaFalta = "ISNULL(F.cod_disciplina, 0)"
End If

sql = " WITH FaltasContagem AS ( " & _
              "     SELECT DISTINCT " & _
              "         F.cod_empresa, " & _
              "         F.ano_letivo, " & _
              "         F.cod_aluno, " & _
              "         CAST(F.data AS DATE) AS data_falta, " & _
              "         " & strChaveDisciplinaFalta & " AS chave_disciplina " & _
              "     FROM SCA_FALTAS_DIARIA F " & _
              "     WHERE F.cod_empresa = " & CLng(Session("CodEmpresa")) & _
              "       AND F.ano_letivo = " & CLng(strAnoLetivo) & _
              "       AND F.cod_aluno IN (" & strAlunos & ") " & _
              " ) " & _
              " SELECT " & _
              "     F.cod_aluno, " & _
              "     COUNT(*) AS TotalFaltas, " & _
              "     SUM(CASE WHEN JF.Justificada = 1 THEN 1 ELSE 0 END) AS FaltasJustificadas " & _
              " FROM FaltasContagem F " & _
              " OUTER APPLY ( " & _
              "     SELECT TOP (1) 1 AS Justificada " & _
              "     FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA J " & _
              "     WHERE J.cod_aluno = F.cod_aluno " & _
              "       AND J.DataFalta = F.data_falta " & _
              "       AND ( " & _
              "            F.chave_disciplina = 0 " & _
              "            OR ISNULL(J.cod_disciplina, 0) = F.chave_disciplina " & _
              "       ) " & _
              " ) JF " & _
              " GROUP BY F.cod_aluno "
			  rs.Open sql, cnn

Do While Not rs.EOF
    dicTotalFaltas(CStr(rs("cod_aluno"))) = CLng(rs("TotalFaltas"))
    dicJustificadas(CStr(rs("cod_aluno"))) = CLng(rs("FaltasJustificadas"))
    rs.MoveNext
Loop

rs.Close

totalAlunos = UBound(vetAlunos, 2)

For i = 0 To totalAlunos

    codAluno = CLng(vetAlunos(0, i))
    matricula = vetAlunos(1, i)
    nomeAluno = vetAlunos(2, i)

    totalFaltas = 0
    faltasJustificadas = 0

    If dicTotalFaltas.Exists(CStr(codAluno)) Then
        totalFaltas = CLng(dicTotalFaltas(CStr(codAluno)))
    End If

    If dicJustificadas.Exists(CStr(codAluno)) Then
        faltasJustificadas = CLng(dicJustificadas(CStr(codAluno)))
    End If

    strTexto1 = ""
    strTexto2 = ""
    strModalidade = ""
	serieAluno = SomenteNumerosSerie(strPeriodo)
	If CLng(intCodCurso) = 4 Then serieAluno = 0	'Guapó: curso 4 = EJA
	
    If CLng(intCodCurso) = 1 Then

        strModalidade = "Educação Infantil"

        strTexto1 = "O(A) aluno(a) " & Html(nomeAluno) & _
                    " está com um total de <strong>" & totalFaltas & _
                    " falta(s)</strong>, sendo destas <strong>" & faltasJustificadas & _
                    " justificada(s)</strong>, o que poderá acarretar o desligamento da criança e a perda da vaga."

        strTexto2 = "Ocorrendo o desligamento por infrequência, a vaga poderá ser destinada a outra criança/família " & _
                    "que esteja aguardando atendimento na lista de espera.<br><br>" & _
                    "Verificar junto à secretaria da Unidade Escolar."

    ElseIf serieAluno >= 1 And serieAluno <= 2 Then

        strModalidade = "Ensino Fundamental - Anos Iniciais (1º e 2º anos)"

        strTexto1 = "O(A) aluno(a) " & Html(nomeAluno) & _
                    " está com um total de <strong>" & totalFaltas & _
                    " falta(s)</strong>, sendo destas <strong>" & faltasJustificadas & _
                    " justificada(s)</strong>, o que poderá acarretar o desligamento do estudante e a perda da vaga."

        strTexto2 = "Ocorrendo o desligamento por infrequência, a vaga poderá ser destinada a outro estudante/família " & _
                    "que esteja aguardando atendimento na lista de espera.<br><br>" & _
                    "Verificar junto à secretaria da Unidade Escolar."

    Else

        If serieAluno >= 3 And serieAluno <= 5 Then
            strModalidade = "Ensino Fundamental - Anos Iniciais (3º ao 5º anos)"
        ElseIf serieAluno >= 6 And serieAluno <= 9 Then
            strModalidade = "Ensino Fundamental - Anos Finais (6º ao 9º anos)"
        Else
            strModalidade = strPeriodo
        End If

        strTexto1 = "O(A) aluno(a) " & Html(nomeAluno) & _
                    " está com um total de <strong>" & totalFaltas & _
                    " falta(s)</strong>, sendo destas <strong>" & faltasJustificadas & _
                    " justificada(s)</strong>, podendo acarretar uma possível reprovação."

        strTexto2 = "Verificar junto à secretaria da Unidade Escolar."

    End If
%>

<div class="documento-alerta">

    <!-- Reaproveita o cabeçalho oficial já utilizado pelos relatórios GEMUL -->
    <!--#include file="includes/inc_cabecalhoRelatorio.asp"-->

    <div class="titulo-alerta">
        ALERTA DE FALTAS
    </div>

    <table class="dados-alerta">
        <tr>
            <td width="20%"><strong>Ano Letivo:</strong></td>
            <td width="30%"><%=Html(strAnoLetivo)%></td>

            <td width="20%"><strong>Turno:</strong></td>
            <td width="30%"><%=Html(strDescTurno)%></td>
        </tr>

        <tr>
            <td><strong>Série:</strong></td>
            <td colspan="3">
                <%=Html(strPeriodo)%>
                <% If strTurmaAluno <> "" Then %> - <%=Html(strTurmaAluno)%><% End If %>
                <% If strNomeTurma <> "" Then %> - <%=Html(strNomeTurma)%><% End If %>
            </td>
        </tr>

        <tr>
            <td><strong>Matrícula:</strong></td>
            <td><%=Html(matricula)%></td>

            <td><strong>Curso:</strong></td>
            <td><%=Html(strModalidade)%></td>
        </tr>

        <tr>
            <td><strong>Aluno:</strong></td>
            <td colspan="3"><strong><%=Html(nomeAluno)%></strong></td>
        </tr>
    </table>

    <div class="texto-alerta">
        <%=strTexto1%>
        <br><br>
        <%=strTexto2%>
    </div>

    <div class="comprovante">
        <div style="text-align:center; font-weight:bold; margin-bottom:22px;">
            COMPROVANTE DE RECEBIMENTO - ALERTA DE FALTAS
        </div>

        <table width="100%" border="0" cellspacing="0" cellpadding="4">
            <tr>
                <td width="18%"><strong>Matrícula:</strong></td>
                <td><%=Html(matricula)%></td>
            </tr>
            <tr>
                <td><strong>Aluno:</strong></td>
                <td><%=Html(nomeAluno)%></td>
            </tr>
            <tr>
                <td><strong>Período:</strong></td>
                <td>
                    <%=Html(strPeriodo)%>
                    <% If strTurmaAluno <> "" Then %> - <%=Html(strTurmaAluno)%><% End If %>
                </td>
            </tr>
			<tr>
                <td><strong>Recebimento:</strong></td>
                <td>
                    _____/_____/_______
                </td>
            </tr>
        </table>

        <div class="assinatura">
            Responsável
        </div>
    </div>

</div>

<%
    If i < totalAlunos Then
%>
    <div class="quebra-pagina"></div>
<%
    End If

Next
%>

</body>
</html>
