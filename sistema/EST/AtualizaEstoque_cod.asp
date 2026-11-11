<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--
	::	IMOB
	::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir sub grupo
	::	Data Atualizacao..: 
-->
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmpresa				= session("codEmpresa")	
	intCodigo 					= Trim(Request.Form("txtCodigo"))
	intCodRequisicao			= Trim(Request.Form("txtCodRequisicao"))
	intConferencista			= Trim(Request.Form("cmbConferencista"))
	strSolicitante				= session("strNomeUsuario")
	intCodProduto				= Trim(Request.Form("cmbProduto"))
	intQuantidade				= Trim(Request.Form("txtQuantidade"))
	strMotivo					= replace(Trim(Request.Form("txtMotivo")),"'","")
	codBalanco					= Trim(Request.Form("codBalanco"))
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		strMensagem = "Registro salvo com sucesso..."
		
		if intCodRequisicao="" then
			sql = "SET NoCount ON Insert Into EST_ATUALIZACAO_ESTOQUE(codEmpresa,codBalanco,usuario,dataEntrada,codSituacao,motivo,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"          
			sql = sql & " Values ("
			sql = sql & "" & intCodEmpresa & ","
			sql = sql & "" & codBalanco & ","
			sql = sql & "'" & strSolicitante & "',"
			sql = sql & "'" & strData_hora_incl & "',1,"
			sql = sql & "'" & strMotivo & "',"
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
		end if
		
		sql = "Insert Into EST_ATUALIZACAO_ESTOQUE_PRODUTO(codAtualizacaoEstoque,codProduto,codConferencista, saldoExistente,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"          
		sql = sql & " Values ("
		sql = sql & "" & intCodRequisicao & ","
		sql = sql & "" & intCodProduto & ","
		sql = sql & "" & intConferencista & ","
		sql = sql & "" & intQuantidade &","
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		sql = "update EST_ATUALIZACAO_ESTOQUE set "
		sql = sql & " motivo = '" & strMotivo & "',"
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_incl & "'"
		sql = sql & " Where Codigo = " & intCodRequisicao
		sql = sql & " And codEmpresa = " & intCodEmpresa
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		sql = "update EST_ATUALIZACAO_ESTOQUE_PRODUTO set "
		sql = sql & " saldoExistente = " & intQuantidade & ","
		sql = sql & " codConferencista = " & intConferencista & ","
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_incl & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And codAtualizacaoEstoque = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

	elseif acao="E" then
		
		strMensagem = "Registro excluida com sucesso..."
		
		sql = "Delete from EST_ATUALIZACAO_ESTOQUE_PRODUTO "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And codAtualizacaoEstoque = " & intCodRequisicao
		sql = sql & " And CodProduto = "& intCodProduto
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

		acao="I"
		bolExiste = "S"
		sql = "select codigo from EST_ATUALIZACAO_ESTOQUE_PRODUTO "
		sql = sql & " where codAtualizacaoEstoque = " & intCodRequisicao
		rs.open sql, cnn
		if rs.eof then
			bolExiste = "N"
		end if
		rs.close

		if bolExiste = "N" then
			sql = "Delete from EST_ATUALIZACAO_ESTOQUE "
			sql = sql & " Where Codigo = " & intCodRequisicao
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
			acao="E" 
		end if 
	elseif acao="F" then
		strMensagem = "Estoque atualizado com sucesso."
		sql = "update EST_ATUALIZACAO_ESTOQUE set codSituacao = 2,"
		sql = sql & " motivo = '" & strMotivo & "'"
		sql = sql & " Where Codigo = " & intCodRequisicao
		sql = sql & " And codEmpresa = " & intCodEmpresa
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

		strMensagem = "Estoque atualizado com sucesso."
		sql = "update EST_BALANCO set SITUACAO = 'I',"
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_incl & "'"
		sql = sql & " Where Codigo = " & codBalanco
		sql = sql & " And cod_Empresa = " & intCodEmpresa
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		sql = "	set nocount on"
		sql = sql & " select isnull(sum(_e.SaldoExistente),0) as saldo, _e.codProduto"
		sql = sql & " into #temp"
		sql = sql & " from EST_ATUALIZACAO_ESTOQUE_produto _e"
		sql = sql & " inner join EST_PRODUTO _p on _p.codigo = _e.codProduto"
		sql = sql & " where _e.codAtualizacaoEstoque = " & intCodRequisicao
		sql = sql & " group by _e.codProduto"
		sql = sql & " update _p"
		sql = sql & " set _p.QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO = _p.QTD_ATUAL_ESTOQUE, _p.QTD_ATUAL_ESTOQUE = _e.saldo, _p.balanco='S', _p.data_balanco = getDate()"
		sql = sql & " from #temp _e"
		sql = sql & " inner join EST_PRODUTO _p on _p.codigo = _e.codProduto"
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="F" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='default.asp';
		</script>
		<%
		elseif acao="E" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AtualizaEstoque_cad.asp';
		</script>
		<%
		elseif acao="A" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AtualizaEstoque_cad.asp?txtCodRequisicao=<%=intCodRequisicao%>';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AtualizaEstoque_cad.asp?txtCodigo=<%=intCodigo%>&txtCodRequisicao=<%=intCodRequisicao%>';
		</script>
		<%
		end if
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>