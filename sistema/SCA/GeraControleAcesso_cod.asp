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

	strNomeArquivo		= "LISTA.TXT"
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
	
	strPaginaTitulo = "GeraControleAcesso_con.asp"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))

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
	if intCodSituacaoAluno = "" then intCodSituacaoAluno = "0"

	cont = 0

	sql = "SET NOCOUNT ON "
	sql = sql & " SELECT DISTINCT COD_ALUNO, SITUACAO "
	sql = sql & " INTO #TEMP1 "
	sql = sql & " FROM SCA_BLOQUEIO_ALUNO "
	sql = sql & " WHERE SITUACAO = 'B'"
	sql = sql & " AND COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " SELECT SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.CTRVIACE, SCA_ALUNO.CODIGO, T.COD_ALUNO, T.SITUACAO "
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	sql = sql & " LEFT JOIN #TEMP1 T ON T.COD_ALUNO = SCA_ALUNO.CODIGO"
	sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
'	sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
'	sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & strSemestre & ")"
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
			intCodAluno = rs("CODIGO")
		    strCtrviace = rs("CTRVIACE")
			strDatanascimento =  rs("DATANASCIMENTO")
			strMatricula =  rs("MATRICULA")
			strSituacao =  rs("SITUACAO")
		    		    
            IF trim(strSituacao) = "B" THEN
		       bloqueio = "S"
		    ELSE
		       bloqueio = "N"
		    END IF	  

	        if strLinha1 = "" then		
                strLinha1="1010103000000???????????????????????????????????????????????"
				outfile.WriteLine(strLinha1)
				strLinha2="01010" & "1" & "000000000" & "9999999999" & "?" & "01" & "????101?????????????????????????"
				outfile.WriteLine(strLinha2)
		    end if	
				
            if Bloqueio = "S" then
               Trava = "0"
               Msg   = "02"
            else
               Trava= "1"
               Msg=  "01"   ' Recebe msg de ACESSO LIBERADO
            end if
  				
			if len(strmatricula) <> 9 then
			   if len(strmatricula) = 5 then
			      strmatricula = "0000" & strmatricula
			   else 
			      strmatricula = "000" & strmatricula
			   end if	  	   
			end if   
				
		    if isnull(strCtrviace) or strCtrviace="" then
   			   matricula = strmatricula & "1"
            else
			   matricula= strmatricula & strCtrviace
            end if
 
             '  * Quando for:
             '  * Acesso Liberado - TRATAMENTO DE MENSAGENS
             '  *
            
            if month(strDatanascimento)=MONTH(DATE) and DAY(strDatanascimento)=DAY(DATE) then
			   msg="05" ' Recebe msg de FELIZ ANIVERSARIO
			end if   
            strLinha3="01010" & Trava & "000000000" & matricula & "?" & Msg & "????101?????????????????????????"
		    
			outfile.WriteLine(strLinha3)
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
				  <a href="<%=session("strCaminhoRaiz")%>/ControleAcessoAlunos/<%=Session("CodEmpresa")%>/<%=strNomeArquivo%>" target="_blank"><img src="../../images/salvar.gif"><br><strong><%=strNomeArquivo%></strong></a> </td>
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
