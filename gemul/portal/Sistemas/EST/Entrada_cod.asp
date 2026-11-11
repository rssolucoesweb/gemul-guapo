<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 27/10/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadatro de Entrada
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
'	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodEntrada				= replace(Trim(Request("txtCodigo")),"'","")
	intCodEmpresa				= session("codEmpresa")	
	  
	intFornecedor				= Trim(Request.Form("cmbFornecedor"))
	strNumeroNota				= replace(Trim(Request("txtNumeroNota")),"'","")
	strDataEntrada				= formatadataBD(replace(Trim(Request.Form("txtDataEntrada")),"'","")) 
	strValorNota				= Replace(Replace(trim(Request("txtValorNota")),".",""), ",",".")
	intQtdeItens				= request("txtItens")
	strOcorrencia				= "Entrada da nota fiscal número: " & strNumeroNota & " foi removida. Codigo:" & intCodEntrada & "."
	strObs						= replace(Trim(Request.Form("txtObservacao")),"'","")
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Entrada salva com sucesso..."
		
		' Dados do Objetivo]
		sql = "SET NoCount ON"
		sql = sql & " Insert Into EST_Entrada( CodEmpresa, CodFornecedor, Numero, Data_Entrada, Valor_Total, obs, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr )" 
		sql = sql & " Values ("
		
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & intFornecedor & ","
		sql = sql & "'" & strNumeroNota & "',"
		sql = sql & "'" & strDataEntrada & "',"
		sql = sql & "" & strValorNota & ","
		sql = sql & "'" & strObs & "',"
			
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		sql = sql & " ;SELECT @@IDENTITY "	
		
		Set rs = cnn.Execute(sql)
		intCodEntrada = rs(0)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		'+-------------------------------------------------------------------------------------------------------------------------
		' Itens
		if intQtdeItens <> 0 then 
		
			for i=1 to intQtdeItens
				
				intCodProduto				= Trim(Request.Form("cmbProdutoEntrada" & i))
				strQtde						= Trim(Request.Form("txtQtde" & i))
				if strQtde = "" then strQtde= "0"
				strValor					= Trim(Request.Form("txtValor" & i))
				strValorUnitario			= Replace(Replace(trim(strValor),".",""), ",",".")
				
				if intCodProduto <> "0" then
				
					sql = "Insert Into EST_EntradaItens (CodEntrada, CodProduto, Quantidade, valor_unitario )"
					sql = sql & " values ( "
					sql = sql & "" & intCodEntrada & ","
					sql = sql & "" & intCodProduto & ","
					sql = sql & "" & strQtde & ","
					sql = sql & "" & strValorUnitario & ")"
					cnn.execute sql
					GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
					
				end if
			next
			
				
			sql = "set nocount on select _i.codProduto, sum(_i.quantidade) as qtde"
			sql = sql & " into #temp"
			sql = sql & " from EST_EntradaItens _i"
			sql = sql & " inner join EST_PRODUTO _p on _p.CODIGO = _i.codProduto"
			sql = sql & " where _i.codEntrada = " & intCodEntrada 
			sql = sql & " group by _i.codProduto"
			sql = sql & " update _p"
			sql = sql & " set _p.QTD_ATUAL_ESTOQUE = _p.QTD_ATUAL_ESTOQUE + _i.qtde"
			sql = sql & " from #temp _i"
			sql = sql & " inner join EST_PRODUTO _p on _p.CODIGO = _i.codProduto"
			cnn.execute sql
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))			
		end if

	elseif acao="A" then


	elseif acao="E" then
	
		codDepartamento = ""
		sql = "SELECT codDepartamento  "
		sql = sql & " FROM SEG_usuarios "
		sql = sql & " Where cpf = '" & session("strNomeUsuario") & "'"
		rsAux.open sql, cnn
		if not rsAux.eof then	
			codDepartamento = rsAux("codDepartamento")
		end if
	
		strMensagem = "Entrada Excluida com sucesso..."
		
		'ocorrencia de exclusão
		sql = " Insert Into EST_Ocorrencias( Cod_Empresa, cod_Departamento, cod_tela, pagina_asp, tela, ocorrencia, usuario_incl, data_incl)" 
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		if codDepartamento = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & codDepartamento & ","
		end if
		sql = sql & "" & intCodEntrada & ","
		sql = sql & "'entrada_cod.asp',"
		sql = sql & "'Entrada de Material',"
		sql = sql & "'" & strOcorrencia & "',"
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "getdate())"
		cnn.execute sql
		
		sql = "set nocount on select _i.codProduto, sum(_i.quantidade) as qtde"
		sql = sql & " into #temp"
		sql = sql & " from EST_EntradaItens _i"
		sql = sql & " inner join EST_PRODUTO _p on _p.CODIGO = _i.codProduto"
		sql = sql & " where _i.codEntrada = " & intCodEntrada 
		sql = sql & " group by _i.codProduto"
		sql = sql & " update _p"
		sql = sql & " set _p.QTD_ATUAL_ESTOQUE = _p.QTD_ATUAL_ESTOQUE - _i.qtde"
		sql = sql & " from #temp _i"
		sql = sql & " inner join EST_PRODUTO _p on _p.CODIGO = _i.codProduto"
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		' Exclui Entrada
		sql = "update EST_Entrada set excluida = 'S' "
		sql = sql & " Where Codigo = " & intCodEntrada
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
	end if
		
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Entrada_cad.asp?txtCodigo=<%=intCodEntrada%>';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>