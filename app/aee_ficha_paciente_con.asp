<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>GEMUL - Consulta Ficha do Paciente AEE</title>
    <!--#include file="includes/inc_verificaSessionApp.asp"-->
    <!--#include file="includes/inc_cnn.asp"-->
    <!--#include file="inc_meta.asp"-->
    <!--#include file="inc_css.asp"-->
    <!--#include file="inc_ico.asp"-->
</head>
<body class="nav-function-top header-function-fixed">
<%
Function H(v)
    If IsNull(v) Then H = "" Else H = Server.HTMLEncode(CStr(v))
End Function

Function J(v)
    If IsNull(v) Then v = ""
    v = Replace(CStr(v), "\\", "\\\\")
    v = Replace(v, "'", "\\'")
    v = Replace(v, vbCrLf, " ")
    v = Replace(v, vbCr, " ")
    v = Replace(v, vbLf, " ")
    J = v
End Function

pagina_inicial_do_modulo = "aee.asp"
pagina_atual = "/app/aee_ficha_paciente_con.asp"
menu_principal = "Atendimento Educacional"
sistema = "GEMUL"
sistema_sigla = "AEE"
modulo = "AEE"
pagina = "Consulta - Ficha do Paciente"
descricao_pagina = "Localização de alunos da rede e pacientes externos cadastrados no AEE."

filtroNome = Trim(Request("txtNome"))
filtroDocumento = Replace(Replace(Replace(Trim(Request("txtDocumento")), ".", ""), "-", ""), " ", "")
filtroTipo = UCase(Trim(Request("cmbTipoPaciente")))
consultar = Trim(Request("consultar"))
modo = LCase(Trim(Request("modo")))
bolSelecao = (modo = "selecao")
%>
<% If Not bolSelecao Then %>
<div class="page-wrapper"><div class="page-inner">
<!--#include file="inc_lado_esquerdo.asp"-->
<div class="page-content-wrapper">
<!--#include file="inc_cabecalho.asp"-->
<% End If %>
<main id="js-page-content" role="main" class="page-content">
    <div class="subheader"><h1 class="subheader-title"><i class="subheader-icon fal fa-search"></i> <%=pagina%><small><%=descricao_pagina%></small></h1></div>
    <div class="panel">
        <div class="panel-hdr"><h2>Filtros</h2></div>
        <div class="panel-container show"><div class="panel-content">
            <form method="post" action="aee_ficha_paciente_con.asp">
                <input type="hidden" name="consultar" value="S">
                <input type="hidden" name="modo" value="<%=H(modo)%>">
                <div class="row">
                    <div class="col-md-5 form-group"><label class="form-label">Nome</label><input name="txtNome" class="form-control" value="<%=H(filtroNome)%>"></div>
                    <div class="col-md-3 form-group"><label class="form-label">Matrícula / CPF</label><input name="txtDocumento" class="form-control" value="<%=H(Request("txtDocumento"))%>"></div>
                    <div class="col-md-2 form-group"><label class="form-label">Tipo</label><select name="cmbTipoPaciente" class="form-control"><option value="">Todos</option><option value="R" <%If filtroTipo="R" Then Response.Write("selected")%>>Aluno da Rede</option><option value="E" <%If filtroTipo="E" Then Response.Write("selected")%>>Paciente Externo</option></select></div>
                    <div class="col-md-2 form-group pt-4"><button class="btn btn-primary btn-block"><i class="fal fa-search"></i> Consultar</button></div>
                </div>
            </form>
        </div></div>
    </div>

