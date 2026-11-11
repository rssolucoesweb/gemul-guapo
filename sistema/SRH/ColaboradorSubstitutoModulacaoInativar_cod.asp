<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodCodSubstituicao	= Trim(Request.Form("txtCodSubistituicao"))
	strDataInativar 		= formatadataBD(Trim(Request.Form("txtDataInicial")))
			
		
	strMensagem  = "Substituicao inativada com sucesso!"
	
	sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE Set "
	sql = sql & " status = 'I' " 
	sql = sql & " Where codigo in (" & intCodCodSubstituicao & ")"
	cnn.execute sql
	GravarLog sql

	sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set "
	sql = sql & " Saldo_Substituicao = Saldo_Substituicao - ( select Total_Aulas from SRH_MODULACAO_DISCIPLINAR_DOCENTE where codigo = " & intCodCodSubstituicao & ")"
	sql = sql & " where codigo in (select Cod_Modulacao_Substituicao from SRH_MODULACAO_DISCIPLINAR_DOCENTE where codigo = " & intCodCodSubstituicao & " )"
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ColaboradorSubstitutoModulacao_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location='ColaboradorSubstitutoModulacao_cad.asp';
		</script>
		<%
	end if
%>