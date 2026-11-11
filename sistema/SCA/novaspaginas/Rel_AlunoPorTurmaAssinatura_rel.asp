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
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strQuebraPagina			= Trim(Request.Form("cmbQuebraPagina"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

response.write "<BR>" & trim(request("cmbDisciplinaTurma"))
response.end

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	
	if intCodDisciplinaTurma = ""
	    strTituloRelatorio  	= "ALUNOS POR TURMA <br>Assinatura"
	else
	    strTituloRelatorio  	= "* ALUNOS POR TURMA <br>Assinatura"	
	end if	

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="13%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="42%" class="celula"><div align="center"><strong>Nome do Aluno</strong></div></td>
		<td width="45%" class="celula"><div align="center"><strong>Assinatura</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub quebraTurma() 
	%>
	  <tr bgcolor="#E2E2E2">
	    <td colspan="3" class="celula"><%=strInfoTurma%>&nbsp;</td>
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
	
    if intCodDisciplinaTurma = "" then
	   sql = "SELECT     SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATAMATRICULA , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma"
	   sql = sql & " FROM SCA_ALUNO_TURMA "
	   sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	   sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	   sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	   sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
	   sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	   sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
	   sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
	   sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
	   sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & strSemestre & ")"
	   if intCodCurso <> "0" then
		  sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
	   end if
	   if intCodPeriodo <> "0" then
		  sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
	   end if
	   if intCodTurno <> "0" then
		  sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
	   end if
	   if intCodTurma <> "0" then
		  sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
	   end if
	   if intCodSituacaoAluno <> "0" then
		  sql = sql & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	   end if
	   if strSexo <> "0" then
		  sql = sql & " and SCA_ALUNO.SEXOALUNO = '" & strSexo & "'"
	   end if
	   	'ordem de classificação do relatorio
	   if strOrdem = "alfabetica" then
	      sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.NOMEALUNO"
	   elseif strOrdem = "matricula" then
	 	  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.matricula"
	   elseif strOrdem = "datamatricula" then
	 	  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.datamatricula"
	   elseif strOrdem = "dataafastamento" then
	   'verificar qual o campos data afastamento no cadastro
	 	  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.NOMEALUNO"
	   elseif strOrdem = "idade" then
	 	  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.DATANASCIMENTO"
	   elseif strOrdem = "bairro" then
	 	  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.CIDADERESIDENCIA"
	   end if
	else
	   sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
	   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
	   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
	   sql = sql & " AD.COD_DISCIPLINA, "
	   sql = sql & " A.NOMEALUNO, "
	   sql = sql & " A.MATRICULA, "
	   sql = sql & " A.DATANASCIMENTO, "
	   sql = sql & " A.DATAMATRICULA, "
	   sql = sql & " '' AS SEQUENCIA, "
	   sql = sql & " P.DESCRICAO AS PERIODO, "
	   sql = sql & " C.DESCRICAO AS CURSO, "
	   sql = sql & " T.NomeTurma, "
	   sql = sql & " SA.DESC_SITUACAOALUNO "
	   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD" 
       sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO"
	   sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO AND AD.COD_EMPRESA = T.COD_EMPRESA"
	   sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
	   sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo and P.cod_empresa = G.cod_empresa"
	   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa =  A.COD_EMPRESA"
	   sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso and C.cod_empresa = P.cod_empresa"
	   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
	   sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
	   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma	
	   sql = sql & " AND SA.Desc_SituacaoAluno = 'ATIVO' "
	   sql = sql & " ORDER BY A.NOMEALUNO "
	   
	   response.write sql
	   response.end
	   
	end if	   
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			IF intCodTurma <> RS("COD_TURMA") THEN
				if controle = 1 then
					%>
					  <tr>
						<td colspan="3" class="celula">Quantidade de Alunos Por Turma: <%=contPorTurma%></td>
					  </tr>
					 <%
					 contPorTurma = 0
				end if
				if trim(strQuebraPagina) = "TURMA" and controle = 1 then
					intPagina = intPagina + 1
					intQtdeRegistroPorPagina = 1
					fimTabela
					%>
					<pre></pre>				
					<%			
					mostraCabecalho
				end if
				strInfoTurma =  "<strong>" & RS("NomeTurma") & "</strong> - " & RS("CURSO") & " - " & RS("PERIODO")
				quebraTurma
			END IF
			controle = 1
			%>
			  <tr>
				<td height="22" class="celula" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
				<td class="celula" align="center">________________________________________________________________________</td>
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
			contPorTurma = contPorTurma + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			intCodTurma = RS("COD_TURMA") 
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="3" class="celula">Quantidade de Alunos Por Turma: <%=contPorTurma%></td>
		  </tr>
		  <tr>
			<td colspan="3" class="celula">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="3" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
