<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/inc_cnn.asp"-->
<%

Function NumeroSeguro(valor, padrao)
    If IsNumeric(valor) Then
        NumeroSeguro = CLng(valor)
    Else
        NumeroSeguro = CLng(padrao)
    End If
End Function

Dim codAluno, codTurma, anoLetivo, semestre, codPeriodo, codEmpresa
Dim rs, rsCalc, rsDisc, sql
Dim nomeAluno, matricula, descPeriodo, nomeTurma
Dim calcCodigos(), calcDescricoes(), qtdCalculos, i

codEmpresa = NumeroSeguro(Session("CodEmpresa"), 0)
codAluno   = NumeroSeguro(Request.QueryString("codAluno"), 0)
codTurma   = NumeroSeguro(Request.QueryString("codTurma"), 0)
anoLetivo  = NumeroSeguro(Request.QueryString("anoLetivo"), 0)
semestre   = NumeroSeguro(Request.QueryString("semestre"), 0)
codPeriodo = NumeroSeguro(Request.QueryString("codPeriodo"), 0)

If codEmpresa = 0 Or codAluno = 0 Or codTurma = 0 Or anoLetivo = 0 Or semestre = 0 Or codPeriodo = 0 Then
    Response.Write "<script>alert('Parâmetros inválidos para configuração.');window.close();</script>"
    Response.End
End If

Set rs = Server.CreateObject("ADODB.Recordset")
Set rsCalc = Server.CreateObject("ADODB.Recordset")
Set rsDisc = Server.CreateObject("ADODB.Recordset")

nomeAluno = ""
matricula = ""
descPeriodo = ""
nomeTurma = ""

sql = " SELECT A.NOMEALUNO, A.MATRICULA, P.Descricao AS DESC_PERIODO, T.NomeTurma " & _
      " FROM SCA_ALUNO A " & _
      " INNER JOIN SCA_TURMA T ON T.Cod_Turma = " & codTurma & " AND T.Cod_Empresa = " & codEmpresa & _
      " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular " & _
      " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo " & _
      " WHERE A.CODIGO = " & codAluno
rs.Open sql, cnn
If Not rs.EOF Then
    nomeAluno = rs("NOMEALUNO")
    matricula = rs("MATRICULA")
    descPeriodo = rs("DESC_PERIODO")
    nomeTurma = rs("NomeTurma")
End If
rs.Close

qtdCalculos = 0
sql = " SELECT codigo, descricao FROM SCA_CALCULO " & _
      " WHERE cod_tipo_calculo = 1 AND cod_tipo_lancamento IN (1,2,3,4) " & _
      " ORDER BY posicao "
rsCalc.Open sql, cnn
Do While Not rsCalc.EOF
    ReDim Preserve calcCodigos(qtdCalculos)
    ReDim Preserve calcDescricoes(qtdCalculos)
    calcCodigos(qtdCalculos) = CLng(rsCalc("codigo"))
    calcDescricoes(qtdCalculos) = CStr(rsCalc("descricao"))
    qtdCalculos = qtdCalculos + 1
    rsCalc.MoveNext
Loop
rsCalc.Close

sql = " SELECT DISTINCT AD.COD_DISCIPLINA, D.Desc_Disciplina, ISNULL(D.ordem,999) AS ordem " & _
      " FROM SCA_ALUNO_DISCIPLINA AD " & _
      " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = AD.COD_DISCIPLINA " & _
      " WHERE AD.COD_EMPRESA = " & codEmpresa & _
      " AND AD.COD_ALUNO = " & codAluno & _
      " AND (AD.COD_TURMA = " & codTurma & " OR AD.COD_TURMA_REMANEJAMENTO = " & codTurma & ") " & _
      " ORDER BY ISNULL(D.ordem,999), D.Desc_Disciplina "
rsDisc.Open sql, cnn

