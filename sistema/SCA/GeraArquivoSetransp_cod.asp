<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: gerar setransp
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<%

	'on error resume next
	'------------------
	'PASTA DO ARQUIVO
	'------------------
	strDia = day(date)
	strMes = month(date)
	if len(day(date)) < 2 then strDia = "0" & day(date)
	if len(month(date)) < 2 then strMes = "0" & month(date)

	strNomeArquivo		= "SETRANSP_" & year(date) & strMes & ".TXT"
	strPastaArquivos	= server.MapPath("../../ArquivoSetransp")
	strPastaArquivos 	= strPastaArquivos & "\" & Session("CodEmpresa")
	strDominiolink       = trim(Request.ServerVariables("SERVER_NAME"))& "/gemul2015"
	
	Set file = Server.CreateObject("Scripting.FileSystemObject")

	'Cria a pasta de acordo com codigo do Imovel
	Pasta = Server.MapPath("../../ArquivoSetransp") & "\" & Session("CodEmpresa")
	IF Not file.FolderExists(Pasta) THEN
		file.CreateFolder(Pasta)
	END IF

	strCaminho = strPastaArquivos & "\" & strNomeArquivo
	if not file.FileExists(strCaminho) then
		Set outfile = file.CreateTextFile(strCaminho, True) 'Parâmetros: Caminho, OverWrite'
	else
		Set outfile = file.OpenTextFile(strCaminho, 2) 'Parâmetros: Caminho, Tipo de Abertura'
	end if
	
	strPaginaTitulo = "GeraArquivoSetransp_con.asp"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSimouNao      		= Trim(Request.Form("cmbSimouNao"))

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

	cont = 0
	
	sql = "SELECT SCA_ALUNO.LOGRADOURO, SCA_ALUNO.COMP_ENDERECO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE, "
	sql = sql & " SCA_ALUNO.NUMERO_ENDERECO, SCA_ALUNO.BAIRROALUNO, SCA_ALUNO.LOGRADOURO, SCA_ALUNO.CIDADERESIDENCIA, SCA_ALUNO.SETRANSP "
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
	sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & strSemestre & ")"

	if strSimouNao = "S" then
	    sql = sql & " and 	SCA_ALUNO.SETRANSP is not null"
	end if

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
 	sql = sql & " Order By SCA_ALUNO.NOMEALUNO"
	rs.open sql, cnn
	if not rs.eof then 
		strLinha1 = ""
		strLinha2 = ""
		strLinha3 = ""
		While not rs.eof
			'cabeçalho
			if strLinha1 = "" then
				strLinha1 = "01;" & UCASE(TRIM(session("EmpresaWeb"))) & ";" & UCASE(TRIM(session("NomeDiretorEmpresaWeb"))) & ";" & codEscolaSetransp
				outfile.WriteLine(strLinha1)
			end if

			'corpo
			strLinha2 = "02;"
			strLinha2 = strLinha2 & UCASE(TRIM(rs("NOMEALUNO"))) & ";" 
			strLinha2 = strLinha2 & formatadataAP(rs("DATANASCIMENTO")) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("MAE"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("MATRICULA"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("LOGRADOURO"))) & ";" 
			strLinha2 = strLinha2 & ";" 'quadra
			strLinha2 = strLinha2 & ";" 'lote
			strLinha2 = strLinha2 & UCASE(TRIM(rs("NUMERO_ENDERECO"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("COMP_ENDERECO"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("BAIRROALUNO"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("CIDADERESIDENCIA"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("SETRANSP"))) & "" 
			outfile.WriteLine(strLinha2)
			cont = cont + 1
			rs.movenext
		wend
		strLinha3 = "03;" & cont
		outfile.WriteLine(strLinha3)
	end if
	rs.close
	
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
  <table width="100%" height="300" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td align="center"><strong><font color="#000099" size="2" face="Arial, Helvetica, sans-serif">Clique 
				  com o bot&atilde;o direito do mouse no &iacute;cone abaixo<br /> 
			    e escolha a op&ccedil;&atilde;o 
				   ou &quot;salvar destino como...&quot; ou &quot;salvar link como...&quot; </font></strong> <br />
				  <br />
				  <a href="http://<%=strDominiolink%>/ArquivoSetransp/<%=Session("CodEmpresa")%>/<%=strNomeArquivo%>" target="_blank"><img src="../../images/salvar.gif"><br><strong><%=strNomeArquivo%></strong></a> </td>
			  </tr>
			  <tr>
				<td align="CENTER"><input type="button" name="cmdPrincipal"  value="Principal"  class="botao" <%=strDesabilitaPrincipal%> onClick="window.location='default.asp'"></td>
			  </tr>
			</table>
<br>
<script>
	aguarde.style.display="none";
</script>
<!--#include file="../rodape.asp"-->
</body>
</html>
