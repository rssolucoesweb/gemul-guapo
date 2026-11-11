<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/01/2020
	::	Desenvolvedores...: sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Configurações gerais
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<%
	acao = request("acao")

	parecer_integral = request.Form("parecer_integral")
	travar_regiao = request.Form("travar_regiao")
	ano_letivo = request.Form("ano_letivo")
	if ano_letivo = "" then ano_letivo = session("strAnoLetivo")
	
	
	if acao = "I" then
		sql = "insert into MAT_configura_transferencia (parecer_integral, travar_regiao, ano_letivo) values ("
		sql = sql & "'" & parecer_integral & "','" & travar_regiao & "','" & ano_letivo & "')"
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registro incluido com sucesso..."
	elseif acao = "A" then
		sql = "Update MAT_configura_transferencia Set ano_letivo = " & ano_letivo & ",travar_regiao = '" & travar_regiao & "', parecer_integral = '" & parecer_integral & "' where codigo = 1"
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registro Alterado com sucesso..."
	end if

	'Log
	sql = "insert MAT_configura_transferencia_log"
	sql = sql & " select *, case when (select top 1 isnull(codigo_log,0)+1 from MAT_configuracoes_log order by codigo_log desc) is null then 1 else	(select  top 1 isnull(codigo_log,0)+1 from MAT_configuracoes_log order by codigo_log desc) end , '"&session("usuarioWeb")&"', getdate() "
	sql = sql & " from MAT_configura_transferencia"
	cnn.execute sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='configurarTransferencia_cad.asp';
		</script>
		<%
		response.end
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location='configurarTransferencia_cad.asp';
		</script>
		<%
	end if
%>