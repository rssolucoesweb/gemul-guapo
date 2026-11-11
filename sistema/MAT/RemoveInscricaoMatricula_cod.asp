<%
	response.Expires=0
	Server.ScriptTimeOut = 5000
%>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------

	strUsuarioWeb				= Session("UsuarioWeb")	
	strCodEmpresa				= trim(request("txtCodigoEmpresa"))
	strCodInscricao				= Trim(Request("txtCodigoInscricao"))

	if strCodInscricao <> "" then
		sql = "execute SP_RemoveInscricaoMatricula " & strCodInscricao & "," & strCodEmpresa & ",'" & strUsuarioWeb & "'"
		cnn.execute sql	
		
		if err.number = 0 then
			%>
			<script>
				alert("Aluno excluído com sucesso.");
				window.location='RemoveInscricaoMatricula_con.asp';
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
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