	<!--#include file="../includes/inc_cnn.asp"-->
	<!--#include file="../includes/inc_formatadata.asp"-->
	<!--#include file="../includes/inc_log.asp"-->

	<%
	strUsuarioPortal 	= Trim(Request.Form("USUA_CODG"))
	strKey 	= Trim(Request.Form("txtKey"))
	strSenha			= Trim(Request.Form("txtSenhaNova"))
	strDataAtual		= formataDataBD(date) & " " & time
	
	'on error resume next
	cnn.begintrans

	strMensagem = "Senha alterado com sucesso!"
	
	if strSenha <> "" then
		
		sql = "Select senha from SEG_USUARIO_HISTORICO_SENHA"
		sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"
		sql = sql & " AND senha = '" & strSenha & "'"

		rs.open sql,cnn
		if rs.eof = false then
			%>
			<script>
				alert("Atenção: A senha não pode ser igual às suas últimas 3 senhas!");
				window.history.back();
			</script>
			<%
			response.end			
		end if
		rs.close		
	end if

	if strSenha <> "" then
		
		sql = "Select Usua_Codg from SEG_USUARIOS_SISTEMA"
		sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"
		sql = sql & " AND KEY_RECUPERAR_SENHA = '" & strKey & "'"
		rs.open sql,cnn
		if rs.eof then
			%>
			<script>
				alert("Atenção: não foi possível alterar a sua senha, tente novamente!");
				window.history.back();
			</script>
			<%
			response.end			
		end if
		rs.close	
		
		
		sql = "Update SEG_USUARIOS_SISTEMA set"
		sql = sql & " Usua_Info_Senha = '" & strSenha & "',"
		sql = sql & " Usua_data_alteracao_senha = '" & strDataAtual & "'"
		sql = sql & " where Usua_Codg = '" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql

		
		sql = "Select count(*) as qtde from SEG_USUARIO_HISTORICO_SENHA"
		sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"

		rs.open sql,cnn

		if rs.eof = false then
			intQtdeSenha 	= rs("qtde")
			if intQtdeSenha < 3 then
			
				'Insere uma nova senha no histórico de senhas
				sql = " INSERT INTO SEG_USUARIO_HISTORICO_SENHA"
				sql = sql & " (Usua_Codg,"
				sql = sql & " senha,"
				sql = sql & " usuario_incl,"
				sql = sql & " data_hora_incl,"
				sql = sql & " usuario_altr,"
				sql = sql & " data_hora_altr) Values ( "
				sql = sql & "'" & strUsuarioPortal & "'," 
				sql = sql & "'" & strSenha & "',"
				sql = sql & "'" & strUsuarioPortal & "'," 
				sql = sql & "'" & strDataAtual & "',"
				sql = sql & "'" & strUsuarioPortal & "'," 
				sql = sql & "'" & strDataAtual & "')"
				cnn.execute sql
				GravarLog sql
				
				else
				'Altera a senha mais antiga para a mais nova entrar na fila
				'Insere uma nova senha no histórico de senhas
				sql = " UPDATE SEG_USUARIO_HISTORICO_SENHA"
				sql = sql & " SET senha = '" & strSenha & "',"
				sql = sql & " usuario_altr = '" & strUsuarioPortal & "'," 
				sql = sql & " data_hora_altr = '" & strDataAtual & "'"
				sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"
				sql = sql & " AND  data_hora_altr in ( "
				sql = sql & "                          SELECT min(data_hora_altr) From SEG_USUARIO_HISTORICO_SENHA  "
				sql = sql & " 						   WHERE Usua_Codg = '" & strUsuarioPortal & "'"
				sql = sql & " 						  )"
				
				cnn.execute sql
				GravarLog sql
				
			end if
		end if
		rs.close 

		
	end if 
		
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		
		
		sql = "Select USUA_CODG, USUA_NOME_COMPLETO from SEG_USUARIOS_SISTEMA"
		sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"
		rs.open sql,cnn
		if rs.eof = false then
			Session("NomeUsuarioWeb")	= rs("USUA_NOME_COMPLETO")
			Session("UsuarioWeb")		= rs("USUA_CODG")
		end if
		rs.close	
		
		'GERAR KEY_RECUPERAR_SENHA
		sql = "SELECT NEWID() AS CodigoUnico"
		rs.open sql, cnn
		strkeynova = rs("codigoUnico")
		rs.close
		
		sql = "update SEG_USUARIOS_SISTEMA set KEY_RECUPERAR_SENHA = '" & strkeynova & "' where USUA_CODG='" & strUsuarioPortal & "'"
		CNN.EXECUTE sql
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='selecionar_escola.asp';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		if err.number = -2147217900 then
			%>
			<script>
				alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
				window.history.back();
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
			</script>
			<%
		end  if 	
	end if
%>