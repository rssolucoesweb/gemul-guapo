<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2008
	::	Desenvolvedores...: Roberto Barbosa - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio de frequencia do envento
-->
<html>
<head>
<title><%=session("Titulo")%> - Frequência do Evento</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
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
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	
	
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "ATIVIDADE COMPLEMENTARES - FREQUÊNCIA"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0">
  	<tr>
    <td align="center">
	
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td align="center" class="<%=strclasse%>"><div align="left"><strong>Turma:</strong></div></td>
	    <td colspan="3" align="center" class="<%=strclasse%>"><div align="left"><%=rs("NomeTurma")%> - <%=strDesc_Disciplina%>: <%=strCargaHorariaCurricular%></div></td>
	    </tr>
	  <tr bgcolor="#CCCCCC">
		<td width="7%" align="center" class="<%=strclasse%>"><strong>Matr&iacute;cula</strong></td>
		<td width="53%" align="center" class="<%=strclasse%>"><strong>Nome do Aluno</strong></td>
		<td width="10%" align="center" class="<%=strclasse%>"><strong>C.H Cumprida</strong></td>
		<td width="11%" align="center" class="<%=strclasse%>"><strong>Aproveitamento</strong></td>
		</tr>
	<%
	end Sub
	
	sub quebraTurma() 
	%>
	  <tr bgcolor="#E2E2E2">
	    <td colspan="5" class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
      </tr>
	<%
	end Sub	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	cont = 0
	
	sql = " SELECT C.COD_CURSO, T.COD_TURMA , T.NOMETURMA FROM SCA_TURMA T "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo and P.cod_empresa = G.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso and C.cod_empresa = P.cod_empresa "
	sql = sql & " WHERE T.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " AND T.COD_TURMA = " & intCodTurma
	rs.open sql, cnn
	if rs.eof = false then
       	intCodCurso = rs("cod_curso") 
	else
		%>
      	<script>
			alert("Não existe Curso associado a essa turma.");
			window.history.back();
		</script>
        <%
	end if 
	rs.close
	  
	sql = "SELECT ED.CODIGO, ED.COD_CURSO, ED.COD_DISCIPLINA, ED.CARGA_HORARIA, D.DESC_DISCIPLINA"
	sql = sql & " FROM SCA_EVENTO_DISCIPLINA ED"
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = ED.COD_DISCIPLINA AND D.COD_EMPRESA = ED.COD_EMPRESA "
	sql = sql & " WHERE ED.COD_EMPRESA = " & Session("CodEmpresa")	
	sql = sql & " AND COD_CURSO = " & intCodCurso			
	sql = sql & " Order by D.DESC_DISCIPLINA"
	rs.open sql, cnn
	if rs.eof = false then
	   	if isnull(rs("cod_curso")) or rs("cod_curso") = "" or rs("cod_curso") = "0" then
		  	%>
        	<script>
				alert("ATENÇÃO: Valor Inválido para a Carga Horária, verifique!");
				window.history.back();
			</script>
        	<%
	   	end if

		strCargaHorariaCurricular	    = rs("CARGA_HORARIA")
		strDesc_Disciplina		        = rs("DESC_DISCIPLINA")

	else
		%>
        <script>
			alert("ATENÇÃO: Disciplina Complementar ainda não foi Cadastrada, verifique!");
			window.history.back();
		</script>
        <%
	end if 
	rs.close

	
	sql = "SELECT  SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma"
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
	sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
	
	if intCodTurma <> "0" then
		sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
	end if
	sql = sql & " Order By SCA_TURMA.COD_TURMA, SCA_ALUNO.NOMEALUNO"
	rs.open sql, cnn
	if rs.eof = false then
       mostraCabecalho
	   while not rs.eof
	
	   controle = 1
	
		sql = " Select sum(EV.CargaHoraria) as CargaHoraria , sum(FR.FrequenciaCH) as FrequenciaCH "
		sql = sql & " From SCA_SEMINARIO_EVENTO_FREQUENCIA FR "
		sql = sql & " inner join SCA_SEMINARIO_EVENTO EV on  EV.Codigo = FR.Cod_Seminario_Evento "
		sql = sql & " Where Cod_empresa = " & session("CodEmpresa")
		sql = sql & " And Cod_Aluno = " & trim(rs("CODIGO"))
		
		rsAux.open sql, cnn
		if rsAux.eof = false then
			if isnull(rsAux("CargaHoraria")) then
			   strCargaHoraria = 0
			else
			   strCargaHoraria = rsAux("CargaHoraria") 
			end if     
			if isnull(rsAux("FrequenciaCH")) then
			   strFrequenciaCH = 0
			else   
			   strFrequenciaCH = rsAux("FrequenciaCH")
			end if   
			if strCargaHoraria <> 0 then
			   strAproveitamento  = (strFrequenciaCH * 100)/strCargaHorariaCurricular
			   strNota = (strAproveitamento / 10)
			   if strNota > 10 then
			      strNota = 10
			   end if	  
			else   
			   strAproveitamento  = 0
			   strNota            = 0
			end if 
		else
			strCargaHorariaCurricular 	= 0
			strFrequenciaCH				= 0
			strNota 					= 0
			strAproveitamento 			= 0
		end if
		rsAux.close
	%>
	  <tr>
		<td class="<%=strclasse%>" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
		<td class="<%=strclasse%>" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
		<td class="<%=strclasse%>" align="center"><%=strFrequenciaCH%></td>
		<td class="<%=strclasse%>" align="center"><%=formatnumber(strAproveitamento,0)%>%</td>
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
		%>
		  <tr>
			<td colspan="5" class="<%=strclasse%>">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="5" class="<%=strclasse%>" align="center"><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
	
	</td>
  </tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
