	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	strUsuarioPortal 	= UCASE(Trim(Trim(Request.Form("txtUsuarioPortal"))))
	acao = request("acao")
	'on error resume next
	cnn.begintrans
	
	strMensagem = "Registro Alterado com sucesso!"
	
	if acao = "I" then
		if strUsuarioPortal <> "" then 
			strMensagem 		= "Registro incluido com sucesso!"
								
			sql = " Insert into SEG_USUARIOS_INCLUI_CADASTRO (CODIGO_SEG_USUARIOS_SISTEMA, COD_GRUPO,SEG_ITENS_SISTEMA_ITEM_CODG, DATA_HORA_INCL)"
			sql = sql & " VALUES ("
			sql = sql & "'" & strUsuarioPortal & "',"
			sql = sql & "'" & SESSION("CODGRUPO") & "',"
			sql = sql & "26,"
			sql = sql & "GETDATE() )"
		
			cnn.execute sql
			GravarLog sql
			intCont = intCont + 1
				
		end if 
	elseif acao = "E" then
		strUsuarios 	= UCASE(Trim(Trim(Request.Form("chkEmp"))))
		if strUsuarios <> "" then   
			vetUsuarios = split(strUsuarios,",")			 
		end if
		
		for intContador = 0 to ubound(vetUsuarios)	
			strUsuarioPortal 			= trim(vetUsuarios(intContador))
			strMensagem 		= "Registro exluido com sucesso!"
			sql = " Delete from SEG_USUARIOS_INCLUI_CADASTRO "
			sql = sql & " Where CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
			cnn.execute sql
			GravarLog sql
		next
	end if
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='UsuarioLiberaCadastro_cad.asp';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>