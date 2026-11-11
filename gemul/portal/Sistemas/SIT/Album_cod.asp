<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Album
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo	 		= Request("txtCodigo")
	intCodTipoAlbum		= Request.Form("cmbTipoAlbum")	
	strDescricao		= Trim(Request.Form("txtDescricao"))
	strData				= formataDataBD(Trim(Request.Form("txtData")))			
	
	' Dados do Usuario
	strUsuario_incl   = session("strNomeUsuario")
	strData_hora_incl = formatadataBD(date) & " " & time 
	strUsuario_altr   =	session("strNomeUsuario")
	strData_hora_altr = formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Album Salvo com sucesso..."
		
		sql = "SELECT Max(CodAlbum) as MaiorCodigo" 
		sql = sql & " FROM SIT_Album"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
		
		sql = "Insert Into SIT_Album(CodAlbum, CodEmpresa, CodTipoAlbum, Descricao, Data, "
		sql = sql & " UsuarioIncl, DataIncl, UsuarioAlt, DataAlt)"                  
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & intCodTipoAlbum & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strData & "',"
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	elseif acao="A" then
		
		strMensagem = "Album Alterado com sucesso..."
		
		sql = "Update SIT_Album Set"
		sql = sql & " CodTipoAlbum = " & intCodTipoAlbum & ","
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Data = '" & strData & "'"
		sql = sql & " Where CodAlbum = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa

	else
		
		strMensagem = "Album Excluido com sucesso..."
		
		sql = "Delete from SIT_AlbumFoto "
		sql = sql & " Where CodAlbum = " & intCodigo
		cnn.execute sql
		
		sql = "Delete From SIT_Album "
		sql = sql & " Where CodAlbum = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		
	end if
	
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao = "I" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AlbumFoto_cad.asp?CodAlbum=<%=intCodigo%>';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('Album_cad.asp');
		</script>
		<%
		end if
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>