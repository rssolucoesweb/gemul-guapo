<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
server.ScriptTimeout = 3000
%>
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Ordem Alfabtica</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>

<%
dim intPagina

intCodAvaliacao					= Trim(Request.Form("cmbAvaliacaoInstitucional"))
intCodCategoria 				= Trim(Request.Form("cmbCategoria"))
intCodTurma 					= Trim(Request.Form("cmbTurma"))
intCodSituacaoAluno				= Trim(Request.Form("cmbSituacaoAluno"))

strSemestre 					= session("strSemestre")
strAnoLetivo 					= session("strAnoLetivo")

sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Tipo_Avaliacao, Tipo_Consulta"
sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
sql = sql & " Where Codigo = " & intCodAvaliacao
sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
rs.open sql, cnn

if rs.eof = false then
   intCodAvaliacao			= rs("Codigo")
   strNomeAvaliacao		    = rs("Descricao")
   intAnoLetivo			    = rs("Ano_Letivo")
   intSemestre				= rs("Semestre")
   intTipoAvaliacao		    = rs("Tipo_Avaliacao")
   intTipoConsulta			= rs("Tipo_Consulta")
end if 
rs.close

sub fimTabela()
	response.Write("</table>")
end Sub
sub mostraCabecalho()
   %>
   <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
   <table "91%" border="0" cellspacing="0" align="center" cellpadding="0">
   <tr>
   <td width="112" class="texto2" height="23" align="center">(<strong>A</strong>) Excelente</td>
   <td width="111" class="texto2" align="center">(<strong>B</strong>) Muito Bom</td>
   <td width="87"  class="texto2" align="center">(<strong>C</strong>) Bom </td>
   <td width="114" class="texto2" align="center">(<strong>D</strong>) Regular</td>
   <td width="111" class="texto2" align="center">(<strong>E</strong>) Insuficiente</td>
   </tr>
   <tr>
     <td height="21" colspan="8" align="center"><strong><%=ucase(strNomeAvaliacao)%></strong></td>
   </tr>
   </table>
   <table width = "91%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
   <%
end Sub

	
if intCodCategoria 		= "" then intCodCategoria 		= "0"
if intCodTurma 	   		= "" then intCodTurma 			= "0"
if intCodSituacaoAluno 	= "" then intCodSituacaoAluno 	= "0"

intPagina = 1
cont = 0

    ' Tipo Avaliação: 
	' 1 - Curricular     ---> Buscao consulta do aluno
	' 2 - Não Curricular 
	
	' Tipo Consulta: 
	' 1 - Curricular  		-->> 1 - Aluno
	' 2 - Não Curricular	-->> 1 - Aluno ou 2 - Colaborador
	
' 1 - Curricular	-->> 1 - Aluno 
' Busca todos os alunos pela turma informada, gerendo uma avaliação por disciplina
if intTipoAvaliacao =  1 and intTipoConsulta = 1 then
	sql = " SELECT "
	sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
	sql = sql & " T.NOMETURMA, "
	sql = sql & " AD.COD_DISCIPLINA, "
	sql = sql & " D.DESC_DISCIPLINA AS DISCIPLINA, "
	sql = sql & " A.NOMEALUNO, "
	sql = sql & " AD.COD_ALUNO, "
	sql = sql & " A.COD_SITUACAOALUNO "
	sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
	sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
	sql = sql & " SCA_TURMA T ON AD.COD_TURMA_REMANEJAMENTO = T.COD_TURMA AND AD.COD_EMPRESA = T.COD_EMPRESA INNER JOIN "
	sql = sql & " SCA_DISCIPLINA D ON D.COD_EMPRESA = AD.COD_EMPRESA AND D.COD_DISCIPLINA = AD.COD_DISCIPLINA  INNER JOIN "
	sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA INNER JOIN "
	sql = sql & " SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
	sql = sql & " SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
	sql = sql & " WHERE AD.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma
	sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') "
    if intCodSituacaoAluno <> 0 then
   	   sql = sql & " AND A.COD_SITUACAOALUNO = " & intCodSituacaoAluno
    end if
    sql = sql & " ORDER BY A.NOMEALUNO, D.DESC_DISCIPLINA"
