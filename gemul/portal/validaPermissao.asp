<%SESSION.Timeout = 1200%>
<!--
	::	IMOB
	::	Data de Criação...: 16/08/2004
	::	Desenvolvedores...: sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Valida o acesso ao sistema
	::	Desenvolvedores...: Iris Maria
	::	Data Atualizacao..: 22/11/2004
	::	Motivo Atualizacao: exclusão da tabela ave_ano_letivo_semestre
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
    ::	Data Atualizacao..: 11/03/2009
	::	Motivo Atualizacao: Criação de uma nova estrutura para acesso ao sistema/imob utilizando o CPF
-->
<title>..:: Portal de Sistemas ::..</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<head>
</head>
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_formataData.asp"-->
<!--#include file="../includes/inc_criptografia.asp"-->
<body>
<%
	session("Titulo") = "..:: Portal de Sistemas ::.."
	
	'Configuração regional do Brasil
	session.LCID=1046
	'**************** CONTROLE DAS DATAS DA SENHA
	intQtdeDiasExpirarSenha  = 45
	intQtdeDiasBloquearSenha = 60
	'****************	

	strLogin 						= "S" 'Variável utilizada na include inc_cnn.asp
	intCpfUsuario 					= Trim(Request.Form("txtlogin"))
	strSenha     					= Trim(Request.Form("txtSenha"))

	response.Cookies("usuarioLoginPortal") = intCpfUsuario
	response.Cookies("usuarioLoginPortal").Expires = date + 60	
	 
	if trim(intCpfUsuario) = "" then
		'Sem senha digitada
		Session("UsuarioWeb") 		= ""
		Session("PerfilUsuario")  	= ""
		%>
		<script>
			alert("O CPF deve ser informado, verifique!");
			window.location = '../../default.asp';
		</script>
		<%
		response.end()
	end if
	
	intCpfUsuario = replace(replace(intCpfUsuario,".",""),"-","")
	
	'VERIFICA SE O USUARIO ESTA CADASTRADO
	sql = " SELECT cpf, nome, situacao, codSecao, senha, data_ultimo_acesso, senhaTemporaria, data_alteracao_senha, data_ultimo_acesso, senhaNuncaExpira, email, telefone" 
	sql = sql & " FROM SEG_Usuarios" 
	sql = sql & " Where CPF = " & intCpfUsuario
	Rs.Open SQL, cnn
	if Rs.EOF then
		Rs.close
		'Não achou o usuário 
		Session("strUsuario") 		= ""
		Session("strEmailUsuario") 	= ""
		Session("strFoneUsuario") 	= ""
		Session("strUsuarioRodape") = ""
		Session("UsuarioWeb") 		= ""
		Session("PerfilUsuario")  	= ""
		Session("CodSecao")			= ""
		%>
		<script>
			alert("Usuário inválido, verifique!");
			window.location = '../../default.asp';
		</script>
		<%
		response.end
	else
		'VERIFICA SE FOI BLOQUEADO
		strSituacaoAcesso = rs("Situacao")
		if isnull(strSituacaoAcesso) then strSituacaoAcesso = "A"
		if trim(strSituacaoAcesso)="" then strSituacaoAcesso = "A"
		
		if trim(strSituacaoAcesso) = "B" then
			'Usuário bloqueado 
				Session("strUsuario") 		= ""
				Session("strEmailUsuario") 	= ""
				Session("strFoneUsuario") 	= ""
				Session("strUsuarioRodape") = ""
				Session("UsuarioWeb") 		= ""
				Session("PerfilUsuario")  	= ""
				Session("CodSecao")			= ""
			%>
			<script>
				alert("Usuário bloqueado!");
				window.location = '../../default.asp';
			</script>
			<%
			response.end()
		'VERIFICA SE FOI INATIVADO
		elseif trim(strSituacaoAcesso) = "I" then
			'Usuário bloqueado 
				Session("strUsuario") 		= ""
				Session("strEmailUsuario") 	= ""
				Session("strFoneUsuario") 	= ""
				Session("strUsuarioRodape") = ""
				Session("UsuarioWeb") 		= ""
				Session("PerfilUsuario")  	= ""
				Session("CodSecao")			= ""
			%>
			<script>
				alert("Usuário inativo!");
				window.location = '../../default.asp';
			</script>
			<%
			response.end()
		'VERIFICA SE ESTA ATIVO
		elseif trim(strSituacaoAcesso) = "A" then

			'VERIFICA SE O USUARIO ESTA CADASTRADO
			sql = " SELECT cpf" 
			sql = sql & " FROM SEG_Usuarios" 
			sql = sql & " Where CPF = " & intCpfUsuario
			sql = sql & " And Senha = '" & FormatCripto(strSenha,True) & "'"
			RsAux.Open SQL, cnn
			if RsAux.EOF then
				RsAux.close
				'Não achou o usuário 
				Session("strUsuario") 		= ""
				Session("strEmailUsuario") 	= ""
				Session("strFoneUsuario") 	= ""
				Session("strUsuarioRodape") = ""
				Session("UsuarioWeb") 		= ""
				Session("PerfilUsuario")  	= ""
				Session("CodSecao")			= ""
				%>
			 	<script>
				  alert("Senha incorreta!");
				  window.location='../../default.asp';
				</script>
		    	<%
				response.end
			end if
			RsAux.close
			
			'***** usuario válido!
			session("strUsuario")   			= rs("cpf")
			session("strNomeUsuario")  			= rs("cpf")
			Session("strEmailUsuario") 			= rs("email")
			Session("strFoneUsuario") 			= rs("telefone")
			Session("CodSecao")					= rs("codSecao")
			if trim(rs("nome")) = "" then
				session("strUsuarioRodape")   	= "Não Informado"
			else
				vetNome 							= split(trim(ucase(rs("nome")))," ")
				intPosicaoFinal 					= ubound(vetNome)
				if cInt(intPosicaoFinal) > 0 then
					session("strUsuarioRodape")   	= vetNome(0) & " " & vetNome(intPosicaoFinal)
				else
					session("strUsuarioRodape")   	= vetNome(0)
				end if
			end if
			'guarda a data do ultimo acesso anterior
			if trim(rs("data_ultimo_acesso")) = "" or isnull(rs("data_ultimo_acesso")) then
				Session("dataUltimoAcessoWeb") = "Primeiro acesso ao sistema"
			else
				Session("dataUltimoAcessoWeb") = "Último acesso: " & trim(rs("data_ultimo_acesso"))
			end if
			'Atualiza a data do ultimo acesso ao sistema
			sql = "Update SEG_Usuarios set data_ultimo_acesso = '" & formatadataBD(date) & " " & time &  "'"
			sql = sql & " where CPF = " & session("strUsuario")
			cnn.execute sql	

			session("strMensagemInclusao")  		= "Os dados foram incluídos com sucesso!" 
			session("strMensagemAlteracao") 		= "Os dados foram alterados com sucesso!" 
			session("strMensagemExclusao")  		= "Os dados foram excluídos com sucesso!" 
			session("strMensagemNaoEncontrado") 	= "Nenhum registro encontrado!"
			
			session("strUsuarioTemporario")		= ""
			'valida se o usuario foi setado a senha temporária
			'caso o usuario esteja em senha o sistema vai validar como sendo senha temporaria
			if trim(Rs("senhaTemporaria")) = "S" or trim(Rs("senha")) = "" or isnull(Rs("senha")) then
				session("strUsuarioTemporario") = session("strUsuario")
				rs.close				
				%>
			 	<script>
				  alert("Atenção!\nSenha temporária expirou. Favor informar nova senha.");
				  window.location='/gemul/portal/sistemas/seg/Seg_SenhaExpirou_cad.asp';
				</script>
		    	<%
				response.end()
			end if	
			
			'variaveis de validação de tempo de expiração da senha
			strDataUltimoAcesso 	= rs("data_ultimo_acesso")
			strDataAlteracaoSenha 	= rs("data_alteracao_senha")
			strSenhaNuncaExpira		= rs("senhaNuncaExpira")
			if isnull(strSenhaNuncaExpira) then strSenhaNuncaExpira = "N"
			rs.close	
			
			'desabilitado a pedido do jean (secretaria)
			strSenhaNuncaExpira = "S"
			
			if trim(strSenhaNuncaExpira) = "N" then
				' Verifica se o usuario expirou
				if isnull(strDataUltimoAcesso) = false and strDataUltimoAcesso<>"" then
					dataUltimoLogon = year(strDataUltimoAcesso) & "/"
					dataUltimoLogon = dataUltimoLogon & month(strDataUltimoAcesso) & "/"
					dataUltimoLogon = dataUltimoLogon & day(strDataUltimoAcesso)
				else
					dataUltimoLogon = ""
				end if
												
				if isNull(strDataAlteracaoSenha) = false then
					dataUltimaAlteracaoSenha = strDataAlteracaoSenha
				else
					dataUltimaAlteracaoSenha = ""
				end if
						
				DataHoje = year(date) & "/" & month(date) & "/" & day(date)
				if trim(dataUltimoLogon) <> "" then
					if datediff("d",dataUltimoLogon,DataHoje) > intQtdeDiasBloquearSenha then
						sql = "Update SEG_usuarios set situacao = 'B'"
						sql = sql & " where cpf = " & Session("UsuarioWeb")
						cnn.execute sql							
	
						Session("UsuarioWeb") 		= ""
						Session("PerfilUsuario")  	= ""
						%>
						<script>
							alert("Atenção!\nO usuário está Bloqueado!");
							window.location='../../default.asp';
						</script>
						<%
						response.end()
					end if
				end if
													
				bolMostrarMensagem = false
				
				if len(dataUltimaAlteracaoSenha) > 0 then
					if datediff("d",dataUltimaAlteracaoSenha,DataHoje) > intQtdeDiasExpirarSenha then
						session("strUsuarioTemporario") = session("strUsuario")
						%>
						<script>
							alert("Atenção!\nO sua senha expirou! Favor informar nova senha.");
							window.location='/gemul/portal/sistemas/seg/Seg_SenhaExpirou_cad.asp';
						</script>
						<%
						response.end()
					elseif datediff("d",dataUltimaAlteracaoSenha,DataHoje) >= intQtdeDiasExpirarSenha-5 then
						bolMostrarMensagem = true
						intTolatDias = intQtdeDiasExpirarSenha - datediff("d",dataUltimaAlteracaoSenha,DataHoje)
					end if
				end if
			else
				bolMostrarMensagem = false
			end if
			
			if bolMostrarMensagem = true then
				%>
				<script>
					if(confirm("Sua senha expira em <%=intTolatDias%> dias. Deseja alterá-la agora?")){
						<%
						session("strUsuarioTemporario") = session("strUsuario")
						%>
						window.location='/gemul/portal/sistemas/seg/Seg_SenhaExpirou_cad.asp';
					}else{
						window.location = 'validaGrupo.asp';
					}
				</script>
				<%
				response.end()
			else
				'Redireciona para a pagina de acesso a unidade de ensino	
				'usuario autorizado - grava log de acesso ao sistema
				strLog_UsuarioAcessoInicial = intCpfUsuario
				'GravarLog "Acessou o sistema", nomePagina(request.ServerVariables("SCRIPT_NAME"))
				%>
				<script>
					window.location = 'validaGrupo.asp';
				</script>
				<%
				response.End()
			end if
		end if
	end if

	'VERIFICAÇÃO DE ERRO'	
	if err.number <> 0 then
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='login.asp'"
	end if
%>
</body>