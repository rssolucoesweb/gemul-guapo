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
		intCodAluno = Trim(CStr(rsPaciente("cod_aluno")))
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
                        <div class="alert alert-info mb-0">
                            <strong>Paciente selecionado:</strong> <%=HtmlValor(strNomePaciente)%>
                            <%If strTipoPaciente="R" Then%> &nbsp; <strong>Matrícula:</strong> <%=HtmlValor(strMatricula)%><%End If%>
                            <%If strCPF<>"" Then%> &nbsp; <strong>CPF:</strong> <%=HtmlValor(strCPF)%><%End If%>
                        </div>
                        <%ElseIf strBuscaPaciente<>"" Then%>
                        <div class="alert alert-warning mb-0"><i class="fal fa-exclamation-triangle mr-2"></i>Paciente não localizado. Utilize a consulta completa para pesquisar por nome.</div>
                        <%End If%>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <% If strCodFichaPaciente <> "" Then %>


    <div class="row">
        <div class="col-xl-12">
            <div class="panel">

                <div class="panel-hdr">
                    <h2>
                        Atendimento <span class="fw-300"><i>registro do atendimento ao paciente</i></span>
                    </h2>

                    <div class="panel-toolbar">
                        <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-original-title="Recolher"></button>
                        <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-original-title="Tela cheia"></button>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">

                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label class="form-label">Data do Atendimento</label>
                                    <input type="text"
                                           class="form-control"
                                           name="txtDataAtendimento"
                                           id="txtDataAtendimento"
                                           maxlength="10"
                                           value="<%=HtmlValor(strDataAtendimento)%>"
                                           onBlur="return validaData(this)"
                                           onKeyPress="return formataCampo(this, 3, 10)">
                                </div>
                            </div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Consultório:</label>
									<select name="cmbConsultorio" id="cmbConsultorio" class="form-control" onChange="submit()">
										<option value="0">Selecione...</option>
										<%
										sql = "SELECT c.Cod_Consultorio, c.NomeConsultorio, c.AnoLetivo, c.situacao "
										sql = sql & " FROM AEE_CONSULTORIO C"
										sql = sql & " WHERE c.Cod_Empresa = " & CLng(Session("CodEmpresa")) & " "
										sql = sql & " AND c.AnoLetivo = " & CLng(session("strAnoLetivo")) & " "
										sql = sql & " 										  AND ("
										sql = sql & "     c.Situacao = 'A'"
										sql = sql & "     OR Cod_Consultorio = " & intCodConsultorio & " "
										sql = sql & "   )"
										sql = sql & " ORDER BY c.NomeConsultorio"
										msn = ""
										rs.Open sql, cnn
										if not rs.eof then
											While Not rs.EOF
												%>
													<option value="<%=rs("Cod_Consultorio")%>" <% If CStr(intCodConsultorio) = CStr(rs("Cod_Consultorio")) Then Response.Write "selected" %>><%=HtmlValor(rs("NomeConsultorio"))%> <% If CStr(rs("Situacao")) <> "A" Then Response.Write " (INATIVO)" %></option>
												<%
												rs.MoveNext
											Wend
										Else
											msn = "Não existe consultório cadastrado!"
										end if
										rs.Close
										
										%>
									</select>
									<%if msn<>"" then%>
									<small class="form-text text-muted">
                                        <font color="red"><%=msn%></font>
                                    </small>
									<%end if%>
								</div>
							</div>
							<div class="col-sm-5">
								<div class="form-group">
									<label class="form-label">Profissional:</label>
									<select name="cmbProfissional" id="cmbProfissional" class="form-control">
										<option value="0">Selecione...</option>
										<%
										sql = "select distinct P.Cod_Profissional, UPPER(C.nome) AS profissional, E.Descricao as especialidade, a.Cod_Consultorio"
										sql = sql & " from AEE_PROFISSIONAL P"
										sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = P.COD_COLABORADOR"
										sql = sql & " INNER JOIN AEE_ESPECIALIDADE E ON E.Cod_Especialidade = P.Cod_Especialidade"
										sql = sql & " INNER JOIN AEE_ATENDIMENTO A ON A.Cod_Profissional = p.Cod_Profissional"
										sql = sql & " where a.Cod_Consultorio = " & intCodConsultorio
										sql = sql & " ORDER BY 2"
										msn = ""
										rs.Open sql, cnn
										if not rs.eof then
											While Not rs.EOF
												%>
													<option value="<%=rs("Cod_Profissional")%>" <% If CStr(intCodProfissional) = CStr(rs("Cod_Profissional")) Then Response.Write "selected" %>><%=HtmlValor(rs("profissional"))%>&nbsp(<%=HtmlValor(rs("especialidade"))%>)</option>
												<%
												rs.MoveNext
											Wend
										Else
											msn = "Não existe profissional vinculado a esse consultório, favor verificar na funcionalidade vincular horário"
										end if
										rs.Close
										
										%>
									</select>
									<%if msn<>"" and intCodConsultorio<>"0" then%>
									<small class="form-text text-muted">
                                        <font color="red"><%=msn%></font>
                                    </small>
									<%end if%>
								</div>
							</div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12">
                                <div class="form-group">
                                    <label class="form-label">Atendimento</label>
                                    <textarea class="form-control"
                                              name="txtAtendimento"
                                              id="txtAtendimento"
                                              rows="7"
                                              maxlength="10000"
                                              placeholder="Descreva o atendimento realizado ao paciente..."><%=HtmlValor(strAtendimento)%></textarea>
                                    <small class="form-text text-muted">
                                        Registre as orientações, procedimentos, encaminhamentos e demais informações do atendimento.
                                    </small>
                                </div>
                            </div>
                        </div>

                        <hr>

                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fal fa-paperclip mr-1"></i>
                                        Anexar arquivo(s)
                                    </label>

                                    <input type="file"
                                           class="form-control"
                                           id="arquivoUpload"
                                           multiple>

                                    <small class="form-text text-muted">
                                        É permitido selecionar mais de um arquivo. Não há restrição de extensão nesta tela.
                                    </small>
                                </div>
                            </div>

                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fal fa-link mr-1"></i>
                                        Link
                                    </label>

                                    <div id="listaLinks">
                                        <div class="input-group mb-2 linha-link">
                                            <input type="text"
                                                   class="form-control campo-link"
                                                   placeholder="https://...">
                                            <div class="input-group-append">
                                                <button type="button"
                                                        class="btn btn-outline-danger"
                                                        onclick="removerLinhaLink(this);"
                                                        title="Remover link">
                                                    <i class="fal fa-times"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary"
                                            onclick="adicionarLinhaLink();">
                                        <i class="fal fa-plus"></i> Adicionar outro link
                                    </button>
                                </div>
                            </div>
                        </div>

                        <% If acao = "AE" Then %>
                            <hr>

                            <div class="row">
                                <div class="col-sm-12">
                                    <label class="form-label">
                                        <strong>Arquivos e links já cadastrados</strong>
                                    </label>

                                    <div class="table-responsive">
                                        <table class="table table-bordered table-hover table-sm">
                                            <thead>
                                                <tr>
                                                    <th width="110">Tipo</th>
                                                    <th>Arquivo / Link</th>
                                                    <th width="110" class="text-center">Excluir</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                sql = "SELECT Cod_Recurso, Tipo_Recurso, Nome_Arquivo, Link "
                                                sql = sql & "FROM AEE_ACOMPANHAMENTO_RECURSO "
                                                sql = sql & "WHERE Cod_Acompanhamento = " & intCodigo & " "
                                                sql = sql & "ORDER BY Cod_Recurso"

                                                rsRecursos.Open sql, cnn

                                                If rsRecursos.EOF Then
                                                %>
                                                    <tr>
                                                        <td colspan="3" class="text-center text-muted">
                                                            Nenhum arquivo ou link cadastrado.
                                                        </td>
                                                    </tr>
                                                <%
                                                Else
                                                    While Not rsRecursos.EOF

                                                        If UCase(Trim(CStr(rsRecursos("Tipo_Recurso")))) = "A" Then
                                                            strDescricaoRecurso = Trim(CStr(rsRecursos("Nome_Arquivo")))
                                                            strUrlRecurso = "aee_acompanhamento_arquivo.asp?codigo=" & rsRecursos("Cod_Recurso")
                                                            strTipoRecurso = "Arquivo"
                                                        Else
                                                            strDescricaoRecurso = Trim(CStr(rsRecursos("Link")))
                                                            strUrlRecurso = Trim(CStr(rsRecursos("Link")))
                                                            strTipoRecurso = "Link"
                                                        End If
														%>
                                                        <tr>
                                                            <td><%=strTipoRecurso%></td>
                                                            <td>
                                                                <a href="<%=HtmlValor(strUrlRecurso)%>" target="_blank">
                                                                    <%=HtmlValor(strDescricaoRecurso)%>
                                                                </a>
                                                            </td>
                                                            <td class="text-center">
                                                                <input type="checkbox"
                                                                       name="chkExcluirRecurso"
                                                                       value="<%=rsRecursos("Cod_Recurso")%>">
                                                            </td>
                                                        </tr>
														<%
                                                        rsRecursos.MoveNext
                                                    Wend
                                                End If

                                                rsRecursos.Close
                                                %>
                                            </tbody>
                                        </table>
										<small class="form-text text-muted">
                                        Marque a opção Excluir para remover o arquivo ou link ao salvar a alteração.
										</small>
                                    </div>

                                    
									
									
									<br>
									<br>
									
                                </div>
                            </div>
                        <% End If %>
						<!-- laudo da ficha do aluno -->
						<% If strTipoPaciente = "R" Then

							sql = "SELECT codigo, cod_aluno, NomeArquivo, Descricao, base64 "
							sql = sql & "FROM SCA_ALUNO_ARQUIVO "
							sql = sql & "WHERE cod_aluno=" & intCodAluno
							rs.Open sql, cnn

							If Not rs.EOF Then
						%>
								<div class="row">
									<div class="col-sm-12">
										<label class="form-label">
											<strong>Laudos cadastrados na ficha do aluno no modulo acadêmico</strong>
										</label>

										<div class="table-responsive">
											<table class="table table-bordered table-hover table-sm">
												<thead>
													<tr>
														<th>Descrição</th>
														<th>Nome do Arquivo</th>
														<th style="width: 120px;">Visualizar</th>
													</tr>
												</thead>

												<tbody>
												<% Do While Not rs.EOF %>

													<tr>
														<td><%=rs("Descricao")%></td>
														<td><%=rs("NomeArquivo")%></td>

														<td class="text-center">
															<button type="button"
																	class="btn btn-sm btn-primary"
																	onclick="visualizarArquivo('<%=rs("codigo")%>')">
																Visualizar
															</button>
														</td>

													</tr>

												<%
													rs.MoveNext
												   Loop
												%>
												</tbody>
											</table>
										</div>
									</div>
								</div>

								<script>
								function visualizarArquivo(codigo) {
									window.open(
										'aee_acompanhamento_visualizarArquivo.asp?codigo=' + codigo,
										'_blank'
									);
								}

								function downloadArquivo(codigo) {
									window.location.href =
										'downloadArquivo.asp?codigo=' + codigo;
								}
								</script>

						<%
							End If

							rs.Close
						End If
						%>		
                        <br>

                        <div class="frame-wrap">
                            <!--#include file="includes/inc_botoes_cadastro.asp"-->
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-12">
            <div class="panel">

                <div class="panel-hdr">
                    <h2>
                        Histórico de Atendimentos
                        <span class="fw-300">
                            <i><%=HtmlValor(strNomePaciente)%></i>
                        </span>
                    </h2>

                    <div class="panel-toolbar">
                        <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse"></button>
                        <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen"></button>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover table-striped table-sm">
                                <thead>
                                    <tr>
                                        <th width="120">Data</th>
                                        <th>Atendimento</th>
                                        <th>Consultório</th>
                                        <th>Profissional</th>
                                        <th width="160">Arquivos / Links</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    sql = "SELECT A.Cod_Acompanhamento, A.Data_Atendimento, A.Atendimento, upper(CO.NOME) AS PROFISSIONAL, C.NomeConsultorio,"
                                    sql = sql & "(SELECT COUNT(*) FROM AEE_ACOMPANHAMENTO_RECURSO R WHERE R.Cod_Acompanhamento = A.Cod_Acompanhamento) AS QtdeRecursos "
                                    sql = sql & "FROM AEE_ACOMPANHAMENTO A "
									sql = sql & "LEFT JOIN AEE_CONSULTORIO C ON C.COD_CONSULTORIO = A.COD_CONSULTORIO "
									sql = sql & "LEFT JOIN AEE_PROFISSIONAL P ON P.COD_PROFISSIONAL = A.COD_PROFISSIONAL "
									sql = sql & "LEFT JOIN SRH_COLABORADOR CO ON CO.CODIGO = P.COD_COLABORADOR "
                                    sql = sql & "WHERE A.Cod_Ficha_Paciente = " & CLng(strCodFichaPaciente) & " "
                                    sql = sql & "AND A.Cod_Empresa = " & CLng(Session("CodEmpresa")) & " "
                                    sql = sql & "ORDER BY A.Data_Atendimento DESC, A.Cod_Acompanhamento DESC"
                                    rsAee.Open sql, cnn

                                    If rsAee.EOF Then
                                    %>
                                        <tr>
                                            <td colspan="5" class="text-center text-muted">
                                                Nenhum atendimento cadastrado para este paciente.
                                            </td>
                                        </tr>
                                    <%
                                    Else
                                        While Not rsAee.EOF
                                    %>
                                            <tr style="cursor:pointer;"
                                                onclick="return resultadoConsulta(<%=rsAee("Cod_Acompanhamento")%>);">
                                                <td><%=DataTela(rsAee("Data_Atendimento"))%></td>
                                                <td style="white-space:normal;">
                                                    <%=HtmlValor(rsAee("Atendimento"))%>
                                                </td>
												<td>
                                                    <%=HtmlValor(rsAee("NomeConsultorio"))%>
                                                </td>
												<td>
                                                    <%=HtmlValor(rsAee("Profissional"))%>
                                                </td>
                                                <td class="text-center">
                                                    <% If CLng(rsAee("QtdeRecursos")) > 0 Then %>
                                                        <span class="badge badge-info">
                                                            <i class="fal fa-paperclip"></i>
                                                            <%=rsAee("QtdeRecursos")%>
                                                        </span>
                                                    <% Else %>
                                                        -
                                                    <% End If %>
                                                </td>
                                            </tr>
                                    <%
                                            rsAee.MoveNext
                                        Wend
                                    End If

                                    rsAee.Close
                                    %>
                                </tbody>
                            </table>
                        </div>

                        <small class="form-text text-muted">
                            Clique em uma linha para alterar ou excluir o atendimento.
                        </small>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <% End If %>

</form>
</main>

<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>

<%
Set rsRecursos = Nothing
Set rsPaciente = Nothing
Set rsAee = Nothing
%>
