<%
Function HtmlValor(valor)
    If IsNull(valor) Then
        HtmlValor = ""
    Else
        HtmlValor = Server.HTMLEncode(CStr(valor))
    End If
End Function

Function DoisDigitos(valor)
    DoisDigitos = Right("0" & CStr(valor), 2)
End Function

acao = "I"
intCodigo = Trim(Request.Form("txtCodigo"))
intCodConsultorio = ""
intCodProfissional = ""
intCodHorario = ""
intCodConsultorioFiltro = 0

intAnoLetivo = Year(Date())
If Trim(CStr(Session("strAnoLetivo"))) <> "" And IsNumeric(Session("strAnoLetivo")) Then
    intAnoLetivo = CInt(Session("strAnoLetivo"))
ElseIf Trim(CStr(Session("AnoLetivo"))) <> "" And IsNumeric(Session("AnoLetivo")) Then
    intAnoLetivo = CInt(Session("AnoLetivo"))
End If

intSemestre = 3
If Trim(Request.Form("txtAnoLetivo")) <> "" And IsNumeric(Request.Form("txtAnoLetivo")) Then
    intAnoLetivo = CInt(Request.Form("txtAnoLetivo"))
End If

If Trim(CStr(Session("strSemestre"))) <> "" And IsNumeric(Session("strSemestre")) Then
    If CInt(Session("strSemestre")) = 1 Or CInt(Session("strSemestre")) = 2 Or CInt(Session("strSemestre")) = 3 Then
        intSemestre = CInt(Session("strSemestre"))
    End If
End If

If Trim(Request.Form("cmbSemestre")) <> "" And IsNumeric(Request.Form("cmbSemestre")) Then
    If CInt(Request.Form("cmbSemestre")) = 1 Or CInt(Request.Form("cmbSemestre")) = 2  Or CInt(Request.Form("cmbSemestre")) = 3 Then
        intSemestre = CInt(Request.Form("cmbSemestre"))
    End If
End If

If IsNumeric(intCodConsultorio) Then intCodConsultorioFiltro = CLng(intCodConsultorio)

