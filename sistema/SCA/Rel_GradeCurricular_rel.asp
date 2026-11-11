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
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intGradeagrupamento	 			= Trim(Request.Form("cmbGradeagrupamento"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	IF intCodCurso	= "" THEN intCodCurso	= 0
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strSituacao 			= Trim(Request.Form("cmbSituacao"))
	strMostraEquivalencia   = Trim(Request.Form("MostrarEquivalencia"))
	
	'DESCRICAO DO CURSO
	sql="SELECT C.DESCRICAO, G.DATAINICIOVIGENCIA, G.DATAFIMVIGENCIA"
	sql=sql & " FROM SCA_CURSO C"
	sql=sql & " INNER JOIN SCA_PERIODO P ON P.COD_CURSO = C.COD_CURSO AND P.COD_EMPRESA = C.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_PERIODO = P.COD_PERIODO AND G.COD_EMPRESA = P.COD_EMPRESA"
	sql=sql & " WHERE G.COD_EMPRESA = " & session("CodEmpresa")
    if intGradeagrupamento = "0" then
	   sql=sql & " AND C.COD_CURSO = " & intCodCurso
	   sql=sql & " AND G.AnoReferencia = " & strAnoLetivo
	   sql=sql & " AND G.SemestreReferencia = " & strSemestre
	else   
	   sql=sql & " AND G.cod_agrupamento = " & intGradeagrupamento
	end if   
    sql=sql & " GROUP BY C.DESCRICAO, G.DATAINICIOVIGENCIA, G.DATAFIMVIGENCIA"
	sql=sql & " ORDER BY 2 DESC"
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoCurso 	 = UCASE(rs("DESCRICAO"))
		strVigencia = ""
		IF NOT ISNULL(rs("DATAINICIOVIGENCIA")) THEN
			strVigencia = "Vigência: " & FORMATADATAAP(rs("DATAINICIOVIGENCIA")) & " a " & FORMATADATAAP(rs("DATAFIMVIGENCIA"))
		END IF
	end if
	rs.close
		
	strFiltro	 			= Trim(Request("f"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "MATRIZ CURRICULAR "

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td colspan="4" class="TituloFormulario" align="center"><font size="+1"><%=UCASE(strDescricaoCurso)%></font><BR><%=strVigencia%></td>
	  </tr>
	</table>	
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="6%" rowspan="2" class="celula"><div align="center"><strong>Cod. Grade </strong></div></td>
	    <td width="19%" height="15" rowspan="2" class="celula"><div align="center"><strong>Disciplinas da Grades </strong></div></td>
	    <td width="9%" rowspan="2" class="celula"><div align="center"><strong>Cod. Disc. </strong></div></td>
	    <td width="17%" rowspan="2" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
	    <td colspan="3" class="celula"><div align="center"><strong>C.H.</strong></div></td>
        <% if strMostraEquivalencia="S" then %>
	       <td colspan="6" class="celula"><div align="center"><strong>Equival&ecirc;ncia</strong></div></td>
        <% End if %>
        </tr>
	    <tr bgcolor="#CCCCCC">
	    <td width="5%" class="celula"><div align="center">S</div></td>
        <td width="5%" class="celula"><div align="center">M</div></td>
        <td width="5%" class="celula"><div align="center">A</div></td>
        <% if strMostraEquivalencia="S" then %>
           <td width="5%" class="celula"><div align="center"><strong>Cod.Grade</strong></div>
           <td width="6%" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
           <td width="18%" class="celula"><div align="center"><strong>Disciplina</strong></div></td>
           <td width="5%" class="celula"><div align="center"><strong>C.H</strong></div></td>
        <% end if %>
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
	totalCh_Anual_Equivalente = 0
	totalGCh_Anual_Equivalente = 0
	contPeriodo = 0

	sql = "SELECT "
	sql = sql & " 	SCA_GRADECURRICULAR.Cod_GRADECURRICULAR,"
	sql = sql & " 	SCA_GRADECURRICULAR.Cod_AGRUPAMENTO,"
	sql = sql & " 	SCA_CURSO.COD_CURSO, "
	sql = sql & " 	SCA_CURSO.DESCRICAO, "
	sql = sql & " 	SCA_PERIODO.cod_periodo, "
	sql = sql & " 	SCA_PERIODO.Descricao as PERIODO, "
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
	sql = sql & " 	SCA_DISCIPLINA.DESC_Disciplina, SCA_GRAU.DESC_GRAU,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Anual,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR_EQUIVALENTE,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULARDISCIPLINA_EQUIVALENTE,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.COD_DISCIPLINA_EQUIVALENTE "
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA" 
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRAU ON SCA_GRAU.Cod_Grau = SCA_CURSO.Cod_Grau and SCA_GRAU.cod_empresa = SCA_CURSO.cod_empresa "
	sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
    if intGradeagrupamento = "0" then
	   sql = sql & " WHERE	SCA_PERIODO.cod_Curso = " & intCodCurso
	   sql = sql & " AND 	SCA_GRADECURRICULAR.AnoReferencia = " & strAnoLetivo 
	   sql = sql & " AND 	SCA_GRADECURRICULAR.SemestreReferencia = " & strSemestre
	else   
	   sql = sql & " WHERE	1=1 "
	   sql=sql & " AND SCA_GRADECURRICULAR.cod_agrupamento = " & intGradeagrupamento
	end if   
	sql = sql & " AND	SCA_PERIODO.Cod_Empresa = " & session("CodEmpresa")
	if strSituacao <> "T" then
		sql = sql & " AND 	SCA_GRADECURRICULAR.situacao = '" & strSituacao & "'"
	end if
	sql = sql & " ORDER BY SCA_PERIODO.SEQUENCIA, SCA_DISCIPLINA.DESC_Disciplina"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		   
			if cont > 1 and  trim(cod_periodo) <> trim(rs("cod_periodo")) then
			%>
			  <tr>
			    <td colspan="4" align="left" class="celula"><div align="right"><strong>Carga Hor&aacute;rio total do per&iacute;odo:&nbsp; </strong></div></td>
			    <td align="center" class="celula">&nbsp;<strong><%=totalCh_Semanal%></strong></td>
			    <td align="center" class="celula">&nbsp;<strong><%=totalCh_Mensal%></strong></td>
			    <td align="center" class="celula">&nbsp;<strong><%=totalCh_Anual%></strong></td>
                <% if strMostraEquivalencia="S" then %>
                    <td align="center" class="celula">&nbsp;</td>
                    <td align="center" class="celula">&nbsp;</td>
                    <td align="center" class="celula">&nbsp;</td>
                    <td align="center" class="celula"><strong><%=totalCh_Anual_Equivalente%></strong></td>
                <% end if %>
     
			  </tr>
			<%
				totalCh_Semanal = 0
				totalCh_Mensal = 0
				totalCh_Anual = 0
				totalCh_Anual_Equivalente = 0
				contPeriodo = contPeriodo + 1
			end if

			intCodGradeCurricularDisciplinaEquivalente =  rs("COD_DISCIPLINA_EQUIVALENTE")
			if isnull(intCodGradeCurricularDisciplinaEquivalente) or intCodGradeCurricularDisciplinaEquivalente = "" then intCodGradeCurricularDisciplinaEquivalente="0"
			 
		    intGrupoEquivalencia = ""
		    intPeriodoEquivalencia = ""
		    intDisciplinaEquivalencia = ""
		    intChAnualEquivalencia = 0
		    intCodGradeCurricular = ""

			sql = " SELECT SCA_GRADECURRICULAR.Cod_AGRUPAMENTO, "
			sql = sql & " SCA_PERIODO.Descricao as PERIODO, "
			sql = sql & " SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, "
			sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, "
			sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Anual "
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR "
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
			sql = sql & " WHERE Cod_GradeCurricularDisciplina = " & intCodGradeCurricularDisciplinaEquivalente
			rs1.open sql, cnn
	        if not rs1.eof then 
			   intGrupoEquivalencia = rs1("Cod_AGRUPAMENTO")
			   intCodGradeCurricular = rs1("COD_GRADECURRICULAR")
			   intPeriodoEquivalencia = rs1("PERIODO")
			   intDisciplinaEquivalencia = rs1("DESC_Disciplina")
			   intChAnualEquivalencia = rs1("Ch_Anual")
			end if
            rs1.close

			%>
			  <tr>
			    <td align="left" class="celula"><div align="center">&nbsp;<%=rs("Cod_AGRUPAMENTO")%>.<%=rs("COD_GRADECURRICULAR")%></div></td>
			    <td align="left" class="celula"><%=rs("DESC_Disciplina")%></td>
			    <td align="left" class="celula"><%=rs("Cod_Disciplina")%></td>
			    <td align="left" class="celula"><%=rs("PERIODO")%></td>
			    <td align="center" class="celula">&nbsp;<%=rs("Ch_Semanal")%></td>
			    <td align="center" class="celula">&nbsp;<%=rs("Ch_Mensal")%></td>
			    <td align="center" class="celula">&nbsp;<%=rs("Ch_Anual")%></td>
                <% if strMostraEquivalencia="S" then %>
                    <td align="center" class="celula">&nbsp;<strong><%=intGrupoEquivalencia%></strong></td>
                    <td align="center" class="celula">&nbsp;<strong><%=intPeriodoEquivalencia%></strong></td>
                    <td class="celula">&nbsp;<strong><%=intDisciplinaEquivalencia%></strong></td>
                    <td align="center" class="celula">&nbsp;<%=intChAnualEquivalencia%></td>
                <% end if %>
			  </tr>
			<%
			
			totalCh_Semanal = totalCh_Semanal + rs("Ch_Semanal")
			totalCh_Mensal = totalCh_Mensal + rs("Ch_Mensal")
			totalCh_Anual = totalCh_Anual + rs("Ch_Anual")

			totalGCh_Semanal = totalGCh_Semanal + rs("Ch_Semanal")
			totalGCh_Mensal = totalGCh_Mensal + rs("Ch_Mensal")
			totalGCh_Anual = totalGCh_Anual + rs("Ch_Anual")

		    totalCh_Anual_Equivalente = totalCh_Anual_Equivalente + intChAnualEquivalencia
		    totalGCh_Anual_Equivalente = totalGCh_Anual_Equivalente + intChAnualEquivalencia
			
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
			cod_periodo = trim(rs("cod_periodo"))
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
		%>
		  <tr>
			<td colspan="4" align="left" class="celula"><div align="right"><strong>Carga Hor&aacute;rio total do per&iacute;odo:&nbsp; </strong></div></td>
			<td align="center" class="celula">&nbsp;<strong><%=totalCh_Semanal%></strong></td>
			<td align="center" class="celula">&nbsp;<strong><%=totalCh_Mensal%></strong></td>
			<td align="center" class="celula">&nbsp;<strong><%=totalCh_Anual%></strong></td>
            <% if strMostraEquivalencia="S" then %>
                <td align="center" class="celula">&nbsp;</td>
                <td align="center" class="celula">&nbsp;</td>
                <td align="center" class="celula">&nbsp;</td>
                <td align="center" class="celula"><strong><%=totalCh_Anual_Equivalente%></strong></td>
        	<% end if %>
		  </tr>
		  <tr>
			<td colspan="4" align="left" class="celula"><div align="right"><strong>Carga Hor&aacute;rio total do curso:&nbsp; </strong></div></td>
			<td align="center" class="celula">&nbsp;<strong><%=totalGCh_Semanal%></strong></td>
			<td align="center" class="celula">&nbsp;<strong><%=totalGCh_Mensal%></strong></td>
			<td align="center" class="celula">&nbsp;<strong><%=totalGCh_Anual%></strong></td>
            <% if strMostraEquivalencia="S" then %>
                <td align="center" class="celula">&nbsp;</td>
                <td align="center" class="celula">&nbsp;</td>
                <td align="center" class="celula">&nbsp;</td>
                <td align="center" class="celula"><strong><%=totalGCh_Anual_Equivalente%></strong></td>
            <% end if %>
		  </tr>
		  <tr>
			<td colspan="19" class="celula">Quantidade de Períodos: <%=contPeriodo%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="11" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
