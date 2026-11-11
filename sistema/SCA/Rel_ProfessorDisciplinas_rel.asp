<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	

	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strDiaSemana 			= Trim(Request.Form("cmbDiaSemana"))

	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	if strSemestre = "" then strSemestre = "0"
	if strDiaSemana = "" then strDiaSemana = "0"

	strFiltroSerie = "0"
	strFiltroTurno = "0"


	strTituloRelatorio  	= "PROFESSORES E DISCIPLINAS MINISTRADAS"
	IF strDiaSemana <> "0" THEN strTituloRelatorio = strTituloRelatorio & "<BR>" & UCASE(WeekDayName(strDiaSemana))

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="20%" class="celula"><div align="center"><strong>Nome do Professor(a)  </strong></div></td>
	    <td width="15%" class="celula"><div align="center"><strong>Curso </strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Período </strong></div></td>
	    <td width="10%" height="15" class="celula"><div align="center"><strong>Turma </strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Disciplina </strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Hor&aacute;rio</strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Temp/Ord</strong></div></td>
        <td width="15%" class="celula"><div align="center"><strong>Assinatura</strong></div></td>
	  </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	totalCh_Semanal = 0
	totalCh_Mensal = 0
	totalCh_Anual = 0
	contPeriodo = 0

	sql = "SELECT	C.NOME AS PROFESSOR,"
	sql = sql & " 			CU.DESCRICAO AS CURSO,"
	sql = sql & " 			P.DESCRICAO AS PERIODO, "
	sql = sql & " 			T.NOMETURMA,"
	sql = sql & " 			D.DESC_DISCIPLINA AS DISCIPLINA,"
	sql = sql & " 			H.HORARIO, "
	sql = sql & " 			HA.TEMPO, "
	sql = sql & " 			HA.SEQUENCIA,"
	sql = sql & " 			HA.DIASEMANA"
	sql = sql & " 	FROM	SCA_HORARIO_AULA HA"
	sql = sql & " 	INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
	sql = sql & " 	INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
	sql = sql & " 	INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
	sql = sql & " 	INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
	sql = sql & " 	INNER JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO"
	sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA=HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
	sql = sql & " 	INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
	sql = sql & " 	WHERE	HA.COD_EMPRESA	= " & session("CodEmpresa")
	IF strAnoLetivo <> "" THEN
		sql = sql & " 	AND		HA.ANOLETIVO	= " & strAnoLetivo 
	END IF
	IF strSemestre <> "0" THEN
		sql = sql & " 	AND		HA.SEMESTRE		= " & strSemestre
	END IF
	IF strDiaSemana <> "0" THEN
		sql = sql & " 	AND		HA.DIASEMANA	= " & strDiaSemana
	END IF
	sql = sql & " 	ORDER BY C.NOME, CU.DESCRICAO,P.Descricao,G.Cod_GRADECURRICULAR, T.NOMETURMA, H.HORARIO"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
		
				strDisciplina = rs("DISCIPLINA")
				strDocente = rs("PROFESSOR")
			%>
			  <tr height="28">
			    <td align="left" class="celula"><%=strDocente%>&nbsp;</td>
			    <td align="left" class="celula"><%=rs("CURSO")%></td>
			    <td align="left" class="celula"><%=rs("PERIODO")%></td>
			    <td align="left" class="celula"><%=rs("NOMETURMA")%></td>
			    <td align="left" class="celula"><%=strDisciplina%>&nbsp;</td>
			    <td align="left" class="celula"><%=rs("HORARIO")%></td>
			    <td align="left" class="celula"><%=rs("TEMPO")%>/<%=rs("SEQUENCIA")%>ª Aula</td>
		        <td align="left" class="celula">&nbsp;</td>
			  </tr>
			<%
			
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td colspan="8" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
