<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
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
	
	intCodGrupo				= Session("CodGrupo") 		
	intCodRota 				= Trim(Request.Form("cmbRota"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	
	if intCodRota <> "" then
	
		sql = " SELECT SCA_ROTA.Cod_Rota, SCA_ROTA.Descricao, SRH_COLABORADOR.nome"
		sql = sql & " FROM SCA_ROTA INNER JOIN"
		sql = sql & " SRH_COLABORADOR ON SCA_ROTA.CodColaborador = SRH_COLABORADOR.codigo"
		sql = sql & " WHERE     SCA_ROTA.Cod_Grupo = " & intCodGrupo
		sql = sql & " AND SCA_ROTA.Cod_Rota = " & intCodRota
		rs.open sql, cnn
		if rs.eof = false then
			strNomeRota     = rs("Descricao")
			strMotorista	= rs("nome")
		end if
		rs.close
	
	end if 
	
	strTituloRelatorio  	= "Transporte Escolar <br> Rota - " & strNomeRota & "<br>Motorista: " & strMotorista
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="9%" align="center" class="celula"><strong>Matr&iacute;cula</strong></td>
		<td width="35%" class="celula"><strong>Nome do Aluno</strong></td>
		<td width="26%" class="celula"><strong>Nome da M&atilde;e </strong></td>
		<td width="11%" class="celula"><strong>Data Nascimento </strong>
	    <div align="center"></div></td>
		<td width="10%" align="center" class="celula"><strong>Telefone</strong></td>
		<td width="9%" align="center" class="celula"><strong>Turma</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	sql = " SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, "
	sql = sql & " SCA_ALUNO.MAE, SCA_ALUNO.FONERESIDENCIAL, SCA_ALUNO.RESPONSAVEL, SCA_ROTA_VICULA_ALUNO.CodTurma, "
    sql = sql & " SCA_ROTA_VICULA_ALUNO.cod_aluno, SCA_ROTA.CodColaborador, SCA_ROTA.Distancia_percorrida, SCA_TURMA.NomeTurma"
    sql = sql & " FROM  SCA_ALUNO INNER JOIN"
    sql = sql & " SCA_ROTA_VICULA_ALUNO ON SCA_ALUNO.CODIGO = SCA_ROTA_VICULA_ALUNO.cod_aluno "
    sql = sql & " INNER JOIN SCA_ROTA ON SCA_ROTA_VICULA_ALUNO.CodRota = SCA_ROTA.Cod_Rota"
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ROTA_VICULA_ALUNO.codTurma = SCA_TURMA.Cod_Turma"
	sql = sql & " WHERE SCA_ALUNO.COD_EMPRESA = " & session("CodEmpresa")
	
	if intCodRota <> "0" then
		sql = sql & " and SCA_ROTA_VICULA_ALUNO.CodRota = " & intCodRota
	end if
	
	if strOrdem = "alfabetica" then
		sql = sql & " Order By SCA_ALUNO.NOMEALUNO"
	elseif strOrdem = "Turma" then
		sql = sql & " Order By SCA_ROTA_VICULA_ALUNO.CodTurma"
	end if

	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td class="celula" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
				<td class="celula"><%=rs("MAE")%>&nbsp;</td>
				<td align="center" class="celula"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
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
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="6" class="celula">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td height="13" colspan="6" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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