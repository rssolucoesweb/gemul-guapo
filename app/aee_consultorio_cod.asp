<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
Function InteiroOuZero(valor)
    If IsNumeric(valor) Then
        InteiroOuZero = CLng(valor)
    Else
        InteiroOuZero = 0
    End If
End Function

Function SqlTexto(valor)
    If IsNull(valor) Then
        SqlTexto = ""
    Else
        SqlTexto = Replace(Trim(CStr(valor)), "'", "''")
    End If
End Function

On Error Resume Next
cnn.BeginTrans

acao = UCase(Trim(Request.QueryString("acao")))
intCodigo = InteiroOuZero(Request.Form("txtCodigo"))
intCodEmpresa = InteiroOuZero(Session("CodEmpresa"))
intAnoLetivo = InteiroOuZero(Request.Form("txtAnoLetivo"))
strNomeConsultorio = SqlTexto(Request.Form("txtNomeConsultorio"))
intCapacidade = InteiroOuZero(Request.Form("txtCapacidade"))
strSituacao = UCase(Trim(Request.Form("cmbSituacao")))
strUsuario = SqlTexto(Session("usuarioWeb"))

If strSituacao = "" Or strSituacao = "0" Then strSituacao = "A"

If acao = "I" Or acao = "A" Then
    If intCodEmpresa <= 0 Then Err.Raise vbObjectError + 1300, "AEE_CONSULTORIO", "Empresa inválida na sessão."
    If intAnoLetivo <= 0 Then Err.Raise vbObjectError + 1301, "AEE_CONSULTORIO", "O ano letivo deve ser informado."
    If strNomeConsultorio = "" Then Err.Raise vbObjectError + 1303, "AEE_CONSULTORIO", "O nome do consultório deve ser informado."
    If intCapacidade <= 0 Then Err.Raise vbObjectError + 1304, "AEE_CONSULTORIO", "A capacidade deve ser maior que zero."
    If strSituacao <> "A" And strSituacao <> "I" Then Err.Raise vbObjectError + 1305, "AEE_CONSULTORIO", "Situação inválida."
End If

If Err.Number = 0 Then
    Select Case acao
        Case "I"
            strMensagem = "Registro salvo com sucesso..."

            sql = "INSERT INTO AEE_CONSULTORIO "
            sql = sql & "(Cod_Empresa, AnoLetivo, NomeConsultorio, Capacidade, Situacao, usuario_incl, data_hora_incl) VALUES ("
            sql = sql & intCodEmpresa & ","
            sql = sql & intAnoLetivo & ","
            sql = sql & "N'" & strNomeConsultorio & "',"
            sql = sql & intCapacidade & ","
            sql = sql & "'" & strSituacao & "',"
            sql = sql & "'" & strUsuario & "',"
            sql = sql & "GETDATE())"

            cnn.Execute sql
            If Err.Number = 0 Then GravarLog sql

        Case "A"
            If intCodigo <= 0 Then Err.Raise vbObjectError + 1306, "AEE_CONSULTORIO", "Código do consultório inválido."

            If Err.Number = 0 Then
                strMensagem = "Registro alterado com sucesso..."

                sql = "UPDATE AEE_CONSULTORIO SET "
                sql = sql & "AnoLetivo = " & intAnoLetivo & ","
                sql = sql & "NomeConsultorio = N'" & strNomeConsultorio & "',"
                sql = sql & "Capacidade = " & intCapacidade & ","
                sql = sql & "Situacao = '" & strSituacao & "',"
                sql = sql & "usuario_altr = '" & strUsuario & "',"
                sql = sql & "data_hora_altr = GETDATE() "
                sql = sql & "WHERE Cod_Consultorio = " & intCodigo & " "
                sql = sql & "AND Cod_Empresa = " & intCodEmpresa

                cnn.Execute sql
                If Err.Number = 0 Then GravarLog sql
            End If

        Case "E"
            If intCodigo <= 0 Then Err.Raise vbObjectError + 1307, "AEE_CONSULTORIO", "Código do consultório inválido."

            If Err.Number = 0 Then
                strMensagem = "Registro excluído com sucesso..."

                sql = "DELETE FROM AEE_CONSULTORIO "
                sql = sql & "WHERE Cod_Consultorio = " & intCodigo & " "
                sql = sql & "AND Cod_Empresa = " & intCodEmpresa

                cnn.Execute sql
                If Err.Number = 0 Then GravarLog sql
            End If

        Case Else
            Err.Raise vbObjectError + 1308, "AEE_CONSULTORIO", "Ação inválida."
    End Select
End If

If Err.Number = 0 Then
    cnn.CommitTrans
%>
<script>
    alert("<%=strMensagem%>");
    window.location = 'aee_consultorio.asp';
</script>
<%
Else
    strErro = Err.Description
    strErro = Replace(strErro, "\", "\\")
    strErro = Replace(strErro, """", "'")
    strErro = Replace(strErro, vbCrLf, "\n")
    strErro = Replace(strErro, vbCr, "\n")
    strErro = Replace(strErro, vbLf, "\n")
    Err.Clear
    cnn.RollbackTrans
%>
<script>
    alert("ATENÇÃO:\n\nNão foi possível executar esse procedimento.\n<%=strErro%>");
    window.history.back();
</script>
<%
End If
%>