end if
	
' 2 - Não Curricular	-->> 1 - Aluno 
' Busca todos os alunos pela turma informada
if intTipoAvaliacao =  2 and intTipoConsulta = 1 then
   sql = " SELECT T.COD_TURMA, T.NOMETURMA, AT.COD_ALUNO, AL.COD_SITUACAOALUNO "
   sql = sql & " FROM SCA_TURMA T "
   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_EMPRESA = T.COD_EMPRESA AND T.COD_TURMA = AT.COD_TURMA"
   sql = sql & " INNER JOIN SCA_ALUNO AL ON AL.COD_EMPRESA = AL.COD_EMPRESA AND AL.CODIGO = AT.COD_ALUNO"
   sql = sql & " WHERE T.COD_EMPRESA = " & session("CodEmpresa")
   sql = sql & " AND T.ANOLETIVO = " & strAnoLetivo 
   sql = sql & " AND T.COD_SEMESTRE = " & strSemestre
   sql = sql & " AND T.COD_TURMA = " & intCodTurma
   if intCodSituacaoAluno <> 0 then
   	  sql = sql & " AND AL.COD_SITUACAOALUNO = " & intCodSituacaoAluno
   end if
   sql = sql & " ORDER BY AT.COD_ALUNO"
end if

' 2 - Não Curricular	-->> 2 - Colaborador
' Busca todos os colaboradores, com situacao Ativo
if intTipoAvaliacao =  2 and intTipoConsulta = 2 then
   sql = "SELECT codigo, cod_empresa, Nome from SRH_COLABORADOR" 
   sql = sql & " 	Where cod_empresa = " & session("CodEmpresa")
   sql = sql & " 	And Situacao = 'A'"
   if intCodCategoria <> 0 then
   	  sql = sql & " 	And CodCategoria = " & intCodCategoria
   end if
