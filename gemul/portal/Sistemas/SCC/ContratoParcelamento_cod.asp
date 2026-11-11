<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 05/07/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Assunto
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	intQtde		 		= Trim(Request.Form("txtQtde"))
	if intQtde = "" then intQtde = 0
	intCodContrato 		= Trim(Request.Form("txtCodContrato"))
	intValorContrato	= Trim(Request.Form("txtValorContrato"))	
	strParcela	 		= Trim(Request.Form("txtParcela"))
	strData		 		= formatadataBD(Trim(Request.Form("txtData")))
	strValor	 		= replace(replace(Trim(Request.Form("txtValor")),".",""),",",".")
	strSituacao	 		= Trim(Request.Form("cmbSituacao"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Registro salvo com sucesso..."
		if intQtde>0 then
			strValor				= formatNumber(intValorContrato/intQtde,2)
			mes_vencimento_parcela 	= month(strData)
			ano_vencimento_parcela 	= year(strData)
			dia_vencimento_parcela 	= day(strData)
			for i=1 to intQtde
				strParcela = i

				if mes_vencimento_parcela = 13 then
					mes_vencimento_parcela = 1
					ano_vencimento_parcela = ano_vencimento_parcela + 1
				end if
				
				if mes_vencimento_parcela = 2 and dia_vencimento_parcela > 28 then
					data_completa_mensal = ano_vencimento_parcela & "/" & mes_vencimento_parcela & "/28"
				else
					data_completa_mensal = ano_vencimento_parcela & "/" & mes_vencimento_parcela & "/" & dia_vencimento_parcela
				end if		

				sql = "Insert Into SCC_contrato_parcela(CodEmpresa, CodContrato, Parcela, Data, Valor, Situacao, "
				sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
				sql = sql & " Values ("
		
				sql = sql & "" & intCodEmpresa & "," 
				sql = sql & "" & intCodContrato & ","
				sql = sql & "" & strParcela & ","
				sql = sql & "'" & (data_completa_mensal) & "',"
				sql = sql & "" & replace(replace(strValor,".",""),",",".") & ","
				sql = sql & "'" & strSituacao & "',"
		
				' Usuario do Sistema
				sql = sql & "'" & strUsuario_incl & "',"
				sql = sql & "'" & strData_hora_incl & "',"
				
				' Campos nulos para campo Usuario Alteracao e data Alteracao'
				sql = sql & "" & "null, null" & ")"
				cnn.execute sql
				GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
				
				mes_vencimento_parcela = mes_vencimento_parcela + 1

			next
		end if
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "Update SCC_contrato_parcela Set"
		sql = sql & " Parcela = " & strParcela & ","
		sql = sql & " Data = '" & strData & "',"
		sql = sql & " Valor = " & strValor & ","
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	else
		strMensagem = "Registro excluida com sucesso..."
		
		sql = "Delete from SCC_contrato_parcela "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
		cnn.execute sql
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ContratoParcelamento_cad.asp?txtCodContrato=<%=intCodContrato%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>