	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 25/09/2020
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Empresa
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	paginaRetorno		= "UsuarioAcesso_cad.asp"
	strAcao 			= Request.QueryString("acao")

	intCodEmpresa		= Trim(Request.Form("cmdEmpresa"))
	strUsuarioPortal 	= UCASE(ReplaceRequest(Trim(Request.Form("txtUsuarioPortal"))))
	strSenha			= Trim(Request.Form("txtSenha"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	strSenhaAnterior	= ReplaceRequest(Trim(Request.Form("txtSenhaAnterior")))
	
	strNomeCompleto			= Trim(Request.Form("txtNomeCompleto"))
	strCPF					= Trim(Request.Form("txtCPF"))
	strTelefone				= Trim(Request.Form("txtTelefone"))
	strEmail				= Trim(Request.Form("txtEmail"))
	
	intCodPerfil 			= Trim(Request.Form("cmbPerfilGrupo"))
	
	if intCodPerfil <> "" then
		vetPerfil = split(intCodPerfil,",")
	end if
	
	strDataAtual			= formataDataBD(date) & " " & time

	bolValidaSenhaUltimas = false
	if trim(strSenhaAnterior)<>trim(strSenha) then bolValidaSenhaUltimas = true
	
	cnn.begintrans

	if strAcao = "I" then  
			
		strMensagem = "Registro Cadastrado com sucesso!"
			
		sql = " Insert into SEG_USUARIOS_SISTEMA (Usua_Codg, Usua_Stat, Usua_Info_Senha, "
		sql = sql & " Usua_Data_Ativacao, CODIGO_DEPARTAMENTO, COD_EMPRESA, "
		sql = sql & " USUA_NOME_COMPLETO, USUA_TELEFONE, USUA_EMAIL, USUA_CPF, USUARIO_MASTER, GESTOR_FINANCEIRO, GESTOR_SUPORTE, GESTOR_MANUTENCAO)" 
		sql = sql & " VALUES("

		sql = sql & "'" & strUsuarioPortal & "'," 
		
		if strStatus <> "" then
			sql = sql & "'" & strSituacao & "',"
		else
			sql = sql & "null, "
		end if 
		
		sql = sql & "'" & strSenha & "'," 
		sql = sql & "'" & strDataAtual & "'," 
		sql = sql & "'" & intCodDepto & "',"
		sql = sql & "'" & intCodEmpresa & "',"
		sql = sql & "'" & strNomeCompleto & "',"
		sql = sql & "'" & strTelefone & "',"
		sql = sql & "'" & strEmail & "',"
		sql = sql & "'" & strCPF & "',"
		
		if usuarioMaster <> "" then
			sql = sql & "'" & usuarioMaster & "',"
		else
			sql = sql & "null, "
		end if 
		if GestorFinanceiro <> "" then
			sql = sql & "'" & GestorFinanceiro & "',"
		else
			sql = sql & "null, "
		end if 
		if GestorSuporte <> "" then
			sql = sql & "'" & GestorSuporte & "',"
		else
			sql = sql & "null, "
		end if 
		if GestorManutencao <> "" then
			sql = sql & "'" & GestorManutencao & "')"
		else
			sql = sql & "null) "
		end if 
		cnn.execute sql
		GravarLog sql

		if intCodPerfil <> "" then
			for i=0 to ubound(vetPerfil)
				sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse )"
				sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & vetPerfil(i) & "', 'N')"
				cnn.execute sql
				GravarLog sql
			next
		end if
		
		sql = " Insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA)"
		sql = sql & " VALUES ("
		sql = sql & "'" & strUsuarioPortal & "',"
		sql = sql & "" & intCodEmpresa & ")"
		
		cnn.execute sql
		GravarLog sql
		
	elseif strAcao = "A" then
	
		strMensagem = "Registro Alterado com sucesso!"
			
		sql = "Update SEG_USUARIOS_SISTEMA set"
		
		sql = sql & " Usua_Stat = '" & strSituacao & "',"
		
		if strSenha <> "" then
			sql = sql & " Usua_Info_Senha = '" & strSenha & "',"
		else
			sql = sql & " Usua_Info_Senha = null, "
		end if 
		sql = sql & " USUA_NOME_COMPLETO ='" & strNomeCompleto & "',"
		sql = sql & " USUA_TELEFONE = '" & strTelefone & "',"
		sql = sql & " USUA_CPF = '" & strCpf & "',"
		sql = sql & " USUA_EMAIL = '" & strEmail & "',"
		sql = sql & " COD_EMPRESA = " & intCodEmpresa & ","
		sql = sql & " GESTOR_SUPORTE = '" & GestorSuporte & "',"
		sql = sql & " GESTOR_MANUTENCAO = '" & GestorManutencao & "',"
		sql = sql & " GESTOR_FINANCEIRO = '" & GestorFinanceiro & "',"
		sql = sql & " USUARIO_MASTER = '" & usuarioMaster & "',"
		
		if bolValidaSenhaUltimas then sql = sql & " USUA_DATA_ALTERACAO_SENHA = '" & strDataAtual & "',"
		
		sql = sql & " CODIGO_DEPARTAMENTO = " & intCodDepto & ""
		sql = sql & " where Usua_Codg = '" & strUsuarioPortal & "'"
	
		cnn.execute sql
		GravarLog sql
		
		if strSenha <> "" then
	
			if bolValidaSenhaUltimas then
			
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
			
		end if 
		
		sql = "delete Seg_Acessos_Usuario where Aces_Usua_Codg='" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql
		
		if intCodPerfil <> "" then
			for i=0 to ubound(vetPerfil)
				sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse )"
				sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & vetPerfil(i) & "', 'N')"
				cnn.execute sql
				GravarLog sql
			next
		end if
		
		sql = "delete SEG_USUARIOS_EMPRESA where CODIGO_SEG_USUARIOS_SISTEMA='" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql
		
		sql = " Insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA)"
		sql = sql & " VALUES ("
		sql = sql & "'" & strUsuarioPortal & "',"
		sql = sql & "" & intCodEmpresa & ")"
		
		cnn.execute sql
		GravarLog sql
		
	elseif strAcao = "E" then 
	
		strMensagem = "Usuario excluido com sucesso."
		
		sql = "delete Seg_Acessos_Usuario "
		sql = sql & " where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql
	
		sql = "delete SEG_USUARIOS_EMPRESA "
		sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql
		
		sql = "delete SEG_USUARIO_HISTORICO_SENHA "
		sql = sql & " where Usua_Codg = '" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql

        sql = " update SRH_COLABORADOR "
		sql = sql & " set CODIGO_SEG_USUARIOS_SISTEMA=null "
		sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql

		sql = "Delete From SEG_USUARIOS_SISTEMA"
		sql = sql & " WHERE Usua_Codg = '" & strUsuarioPortal & "'"
		cnn.execute sql
		GravarLog sql		
	end if
		
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=paginaRetorno%>';
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