end if
rs.open sql, cnn
if not rs.eof then 

  mostraCabecalho

   While not rs.eof 
     if intTipoAvaliacao =  1 and intTipoConsulta = 1 then
        strCodTurma			= rs("COD_TURMA") 
		strTurma			= rs("NOMETURMA")
		strCodSituacaoAluno = rs("COD_SITUACAOALUNO")
		strCodDisciplina 	= rs("COD_DISCIPLINA")
		strDisciplina 		= rs("DISCIPLINA")
		strNomealuno        = rs("NOMEALUNO")
  		sql = " SELECT C.CODIGO, C.NOME FROM SCA_HORARIO_AULA HA"
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = HA.COD_EMPRESA AND C.CODIGO = HA.Cod_Colaborador"
		sql = sql & " WHERE HA.COD_EMPRESA = " & session("CodEmpresa")
		sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo 
		sql = sql & " AND HA.SEMESTRE = " & strSemestre
		sql = sql & " AND HA.cod_Turma = " & strCodTurma
		sql = sql & " and HA.Cod_Disciplina = " & strCodDisciplina
		rsAux.open sql, cnn
		if not rsAux.eof then 
		   strNome = rsAux("NOME")	
		else
		   strNome = ""
		end if 	
		rsAux.close		
	 end if
  	 if intTipoAvaliacao =  2 and intTipoConsulta = 1 then
  	    strCodTurma			= rs("COD_TURMA") 
		strTurma			= rs("NOMETURMA")
 	 end if
	 if intTipoAvaliacao =  2 and intTipoConsulta = 2 then
 	    strDisciplina 	= ""
		strNome 		= rs("Nome")	
		strCurso		= ""
		strTurma		= ""
	  end if
	  sql = "SELECT Codigo, Cod_Avaliacao_Institucional, Descricao, Tipo_Pergunta, Subtitulo"
 	  sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
	  sql = sql & " Where Cod_Avaliacao_Institucional = " & intCodAvaliacao
	  sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
	  rsAux.open sql, cnn
	  if not rsAux.eof then
		 if intTipoAvaliacao =  1 and intTipoConsulta = 1 or intTipoAvaliacao =  2 and intTipoConsulta = 1 then
		    %>
		    <tr>
		      <td height="21" colspan="9" class="celula">&nbsp;</td>
	       </tr>
		    <tr bgcolor="#E5E5E5">
		    <td width="11%" height="21" class="celula"><strong>TURMA: </strong></td>
			<td width="21%" height="21" class="celula"><%=strTurma%></td>
			<td width="15%" height="21" class="celula"><strong>PROFESSOR(A) : </strong></td>
			<td height="21" colspan="6" class="celula"><%=strNome%>&nbsp;</td>
		    </tr>
		    <tr bgcolor="#E5E5E5">
			<td height="21" class="celula"><strong>DISCIPLINA</strong>:</td>
			<td height="21" colspan="8" class="celula"><%=strDisciplina%>&nbsp;</td>
		    </tr>
		    <%
		 end if
		 %>
		 <tr bgcolor="#E5E5E5">
		 <td height="21" colspan="4" class="celula">&nbsp;</td>
		 <td colspan="5" align="center" class="celula"><strong>Conceito</strong></td>
		 </tr>
		 <tr bgcolor="#E5E5E5">
		 <td height="21" colspan="4" class="celula">&nbsp;&nbsp;</td>
		 <td width="4%" align="center" class="celula"><strong>A</strong></td>
		 <td width="4%" align="center" class="celula"><strong>B</strong></td>
		 <td width="3%" align="center" class="celula"><strong>C</strong></td>
		 <td width="4%" align="center" class="celula"><strong>D</strong></td>
		 <td width="5%" align="center" class="celula"><strong>E</strong></td>
		 </tr>
		 <%
		 while not rsAux.eof
   	        strTipo_pergunta = rsAux("Tipo_Pergunta")

		    if trim(rsAux("Subtitulo")) <> "" then
		   	   %>
		 	   <tr bgcolor="#E5E5E5">
			   <td height="21" colspan="9" class="celula"><strong><%=trim(rsAux("Subtitulo"))%></strong></td>
		 	   </tr>
			   <%
			end if 
			if strTipo_pergunta = "O" then
			   %>
			   <tr>
			   <td height="21" colspan="4" class="celula"><%=trim(rsAux("Descricao"))%></td>
			   <td height="21" align="center" class="celula">&nbsp;</td>
			   <td height="21" align="center" class="celula">&nbsp;</td>
			   <td height="21" align="center" class="celula">&nbsp;</td>
			   <td height="21" align="center" class="celula">&nbsp;</td>
			   <td height="21" align="center" class="celula">&nbsp;</td>
			   </tr>
			   <%
			else
			   %>
			   <tr>
			   <td height="21" colspan="9" class="celula"><%=trim(rsAux("Descricao"))%></td>
			   </tr>
			   <tr>
			   <td height="30" colspan="9" class="celula">&nbsp;</td>
			   </tr>
			   <tr>
			   <td height="30" colspan="9" class="celula">&nbsp;</td>
			   </tr>
			   <tr>
			   <td height="30" colspan="9" class="celula">&nbsp;</td>
			   </tr>
               <%
			end if  
			if cont = 20 then
			
			   fimTabela
			   %>
			   <pre> </pre>				
			   <%			
			   mostraCabecalho
			   intPagina = intPagina + 1
			   cont = 1
 		    end if	
		    cont = cont + 1
		    rsAux.movenext
		 wend
 	     rsAux.close
 	  end if
  	  rs.movenext
   wend
   rs.close
end if
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
