<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodGrupo				= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strNome		 			= Trim(Request.Form("txtNome"))
	strSecretaria 			= Trim(Request.Form("txtSecretaria"))
	strDepartamento			= Trim(Request.Form("txtDepartamento"))
	strCPF		 			= Trim(Request.Form("txtCPF"))
	strEmail	 			= Trim(Request.Form("txtEmail"))
	strTelefone 			= Trim(Request.Form("txtTelefone"))
	strSituacao 			= Trim(Request.Form("cmbSituacao"))
	strUsuarioPortal		= Trim(Request.Form("txtUsuarioPortal"))
	strSenhaPortal			= Trim(Request.Form("txtSenhaPortal"))
	codColaborador			= Trim(Request.Form("codColaborador"))
	intCodArea				= Trim(Request.Form("cmbArea"))
	intCodPerfil 			= 69 'atendimento/executor
	
	' Dados do Usuario
	strUsuario_incl   	=	session("usuarioWeb")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("usuarioWeb")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		if codColaborador <> "" then
			if strUsuarioPortal <> "" then
				sql = "SELECT Usua_Codg" 
				sql = sql & " FROM SEG_USUARIOS_SISTEMA"
				sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"
				rs.open sql, cnn
				if rs.EOF then
					'insere usuario para acesso no portal
					sql = " Insert into SEG_USUARIOS_SISTEMA (Usua_Codg, Usua_Stat, Usua_Info_Senha, "
					sql = sql & " Usua_Data_Ativacao, CODIGO_DEPARTAMENTO, COD_EMPRESA, "
					sql = sql & " USUA_NOME_COMPLETO, USUA_TELEFONE, USUA_EMAIL, USUA_CPF)" 
					sql = sql & " VALUES("
			
					sql = sql & "'" & strUsuarioPortal & "'," 
					if strSituacao <> "" then
						sql = sql & "'" & strSituacao & "',"
					else
						sql = sql & "null, "
					end if 
					sql = sql & "'" & strSenhaPortal & "'," 
					sql = sql & "'" & strData_hora_incl & "'," 
					sql = sql & "null,"
					sql = sql & "'" & session("codEmpresa") & "',"
			
					sql = sql & "'" & strnome & "',"
					sql = sql & "'" & strTelefone & "',"
					if stremail <> "" then
						sql = sql & "'" & LCase(stremail) & "',"
					else 
						sql = sql &" null ,"
					end if
					sql = sql & "'" & strCPF & "')"
					cnn.execute sql
					GravarLog sql
					
					sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse )"
					sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & intCodPerfil & "', 'N')"
					cnn.execute sql
					GravarLog sql
					
					sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA )"
					sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & session("codEmpresa") & "')"
					cnn.execute sql
					GravarLog sql
				end if
				rs.close
			end if
		
			sql = "Insert Into SOS_FUNCIONARIO_EXTERNO(Cod_grupo, codigo_seg_usuarios_sistema, nome, secretaria, departamento, telefone, cpf, email, situacao, cod_colaborador, cod_area, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"
			sql = sql & " Values ("
			sql = sql & "'" & intCodGrupo  & "',"
			IF strUsuarioPortal="" THEN
				sql = sql & "null,"
			ELSE
				sql = sql & "'" & strUsuarioPortal & "',"
			END IF
			sql = sql & "'" & strNome & "',"
			sql = sql & "'" & strSecretaria & "',"
			sql = sql & "'" & strDepartamento & "',"
			sql = sql & "'" & strTelefone & "',"
			sql = sql & "'" & strCPF & "',"
			sql = sql & "'" & strEmail & "',"
			sql = sql & "'" & strSituacao & "',"
			if codColaborador="" then
				sql = sql & "null,"
			else
				sql = sql & "" & codColaborador & ","
			end if
			sql = sql & "" & intCodArea & ","
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "',"
			
			' Campos nulos para campo Usuario Alteracao e data Alteracao'
			sql = sql & "" & "null, null" & ")"
			cnn.execute sql
			GravarLog sql
				
		else
			if strUsuarioPortal <> "" then
				sql = "SELECT Usua_Codg" 
				sql = sql & " FROM SEG_USUARIOS_SISTEMA"
				sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"	
				rs.open sql, cnn
				if not RS.EOF then
					Usua_Codg = rs("Usua_Codg")
					rs.close
					cnn.rollbackTrans
					%>
					<script>
						alert("O login <%=Usua_Codg%> esta sendo utilizado por outro funcionario.");
						window.history.back();
					</script>
					<%
					response.End()
				end if
				rs.close
				
				'insere usuario para acesso no portal
				sql = " Insert into SEG_USUARIOS_SISTEMA (Usua_Codg, Usua_Stat, Usua_Info_Senha, "
				sql = sql & " Usua_Data_Ativacao, CODIGO_DEPARTAMENTO, COD_EMPRESA, "
				sql = sql & " USUA_NOME_COMPLETO, USUA_TELEFONE, USUA_EMAIL, USUA_CPF)" 
				sql = sql & " VALUES("
		
				sql = sql & "'" & strUsuarioPortal & "'," 
				if strSituacao <> "" then
					sql = sql & "'" & strSituacao & "',"
				else
					sql = sql & "null, "
				end if 
				
				sql = sql & "'" & strSenhaPortal & "'," 
				sql = sql & "'" & strData_hora_incl & "'," 
				sql = sql & "null,"
				sql = sql & "'" & session("codEmpresa") & "',"
		
				sql = sql & "'" & strnome & "',"
				sql = sql & "'" & strTelefone & "',"
				if stremail <> "" then
					sql = sql & "'" & LCase(stremail) & "',"
				else 
					sql = sql &" null ,"
				end if
				sql = sql & "'" & strCPF & "')"
				cnn.execute sql
				GravarLog sql
				
				sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse )"
				sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & intCodPerfil & "', 'N')"
				cnn.execute sql
				GravarLog sql
				
				sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA )"
				sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & session("codEmpresa") & "')"
				cnn.execute sql
				GravarLog sql
			end if

			sql = "Insert Into SOS_FUNCIONARIO_EXTERNO(Cod_grupo, codigo_seg_usuarios_sistema, nome, secretaria, departamento, telefone, cpf, email, situacao,  cod_colaborador, cod_area, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"
			sql = sql & " Values ("
			sql = sql & "'" & intCodGrupo  & "',"
			IF strUsuarioPortal="" THEN
				sql = sql & "null,"
			ELSE
				sql = sql & "'" & strUsuarioPortal & "',"
			END IF
			sql = sql & "'" & strNome & "',"
			sql = sql & "'" & strSecretaria & "',"
			sql = sql & "'" & strDepartamento & "',"
			sql = sql & "'" & strTelefone & "',"
			sql = sql & "'" & strCPF & "',"
			sql = sql & "'" & strEmail & "',"
			sql = sql & "'" & strSituacao & "',"
			if codColaborador="" then
				sql = sql & "null,"
			else
				sql = sql & "" & codColaborador & ","
			end if
			sql = sql & "" & intCodArea & ","
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "',"
			
			' Campos nulos para campo Usuario Alteracao e data Alteracao'
			sql = sql & "" & "null, null" & ")"
			cnn.execute sql
			GravarLog sql
		end if

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SOS_FUNCIONARIO_EXTERNO Set"
		sql = sql & " nome = '" & strNome & "',"
		sql = sql & " secretaria = '" & strSecretaria & "',"
		sql = sql & " cod_area = '" & intCodArea & "',"
		if codColaborador="" then
			sql = sql & "cod_colaborador = null,"
		else
			sql = sql & "cod_colaborador = '" & codColaborador & "',"
		end if
		sql = sql & " departamento = '" & strDepartamento & "',"
		sql = sql & " telefone = '" & strTelefone & "',"
		sql = sql & " cpf = '" & strCPF & "',"
		sql = sql & " email = '" & strEmail & "',"
		sql = sql & " situacao = '" & strSituacao  & "',"
		IF strUsuarioPortal="" THEN
			sql = sql & " codigo_seg_usuarios_sistema = null,"
		ELSE
			sql = sql & " codigo_seg_usuarios_sistema = '" & strUsuarioPortal  & "',"
		END IF
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " and Cod_grupo = " & intCodGrupo 		
		cnn.execute sql
		GravarLog sql
		
		bolExiste = false
		if strUsuarioPortal <> "" then
		
			sql = "select count(*) as contLogin "
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
			rs.open sql, cnn
			if not rs.eof then
				if not isnull(rs("contLogin")) then
					if rs("contLogin")=1 then
						bolExiste = true
					end if
				end if
				rs.close
			else
				rs.close
			end if
			
			sql = "select count(*) as contLogin "
			sql = sql & " from SEG_USUARIOS_SISTEMA"
			sql = sql & " where Usua_Codg = '"& strUsuarioPortal & "'"
			rs.open sql, cnn
			if not rs.eof then
				if not isnull(rs("contLogin")) then
					if rs("contLogin")=1 then
						bolExiste = true
					end if
				end if
				rs.close
			else
				rs.close
			end if
			
			if bolExiste = false then
			
				'insere usuario para acesso no portal
				sql = " Insert into SEG_USUARIOS_SISTEMA (Usua_Codg, Usua_Stat, Usua_Info_Senha, "
				sql = sql & " Usua_Data_Ativacao, CODIGO_DEPARTAMENTO, COD_EMPRESA, "
				sql = sql & " USUA_NOME_COMPLETO, USUA_TELEFONE, USUA_EMAIL, USUA_CPF)" 
				sql = sql & " VALUES("
		
				sql = sql & "'" & strUsuarioPortal & "'," 
				if strSituacao <> "" then
					sql = sql & "'" & strSituacao & "',"
				else
					sql = sql & "null, "
				end if 
				
				sql = sql & "'" & strSenhaPortal & "'," 
				sql = sql & "'" & strData_hora_incl & "'," 
				sql = sql & "null,"
				sql = sql & "'" & session("codEmpresa") & "',"
		
				sql = sql & "'" & strnome & "',"
				sql = sql & "'" & strTelefone & "',"
				if stremail <> "" then
					sql = sql & "'" & LCase(stremail) & "',"
				else 
					sql = sql &" null ,"
				end if
				sql = sql & "'" & strCPF & "')"
				cnn.execute sql
				GravarLog sql
				
				sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse )"
				sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & intCodPerfil & "', 'N')"
				cnn.execute sql
				GravarLog sql
				
				sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA )"
				sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & session("codEmpresa") & "')"
				cnn.execute sql
				GravarLog sql
			else
				sql = "Update SEG_USUARIOS_SISTEMA set"
				sql = sql & " Usua_Stat = '" & strSituacao & "',"
				
				if strSenhaPortal <> "" then
					sql = sql & " Usua_Info_Senha = '" & strSenhaPortal & "',"
				else
					sql = sql & " Usua_Info_Senha = null, "
				end if 
				sql = sql & " USUA_NOME_COMPLETO ='" & strnome & "',"
				sql = sql & " USUA_TELEFONE = '" & strTelefone & "',"
				sql = sql & " USUA_CPF = '" & strcpf & "',"
				if strEmail <> "" then
					sql = sql & " USUA_EMAIL = '" & LCase(strEmail) & "'"
				else
					sql = sql & " USUA_EMAIL = null "
				end if 
				sql = sql & " where Usua_Codg = '" & strUsuarioPortal & "'"

				cnn.execute sql
				GravarLog sql
				
				sql = " delete from Seg_Acessos_Usuario"
				sql = sql & " where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
				cnn.execute sql
				GravarLog sql
				
				sql = "SELECT Aces_Usua_Codg From Seg_Acessos_Usuario" 
				sql = sql & " WHERE Aces_Usua_Codg = '" & strUsuarioPortal & "'"
				sql = sql & " AND Aces_Perf_Codg = " & intCodPerfil  
				rs.open sql,cnn
				if rs.eof = true then
					sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse )"
					sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & intCodPerfil & "', 'N')"
					cnn.execute sql
					GravarLog sql
				end if		
				rs.close	
				
			end if
		end if		
		
	else

	 	'if strUsuarioPortal <> "" then
'
'			sql = "delete Seg_Acessos_Usuario "
'			sql = sql & " where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
'			sql = sql & " and Aces_Perf_Codg = " & intCodPerfil
'			cnn.execute sql
'			GravarLog sql
'	
'			sql = "delete SEG_USUARIOS_EMPRESA "
'			sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
'			cnn.execute sql
'			GravarLog sql
'
'			sql = "delete SEG_USUARIOS_SISTEMA "
'			sql = sql & " where USUA_CODG = '" & strUsuarioPortal & "'"
'			cnn.execute sql
'			GravarLog sql
'			
'		end if		
'	
'		strMensagem = "Registro Excluido com sucesso..."
'		sql = "Delete from SOS_FUNCIONARIO_EXTERNO "
'		sql = sql & " where codigo = " & intCodigo
'
'		cnn.execute sql
'		GravarLog sql


		strMensagem = "Registro Excluido com sucesso..."
		sql = "update SOS_FUNCIONARIO_EXTERNO set situacao='I' "
		sql = sql & " where codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='usuarioExterno_cad.asp';
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