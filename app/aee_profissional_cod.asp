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
intCodColaborador = InteiroOuZero(Request.Form("cmbColaborador"))
intCodEspecialidade = InteiroOuZero(Request.Form("cmbEspecialidade"))
strUsuario = SqlTexto(Session("usuarioWeb"))

If acao = "I" Or acao = "A" Then
    If intCodColaborador <= 0 Then Err.Raise vbObjectError + 1200, "AEE_PROFISSIONAL", "O colaborador deve ser informado."
    If intCodEspecialidade <= 0 Then Err.Raise vbObjectError + 1201, "AEE_PROFISSIONAL", "A especialidade deve ser informada."

    If Err.Number = 0 Then
        sql = "SELECT COUNT(*) AS qtde FROM SRH_COLABORADOR WHERE codigo = " & intCodColaborador
        rs.Open sql, cnn
        If rs("qtde") = 0 Then Err.Raise vbObjectError + 1202, "AEE_PROFISSIONAL", "Colaborador inválido."
        rs.Close
    End If

    If Err.Number = 0 Then
        sql = "SELECT COUNT(*) AS qtde FROM AEE_ESPECIALIDADE WHERE Cod_Especialidade = " & intCodEspecialidade
        rs.Open sql, cnn
        If rs("qtde") = 0 Then Err.Raise vbObjectError + 1203, "AEE_PROFISSIONAL", "Especialidade inválida."
        rs.Close
    End If
End If

If Err.Number = 0 Then
    Select Case acao
        Case "I"
            strMensagem = "Registro salvo com sucesso..."

            sql = "INSERT INTO AEE_PROFISSIONAL "
            sql = sql & "(Cod_Colaborador, Cod_Especialidade, usuario_incl, data_hora_incl) VALUES ("
            sql = sql & intCodColaborador & ","
            sql = sql & intCodEspecialidade & ","
            sql = sql & "'" & strUsuario & "',"
            sql = sql & "GETDATE())"

            cnn.Execute sql
            If Err.Number = 0 Then GravarLog sql

        Case "A"
            If intCodigo <= 0 Then Err.Raise vbObjectError + 1204, "AEE_PROFISSIONAL", "Código do profissional inválido."

            If Err.Number = 0 Then
                strMensagem = "Registro alterado com sucesso..."

                sql = "UPDATE AEE_PROFISSIONAL SET "
                sql = sql & "Cod_Colaborador = " & intCodColaborador & ","
                sql = sql & "Cod_Especialidade = " & intCodEspecialidade & ","
                sql = sql & "usuario_altr = '" & strUsuario & "',"
                sql = sql & "data_hora_altr = GETDATE() "
                sql = sql & "WHERE Cod_Profissional = " & intCodigo

                cnn.Execute sql
                If Err.Number = 0 Then GravarLog sql
            End If

        Case "E"
            If intCodigo <= 0 Then Err.Raise vbObjectError + 1205, "AEE_PROFISSIONAL", "Código do profissional inválido."

            If Err.Number = 0 Then
                strMensagem = "Registro excluído com sucesso..."
                sql = "DELETE FROM AEE_PROFISSIONAL WHERE Cod_Profissional = " & intCodigo
                cnn.Execute sql
                If Err.Number = 0 Then GravarLog sql
            End If

        Case Else
            Err.Raise vbObjectError + 1206, "AEE_PROFISSIONAL", "Ação inválida."
    End Select
End If

If Err.Number = 0 Then
    cnn.CommitTrans
%>
<script>
    alert("<%=strMensagem%>");
    window.location = 'aee_profissional.asp';
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
