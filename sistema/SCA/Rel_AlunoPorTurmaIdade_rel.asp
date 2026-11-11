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
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurmaQuebra		= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strQuebraPagina			= Trim(Request.Form("cmbQuebraPagina"))
	strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))
	intCodFormaIngresso 	= Trim(Request.Form("cmbFormaIngresso"))
	strAlunoSemSituacao     = Trim(Request.Form("AlunoSemSituacao"))
	intCodEstagio     		= Trim(Request.Form("cmbEstagio"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"

    if intCodEstagio <> "0" then
		sql = "SELECT E.Ano, E.Semestre, E.Descricao as Grupo, C.nome as Orientador"
		sql = sql & " FROM SCA_ESTAGIO E"
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = E.COD_COLABORADOR " 
		sql = sql & " And E.codigo = " & intCodEstagio
		rs.open sql, cnn
		if rs.eof = false then
			strEstagio = "Estágio: " & rs("grupo")&"<BR>Preceptor: " & rs("Orientador")  
		end if
		rs.close	
    end if
	
	if intCodDisciplinaTurma = "" or intCodDisciplinaTurma = "0" then
		if trim(strAnoLetivo) = trim(session("strAnoLetivo")) and trim(strSemestre) =  trim(session("strSemestre")) then
		   strTituloRelatorio  = "ALUNOS POR TURMA <br>DATA DE NASCIMENTO, NATURALIDADE E IDADE<br>" & strEstagio
		else   
		   strTituloRelatorio  = "ALUNOS POR TURMA <br>DATA DE NASCIMENTO, NATURALIDADE E IDADE - Período Letivo: " & strAnoLetivo & "/" & strSemestre & "<BR>" & strEstagio
		end if   
	else
	    strDescDisciplina    = ""
	  	sql = "SELECT DESC_DISCIPLINA "
		sql = sql & "  FROM SCA_DISCIPLINA "
		SQL = SQL & " WHERE COD_EMPRESA =" & Session("CodEmpresa")
		sql = sql & " AND COD_DISCIPLINA = " &  intCodDisciplinaTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			strDescDisciplina  =  rs("DESC_DISCIPLINA")
		END IF
		rs.close
        strTituloRelatorio  	= "ALUNOS POR TURMA <br>DATA DE NASCIMENTO, NATURALIDADE E IDADE : " & strDescDisciplina & "<BR>" & strEstagio
	end if	

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <%
	  if strSubTitulo <> "" then
	     %>
	     <tr bgcolor="#CCCCCC">
	     <td colspan="5" class="<%=strclasse%>"><div align="center"><%=strSubTitulo%>&nbsp;</div></td>
         </tr>
		 <%
	  end if	
	  %> 
	  <tr bgcolor="#CCCCCC">
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="45%" class="<%=strclasse%>"><div align="center"><strong>Nome do Aluno</strong></div></td>
		<td width="15%" class="<%=strclasse%>"><div align="center"><strong>Data Nascimento </strong></div></td>
		<td width="15%" class="<%=strclasse%>"><div align="center"><strong>Naturalidade - UF</strong></div></td>
		<td width="15%" class="<%=strclasse%>"><div align="center"><strong>Idade</strong></div></td>
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
	mostraCabecalho
	cont = 0

   if intCodDisciplinaTurma = "" or intCodDisciplinaTurma = "0" then
	   sql = "SELECT  DISTINCT   SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATAMATRICULA , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma,  SCA_ALUNO.COD_FORMAINGRESSO, SCA_ALUNO.CIDADENASCIMENTO, SCF_UF.SIGLA AS UFNASCIMENTO"
	   sql = sql & " FROM SCA_ALUNO_TURMA "
	   sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	   sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	   sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	   sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
	   sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	   sql = sql & " LEFT JOIN SCF_UF ON SCF_UF.CODIGO = SCA_ALUNO.UFNASCIMENTO"
	    ' Filtra o estagio
	   if intCodEstagio <> "0" then
		   sql = sql & " INNER JOIN SCA_ESTAGIO_VINCULO E ON E.Cod_Aluno = SCA_ALUNO.CODIGO "
	   end if
	   
	   sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
	   if trim(strAnoLetivo) = trim(session("strAnoLetivo")) and trim(strSemestre) =  trim(session("strSemestre")) then
	      sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
	   end if	  
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
	   if strAlunoSemSituacao = "S" then
	      sql = sql & "and ISNULL(SCA_ALUNO.COD_SITUACAOALUNO, '0') = 0"
	   else	    
		  if intCodSituacaoAluno <> "0" then
			  sql = sql & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
		  end if 
	   end if
	   if intCodFormaIngresso <> "0" then
		  sql = sql & " and SCA_ALUNO.COD_FORMAINGRESSO = " & intCodFormaIngresso
	   end if
	   if strSexo <> "0" then
		  sql = sql & " and SCA_ALUNO.SEXOALUNO = '" & strSexo & "'"
	   end if
	   
	      ' Filtra o estagio
	   if intCodEstagio <> "0" then
		  sql = sql & " and E.CodEstagio = " & intCodEstagio
	   end if
	   
	   	'ordem de classificação do relatorio
	   if intCodTurmaQuebra <> "" and  intCodTurmaQuebra <> "0" then
		   if strOrdem = "alfabetica" then
			  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.NOMEALUNO"
		   elseif strOrdem = "matricula" then
			  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.matricula"
		   elseif strOrdem = "datamatricula" then
			  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.datamatricula"
		   elseif strOrdem = "dataafastamento" then
		   'verificar qual o campos data afastamento no cadastro
			  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.DATAFASTAMENTO"
		   elseif strOrdem = "idade" then
			  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.DATANASCIMENTO"
		   elseif strOrdem = "bairro" then
			  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.BAIRROALUNO"
		   end if
		else
			sql = sql & " Order By SCA_ALUNO.NOMEALUNO"
		end if   
	else
	   sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
	   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
	   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
	   sql = sql & " AD.COD_DISCIPLINA, "
	   sql = sql & " AD.SITUACAO AS SIT_CURRICULAR, "
	   sql = sql & " A.NOMEALUNO, "
	   sql = sql & " A.MATRICULA, "
	   sql = sql & " A.DATANASCIMENTO, "
	   sql = sql & " A.DATAMATRICULA, "
	   sql = sql & " A.COD_FORMAINGRESSO, "
	   sql = sql & " '' AS SEQUENCIA, "
	   sql = sql & " P.DESCRICAO AS PERIODO, "
	   sql = sql & " C.DESCRICAO AS CURSO, "
	   sql = sql & " T.NomeTurma, "
	   sql = sql & " A.CIDADENASCIMENTO, "
	   sql = sql & " UFN.SIGLA AS UFNASCIMENTO, "
	   sql = sql & " SA.DESC_SITUACAOALUNO "
	   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD" 
       sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO AND AD.COD_EMPRESA = A.COD_EMPRESA"
	   sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO AND AD.COD_EMPRESA = T.COD_EMPRESA"
	   sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
	   sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo and P.cod_empresa = G.cod_empresa"
	   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa =  A.COD_EMPRESA"
	   sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso and C.cod_empresa = P.cod_empresa"
	   sql = sql & " LEFT JOIN SCF_UF UFN ON UFN.CODIGO = A.UFNASCIMENTO"
	    ' Filtra o estagio
	   if intCodEstagio <> "0" then
		   sql = sql & " INNER JOIN SCA_ESTAGIO_VINCULO E ON E.Cod_Aluno = A.CODIGO "
	   end if
	   
	   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
	   sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
	   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma	
	   sql = sql & " AND SA.Desc_SituacaoAluno = 'ATIVO' "
	   if intCodCurso <> "0" then
		  sql = sql & " and C.Cod_Curso = " & intCodCurso
	   end if
	   if intCodPeriodo <> "0" then
		  sql = sql & " and G.Cod_Periodo = " & intCodPeriodo
	   end if
	   if intCodTurno <> "0" then
		  sql = sql & " and T.COD_TURNO = " & intCodTurno
	   end if
	   if strAlunoSemSituacao = "S" then
	      sql = sql & "and ISNULL(SA.COD_SITUACAOALUNO, '0') = 0"
	   else	    
		  if intCodSituacaoAluno <> "0" then
			  sql = sql & " and SA.COD_SITUACAOALUNO = " & intCodSituacaoAluno
		  end if 
	   end if
	   if intCodFormaIngresso <> "0" then
		  sql = sql & " and A.COD_FORMAINGRESSO = " & intCodFormaIngresso
	   end if
	   if strSexo <> "0" then
		  sql = sql & " and A.SEXOALUNO = '" & strSexo & "'"
	   end if
	   
	      ' Filtra o estagio
	   if intCodEstagio <> "0" then
		  sql = sql & " and E.CodEstagio = " & intCodEstagio
	   end if
	   
       'ordem de classificação do relatorio
	   if intCodTurmaQuebra <> "" and  intCodTurmaQuebra <> "0" then
		   if strOrdem = "alfabetica" then
			  sql = sql & " Order By T.NOMETURMA, A.NOMEALUNO"
		   elseif strOrdem = "matricula" then
			  sql = sql & " Order By T.NOMETURMA, A.MATRICULA"
		   elseif strOrdem = "datamatricula" then
			  sql = sql & " Order By T.NOMETURMA, A.datamatricula"
		   elseif strOrdem = "dataafastamento" then
			  sql = sql & " Order By T.NOMETURMA, A.DATAFASTAMENTO"
		   elseif strOrdem = "idade" then
			  sql = sql & " Order By T.NOMETURMA, A.DATANASCIMENTO"
		   elseif strOrdem = "bairro" then
			  sql = sql & " Order By T.NOMETURMA, A.BAIRROALUNO"
		   end if
		else
 			sql = sql & " Order By A.NOMEALUNO"		
		end if   
    end if	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			IF intCodTurmaQuebra <> "" and  intCodTurmaQuebra <> "0"  then
			IF intCodTurma <> RS("COD_TURMA") THEN
				if controle = 1 then
					%>
					  <tr>
						<td colspan="5" class="<%=strclasse%>">Quantidade de Alunos Por Turma: <%=contPorTurma%></td>
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
			end if
			idade = ""
			if not isnull(rs("DATANASCIMENTO")) then
				idade = calculaIdade(rs("DATANASCIMENTO")) & " anos"
			end if
			%>
			  <tr>
				<td class="<%=strclasse%>" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
				<% if intCodDisciplinaTurma = "" or intCodDisciplinaTurma = "0" then %>
                    <td class="<%=strclasse%>" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
                <% else %>    
                     <% if trim(rs("SIT_CURRICULAR")) = "CR" then %>
                        <td class="<%=strclasse%>" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
                     <% else %>    
                        <td class="<%=strclasse%>" align="left"><%=rs("NOMEALUNO")%> - (** <%=trim(rs("SIT_CURRICULAR"))%> ** )&nbsp;</td>
                    <% end if %> 
                <% end if %> 
				<td class="<%=strclasse%>" align="center"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
				<td class="<%=strclasse%>" align="center"><div align="left">&nbsp;&nbsp;&nbsp;<%=rs("CIDADENASCIMENTO")%> - <%=rs("UFNASCIMENTO")%></div></td>
				<td class="<%=strclasse%>" align="center"><%=idade%>&nbsp;</td>
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
			intCodTurma = RS("COD_TURMA") 
			rs.movenext
		wend
		IF intCodTurmaQuebra <> "" and  intCodTurmaQuebra <> "0"  then
		   %>
		   <tr>
			<td colspan="6" class="<%=strclasse%>">Quantidade de Alunos Por Turma: <%=contPorTurma%></td>
		   </tr>
           <%
		end if
		   %>   
		  <tr>
			<td colspan="5" class="<%=strclasse%>">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="5" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
