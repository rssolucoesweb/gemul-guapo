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
strDescricao = SqlTexto(Request.Form("txtDescricao"))
strSituacao = UCase(Trim(Request.Form("cmbSituacao")))

If strSituacao = "" Or strSituacao = "0" Then strSituacao = "A"

If acao = "I" Or acao = "A" Then
    If intCodigo <= 0 Then Err.Raise vbObjectError + 1400, "AEE_ESPECIALIDADE", "O código da especialidade deve ser informado."
    If strDescricao = "" Then Err.Raise vbObjectError + 1401, "AEE_ESPECIALIDADE", "A descrição deve ser informada."
    If Len(strDescricao) > 50 Then Err.Raise vbObjectError + 1402, "AEE_ESPECIALIDADE", "A descrição deve possuir no máximo 50 caracteres."
    If strSituacao <> "A" And strSituacao <> "I" Then Err.Raise vbObjectError + 1403, "AEE_ESPECIALIDADE", "Situação inválida."
End If

If Err.Number = 0 Then
    Select Case acao
        Case "I"
            sql = "SELECT COUNT(*) AS qtde FROM AEE_ESPECIALIDADE WHERE Cod_Especialidade = " & intCodigo
            rs.Open sql, cnn
            intQtde = rs("qtde")
            rs.Close

            If intQtde > 0 Then
                Err.Raise vbObjectError + 1404, "AEE_ESPECIALIDADE", "Já existe uma especialidade cadastrada com este código."
            End If

            If Err.Number = 0 Then
                strMensagem = "Registro salvo com sucesso..."

                sql = "INSERT INTO AEE_ESPECIALIDADE (Cod_Especialidade, Descricao, Situacao) VALUES ("
                sql = sql & intCodigo & ","
                sql = sql & "N'" & strDescricao & "',"
                sql = sql & "'" & strSituacao & "')"

                cnn.Execute sql
                If Err.Number = 0 Then GravarLog sql
            End If

        Case "A"
            If intCodigo <= 0 Then Err.Raise vbObjectError + 1405, "AEE_ESPECIALIDADE", "Código da especialidade inválido."

            If Err.Number = 0 Then
                strMensagem = "Registro alterado com sucesso..."

                sql = "UPDATE AEE_ESPECIALIDADE SET "
                sql = sql & "Descricao = N'" & strDescricao & "',"
                sql = sql & "Situacao = '" & strSituacao & "' "
                sql = sql & "WHERE Cod_Especialidade = " & intCodigo

                cnn.Execute sql
                If Err.Number = 0 Then GravarLog sql
            End If

        Case "E"
            If intCodigo <= 0 Then Err.Raise vbObjectError + 1406, "AEE_ESPECIALIDADE", "Código da especialidade inválido."

            If Err.Number = 0 Then
                sql = "SELECT COUNT(*) AS qtde FROM AEE_PROFISSIONAL WHERE Cod_Especialidade = " & intCodigo
                rs.Open sql, cnn
                intQtdeUso = rs("qtde")
                rs.Close

                If intQtdeUso > 0 Then
                    Err.Raise vbObjectError + 1407, "AEE_ESPECIALIDADE", "Não é possível excluir esta especialidade, pois ela está vinculada a profissional(is). Inative o cadastro."
                End If
            End If

            If Err.Number = 0 Then
                strMensagem = "Registro excluído com sucesso..."
                sql = "DELETE FROM AEE_ESPECIALIDADE WHERE Cod_Especialidade = " & intCodigo
                cnn.Execute sql
                If Err.Number = 0 Then GravarLog sql
            End If

        Case Else
            Err.Raise vbObjectError + 1408, "AEE_ESPECIALIDADE", "Ação inválida."
    End Select
End If

If Err.Number = 0 Then
    cnn.CommitTrans
%>
<script>
    alert("<%=strMensagem%>");
    window.location = 'aee_especialidade.asp';
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
