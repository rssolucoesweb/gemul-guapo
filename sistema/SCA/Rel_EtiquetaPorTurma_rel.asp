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
	
	
    strAnoLetivo = Trim(Request.Form("txtAnoLetivo"))
  	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strQuebraPagina			= Trim(Request.Form("cmbQuebraPagina"))
	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	strMes					= Trim(Request.Form("cmbMes"))
	strIdadeInformada   	= Trim(Request.Form("cmbIdade"))
	
	strCodParcelaInicial	= Trim(Request.Form("cmbParcelaInicial"))
	strCodParcelaFinal		= Trim(Request.Form("cmbParcelaFinal"))
	strAnoInicial			= Trim(Request.Form("cmbAnoInicial"))
	strAnoFinal				= Trim(Request.Form("cmbAnoFinal"))
	strStatusFinanceiro  	= Trim(Request.Form("cmbStatusFinanceiro"))
	intCodTipoParcela		= Trim(Request.Form("cmbTipoParcela"))


	
	campo1			= Trim(Request.Form("cmbCampo1"))
	campo2			= Trim(Request.Form("cmbCampo2"))
	campo3			= Trim(Request.Form("cmbCampo3"))
	campo4			= Trim(Request.Form("cmbCampo4"))
	campo5			= Trim(Request.Form("cmbCampo5"))
	campo6			= Trim(Request.Form("cmbCampo6"))


	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"


	strModeloEtiqueta			= Trim(Request.Form("cmbModeloEtiqueta"))
	if trim(strModeloEtiqueta) <> "0" then
		sql = "SELECT coluna, linha, tamanhoHorizontal, tamanhoVertical, espaco"
		sql = sql & " FROM SCA_MODELO_ETIQUETA "
		SQL = SQL & " WHERE	cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND 	codigo= " & strModeloEtiqueta
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			linhaPorPagina 		= rs("linha")
			colunaPorPagina 	= rs("coluna")
			tamanhoHorizontal 	= rs("tamanhoHorizontal")
			tamanhoVertical 	= rs("tamanhoVertical")
			espaco 				= rs("espaco")
		END IF
		rs.close

	end if

	tamanho_espaco=""
	for i=1 to espaco
	   tamanho_espaco = tamanho_espaco & "&nbsp;"
    next
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	cont = 0
	sql = ""
	if strOpcaoRelatorio = "0" then
		sql = " SET NOCOUNT ON "
		sql = sql & " SELECT DISTINCT CODIGO AS COD_ALUNO, "
		sql = sql & " CASE WHEN DATEPART(MONTH,DATANASCIMENTO)<= DATEPART(MONTH,GETDATE()) AND DATEPART(DAY,DATANASCIMENTO)<= DATEPART(DAY,GETDATE()) "
		sql = sql & "    THEN (DATEDIFF(YEAR,DATANASCIMENTO,GETDATE())) "
		sql = sql & "    ELSE (DATEDIFF(YEAR,DATANASCIMENTO,GETDATE()))- 1 "
		sql = sql & " END AS IDADEATUAL "
		sql = sql & " INTO #TEMP "
		sql = sql & " FROM SCA_ALUNO "
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		if strMes <> "0" then
		   sql = sql & " AND MONTH(DATANASCIMENTO) = " & strMes
		end if  
		if strIdadeInformada <> "0" then 
			sql = sql & " AND CASE WHEN DATEPART(MONTH,DATANASCIMENTO)<= DATEPART(MONTH,GETDATE()) AND DATEPART(DAY,DATANASCIMENTO)<= DATEPART(DAY,GETDATE()) "
			sql = sql & "        THEN (DATEDIFF(YEAR,DATANASCIMENTO,GETDATE())) "
			sql = sql & "        ELSE (DATEDIFF(YEAR,DATANASCIMENTO,GETDATE()))- 1 "
		    sql = sql & "     END  >= " & strIdadeInformada
		end if	
	end if	

     if strOpcaoRelatorio = "1" then       'Para Filtrar somente os alunos que devem documentos
	   	sql = " SET NOCOUNT ON "
	   	sql = sql & " SELECT DISTINCT COD_ALUNO "
	   	sql = sql & " INTO #TEMP "
	   	sql = sql & " FROM SCA_ALUNO_DOCUMENTACOES "
       	sql = sql & " WHERE (SITUACAO = 'I' OR SITUACAO IS NULL) "
	end if  
	
    if strOpcaoRelatorio = "2" then       'Para Filtrar somente os alunos Conforme a Posição Financeira
			
		sql = " SET NOCOUNT ON "	
		sql = sql & " SELECT DISTINCT D.COD_ALUNO, T.NOMETURMA, A.NOMEALUNO "
	   	sql = sql & " INTO #TEMP "
		sql = sql & " FROM SCF_DEBITOALUNO D "
		sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = D.COD_ALUNO AND A.COD_EMPRESA = D.COD_EMPRESA "
		sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA = D.COD_TURMA "
		sql = sql & " LEFT JOIN SCF_TIPOPARCELA TP ON TP.COD_TIPO = D.COD_TIPOPARCELA and TP.COD_EMPRESA = D.COD_EMPRESA "
		sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular "
		sql = sql & " LEFT JOIN SCA_PERIODO P ON GC.Cod_Periodo = P.Cod_Periodo "
		sql = sql & " WHERE D.COD_EMPRESA = " & Session("CodEmpresa")
		if strCodParcelaInicial <> "0" then
		 	sql = sql & " and (D.PARCELA >= " & strCodParcelaInicial
		 	sql = sql & " and D.PARCELA <= " & strCodParcelaFinal & ")"
		end if
		if strAnoInicial <> "0" then
			sql = sql & " and (D.ANO >= " & strAnoInicial
			sql = sql & " and D.ANO <= " & strAnoFinal & ")"
		end if
		
		if intCodCurso <> "0" then
			sql = sql & " and P.COD_CURSO = " & intCodCurso
		end if
		if intCodPeriodo <> "0" then
			sql = sql & " and P.COD_PERIODO = " & intCodPeriodo
		end if
		if intCodTurno <> "0" then
			sql = sql & " and T.COD_TURNO = " & intCodTurno
		end if
		if intCodTurma <> "0" then
		sql = sql & " and D.COD_TURMA = " & intCodTurma
		end if
		if intCodTipoParcela <> "0" then
			sql = sql & " and D.COD_TIPOPARCELA = " & intCodTipoParcela
		end if
		if strStatusFinanceiro <> "0" then
			sql = sql & " and D.COD_SITUACAO_PAGAMENTO = " & strStatusFinanceiro
		end if   
		sql = sql & " order by T.NOMETURMA, A.NOMEALUNO "
	end if
	
   sql = sql & " SELECT SCA_ALUNO.CODIGO, "'0
   sql = sql & " SCA_ALUNO.MATRICULA, "'1
   sql = sql & " SCA_ALUNO.NOMEALUNO, "'2
   sql = sql & " SCA_ALUNO.FONERESIDENCIAL, "'3
   sql = sql & " SCA_ALUNO.DATAMATRICULA , "'4
   sql = sql & " SCA_PERIODO.DESCRICAO AS PERIODO, "'5
   sql = sql & " SCA_CURSO.DESCRICAO AS CURSO, "'6
   sql = sql & " SCA_TURMA.COD_TURMA, "'7
   if intCodDisciplinaTurma <> "" and intCodDisciplinaTurma <> "0" then
   		sql = sql & " cast(SCA_TURMA.NomeTurma as varchar) + ' - ' + cast(SCA_DISCIPLINA.Desc_Disciplina as varchar) AS NomeTurma, "'8 
   else		
   		sql = sql & " SCA_TURMA.NomeTurma, "'8
   end if
   sql = sql & " SCA_TURMA.NomeTurma + ' - ' + ISNULL(SCA_ALUNO.COMP_ENDERECO,' ') +' '+ ISNULL(SCA_ALUNO.NUMERO_ENDERECO,' ') as logradouro, "'9
   sql = sql & " ISNULL(SCA_ALUNO.LOGRADOURO,' ') + ', ' + ISNULL(SCA_ALUNO.COMP_ENDERECO,' ') +' '+ ISNULL(SCA_ALUNO.NUMERO_ENDERECO,' ') as logradouro, "'9
   sql = sql & " SCA_ALUNO.NUMERO_ENDERECO, "'10
   sql = sql & " SCA_ALUNO.COMP_ENDERECO, "'11
   sql = sql & " cast(SCA_ALUNO.MATRICULA as varchar) + ' - ' + cast(SCA_TURMA.NomeTurma as varchar) as matriculaTurma, "'12
   sql = sql & " cast(BAIRROALUNO as varchar) + ' - ' + cast(CEPRESIDENCIA as varchar) as cepBairro, "'13
   sql = sql & " SCF_UF.SIGLA AS UFRESIDENCIA, "'14
   sql = sql & " cast(CIDADERESIDENCIA as varchar) + ' - ' + cast(SCF_UF.SIGLA as varchar) as cidadeUF, "'15
   sql = sql & " SCA_ALUNO.FONECOMERCIAL, "'16
   sql = sql & " SCA_ALUNO.FONECELULAR	"'17
   sql = sql & " FROM SCA_ALUNO_TURMA "
   sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
   sql = sql & " LEFT JOIN SCF_UF ON SCF_UF.CODIGO = SCA_ALUNO.UFRESIDENCIA"
   sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
   sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
   sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
   sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
   if (strOpcaoRelatorio = "0" or strOpcaoRelatorio = "1" or strOpcaoRelatorio = "2") then    'Para Filtrar somente os alunos conforme condição acima
	   sql = sql & " INNER JOIN #TEMP TMP ON TMP.COD_ALUNO = SCA_ALUNO.CODIGO  "
   end if   
   if intCodDisciplinaTurma <> "" and intCodDisciplinaTurma <> "0" then
		sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO = SCA_ALUNO_TURMA.COD_TURMA AND SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplinaTurma
		sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.Cod_Disciplina = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
   end if	
   sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
   sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
   sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
   sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
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
	  sql = sql & " Order By SCA_TURMA.NomeTurma, SCA_ALUNO.BAIRROALUNO"
   end if
  	vetAlunos = null
	rs.open sql, cnn
	if not rs.eof then
		vetAlunos = rs.getRows
	end if
	rs.close

	if isArray(vetAlunos) then
		intPosicao = 0
		intPosicaoQuebra = 0
		registros = ubound(vetAlunos,2) 
		if registros = 0 then
		   registros = registros + 1
		end if   
		totalLinhas = registros/colunaPorPagina
		if totalLinhas = 0 then 
		   totalLinhas = 1
		end if   
		if totalLinhas - int(totalLinhas) <> 0 then
		   totalLinhas = int(totalLinhas) + 1
		end if   
		
		%><table border="0" cellspacing="0" cellpadding="0"><%
		for linha=0 to totalLinhas-1
			%>
            <tr>
                <!-- inicio espaço -->
                <td height="<%=tamanhoVertical%>" width="8"></td>
                <!-- fim espaço -->
            <%
			for coluna=0 to colunaPorPagina -1

			    if coluna = 0 then
				   EspacoEntreEtiquetas = ""
				else
				   EspacoEntreEtiquetas = tamanho_espaco
				end if   
				   

				strCampo1 = ""
				strCampo2 = ""
				strCampo3 = ""	
				strCampo4 = ""	
				strCampo5 = ""
				strCampo6 = ""
				
				if intPosicao <= ubound(vetAlunos,2) then
					if campo1 <> "" then strCampo1 = vetAlunos(campo1,intPosicao)
					if campo2 <> "" then strCampo2 = vetAlunos(campo2,intPosicao)
					if campo3 <> "" then strCampo3 = vetAlunos(campo3,intPosicao)	
					if campo4 <> "" then strCampo4 = vetAlunos(campo4,intPosicao)	
					if campo5 <> "" then strCampo5 = vetAlunos(campo5,intPosicao)
					if campo6 <> "" then strCampo6 = vetAlunos(campo6,intPosicao)
				end if	
				%>
                 <!-- inicio etiqueta -->
                <td height="<%=tamanhoVertical%>" width="<%=tamanhoHorizontal%>">
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo1%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo2%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo3%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo4%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo5%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo6%>&nbsp;</NOBR></DIV>
                </td>
                <!-- fim etiqueta -->
                <!-- inicio espaço -->
                <td height="<%=tamanhoVertical%>" width="<%=espaco%>" ><img width="<%=espaco%>" src="../../images/espacoEtiqueta.jpg"></td>
                <!-- fim espaço -->
			<%
				intPosicao = intPosicao + 1
			
			next
			%></tr><%
				
			intPosicaoQuebra = intPosicaoQuebra + 1
			if cInt(linhaPorPagina) = cInt(intPosicaoQuebra) then
				intPosicaoQuebra = 0
				response.Write("</table><pre>&nbsp;</pre><table border='0' cellspacing='0' cellpadding='0'>")
			end if

		next
		%></table><% 
	else
		%>
		<script>
			alert("Nenhum registro foi encontrado para esse relatório!");
			window.navigate('Rel_EtiquetasPorTurma_con.asp');
		</script>
		<%
	end if
	%> 

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
