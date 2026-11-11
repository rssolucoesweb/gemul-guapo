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
<title><%=session("Titulo")%> - Planilha de Notas</title>
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

	strAvaliacao 	= Request.Form("chkTipoNota")
	strTipoNota		= strAvaliacao
	strBimestreDescricao = ""
	sql="SELECT DISTINCT TAA.DESCRICAO AS BIMESTRE"
	sql=sql & " FROM SCA_TIPO_AVALIACAO_Planilha TA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO TAA ON TAA.CODIGO = TA.BIMESTRE"
	sql=sql & " WHERE	TA.COD_EMPRESA = " & Session("CodEmpresa") 
	sql=sql & " AND	TA.BIMESTRE = " & strAvaliacao
	rs.open sql, cnn
	intCont = 0
	if rs.eof = false then
		strBimestreDescricao = rs("BIMESTRE")
	end if
	rs.close

	if strBimestreDescricao = "" then
		%>
		<script>
			alert("ATENÇÃO: \n\nSelecione no máximo duas avaliação para a geração correta desse relatório.");
			window.history.back();
		</script>
		<%	
		response.End()
	end if
	
	strOpcaoRelatorio			= Trim(Request.Form("optOpcao"))
	intCodCurso	 				= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	intCodTurno		 			= Trim(Request.Form("cmbTurno"))
	strSemestre 				= session("strSemestre")
	strAnoLetivo 				= session("strAnoLetivo")
	strclasse               	= Trim(Request.Form("cmbTamanhoFonteArial"))
	intCodSituacaoAluno	 	= Trim(Request.Form("cmbSituacaoAluno"))
	if intCodSituacaoAluno 	= "" then intCodSituacaoAluno = "0"
	
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina		= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))
	end if

	if intCodCurso 		= "" then intCodCurso = "0"
	if intCodPeriodo 	= "" then intCodPeriodo = "0"
	if intSemestre 		= "" then intSemestre = "0"
	if intCodTurno 		= "" then intCodTurno = "0"
	if intCodTurma 		= "" then intCodTurma = "0"
	if intCodDisciplinaTurma 		= "" then intCodDisciplinaTurma = "0"
	if intCodEstagio = "" then intCodEstagio="0"

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
		
	strTituloRelatorio  	= "PLANILHA DE NOTAS"
	intQtdeAvaliacao1 = 1
	
	'carrega campos
	sql = "SELECT  posicao, descricao, formula, digitar, bimestre as tipo "
	sql = sql & " FROM SCA_TIPO_AVALIACAO_Planilha "
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	sql = sql & " AND tipo_bimestre = " & strTipoNota
	sql = sql & " order by posicao"
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		vetCampo = rs.getRows
	end if
	rs.close

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
	<table class="tabela" border="1" cellspacing="0" width="100%" bordercolor="#000000"  align="center">
    <tr>
		<td width="8%" height="17" class="<%=strclasse%>">TURMA: </td>
		<td  class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
		<td width="9%" class="<%=strclasse%>">AVALIAÇÃO:</td>
        <td colspan="3" class="<%=strclasse%>"><strong><%=strBimestreDescricao%></strong>&nbsp;</td>
    </tr>
        <tr>
        <td height="17" class="<%=strclasse%>">DISCIPLINA: </td>
        <td width="23%" class="<%=strclasse%>"><strong><%=strDisciplinaTurma%>&nbsp;</strong></td>
        <td width="9%" class="<%=strclasse%>">PROFESSOR(A):</td>
        <td colspan="3" class="<%=strclasse%>"><strong><%=strProfessor%></strong>&nbsp;</td>
        </tr>
    </table>
	<br>
	 <table class="tabela" width="100%" align="center" border="1" cellpadding="0" cellspacing="0">
		<tr class="CabecalhoConsulta"> 
		<td width="80" class="<%=strclasse%>"><strong>Matr&iacute;cula</strong></td>
		<td width="765" class="<%=strclasse%>"><strong>Nome</strong></td>
		<%
			for i=0 to ubound(vetCampo,2)
			%>
				<td class="<%=strclasse%>" align="center" width="10%"><strong><%=ucase(vetCampo(1,i))%></strong></td>
			<%
			next
			%>
		</tr>

		<%	
	   sql = "  SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
	   sql = sql & " AD.COD_ALUNO, "
	   sql = sql & " NF.CODIGO, " 
	   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
	   sql = sql & " GCD.COD_DISCIPLINA, "
	   sql = sql & " A.NOMEALUNO, "
	   sql = sql & " A.MATRICULA, "
	   sql = sql & " '' AS SEQUENCIA, "
	   for n=1 to 30
			strComplemento = "0"	
			if cInt(n)>9 then strComplemento = ""
			sql = sql & " NF.nota" & strComplemento & n & ", "
		next
		
	   sql = sql & " SA.DESC_SITUACAOALUNO "
	   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
	   sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
	   sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
	   sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
	   sql = sql & " LEFT JOIN SCA_NOTAS_PLANILHA NF ON NF.cod_aluno_disciplina = AD.CODIGO "
	   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
	   sql = sql & " AND GCD.COD_DISCIPLINA= " & intCodDisciplinaTurma
	   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma
	   if intCodSituacaoAluno <> "0" then	
		  sql = sql & " AND SA.Cod_SituacaoAluno = " & intCodSituacaoAluno
	   end if	  
	   sql = sql & " ORDER BY A.NOMEALUNO "
	   rs.open sql, cnn
	   if rs.eof = false then
		   while not rs.eof
			  contLanc 				= contLanc + 1
			  strCodAlunoNota		= RS("CODIGO")
			  strCodAluno 			= RS("COD_ALUNO")
			  strCodAlunoZeros 		= ZeroLeft(RS("COD_ALUNO"),10)  
			  intCodEmp             = Session("CodEmpresa") 
			  strSituacaoAluno 		= ""
			  
			  strCodAlunoDisciplina  	= rs("COD_ALUNO_DISCIPLINA")
			 
			 strMatricula		          = rs("MATRICULA")
			 strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
			 'Função que verifica a siuação do aluno
			 strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
			 %>
			 <tr> 
			 <td class="<%=strclasse%>"><%=strMatricula%>
			 <input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina_<%=contLanc%>">
			 <input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("CODIGO")%>">
			 <input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=strCodAluno%>">
			 </td>
			 <td class="<%=strclasse%>">
			 <%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
			 <%
			 for i=0 to ubound(vetCampo,2)
				strComplementoNota = "0"	
				if cInt(vetCampo(0,i))>9 then strComplementoNota = ""
				strNota = RS("NOTA" &strComplementoNota& vetCampo(0,i))
				%>
				<td class="<%=strclasse%>" align="center">
						<%=strNota%>&nbsp;
				</td>
				<%   
				   
			 next	
				%>
	   </tr>
	   <%					
		rs.movenext
		wend
		%>
		</table>
		<%
	 end if
	 rs.close
	 %>
			 
		</table>
        <br><br>
        <table width="100%" border="0">
  <tr>
    <td width="54%" align="center">_____________________________________________________________________</td>
    <td width="46%">&nbsp;</td>
  </tr>
  <tr>
    <td align="center"><%=strProfessor%></td>
    <td>&nbsp;</td>
  </tr>
</table>

	
	
	

	
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
