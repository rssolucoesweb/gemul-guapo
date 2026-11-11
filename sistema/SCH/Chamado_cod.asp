<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Convênios - Modulação Folha de Pagamento
-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
    <!--#include file="../../includes/inc_cnnDocumento.asp"-->
    <!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_log.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
	intCodigo	 					= Trim(Request.Form("txtCodigo"))
	intCodEmpresa					= session("codEmpresa")
	strDataAbertura 				= formataDataBDAccess(Trim(Request.Form("txtDataAbertura")))
	intCodEmpresaGrupoUsuario		= Trim(Request.Form("cmdEmpresaGrupoUsuario"))
	strResponsavelAbertura			= Trim(session("UsuarioWeb"))
	intCodUsuarioChamado			= Trim(Request.Form("cmbUsuarioChamado"))
	srtSituacao						= Trim(Request.Form("cmbSituacao"))
	strPrioridade					= Trim(Request.Form("cmbPrioridade"))
	strOcorrencia					= Trim(Request.Form("txtOcorrencia"))
	intTipoServico					= Trim(Request.Form("chkTipoServico"))
	strGrupo						= Trim(Request.Form("cmbGrupo"))
	intSeq							= Trim(Request.Form("cmbSequencia"))
	
	if acao="I" then
		
		if intTipoServico <> "" then   
			vetTipoServico = split(intTipoServico,",")			 
		end if
		
		strMensagem = "Chamado Aberto com sucesso..."
		
		sql = " SET NoCount ON"	
		sql = sql & " Insert Into SCH_CHAMADO(Cod_empresa, DataAbertura, Ocorrencias,"
		sql = sql & " Cod_Usuario_Abertura, Cod_Usuario_Destino, pedido_por, sequencia_desenvolvimento, " 
		sql = sql & " Situacao, Prioridade )"

		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strDataAbertura & "',"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & strResponsavelAbertura & "',"
		sql = sql & "'" & intCodUsuarioChamado & "',"
		sql = sql & "'" & strGrupo & "',"
		sql = sql & "'" & intSeq & "',"
		sql = sql & "'" & srtSituacao & "',"
		sql = sql & "'" & strPrioridade & "'); SELECT @@IDENTITY"
	
		Set rs = cnn.Execute(sql)
		intCodChamado = rs(0)
		rs.close
		
		if intTipoServico <> "" then   
		
			for intCont = 0 to ubound(vetTipoServico)
				
				intCodTipoServico = trim(vetTipoServico(intCont))
							
				sql = " Insert Into SCH_CHAMADO_SERVICO(CodChamado, CodTipoServico)"
				sql = sql & " Values ("
				sql = sql & "" & intCodChamado & ","
				sql = sql & "" & intCodTipoServico & ")"
				cnn.execute sql
				GravarLog sql
			
			next
		
		end if

		strEmailAbertura = ""
		strEmailChamado = ""
		strEmailDiretor = ""
		
		SQL = "SELECT USUA_EMAIL, USUA_NOME_COMPLETO FROM SEG_USUARIOS_SISTEMA WHERE USUA_CODG='" & strResponsavelAbertura & "'"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			strEmailAbertura = RS("USUA_EMAIL")
			strNomeAbertura = RS("USUA_NOME_COMPLETO")
		END IF
		RS.CLOSE
		
		SQL = "SELECT USUA_EMAIL, USUA_NOME_COMPLETO FROM SEG_USUARIOS_SISTEMA WHERE USUA_CODG='" & intCodUsuarioChamado & "'"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			strEmailChamado = RS("USUA_EMAIL")
			strNomeChamado = RS("USUA_NOME_COMPLETO")
		END IF
		RS.CLOSE
		
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
		
		for i=0 to ubound(vetEmail)
			
			strEmail = vetEmail(i,0)
			strNome = vetEmail(i,1)
		
			if strEmail <> "" AND NOT ISNULL(strEmail) then
				
				
			   '****** CONFIGURAÇÃO DE EMAIL *****************
				servidorSMTP = "smtp-relay.sendinblue.com"
				usuarioSMTP  =  "suporte@gemul.com.br" 
				senhaSMTP    = "IOW5qh9Pdn3zvBFp" 
				NomeSMTP     = "GEMUL"
				'***********************
			
				nomeDestinatario=strNome
				emailDestinatario=strEmail
				nomeRemetente="Sistema GEMUL"
				emailRemetente="suporte@gemul.com.br" 'O endereço de e-mail deve ser preenchido com uma conta existente em seu próprio domínio.
				emailRetorno="suporte@gemul.com.br"
				responderPara="suporte@gemul.com.br"
				strAssunto="GEMUL - Abertura de chamado número " & intCodChamado
				strDadosEmail = "Olá " & strNome & ", tudo bem?<br><br>"
				strDadosEmail = strDadosEmail & "Um novo chamado foi aberto no sistema GEMUL por " & strNomeAbertura & " e foi encaminhado para " & strNomeChamado & ", com a seguinte ocorrência: <br><br>"
				strDadosEmail = strDadosEmail & "<b>" & strOcorrencia & "</b>"
				strDadosEmail = strDadosEmail & "<br><br>Qualquer dúvida, favor entrar no sistema e efetuar o acompanhamento na listas de chamados em aberto, número desse chamado é <b>" & intCodChamado & "</b>!"
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
			
					'DESTR?I OS OBJETOS 
					Set objCDOSYSMail = Nothing 
					Set objCDOSYSCon = Nothing 
			
				end if
			end if
		next
	
	elseif acao="A" then
	
		sql = "update SCH_CHAMADO set Ocorrencias = '" & strOcorrencia & "',"
		if intCodUsuarioChamado = "0" then
			sql = sql & " Cod_Usuario_Destino = null," 
		else
			sql = sql & " Cod_Usuario_Destino = '" & intCodUsuarioChamado & "'," 
		end if
		sql = sql & " Prioridade = '" & strPrioridade & "',"
		sql = sql & " sequencia_desenvolvimento = '" & intSeq & "',"
		sql = sql & " pedido_por = '" & strGrupo & "'"
		sql = sql & " Where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		strMensagem = "Chamado alterado com sucesso..."
		
	else
	
		strMensagem = "Chamado Excluido com sucesso..."
		
		sql = "Delete From SCH_CHAMADO_SERVICO "
		sql = sql & " Where CodChamado = " & intCodigo
		cnn.execute sql
		GravarLog sql
	
		
		sql = "Delete From SCH_CHAMADO "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_empresa = " & intCodEmpresa
		cnn.execute sql
		GravarLog sql

	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Chamado_cad.asp';
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