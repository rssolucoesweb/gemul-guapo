<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"

Function InteiroOuZero(valor)
    If Trim(CStr(valor)) <> "" And IsNumeric(valor) Then
        InteiroOuZero = CLng(valor)
    Else
        InteiroOuZero = 0
    End If
End Function

Function SqlTexto(valor)
    SqlTexto = Replace(Trim(CStr(valor)), "'", "''")
End Function

Sub FinalizarComErro(mensagem)
    On Error Resume Next
    cnn.RollbackTrans
    On Error GoTo 0
    mensagem = Replace(mensagem, "'", "\'")
    Response.Write "<script>alert('" & mensagem & "');history.back();</script>"
    Response.End
End Sub

acao = UCase(Trim(Request.QueryString("acao")))
intCodigo = InteiroOuZero(Request.Form("txtCodigo"))
intCodConsultorio = InteiroOuZero(Request.Form("cmbConsultorio"))
intCodProfissional = InteiroOuZero(Request.Form("cmbProfissional"))
intCodEmpresa = InteiroOuZero(Session("CodEmpresa"))
intAnoLetivo = InteiroOuZero(Request.Form("txtAnoLetivo"))
intSemestre = InteiroOuZero(Request.Form("cmbSemestre"))
strUsuario = SqlTexto(Session("usuarioWeb"))
strHorarios = Trim(Request.Form("chkHorario"))

If intCodEmpresa <= 0 Then
    Response.Write "<script>alert('Empresa não identificada na sessão.');history.back();</script>"
    Response.End
End If

On Error Resume Next
cnn.BeginTrans
If Err.Number <> 0 Then
    strErro = Err.Description
    Err.Clear
    On Error GoTo 0
    Response.Write "<script>alert('" & Replace(strErro, "'", "\'") & "');history.back();</script>"
    Response.End
End If
On Error GoTo 0

