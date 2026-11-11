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
<title><%=session("Titulo")%> - Alunos Por Turma</title>
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

	strTituloRelatorio		= "Remanejamento"
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno 			= Trim(Request.Form("cmbTurno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSituacaoDisciplina 	= Trim(Request.Form("cmbSituacaoDisciplina"))
	strRemanejamento		= Trim(Request.Form("cmbRemanejamento"))

	if intCodTurno 	= "" then intCodTurno = "0"
	if intCodTurma 	= "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if strRemanejamento = "" then strRemanejamento = "N"

    sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <%
	  if strSubTitulo <> "" then
	     %>
	     <tr bgcolor="#CCCCCC">
	     <td colspan="7" class="<%=strclasse%>"><div align="center"><%=strSubTitulo%>&nbsp;</div></td>
         </tr>
		 <%
	  end if	
	  %> 
	  <tr bgcolor="#CCCCCC">
		<td width="7%" class="celula"><strong>Matr&iacute;cula</strong></td>
		<td width="34%" class="celula"><strong>Nome do aluno </strong></td>
		<td width="11%" class="celula"><strong>Turma Origem</strong></td>
		<td width="11%" class="celula"><strong>Discip. Origem </strong></td>
		<td width="11%" class="celula"><strong>Turma Remanejamento</strong></td>
		<td width="19%" class="celula"><strong>Discip. Remanejamento </strong></td>
		<td width="7%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
	  </tr>
	<%
	end Sub
	
	sub quebraTurma() 
	%>
	  <tr bgcolor="#E2E2E2">
	    <td colspan="7" class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
      </tr>
	<%
	end Sub	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	mostraCabecalho
	cont = 0
	
    if intCodCurso <> "" or intCodCurso <> "0" then
	
		sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
		sql = sql & " AD.COD_ALUNO AS CODIGO, " 
		sql = sql & " AD.COD_TURMA_REMANEJAMENTO, "
		sql = sql & " AD.COD_DISCIPLINA, "
		sql = sql & " AD.Situacao as SitDisciplinar, "
		sql = sql & " A.NOMEALUNO, "
		sql = sql & " A.MATRICULA, "
		sql = sql & " A.DATANASCIMENTO, "
		sql = sql & " A.DATAMATRICULA, "
		sql = sql & " A.COD_FORMAINGRESSO, "
		sql = sql & " P.DESCRICAO AS PERIODO, "
		sql = sql & " C.DESCRICAO AS CURSO, "
		sql = sql & " T.NomeTurma as TurmaRemanejada, "
		sql = sql & " TTO.NomeTurma as TurmaOrigem, "
		sql = sql & " SA.DESC_SITUACAOALUNO, "
		sql = sql & " DO.Desc_Disciplina as DisciplinaOrigem , "
		sql = sql & " DR.Desc_Disciplina as DisciplinaRemanejamento"
		
		sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD" 
		sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO AND AD.COD_EMPRESA = A.COD_EMPRESA"
		
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO AND AD.COD_EMPRESA = T.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_TURMA TTO ON TTO.COD_TURMA = AD.COD_TURMA AND AD.COD_EMPRESA = TTO.COD_EMPRESA"
		
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GOD ON GOD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA "
		sql = sql & " INNER JOIN SCA_DISCIPLINA DO ON DO.Cod_Disciplina = GOD.Cod_Disciplina "
		
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GRD ON GRD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "
		sql = sql & " INNER JOIN SCA_DISCIPLINA DR ON DR.Cod_Disciplina = GRD.Cod_Disciplina "
		
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo and P.cod_empresa = G.cod_empresa"
		sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa =  A.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso and C.cod_empresa = P.cod_empresa"
		sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
		sql = sql & " AND SA.Desc_SituacaoAluno = 'ATIVO' "
		
		if strRemanejamento = "S" then
			sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO <>  AD.COD_TURMA " 
		end if
		
		if intCodDisciplinaTurma <> "0" then
			sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
		end if
		
		if intCodTurma <> "0" then
			sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma	
		end if
		
		if intCodCurso <> "0" then
		sql = sql & " and C.Cod_Curso = " & intCodCurso
		end if
		
		if intCodPeriodo <> "0" then
			sql = sql & " and G.Cod_Periodo = " & intCodPeriodo
		end if
		
		if intCodTurno <> "0" then
			sql = sql & " and T.COD_TURNO = " & intCodTurno
		end if
		
		if intCodSituacaoAluno <> "0" then
			sql = sql & " and SA.COD_SITUACAOALUNO = " & intCodSituacaoAluno
		end if
		
		if strSituacaoDisciplina <> "0" then
			sql = sql & " and AD.Situacao = '" & strSituacaoDisciplina & "'"
		end if
		
		sql = sql & " Order By A.NOMEALUNO"	
	
		rs.open sql, cnn

		if not rs.eof then 
			controle = 0
			contPorTurma = 0
			While not rs.eof
		
			IF intCodAlunoQuebra <> "" and  intCodAlunoQuebra <> "0"  then
				IF intCodAluno <> RS("CODIGO") THEN
					strInfoTurma =  "<strong>" & RS("NOMEALUNO") & "</strong>" 
					quebraTurma
				END IF
				controle = 1
			end if	
			%>
			<tr>
			<td class="celula" align="left"><%=rs("MATRICULA")%></td>
			<td class="celula" align="left"><%=rs("NOMEALUNO")%></td>
			<td class="celula" ><%=rs("TurmaOrigem")%></td>
			<td class="celula"><%=rs("DisciplinaOrigem")%></td>
			<td class="celula"><%=rs("TurmaRemanejada")%></td>
			<td class="celula"><%=rs("DisciplinaRemanejamento")%></td>
			<td class="celula" align="center"><%=rs("SitDisciplinar")%></td>
			</tr>
			<%
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
			contPorTurma = contPorTurma + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			intCodAluno = rs("CODIGO") 
			rs.movenext
		wend
		 %>   
		  <tr>
			<td colspan="7" class="celula"><strong>Quantidade de Alunos:</strong> <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="7" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
end if
%>
</table>
<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>