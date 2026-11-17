<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>

<html>
<head>
<title><%=session("Titulo")%> - Justificativa de Faltas</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>

<script>
	function abrePaginaJustificativa(cod){
		
		var caminho = "sca_justificativa_faltas_img.asp?codigo="+cod;
		window.open(caminho,"abreConsulta","top=50,left=50,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
</script>

</head>

<body>

<!--#include file="includes/inc_verificaSessionApp.asp"-->

<!--#include file="includes/inc_cnn.asp"-->

<!--#include file="includes/inc_formatadata.asp"-->

<!--#include file="includes/inc_Botoes_relatorio.asp"-->

<!--#include file="includes/inc_aguarde.asp"-->

<br>

<%


dim intPagina
redim vetTipoAvaliacao(0,2)
dim intCodPeriodo

strTituloRelatorio = "Justificativa de Faltas<br>"

sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
end Sub

sub fimTabela()
	response.Write("</table>")
end sub	


'============================================================
' PARÂMETROS DO RELATÓRIO
'============================================================

strMostraResultadoFinal = Trim(Request.Form("resultadoFinal"))
strMostraCH = Trim(Request.Form("CH"))
strMostraPercFaltas = Trim(Request.Form("PercFaltas"))
strTipoResultadoFinal = Trim(Request.Form("txtTipoResultadoFinal"))
intQtdeQuebraExtrato = Trim(Request.Form("cmbTotalExtrato"))

intCodCurso = Trim(Request.Form("cmbCurso"))
intCodPeriodo = Trim(Request.Form("cmbPeriodo"))

'------------------------------------------------------------
' 6º AO 9º POSSUI CONTROLE POR DISCIPLINA
'------------------------------------------------------------
mostraColunaAula = "N"

if intCodPeriodo >= 6 and intCodPeriodo <= 9 then
	mostraColunaAula = "S"
end if

intCodTurma = Trim(Request.Form("cmbTurma"))
intCodBimestre = Trim(Request.Form("cmbBimestre"))
intCodTipoJustificativa = Trim(Request.Form("cmbTipoJustificativa"))
strCod_empresa = Session("CodEmpresa")
intAnoLetivo = Trim(Request.Form("txtAnoLetivo"))

strCodAluno = Trim(Request("chkAluno"))

if strCodAluno <> "" then
	vetAluno = split(Trim(Request.form("chkAluno")),",")
end if


if strCodAluno <> "" then 

	contQuebra = 0		

	for j=0 to ubound(vetAluno)
		
		intCodAluno = vetAluno(j)

		'============================================================
		' CONSULTA DAS JUSTIFICATIVAS
		'
		' qtde_dias_justificados:
		'   quantidade de dias lançados na justificativa.
		'
		' qtde_faltas_justificadas:
		'   somente as faltas que realmente existem em
		'   SCA_FALTAS_DIARIA.
		'
		'   6º ao 9º:
		'       ALUNO + DATA + DISCIPLINA
		'
		'   Demais períodos:
		'       ALUNO + DATA
		'============================================================

		sql = ""

		'------------------------------------------------------------
		' CTE COM AS FALTAS REAIS
		'
		' Elimina duplicidades da SCA_FALTAS_DIARIA.
		'
		' Para 6º ao 9º:
		'   será utilizada DATA + DISCIPLINA.
		'
		' Para os demais períodos:
		'   será utilizada somente DATA.
		'------------------------------------------------------------

		sql = sql & " ;WITH FaltasReais AS ( "

		sql = sql & "     SELECT DISTINCT "
		sql = sql & "         F.cod_empresa, "
		sql = sql & "         F.ano_letivo, "
		sql = sql & "         F.cod_aluno, "
		sql = sql & "         CAST(F.data AS DATE) AS data_falta, "
		sql = sql & "         ISNULL(F.cod_disciplina, 0) AS cod_disciplina "

		sql = sql & "     FROM SCA_FALTAS_DIARIA F "

		sql = sql & "     WHERE F.cod_empresa = " & strCod_empresa
		sql = sql & "       AND F.ano_letivo = " & intAnoLetivo
		sql = sql & "       AND F.cod_aluno = " & intCodAluno

		sql = sql & " ) "

		'------------------------------------------------------------
		' SELECT PRINCIPAL
		'------------------------------------------------------------

		sql = sql & " SELECT "
		sql = sql & "     j.codigo, "
		sql = sql & "     j.ano_letivo, "
		sql = sql & "     j.DataInicial, "
		sql = sql & "     j.DataFinal, "
		sql = sql & "     j.justificativa, "
		sql = sql & "     a.NOMEALUNO AS aluno, "
		sql = sql & "     a.MATRICULA, "
		sql = sql & "     b.Descricao AS bimestre, "
		sql = sql & "     t.Descricao AS tipo, "
		sql = sql & "     tu.NomeTurma, "
		sql = sql & "     tu.TurmaAluno, "
		sql = sql & "     c.Descricao AS curso, "
		sql = sql & "     p.Descricao AS periodo, "
		sql = sql & "     p.Cod_Periodo, "
		sql = sql & "     tur.Desc_Turno AS turno, "

		'------------------------------------------------------------
		' DIAS DA JUSTIFICATIVA
		'
		' Continua contando todos os dias lançados na justificativa.
		' Não depende de existir uma falta real.
		'------------------------------------------------------------

		sql = sql & "     COUNT(DISTINCT CONVERT(varchar(10), d.DataFalta, 120)) AS qtde_dias_justificados, "

		'------------------------------------------------------------
		' FALTAS EFETIVAMENTE JUSTIFICADAS
		'
		' 6º ao 9º:
		'     DATA + DISCIPLINA
		'
		' Demais períodos:
		'     DATA
		'
		' Como f vem do LEFT JOIN com FaltasReais,
		' somente datas que possuem falta real entram na contagem.
		'------------------------------------------------------------

		sql = sql & "     COUNT(DISTINCT "
		sql = sql & "         CASE "
		sql = sql & "             WHEN f.data_falta IS NOT NULL THEN "

		sql = sql & "                 CASE "
		sql = sql & "                     WHEN p.Cod_Periodo BETWEEN 6 AND 9 THEN "

		sql = sql & "                         CONVERT(VARCHAR(10), d.DataFalta, 120) "
		sql = sql & "                         + '|' "
		sql = sql & "                         + CONVERT(VARCHAR(20), ISNULL(d.cod_disciplina, 0)) "

		sql = sql & "                     ELSE "

		sql = sql & "                         CONVERT(VARCHAR(10), d.DataFalta, 120) "

		sql = sql & "                 END "

		sql = sql & "         END "
		sql = sql & "     ) AS qtde_faltas_justificadas "

		'------------------------------------------------------------
		' TABELA DE JUSTIFICATIVAS
		'------------------------------------------------------------

		sql = sql & " FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS j "

		sql = sql & " INNER JOIN SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA d "
		sql = sql & "     ON d.cod_aluno_justificativa_faltas = j.codigo "

		'------------------------------------------------------------
		' ALUNO
		'------------------------------------------------------------

		sql = sql & " INNER JOIN SCA_ALUNO a "
		sql = sql & "     ON a.codigo = j.cod_aluno "

		'------------------------------------------------------------
		' BIMESTRE
		'------------------------------------------------------------

		sql = sql & " INNER JOIN SCA_BIMESTRE b "
		sql = sql & "     ON b.Codigo = j.Cod_bimestre "

		'------------------------------------------------------------
		' TIPO DE JUSTIFICATIVA
		'------------------------------------------------------------

		sql = sql & " INNER JOIN SCA_TIPO_JUSTIFICATIVA_FALTAS t "
		sql = sql & "     ON t.Codigo = j.cod_Tipo_Justificativa_Faltas "

		'------------------------------------------------------------
		' TURMA
		'------------------------------------------------------------

		sql = sql & " INNER JOIN SCA_TURMA tu "
		sql = sql & "     ON tu.Cod_Turma = j.Cod_turma "

		'------------------------------------------------------------
		' PERÍODO
		'------------------------------------------------------------

		sql = sql & " INNER JOIN SCA_PERIODO p "
		sql = sql & "     ON p.Cod_Periodo = tu.Cod_periodo "

		'------------------------------------------------------------
		' CURSO
		'------------------------------------------------------------

		sql = sql & " INNER JOIN SCA_CURSO c "
		sql = sql & "     ON c.Cod_curso = p.Cod_curso "

		'------------------------------------------------------------
		' TURNO
		'------------------------------------------------------------

		sql = sql & " INNER JOIN SCA_TURNO tur "
		sql = sql & "     ON tur.Cod_Turno = tu.Cod_Turno "

		'------------------------------------------------------------
		' FALTAS REAIS
		'
		' Para 6º ao 9º:
		'   aluno + data + disciplina
		'
		' Para demais períodos:
		'   aluno + data
		'------------------------------------------------------------

		sql = sql & " LEFT JOIN FaltasReais f "
		sql = sql & "     ON f.cod_empresa = j.cod_empresa "
		sql = sql & "    AND f.ano_letivo = j.ano_letivo "
		sql = sql & "    AND f.cod_aluno = j.cod_aluno "
		sql = sql & "    AND f.data_falta = CAST(d.DataFalta AS DATE) "

		sql = sql & "    AND ( "
		sql = sql & "         p.Cod_Periodo NOT BETWEEN 6 AND 9 "
		sql = sql & "         OR f.cod_disciplina = ISNULL(d.cod_disciplina, 0) "
		sql = sql & "    ) "

		'------------------------------------------------------------
		' FILTROS
		'------------------------------------------------------------

		sql = sql & " WHERE j.ano_letivo = " & intAnoLetivo
		sql = sql & " AND tu.cod_empresa = " & strCod_empresa

		If intCodTurma <> "" Then
			sql = sql & " AND j.Cod_turma = " & intCodTurma
		End If

		sql = sql & " AND j.Cod_aluno = " & intCodAluno

		if intCodTipoJustificativa <> "0" then
			sql = sql & " AND j.cod_Tipo_Justificativa_Faltas = " & intCodTipoJustificativa
		end if

		if intCodBimestre <> "0" then
			sql = sql & " AND j.Cod_bimestre = " & intCodBimestre
		end if

		'------------------------------------------------------------
		' GROUP BY
		'------------------------------------------------------------

		sql = sql & " GROUP BY "
		sql = sql & "     j.codigo, "
		sql = sql & "     j.ano_letivo, "
		sql = sql & "     j.DataInicial, "
		sql = sql & "     j.DataFinal, "
		sql = sql & "     j.justificativa, "
		sql = sql & "     a.NOMEALUNO, "
		sql = sql & "     a.MATRICULA, "
		sql = sql & "     b.Descricao, "
		sql = sql & "     t.Descricao, "
		sql = sql & "     tu.NomeTurma, "
		sql = sql & "     tu.TurmaAluno, "
		sql = sql & "     c.Descricao, "
		sql = sql & "     p.Descricao, "
		sql = sql & "     p.Cod_Periodo, "
		sql = sql & "     tur.Desc_Turno "

		'------------------------------------------------------------
		' ORDER BY
		'------------------------------------------------------------

		sql = sql & " ORDER BY "
		sql = sql & "     j.ano_letivo, "
		sql = sql & "     a.NOMEALUNO, "
		sql = sql & "     j.DataInicial "


		'============================================================
		' INICIALIZA TOTAIS
		'============================================================

		qtde_faltas_justificadas = 0
		qtde_dias_justificados = 0
		quebraPagina = ""


		IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
			'response.write sql
		END IF


		rs.open sql, cnn

		if rs.eof = false then

			mostraCabecalho 

			strNomeAluno = rs("aluno")
			strMatricula = rs("MATRICULA")
			strNomeTurma = rs("NOMETURMA") & " - " & rs("TurmaAluno")
			strDescricaoCurso = rs("curso")
			strDescricaoPeriodo = rs("periodo")
			strDescricaoTurno = rs("TURNO")

			quebraPagina = "S"

			%>

			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">

				<tr>
					<td width="8%">Aluno(a):</td>
					<td width="63%">&nbsp;<strong><%=strNomeAluno%></strong></td>
					<td width="14%">Matr&iacute;cula:</td>
					<td width="15%">&nbsp;<strong><%=strMatricula%></strong></td>
				</tr>

				<tr>
					<td>Curso:</td>
					<td>&nbsp;<strong><%=strDescricaoCurso%></strong></td>
					<td>Turma:</td>
					<td>&nbsp;<strong><%=strNomeTurma%></strong></td>
				</tr>

				<tr>
					<td>Per&iacute;odo:</td>
					<td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
					<td>Turno:</td>
					<td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
				</tr>

			</table>

			<br>

			<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">

				<tr style="background-color: #e0e0e0;">

					<td width="10%" align="center" class="celula">
						<strong>Bimestre</strong>
					</td>

					<td width="20%" align="center" class="celula">
						<strong>Tipo</strong>
					</td>

					<td width="30%" align="center" class="celula">
						<strong>Justificativa</strong>
					</td>

					<td width="10%" align="center" class="celula">
						<strong>Data Inicial</strong>
					</td>

					<td width="10%" align="center" class="celula">
						<strong>Data Final</strong>
					</td>

					<td width="10%" align="center" class="celula">
						<strong>Dias Justificados</strong>
					</td>

					<td width="10%" align="center" class="celula">
						<%if mostraColunaAula = "S" then%>
							<strong>Aulas Justificadas</strong>
						<%else%>
							<strong>Faltas Justificadas</strong>
						<%end if%>
					</td>

				</tr>

			<%

			while not rs.eof	

				dataInicial = CDate(rs("DataInicial"))
				dataFinal = CDate(rs("DataFinal"))

				%>

				<tr 
					style="cursor:pointer"
					title="Clique para visualizar o atestado lançado"
					onClick="return abrePaginaJustificativa('<%=rs("codigo")%>')"
					onMouseOver="return linhaMouseOver(this)"
					onMouseOut="return linhaMouseOut(this)"
				>

					<td align="left" class="celula">
						&nbsp;<%=rs("bimestre")%>
					</td>

					<td align="left" class="celula">
						&nbsp;<%=rs("tipo")%>
					</td>

					<td align="left" class="celula">
						&nbsp;<%=ucase(rs("justificativa"))%>
					</td>

					<td align="center" class="celula">
						&nbsp;<%=formatadataAP(rs("DataInicial"))%>
					</td>

					<td align="center" class="celula">
						&nbsp;<%=formatadataAP(rs("DataFinal"))%>
					</td>

					<td align="center" class="celula">
						&nbsp;<%=rs("qtde_dias_justificados")%>
					</td>

					<td align="center" class="celula">
						&nbsp;<%=rs("qtde_faltas_justificadas")%>
					</td>

				</tr>

				<%

				'========================================================
				' ACUMULA OS TOTAIS
				'========================================================

				qtde_faltas_justificadas = _
					qtde_faltas_justificadas + _
					rs("qtde_faltas_justificadas")

				qtde_dias_justificados = _
					qtde_dias_justificados + _
					rs("qtde_dias_justificados")

				rs.movenext

			wend 

			%>

			<%
				'========================================================
				' RECALCULA OS TOTAIS GERAIS DO ALUNO SEM DUPLICIDADE
				'========================================================
				sqlTotal = ""
				sqlTotal = sqlTotal & " ;WITH FaltasReais AS ( "
				sqlTotal = sqlTotal & "     SELECT DISTINCT "
				sqlTotal = sqlTotal & "         F.cod_aluno, "
				sqlTotal = sqlTotal & "         CAST(F.data AS DATE) AS data_falta, "
				sqlTotal = sqlTotal & "         ISNULL(F.cod_disciplina, 0) AS cod_disciplina "
				sqlTotal = sqlTotal & "     FROM SCA_FALTAS_DIARIA F "
				sqlTotal = sqlTotal & "     WHERE F.cod_empresa = " & strCod_empresa
				sqlTotal = sqlTotal & "       AND F.ano_letivo = " & intAnoLetivo
				sqlTotal = sqlTotal & "       AND F.cod_aluno = " & intCodAluno
				sqlTotal = sqlTotal & " ), "
				sqlTotal = sqlTotal & " Justificativas AS ( "
				sqlTotal = sqlTotal & "     SELECT DISTINCT "
				sqlTotal = sqlTotal & "         d.DataFalta, "
				sqlTotal = sqlTotal & "         ISNULL(d.cod_disciplina, 0) AS cod_disciplina "
				sqlTotal = sqlTotal & "     FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS j "
				sqlTotal = sqlTotal & "     INNER JOIN SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA d "
				sqlTotal = sqlTotal & "         ON d.cod_aluno_justificativa_faltas = j.codigo "
				sqlTotal = sqlTotal & "     WHERE j.ano_letivo = " & intAnoLetivo
				sqlTotal = sqlTotal & "       AND j.cod_aluno = " & intCodAluno

				If intCodTurma <> "" Then
					sqlTotal = sqlTotal & "       AND j.Cod_turma = " & intCodTurma
				End If

				If intCodTipoJustificativa <> "0" Then
					sqlTotal = sqlTotal & "       AND j.cod_Tipo_Justificativa_Faltas = " & intCodTipoJustificativa
				End If

				If intCodBimestre <> "0" Then
					sqlTotal = sqlTotal & "       AND j.Cod_bimestre = " & intCodBimestre
				End If

				sqlTotal = sqlTotal & " ) "
				sqlTotal = sqlTotal & " SELECT "
				sqlTotal = sqlTotal & "     COUNT(DISTINCT CONVERT(VARCHAR(10), J.DataFalta, 120)) AS total_dias_justificados, "
				sqlTotal = sqlTotal & "     COUNT(DISTINCT "
				sqlTotal = sqlTotal & "         CASE "
				sqlTotal = sqlTotal & "             WHEN F.data_falta IS NOT NULL THEN "
				sqlTotal = sqlTotal & "                 CASE "
				sqlTotal = sqlTotal & "                     WHEN " & intCodPeriodo & " BETWEEN 6 AND 9 THEN "
				sqlTotal = sqlTotal & "                         CONVERT(VARCHAR(10), J.DataFalta, 120) + '|' + "
				sqlTotal = sqlTotal & "                         CONVERT(VARCHAR(20), J.cod_disciplina) "
				sqlTotal = sqlTotal & "                     ELSE "
				sqlTotal = sqlTotal & "                         CONVERT(VARCHAR(10), J.DataFalta, 120) "
				sqlTotal = sqlTotal & "                 END "
				sqlTotal = sqlTotal & "         END "
				sqlTotal = sqlTotal & "     ) AS total_faltas_justificadas "
				sqlTotal = sqlTotal & " FROM Justificativas J "
				sqlTotal = sqlTotal & " LEFT JOIN FaltasReais F "
				sqlTotal = sqlTotal & "     ON F.data_falta = CAST(J.DataFalta AS DATE) "
				sqlTotal = sqlTotal & "    AND ( "
				sqlTotal = sqlTotal & "         " & intCodPeriodo & " NOT BETWEEN 6 AND 9 "
				sqlTotal = sqlTotal & "         OR F.cod_disciplina = J.cod_disciplina "
				sqlTotal = sqlTotal & "    ) "

				Set rsTotal = Server.CreateObject("ADODB.Recordset")
				rsTotal.Open sqlTotal, cnn

				If Not rsTotal.EOF Then
					If Not IsNull(rsTotal("total_dias_justificados")) Then
						qtde_dias_justificados = rsTotal("total_dias_justificados")
					Else
						qtde_dias_justificados = 0
					End If

					If Not IsNull(rsTotal("total_faltas_justificadas")) Then
						qtde_faltas_justificadas = rsTotal("total_faltas_justificadas")
					Else
						qtde_faltas_justificadas = 0
					End If
				End If

				rsTotal.Close
				Set rsTotal = Nothing
			%>

				<tr style="background-color: #e0e0e0;">

					<td 
						align="left" 
						class="celula" 
						colspan="5"
					>
						&nbsp;<strong>Total</strong>
					</td>

					<td align="center" class="celula">
						&nbsp;<strong><%=qtde_dias_justificados%></strong>
					</td>

					<td align="center" class="celula">
						&nbsp;<strong><%=qtde_faltas_justificadas%></strong>
					</td>

				</tr>

			</table>

		<%		

		end if

		rs.close


		if j <> ubound(vetAluno) and quebraPagina = "S" then
			%>

			<pre></pre>				

			<%	
		end if			

	next

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

</body>

<script>
	aguarde.style.display="none";
</script>

</html>