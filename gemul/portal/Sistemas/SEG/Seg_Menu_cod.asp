<!--
	::	IMOB
	::	Data de Criação...: 12/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Inclusão de Menu (pagina de gravar)
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
<!--#include file="../../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	strAcao 			= request.QueryString("acao")
	
	intCodMenu 			= request.Form("codMenu")
	intCodModulo		= request.Form("CodModulo")
	strDescricao 		= ReplaceRequest(request.Form("txtDescricao"))
	strLink 			= ReplaceRequest(request.Form("txtLink"))
	strImagem 			= ReplaceRequest(request.Form("txtImagem"))
	strScript 			= ReplaceRequest(request.Form("txtScript"))
	intOrdem 			= ReplaceRequest(request.Form("txtOrdem"))
	strComentario 		= ReplaceRequest(request.Form("txtComentario"))
	intAnoInicio 		= ReplaceRequest(request.Form("txtAnoInicio"))
	intAnoTermino		= ReplaceRequest(request.Form("txtAnoTermino"))
	
	' Dados do Usuario	
	strUsuario_incl 		= session("strUsuario")
	strData_hora_incl 	= formataDataBd(date) & " " & time
	strUsuario_altr 		= session("strUsuario")
	strData_hora_altr		= formataDataBd(date) & " " & time

	'on error resume next
	cnn.begintrans

	if strAcao = "I" then
		
		strMensagem = session("strMensagemInclusao")	
		
		'insere item no menu
		sql = "Insert Into SEG_menu (codigo_SEG_menu, codigo_seg_modulo, "
		sql = sql & " ordem, descricao, link, "
		sql = sql & " imagem, script, comentario, Ano_Inicio, Ano_termino, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)" 
		sql = sql & " Values ("
		
		sql = sql & intCodMenu & ","
		sql = sql & intCodModulo & ","
		sql = sql & intOrdem & ","
		sql = sql & "'" & strDescricao & "',"
		if strLink <> "" then
			sql = sql & "'" & strLink & "',"
		else
			sql = sql & "null,"
		end if
		if strImagem <> "" then
			sql = sql & "'" & strImagem & "',"
		else
			sql = sql & "null,"
		end if
		if strScript <> "" then
			sql = sql & "'" & strScript & "',"
		else
			sql = sql & "null,"
		end if
		if strComentario <> "" then
			sql = sql & "'" & strComentario & "',"
		else
			sql = sql & "null,"
		end if

		if intAnoInicio <> "" then
			sql = sql & "" & intAnoInicio & ","
		else
			sql = sql & "1900,"
		end if
		if intAnoTermino <> "" then
			sql = sql & "" & intAnoTermino & ","
		else
			sql = sql & "32000,"
		end if

		' Usuario do Sistema
		if strUsuario_incl <> "" then
			sql = sql & "'" & strUsuario_incl & "',"
		else
			sql = sql & "null,"
		end if
		
		if strData_hora_incl <> "" then
			sql = sql & "'" & strData_hora_incl & "',"
		else
			sql = sql & "null,"
		end if
		
		'Campos nulos para campo Usuario Alteracao e data Alteracao
		sql = sql & "" & "null, null" & ")"
		

		cnn.execute sql
	elseif strAcao = "A" then
		
		strMensagem = session("strMensagemAlteracao")
		
		'altera item no menu
		sql = "update SEG_menu set "
		sql = sql & " ordem = " & intOrdem & ", "
		sql = sql & " descricao = '" & strDescricao & "', "
		sql = sql & " codigo_seg_modulo = " & intCodModulo & ", "
		
		if strLink <> "" then
			sql = sql & " link = '" & strLink & "',"
		else
			sql = sql & " link = null,"
		end if
		if strImagem <> "" then
			sql = sql & " imagem = '" & strImagem & "', "
		else
			sql = sql & " imagem = null, "
		end if
		if strScript <> "" then
			sql = sql & "script = '" & strScript & "',"
		else
			sql = sql & "script = null,"
		end if
		if strComentario <> "" then
			sql = sql & "comentario = '" & strComentario & "',"
		else
			sql = sql & "comentario = null,"
		end if
		if intAnoInicio <> "" then
			sql = sql & "ano_inicio = " & intAnoInicio & ","
		else
			sql = sql & "ano_inicio = 1900,"
		end if
		if intAnoTermino <> "" then
			sql = sql & "ano_termino = " & intAnoTermino & ","
		else
			sql = sql & "ano_termino = 32000,"
		end if
		
		if strUsuario_incl <> "" then
			sql = sql & "usuario_altr = '" & strUsuario_incl & "',"
		else
			sql = sql & "usuario_altr = null,"
		end if		
		if strData_hora_incl <> "" then
			sql = sql & "data_hora_altr = '" & strData_hora_incl & "'"
		else
			sql = sql & "data_hora_altr = null"
		end if
		sql = sql & " where codigo = " & intCodMenu
		cnn.execute sql		
	elseif strAcao = "E" then
		
		strMensagem = session("strMensagemExclusao")
		
		' Exclui os dados referente ao menu
		sql = " DELETE FROM SEG_menu"
		sql = sql & " Where codigo = " & intCodMenu
		sql = sql & " and codigo_seg_modulo = " & intCodModulo
		cnn.execute sql		
	 
	end if

	if err.number = 0 then
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Seg_menu_cad.asp?acao=<%=strAcao%>&codMenu=<%=intCodMenu%>&CodModulo=<%=intCodModulo%>';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans 
		response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='modulos/academico/Seg_InclusaoUsrGrupo_cad.asp'"
	end if
%>