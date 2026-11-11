<!--
	::	IMOB
	::	Data de CriaÃ§Ã£o...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir sub grupo
	::	Data Atualizacao..: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzaÃ§Ã£o--------------
	cnn.begintrans
	
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmpresa				= session("codEmpresa")	
	intCodigo 					= Trim(Request.Form("txtCodigo"))
	strDescricaoProduto			= Trim(Request.Form("txtDescricaoProduto"))
	intCodMarca					= Trim(Request.Form("cmbMarcaProduto"))
	intUnidadeProduto			= Trim(Request.Form("cmbUnidadeProduto"))
	intGrupoProduto				= Trim(Request.Form("cmbGrupoProduto")) 
	intSubGrupoProduto			= Trim(Request.Form("cmbSubGrupoProduto")) 
	intEstMinimo		 		= Trim(Request.Form("txtEstMinimo"))
	intEstMaximo		 		= Trim(Request.Form("txtEstMaximo"))
	strQtdAtualEst		 		= Trim(Request.Form("txtQtdAtualEst"))
	strPrecoCusto		 		= Replace(Replace(trim(Request("txtPrecoCusto")),".",""), ",",".")
	strMargemLucro		 		= Replace(Replace(Trim(Request.Form("txtMargemLucro")),".",""), ",",".")
	strPrecoVenda		 		= Replace(Replace(trim(Request("txtPrecoVenda")),".",""), ",",".")
	intSecaoProduto				= Trim(Request.Form("cmbSecaoProduto"))
	strReferProduto		 		= Trim(Request.Form("txtReferProduto"))
	intEAN				 		= Trim(Request.Form("txtEAN"))
	intFornecedor		 		= Trim(Request.Form("cmbFornecedor"))
	strAcessoProduto		 	= Trim(Request.Form("chkAcessoProduto"))
	strTombamento			 	= Trim(Request.Form("tombamento"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		strSituacao = "A"
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "SET NoCount ON Insert Into est_produto(COD_EMPRESA,DESCRICAO, COD_MARCA,COD_UNIDADE,COD_SUBGRUPO,ESTOQUE_MINIMO,ESTOQUE_MAXIMO,"
		sql = sql & "QTD_ATUAL_ESTOQUE,PRECO_CUSTO,PRECO_VENDA,MARGEM_LUCRO,COD_SECAO,REFERENCIA,CODG_BARRAS,OBSERVACAO,situacao,Tombamento, usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"          
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		if strDescricaoProduto = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strDescricaoProduto & "',"
		end if
		if intCodMarca = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodMarca & ","
		end if
		
		if intUnidadeProduto = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intUnidadeProduto & ","
		end if
		if intSubGrupoProduto = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intSubGrupoProduto & ","
		end if
		if intEstMinimo = "" then
			sql = sql & "0,"
		else
			sql = sql & "" & intEstMinimo & ","
		end if
		if intEstMaximo = "" then
			sql = sql & "0,"
		else
			sql = sql & "" & intEstMaximo & ","
		end if
		if strQtdAtualEst = "" then
			sql = sql & "0,"
		else
			sql = sql & "" & strQtdAtualEst & ","
		end if
		if strPrecoCusto = "" then
			sql = sql & "0,"
		else
			sql = sql & "" & strPrecoCusto & ","
		end if
		if strPrecoVenda = "" then
			sql = sql & "0,"
		else
			sql = sql & "" & strPrecoVenda & ","
		end if
		if strMargemLucro = "" then
			sql = sql & "0,"
		else
			sql = sql & "" & strMargemLucro & ","
		end if
		sql = sql & "" & intSecaoProduto & ","
		if strReferProduto = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strReferProduto & "',"
		end if
		
		if intEAN = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & intEAN & "',"
		end if
		if strObsProduto = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strObsProduto & "',"
		end if
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strTombamento & "',"
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		sql = sql & " ;SELECT @@IDENTITY "	
			
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		if strAcessoProduto<>"" then
			vetAcessoProduto = split(strAcessoProduto,",")
			for i=0 to ubound(vetAcessoProduto)
				sql = "INSERT est_produto_acesso (COD_PRODUTO,ACESSO,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr) values ( "
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & trim(vetAcessoProduto(i)) & "',"
				sql = sql & "'" & strUsuario_incl & "',"
				sql = sql & "'" & strData_hora_incl & "',"
				sql = sql & "'" & strUsuario_incl & "',"
				sql = sql & "'" & strData_hora_incl & "')"
				cnn.execute sql
				GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))		
			next
		end if
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "Update est_produto Set "

		if strDescricaoProduto = "" then
			sql = sql & "DESCRICAO=null,"
		else
			sql = sql & "DESCRICAO='" & strDescricaoProduto & "',"
		end if
		if intUnidadeProduto = "0" then
			sql = sql & "COD_UNIDADE=null,"
		else
			sql = sql & "COD_UNIDADE=" & intUnidadeProduto & ","
		end if
		if intSubGrupoProduto = "" then
			sql = sql & "COD_SUBGRUPO=null,"
		else
			sql = sql & "COD_SUBGRUPO=" & intSubGrupoProduto & ","
		end if
		if intEstMinimo = "" then
			sql = sql & "ESTOQUE_MINIMO=0,"
		else
			sql = sql & "ESTOQUE_MINIMO=" & intEstMinimo & ","
		end if
		if intEstMaximo = "" then
			sql = sql & "ESTOQUE_MAXIMO=0,"
		else
			sql = sql & "ESTOQUE_MAXIMO=" & intEstMaximo & ","
		end if
		if strPrecoCusto = "" then
			sql = sql & "PRECO_CUSTO=0,"
		else
			sql = sql & "PRECO_CUSTO=" & strPrecoCusto & ","
		end if
		if strMargemLucro = "" then
			sql = sql & "MARGEM_LUCRO=0,"
		else
			sql = sql & "MARGEM_LUCRO=" & strMargemLucro & ","
		end if
		if strPrecoVenda = "" then
			sql = sql & "PRECO_VENDA=0,"
		else
			sql = sql & "PRECO_VENDA=" & strPrecoVenda & ","
		end if
		sql = sql & "COD_SECAO=" & intSecaoProduto & ","
		if strReferProduto = "" then
			sql = sql & "REFERENCIA=null,"
		else
			sql = sql & "REFERENCIA='" & strReferProduto & "',"
		end if
		
		if intEAN = "" then
			sql = sql & "CODG_BARRAS=null,"
		else
			sql = sql & "CODG_BARRAS='" & intEAN & "',"
		end if
		if strObsProduto = "" then
			sql = sql & "OBSERVACAO=null,"
		else
			sql = sql & "OBSERVACAO='" & strObsProduto & "',"
		end if
		if intCodMarca = "0" then
			sql = sql & "COD_MARCA=null,"
		else
			sql = sql & "COD_MARCA=" & intCodMarca & ","
		end if
		sql = sql & " Tombamento='" & strTombamento & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
		
		sql = " delete est_produto_acesso Where Cod_produto = " & intCodigo 
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
		
		if strAcessoProduto<>"" then
			vetAcessoProduto = split(strAcessoProduto,",")
			for i=0 to ubound(vetAcessoProduto)
				sql = "INSERT est_produto_acesso (COD_PRODUTO,ACESSO,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr) values ( "
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & trim(vetAcessoProduto(i)) & "',"
				sql = sql & "'" & strUsuario_incl & "',"
				sql = sql & "'" & strData_hora_incl & "',"
				sql = sql & "'" & strUsuario_incl & "',"
				sql = sql & "'" & strData_hora_incl & "')"
				cnn.execute sql
				GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))		
			next
		end if
	else
		strMensagem = "Registro excluida com sucesso..."
	
		sql = "  select codigo"									
		sql = sql & " from EST_RequisicaoProduto"
		sql = sql & " where codProduto = "& intCodigo
		rsAux.open sql, cnn
		if not rsAux.eof then
			rsAux.close
			%>
			<script>
            	alert("ATENÇÃO: Esse produto nãopode ser excluido, existe solicitaçõess vinculada a ele.");
				window.history.back();
            </script>
			<%
			response.End()
		end if
		rsAux.close
		sql = " delete est_produto_acesso Where Cod_produto = " & intCodigo 
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
		sql = "Delete from est_produto "
		sql = sql & " Where Codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzaÃ§Ã£o iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Produto_cad.asp?txtCodigo=<%=intCodigo%>&cmbSecaoProduto=<%=intSecaoProduto%>';
        </script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>