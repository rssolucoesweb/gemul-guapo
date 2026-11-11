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
	intCodEmpresa				= session("codEmpresa")	
	intCodigo 					= Trim(Request.Form("txtCodigo"))
	intCodRequisicao			= Trim(Request.Form("txtCodRequisicao"))
	intCodDepartamento			= Trim(Request.Form("cmbDepartamento"))
	strSolicitante				= session("strNomeUsuario")
	intCodProduto				= Trim(Request.Form("cmbProduto"))
	intQuantidade				= Trim(Request.Form("txtQuantidade"))
	strObs						= replace(Trim(Request.Form("txtObs")),"'","")
	intSecaoProduto				= Trim(Request.Form("cmbSecaoProduto"))
	strSituacao					= 1

	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		strMensagem = "Registro salvo com sucesso..."
		
		if intCodRequisicao="" then
			
					
			sql = "SET NoCount ON Insert Into est_requisicao(codEmpresa,cod_secao,solicitante,codDepartamento,dataEntrada,codSituacao,obs,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"          
			sql = sql & " Values ("
			sql = sql & "" & intCodEmpresa & ","
			sql = sql & "" & intSecaoProduto & ","
			sql = sql & "'" & strSolicitante & "',"
			sql = sql & "" & intCodDepartamento & ","
			sql = sql & "'" & strData_hora_incl & "',"
			sql = sql & "1,"
			sql = sql & "'" & strObs & "',"
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "',"
			' Campos nulos para campo Usuario Alteracao e data Alteracao'
			sql = sql & "" & "null, null" & ")"
			sql = sql & " ;SELECT @@IDENTITY "	
			
			Set rs = cnn.Execute(sql)
			intCodRequisicao = rs(0)
			rs.close
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

			'incluir movimentação
			strSituacaoAndamento = "Iniciada a digitação da distribuição"
			'strUsuario_incl
			'strData_hora_incl
			'intCodRequisicao
			%><!--#include file="../../../includes/inc_andamento_requisicao.asp"--><%

		else
			sql = "UPDATE est_requisicao SET "          
			sql = sql & " OBS='" & strObs & "'"
			sql = sql & " where CODIGO = " & intCodRequisicao
			cnn.Execute(sql)
		end if
		
		'verifica se o material já existe nessa solicitação
		sql = "select codigo"
		sql = sql & " from est_requisicaoproduto"
		sql = sql & " where codRequisicao = " & intCodRequisicao
		sql = sql & " and codProduto = " & intCodProduto
		rs.open sql, cnn
		if not rs.eof then
			rs.close
			%>
			<script>
				alert("ATENÇÃO: Já foi incluído esse mesmo material nesta distribuição, caso deseje incluí-lo novamente, você deverá excluí-lo e incluí-lo com a quantidade correta.");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		rs.close
		
		sql = "Insert Into est_requisicaoproduto(codRequisicao,codProduto,unidade,quantidade,quantidade_autorizada,quantidade_liberada,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"          
		sql = sql & " Values ("
		sql = sql & "" & intCodRequisicao & ","
		sql = sql & "" & intCodProduto & ","
		sql = sql & "null,"
		sql = sql & "" & intQuantidade & ","
		sql = sql & "" & intQuantidade & ","
		sql = sql & "" & intQuantidade & ","
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
	elseif acao="EXCLUIR" then
		
		strMensagem = "Registro excluida com sucesso..."
		
		sql = "Delete from est_requisicaoproduto "
		sql = sql & " where codRequisicao = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

		sql = "Delete from EST_RequisicaoAndamento "
		sql = sql & " where codRequisicao = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		sql = "Delete from est_requisicao "
		sql = sql & " Where Codigo = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		acao="E" 
	elseif acao="EM" then
		intCodRequisicao			= Trim(Request("txtCodRequisicao"))
		intCodigo					= Trim(Request("codigo"))
		strMensagem = "Material excluido com sucesso..."
		
		sql = "Delete from est_requisicaoproduto "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And codRequisicao = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

		acao="I"
		bolExiste = "S"
		sql = "select codigo from est_requisicaoproduto "
		sql = sql & " where codRequisicao = " & intCodRequisicao
		rs.open sql, cnn
		if rs.eof then
			bolExiste = "N"
		end if
		rs.close

		if bolExiste = "N" then
			sql = "Delete from EST_RequisicaoAndamento "
			sql = sql & " where codRequisicao = " & intCodRequisicao
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
			
			sql = "Delete from est_requisicao "
			sql = sql & " Where Codigo = " & intCodRequisicao
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
			acao="E"
			strMensagem = "Material e distribuição foram excluidos com sucesso..."
			 
		end if 

	elseif acao="F" then
		
		strMensagem = "Distribuição foi enviada para autorizacao."
		sql = "update est_requisicao set codSituacao = 2 "
		sql = sql & " Where Codigo = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

		sql = "Insert est_requisicaoDistribuicao (codRequisicao, usuario_incl, data_hora_incl) values (" & intCodRequisicao & ",'"&strUsuario_incl&"',getdate())"
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		sql = "update est_requisicaoproduto set quantidade_autorizada = quantidade, quantidade_liberada = quantidade "
		sql = sql & " Where CodRequisicao = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		'incluir movimentação
		strSituacaoAndamento = "Enviado para Autorização"
		'strUsuario_incl
		'strData_hora_incl
		'intCodRequisicao
		%><!--#include file="../../../includes/inc_andamento_requisicao.asp"--><%
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="E" or acao="F" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Distribuicao_cad.asp';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Distribuicao_cad.asp?txtCodRequisicao=<%=intCodRequisicao%>';
		</script>
		<%
		end if
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>