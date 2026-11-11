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
    SqlTexto = Replace(CStr(valor), "'", "''")
End Function

Function DataSql(valor)
    Dim partes

    valor = Trim(CStr(valor))

    If valor = "" Then
        DataSql = ""
        Exit Function
    End If

    partes = Split(valor, "/")

    If UBound(partes) <> 2 Then
        DataSql = ""
        Exit Function
    End If

    If Not IsNumeric(partes(0)) Or Not IsNumeric(partes(1)) Or Not IsNumeric(partes(2)) Then
        DataSql = ""
        Exit Function
    End If

    On Error Resume Next
    Dim dataTeste
    dataTeste = DateSerial(CInt(partes(2)), CInt(partes(1)), CInt(partes(0)))

    If Err.Number <> 0 Then
        Err.Clear
        On Error GoTo 0
        DataSql = ""
        Exit Function
    End If

    On Error GoTo 0

    DataSql = Right("0" & Day(dataTeste), 2) & "/" & Right("0" & Month(dataTeste), 2) & "/" & Year(dataTeste)
End Function

Sub FinalizarComErro(mensagem)
    On Error Resume Next
    cnn.RollbackTrans
    On Error GoTo 0

    mensagem = Replace(CStr(mensagem), "'", "\'")
    Response.Write "<script>alert('" & mensagem & "');history.back();</script>"
    Response.End
End Sub

acao = UCase(Trim(Request.QueryString("acao")))

intCodigo = InteiroOuZero(Request.Form("txtCodigo"))
intCodFichaPaciente = InteiroOuZero(Request.Form("txtCodFichaPaciente"))
intCodEmpresa = InteiroOuZero(Session("CodEmpresa"))

strBuscaPaciente = Trim(Request.Form("txtBuscaPaciente"))
strDataAtendimento = DataSql(Request.Form("txtDataAtendimento"))
strAtendimento = Trim(Request.Form("txtAtendimento"))
intCodConsultorio = Trim(Request.Form("cmbConsultorio"))
intCodProfissional = Trim(Request.Form("cmbProfissional"))

intQtdeArquivos = InteiroOuZero(Request.Form("txtQtdeArquivos"))
intQtdeLinks = InteiroOuZero(Request.Form("txtQtdeLinks"))

If intCodEmpresa <= 0 Then
    Response.Write "<script>alert('Empresa não identificada na sessão.');history.back();</script>"
    Response.End
End If

If acao = "I" Or acao = "A" Then

    If intCodFichaPaciente <= 0 Then
        Response.Write "<script>alert('Paciente não identificado. Pesquise e selecione o paciente novamente.');history.back();</script>"
        Response.End
    End If

    If strDataAtendimento = "" Then
        Response.Write "<script>alert('Informe uma Data de Atendimento válida.');history.back();</script>"
        Response.End
    End If

    If strAtendimento = "" Then
        Response.Write "<script>alert('O Atendimento deve ser informado.');history.back();</script>"
        Response.End
    End If
	
	If intCodConsultorio = "" or intCodConsultorio = "0" Then
        Response.Write "<script>alert('O Consultório deve ser informado.');history.back();</script>"
        Response.End
    End If
	
	If intCodProfissional = "" or intCodProfissional = "0" Then
        Response.Write "<script>alert('O Profissional deve ser informado.');history.back();</script>"
        Response.End
    End If

    'Confirma que a ficha pertence à empresa atual e está ativa.
    sql = "SELECT COUNT(*) AS qtde FROM AEE_FICHA_PACIENTE "
    sql = sql & "WHERE Cod_Ficha_Paciente = " & intCodFichaPaciente & " "
    sql = sql & "AND Cod_Empresa = " & intCodEmpresa & " "
    sql = sql & "AND Situacao = 'A'"

    Set rsVerifica = Server.CreateObject("ADODB.Recordset")
    rsVerifica.Open sql, cnn
    qtde = CLng(rsVerifica("qtde"))
    rsVerifica.Close
    Set rsVerifica = Nothing

    If qtde = 0 Then
        Response.Write "<script>alert('Paciente não encontrado ou ficha AEE inativa.');history.back();</script>"
        Response.End
    End If

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

