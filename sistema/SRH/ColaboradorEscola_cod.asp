<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodEmp           = Trim(Request.Form("txtCodEmpresa"))
	strUsuarioPortal 	= Trim(Request.Form("txtUsuarioPortal"))
	strStatus			= Trim(Request.Form("optStatus"))
	strAcao				= Trim(Request.QueryString("acao"))
	intCodFunc 			= Trim(Request("txtCodFuncionario"))

	strCNH 	           	= TRIM(Request.Form("txtCNH"))
	strCategoriaCNH 	= TRIM(Request.Form("txtCategoriaCNH"))

	'endereço
	strLogradouro 		= ReplaceRequest(Trim(Request.Form("txtLogradouro")))
	strNumero_endereco 	= ReplaceRequest(Trim(Request.Form("txtNumero_endereco")))
	strComp_endereco 	= ReplaceRequest(Trim(Request.Form("txtComp_endereco")))
	strBairro    		= ReplaceRequest(Trim(Request.Form("txtBairro")))
	strCidade       	= ReplaceRequest(Trim(Request.Form("txtCidade")))
	strUf 				= ReplaceRequest(Trim(Request.Form("cmbUfresidencia")))
	strCep          	= ReplaceRequest(Trim(Request.Form("txtCep")))
	
	strFoneResidencial  = Trim(Request.Form("txtFoneResidencial"))
	strFoneComercial    = Trim(Request.Form("txtFoneComercial"))
	strFoneCelular      = Trim(Request.Form("txtFoneCelular"))
	carteira_reservista	= Trim(Request.Form("carteira_reservista"))
	
	stremail  			= Trim(Request.Form("txtemail"))
	strEmailCoorporativo= Trim(Request.Form("txtEmailCoorporativo"))
	strpai  			= Trim(Request.Form("txtpai"))
	strmae  			= Trim(Request.Form("txtmae"))
	strestado_civil  	= Trim(Request.Form("txtestado_civil"))
	strconjuge  		= Trim(Request.Form("txtconjuge"))
	strnumero_filhos  	= Trim(Request.Form("txtnumero_filhos"))
	strcpf  			= Trim(Request.Form("txtcpf"))
	strrg  				= Trim(Request.Form("txtrg"))
	strorgao_expedidor  = Trim(Request.Form("txtorgao_expedidor"))
	strtitulo_eleitor  	= Trim(Request.Form("txttitulo_eleitor"))
	strcarteira_trabalho= Trim(Request.Form("txtcarteira_trabalho"))
	strpis  			= Trim(Request.Form("txtpis"))
	strSexo 			= Trim(Request.Form("cboSexo"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))	
	intCodFuncional  	= Trim(Request.Form("txtCodigoFuncional"))
	strObs				= Trim(Request.Form("txtObs"))
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if strUf = "" then strUf = "0"
	
	if strAcao = "A" then
	
		strMensagem = "Registro Alterado com sucesso!"
		sql = "UPDATE SRH_COLABORADOR set "
		
		sql = sql & "sexo='" & strSexo & "',"

		if strLogradouro <> "" then
			sql = sql & "Logradouro='" & strLogradouro & "',"
		else 
			sql = sql &"Logradouro=null ,"
		end if
		
		if strNumero_endereco <> "" then
			sql = sql & "numero_logradouro='" & strNumero_endereco & "',"
		else 
			sql = sql &"numero_logradouro=null ,"
		end if
		
		if strComp_endereco <> "" then
			sql = sql & "Comp_Endereco='" & strComp_endereco & "',"
		else 
			sql = sql &"Comp_Endereco=null ,"
		end if
		
		if strBairro <> "" then
			sql = sql & "Bairro='" & strBairro & "',"
		else 
			sql = sql &"Bairro=null ,"
		end if
		
		if strCidade <> "" then
			sql = sql & "Cidade='" & strCidade & "',"
		else 
			sql = sql & "Cidade=null ,"
		end if
		
		if strUf <> "" then
			sql = sql & "UF='" & strUf & "',"
		else 
			sql = sql &"UF=null ,"
		end if
		
		if strCep <> "" then
			sql = sql & "Cep='" & strCep & "',"
		else 
			sql = sql &"Cep=null ,"
		end if
		
		if strFoneResidencial <> "" then
			sql = sql & "FoneResidencial='" & strFoneResidencial & "',"
		else 
			sql = sql &"FoneResidencial=null ,"
		end if
		
		if strFoneComercial <> "" then
			sql = sql & "FoneComercial='" & strFoneComercial & "',"
		else 
			sql = sql &"FoneComercial=null ,"
		end if
		
		if strFoneCelular <> "" then
			sql = sql & "FoneCelular='" & strFoneCelular & "',"
		else 
			sql = sql & "FoneCelular=null ,"
		end if
	
		if carteira_reservista <> "" then
			sql = sql & "carteira_reservista='" & carteira_reservista & "',"
		else 
			sql = sql &"carteira_reservista=null ,"
		end if
		
		if stremail <> "" then
			sql = sql & "email='" & LCase(stremail) & "',"
		else 
			sql = sql &"email=null ,"
		end if

		if strEmailCoorporativo <> "" then
			sql = sql & "email_coorporativo='" & LCase(strEmailCoorporativo) & "',"
		else 
			sql = sql &"email_coorporativo=null ,"
		end if

		if strpai <> "" then
			sql = sql & "pai='" & strpai & "',"
		else 
			sql = sql &"pai=null ,"
		end if
		if strmae <> "" then
			sql = sql & "mae='" & strmae & "',"
		else 
			sql = sql &"mae=null ,"
		end if
		if strestado_civil <> "" then
			sql = sql & "estado_civil='" & strestado_civil & "',"
		else 
			sql = sql &"estado_civil=null ,"
		end if
		if strconjuge <> "" then
			sql = sql & "conjuge='" & strconjuge & "',"
		else 
			sql = sql &"conjuge=null ,"
		end if
		if strnumero_filhos <> "" then
			sql = sql & "numero_filhos=" & strnumero_filhos & ","
		else 
			sql = sql &"numero_filhos=null ,"
		end if
		if strrg <> "" then
			sql = sql & "rg='" & strrg & "',"
		else 
			sql = sql &"rg=null ,"
		end if
		
		if strorgao_expedidor <> "" then
			sql = sql & "orgaoexp='" & strorgao_expedidor & "',"
		else 
			sql = sql &"orgaoexp=null ,"
		end if
		
		if strtitulo_eleitor <> "" then
			sql = sql & "titulo_eleitor='" & strtitulo_eleitor & "',"
		else 
			sql = sql &"titulo_eleitor=null ,"
		end if
		
		if strcarteira_trabalho <> "" then
			sql = sql & "carteira_trabalho='" & strcarteira_trabalho & "',"
		else 
			sql = sql &"carteira_trabalho=null ,"
		end if
		
		if strpis <> "" then
			sql = sql & "pis='" & strpis & "',"
		else 
			sql = sql &"pis=null ,"
		end if	
		
		if strCNH <> "" then
			sql = sql & "CNH='" & strCNH & "',"
		else 
			sql = sql & "CNH=null,"
		end if							
		if strCategoriaCNH <> "" then
			sql = sql & "CategoriaCNH='" & strCategoriaCNH & "',"
		else 
			sql = sql & "CategoriaCNH=null,"
		end if		
		
		sql = sql & "usuario_altr = '" & strUsuario_incl & "',"
	    sql = sql & "data_hora_altr = '" & strData_hora_incl & "'"

		sql = sql & " WHERE codigo = " & intCodFunc
		
		cnn.execute sql
		GravarLog sql
		
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		if strAcao="A" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location.href = "ColaboradorEscola_cad.asp";
		</script>			
		<%
		end if
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>