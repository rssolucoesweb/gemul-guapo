<%
Function HtmlValor(valor)
    If IsNull(valor) Then
        HtmlValor = ""
    Else
        HtmlValor = Server.HTMLEncode(CStr(valor))
    End If
End Function

Function TextoValor(valor)
    If IsNull(valor) Then
        TextoValor = ""
    Else
        TextoValor = Trim(CStr(valor))
    End If
End Function

Function DataTela(valor)
    If IsNull(valor) Or Trim(CStr(valor & "")) = "" Then
        DataTela = ""
    ElseIf IsDate(valor) Then
        DataTela = Right("0" & Day(CDate(valor)), 2) & "/" & Right("0" & Month(CDate(valor)), 2) & "/" & Year(CDate(valor))
    Else
        DataTela = CStr(valor)
    End If
End Function

Function SqlSeguro(valor)
    SqlSeguro = Replace(Trim(CStr(valor & "")), "'", "''")
End Function

Dim rsAee, rsPaciente, rsRecursos
Set rsAee = Server.CreateObject("ADODB.Recordset")
Set rsPaciente = Server.CreateObject("ADODB.Recordset")
Set rsRecursos = Server.CreateObject("ADODB.Recordset")

strBuscaPaciente = Trim(Request("txtBuscaPaciente"))
strTipoPacienteBusca = UCase(Trim(Request("cmbTipoPacienteBusca")))
strCodFichaPaciente = Trim(Request("txtCodFichaPaciente"))
strTipoPaciente = ""
strNomePaciente = ""
strMatricula = ""
strCPF = ""
intCodigo = 0
strDataAtendimento = ""
strAtendimento = ""
acao = "I"

If Trim(Request("txtCodigo")) <> "" And IsNumeric(Request("txtCodigo")) Then intCodigo = CLng(Request("txtCodigo"))

intCodConsultorio = Request("cmbConsultorio")
If intCodConsultorio = "" Then intCodConsultorio = "0"
intCodProfissional = Request("cmbProfissional")
If intCodProfissional = "" Then intCodProfissional = "0"

'=========================================================
' CARREGA O REGISTRO PARA ALTERAÇÃO
'=========================================================
If intCodigo > 0 Then
    sql = "SELECT A.Cod_Acompanhamento, A.Cod_Ficha_Paciente, AL.codigo as cod_aluno, A.Data_Atendimento, A.Atendimento, A.Cod_Consultorio, ISNULL(A.Cod_Profissional,'') AS Cod_Profissional," & _
          " F.Tipo_Paciente, " & _
          " CASE WHEN F.Tipo_Paciente='R' THEN AL.NomeAluno ELSE PE.NomeAluno END AS NomePaciente," & _
          " CASE WHEN F.Tipo_Paciente='R' THEN CAST(AL.Matricula AS VARCHAR(20)) ELSE '' END AS Matricula," & _
          " CASE WHEN F.Tipo_Paciente='R' THEN AL.CPF ELSE PE.CPF END AS CPF " & _
          " FROM AEE_ACOMPANHAMENTO A " & _
          " INNER JOIN AEE_FICHA_PACIENTE F ON F.Cod_Ficha_Paciente=A.Cod_Ficha_Paciente " & _
          " LEFT JOIN SCA_ALUNO AL ON AL.Codigo=F.Cod_Aluno AND F.Tipo_Paciente='R' " & _
          " LEFT JOIN AEE_PACIENTE_EXTERNO PE ON PE.Cod_Paciente_Externo=F.Cod_Paciente_Externo AND F.Tipo_Paciente='E' " & _
          " WHERE A.Cod_Acompanhamento=" & intCodigo & " AND A.Cod_Empresa=" & CLng(Session("CodEmpresa")) & " AND F.Cod_Empresa=" & CLng(Session("CodEmpresa"))
		  
    rsAee.Open sql, cnn
    If Not rsAee.EOF Then
        intCodAluno = Trim(CStr(rsAee("cod_aluno")))
        strCodFichaPaciente = Trim(CStr(rsAee("Cod_Ficha_Paciente")))
        strTipoPaciente = Trim(CStr(rsAee("Tipo_Paciente")))
        strNomePaciente = TextoValor(rsAee("NomePaciente"))
        strMatricula = TextoValor(rsAee("Matricula"))
        strCPF = TextoValor(rsAee("CPF"))
        intCodConsultorio = TextoValor(rsAee("Cod_Consultorio"))
        intCodProfissional = TextoValor(rsAee("Cod_Profissional"))
        strDataAtendimento = DataTela(rsAee("Data_Atendimento"))
        strAtendimento = TextoValor(rsAee("Atendimento"))
        acao = "AE"
    Else
        intCodigo = 0
        acao = "I"
    End If
    rsAee.Close
End If

