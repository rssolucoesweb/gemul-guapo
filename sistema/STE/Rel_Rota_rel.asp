<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
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
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	intCodGrupo				= Session("CodGrupo") 	
	intCodEmpresaUsuario	= Trim(Request.Form("cmdEmpresaUsuario"))
	intCodRota 				= Trim(Request.Form("cmbRota"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strAnoLetivo		 	= session("strAnoLetivo")
	strSemestre			 	= Trim(Request.Form("cmbSemestre"))
	if intCodRota = "" then intCodRota = "0"
	if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
	
	strTituloRelatorio  	= "Transporte Escolar - Rotas"
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="2%" align="center" class="celula"><strong>Matr&iacute;cula</strong></td>
		<td width="15%" class="celula"><strong>Aluno</strong></td>
		<td width="15%" class="celula"><strong>M&atilde;e </strong></td>
		<td width="15%" class="celula"><strong>Responsável </strong></td>
		<td width="5%" class="celula"><strong>Nascimento </strong></td>
		<td width="30%" class="celula"><strong>Endereço completo </strong></td>
		<td width="10%" align="center" class="celula"><strong>Telefone</strong></td>
		<td width="2%" align="center" class="celula"><strong>Turma</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	sql = " SELECT SCA_ALUNO.RESPONSAVEL, SCA_ALUNO.CEPRESIDENCIA, SCA_ALUNO.CIDADERESIDENCIA, SCA_ALUNO.BAIRROALUNO, SCA_ALUNO.COMP_ENDERECO, SCA_ALUNO.NUMERO_ENDERECO, SCA_ALUNO.LOGRADOURO, SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SRH_COLABORADOR.nome as motorista, SCA_ROTA.Descricao as rota,"
	sql = sql & " SCA_ALUNO.MAE, SCA_ALUNO.FONERESIDENCIAL, SCA_ALUNO.RESPONSAVEL, SCA_ROTA_VICULA_ALUNO.CodTurma, "
    sql = sql & " SCA_ROTA_VICULA_ALUNO.cod_aluno, SCA_ROTA.CodColaborador, SCA_ROTA.Distancia_percorrida, SCA_TURMA.NomeTurma, SEG_EMPRESA.razaosocial as unidade"
    sql = sql & " FROM  SCA_ALUNO "
    sql = sql & " INNER JOIN SCA_ROTA_VICULA_ALUNO ON SCA_ALUNO.CODIGO = SCA_ROTA_VICULA_ALUNO.cod_aluno "
    sql = sql & " INNER JOIN SCA_ROTA ON SCA_ROTA.COD_ROTA = SCA_ROTA_VICULA_ALUNO.CodRota"
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.codigo = SCA_ROTA.Cod_empresa"
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ROTA_VICULA_ALUNO.codTurma = SCA_TURMA.Cod_Turma"
	sql = sql & " left JOIN SRH_COLABORADOR ON SCA_ROTA.CodColaborador = SRH_COLABORADOR.codigo"
	sql = sql & " WHERE 1=1"
	if intCodEmpresaUsuario<>"0" then
		sql = sql & " and SCA_ALUNO.COD_EMPRESA = " & intCodEmpresaUsuario
	end if
	sql = sql & " and SCA_TURMA.AnoLetivo=" & 	strAnoLetivo
	
	if intCodRota <> "0" then
		sql = sql & " and SCA_ROTA_VICULA_ALUNO.CodRota = " & intCodRota
	end if
	
	if strOrdem = "alfabetica" then
		sql = sql & " Order By SEG_EMPRESA.razaosocial,SCA_ROTA.Descricao, SCA_ALUNO.NOMEALUNO"
	elseif strOrdem = "Turma" then
		sql = sql & " Order By SEG_EMPRESA.razaosocial,SCA_ROTA.Descricao, SCA_TURMA.NomeTurma, SCA_ROTA_VICULA_ALUNO.CodTurma"
	end if
	rota = ""
	unidade = ""
	controle = 0
	contPorUnidade = 0
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			if unidade <> rs("unidade") then
				IF controle = 1 then
					%>
					  <tr>
						<td colspan="8" class="celula">Quantidade de Alunos: <%=contPorUnidade%></td>
					  </tr>
					 <%
					fimTabela
					response.write "<pre>&nbsp;</pre>"
					mostraCabecalho
					contPorUnidade = 0
				end if
			%>
			  <tr>
				<td bgcolor="#cococo" height="35px" class="celula" colspan="8" align="left"><strong><%=rs("unidade")%></strong></td>
			  </tr>
			<%
				controle = 1
			end if
			if rota <> rs("rota") then
			%>
			  <tr>
				<td class="celula" colspan="8" align="left"><strong>Rota: <%=rs("rota")%><br>Motorista: <%=rs("motorista")%></strong></td>
			  </tr>
			<%
			end if
			endereco = RS("LOGRADOURO")
			if not (RS("NUMERO_ENDERECO") = "" or isnull(RS("NUMERO_ENDERECO"))) then
				endereco = endereco & ", " & RS("NUMERO_ENDERECO")
			end if
			if not (RS("COMP_ENDERECO") = "" or isnull(RS("COMP_ENDERECO")))  then
				endereco = endereco & ", " & RS("COMP_ENDERECO")
			end if
			bairro = ""
			if not (RS("BAIRROALUNO")  = "" or isnull(RS("BAIRROALUNO"))) then
				bairro =  RS("BAIRROALUNO")
			end if
			cidade = ""
			if not (RS("CIDADERESIDENCIA") = "" or isnull(RS("CIDADERESIDENCIA"))) then
				cidade = RS("CIDADERESIDENCIA") 
			end if
			if not (RS("CEPRESIDENCIA") = "" or isnull(RS("CEPRESIDENCIA")))  then
				endereco = endereco & ", CEP: " & RS("CEPRESIDENCIA")
			end if	
			%>
			  <tr>
				<td class="celula" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
				<td class="celula"><%=rs("MAE")%>&nbsp;</td>
				<td class="celula"><%=rs("RESPONSAVEL")%>&nbsp;</td>
				<td align="center" class="celula"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
				<td class="celula"><%=endereco%>&nbsp;</td>
				<td class="celula" align="center"><strong><%=rs("FONERESIDENCIAL")%>&nbsp;</strong></td>
				<td class="celula" align="center"><%=rs("NomeTurma")%>&nbsp;</td>
			  </tr>
			<%
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
			rota = rs("rota") 		
			unidade = rs("unidade") 			
			contPorUnidade = contPorUnidade + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="8" class="celula">Quantidade de Alunos: <%=contPorUnidade%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td height="13" colspan="8" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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