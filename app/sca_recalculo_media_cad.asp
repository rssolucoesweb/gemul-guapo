<%
acao = "I"

strExecutarSubmitTurma = "S"
strSubmitDisciplinaQuadro = "S"
strExecutarSubmitDisciplinaDoProfessor = "S"
strExecutarSubmitSemestre = "S"
submitDisciplinaTurma = "S"

If intCodComp = "" Then intCodComp = "0"
If intCodSerie = "" Then intCodSerie = "0"
If intCodTurno = "" Then intCodTurno = "0"
If intCodTurma = "" Then intCodTurma = "0"
If intCodSemestre = "" Then intCodSemestre = "3"

' Identifica se o usuário é professor, seguindo o padrão da tela base.
sql = "select codigo from SRH_COLABORADOR "
sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & Replace(Trim(Session("usuarioWeb")), "'", "''") & "'"
sql = sql & " and codLotacao = " & Session("CodEmpresa")
sql = sql & " and CodCategoria = 1 and Situacao = 'A'"
rs.Open sql, cnn
If Not rs.EOF Then
    strVerificaCategoria = "Professor"
    intCodColaboradorProfessor = Trim(rs("codigo"))
Else
    strVerificaCategoria = ""
End If
rs.Close

strAnoLetivo = Trim(Request("txtAnoLetivo"))
If strAnoLetivo = "" Then strAnoLetivo = Session("strAnoLetivo")

intCodSemestre = Trim(Request("cmbSemestre"))
If intCodSemestre = "" Then intCodSemestre = "3"

If strVerificaCategoria <> "Professor" Then
    intCodTurma = Trim(Request("cmbTurma"))
    intCodDisciplinaTurma = Trim(Request("cmbDisciplinaTurma"))
Else
    intCodTurmaProfessor = Trim(Request("cmbTurmaProfessor"))
    intCodTurma = intCodTurmaProfessor
    intCodDisciplina = Trim(Request("cmbDisciplinaDoProfessor"))
    intCodDisciplinaTurma = intCodDisciplina
End If

If intCodTurma = "" Then intCodTurma = "0"
If intCodDisciplinaTurma = "" Then intCodDisciplinaTurma = "0"

strAtivos = Trim(Request("cmbativos"))
If strAtivos = "" Then strAtivos = "A"

intCodCurso = 0
intCodPeriodo = 0
intCodTurno = 0
If CLng(intCodTurma) > 0 Then
    sql = "SELECT T.cod_turma, T.cod_Semestre, P.Cod_Curso, P.Cod_Periodo, T.cod_turno, T.NomeTurma "
    sql = sql & " FROM SCA_TURMA T "
    sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular "
    sql = sql & " INNER JOIN SCA_PERIODO P ON GC.Cod_Periodo = P.Cod_Periodo "
    sql = sql & " WHERE T.cod_empresa = " & Session("CodEmpresa")
    sql = sql & " AND T.Cod_Turma = " & CLng(intCodTurma)
    rs.Open sql, cnn
    If Not rs.EOF Then
        intCodCurso = rs("Cod_Curso")
        intCodPeriodo = rs("Cod_Periodo")
        intCodTurno = rs("cod_turno")
        intCodSemestre = rs("cod_Semestre")
    End If
    rs.Close
End If
%>

