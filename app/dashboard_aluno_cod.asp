<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="json/JSON_2.0.4.asp"-->
<!--#include file="json/JSON_UTIL_0.1.1.asp"-->
<%
acao = request("acao")
strCodGrupo = Session("CodGrupo") 
strAnoLetivo = request("strAnoLetivo")
strTipoUnidadeEnsino = request("strTipoUnidadeEnsino")
strUnidadeEnsino = request("strUnidadeEnsino")
strModalidade = request("strModalidade")
strPeriodo = request("strPeriodo")

if strUnidadeEnsino = "" then strUnidadeEnsino = "0"
if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
if strSemestre = "" then strSemestre = session("strSemestre")


if acao="alunosPorMes" then
    Dim i, quantidade
    result = "["

    sql="exec SP_DAS_Quantitativo_Alunos_Anual_Historico " & strCodGrupo & "," & strAnoLetivo & "," & strUnidadeEnsino & ",''," & strTipoUnidadeEnsino
    'response.write sql
    rs.open sql, cnn
    if rs.eof = false then    
        

        For i = 1 To 12
            quantidade = rs(i-1)
            result = result & "{""mes"": " & i & ", ""quantidade"": " & quantidade & "},"
        Next

        ' Remover a última vírgula e fechar o JSON
        If Len(result) > 1 Then
            result = Left(result, Len(result) - 1)
        End If
    end if
    rs.close
    result = result & "]"

    Response.Write result
elseif acao="alunosPorSerie" then
    sql="exec [dbo].[SP_DAS_Quantitativo_Alunos_Serie] " & strCodGrupo & ", " & strAnoLetivo & "," & strUnidadeEnsino & ",'" & strModalidade & "'," & strTipoUnidadeEnsino
    QueryToJSON(cnn, sql).Flush

elseif acao = "alunosPorTurno" then

    sql="exec SP_DAS_Quantitativo_Alunos_turno " & strCodGrupo & ", " & strAnoLetivo & "," & strUnidadeEnsino & ",'" & strModalidade & "'," & strTipoUnidadeEnsino
    rs.open sql, cnn
    result = result & "["    
    if rs.eof = false then    
        while not rs.eof
            result = result & "{""turno"": """ & left(rs("turno"),3) & """, ""quantidade"": " & rs("quantitativo") & "},"
            rs.movenext
        wend
        ' Remover a última vírgula e fechar o JSON
        If Len(result) > 1 Then
            result = Left(result, Len(result) - 1)
        End If
    end if
    result = result & "]"
    rs.close
     
    Response.Write result

'elseif acao = "alunosPorSexo" then
'
'  result = "["

 '   For i = 1 To 2
 '       ' Gerar uma quantidade aleatória entre 10 e 100 para cada mês
 '       Randomize
 '       quantidade = Int((100 - 10 + 1) * Rnd + 10)
 '       if i=1 then
 '           result = result & "{""sexo"": ""Masculino"", ""quantidade"": " & quantidade & "},"
 '       else
 '           result = result & "{""sexo"": ""Feminino"", ""quantidade"": " & quantidade & "},"
 '       end if'

'    Next
'    If Len(result) > 1 Then
'        result = Left(result, Len(result) - 1)
'    End If
'
'    result = result & "]"    
'    Response.Write result    

elseif acao = "porModalidade" then


    sql="select c.descricao, count(*) as qtde"
    sql=sql & " from SCA_ALUNO a"
    sql=sql & " inner join SCA_ALUNO_TURMA at on at.COD_ALUNO = a.CODIGO"
    sql=sql & " inner join sca_turma t on t.Cod_Turma = at.COD_TURMA"
    sql=sql & " inner join SCA_PERIODO p on p.Cod_Periodo = t.Cod_periodo"
    sql=sql & " inner join sca_curso c on c.Cod_curso = p.Cod_Curso"
    sql=sql & " where a.COD_SITUACAOALUNO = 1"
    sql=sql & " and t.AnoLetivo = year(getdate())"
    sql=sql & " and t.Situacao = 'A'"
    sql=sql & " group by c.Descricao"
    sql=sql & " order by 1"
    QueryToJSON(cnn, sql).Flush

elseif acao = "qtde" then

    sql="exec SP_DAS_Quantitativo_Alunos_Curso " & strCodGrupo & "," & strAnoLetivo & "," & strUnidadeEnsino & "," & strTipoUnidadeEnsino
	'RESPONSE.WRITE SQL
    QueryToJSON(cnn, sql).Flush

elseif acao="outrosQtde" then

    sql="exec SP_DAS_Quantitativo_Alunos_curso_outros " & strCodGrupo & "," & strAnoLetivo & "," & strUnidadeEnsino & ",'" & strModalidade & "'," & strTipoUnidadeEnsino
    QueryToJSON(cnn, sql).Flush

elseif acao="alunosNominal" then

    sql="exec SP_DAS_Quantitativo_Alunos_Serie_nominal " & strCodGrupo & "," & strAnoLetivo & "," & strUnidadeEnsino & ",'" & strModalidade & "','" & strPeriodo & "'"
    QueryToJSON(cnn, sql).Flush

end if

%>