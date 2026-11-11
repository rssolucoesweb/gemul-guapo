<%
Function HtmlValor(valor)
    If IsNull(valor) Then
        HtmlValor = ""
    Else
        HtmlValor = Server.HTMLEncode(CStr(valor))
    End If
End Function

Function DoisDigitos(valor)
    If IsNull(valor) Or Trim(CStr(valor)) = "" Then
        DoisDigitos = "00"
    Else
        DoisDigitos = Right("0" & CStr(valor), 2)
    End If
End Function

acao = "I"
intCodigo = Trim(Request.Form("txtCodigo"))
intCodTurno = ""
intHoraInicio = ""
intMinutoInicio = ""
intHoraTermino = ""
intMinutoTermino = ""

intAnoLetivo = ""
If Trim(CStr(Session("strAnoLetivo"))) <> "" And IsNumeric(Session("strAnoLetivo")) Then
    intAnoLetivo = Session("strAnoLetivo")
ElseIf Trim(CStr(Session("AnoLetivo"))) <> "" And IsNumeric(Session("AnoLetivo")) Then
    intAnoLetivo = Session("AnoLetivo")
Else
    intAnoLetivo = Year(Date())
End If

intSemestre = 1
If Trim(CStr(Session("strSemestre"))) <> "" And IsNumeric(Session("strSemestre")) Then
    If CInt(Session("strSemestre")) = 1 Or CInt(Session("strSemestre")) = 2 Or CInt(Session("strSemestre")) = 3 Then
        intSemestre = CInt(Session("strSemestre"))
    End If
End If

