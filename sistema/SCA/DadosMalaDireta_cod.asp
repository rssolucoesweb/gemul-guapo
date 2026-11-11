<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true
server.ScriptTimeout = 5000
%>
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

	strNomeArquivo		= "DADOS.TXT"
	strPastaArquivos	= server.MapPath("../../ControleAcessoAlunos")
	strPastaArquivos 	= strPastaArquivos & "\" & Session("CodEmpresa")
	
	Set file = Server.CreateObject("Scripting.FileSystemObject")

	'Cria a pasta de acordo com codigo do Imovel
	Pasta = Server.MapPath("../../ControleAcessoAlunos") & "\" & Session("CodEmpresa")
	IF Not file.FolderExists(Pasta) THEN
		file.CreateFolder(Pasta)
	END IF

	strCaminho = strPastaArquivos & "\" & strNomeArquivo
	if not file.FileExists(strCaminho) then
		Set outfile = file.CreateTextFile(strCaminho, True) 'Parâmetros: Caminho, OverWrite'
	else
		Set outfile = file.OpenTextFile(strCaminho, 2) 'Parâmetros: Caminho, Tipo de Abertura'
	end if
	
	strPaginaTitulo = "DadosMalaDireta_con.asp"
	
	if Trim(Request.Form("txtAnoLetivo")) = "" then 
	   intAnoLetivo 		= session("strAnoLetivo")
	else  
	   intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	end if   
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	strMes					= Trim(Request.Form("cmbMes"))
	strIdadeInformada   	= Trim(Request.Form("cmbIdade"))

	sql = ""
    if strOpcaoRelatorio = "1" then       'Para Filtrar somente os alunos que devem alguma parcela
	    sql = " SET NOCOUNT ON "
		sql = sql & " SELECT DISTINCT COD_ALUNO "
 	    sql = sql & " INTO #TEMP "
		sql = sql & " from SCF_DEBITOALUNO " 
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and COD_SITUACAO_PAGAMENTO  = 1 "
		sql = sql & " and convert(varchar(4),ANO)+ REPLICATE ( '0' ,2 - LEN(convert(varchar(2),PARCELA)))+ convert(varchar(2),PARCELA) <  '201001' "
    end if
    if strOpcaoRelatorio = "4" then       ' Somente parcelas que ainda não foram emitidas
	    sql = " SET NOCOUNT ON "
		sql = sql & " SELECT DISTINCT COD_ALUNO "
 	    sql = sql & " INTO #TEMP "
		sql = sql & " from SCF_DEBITOALUNO " 
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and COD_SITUACAO_PAGAMENTO  = 1 "
		sql = sql & " and convert(varchar(4),ANO)+ REPLICATE ( '0' ,2 - LEN(convert(varchar(2),PARCELA)))+ convert(varchar(2),PARCELA) =  '201001' "
		 sql = sql & " and NUMEROVIA = " & " '0' " 
    end if
	
    if strOpcaoRelatorio = "2" then       'Para Filtrar somente os alunos que devem documentos
	   sql = " SET NOCOUNT ON "
	   sql = sql & " SELECT DISTINCT COD_ALUNO "
	   sql = sql & " INTO #TEMP "
	   sql = sql & " FROM SCA_ALUNO_DOCUMENTACOES "
       sql = sql & " WHERE (SITUACAO = 'I' OR SITUACAO IS NULL)"
	end if   
	sql = sql & " SELECT "
	sql = sql & " A.CODIGO AS CONTROLE, "
	sql = sql & " T.NOMETURMA AS TURMA, "
	sql = sql & " A.MATRICULA, "
	sql = sql & " A.NOMEALUNO, "
	sql = sql & " A.DATAMATRICULA, " 
	sql = sql & " A.SEXOALUNO AS SEXO, "
	sql = sql & " A.DATANASCIMENTO, "
	sql = sql & " A.CIDADENASCIMENTO, "
	sql = sql & " UFN.Sigla AS UFNASCIMENTO, "
	sql = sql & " A.LOGRADOURO, "
	sql = sql & " A.NUMERO_ENDERECO, "
	sql = sql & " A.COMP_ENDERECO, "
	sql = sql & " A.BAIRROALUNO, "
	sql = sql & " A.CIDADERESIDENCIA, "
	sql = sql & " UFR.Sigla AS UFRESIDENCIA, " 
	sql = sql & " A.CEPRESIDENCIA, " 
	sql = sql & " A.PAI, "
	sql = sql & " A.MAE, "
	sql = sql & " SA.DESC_SITUACAOALUNO "
	sql = sql & " FROM SCA_ALUNO_TURMA AT "
	sql = sql & " INNER JOIN SCA_ALUNO A ON AT.COD_ALUNO = A.CODIGO "
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA " 
	sql = sql & " INNER JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma  AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo and P.cod_empresa = GC.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso and C.cod_empresa = P.cod_empresa "
    if (strOpcaoRelatorio = "1" or strOpcaoRelatorio = "2" or strOpcaoRelatorio = "4") then    'Para Filtrar somente os alunos conforme condição acima
	   sql = sql & " INNER JOIN #TEMP TMP ON TMP.COD_ALUNO = A.CODIGO "
	end if   
	sql = sql & " LEFT JOIN SCF_UF UFN ON UFN.CODIGO = A.UFNASCIMENTO "
	sql = sql & " LEFT JOIN SCF_UF UFR ON UFR.CODIGO = A.UFRESIDENCIA "
	sql = sql & " where T.cod_empresa = " & Session("CodEmpresa")
    sql = sql & " and AT.situacao = 'A' "
    if intAnoLetivo <> "" then
	   sql = sql & " AND T.ANOLETIVO = " & intAnoLetivo
	end if   
    if intSemestre <> "" then
	   sql = sql & " AND T.COD_SEMESTRE = " & intSemestre
	end if   
    if intCodCurso <> "0" then
	   sql = sql & " AND C.Cod_Curso = " & intCodCurso
	end if   

    if intCodPeriodo <> "0" then
	   sql = sql & " AND GC.Cod_Periodo = " & intCodPeriodo
	end if   
    if intCodTurma <> "0" then
	   sql = sql & " AND T.COD_TURMA = " & intCodTurma
	end if   
    if intCodSituacaoAluno <> "0" then
	   sql = sql & " AND A.COD_SITUACAOALUNO = " & intCodSituacaoAluno  
	end if
	if strOpcaoRelatorio = "0" then
	    sql = sql & " AND MONTH(A.DATANASCIMENTO) = " & strMes
	end if	
	sql = sql & " ORDER BY T.NOMETURMA, A.NOMEALUNO "
	rs.open sql, cnn
	if not rs.eof then 
       strLinha1 = ""
	   While not rs.eof
	     seleciona = ""
	     if strOpcaoRelatorio = "3" or strOpcaoRelatorio = "4" then       'Para Filtrar somente os alunos que estão em dias com suas parcelas
	        intCodAluno = trim(rs("CONTROLE"))
		    sql = " SELECT COD_SITUACAO_PAGAMENTO AS CODPGTO "
		    sql = sql & " from SCF_DEBITOALUNO "
		    sql = sql & " where COD_EMPRESA = " & Session("CodEmpresa")
		    sql = sql & " and COD_ALUNO = " & intCodAluno
	       sql = sql & " and convert(varchar(4),ANO)+ REPLICATE ( '0' ,2 - LEN(convert(varchar(2),PARCELA)))+ convert(varchar(2),PARCELA) <  '201001' "
            rsaux.open sql, cnn
	        if not rsaux.eof then 
               While not rsaux.eof
			      if trim(rsaux("CODPGTO")) = "1" or trim(rsaux("CODPGTO")) = "5" or trim(rsaux("CODPGTO")) = "6" then
			         seleciona = "N"
			      end if
			      rsaux.movenext
			   Wend	
			end if     
            rsaux.close
         end if

		 if strOpcaoRelatorio = "0" and strIdadeInformada <> "0" then
		    idade = calculaIdade(rs("DATANASCIMENTO"))
		    if idade < strIdadeInformada then
			   seleciona = "N"
			end if   
         end if
	     if seleciona = "" then
 		    strLinha2 = trim(rs("TURMA")) & ";"
		    strLinha2 = strLinha2 & trim(rs("MATRICULA")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("NOMEALUNO")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("DATAMATRICULA")) & ";"
		    strLinha2 = strLinha2 & trim(rs("SEXO")) &  ";"  
		    strLinha2 = strLinha2 & trim(rs("DATANASCIMENTO")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("CIDADENASCIMENTO")) & ";"
		    strLinha2 = strLinha2 & trim(rs("UFNASCIMENTO")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("LOGRADOURO"))  & ", " & trim(rs("NUMERO_ENDERECO"))  & ", " & trim(rs("COMP_ENDERECO")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("BAIRROALUNO")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("CIDADERESIDENCIA")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("UFRESIDENCIA")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("CEPRESIDENCIA")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("PAI")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("MAE")) & ";" 
		    strLinha2 = strLinha2 & trim(rs("DESC_SITUACAOALUNO")) & ";" 
	        if strLinha1 = "" then		
               strLinha1="TURMA;MATRICULA;NOME;DATAMATRICULA;SEXO;DATANASCIMENTO;CIDADENASCIMENTO;UFNASCIMENTO;ENDERECO;BAIRRO;CIDADE;UF;CEP;PAI;MAE;SITUACAO;"
		       outfile.WriteLine(strLinha1)
		    end if	
 		    outfile.WriteLine(strLinha2)
		 end if	
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
				  <a href="http://www.sisge.com.br/ControleAcessoAlunos/<%=Session("CodEmpresa")%>/<%=strNomeArquivo%>" target="_blank"><img src="../../images/salvar.gif"><br><strong><%=strNomeArquivo%></strong></a> </td>
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
