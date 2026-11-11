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
strDescricao = ""
strSituacao = "A"
strBloqueiaCodigo = ""

If intCodigo <> "" And IsNumeric(intCodigo) Then
    sql = "SELECT Cod_Especialidade, Descricao, Situacao "
    sql = sql & "FROM AEE_ESPECIALIDADE "
    sql = sql & "WHERE Cod_Especialidade = " & CLng(intCodigo)

    rs.Open sql, cnn
    If Not rs.EOF Then
        intCodigo = rs("Cod_Especialidade")
        If Not IsNull(rs("Descricao")) Then strDescricao = rs("Descricao")
        If Not IsNull(rs("Situacao")) Then strSituacao = rs("Situacao")
        strBloqueiaCodigo = "readonly"
        acao = "AE"
    Else
        intCodigo = ""
        strBloqueiaCodigo = ""
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
            <i class="subheader-icon fal fa-stethoscope"></i> <%=pagina%>
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
                            <div class="row">
                                <div class="col-sm-2">
                                    <div class="form-group">
                                        <label class="form-label">Código:</label>
                                        <input name="txtCodigo" type="number" class="form-control" id="txtCodigo" min="1" value="<%=HtmlValor(intCodigo)%>" <%=strBloqueiaCodigo%>>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="form-label">Descrição:</label>
                                        <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" maxlength="50" value="<%=HtmlValor(strDescricao)%>">
                                    </div>
                                </div>

                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <label class="form-label">Situação:</label>
                                        <!--#include file="includes/inc_cmbSituacao.asp"-->
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
    sql = "SELECT Cod_Especialidade AS codigo, Descricao, Situacao "
    sql = sql & "FROM AEE_ESPECIALIDADE "
    sql = sql & "ORDER BY Descricao"

    rs.Open sql, cnn
    If Not rs.EOF Then
    %>
        <div class="row">
            <div class="col-xl-10">
                <div class="panel">
                    <div class="panel-hdr">
                        <h2>Especialidades cadastradas</h2>
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
                                            <th style="width:15%"><strong>Código</strong></th>
                                            <th><strong>Descrição</strong></th>
                                            <th style="width:20%"><strong>Situação</strong></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                    While Not rs.EOF
                                        cont = cont + 1
                                        situacao = ""
                                        If rs("Situacao") = "A" Then situacao = "Ativo"
                                        If rs("Situacao") = "I" Then situacao = "Inativo"
                                    %>
                                        <tr style="cursor:pointer" onclick="return resultadoConsulta('<%=rs("codigo")%>')">
                                            <td class="celula"><%=rs("codigo")%></td>
                                            <td class="celula"><%=HtmlValor(rs("Descricao"))%></td>
                                            <td class="celula"><%=situacao%></td>
                                        </tr>
                                    <%
                                        rs.MoveNext
                                    Wend
                                    %>
                                        <tr>
                                            <td colspan="3" class="celula">Total Registros : <%=cont%></td>
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
