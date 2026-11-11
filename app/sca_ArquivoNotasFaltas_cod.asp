<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formataData.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	intCodigoNota 				= trim(request("Codigo"))
		

	sql = "delete SCA_NOTAS_FALTAS "
	sql = sql & " WHERE	CODIGO = " & intCodigoNota
	cnn.execute sql
	GravarLog sql	

	if err.number = 0 then
		
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
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