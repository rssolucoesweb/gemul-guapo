<!--
	::	pro
	::	Data de Criação...: 12/05/2013
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir assunto
	::	Data Atualizacao..: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodProtocolo		= Trim(Request.Form("txtCodigo"))
	strTipoProtocolo 	= Trim(Request.Form("cmbTipoProtocolo"))
	strRequerente 		= ucase(Trim(Request.Form("txtRequerente")))
	strCPF			 	= Trim(Request.Form("txtCPF"))
	intCodAssunto 		= Trim(Request.Form("cmbAssunto"))
	intCodTipoDocumento = Trim(Request.Form("cmbTipoDocumento"))
	intCodDepartamento 	= Trim(Request.Form("cmbDepartamento"))
	intCodSituacao 		= Trim(Request.Form("cmbSituacao"))
	strNumeroDocumento 	= Trim(Request.Form("txtNumeroDocumento"))
	strMotivo 			= Trim(Request.Form("txtMotivo"))
	strObs		 		= Trim(Request.Form("txtObs"))
	strAno 				= year(date)


	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		
		sql = "SET NoCount ON Insert Into PRO_Protocolo(Cod_Empresa, ano, dataAbertura, tipoProtocolo, cpf, requerente, cod_Assunto, motivo, obs, cod_TipoDocumento, numeroDocumento,"
		sql = sql & " cod_Departamento, cod_departamentoAtual, cod_Situacao, tipoAndamento, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strAno & "',"
		sql = sql & "getdate(),"
		sql = sql & "'" & strTipoProtocolo & "',"
		sql = sql & "'" & strCPF & "',"
		sql = sql & "'" & strRequerente & "',"
		sql = sql & "'" & intCodAssunto & "',"
		sql = sql & "'" & strMotivo & "',"
		sql = sql & "'" & strObs & "',"
		sql = sql & "'" & intCodTipoDocumento & "',"
		sql = sql & "'" & strNumeroDocumento & "',"
		sql = sql & "'" & intCodDepartamento & "',"
		sql = sql & "'" & intCodDepartamento & "',"
		sql = sql & "'" & intCodSituacao & "',"
		sql = sql & "'E'," 'encaminhar

		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		sql = sql & " ;SELECT @@IDENTITY "
		
		Set rs = cnn.Execute(sql)
		intCodProtocolo = rs(0)
		rs.close
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
		
		strNumeroProtocolo = formataTimeBD(time) & "." & ZeroLeft(intCodProtocolo,6) & "/" &  year(date)
		strSenha = formataTimeBD(time) + 12345
		sql = "Update PRO_Protocolo Set "
		sql = sql & " numero = '" & strNumeroProtocolo & "',"
		sql = sql & " senha = '" & strSenha & "'"
		sql = sql & " Where Codigo = " & intCodProtocolo 
		sql = sql & " And Cod_Empresa = " & intCodEmpresa 
		cnn.execute sql

		sql = "Insert Into PRO_Protocolo_Andamento (Cod_Empresa, codigo_PRO_protocolo, cod_departamentoAtual, cod_departamentoDestino, tipoAndamento, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & intCodProtocolo & "',"
		sql = sql & "'" & intCodDepartamento & "',"
		sql = sql & "'" & intCodDepartamento & "',"
		sql = sql & "'E',"

		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
		strMensagem = "Protocolo aberto com sucesso.\n\nNúmero: " & strNumeroProtocolo & "\n\nDeseja emitir recibo?"

	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "Update PRO_Protocolo Set "
		sql = sql & "tipoProtocolo = '" & strTipoProtocolo & "',"
		sql = sql & "cpf = '" & strCPF & "',"
		sql = sql & "requerente = '" & strRequerente & "',"
		sql = sql & "cod_assunto = '" & intCodAssunto & "',"
		sql = sql & "motivo = '" & strMotivo & "',"
		sql = sql & "obs = '" & strObs & "',"
		sql = sql & "cod_tipoDocumento = '" & intCodTipoDocumento & "',"
		sql = sql & "numeroDocumento = '" & strNumeroDocumento & "',"
		sql = sql & "cod_departamento = '" & intCodDepartamento & "',"
		sql = sql & "cod_departamentoAtual = '" & intCodDepartamento & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodProtocolo 
		sql = sql & " And Cod_Empresa = " & intCodEmpresa 
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
		
	else
		strMensagem = "Registro excluida com sucesso..."
		
		sql = "Delete from PRO_Protocolo_andamento "
		sql = sql & " Where Codigo_PRO_Protocolo = " & intCodProtocolo
		sql = sql & " And Cod_Empresa = " & intCodEmpresa 
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))

		sql = "Delete from PRO_Protocolo "
		sql = sql & " Where Codigo = " & intCodProtocolo
		sql = sql & " And Cod_Empresa = " & intCodEmpresa 
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="I" then
		%>
		<script>
			if (confirm("<%=strMensagem%>")) {
				window.location="AbrirProtocolo_rel.asp?txtCodigo=<%=intCodProtocolo%>";
			}else{
				window.location='AbrirProtocolo_cad.asp';	
			}
		</script>
        <%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AbrirProtocolo_cad.asp';
		</script>
		<%
		end if
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>