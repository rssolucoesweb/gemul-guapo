<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 05/07/2011
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Contratos
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
	strNumero			= trim(Trim(Request.Form("txtnumero")))
	strAno				= trim(Request.Form("txtano"))
	strProcesso			= trim(Request.Form("cmbProcesso"))
	intCodDepartamento	= trim(Request.Form("cmbDepartamento"))
	if intcodDepartamento = "" then intcodDepartamento = "0"
	intCodBeneficiario	= trim(Request.Form("cmbContratado"))
	if intcodDepartamento = "" then intcodDepartamento = "0"
	strDataInicio		= formataDataBD(trim(Request.Form("txtDataInicial")))
	strDataFim			= formataDataBD(trim(Request.Form("txtdataFim")))
	strDataOutorga		= formataDataBD(trim(Request.Form("txtdataOutorga")))
	strDataPublicacao	= formataDataBD(trim(Request.Form("txtdataPublicacao")))
	strDataEntrega		= formataDataBD(trim(Request.Form("txtDataEntrega")))
	strNumeroDespacho	= trim(Request.Form("txtnumeroDespacho"))
	strAnoDespacho		= trim(Request.Form("txtanoDespacho"))
	strNumeroDiario		= trim(Request.Form("txtnumeroDiario"))
	strAnoDiario		= trim(Request.Form("txtanoDiario"))
	strNumeroFolha		= trim(Request.Form("txtnumeroFolha"))
	intTotalContrato	= replace(replace(trim(Request.Form("txttotalContrato")),".",""),",",".")
	strObs				= replace(trim(Request.Form("txtobs")),"'","")
	
	' Dados do Usuario
	strUsuario_incl   	= session("strNomeUsuario")
	strData_hora_incl 	= formatadataBD(date) & " " & time 
	strUsuario_altr   	= session("strNomeUsuario")
	strData_hora_altr 	= formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Insert Into SCC_contrato ( "
		sql = sql & " codEmpresa, "
		sql = sql & " numero, "
		sql = sql & " ano, "
		sql = sql & " codProcesso, "
		sql = sql & " codDepartamento, "
		sql = sql & " codBeneficiario, "
		sql = sql & " dataInicio, "
		sql = sql & " dataFim, "
		sql = sql & " dataOutorga, "
		sql = sql & " dataPublicacao, "
		sql = sql & " dataEntrega, "
		sql = sql & " numeroDespacho, "
		sql = sql & " anoDespacho, "
		sql = sql & " numeroDiario, "
		sql = sql & " anoDiario, "
		sql = sql & " numeroFolha, "
		sql = sql & " totalContrato, "
		sql = sql & " obs, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("


		if intCodEmpresa = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodEmpresa & ","
		end if
		sql = sql & "'" & strnumero & "',"
		sql = sql & "'" & strano & "',"
		
		if strprocesso = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strprocesso & "',"
		end if
		
		if intcodDepartamento = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intcodDepartamento & ","
		end if
		
		if intcodBeneficiario = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intcodBeneficiario & ","
		end if
		
		if strdataInicio = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strdataInicio & "',"
		end if
		
		if strdataFim = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strdataFim & "',"
		end if
		
		if strdataOutorga = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strdataOutorga & "',"
		end if
		
		if strdataPublicacao = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strdataPublicacao & "',"
		end if
		
		if strDataEntrega = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strDataEntrega & "',"
		end if
		if strnumeroDespacho = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strnumeroDespacho & "',"
		end if
		
		if stranoDespacho = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & stranoDespacho & "',"
		end if
		
		if strnumeroDiario = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strnumeroDiario & "',"
		end if
		
		if stranoDiario = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & stranoDiario & "',"
		end if
		
		if strnumeroFolha = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strnumeroFolha & "',"
		end if
		
		if inttotalContrato  = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & inttotalContrato & ","
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
		
	elseif acao="A" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Update SCC_contrato Set "
		sql = sql & "numero = '" & strnumero & "',"
		sql = sql & "ano = '" & strano & "',"
		
		if strprocesso = "0" then
			sql = sql & "codProcesso = null,"
		else
			sql = sql & "codProcesso = '" & strprocesso & "',"
		end if
		
		if intcodDepartamento = "0" then
			sql = sql & "codDepartamento = null,"
		else
			sql = sql & "codDepartamento = " & intcodDepartamento & ","
		end if
		if intcodBeneficiario = "0" then
			sql = sql & "codBeneficiario = null,"
		else
			sql = sql & "codBeneficiario = " & intcodBeneficiario & ","
		end if
		if strdataInicio = "" then
			sql = sql & "dataInicio = null,"
		else
			sql = sql & "dataInicio = '" & strdataInicio & "',"
		end if
		if strdataFim = "" then
			sql = sql & "dataFim = null,"
		else
			sql = sql & "dataFim = '" & strdataFim & "',"
		end if
		if strdataOutorga = "" then
			sql = sql & "dataOutorga = null,"
		else
			sql = sql & "dataOutorga = '" & strdataOutorga & "',"
		end if
		if strdataPublicacao = "" then
			sql = sql & "dataPublicacao = null,"
		else
			sql = sql & "dataPublicacao = '" & strdataPublicacao & "',"
		end if
		if strDataEntrega = "" then
			sql = sql & "DataEntrega = null,"
		else
			sql = sql & "DataEntrega = '" & strDataEntrega & "',"
		end if
		if strnumeroDespacho = "" then
			sql = sql & "numeroDespacho = null,"
		else
			sql = sql & "numeroDespacho = '" & strnumeroDespacho & "',"
		end if
		if stranoDespacho = "" then
			sql = sql & "anoDespacho = null,"
		else
			sql = sql & "anoDespacho = '" & stranoDespacho & "',"
		end if
		if strnumeroDiario = "" then
			sql = sql & "numeroDiario = null,"
		else
			sql = sql & "numeroDiario = '" & strnumeroDiario & "',"
		end if
		if stranoDiario = "" then
			sql = sql & "anoDiario = null,"
		else
			sql = sql & "anoDiario = '" & stranoDiario & "',"
		end if
		if strnumeroFolha = "" then
			sql = sql & "numeroFolha = null,"
		else
			sql = sql & "numeroFolha = '" & strnumeroFolha & "',"
		end if
		if inttotalContrato = "" then
			sql = sql & "totalContrato = null,"
		else
			sql = sql & "totalContrato = " & inttotalContrato & ","
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
		
		sql = "Delete from SCC_contrato "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
	
	end if
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if strDestino = "E" then
			strDestino = "Contrato_cad.asp"
		else
			strDestino = "Contrato_cad.asp?txtNumero=" & strNumero & "&txtAno=" & strAno
		end if
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=strDestino%>';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>