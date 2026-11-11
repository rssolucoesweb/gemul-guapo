<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Noticias
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodNoticia 		= Trim(Request("txtCodNoticia"))
	strRetranca			= replace(Trim(Request.Form("txtRetranca")),"'","") 
	strTitulo			= replace(Trim(Request.Form("txtTitulo")),"'","")
	intCodTipoNoticia	= Trim(Request.Form("cmbTipoNoticia"))
	strData				= formatadataBD(replace(Trim(Request.Form("txtData")),"'","")) & " " & time						
	strNoticia			= replace(Request.Form("txtNoticia"),"'","")
	strResumoNoticia	= replace(Request.Form("txtResumoNoticia"),"'","")
	strDestaqueNoticia	= Trim(request.Form("chkNoticiaDestaque"))
	strFonteNoticia		= replace(Request.Form("txtFonte"),"'","")
	strNomeFoto     	= ""
	strAno				= year(date)
	strDiasAnuncio 		= Trim(Request.Form("txtDiasAnuncio"))
	strDataInicio 		= formatadataBD(replace(Trim(Request.Form("txtDataInicio")),"'","")) & " " & time	
	strDataFinal 		= formatadataBD(replace(Trim(Request.Form("txtDataFinal")),"'","")) & " " & time
	strSituacao 		= Trim(Request.Form("cmbSituacao"))
	strPublicado		= Trim(Request("cmbPublicado"))
	
	if strDestaqueNoticia = "" then	
		strDestaqueNoticia = "N"
	end if 
	
	' Dados do Usuario
	strUsuario_incl   =session("strNomeUsuario")
	strData_hora_incl = formatadataBD(date) & " " & time 
	strUsuario_altr   =	session("strNomeUsuario")
	strData_hora_altr = formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		if strDestaqueNoticia = "S" then 
			sql = "UPDATE SIT_Noticias SET Destaque = 'N'"
			cnn.execute sql
		end if
		
		sql = "SET NoCount ON Insert Into SIT_Noticias(CodEmpresa,Retranca, Titulo, CodTipoNoticia, Data, Ano, "
		sql = sql & " Noticia, ResumoNoticia, FonteNoticia, NomeFoto, Destaque, DataInicio, DiasAnuncio, DataFinal, Situacao, Publicado,  "
		sql = sql & " Usuario, DataIncl, UsuarioAlt, DataAlt)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strRetranca & "',"
		sql = sql & "'" & strTitulo & "',"
		sql = sql & "" & intCodTipoNoticia & ","
		sql = sql & "'" & strData & "',"
		sql = sql & "" & strAno & ","
		sql = sql & "'" & strNoticia & "',"
		sql = sql & "'" & strResumoNoticia & "',"

		if strFonteNoticia <>"" then 
			sql = sql & "'" & strFonteNoticia & "',"
		else
			sql = sql & "null,"
		end if
		
		if strNomeFoto <>"" then 
			sql = sql & "'" & strNomeFoto & "',"
		else
			sql = sql & "null, "
		end if
		
		sql = sql & "'" & strDestaqueNoticia & "',"
		sql = sql & "'" & strDataInicio & "',"
		sql = sql & "" & strDiasAnuncio & ","
		sql = sql & "'" & strDataFinal & "',"
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strPublicado & "',"

		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		sql = sql & " ;SELECT @@IDENTITY "	
		Set rs = cnn.Execute(sql)
		intCodNoticia = rs(0)
		rs.close
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
	elseif acao="A" then
		
		strMensagem = "Registro alterada com sucesso..."
		
		if strDestaqueNoticia = "S" then 
			sql = "UPDATE SIT_Noticias SET Destaque = 'N'"
			cnn.execute sql
		end if
		
		sql = "Update SIT_Noticias Set"
		sql = sql & " Retranca = '" & strRetranca & "',"
		sql = sql & " Titulo = '" & strTitulo & "',"
		sql = sql & " CodTipoNoticia = " & intCodTipoNoticia & ","
		sql = sql & " Data = '" & strData & "',"
		sql = sql & " Ano = " & strAno & ","
		sql = sql & " Noticia = '" & strNoticia  & "',"
		sql = sql & " ResumoNoticia = '" & strResumoNoticia  & "',"
		sql = sql & " Destaque = '" & strDestaqueNoticia  & "',"
		
		if strFonteNoticia <>"" then 
			sql = sql & " FonteNoticia = '" & strFonteNoticia  & "',"
		else
			sql = sql & " FonteNoticia = null,"
		end if
		
		sql = sql & " DataInicio = '" & strDataInicio & "',"
		sql = sql & " DiasAnuncio = " & strDiasAnuncio & ","
		sql = sql & " DataFinal = '" & strDataFinal & "',"
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " Publicado = '" & strPublicado & "',"
		sql = sql & " UsuarioAlt = '" & strUsuario_incl  & "',"
		sql = sql & " DataAlt = '" & strData_hora_incl  & "'"
		sql = sql & " Where Codigo = " & intCodNoticia
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
	elseif acao="EF" then
	
		strMensagem = "Foto Excluido com sucesso..."
		
		sql = "Update SET_Noticias Set"
		sql = sql & " NomeFoto = null" 
		sql = sql & " where Codigo = " & intCodNoticia
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		'Exclui foto da pasta
		PastaFotos = Server.MapPath("../../../FotoNoticia") & "\" & intCodEmpresa & "\" & intCodNoticia
		
		Set objFSO = CreateObject("Scripting.FileSystemObject")
		
		IF objFSO.FileExists(PastaFotos & "\" & intCodNoticia & ".jpg") = True THEN objFSO.DeleteFile PastaFotos & "\" & intCodNoticia & ".jpg", True
		
		objFSO.DeleteFile PastaFotos 

	else
	
		strMensagem = "Registro excluido com sucesso..."
		
		sql = "Delete from SIT_NoticiaFoto "
		sql = sql & " Where CodNoticia = " & intCodNoticia
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		sql = "Delete from SIT_Noticias "
		sql = sql & " where Codigo = " & intCodNoticia
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
	end if

	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao = "E" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.localtion='Noticia_cad.asp';
		</script>
		<%
		end if
		
		if acao <> "EF" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Noticia_cad.asp?txtCodNoticia=<%=intCodNoticia%>';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('NoticiaFoto_cad.asp?codNoticia=<%=intCodNoticia%>');
		</script>
		<%
		end if
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>