<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnndocumento.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 										= Trim(Request.QueryString("acao"))
	
	intCodEmp									= Session("CodEmpresa")
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodColaborador	         	 			= Trim(Request("cmbColaborador")) 
	senha				         	 			= Trim(Request("senha")) 
	
	if acao = "I" then
		strImagem									= Trim(Request("txtTexto"))
	end if
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		strMensagem = "Registro incluido com sucesso..."
		
		sql = "Insert Into SRH_COLABORADOR_ASSINATURA_DIGITAL(cod_empresa, codcolaborador, senha, imagem )"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodColaborador & ","
		sql = sql & "'" & senha & "',"
		sql = sql & "'" & strImagem & "')"
		cnn.execute sql
		
	elseif acao = "E" then
		
		sql = "delete from SRH_COLABORADOR_ASSINATURA_DIGITAL"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		strMensagem = "Registro excluido com sucesso..."
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "assinaturaDigital_cad.asp";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>