'=========================================================
' CARREGA PACIENTE JÁ SELECIONADO PELO CÓDIGO DA FICHA
'=========================================================
If intCodigo = 0 And strCodFichaPaciente <> "" And IsNumeric(strCodFichaPaciente) Then
    sql = "SELECT F.Cod_Aluno, F.Cod_Ficha_Paciente,F.Tipo_Paciente," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN AL.NomeAluno ELSE PE.NomeAluno END AS NomePaciente," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN CAST(AL.Matricula AS VARCHAR(20)) ELSE '' END AS Matricula," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN AL.CPF ELSE PE.CPF END AS CPF " & _
          "FROM AEE_FICHA_PACIENTE F " & _
          "LEFT JOIN SCA_ALUNO AL ON AL.Codigo=F.Cod_Aluno AND F.Tipo_Paciente='R' " & _
          "LEFT JOIN AEE_PACIENTE_EXTERNO PE ON PE.Cod_Paciente_Externo=F.Cod_Paciente_Externo AND F.Tipo_Paciente='E' " & _
          "WHERE F.Cod_Ficha_Paciente=" & CLng(strCodFichaPaciente) & " AND F.Cod_Empresa=" & CLng(Session("CodEmpresa")) & " AND F.Situacao='A'"
    rsPaciente.Open sql, cnn
    If Not rsPaciente.EOF Then
		intCodAluno = Trim(rsPaciente("cod_aluno"))
        strTipoPaciente = Trim(CStr(rsPaciente("Tipo_Paciente")))
        strNomePaciente = TextoValor(rsPaciente("NomePaciente"))
        strMatricula = TextoValor(rsPaciente("Matricula"))
        strCPF = TextoValor(rsPaciente("CPF"))
        If strTipoPaciente="R" Then strBuscaPaciente=strMatricula Else strBuscaPaciente=strCPF
    Else
        strCodFichaPaciente = ""
    End If
    rsPaciente.Close
End If

'=========================================================
' PESQUISA RÁPIDA: MATRÍCULA (REDE) OU CPF (EXTERNO)
'=========================================================
If intCodigo = 0 And strCodFichaPaciente = "" And strBuscaPaciente <> "" Then
    strBuscaNormalizada = Replace(Replace(Replace(strBuscaPaciente,".",""),"-","")," ","")
    sql = "SELECT TOP 2 F.Cod_Aluno, F.Cod_Ficha_Paciente,F.Tipo_Paciente," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN AL.NomeAluno ELSE PE.NomeAluno END AS NomePaciente," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN CAST(AL.Matricula AS VARCHAR(20)) ELSE '' END AS Matricula," & _
          "CASE WHEN F.Tipo_Paciente='R' THEN AL.CPF ELSE PE.CPF END AS CPF " & _
          "FROM AEE_FICHA_PACIENTE F " & _
          "LEFT JOIN SCA_ALUNO AL ON AL.Codigo=F.Cod_Aluno AND F.Tipo_Paciente='R' " & _
          "LEFT JOIN AEE_PACIENTE_EXTERNO PE ON PE.Cod_Paciente_Externo=F.Cod_Paciente_Externo AND F.Tipo_Paciente='E' " & _
          "WHERE F.Cod_Empresa=" & CLng(Session("CodEmpresa")) & " AND F.Situacao='A' "
    If strTipoPacienteBusca="R" Or strTipoPacienteBusca="E" Then sql=sql & " AND F.Tipo_Paciente='" & strTipoPacienteBusca & "' "
    sql = sql & "AND ((F.Tipo_Paciente='R' AND REPLACE(CAST(AL.Matricula AS VARCHAR(20)),' ','')='" & SqlSeguro(strBuscaNormalizada) & "') " & _
                "OR (F.Tipo_Paciente='E' AND REPLACE(REPLACE(REPLACE(ISNULL(PE.CPF,''),'.',''),'-',''),' ','')='" & SqlSeguro(strBuscaNormalizada) & "')) "
    sql = sql & "ORDER BY F.Cod_Ficha_Paciente"
    rsPaciente.Open sql, cnn
    If Not rsPaciente.EOF Then
		intCodAluno = Trim(CStr(rsPaciente("cod_aluno")))
        strCodFichaPaciente = Trim(CStr(rsPaciente("Cod_Ficha_Paciente")))
        strTipoPaciente = Trim(CStr(rsPaciente("Tipo_Paciente")))
        strNomePaciente = TextoValor(rsPaciente("NomePaciente"))
        strMatricula = TextoValor(rsPaciente("Matricula"))
        strCPF = TextoValor(rsPaciente("CPF"))
    End If
    rsPaciente.Close
End If

If strDataAtendimento = "" Then strDataAtendimento = DataTela(Date())
if intCodAluno = "" then intCodAluno = 0
if isnull(intCodAluno) then intCodAluno = 0
%>

