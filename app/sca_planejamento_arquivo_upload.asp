<%
Response.Charset = "utf-8"
Server.ScriptTimeout = 300

Function UTF8Decode(str)
    UTF8Decode = BinaryToString(StringToBinary(str), "utf-8")
End Function

Function StringToBinary(Text)
    Dim Stream
    Set Stream = Server.CreateObject("ADODB.Stream")
    Stream.Type = 2
    Stream.Charset = "iso-8859-1"
    Stream.Open
    Stream.WriteText Text
    Stream.Position = 0
    Stream.Type = 1
    StringToBinary = Stream.Read
    Stream.Close
End Function

Function BinaryToString(Binary, Charset)
    Dim Stream
    Set Stream = Server.CreateObject("ADODB.Stream")
    Stream.Type = 1
    Stream.Open
    Stream.Write Binary
    Stream.Position = 0
    Stream.Type = 2
    Stream.Charset = Charset
    BinaryToString = Stream.ReadText
    Stream.Close
End Function


anoLetivo = Request.Form("anoLetivo")
mes = Request.Form("mes")
codDisciplina = Request.Form("codDisciplina")
codTurma = Request.Form("codTurma")
nomeArquivo = UTF8Decode(Request.Form("nomeArquivo"))
tipoArquivo = Request.Form("tipoArquivo")
arquivoBase64 = Request.Form("arquivoBase64")

%>
<!--#include file="includes/inc_cnn.asp"-->
<%

If anoLetivo = "" Or mes = "" Or codDisciplina = "" Or codTurma = "" Then
    Response.Write "Parâmetros obrigatórios não informados."
    Response.End
End If

sql = "INSERT INTO sca_planejamento_arquivo "
sql = sql & " (ano_letivo, mes, cod_turma, cod_disciplina, nome_arquivo, tipo_arquivo, arquivo_base64, usuario_incl, data_hora_incl) "
sql = sql & " VALUES ("
sql = sql & CLng(anoLetivo) & ", "
sql = sql & CLng(mes) & ", "
sql = sql & CLng(codTurma) & ", "
sql = sql & CLng(codDisciplina) & ", "
sql = sql & "'" & Replace(nomeArquivo, "'", "''") & "', "
sql = sql & "'" & Replace(tipoArquivo, "'", "''") & "', "
sql = sql & "'" & Replace(arquivoBase64, "'", "''") & "', "
sql = sql & "'" & Replace(Session("usuarioWeb"), "'", "''") & "', "
sql = sql & "GETDATE())"

cnn.Execute sql

Response.Write "OK"
%>