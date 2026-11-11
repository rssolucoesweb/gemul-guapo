<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodGrupo				= Session("CodGrupo")
	intCodCodSubstituicao	= Trim(Request.Form("chkCodSubistituicao"))
	strDataInativar 		= formatadataBD(Trim(Request.Form("txtDataInicial")))
			
		
	strMensagem  = "Foi inativada com sucesso!"
	
	sql = " Update SRH_COLABORADOR_SUBSTITUTO Set "
	sql = sql & " DataFinal = '" & strDataInativar & "',"
	sql = sql & " Situacao = 'I'"
	sql = sql & " where codigo in (" & intCodCodSubstituicao & ")"
	cnn.execute sql
	GravarLog sql

	sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE Set "
	sql = sql & " status = 'I' " 
	sql = sql & " Where Cod_Substituicao in (" & intCodCodSubstituicao & ")"
	cnn.execute sql
	GravarLog sql
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ColaboradorSubstitutoNovo_cad.asp';
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