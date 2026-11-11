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
	intCodTurno 			= TRIM(Request.Form("cmbTurnoRH"))
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
	

	intCodPerfil = Trim(Request.Form("cmbPerfilGrupo"))
	
	if intCodPerfil <> "" then
		vetPerfil = split(intCodPerfil,",")
	end if
	
	if strAcao = "I"then  
		
		strMensagem = "Registro gravado com sucesso!"
		if intCodFuncional <> "" then
			sql = "SELECT  codigo "
			sql = sql & " FROM SRH_COLABORADOR "
			sql = sql & " Where cpf = '" & strCPF & "'"
			sql = sql & " And CodFuncional = " & intCodFuncional  
			rs.open sql, cnn
			if rs.eof = false then
				rs.close
					%>
					<script>
						alert("Existe um colaborador cadastrado com o mesmo CPF e matrícula funcional, verifique na pesquisa antes de incluir para não gerar duplicidades de cadastro!")
						window.history.back();
					</script>
					<%
					response.end
	
			else
				rs.close
			end if 
			
		else
			'gerar matricula temporária
			SQL = "SET NoCount ON INSERT INTO SRH_COLABORDOR_MATRICULA_PROVISORIA (usuario_incl, DATA) VALUES('" & session("UsuarioWeb") &"',GETDATE()) ;SELECT @@IDENTITY "
			Set rs = cnn.Execute(sql)
			intCodFuncionalProvisorio = rs(0)
			rs.close
			
			intCodFuncional = intCodFuncionalProvisorio
		end if

		sql = "set nocount on insert into SRH_COLABORADOR (cod_empresa, nome, data_admissao, "
		sql = sql & " Logradouro, numero_logradouro, Comp_Endereco, "
 		sql = sql & " Bairro, Cidade, uf, cep, "
		sql = sql & " FoneResidencial, FoneComercial, FoneCelular, carteira_reservista, "
		sql = sql & " email, email_coorporativo, pai, mae, data_nascimento, naturalidade, UFNaturalidade, nacionalidade, "
		sql = sql & " estado_civil, conjuge, numero_filhos, cpf, rg, orgaoexp, "
		sql = sql & " titulo_eleitor, carteira_trabalho, pis, sexo, Situacao, Datafastamento, "
		sql = sql & " CodCategoria, CodGrauInstrucao, Cargo, CodTurno, Funcao, CodDepartamento, Obs, codigo_SEG_USUARIOS_SISTEMA,"
		sql = sql & " CodFuncional, codFuncao, codCargo, codLotacao, codRemocao, CNH, CategoriaCNH, codFormaNomeacao,Cod_nivel, salario_base, "
		sql = sql & " carga_horario_contratada, total_aulas, total_aulas_Cumprida, Fator_Extra_Classe ,percentual_quinquenio, quantidade_quinquenio,"
		sql = sql & "  percentual_repouso_Semanal, modular, Lattes, DataLotacao, Cod_Regencia,usuario_incl,data_hora_incl)"

		sql = sql & " values (" 
		
		sql = sql & "" & session("codEmpresa") & ","
		sql = sql & "'" & strnome & "',"
		
		if strdata_admissao <> "" then
			sql = sql & "'" & strdata_admissao & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strLogradouro <> "" then
			sql = sql & "'" & strLogradouro & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strNumero_endereco <> "" then
			sql = sql & "'" & strNumero_endereco & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strComp_endereco <> "" then
			sql = sql & "'" & strComp_endereco & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strBairro <> "" then
			sql = sql & "'" & strBairro & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strCidade <> "" then
			sql = sql & "'" & strCidade & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strUf <> "" then
			sql = sql & "'" & strUf & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strCep <> "" then
			sql = sql & "'" & strCep & "',"
		else 
			sql = sql &" null ,"
		end if

		if strFoneResidencial <> "" then
			sql = sql & "'" & strFoneResidencial & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strFoneComercial <> "" then
			sql = sql & "'" & strFoneComercial & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strFoneCelular <> "" then
			sql = sql & "'" & strFoneCelular & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if carteira_reservista <> "" then
			sql = sql & "'" & carteira_reservista & "',"
		else 
			sql = sql &" null ,"
		end if
	
		if stremail <> "" then
			sql = sql & "'" & LCase(stremail) & "',"
		else 
			sql = sql &" null ,"
		end if

		if strEmailCoorporativo <> "" then
			sql = sql & "'" & LCase(strEmailCoorporativo) & "',"
		else 
			sql = sql &" null ,"
		end if

		if strpai <> "" then
			sql = sql & "'" & strpai & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strmae <> "" then
			sql = sql & "'" & strmae & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strdata_nascimento <> "" then
			sql = sql & "'" & strdata_nascimento & "',"
		else 
			sql = sql &" null ,"
		end if
	
		if strnaturalidade <> "" then
			sql = sql & "'" & strnaturalidade & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strUFNaturalidade <> "" then
			sql = sql & "'" & strUFNaturalidade & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strnacionalidade <> "" then
			sql = sql & "'" & strnacionalidade & "',"
		else 
			sql = sql &" null ,"
		end if
		if strestado_civil <> "" then
			sql = sql & "'" & strestado_civil & "',"
		else 
			sql = sql &" null ,"
		end if
	
		if strconjuge <> "" then
			sql = sql & "'" & strconjuge & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strnumero_filhos <> "" then
			sql = sql & "" & strnumero_filhos & ","
		else 
			sql = sql &" null ,"
		end if
		
		if strcpf <> "" then
			sql = sql & "'" & strcpf & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strrg <> "" then
			sql = sql & "'" & strrg & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strorgao_expedidor <> "" then
			sql = sql & "'" & strorgao_expedidor & "',"
		else 
			sql = sql &" null ,"
		end if
	
		if strtitulo_eleitor <> "" then
			sql = sql & "'" & strtitulo_eleitor & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strcarteira_trabalho <> "" then
			sql = sql & "'" & strcarteira_trabalho & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strpis <> "" then
			sql = sql & "'" & strpis & "',"
		else 
			sql = sql &" null ,"
		end if
		
		sql = sql & "'" & strSexo & "',"
	
		if strSituacao <> "" then
			sql = sql & "'" & strSituacao & "',"
		else 
			sql = sql &" null ,"
		end if
	
		if strDatafastamento <> "" then
			sql = sql & "'" & strDatafastamento & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if intCodCategoria <> "0" then
			sql = sql & "" & intCodCategoria & ","
		else 
			sql = sql &" null ,"
		end if
		
		if intCodGrauInstrucao <> "0" then
			sql = sql & "" & intCodGrauInstrucao & ","
		else 
			sql = sql &" null ,"
		end if
		
		if strCargo <> "" then
			sql = sql & "'" & strCargo & "',"
		else 
			sql = sql &" null ,"
		end if

		if intCodTurno <> "" then
			sql = sql & "'" & intCodTurno & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if strFuncao <> "" then
			sql = sql & "'" & strFuncao & "',"
		else 
			sql = sql &" null ,"
		end if
		
		if intCodDepartamento <> "0" then
			sql = sql & "" & intCodDepartamento & ","
		else 
			sql = sql &" null ,"
		end if
	
		if strObs <> "" then
			sql = sql & "'" & strObs & "',"
		else 
			sql = sql &" null,"
		end if
		
		if strUsuarioPortal <> "" then
			sql = sql & "'" & strUsuarioPortal & "',"
		else 
			sql = sql &" null,"
		end if
		
		if intCodFuncional <> "" then
			sql = sql & "" & intCodFuncional & ","
		else 
			sql = sql &" null ,"
		end if
		
		if intcodFuncao <> "0" then
			sql = sql & "" & intcodFuncao & ","
		else 
			sql = sql &" null ,"
		end if
		if intcodCargo <> "0" then
			sql = sql & "" & intcodCargo & ","
		else 
			sql = sql &" null ,"
		end if
		if intcodLotacao <> "" then
		   ' sql = sql & "" & session("codEmpresa") & "," ' Durante a inclusão do colaborador o codigo da lotação é o mesmo código da empresa
			sql = sql & "" & intcodLotacao & ","
		else 
			sql = sql &" null ,"
		end if
		if intcodRemocao <> "" then
			sql = sql & "" & intcodRemocao & ","
		else 
			sql = sql &" null ,"
		end if
		if strCNH <> "" then
			sql = sql & "'" & strCNH & "',"
		else 
			sql = sql &" null ,"
		end if							
		if strCategoriaCNH <> "" then
			sql = sql & "'" & strCategoriaCNH & "',"
		else 
			sql = sql &" null,"
		end if		
		if intCodFormaNomeacao <> "" then
			sql = sql & "" & intCodFormaNomeacao & ","
		else 
			sql = sql &" null,"
		end if
		if intCodNivel <> "" then
			sql = sql & "" & intCodNivel & ","
		else 
			sql = sql &" null,"
		end if
		if strSalarioBase <> "" then
			sql = sql & "" & strSalarioBase & ","
		else 
			sql = sql &" null,"
		end if
		if strCargaHorariaTotal <> "" then
			sql = sql & "" & strCargaHorariaTotal & ","
		else 
			sql = sql &" null,"
		end if
		if strTotalAulas <> "" then
			sql = sql & "" & strTotalAulas & ","
		else 
			sql = sql &" null,"
		end if
		if strTotalAulasCumprida <> "" then
			sql = sql & "" & strTotalAulasCumprida & ","
		else 
			sql = sql &" null,"
		end if
		if strFatorExtraClasse <> "" then
			sql = sql & "" & strFatorExtraClasse & ","
		else 
			sql = sql &" null,"
		end if
		if strPercentualQuinquenio <> "" then
			sql = sql & "" & strPercentualQuinquenio & ","
		else 
			sql = sql &" null,"
		end if
		if strQuantidadeQuinquenio <> "" then
			sql = sql & "" & strQuantidadeQuinquenio & ","
		else 
			sql = sql &" null,"
		end if
		if strPercentualRepousoSemanal <> "" then
			sql = sql & "" & strPercentualRepousoSemanal & ","
		else 
			sql = sql &" null,"
		end if
		
	    sql = sql & "'N',"
		
		if strLattes <> "" then
		   sql = sql & "'" & strLattes & "',"
		else 
			sql = sql &" null,"
		end if
		
		if strDataLotacao <> "" then
		   sql = sql & "'" & strDataLotacao & "',"
		else 
			sql = sql &" null,"
		end if

		if intCodRegencia <> "0" then
		   sql = sql & "" & intCodRegencia & ","
		else 
			sql = sql &" null,"
		end if
	    sql = sql & "'" & strUsuario_incl & "',"
	    sql = sql & "'" & strData_hora_incl & "')"
		
		sql = sql & " Select @@Identity as id "
		rs.open sql, cnn
		if not rs.eof then
			intCodFunc = rs("id")
		end if
		rs.close
			
		GravarLog replace(replace(sql,"Select @@Identity as id",""),"set nocount on","")
		
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
		
		
		sql = " insert into SRH_LOTACAOHISTORICO (COD_COLABORADOR, COD_LOTACAO, DATA_ALTERACAO, DataLotacao, USUA_CODG)"
		sql = sql & " VALUES (" & intCodFunc & ", " & session("codEmpresa") & ", '" & formatadataBD(date()) & "','" & formatadataBD(strDataLotacao) & "','" & Session("UsuarioWeb") & "' )"
		cnn.execute sql
		GravarLog sql
	
		bolExiste = false
		bolExisteUsuario = false
		if strUsuarioPortal <> "" then

			' Verifica se existe o login já cadastrado para outro usuario
			sql = "select Usua_Codg From SEG_USUARIOS_SISTEMA"
			sql = sql & " where Usua_Codg = '"& trim(strUsuarioPortal) & "'"
			rs.open sql, cnn
			if rs.eof = false then
				bolExisteUsuario = true
				if request("aproveitamentoDeCadastro") <> "S" then
					%>
					<script>
						alert("ATENÇÃO: Login já existe para outro colaborador, os dados serão gravados, mais o login de acesso do usuário você deverá inclui-lo novamente.");
					</script>
					<%	
				end if
			end if
			rs.close
			
			if bolExisteUsuario = true then
				if request("aproveitamentoDeCadastro") <> "S" then
					sql = "UPDATE SRH_COLABORADOR set codigo_SEG_USUARIOS_SISTEMA=null WHERE codigo = " & intCodFunc
					cnn.execute sql
					GravarLog sql
				end if
			end if
			
		    if bolExisteUsuario = false then
				'insere usuario para acesso no portal
				sql = " Insert into SEG_USUARIOS_SISTEMA (Usua_Codg, Usua_Stat, Usua_Info_Senha, "
				sql = sql & " Usua_Data_Ativacao, CODIGO_DEPARTAMENTO, COD_EMPRESA, "
				sql = sql & " USUA_NOME_COMPLETO, USUA_TELEFONE, USUA_EMAIL, USUA_CPF)" 
				sql = sql & " VALUES("
		
				sql = sql & "'" & strUsuarioPortal & "'," 
				if strStatus <> "" then
					sql = sql & "'" & strStatus & "',"
				else
					sql = sql & "null, "
				end if 
				
				sql = sql & "'" & strSenha & "'," 
				sql = sql & "'" & strData_hora_incl & "'," 
				sql = sql & "'" & intCodDepto & "',"
				sql = sql & "'" & session("codEmpresa") & "',"
		
				sql = sql & "'" & strnome & "',"
				sql = sql & "'" & strFoneResidencial & "',"
				if stremail <> "" then
					sql = sql & "'" & LCase(stremail) & "',"
				else 
					sql = sql &" null ,"
				end if
				sql = sql & "'" & strCPF & "')"

				cnn.execute sql
				GravarLog sql
				
				if intCodPerfil <> "" then
					for i=0 to ubound(vetPerfil)
						sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse, cod_colaborador )"
						sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & vetPerfil(i) & "', 'N'," & intCodFunc & ")"
						cnn.execute sql
						GravarLog sql
					next
				end if
				
				sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA,  COD_EMPRESA )"
				sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & session("codEmpresa") & "')"
				cnn.execute sql
				GravarLog sql
			
			end if
		end if		
	
	elseif strAcao = "A" then
	
		if Session("NivelPermissao") = "A" then
		
			bolExiste = false
			if strUsuarioPortal <> "" then
				sql = "select count(*) as contLogin "
				sql = sql & " from SRH_COLABORADOR"
				sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
				rs.open sql, cnn
				if not rs.eof then
					if not isnull(rs("contLogin")) then
						if rs("contLogin")=1 then
							bolExiste = true
						end if
					end if
					rs.close
				else
					rs.close
				end if
				
				sql = "select count(*) as contLogin "
				sql = sql & " from SEG_USUARIOS_SISTEMA"
				sql = sql & " where Usua_Codg = '"& strUsuarioPortal & "'"
				rs.open sql, cnn
				if not rs.eof then
					if not isnull(rs("contLogin")) then
						if rs("contLogin")=1 then
							bolExiste = true
						end if
					end if
					rs.close
				else
					rs.close
				end if
				if bolExiste = false then
					'insere usuario para acesso no portal
					sql = " Insert into SEG_USUARIOS_SISTEMA (Usua_Codg, Usua_Stat, Usua_Info_Senha, "
					sql = sql & " Usua_Data_Ativacao, CODIGO_DEPARTAMENTO, COD_EMPRESA, "
					sql = sql & " USUA_NOME_COMPLETO, USUA_TELEFONE, USUA_EMAIL, USUA_CPF)" 
					sql = sql & " VALUES("
			
					sql = sql & "'" & strUsuarioPortal & "'," 
					if strStatus <> "" then
						sql = sql & "'" & strStatus & "',"
					else
						sql = sql & "null, "
					end if 
					
					sql = sql & "'" & strSenha & "'," 
					sql = sql & "'" & strData_hora_incl & "'," 
					sql = sql & "'" & intCodDepto & "',"
					sql = sql & "'" & session("codEmpresa") & "',"
			
					sql = sql & "'" & strnome & "',"
					sql = sql & "'" & strFoneResidencial & "',"
					if stremail <> "" then
						sql = sql & "'" & LCase(stremail) & "',"
					else 
						sql = sql &" null ,"
					end if
					sql = sql & "'" & strCPF & "')"
					cnn.execute sql
					GravarLog sql
					
					sql = " delete from Seg_Acessos_Usuario"
					sql = sql & " where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
					sql = sql & " AND cod_colaborador = " & intCodFunc
					cnn.execute sql
					GravarLog sql
					
					if intCodPerfil<>"" then
						
						for i=0 to ubound(vetPerfil)
							sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse, cod_colaborador )"
							sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & vetPerfil(i) & "', 'N'," & intCodFunc & ")"
							cnn.execute sql
							GravarLog sql
						next
					
					end if
					
					sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA,  COD_EMPRESA )"
					sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & session("codEmpresa") & "')"
					cnn.execute sql
					GravarLog sql
				
				else
					
					sql = "Update SEG_USUARIOS_SISTEMA set"
					sql = sql & " Usua_Stat = '" & strStatus & "',"
					sql = sql & " CODIGO_DEPARTAMENTO = " & intCodDepto & ","
					
					if strSenha <> "" then
						sql = sql & " Usua_Info_Senha = '" & strSenha & "',"
					else
						sql = sql & " Usua_Info_Senha = null, "
					end if 
					sql = sql & " USUA_NOME_COMPLETO ='" & strnome & "',"
					sql = sql & " USUA_TELEFONE = '" & strFoneResidencial & "',"
					sql = sql & " USUA_CPF = '" & strcpf & "',"
					if strEmail <> "" then
						sql = sql & " USUA_EMAIL = '" & LCase(strEmail) & "'"
					else
						sql = sql & " USUA_EMAIL = null "
					end if 
					sql = sql & " where Usua_Codg = '" & strUsuarioPortal & "'"
					cnn.execute sql
					GravarLog sql
					
					sql = " delete from Seg_Acessos_Usuario"
					sql = sql & " where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
					sql = sql & " AND cod_colaborador = " & intCodFunc
					cnn.execute sql
					GravarLog sql
					
					if intCodPerfil<>"" then
						for i=0 to ubound(vetPerfil)
							CodPerilUsuario = trim(vetPerfil(i))
							if CodPerilUsuario = "" then CodPerilUsuario = "0"
							if CodPerilUsuario<>"0" then
								'sql = "SELECT Aces_Usua_Codg From Seg_Acessos_Usuario" 
								'sql = sql & " WHERE Aces_Usua_Codg = '" & strUsuarioPortal & "'"
								'sql = sql & " AND Aces_Perf_Codg = " & CodPerilUsuario
								'rs.open sql,cnn
								'if rs.eof = true then
									sql = " insert into Seg_Acessos_Usuario (Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse, cod_colaborador )"
									sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & vetPerfil(i) & "', 'N'," & intCodFunc & ")"
									cnn.execute sql
									GravarLog sql
								'end if		
								'rs.close	
								
								
							end if
						next
					end if
				end if
	
			end if
		end if
		'response.write intCodigoFuncionalAnterior & "-" & intCodFuncional
		if intCodigoFuncionalAnterior <> intCodFuncional then
			if session("CodGrupo") = "77777" then
				existeFuncPonto = "N"
				'sql = "select CODI_EMP "
				'sql = sql & " from gemul5.dbo.FUNCIONARIOS"
				'sql = sql & " where CODI_FUNC = '"& intCodFuncional & "'"
				'rs.open sql, cnn
				'if not rs.eof then
				'	existeFuncPonto = "S"
				'end if
				'rs.close
				
				if existeFuncPonto = "N" then
					SQL = "insert into gemul5.dbo.FUNCIONARIOS (CODI_EMP, CODI_FUNC, NOME_FUNC, EXCLUIDO, MATRICULA_FP, SEXO, CPF, MATRICULA_CRACHA, DATA_UPDATE, IMAGEM_FACIAL)"
					SQL = SQL & " select "
					SQL = SQL & " 1 AS CODI_EMP,"
					SQL = SQL & " " & intCodFuncional &","
					SQL = SQL & " '" & strnome & "',"
					SQL = SQL & " 'N',"
					SQL = SQL & " " & intCodFuncional & ","
					SQL = SQL & " SEXO,"
					SQL = SQL & " CPF,"
					SQL = SQL & " " & intCodFuncional & ","
					SQL = SQL & " GETDATE() AS DATA_UPDATE, IMAGEM_FACIAL"
					SQL = SQL & " from gemul5.dbo.FUNCIONARIOS "
					SQL = SQL & " where CODI_FUNC = " & intCodigoFuncionalAnterior
					'RESPONSE.WRITE SQL	& "<HR>"		
					'cnn.execute sql
					'GravarLog sql
				end if
				
				SQL = "UPDATE gemul5.dbo.FUNCIONARIOS SET EXCLUIDO = 'S'"
				SQL = SQL & " where CODI_FUNC = " & intCodigoFuncionalAnterior
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql
				'GravarLog sql
				
				existeFuncPonto = "N"
				sql = "select CODI_EMP "
				sql = sql & " from gemul5.dbo.FUNC_COLETOR"
				sql = sql & " where CODI_FUNC = '"& intCodFuncional & "'"
				rs.open sql, cnn
				if not rs.eof then
					existeFuncPonto = "S"
				end if
				rs.close
				
				if existeFuncPonto = "S" then
				
					SQL = " DELETE gemul5.dbo.FUNC_COLETOR "
					SQL = SQL & " where CODI_FUNC = " & intCodFuncional
					'RESPONSE.WRITE SQL	& "<HR>"		
					'cnn.execute sql
					'GravarLog sql
				
				end if
				SQL = " INSERT INTO GEMUL5.DBO.FUNC_COLETOR VALUES (1,"&intCodFuncional&","&intcodLotacao&", NULL, 0,0,0,0,0,0,1,NULL,NULL)"
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql					
				'GravarLog sql

				'coletor curinga
				SQL = " INSERT INTO GEMUL5.DBO.FUNC_COLETOR VALUES (1,"&intCodFuncional&",999, NULL, 0,0,0,0,0,0,1,NULL,NULL)"
				'cnn.execute sql												

				SQL = "insert into gemul5.dbo.COLETA (CODI_EMP, CODI_FUNC, DATA, HORA, COLETOR, STCATRACA, NSR)"
				SQL = SQL & " select CODI_EMP,"& intCodFuncional &",DATA,HORA,COLETOR,STCATRACA,NSR"
				SQL = SQL & " from gemul5.dbo.COLETA "
				SQL = SQL & " where CODI_FUNC = " & intCodigoFuncionalAnterior
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql
				'GravarLog sql
				
				SQL = " DELETE gemul5.dbo.COLETA "
				SQL = SQL & " where CODI_FUNC = " & intCodigoFuncionalAnterior
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql
				'GravarLog sql
				
				sql = "UPDATE SRH_COLABORADOR set codFuncional = " &intCodFuncional 
				sql = sql & " WHERE codigo = " & intCodFunc
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql
				'GravarLog sql		
				
				'coletor curinga
				SQL = " INSERT INTO APO_Historico_Matricula_Temporaria VALUES ("&intCodigoFuncionalAnterior&","&intCodFuncional&",GETDATE(),'"&trim(session("usuarioWeb"))&"')"
				'cnn.execute sql			
				'GravarLog sql
				
				sql = "UPDATE gemul5.dbo.FUNCIONARIOS set DATA_UPDATE = getdate() "
				sql = sql & " WHERE CODI_FUNC = " & intCodigoFuncionalAnterior
				'RESPONSE.WRITE SQL	& "<HR>"		
				'CNN.EXECUTE SQL
				'GravarLog sql

				sql = "UPDATE f set DATA_UPDATE = getdate() "
				sql = sql & " from  gemul5.dbo.FUNCIONARIOS f"
				sql = sql & " inner join  gemul5.dbo.FUNC_COLETOR fc on fc.CODI_FUNC = f.CODI_FUNC"
				sql = sql & " WHERE fc.CODI_FUNC = " & intCodFuncional
				'RESPONSE.WRITE SQL	& "<HR>"		
				'CNN.EXECUTE SQL
				'GravarLog sql
			end if
		end if		
		
		if trim(intCodFuncional) <> trim(intCodigoFuncionalAnterior) then
			sql = "select codigo "
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where CodFuncional = '"&intCodFuncional & "'"
			sql = sql & " and CodLotacao in (select codigo from seg_empresa where cod_grupo=" & session("codGrupo") & ")"
			rs.open sql, cnn
			if not rs.eof then
				if not isnull(rs("codigo")) then
					%>
					<script>
						alert("ATENÇÃO: Já existe um colaborador cadastrado com essa matrícula, verifique!");
						window.history.go(-1);
					</script>
					<%	
					response.end
				end if
			end if
			rs.close
		end if
		
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
		if strcpf <> "" then
			sql = sql & "cpf='" & strcpf & "',"
		else 
			sql = sql &"cpf=null ,"
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
		
		if strSituacao <> "0" then
			sql = sql & "Situacao='" & strSituacao & "',"
		else 
			sql = sql & "Situacao=null ,"
		end if	
		
		if strDatafastamento <> "" then
			sql = sql & "Datafastamento='" & strDatafastamento & "',"
		else 
			sql = sql & "Datafastamento=null ,"
		end if	
		
		if intCodCategoria <> "0" then
			sql = sql & "CodCategoria =" & intCodCategoria & ","
		else 
			sql = sql & "CodCategoria=null ,"
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
		
		if intCodDepartamento <> "0" then
			sql = sql & "CodDepartamento= " & intCodDepartamento & ","
		else 
			sql = sql & "CodDepartamento=null ,"
		end if	
		
		if Session("NivelPermissao") = "A" then
			if strUsuarioPortal <> "" then
				sql = sql & "codigo_SEG_USUARIOS_SISTEMA= '" & strUsuarioPortal & "',"
			else 
				sql = sql & "codigo_SEG_USUARIOS_SISTEMA=null ,"
			end if			
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
		if intcodRemocao <> "" then
			sql = sql & "codRemocao=" & intcodRemocao & ","
		else 
			sql = sql & "codRemocao=null ,"
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
		if intCodNivel <> "" then
			sql = sql & "Cod_nivel=" & intCodNivel & ","
		else 
			sql = sql & "Cod_nivel=null, "
		end if
	
		if strSalarioBase <> "" then
			sql = sql & "salario_base=" & strSalarioBase & ","
		else 
			sql = sql & "salario_base=null, "
		end if
		if strCargaHorariaTotal <> "" then
			sql = sql & "carga_horario_contratada=" & strCargaHorariaTotal & ","
		else 
			sql = sql & "carga_horario_contratada=null, "
		end if
		if strTotalAulas <> "" then
			sql = sql & "total_aulas=" & strTotalAulas & ","
		else 
			sql = sql & "total_aulas=null, "
		end if
		if strTotalAulasCumprida <> "" then
			sql = sql & "total_aulas_Cumprida=" & strTotalAulasCumprida & ","
		else 
			sql = sql & "total_aulas_Cumprida=null, "
		end if
		if strFatorExtraClasse <> "" then
			sql = sql & "Fator_Extra_Classe=" & strFatorExtraClasse & ","
		else 
			sql = sql & "Fator_Extra_Classe=null, "
		end if
		if strQuantidadeQuinquenio <> "" then
			sql = sql & "quantidade_quinquenio=" & strQuantidadeQuinquenio & ","
		else 
			sql = sql & "quantidade_quinquenio=null, "
		end if
		if strPercentualQuinquenio <> "" then
			sql = sql & "percentual_quinquenio=" & strPercentualQuinquenio & ","
		else 
			sql = sql & "percentual_quinquenio=null, "
		end if
		if strPercentualRepousoSemanal <> "" then
			sql = sql & "percentual_repouso_Semanal=" & strPercentualRepousoSemanal & ","
		else 
			sql = sql & "percentual_repouso_Semanal=null, "
		end if
		
		if strLattes <> "" then
			sql = sql & "Lattes = '" & strLattes & "',"
		else 
			sql = sql & "Lattes = null, "
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
		
		'readaptacao
		qtde = 1
		sql = "select count(codigo) as qtde from SRH_COLABORADOR_READAPTACAO "
		sql = sql & " where cod_colaborador = " & intCodFunc 
		rs.open sql, cnn
		if not rs.eof then
			qtde = rs("qtde")+1
		end if
		rs.close
		
		if qtde = "0" then qtde = 1
		
		'response.write "qtde:" & qtde
		
		'readaptacao
		if request.form("cmbReadaptacao") = "S" then
			for controle=qtde to 5
			
					id_funcao = request.form("cmbFuncaoReadaptacao_"&controle)
					tipo_readaptacao = request.form("cmbTipoReadaptacao_"&controle)
					data_inicio = request.form("txtDataInicio_"&controle)
					data_fim = request.form("txtDataFim_"&controle)
					obs = request.form("txtObs_"&controle)
					
					
					if id_funcao <> "0" then
					
						sql = " Insert into SRH_COLABORADOR_READAPTACAO (cod_Empresa, cod_colaborador, cod_funcao, tipo, data_inicio, data_final, observacao, usuario_incl, data_incl, usuario_altr, data_altr)" 
						sql = sql & " VALUES("
				
						sql = sql & "" & session("codEmpresa") & "," 
						sql = sql & "" & intCodFunc & "," 
						sql = sql & "" & id_funcao & "," 
						sql = sql & "'" & tipo_readaptacao & "',"
						
						if data_inicio = "" then
							sql = sql & "null,"
						else
							sql = sql & "'" & formatadataBD(data_inicio) & "'," 
						end if
						if data_fim = "" then
							sql = sql & "null,"
						else
							sql = sql & "'" & formatadataBD(data_fim) & "',"
						end if
				
						sql = sql & "'" & obs & "',"
						sql = sql & "'" & Session("UsuarioWeb") & "',getdate(),'" & Session("UsuarioWeb") & "',getdate())"
						'response.write sql
						cnn.execute sql
						GravarLog sql
						
					end if
	
			next	
		end if	
		
		'PROCESSO_LICENCA
		'sql = "delete SRH_COLABORADOR_PROCESSO_LICENCA "
		'sql = sql & " where cod_colaborador = " & intCodFunc 
		'cnn.execute sql
		'GravarLog sql
		'PROCESSO_LIBERACAO
		if request.form("cmbProcessoLicenca") = "S" then
			controle = 0
	
			id_funcao = request.form("cmbFuncaoProcessoLicenca_"&controle)
			cod_tipo_processo_licenca = request.form("cmbTipoProcessoLicenca_"&controle)
			data_inicio = request.form("txtDataInicioProcessoLicenca_"&controle)
			data_fim = request.form("txtDataFimProcessoLicenca_"&controle)
			obs = request.form("txtObsProcessoLicenca_"&controle)
			
			
			if id_funcao <> "0" and cod_tipo_processo_licenca <> "0" then
			
				sql = " Insert into SRH_COLABORADOR_PROCESSO_LICENCA (cod_Empresa, cod_colaborador, cod_funcao, cod_tipo_processo_licenca, data_inicio, data_final, observacao, usuario_incl, data_incl, usuario_altr, data_altr)" 
				sql = sql & " VALUES("
		
				sql = sql & "" & session("codEmpresa") & "," 
				sql = sql & "" & intCodFunc & "," 
				sql = sql & "" & id_funcao & "," 
				sql = sql & "" & cod_tipo_processo_licenca & ","
				
				if data_inicio = "" then
					sql = sql & "null,"
				else
					sql = sql & "'" & formatadataBD(data_inicio) & "'," 
				end if
				if data_fim = "" then
					sql = sql & "null,"
				else
					sql = sql & "'" & formatadataBD(data_fim) & "',"
				end if
		
				sql = sql & "'" & obs & "',"
				sql = sql & "'" & Session("UsuarioWeb") & "',getdate(),'" & Session("UsuarioWeb") & "',getdate())"

				cnn.execute sql
				GravarLog sql
			end if

		end if	
	
	    if strcpf <> "" then
		   if strSituacao = "I" then
				sql = "Update SEG_USUARIOS_SISTEMA set"
	  			sql = sql & " Usua_Stat = 'I'"
				sql = sql & " where Usua_Cpf = '"& trim(strcpf) & "'"
				cnn.execute sql
				GravarLog sql
				
				'Inativa modulação
				sql = "Update SRH_MODULACAO_DISCIPLINAR_DOCENTE set periodo_final = getdate(), DataFinal = getdate()"
				sql = sql & " where cod_colaborador = " & intCodFunc
				sql = sql & " and status = 'A'"
				sql = sql & " and tipo_contratacao <> 'C'"
				cnn.execute sql
				GravarLog sql
				
				sql = "Update SRH_MODULACAO_DISCIPLINAR_DOCENTE set DataFinal = getdate()"
				sql = sql & " where cod_colaborador = " & intCodFunc
				sql = sql & " and status = 'A'"
				sql = sql & " and tipo_contratacao = 'C'"
				cnn.execute sql
				GravarLog sql
				
				sql = "Update SRH_MODULACAO_DISCIPLINAR_DOCENTE set periodo_final = getdate(), DataFinal = getdate()"
				sql = sql & " where cod_colaborador = " & intCodFunc
				sql = sql & " and status = 'A'"
				'sql = sql & " and periodo_final is not null"
				cnn.execute sql
				GravarLog sql

				sql = "Update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status = 'I'"
				sql = sql & " where cod_colaborador = " & intCodFunc
				sql = sql & " and status = 'A'"
				cnn.execute sql
				GravarLog sql
			end if
		end if	
 	    
		'----------------
		'TROCA DE LOTACAO
		'----------------
		if intcodLotacaoAnterior <> intcodLotacao  then
			if intcodLotacaoAnterior = "" then intcodLotacaoAnterior = Session("CodEmpresa")
			' Criando Histórico de Lotação
			sql = " insert into SRH_LOTACAOHISTORICO (COD_COLABORADOR, COD_LOTACAO, DATA_ALTERACAO, DataLotacao, USUA_CODG)"
			sql = sql & " VALUES (" & intCodFunc & "," & intcodLotacaoAnterior & ", '" & formatadataBD(date()) & "','" & formatadataBD(strDataLotacao) & "','" & Session("UsuarioWeb") & "' )"
			cnn.execute sql
			GravarLog sql
			
			if session("CodGrupo") = "7" then
				sql = " insert into SRH_COLABORADOR_MOTIVO_LOTACAO (COD_COLABORADOR, codigo_motivo, OBSERVACAO, cod_lotacao_atual, cod_lotacao_nova, usuario_incl, data_hora_incl)"
				sql = sql & " VALUES (" & intCodFunc & "," & motivoTrocaLotacao & ",'" & obsmotivoTrocaLotacao & "'," & intcodLotacaoAnterior & "," & intcodLotacao & ",'" & Session("UsuarioWeb") & "',getdate())"
				cnn.execute sql
				GravarLog sql
			
				' ATUALIZA PONTO DELETE
				sql = " DELETE GEMUL5.DBO.FUNC_COLETOR"
				sql = sql & " WHERE CODI_FUNC = " & intCodFuncional
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql
				'GravarLog sql
						
				sql = "UPDATE f set DATA_UPDATE = getdate() "
				sql = sql & " from  gemul5.dbo.FUNCIONARIOS f"
				sql = sql & " inner join  gemul5.dbo.FUNC_COLETOR fc on fc.CODI_FUNC = f.CODI_FUNC"
				sql = sql & " WHERE fc.CODI_FUNC = " & intCodFuncional
				'RESPONSE.WRITE SQL	& "<HR>"		
				'CNN.EXECUTE SQL
				'GravarLog sql
				
				MODULAR = "N"
				'SQL = "SELECT ISNULL(F.MODULAR ,'N') AS MODULAR from srh_colaborador c"
				'SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.CODFUNCAO"
				'SQL = SQL & " WHERE C.CODIGO = " & intCodFunc
				'RS.OPEN SQL, CNN
				'IF NOT RS.EOF THEN
				'	MODULAR = RS("MODULAR")
				'END IF
				'RS.CLOSE
				
				IF MODULAR = "S" THEN 'MODULACAO
				
				
					SQL = " INSERT GEMUL5.DBO.FUNC_COLETOR"
					SQL = SQL & " select distinct 1, " & intCodFuncional & ", M.Cod_empresa, NULL, 0,0,0,0,0,0,1,NULL,NULL"
					SQL = SQL & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
					SQL = SQL & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO=M.COD_COLABORADOR"
					SQL = SQL & " WHERE C.CODFUNCIONAL=" & intCodFuncional
					SQL = SQL & " AND M.Ano_Letivo=" & session("strAnoLetivo")
					SQL = SQL & " AND C.SITUACAO = 'A'"
					SQL = SQL & " AND M.Status = 'A'"
					'RESPONSE.WRITE SQL	& "<HR>"		
					'cnn.execute sql
					'GravarLog sql
				ELSEIF MODULAR = "N" THEN 'CADASTRO
					SQL = " INSERT INTO GEMUL5.DBO.FUNC_COLETOR VALUES (1,"&intCodFuncional&","&intcodLotacao&", NULL, 0,0,0,0,0,0,1,NULL,NULL)"
					'RESPONSE.WRITE SQL	& "<HR>"		
					'cnn.execute sql								
					'GravarLog sql
				END IF
				
				'coletor curinga
				SQL = " INSERT INTO GEMUL5.DBO.FUNC_COLETOR VALUES (1,"&intCodFuncional&",999, NULL, 0,0,0,0,0,0,1,NULL,NULL)"
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql								
				'GravarLog sql
	
			end if
			
			' Grava Dociê
			sql = "SELECT Codigo, Cod_Empresa, Desc_EventoDossie"
			sql = sql & " FROM SRH_COLABORADOR_EVENTO_DOSSIE"
			sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
			sql = sql & " AND Desc_EventoDossie = 'Outros'"
			rs.open sql,cnn
			if rs.eof = false then
				intCodColaboradorEventoDossie = trim(rs("Codigo"))
			else
				intCodColaboradorEventoDossie = 0
			end if		
			rs.close	
			
			strAverbacoes = "Remoção realizada por " & session("UsuarioWeb")
			strValor = 0
			
			sql = "Insert Into SRH_DOSSIE_COLABORADOR( Cod_Colaborador, Cod_empresa, Cod_ColaboradorEventoDossie, "
			sql = sql & " Cod_cargo, Cod_lotacao," 
			sql = sql & " Cod_departamento, Data_admissao, Data_afastamento,"
			sql = sql & " DataPeridoReferencia_Inicio, DataPeridoReferencia_Final, "
			sql = sql & " DataPeriodoAquisicao_Inicio, DataPeriodoAquisicao_Final, "
			sql = sql & " Averbacoes, Valor )"
			sql = sql & " Values ("
			sql = sql & "" & intCodFunc & ","
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodColaboradorEventoDossie & ","
			
			if intCodCargo <> "0" then
				sql = sql & "" & intCodCargo & ","
			else
				sql = sql & "null, "
			end if 
			
			if intcodLotacao <> "0" then
				sql = sql & "" & intcodLotacao & ","
			else
				sql = sql & "null, "
			end if 
			
			if intCodDepartamento <> "0" then
				sql = sql & "" & intCodDepartamento & ","
			else
				sql = sql & "null, "
			end if 
				
			if strdata_admissao <> "" then
				sql = sql & "'" & strdata_admissao & "',"
			else
				sql = sql & "null, "
			end if 
			
			if strDatafastamento <> "" then
				sql = sql & "'" & strDatafastamento & "',"
			else
				sql = sql & "null, "
			end if 
			
			sql = sql & "'" & formatadataBD(date()) & "',"
			sql = sql & "'" & formatadataBD(date()) & "',"
			sql = sql & "'" & formatadataBD(date()) & "',"
			sql = sql & "'" & formatadataBD(date()) & "',"
			sql = sql & "'" & strAverbacoes & "',"
			sql = sql & "" & strValor & ")"
			cnn.execute sql
			GravarLog sql


		end if		
	    
		if intcodLotacaoAnterior <> ""  and strUsuarioPortal <> "" then
		
		   if trim(intcodLotacaoAnterior) <> trim(intcodLotacao)  then
		   
				sql = "Update SEG_USUARIOS_SISTEMA"
				sql = sql & " set cod_empresa = " & intcodLotacao
				sql = sql & " where Usua_codg = '" & strUsuarioPortal & "'"
				cnn.execute sql
				GravarLog sql
				
				sql = "SELECT COD_EMPRESA FROM SEG_USUARIOS_EMPRESA " 
				sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
				sql = sql & " AND COD_EMPRESA = " & intcodLotacao
				rs.open sql,cnn
				if rs.eof = false then
				   JaExiste = True
				else
				   JaExiste = False
				end if		
				rs.close
				
				if JaExiste = True then
					sql = " Update SEG_USUARIOS_EMPRESA "
					sql = sql & " set COD_EMPRESA = " & intcodLotacao
					sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
					sql = sql & " AND COD_EMPRESA = " & intcodLotacao
					cnn.execute sql
					GravarLog sql
				else
				
					sql = "delete SEG_USUARIOS_EMPRESA "
					sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
					sql = sql & " And COD_EMPRESA = " & intcodLotacaoAnterior 
					cnn.execute sql
					GravarLog sql


					sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA )"
					sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & intcodLotacao & "')"
					cnn.execute sql
					GravarLog sql
		        end if

			end if
		end if	
	
		'verifica se os campos:  Cargo, Nivel, Função e Situação
		'tiveram alterações será incluida automaticamente nas ocorrências do colaborador
		strCargoAtual 	 = request.Form("txtCargoAtual")
		if strCargoAtual = "" then strCargoAtual = "0"
		strFuncaoAtual 	 = request.Form("txtFuncaoAtual")
		if strFuncaoAtual = "" then strFuncaoAtual = "0"
		strNivelAtual 	 = request.Form("txtNivelAtual")
		if strNivelAtual= "" then strNivelAtual = "0"
		strSituacaoAtual = request.Form("txtSituacaoAtual")
		if strSituacaoAtual = "" then strSituacaoAtual = "0"
		strTurnoAtual 	= request.Form("txtTurnoAtual")
		if strTurnoAtual = "" then strTurnoAtual = "0"
		
		if trim(strCargoAtual) <> trim(intCodCargo) then
			
			strCargoAtualDesc = ""
			sql = "select Desc_Cargo from srh_cargocolaborador where cod_cargo = " & strCargoAtual
			rs.open sql, cnn
			if rs.eof = false then
				strCargoAtualDesc = rs("Desc_Cargo")
			end if
			rs.close
			strCargoDesc = ""
			sql = "select Desc_Cargo from srh_cargocolaborador where cod_cargo = " & intCodCargo
			rs.open sql, cnn
			if rs.eof = false then
				strCargoDesc = rs("Desc_Cargo")
			end if
			rs.close
			
			strOcorrencia = "Cargo foi alterado de " & strCargoAtualDesc & " para " & strCargoDesc & "."
			
			%><!--#include file="../includes/inc_lancamentoDeOcorrenciaColaborador.asp"--><%
		end if
		
		if trim(strDataLotacaoAnterior) <> trim(strDataLotacao) then
			strOcorrencia = "A data de lotação foi alterada de " & strDataLotacaoAnterior & " para " & strDataLotacao & "."
			%><!--#include file="../includes/inc_lancamentoDeOcorrenciaColaborador.asp"--><%
		end if

		if trim(strTurnoAtual) <> trim(intCodTurno) then
			
			strTurnoAtualDesc = ""
			sql = "select desc_turno from srh_turno where cod_turno = " & strTurnoAtual
			rs.open sql, cnn
			if rs.eof = false then
				strTurnoAtualDesc = rs("desc_turno")
			end if
			rs.close
			strTurnoDesc = ""
			sql = "select desc_turno from srh_turno where cod_turno = " & intCodTurno
			rs.open sql, cnn
			if rs.eof = false then
				strTurnoDesc = rs("desc_turno")
			end if
			rs.close
			
			strOcorrencia = "Turno foi alterado de " & strTurnoAtualDesc & " para " & strTurnoDesc & "."
			
			%><!--#include file="../includes/inc_lancamentoDeOcorrenciaColaborador.asp"--><%
		end if
		
		if trim(strFuncaoAtual) <> trim(intCodFuncao) then
			strFuncaoAtualDesc = ""
			sql = "select Desc_Funcao from srh_funcaocolaborador where cod_funcao = " & strFuncaoAtual
			rs.open sql, cnn
			if rs.eof = false then
				strFuncaoAtualDesc = rs("Desc_Funcao")
			end if
			rs.close
			strFuncaoDesc = ""
			sql = "select Desc_Funcao from srh_funcaocolaborador where cod_funcao = " & intCodFuncao
			rs.open sql, cnn
			if rs.eof = false then
				strFuncaoDesc = rs("Desc_Funcao")
			end if
			rs.close
			
			strOcorrencia = "Função foi alterado de " & strFuncaoAtualDesc & " para " & strFuncaoDesc & "."

			%><!--#include file="../includes/inc_lancamentoDeOcorrenciaColaborador.asp"--><%

			if session("CodGrupo") = "7" then

				' ATUALIZA PONTO DELETE
				sql = " DELETE GEMUL5.DBO.FUNC_COLETOR"
				sql = sql & " WHERE CODI_FUNC = " & intCodFuncional
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql
				'GravarLog sql
						
				sql = "UPDATE f set DATA_UPDATE = getdate() "
				sql = sql & " from  gemul5.dbo.FUNCIONARIOS f"
				sql = sql & " inner join  gemul5.dbo.FUNC_COLETOR fc on fc.CODI_FUNC = f.CODI_FUNC"
				sql = sql & " WHERE fc.CODI_FUNC = " & intCodFuncional
				'RESPONSE.WRITE SQL	& "<HR>"		
				'CNN.EXECUTE SQL
				'GravarLog sql
				
				MODULAR = "N"
				SITUACAO_DISCIPLINAR=""
				SQL = "SELECT ISNULL(F.MODULAR ,'N') AS MODULAR, F.SITUACAO_DISCIPLINAR from srh_colaborador c"
				SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.CODFUNCAO"
				SQL = SQL & " WHERE C.CODIGO = " & intCodFunc
				RS.OPEN SQL, CNN
				IF RS.EOF THEN
					MODULAR = RS("MODULAR")
					SITUACAO_DISCIPLINAR = RS("SITUACAO_DISCIPLINAR")
				END IF
				RS.CLOSE
				
				IF MODULAR = "S" THEN 'MODULACAO
					SQL = " INSERT GEMUL5.DBO.FUNC_COLETOR"
					SQL = SQL & " select distinct 1, " & intCodFuncional & ", M.Cod_empresa, NULL, 0,0,0,0,0,0,1,NULL,NULL"
					SQL = SQL & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
					SQL = SQL & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO=M.COD_COLABORADOR"
					SQL = SQL & " WHERE C.CODFUNCIONAL=" & intCodFuncional
					SQL = SQL & " AND M.Ano_Letivo=" & session("strAnoLetivo")
					SQL = SQL & " AND C.SITUACAO = 'A'"
					SQL = SQL & " AND M.Status = 'A'"
					'RESPONSE.WRITE SQL	& "<HR>"		
					'cnn.execute sql
					'GravarLog sql
				ELSEIF MODULAR = "N" THEN 'CADASTRO
					SQL = " INSERT INTO GEMUL5.DBO.FUNC_COLETOR VALUES (1,"&intCodFuncional&","&intcodLotacao&", NULL, 0,0,0,0,0,0,1,NULL,NULL)"
					'RESPONSE.WRITE SQL	& "<HR>"		
					'cnn.execute sql								
					'GravarLog sql
				END IF
				
				'coletor curinga
				SQL = " INSERT INTO GEMUL5.DBO.FUNC_COLETOR VALUES (1,"&intCodFuncional&",999, NULL, 0,0,0,0,0,0,1,NULL,NULL)"
				'RESPONSE.WRITE SQL	& "<HR>"		
				'cnn.execute sql								
				'GravarLog sql
	
				IF SITUACAO_DISCIPLINAR = "I" THEN
					'atualiza horario
					sql = "Delete from APO_FAIXA_HORARIO_COLABORADOR "
					sql = sql & " where COD_COLABORADOR = " & intCodFunc
					cnn.execute sql
					GravarLog sql
			
					for i=2 to 7
						strHoraInicio="" 
						strMinutoInicio=""
						strHoraFim=""
						strMinutoFim=""
			
						'INTEGRAL
						if trim(intCodTurno) = "4" then
							'atualiza o horario novo para a função alterada
							sql = "select top 1 h.hora, h.Minuto "
							sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
							sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
							sql = sql & " where cod_funcao=" & intCodFuncao
							sql = sql & " and Cod_turno=" & intCodTurno
							sql = sql & " and Cod_DiaSemana=" & i
							sql = sql & " and tipo='E'"
							sql = sql & " order by h.hora "
							rs.open sql, cnn
							if rs.eof = false then
								strHoraInicioM = rs("hora")
								strMinutoInicioM = rs("minuto")
							end if
							rs.close
							
							sql = "select top 1 h.hora, h.Minuto "
							sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
							sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
							sql = sql & " where cod_funcao=" & intCodFuncao
							sql = sql & " and Cod_turno=" & intCodTurno
							sql = sql & " and Cod_DiaSemana=" & i
							sql = sql & " and tipo='E'"
							sql = sql & " order by h.hora desc "
							rs.open sql, cnn
							if rs.eof = false then
								strHoraInicioV = rs("hora")
								strMinutoInicioV = rs("minuto")
							end if
							rs.close
				
							sql = "select top 1 h.hora, h.Minuto "
							sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
							sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
							sql = sql & " where cod_funcao="&intCodFuncao
							sql = sql & " and Cod_turno=" & intCodTurno
							sql = sql & " and Cod_DiaSemana=" & i
							sql = sql & " and tipo='S'"
							sql = sql & " order by h.hora "
							rs.open sql, cnn
							if rs.eof = false then
								strHoraFimM = rs("hora")
								strMinutoFimM = rs("minuto")
							end if
							rs.close
							
							sql = "select top 1 h.hora, h.Minuto "
							sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
							sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
							sql = sql & " where cod_funcao="&intCodFuncao
							sql = sql & " and Cod_turno=" & intCodTurno
							sql = sql & " and Cod_DiaSemana=" & i
							sql = sql & " and tipo='S'"
							sql = sql & " order by h.hora desc"
							rs.open sql, cnn
							if rs.eof = false then
								strHoraFimV = rs("hora")
								strMinutoFimV = rs("minuto")
							end if
							rs.close
							
							IF strHoraInicioV="" OR strMinutoInicioV ="" OR strHoraFimV = "" OR strMinutoFimV = "" THEN
							%>
								<script>
									alert("Função informada para esse colaborador está faixa sem de horário no turno!");
									window.location="colaborador_cad.asp";
								</script>
							<%
								RESPONSE.END
							END IF
							
							
							if modular = "S" then
								' Deleta a Tabela de Colaborador Folha
								sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
								sql = sql & " select distinct m.Cod_empresa, m.Cod_Colaborador, m.cod_Turno, "&i&", " & strHoraInicioM &", " & strMinutoInicioM &", " & strHoraFimM &", " & strMinutoFimM 
								sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE m "
								sql = sql & " inner join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao=m.Cod_Funcao"
								sql = sql & " Where m.Cod_Funcao = " & intCodFuncao & " and m.cod_Turno = " & intCodTurno & " and m.Status = 'A'"
								sql = sql & " and m.cod_colaborador="&intCodFunc
								sql = sql & " and m.cod_turno=" & intCodTurno
								'response.write sql & "<hr>"
								cnn.execute sql
								sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
								sql = sql & " select distinct m.Cod_empresa, m.Cod_Colaborador, m.cod_Turno, "&i&", " & strHoraInicioV &", " & strMinutoInicioV &", " & strHoraFimV &", " & strMinutoFimV 
								sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE m "
								sql = sql & " inner join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao=m.Cod_Funcao"
								sql = sql & " Where m.Cod_Funcao = " & intCodFuncao & " and m.cod_Turno = " & intCodTurno & " and m.Status = 'A'"
								sql = sql & " and m.cod_colaborador="&intCodFunc
								sql = sql & " and m.cod_turno=" & intCodTurno
								cnn.execute sql
							else
								sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
								sql = sql & " select codLotacao, codigo, codTurno, "&i&", " & strHoraInicioM &", " & strMinutoInicioM &", " & strHoraFimM &", " & strMinutoFimM 
								sql = sql & " from SRH_COLABORADOR"
								sql = sql & " where SITUACAO='A' and codigo="&intCodFunc
			
								cnn.execute sql	
								
								sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
								sql = sql & " select codLotacao, codigo, codTurno, "&i&", " & strHoraInicioV &", " & strMinutoInicioV &", " & strHoraFimV &", " & strMinutoFimV 
								sql = sql & " from SRH_COLABORADOR"
								sql = sql & " where SITUACAO='A' and codigo="&intCodFunc
								cnn.execute sql	
								'			response.write sql & "<hr>"
							end if
						
						'MATUTINO E VESPERTINO OU NOTURNO
						else
						
							'atualiza o horario novo para a função alterada
							sql = "select top 1 hora, Minuto "
							sql = sql & " from APO_PONTOHORARIO "
							sql = sql & " where Cod_turno=" & intCodTurno
							sql = sql & " and tipo='E'"
							sql = sql & " order by hora "
							rs.open sql, cnn
							if rs.eof = false then
								strHoraInicio = rs("hora")
								strMinutoInicio = rs("minuto")
							end if
							rs.close
				
							sql = "select top 1 hora, Minuto "
							sql = sql & " from APO_PONTOHORARIO "
							sql = sql & " where Cod_turno=" & intCodTurno
							sql = sql & " and tipo='S'"
							sql = sql & " order by hora desc"
							rs.open sql, cnn
							if rs.eof = false then
								strHoraFim = rs("hora")
								strMinutoFim = rs("minuto")
							end if
							rs.close
							
							sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
							sql = sql & " select codLotacao, codigo, codTurno, "&i&", " & strHoraInicio &", " & strMinutoInicio &", " & strHoraFim &", " & strMinutoFim 
							sql = sql & " from SRH_COLABORADOR"
							sql = sql & " where SITUACAO='A' and codigo="&intCodFunc
							cnn.execute sql						
						
						end if
						
					next
				END IF
			end if
				
		end if
		
		if trim(strNivelAtual) <> trim(intCodNivel) then
			strOcorrencia = "Nível foi alterado. "
			%><!--#include file="../includes/inc_lancamentoDeOcorrenciaColaborador.asp"--><%
		end if
		if trim(strSituacaoAtual) <> trim(strSituacao) then
			if strSituacaoAtual = "A" then strSituacaoAtualDesc = "Ativo"
			if strSituacao 		= "A" then strSituacaoDesc = "Ativo"
			if strSituacaoAtual = "I" then strSituacaoAtualDesc = "Inativo"
			if strSituacao 		= "I" then strSituacaoDesc = "Inativo"
			strOcorrencia = "Situação foi alterada de " & strSituacaoAtualDesc & " para " & strSituacaoDesc & "."
			%><!--#include file="../includes/inc_lancamentoDeOcorrenciaColaborador.asp"--><%
		end if
		
		
	elseif strAcao = "E" then 
		
		strMensagem = "Registro excluido com sucesso!"

		intCodPerfil = 11 'PROFESSORES
	 	if strUsuarioPortal <> "" then

			sql = "delete Seg_Acessos_Usuario "
			sql = sql & " where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
			sql = sql & " and Aces_Perf_Codg = " & intCodPerfil
			cnn.execute sql
			GravarLog sql
	
			sql = "delete SEG_USUARIOS_EMPRESA "
			sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
			cnn.execute sql
			GravarLog sql

			sql = "delete SEG_USUARIOS_SISTEMA "
			sql = sql & " where USUA_CODG = '" & strUsuarioPortal & "'"
			cnn.execute sql
			GravarLog sql
			
			sql = " Delete from SCA_horario_aula "
			sql = sql & " where Cod_Colaborador = " & intCodFunc
			cnn.execute sql
			GravarLog sql
		end if		
		
		sql = "DELETE FROM SRH_OCORRENCIA"
		sql = sql & " where Cod_Colaborador = " & intCodFunc
		cnn.execute sql
		GravarLog sql

		sql = "DELETE FROM SRH_LOTACAOHISTORICO"
		sql = sql & " where Cod_Colaborador = " & intCodFunc
		cnn.execute sql
		GravarLog sql
		
		'INICIO PONTO
		if session("CodGrupo") = "7" then
			
			SQL = "UPDATE gemul5.dbo.FUNCIONARIOS SET EXCLUIDO = 'S', DATA_UPDATE = getdate() "
			SQL = SQL & " where CODI_FUNC = " & intCodFuncional
			'cnn.execute sql
			'GravarLog sql
			
			' ATUALIZA PONTO DELETE
			sql = " DELETE GEMUL5.DBO.FUNC_COLETOR"
			sql = sql & " WHERE CODI_COLE = " & intcodLotacao
			sql = sql & " AND 	CODI_FUNC = " & intCodFuncional
			'cnn.execute sql
			'GravarLog sql
			
			'FIM PONTO
		end if
		
		sql = "DELETE FROM SRH_COLABORADOR"
		sql = sql & " WHERE codigo = " & intCodFunc		
		cnn.execute sql
		GravarLog sql


	elseif strAcao = "P" then 

		intCodFuncOutraEmpresa = request("cd_func")
		strMensagem = "Registro importado com sucesso!"

		sql = "SELECT max(codigo) as NovoCodigo From SRH_COLABORADOR" 
		rs.open sql,cnn
		if rs.eof = false then
			if isnull(rs("NovoCodigo")) = false then
				intCodFunc = cint(rs("NovoCodigo")) + 1
			else
				intCodFunc = 1
			end if
		else
			intCodFunc = 1
		end if		
		rs.close	
		

				
		sql = "insert srh_colaborador"
		sql = sql & " select	"&intCodFunc&","
		sql = sql & "" & session("codEmpresa") & ","
		sql = sql & " nome,"
		sql = sql & " data_admissao,"
		sql = sql & " logradouro,"
		sql = sql & " numero_logradouro,"
		sql = sql & " Comp_Endereco,"
		sql = sql & " bairro,"
		sql = sql & " Cidade,"
		sql = sql & " uf,"
		sql = sql & " cep,"
		sql = sql & " FoneResidencial,"
		sql = sql & " FoneComercial,"
		sql = sql & " FoneCelular,"
		sql = sql & " carteira_reservista,"
		sql = sql & " email,"
		sql = sql & " email_coorporativo,"
		sql = sql & " pai,"
		sql = sql & " mae,"
		sql = sql & " data_nascimento,"
		sql = sql & " naturalidade,"
		sql = sql & " UFNaturalidade,"
		sql = sql & " nacionalidade,"
		sql = sql & " estado_civil,"
		sql = sql & " conjuge,"
		sql = sql & " numero_filhos,"
		sql = sql & " cpf,"
		sql = sql & " rg,"
		sql = sql & " orgaoexp,"
		sql = sql & " titulo_eleitor,"
		sql = sql & " carteira_trabalho,"
		sql = sql & " pis,"
		sql = sql & " Sexo,"
		sql = sql & " Situacao,"
		sql = sql & " Datafastamento,"
		sql = sql & " CodCategoria,"
		sql = sql & " CodGrauInstrucao,"
		sql = sql & " Cargo,"
		sql = sql & " Funcao,"
		sql = sql & " CodDepartamento,"
		sql = sql & " Obs,"
		sql = sql & " codigo_SEG_USUARIOS_SISTEMA,"
		sql = sql & " codFuncional,"
		sql = sql & " codFuncao,"
		sql = sql & " codCargo,"
		sql = sql & " codLotacao,"
		sql = sql & " codRemocao,"
		sql = sql & " CNH,"
		sql = sql & " CategoriaCNH,"
		sql = sql & " codFormaNomeacao,"
		sql = sql & " CodTurno,"
		sql = sql & " Cod_nivel,"
		sql = sql & " salario_base,"
		sql = sql & " carga_horario_contratada,"
		sql = sql & " total_aulas,"
		sql = sql & " total_aulas_Cumprida,"
		sql = sql & " Fator_Extra_Classe,"
		sql = sql & " percentual_quinquenio,"
		sql = sql & " quantidade_quinquenio,"
		sql = sql & " percentual_repouso_Semanal,"
		sql = sql & " valor_rubrica,"
		sql = sql & " modular,"
		sql = sql & " Lattes,"
		sql = sql & " DataLotacao,"
		sql = sql & " Cod_Regencia"
		sql = sql & " from	srh_colaborador"
		sql = sql & " where	codigo = " & intCodFuncOutraEmpresa
		'cnn.execute sql
		'GravarLog sql
		'funcionalidade foi desabilitada por estar duplicando!

	end if
	if session("CodGrupo") = "7" and trim(request.ServerVariables("SERVER_NAME")) <> "desenv.gemul.com.br" then
		if intCodFunc<>"" then
			'ATUALIZA PONTO - FAIXA 
			sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & year(date) & "," & session("CodGrupo") & "," & intCodFunc
			'cnn.execute sql
			
			'ATUALIZA PONTO - LOTACAO
			sql = "EXECUTE SP_APO_Atualiza_Lotacao_Ponto " & year(date) & "," & session("CodGrupo") & "," & intCodFunc
			'cnn.execute sql
		end if
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		if strUsuarioPortal <> "" then
		
			sql = "select count(*) as contLogin "
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where cod_empresa = "& session("codEmpresa")
			sql = sql & " and codigo_SEG_USUARIOS_SISTEMA = '"&strUsuarioPortal & "'"
			sql = sql & " and cpf <> '"& strcpf & "'"
			rs.open sql, cnn
			if not rs.eof then
				if not isnull(rs("contLogin")) then
					if cInt(rs("contLogin"))> 1 then
						rs.close
						cnn.Rollbacktrans
						%>
						<script>
							alert("ATENÇÃO: \n\nLogin já utilizado por outro colaborador.");
							window.location.href = 'Colaborador_cad.asp?txtCodFuncionario=<%=intCodFunc%>'
						</script>
						<%	
						response.End()
					end if
				end if
				rs.close
			else
				rs.close
			end if
		end if

		'atualiza nome de diretor e secretario
		if strAcao="I" or strAcao="A" then
					
			'--diretor
			strNomeAtualizadoDiretor = ""
			strEmailAtualizadoDiretor = ""
			strFoneAtualizadoDiretor = ""
			sql = " select distinct nome,  FoneCelular, email "
			sql = sql & " from srh_colaborador"
			sql = sql & " where situacao = 'A'"
			sql = sql & " and codLotacao = " & intcodLotacao
			sql = sql & " and codFuncao in	(select cod_funcao from SRH_FUNCAOCOLABORADOR where desc_funcao like '%diretor%' and cod_grupo="&session("CodGrupo")&")"
				'response.write sql
			rs.open sql, cnn
			if not rs.eof then
				while not rs.eof
					if strNomeAtualizadoDiretor = "" then
						strNomeAtualizadoDiretor = rs("nome")
					else
						strNomeAtualizadoDiretor = strNomeAtualizadoDiretor & " / " & rs("nome")
					end if
					if strEmailAtualizadoDiretor = "" then
						strEmailAtualizadoDiretor = rs("email")
					else
						strEmailAtualizadoDiretor = strEmailAtualizadoDiretor & " / " & rs("email")
					end if
					if strFoneAtualizadoDiretor = "" then
						strFoneAtualizadoDiretor = rs("FoneCelular")
					else
						strFoneAtualizadoDiretor = strFoneAtualizadoDiretor & " / " & rs("FoneCelular")
					end if
					
					rs.movenext
				wend
			end if
			rs.close

			'--secretaria
			strNomeAtualizadoSecretaria = ""
			strEmailAtualizadoSecretaria = ""
			strFoneAtualizadoSecretaria = ""
			sql = " select distinct nome,  FoneCelular, email "
			sql = sql & " from srh_colaborador"
			sql = sql & " where situacao = 'A'"
			sql = sql & " and codLotacao = " & intcodLotacao
			sql = sql & " and codFuncao in	(select cod_funcao from SRH_FUNCAOCOLABORADOR where desc_funcao like '%SECRETÁRIO%' and cod_grupo="&session("CodGrupo")&")"
			rs.open sql, cnn
			if not rs.eof then
				while not rs.eof
					if strNomeAtualizadoSecretaria = "" then
						strNomeAtualizadoSecretaria = rs("nome")
					else
						strNomeAtualizadoSecretaria = strNomeAtualizadoSecretaria & " / " & rs("nome")
					end if
					if strEmailAtualizadoSecretaria = "" then
						strEmailAtualizadoSecretaria = rs("email")
					else
						strEmailAtualizadoSecretaria = strEmailAtualizadoSecretaria & " / " & rs("email")
					end if
					if strFoneAtualizadoSecretaria = "" then
						strFoneAtualizadoSecretaria = rs("FoneCelular")
					else
						strFoneAtualizadoSecretaria = strFoneAtualizadoSecretaria & " / " & rs("FoneCelular")
					end if
					
					rs.movenext
				wend
			end if
			rs.close
			
			sql = " update seg_empresa set DIRETOR = '" & left(trim(strNomeAtualizadoDiretor),150) & "',"
			sql = sql & " EMAIL_DIRETORIA = '" & left(trim(strEmailAtualizadoDiretor),140) & "', "
			sql = sql & " contato = '" & left(trim(strFoneAtualizadoDiretor),50) & "' where codigo = " & intcodLotacao
			
			'RESPONSE.WRITE SQL
			
			cnn.execute sql
			GravarLog sql
			
			session("NomeDiretorEmpresaWeb") = left(strNomeAtualizadoDiretor,150)
			
			sql = " update seg_empresa set SECRETARIA = '" & left(strNomeAtualizadoSecretaria,150) & "',"
			sql = sql & " EMAIL_FINANCEIRO = '" & left(strEmailAtualizadoSecretaria,140) & "', "
			sql = sql & " contato1 = '" & left(strFoneAtualizadoSecretaria,50) & "' where codigo = " & intcodLotacao
			cnn.execute sql
			GravarLog sql
			'RESPONSE.WRITE SQL
			session("NomeSecretariaEmpresaWeb") = left(strNomeAtualizadoSecretaria,150)
			
			
			'RESPONSE.END
		end if

		
		'atualizando a funcao da readaptacao
		sql = "update SRH_COLABORADOR set codFuncao_readaptacao = null where codFuncao_readaptacao is not null"
		cnn.execute sql

		sql = "select max(data_final) as data_fim, cod_colaborador, cod_funcao"
		sql = sql & " into #temp_readaptacao"
		sql = sql & " from SRH_COLABORADOR_READAPTACAO" 
		sql = sql & " group by cod_funcao, cod_colaborador"
		sql = sql & " update c set c.codFuncao_readaptacao = t.cod_funcao"
		sql = sql & " from SRH_COLABORADOR c"
		sql = sql & " inner join #temp_readaptacao t on t.cod_colaborador = c.codigo"
		cnn.execute sql
		
		cnn.commitTrans
		
		if strAcao="I" then
		%>
		<script>
			var men = 'Colaborador Salvo com sucesso. Deseja imprimir o relatório de locação?\n';
			var caminho = 'Rel_Declaracao_Lotacao_rel.asp?CodColaborador=<%=intCodFunc%>&CodLotacao=<%=intcodLotacao%>&CodLotacaoAnterior=<%=intcodLotacaoAnterior%>';
			if (confirm(men)) {
				//window.showModalDialog(caminho,"Dialog Box Arguments # 1","dialogHeight:543px; dialogWidth:793px; dialogTop: 0px; dialogLeft: 0px; edge: Raised; center: No; help: No; resizable: No; status: No")
				 window.open(caminho,"consulta", "top=0,left=0,height=570,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
				 //window.location.href = 'Rel_Declaracao_Lotacao_rel.asp?CodColaborador=<%=intCodFunc%>&CodLotacao=<%=intcodLotacao%>&CodLotacaoAnterior=<%=intcodLotacaoAnterior%>';
			}
		   window.location.href = 'Colaborador_cad.asp?txtCodFuncionario=<%=intCodFunc%>'
		</script>			
		<%
		end if
		
		if strAcao="A" and intcodLotacaoAnterior <> "" then
	      if intcodLotacaoAnterior <> intcodLotacao  then
		      %>
				<script>
                    var men = 'Colaborador Alterado com sucesso. Deseja imprimir o relatório de locação ou Remoção?\n';
                    var caminho = 'Rel_Declaracao_Remocao_rel.asp?CodColaborador=<%=intCodFunc%>&CodLotacao=<%=intcodLotacao%>&CodLotacaoAnterior=<%=intcodLotacaoAnterior%>';
                    if (confirm(men)) {
                        //window.showModalDialog(caminho,"Dialog Box Arguments # 1","dialogHeight:543px; dialogWidth:793px; dialogTop: 0px; dialogLeft: 0px; edge: Raised; center: No; help: No; resizable: No; status: No")
                        window.open(caminho,"consulta", "top=0,left=0,height=570,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
                    }
                   window.location.href = 'Colaborador_cad.asp?txtCodFuncionario=<%=intCodFunc%>'
                </script>			
			   <%
			   else 
				%>
				<script>
					alert("<%=strMensagem%>");
					window.location.href = 'Colaborador_cad.asp?txtCodFuncionario=<%=intCodFunc%>'
				</script>			

				<%
			   
		  end if	   
		end if
		
		if strAcao="E" or strAcao="P" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location.href = 'Colaborador_cad.asp?txtCodFuncionario=<%=intCodFunc%>'
		</script>			
		<%
		end if
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>