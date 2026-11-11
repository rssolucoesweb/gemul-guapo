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
intAnoLetivo = ""
strNomeConsultorio = ""
intCapacidade = ""
strSituacao = "A"

If Session("AnoLetivo") <> "" And IsNumeric(Session("AnoLetivo")) Then
    intAnoLetivo = Session("AnoLetivo")
Else
    intAnoLetivo = Year(Date())
End If

If intCodigo <> "" And IsNumeric(intCodigo) Then
    sql = "SELECT Cod_Consultorio, Cod_Empresa, AnoLetivo, NomeConsultorio, Capacidade, Situacao "
    sql = sql & "FROM AEE_CONSULTORIO "
    sql = sql & "WHERE Cod_Consultorio = " & CLng(intCodigo) & " "
    sql = sql & "AND Cod_Empresa = " & CLng(Session("CodEmpresa"))

    rs.Open sql, cnn
    If Not rs.EOF Then
        intCodigo = rs("Cod_Consultorio")
        If Not IsNull(rs("AnoLetivo")) Then intAnoLetivo = rs("AnoLetivo")
        If Not IsNull(rs("NomeConsultorio")) Then strNomeConsultorio = rs("NomeConsultorio")
        intCapacidade = rs("Capacidade")
        If Not IsNull(rs("Situacao")) Then strSituacao = rs("Situacao")
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
            <i class="subheader-icon fal fa-clinic-medical"></i> <%=pagina%>
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
                                <div class="col-sm-2">
                                    <div class="form-group">
                                        <label class="form-label">Ano letivo:</label>
                                        <input name="txtAnoLetivo" type="number" class="form-control" id="txtAnoLetivo" min="2000" max="2100" value="<%=HtmlValor(intAnoLetivo)%>">
                                    </div>
                                </div>

                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <label class="form-label">Nome do consultório:</label>
                                        <input name="txtNomeConsultorio" type="text" class="form-control" id="txtNomeConsultorio" maxlength="60" value="<%=HtmlValor(strNomeConsultorio)%>">
                                    </div>
                                </div>

                                <div class="col-sm-2">
                                    <div class="form-group">
                                        <label class="form-label">Capacidade:</label>
                                        <input name="txtCapacidade" type="number" class="form-control" id="txtCapacidade" min="1" maxlength="5" value="<%=HtmlValor(intCapacidade)%>">
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
    sql = "SELECT C.Cod_Consultorio AS codigo, C.AnoLetivo, C.NomeConsultorio, C.Capacidade, C.Situacao"
    sql = sql & " FROM AEE_CONSULTORIO C "
    sql = sql & " WHERE C.Cod_Empresa = " & CLng(Session("CodEmpresa")) & " "
	sql = sql & " AND C.ANOLETIVO = " & intAnoLetivo
    sql = sql & " ORDER BY C.AnoLetivo DESC, C.NomeConsultorio"
	rs.Open sql, cnn
    If Not rs.EOF Then
    %>
        <div class="row">
            <div class="col-xl-10">
                <div class="panel">
                    <div class="panel-hdr">
                        <h2>Consultórios cadastrados</h2>
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
                                            <th><strong>Consultório</strong></th>
                                            <th><strong>Ano letivo</strong></th>
                                            <th><strong>Capacidade</strong></th>
                                            <th><strong>Situação</strong></th>
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
                                            <td class="celula"><%=HtmlValor(rs("NomeConsultorio"))%></td>
                                            <td class="celula"><%=HtmlValor(rs("AnoLetivo"))%></td>
                                            <td class="celula"><%=HtmlValor(rs("Capacidade"))%></td>
                                            <td class="celula"><%=situacao%></td>
                                        </tr>
                                    <%
                                        rs.MoveNext
                                    Wend
                                    %>
                                        <tr>
                                            <td colspan="4" class="celula">Total Registros : <%=cont%></td>
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