<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="aee_acompanhamento.asp">

    <input type="hidden" name="txtCodigo" id="txtCodigo" value="<%=intCodigo%>">
    <input type="hidden" name="txtCodFichaPaciente" id="txtCodFichaPaciente" value="<%=HtmlValor(strCodFichaPaciente)%>">
    <input type="hidden" name="txtQtdeArquivos" id="txtQtdeArquivos" value="0">
    <input type="hidden" name="txtQtdeLinks" id="txtQtdeLinks" value="0">

    <div id="camposArquivosBase64"></div>

    <ol class="breadcrumb page-breadcrumb">
        <li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
        <li class="breadcrumb-item"><%=modulo%></li>
        <li class="breadcrumb-item active"><%=pagina%></li>
        <li class="position-absolute pos-top pos-right d-none d-sm-block"><%=Session("data_hoje")%></li>
    </ol>

    <div class="subheader">
        <h1 class="subheader-title">
            <i class="subheader-icon fal fa-notes-medical"></i> <%=pagina%>
            <small><%=descricao_pagina%></small>
        </h1>
    </div>

    <div class="row">
        <div class="col-xl-12">
            <div class="panel">
                <div class="panel-hdr">
                    <h2>Paciente <span class="fw-300"><i>aluno da rede ou paciente externo</i></span></h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-original-title="Recolher"></button>
                        <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-original-title="Tela cheia"></button>
                    </div>
                </div>
                <div class="panel-container show">
                    <div class="panel-content">
                        <div class="row">
                            <div class="col-sm-2">
                                <div class="form-group">
                                    <label class="form-label"><strong>Tipo</strong></label>
                                    <select class="form-control" name="cmbTipoPacienteBusca" id="cmbTipoPacienteBusca" <%If intCodigo>0 Then Response.Write("disabled")%>>
                                        <option value="">Todos</option>
                                        <option value="R" <%If strTipoPacienteBusca="R" Or (strTipoPaciente="R" And strCodFichaPaciente<>"") Then Response.Write("selected")%>>Aluno da Rede</option>
                                        <option value="E" <%If strTipoPacienteBusca="E" Or (strTipoPaciente="E" And strCodFichaPaciente<>"") Then Response.Write("selected")%>>Paciente Externo</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label class="form-label"><strong>Matrícula / CPF</strong></label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="txtBuscaPaciente" id="txtBuscaPaciente" value="<%=HtmlValor(strBuscaPaciente)%>" maxlength="20" <%If intCodigo>0 Then Response.Write("readonly")%>>
                                        <%If intCodigo=0 Then%>
                                        <div class="input-group-append">
                                            <button class="btn btn-primary" type="button" onclick="return buscarPaciente();" title="Pesquisar"><i class="fal fa-search"></i></button>
                                            <button class="btn btn-outline-primary" type="button" onclick="return abrirConsultaPaciente();" title="Consulta completa"><i class="fal fa-list"></i></button>
                                        </div>
                                        <%End If%>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-5">
                                <div class="form-group">
                                    <label class="form-label">Nome do Paciente</label>
                                    <input type="text" class="form-control" id="txtNomePaciente" readonly value="<%=HtmlValor(strNomePaciente)%>">
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <div class="form-group">
                                    <label class="form-label">Origem</label>
                                    <input type="text" class="form-control" readonly value="
									<%
									If strTipoPaciente="R" Then 
										Response.Write("Aluno da Rede") 
									ElseIf strTipoPaciente="E" Then 
										Response.Write("Paciente Externo") 
									End If
									%>">
                                </div>
                            </div>
                        </div>
                        <%If strCodFichaPaciente<>"" Then%>
						<br>
                        <div class="alert alert-info mb-0">
                            <strong>Paciente selecionado:</strong> <%=HtmlValor(strNomePaciente)%>
                            <%If strTipoPaciente="R" Then%> &nbsp; <strong>Matrícula:</strong> <%=HtmlValor(strMatricula)%><%End If%>
                            <%If strCPF<>"" Then%> &nbsp; <strong>CPF:</strong> <%=HtmlValor(strCPF)%><%End If%>
                        </div>
                        <%ElseIf strBuscaPaciente<>"" Then%>
                        <div class="alert alert-warning mb-0"><i class="fal fa-exclamation-triangle mr-2"></i>Paciente não localizado. Utilize a consulta completa para pesquisar por nome.</div>
                        <%End If%>
						<br>
						<div class="row">
                            <div class="col-sm-2">
                                <div class="form-group">
                                    <label class="form-label"><strong>Modelo de documento</strong></label>
                                    <!--#include file="includes/inc_cmbModeloDocumentoAEE.asp" -->
                                </div>
                            </div>
                        </div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
						</div>
                    </div>
					
                </div>
            </div>
        </div>
    </div>

   
</form>
</main>

<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>

<%
Set rsRecursos = Nothing
Set rsPaciente = Nothing
Set rsAee = Nothing
%>
