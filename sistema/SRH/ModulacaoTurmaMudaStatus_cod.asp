<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	strCodturma 		= trim(request("Codturma"))
	strStatus 			= trim(request("Status"))

	if strStatus = "A" then
		strMensagem 		= "Modulação INATIVADA com Sucesso..."
		strNovoStatus		= "I"
	else
		strMensagem 		= "Modulação ATIVADA com Sucesso..."
		strNovoStatus		= "A"
	end if
	
	sql = "Update SCA_TURMA Set"
	sql = sql & " Situacao_modulacao = '" & strNovoStatus & "'"
	sql = sql & " Where cod_turma = " & strCodturma
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