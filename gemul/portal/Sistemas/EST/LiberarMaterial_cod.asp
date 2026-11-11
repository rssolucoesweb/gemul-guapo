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
	strSituacao					= 4 'liberado

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
		strMensagem = "Solicitação liberada com sucesso. Deseja imprimir a solicitação?"
		sql = "update est_requisicao set codSituacao = 4, usuario_liberacao = '"& strUsuario_incl &"',data_liberacao = '" & strData_hora_incl & "'"
		sql = sql & " Where Codigo = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		'incluir movimentação
		strSituacaoAndamento = "Solicitação Liberada e Entregue"
		'strUsuario_incl
		'strData_hora_incl
		'intCodRequisicao
		%><!--#include file="../../../includes/inc_andamento_requisicao.asp"--><%		
		for i=0 to ubound(vetReq,2)
			codProduto = vetReq(1,i)
			codRequisicaoProduto = vetReq(0,i)
			intQtdeAutorizada = request.Form("txtQuantidadeAutorizada_"&intCodRequisicao&"_"&codProduto&"_"&codRequisicaoProduto)
			
			sql = "update est_requisicaoproduto set quantidade_liberada = "& intQtdeAutorizada
			sql = sql & " Where CodRequisicao = " & intCodRequisicao
			sql = sql & " And codProduto= " & codProduto
			sql = sql & " And codigo = " & codRequisicaoProduto
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		next
		
		'atualiza estoque
		sql = "set nocount on select _i.codProduto, sum(_i.quantidade_liberada) as qtde"
		sql = sql & " into #temp"
		sql = sql & " from est_requisicaoproduto _i"
		sql = sql & " inner join EST_PRODUTO _p on _p.CODIGO = _i.codProduto"
		sql = sql & " where _i.codRequisicao = " & intCodRequisicao 
		sql = sql & " group by _i.codProduto"
		sql = sql & " update _p"
		sql = sql & " set _p.QTD_ATUAL_ESTOQUE = "
		sql = sql & " 	case"
		sql = sql & " 		when _p.QTD_ATUAL_ESTOQUE - _i.qtde < 0 then 0"
		sql = sql & " 	else"
		sql = sql & " 		_p.QTD_ATUAL_ESTOQUE - _i.qtde"
		sql = sql & " 	end "
		sql = sql & " from #temp _i"
		sql = sql & " inner join EST_PRODUTO _p on _p.CODIGO = _i.codProduto"
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))		
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			if (confirm('<%=strMensagem%>'))
				window.location='Rel_SolicitacaoAutorizada_rel.asp?req=<%=intCodRequisicao%>'
			else
				window.location='LiberarMaterial_con.asp';
		</script>
		<%
		
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>