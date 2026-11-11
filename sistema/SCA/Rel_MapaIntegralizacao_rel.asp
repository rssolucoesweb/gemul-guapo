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
	
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strAlunoSemSituacao     = Trim(Request.Form("AlunoSemSituacao"))
	strIntervaloPercInicial	= Trim(Request.Form("txtIntervaloPercInicial"))
	strIntervaloPercFinal	= Trim(Request.Form("txtIntervaloPercFinal"))
	strCursoSigla			= Trim(Request.Form("cmbCursoSigla"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strTituloRelatorio  	= "Mapa de Integralização <br> Classificados entre: " & trim(strIntervaloPercInicial) &"% a " & trim(strIntervaloPercFinal) &"%"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="30%" class="<%=strclasse%>"><div align="center"><strong>Nome do Aluno</strong></div></td>
	    <td width="14%" class="<%=strclasse%>"><div align="center"><strong>Turma </strong></div></td>
	    <td width="16%" class="<%=strclasse%>"><div align="center"><strong>CH. Exigida</strong></div></td>
	    <td width="14%" class="<%=strclasse%>"><div align="center"><strong>CH. Cumprida</strong></div></td>
	    <td width="16%" class="<%=strclasse%>"><div align="center"><strong>(%) Integralizado</strong></div></td>
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
	
	
	sql = "select "
	sql = sql & " he.cod_aluno, " 
	sql = sql & " a.Nomealuno, "
	sql = sql & " a.matricula, "
	sql = sql & " sum(hed.carga_horaria) as CargaCumprida, "
	sql = sql & " (SELECT TOP 1 C.CH_exigida "
		sql = sql & " FROM SCA_ALUNO A "
		sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND  T.COD_EMPRESA = G.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = G.COD_PERIODO AND  P.COD_EMPRESA = G.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND P.COD_EMPRESA = C.COD_EMPRESA "
		sql = sql & " WHERE AT.COD_ALUNO = he.cod_aluno "
		sql = sql & " AND AT.COD_EMPRESA = " & session("CodEmpresa") 
		sql = sql & " 	order by AT.CODIGO DESC ) as CargaExigida, "

		sql = sql & " round((sum(hed.carga_horaria) * 100) / (SELECT TOP 1 C.CH_exigida "
		sql = sql & " FROM SCA_ALUNO A "
		sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND  T.COD_EMPRESA = G.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = G.COD_PERIODO AND  P.COD_EMPRESA = G.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND P.COD_EMPRESA = C.COD_EMPRESA "
		sql = sql & " WHERE AT.COD_ALUNO = he.cod_aluno "
		sql = sql & " AND AT.COD_EMPRESA = " & session("CodEmpresa")
		sql = sql & " order by AT.CODIGO DESC ),0) as PercentualCumprido, "

	sql = sql & " (SELECT TOP 1 NOMETURMA "
		sql = sql & " 	FROM SCA_ALUNO A "
		sql = sql & " 	INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " 	INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " 	WHERE AT.COD_ALUNO = he.cod_aluno "
		sql = sql & " 	AND AT.COD_EMPRESA = " & session("CodEmpresa")
		sql = sql & " 	order by AT.CODIGO DESC) as TURMA "
		
	sql = sql & " from sca_historico_escolar_disciplina hed "
	sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar "
	sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina AND d.cod_empresa = he.cod_empresa "
	sql = sql & " left JOIN sca_periodo p ON p.cod_periodo = hed.cod_periodo AND p.cod_empresa = he.cod_empresa "
	sql = sql & " left join SCA_ALUNO a ON a.CODIGO = he.cod_aluno "
	sql = sql & " WHERE he.cod_empresa = " & session("CodEmpresa")
	sql = sql & " AND (hed.situacao ='AP' OR hed.situacao ='AC' OR hed.situacao ='DI') "
 	if strAlunoSemSituacao = "S" then
	  sql = sql & "and ISNULL(A.COD_SITUACAOALUNO, '0') = 0 "
	else	    
	  if intCodSituacaoAluno <> "0" then
		  sql = sql & " and A.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	  end if 
	end if
	if strCursoSigla <> "0" then
		sql = sql & "and (SELECT TOP 1 SUBSTRING(NOMETURMA,1,2) FROM SCA_ALUNO A INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA WHERE AT.COD_ALUNO = he.cod_aluno AND AT.COD_EMPRESA = 8 order by AT.CODIGO DESC) = '" & trim(strCursoSigla) & "'"
	end if	  
	sql = sql & " group by he.cod_aluno, a.Nomealuno, a.Matricula "
	sql = sql & " order by TURMA, a.Nomealuno "
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		    if isnull(rs("PERCENTUALCUMPRIDO")) then 
			   PercentualCumprido = "0"
			else
			   PercentualCumprido = rs("PERCENTUALCUMPRIDO")
			end if   
			  
		    if  clng(trim(PercentualCumprido))  >= clng(trim(strIntervaloPercInicial))  and  clng(trim(PercentualCumprido)) <=  clng(trim(strIntervaloPercFinal)) then
				%>
				  <tr>
					<td class="<%=strclasse%>" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
					<td align="left" class="<%=strclasse%>"><%=rs("NOMEALUNO")%>&nbsp;</td>
					<td align="left" class="<%=strclasse%>"><div align="center"><%=rs("TURMA")%>&nbsp;</div></td>
					<td align="left" class="<%=strclasse%>"><div align="center"><%=rs("CARGAEXIGIDA")%>&nbsp;</div></td>
					<td align="left" class="<%=strclasse%>"><div align="center"><%=rs("CARGACUMPRIDA")%>&nbsp;</div></td>
					<td align="left" class="<%=strclasse%>"><div align="center"><%=rs("PERCENTUALCUMPRIDO")%>%&nbsp;</div></td>
				  </tr>
				<%
				'quantidade de registros da página
				if int(intQtdeRegistroPorPagina) = int(strlpp) then
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
			end if 
				
		    rs.movenext
		wend
		%>
		  <tr>
			<td colspan="6" class="<%=strclasse%>">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="6" class="<%=strclasse%>" align="center"><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
