<%@ Language="VBScript" %>
<!--#include file="includes/inc_cnn.asp"-->
<%
Response.ContentType = "application/json"
Response.Charset = "utf-8"

Dim cod_aluno, rs, sql, arquivos
cod_aluno = Request.QueryString("cod_aluno")

If cod_aluno = "" Then
    Response.Write "[]"
    Response.End
End If

Set rs = Server.CreateObject("ADODB.Recordset")

' Agora também buscamos o campo Descricao
sql = "SELECT codigo, cod_aluno, NomeArquivo, Descricao, base64 " & _
      "FROM SCA_ALUNO_ARQUIVO WHERE cod_aluno=" & CLng(cod_aluno)

rs.Open sql, cnn

arquivos = "["

Do Until rs.EOF
    arquivos = arquivos & "{""idArquivo"":" & rs("codigo") & _
                          ",""codAluno"":" & rs("cod_aluno") & _
                          ",""nomeArquivo"":""" & Replace(rs("NomeArquivo"), """", "\""") & """" & _
                          ",""descricao"":""" & Replace(rs("Descricao"), """", "\""") & """" & _
                          ",""base64"":""" & Replace(rs("base64"), """", "\""") & """},"
    rs.MoveNext
Loop

rs.Close
Set rs = Nothing

If Right(arquivos,1) = "," Then arquivos = Left(arquivos, Len(arquivos)-1)
arquivos = arquivos & "]"

Response.Write arquivos
%>
