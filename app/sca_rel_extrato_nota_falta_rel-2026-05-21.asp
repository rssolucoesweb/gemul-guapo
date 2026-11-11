<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title><%=session("Titulo")%> - Extrato de Notas e Faltas</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
<script>
alert("EM MANUTENÇÃO!")

</SCRIPT>
<%
RESPONSE.END

	dim intPagina
	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "Extrato de Notas e Faltas<br>"

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
	intCodTurma 		= Trim(Request.Form("cmbTurma"))
	strCod_empresa 		= Session("CodEmpresa")
	
	'DESCRICAO DO PERIODO	
	sql="SELECT P.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO "
	sql=sql & " FROM 	SCA_PERIODO P "
	sql=sql & " INNER 	JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA "
	sql=sql & " WHERE 	C.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND 	P.COD_PERIODO = " & intCodPeriodo
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoPeriodo  = rs("PERIODO")
		strDescricaoCurso 	 = rs("CURSO")
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
	strCodBimestre		= ""

	'BUSCA A AVALIACOES
	sql="SELECT distinct TA.POSICAO, TA.DESCRICAO, TA.BIMESTRE, CA.media_aprovacao"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA"
	sql=sql & " WHERE	CA.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		ta.cod_tipo_criterio = 1"
	sql=sql & " ORDER BY TA.POSICAO"
	
	rs.open sql, cnn, 3, 1
	if rs.eof = false then
		intMediaAprovacao = rs("media_aprovacao")
		intCont = 1
		redim vetTipoNota(rs.recordCount,2)
		while not rs.eof
			vetTipoNota(intCont,1) = ZeroLeft(RS("POSICAO"),2) & "_" & RS("BIMESTRE")
			vetTipoNota(intCont,2) = RS("DESCRICAO")
			intCont = intCont + 1
			rs.movenext
		wend
	end if
	rs.close
	
	strCodAluno			= Trim(Request("chkAluno"))
	if strCodAluno <> "" then
		vetAluno	=	split(Trim(Request.form("chkAluno")),",")
	end if
	

	if strCodAluno <> "" then 
		contQuebra = 0		
		for j=0 to ubound(vetAluno)
			mostraCabecalho
			sql = " SELECT SCA_ALUNO.CODIGO, "
			sql = sql & " 	SCA_ALUNO.MATRICULA, "
			sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
			sql = sql & " 	SCA_ALUNO_TURMA.SEQUENCIA, "
			sql = sql & " 	SCA_ALUNO_TURMA.COD_TURMA, "
			sql = sql & " 	SCA_TURMA.NOMETURMA, "
			sql = sql & " 	SCA_GRADECURRICULAR.Cod_Periodo, "
			sql = sql & " 	SCA_NOTAS_FALTAS.MEDIA, "
			for i=1 to ubound(vetTipoNota)
				strPos = left(vetTipoNota(i,1),2)
				sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
				sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
			next
			sql = sql & " 	SCA_DISCIPLINA.DESC_DISCIPLINA,"
			sql = sql & " 	SCA_TURNO.DESC_TURNO,"
			sql = sql & " 	SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
			sql = sql & " 	SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA "
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA and SCA_ALUNO_TURMA.situacao = 'A'"
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_TURMA.COD_EMPRESA = SCA_GRADECURRICULAR.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA		ON SCA_DISCIPLINA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA"
			sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
			sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
			sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
			sql = sql & " AND SCA_ALUNO.CODIGO = " & vetAluno(j)
			sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO"
			rs.open sql, cnn
			if rs.eof = false then
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("NOMETURMA")
				strDescricaoTurno= rs("DESC_TURNO")
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
				  <tr>
					<td width="16%" rowspan="2" align="center" class="celula">Disciplinas</td>
					<%FOR I=1 TO UBOUND(vetTipoNota) 
						strBim = right(vetTipoNota(I,1),1) & "ºBimestre" 
						'5	Média Provisória 
						'6	Exame
						'7	Conselho de Classe
						'8	Media Final							
						if cInt(right(vetTipoNota(I,1),1)) > 4 then strBim = vetTipoNota(I,2)
						if cInt(right(vetTipoNota(I,1),1)) = 5 then strBim = "Média Provisória"
						if cInt(right(vetTipoNota(I,1),1)) = 6 then strBim = "Exame"
						if cInt(right(vetTipoNota(I,1),1)) = 7 then strBim = "Cons. de Classe"
					%>
					<td align="center" class="celula" colspan="2"><%=strBim%></td>
					<%NEXT %>
					<td align="center" class="celula" >Média</td>
					<td align="center" class="celula" >Resultado</td>
					</tr>
				  <tr>
				    <%FOR I=1 TO UBOUND(vetTipoNota) %>
					<td align="center" class="celula"><%=vetTipoNota(I,2)%></td>
					<td align="center" class="celula">Falta</td>
					<%NEXT %>
					<td align="center" class="celula" >Final</td>
					<td align="center" class="celula" >Final</td>
					</tr>
				  <tr>
				<%
				while not rs.eof	
					strTotalFalta 	= 0
					strDisciplina 	= rs("DESC_DISCIPLINA")
					strMedia		= "---"
					strResultadoFinal 		= ""
					if not isnull(rs("MEDIA")) and rs("MEDIA")<>"" then
						strMedia = FORMATNUMBER(rs("MEDIA"),1)
						if cCur(strMedia) < cCur(intMediaAprovacao) then
							strResultadoFinal = "<font color='#FF0000'>RN</font>"
						else
							strResultadoFinal = "<font color='#0000FF'>AP</font>"
						end if
					end if
						%>
						<td width="16%" align="left" class="celula">&nbsp;<%=strDisciplina%></td>
						<%					
						for i=1 to ubound(vetTipoNota)
							strPos = left(vetTipoNota(i,1),2)
							strNota = "---"
							if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
								strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
							end if
							strFalta = ""
							if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
								strFalta = rs("FALTA" & strPos)
							end if
							%>
							<td width="5%" align="center" class="celula">&nbsp;<%=strNota%>&nbsp;</td>
							<td width="5%" align="center" class="celula">&nbsp;<%=strFalta%>&nbsp;</td>
							<%
						next
						%>
						<td width="5%" align="center" class="celula">&nbsp;<%=strMedia%>&nbsp;</td>
						<td width="5%" align="center" class="celula">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
					  </tr>
						<%
				
					rs.movenext
				wend 
				%></table>
				<br>
				<!--#include file="includes/inc_RepresentantesLegais.asp"-->
				<br>
			<%		
			end if
			rs.close
			contQuebra = contQuebra + 1
			if j <> ubound(vetAluno) and contQuebra = 2 then
				%>
				<pre></pre>				
				<%	
				contQuebra = 0		
			end if			
		next
		'next aluno		
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