<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
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
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strAlunoSemSituacao     = Trim(Request.Form("AlunoSemSituacao"))

	strDataINasc			= formatadataAP(request.Form("txtDataINasc"))   
    strDataFNasc			= formatadataAP(request.Form("txtDataFNasc"))   
	strDataIAfast			= formatadataAP(request.Form("txtDataIAfast"))   
    strDataFAfast			= formatadataAP(request.Form("txtDataFAfast"))   
	strDataIMat				= formatadataAP(request.Form("txtDataIMat"))   
    strDataFMat				= formatadataAP(request.Form("txtDataFMat"))   

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "ALUNOS<br>Datas"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="45%" class="<%=strclasse%>"><div align="center"><strong>Nome do Aluno</strong></div></td>
		<td width="15%" class="<%=strclasse%>"><div align="center"><strong>Data Matr&iacute;cula </strong></div></td>
		<td width="15%" class="<%=strclasse%>"><div align="center"><strong>Data Afastamento </strong></div></td>
		<td width="15%" class="<%=strclasse%>"><div align="center"><strong>Data Nascimento </strong></div></td>
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
	intCodTurma = 0
	sql = "SELECT  DISTINCT   SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATAMATRICULA, SCA_ALUNO.DATAFASTAMENTO "
	sql = sql & " FROM SCA_ALUNO "
	sql = sql & " where SCA_ALUNO.cod_empresa = " & session("CodEmpresa")
	if strAlunoSemSituacao = "S" then
	  sql = sql & "and ISNULL(SCA_ALUNO.COD_SITUACAOALUNO, '0') = 0"
	else	    
	  if intCodSituacaoAluno <> "0" then
		  sql = sql & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	  end if 
	end if
	if strSexo <> "0" then
		sql = sql & " and SCA_ALUNO.SEXOALUNO = '" & strSexo & "'"
	end if
	if strDataINasc <> "" and strDataFNasc <> "" then
	   	sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATANASCIMENTO, 103),103) >=  convert(datetime, ' " & strDataINasc & "',103)"
        sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATANASCIMENTO, 103),103) <=  convert(datetime, ' " & strDataFNasc & "',103)"
	end if
	if strDataIAfast <> "" and strDataFAfast <> "" then
	   	sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATAFASTAMENTO, 103),103) >=  convert(datetime, ' " & strDataIAfast & "',103)"
        sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATAFASTAMENTO, 103),103) <=  convert(datetime, ' " & strDataFAfast & "',103)"
	end if
	if strDataIMat <> "" and strDataFMat <> "" then
	   	sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATAMATRICULA, 103),103) >=  convert(datetime, ' " & strDataIMat & "',103)"
        sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATAMATRICULA, 103),103) <=  convert(datetime, ' " & strDataFMat & "',103)"
	end if
	'ordem de classificação do relatorio
	 if strOrdem = "alfabetica" then
	 	sql = sql & " Order By SCA_ALUNO.NOMEALUNO"
	 elseif strOrdem = "matricula" then
	 	sql = sql & " Order By SCA_ALUNO.matricula"
	 elseif strOrdem = "datamatricula" then
	 	sql = sql & " Order By SCA_ALUNO.datamatricula"
	 elseif strOrdem = "dataafastamento" then
	 'verificar qual o campos data afastamento no cadastro
	 	sql = sql & " Order By SCA_ALUNO.NOMEALUNO"
	 elseif strOrdem = "idade" then
	 	sql = sql & " Order By SCA_ALUNO.DATANASCIMENTO"
	 elseif strOrdem = "bairro" then
	 	sql = sql & " Order By SCA_ALUNO.CIDADERESIDENCIA"
	 end if

	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td class="<%=strclasse%>" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
				<td class="<%=strclasse%>" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
				<td class="<%=strclasse%>" align="center"><%=formatadataAP(rs("DATAMATRICULA"))%>&nbsp;</td>
				<td class="<%=strclasse%>" align="center"><%=formatadataAP(rs("DATAFASTAMENTO"))%>&nbsp;</td>
				<td class="<%=strclasse%>" align="center"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
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
