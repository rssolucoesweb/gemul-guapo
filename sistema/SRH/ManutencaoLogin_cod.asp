    <!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 27/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...:  Manutenção de Login
	-->
 	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->

	<%
	paginaRetorno		= "ManutencaoLogin_cad.asp"
	strAcao 			= Request.QueryString("acao")

	intCodDepto			= Trim(Request.Form("txtCodDepto"))
	intCodEmpresa		= Trim(Request.Form("txtCodEmpresa"))
	strUsuarioPortal 	= UCASE(ReplaceRequest(Trim(Request.Form("txtUsuarioPortal"))))
	strSenha			= Trim(Request.Form("txtSenha"))
	strStatus			= Trim(Request.Form("optStatus"))
	strSenhaAnterior	= ReplaceRequest(Trim(Request.Form("txtSenhaAnterior")))
	
	strNomeCompleto			= Trim(Request.Form("txtNomeCompleto"))
	strCPF					= Trim(Request.Form("txtCPF"))
	strTelefone				= Trim(Request.Form("txtTelefone"))
	strEmail				= Trim(Request.Form("txtEmail"))
	strDataAtual			= formataDataBD(date) & " " & time
	GestorManutencao		= Trim(Request.Form("GestorManutencao"))

	bolValidaSenhaUltimas = false
	if trim(strSenhaAnterior)<>trim(strSenha) then bolValidaSenhaUltimas = true
	
	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
			
		strMensagem = "Realize a inclusão pelo cadastro de colaborador."
			
	elseif strAcao = "A" then
	
		strMensagem = "Registro Alterado com sucesso!"
			
		sql = "Update SEG_USUARIOS_SISTEMA set"
		sql = sql & " Usua_Stat = '" & strStatus & "',"
		
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
		if bolValidaSenhaUltimas then sql = sql & " USUA_DATA_ALTERACAO_SENHA = '" & strDataAtual & "',"
		sql = sql & " CODIGO_DEPARTAMENTO = " & intCodDepto & ","
		sql = sql & " GESTOR_MANUTENCAO = '" & GestorManutencao & "'"
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