If acao = "I" Or acao = "A" Then
    If intAnoLetivo < 2000 Or intAnoLetivo > 2100 Then Call FinalizarComErro("O Ano Letivo deve ser informado corretamente!")
    If intSemestre <> 1 And intSemestre <> 2  And intSemestre <> 3 Then Call FinalizarComErro("O Semestre deve ser informado!")
    If intCodConsultorio <= 0 Then Call FinalizarComErro("O consultório deve ser informado!")
    If intCodProfissional <= 0 Then Call FinalizarComErro("O profissional deve ser informado!")
    If strHorarios = "" Then Call FinalizarComErro("Selecione pelo menos um horário de atendimento!")

    arrHorarios = Split(strHorarios, ",")

    If acao = "A" And UBound(arrHorarios) <> 0 Then
        Call FinalizarComErro("Para alterar um vínculo, selecione somente um horário de atendimento!")
    End If

    ' Valida se o consultório pertence à empresa e ao ano letivo informado.
    sqlVerifica = "SELECT COUNT(*) AS qtde FROM AEE_CONSULTORIO "
    sqlVerifica = sqlVerifica & "WHERE Cod_Consultorio = " & intCodConsultorio & " "
    sqlVerifica = sqlVerifica & "AND Cod_Empresa = " & intCodEmpresa & " "
    sqlVerifica = sqlVerifica & "AND AnoLetivo = " & intAnoLetivo

    Set rsVerifica = Server.CreateObject("ADODB.Recordset")
    rsVerifica.Open sqlVerifica, cnn
    qtde = rsVerifica("qtde")
    rsVerifica.Close

    If qtde = 0 Then
        Set rsVerifica = Nothing
        Call FinalizarComErro("Consultório inválido para a empresa/ano letivo informado.")
    End If

    ' Valida se o profissional existe.
    sqlVerifica = "SELECT COUNT(*) AS qtde FROM AEE_PROFISSIONAL WHERE Cod_Profissional = " & intCodProfissional
    rsVerifica.Open sqlVerifica, cnn
    qtde = rsVerifica("qtde")
    rsVerifica.Close

    If qtde = 0 Then
        Set rsVerifica = Nothing
        Call FinalizarComErro("Profissional inválido.")
    End If

    ' Valida cada horário selecionado antes de efetuar qualquer inclusão/alteração.
    For i = 0 To UBound(arrHorarios)
        intCodHorario = InteiroOuZero(Trim(arrHorarios(i)))
        If intCodHorario <= 0 Then
            Set rsVerifica = Nothing
            Call FinalizarComErro("Foi informado um horário de atendimento inválido.")
        End If

        ' O horário precisa pertencer à empresa, ao ano e ao semestre informados.
        sqlVerifica = "SELECT COUNT(*) AS qtde FROM AEE_HORARIO "
        sqlVerifica = sqlVerifica & "WHERE cod_horario = " & intCodHorario & " "
        sqlVerifica = sqlVerifica & "AND cod_empresa = " & intCodEmpresa & " "
        sqlVerifica = sqlVerifica & "AND anoLetivo = " & intAnoLetivo & " "
        sqlVerifica = sqlVerifica & "AND semestre = " & intSemestre

        rsVerifica.Open sqlVerifica, cnn
        qtde = rsVerifica("qtde")
        rsVerifica.Close

        If qtde = 0 Then
            Set rsVerifica = Nothing
            Call FinalizarComErro("Um dos horários selecionados não pertence à empresa, ano letivo ou semestre informado.")
        End If

        ' Regra principal: um consultório só pode ter um profissional em cada horário.
        sqlVerifica = "SELECT COUNT(*) AS qtde FROM AEE_ATENDIMENTO "
        sqlVerifica = sqlVerifica & "WHERE Cod_Consultorio = " & intCodConsultorio & " "
        sqlVerifica = sqlVerifica & "AND Cod_Horario = " & intCodHorario
        If acao = "A" Then sqlVerifica = sqlVerifica & " AND Cod_Atendimento <> " & intCodigo

        rsVerifica.Open sqlVerifica, cnn
        qtdeDuplicado = rsVerifica("qtde")
        rsVerifica.Close

        If qtdeDuplicado > 0 Then
            ' Busca a descrição para apresentar uma mensagem mais clara.
            sqlHorario = "SELECT ISNULL(T.DESC_TURNO, '') AS DESC_TURNO, H.hora_Inicio, H.minuto_Inicio, H.hora_termino, H.minuto_termino "
            sqlHorario = sqlHorario & "FROM AEE_HORARIO H LEFT JOIN SCA_TURNO T ON T.Cod_Turno = H.Cod_Turno "
            sqlHorario = sqlHorario & "WHERE H.cod_horario = " & intCodHorario
            rsVerifica.Open sqlHorario, cnn
            strHorarioDuplicado = "horário selecionado"
            If Not rsVerifica.EOF Then
                strHorarioDuplicado = Trim(CStr(rsVerifica("DESC_TURNO"))) & " - " & _
                    Right("0" & CStr(rsVerifica("hora_Inicio")), 2) & ":" & Right("0" & CStr(rsVerifica("minuto_Inicio")), 2) & " às " & _
                    Right("0" & CStr(rsVerifica("hora_termino")), 2) & ":" & Right("0" & CStr(rsVerifica("minuto_termino")), 2)
            End If
            rsVerifica.Close
            Set rsVerifica = Nothing
            Call FinalizarComErro("Este consultório já possui um profissional vinculado ao horário " & strHorarioDuplicado & ".")
        End If
    Next

    Set rsVerifica = Nothing
End If

If acao = "I" Then
    intIncluidos = 0

    For i = 0 To UBound(arrHorarios)
        intCodHorario = InteiroOuZero(Trim(arrHorarios(i)))

        sql = "INSERT INTO AEE_ATENDIMENTO "
        sql = sql & "(Cod_Consultorio, Cod_Profissional, Cod_Horario, usuario_incl, data_hora_incl) VALUES ("
        sql = sql & intCodConsultorio & ","
        sql = sql & intCodProfissional & ","
        sql = sql & intCodHorario & ","
        sql = sql & "'" & strUsuario & "',GETDATE())"
        'GravarLog sql
        On Error Resume Next
        cnn.Execute sql
        If Err.Number <> 0 Then
            strErro = Err.Description
            Err.Clear
            On Error GoTo 0
            Call FinalizarComErro(strErro)
        End If
        On Error GoTo 0

        intIncluidos = intIncluidos + 1
    Next

    If intIncluidos = 1 Then
        strMensagem = "Vínculo de atendimento cadastrado com sucesso!"
    Else
        strMensagem = CStr(intIncluidos) & " vínculos de atendimento cadastrados com sucesso!"
    End If

