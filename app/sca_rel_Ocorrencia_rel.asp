<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Ocorrências</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
</head>
<body>
<br>
<%
	dim intPagina
	dim strDepartamento

	dataInicial				= Trim(Request.Form("txtDataInicial"))
	dataFinal				= Trim(Request.Form("txtDataFinal"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strMatricula 			= Trim(Request("txtMatricula"))
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
	strTituloRelatorio  	= "OCORRÊNCIAS<br>		Período: " & formatadataAP(dataInicial) & " a " & formatadataAP(dataFinal)

	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="8%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="30%" class="celula"><div align="center"><strong>Nome do Aluno</strong></div></td>
		<td width="20%" class="celula"><div align="center"><strong>Ocorr&ecirc;ncia</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Usu&aacute;rio inclus&atilde;o </strong></div></td>
	    <td width="25%" class="celula" align="center"><strong>Data</strong></td>
	  </tr>
	<%
	end Sub
	
	sub quebraDepartamento() 
	%>
	  <tr bgcolor="#E2E2E2">
	    <td colspan="6" class="celula"><%=strDepartamento%>&nbsp;</td>
      </tr>
	<%
	end Sub	
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = "select a.matricula, a.nomealuno, o.ocorrencia, o.usuario_incl, o.dataocorrencia"
	sql = sql & " from sca_ocorrencia o"
	sql = sql & " left join sca_aluno a on a.codigo = o.cod_aluno "
	sql = sql & " where o.cod_empresa = " &  session("CodEmpresa")
	sql = sql & " and 	o.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and 	o.Semestre = " & intSemestre
	sql = sql & " and 	o.dataocorrencia >='" & formatadataBD(dataInicial) & "'"
	sql = sql & " and 	o.dataocorrencia <='" & formatadataBD(dataFinal) & "'"
	if strCodAluno <> "" then
		sql = sql & " and a.codigo = " & strCodAluno
	end if
	sql = sql & " order by "
	sql = sql & " 	o.dataocorrencia"
	rs.open sql, cnn
	if not rs.eof then 
		controle = 0
		contPorDepto = 0
		While not rs.eof
			%>
			<tr bgcolor="#FFFFCC"> 
			  <td class="celula" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
			  <td class="celula" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
			  <td class="celula"><%=RS("OCORRENCIA")%>&nbsp;</td>
			  <td class="celula"><%=RS("USUARIO_INCL")%>&nbsp;</td>
			  <td class="celula"><%=RS("DATAOCORRENCIA")%></td>
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
			contPorDepto = contPorDepto + 1
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
			<td colspan="6" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
