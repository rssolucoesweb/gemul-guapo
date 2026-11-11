<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
strPaginaDestino = ""
%>
<%
strAnoCab = Trim(Request.QueryString("AnoLetivo"))
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
</head>
<body>
<script src="js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="js/js_dragdrop.js"></script>

<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))

	strclasse				= "celula"
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
	strlpp					= 40

	if intCodComp = "" then intCodComp = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	'verifica se tem mensagem configurada
	sql = "select m.quantidade_maior, m.mensagem "
	sql = sql & " from SEG_CONFIGURAR_MENSAGEM m "
	sql = sql & " inner join SEG_CONFIGURAR_MENSAGEM_PERFIL p on p.cod_configurar_mensagem = m.codigo "
	sql = sql & " where 1=1"'p.cod_perfil in (" & Session("CodPerfilUsuario") & ")"
	sql = sql & " and m.tipo = 'QUANTIDADE_FALTAS'"
	'sql = sql & " and m.cod_grupo = " & session("CodGrupo")
	rsAux.open sql, cnn
	if not rsAux.eof then
		mensagemAlerta = rsAux("mensagem")
		quantidadeMaior = rsAux("quantidade_maior")
	end if
	rsAux.close
	
	strTituloRelatorio  	= "ALUNOS COM MAIS DE " & quantidadeMaior & " FALTAS"

	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<div class="table-responsive-lg">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td width="7%" align="center" class="<%=strclasse%>"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
	    <td width="20%" class="<%=strclasse%>"><div align="center"><strong>Nome do Aluno</strong></div></td>
		<td width="25%" align="center" class="<%=strclasse%>"><div align="center"><strong>Unidade</strong></div></td>
	    <td width="15%" align="center" class="<%=strclasse%>"><strong>Período</strong></td>
		<td width="10%" align="center" class="<%=strclasse%>"><strong>Turma</strong></td>
	    <td width="9%" align="center" class="<%=strclasse%>"><strong>Faltas</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table></div>")
	end Sub
%>
<%
	intPagina = 1
	mostraCabecalho
	cont = 0
	intCodTurma = 0
	quantidadeMaior = 30
	sql = "exec SP_SCA_AlunosFaltantes " & session("strAnoLetivo") & "," & session("strSemestre") & "," & session("codGrupo") & "," & session("codEmpresa") & "," & quantidadeMaior & "," & intCodTurma & "," & intCodCurso

	rs.open sql, cnn
	if not rs.eof then
		While not rs.eof
	

			%>
			  <tr>
				<td class="<%=strclasse%>" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
				<td class="<%=strclasse%>" align="left"><%=rs("aluno_completo")%>&nbsp;</td>
				<td class="<%=strclasse%>" align="left"><%=rs("empresa")%>&nbsp;</td>
				<td class="<%=strclasse%>" align="left"><div align="center"><%=RS("PERIODO_COMPLETO")%>&nbsp;</div></td>
				<td class="<%=strclasse%>" align="left"><div align="center"><%=RS("TURMA")%>&nbsp;</div></td>
			    <td align="center" class="<%=strclasse%>"><div align="center"><%=RS("FALTAS")%>&nbsp;</div></td>
			  </tr>
			<%
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = int(strlpp) then
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
			<td colspan="6" class="<%=strclasse%>">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="6" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
</div>
<script>
	aguarde.style.display="none";
</script>