'Lista das configuracoes que ja existiam ao abrir a tela.
'Usada no processamento para limpar notas somente quando houver uma NOVA marcacao.
Dim configOriginais, rsOrig
configOriginais = ""
Set rsOrig = Server.CreateObject("ADODB.Recordset")
sql = " SELECT ME.COD_DISCIPLINA, ME.COD_CALCULO " & _
      " FROM SCA_ALUNO_MEDIA_ESPECIAL ME " & _
      " INNER JOIN SCA_CALCULO C ON C.codigo = ME.COD_CALCULO " & _
      " WHERE ME.COD_EMPRESA = " & codEmpresa & _
      " AND ME.COD_ALUNO = " & codAluno & _
      " AND ME.ANO_LETIVO = " & anoLetivo & _
      " AND ME.SEMESTRE = " & semestre & _
      " AND ME.COD_PERIODO = " & codPeriodo & _
      " AND C.cod_tipo_calculo = 1 " & _
      " AND C.cod_tipo_lancamento IN (1,2,3,4) "
rsOrig.Open sql, cnn
Do While Not rsOrig.EOF
    If configOriginais <> "" Then configOriginais = configOriginais & ","
    configOriginais = configOriginais & CLng(rsOrig("COD_DISCIPLINA")) & "|" & CLng(rsOrig("COD_CALCULO"))
    rsOrig.MoveNext
