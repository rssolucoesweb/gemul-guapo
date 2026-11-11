<%
	response.Expires=0
	Server.ScriptTimeOut = 5000
%>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	intCodigo 		= Trim(Request.Form("chkCodigo"))
	intOrdenacao 	= request("cmbOrdenacao")
	
	if intCodigo <> "" then
	
		sql = "Delete From MAT_Reserva "
		sql = sql & " Where Codigo in(" & intCodigo & ")"
		cnn.execute sql	
		
		if err.number = 0 then
			%>
			<script>
				alert("Reserva excluída com sucesso.");
				window.location='RemoveReserva_con.asp?cmbOrdenacao=<%=intOrdenacao%>';
			</script>
			<%
		end if	
	else
		%>
		<script>
            alert("ATENÇÃO: Codigo não informado.");
            window.history.back();
        </script>
        <%
	end if
%>