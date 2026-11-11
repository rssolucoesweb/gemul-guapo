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


	strNomeArquivo		= "Empresas.xml"
	strPastaArquivos	= server.MapPath("../../Apontamento")
	strPastaArquivos 	= strPastaArquivos & "\" & Session("CodEmpresa")
	strDominiolink       = trim(Request.ServerVariables("SERVER_NAME"))
	
	Set file = Server.CreateObject("Scripting.FileSystemObject")

	'Cria a pasta de acordo com codigo da Empresa
	Pasta = Server.MapPath("../../Apontamento") & "\" & Session("CodEmpresa")
	IF Not file.FolderExists(Pasta) THEN
		file.CreateFolder(Pasta)
	END IF

	strCaminho = strPastaArquivos & "\" & strNomeArquivo
	if not file.FileExists(strCaminho) then
		Set outfile = file.CreateTextFile(strCaminho, True) 'Parâmetros: Caminho, OverWrite'
	else
		Set outfile = file.OpenTextFile(strCaminho, 2) 'Parâmetros: Caminho, Tipo de Abertura'
	end if
	
	strPaginaTitulo = "AtualizaEmpresaRepXML_cod.asp"

	sql = " SELECT " 
	sql = sql & " CODIGO AS CodEmpresa, "
	sql = sql & " SUBSTRING(RAZAOSOCIAL,1,50) AS RazaoSocial, "
	sql = sql & " SUBSTRING(RAZAOSOCIAL,1,50) AS NomeFantasia, "
	sql = sql & " SUBSTRING(CNPJ,1,20) AS CNPJ, "
	sql = sql & " 'ISENTO' AS InscEstadual, "
	sql = sql & " '' AS InscMunicipal, "
	sql = sql & " SUBSTRING(ENDERECO,1,50) AS Endereco, "
	sql = sql & " SUBSTRING(BAIRRO,1,30) AS Bairro, "
	sql = sql & " SUBSTRING(MUNICIPIO,1,40) AS Cidade, "
	sql = sql & " SUBSTRING(UF,1,2) AS Estado, "
	sql = sql & " SUBSTRING(TELEFONE,1,15) AS Telefone01, "
	sql = sql & " '' AS Telefone02, "
	sql = sql & " '' AS Telefone03 "
	sql = sql & " FROM SEG_EMPRESA " 
	sql = sql & " WHERE CODIGO = " & session("CodEmpresa")

	rs.open sql, cnn
	if not rs.eof then 
		strLinha1 = "<?xml version="1.0" encoding="utf-8"?><BR>"
		strLinha2 = ""
		While not rs.eof
			'cabeçalho
			if strLinha1 = "" then
				strLinha1 = "MATRICULA;DATA_NASCIMENTO;CODIGO_SEGURANCA;NOME;CURSO;RG;ORGAO;TURMA"
				outfile.WriteLine(strLinha1)
			end if
			strLinha2 = strLinha2 & "<Empresas>"
			strLinha2 = strLinha2 & "<Registro>"
			strLinha2 = strLinha2 & "<CodEmpresa>" & UCASE(TRIM(rs("CodEmpresa"))) & "</CodEmpresa>"
			strLinha2 = strLinha2 & "<RazaoSocial>" & UCASE(TRIM(rs("RazaoSocial"))) & "</RazaoSocial>"
			strLinha2 = strLinha2 & "<NomeFantasia>" & UCASE(TRIM(rs("NomeFantasia"))) & "</NomeFantasia>"
			strLinha2 = strLinha2 & "<CNPJ>" & UCASE(TRIM(rs("CNPJ"))) & "</CNPJ>"
			strLinha2 = strLinha2 & "<InscEstadual>" & UCASE(TRIM(rs("InscEstadual"))) & "</InscEstadual>"
			strLinha2 = strLinha2 & "<InscMunicipal>" & UCASE(TRIM(rs("InscMunicipal"))) & "</InscMunicipal>"
			strLinha2 = strLinha2 & "<Endereco>" & UCASE(TRIM(rs("Endereco"))) & "</Endereco>"
			strLinha2 = strLinha2 & "<Bairro>" & UCASE(TRIM(rs("Bairro"))) & "</Bairro>"
			strLinha2 = strLinha2 & "<Cidade>" & UCASE(TRIM(rs("Cidade"))) & "</Cidade>"
			strLinha2 = strLinha2 & "<Estado>" &  UCASE(TRIM(rs("Estado"))) & "</Estado>"
			strLinha2 = strLinha2 & "<Telefone01>" & UCASE(TRIM(rs("Telefone01"))) & "</Telefone01>"
			strLinha2 = strLinha2 & "<Telefone02>" & UCASE(TRIM(rs("Telefone02"))) & "</Telefone02>"
			strLinha2 = strLinha2 & "<Telefone03>" & UCASE(TRIM(rs("Telefone03"))) & "</Telefone03>"
			strLinha2 = strLinha2 & "</Registro>"
			outfile.WriteLine(strLinha2)
			cont = cont + 1
			rs.movenext
		wend
		strLinha2 = strLinha2 & "</Empresas>"
		outfile.WriteLine(strLinha2)
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
				  <a href="http://<%=strDominiolink%>/Apontamento/<%=Session("CodEmpresa")%>/<%=strNomeArquivo%>" target="_blank"><img src="../../images/salvar.gif"><br><strong><%=strNomeArquivo%></strong></a> </td>
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
