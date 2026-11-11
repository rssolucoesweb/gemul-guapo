<!--
	::	IMOB
	::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir grupo
	::	Data Atualizacao..: 
-->
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request("txtCodigo"))
	strDepartamento 	= Trim(Request.Form("cmbDepartamento"))
	strUsuario	 		= Trim(Request.Form("cmbUsuario"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Insert Into EST_RequisicaoEmergencialAutorizacao (codEmpresa, solicitante, cod_departamento, data, situacao, usuario_autorizacao, data_autorizacao,usuario_incl,data_hora_incl)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strUsuario & "',"
		sql = sql & "" & strDepartamento & ","
		sql = sql & "getdate(),"
		sql = sql & "'AUTORIZADO',"
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "getdate(),"
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "getdate())"
				
	elseif acao="E" then
		strMensagem = "Registro excluida com sucesso..."
		
		sql = "select codigo "
		sql = sql & " from EST_RequisicaoEmergencialAutorizacao "
		sql = sql & " Where codEmpresa	= " & session("codEmpresa")	
		sql = sql & " And codigo	= " & intCodigo
		sql = sql & " And situacao = 'AUTORIZADO'"
		rs.open sql, cnn
		if rs.eof then	
			rs.close
			%>
			<script>
				alert("Autorização não pode ser mais excluída, ela já foi utilizada.");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		rs.close		
		
		sql = "Delete from EST_RequisicaoEmergencialAutorizacao "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
	
	end if
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AutorizacaoEmergencial_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>