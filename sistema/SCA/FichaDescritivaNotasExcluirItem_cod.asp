<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: historico escolar
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodEmp			= Session("CodEmpresa")
	intCodigo			= Trim(Request("Codigo"))
	intCodAluno			= Trim(Request("codAluno"))
	intCodBimestre		= Trim(Request("CodBimestre"))

	sql=" delete from SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA "
	sql=sql & " where cod_aluno = " & intCodAluno
	sql=sql & " and Cod_Ficha_Descritiva_Pergunta = " & intCodigo
	sql=sql & " and cod_bimestre = " & intCodBimestre
	cnn.execute SQL
	GravarLog sql	

	strMensagem = "Registro excluído com sucesso..."
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.close()
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.close()
		</script>
		<%
	end if
%>