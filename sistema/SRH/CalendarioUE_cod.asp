<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	response.end
	
	strCodGrupo		        = Session("CodGrupo")
	acao 				 	= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.form("txtCodigo"))
	
	strAno		 			= Trim(Request.form("txtAno"))
	strNome		 			= Trim(Request.form("txtNome"))
	strDataInicio 			= strAno & "/01/01"
	strDataFim 				= strAno & "/12/31"
	strSituacao				= Trim(Request.form("cmbSituacao"))
	
	if acao="I" then
		
		
	
	end if
	
		
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao = "E" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='CalendarioUE_cad.asp';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='CalendarioUE_cad.asp?txtCodigoRetorno=<%=intCodigo%>';
		</script>
		<%
		end if
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