<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Curso
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodGrupo				= Session("CodGrupo") 
	
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	strNomeRota	 			= Trim(Request.Form("txtNome"))
	intDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
	intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
	strValor	 			= Replace(Replace(Trim(Request("txtValor")),".",""),",",".") 
	strVeiculo	 			= Trim(Request.Form("txtVeiculo"))
	strPlaca	 			= Trim(Request.Form("txtPlaca"))
	strCor	 				= Trim(Request.Form("txtCor"))
	strData	 				= formatadataBD(Trim(Request.Form("txtData"))) 
	strObservacao			= Trim(Request.Form("txtObservacao"))
	intCodEmpMarcada  	= Trim(Request.Form("chkEmpresa"))

	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		
		vetEmp 				= split(intCodEmpMarcada,",")	
		intCont = 0
		
		for i = 0 to ubound(vetEmp)
			
				intCont = intCont + 1	
				intCodEmpresa 		= TRIM(vetEmp(i))
	
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
		
				sql = "Insert Into SCA_ROTA(Cod_Empresa, Cod_Grupo, Cod_Rota, Descricao, Distancia_percorrida, "
				sql = sql & " CodColaborador, Valor, Veiculo, Placa, Cor, Data, Observacao )"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmpresa & ","
				sql = sql & "" & intCodGrupo & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & strNomeRota & "',"
				sql = sql & "" & intDistanciaPercorrida & ","
				sql = sql & "" & intCodColaborador & ","
				sql = sql & "'" & strValor & "',"
				sql = sql & "'" & strVeiculo & "',"
				sql = sql & "'" & strPlaca & "',"
				sql = sql & "'" & strCor & "',"
				sql = sql & "'" & strData & "',"
			
				if strObservacao <> "" then
					sql = sql & "'" & strObservacao & "')"
				else
					sql = sql & "null )"
				end if
				
				cnn.execute sql
				GravarLog sql
	
			next
			
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		vetEmp 				= split(intCodEmpMarcada,",")	
		intCont = 0
		
		for i = 0 to ubound(vetEmp)
		
			intCont = intCont + 1	
			intCodEmpresa 		= TRIM(vetEmp(i))

			sql = "Update SCA_ROTA Set"
			sql = sql & " Descricao = '" & strNomeRota & "',"
			sql = sql & " Distancia_percorrida = " & intDistanciaPercorrida & ","
			sql = sql & " CodColaborador = " & intCodColaborador & ","
			sql = sql & " Valor = '" & strValor & "',"
			sql = sql & " Veiculo = '" & strVeiculo & "',"
			sql = sql & " Placa = '" & strPlaca & "',"
			sql = sql & " Cor = '" & strCor & "',"
			sql = sql & " Data = '" & strData & "',"
			
			if strObservacao <> "" then
				sql = sql & " Observacao = '" & strObservacao & "'"
			else
				sql = sql & " Observacao = null " & strObservacao & ""
			end if
			
			sql = sql & " where Cod_Empresa = " & intCodEmpresa
			sql = sql & " And Cod_Grupo = " & intCodGrupo
			cnn.execute sql
			GravarLog sql
			
		next
	
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
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