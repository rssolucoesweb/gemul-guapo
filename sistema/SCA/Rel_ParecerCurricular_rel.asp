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
<title><%=session("Titulo")%> - Alunos</title>
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
	
	intCodEmpresa 		= Session("CodEmpresa")
	strCodigo							= Trim(Request("txtCodigo"))
	strCodigoGradeCurricularDisciplina	= Trim(Request("txtCodigoGradeCurricularDisciplina"))
	strCodDisciplinaOutrasAnterior	= Trim(Request("txtCodDisciplinaOutrasAnterior"))
	strCodigoFicha	= Trim(Request("txtCodigoFicha"))
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	
	strEscola 			= Trim(Request.Form("txtEscola"))
	strCidade 			= Trim(Request.Form("txtCidade"))
	strUfResidencia		= Trim(Request.Form("cmbUFResidencia"))
	
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	
    intCodDisciplina        = request("cmbDisciplina")
	intCodDisciplinaOutras	= Trim(Request.Form("cmbDisciplinaOutras"))
	strDisciplinaNova		= Trim(Request.Form("txtDisciplinaNova"))
    strCH			        = request("txtCH")
	strNota					= replace(replace(Trim(Request.Form("txtNota")),".",""),",",".")
	strConceito				= Trim(Request.Form("txtConceito"))
	strSituacaoPromocao		= Trim(Request.Form("cmbSituacaoPromocao"))

	
	intCodAluno			= Trim(Request.Form("txtCodAluno"))
	strMatricula		= Trim(Request.Form("txtMatricula"))

	'DADOS DO HISTORICO 
	strEscola			= Trim(Request.Form("txtEscola"))
	strCidade			= Trim(Request.Form("txtCidade"))
	strUfResidencia		= Trim(Request.Form("cmbUFResidencia"))
	
	if strMatricula <> "" or strCodAluno <> "" then 
		sql = "select top 1 p.Cod_Curso, A.MATRICULA, A.CODIGO, A.NOMEALUNO, G.AnoReferencia, G.SemestreReferencia"
		sql = sql & " from SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AT.COD_ALUNO"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular AND G.COD_EMPRESA = T.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_periodo = G.Cod_periodo AND G.COD_EMPRESA = T.COD_EMPRESA"
		sql = sql & " Where AT.COD_EMPRESA = " & Session("CodEmpresa")	
		if strMatricula<>"" then
			sql = sql & " and A.MATRICULA = " & strMatricula
		end if
		if strCodAluno <> "" then
			sql = sql & " and A.codigo = " & strCodAluno
		end if
		sql = sql & " and G.Situacao = 'A'"
		sql = sql & " order by AT.CODIGO desc"
		rs.open sql, cnn
		if rs.eof = false then
			strMatricula = TRIM(rs("Matricula"))
			strNomealuno = TRIM(rs("Nomealuno"))
			strCodAluno	 = TRIM(rs("Codigo"))
			intCodCurso	 = TRIM(rs("cod_curso"))
			strAnoLetivoGrade 		= Trim(rs("AnoReferencia"))
			intSemestreGrade 		= Trim(rs("SemestreReferencia"))
		end if
		rs.close
	end if
	
	strTituloRelatorio  	= "PARECER CURRICULAR"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
  	<table width = "99%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td width="15%" align="right" >Matr&iacute;cula: </td>
		<td width="15%" align="left"><strong>&nbsp;<%=strMatricula%></strong></td>
		<td width="15%" align="right">Nome do Aluno: </td>
		<td width="85%" align="left" ><strong>&nbsp;<%=strNomealuno%></strong></td>
      </tr>
	  </table>
		<br>	
