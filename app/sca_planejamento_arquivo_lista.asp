<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
Response.Charset = "utf-8"

On Error Resume Next

anoLetivo = Request.QueryString("anoLetivo")
mes = Request.QueryString("mes")
codTurma = Request.QueryString("codTurma")
codDisciplina = Request.QueryString("codDisciplina")

If anoLetivo = "" Or mes = "" Or codTurma = "" Or codDisciplina = "" Then
    Response.Write "<div class='alert alert-danger'>Parâmetros obrigatórios não informados.</div>"
    Response.End
End If

sql = ""
sql = sql & " SELECT codigo, nome_arquivo, tipo_arquivo, data_hora_incl "
sql = sql & " FROM sca_planejamento_arquivo "
sql = sql & " WHERE ano_letivo = " & CLng(anoLetivo)
sql = sql & " AND mes = " & CLng(mes)
sql = sql & " AND cod_turma = " & CLng(codTurma)
sql = sql & " AND cod_disciplina = " & CLng(codDisciplina)
sql = sql & " ORDER BY data_hora_incl DESC "
Set rs = cnn.Execute(sql)

If Err.Number <> 0 Then
    Response.Write "<div class='alert alert-danger'>"
    Response.Write "<b>Erro SQL:</b><br>"
    Response.Write Err.Description & "<br><br>"
    Response.Write "<b>SQL:</b><br>" & sql
    Response.Write "</div>"
    Response.End
End If

If rs.EOF Then
    Response.Write "<div class='alert alert-info mb-0'>Nenhum arquivo encontrado.</div>"
Else
    Response.Write "<table class='table table-sm table-bordered'>"
    Response.Write "<thead>"
    Response.Write "<tr>"
    Response.Write "<th>Arquivo</th>"
    Response.Write "<th>Data</th>"
    Response.Write "<th width='180'>Ações</th>"
    Response.Write "</tr>"
    Response.Write "</thead>"
    Response.Write "<tbody>"

    Do While Not rs.EOF
        Response.Write "<tr>"
        Response.Write "<td>" & Server.HTMLEncode(rs("nome_arquivo")) & "</td>"
        Response.Write "<td>" & rs("data_hora_incl") & "</td>"
        Response.Write "<td>"
        Response.Write "<a target='_blank' class='btn btn-sm btn-outline-info' href='sca_planejamento_arquivo_visualizar.asp?codigo=" & rs("codigo") & "'>Visualizar</a> "
        Response.Write "<button type='button' class='btn btn-sm btn-outline-danger' onclick='removerArquivo(" & rs("codigo") & ")'>Remover</button>"
        Response.Write "</td>"
        Response.Write "</tr>"

        rs.MoveNext
    Loop

    Response.Write "</tbody>"
    Response.Write "</table>"
End If

rs.Close
Set rs = Nothing
%>