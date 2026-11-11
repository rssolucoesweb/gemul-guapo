<%
Function HtmlValor(valor)
    If IsNull(valor) Then
        HtmlValor = ""
    Else
        HtmlValor = Server.HTMLEncode(CStr(valor))
    End If
End Function

acao = "I"
intCodigo = Trim(Request.Form("txtCodigo"))
intCodColaborador = ""
intCodEspecialidade = ""

If intCodigo <> "" And IsNumeric(intCodigo) Then
    sql = "SELECT Cod_Profissional, Cod_Colaborador, Cod_Especialidade "
    sql = sql & "FROM AEE_PROFISSIONAL "
    sql = sql & "WHERE Cod_Profissional = " & CLng(intCodigo)

    rs.Open sql, cnn
    If Not rs.EOF Then
        intCodigo = rs("Cod_Profissional")
        intCodColaborador = rs("Cod_Colaborador")
        If Not IsNull(rs("Cod_Especialidade")) Then intCodEspecialidade = rs("Cod_Especialidade")
        acao = "AE"
    Else
        intCodigo = ""
        acao = "I"
    End If
    rs.Close
End If
%>

<main id="js-page-content" role="main" class="page-content">
    <ol class="breadcrumb page-breadcrumb">
        <li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
        <li class="breadcrumb-item"><%=modulo%></li>
        <li class="breadcrumb-item active"><%=pagina%></li>
        <li class="position-absolute pos-top pos-right d-none d-sm-block"><%=Session("data_hoje")%></li>
    </ol>

    <div class="subheader">
        <h1 class="subheader-title">
            <i class="subheader-icon fal fa-user-md"></i> <%=pagina%>
            <small><%=descricao_pagina%></small>
        </h1>
    </div>

    <div class="row">
        <div class="col-xl-10">
            <div id="panel-1" class="panel">
                <div class="panel-hdr">
                    <h2><%=pagina%> <span class="fw-300"><i></i></span></h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                        <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">
                        <% If mensagem_alerta_pagina <> "" Then %>
                            <div class="panel-tag"><%=mensagem_alerta_pagina%></div>
                        <% End If %>

                        <form id="frm" name="frm" method="post">
                            <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=HtmlValor(intCodigo)%>">

                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="form-label">Colaborador:</label>
                                        <select name="cmbColaborador" id="cmbColaborador" class="form-control">
                                            <option value="0">Selecione...</option>
                                            <%
                                            sql = "SELECT codigo, nome, codFuncional FROM SRH_COLABORADOR where codLotacao=" & session("codempresa")& " and situacao='A' ORDER BY nome"
                                            rs.Open sql, cnn
                                            While Not rs.EOF
                                            %>
                                                <option value="<%=rs("codigo")%>" <% If CStr(intCodColaborador) = CStr(rs("codigo")) Then Response.Write "selected" %>><%=HtmlValor(ucase(rs("nome")))%> (<%=rs("codFuncional")%>)</option>
                                            <%
                                                rs.MoveNext
                                            Wend
                                            rs.Close
                                            %>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="form-label">Especialidade:</label>
                                        <select name="cmbEspecialidade" id="cmbEspecialidade" class="form-control">
                                            <option value="0">Selecione...</option>
                                            <%
                                            sql = "SELECT Cod_Especialidade, Descricao, Situacao "
                                            sql = sql & "FROM AEE_ESPECIALIDADE "
                                            sql = sql & "WHERE Situacao = 'A' "
                                            If intCodEspecialidade <> "" And IsNumeric(intCodEspecialidade) Then
                                                sql = sql & "OR Cod_Especialidade = " & CLng(intCodEspecialidade) & " "
                                            End If
                                            sql = sql & "ORDER BY Descricao"

                                            rs.Open sql, cnn
                                            While Not rs.EOF
                                                strEspecialidade = HtmlValor(rs("Descricao"))
                                                If rs("Situacao") = "I" Then strEspecialidade = strEspecialidade & " (INATIVA)"
                                            %>
                                                <option value="<%=rs("Cod_Especialidade")%>" <% If CStr(intCodEspecialidade) = CStr(rs("Cod_Especialidade")) Then Response.Write "selected" %>><%=strEspecialidade%></option>
                                            <%
                                                rs.MoveNext
                                            Wend
                                            rs.Close
                                            %>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <br>
                            <div class="frame-wrap">
                                <!--#include file="includes/inc_botoes_cadastro.asp"-->
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%
    cont = 0
    sql = "SELECT P.Cod_Profissional AS codigo, C.Nome AS colaborador, "
    sql = sql & "E.Descricao AS especialidade, E.Situacao AS situacao_especialidade "
    sql = sql & "FROM AEE_PROFISSIONAL P "
    sql = sql & "INNER JOIN SRH_COLABORADOR C ON C.Codigo = P.Cod_Colaborador "
    sql = sql & "LEFT JOIN AEE_ESPECIALIDADE E ON E.Cod_Especialidade = P.Cod_Especialidade "
    sql = sql & "ORDER BY C.Nome, E.Descricao"

    rs.Open sql, cnn
    If Not rs.EOF Then
    %>
        <div class="row">
            <div class="col-xl-10">
                <div class="panel">
                    <div class="panel-hdr">
                        <h2>Profissionais cadastrados</h2>
                        <div class="panel-toolbar">
                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                        </div>
                    </div>
                    <div class="panel-container show">
                        <div class="panel-content">
                            <div class="panel-tag"><span class="fw-300">Para editar clique na linha abaixo.</span></div>
                            <div class="table-responsive-lg">
                                <table class="table table-bordered table-hover m-0">
                                    <thead class="thead-themed">
                                        <tr>
                                            <th><strong>Colaborador</strong></th>
                                            <th><strong>Especialidade</strong></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                    While Not rs.EOF
                                        cont = cont + 1
                                        strEspecialidadeLista = HtmlValor(rs("especialidade"))
                                        If Not IsNull(rs("situacao_especialidade")) Then
                                            If rs("situacao_especialidade") = "I" Then strEspecialidadeLista = strEspecialidadeLista & " (INATIVA)"
                                        End If
                                    %>
                                        <tr style="cursor:pointer" onclick="return resultadoConsulta('<%=rs("codigo")%>')">
                                            <td class="celula"><%=HtmlValor(ucase(rs("colaborador")))%></td>
                                            <td class="celula"><%=strEspecialidadeLista%></td>
                                        </tr>
                                    <%
                                        rs.MoveNext
                                    Wend
                                    %>
                                        <tr>
                                            <td colspan="2" class="celula">Total Registros : <%=cont%></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <%
    End If
    rs.Close
    %>
</main>

<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