<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
        <tr bgcolor="#E5E5E5">
          <td colspan="3" align="center" class="celula"><strong>Dados da Institui&ccedil;&atilde;o Atual</strong></td>
          <td height="21" colspan="7" align="center" class="celula"><strong>Dados da Insctitui&ccedil;&atilde;o de Origem</strong></td>
        </tr>	  
		<tr bgcolor="#E5E5E5">
			<td width="8%" align="center" class="celula"><strong>Per&iacute;odo/S&eacute;rie</strong></td>
		  <td width="22%" align="center" class="celula"><strong>Disciplina</strong></td>
		  <td width="5%" align="center" class="celula"><strong><strong>C.H.</strong></strong></td>
		  <td width="28%" align="center" class="celula"><strong><strong>Disciplina </strong></strong></td>
		  <td width="7%" align="center" class="celula"><strong>Ano</strong></td>
		  <td width="7%" align="center" class="celula"><strong>Semestre</strong></td>
		  <td width="4%" height="21" align="center" class="celula"><strong>C.H<span class="TextoForm">.</span></strong></td>
		  <td width="4%" align="center" class="celula"><strong>Nota</strong></td>
		  <td width="9%" align="center" class="celula"><strong>Conceito</strong></td>
		  <td width="6%" align="center" class="celula"><strong>Parecer</strong></td>
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
	strlpp = 36
	cont =0
	if strAnoLetivoGrade = "" then strAnoLetivoGrade = 0
	if intSemestreGrade = "" then intSemestreGrade = 0
	
	sql = "SELECT SCA_GRADECURRICULAR.Cod_GRADECURRICULAR, "
	sql = sql & " SCA_GRADECURRICULAR.Cod_AGRUPAMENTO, SCA_CURSO.COD_CURSO, "
	sql = sql & " SCA_CURSO.DESCRICAO, SCA_PERIODO.cod_periodo, SCA_PERIODO.Descricao as PERIODO, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.DESC_Disciplina, "
	sql = sql & " SCA_GRAU.DESC_GRAU, SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina,"
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Anual, SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR_EQUIVALENTE, SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULARDISCIPLINA_EQUIVALENTE, SCA_GRADECURRICULARDISCIPLINA.COD_DISCIPLINA_EQUIVALENTE,"
	sql = sql & " SCA_FICHA_EQUIVALENCIA_DISCIPLINA.ano_letivo, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.semestre,SCA_FICHA_EQUIVALENCIA_DISCIPLINA.ch as Ch_Anual_origem, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Nota, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Conceito, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.codigo as codEquivDisc, "
	sql = sql & " SCA_FICHA_EQUIVALENCIA_DISCIPLINA.cod_situacaopromocao as situacao, SCA_DisciplinaOutrasInstituicoes.Desc_Disciplina AS Desc_Disciplina_origem, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.cod_ficha_equivalencia  as codFicha"
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa INNER JOIN SCA_GRAU ON SCA_GRAU.Cod_Grau = SCA_CURSO.Cod_Grau and SCA_GRAU.cod_empresa = SCA_CURSO.cod_empresa INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	sql = sql & " INNER JOIN SCA_FICHA_EQUIVALENCIA_DISCIPLINA ON SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Cod_GradeCurricularDisciplina = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
	sql = sql & " INNER JOIN SCA_DisciplinaOutrasInstituicoes ON SCA_DisciplinaOutrasInstituicoes.cod_Disciplina = SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Cod_DisciplinaOutrasInstituicoes"
	sql = sql & " WHERE 	SCA_GRADECURRICULAR.AnoReferencia = " & strAnoLetivoGrade 
	sql = sql & " AND 		SCA_GRADECURRICULAR.SemestreReferencia = " & intSemestreGrade
	sql = sql & " AND 		SCA_CURSO.Cod_Curso = " & intCodCurso
	sql = sql & " AND		SCA_GRADECURRICULAR.situacao = 'A'"
	sql = sql & " ORDER BY SCA_PERIODO.SEQUENCIA, SCA_DISCIPLINA.DESC_Disciplina "
	rs.open sql, cnn
					
	if rs.eof = false then
		strPeriodoQuebra = ""
		while not rs.eof
			cont = cont + 1	
			sem = rs("semestre")
			if rs("semestre") = "3" then sem = "Anual"
			
			if strPeriodoQuebra <> rs("periodo") and strPeriodoQuebra<>"" then
			%>
			<tr >
			  <td class="celula" colspan="10" height="6" bgcolor="#E5E5E5"></td>
			</tr>
			<%
			end if
			%>
		<tr >
		  <td class="celula">&nbsp;<%=rs("periodo")%></td>
		  <td class="celula">&nbsp;<%=rs("desc_disciplina")%></td>
		  <td class="celula" align="center">&nbsp;<%=trim(rs("Ch_Anual"))%></td>
		  <td class="celula">&nbsp;<%=rs("desc_Disciplina_origem")%></td>
		  <td align="center" class="celula"><%=rs("ano_letivo")%>&nbsp;</td>
		  <td align="center" class="celula"><%=sem%>&nbsp;</td>
		  <td height="20" class="celula">&nbsp;<%=trim(rs("Ch_Anual_origem"))%></td>
		  <td class="celula">&nbsp;<%=trim(rs("nota"))%></td>
		  <td class="celula">&nbsp;<%=trim(rs("conceito"))%></td>
		  <td class="celula">&nbsp;<%=trim(rs("situacao"))%></td>
		</tr>
	
		<%		strPeriodoQuebra = rs("periodo")
				
				'quantidade de registros da página
				if int(intQtdeRegistroPorPagina) = int(strlpp) then
					 intPagina = intPagina + 1
					 intQtdeRegistroPorPagina = 1
					 fimTabela
					%>
					<pre>&nbsp;</pre>				
					<%			
					mostraCabecalho
				end if	
				cont = cont + 1
				intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
				rs.movenext
			wend
	  end if
	  rs.close%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
