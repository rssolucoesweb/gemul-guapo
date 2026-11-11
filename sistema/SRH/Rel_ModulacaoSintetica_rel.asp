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
<title><%=session("Titulo")%> - Modulação</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina
	

	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))

	intCodCurso				= Trim(Request.Form("cmbCurso"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplina		= Trim(Request.Form("cmbDisciplina"))
	intCodDiaSemana			= Trim(Request.Form("cmbDiaSemana"))
	strDataI				= formatadataAP(request.Form("txtDataI"))
	strDataF				= formatadataAP(request.Form("txtDataF"))
	
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")



	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	if strSemestre = "" then strSemestre = "0"

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	strTituloRelatorio  	= "MODULAÇÃO DOCENTES - SINTÉTICA"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="14%" align="center" class="celula"><strong>Matr&iacute;cula</strong></td>
	    <td width="45%" align="center" class="celula"><strong>Colaborador</strong></td>
	    <td width="14%" align="center" class="celula"><strong>Carga Hor&aacute;ria </strong></td>
	    <td width="13%" align="center" class="celula"><strong>Faltas </strong></td>
        <td width="14%" align="center" class="celula"><strong>Substitui&ccedil;&otilde;es</strong></td>
	  </tr>
	  
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	CargaHoraria = 0
	Falta = 0
	substituicao = 0


	'Tabela temporária das Substituições
	sql = "SET NOCOUNT ON  select  CF.cod_empresa, CF.ano_letivo, CF.semestre_letivo, C.codigo, C.nome, sum(convert(int,numero_aula)) as aula "
	sql = sql & " 	INTO #TEMP "
	sql = sql & " 	from dbo.SRH_COLABORADOR_FREQUENCIA CF "
	sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADORSUBSTITUTO  "
	sql = sql & " 	LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA = CF.COD_EMPRESA AND T.COD_TURMA = CF.COD_TURMA " 
	sql = sql & " 	LEFT JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR " 
	sql = sql & " 	LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO " 
	sql = sql & " 	LEFT JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO "
	sql = sql & " 	WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
	sql = sql & " 	AND CF.NUMERO_AULA <> 0 "
	sql = sql & "   AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
	sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, ' " & strDataI & "',103)"
	sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, ' " & strDataF & "',103)"
	sql = sql & " 	group by CF.cod_empresa, ano_letivo, semestre_letivo, c.nome, C.codigo " 

	'Tabela temporária das Faltas
	sql = sql & "SET NOCOUNT ON  select CF.cod_empresa, CF.ano_letivo, CF.semestre_letivo, C.codigo, C.nome, sum(convert(int,numero_falta)) as falta "
	sql = sql & " 	INTO #TEMP1 "
	sql = sql & " 	from dbo.SRH_COLABORADOR_FREQUENCIA CF "
	sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR  "
	sql = sql & " 	LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA = CF.COD_EMPRESA AND T.COD_TURMA = CF.COD_TURMA " 
	sql = sql & " 	LEFT JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR " 
	sql = sql & " 	LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO " 
	sql = sql & " 	LEFT JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO "
	sql = sql & " 	WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
	sql = sql & " 	AND CF.NUMERO_FALTA <> 0 "
    sql = sql & "   AND CF.SITUACAO <> 'S' "  'se não estiver abonada
	sql = sql & "   AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
	sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, ' " & strDataI & "',103)"
	sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, ' " & strDataF & "',103)"
	sql = sql & " group by CF.cod_empresa, ano_letivo, semestre_letivo, c.nome, C.codigo " 

	sql = sql & " select "
	sql = sql & " ISNULL(T1.AULA, '0') AS AULAS, "
	sql = sql & " ISNULL(T2.FALTA,'0') AS FALTAS, "
	sql = sql & " C.CODFUNCIONAL, "
	sql = sql & " C.NOME, "
	sql = sql & " C.CARGA_HORARIO_CONTRATADA, "
	sql = sql & " ISNULL(((C.TOTAL_AULAS_CUMPRIDA - C.TOTAL_AULAS) * FATOR_EXTRA_CLASSE),'0') AS EXTRA_CLASSE, "
	sql = sql & " SUM(H.numero_aula) AS CARGA_HORARIA  "
	sql = sql & " from SRH_COLABORADOR C "
	sql = sql & " left join SCA_HORARIO_AULA HA on HA.Cod_Colaborador = C.codigo "
	sql = sql & " left join SCA_HORARIO H on H.codigo = HA.Cod_Horario and H.cod_empresa = HA.Cod_Empresa "
	sql = sql & " left join SCA_DISCIPLINA D on D.Cod_Disciplina = HA.Cod_Disciplina and D.cod_empresa = HA.Cod_Empresa "
	sql = sql & " left join SCA_TURMA T on T.Cod_Turma = HA.Cod_turma and T.AnoLetivo = H.anoLetivo and T.Cod_Semestre = HA.Semestre and T.Cod_Empresa = HA.Cod_Empresa "
	sql = sql & " left join SCA_GRADECURRICULAR G on G.Cod_GradeCurricular = T.Cod_GradeCurricular and D.cod_empresa = HA.Cod_Empresa "
	sql = sql & " left join SCA_GRADECURRICULARDISCIPLINA GD on GD.Cod_GradeCurricular = G.Cod_GradeCurricular and GD.Cod_Disciplina = D.Cod_Disciplina "
	sql = sql & " left join #temp T1 on T1.codigo = C.codigo  "
	sql = sql & " left join #temp1 T2 on T2.codigo = C.codigo  "
	sql = sql & " WHERE  (C.codLotacao = " & session("CodEmpresa") & " OR C.nome = 'DEFICIT') "
	sql = sql & " and T.COD_EMPRESA = " & session("CodEmpresa")
		
	sql = sql & " and H.anoLetivo =  " & strAnoLetivo 
	sql = sql & " and C.modular = 'S'"
	if strSemestre<> "0" then
		sql = sql & " and H.semestre = " & strSemestre
	end if
	
	if intCodTurma<>"0" then
		sql = sql & " and T.cod_turma = " & intCodTurma
	end if

	if intCodDisciplina<>"0" then
		sql = sql & " and D.Cod_Disciplina = " & intCodDisciplina
	end if
	if intCodDiaSemana<>"0" then
		sql = sql & " and HA.DiaSemana = " & intCodDiaSemana
	end if
	sql = sql & " GROUP BY T1.AULA, T2.FALTA, C.CODFUNCIONAL, C.nome, CARGA_HORARIO_CONTRATADA, ISNULL(((C.TOTAL_AULAS_CUMPRIDA - C.TOTAL_AULAS) * FATOR_EXTRA_CLASSE),'0') "
	sql = sql & " order by C.nome "

	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
			%>
		  	<tr>
			<td align="left" class="celula">&nbsp;<strong><font size="2"><%=rs("CODFUNCIONAL")%></font></strong></td>
			<td align="left" class="celula">&nbsp;<strong><font size="2"><%=rs("NOME")%></font></strong></td>
			<td align="right" class="celula"><div align="center"><strong><font size="2"><%=rs("CARGA_HORARIO_CONTRATADA")%>&nbsp;</font></strong></div></td>
			<td align="right" class="celula"><div align="center"><strong><font size="2"><%=rs("FALTAS")%></font></strong></div></td>
			<td align="right" class="celula"><div align="center"><strong><font size="2"><%=rs("AULAS") + rs("EXTRA_CLASSE")%></font></strong></div></td>
		  	</tr>
			<%
			CargaHoraria = CargaHoraria + rs("CARGA_HORARIA")
			Falta = Falta + rs("FALTAS")
			substituicao = substituicao + rs("AULAS") + rs("EXTRA_CLASSE")
			
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
				 
		<tr bgcolor="#EAEAEA">
		<td align="right" class="celula"><div align="left">Registros: &nbsp;<strong><%=cont%></strong></div></td>
		<td align="right" class="celula"><strong>Total Geral: </strong></td>
		<td align="right" class="celula"><div align="center"><strong>&nbsp;<%=CargaHoraria%></strong></div></td>
		<td align="right" class="celula"><div align="center"><strong>&nbsp;<%=Falta%></strong></div></td>
		<td align="right" class="celula"><div align="center"><strong>&nbsp;<%=substituicao%></strong></div></td>
		</tr>
              
		<%			  
	else
		%>
		  <tr>
			<td colspan="5" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
