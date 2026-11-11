<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Diario de Frequencia
-->
<html>
<head>
<title><%=session("Titulo")%> - Ficha Acumulativa de Notas e Faltas</title>
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
<!--#include file=../../includes/inc_aguarde.asp-->
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	vetAvaliacoes = split(Request.Form("chkTipoNota"))

	
	if ubound(split(Request.Form("chkTipoNota"))) = 0 then
		strTpRelAcum = "1Avaliacao"
	    intBimestre1 			= left(vetAvaliacoes(0),1)
	elseif ubound(split(Request.Form("chkTipoNota"))) = 1 then
		strTpRelAcum = "2Avaliacao"
		intBimestre1 			= left(vetAvaliacoes(0),1)
		intBimestre2 			= left(vetAvaliacoes(1),1)
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nSelecione no máximo duas avaliação para a geração correta desse relatório.");
			window.history.back();
		</script>
		<%	
		response.End()
	end if
	
'	response.Write "<br><br><br><br><br><br><br><br><br>" & strTpRelAcum & "<br>"
'	response.Write intBimestre1 & "<br>"
'	response.Write intBimestre2 & "<br>"
'	response.End()

	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	intCodEstagio		 	= Trim(Request.Form("cmbEstagio"))
	stromiteDadosdoDiario 	= Trim(Request.Form("omiteDadosdoDiario"))

	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if



	if intCodCurso 		= "" then intCodCurso = "0"
	if intCodPeriodo 	= "" then intCodPeriodo = "0"
	if intSemestre 		= "" then intSemestre = "0"
	if intCodTurno 		= "" then intCodTurno = "0"
	if intCodTurma 		= "" then intCodTurma = "0"
	if intCodDisciplinaTurma 		= "" then intCodDisciplinaTurma = "0"
	if intCodEstagio = "" then intCodEstagio="0"

    if intCodEstagio <> "0" then
		sql = "SELECT E.Ano, E.Semestre, E.Descricao as Grupo, C.nome as Orientador"
		sql = sql & " FROM SCA_ESTAGIO E"
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = E.COD_COLABORADOR " 
		sql = sql & " And E.codigo = " & intCodEstagio
		rs.open sql, cnn
		if rs.eof = false then
			strGrupo = rs("grupo")   
			strSupervisor = rs("Orientador")
		end if
		rs.close	
    end if
	
	
	strProfessor = ""
	strDisciplinaTurma = ""
	if intCodDisciplinaTurma <> "0" then
		
		sql = "select Desc_Disciplina from sca_disciplina"
		sql = sql & " where cod_disciplina = " & intCodDisciplinaTurma		
		rs.open sql, cnn
		if not rs.eof then 
			strDisciplinaTurma = RS("Desc_Disciplina")
		end if
		rs.close

		sql = "SELECT DISTINCT SRH_COLABORADOR.NOME AS COLABORADOR"
		sql = sql & " FROM SCA_HORARIO_AULA"
		sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
		sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO=" & strAnoLetivo
		sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE=" & intSemestre
		sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA=" & intCodTurma
		sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA=" & intCodDisciplinaTurma
		rs.open sql, cnn
		if not rs.eof then 
			strProfessor = RS("COLABORADOR")
		else
			strProfessor = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
		end if
		rs.close
				
	end if

	sql = "SELECT SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_CURSO.descricao as curso, SCA_PERIODO.descricao as periodo"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR on SCA_GRADECURRICULAR.cod_GRADECURRICULAR = SCA_TURMA.cod_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso"
	sql = sql & " Where SCA_TURMA.Cod_Empresa = " & session("CodEmpresa")
	sql = sql & " and SCA_TURMA.Cod_Turma = " & intCodTurma
	rs.open sql, cnn
	if not rs.eof then 
		strInfoTurma =  "<strong>" & RS("NomeTurma") & " - " & rs("curso") & " - " &  rs("periodo")  & "</strong>"
	end if
	rs.close
		
	strTituloRelatorio  	= "FICHA ACUMULATIVA DE NOTAS E FALTAS"
    %>
    <form name="form1" id=frm method="post" target="_top" >
    <%		  
	intQtdeAvaliacao1 = 1
	
	'BUSCA A AVALIACOES
	sql="SELECT TA.DESCRICAO"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA"
	sql=sql & " WHERE	CA.COD_EMPRESA = " & Session("CodEmpresa")
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		TA.BIMESTRE = " & intBimestre1
	sql=sql & " ORDER BY TA.POSICAO"
	rs.open sql, cnn, 3, 1
	if rs.eof = false then
		strAvaliacao1 = RS("DESCRICAO")
	end if
	rs.close	
	
	if TRIM(strTpRelAcum) = "2Avaliacao" then
		'BUSCA A AVALIACOES
		sql="SELECT TA.DESCRICAO"
		sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
		sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
		sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA"
		sql=sql & " WHERE	CA.COD_EMPRESA = " & Session("CodEmpresa")
		sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
		sql=sql & " AND		TA.BIMESTRE = " & intBimestre2
		sql=sql & " ORDER BY TA.POSICAO"
		rs.open sql, cnn, 3, 1
		if rs.eof = false then
			strAvaliacao2 = RS("DESCRICAO")
		end if
		rs.close	
	end if


	
	'BUSCA A AVALIACOES
	sql="SELECT TA.POSICAO, TA.DESCRICAO, TA.BIMESTRE, CA.media_aprovacao"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA"
	sql=sql & " WHERE	CA.COD_EMPRESA = " & Session("CodEmpresa")
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		TA.BIMESTRE = " & intBimestre1
	sql=sql & " ORDER BY TA.POSICAO"
	rs.open sql, cnn, 3, 1
	if rs.eof = false then
		intQtdeAvaliacao1 = rs.recordCount
		intCont = 1
		redim vetTipoNota1(rs.recordCount)
		while not rs.eof
			vetTipoNota1(intCont) = RS("DESCRICAO")
			intCont = intCont + 1
			rs.movenext
		wend
	end if
	QtdeContAvaliacao1 = intCont-1
	rs.close
	
	if strTpRelAcum = "2Avaliacao" then
		QtdeContAvaliacao2 = 0
		intQtdeAvaliacao2 = 1
		'BUSCA A AVALIACOES
		sql="SELECT TA.POSICAO, TA.DESCRICAO, TA.BIMESTRE, CA.media_aprovacao"
		sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
		sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
		sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA"
		sql=sql & " WHERE	CA.COD_EMPRESA = " & Session("CodEmpresa")
		sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
		sql=sql & " AND		TA.BIMESTRE = " & intBimestre2
		sql=sql & " ORDER BY TA.POSICAO"
		rs.open sql, cnn, 3, 1
		if rs.eof = false then
			intQtdeAvaliacao2 = rs.recordCount
			intCont = 1
			redim vetTipoNota2(rs.recordCount)
			while not rs.eof
				vetTipoNota2(intCont) = RS("DESCRICAO")
				intCont = intCont + 1
				rs.movenext
			wend
		end if
		rs.close	
		QtdeContAvaliacao2 = intCont-1
	end if


	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	  		= Trim(Request.Form("cmbSemestre"))
	strlpp 				    	= Trim(Request.Form("cmblpp"))
	intQtdeRegistroPorPagina = strlpp
	intQtdeRegistro = 1
	
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual

    %>
    <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<BR>
	<table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000">
    <tr>
    <td width="8%" height="17" class="<%=strclasse%>">TURMA: </td>
    <td colspan="5" class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
    </tr>
    <% if intCodEstagio = "0" then %>
        <tr>
        <td height="17" class="<%=strclasse%>">DISCIPLINA: </td>
        <td width="23%" class="<%=strclasse%>"><strong><%=strDisciplinaTurma%>&nbsp;</strong></td>
        <td width="9%" class="<%=strclasse%>">PROFESSOR(A):</td>
        <td colspan="3" class="<%=strclasse%>"><strong><%=strProfessor%></strong>&nbsp;</td>
        </tr>
     <% else %>   
        <tr>
        <td height="17" class="<%=strclasse%>">DISCIPLINA:</td>
        <td width="23%" class="<%=strclasse%>"><strong><%=strDisciplinaTurma%>&nbsp;</strong></td>
        <td width="9%" class="<%=strclasse%>">SUPERVISOR:</td>
        <td width="25%" class="<%=strclasse%>"><strong><%=strSupervisor%></strong>&nbsp;</td>
        <td width="5%" class="<%=strclasse%>">GRUPO:</td>
        <td width="30%" class="<%=strclasse%>"><strong><%=strGrupo%></strong>&nbsp;</td>
        </tr>
     <% end if%>   
    </table>
	<table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000">
    <tr>
    <td width="3%" height="45" rowspan="3" align="center" class="<%=strclasse%>">N&ordm;</td>
	<td width="31%" rowspan="3" align="center" class="<%=strclasse%>">NOME DO ALUNO </td>
    <td width="9%" rowspan="3" align="center" class="<%=strclasse%>">MATR.</td>
    <%
	if strTpRelAcum = "1Avaliacao" then%>
       <td width="10%" colspan="<%=intQtdeAvaliacao1+2+5%>" align="center" class="<%=strclasse%>"><%=strAvaliacao%></td>
       <td colspan="4" align="center" class="<%=strclasse%>"><%=strAvaliacao%></td>
       <%
	end if%>
    </tr>
    <tr>
    <td colspan="5" align="center" class="<%=strclasse%>">TRABALHOS</td>
    <td colspan="<%=intQtdeAvaliacao1+2%>" align="center" class="<%=strclasse%>">AVALIA&Ccedil;&Otilde;ES</td>
    <%
	if strTpRelAcum = "2Avaliacao" then%>
       <td colspan="5" align="center" class="<%=strclasse%>">TRABALHOS</td>
       <td colspan="<%=intQtdeAvaliacao2+2%>" align="center" class="<%=strclasse%>">AVALIA&Ccedil;&Otilde;ES</td>
       <%
	end if%>
    <%
	if strTpRelAcum = "1Avaliacao" then%>
       <td width="5%" rowspan="2" align="center" class="<%=strclasse%>">MATRIC.</td>
       <td width="20%" rowspan="2" align="center" class="<%=strclasse%>">ALUNO</td>
       <td width="5%" rowspan="2" align="center" class="<%=strclasse%>">FALTA</td>
       <td width="15%" rowspan="2" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
       <%
    end if%>
    </tr>
    <tr>
    <td align="center" class="<%=strclasse%>">T1</td>
    <td align="center" class="<%=strclasse%>">T2</td>
    <td align="center" class="<%=strclasse%>">T3</td>
    <td align="center" class="<%=strclasse%>">T4</td>
    <td align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
    <%for i=1 to ubound(vetTipoNota1)%>
		<td  width="4%" align="center" class="<%=strclasse%>"><%=vetTipoNota1(i)%></td>
	<%next%>
	<td width="4%" align="center" class="<%=strclasse%>">FALTA</td>
    <td width="4%" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
    <%if strTpRelAcum = "2Avaliacao" then%>
	   <td align="center" class="<%=strclasse%>">T1</td>
       <td align="center" class="<%=strclasse%>">T2</td>
       <td align="center" class="<%=strclasse%>">T3</td>
       <td align="center" class="<%=strclasse%>">T4</td>
       <td align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
	   <%for i=1 to ubound(vetTipoNota2)%>
       <td  width="4%" align="center" class="<%=strclasse%>"><%=vetTipoNota2(i)%></td>
       <%next%>
	   <td width="4%" align="center" class="<%=strclasse%>">FALTA</td>
       <td width="4%" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
    <%end if%>
    </tr>
    <%
  	intPagina = 1
    ContAluno = 1
	if cInt(intCodDisciplinaTurma) <> "0" then
   	   sql = "SELECT distinct "
  	   sql = sql & " 	SCA_SITUACAOALUNO.Desc_SituacaoAluno, "
  	   sql = sql & " 	SCA_ALUNO.CODIGO, "
 	   sql = sql & " 	SCA_ALUNO.MATRICULA, "
       sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
	   sql = sql & " 	SCA_ALUNO.DATANASCIMENTO, "
	   sql = sql & " 	SCA_ALUNO.MAE, "
	   sql = sql & " 	SCA_PERIODO.DESCRICAO AS PERIODO, "
	   sql = sql & " 	SCA_CURSO.DESCRICAO AS CURSO, "
	   sql = sql & " 	SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO as COD_TURMA, "
	   sql = sql & " 	SCA_TURMA.NomeTurma,"
	   sql = sql & " 	SCA_ALUNO_DISCIPLINA.SITUACAO"
	   sql = sql & " FROM SCA_ALUNO_DISCIPLINA "
	   sql = sql & " INNER JOIN SCA_ALUNO		ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO and SCA_ALUNO_DISCIPLINA.cod_empresa = SCA_ALUNO.cod_empresa "
	   sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO and SCA_SITUACAOALUNO.cod_empresa = SCA_ALUNO.cod_empresa "
	   sql = sql & " INNER JOIN SCA_TURMA		ON SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO = SCA_TURMA.Cod_Turma  and SCA_ALUNO_DISCIPLINA.cod_empresa = SCA_TURMA.cod_empresa "
	   sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular  and SCA_TURMA.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	   sql = sql & " INNER JOIN SCA_PERIODO		ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	   sql = sql & " INNER JOIN SCA_CURSO		ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	   
	    ' Filtra o estagio
	   if intCodEstagio <> "0" then
		   sql = sql & " INNER JOIN SCA_ESTAGIO_VINCULO ON SCA_ESTAGIO_VINCULO.Cod_Aluno = SCA_ALUNO.CODIGO and CodEstagio = " & intCodEstagio
	   end if
	   
	   sql = sql & " where	SCA_TURMA.cod_empresa = " & session("CodEmpresa")
       sql = sql & " and 	SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'ATIVO'"'SOMENTE ALUNOS ATIVOS
  	   if intCodCurso <> "0" then
	  	  sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
	   end if
   	   if intCodPeriodo <> "0" then
	  	  sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
	   end if
 	   if intCodTurno <> "0" then
  		  sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
	   end if
	   sql = sql & " and		SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO = " & intCodTurma
	   sql = sql & " and		SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplinaTurma
	   sql = sql & " and		SCA_ALUNO_DISCIPLINA.SITUACAO <> 'DI'"
	   sql = sql & " Order By 4"
	else				
  	   sql = "SELECT SCA_SITUACAOALUNO.Desc_SituacaoAluno, '' as SITUACAO, SCA_ALUNO_TURMA.SEQUENCIA, "
	   sql = sql & " SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, "
	   sql = sql & " SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, "
	   sql = sql & " SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma"
	   sql = sql & " FROM SCA_ALUNO_TURMA "
	   sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	   sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO and SCA_SITUACAOALUNO.cod_empresa = SCA_ALUNO.cod_empresa"
	   sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	   sql = sql & " INNER JOIN SCA_GRADECURRICULAR "
	   sql = sql & " ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	   sql = sql & " INNER JOIN SCA_PERIODO "
	   sql = sql & " ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
	   sql = sql & " and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
	   sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
	   sql = sql & " and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	  
	   ' Filtra o estagio
	   if intCodEstagio <> "0" then
		   sql = sql & " INNER JOIN SCA_ESTAGIO_VINCULO ON SCA_ESTAGIO_VINCULO.Cod_Aluno = SCA_ALUNO.CODIGO and CodEstagio = " & intCodEstagio
	   end if
	   	  
	   sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
       sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
	   sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual
  	   sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestreAtual
       sql = sql & " and 	SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'ATIVO'"'SOMENTE ALUNOS ATIVOS
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
	   
	    ' Filtra o estagio
		if intCodEstagio <> "0" then
		  sql = sql & " and SCA_ESTAGIO_VINCULO.CodEstagio = " & intCodEstagio
		end if
	   
	   
	   sql = sql & " Order By 6"
    end if
	rs.open sql, cnn
	if not rs.eof then 
	   While not rs.eof
          strSitAluno = "(" & rs("Desc_SituacaoAluno") & ")"
      	  if ucase(trim(strSitAluno)) = "ATIVO" or trim(strSitAluno) = "()" then strSitAluno = ""
		  strSitDisciplina = rs("situacao")
		  IF strSitDisciplina = "CR" THEN strSitDisciplina = "Curricular"
		  IF strSitDisciplina = "DE" THEN strSitDisciplina = "Dependência"
		  IF strSitDisciplina = "DI" THEN strSitDisciplina = "Dispensa"
		  strSitDisciplina = "(" & strSitDisciplina & ")"
		  if ucase(trim(rs("situacao"))) = "CR" or trim(strSitDisciplina) = "()" then strSitDisciplina = ""
		  if strSitAluno = "(ATIVO)" then strSitAluno = ""
		  
		  if stromiteDadosdoDiario <> "S" then
		  %>
		  <tr>
		  <td width="3%" align="center" class="<%=strclasse%>"><%=ContAluno%></td>
		  <td class="<%=strclasse%>">&nbsp;<%=rs("NOMEALUNO")%>&nbsp;<%=strSitDisciplina%> <%=strSitAluno%></td>
		  <td width="8%" align="center" class="<%=strclasse%>"><%=rs("MATRICULA")%></td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <%for i=1 to ubound(vetTipoNota1)%>
		    <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <%next%>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <%if strTpRelAcum = "2Avaliacao" then%>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <%for i=1 to ubound(vetTipoNota2)%>
		 		 <td  width="4%" align="center" class="<%=strclasse%>">&nbsp;</td>
	  		   <%next%>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <%end if%>                            
			   <%if strTpRelAcum = "1Avaliacao" then%>
				   <td width="8%" align="center" class="<%=strclasse%>"><%=rs("MATRICULA")%></td>
				   <td width="30%" align="left" class="<%=strclasse%>"><%=MID(rs("NOMEALUNO"),1,25)%></td>
				   <td width="5%" align="center" class="<%=strclasse%>">&nbsp;</td>
				   <td width="5%" align="center" class="<%=strclasse%>">&nbsp;&nbsp;</td>
			   <%end if%>                            
      </tr>
