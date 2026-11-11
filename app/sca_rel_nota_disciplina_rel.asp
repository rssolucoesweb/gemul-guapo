<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Notas disciplina</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<style>
	.fonte7 {
		font-size: 7;
		color:blue
	}

    .quadroInfo { width:98%; border-collapse:collapse; margin:0 auto 10px auto; font-family:Arial, Helvetica, sans-serif; font-size:10px; }
    .quadroInfo td { border:1px solid #777; padding:2px 4px; }
    .quadroInfo .rotulo { width:12%; }
    .quadroInfo .valor { font-weight:bold; }
    .gradeNotas { width:98%; border-collapse:collapse; margin:0 auto; font-family:Arial, Helvetica, sans-serif; font-size:10px; }
    .gradeNotas th, .gradeNotas td { border:1px solid #777; padding:2px 4px; }
    .gradeNotas th { text-align:center; font-weight:bold; }
    .gradeNotas .ord { width:4%; text-align:center; }
    .gradeNotas .matricula { width:12%; }
    .gradeNotas .aluno { width:34%; }
    .gradeNotas .nota { width:7%; text-align:center; }
    .gradeNotas .fechar { width:9%; text-align:center; }
    .gradeNotas .situacao { width:14%; }
    .situacaoTransferido { color:#ff0000; font-weight:bold; }
</style>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
<br>
<%
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	
	strAnoLetivo				= intAnoLetivoAtual
	ano_letivo					= strAnoLetivo
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")
	intCodSituacaoAluno		    = Trim(Request.Form("cmbSituacaoAluno"))	
    strSituacaoPromocao 		= Trim(Request("cmbSituacaoPromocao"))
	strAtivos              		= Trim(Request.Form("cmbativos"))
	mostra_resultado       		= Trim(Request.Form("mostra_resultado"))

	buscaHistorico = "N"
	msnHistorico = ""
	if trim(intSemestreAtual) = "3" then
	   if trim(intAnoLetivoAtual) <> trim(session("strAnoLetivo"))  then
	      buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if
	else
	   if trim(intAnoLetivoAtual) <> trim(session("strAnoLetivo"))  or trim(intSemestreAtual) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if	   
    end if

    if strVerificaCategoria <> "Professor" then
	   
	end if	 


	dim intPagina
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual

	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "Fechamento de Notas por Disciplinas<br>" & msnHistorico

	sub mostraCabecalho()
	%>
    <!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub	

	intCodCurso	 		= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 		= Trim(Request.Form("cmbPeriodo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if


	strCod_empresa 		= Session("CodEmpresa")
	strMostraResultadoFinal	= Trim(Request.Form("resultadoFinal"))
	strMostraResumoResultados	= Trim(Request.Form("ResumoResultados"))
	'Busca o nome do professor
	sql = "SELECT DISTINCT SRH_COLABORADOR.NOME AS COLABORADOR"
    sql = sql & " FROM SCA_HORARIO_AULA"
    sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
    sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO = " & intAnoLetivoAtual
    sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE = " & intSemestreAtual
    sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA = " & intCodTurma
    sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA = " & intCodDisciplina
    rs.open sql, cnn
    if not rs.eof then 
	  strProfessorAssinatura = rs("COLABORADOR")
    else
	  strProfessorAssinatura = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
    end if
    rs.close

	'DESCRICAO DO PERIODO	
	sql="SELECT P.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO, P.COD_CURSO "
	sql=sql & " FROM 	SCA_PERIODO P "
	sql=sql & " INNER 	JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO "
	sql=sql & " WHERE 	P.COD_PERIODO = " & intCodPeriodo
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoPeriodo  = rs("PERIODO")
		strDescricaoCurso 	 = rs("CURSO")
		intCodCurso = rs("cod_curso")
	end if
	rs.close	
	
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	strBimestreAtual 	= ""
	strBimestre1		= "1Bim"
	strBimestre2		= "2Bim"
	strBimestre3		= "3Bim"
	strBimestre4		= "4Bim"
	strExameFinal		= "5EF"
	strCC				= "6CC"
	strCodBimestre		= ""

	
	'carrega campos
	sql="select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " order by c.posicao"
	'response.write sql
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		strTipoCalculo 				= rs("TIPO_CALCULO")
		media_aprovacao 			= rs("media_aprovacao")
		media_aprovacao_final		= rs("media_aprovacao_final")
		intQtdeDisciplinaRecuperacao= rs("num_disciplina_recuperacao")
		intQtdeDisciplinaDependencia= rs("num_disciplina_prog_parcial")
		if isnull(intQtdeDisciplinaDependencia) then intQtdeDisciplinaDependencia  = 0 
		strTipoFormulaFinal 		= rs("tipoFormulaFinal")
		frequencia_minima_percentual= rs("frequencia_minima_percentual")
		
		vetCampo = rs.getRows
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.history.back();
		</script>
		<%
		response.end
	end if
	rs.close

	strCodAluno			= Trim(Request("chkAluno"))
	
	if strCodAluno <> "" then 
		contQuebra = 0		
		mostraCabecalho
		'regra para buscar dados de anos anteriores
		if buscaHistorico = "S" then
			'HISTORICO ESCOLAR
			sql = " SELECT A.CODIGO, "
			sql = sql & " 	A.MATRICULA, "
			sql = sql & " 	A.NOMEALUNO, "
			sql = sql & " 	HED.COD_TURMA, "
			sql = sql & " 	T.NOMETURMA, "
			sql = sql & " 	T.TURMAALUNO, "
			sql = sql & " 	G.Cod_Periodo, "
			'sql = sql & " 	HED.MEDIA, "
			sql = sql & " 	Isnull(HED.MEDIA,'0') AS MEDIA, "
			sql = sql & " 	(Isnull(HED.falta01,'0') + Isnull(HED.falta02,'0') + Isnull(HED.falta03,'0') + Isnull(HED.falta04,'0') + Isnull(HED.falta05,'0') + Isnull(HED.falta06,'0') + Isnull(HED.falta07,'0') + Isnull(HED.falta08,'0') + Isnull(HED.falta09,'0') + Isnull(HED.falta10,'0') + Isnull(HED.falta11,'0') + Isnull(HED.falta12,'0') + Isnull(HED.falta13,'0') + Isnull(HED.falta14,'0') + Isnull(HED.falta15,'0'))*100/ISNULL(HED.CARGA_HORARIA,'1') as percFaltas, "
			sql = sql & " 	HED.CARGA_HORARIA as CH_ANUAL,"
			sql = sql & " 	GCD.Omitir_Criterio, isnull(T.DesvincularCriterioAvaliacao,'N') as DesvincularCriterioAvaliacao,"
			sql = sql & "   HED.situacao, PE.Descricao AS PERIODO, CU.Descricao AS CURSO, GCD.Ch_Anual,"
			for i=0 to ubound(vetCampo,2)
				strPos = vetCampo(0,i)
				if IsNumeric(strPos) then
					if cInt(strPos)<10 then strPos = "0" & strPos
				end if
				sql = sql & " 	HED.NOTA"&strPos&", "
				sql = sql & " 	HED.FALTA"&strPos&", "
			next
			sql = sql & " 	D.DESC_DISCIPLINA,"
			sql = sql & " 	TU.DESC_TURNO,"
			sql = sql & " 	HED.CODIGO AS COD_NOTA, "
			sql = sql & " 	SA.DESC_SITUACAOALUNO, "
			sql = sql & " 	HED.SITUACAO, PE.TIPO, PE.COD_PERIODO"
				
			sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
			sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
			sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
			sql = sql & " LEFT JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO FE on FE.COD_ALUNO = HE.COD_ALUNO and FE.ano_letivo = HED.ANO_LETIVO and HED.COD_TURMA = FE.COD_TURMA "
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = FE.COD_SITUACAOALUNO_ATUAL "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = HED.COD_TURMA AND T.ANOLETIVO = HED.Ano_Letivo AND T.COD_SEMESTRE = HED.SEMESTRE AND T.cod_empresa = HE.cod_empresa "
			sql = sql & " INNER JOIN SCA_PERIODO PE ON PE.COD_PERIODO = T.COD_PERIODO"
			sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO = PE.COD_PERIODO"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
			sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO "
			sql = sql & " LEFT JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = HED.Cod_GradeCurricularDisciplina "					
			sql = sql & " WHERE HE.COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND HED.COD_DISCIPLINA = " & intCodDisciplina
			'sql = sql & " AND HED.COD_TURMA = " & intCodTurma
			sql = sql & " AND A.CODIGO IN (" & strCodAluno & ")"
			sql = sql & " AND HED.ANO_LETIVO =  " & intAnoLetivoAtual
			sql = sql & " AND HED.SEMESTRE = " & intSemestreAtual
			sql = sql & " ORDER BY A.NOMEALUNO, D.DESC_DISCIPLINA 	"	
			
		else

			sql = " SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, "
			sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, SCA_TURMA.NOMETURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_NOTAS_FALTAS.MEDIA, "
			for i=0 to ubound(vetCampo,2)
				strPos = vetCampo(0,i)
				if IsNumeric(strPos) then
					if cInt(strPos)<10 then strPos = "0" & strPos
				end if
				sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
				sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
			next
			sql = sql & " SCA_DISCIPLINA.DESC_DISCIPLINA, SCA_TURNO.DESC_TURNO, isnull(SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,'N') as Omitir_Criterio,SCA_SITUACAOALUNO.DESC_SITUACAOALUNO,"
			sql = sql & " SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA,isnull(sca_turma.DesvincularCriterioAvaliacao,'N') as DesvincularCriterioAvaliacao,"
			sql = sql & " SCA_NOTAS_FALTAS.situacao, SCA_TURMA.TURMAALUNO, SCA_PERIODO.Descricao AS PERIODO, SCA_CURSO.Descricao AS CURSO, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual, SCA_PERIODO.TIPO,SCA_PERIODO.COD_PERIODO"
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.SITUACAO in ('A','C','T')"
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_TURMA.Cod_periodo"
			sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso"
			sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO "
			sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.COD_SITUACAOALUNO = (select top 1 COD_SITUACAOALUNO from SCA_CONTROLE_SITUACAO_ALUNO where COD_ALUNO = SCA_ALUNO.CODIGO and ANO_LETIVO = SCA_TURMA.anoletivo and COD_EMPRESA = SCA_TURMA.cod_empresa order by codigo desc) "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
			sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
			sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
			sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
			sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
			sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplina
			sql = sql & " AND SCA_ALUNO.CODIGO IN (" & strCodAluno & ")"
			sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO, SCA_DISCIPLINA.DESC_DISCIPLINA"
		
		end if
		'response.Write(buscaHistorico)
		'response.End()
		
		rs.open sql, cnn
		if rs.eof = false then
			
			strNomeTurma 	 = rs("NOMETURMA")
			strDescricaoTurno= rs("DESC_TURNO")
			strDisciplina 	= rs("DESC_DISCIPLINA")
			%>
            <table class="quadroInfo">
                <tr>
                    <td class="rotulo">Composição de Ensino</td>
                    <td class="valor" colspan="5"><%=strDescricaoCurso%></td>
                </tr>
                <tr>
                    <td class="rotulo">Turma</td>
                    <td class="valor"><%=strNomeTurma%></td>
                    <td class="rotulo">Série</td>
                    <td class="valor"><%=strDescricaoPeriodo%></td>
                    <td class="rotulo">Ano Letivo</td>
                    <td class="valor"><%=intAnoLetivoAtual%></td>
                </tr>
                <tr>
                    <td class="rotulo">Turno</td>
                    <td class="valor"><%=strDescricaoTurno%></td>
                    <td class="rotulo">Data Emissão</td>
                    <td class="valor"><%=Right("0" & Day(Date),2) & "/" & Right("0" & Month(Date),2) & "/" & Year(Date)%></td>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="rotulo">Disciplina</td>
                    <td class="valor" colspan="5"><%=UCASE(strDisciplina)%></td>
                </tr>
            </table>

            <table class="gradeNotas">
                <tr>
                    <th class="ord">Ord.</th>
                    <th class="matricula">Matrícula</th>
                    <th class="aluno">Nome do Aluno</th>
                    <%
                    'Cabe硬hos dos bimestres obtidos do crit鲩o de avalia磯.
                    FOR I = 0 TO UBOUND(vetCampo,2)
                        If IsNumeric(vetCampo(4,I)) Then
                            If CInt(vetCampo(4,I)) >= 1 And CInt(vetCampo(4,I)) <= 4 Then
                    %>
                    <th class="nota"><%=Replace(UCase(CStr(vetCampo(1,I))), "BIMESTRE", "Bim.")%></th>
                    <%
                            End If
                        End If
                    NEXT
                    %>
                    <th class="fechar">Para fechar</th>
                    <th class="situacao">Situação Disciplina</th>
                </tr>
            <%
            intContTotalAluno = intContTotalAluno + 0
            intCotRN = 0
            intCotAP = 0
            intOrdemRelatorio = 0

            while not rs.eof
                intOrdemRelatorio = intOrdemRelatorio + 1
                intContTotalAluno = intContTotalAluno + 1

                cod_aluno      = rs("CODIGO")
                cod_curso      = intCodCurso
                strNomeAluno   = rs("NOMEALUNO")
                strMatricula   = rs("MATRICULA")

                strNotaBim1 = "-"
                strNotaBim2 = "-"
                strNotaBim3 = "-"
                strNotaBim4 = "-"
                vlNotaBim1 = Null
                vlNotaBim2 = Null
                vlNotaBim3 = Null
                vlNotaBim4 = Null

                'Carrega somente os tipos 1, 2, 3 e 4 (quatro bimestres).
                'GetRows: vetCampo(indice_do_campo, indice_do_registro)
                '0=posicao, 1=descricao, 4=tipo.
                FOR I = 0 TO UBOUND(vetCampo,2)
                    strPos = ""
                    strTipoCampo = ""

                    If Not IsNull(vetCampo(0,I)) Then strPos = Trim(CStr(vetCampo(0,I)))
                    If Not IsNull(vetCampo(4,I)) Then strTipoCampo = Trim(CStr(vetCampo(4,I)))

                    If IsNumeric(strPos) And IsNumeric(strTipoCampo) Then
                        If CInt(strPos) < 10 Then strPos = "0" & CInt(strPos)

                        If CInt(strTipoCampo) >= 1 And CInt(strTipoCampo) <= 4 Then
                            vlNotaCampo = rs("NOTA" & strPos)

                            If Not IsNull(vlNotaCampo) Then
                                If Trim(CStr(vlNotaCampo)) <> "" And IsNumeric(vlNotaCampo) Then
                                    Select Case CInt(strTipoCampo)
                                        Case 1
                                            vlNotaBim1 = CDbl(vlNotaCampo)
                                            strNotaBim1 = FormatNumber(vlNotaBim1,1)
                                        Case 2
                                            vlNotaBim2 = CDbl(vlNotaCampo)
                                            strNotaBim2 = FormatNumber(vlNotaBim2,1)
                                        Case 3
                                            vlNotaBim3 = CDbl(vlNotaCampo)
                                            strNotaBim3 = FormatNumber(vlNotaBim3,1)
                                        Case 4
                                            vlNotaBim4 = CDbl(vlNotaCampo)
                                            strNotaBim4 = FormatNumber(vlNotaBim4,1)
                                    End Select
                                End If
                            End If
                        End If
                    End If
                NEXT

                '============================================================
                ' PARA FECHAR
                ' Soma as notas ja lancadas. Bimestres sem nota valem zero
                ' para a projecao, mas a divisao continua sendo pelos 4 bimestres.
                ' Ex.: 9,5 + 9,7 + 9,2 = 28,4 / 4 = 7,1.
                ' Se a media projetada ja atingiu media_aprovacao, Para fechar = 0.
                ' Caso contrario, mostra quantos pontos ainda faltam no total.
                '============================================================
                dblSomaNotas = 0

                If Not IsNull(vlNotaBim1) Then If IsNumeric(vlNotaBim1) Then dblSomaNotas = dblSomaNotas + CDbl(vlNotaBim1)
                If Not IsNull(vlNotaBim2) Then If IsNumeric(vlNotaBim2) Then dblSomaNotas = dblSomaNotas + CDbl(vlNotaBim2)
                If Not IsNull(vlNotaBim3) Then If IsNumeric(vlNotaBim3) Then dblSomaNotas = dblSomaNotas + CDbl(vlNotaBim3)
                If Not IsNull(vlNotaBim4) Then If IsNumeric(vlNotaBim4) Then dblSomaNotas = dblSomaNotas + CDbl(vlNotaBim4)

                strParaFechar = "-"
                vlParaFechar = Null

                If Not IsNull(media_aprovacao) Then
                    If IsNumeric(media_aprovacao) Then
                        dblMediaAprovacao = CDbl(media_aprovacao)
                        dblMediaProjetada = round(dblSomaNotas / 4,1)
                        dblTotalNecessario = dblMediaAprovacao * 4

                        If dblMediaProjetada >= dblMediaAprovacao Then
                            vlParaFechar = 0
                            strParaFechar = "0"
                        Else
                            vlParaFechar = dblTotalNecessario - dblSomaNotas
                            If vlParaFechar < 0 Then vlParaFechar = 0
                            strParaFechar = FormatNumber(vlParaFechar,1)
                        End If
                    End If
                End If

                '============================================================
                ' SITUACAO DA DISCIPLINA
                ' Transferido prevalece. Para os demais, deixa a situacao
                ' coerente com o calculo de Para fechar neste momento:
                '   Para fechar = 0  -> Aprovado
                '   Para fechar > 0  -> Reprovado
                '============================================================
                strSituacaoDisciplina = ""
                strClasseSituacao = ""
                strSituacaoAluno = ""

                If Not IsNull(rs("DESC_SITUACAOALUNO")) Then
                    strSituacaoAluno = UCase(Trim(CStr(rs("DESC_SITUACAOALUNO"))))
                End If

                If InStr(strSituacaoAluno,"TRANSFER") > 0 Then
                    strSituacaoDisciplina = "(transferido)"
                    strClasseSituacao = "situacaoTransferido"
                ElseIf Not IsNull(vlParaFechar) Then
                    If CDbl(vlParaFechar) <= 0 Then
                        strSituacaoDisciplina = "Aprovado"
                        intCotAP = intCotAP + 1
                    Else
                        strSituacaoDisciplina = "Reprovado"
                        intCotRN = intCotRN + 1
                    End If
                Else
                    strSituacaoDisciplina = "-"
                End If
				
				if mostra_resultado="" and (strSituacaoDisciplina = "Aprovado" or strSituacaoDisciplina = "Reprovado") then
					strSituacaoDisciplina = "Cursando"
				end if
            %>
                <tr>
                    <td class="ord"><%=intOrdemRelatorio%></td>
                    <td class="matricula"><%=strMatricula%></td>
                    <td class="aluno"><%=UCASE(strNomeAluno)%></td>
                    <td class="nota"><%=strNotaBim1%></td>
                    <td class="nota"><%=strNotaBim2%></td>
                    <td class="nota"><%=strNotaBim3%></td>
                    <td class="nota"><%=strNotaBim4%></td>
                    <td class="fechar"><%=strParaFechar%></td>
                    <td class="situacao <%=strClasseSituacao%>"><%=strSituacaoDisciplina%></td>
                </tr>
            <%
                rs.movenext
            wend
            
		end if
		rs.close
	else
		rs.close
		cnn.close
		%>
			<script>
			alert("Aluno não foi encontrato, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	%>
	<script>
		aguarde.style.display="none";
	</script>
</body>
</html>