If acao = "I" Then

    sql = "INSERT INTO AEE_ACOMPANHAMENTO "
    sql = sql & "(Cod_Empresa, Cod_Ficha_Paciente, Cod_consultorio, cod_Profissional, Data_Atendimento, Atendimento, usuario_incl, data_hora_incl) VALUES ("
    sql = sql & intCodEmpresa & ","
    sql = sql & intCodFichaPaciente & ","
    sql = sql & intCodConsultorio & ","
    sql = sql & intCodProfissional & ","
    sql = sql & "CONVERT(datetime,'" & strDataAtendimento & "',103),"
    sql = sql & "N'" & SqlTexto(strAtendimento) & "',"
    sql = sql & "'" & SqlTexto(Session("usuarioWeb")) & "',"
    sql = sql & "GETDATE())"

    On Error Resume Next
    cnn.Execute sql

    If Err.Number <> 0 Then
        strErro = Err.Description
        Err.Clear
        On Error GoTo 0
        Call FinalizarComErro(strErro)
    End If

    On Error GoTo 0
    'GravarLog sql

    Set rsCodigo = cnn.Execute("SELECT CAST(SCOPE_IDENTITY() AS int) AS Codigo")
    intCodigo = CLng(rsCodigo("Codigo"))
    rsCodigo.Close
    Set rsCodigo = Nothing

    strMensagem = "Atendimento cadastrado com sucesso!"

ElseIf acao = "A" Then

    If intCodigo <= 0 Then
        Call FinalizarComErro("Atendimento não identificado para alteração.")
    End If

    sql = "SELECT COUNT(*) AS qtde FROM AEE_ACOMPANHAMENTO "
    sql = sql & "WHERE Cod_Acompanhamento = " & intCodigo & " "
    sql = sql & "AND Cod_Empresa = " & intCodEmpresa

    Set rsVerifica = Server.CreateObject("ADODB.Recordset")
    rsVerifica.Open sql, cnn
    qtde = CLng(rsVerifica("qtde"))
    rsVerifica.Close
    Set rsVerifica = Nothing

    If qtde = 0 Then
        Call FinalizarComErro("Atendimento não encontrado para a empresa atual.")
    End If

    sql = "UPDATE AEE_ACOMPANHAMENTO SET "
    sql = sql & "Cod_Ficha_Paciente = " & intCodFichaPaciente & ","
    sql = sql & "Cod_consultorio = " & intCodConsultorio & ","
    sql = sql & "Cod_Profissional = " & intCodProfissional & ","
    sql = sql & "Data_Atendimento = CONVERT(datetime,'" & strDataAtendimento & "',103),"
    sql = sql & "Atendimento = N'" & SqlTexto(strAtendimento) & "',"
    sql = sql & "usuario_altr = '" & SqlTexto(Session("usuarioWeb")) & "',"
    sql = sql & "data_hora_altr = GETDATE() "
    sql = sql & "WHERE Cod_Acompanhamento = " & intCodigo & " "
    sql = sql & "AND Cod_Empresa = " & intCodEmpresa

    On Error Resume Next
    cnn.Execute sql

    If Err.Number <> 0 Then
        strErro = Err.Description
        Err.Clear
        On Error GoTo 0
        Call FinalizarComErro(strErro)
    End If

    On Error GoTo 0
    'GravarLog sql

    strMensagem = "Atendimento alterado com sucesso!"

ElseIf acao = "E" Then

    If intCodigo <= 0 Then
        Call FinalizarComErro("Atendimento não identificado para exclusão.")
    End If

    sql = "SELECT A.Cod_Ficha_Paciente "
    sql = sql & "FROM AEE_ACOMPANHAMENTO A "
    sql = sql & "WHERE A.Cod_Acompanhamento = " & intCodigo & " "
    sql = sql & "AND A.Cod_Empresa = " & intCodEmpresa

    Set rsVerifica = Server.CreateObject("ADODB.Recordset")
    rsVerifica.Open sql, cnn

    If rsVerifica.EOF Then
        rsVerifica.Close
        Set rsVerifica = Nothing
        Call FinalizarComErro("Atendimento não encontrado para a empresa atual.")
    End If

    intCodFichaPaciente = CLng(rsVerifica("Cod_Ficha_Paciente"))

    rsVerifica.Close
    Set rsVerifica = Nothing

    sql = "DELETE FROM AEE_ACOMPANHAMENTO_RECURSO "
    sql = sql & "WHERE Cod_Acompanhamento = " & intCodigo

    On Error Resume Next
    cnn.Execute sql

    If Err.Number <> 0 Then
        strErro = Err.Description
        Err.Clear
        On Error GoTo 0
        Call FinalizarComErro(strErro)
    End If

    On Error GoTo 0
    'GravarLog sql

    sql = "DELETE FROM AEE_ACOMPANHAMENTO "
    sql = sql & "WHERE Cod_Acompanhamento = " & intCodigo & " "
    sql = sql & "AND Cod_Empresa = " & intCodEmpresa

    On Error Resume Next
    cnn.Execute sql

    If Err.Number <> 0 Then
        strErro = Err.Description
        Err.Clear
        On Error GoTo 0
        Call FinalizarComErro(strErro)
    End If

    On Error GoTo 0
    'GravarLog sql

    cnn.CommitTrans

    strMensagem = Replace("Atendimento excluído com sucesso!", "'", "\'")
    Response.Write "<script>alert('" & strMensagem & "');window.location='aee_acompanhamento.asp?txtCodFichaPaciente=" & intCodFichaPaciente & "';</script>"
    Response.End

