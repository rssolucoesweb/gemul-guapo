<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Rubricas Avulsas
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	 'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strCodigo			= Trim(Request("txtCodigo"))
	strCodFunc			= Trim(Request("txtCodFuncionario"))
	strCodRubrica		= Trim(Request("txtCodRubrica"))
	intCodTipoFolha		= Trim(Request("cmbTipoFolha"))
	strMes				= Trim(Request("cmbMes"))
	strAno				= Trim(Request("cmbAno"))
	intValorRubrica		= replace(replace(trim(request.form("txtValorRubrica")),".",""),",",".")
				
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_RUBRICA_COLABORADOR_AVULSA (cod_empresa, Cod_colaborador, Cod_TipoFolha, Mes, Ano, Cod_rubrica, valor_rubrica) "
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strCodFunc & ","
		sql = sql & "" & intCodTipoFolha & ","
		sql = sql & "" & strMes & ","
		sql = sql & "" & strAno & ","
		sql = sql & "" & strCodRubrica & ","
		sql = sql & "" & intValorRubrica & ")"
		cnn.execute sql
		GravarLog sql

	elseif acao="A" then
		

	else
		
		strMensagem = "Registro Excluido com sucesso"
		
		sql = " Delete from SRH_RUBRICA_COLABORADOR_AVULSA"
		sql = sql & " Where cod_colaborador = " & strCodFunc
		sql = sql & " and codigo = " & strCodigo
		cnn.execute sql
		GravarLog sql
	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='RubricaAvulsa_cad.asp?txtCodFuncionario=<%=strCodFunc%>';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>