<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	strAcao 			= request.QueryString("acao")
	
	intCodigo		= request.Form("txtCodigo")
	strDescricao 		= ReplaceRequest(request.Form("txtDescricao"))
	
	cnn.begintrans

	if strAcao = "I" then
		
		strMensagem = session("strMensagemInclusao")	
		
		'insere item no menu
		sql = "Insert Into SEG_grupo (descricao)" 
		sql = sql & " Values ('" & strDescricao & "')"
		cnn.execute sql
	elseif strAcao = "A" then
		
		strMensagem = session("strMensagemAlteracao")
		
		'altera item no menu
		sql = "update SEG_grupo set "
		sql = sql & " descricao = '" & strDescricao & "' "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql		
	elseif strAcao = "E" then
		
		strMensagem = session("strMensagemExclusao")
		
		' Exclui os dados referente ao menu
		sql = " DELETE FROM SEG_grupo"
		sql = sql & " Where codigo = " & intCodigo
		cnn.execute sql		
	 
	end if

	if err.number = 0 then
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Seg_grupo_cad.asp?acao=<%=strAcao%>&codMenu=<%=intCodMenu%>';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans 
		response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='modulos/academico/Seg_InclusaoUsrGrupo_cad.asp'"
	end if
%>