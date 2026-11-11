	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Fechamento Chamado
	-->
	<!--#include file="../includes/inc_verificaSession.asp"-->
	<!--#include file="../includes/inc_cnn.asp"-->
	<!--#include file="../includes/inc_replaceRequest.asp"-->
	<!--#include file="../includes/inc_log.asp"-->
    <!--#include file="../includes/inc_formatadata.asp"-->
	<%

	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
	intCodigo	 					= Trim(Request.Form("txtCodChamado"))
	intCodEmpresa					= session("codEmpresa")
	strOBs							= Trim(Request.Form("txtOBs"))
	intCodChamadoAbertura			= Trim(Request.Form("txtCodChamadoAbertura"))
	intCodUsuarioChamado			= Trim(Request.Form("cmbUsuarioChamado"))
	srtSituacao						= Trim(Request.Form("cmbSituacao"))
	strParecerSuporte				= Trim(Request.Form("cmbParecerSuporte"))
	strChamadoAbertura				= Trim(Request.Form("txtChamadoAbertura"))

	if acao="A" then
		
		strMensagem = "Chamando alterado com sucesso!"
		
		sql = "Update SCH_CHAMADO Set "
		
		if strOBs <> "" then
			sql = sql & " Observacao = '" & strOBs & "',"
		else 
			sql = sql &" Observacao = null ,"
		end if
		
		if intCodUsuarioChamado <> "" then
			sql = sql & " Cod_Usuario_Destino = '" & intCodUsuarioChamado & "',"
		else 
			sql = sql &" Cod_Usuario_Destino = null ,"
		end if
		
		if srtSituacao <> "" then
			sql = sql & " Situacao = '" & srtSituacao & "',"
		else 
			sql = sql &" Situacao = null, "
		end if

		if strParecerSuporte <> "" then
			sql = sql & " Visto_Gestor = '" & strParecerSuporte & "'"
		else 
			sql = sql &" Visto_Gestor = null "
		end if

		sql = sql & " Where Codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		strEmailAbertura = ""
		strEmailChamado = ""
		strEmailDiretor = ""
		intCodChamado = intCodigo
		
		SQL = "SELECT USUA_EMAIL, USUA_NOME_COMPLETO FROM SEG_USUARIOS_SISTEMA WHERE USUA_CODG='" & intCodUsuarioChamado & "'"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			strEmailChamado = RS("USUA_EMAIL")
			strNomeChamado = RS("USUA_NOME_COMPLETO")
		END IF
		RS.CLOSE
		
		strSituacaoDOChamado = "O chamado número <b>" & intCodChamado & "</b> foi alterada a situação para <b>Pendente</b> e está sendo acompanhado pelo <b>" & strNomeChamado & "</b>.<br><br>- Chamado: <strong>" & strChamadoAbertura & "</strong><br>- Interação: <b>" & strOBs & "</b>"

		if srtSituacao = "E" then
			sql = "Update SCH_CHAMADO Set "
			sql = sql & " DataExecucao = getdate()"
			sql = sql & " Where Codigo = " & intCodigo
			cnn.execute sql
			GravarLog sql
		   
			SQL = "SELECT USUA_EMAIL, USUA_NOME_COMPLETO FROM SEG_USUARIOS_SISTEMA WHERE USUA_CODG='" & intCodChamadoAbertura & "'"
			RS.OPEN SQL, CNN
			IF NOT RS.EOF THEN
				strEmailAbertura = RS("USUA_EMAIL")
				strNomeAbertura = RS("USUA_NOME_COMPLETO")
			END IF
			RS.CLOSE
		   	
			strSituacaoDOChamado = "O chamado número <b>" & intCodChamado & "</b> foi alterada a situação para <b>Executado</b> e já foi disponibilizado pelo <b>" & strNomeChamado & "</b> para os testes e homologação.<br><br- Chamado: <b>" & strChamadoAbertura & "</b><br>- Interação: <b>" & strOBs & "</b>"
		end if  
		
		sql = "Update SCH_CHAMADO Set "
		sql = sql & " DataAndamento = getdate()"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " and DataAndamento is null"
		cnn.execute sql
		GravarLog sql

		'----------------------------EMAIL------------------------------
		SQL = "SELECT USUA_EMAIL, USUA_NOME_COMPLETO FROM SEG_USUARIOS_SISTEMA WHERE USUA_CODG='NIVALDO'"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			strEmailDiretor = RS("USUA_EMAIL")
			strNomeDiretor = RS("USUA_NOME_COMPLETO")
		END IF
		RS.CLOSE
		
		dim vetEmail(3,2)

		vetEmail(0,0) = strEmailAbertura
		vetEmail(0,1) = strNomeAbertura

		vetEmail(1,0) = strEmailChamado
		vetEmail(1,1) = strNomeChamado

		vetEmail(2,0) = strEmailDiretor
		vetEmail(2,1) = strNomeDiretor
		
		'RESPONSE.Write "<BR>strEmailAbertura: " & strEmailAbertura
		'RESPONSE.Write "<BR>strEmailChamado: " & strEmailChamado
		'RESPONSE.Write "<BR>strEmailDiretor: " & strEmailDiretor
		'RESPONSE.END
		
		for i=0 to ubound(vetEmail)
			
			strEmail = vetEmail(i,0)
			strNome = vetEmail(i,1)
		
			if TRIM(strEmail) <> "" AND NOT ISNULL(strEmail) then
				
			   '****** CONFIGURAÇÃO DE EMAIL *****************
				servidorSMTP = "smtp-relay.sendinblue.com"
				usuarioSMTP  =  "suporte@gemul.com.br" 
				senhaSMTP    = "IOW5qh9Pdn3zvBFp" 
				NomeSMTP     = "GEMUL"
				'***********************
			
				nomeDestinatario	=strNome
				emailDestinatario	=strEmail
				nomeRemetente		="Sistema GEMUL"
				emailRemetente		="suporte@gemul.com.br" 'O endereço de e-mail deve ser preenchido com uma conta existente em seu próprio domínio.
				emailRetorno		="suporte@gemul.com.br"
				responderPara		="suporte@gemul.com.br"
				strAssunto			="GEMUL - Andamento do chamado número " & intCodChamado
				
				strDadosEmail = "Olá " & strNome & ", tudo bem?<br><br>"
				strDadosEmail = strDadosEmail & strSituacaoDOChamado
				strDadosEmail = strDadosEmail & "<br><br>Qualquer dúvida, favor entrar no sistema e efetuar o acompanhamento na listas de chamados em aberto!"
				strDadosEmail = strDadosEmail & "<br><br>"
				strDadosEmail = strDadosEmail & "<br>Atenciosamente."
				strDadosEmail = strDadosEmail & "<br><br>Equipe <b>GEMUL</b>"
				strEmailInvalido = "N"
				if not instr(strEmail,"@") > 0 then
					strEmailInvalido = "S"
				end if
				
				if strEmailInvalido = "N" then
					
					'CRIA A INSTANCIA COM O OBJETO CDOSYS 
					Set objCDOSYSMail = Server.CreateObject("CDO.Message") 
			
					'CRIA A INSTANCIA DO OBJETO PARA CONFIGURAÇÃO DO SMTP 
					Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration") 
			
					'SERVIDOR DE SMTP 
					objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = servidorSMTP
			
					'PORTA PARA COMUNICAÇÃO COM O SERVIÇO DE SMTP 
					objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 587
			
					'Utilização de SSl 
					'objCDOSYSCon.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
			
					objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
			
					'ATIVAR RECURSO DE SMTP AUTENTICADO 
					objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1 
			
					'USU?RIO PARA SMTP AUTENTICADO 
					objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusername") = usuarioSMTP
			
					'SENHA DO USUÁRIO PARA SMTP AUTENTICADO 
					objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendpassword") = senhaSMTP
			
					'TEMPO DE TIMEOUT (EM SEGUNDOS) 
					objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60 
			
					'ATUALIZA A CONFIGURAÇÃO DO CDOSYS PARA ENVIO DO E-MAIL 
					objCDOSYSCon.Fields.update 
					Set objCDOSYSMail.Configuration = objCDOSYSCon 
			
					'NOME DO REMETENTE, E-MAIL DO REMETENTE 
					'objCDOSYSMail.From = "Feegoweb <noreplay@feegoweb.com.br>" 
					objCDOSYSMail.From = NomeSMTP & " <" & usuarioSMTP & ">" 
			
					'NOME DO DESINATARIO, E-MAIL DO DESINATÁRIO 
					objCDOSYSMail.To  = strNome & " <" & strEmail & ">"
					objCDOSYSMail.cc  = "" 
					objCDOSYSMail.bcc = "" 
			
					'ASSUNTO DA MENSAGEM 
					objCDOSYSMail.Subject = strAssunto
			
					'CONTEÚDO DA MENSAGEM 
					'objCDOSYSMail.TextBody = "Teste do componente CDOSYS - Texto sem HTML" 
					'PARA ENVIO DA MENSAGEM NO FORMATO HTML, ALTERE O TextBody PARA HtmlBody 
					objCDOSYSMail.HtmlBody = "<html> <head><meta http-equiv=""Content-Type"" content=""text/html;charset=utf-8""></head><body>" & strDadosEmail & "</body></html>" 
			
					'ENVIA A MENSAGEM 
					objCDOSYSMail.Send			

		'RESPONSE.Write "<BR>strEmail: " & strEmail
			
					'DESTR?I OS OBJETOS 
					Set objCDOSYSMail = Nothing 
					Set objCDOSYSCon = Nothing 
					
					emailEnviados = emailEnviados & "\n" & strEmail
				end if
			end if
		next	

		emailEnviados = "\n\nEnviada para: " & emailEnviados
	end if
	'RESPONSE.End()

	if acao="E" then
		
		strMensagem = "Chamando Excluído com sucesso!"
		
		sql = "delete from SCH_CHAMADO "
		sql = sql & " Where Codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql

	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%><%=emailEnviados%>");
			window.opener.frm.submit();
			window.close();	
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>