<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_recalculo_media.asp">
    <ol class="breadcrumb page-breadcrumb">
        <li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
        <li class="breadcrumb-item"><%=modulo%></li>
        <li class="breadcrumb-item active"><%=pagina%></li>
        <li class="position-absolute pos-top pos-right d-none d-sm-block"><%=Session("data_hoje")%></li>
    </ol>

    <div class="subheader">
        <h1 class="subheader-title">
            <i class='subheader-icon fal fa-calculator'></i> <%=pagina%>
            <small><%=descricao_pagina%></small>
        </h1>
    </div>

    <% If Request("ok") = "S" Then %>
    <div class="alert alert-success">
        Recálculo realizado com sucesso para <strong><%=Server.HTMLEncode(Request("qtd"))%></strong> aluno(s).
    </div>
    <% End If %>

    <div class="row">
        <div class="col-xl-12">
            <div class="panel">
                <div class="panel-hdr">
                    <h2>Filtros para recálculo</h2>
                </div>
                <div class="panel-container show">
                    <div class="panel-content">
                        <div class="row">
                            <div class="col-sm-1">
                                <div class="form-group">
                                    <label class="form-label">Ano Letivo:</label>
                                    <input readonly name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>">
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <div class="form-group">
                                    <label class="form-label">Semestre:</label>
                                    <!--#include file="includes/inc_cmdSemestre.asp" -->
                                </div>
                            </div>
                            <div class="col-sm-5">
                                <div class="form-group">
                                    <label class="form-label">Turma <%=strVerificaCategoria%></label>
                                    <% If strVerificaCategoria <> "Professor" Then %>
                                        <!--#include file="includes/inc_cmdTurma.asp"-->
                                    <% Else %>
                                        <!--#include file="includes/inc_cmdTurmaProfessor.asp"-->
                                    <% End If %>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="form-group">
                                    <label class="form-label">Disciplina <small class="text-muted">(opcional)</small></label>
                                    <% If strVerificaCategoria <> "Professor" Then %>
                                        <!--#include file="includes/inc_cmbDisciplinaTurma.asp"-->
                                    <% Else %>
                                        <!--#include file="includes/inc_cmdDisciplinaDoProfessor.asp"-->
                                    <% End If %>
                                    <small class="form-text text-muted">Sem disciplina selecionada, serão recalculadas todas as disciplinas.</small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label class="form-label">Situação</label>
                                    <!--#include file="includes/inc_cmbAtivos.asp"-->
                                </div>
                            </div>
                        </div>

                        <div class="frame-wrap mt-3">
                            <button onclick="return recalcularMedia()" id="btnRecalcular" type="button" class="btn btn-outline-success">Recalcular Média</button>
                            <button onclick="window.location='sca_recalculo_media.asp'" type="button" class="btn btn-outline-warning">Limpar tela</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<%
If CLng(intCodTurma) > 0 Then
%>
    <input type="hidden" name="txtCodCurso" value="<%=intCodCurso%>">
    <input type="hidden" name="txtCodPeriodo" value="<%=intCodPeriodo%>">

    <div class="row">
        <div class="col-xl-12">
            <div class="panel">
                <div class="panel-hdr">
                    <h2>Alunos da turma</h2>
                </div>
                <div class="panel-container show">
                    <div class="panel-content">
                        <div class="mb-3">
                            <strong>Selecionados: <span id="qtdSelecionados">0</span></strong>
                        </div>
                        <div class="table-responsive-lg">
                            <table class="table table-bordered table-hover m-0">
                                <thead class="thead-themed">
                                    <tr>
                                        <th width="50" class="text-center">
                                            <input type="checkbox" id="chkTodos" onclick="marcarTodos(this)" title="Selecionar todos">
                                        </th>
                                        <th width="60">Ordem</th>
                                        <th width="120">Matrícula</th>
                                        <th>Nome</th>
                                        <th width="180">Situação</th>
                                    </tr>
                                </thead>
                                <tbody>
