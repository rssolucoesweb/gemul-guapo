<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--
	::	IMOB
	::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: incluir liberacao
	::	Data Atualizacao..: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmpresa				= session("codEmpresa")	
	intCodRequisicao 			= Trim(Request("req"))
	strSituacao					= 3 'autorizado

	' Dados do Usuario
	strUsuario_incl   	=	request.Form("usuarioAutorizacao")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	request.Form("usuarioAutorizacao")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 


	sql = "  select	_rp.codigo, _rp.codProduto"									
	sql = sql & " from EST_RequisicaoProduto _rp"
	sql = sql & " inner join EST_PRODUTO _p on _p.codigo = _rp.codProduto"
	sql = sql & " where _rp.codRequisicao = "& intCodRequisicao
	sql = sql & " order by 1"
	vetReq = null
	rs.open sql, cnn
	if not rs.eof then
		vetReq = rs.getRows
	end if
	rs.close
		
	if isArray(vetReq) then
		strMensagem = "Solicitação autorizada com sucesso."
		sql = "update est_requisicao set codSituacao = 3, usuario_autorizacao = '"& strUsuario_incl &"',data_autorizacao = '" & strData_hora_incl & "'"
		sql = sql & " Where Codigo = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		'incluir movimentação
		strSituacaoAndamento = "Solicitação Autorizada"
		'strUsuario_incl
		'strData_hora_incl
		'intCodRequisicao
		%><!--#include file="../../../includes/inc_andamento_requisicao.asp"--><%		
		for i=0 to ubound(vetReq,2)
			codProduto = vetReq(1,i)
			codRequisicaoProduto = vetReq(0,i)
			intQtdeAutorizada = request.Form("txtQuantidadeAutorizada_"&intCodRequisicao&"_"&codProduto&"_"&codRequisicaoProduto)
			intQtdeAtualEstoque = request.Form("txtQuantEstoqueDisp_"&intCodRequisicao&"_"&codProduto&"_"&codRequisicaoProduto)
			
			if cLng(intQtdeAutorizada) > cLng(intQtdeAtualEstoque) then intQtdeAutorizada = intQtdeAtualEstoque
						
			sql = "update est_requisicaoproduto set quantidade_autorizada = "& intQtdeAutorizada
			sql = sql & " ,quantidade_liberada = "& intQtdeAutorizada
			sql = sql & " Where CodRequisicao = " & intCodRequisicao
			sql = sql & " And codProduto= " & codProduto
			sql = sql & " And codigo = " & codRequisicaoProduto
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		next
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='LiberarRequisicao_con.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>