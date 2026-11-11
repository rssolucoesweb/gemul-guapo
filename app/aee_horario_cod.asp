<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
Function InteiroOuZero(valor)
    If Trim(CStr(valor)) <> "" And IsNumeric(valor) Then
        InteiroOuZero = CLng(valor)
    Else
        InteiroOuZero = 0
    End If
End Function

Sub FinalizarComErro(mensagem)
    If cnn.Errors.Count >= 0 Then
        On Error Resume Next
        cnn.RollbackTrans
        On Error GoTo 0
    End If
    mensagem = Replace(mensagem, "\", "\\")
    mensagem = Replace(mensagem, "'", "\'")
    mensagem = Replace(mensagem, vbCrLf, "\n")
    mensagem = Replace(mensagem, vbCr, "\n")
    mensagem = Replace(mensagem, vbLf, "\n")
    Response.Write "<script>alert('" & mensagem & "');history.back();</script>"
    Response.End
End Sub

acao = UCase(Trim(Request.QueryString("acao")))
intCodigo = InteiroOuZero(Request.Form("txtCodigo"))
intCodEmpresa = InteiroOuZero(Session("CodEmpresa"))
intAnoLetivo = InteiroOuZero(Request.Form("txtAnoLetivo"))
intSemestre = InteiroOuZero(Request.Form("cmbSemestre"))
intCodTurno = InteiroOuZero(Request.Form("cmbTurno"))
intHoraInicio = InteiroOuZero(Request.Form("txtHoraInicio"))
intMinutoInicio = InteiroOuZero(Request.Form("txtMinutoInicio"))
intHoraTermino = InteiroOuZero(Request.Form("txtHoraTermino"))
intMinutoTermino = InteiroOuZero(Request.Form("txtMinutoTermino"))

If intCodEmpresa <= 0 Then
    Response.Write "<script>alert('Empresa não identificada na sessão.');history.back();</script>"
    Response.End
End If

On Error Resume Next
cnn.BeginTrans

If acao = "I" Or acao = "A" Then
    If intAnoLetivo < 2000 Or intAnoLetivo > 2100 Then Call FinalizarComErro("Informe um ano letivo válido.")
    If intSemestre <> 1 And intSemestre <> 2 And intSemestre <> 3 Then Call FinalizarComErro("Informe o semestre.")
    If intCodTurno <= 0 Then Call FinalizarComErro("Informe o turno.")
    If intHoraInicio < 0 Or intHoraInicio > 23 Then Call FinalizarComErro("Hora inicial inválida.")
    If intMinutoInicio < 0 Or intMinutoInicio > 59 Then Call FinalizarComErro("Minuto inicial inválido.")
    If intHoraTermino < 0 Or intHoraTermino > 23 Then Call FinalizarComErro("Hora de término inválida.")
    If intMinutoTermino < 0 Or intMinutoTermino > 59 Then Call FinalizarComErro("Minuto de término inválido.")

    intInicioTotal = (intHoraInicio * 60) + intMinutoInicio
    intTerminoTotal = (intHoraTermino * 60) + intMinutoTermino
    If intTerminoTotal <= intInicioTotal Then Call FinalizarComErro("O horário de término deve ser maior que o horário inicial.")

    ' Impede duplicidade do mesmo horário no mesmo ano/semestre/turno.
    sqlVerifica = "SELECT COUNT(*) AS qtde FROM AEE_HORARIO "
    sqlVerifica = sqlVerifica & "WHERE cod_empresa = " & intCodEmpresa
    sqlVerifica = sqlVerifica & " AND anoLetivo = " & intAnoLetivo
    sqlVerifica = sqlVerifica & " AND semestre = " & intSemestre
    sqlVerifica = sqlVerifica & " AND Cod_Turno = " & intCodTurno
    sqlVerifica = sqlVerifica & " AND hora_Inicio = " & intHoraInicio
    sqlVerifica = sqlVerifica & " AND minuto_Inicio = " & intMinutoInicio
    sqlVerifica = sqlVerifica & " AND hora_termino = " & intHoraTermino
    sqlVerifica = sqlVerifica & " AND minuto_termino = " & intMinutoTermino
    If acao = "A" Then sqlVerifica = sqlVerifica & " AND cod_horario <> " & intCodigo

    Set rsVerifica = Server.CreateObject("ADODB.Recordset")
    rsVerifica.Open sqlVerifica, cnn
    qtdeDuplicado = rsVerifica("qtde")
    rsVerifica.Close
    Set rsVerifica = Nothing

    If qtdeDuplicado > 0 Then Call FinalizarComErro("Este horário já está cadastrado para o ano, semestre e turno informados.")
End If

If acao = "I" Then
    sql = "INSERT INTO AEE_HORARIO (cod_empresa, anoLetivo, semestre, hora_Inicio, minuto_Inicio, hora_termino, minuto_termino, Cod_Turno) VALUES ("
    sql = sql & intCodEmpresa & ","
    sql = sql & intAnoLetivo & ","
    sql = sql & intSemestre & ","
    sql = sql & intHoraInicio & ","
    sql = sql & intMinutoInicio & ","
    sql = sql & intHoraTermino & ","
    sql = sql & intMinutoTermino & ","
    sql = sql & intCodTurno & ")"

    GravarLog sql
    cnn.Execute sql
    strMensagem = "Horário cadastrado com sucesso!"

ElseIf acao = "A" Then
    If intCodigo <= 0 Then Call FinalizarComErro("Horário não identificado para alteração.")

    sql = "UPDATE AEE_HORARIO SET "
    sql = sql & "anoLetivo = " & intAnoLetivo & ","
    sql = sql & "semestre = " & intSemestre & ","
    sql = sql & "hora_Inicio = " & intHoraInicio & ","
    sql = sql & "minuto_Inicio = " & intMinutoInicio & ","
    sql = sql & "hora_termino = " & intHoraTermino & ","
    sql = sql & "minuto_termino = " & intMinutoTermino & ","
    sql = sql & "Cod_Turno = " & intCodTurno & " "
    sql = sql & "WHERE cod_horario = " & intCodigo & " "
    sql = sql & "AND cod_empresa = " & intCodEmpresa

    GravarLog sql
    cnn.Execute sql
    strMensagem = "Horário alterado com sucesso!"

ElseIf acao = "E" Then
    If intCodigo <= 0 Then Call FinalizarComErro("Horário não identificado para exclusão.")

    sql = "DELETE FROM AEE_HORARIO WHERE cod_horario = " & intCodigo & " AND cod_empresa = " & intCodEmpresa
    GravarLog sql
    cnn.Execute sql
    strMensagem = "Horário excluído com sucesso!"

ElseIf acao = "P" Then
    ' Gera automaticamente os 4 horários do Matutino e os 4 horários do Vespertino.
    ' O código do turno é localizado pela descrição, evitando hardcode de Cod_Turno.
    Set rsTurno = Server.CreateObject("ADODB.Recordset")

    sqlTurno = "SELECT TOP 1 Cod_Turno FROM SCA_TURNO WHERE UPPER(LTRIM(RTRIM(DESC_TURNO))) LIKE 'MATUTINO%' ORDER BY Cod_Turno"
    rsTurno.Open sqlTurno, cnn
    If rsTurno.EOF Then
        rsTurno.Close
        Set rsTurno = Nothing
        Call FinalizarComErro("Turno Matutino não encontrado na tabela SCA_TURNO.")
    End If
    intTurnoMatutino = CLng(rsTurno("Cod_Turno"))
    rsTurno.Close

    sqlTurno = "SELECT TOP 1 Cod_Turno FROM SCA_TURNO WHERE UPPER(LTRIM(RTRIM(DESC_TURNO))) LIKE 'VESPERTINO%' ORDER BY Cod_Turno"
    rsTurno.Open sqlTurno, cnn
    If rsTurno.EOF Then
        rsTurno.Close
        Set rsTurno = Nothing
        Call FinalizarComErro("Turno Vespertino não encontrado na tabela SCA_TURNO.")
    End If
    intTurnoVespertino = CLng(rsTurno("Cod_Turno"))
    rsTurno.Close
    Set rsTurno = Nothing

    If intAnoLetivo < 2000 Or intAnoLetivo > 2100 Then Call FinalizarComErro("Informe um ano letivo válido para gerar os horários padrão.")
    If intSemestre <> 1 And intSemestre <> 2 And intSemestre <> 3 Then Call FinalizarComErro("Informe o semestre para gerar os horários padrão.")

    sql = ""
    sql = sql & "IF NOT EXISTS (SELECT 1 FROM AEE_HORARIO WHERE cod_empresa=" & intCodEmpresa & " AND anoLetivo=" & intAnoLetivo & " AND semestre=" & intSemestre & " AND Cod_Turno=" & intTurnoMatutino & " AND hora_Inicio=7 AND minuto_Inicio=15 AND hora_termino=8 AND minuto_termino=0) INSERT INTO AEE_HORARIO (cod_empresa,anoLetivo,semestre,hora_Inicio,minuto_Inicio,hora_termino,minuto_termino,Cod_Turno) VALUES (" & intCodEmpresa & "," & intAnoLetivo & "," & intSemestre & ",7,15,8,0," & intTurnoMatutino & ");"
    sql = sql & "IF NOT EXISTS (SELECT 1 FROM AEE_HORARIO WHERE cod_empresa=" & intCodEmpresa & " AND anoLetivo=" & intAnoLetivo & " AND semestre=" & intSemestre & " AND Cod_Turno=" & intTurnoMatutino & " AND hora_Inicio=8 AND minuto_Inicio=15 AND hora_termino=9 AND minuto_termino=0) INSERT INTO AEE_HORARIO (cod_empresa,anoLetivo,semestre,hora_Inicio,minuto_Inicio,hora_termino,minuto_termino,Cod_Turno) VALUES (" & intCodEmpresa & "," & intAnoLetivo & "," & intSemestre & ",8,15,9,0," & intTurnoMatutino & ");"
    sql = sql & "IF NOT EXISTS (SELECT 1 FROM AEE_HORARIO WHERE cod_empresa=" & intCodEmpresa & " AND anoLetivo=" & intAnoLetivo & " AND semestre=" & intSemestre & " AND Cod_Turno=" & intTurnoMatutino & " AND hora_Inicio=9 AND minuto_Inicio=15 AND hora_termino=10 AND minuto_termino=0) INSERT INTO AEE_HORARIO (cod_empresa,anoLetivo,semestre,hora_Inicio,minuto_Inicio,hora_termino,minuto_termino,Cod_Turno) VALUES (" & intCodEmpresa & "," & intAnoLetivo & "," & intSemestre & ",9,15,10,0," & intTurnoMatutino & ");"
    sql = sql & "IF NOT EXISTS (SELECT 1 FROM AEE_HORARIO WHERE cod_empresa=" & intCodEmpresa & " AND anoLetivo=" & intAnoLetivo & " AND semestre=" & intSemestre & " AND Cod_Turno=" & intTurnoMatutino & " AND hora_Inicio=10 AND minuto_Inicio=15 AND hora_termino=11 AND minuto_termino=0) INSERT INTO AEE_HORARIO (cod_empresa,anoLetivo,semestre,hora_Inicio,minuto_Inicio,hora_termino,minuto_termino,Cod_Turno) VALUES (" & intCodEmpresa & "," & intAnoLetivo & "," & intSemestre & ",10,15,11,0," & intTurnoMatutino & ");"
    sql = sql & "IF NOT EXISTS (SELECT 1 FROM AEE_HORARIO WHERE cod_empresa=" & intCodEmpresa & " AND anoLetivo=" & intAnoLetivo & " AND semestre=" & intSemestre & " AND Cod_Turno=" & intTurnoVespertino & " AND hora_Inicio=13 AND minuto_Inicio=15 AND hora_termino=14 AND minuto_termino=0) INSERT INTO AEE_HORARIO (cod_empresa,anoLetivo,semestre,hora_Inicio,minuto_Inicio,hora_termino,minuto_termino,Cod_Turno) VALUES (" & intCodEmpresa & "," & intAnoLetivo & "," & intSemestre & ",13,15,14,0," & intTurnoVespertino & ");"
    sql = sql & "IF NOT EXISTS (SELECT 1 FROM AEE_HORARIO WHERE cod_empresa=" & intCodEmpresa & " AND anoLetivo=" & intAnoLetivo & " AND semestre=" & intSemestre & " AND Cod_Turno=" & intTurnoVespertino & " AND hora_Inicio=14 AND minuto_Inicio=15 AND hora_termino=15 AND minuto_termino=0) INSERT INTO AEE_HORARIO (cod_empresa,anoLetivo,semestre,hora_Inicio,minuto_Inicio,hora_termino,minuto_termino,Cod_Turno) VALUES (" & intCodEmpresa & "," & intAnoLetivo & "," & intSemestre & ",14,15,15,0," & intTurnoVespertino & ");"
    sql = sql & "IF NOT EXISTS (SELECT 1 FROM AEE_HORARIO WHERE cod_empresa=" & intCodEmpresa & " AND anoLetivo=" & intAnoLetivo & " AND semestre=" & intSemestre & " AND Cod_Turno=" & intTurnoVespertino & " AND hora_Inicio=15 AND minuto_Inicio=15 AND hora_termino=16 AND minuto_termino=0) INSERT INTO AEE_HORARIO (cod_empresa,anoLetivo,semestre,hora_Inicio,minuto_Inicio,hora_termino,minuto_termino,Cod_Turno) VALUES (" & intCodEmpresa & "," & intAnoLetivo & "," & intSemestre & ",15,15,16,0," & intTurnoVespertino & ");"
    sql = sql & "IF NOT EXISTS (SELECT 1 FROM AEE_HORARIO WHERE cod_empresa=" & intCodEmpresa & " AND anoLetivo=" & intAnoLetivo & " AND semestre=" & intSemestre & " AND Cod_Turno=" & intTurnoVespertino & " AND hora_Inicio=16 AND minuto_Inicio=15 AND hora_termino=17 AND minuto_termino=0) INSERT INTO AEE_HORARIO (cod_empresa,anoLetivo,semestre,hora_Inicio,minuto_Inicio,hora_termino,minuto_termino,Cod_Turno) VALUES (" & intCodEmpresa & "," & intAnoLetivo & "," & intSemestre & ",16,15,17,0," & intTurnoVespertino & ");"

    GravarLog sql
    cnn.Execute sql
    strMensagem = "Horários padrão cadastrados com sucesso! Registros já existentes foram mantidos."
Else
    Call FinalizarComErro("Ação inválida.")
End If

If Err.Number <> 0 Then
    strErro = Err.Description
    Err.Clear
    Call FinalizarComErro(strErro)
End If

cnn.CommitTrans
On Error GoTo 0

strMensagem = Replace(strMensagem, "'", "\'")
Response.Write "<script>alert('" & strMensagem & "');window.location='aee_horario.asp';</script>"
%>