<%
			   if cInt(intQtdeRegistro) >= cInt(intQtdeRegistroPorPagina) then
				  intPagina = intPagina + 1
				  intQtdeRegistro = 1
				  %>
				  </table>
				  <pre></pre>
				  <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
				  <BR>
				  <table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000">
				  <tr>
				  <td width="8%" height="17" class="<%=strclasse%>">TURMA: </td>
				  <td colspan="3" class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
				  </tr>
				  <tr>
				  <td height="17" class="<%=strclasse%>">DISCIPLINA: </td>
				  <td width="31%" class="<%=strclasse%>"><strong><%=strDisciplinaTurma%>&nbsp;</strong></td>
				  <td width="10%" class="<%=strclasse%>">PROFESSOR(A):</td>
				  <td width="51%" class="<%=strclasse%>"><strong><%=strProfessor%></strong>&nbsp;</td>
				  </tr>
				  </table>
				  <table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000">
				  <tr>
				  <td width="3%" height="45" rowspan="3" align="center" class="<%=strclasse%>">N&ordm;</td>
				  <td width="31%" rowspan="3" align="center" class="<%=strclasse%>">NOME DO ALUNO </td>
				  <td width="9%" rowspan="3" align="center" class="<%=strclasse%>">MATR.</td>
				  <%
				  if strTpRelAcum = "1Avaliacao" then%>
				     <td width="10%" colspan="<%=intQtdeAvaliacao1+2+5%>" align="center" class="<%=strclasse%>"><%=strAvaliacao%></td>
				     <td colspan="4" align="center" class="<%=strclasse%>"><%=strAvaliacao%></td>
				     <%
				  end if%>
				  </tr>
				  <tr>
				  <td colspan="5" align="center" class="<%=strclasse%>">TRABALHOS</td>
				  <td colspan="<%=intQtdeAvaliacao1+2%>" align="center" class="<%=strclasse%>">AVALIA&Ccedil;&Otilde;ES</td>
				  <%
				  if strTpRelAcum = "2Avaliacao" then%>
				     <td colspan="5" align="center" class="<%=strclasse%>">TRABALHOS</td>
				     <td colspan="<%=intQtdeAvaliacao2+2%>" align="center" class="<%=strclasse%>">AVALIA&Ccedil;&Otilde;ES</td>
				     <%
				  end if%>
				  <%
				  if strTpRelAcum = "1Avaliacao" then%>
				     <td width="5%" rowspan="2" align="center" class="<%=strclasse%>">MATRIC.</td>
				     <td width="20%" rowspan="2" align="center" class="<%=strclasse%>">ALUNO</td>
				     <td width="5%" rowspan="2" align="center" class="<%=strclasse%>">FALTA</td>
				     <td width="15%" rowspan="2" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				     <%
				  end if%>
				  </tr>
				  <tr>
				  <td align="center" class="<%=strclasse%>">T1</td>
				  <td align="center" class="<%=strclasse%>">T2</td>
				  <td align="center" class="<%=strclasse%>">T3</td>
			  	  <td align="center" class="<%=strclasse%>">T4</td>
				  <td align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				  <%for i=1 to ubound(vetTipoNota1)%>
				  	 <td  width="4%" align="center" class="<%=strclasse%>"><%=vetTipoNota1(i)%></td>
				  <%next%>
				  <td width="4%" align="center" class="<%=strclasse%>">FALTA</td>
				  <td width="4%" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				  <%if strTpRelAcum = "2Avaliacao" then%>
				     <td align="center" class="<%=strclasse%>">T1</td>
				     <td align="center" class="<%=strclasse%>">T2</td>
				     <td align="center" class="<%=strclasse%>">T3</td>
				     <td align="center" class="<%=strclasse%>">T4</td>
				     <td align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				     <%for i=1 to ubound(vetTipoNota2)%>
			  	   	   <td  width="4%" align="center" class="<%=strclasse%>"><%=vetTipoNota2(i)%></td>
				     <%next%>
				     <td width="4%" align="center" class="<%=strclasse%>">FALTA</td>
				     <td width="4%" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				  <%end if%>
				  </tr>
				  <%
			   end if	
			   
		    else
			
			
					  %>
		  <tr>
		  <td width="3%" align="center" class="<%=strclasse%>">&nbsp;</td>
		  <td class="<%=strclasse%>">&nbsp;&nbsp;</td>
		  <td width="8%" align="center" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <%for i=1 to ubound(vetTipoNota1)%>
		    <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <%next%>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <td width="4%" class="<%=strclasse%>">&nbsp;</td>
		  <%if strTpRelAcum = "2Avaliacao" then%>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
               
			   <%for i=1 to ubound(vetTipoNota2)%>
		 		 <td  width="4%" align="center" class="<%=strclasse%>">&nbsp;</td>
	  		   <%next%>
               
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			   <%end if%>     
                                      
			   <%if strTpRelAcum = "1Avaliacao" then%>
				   <td width="8%" align="center" class="<%=strclasse%>">&nbsp;</td>
				   <td width="30%" align="left" class="<%=strclasse%>">&nbsp;</td>
				   <td width="5%" align="center" class="<%=strclasse%>">&nbsp;</td>
				   <td width="5%" align="center" class="<%=strclasse%>">&nbsp;&nbsp;</td>
			   <%end if%>                            
			   </tr>
			   <%
			   if cInt(intQtdeRegistro) >= cInt(intQtdeRegistroPorPagina) then
				  intPagina = intPagina + 1
				  intQtdeRegistro = 1
				  %>
				  </table>
				  <pre></pre>
				  <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
				  <BR>
				  <table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000">
				  <tr>
				  <td width="8%" height="17" class="<%=strclasse%>">TURMA: </td>
				  <td colspan="3" class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
				  </tr>
				  <tr>
				  <td height="17" class="<%=strclasse%>">DISCIPLINA: </td>
				  <td width="31%" class="<%=strclasse%>"><strong>&nbsp;</strong></td>
				  <td width="10%" class="<%=strclasse%>">PROFESSOR(A):</td>
				  <td width="51%" class="<%=strclasse%>"><strong>&nbsp;</strong>&nbsp;</td>
				  </tr>
				  </table>
				  <table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000">
				  <tr>
				  <td width="3%" height="45" rowspan="3" align="center" class="<%=strclasse%>">N&ordm;</td>
				  <td width="31%" rowspan="3" align="center" class="<%=strclasse%>">NOME DO ALUNO </td>
				  <td width="9%" rowspan="3" align="center" class="<%=strclasse%>">MATR.</td>
				  <%
				  if strTpRelAcum = "1Avaliacao" then%>
				     <td width="10%" colspan="<%=intQtdeAvaliacao1+2+5%>" align="center" class="<%=strclasse%>">&nbsp;</td>
				     <td colspan="4" align="center" class="<%=strclasse%>">&nbsp;</td>
				     <%
				  end if%>
				  </tr>
				  <tr>
				  <td colspan="5" align="center" class="<%=strclasse%>">TRABALHOS</td>
				  <td colspan="<%=intQtdeAvaliacao1+2%>" align="center" class="<%=strclasse%>">AVALIA&Ccedil;&Otilde;ES</td>
				  <%
				  if strTpRelAcum = "2Avaliacao" then%>
				     <td colspan="5" align="center" class="<%=strclasse%>">TRABALHOS</td>
				     <td colspan="<%=intQtdeAvaliacao2+2%>" align="center" class="<%=strclasse%>">AVALIA&Ccedil;&Otilde;ES</td>
				     <%
				  end if%>
				  <%
				  if strTpRelAcum = "1Avaliacao" then%>
				     <td width="5%" rowspan="2" align="center" class="<%=strclasse%>">MATRIC.</td>
				     <td width="20%" rowspan="2" align="center" class="<%=strclasse%>">ALUNO</td>
				     <td width="5%" rowspan="2" align="center" class="<%=strclasse%>">FALTA</td>
				     <td width="15%" rowspan="2" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				     <%
				  end if%>
				  </tr>
				  <tr>
				  <td align="center" class="<%=strclasse%>">T1</td>
				  <td align="center" class="<%=strclasse%>">T2</td>
				  <td align="center" class="<%=strclasse%>">T3</td>
			  	  <td align="center" class="<%=strclasse%>">T4</td>
				  <td align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				  <%for i=1 to ubound(vetTipoNota1)%>
				  	 <td  width="4%" align="center" class="<%=strclasse%>">&nbsp;</td>
				  <%next%>
				  <td width="4%" align="center" class="<%=strclasse%>">FALTA</td>
				  <td width="4%" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				  <%if strTpRelAcum = "2Avaliacao" then%>
				     <td align="center" class="<%=strclasse%>">T1</td>
				     <td align="center" class="<%=strclasse%>">T2</td>
				     <td align="center" class="<%=strclasse%>">T3</td>
				     <td align="center" class="<%=strclasse%>">T4</td>
				     <td align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				     <%for i=1 to ubound(vetTipoNota2)%>
			  	   	   <td  width="4%" align="center" class="<%=strclasse%>"></td>
				     <%next%>
				     <td width="4%" align="center" class="<%=strclasse%>">FALTA</td>
				     <td width="4%" align="center" class="<%=strclasse%>">M&Eacute;DIA</td>
				  <%end if%>
				  </tr>
				  <%
			   end if	
			end if

			   ContAluno = ContAluno + 1
			   intQtdeRegistro = intQtdeRegistro + 1
			   intCodTurma = RS("COD_TURMA") 
			   rs.movenext
			wend
		    end if
			rs.close
			sequencia = ContAluno - 1
   	        for i=1 to 3 
			sequencia = sequencia + 1
			%>
			<tr>
    		<td width="3%" align="center" class="<%=strclasse%>">&nbsp;</td>
    		<td class="<%=strclasse%>">&nbsp;</td>
    		<td width="8%" align="center" class="<%=strclasse%>">&nbsp;</td>
 			<td width="4%" class="<%=strclasse%>">&nbsp;</td>
    		<td width="4%" class="<%=strclasse%>">&nbsp;</td>
    		<td width="4%" class="<%=strclasse%>">&nbsp;</td>
    		<td width="4%" class="<%=strclasse%>">&nbsp;</td>
    		<td width="4%" class="<%=strclasse%>">&nbsp;</td>
  			<%for j=1 to QtdeContAvaliacao1%>
			<td width="4%" class="<%=strclasse%>">&nbsp;</td>
			<%next%>
			<td width="4%" class="<%=strclasse%>">&nbsp;</td>
    		<td width="4%" class="<%=strclasse%>">&nbsp;</td>
			<%if strTpRelAcum = "2Avaliacao" then%>
		    <td width="4%" class="<%=strclasse%>">&nbsp;</td>
			<td width="4%" class="<%=strclasse%>">&nbsp;</td>
			<td width="4%" class="<%=strclasse%>">&nbsp;</td>
			<td width="4%" class="<%=strclasse%>">&nbsp;</td>
			 <td width="4%" class="<%=strclasse%>">&nbsp;</td>
<%for h=1 to QtdeContAvaliacao2%>
                  <td  width="4%" align="center" class="<%=strclasse%>">&nbsp;</td>
            <%next%>
    		<td width="4%" class="<%=strclasse%>">&nbsp;</td>
    		<td width="4%" class="<%=strclasse%>">&nbsp;</td>
        <%end if%>           
		<%if strTpRelAcum = "1Avaliacao" then%>
             <td width="8%" align="center" class="<%=strclasse%>">&nbsp;</td>
             <td width="30%" align="left" class="<%=strclasse%>">&nbsp;</td>
             <td width="5%" align="center" class="<%=strclasse%>">&nbsp;</td>
             <td width="5%" align="center" class="<%=strclasse%>">&nbsp;&nbsp;</td>
        <%end if%>                 
   		</tr>
		<%
		next
		%>
           
    </table>
	</form>
	
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
