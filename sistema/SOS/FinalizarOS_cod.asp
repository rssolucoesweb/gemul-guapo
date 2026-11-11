<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnndocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%


	intCodRequisicao 										= Trim(Request.QueryString("id"))
	SituacaoFinal 										= Trim(Request("cmbSituacaoFinal"))
	
	if intCodRequisicao="" then
		%>
		<script>
			alert("ID invalido!");
			window.history.back();
		</script>
		<%
		response.end 
	end if	
	
	' Dados do Usuario
	strUsuario_incl   	=	session("usuarioWeb")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("usuarioWeb")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
	
	strMensagem = "OS Finalizado com sucesso!"

	sql = "UPDATE SOS_REQUISICAO SET "
	sql = sql & "cod_tipo_andamento=7,"
	sql = sql & "Situacao_Final='" & SituacaoFinal & "',"
	sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
	sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
	sql = sql & " WHERE codigo = " & intCodRequisicao
	cnn.execute sql
	GravarLog SQL
	
	sql = "insert into SOS_REQUISICAO_ANDAMENTO (cod_requisicao, cod_tipo_andamento, parecer, usuario_incl, data_hora_incl) values ("
	sql = sql & "'" & intCodRequisicao & "',"
	sql = sql & "7,"
	sql = sql & "'OS Finalizada',"
	sql = sql & "'" & strUsuario_incl & "',"
	sql = sql & "'" & strData_hora_altr & "')"
	cnn.execute sql
	GravarLog sql
		

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
			%>
			<script>
				alert("<%=strMensagem%>");
				window.close();
			</script>
			<%
	end if
%>