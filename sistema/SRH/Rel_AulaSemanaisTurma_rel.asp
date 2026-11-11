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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<br>
<%
	dim intPagina
	dim strInfoTurma
	
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strSemestreTitulo		= "/" & Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strSemestreTitulo = "/3" then strSemestreTitulo = ""

	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	if strSemestre = "" then strSemestre = "0"

	intCodTurma 			= Trim(Request.Form("cmbTurmaProfessor"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	strOmitirHorario        = Trim(Request.Form("txtOmitirHorario"))
	intCodColaborador 		= Trim(Request.Form("cmbProfessor"))

	if intCodColaborador= "" then intCodColaborador 		= "0"
	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	if intCodGrade 		= "" then intCodGrade 		= "0"

	strFiltroSerie = "0"
	strFiltroTurno = "0"


	strTituloRelatorio  	= "AULAS SEMANAIS POR TURMAS - ( Horário de Aula ) <br> Referência: " & strAnoLetivo & strSemestreTitulo

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
        <%if strOmitirHorario <> "S" then %>
	       <td width="9%" rowspan="2" class="celula"><div align="center"><strong>Hor&aacute;rio </strong></div></td>
        <% end if %>
		<td width="5%" rowspan="2" class="celula"><div align="center"><strong>Aula</strong></div></td>
	    <%for i=1 to 7%>
			<td width="13%" height="7" colspan="2" class="celula"><div align="center"><strong><%=ucase(WeekDayName(i))%></strong></div></td>
      	<%next%>
	  </tr>
	  <tr bgcolor="#CCCCCC">
	  <%for i=1 to 7%>
	    <td width="6%" height="8" class="celula"><div align="center">Disciplina</div></td>
        <td width="7%" class="celula"><div align="center">Professor(a)</div></td>
		<%next%>
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

	sql = "SELECT DISTINCT  T.NOMETURMA,  T.TURMAALUNO, T.COD_TURMA, H.CODIGO AS COD_HORARIO, H.HORARIO, HA.SEQUENCIA, EMP.RAZAOSOCIAL AS ESCOLA"
	sql = sql & " 	FROM	SCA_HORARIO_AULA HA"
	sql = sql & " 	INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
	sql = sql & " 	INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
	sql = sql & " 	INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
	sql = sql & " 	INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
	sql = sql & " 	INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO"
	sql = sql & " 	INNER JOIN SEG_EMPRESA EMP ON EMP.CODIGO=HA.COD_EMPRESA "
    sql = sql & " 	LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR"
	sql = sql & " 	LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
	sql = sql & " WHERE	1=1 "
	sql = sql & " AND HA.COD_EMPRESA	= " & Session("CodEmpresa")
	sql = sql & " 	AND		HA.ANOLETIVO	= " & strAnoLetivo 
	sql = sql & " 	AND		HA.SEMESTRE		= " & strSemestre
	if intCodCurso <> "0" then
		sql = sql & " 	AND		CU.COD_CURSO		= " & intCodCurso
	end if
	if intCodColaborador <> "0" then
		sql = sql & " 	AND		C.CODIGO		= " & intCodColaborador
	end if
	if intCodTurma <> "0" then
		sql = sql & " 	AND		T.COD_TURMA		= " & intCodTurma
	end if
	sql = sql & " AND T.Situacao = 'A' " 
	sql = sql & " ORDER BY T.NOMETURMA, H.HORARIO, HA.SEQUENCIA"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
			if trim(strTurma)<>trim(rs("COD_TURMA")) then
			%>	  
			<tr bgcolor="#CCCCCC">
	    		<td height="25" colspan="16" class="celula"><div align="center"><strong><%=rs("NOMETURMA")%></strong></div></td>
      		</tr>
			<%
			end if
			%>
			  <tr height="40">
                 <%if strOmitirHorario <> "S" then %>
			       <td align="left" class="celula"><%=rs("HORARIO")%></td>
                 <% end if %>
				<td align="left" class="celula"><div align="center"><%=rs("SEQUENCIA")%>ª	</div></td>
				<%for i=1 to 7%>
				<!-- horario -->
				<%
					strDisciplina 	= ""
					strProfessor	= ""
					
					SQL = "SELECT C.NOME AS PROFESSOR,"
					SQL = SQL & " D.DESC_DISCIPLINA AS DISCIPLINA,"
					sql = sql & " 			H.HORARIO, "
					sql = sql & " 			HA.TEMPO, "
					sql = sql & " 			HA.SEQUENCIA"
					
					SQL = SQL & " FROM	SCA_HORARIO_AULA HA"
					SQL = SQL & " INNER JOIN SCA_HORARIO H ON H.CODIGO=HA.COD_HORARIO"
					SQL = SQL & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
					SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
					SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
					SQL = SQL & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO"
					if strCompartilharDados = "S" then
					   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR"
					else   
					   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.COD_EMPRESA=HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
					end if   
					SQL = SQL & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
					sql = sql & " WHERE	1=1 " 
					if strCompartilharDados = "S" then
					   'sql = sql & " AND HA.COD_EMPRESA	= " & session("CodEmpresa")
					else   
					   sql = sql & " AND HA.COD_EMPRESA	= " & session("CodEmpresa") 
					end if     
					
					if intCodColaborador <> "0" then
						sql = sql & " 	AND		C.CODIGO		= " & intCodColaborador
					end if
					sql = sql & " AND		HA.ANOLETIVO	= " & strAnoLetivo 
					sql = sql & " AND		HA.SEMESTRE		= " & strSemestre
					SQL = SQL & " AND		T.COD_TURMA		= " & RS("COD_TURMA")
					SQL = SQL & " AND		HA.DIASEMANA    = " & i
					SQL = SQL & " AND		H.CODIGO    	= " & RS("COD_HORARIO")
					SQL = SQL & " AND		HA.SEQUENCIA    = " & RS("SEQUENCIA")
					
					RSAux.open sql, cnn
					if not RSAux.eof then 
						strDisciplina 	= RSAux("DISCIPLINA")
						strProfessor	= RSAux("PROFESSOR")
						if isnull(strProfessor) then strProfessor = "<strong><font color='#FF0000'>**DEFICIT**</font></strong>" 
					end if
					RSAux.close
					%>				
				
				<!-- fim horario -->				
				<td  align="left" class="celula"><%=strDisciplina%>&nbsp;</td>
				<td  align="left" class="celula"><%=strProfessor%>&nbsp;</td>
				<%next%>
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
			strTurma = rs("COD_TURMA")
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  
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
