<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "text/html"
response.Expires = 0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Fechamento por disciplinas</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<style>
    .quadroInfo { width:98%; border-collapse:collapse; margin:0 auto 10px auto; font-family:Arial, Helvetica, sans-serif; font-size:10px; }
    .quadroInfo td { border:1px solid #777; padding:2px 4px; }
    .quadroInfo .rotulo { width:12%; }
    .quadroInfo .valor { font-weight:bold; }
    .gradeGeral { width:98%; border-collapse:collapse; margin:0 auto; font-family:Arial, Helvetica, sans-serif; font-size:9px; table-layout:auto; }
    .gradeGeral th, .gradeGeral td { border:1px solid #777; padding:2px 3px; }
    .gradeGeral th { text-align:center; font-weight:bold; white-space:nowrap; }
    .gradeGeral .ord { width:3%; text-align:center; }
    .gradeGeral .aluno { min-width:300px; white-space:nowrap; }
    .gradeGeral .disc { min-width:55px; text-align:center; }
    .gradeGeral .situacao { min-width:120px; white-space:nowrap; }
    .situacaoEspecial { color:#ff0000; }
    @media print {
        @page { size: landscape; margin: 8mm; }
        .gradeGeral { width:100%; font-size:8px; }
        .quadroInfo { width:100%; }
    }
</style>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
<%
' ============================================================================
' RELATORIO GERAL - PARA FECHAR POR DISCIPLINA
' Baseado em sca_rel_nota_disciplina_rel.asp
' Cada disciplina vira uma coluna e a celula mostra somente quanto falta
' para o aluno atingir a media de aprovacao daquela disciplina.
' ============================================================================

intAnoLetivoAtual = Trim(Request.Form("txtAnoLetivo"))
intSemestreAtual = Trim(Request.Form("cmbSemestre"))
strAnoLetivo = intAnoLetivoAtual
strCod_empresa = Session("CodEmpresa")
mostra_resultado = UCase(Trim(Request("mostra_resultado") & ""))

if Trim(Request("cmbTurma")) <> "" then
    intCodTurma = Trim(Request("cmbTurma"))
else
    intCodTurma = Trim(Request("cmbTurmaProfessor"))
end if

intCodCurso = Trim(Request.Form("cmbCurso"))
intCodPeriodo = Trim(Request.Form("cmbPeriodo"))
strCodAluno = Trim(Request("chkAluno"))

buscaHistorico = "N"
msnHistorico = ""
if Trim(intSemestreAtual) = "3" then
    if Trim(intAnoLetivoAtual) <> Trim(Session("strAnoLetivo")) then
        buscaHistorico = "S"
        msnHistorico = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
    end if
else
    if Trim(intAnoLetivoAtual) <> Trim(Session("strAnoLetivo")) or Trim(intSemestreAtual) <> Trim(Session("strSemestre")) then
        buscaHistorico = "S"
        msnHistorico = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
    end if
end if

strTituloRelatorio = "Fechamento de Notas por Disciplinas<br>" & msnHistorico
sub mostraCabecalho()
%>
<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
<br>
<%
end sub

' ----------------------------------------------------------------------------
' Dados do periodo/curso
' ----------------------------------------------------------------------------
sql = "SELECT P.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO, P.COD_CURSO "
sql = sql & " FROM SCA_PERIODO P "
sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO "
sql = sql & " WHERE P.COD_PERIODO = " & intCodPeriodo
rs.open sql, cnn
if not rs.eof then
    strDescricaoPeriodo = rs("PERIODO")
    strDescricaoCurso = rs("CURSO")
    intCodCurso = rs("COD_CURSO")
end if
rs.close

' ----------------------------------------------------------------------------
' Criterio de avaliacao - mesma estrutura do relatorio individual
' ----------------------------------------------------------------------------
sql = "select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
sql = sql & " from SCA_CRITERIO_AVALIACAO ca "
sql = sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo "
sql = sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo "
sql = sql & " where ca.ano_letivo = " & strAnoLetivo
sql = sql & " and ca.cod_curso = " & intCodCurso
sql = sql & " order by c.posicao"

vetCampo = Null
rs.open sql, cnn
if not rs.eof then
    media_aprovacao = rs("media_aprovacao")
    vetCampo = rs.getRows
else
    rs.close
%>
<script>
alert("O critério de avaliação não foi criado para esse curso.");
window.history.back();
</script>
<%
    response.end
end if
rs.close

' ----------------------------------------------------------------------------
' Dados da turma
' ----------------------------------------------------------------------------
sql = "SELECT TOP 1 T.NOMETURMA, TU.DESC_TURNO, T.TurmaAluno "
sql = sql & " FROM SCA_TURMA T "
sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO "
sql = sql & " WHERE T.COD_EMPRESA = " & strCod_empresa
sql = sql & " AND T.COD_TURMA = " & intCodTurma
rs.open sql, cnn
if not rs.eof then
    strNomeTurma = rs("NOMETURMA")
    strDescricaoTurno = rs("DESC_TURNO")
    strTurmaAluno = rs("TurmaAluno")
else
    strNomeTurma = ""
    strDescricaoTurno = ""
	strTurmaAluno = ""
end if
rs.close

' ----------------------------------------------------------------------------
' Disciplinas da turma/grade - dinamicas.
' Mantemos codigo + descricao para montar as colunas e localizar os valores.
' ----------------------------------------------------------------------------
sql = "SELECT DISTINCT D.COD_DISCIPLINA, D.DESC_DISCIPLINA "
sql = sql & " FROM SCA_TURMA T "
sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = T.Cod_GradeCurricular "
sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = GCD.COD_DISCIPLINA "
sql = sql & " WHERE D.DOCUMENTO_OFICIAL='S' AND T.COD_EMPRESA = " & strCod_empresa
sql = sql & " AND T.COD_TURMA = " & intCodTurma
sql = sql & " ORDER BY D.DESC_DISCIPLINA"

rs.open sql, cnn
if rs.eof then
    rs.close
%>
<script>
alert("Nenhuma disciplina foi encontrada para a turma selecionada.");
window.history.back();
</script>
<%
    response.end
end if
vetDisciplinas = rs.getRows
rs.close

' Dicionario para localizar a coluna de cada disciplina pelo codigo.
Set dicIndiceDisciplina = Server.CreateObject("Scripting.Dictionary")
for iDisc = 0 to UBound(vetDisciplinas,2)
    dicIndiceDisciplina(CStr(vetDisciplinas(0,iDisc))) = iDisc
next

if strCodAluno = "" then
%>
<script>
alert("Aluno não foi encontrado, verifique.");
window.history.back();
</script>
<%
    response.end
end if

mostraCabecalho
%>
<table class="quadroInfo">
    <tr>
        <td class="rotulo">Composição de Ensino</td>
        <td class="valor" colspan="5"><%=strDescricaoCurso%></td>
    </tr>
    <tr>
        <td class="rotulo">Turma</td>
        <td class="valor"><%=strNomeTurma%> - <%=strDescricaoPeriodo%>&nbsp;<%=strTurmaAluno%></td>
        <td class="rotulo">Série</td>
        <td class="valor"><%=strDescricaoPeriodo%></td>
        <td class="rotulo">Ano Letivo</td>
        <td class="valor"><%=intAnoLetivoAtual%></td>
    </tr>
    <tr>
        <td class="rotulo">Turno</td>
        <td class="valor"><%=strDescricaoTurno%></td>
        <td class="rotulo">Data Emissão</td>
        <td class="valor"><%=Right("0" & Day(Date),2) & "/" & Right("0" & Month(Date),2) & "/" & Year(Date)%></td>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>

<table class="gradeGeral">
<tr>
    <th class="ord">Nº</th>
    <th class="aluno">Nome do aluno</th>
<%
for iDisc = 0 to UBound(vetDisciplinas,2)
%>
    <th class="disc" title="<%=vetDisciplinas(1,iDisc)%>"><%=UCase(vetDisciplinas(1,iDisc))%></th>
<%
next
%>
    <th class="situacao">Situação</th>
</tr>
<%
' ----------------------------------------------------------------------------
' Consulta geral: uma linha por aluno/disciplina.
' Nao filtra uma disciplina especifica.
' ----------------------------------------------------------------------------
if buscaHistorico = "S" then
    sql = " SELECT A.CODIGO, A.MATRICULA, A.NOMEALUNO, HED.COD_DISCIPLINA, D.DESC_DISCIPLINA, "
    sql = sql & " SA.DESC_SITUACAOALUNO, T.NOMETURMA, TU.DESC_TURNO, "
    for i = 0 to UBound(vetCampo,2)
        strPos = vetCampo(0,i)
        if IsNumeric(strPos) then
            if CInt(strPos) < 10 then strPos = "0" & CInt(strPos)
            sql = sql & " HED.NOTA" & strPos & ", "
        end if
    next
    sql = sql & " HED.SITUACAO AS SITUACAO_NOTA "
    sql = sql & " FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
    sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
    sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
    sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = HED.COD_TURMA AND T.ANOLETIVO = HED.ANO_LETIVO AND T.COD_SEMESTRE = HED.SEMESTRE AND T.COD_EMPRESA = HE.COD_EMPRESA "
    sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO "
    sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
    sql = sql & " LEFT JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO FE ON FE.COD_ALUNO = HE.COD_ALUNO AND FE.ANO_LETIVO = HED.ANO_LETIVO AND FE.COD_TURMA = HED.COD_TURMA "
    sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = FE.COD_SITUACAOALUNO_ATUAL "
    sql = sql & " WHERE HE.COD_EMPRESA = " & strCod_empresa
    sql = sql & " AND HED.COD_TURMA = " & intCodTurma
    sql = sql & " AND A.CODIGO IN (" & strCodAluno & ")"
    sql = sql & " AND HED.ANO_LETIVO = " & intAnoLetivoAtual
    sql = sql & " AND HED.SEMESTRE = " & intSemestreAtual
    sql = sql & " ORDER BY A.NOMEALUNO, D.DESC_DISCIPLINA "
else
    sql = " SELECT A.CODIGO, A.MATRICULA, A.NOMEALUNO, AD.COD_DISCIPLINA, D.DESC_DISCIPLINA, "
    sql = sql & " SA.DESC_SITUACAOALUNO, "
    for i = 0 to UBound(vetCampo,2)
        strPos = vetCampo(0,i)
        if IsNumeric(strPos) then
            if CInt(strPos) < 10 then strPos = "0" & CInt(strPos)
            sql = sql & " NF.NOTA" & strPos & ", "
        end if
    next
    sql = sql & " NF.SITUACAO AS SITUACAO_NOTA "
    sql = sql & " FROM SCA_ALUNO_TURMA AT "
    sql = sql & " INNER JOIN SCA_ALUNO A ON AT.COD_ALUNO = A.CODIGO AND AT.SITUACAO IN ('A','C','T') "
    sql = sql & " INNER JOIN SCA_TURMA T ON AT.COD_TURMA = T.COD_TURMA AND AT.COD_EMPRESA = T.COD_EMPRESA "
    sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA AD ON AD.COD_ALUNO = A.CODIGO AND AD.COD_TURMA = T.COD_TURMA AND AD.COD_EMPRESA = T.COD_EMPRESA "
    sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = AD.COD_DISCIPLINA "
    sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = T.Cod_GradeCurricular AND GCD.Cod_Disciplina = AD.COD_DISCIPLINA "
    sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS NF ON NF.COD_ALUNO = A.CODIGO AND NF.COD_EMPRESA = AD.COD_EMPRESA AND NF.COD_DISCIPLINA = AD.COD_DISCIPLINA AND NF.COD_ALUNO_DISCIPLINA = AD.CODIGO "
    sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = (SELECT TOP 1 CSA.COD_SITUACAOALUNO FROM SCA_CONTROLE_SITUACAO_ALUNO CSA WHERE CSA.COD_ALUNO = A.CODIGO AND CSA.ANO_LETIVO = T.ANOLETIVO AND CSA.COD_EMPRESA = T.COD_EMPRESA ORDER BY CSA.CODIGO DESC) "
    sql = sql & " WHERE T.COD_EMPRESA = " & strCod_empresa
    sql = sql & " AND AT.COD_TURMA = " & intCodTurma
    sql = sql & " AND A.CODIGO IN (" & strCodAluno & ")"
    sql = sql & " ORDER BY A.NOMEALUNO, D.DESC_DISCIPLINA "
end if

rs.open sql, cnn

if not rs.eof then
    codAlunoAtual = ""
    intOrdem = 0
    Set dicValores = Server.CreateObject("Scripting.Dictionary")
    strSituacaoAlunoAtual = ""
    strNomeAlunoAtual = ""
    alunoTemDisciplinaReprovada = False

    do while not rs.eof
        codAlunoRegistro = CStr(rs("CODIGO"))

        ' Mudou de aluno: imprime o aluno anterior antes de iniciar o novo.
        if codAlunoAtual <> "" and codAlunoRegistro <> codAlunoAtual then
            intOrdem = intOrdem + 1
%>
<tr>
    <td class="ord"><%=intOrdem%></td>
    <td class="aluno"><%=UCase(strNomeAlunoAtual)%></td>
<%
            for iDisc = 0 to UBound(vetDisciplinas,2)
                chaveDisc = CStr(vetDisciplinas(0,iDisc))
                valorCelula = "-"
                if dicValores.Exists(chaveDisc) then valorCelula = dicValores(chaveDisc)
%>
    <td class="disc"><%=valorCelula%></td>
<%
            next

            classeSituacao = ""
            situacaoExibir = strSituacaoAlunoAtual
            if situacaoExibir = "" then situacaoExibir = "Cursando"

            strSituacaoComparar = UCase(Trim(situacaoExibir & ""))

        ' Somente a situacao ATIVO e substituida pelo relatorio.
        ' Demais situacoes (TRANSFERIDO, DEIXOU DE FREQUENTAR etc.) sao preservadas.
        if strSituacaoComparar = "ATIVO" then
            if mostra_resultado = "S" then
                ' Com resultado: verifica o Para Fechar de todas as disciplinas.
                alunoTemDisciplinaReprovada = False
                for iDiscResultado = 0 to UBound(vetDisciplinas,2)
                chaveDiscResultado = CStr(vetDisciplinas(0,iDiscResultado))
                if dicValores.Exists(chaveDiscResultado) then
                    valorResultado = dicValores(chaveDiscResultado)
                    if valorResultado <> "-" then
                        valorResultadoNumerico = Replace(CStr(valorResultado), ".", "")
                        valorResultadoNumerico = Replace(valorResultadoNumerico, ",", ".")
                        if IsNumeric(valorResultadoNumerico) then
                        if CDbl(valorResultadoNumerico) > 0 then alunoTemDisciplinaReprovada = True
                        end if
                    end if
                end if
                next

                if alunoTemDisciplinaReprovada then
                situacaoExibir = "Reprovado"
                else
                situacaoExibir = "Aprovado"
                end if
            else
                ' Sem resultado final: ATIVO e exibido como CURSANDO.
                situacaoExibir = "Cursando"
            end if
        end if

        if InStr(UCase(situacaoExibir),"TRANSFER") > 0 or InStr(UCase(situacaoExibir),"DEIXOU") > 0 then classeSituacao = "situacaoEspecial"
%>
    <td class="situacao <%=classeSituacao%>"><%=situacaoExibir%></td>
</tr>
<%
            Set dicValores = Server.CreateObject("Scripting.Dictionary")
            alunoTemDisciplinaReprovada = False
        end if

        if codAlunoRegistro <> codAlunoAtual then
            codAlunoAtual = codAlunoRegistro
            strNomeAlunoAtual = rs("NOMEALUNO")
            strSituacaoAlunoAtual = ""
            if not IsNull(rs("DESC_SITUACAOALUNO")) then strSituacaoAlunoAtual = Trim(CStr(rs("DESC_SITUACAOALUNO")))
        end if

        codDiscRegistro = CStr(rs("COD_DISCIPLINA"))
        dblSomaNotas = 0

        ' Mesma regra validada no relatorio individual:
        ' usa apenas os tipos 1..4 e bimestre sem nota vale zero.
        for i = 0 to UBound(vetCampo,2)
            strPos = ""
            strTipoCampo = ""
            if not IsNull(vetCampo(0,i)) then strPos = Trim(CStr(vetCampo(0,i)))
            if not IsNull(vetCampo(4,i)) then strTipoCampo = Trim(CStr(vetCampo(4,i)))

            if IsNumeric(strPos) and IsNumeric(strTipoCampo) then
                if CInt(strTipoCampo) >= 1 and CInt(strTipoCampo) <= 4 then
                    if CInt(strPos) < 10 then strPos = "0" & CInt(strPos)
                    vlNotaCampo = rs("NOTA" & strPos)
                    if not IsNull(vlNotaCampo) then
                        if IsNumeric(vlNotaCampo) then dblSomaNotas = dblSomaNotas + CDbl(vlNotaCampo)
                    end if
                end if
            end if
        next

        strParaFechar = "-"
        if not IsNull(media_aprovacao) then
            if IsNumeric(media_aprovacao) then
                dblMediaAprovacao = CDbl(media_aprovacao)
                dblMediaProjetada = Round(dblSomaNotas / 4, 1)
                dblTotalNecessario = dblMediaAprovacao * 4

                if dblMediaProjetada >= dblMediaAprovacao then
                    strParaFechar = "0"
                else
                    dblParaFechar = dblTotalNecessario - dblSomaNotas
                    if dblParaFechar < 0 then dblParaFechar = 0
                    strParaFechar = FormatNumber(dblParaFechar,1)
                    if dblParaFechar > 0 then alunoTemDisciplinaReprovada = True
                end if
            end if
        end if

        dicValores(codDiscRegistro) = strParaFechar
        rs.movenext
    loop

    ' Imprime o ultimo aluno.
    if codAlunoAtual <> "" then
        intOrdem = intOrdem + 1
%>
<tr>
    <td class="ord"><%=intOrdem%></td>
    <td class="aluno"><%=UCase(strNomeAlunoAtual)%></td>
<%
        for iDisc = 0 to UBound(vetDisciplinas,2)
            chaveDisc = CStr(vetDisciplinas(0,iDisc))
            valorCelula = "-"
            if dicValores.Exists(chaveDisc) then valorCelula = dicValores(chaveDisc)
%>
    <td class="disc"><%=valorCelula%></td>
<%
        next
        classeSituacao = ""
        situacaoExibir = strSituacaoAlunoAtual
        if situacaoExibir = "" then situacaoExibir = "Cursando"

        strSituacaoComparar = UCase(Trim(situacaoExibir & ""))

        ' Somente a situacao ATIVO e substituida pelo relatorio.
        ' Demais situacoes (TRANSFERIDO, DEIXOU DE FREQUENTAR etc.) sao preservadas.
        if strSituacaoComparar = "ATIVO" then
            if mostra_resultado = "S" then
                ' Com resultado: verifica o Para Fechar de todas as disciplinas.
                alunoTemDisciplinaReprovada = False
                for iDiscResultado = 0 to UBound(vetDisciplinas,2)
                    chaveDiscResultado = CStr(vetDisciplinas(0,iDiscResultado))
                    if dicValores.Exists(chaveDiscResultado) then
                        valorResultado = dicValores(chaveDiscResultado)
                        if valorResultado <> "-" then
                            valorResultadoNumerico = Replace(CStr(valorResultado), ".", "")
                            valorResultadoNumerico = Replace(valorResultadoNumerico, ",", ".")
                            if IsNumeric(valorResultadoNumerico) then
                                if CDbl(valorResultadoNumerico) > 0 then alunoTemDisciplinaReprovada = True
                            end if
                        end if
                    end if
                next

                if alunoTemDisciplinaReprovada then
                    situacaoExibir = "Reprovado"
                else
                    situacaoExibir = "Aprovado"
                end if
            else
                ' Sem resultado final: ATIVO e exibido como CURSANDO.
                situacaoExibir = "Cursando"
            end if
        end if

        if InStr(UCase(situacaoExibir),"TRANSFER") > 0 or InStr(UCase(situacaoExibir),"DEIXOU") > 0 then classeSituacao = "situacaoEspecial"
%>
    <td class="situacao <%=classeSituacao%>"><%=situacaoExibir%></td>
</tr>
<%
    end if
else
%>
<tr><td colspan="<%=UBound(vetDisciplinas,2)+4%>" style="text-align:center;">Nenhum aluno encontrado.</td></tr>
<%
end if
rs.close
%>
</table>

<script>
    aguarde.style.display="none";
</script>
</body>
</html>