If intCodigo <> "" And IsNumeric(intCodigo) Then
    sql = "SELECT cod_horario, cod_empresa, anoLetivo, semestre, hora_Inicio, minuto_Inicio, "
    sql = sql & "hora_termino, minuto_termino, Cod_Turno "
    sql = sql & "FROM AEE_HORARIO "
    sql = sql & "WHERE cod_horario = " & CLng(intCodigo) & " "
    sql = sql & "AND cod_empresa = " & CLng(Session("CodEmpresa"))

    rs.Open sql, cnn
    If Not rs.EOF Then
        intCodigo = rs("cod_horario")
        intAnoLetivo = rs("anoLetivo")
        intSemestre = rs("semestre")
        If Not IsNull(rs("hora_Inicio")) Then intHoraInicio = rs("hora_Inicio")
        If Not IsNull(rs("minuto_Inicio")) Then intMinutoInicio = rs("minuto_Inicio")
        If Not IsNull(rs("hora_termino")) Then intHoraTermino = rs("hora_termino")
        If Not IsNull(rs("minuto_termino")) Then intMinutoTermino = rs("minuto_termino")
        If Not IsNull(rs("Cod_Turno")) Then intCodTurno = rs("Cod_Turno")
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
            <i class="subheader-icon fal fa-clock"></i> <%=pagina%>
            <small><%=descricao_pagina%></small>
        </h1>
    </div>

    <div class="row">
        <div class="col-xl-10">
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
                            Os horários são cadastrados por ano letivo, semestre e turno. Utilize o botão <strong>Gerar horários padrão</strong> para incluir automaticamente os horários padrão do Matutino e Vespertino.
                        </div>

                        <form id="frm" name="frm" method="post">
                            <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=HtmlValor(intCodigo)%>">

                            <div class="row">
                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <label class="form-label">Ano letivo:</label>
                                        <input name="txtAnoLetivo" type="number" class="form-control" id="txtAnoLetivo" min="2000" max="2100" value="<%=HtmlValor(intAnoLetivo)%>">
                                    </div>
                                </div>

                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <label class="form-label">Semestre:</label>
                                        <select name="cmbSemestre" id="cmbSemestre" class="form-control">
                                            <option value="0">Selecione...</option>
                                            <option value="3" <% If CStr(intSemestre) = "3" Then Response.Write "selected" %>>Anual</option>
                                            <option value="1" <% If CStr(intSemestre) = "1" Then Response.Write "selected" %>>1º Semestre</option>
                                            <option value="2" <% If CStr(intSemestre) = "2" Then Response.Write "selected" %>>2º Semestre</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="form-label">Turno:</label>
                                        <select name="cmbTurno" id="cmbTurno" class="form-control">
                                            <option value="0">Selecione...</option>
                                            <%
                                            sql = "SELECT Cod_Turno, DESC_TURNO FROM SCA_TURNO "
                                            sql = sql & "WHERE UPPER(LTRIM(RTRIM(DESC_TURNO))) LIKE 'MATUTINO%' "
                                            sql = sql & "OR UPPER(LTRIM(RTRIM(DESC_TURNO))) LIKE 'VESPERTINO%' "
                                            sql = sql & "ORDER BY DESC_TURNO"
                                            rs.Open sql, cnn
                                            While Not rs.EOF
                                            %>
                                                <option value="<%=rs("Cod_Turno")%>" <% If CStr(intCodTurno) = CStr(rs("Cod_Turno")) Then Response.Write "selected" %>><%=HtmlValor(rs("DESC_TURNO"))%></option>
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
                            <div class="row">
                                <div class="col-sm-6">
                                    <label class="form-label">Horário inicial:</label>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label class="form-label">Hora</label>
                                                <input name="txtHoraInicio" type="number" class="form-control" id="txtHoraInicio" min="0" max="23" placeholder="Hora" value="<%=HtmlValor(intHoraInicio)%>">
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label class="form-label">Minuto</label>
                                                <input name="txtMinutoInicio" type="number" class="form-control" id="txtMinutoInicio" min="0" max="59" placeholder="Minuto" value="<%=HtmlValor(intMinutoInicio)%>">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <label class="form-label">Horário término:</label>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label class="form-label">Hora</label>
                                                <input name="txtHoraTermino" type="number" class="form-control" id="txtHoraTermino" min="0" max="23" placeholder="Hora" value="<%=HtmlValor(intHoraTermino)%>">
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label class="form-label">Minuto</label>
                                                <input name="txtMinutoTermino" type="number" class="form-control" id="txtMinutoTermino" min="0" max="59" placeholder="Minuto" value="<%=HtmlValor(intMinutoTermino)%>">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <br>
                            <div class="frame-wrap">
                                <!--#include file="includes/inc_botoes_cadastro.asp"-->
                                <% If acao = "I" Then %>
                                    <button type="button" class="btn btn-info ml-2" onclick="return gerarHorariosPadrao();">
                                        <i class="fal fa-clock"></i> Gerar horários padrão
                                    </button>
                                <% End If %>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%
    cont = 0
    sql = "SELECT H.cod_horario AS codigo, H.anoLetivo, H.semestre, H.hora_Inicio, H.minuto_Inicio, "
    sql = sql & "H.hora_termino, H.minuto_termino, H.Cod_Turno, T.DESC_TURNO "
    sql = sql & "FROM AEE_HORARIO H "
    sql = sql & "LEFT JOIN SCA_TURNO T ON T.Cod_Turno = H.Cod_Turno "
    sql = sql & "WHERE H.cod_empresa = " & CLng(Session("CodEmpresa")) & " "
    sql = sql & "ORDER BY H.anoLetivo DESC, H.semestre, T.DESC_TURNO, H.hora_Inicio, H.minuto_Inicio"

    rs.Open sql, cnn
    If Not rs.EOF Then
    %>
        <div class="row">
            <div class="col-xl-10">
                <div class="panel">
                    <div class="panel-hdr">
                        <h2>Horários cadastrados</h2>
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
                                            <th><strong>Ano letivo</strong></th>
                                            <th><strong>Semestre</strong></th>
                                            <th><strong>Turno</strong></th>
                                            <th><strong>Horário inicial</strong></th>
                                            <th><strong>Horário término</strong></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                    While Not rs.EOF
                                        cont = cont + 1
										semestre=""
										if rs("semestre") = "3" then semestre = "Anual"
										if rs("semestre") = "1" then semestre = "1º Semestre"
										if rs("semestre") = "2" then semestre = "2º Semestre"
                                    %>
                                        <tr style="cursor:pointer" onclick="return resultadoConsulta('<%=rs("codigo")%>')">
                                            <td class="celula"><%=HtmlValor(rs("anoLetivo"))%></td>
                                            <td class="celula"><%=HtmlValor(semestre)%></td>
                                            <td class="celula"><%=HtmlValor(rs("DESC_TURNO"))%></td>
                                            <td class="celula"><%=DoisDigitos(rs("hora_Inicio"))%>:<%=DoisDigitos(rs("minuto_Inicio"))%></td>
                                            <td class="celula"><%=DoisDigitos(rs("hora_termino"))%>:<%=DoisDigitos(rs("minuto_termino"))%></td>
                                        </tr>
                                    <%
                                        rs.MoveNext
                                    Wend
                                    %>
                                        <tr>
                                            <td colspan="5" class="celula">Total Registros : <%=cont%></td>
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
