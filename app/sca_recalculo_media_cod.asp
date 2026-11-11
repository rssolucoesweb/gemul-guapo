<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"
Response.Expires = 0
Server.ScriptTimeOut = 5000
Response.Buffer = True
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_recalcula_notas_turma.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<%
Dim intCodEmp, intCodTurma, intCodCurso, intCodPeriodo, intAnoLetivo, intSemestre
Dim intCodDisciplina, strAlunos, arrAlunos, qtdAlunos, itemAluno
Dim sql, rsTurma

intCodEmp = CLng(Session("CodEmpresa"))
intAnoLetivo = Trim(Request.Form("txtAnoLetivo"))
intSemestre = Trim(Request.Form("cmbSemestre"))

intCodTurma = Trim(Request.Form("cmbTurma"))
If intCodTurma = "" Or intCodTurma = "0" Then
    intCodTurma = Trim(Request.Form("cmbTurmaProfessor"))
End If

intCodDisciplina = Trim(Request.Form("cmbDisciplinaTurma"))
If intCodDisciplina = "" Or intCodDisciplina = "0" Then
    intCodDisciplina = Trim(Request.Form("cmbDisciplinaDoProfessor"))
End If
If intCodDisciplina = "" Then intCodDisciplina = "0"

strAlunos = Trim(Request.Form("chkAluno"))
strAlunos = RNT_SomenteNumerosCSV(strAlunos)

If intAnoLetivo = "" Or Not IsNumeric(intAnoLetivo) Then
    Response.Write "<script>alert('Ano letivo inválido.');history.back();</script>"
    Response.End
End If
If intSemestre = "" Or Not IsNumeric(intSemestre) Or CLng(intSemestre) <= 0 Then
    Response.Write "<script>alert('Semestre inválido.');history.back();</script>"
    Response.End
End If
If intCodTurma = "" Or Not IsNumeric(intCodTurma) Or CLng(intCodTurma) <= 0 Then
    Response.Write "<script>alert('Turma inválida.');history.back();</script>"
    Response.End
End If
If strAlunos = "" Then
    Response.Write "<script>alert('Selecione pelo menos um aluno.');history.back();</script>"
    Response.End
End If

If Not IsNumeric(intCodDisciplina) Then intCodDisciplina = 0

' O curso e o período são sempre obtidos novamente da turma no servidor.
Set rsTurma = Server.CreateObject("ADODB.Recordset")
sql = "SELECT P.Cod_Curso, P.Cod_Periodo, T.Cod_Semestre "
sql = sql & " FROM SCA_TURMA T "
sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular=T.Cod_GradeCurricular "
sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo=GC.Cod_Periodo "
sql = sql & " WHERE T.COD_EMPRESA=" & intCodEmp
sql = sql & " AND T.Cod_Turma=" & CLng(intCodTurma)
rsTurma.Open sql, cnn
If rsTurma.EOF Then
    rsTurma.Close
    Set rsTurma = Nothing
    Response.Write "<script>alert('Turma não encontrada.');history.back();</script>"
    Response.End
End If

intCodCurso = CLng(rsTurma("Cod_Curso"))
intCodPeriodo = CLng(rsTurma("Cod_Periodo"))
intSemestre = CLng(rsTurma("Cod_Semestre"))
rsTurma.Close
Set rsTurma = Nothing

arrAlunos = Split(strAlunos, ",")
qtdAlunos = UBound(arrAlunos) + 1

On Error Resume Next
cnn.BeginTrans

Call RecalcularNotasTurmaAlunos( _
    intCodEmp, _
    CLng(intCodTurma), _
    intCodCurso, _
    intCodPeriodo, _
    CLng(intAnoLetivo), _
    CLng(intSemestre), _
    CLng(intCodDisciplina), _
    strAlunos _
)
%>
<script>
    aguarde.style.display="none";
</script>
<%
If Err.Number = 0 Then
    cnn.CommitTrans
    On Error GoTo 0
    Response.Redirect "sca_recalculo_media.asp?ok=S&qtd=" & qtdAlunos & _
        "&txtAnoLetivo=" & Server.URLEncode(intAnoLetivo) & _
        "&cmbSemestre=" & Server.URLEncode(intSemestre)
Else
    Dim numeroErro, descricaoErro
    numeroErro = Err.Number
    descricaoErro = Err.Description
    Err.Clear
    cnn.RollbackTrans
    On Error GoTo 0
    Response.Write "<script>alert('Erro ao recalcular as médias: " & Replace(Replace(descricaoErro, "'", "\'"), vbCrLf, " ") & "');history.back();</script>"
End If
%>