<%If consultar<>"" Then
    sql = "SELECT F.Cod_Ficha_Paciente,F.Tipo_Paciente,F.Situacao," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN A.NOMEALUNO ELSE P.NomeAluno END AS NomePaciente," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN CAST(A.MATRICULA AS VARCHAR(20)) ELSE '' END AS Matricula," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN A.CPF ELSE P.CPF END AS CPF," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN A.DATANASCIMENTO ELSE P.DataNascimento END AS DataNascimento " & _
          "FROM AEE_FICHA_PACIENTE F " & _
          "LEFT JOIN SCA_ALUNO A ON A.CODIGO=F.Cod_Aluno AND F.Tipo_Paciente='R' " & _
          "LEFT JOIN AEE_PACIENTE_EXTERNO P ON P.Cod_Paciente_Externo=F.Cod_Paciente_Externo AND F.Tipo_Paciente='E' " & _
          "WHERE F.Cod_Empresa=" & CLng(Session("CodEmpresa")) & " AND F.Situacao='A'"
    If filtroTipo="R" Or filtroTipo="E" Then sql = sql & " AND F.Tipo_Paciente='" & filtroTipo & "'"
    If filtroNome<>"" Then sql = sql & " AND (CASE WHEN F.Tipo_Paciente='R' THEN A.NOMEALUNO ELSE P.NomeAluno END) COLLATE Latin1_General_CI_AI LIKE '%" & Replace(filtroNome,"'","''") & "%'"
    If filtroDocumento<>"" Then sql = sql & " AND ((F.Tipo_Paciente='R' AND REPLACE(CAST(A.MATRICULA AS VARCHAR(20)),' ','')='" & Replace(filtroDocumento,"'","''") & "') OR (REPLACE(REPLACE(CASE WHEN F.Tipo_Paciente='R' THEN A.CPF ELSE P.CPF END,'.',''),'-','')='" & Replace(filtroDocumento,"'","''") & "'))"
    sql = sql & " ORDER BY NomePaciente"
    rs.Open sql, cnn
%>
    <div class="panel"><div class="panel-hdr"><h2>Pacientes encontrados</h2></div><div class="panel-container show"><div class="panel-content">
    <div class="table-responsive"><table class="table table-bordered table-hover m-0"><thead class="thead-themed"><tr><th>Nome</th><th>Tipo</th><th>Matrícula</th><th>CPF</th><th>Data nascimento</th></tr></thead><tbody>
    <%If rs.EOF Then%>
        <tr><td colspan="5" class="text-center text-muted">Nenhum paciente encontrado.</td></tr>
    <%Else
      Do While Not rs.EOF
        strTipoDesc = "Paciente Externo"
        If rs("Tipo_Paciente")="R" Then strTipoDesc = "Aluno da Rede"
        If bolSelecao Then
            strClick = "selecionarPaciente(" & rs("Cod_Ficha_Paciente") & ", '" & J(rs("Tipo_Paciente")) & "', '" & J(rs("Matricula")) & "', '" & J(rs("CPF")) & "', '" & J(rs("NomePaciente")) & "')"
        Else
            strClick = "location.href='aee_ficha_paciente.asp?txtCodigo=" & rs("Cod_Ficha_Paciente") & "'"
        End If
    %>
        <tr style="cursor:pointer" onclick="<%=strClick%>">
            <td><%=H(rs("NomePaciente"))%></td>
            <td><%=strTipoDesc%></td>
            <td><%=H(rs("Matricula"))%></td>
            <td><%=H(rs("CPF"))%></td>
            <td><%If Not IsNull(rs("DataNascimento")) Then Response.Write(Right("0"&Day(rs("DataNascimento")),2)&"/"&Right("0"&Month(rs("DataNascimento")),2)&"/"&Year(rs("DataNascimento")))%></td>
        </tr>
    <%rs.MoveNext: Loop
      End If%>
    </tbody></table></div>
    </div></div></div>
<%rs.Close
 End If%>
    <%If bolSelecao Then%>
        <button type="button" class="btn btn-secondary" onclick="window.close();"><i class="fal fa-times"></i> Fechar</button>
    <%Else%>
        <a href="aee_ficha_paciente.asp" class="btn btn-secondary"><i class="fal fa-arrow-left"></i> Voltar</a>
    <%End If%>
</main>
<% If Not bolSelecao Then %>
<!--#include file="inc_rodape.asp"-->
</div></div></div>
<% End If %>
<script src="js/vendors.bundle.js"></script><script src="js/app.bundle.js"></script>
<script>
function selecionarPaciente(codFicha, tipo, matricula, cpf, nome){
    if(window.opener && !window.opener.closed && typeof window.opener.selecionarPacienteAEE === 'function'){
        window.opener.selecionarPacienteAEE(codFicha, tipo, matricula, cpf, nome);
        window.close();
        return;
    }
    alert('A tela que abriu esta consulta não está disponível.');
}
</script>
</body></html>
