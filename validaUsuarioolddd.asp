<%
	'Configuração regional do Brasil
	session.LCID = 1046

	'Armazena o caminho da raiz do banco
	session("Titulo") = "GEMUL"
	
	session("strCaminhoRaiz")  = "http://" & Request.ServerVariables("SERVER_NAME") 
%>
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formataData.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%

	strUsuario 				=  Trim(Request.Form("txtLogin"))
	strSenha 				=  Trim(Request.Form("txtSenha"))
	
	response.Cookies("usuarioLoginSisge") = strUsuario
	response.Cookies("usuarioLoginSisge").Expires = date + 60
	
	session("strMensagemInclusao") 		= "Registro salvo com sucesso!"
	session("strMensagemAlteracao") 	= "Registro alterado com sucesso!"
	session("strMensagemExclusao") 		= "Registro exluido com sucesso!"
	session("strMensagemNaoEncontrado") = "Não foram encontrados dados para esta consulta."
						
	Dim Usuario, Senha, Mensagem
	
	Usuario = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Request.Form("txtLogin"),"'",""),"-",""),"/",""),"*",""),"?",""),")",""),"(","")
	Senha 	= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Request.Form("txtSenha"),"'",""),"-",""),"/",""),"*",""),"?",""),")",""),"(","")
	
	Usuario = UCASE(Usuario)
	if trim(Usuario) = "SERGIO" OR trim(Usuario) = "FERNANDO.DOMINGOS" OR trim(Usuario) = "CLEOVIS" OR trim(Usuario) = "NIVALDO.SILVA" then
		'liberado
	else
			%>
			<!--script>
			  //alert("Sistema bloqueado!");
			  //window.location = 'login.asp';
			</script!-->
			<%
			'response.redirect("default.asp")
			'response.end
	end if	
	
	
	'Verifica se o usuário foi digitado	
	if trim(Usuario) = "" then
		response.redirect("default.asp")
		response.end
	else
		
		' Valida Senha 123456 - antes estou testando se o usuário existe no banco de dados para depois testar a senha 123456
		sql = " SELECT Usua_Codg, USUA_STAT, Usua_Info_Senha, Usua_data_alteracao_senha, "
		sql = sql & " Usua_data_hora_ult_logon_web, cod_empresa" 
		sql = sql & " FROM SEG_Usuarios_Sistema" 
		sql = sql & " Where Usua_Codg = '" & Usuario & "'"
		Rs.Open SQL, cnn
		if not Rs.EOF then
			
			senhaInformada = Senha
	
			if trim(senhaInformada) = trim(Rs("Usua_Info_Senha")) then
			
				if trim(Senha) = "123456" or trim(Senha) = "0123456" or trim(Senha) = trim(Usuario) or len(senha) < 6 then
				
					session("usuarioWeb") = strUsuario
					%>
					<script>
						if (confirm("Sua senha expirou! Por favor altere agora.")) {
							window.location = "sistema/seg/UsuarioAlterar_senha_cad.asp?UsuarioWeb=<%=strUsuario%>";
						}						
						else {
							 window.location = 'default.asp';
						}
					</script>
					<%
					response.end()
				end if
			end if	
		end if
		rs.close

	
		sql = " SELECT Usua_Codg, USUA_STAT, Usua_Info_Senha, Usua_data_alteracao_senha, "
		sql = sql & " Usua_data_hora_ult_logon_web, cod_empresa" 
		sql = sql & " FROM SEG_Usuarios_Sistema" 
		sql = sql & " Where Usua_Codg = '" & Usuario & "'"
		Rs.Open SQL, cnn
		if Rs.EOF then
			Rs.close
	
			' Testando o login de aluno
			sql = " SELECT MATRICULA, Senha" 
			sql = sql & " FROM SCA_ALUNO" 
			sql = sql & " Where CONVERT(VARCHAR(10),MATRICULA) = '" & Usuario & "'"
			RsAux.Open SQL, cnn
			if not  RsAux.EOF then
				'Existe senha
			
				if trim(RsAux("MATRICULA")) <> trim(Usuario) then
					Session("UsuarioWeb") 		= ""
					Session("PerfilUsuario")  	= ""
					Session("Aluno")  			= ""
					Session("CodSeguranca")     = ""
					%>
					<script>
					  alert("Senha incorreta!");
					  window.location = 'login.asp';
					</script>
					<%
					RsAux.close
					response.end()
				else
					' Permitindo acesso ao aluno
					Session("UsuarioWeb") 		= Usuario
					Session("PerfilUsuario")  	= ""
					Session("Aluno")  			= "S"
					Session("SenhaAluno")  		= Senha
					Session("CodSeguranca")     = ""
					%>
					<script>
						 window.location = 'LoginAluno.asp';
					</script>
					<%
					RsAux.close
				end if
			else
				RsAux.close
				'Não achou o usuário 
				Session("UsuarioWeb") 		= ""
				Session("PerfilUsuario")  	= ""
				Session("Aluno")  			= ""
				Session("CodSeguranca")     = ""
				%>
					<script>
						alert("Usuário inválido, verifique!");
						window.location = 'login.asp';
					</script>
				<%
				response.end
			end if	
		else
			
			sql = " SELECT Usua_Codg, USUA_STAT, Usua_Info_Senha, Usua_Stat" 
			sql = sql & " FROM SEG_Usuarios_Sistema" 
			sql = sql & " Where Usua_Codg = '" & Usuario & "'"
			RsAux.Open SQL, cnn
			if not RsAux.EOF then
				'Usuário bloqueado 
				if trim(RsAux("Usua_Stat")) = "I" then
					Session("UsuarioWeb") 		= ""
					Session("PerfilUsuario")  	= ""
					Session("Aluno")  			= ""
					Session("CodSeguranca")     = ""
					%>
					<script>
						alert("Usuário inativo, verifique!");
						window.location = 'login.asp';
					</script>
					<%
					response.end()
				elseif trim(RsAux("Usua_Stat")) = "B" then
					Session("UsuarioWeb") 		= ""
					Session("PerfilUsuario")  	= ""
					Session("Aluno")  			= ""
					Session("CodSeguranca")     = ""
					%>
					<script>
						alert("Usuário bloqueado, verifique!");
						window.location = 'login.asp';
					</script>
					<%
					response.end()
				end if
				RsAux.close
			else
				RsAux.close
				'Não achou o usuário 
				Session("UsuarioWeb") 		= ""
				Session("PerfilUsuario")  	= ""
				Session("Aluno")  			= ""
				Session("CodSeguranca")     = ""
				%>
				<script>
					alert("Usuário inválido, verifique!");
					window.location = 'login.asp';
				</script>
				<%
				response.end
			End if
			
			'Achou o usuário. Verificar as senhas do mesmo
			if isnull(trim(Rs("Usua_Info_Senha"))) or trim(Rs("Usua_Info_Senha")) = "" then
				'Sem senhas cadastradas								
				Session("UsuarioWebTemporario")  = Usuario
				%>
				<script>
					if (confirm("Usuário não tem senha para acessar o portal, deseja cadastrar?")){
						window.location = "sistema/seg/Usuario_senha_cad.asp";
					}else{
						window.location = 'login.asp';
					}
				</script>
				<%
				Session("UsuarioWeb") 		= ""
				Session("PerfilUsuario")  	= ""
				Session("Aluno")  			= ""
				Session("CodSeguranca")     = ""
				response.end()
			else
				'Verifica a senha digitada
				if Senha = "" then
					'Sem senha digitada
					Session("UsuarioWeb") 		= ""
					Session("PerfilUsuario")  	= ""
					Session("Aluno")  			= ""
					Session("CodSeguranca")     = ""
					%>
					<script>
						alert("A senha deve ser informada, verifique!");
						window.location = 'login.asp';;
					</script>
					<%
					response.end()
				else
					'Existe senha
					if trim(Rs("Usua_Info_Senha")) <> trim(senha) then
						Session("UsuarioWeb") 		= ""
						Session("PerfilUsuario")  	= ""
						Session("Aluno")  			= ""
						Session("CodSeguranca")     = ""
						%>
						<script>
						  alert("Senha incorreta!");
						  window.location = 'login.asp';
						</script>
						<%
						response.end()
					end if
					
					'mensagem padroes
					session("strMensagemRelatorioNaoEncontrado") = "Nenhum registro foi encontrado."
	
					' Verifica se o usuario expirou
					if isnull(Rs("Usua_data_hora_ult_logon_web"))=false then
						dataUltimoLogon = year(Rs("Usua_data_hora_ult_logon_web")) & "/" & month(Rs("Usua_data_hora_ult_logon_web")) & "/" & day(Rs("Usua_data_hora_ult_logon_web"))
					else
						dataUltimoLogon = ""
					end if
					
					if isnull(Rs("Usua_data_alteracao_senha")) = false then
						dataUltimaAlteracaoSenha = Rs("Usua_data_alteracao_senha")
					else
						dataUltimaAlteracaoSenha = ""
					end if
					
					Session("QtdeUsuarioEmpresaAcessa") = 0
					Session("CodEmpresaTemp") = ""
					Session("CodEmpresaCadastro") = Rs("cod_empresa")
					Rs.Close
	
					sql = "select cod_empresa "
					sql = sql & " from SEG_USUARIOS_EMPRESA "
					sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '" & Usuario & "'"
					RsAux.Open SQL, cnn,3 ,1
					if not RsAux.EOF then
						Session("QtdeUsuarioEmpresaAcessa") = RsAux.recordCount
						intCodEmpTemp = RsAux("cod_empresa")
					end if
					RsAux.close
	
					if cInt(Session("QtdeUsuarioEmpresaAcessa")) < 2 then
						Session("CodEmpresaTemp") = intCodEmpTemp
					end if
					
					Session("UsuarioWeb") = Usuario
					Session("Aluno")  	  = "N"
					
					sql = "update SEG_Usuarios_Sistema set USUA_DATA_HORA_ULT_LOGON_WEB ='" & formataDataBD(date) & " " & time & "'"
					sql = sql & " Where USUA_CODG = '" & Session("UsuarioWeb") & "'"
					cnn.execute sql
					GravarLog sql
	
					if bolMostrarMensagem = true then
						%>
						<script>
							if (confirm("Sua senha expira em <%=intTolatDias%> dias. Deseja alterá-la agora?")) {
								window.location = "sisPortal/Usuario_cad.asp?strMenu=Portal&UsuarioWeb=<%=Usuario%>";
							}						
							else {
								window.location = "Principal.asp";
							}
						</script>
						<%
						response.end()
					end if
					%>
					<script>
						window.location = "Sistema/Default.asp";
					</script>
					<%	
				end if
			end if
		end if 'Fim usuário não encontrado
	end if 'Fim usuário em branco
%>
