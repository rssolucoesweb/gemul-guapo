<%
response.buffer = false
%>
<!--#include file="includes/inc_cnn.asp"-->

<%

cod_planejamento_geral = 0
cod_empresa = 1
anoLetivo = 2
numero_aula = 3
cod_turma = 4
cod_disciplina = 5
cod_turno = 6

intContTotal = 0

sql="select top 100 cod_planejamento_geral, cod_empresa, anoLetivo, numero_aula, cod_turma, cod_disciplina, cod_turno,  COUNT(*) as qtde"
sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR"
sql=sql & " where data_aula_extra is null"
sql=sql & " group by cod_planejamento_geral, cod_empresa, anoLetivo, numero_aula, cod_turma, cod_disciplina, cod_turno"
sql=sql & " having count(*) > 1"
sql=sql & " order by cod_empresa, anoLetivo, cod_turma, cod_disciplina, numero_aula"

response.write sql & "<hr>"

rs.open sql, cnn
if rs.eof = false then
    vetDuplicados = rs.getRows
end if
rs.close

if isArray(vetDuplicados) then

    for i=0 to ubound(vetDuplicados,2)

        'verifica se esiste pelo menos 1 registro validado
        sql="select cod_planejamento_professor, validado from SCA_PLANEJAMENTO_PROFESSOR"
        sql=sql & " where cod_planejamento_geral = " & vetDuplicados(cod_planejamento_geral,i)
        sql=sql & " and cod_empresa = " & vetDuplicados(cod_empresa,i)
        sql=sql & " and anoLetivo = " & vetDuplicados(anoLetivo,i)
        sql=sql & " and numero_aula = " & vetDuplicados(numero_aula,i)
        sql=sql & " and cod_turma = " & vetDuplicados(cod_turma,i)
        sql=sql & " and cod_disciplina = " & vetDuplicados(cod_disciplina,i)
        sql=sql & " and cod_turno = " & vetDuplicados(cod_turno,i)
        sql=sql & " order by validado desc, cod_planejamento_professor"
        rs.open sql, cnn
        if rs.eof = false then
            'O primeiro registro possui o código pálido
            codPlanejamentoValido = rs("cod_planejamento_professor")
            codPlanejamentoExcluir = ""

            rs.movenext

            while not rs.eof
                if codPlanejamentoExcluir <>"" then codPlanejamentoExcluir = codPlanejamentoExcluir & ", "
                codPlanejamentoExcluir = codPlanejamentoExcluir & rs("cod_planejamento_professor")
                rs.movenext
            wend

            response.write (intContTotal + 1) & " - " & codPlanejamentoValido & " | " & codPlanejamentoExcluir & "<br>"


            'SQL="DELETE from SCA_CONTEUDO_MINISTRADO_PROFESSOR WHERE cod_planejamento_professor IN (" & codPlanejamentoExcluir & ");"
            'SQL=SQL & " DELETE from SCA_ITEM_PLANEJAMENTO_PROFESSOR WHERE cod_planejamento_professor IN (" & codPlanejamentoExcluir & ");"
            'SQL=SQL & " DELETE from SCA_PLANEJAMENTO_PROFESSOR WHERE cod_planejamento_professor IN (" & codPlanejamentoExcluir & ")"
            'cnn.execute sql
            
            'RESPONSE.WRITE SQL & "<HR>"
            'response.write (intContTotal + 1) & "|"
        end if
        rs.close

        intContTotal = intContTotal + 1
    next

end if
cnn.close


response.write "<hr>TOLAL: " & intContTotal

%>