ElseIf acao = "A" Then
    If intCodigo <= 0 Then Call FinalizarComErro("Vínculo não identificado para alteração.")
    intCodHorario = InteiroOuZero(Trim(arrHorarios(0)))

    ' Confirma que o registro pertence à empresa atual.
    sqlVerifica = "SELECT COUNT(*) AS qtde FROM AEE_ATENDIMENTO A "
    sqlVerifica = sqlVerifica & "INNER JOIN AEE_CONSULTORIO C ON C.Cod_Consultorio = A.Cod_Consultorio "
    sqlVerifica = sqlVerifica & "INNER JOIN AEE_HORARIO H ON H.cod_horario = A.Cod_Horario "
    sqlVerifica = sqlVerifica & "WHERE A.Cod_Atendimento = " & intCodigo & " "
    sqlVerifica = sqlVerifica & "AND C.Cod_Empresa = " & intCodEmpresa & " AND H.cod_empresa = " & intCodEmpresa

    Set rsVerifica = Server.CreateObject("ADODB.Recordset")
    rsVerifica.Open sqlVerifica, cnn
    qtde = rsVerifica("qtde")
    rsVerifica.Close
    Set rsVerifica = Nothing

    If qtde = 0 Then Call FinalizarComErro("Vínculo não encontrado para a empresa atual.")

    sql = "UPDATE AEE_ATENDIMENTO SET "
    sql = sql & "Cod_Consultorio = " & intCodConsultorio & ","
    sql = sql & "Cod_Profissional = " & intCodProfissional & ","
    sql = sql & "Cod_Horario = " & intCodHorario & ","
    sql = sql & "usuario_altr = '" & strUsuario & "',"
    sql = sql & "data_hora_altr = GETDATE() "
    sql = sql & "WHERE Cod_Atendimento = " & intCodigo

    'GravarLog sql
    On Error Resume Next
    cnn.Execute sql
    If Err.Number <> 0 Then
        strErro = Err.Description
        Err.Clear
        On Error GoTo 0
        Call FinalizarComErro(strErro)
    End If
    On Error GoTo 0

    strMensagem = "Vínculo de atendimento alterado com sucesso!"

ElseIf acao = "E" Then
    If intCodigo <= 0 Then Call FinalizarComErro("Vínculo não identificado para exclusão.")

    sqlVerifica = "SELECT COUNT(*) AS qtde FROM AEE_ATENDIMENTO A "
    sqlVerifica = sqlVerifica & "INNER JOIN AEE_CONSULTORIO C ON C.Cod_Consultorio = A.Cod_Consultorio "
    sqlVerifica = sqlVerifica & "INNER JOIN AEE_HORARIO H ON H.cod_horario = A.Cod_Horario "
    sqlVerifica = sqlVerifica & "WHERE A.Cod_Atendimento = " & intCodigo & " "
    sqlVerifica = sqlVerifica & "AND C.Cod_Empresa = " & intCodEmpresa & " AND H.cod_empresa = " & intCodEmpresa

    Set rsVerifica = Server.CreateObject("ADODB.Recordset")
    rsVerifica.Open sqlVerifica, cnn
    qtde = rsVerifica("qtde")
    rsVerifica.Close
    Set rsVerifica = Nothing

    If qtde = 0 Then Call FinalizarComErro("Vínculo não encontrado para a empresa atual.")

    sql = "DELETE FROM AEE_ATENDIMENTO WHERE Cod_Atendimento = " & intCodigo
    'GravarLog sql

    On Error Resume Next
    cnn.Execute sql
    If Err.Number <> 0 Then
        strErro = Err.Description
        Err.Clear
        On Error GoTo 0
        Call FinalizarComErro(strErro)
    End If
    On Error GoTo 0

    strMensagem = "Vínculo de atendimento excluído com sucesso!"
Else
    Call FinalizarComErro("Ação inválida.")
End If

On Error Resume Next
cnn.CommitTrans
If Err.Number <> 0 Then
    strErro = Err.Description
    Err.Clear
    On Error GoTo 0
    Call FinalizarComErro(strErro)
End If
On Error GoTo 0

strMensagem = Replace(strMensagem, "'", "\'")
Response.Write "<script>alert('" & strMensagem & "');window.location='aee_atendimento.asp';</script>"
%>
