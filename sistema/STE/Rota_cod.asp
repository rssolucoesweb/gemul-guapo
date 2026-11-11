	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Empresa
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formataData.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodGrupo				= Session("CodGrupo") 
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	strNomeRota	 			= Trim(Request.Form("txtNome"))
	intDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
	intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
	strVeiculo	 			= Trim(Request.Form("txtVeiculo"))
	strPlaca	 			= Trim(Request.Form("txtPlaca"))
	strCor	 				= Trim(Request.Form("txtCor"))
	strData	 				= formatadataBD(Trim(Request.Form("txtData"))) 
	strObservacao			= Trim(Request.Form("txtObservacao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	strMotorista				= Trim(Request.Form("txtMotorista"))
	intCodEmpMarcada  	= Trim(Request.Form("chkEmpresa"))


	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Cod_Rota) as MaiorCodigo" 
		sql = sql & " FROM SCA_ROTA"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
		
		sql = "Insert Into SCA_ROTA(Cod_Grupo, Cod_Rota, Motorista, Descricao, Distancia_percorrida, "
		sql = sql & " CodColaborador, Veiculo, Placa, Cor, Data, Observacao, Situacao )"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strMotorista & "',"
		sql = sql & "'" & strNomeRota & "',"
		if intDistanciaPercorrida = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intDistanciaPercorrida & ","
		end if
		if intCodColaborador = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodColaborador & ","
		end if
		sql = sql & "'" & strVeiculo & "',"
		sql = sql & "'" & strPlaca & "',"
		sql = sql & "'" & strCor & "',"
		sql = sql & "'" & strData & "',"
	
		if strObservacao <> "" then
			sql = sql & "'" & strObservacao & "',"
		else
			sql = sql & "null,"
		end if
		
		sql = sql & "'" & strSituacao & "')"
		
		cnn.execute sql
		GravarLog sql
			
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_ROTA Set"
		sql = sql & " Descricao = '" & strNomeRota & "',"
		sql = sql & " Motorista = '" & strMotorista & "',"
		if intDistanciaPercorrida = "" then
			sql = sql & " Distancia_percorrida = null,"
		else
			sql = sql & " Distancia_percorrida = " & intDistanciaPercorrida & ","
		end if
		if intCodColaborador = "0" then
			sql = sql & " CodColaborador = null,"
		else
			sql = sql & " CodColaborador = " & intCodColaborador & ","
		end if
		sql = sql & " Veiculo = '" & strVeiculo & "',"
		sql = sql & " Placa = '" & strPlaca & "',"
		sql = sql & " Cor = '" & strCor & "',"
		sql = sql & " Data = '" & strData & "',"
		
		if strObservacao <> "" then
			sql = sql & " Observacao = '" & strObservacao & "',"
		else
			sql = sql & " Observacao = null " & strObservacao & ","
		end if
		
		sql = sql & " Situacao = '" & strSituacao & "'"
		
		sql = sql & " where Cod_Grupo = " & intCodGrupo
		sql = sql & " And Cod_Rota = " & intCodigo

		cnn.execute sql
		GravarLog sql
			
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_ROTA_VICULA_ALUNO "
		sql = sql & " where CodRota = " & intCodigo
		cnn.execute sql
		GravarLog sql
	
		sql = "Delete from SCA_ROTA_VICULA_EMPRESA "
		sql = sql & " where CodRota = " & intCodigo
		cnn.execute sql
		GravarLog sql
	
		sql = "Delete from SCA_ROTA "
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
			window.location='Rota_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>