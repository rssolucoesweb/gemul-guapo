<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<!--#include file="../../../includes/inc_criptografia.asp"-->
<%
	
	'on error resume next
	'----------Inicia uma transao--------------
	cnn.begintrans
	
	acao 			= Trim(Request.QueryString("acao"))
	strCPF			= formataCpfBD(Trim(session("strUsuario")))
	strDataAlteracaoSenha	= request.Form("txtDataAlteracaoSenha")
	strSenhaNova	= request.Form("txtSenha")
	strSenhaAntiga	= request.Form("txtSenhaAntiga")
	
	'Descriptografica Senha
	if trim(strSenhaAntiga) <> "" then 
		strSenhaAntiga = FormatCripto(strSenhaAntiga,True)
	end if		

	'Descriptografica Senha
	if trim(strSenhaNova) <> "" then 
		strSenhaNova = FormatCripto(strSenhaNova,True)
	end if			

	' Dados do Usuario	
	strUsuario_incl 		= session("strUsuario")	
	strData_hora_incl 		= formataDataBd(date) & " " & time
	strUsuario_altr 		= session("strUsuario")
	strData_hora_altr		= formataDataBd(date) & " " & time
	
	if acao="A" then

		'valida senha antiga com a senha cadastrada anteriormente no cadastro
		sql = " SELECT senha"
		sql = sql & " FROM SEG_usuarios" 
		sql = sql & " WHERE cpf = " & formataCpfBD(strCPF)
		'sql = sql & " AND senha <> '" & strSenhaAntiga & "'"
		rs.open sql , cnn		
		if not rs.eof then
			rs.close		
			%>
			<script>
				alert("Senha antiga esta incorreta.");
				//window.history.back();
			</script>
			<%			
			'response.End()
		else
			rs.close		
		end if

		'valida a troca de senha no poder ser igual as 3 ultimas informadas
		if trim(strSenhaNova) <> "" and trim(strDataAlteracaoSenha) <> "" then
			sql = "Select senha from SEG_historico_senha"
			sql = sql & " WHERE cpf_SEG_usuarios = " & strCPF
			sql = sql & " AND 	senha = '" & strSenhaNova & "'"
			rs.open sql,cnn
			if rs.eof = false then
				rs.close		
				%>
				<script type="text/javascript">
					alert("A senha no pode ser igual as suas últimas 3 senhas!");
					window.history.back();
				</script>
				<%
				'response.end			
			end if
			rs.close		
				
			sql = "Select count(*) as qtde from SEG_historico_senha"
			sql = sql & " WHERE cpf_SEG_usuarios = " & strCPF
			rs.open sql,cnn
			if rs.eof = false then
				intQtdeSenha 	= rs("qtde")
				if intQtdeSenha < 3 then
					'Insere uma nova senha no histrico de senhas
					sql = " INSERT INTO SEG_historico_senha"
					sql = sql & " (cpf_SEG_usuarios,"
					sql = sql & " senha,"
					sql = sql & " usuario_incl,"
					sql = sql & " data_hora_incl,"
					sql = sql & " usuario_altr,"
					sql = sql & " data_hora_altr) Values ( "
					sql = sql & "" & strCPF & "," 
					sql = sql & "'" & strSenhaNova & "',"
					sql = sql & "'" & strUsuario_incl & "'," 
					sql = sql & "'" & strData_hora_incl & "',"
					sql = sql & "'" & strUsuario_incl & "'," 
					sql = sql & "'" & strData_hora_incl & "')"
					cnn.execute sql
					
				else
					'Altera a senha mais antiga para a mais nova entrar na fila
					'Insere uma nova senha no histrico de senhas
					sql = " UPDATE SEG_historico_senha"
					sql = sql & " SET senha = '" & strSenhaNova & "',"
					sql = sql & " usuario_altr = '" & strUsuario_incl & "'," 
					sql = sql & " data_hora_altr = '" & strData_hora_incl & "'"
					sql = sql & " WHERE cpf_SEG_usuarios = " & strCPF
					sql = sql & " AND data_hora_altr in ("
					sql = sql & " SELECT min(data_hora_altr) From SEG_historico_senha  "
					sql = sql & " WHERE cpf_SEG_usuarios = " & strCPF
					sql = sql & " )"
					
					cnn.execute sql
					
				end if
			else
				'Insere uma nova senha no histrico de senhas
				sql = " INSERT INTO SEG_historico_senha"
				sql = sql & " (cpf_SEG_usuarios,"
				sql = sql & " senha,"
				sql = sql & " usuario_incl,"
				sql = sql & " data_hora_incl,"
				sql = sql & " usuario_altr,"
				sql = sql & " data_hora_altr) Values ( "
				sql = sql & "" & strCPF & "," 
				sql = sql & "'" & strSenhaNova & "',"
				sql = sql & "'" & strUsuario_incl & "'," 
				sql = sql & "'" & strData_hora_incl & "',"
				sql = sql & "'" & strUsuario_incl & "'," 
				sql = sql & "'" & strData_hora_incl & "')"
				cnn.execute sql				
			end if
			rs.close 	
		end if

		strMensagem = session("strMensagemAlteracao")
		
		sql = " Update SEG_usuarios Set "
		sql = sql & " Senha = '" & strSenhaNova & "',"
		sql = sql & " data_alteracao_senha = '" & strdata_hora_altr & "',"
		sql = sql & " data_ultimo_acesso = '" & strdata_hora_altr & "',"
			
		' Usuario do Sistema
		if strUsuario_altr <> "" then
			sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		else
			sql = sql & " usuario_altr = null,"
		end if 
	
		if strdata_hora_altr <> "" then
			sql = sql & " data_hora_altr = '" & strdata_hora_altr & "'"
		else
			sql = sql & " data_hora_altr = null"
		end if 
		
		sql = sql & " WHERE cpf = " & formataCpfBD(strCPF)


	end if

	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzao iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Seg_AlterarSenha_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='modulos/academico/Seg_cadastraUsr_cad.asp'"
	end if
%>