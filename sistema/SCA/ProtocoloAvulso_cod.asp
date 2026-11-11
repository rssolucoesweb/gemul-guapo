<!--
	::	Data de Criação...: 04/03/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Taxa avulsa de parcelas
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'On error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	strMensagem 		= "Protocolo avulso incluído com sucesso..."

	intCodAluno	 		= Trim(Request.Form("codAluno"))
	strMatricula 		= Trim(Request.Form("txtMatricula"))
	strCodDisciplina	= Trim(Request.Form("cmbDisciplinaAluno"))
	intCodEmp			= session("codEmpresa")
	intPrazo			= trim(request.form("txtPrazo"))
	if intPrazo <> "" then
		strDataVencimento = formatadataBD(DateAdd("d", intPrazo, date))
	end if
	intCodDepartamento	= trim(request.form("cmbDepartamento"))
	if intCodDepartamento = "" then intCodDepartamento = "1" 'financeiro
	if intCodDepartamento = "0" then intCodDepartamento = "1" 'financeiro

	intCodTaxa			= trim(request.form("cmbTaxa"))
	strValor			= replace(replace(trim(request.form("txtValor")),".",""),",",".")
	strProtocolo		= trim(request.form("txtProtocolo"))
	strDataEntrada 		= Trim(Request.Form("txtDataEntrada"))	
	strAno				= year(Date)
	intCodTipoParcela	= 4'taxa avulsa
	strParcelaComZero 	= "99"
	strReferenciaMensal	= ucase(monthname(month(date))) & "/" & year(date)

	if strProtocolo = "S" then
		'Gera Protocolo Automatica 
		'parametros:
		'	intCodEmp
		'	intCodDepartamento
		'	intCodAluno
		'	intCodTaxa
		'	strUsuarioIncl
		'	strSituacaoProtocolo
	
		intCodEmp			= Session("CodEmpresa")
		intCodDepartamento	= intCodDepartamento
		intCodDebitoAluno	= ""
		intCodAluno			= intCodAluno
		intCodTaxa			= intCodTaxa
		strDataSolicitacao	= formatadataBD(strDataEntrada)
		strDataEntrega		= ""
		strDataVencimento	= strDataVencimento
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strCodDisciplinaTaxa= strCodDisciplina
		strSituacaoProtocolo = "A"
		%>
		<!--#include file="../includes/inc_lancamentoDeProtocolo.asp"-->	
		<%
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.opener.frm.submit();
			window.close();	
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		msnErro = "ATENÇÃO: Procedimento não foi executado, verifique o erro número " & err.number & " - " & replace(err.description,"'","")
		%>
		<script>
			alert("<%=msnErro%>");
			window.close();	
		</script>
		<%
		response.end		
	end if
%>