<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 05/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Relatorio - Comunicado de Documentação em Debito
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
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
<br>
<%
	dim intPagina
	dim sEmail
	dim strAssunto
	dim sMsg
	dim cMail
	
	strTituloRelatorio  	= "Documentações Pendentes - ESTÁGIO"
	strCod_empresa 			= Session("CodEmpresa")
	strCodAluno				= Trim(Request("txtCodAluno"))
	strEnviarNotificacao    = Trim(Request("txtEnviarNotificacao"))

	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	%>
	<!--#include file=../../includes/inc_cabecalhoRelatorio.asp-->
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
		sql = sql & " From SCA_ALUNO_DOCUMENTACOES_ESTAGIO  AD "
		sql = sql & " inner JOIN SCA_DOCUMENTACOES_ESTAGIO Doc ON AD.Cod_documentacoes = Doc.Codigo "
		sql = sql & " inner JOIN SCA_ALUNO A ON A.CODIGO = AD.Cod_aluno "
		sql = sql & " Where AD.Cod_aluno in (" & strCodAluno & ")"
		sql = sql & " and (AD.situacao = 'I' or AD.situacao is null)"
		rs.open sql, cnn
		
		if rs.eof = false then
		
		while not rs.eof
		
			intCodAluno = rs("Cod_aluno")
			sEmail		= rs("email_aluno")
			%>
	<!--#include file="../includes/inc_sqlDadosAluno.asp"-->
	<hr size="1">
	<table width="100%" border="0">
			<tr>
			<td height="224" align="center">
			<table width="93%" border="0">
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">Senhor(a) Aluno(a), </td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">&nbsp;</td>
			  </tr>
			  <tr>
				<td class="textoRelatorio">Comunicamos a V. S&ordf; que sua matr&iacute;cula nessa institui&ccedil;&atilde;o ainda se encontra irregular, por falta do(s) seguintes(s) documentos: </td>
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
					sql = sql & " From SCA_ALUNO_DOCUMENTACOES_ESTAGIO  AD "
					sql = sql & " inner JOIN SCA_DOCUMENTACOES_ESTAGIO Doc ON AD.Cod_documentacoes = Doc.Codigo "
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
					<td class="textoRelatorio">Toda documenta&ccedil;&atilde;o acima citada dever&aacute; ser apresentada  juntamente com ORIGINAL, que ser&aacute; devolvido ap&oacute;s confer&ecirc;ncia junto a Secretaria Geral.</td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">&nbsp;</td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">A n&atilde;o regulariza&ccedil;&atilde;o na Secretaria Geral, no prazo de 72 (setenta e duas ) horas a contar do recebimento desta, implicar&aacute; em san&ccedil;&otilde;es de natureza administrativas. </td>
				  </tr>
				  <tr>
					<td class="textoRelatorio">&nbsp;</td>
				  </tr>
			  </table>
			  </td>
	  </tr>
	</table>
			<!--#include file="../includes/inc_RepresentantesLegaisSecretaria.asp"-->
			<pre></pre>	
			<%
			

			if strEnviarNotificacao = "S" then

				strTitulo		= "Comunicado - Secretaria"
				strOrigem		= strEmailDominio
				strData 	 	=  formataDataAP(date)  & " " & time 
				strAssunto		= "Pedido de regularização de documentos junto a Secretaria Geral"
				strMensagem		=  " Senhor(a) Aluno(a), <BR>"
                strMensagem = strMensagem & "       Comunicamos a V. S&ordf; que sua matr&iacute;cula nessa institui&ccedil;&atilde;o ainda se encontra irregular, por falta do(s) seguintes(s) documentos: <BR><BR>"
				strMensagem = strMensagem & strMensagemDoc
				strMensagem = strMensagem & "       Toda documenta&ccedil;&atilde;o acima citada dever&aacute; ser apresentada  juntamente com ORIGINAL, que ser&aacute; devolvido ap&oacute;s confer&ecirc;ncia junto a Secretaria Geral. <BR><BR>"
				
				'
				strMsg = "<html>"
				strMsg = strMsg & "<head>"
				strMsg = strMsg & "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />"
				strMsg = strMsg & "<title>" & strTitulo & "</title>"
				strMsg = strMsg & "</head>"
				strMsg = strMsg & "<body>"
				strMsg = strMsg & "<strong>"& session("EmpresaWeb") &"</strong><br><br>"
				strMsg = strMsg & "<strong>* Notificação Eletrônica ( Não é necessário responder esse email )</strong><br><br>"
				strMsg = strMsg & "Assunto: " & strAssunto & "<br>"
				strMsg = strMsg & "Data do Envio: "& strData & "<br><br>"
				strMsg = strMsg & strMensagem & "<br>"
				strMsg = strMsg & "</body>"
				strMsg = strMsg & "</html>"
				
				' Enviar e-mail
				if strOrigem <> "" and sEmail <> "" and strAssunto <> "" and strMsg <> "" then 
					
					Set cMail = Server.CreateObject("Persits.MailSender") 
					'Servidor de SMTP 
					cMail.Host = "localhost" 
					'O endereço deve ser um e-mail existente no domínio de sua revenda.
					cMail.From = strOrigem 
					'Remetente 
					cMail.FromName = strDominio
					'Destinatario 
					cMail.AddAddress sEmail
					cMail.AddCC ""
					cMail.AddBcc ""
					'Assunto da mensagem 
					cMail.Subject = strAssunto
					'Corpo da mensagem 
					cMail.Body = strMsg
					cMail.IsHTML = true
					'On Error Resume Next 
					cMail.Send 
					Set cMail = nothing
			
				end if	
		
			end if
			
			rs.movenext
			if not rs.eof  then
			%>
				<!--#include file=../../includes/inc_cabecalhoRelatorio.asp-->
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