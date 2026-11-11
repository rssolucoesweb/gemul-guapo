<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Alunos</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
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
	intCodTurmaQuebra		= Trim(Request.Form("cmbQuebraPagina"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strQuebraPagina			= "TURMA"
	strUniformeTenis 	= Trim(Request.Form("cmbUniformeTenis"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if
	
	if strUniformeTenis = "U" then
	   strTipo 			= "Tamanho do Uniforme"
	   
	else
	   strTipo 			= "Tamanho do Calçado"
	end if   
	
	
	emitirNormal = "N"

	
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strAniversariante       = Trim(Request.Form("cmbMes"))
	strIdade                = Trim(Request.Form("cmbIdade"))
	strTituloRelatorio = "Relatório de " & strTipo

	if strIdade <> "0" then
		strTituloRelatorio  	= strTituloRelatorio & " - Com idade de " & strIdade
	end if	
    sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="10%" class="celula"><div align="center"><strong>Turma</strong></div></td>
	  </tr>
	<%
	end Sub
	
	intPagina = 1
	mostraCabecalho
	cont = 0
	
   sql = "SELECT  DISTINCT   T.COD_TURMA, T.NomeTurma, T.TURMAALUNO"
   sql = sql & " FROM SCA_ALUNO A "
   if strUniformeTenis = "T" then
		sql = sql & " INNER JOIN SCA_TAMANHO_CALCADO TA ON TA.CODIGO = A.COD_TAMANHO_CALCADO"
   else
		sql = sql & " INNER JOIN SCA_TAMANHO_ROUPA TA ON TA.CODIGO = A.COD_TAMANHO_ROUPA"
   end if
   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO "
   sql = sql & " LEFT JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma  AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
   sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
   sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
   sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
   sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SITUACAOALUNO = A.COD_SITUACAOALUNO"
   sql = sql & " where T.cod_empresa = " & session("CodEmpresa")
   sql = sql & " AND T.SITUACAO='A'"
   if trim(strAnoLetivo) = trim(session("strAnoLetivo")) and trim(strSemestre) =  trim(session("strSemestre")) then
	  sql = sql & " and 	AT.situacao = 'A'"
   end if	
	 
   sql = sql & " and 	AT.Ano_Letivo = " &  strAnoLetivo
   sql = sql & " and 	AT.Semestre in (" & strSemestre & ")"
   
   if intCodCurso <> "0" then
	  sql = sql & " and C.Cod_Curso = " & intCodCurso
   end if
   
   if intCodPeriodo <> "0" then
	  sql = sql & " and G.Cod_Periodo = " & intCodPeriodo
   end if
   
   if intCodTurno <> "0" then
	  sql = sql & " and T.COD_TURNO = " & intCodTurno
   end if
   
   if intCodTurma <> "0" then
	  sql = sql & " and AT.COD_TURMA = " & intCodTurma
   end if
   
   if intCodSituacaoAluno <> "0" then
	  sql = sql & " and A.COD_SITUACAOALUNO = " & intCodSituacaoAluno
   end if 
   
   if strSexo <> "0" then
	  sql = sql & " and A.SEXOALUNO = '" & strSexo & "'"
   end if
   
   if strIdade <> "0" and strIdade <> "" then
	  sql = sql & " and FLOOR(DATEDIFF(DAY, A.DataNascimento, GETDATE()) / 365.25)  = " & strIdade
   end if
   
	'ordem de classificação do relatorio
	sql = sql & " Order By T.NomeTurma"
	 'response.write sql
	
	rs.open sql, cnn
	if not rs.eof then 
		controle = 0
		contPorTurma = 0
		While not rs.eof
		
			IF intCodTurma <> RS("COD_TURMA") THEN
				strInfoTurma =  "<strong>" & RS("NomeTurma") & "</strong> - " & RS("TURMAALUNO")
				%>
				<tr>
					<td bgcolor="#cococo" class="celula"><div align="center"><%=strInfoTurma%></div></td>
				</tr>
				<%
			END IF
			%>
			<tr>
				<td class="celula">
					<br>
					<div align="center">
					<%
					if strUniformeTenis = "T" then
						sql = " select ta.DESCRICAO + ' (' + ta.RESUMO + ')' as tipo, count(*) as qtde"
						sql = sql & " from sca_aluno a"
						sql = sql & " INNER JOIN SCA_TAMANHO_CALCADO TA ON TA.CODIGO = A.COD_TAMANHO_CALCADO"
						sql = sql & " inner join sca_aluno_turma at on at.COD_ALUNO = a.codigo"
						sql = sql & " where AT.SITUACAO='A' AND at.COD_TURMA=" & rs("cod_turma")
						sql = sql & " group by ta.DESCRICAO + ' (' + ta.RESUMO + ')'"
					else
						sql = " select ta.DESCRICAO as tipo, count(*) as qtde"
						sql = sql & " from sca_aluno a"
						sql = sql & " INNER JOIN SCA_TAMANHO_ROUPA TA ON TA.CODIGO = A.COD_TAMANHO_ROUPA"
						sql = sql & " inner join sca_aluno_turma at on at.COD_ALUNO = a.codigo"
						sql = sql & " where AT.SITUACAO='A' AND at.COD_TURMA=" & rs("cod_turma")
						sql = sql & " group by ta.DESCRICAO"
					end if
					
					rsAux.open sql, cnn
					if not rsAux.eof then 
						%>
						<table width="60%" border="0" cellspacing="0" cellpadding="0" class="tabela">
							<tr>
								<td class="celula"><div align="center"><strong><%=strTipo%></strong></div></td>
								<td class="celula"><div align="center"><strong>Quantidade alunos</strong></div></td>
							  </tr>
						<%
						While not rsAux.eof
							%>
							  <tr>
								<td width="50%" class="celula"><div align="center"><%=rsaux("tipo")%></div></td>
								<td width="50%" class="celula"><div align="center"><%=rsaux("qtde")%></div></td>
							  </tr>
							<%
							rsAux.movenext
						wend
						%>
						</table>
						<%
					end if
					rsAux.close
					%>
					</div>
					<br>
				</td>
			</tr>
			<%

		
			cont = cont + 1
			contPorTurma = contPorTurma + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			intCodTurma = RS("COD_TURMA") 
			rs.movenext
		wend
		
		   %>   
		  <tr>
			<td bgcolor="#cococo" class="celula"><div align="center"><strong>RESUMO DA UNIDADE</strong></div></td>
		  </tr>
		  <tr>
			<td class="celula">
			
				<br>
				<div align="center">
				<%
				
				if strUniformeTenis = "T" then
					sql = " select ta.DESCRICAO + ' (' + ta.RESUMO + ')' as tipo, count(*) as qtde"
					sql = sql & " from sca_aluno a"
					sql = sql & " INNER JOIN SCA_TAMANHO_CALCADO TA ON TA.CODIGO = A.COD_TAMANHO_CALCADO"
					sql = sql & " inner join sca_aluno_turma at on at.COD_ALUNO = a.codigo"
					sql = sql & " where AT.SITUACAO='A' AND at.COD_empresa=" & session("CodEmpresa")
					sql = sql & " group by ta.DESCRICAO + ' (' + ta.RESUMO + ')'"
				else
					sql = " select ta.DESCRICAO as tipo, count(*) as qtde"
					sql = sql & " from sca_aluno a"
					sql = sql & " INNER JOIN SCA_TAMANHO_ROUPA TA ON TA.CODIGO = A.COD_TAMANHO_ROUPA"
					sql = sql & " inner join sca_aluno_turma at on at.COD_ALUNO = a.codigo"
					sql = sql & " where AT.SITUACAO='A' AND at.COD_empresa=" & session("CodEmpresa")
					sql = sql & " group by ta.DESCRICAO"
				end if
				
				rsAux.open sql, cnn
				if not rsAux.eof then 
					%>
					<table width="60%" border="0" cellspacing="0" cellpadding="0" class="tabela">
						<tr>
							<td class="celula"><div align="center"><strong><%=strTipo%></strong></div></td>
							<td class="celula"><div align="center"><strong>Quantidade alunos</strong></div></td>
						  </tr>
					<%
					While not rsAux.eof
						%>
						  <tr>
							<td width="50%" class="celula"><div align="center"><%=rsaux("tipo")%></div></td>
							<td width="50%" class="celula"><div align="center"><%=rsaux("qtde")%></div></td>
						  </tr>
						<%
						total = total + rsaux("qtde")
						rsAux.movenext
					wend
					%>
						<tr>
							<td width="50%" class="celula"><div align="center"><strong>Total</strong></div></td>
							<td width="50%" class="celula"><div align="center"><strong><%=total%></strong></div></td>
						  </tr>
					</table>
					<%
				end if
				rsAux.close
				%>
				</div>
				<br>
			
			</td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td  class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
