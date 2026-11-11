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

	strNomeArquivo		= "CARTEIRA-ESTUDANTIL.CSV"
	strPastaArquivos	= server.MapPath("../../CarteiraEstudantil")
	strPastaArquivos 	= strPastaArquivos & "\" & Session("CodEmpresa")
	strDominiolink       = trim(Request.ServerVariables("SERVER_NAME"))
	
	Set file = Server.CreateObject("Scripting.FileSystemObject")

	'Cria a pasta de acordo com codigo da Empresa
	Pasta = Server.MapPath("../../CarteiraEstudantil") & "\" & Session("CodEmpresa")
	IF Not file.FolderExists(Pasta) THEN
		file.CreateFolder(Pasta)
	END IF

	strCaminho = strPastaArquivos & "\" & strNomeArquivo
	if not file.FileExists(strCaminho) then
		Set outfile = file.CreateTextFile(strCaminho, True) 'Parâmetros: Caminho, OverWrite'
	else
		Set outfile = file.OpenTextFile(strCaminho, 2) 'Parâmetros: Caminho, Tipo de Abertura'
	end if
	
	strPaginaTitulo = "EmissaoCarteirinha_con.asp"
	strCodAluno		=	Trim(Request.form("chkAluno"))
	strDataAP		= request.Form("txtData")

	cont = 0
	sql = "SELECT DISTINCT "
	sql = sql & " A.MATRICULA, "
	sql = sql & " A.NOMEALUNO AS NOME, "
	sql = sql & " SUBSTRING(C.DESCRICAO,1,40) AS CURSO, "
	sql = sql & " ISNULL(A.IDENTIDADE, '') AS RG, "
	sql = sql & " ISNULL(A.IDENTIDADEORGAO, '') AS ORGAO, " 
	sql = sql & " '"&strDataAP&"' AS DATAVALIDADE, "
	sql = sql & " CASE WHEN LEN(A.MATRICULA) = 5 THEN   '0000'+CONVERT(VARCHAR(10),A.MATRICULA)+CONVERT(VARCHAR(10),ISNULL(A.CTRVIACE,'0')+1) " 
	sql = sql & "      WHEN LEN(A.MATRICULA) = 6 THEN  '000'+CONVERT(VARCHAR(10),A.MATRICULA)+CONVERT(VARCHAR(10),ISNULL(A.CTRVIACE,'0')+1) "
	sql = sql & "      ELSE CONVERT(VARCHAR(10),A.MATRICULA) + CONVERT(VARCHAR(10),ISNULL(A.CTRVIACE,'0')+1) "
	sql = sql & "      END  AS CODBARRA_10DG, "
	sql = sql & " ISNULL(A.CTRVIACE,'0')+1 AS NUMERODAVIA "
	sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD " 
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA=AD.COD_TURMA_REMANEJAMENTO AND T.Cod_Empresa = AD.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.Cod_Empresa = AD.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = GC.COD_PERIODO AND P.Cod_Empresa = AD.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.Cod_Empresa = AD.COD_EMPRESA "
	sql = sql & " WHERE AD.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " And 	A.codigo in (" & strCodAluno & ")"
	sql = sql & " ORDER BY CURSO, A.NOMEALUNO "	
	rs.open sql, cnn
	if not rs.eof then 
		strLinha1 = ""
		strLinha2 = ""
		While not rs.eof
			'cabeçalho
			if strLinha1 = "" then
				strLinha1 = "MATRICULA;NOME;CURSO;RG;ORGAO;DATA_VALIDADE;CODBARRA_10DG;NUMERODAVIA"
				outfile.WriteLine(strLinha1)
			end if

			'corpo
			strLinha2 = UCASE(TRIM(rs("MATRICULA"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("NOME"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("CURSO"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("RG"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("ORGAO"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("DATAVALIDADE"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("CODBARRA_10DG"))) & ";" 
			strLinha2 = strLinha2 & UCASE(TRIM(rs("NUMERODAVIA")))
			outfile.WriteLine(strLinha2)
			cont = cont + 1
			rs.movenext
		wend
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
				  &quot;salvar destino como...&quot; </font></strong> <br />
				  <br />
				  <a href="http://<%=strDominiolink%>/CarteiraEstudantil/<%=Session("CodEmpresa")%>/<%=strNomeArquivo%>" target="_blank"><img src="../../images/salvar.gif"><br><strong><%=strNomeArquivo%></strong></a> </td>
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
