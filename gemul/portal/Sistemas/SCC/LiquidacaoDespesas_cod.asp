<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 05/07/2011
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Previsão Liquidação
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

	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strProcesso			= trim(Request.Form("cmbProcesso"))
	intCodTipo			= trim(Request.Form("cmbTipo"))
	if intCodTipo = "" then intCodTipo = "0"
	
	intCodTipoDocumento	= trim(Request.Form("cmbTipoDocumento"))
	if intCodTipoDocumento = "" then intCodTipoDocumento = "0"	
	
	strNumeroTipoDocumento	= trim(Request.Form("txtNumeroTipoDocumento"))
	strDataEmissao		= formataDataBD(trim(Request.Form("txtDataEmissao")))
	strDataVencimento	= formataDataBD(trim(Request.Form("txtDataVencimento")))

	intCodBeneficiario	= trim(Request.Form("cmbBeneficiario"))
	if intCodBeneficiario = "" then intCodBeneficiario = "0"	

	intCodGrupo	= trim(Request.Form("cmbGrupo"))
	if intCodGrupo = "" then intCodGrupo = "0"	

	intValor			= replace(replace(trim(Request.Form("txtValor")),".",""),",",".")
	strObs				= replace(trim(Request.Form("txtobs")),"'","")
	
	' Dados do Usuario
	strUsuario_incl   	= session("strNomeUsuario")
	strData_hora_incl 	= formatadataBD(date) & " " & time 
	strUsuario_altr   	= session("strNomeUsuario")
	strData_hora_altr 	= formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Insert Into SCC_previsao_liquidacao ( "
		sql = sql & " codEmpresa, "
		sql = sql & " codProcesso, "
		sql = sql & " tipo, "
		sql = sql & " codTipoDocumento, "
		sql = sql & " numeroTipoDocumento, "
		sql = sql & " dataEmissao, "
		sql = sql & " codGrupo, "
		sql = sql & " codBeneficiario, "
		sql = sql & " dataVencimento, "
		sql = sql & " ValorTotal, "
		sql = sql & " obs, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
	
		if strprocesso = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & strprocesso & ","
		end if

		if intCodTipo = "0" then
			sql = sql & "null,"
		else
			sql = sql & "'" & intCodTipo & "',"
		end if
		if intCodTipoDocumento = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodTipoDocumento & ","
		end if
		if strNumeroTipoDocumento = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strNumeroTipoDocumento & "',"
		end if
		if strDataEmissao = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strDataEmissao & "',"
		end if
		if intcodGrupo = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intcodGrupo & ","
		end if
		if intcodBeneficiario = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intcodBeneficiario & ","
		end if
		if strDataVencimento = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strDataVencimento & "',"
		end if
		
		if intValor  = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intValor & ","
		end if
		
		if strobs = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strobs & "',"
		end if
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		response.Write(sql)
	elseif acao="A" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Update SCC_previsao_liquidacao Set "
		if strprocesso = "0" then
			sql = sql & "codProcesso = null,"
		else
			sql = sql & "codProcesso = " & strprocesso & ","
		end if

		if intCodTipo = "0" then
			sql = sql & "tipo = null,"
		else
			sql = sql & "tipo = '" & intCodTipo & "',"
		end if
		if intCodTipoDocumento = "0" then
			sql = sql & "codTipoDocumento = null,"
		else
			sql = sql & "codTipoDocumento = " & intCodTipoDocumento & ","
		end if
		if strNumeroTipoDocumento = "" then
			sql = sql & "NumeroTipoDocumento = null,"
		else
			sql = sql & "NumeroTipoDocumento = '" & strNumeroTipoDocumento & "',"
		end if
		if strDataEmissao = "" then
			sql = sql & "dataEmissao = null,"
		else
			sql = sql & "dataEmissao = '" & strDataEmissao & "',"
		end if
		if intcodGrupo = "0" then
			sql = sql & "codGrupo = null,"
		else
			sql = sql & "codGrupo = " & intcodGrupo & ","
		end if
		if intcodBeneficiario = "0" then
			sql = sql & "codBeneficiario = null,"
		else
			sql = sql & "codBeneficiario = " & intcodBeneficiario & ","
		end if
		if strDataVencimento = "" then
			sql = sql & "DataVencimento = null,"
		else
			sql = sql & "DataVencimento = '" & strDataVencimento & "',"
		end if
		
		if intValor  = "" then
			sql = sql & "ValorTotal = null,"
		else
			sql = sql & "ValorTotal = " & intValor & ","
		end if
		
		if strobs = "" then
			sql = sql & "obs = null,"
		else
			sql = sql & "obs = '" & strobs & "',"
		end if
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
		
	else
		strMensagem = "Registro excluido com sucesso..."
		
		sql = "Delete from SCC_previsao_liquidacao "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
	
	end if
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='LIquidacaoDespesas_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>