Loop
rsOrig.Close
Set rsOrig = Nothing
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="utf-8">
<title>Configuração de Critério de Avaliação - Média Diferenciada</title>
<style>
body{font-family:Arial,Helvetica,sans-serif;margin:0;background:#f5f5f5;color:#333;font-size:13px}.topo{background:#fff;border-bottom:1px solid #ddd;padding:16px 20px;display:flex;justify-content:space-between;align-items:center}.topo h2{margin:0;font-size:18px;font-weight:600}.conteudo{padding:18px}.card{background:#fff;border:1px solid #ddd;border-radius:4px;margin-bottom:15px}.dados{padding:14px 18px}.linha{display:flex;gap:25px;margin:6px 0}.rotulo{font-weight:bold;min-width:90px}.valor{font-weight:600}.tabela{width:100%;border-collapse:collapse}.tabela th,.tabela td{border:1px solid #ddd;padding:9px}.tabela th{background:#f0f0f0;text-align:center}.tabela td:first-child{text-align:left}.tabela td{text-align:center}.obs{font-size:13px;margin:15px 0;padding:10px 12px;color:#dc3545;background:#fff5f5;border:1px solid #f5c2c7;border-radius:4px;font-weight:600}.acoes{text-align:center;padding:12px}.btn{border-radius:4px;padding:8px 18px;cursor:pointer;margin:0 4px;background:transparent;font-weight:400}.btn-outline-success{color:#28a745;border:1px solid #28a745}.btn-outline-success:hover{color:#fff;background:#28a745}.btn-outline-warning{color:#ffc107;border:1px solid #ffc107}.btn-outline-warning:hover{color:#212529;background:#ffc107}.btn-outline-secondary{color:#6c757d;border:1px solid #6c757d}.btn-outline-secondary:hover{color:#fff;background:#6c757d}.fechar{font-size:24px;border:0;background:transparent;cursor:pointer}.msg{padding:10px 14px;margin-bottom:12px;border-radius:4px;background:#d4edda;border:1px solid #c3e6cb;color:#155724}
</style>
<script>
function limparMarcacoes(){
    var itens=document.querySelectorAll('input[name="chkMedia"]');
    for(var i=0;i<itens.length;i++){itens[i].checked=false;}
}
function confirmarAlteracao(){
    return confirm("ATENÇÃO!\n\nAo salvar esta configuração, eventuais notas já lançadas nos bimestres NOVAMENTE selecionados serão excluídas.\n\nTambém serão limpos os resultados calculados por fórmula e o campo de média da disciplina, pois precisarão ser recalculados conforme a nova configuração.\n\nAs notas excluídas não serão restauradas automaticamente se a configuração for desmarcada posteriormente.\n\nDeseja continuar?");
}
</script>
</head>
<body>
<div class="topo"><h2>Configuração de Critério de Avaliação - Média Diferenciada</h2><button class="fechar" onclick="window.close()">&times;</button></div>
<div class="conteudo">
<% If Request.QueryString("salvo") = "S" Then %><div class="msg">Configuração salva com sucesso.</div><% End If %>
<div class="card dados">
    <div class="linha"><span class="rotulo">Matrícula:</span><span class="valor"><%=Server.HTMLEncode(matricula & " - " & nomeAluno)%></span></div>
    <div class="linha"><span class="rotulo">Série:</span><span><%=Server.HTMLEncode(descPeriodo)%></span></div>
    <div class="linha"><span class="rotulo">Turma:</span><span><%=Server.HTMLEncode(nomeTurma)%></span></div>
    <div class="linha"><span class="rotulo">Ano/Semestre:</span><span><%=anoLetivo%> / <%=semestre%></span></div>
</div>
<form method="post" action="sca_aluno_media_especial_cod.asp" onsubmit="return confirmarAlteracao();">
<input type="hidden" name="codAluno" value="<%=codAluno%>">
<input type="hidden" name="codTurma" value="<%=codTurma%>">
<input type="hidden" name="anoLetivo" value="<%=anoLetivo%>">
<input type="hidden" name="semestre" value="<%=semestre%>">
<input type="hidden" name="codPeriodo" value="<%=codPeriodo%>">
<input type="hidden" name="configOriginais" value="<%=Server.HTMLEncode(configOriginais)%>">
<div class="card">
<table class="tabela">
<thead><tr><th>Disciplina</th><th colspan="<%=qtdCalculos%>">Critério de avaliação diferenciado - Média Diferenciada</th></tr>
<tr><th></th><% For i = 0 To qtdCalculos - 1 %><th><%=Server.HTMLEncode(calcDescricoes(i))%></th><% Next %></tr></thead>
<tbody>
<%
Dim codDisciplina, marcado, rsMarc
Set rsMarc = Server.CreateObject("ADODB.Recordset")
If rsDisc.EOF Then
    Response.Write "<tr><td colspan='" & (qtdCalculos + 1) & "'>Nenhuma disciplina encontrada para o aluno.</td></tr>"
Else
    Do While Not rsDisc.EOF
        codDisciplina = CLng(rsDisc("COD_DISCIPLINA"))
%>
<tr><td><%=Server.HTMLEncode(rsDisc("Desc_Disciplina"))%></td>
<%      For i = 0 To qtdCalculos - 1
            marcado = ""
            sql = " SELECT TOP 1 CODIGO FROM SCA_ALUNO_MEDIA_ESPECIAL " & _
                  " WHERE COD_EMPRESA=" & codEmpresa & _
                  " AND COD_ALUNO=" & codAluno & _
                  " AND ANO_LETIVO=" & anoLetivo & _
                  " AND SEMESTRE=" & semestre & _
                  " AND COD_PERIODO=" & codPeriodo & _
                  " AND COD_DISCIPLINA=" & codDisciplina & _
                  " AND COD_CALCULO=" & calcCodigos(i)
            rsMarc.Open sql, cnn
            If Not rsMarc.EOF Then marcado = " checked"
            rsMarc.Close
%><td><input type="checkbox" name="chkMedia" value="<%=codDisciplina%>|<%=calcCodigos(i)%>"<%=marcado%>></td><%
        Next
%></tr>
<%
        rsDisc.MoveNext
    Loop
End If
rsDisc.Close
Set rsMarc = Nothing
%>
</tbody></table>
</div>
<div class="obs"><strong>*</strong> Selecione os bimestres em que <strong>não serão cadastradas notas</strong> para o aluno.</div>
<div class="acoes"><button type="submit" class="btn btn-outline-success">Alterar</button><button type="button" class="btn btn-outline-warning" onclick="limparMarcacoes()">Limpar</button><button type="button" class="btn btn-outline-secondary" onclick="window.close()">Retornar</button></div>
</form>
</div>
</body>
</html>
<%
Set rsDisc = Nothing
Set rsCalc = Nothing
Set rs = Nothing
%>
