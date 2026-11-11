<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--
	::	IMOB
	::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir sub grupo
	::	Data Atualizacao..: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("CodEmpresa")	
	intDiaInicial		= Trim(Request.Form("cmbDiaInicial"))
	intDiaFinal			= Trim(Request.Form("cmbDiaFinal"))

	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		strMensagem = "Registro salvo com sucesso..."
		strDepartamento	= Trim(Request("chkDepartamentoEmpresa"))
		vetDepto		= split(strDepartamento,", ")
		for i=0 to ubound(vetDepto)
			sql = "DELETE EST_LIBERA_REQUISICAO "
			sql = sql & " Where COD_DEPARTAMENTO = " & trim(vetDepto(i))
			sql = sql & " And COD_EMPRESA = " & intCodEmpresa
			cnn.Execute(sql)
			
			sql = "Insert Into EST_LIBERA_REQUISICAO(COD_EMPRESA,COD_DEPARTAMENTO,DIA_INICIAL,DIA_FINAL,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"          
			sql = sql & " Values ("
			sql = sql & "" & intCodEmpresa & ","
			sql = sql & "" & trim(vetDepto(i)) & ","
			sql = sql & "" & intDiaInicial & ","
			sql = sql & "" & intDiaFinal & ","
			
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "',"
			' Campos nulos para campo Usuario Alteracao e data Alteracao'
			sql = sql & "" & "null, null" & ")"
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		next
	elseif acao="A" then
	elseif acao="E" then
		
		bolExcluir = false
		strMensagem = "Registro excluido com sucesso..."
		
		strDepartamento	= Trim(Request("chkDepartamentoEmpresa"))
		vetDepto		= split(strDepartamento,", ")
		for i=0 to ubound(vetDepto)
			sql = "DELETE EST_LIBERA_REQUISICAO "
			sql = sql & " Where COD_DEPARTAMENTO = " & trim(vetDepto(i))
			sql = sql & " And COD_EMPRESA = " & intCodEmpresa
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		next
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="E" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='periodorequisicao_cad.asp';
		</script>
		<%
		elseif acao="A" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='periodorequisicao_cad.asp?cmbDepartamento=<%=intCodDepartamento%>';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='periodorequisicao_cad.asp';
		</script>
		<%
		end if
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>