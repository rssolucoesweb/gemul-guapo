<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Expires = 0
Response.Buffer = True
Response.Charset = "utf-8"
Response.ContentType = "text/html"
Server.ScriptTimeout = 1200
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>GEMUL - Total de Aulas Mensal</title>
    <link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
    <style>
        body { font-family: Arial, sans-serif; font-size: 11px; color: #000; }
        .titulo { text-align: center; font-size: 15px; font-weight: bold; margin: 8px 0 12px; }
        .filtros { margin-bottom: 8px; }
        .tabela { width: 100%; border-collapse: collapse; table-layout: fixed; }
        .tabela th, .tabela td { border: 1px solid #000; padding: 4px 3px; }
        .tabela th { font-weight: bold; text-align: center; }
        .numero { text-align: center; font-weight: bold; }
        .aguardando { background: #fff9e6; }
        .nao-validado { background: #ff9fa3; }
        .validado { background: #c4e6a1; }
        .observacao { background: #bad5eb; }
        .ministrado { background: #ffe49b; }
        .saldo-negativo { color: #b00020; }
        .sem-registro { padding: 20px; text-align: center; font-weight: bold; }
        @media print {
            @page { size: A4 landscape; margin: 8mm; }
            .noPrint { display: none !important; }
            body { margin: 0; padding: 0; }
            .tabela { border-collapse: separate !important; border-spacing: 0 !important; border-top: 1pt solid #000; border-left: 1pt solid #000; }
            .tabela th, .tabela td { border-top: 0 !important; border-left: 0 !important; border-right: 1pt solid #000 !important; border-bottom: 1pt solid #000 !important; }
        }
    </style>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<%
Function InteiroSeguro(valor)
    If IsNumeric(valor) Then
        InteiroSeguro = CLng(valor)
    Else
        InteiroSeguro = 0
    End If
End Function

intCodColaborador		= Trim(Request("cmbProfessor"))
if intCodColaborador = "" then intCodColaborador = "0"
intCodTurma             = Trim(Request("cmbTurmaProfessor"))
intCodTurnoTela             = Trim(Request("cmbTurnoDoProfessor"))
if intCodTurnoTela = "" then intCodTurnoTela = "0"
intCodDisciplina        = Trim(Request("cmbDisciplinaDoProfessor"))
if intCodDisciplina = "" then intCodDisciplina = "0"
strAnoLetivo		 	= Trim(Request.Form("txtAnoLetivo"))
semestre		 	= Trim(Request.Form("cmbSemestre"))
if semestre="1" then strSemestre = "1º"
if semestre="2" then strSemestre = "2º"
if semestre="3" then strSemestre = "Anual"
mes				= trim(request("cmbMes")) 		

'sql="select Cod_Turno from SCA_TURMA where Cod_Turma =" & intCodTurma
sql="select Cod_Turno, desc_turno "
sql=sql & " from SRH_TURNO "
sql=sql & " where Cod_Turno =" & intCodTurnoTela
rs.open sql, cnn
if rs.eof = false then
	intCodTurnoTela = rs("Cod_Turno")
	strTurno = rs("desc_turno")
end if
rs.close

if intCodDisciplina <> "0" then
	sql="select desc_disciplina from sca_disciplina"
	sql=sql & " where cod_disciplina =" & intCodDisciplina
	rs.open sql, cnn
	if rs.eof = false then
		strDisciplina = rs("desc_disciplina")
	end if
	rs.close	
else
	strDisciplina = "Todos"
end if

strTurma="Todas"
sql="select tu.NomeTurma, tu.TurmaAluno, pe.Descricao as periodo, cu.Descricao as curso, t.Desc_Turno as turno "
sql=sql & " from sca_turma tu"
sql=sql & " inner join SCA_PERIODO pe on pe.Cod_Periodo = tu.Cod_periodo"
sql=sql & " inner join SCA_curso cu on cu.Cod_curso=pe.Cod_Curso"
sql=sql & " inner join SCA_turno t on t.Cod_Turno = tu.Cod_Turno"
sql=sql & " where tu.Cod_Turma=" & intCodTurma
rs.open sql, cnn
if rs.eof = false then
	strCurso = rs("curso")
	strPeriodo = rs("periodo")
	strTurma = rs("NomeTurma") & " " & rs("TurmaAluno") & " (" & rs("turno") & ")"
end if
rs.close

'Response.write "<br>strAnoLetivo:" & strAnoLetivo
'Response.write "<br>mes:" & mes
'Response.write "<br>intCodColaborador:" & intCodColaborador
'Response.write "<br>intCodTurnoTela:" & intCodTurnoTela

If strAnoLetivo = "" Or mes < 1 Or mes > 12 Or intCodTurnoTela = "0" Then
    Response.Write "<div class='sem-registro'><br><br><br><br>Parâmetros inválidos para emissão do relatório.</div>"
    Response.End
End If

nomesMeses = Array("", "JANEIRO", "FEVEREIRO", "MARÇO", "ABRIL", "MAIO", "JUNHO", "JULHO", "AGOSTO", "SETEMBRO", "OUTUBRO", "NOVEMBRO", "DEZEMBRO")
strTituloRelatorio = "PLANEJAMENTO<br>Total de Aulas - " & nomesMeses(mes)  & "/" & strAnoLetivo

nomeProfessor = ""
Set cmdNome = Server.CreateObject("ADODB.Command")
Set cmdNome.ActiveConnection = cnn
cmdNome.CommandText = "SELECT nome FROM SRH_COLABORADOR WHERE codigo = ?"
cmdNome.CommandType = 1
cmdNome.Parameters.Append cmdNome.CreateParameter("@codigo", 3, 1, , intCodColaborador)
Set rsNome = cmdNome.Execute
If Not rsNome.EOF Then nomeProfessor = rsNome("nome")
rsNome.Close
Set rsNome = Nothing
Set cmdNome = Nothing

Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = cnn
cmd.CommandText = "SP_SCA_RelatorioTotalAulasMensal"
cmd.CommandType = 4
cmd.CommandTimeout = 1200
cmd.Parameters.Append cmd.CreateParameter("@cod_empresa", 3, 1, , CLng(Session("CodEmpresa")))
cmd.Parameters.Append cmd.CreateParameter("@ano_letivo", 3, 1, , strAnoLetivo)
cmd.Parameters.Append cmd.CreateParameter("@semestre", 3, 1, , semestre)
cmd.Parameters.Append cmd.CreateParameter("@mes", 3, 1, , mes)
cmd.Parameters.Append cmd.CreateParameter("@cod_colaborador", 3, 1, , intCodColaborador)
cmd.Parameters.Append cmd.CreateParameter("@cod_turno", 3, 1, , intCodTurnoTela)
cmd.Parameters.Append cmd.CreateParameter("@cod_turma", 3, 1, , intCodTurma)
cmd.Parameters.Append cmd.CreateParameter("@cod_disciplina", 3, 1, , intCodDisciplina)

'sql = "exec SP_SCA_RelatorioTotalAulasMensal " & Session("CodEmpresa") & "," & strAnoLetivo & "," & semestre & "," & mes & "," & intCodColaborador & "," & intCodTurnoTela & "," & intCodTurma & "," & intCodDisciplina
'response.write sql

Set rs = cmd.Execute
%>
<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
<div class="filtros" style="text-align: center;">
    <strong>Ano letivo:</strong> <%=strAnoLetivo%>
    &nbsp;&nbsp;|&nbsp;&nbsp; <strong>Semestre:</strong> <%=strSemestre%>
    &nbsp;&nbsp;|&nbsp;&nbsp; <strong>Turno:</strong> <%=strTurno%>
	
	<%if nomeProfessor<>"" then%>
    &nbsp;&nbsp;|&nbsp;&nbsp; <strong>Professor(a):</strong> <%=Server.HTMLEncode(nomeProfessor)%>
	<%end if%>
</div>
<% If rs.EOF Then %>
    <div class="sem-registro">Nenhuma aula encontrada para os filtros informados.</div>
<% Else %>
    <table class="tabela">
        <colgroup>
            <col style="width:8%"><col style="width:17%"><col style="width:12%">
            <col style="width:12%"><col style="width:10%"><col style="width:17%">
            <col style="width:11%"><col style="width:7%"><col style="width:6%">
        </colgroup>
        <thead>
            <tr>
                <th rowspan="2">Turma</th>
                <th rowspan="2">Disciplina</th>
                <th colspan="5">Total de Aulas - <%=nomesMeses(mes)%></th>
                <th rowspan="2">Matriz mensal</th>
                <th rowspan="2">Saldo Ministrado</th>
            </tr>
            <tr>
                <th class="aguardando">Aguardando Planejamento</th>
                <th class="nao-validado">Planejado e não validado</th>
                <th class="validado">Planejado e validado</th>
                <th class="observacao">Planejado e validado com observação</th>
                <th class="ministrado">Conteúdo Ministrado</th>
            </tr>
        </thead>
        <tbody>
        <% Do While Not rs.EOF %>
            <tr>
                <td><%=Server.HTMLEncode(rs("turma") & "")%></td>
                <td><%=Server.HTMLEncode(rs("disciplina") & "")%></td>
                <td class="numero aguardando"><%=rs("aguardando_planejamento")%></td>
                <td class="numero nao-validado"><%=rs("planejado_nao_validado")%></td>
                <td class="numero validado"><%=rs("planejado_validado")%></td>
                <td class="numero observacao"><%=rs("planejado_validado_observacao")%></td>
                <td class="numero ministrado"><%=rs("conteudo_ministrado")%></td>
                <td class="numero"><%=rs("matriz_mensal")%></td>
                <td class="numero <%If CLng(rs("saldo_ministrado")) < 0 Then Response.Write "saldo-negativo"%>"><%=rs("saldo_ministrado")%></td>
            </tr>
            <% rs.MoveNext %>
        <% Loop %>
        </tbody>
    </table>
<% End If
rs.Close
Set rs = Nothing
Set cmd = Nothing
%>
</body>
<script>
	aguarde.style.display="none";
</script>

</html>
