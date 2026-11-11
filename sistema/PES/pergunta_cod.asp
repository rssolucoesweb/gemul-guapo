<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
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

	nome										= Trim(Request.form("nome"))
	cod_pesquisa								= Trim(Request.form("cmbPesquisa"))
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		
		strMensagem = "Registro incluido com sucesso..."

		sql = "SET NoCount ON Insert Into PES_pergunta(cod_pesquisa,nome,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "" & cod_pesquisa & ","
		sql = sql & "'" & nome & "',"
		sql = sql & "'" & strUsuario_incl & "',GETDATE(),"
		sql = sql & "'" & strUsuario_incl & "',GETDATE()); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
	elseif acao = "A" then
		
		strMensagem = "Registro alterado com sucesso..."

		sql = "update PES_pergunta set nome = '" & nome & "',"
		sql = sql & " cod_pesquisa = " & cod_pesquisa & ","
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
	
	elseif acao = "E" then
		
		strMensagem = "Registro alterado com sucesso..."

		sql = "delete PES_pergunta"
		sql = sql & " where codigo =" & intCodigo
		Set rs = cnn.Execute(sql)
		GravarLog SQL
		
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "pergunta_cad.asp?txtCodigo=<%=intCodigo%>";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>