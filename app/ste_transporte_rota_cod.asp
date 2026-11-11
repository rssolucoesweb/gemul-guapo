<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodGrupo				= Session("CodGrupo") 
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	strNomeRota	 			= Trim(Request.Form("txtNome"))
	strDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
	
	strCapacidadeMatutino  	= Trim(Request.Form("txtCapacidadeMatutino"))
	strReservadoMatutino   	= Trim(Request.Form("txtReservadoMatutino"))

	strCapacidadeVespertino = Trim(Request.Form("txtCapacidadeVespertino"))
	strReservadoVespertino 	= Trim(Request.Form("txtReservadoVespertino"))

	strCapacidadeNoturno	= Trim(Request.Form("txtCapacidadeNoturno"))
	strReservadoNoturno		= Trim(Request.Form("txtReservadoNoturno"))
	
	intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
	strVeiculo	 			= Trim(Request.Form("txtVeiculo"))
	strPlaca	 			= Trim(Request.Form("txtPlaca"))
	strCor	 				= Trim(Request.Form("txtCor"))
	strData	 				= formatadataBD(Trim(Request.Form("txtData"))) 
	strObservacao			= Trim(Request.Form("txtObservacao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	if strSituacao = "" or strSituacao = "0" then strSituacao = "A"
	intCodEmpMarcada  	= Trim(Request.Form("chkEmpresa"))

	
	if strCapacidadeMatutino 	= "" then strCapacidadeMatutino = 0
	if strReservadoMatutino 	= "" then strReservadoMatutino = 0
	if strCapacidadeVespertino 	= "" then strCapacidadeVespertino = 0
	if strReservadoVespertino 	= "" then strReservadoVespertino = 0
	if strCapacidadeNoturno 	= "" then strCapacidadeNoturno = 0
	if strReservadoNoturno 		= "" then strReservadoNoturno = 0
	
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into STE_ROTA(Cod_Grupo, Descricao, Capacidade_Matutino, reservado_Matutino, Capacidade_Vespertino, reservado_Vespertino, Capacidade_Noturno, reservado_Noturno, Distancia_percorrida, "
		sql = sql & " CodColaborador, Veiculo, Placa, Cor, Data, Observacao, Situacao, usuario_incl, data_hora_incl )"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strNomeRota & "',"
		sql = sql & "" & strCapacidadeMatutino & ","
		sql = sql & "" & strReservadoMatutino & ","
		sql = sql & "" & strCapacidadeVespertino & ","
		sql = sql & "" & strReservadoVespertino & ","
		sql = sql & "" & strCapacidadeNoturno & ","
		sql = sql & "" & strReservadoNoturno & ","
		sql = sql & "'" & strDistanciaPercorrida & "',"
		if intCodColaborador = "" or intCodColaborador = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodColaborador & ","
		end if
		sql = sql & "'" & strVeiculo & "',"
		sql = sql & "'" & strPlaca & "',"
		sql = sql & "'" & strCor & "',"
		sql = sql & "getdate(),"
	
		if strObservacao <> "" then
			sql = sql & "'" & strObservacao & "',"
		else
			sql = sql & "null,"
		end if
		
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & session("usuarioWeb") & "',"
		sql = sql & "getdate())"
		'response.write sql
		cnn.execute sql
		GravarLog sql
			
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update STE_ROTA Set"
		sql = sql & " Descricao = '" & strNomeRota & "',"
		sql = sql & " Capacidade_Matutino = " & strCapacidadeMatutino & ","
		sql = sql & " Reservado_Matutino = " & strReservadoMatutino & ","
		sql = sql & " Capacidade_Vespertino = " & strCapacidadeVespertino & ","
		sql = sql & " Reservado_Vespertino = " & strReservadoVespertino & ","
		sql = sql & " Capacidade_Noturno = " & strCapacidadeNoturno & ","
		sql = sql & " Reservado_Noturno = " & strReservadoNoturno & ","
		
		sql = sql & " Distancia_percorrida = '" & strDistanciaPercorrida & "',"
		if intCodColaborador = "" or intCodColaborador = "0" then
			sql = sql & " CodColaborador = null,"
		else
			sql = sql & " CodColaborador = " & intCodColaborador & ","
		end if
		
		sql = sql & " Veiculo = '" & strVeiculo & "',"
		sql = sql & " Placa = '" & strPlaca & "',"
		sql = sql & " Cor = '" & strCor & "',"
		
		if strObservacao <> "" then
			sql = sql & " Observacao = '" & strObservacao & "',"
		else
			sql = sql & " Observacao = null " & strObservacao & ","
		end if
		
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & session("usuarioWeb") & "',"
		sql = sql & " data_hora_altr = getdate()"
		
		sql = sql & " where Cod_Grupo = " & intCodGrupo
		sql = sql & " And Cod_Rota = " & intCodigo

		cnn.execute sql
		GravarLog sql
			
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from STE_ROTA "
		sql = sql & " where Cod_Rota = " & intCodigo
		cnn.execute sql
		GravarLog sql

	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ste_transporte_rota.asp';
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