If intCodigo <> "" And IsNumeric(intCodigo) Then
    sql = "SELECT A.Cod_Atendimento, A.Cod_Consultorio, A.Cod_Profissional, A.Cod_Horario, "
    sql = sql & "H.anoLetivo, H.semestre "
    sql = sql & "FROM AEE_ATENDIMENTO A "
    sql = sql & "INNER JOIN AEE_HORARIO H ON H.cod_horario = A.Cod_Horario "
    sql = sql & "WHERE A.Cod_Atendimento = " & CLng(intCodigo) & " "
    sql = sql & "AND H.cod_empresa = " & CLng(Session("CodEmpresa"))

    rs.Open sql, cnn
    If Not rs.EOF Then
        intCodigo = rs("Cod_Atendimento")
        intCodConsultorio = rs("Cod_Consultorio")
        intCodProfissional = rs("Cod_Profissional")
        intCodHorario = rs("Cod_Horario")
        intAnoLetivo = rs("anoLetivo")
        intSemestre = rs("semestre")
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
            <i class="subheader-icon fal fa-calendar-check"></i> <%=pagina%>
            <small><%=descricao_pagina%></small>
        </h1>
    </div>

    <div class="row">
        <div class="col-xl-12">
            <div id="panel-1" class="panel">
                <div class="panel-hdr">
                    <h2><%=pagina%></h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                        <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">
                        <div class="panel-tag">
                            Vincule um profissional a um consultório e horário de atendimento. Um mesmo consultório não poderá possuir mais de um profissional no mesmo horário.
                        </div>

                        <form id="frm" name="frm" method="post">
                            <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=HtmlValor(intCodigo)%>">

                            <div class="row">
                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <label class="form-label">Ano letivo:</label>
                                        <input name="txtAnoLetivo" type="number" class="form-control" id="txtAnoLetivo" min="2000" max="2100" value="<%=HtmlValor(intAnoLetivo)%>" <% If acao = "AE" Then Response.Write "readonly" %>>
                                    </div>
                                </div>

                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <label class="form-label">Semestre:</label>
                                        <select name="cmbSemestre" id="cmbSemestre" class="form-control" <% If acao = "AE" Then Response.Write "disabled" %>>
                                            <option value="0">Selecione...</option>
                                            <option value="3" <% If CStr(intSemestre) = "3" Then Response.Write "selected" %>>Anual</option>
                                            <option value="1" <% If CStr(intSemestre) = "1" Then Response.Write "selected" %>>1º Semestre</option>
                                            <option value="2" <% If CStr(intSemestre) = "2" Then Response.Write "selected" %>>2º Semestre</option>
                                        </select>
                                        <% If acao = "AE" Then %>
                                            <input type="hidden" name="cmbSemestre" value="<%=HtmlValor(intSemestre)%>">
                                        <% End If %>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="form-label">Consultório:</label>
                                        <select name="cmbConsultorio" id="cmbConsultorio" class="form-control">
                                            <option value="0">Selecione...</option>
                                            <%
                                            sql = "SELECT c.Cod_Consultorio, c.NomeConsultorio, c.AnoLetivo, c.situacao "
                                            sql = sql & " FROM AEE_CONSULTORIO C"
                                            sql = sql & " WHERE c.Cod_Empresa = " & CLng(Session("CodEmpresa")) & " "
                                            sql = sql & " AND c.AnoLetivo = " & CLng(intAnoLetivo) & " "
                                            sql = sql & " 										  AND ("
                                            sql = sql & "     c.Situacao = 'A'"
                                            sql = sql & "     OR Cod_Consultorio = " & intCodConsultorioFiltro & " "
                                            sql = sql & "   )"
											sql = sql & " ORDER BY c.NomeConsultorio"
                                            rs.Open sql, cnn
                                            While Not rs.EOF
												%>
													<option value="<%=rs("Cod_Consultorio")%>" <% If CStr(intCodConsultorio) = CStr(rs("Cod_Consultorio")) Then Response.Write "selected" %>><%=HtmlValor(rs("NomeConsultorio"))%> <% If CStr(rs("Situacao")) <> "A" Then Response.Write " (INATIVO)" %></option>
												<%
                                                rs.MoveNext
                                            Wend
                                            rs.Close
                                            %>
                                        </select>
										
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="form-label">Profissional:</label>
                                        <select name="cmbProfissional" id="cmbProfissional" class="form-control">
                                            <option value="0">Selecione...</option>
                                            <%
                                            sql = "SELECT P.Cod_Profissional, C.Nome, E.Descricao AS Especialidade "
                                            sql = sql & " FROM AEE_PROFISSIONAL P "
                                            sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = P.Cod_Colaborador "
                                            sql = sql & " LEFT JOIN AEE_ESPECIALIDADE E ON E.Cod_Especialidade = P.Cod_Especialidade "
                                            sql = sql & " ORDER BY C.Nome, E.Descricao"
                                            rs.Open sql, cnn
                                            While Not rs.EOF
                                            %>
                                                <option value="<%=rs("Cod_Profissional")%>" <% If CStr(intCodProfissional) = CStr(rs("Cod_Profissional")) Then Response.Write "selected" %>><%=HtmlValor(ucase(rs("Nome")))%><% If Not IsNull(rs("Especialidade")) And Trim(CStr(rs("Especialidade"))) <> "" Then Response.Write " - " & HtmlValor(rs("Especialidade")) %></option>
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
                                        <label class="form-label">Horários de atendimento:</label>
                                        <div class="border rounded p-3" id="listaHorarios">
                                            <%
                                            sql = "SELECT H.cod_horario, H.hora_Inicio, H.minuto_Inicio, H.hora_termino, H.minuto_termino, "
                                            sql = sql & "H.Cod_Turno, ISNULL(T.DESC_TURNO, 'SEM TURNO') AS DESC_TURNO "
                                            sql = sql & "FROM AEE_HORARIO H "
                                            sql = sql & "LEFT JOIN SCA_TURNO T ON T.Cod_Turno = H.Cod_Turno "
                                            sql = sql & "WHERE H.cod_empresa = " & CLng(Session("CodEmpresa")) & " "
                                            sql = sql & "AND H.anoLetivo = " & CLng(intAnoLetivo) & " "
                                            sql = sql & "AND H.semestre = " & CLng(intSemestre) & " "
                                            sql = sql & "ORDER BY T.DESC_TURNO, H.hora_Inicio, H.minuto_Inicio"

                                            rs.Open sql, cnn
                                            strTurnoAnterior = ""
                                            intQtdeHorarios = 0
                                            While Not rs.EOF
                                                intQtdeHorarios = intQtdeHorarios + 1
                                                strTurnoAtual = CStr(rs("DESC_TURNO"))

                                                If strTurnoAnterior <> strTurnoAtual Then
                                                    If strTurnoAnterior <> "" Then
                                                        Response.Write "</div>"
                                                    End If
                                            %>
                                                    <div class="d-flex align-items-center justify-content-between mb-2 <% If strTurnoAnterior <> "" Then Response.Write "mt-3" %>">
                                                        <strong><%=HtmlValor(strTurnoAtual)%></strong>
                                                        <% If acao = "I" Then %>
                                                            <button type="button" class="btn btn-xs btn-outline-primary" onclick="marcarTurno('<%=rs("Cod_Turno")%>', true); return false;">Marcar todos</button>
                                                        <% End If %>
                                                    </div>
                                                    <div class="row">
                                            <%
                                                    strTurnoAnterior = strTurnoAtual
                                                End If

                                                blnMarcado = (CStr(intCodHorario) = CStr(rs("cod_horario")))
                                            %>
                                                <div class="col-sm-6 mb-2">
                                                    <div class="custom-control custom-checkbox">
                                                        <input type="checkbox"
                                                               class="custom-control-input chkHorario"
                                                               name="chkHorario"
                                                               id="chkHorario_<%=rs("cod_horario")%>"
                                                               value="<%=rs("cod_horario")%>"
                                                               data-turno="<%=rs("Cod_Turno")%>"
                                                               <% If blnMarcado Then Response.Write "checked" %>>
                                                        <label class="custom-control-label" for="chkHorario_<%=rs("cod_horario")%>">
                                                            <%=DoisDigitos(rs("hora_Inicio"))%>:<%=DoisDigitos(rs("minuto_Inicio"))%> às <%=DoisDigitos(rs("hora_termino"))%>:<%=DoisDigitos(rs("minuto_termino"))%>
                                                        </label>
                                                    </div>
                                                </div>
                                            <%
                                                rs.MoveNext
                                            Wend

                                            If strTurnoAnterior <> "" Then Response.Write "</div>"
                                            rs.Close

                                            If intQtdeHorarios = 0 Then
                                            %>
                                                <div class="alert alert-warning mb-0">
                                                    Nenhum horário cadastrado para o ano letivo e semestre selecionados.
                                                </div>
                                            <%
                                            End If
                                            %>
                                        </div>

                                        <% If acao = "I" And intQtdeHorarios > 0 Then %>
                                            <div class="mt-2">
                                                <button type="button" class="btn btn-xs btn-outline-primary" onclick="marcarTodosHorarios(true); return false;">Marcar todos</button>
                                                <button type="button" class="btn btn-xs btn-outline-secondary" onclick="marcarTodosHorarios(false); return false;">Desmarcar todos</button>
                                            </div>
                                            <small class="form-text text-muted">Você pode selecionar vários horários e cadastrá-los de uma única vez.</small>
                                        <% ElseIf acao = "AE" Then %>
                                            <small class="form-text text-muted">Na alteração, selecione somente um horário. Para cadastrar vários horários, utilize um novo vínculo.</small>
                                        <% End If %>
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

    <div class="row">
        <div class="col-xl-12">
            <div id="panel-2" class="panel">
                <div class="panel-hdr">
                    <h2>Atendimentos vinculados</h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                    </div>
                </div>
                <div class="panel-container show">
                    <div class="panel-content">
                        <div class="table-responsive-lg">
                            <table class="table table-bordered table-hover table-striped w-100">
                                <thead class="bg-primary-600">
                                    <tr>
                                        <th>Consultório</th>
                                        <th>Profissional</th>
                                        <th>Especialidade</th>
                                        <th>Turno</th>
                                        <th>Horário</th>
                                        <th>Ano</th>
                                        <th>Semestre</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                sql = "SELECT A.Cod_Atendimento AS codigo, CO.NomeConsultorio, C.Nome AS Profissional, "
                                sql = sql & " E.Descricao AS Especialidade, T.DESC_TURNO, H.hora_Inicio, H.minuto_Inicio, "
                                sql = sql & " H.hora_termino, H.minuto_termino, H.anoLetivo, H.semestre "
                                sql = sql & " FROM AEE_ATENDIMENTO A "
                                sql = sql & " INNER JOIN AEE_CONSULTORIO CO ON CO.Cod_Consultorio = A.Cod_Consultorio "
                                sql = sql & " INNER JOIN AEE_PROFISSIONAL P ON P.Cod_Profissional = A.Cod_Profissional "
                                sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = P.Cod_Colaborador "
                                sql = sql & " LEFT JOIN AEE_ESPECIALIDADE E ON E.Cod_Especialidade = P.Cod_Especialidade "
                                sql = sql & " INNER JOIN AEE_HORARIO H ON H.cod_horario = A.Cod_Horario "
                                sql = sql & " LEFT JOIN SCA_TURNO T ON T.Cod_Turno = H.Cod_Turno "
                                sql = sql & " WHERE CO.Cod_Empresa = " & CLng(Session("CodEmpresa")) & " "
                                sql = sql & " AND H.cod_empresa = " & CLng(Session("CodEmpresa")) & " "
                                sql = sql & " ORDER BY H.anoLetivo DESC, H.semestre, CO.NomeConsultorio, T.DESC_TURNO, H.hora_Inicio, H.minuto_Inicio "

                                rs.Open sql, cnn
                                intTotal = 0
                                While Not rs.EOF
                                    intTotal = intTotal + 1
									semestre = ""
									if rs("semestre")="3" then semestre = "Anual"
									if rs("semestre")="1" then semestre = "1º"
									if rs("semestre")="2" then semestre = "2º"
                                %>
                                    <tr style="cursor: pointer" onclick="return resultadoConsulta('<%=rs("codigo")%>')">
                                        <td><%=HtmlValor(rs("NomeConsultorio"))%></td>
                                        <td><%=HtmlValor(ucase(rs("Profissional")))%></td>
                                        <td><%=HtmlValor(rs("Especialidade"))%></td>
                                        <td><%=HtmlValor(rs("DESC_TURNO"))%></td>
                                        <td><%=DoisDigitos(rs("hora_Inicio"))%>:<%=DoisDigitos(rs("minuto_Inicio"))%> às <%=DoisDigitos(rs("hora_termino"))%>:<%=DoisDigitos(rs("minuto_termino"))%></td>
                                        <td><%=rs("anoLetivo")%></td>
                                        <td><%=semestre%></td>
                                    </tr>
                                <%
                                    rs.MoveNext
                                Wend
                                rs.Close
                                %>
                                </tbody>
                            </table>
                        </div>
                        <div class="mt-2"><strong>Total de registros:</strong> <%=intTotal%></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
