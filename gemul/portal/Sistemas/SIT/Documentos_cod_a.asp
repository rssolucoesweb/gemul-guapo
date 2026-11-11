<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...:  Altera cadastro de documentos
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	'	on error resume next

	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodEmpresa		= session("codEmpresa")
	intCodigo 			= Trim(request.QueryString("txtCodigo"))
	intCodTipoDocumento	= Trim(request.QueryString("cmbTipoDocumento"))
	strDescricao		= Trim(request.QueryString("txtDescricao"))
	strData 			= formatadataBD(Trim(request.QueryString("txtData")))
	strPublicado		= Trim(request.QueryString("Publicado"))
	strUsuario_altr   	= session("strNomeUsuario")
	strData_hora_altr 	= formatadataBD(date) & " " & time 

	strMensagem = "Documento Alterado com sucesso..."
	
	sql = "Update SIT_Documentos Set"
	sql = sql & " CodTipoDocumento = " & intCodTipoDocumento & ","
	sql = sql & " Descricao = '" & strDescricao & "',"
	sql = sql & " Data = '" & strData & "',"
	sql = sql & " Publicado = '" & strPublicado & "'"
	sql = sql & " Where Codigo = " & intCodigo
	sql = sql & " And CodEmpresa = " & intCodEmpresa
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Documentos_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>