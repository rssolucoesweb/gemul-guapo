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
<!--#include file=../../includes/inc_aguarde.asp--><br>
<%
	dim intPagina
	dim strInfoTurma

	sub mostraCabecalho()
	    %>
	    <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->

	    <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
		<br>
		<div align="center"><font size="+1"><%=strDescricaoCurso%></font></div>
		<div align="center"><%=DescCompletaDoCurso%></div>
        <br>
		<tr>
		<td width="8%" class="<%=strclasse%>">Aluno(a):</td>
		<% if intCodAluno <> "" then %>
		      <td width="63%" class="<%=strclasse%>">&nbsp;<strong><%=strNomeAluno%></strong></td>
		<%else%>   
		      <td height="25" width="63%" class="<%=strclasse%>" colspan="6">&nbsp;</strong></td>
		<%end if%>  
		<% if intCodAluno <> "" then %> 
		      <td width="14%" class="<%=strclasse%>">Matr&iacute;cula:</td>
			  <td width="15%" class="<%=strclasse%>">&nbsp;<strong><%=strMatricula%></strong></td>
		<%else%>
	      <%end if%>  
	    </tr>
		<tr>
		<% if intCodAluno <> "" then %> 
		      <td class="<%=strclasse%>">Turma:</td>
		      <td class="<%=strclasse%>" colspan="6">&nbsp;<strong><%=strNomeTurma%></strong></td>
		<%else%>
		      <td class="<%=strclasse%>">Turma:</td>
		      <td height="25" class="<%=strclasse%>" colspan="6">&nbsp;</strong></td>
		<%end if%>  
		</tr>
		<tr>
		<% if intCodAluno <> "" then %> 
		      <td class="<%=strclasse%>">Per&iacute;odo:</td>
		      <td class="<%=strclasse%>">&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
		      <td class="<%=strclasse%>">Turno:</td>
		      <td class="<%=strclasse%>">&nbsp;<strong><%=strDescricaoTurno%></strong></td>
		<%else%>
		      <td height="25" class="<%=strclasse%>">Per&iacute;odo:</td>
		      <td class="<%=strclasse%>">&nbsp;</td>
		      <td height="25" class="<%=strclasse%>">Turno:</td>
		<%end if%>	
		</tr>
		</table>
		<br>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
          <tr bgcolor="#CCCCCC">
            <td rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Grupo</strong></div></td>
            <td width="76" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Cod. Grade </strong></div></td>
            <td width="573" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Disciplinas da Grades </strong></div></td>
            <td width="89" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Cod. Disc. </strong></div></td>
            <td width="101" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Per&iacute;odo</strong></div></td>
            <td height="4" colspan="4" class="<%=strclasse%>"><div align="center"><strong>C.H.</strong></div></td>
            <td height="4" colspan="4" class="<%=strclasse%>"><div align="center"><strong>Cursar?</strong></div></td>
          </tr>
          <tr bgcolor="#CCCCCC">
            <td width="82" class="<%=strclasse%>"><div align="center"><strong>S</strong></div></td>
            <td width="86" class="<%=strclasse%>"><div align="center"><strong>M</strong></div></td>
            <td colspan="2" class="<%=strclasse%>"><div align="center"><strong>A</strong></div></td>
            <td width="54"  class="<%=strclasse%>"><div align="center">(S/N)</div></td>
          </tr>
          <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub	

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
	intCodAluno 			= request.Form("txtCodAluno")
    intCodCurso 		    = Trim(Request("cmbCurso"))
	strOpcional 			= request.Form("opcional")
    intCodGradeagrupamento	= Trim(Request.Form("cmbGradeagrupamento"))	
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "FICHA PARA ANÁLISE CURRICULAR "


	if intCodAluno <> "" then
	   sql=" SELECT A.MATRICULA, A.NOMEALUNO, T.NOMETURMA, TU.DESC_TURNO, SCA_PERIODO.Cod_periodo, SCA_CURSO.descricao as curso, "
	   sql=sql & " SCA_PERIODO.descricao as periodo, SCA_PERIODO.Cod_curso, SCA_CURSO.habilitacao, SCA_CURSO.reconhecimento, "
	   sql=sql & " SCA_CURSO.autorizacao"
	   sql=sql & " FROM SCA_ALUNO A "
	   sql=sql & " INNER JOIN SCA_ALUNO_TURMA AT	ON AT.COD_ALUNO = A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
	   sql=sql & " INNER JOIN SCA_TURMA T			ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
	   sql=sql & " INNER JOIN SCA_TURNO TU			ON TU.COD_TURNO = T.COD_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
	   sql=sql & " INNER JOIN SCA_GRADECURRICULAR 	ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR  and T.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	   sql=sql & " INNER JOIN SCA_PERIODO			ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	   sql=sql & " INNER JOIN SCA_CURSO			ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	   sql=sql & " WHERE  AT.COD_ALUNO = " & intCodAluno
	   sql=sql & " AND	  AT.COD_EMPRESA = " & session("CodEmpresa")
	   sql=sql & " AND	  AT.SITUACAO = 'A'"
	else
	   sql=" SELECT DISTINCT SCA_PERIODO.Cod_periodo, " 
	   sql=sql & " SCA_CURSO.descricao as curso, " 
	   sql=sql & " SCA_PERIODO.descricao as periodo, "
	   sql=sql & " SCA_PERIODO.Cod_curso, " 
	   sql=sql & " SCA_CURSO.habilitacao,  "
	   sql=sql & " SCA_CURSO.reconhecimento, " 
	   sql=sql & " SCA_CURSO.autorizacao "
	   sql=sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
	   sql=sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR "
	   sql=sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	   sql=sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	   sql=sql & " INNER JOIN SCA_GRAU ON SCA_GRAU.Cod_Grau = SCA_CURSO.Cod_Grau and SCA_GRAU.cod_empresa = SCA_CURSO.cod_empresa "
	   sql=sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
       sql=sql & " WHERE SCA_PERIODO.Cod_Empresa = " & session("CodEmpresa")
       if intGradeagrupamento = "0" then
   	      sql=sql & " AND SCA_PERIODO.cod_Curso = " & intCodCurso
	   else
          sql=sql & " AND SCA_GRADECURRICULAR.cod_agrupamento = " & intCodGradeagrupamento
	   end if  	   	  
	   sql=sql & " AND SCA_GRADECURRICULAR.situacao = 'A' "
       sql=sql & " ORDER BY SCA_PERIODO.Descricao "
	end if		
	rs.open sql, cnn
	if rs.eof = false then
	    if intCodAluno <> "" then
		   strNomeAluno 	 = rs("NOMEALUNO")
		   strMatricula 	 = rs("MATRICULA")
		   strNomeTurma 	 = rs("NOMETURMA")
		   strDescricaoTurno= rs("DESC_TURNO")
		end if   
		strDescricaoCurso= rs("curso")
		strDescricaoPeriodo = rs("periodo")
		intCodCurso			= rs("Cod_curso")
		intCodPeriodo		= rs("Cod_periodo")

		DescCompletaDoCurso = "Habilitação: " & rs("habilitacao") 
		DescCompletaDoCurso = DescCompletaDoCurso & "&nbsp;&nbsp;|&nbsp;&nbsp;Reconhecimento: "& rs("reconhecimento") 
		DescCompletaDoCurso = DescCompletaDoCurso & "&nbsp;&nbsp;|&nbsp;&nbsp;Autorização: " & rs("autorizacao")
		rs.close
	else
	    rs.close
		%>
		<script>
		   alert("Aluno ainda não alocado. Verifique!");
		   window.history.back();
		</script>
		<%
		response.end
	end if

    mostraCabecalho  
		   
	intPagina = 1
	cont = 0
	totalCh_Semanal = 0
	totalCh_Mensal = 0
	totalCh_Anual = 0
    totalGCh_Anual = 0

	contPeriodo = 1
	sql = "SELECT "
	sql = sql & " 	SCA_GRADECURRICULAR.Cod_GRADECURRICULAR,"
	sql = sql & " 	SCA_GRADECURRICULAR.Cod_agrupamento,"
	sql = sql & " 	SCA_CURSO.COD_CURSO, "
	sql = sql & " 	SCA_CURSO.DESCRICAO, "
	sql = sql & " 	SCA_PERIODO.cod_periodo, "
	sql = sql & " 	SCA_PERIODO.Descricao as PERIODO, "
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
	sql = sql & " 	SCA_DISCIPLINA.DESC_Disciplina, SCA_GRAU.DESC_GRAU,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Anual"
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA" 
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRAU ON SCA_GRAU.Cod_Grau = SCA_CURSO.Cod_Grau and SCA_GRAU.cod_empresa = SCA_CURSO.cod_empresa "
	sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	sql = sql & " WHERE	SCA_PERIODO.Cod_Empresa = " & session("CodEmpresa")
	if intGradeagrupamento = "0" then
	   sql = sql & " AND SCA_PERIODO.cod_Curso = " & intCodCurso
	   sql = sql & " AND SCA_GRADECURRICULAR.AnoReferencia = " & strAnoLetivo 
	   sql = sql & " AND SCA_GRADECURRICULAR.SemestreReferencia in (" & strSemestre & ")"
	else   
	   sql=sql & " AND SCA_GRADECURRICULAR.cod_agrupamento = " & intCodGradeagrupamento
	end if 
    sql=sql & " AND SCA_GRADECURRICULAR.situacao = 'A' "
	sql = sql & " ORDER BY SCA_PERIODO.SEQUENCIA, SCA_DISCIPLINA.DESC_Disciplina"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
          <tr>
            <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("Cod_agrupamento")%></div></td>
            <td align="left" class="<%=strclasse%>">&nbsp;<%=rs("Cod_GRADECURRICULAR")%></td>
            <td align="left" class="<%=strclasse%>">&nbsp;<%=rs("DESC_Disciplina")%></td>
            <td align="left" class="<%=strclasse%>">&nbsp;<%=rs("Cod_Disciplina")%></td>
            <td align="left" class="<%=strclasse%>">&nbsp;<%=rs("PERIODO")%></td>
            <td align="center" class="<%=strclasse%>">&nbsp;<%=rs("Ch_Semanal")%></td>
            <td align="center" class="<%=strclasse%>">&nbsp;<%=rs("Ch_Mensal")%></td>
            <td align="center" class="<%=strclasse%>" colspan="2">&nbsp;<%=rs("Ch_Anual")%></td>
            <td align="center" class="<%=strclasse%>" colspan="2">&nbsp;</td>
          </tr>
          <%if strOpcional = "S" then%>
          <tr>
            <td height="20" colspan="3" align="left" class="<%=strclasse%>">Disciplina:</td>
            <td colspan="4" align="left" class="<%=strclasse%>">C.Hor.:</td>
            <td colspan="2" align="center" class="<%=strclasse%>"><div align="left">M&eacute;dia: </div></td>
			<td colspan="2" align="center" class="<%=strclasse%>"><div align="left">&nbsp;</div></td>
          </tr>
          <tr>
            <td height="20" colspan="11" align="left" class="<%=strclasse%>">Observa&ccedil;&atilde;o:</td>
          </tr>
          <%end if

			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
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
			totalCh_Semanal = totalCh_Semanal + rs("Ch_Semanal")
	        totalCh_Mensal = totalCh_Mensal + rs("Ch_Mensal")
	        totalCh_Anual = totalCh_Anual + rs("Ch_Anual")
			totalGCh_Anual = totalGCh_Anual + rs("Ch_Anual")

			rs.movenext
			if not rs.eof then
		       if trim(cod_periodo) <> trim(rs("cod_periodo")) then
   	   		      contPeriodo = contPeriodo + 1
		          %>
		          <tr bgcolor="#CCCCCC">
                  <td height="4" colspan="5" align="left" class="<%=strclasse%>"><div align="right"><strong>Carga Hor&aacute;rio total do per&iacute;odo:&nbsp; </strong></div></td>
                  <td align="center" class="<%=strclasse%>">&nbsp;<strong><%=totalCh_Semanal%></strong></td>
                  <td align="center" class="<%=strclasse%>">&nbsp;<strong><%=totalCh_Mensal%></strong></td>
                  <td align="center" class="<%=strclasse%>" colspan="2">&nbsp;<strong><%=totalCh_Anual%></strong></td>
                  <td align="center" class="<%=strclasse%>" colspan="2">&nbsp;</td>
                  </tr>
                  <%
			      totalCh_Semanal = 0
			      totalCh_Mensal = 0
			      totalCh_Anual = 0
			   end if
			else
		       %>
		       <tr bgcolor="#CCCCCC">
               <td height="4" colspan="5" align="left" class="<%=strclasse%>"><div align="right"><strong>Carga Hor&aacute;rio total do per&iacute;odo:&nbsp; </strong></div></td>
               <td align="center" class="<%=strclasse%>">&nbsp;<strong><%=totalCh_Semanal%></strong></td>
               <td align="center" class="<%=strclasse%>">&nbsp;<strong><%=totalCh_Mensal%></strong></td>
               <td align="center" class="<%=strclasse%>" colspan="2">&nbsp;<strong><%=totalCh_Anual%></strong></td>
               <td align="center" class="<%=strclasse%>" colspan="2">&nbsp;</td>
               </tr>
               <%
			   totalCh_Semanal = 0
			   totalCh_Mensal = 0
			   totalCh_Anual = 0
            end if
		wend
		%>
		<tr bgcolor="#CCCCCC">
        <td height="4" colspan="5" align="left" class="<%=strclasse%>"><div align="right"><strong>Carga Hor&aacute;rio total do curso:&nbsp;</strong></div></td>
        <td align="center" class="<%=strclasse%>">&nbsp;<strong><%=totalGCh_Semanal%></strong></td>
        <td align="center" class="<%=strclasse%>">&nbsp;<strong><%=totalGCh_Mensal%></strong></td>
        <td align="center" class="<%=strclasse%>" colspan="2">&nbsp;<strong><%=totalGCh_Anual%></strong></td>
        <td align="center" class="<%=strclasse%>" colspan="2">&nbsp;</td>
        </tr>
        <tr>
        <td colspan="11" class="<%=strclasse%>">Quantidade de Períodos: <%=contPeriodo%></td>
        </tr>
        <%
	else
		%>
          <tr>
            <td colspan="11" class="<%=strclasse%>" align="center"><br>
              <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
          </tr>
          <%
	end if
	rs.close
%>
        </table>
		</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
