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
	intCodigoFuncionalAnterior = Trim(Request("txtCodigoFuncionalAnterior"))
	if intCodFunc = "4205" then
		%>
			<script>
				alert("Colaborador DEFICT não pode ser alterado.");
				window.history.go(-1);
			</script>
		<%
		response.end
	end if
	strnome 			= Trim(Request.Form("txtNomeFuncionario"))
	strdata_admissao  	= formataDataBDAccess(Trim(Request.Form("txtdata_admissao")))

	intCodFuncao 	    	= TRIM(Request.Form("cmbFuncao"))
	if intCodFuncao			= "" then intCodFuncao = "0"
	intCodCargo 	    	= TRIM(Request.Form("cmbCargo"))
	if intCodCargo 			= "" then intCodCargo = "0"
	intCodTurno 			= TRIM(Request.Form("cmbTurno"))
	if intCodTurno			= "" then intCodTurno = "0"
	intcodLotacao 	    	= TRIM(Request.Form("cmbLotacao"))
	if intcodLotacao 		= "" then intcodLotacao = "0"
	intcodLotacaoAnterior 	=  Trim(Request("txtcodLotacaoAnterior"))
	intcodRemocao    		= TRIM(Request.Form("cmbRemocao"))
	if intcodRemocao		= "" then intcodRemocao = "0"

	strCNH 	           	= TRIM(Request.Form("txtCNH"))
	strCategoriaCNH 	= TRIM(Request.Form("txtCategoriaCNH"))
	intCodFormaNomeacao 	    = TRIM(Request.Form("cmbFormaNomeacao"))
	if intCodFormaNomeacao = "" then intCodFormaNomeacao = "0"
	strOcorrenciaColaborador			= ReplaceRequest(Trim(Request.Form("txtOcorrencia")))
	
	if Session("NivelPermissao") = "A" then
		strSenha			= replace(Trim(Request.Form("txtSenha")),"'","")
		'Criptografa Senha
		'if strSenha <> "" then 
		'	strSenha = FormatCripto(strSenha,True)
		'end if
	else
		strUsuarioPortal = ""
	end if
		
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
	strdata_nascimento  = formataDataBDAccess(Trim(Request.Form("txtData_Nascimento")))
	strnaturalidade  	= Trim(Request.Form("txtnaturalidade"))
	strUFNaturalidade  	= Trim(Request.Form("cmbUFNaturalidade"))
	strnacionalidade  	= Trim(Request.Form("txtnacionalidade"))
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
	strDatafastamento	= formataDataBD(Trim(Request.Form("txtDatafastamento")))
	intCodCategoria		= Trim(Request.Form("cmbCategoria"))	
	intCodGrauInstrucao	= Trim(Request.Form("cmbGrauInstrucao"))	
	strCargo			= Trim(Request.Form("txtCargo"))
	strFuncao			= Trim(Request.Form("txtFuncao"))
	intCodDepartamento	= Trim(Request.Form("cmbDepartamento"))
	intCodFuncional  	= Trim(Request.Form("txtCodigoFuncional"))
	strObs				= Trim(Request.Form("txtObs"))
	intCodDepto		 	= Trim(Request.Form("cmbDepartamento"))
	motivoTrocaLotacao 	= Trim(Request.Form("motivoTrocaLotacao"))
	obsmotivoTrocaLotacao 	= Trim(Request.Form("obsmotivoTrocaLotacao"))
	
	intCodNivel 				= Trim(Request.Form("cmbNivel"))
	strSalarioBase 				= replace(replace(trim(request.form("txtSalarioBase")),".",""),",",".") 
	strCargaHorariaTotal 		= Trim(Request.Form("txtCargaHorariaTotal"))
 	strTotalAulas		 		= Trim(Request.Form("txtTotalAulas"))
	strTotalAulasCumprida 		= Trim(Request.Form("txtTotalAulasCumprida"))
	strFatorExtraClasse 		= replace(replace(trim(request.form("txtFatorExtraClasse")),".",""),",",".")
	strPercentualRepousoSemanal	= replace(replace(trim(request.form("txtPercentualRepousoSemanal")),".",""),",",".") 
	strPercentualQuinquenio		= Trim(Request.Form("txtPercentualQuinquenio"))
	strQuantidadeQuinquenio		= Trim(Request.Form("txtQuantidadeQuinquenio"))
	strSimouNao         		= Trim(Request.Form("cmbSimouNao"))
	strLattes					= Trim(Request.Form("txtLattes"))
	strDataLotacao				= formataDataBD(Trim(Request.Form("txtDataLotacao")))
	strDataLotacaoAnterior		= formataDataBD(Trim(Request.Form("txtDataLotacaoAnterior")))
	
	intCodRegencia				= Trim(Request.Form("cmbRegencia"))
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if strUf = "" then strUf = "0"
	if intCodDepartamento = "" then intCodDepartamento = "0"
	if intCodCategoria = "" then intCodCategoria = "0"

	if intCodRegencia = "" then intCodRegencia = "0"

	
	if strAcao = "A" then
	
		strMensagem = "Registro Alterado com sucesso!"
		sql = "UPDATE SRH_COLABORADOR set "
		
		sql = sql & "nome='" & strnome & "',"
		sql = sql & "sexo='" & strSexo & "',"

		if strdata_admissao <> "" then
			sql = sql & "data_admissao='" & strdata_admissao & "',"
		else 
			sql = sql &"data_admissao=null ,"
		end if
		
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
		if strdata_nascimento <> "" then
			sql = sql & "data_nascimento='" & strdata_nascimento & "',"
		else 
			sql = sql &"data_nascimento=null ,"
		end if
		if strnaturalidade <> "" then
			sql = sql & "naturalidade='" & strnaturalidade & "',"
		else 
			sql = sql &"naturalidade=null ,"
		end if
		
		if strUFNaturalidade <> "" then
			sql = sql & "UFNaturalidade='" & strUFNaturalidade & "',"
		else 
			sql = sql &" UFNaturalidade = null ,"
		end if
		if strnacionalidade <> "" then
			sql = sql & "nacionalidade='" & strnacionalidade & "',"
		else 
			sql = sql &"nacionalidade=null ,"
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
		
		
		
		if strDatafastamento <> "" then
			sql = sql & "Datafastamento='" & strDatafastamento & "',"
		else 
			sql = sql & "Datafastamento=null ,"
		end if	
		
		
		
		if intCodGrauInstrucao <> "0" then
			sql = sql & "CodGrauInstrucao = " & intCodGrauInstrucao & ","
		else 
			sql = sql & "CodGrauInstrucao = null ,"
		end if	
		
		if strCargo <> "" then
			sql = sql & "Cargo='" & strCargo & "',"
		else 
			sql = sql & "Cargo=null ,"
		end if	

		if intCodTurno <> "" then
			sql = sql & "CodTurno='" & intCodTurno & "',"
		else 
			sql = sql & "CodTurno=null ,"
		end if	
		
		if strFuncao <> "" then
			sql = sql & "Funcao='" & strFuncao & "',"
		else 
			sql = sql & "Funcao=null ,"
		end if	
		
		
		if strObs <> "" then
			sql = sql & "Obs = '" & strObs & "',"
		else 
			sql = sql & "Obs = null, "
		end if	
		
		if intCodFuncional <> "" then
			sql = sql & " CodFuncional = " & intCodFuncional & ","
		else 
			sql = sql & " CodFuncional =null, "
		end if	
		
		if intcodFuncao <> "0" then
			sql = sql & "codFuncao=" & intcodFuncao & ","
		else 
			sql = sql & "codFuncao=null ,"
		end if
		if intcodCargo <> "0" then
			sql = sql & "codCargo=" & intcodCargo & ","
		else 
			sql = sql & "codCargo=null ,"
		end if
		if intcodLotacao <> "" then
			sql = sql & "codLotacao=" & intcodLotacao & ","
		else 
			sql = sql & "codLotacao=null ,"
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
		if intCodFormaNomeacao <> "" then
			sql = sql & "CodFormaNomeacao=" & intCodFormaNomeacao & ","
		else 
			sql = sql & "CodFormaNomeacao=null, "
		end if
		
		
		if strDataLotacao <> "" then
			sql = sql & "DataLotacao = '" & strDataLotacao & "',"
		else 
			sql = sql & "DataLotacao = null, "
		end if
		
		if intCodRegencia <> "0" then
			sql = sql & " Cod_Regencia = " & intCodRegencia & ","
		else 
			sql = sql & " Cod_Regencia = null,"
		end if
		
		sql = sql & "usuario_altr = '" & strUsuario_incl & "',"
	    	sql = sql & "data_hora_altr = '" & strData_hora_incl & "'"

		sql = sql & " WHERE codigo = " & intCodFunc
		
		cnn.execute sql
		GravarLog sql

		'OCORRENCIA
		if trim(strOcorrenciaColaborador) <> "" then
		
			sql = " Insert into SRH_COLABORADOR_OCORRENCIA (cod_Empresa, cod_colaborador, ocorrencia, usuario_incl, data_incl)" 
			sql = sql & " VALUES("
			sql = sql & "" & session("codEmpresa") & "," 
			sql = sql & "" & intCodFunc & "," 
			sql = sql & "'" & strOcorrenciaColaborador & "',"
			sql = sql & "'" & Session("UsuarioWeb") & "',getdate())"
			cnn.execute sql
			GravarLog sql
			
		end if	
		GravarLog sql

		
		
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		
		if strAcao="A" then
			strMensagem = "Registro alterado com sucesso!"
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location.href = 'ColaboradorUE_cad.asp?txtCodFuncionario=<%=intCodFunc%>'
			</script>			
			<%
		end if
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>