<%
    sql = "SET NOCOUNT ON; WITH ALUNO_TURMA AS ("
    sql = sql & " SELECT AT.CODIGO, AT.COD_EMPRESA, AT.COD_ALUNO, AT.COD_TURMA, AT.SEQUENCIA, AT.ANO_LETIVO, AT.SEMESTRE, AT.SITUACAO,"
    sql = sql & " ROW_NUMBER() OVER (PARTITION BY AT.ANO_LETIVO, AT.COD_ALUNO, AT.COD_EMPRESA ORDER BY AT.CODIGO DESC) AS RN"
    sql = sql & " FROM SCA_ALUNO_TURMA AT"
    sql = sql & " WHERE AT.COD_EMPRESA = " & Session("CodEmpresa")
    sql = sql & " AND AT.COD_TURMA = " & CLng(intCodTurma)
    sql = sql & " AND AT.ANO_LETIVO = " & CLng(strAnoLetivo)
    sql = sql & " AND AT.SEMESTRE = " & CLng(intCodSemestre)
    sql = sql & ") "
    sql = sql & " SELECT DISTINCT A.CODIGO AS COD_ALUNO, A.MATRICULA, A.NOMEALUNO,"
    sql = sql & " ISNULL(ST.Desc_SituacaoAluno,'ATIVO') AS Desc_SituacaoAluno,"
    sql = sql & " ISNULL(ST.Cod_SituacaoAluno,1) AS COD_SITUACAOALUNOATUAL"
    sql = sql & " FROM SCA_ALUNO A"
    sql = sql & " INNER JOIN ALUNO_TURMA AT ON AT.COD_ALUNO=A.CODIGO AND AT.RN=1"
    sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma=AT.COD_TURMA AND T.COD_EMPRESA=AT.COD_EMPRESA"
    sql = sql & " OUTER APPLY (SELECT TOP 1 SS.Cod_SituacaoAluno, SS.Desc_SituacaoAluno"
    sql = sql & " FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
    sql = sql & " INNER JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno=CS.COD_SITUACAOALUNO"
    sql = sql & " WHERE CS.COD_EMPRESA=AT.COD_EMPRESA AND CS.COD_ALUNO=AT.COD_ALUNO AND CS.ANO_LETIVO=AT.ANO_LETIVO"
    sql = sql & " ORDER BY CS.CODIGO DESC) ST"
    sql = sql & " WHERE AT.COD_EMPRESA=" & Session("CodEmpresa")
    sql = sql & " AND AT.COD_TURMA=" & CLng(intCodTurma)
    sql = sql & " AND AT.ANO_LETIVO=" & CLng(strAnoLetivo)
    sql = sql & " AND AT.SITUACAO IN ('A','T','D','C')"
    sql = sql & " AND T.SITUACAO='A'"

    ' Se houver disciplina selecionada, lista somente alunos vinculados a ela.
    If CLng(intCodDisciplinaTurma) > 0 Then
        sql = sql & " AND EXISTS (SELECT 1 FROM SCA_ALUNO_DISCIPLINA AD"
        sql = sql & " WHERE AD.COD_EMPRESA=AT.COD_EMPRESA"
        sql = sql & " AND AD.COD_ALUNO=AT.COD_ALUNO"
        sql = sql & " AND (AD.COD_TURMA=AT.COD_TURMA OR AD.COD_TURMA_REMANEJAMENTO=AT.COD_TURMA)"
        sql = sql & " AND AD.COD_DISCIPLINA=" & CLng(intCodDisciplinaTurma) & ")"
    End If

    If strAtivos = "A" Then
        sql = sql & " AND ISNULL(ST.Cod_SituacaoAluno,1)=1"
    End If

    sql = sql & " ORDER BY A.NOMEALUNO"

    rs.Open sql, cnn
    cont = 0
    If Not rs.EOF Then
        Do While Not rs.EOF
            cont = cont + 1
%>
                                    <tr>
                                        <td class="text-center">
                                            <input type="checkbox" name="chkAluno" value="<%=rs("COD_ALUNO")%>" onclick="atualizarQuantidade()">
                                        </td>
                                        <td><%=ZeroLeft(cont,2)%></td>
                                        <td><%=rs("MATRICULA")%></td>
                                        <td><%=rs("NOMEALUNO")%></td>
                                        <td><%=rs("Desc_SituacaoAluno")%></td>
                                    </tr>
<%
            rs.MoveNext
        Loop
    Else
%>
                                    <tr>
                                        <td colspan="5" class="text-center"><%=Session("strMensagemNaoEncontrado")%></td>
                                    </tr>
<%
    End If
    rs.Close
%>
                                </tbody>
                            </table>
                        </div>

                        <div class="frame-wrap mt-4">
                            <button onclick="return recalcularMedia()" id="btnRecalcularRodape" type="button" class="btn btn-outline-success">Recalcular Média</button>
                            <button onclick="window.location='sca_recalculo_media.asp'" type="button" class="btn btn-outline-warning">Limpar tela</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<%
End If
%>
</form>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
<script type="text/javascript">
if (typeof aguarde !== "undefined") aguarde.style.display="none";
</script>