Else

    Call FinalizarComErro("Ação inválida.")

End If

'=========================================================
' REMOVE RECURSOS MARCADOS NA ALTERAÇÃO
'=========================================================
If acao = "A" Then

    strExcluirRecursos = Trim(Request.Form("chkExcluirRecurso"))

    If strExcluirRecursos <> "" Then

        arrExcluir = Split(strExcluirRecursos, ",")

        For i = 0 To UBound(arrExcluir)

            intCodRecursoExcluir = InteiroOuZero(Trim(arrExcluir(i)))

            If intCodRecursoExcluir > 0 Then

                sql = "DELETE FROM AEE_ACOMPANHAMENTO_RECURSO "
                sql = sql & "WHERE Cod_Recurso = " & intCodRecursoExcluir & " "
                sql = sql & "AND Cod_Acompanhamento = " & intCodigo

                On Error Resume Next
                cnn.Execute sql

                If Err.Number <> 0 Then
                    strErro = Err.Description
                    Err.Clear
                    On Error GoTo 0
                    Call FinalizarComErro(strErro)
                End If

                On Error GoTo 0
                'GravarLog sql

            End If

        Next

    End If

End If

'=========================================================
' NOVOS ARQUIVOS
'=========================================================
For i = 1 To intQtdeArquivos

    strNomeArquivo = Trim(Request.Form("txtArquivoNome_" & i))
    strTipoArquivo = Trim(Request.Form("txtArquivoTipo_" & i))
    strArquivoBase64 = Trim(Request.Form("txtArquivoBase64_" & i))

    If strNomeArquivo <> "" And strArquivoBase64 <> "" Then

        sql = "INSERT INTO AEE_ACOMPANHAMENTO_RECURSO "
        sql = sql & "(Cod_Acompanhamento, Tipo_Recurso, Nome_Arquivo, Tipo_Arquivo, Arquivo_Base64, usuario_incl, data_hora_incl) VALUES ("
        sql = sql & intCodigo & ","
        sql = sql & "'A',"
        sql = sql & "N'" & SqlTexto(strNomeArquivo) & "',"
        sql = sql & "'" & SqlTexto(strTipoArquivo) & "',"
        sql = sql & "'" & SqlTexto(strArquivoBase64) & "',"
        sql = sql & "'" & SqlTexto(Session("usuarioWeb")) & "',"
        sql = sql & "GETDATE())"

        On Error Resume Next
        cnn.Execute sql

        If Err.Number <> 0 Then
            strErro = Err.Description
            Err.Clear
            On Error GoTo 0
            Call FinalizarComErro(strErro)
        End If

        On Error GoTo 0
        'GravarLog sql

    End If

Next

'=========================================================
' NOVOS LINKS
'=========================================================
For i = 1 To intQtdeLinks

    strLink = Trim(Request.Form("txtLink_" & i))

    If strLink <> "" Then

        If LCase(Left(strLink, 7)) <> "http://" And LCase(Left(strLink, 8)) <> "https://" Then
            Call FinalizarComErro("Foi informado um link inválido. Utilize http:// ou https://.")
        End If

        sql = "INSERT INTO AEE_ACOMPANHAMENTO_RECURSO "
        sql = sql & "(Cod_Acompanhamento, Tipo_Recurso, Link, usuario_incl, data_hora_incl) VALUES ("
        sql = sql & intCodigo & ","
        sql = sql & "'L',"
        sql = sql & "N'" & SqlTexto(strLink) & "',"
        sql = sql & "'" & SqlTexto(Session("usuarioWeb")) & "',"
        sql = sql & "GETDATE())"

        On Error Resume Next
        cnn.Execute sql

        If Err.Number <> 0 Then
            strErro = Err.Description
            Err.Clear
            On Error GoTo 0
            Call FinalizarComErro(strErro)
        End If

        On Error GoTo 0
        'GravarLog sql

    End If

Next

cnn.CommitTrans

strMensagem = Replace(strMensagem, "'", "\'")
Response.Write "<script>alert('" & strMensagem & "');window.location='aee_acompanhamento.asp?txtCodFichaPaciente=" & intCodFichaPaciente & "';</script>"
%>
