<!--
	::	IMOB
	::	Data de Criação...: 20/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cria senha para acesso -  grava
	::	Desenvolvedores...: 
	::	Data Atualizacao..: 
-->
<%
'as paginas do menu administrativo não vão validar o ano letivo
bolPaginaAnoLetivo 	= "N"
'as paginas do menu administrativo não vão validar a unidade de ensino
strValidaUnidadeEnsino = "N"
%>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<!--#include file="../../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../../includes/inc_criptografia.asp"-->
<%
	
	'on error resume next
	'----------Inicia uma transação--------------
	cnn.begintrans
	
	acao = Trim(Request.QueryString("acao"))

	strCPF		= formataCpfBD(Trim(Request("txtCPF")))
	strNome     = ReplaceRequest(request.Form("txtNome"))
	'strSituacao = request.Form("cmbSituacao")

	strDataAlteracaoSenha	= request.Form("txtDataAlteracaoSenha")

	strTelefone	= ReplaceRequest(request.Form("txtTelefone"))
	strEmail	= ReplaceRequest(request.Form("txtEmail"))
	intCodDepartamento		= request.form("cmbDepartamento")
	intCodSecao				= request.form("cmbSecaoUsuario")
	'seta senha temporaria
	bolSenhaTemporaria = false
	strSenha	= ""
	if trim(request.Form("txtSenhaCriada")) <> "" then
		strSenha	= request.Form("txtSenhaCriada")
		'seta senha temporária
		bolSenhaTemporaria = true
	end if
	
	
	' Dados do Usuario	
	strUsuario_incl 		= session("strUsuario")	
	strData_hora_incl 		= formataDataBd(date) & " " & time
	strUsuario_altr 		= session("strUsuario")
	strData_hora_altr		= formataDataBd(date) & " " & time
	strDataAtual			= formataDataBd(date) & " " & time
	
	if acao="I" then			
		strMensagem = session("strMensagemInclusao")			
		sql = "Insert Into SEG_usuarios (Cpf, nome, "
		if strSenha <> "" then
			sql = sql & " senha, "
		end if		
		sql = sql & " senhaTemporaria, data_ativacao, telefone, email, codDepartamento, codSecao, " 
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)" 
		sql = sql & " Values ("
		sql=sql & "" & strCPF & ","
		sql=sql & "'" & strNome & "',"
		if strSenha <> "" then
			strSenha = FormatCripto(strSenha,True)
			sql=sql & "'" & strSenha & "',"
		end if
		
		' senha temporária
		if bolSenhaTemporaria then
			sql=sql & "'S',"
		else
			sql=sql & "'N',"
		end if

		if strData_hora_incl <> "" then
			sql=sql & "'" & strData_hora_incl & "',"
		else
			sql=sql & "null,"
		end if
		
		if strTelefone <> "" then
			sql=sql & "'" & strTelefone & "',"
		else
			sql=sql & "null,"
		end if

		if strEmail <> "" then
			sql=sql & "'" & strEmail & "',"
		else
			sql=sql & "null,"
		end if
		sql=sql & "" & intCodDepartamento & ","
		sql=sql & "" & intCodSecao & ","
		
		' Usuario do Sistema
		if strUsuario_incl <> "" then
			sql=sql & "'" & strUsuario_incl & "',"
		else
			sql=sql & "null,"
		end if
		
		if strData_hora_incl <> "" then
			sql=sql & "'" & strData_hora_incl & "',"
		else
			sql=sql & "null,"
		end if
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao
		sql=sql & "" & "null, null" & ")"
		cnn.execute sql
		
	elseif acao="A" then

		strMensagem = session("strMensagemAlteracao")
		
		sql = " Update SEG_usuarios Set "
		sql = sql & "Nome = '" & strNome & "',"
		
		if strSenha <> "" then
			strSenha = FormatCripto(strSenha,True)
			sql=sql & "Senha = '" & strSenha & "',"
		end if

		' senha temporária
		if bolSenhaTemporaria then
			sql=sql & "senhaTemporaria = 'S',"
			sql = sql & " data_alteracao_senha = '" & strdata_hora_altr & "',"
		else
			sql=sql & "senhaTemporaria = 'N',"
			if trim(strSenha) <> trim(strSenhaAtual) then
				sql = sql & " data_alteracao_senha = '" & strdata_hora_altr & "',"
			end if					
		end if

		sql = sql & " data_ultimo_acesso = '" & strdata_hora_altr & "',"
		
		if strTelefone <> "" then
			sql=sql & "telefone = '" & strTelefone & "',"
		else
			sql=sql & "telefone = null,"
		end if

		if strEmail <> "" then
			sql=sql & "email = '" & strEmail & "',"
		else
			sql=sql & "email = null,"
		end if
		sql=sql & "CodDepartamento = " & intCodDepartamento & ","
		sql=sql & "CodSecao = " & intCodSecao & ","
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
		cnn.execute sql
	
	else
		strMensagem = session("strMensagemExclusao")
		
		sql = "delete from SEG_usuarios_acesso"
		sql = sql & " WHERE cpf_SEG_usuarios = " & formataCpfBD(strCPF)
		cnn.execute sql

		sql = "delete from SEG_usuarios"
		sql = sql & " WHERE cpf = " & formataCpfBD(strCPF)
		cnn.execute sql
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Seg_UsuarioAutorizacao_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='modulos/academico/Seg_cadastraUsr_cad.asp'"
		cnn.rollbacktrans
	end if
rs.close
%>