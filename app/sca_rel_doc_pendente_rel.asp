<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Documento pendente</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<br>
<%
	dim intPagina
	dim sEmail
	dim strAssunto
	dim sMsg
	dim cMail
	
	strTituloRelatorio  	= "Comunicado de Documentações Pendentes"
	strCod_empresa 			= Session("CodEmpresa")
	strCodAluno				= Trim(Request("txtCodAluno"))
	strEnviarNotificacao    = Trim(Request("txtEnviarNotificacao"))

	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	%>
	<!--#include file=includes/inc_cabecalhoRelatorio.asp-->
	<%
	
	if trim(strCodAluno) <> "" then
	    
		'Carregando email e domínio para envio de notificação.
		strDominio = ""	
		strEmailDominio = ""	
		sql=" SELECT DOMINIO, EMAIL_DOMINIO FROM SEG_EMPRESA "
		sql=sql & " WHERE CODIGO = " & Session("CodEmpresa") 
		rs.open sql, cnn
		if not rs.eof then
		   strDominio	= rs("DOMINIO")	
		   strEmailDominio	= rs("EMAIL_DOMINIO")
		   if isnull(strDominio) then strDominio = ""		
		   if isnull(strEmailDominio) then strEmailDominio = ""		
		end if
		rs.close	
	
		sql = " Select distinct Cod_aluno, ISNULL(EMAIL,'') as email_aluno "
		sql = sql & " From SCA_ALUNO_DOCUMENTACOES  AD "
		sql = sql & " inner JOIN SCA_DOCUMENTACOES Doc ON AD.Cod_documentacoes = Doc.Codigo "
		sql = sql & " inner JOIN SCA_ALUNO A ON A.CODIGO = AD.Cod_aluno "
		sql = sql & " Where AD.Cod_aluno in (" & strCodAluno & ")"
		sql = sql & " and (AD.situacao = 'I' or AD.situacao is null)"
		rs.open sql, cnn
		
		if rs.eof = false then
		
		while not rs.eof
		
			intCodAluno = rs("Cod_aluno")
			sEmail		= rs("email_aluno")
			%>
	<!--#include file="includes/inc_sqlDadosAluno.asp"-->
	<hr size="1">
	<table width="100%" border="0">
			<tr>
			<td height="224" align="center">
			<table width="93%" border="0">
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">Prezado(a) Aluno(a) ou 
			    Respons&aacute;vel</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">Consta em nossos arquivos  a falta do(s) seguintes(s) documentos: </td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">
				<%
				if strCodAluno <> "" then	%>
				
				  <table width="87%" align="center" border="0" cellpadding="0" cellspacing="0">
				   <%
					sql = " Select Cod_aluno, Cod_documentacoes, data_prorrogacao, situacao, doc.descricao "
					sql = sql & " From SCA_ALUNO_DOCUMENTACOES  AD "
					sql = sql & " inner JOIN SCA_DOCUMENTACOES Doc ON AD.Cod_documentacoes = Doc.Codigo "
					sql = sql & " Where AD.Cod_aluno = " & intCodAluno
					sql = sql & " and situacao = 'I'"
					rsAux.open sql, cnn
			
					if rsAux.eof = false then

						strMensagemDoc          = ""

						while not rsAux.eof
							%>
							<tr>
								<td width="6%" height="24" align="center">* </td>
								<td width="94%"><strong><%=rsAux("descricao")%>&nbsp;</strong></td>
							</tr>
							<%
							strMensagemDoc = strMensagemDoc & "  * " & rsAux("descricao") & "<BR>"
							rsAux.movenext
						wend
						strMensagemDoc = strMensagemDoc & "<BR>"
					end if 
					rsAux.close
				end if
				%>
				 </table>
				 <br>
			    </td>
			  </tr>
				  <tr>
					<td class="textoRelatorio">Toda documenta&ccedil;&atilde;o acima citada, dever&aacute; ser entregue em 01 (uma) c&oacute;pia e apresentada a ORIGINAL, junto &agrave; Secretaria desta  unidade, sendo devolvido ap&oacute;s confer&ecirc;ncia.</td>
			  </tr>
				  <tr>
					<td class="textoRelatorio">&nbsp;</td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">A n&atilde;o regulariza&ccedil;&atilde;o na Secretaria desta  unidade, o mais r&aacute;pido possivel, implicar&aacute; em san&ccedil;&otilde;es de natureza administrativa e a n&atilde;o <strong>renova&ccedil;&atilde;o da matr&iacute;cula </strong>para o ano subsequente.</td>
			  </tr>
				  <tr>
					<td class="textoRelatorio">&nbsp;</td>
				  </tr>
			  </table>
			  </td>
	  </tr>
	</table>
			<!--#include file="includes/inc_RepresentantesLegaisSecretaria.asp"-->
			<pre></pre>	
			<%
			rs.movenext
			if not rs.eof  then
			%>
				<!--#include file=includes/inc_cabecalhoRelatorio.asp-->
			<%
			end if
			
		wend
		else
		%>
		<script>
			alert("Não existe documentos em débito.")
			window.history.back()
		</script>
		
		<%
		end if 
		rs.close
	end if
		%>
</body>
</html>