<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"--> 
<!--#include file="../../includes/inc_formataCPF.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
            <div class="container">
                <h1 class="pull-left">SRH - Recurso Humano</h1>
                <ul class="pull-right breadcrumb">
                    <li><a href="Default.asp">Home</a></li>
                    <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
                </ul>
            </div><!--/container-->
        </div><!--/breadcrumbs-->
        <!--=== End Breadcrumbs ===-->
	
    <%
if trim(session("voltarPaginaParaColaboradorModulacao")) = "" then
	 session("voltarPaginaParaColaboradorModulacao") = request("paginaVoltar")
end if   


	if trim(Session("CodTodasEmpresaGrupo")) = "" then
		intCodGrupo = 0
		strGrupo = ""
		sql = "select SEG_EMPRESA.COD_GRUPO, SEG_GRUPO.DESCRICAO AS GRUPO"
		sql = sql & " FROM SEG_USUARIOS_EMPRESA"
		sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
		sql = sql & " INNER JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
		sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & session("UsuarioWeb") & "' "
		sql = sql & " AND SEG_USUARIOS_EMPRESA.COD_EMPRESA = " & SESSION("CODEMPRESA")
		RsAux.Open SQL, cnn,3 ,1
		if not RsAux.EOF then
			intCodGrupo = rsAux("cod_grupo")
			strGrupo = rsAux("grupo")
		end if
		RsAux.close
		
		sql = "select SEG_USUARIOS_EMPRESA.COD_EMPRESA"
		sql = sql & " FROM SEG_USUARIOS_EMPRESA"
		sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
		sql = sql & " LEFT 	JOIN SEG_GRUPO 	 ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
		sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & session("UsuarioWeb") & "' "
		sql = sql & " AND SEG_EMPRESA.COD_GRUPO = " & intCodGrupo
		RsAux.Open SQL, cnn,3 ,1
		if not RsAux.EOF then
			Session("QtdeUsuarioEmpresaAcessa") = RsAux.recordCount
			while not rsAux.eof
				if intCodEmpTodas = "" then
					intCodEmpTodas = RsAux("cod_empresa")
				else
					intCodEmpTodas = intCodEmpTodas & ", " & RsAux("cod_empresa")
				end if
				rsAux.movenext
			wend
		end if
		RsAux.close
		
		Session("CodGrupo") = intCodGrupo
		Session("Grupo") = strGrupo
		Session("CodTodasEmpresaGrupo") = intCodEmpTodas
		Session("strNomeGrupo") = strGrupo
	end if
	
    strPaginaTitulo = "Colaborador_cad.asp"

	strCompartilharDados 			= "S"
    strModulacaoDiscipinarDocente 	= "S"
	strSubmitNivel      			= "" 
	strPagina						= "Colaborador_cad.asp"
	intCodigo	 					= Trim(Request("txtCodFuncionario"))
	strNomeBotaoFoto				= "Incluir Foto"
	strBloqUsu 						= ""
	strAnoLetivo 					= session("strAnoLetivo")
	strSemestre 					= session("strSemestre")
	intCodEmp          				= Trim(Request.Form("txtCodEmpresa"))
	strUsuarioPortal 				= Trim(Request.Form("txtUsuarioPortal"))
	strStatus						= Trim(Request.Form("optStatus"))
	if Trim(Request.form("txtCodFuncionario")) = "" then
		intCodigo 						= Trim(Request("txtCodFuncionario"))
	else
		intCodigo 						= Trim(Request.form("txtCodFuncionario"))
	end if	
	intCodigoFuncionalAnterior 						= Trim(Request.Form("txtCodigoFuncionalAnterior"))					
	strnome 						= Trim(Request.Form("txtNomeFuncionario"))
	strdata_admissao  				= Trim(Request.Form("txtdata_admissao"))
	intCodFuncao 	    			= TRIM(Request.Form("cmbFuncao"))
	intCodCargo 	    			= TRIM(Request.Form("cmbCargo"))
	intCodTurno 					= TRIM(Request.Form("cmbTurnoRH"))
	intcodLotacao 	    			= TRIM(Request.Form("cmbLotacao"))
	intcodLotacaoAnterior 			= Trim(Request("txtcodLotacaoAnterior"))
	intcodRemocao    				= TRIM(Request.Form("cmbRemocao"))
		
	'endereço
	strLogradouro 		= UCASE(trim(replace(Trim(Request.Form("txtLogradouro")),"'"," "))) 
	strNumero_endereco 	= UCASE(trim(replace(Trim(Request.Form("txtNumero_endereco")),"'"," "))) 
	strComp_endereco 	= UCASE(trim(replace(Trim(Request.Form("txtComp_endereco")),"'"," ")))  
	strBairro    		= UCASE(trim(replace(Trim(Request.Form("txtBairro")),"'"," ")))  
	strCidade       	= UCASE(trim(replace(Trim(Request.Form("txtCidade")),"'"," ")))   
	strUf 				= UCASE(trim(replace(Trim(Request.Form("cmbUfresidencia")),"'"," ")))   
	strCep          	= UCASE(trim(replace(Trim(Request.Form("txtCep")),"'"," "))) 
	
	strFoneResidencial  = Trim(Request.Form("txtFoneResidencial"))
	strFoneComercial    = Trim(Request.Form("txtFoneComercial"))
	strFoneCelular      = Trim(Request.Form("txtFoneCelular"))
	carteira_reservista	= Trim(Request.Form("carteira_reservista"))
	
	stremail  			= Trim(Request.Form("txtemail"))
	strEmailCoorporativo= Trim(Request.Form("txtEmailCoorporativo"))
	strpai  			= Trim(Request.Form("txtpai"))
	strmae  			= Trim(Request.Form("txtmae"))
	strdata_nascimento  = Trim(Request.Form("txtData_Nascimento"))
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
	strDatafastamento	= Trim(Request.Form("txtDatafastamento"))	
	intCodCategoria		= Trim(Request.Form("cmbCategoria"))	
	intCodGrauInstrucao	= Trim(Request.Form("cmbGrauInstrucao"))	
	strCargo			= Trim(Request.Form("txtCargo"))
	strFuncao			= Trim(Request.Form("txtFuncao"))
	intCodDepartamento	= Trim(Request.Form("cmbDepartamento"))
	intCodFuncional  	= Trim(Request.Form("txtCodigoFuncional"))
	strObs				= Trim(Request.Form("txtObs"))
	intCodDepto		 	= Trim(Request.Form("cmbDepartamento"))
	intCodformanomeacao	= Trim(Request.Form("cmbFormaNomeacao"))
	
	
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
	strDataLotacao				= Trim(Request.Form("txtDataLotacao"))
	intCodRegencia				= Trim(Request.Form("cmbRegencia"))
	strCarregado				= Trim(Request.Form("txtCarregado"))
	
	if intCodNivel = "" then intCodNivel = "0"
	if intCodEmp = "" then intCodEmp = session("codEmpresa")

	if Trim(Request.Form("LocalizarMatricula")) = "S" and intCodFuncional <> "" then
		sql = "SELECT * "
		sql = sql & " FROM 	SRH_COLABORADOR C "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " Where CodFuncional = " & intCodFuncional
		sql = sql & " and E.COD_GRUPO = " & session("codGrupo")
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	= Trim(Rs("Codigo"))
			strUsuarioPortal	= Trim(Rs("codigo_SEG_USUARIOS_SISTEMA"))
			intCodigo	 		= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strnome 			= Trim(Rs("nome"))
			strdata_admissao  	= formatadataAP(Trim(Rs("data_admissao")))
			
			' Endereco
			strLogradouro 		= TRIM(rs("Logradouro"))
			strNumero_endereco 	= TRIM(rs("numero_logradouro"))
			strComp_endereco 	= TRIM(rs("Comp_endereco"))
			strBairro 		    = TRIM(rs("Bairro"))
			strCidade	        = TRIM(rs("Cidade"))
			strUfresidencia 	= TRIM(rs("UF"))
			strCep 	            = TRIM(rs("Cep"))
			
			intCodFuncao 	      = TRIM(rs("codFuncao"))
			intCodCargo 	      = TRIM(rs("codCargo"))
			intCodTurno= TRIM(rs("codTurno"))
			intcodLotacao 	      = TRIM(rs("codLotacao"))
			intcodLotacaoAnterior = TRIM(rs("codLotacao"))
			intcodRemocao 	      = TRIM(rs("CodRemocao"))
			strCNH 	           	  = TRIM(rs("CNH"))
			strCategoriaCNH 	  = TRIM(rs("CategoriaCNH"))
			intCodFormaNomeacao	  = TRIM(rs("codFormaNomeacao"))
		
			intCodRegencia		  = TRIM(rs("Cod_Regencia"))

			strSenha 			= ""
			if strUsuarioPortal <> "" then
				sql = " SELECT Usua_Info_senha,Usua_Stat, USUA_CODG "
				sql = sql & " FROM SEG_USUARIOS_SISTEMA"
				sql = sql & " WHERE USUA_CODG = '" &  strUsuarioPortal & "'"
				rsAux.open sql, cnn
				if not rsAux.eof then
					strBloqUsu = " readonly "
					strUsuarioPortal			= Trim(rsAux("USUA_CODG"))
					strStatus 					= Trim(rsAux("Usua_Stat"))
					strSenha 					= Trim(rsAux("Usua_Info_senha"))
				end if
				rsAux.close
			end if
												
			strFoneResidencial  = Trim(Rs("FoneResidencial"))
			strFoneComercial    = Trim(Rs("FoneComercial"))
			strFoneCelular      = Trim(Rs("FoneCelular"))
			carteira_reservista	= Trim(Rs("carteira_reservista"))
			stremail  			= Trim(Rs("email"))
			strEmailCoorporativo= Trim(Rs("email_coorporativo"))
			strpai  			= Trim(Rs("pai"))
			strmae  			= Trim(Rs("mae"))
			strdata_nascimento  = formataDataAP(Trim(Rs("Data_Nascimento")))
			strnaturalidade  	= Trim(Rs("naturalidade"))
			strUFNaturalidade 	= Trim(Rs("UFNaturalidade")) 
			strnacionalidade  	= Trim(Rs("nacionalidade"))
			strestado_civil  	= Trim(Rs("estado_civil"))
			strconjuge  		= Trim(Rs("conjuge"))
			strnumero_filhos  	= Trim(Rs("numero_filhos"))
			strrg  				= Trim(Rs("rg"))
			strorgao_expedidor  = Trim(Rs("orgaoExp"))
			strtitulo_eleitor  	= Trim(Rs("titulo_eleitor"))
			strcarteira_trabalho= Trim(Rs("carteira_trabalho"))
			strpis  			= Trim(Rs("pis"))
			strSexo 			= Trim(Rs("Sexo"))
			strSituacao			= Trim(Rs("Situacao"))	
			strDatafastamento	= Trim(Rs("Datafastamento"))
			intCodCategoria		= Trim(Rs("CodCategoria"))	
			intCodGrauInstrucao	= Trim(Rs("CodGrauInstrucao"))
			strCargo			= Trim(Rs("Cargo"))
			strFuncao			= Trim(Rs("Funcao"))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			intCodigoFuncionalAnterior = Trim(Rs("CodFuncional"))
			intCodDepartamento	= Trim(Rs("CodDepartamento"))
			strObs				= Trim(Rs("Obs"))
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			strLattes			= Trim(Rs("Lattes"))
			strDataLotacao 		= formataDataAP(Rs("DataLotacao"))
			intCodNivel 		= rs("Cod_nivel")
			
			'if trim(Request.Form("cmbNivel")) <> trim(rs("Cod_nivel")) then
			
			if isnull(rs("salario_base")) or rs("salario_base") = "" then 
			   strSalarioBase				= "0"
			   strSalarioBase 				= formatNumber(strSalarioBase,2) 
			else   
			   strSalarioBase 				= formatNumber(rs("salario_base"),2) 
			end if   
			strCargaHorariaTotal 		= rs("carga_horario_contratada")
			strTotalAulas		 		= rs("total_aulas")
			strTotalAulasCumprida 		= rs("total_aulas_Cumprida")
			strFatorExtraClasse	 		= rs("Fator_Extra_Classe")
			strPercentualRepousoSemanal	= rs("percentual_repouso_Semanal")
			strPercentualQuinquenio		= rs("percentual_quinquenio")
			strQuantidadeQuinquenio		= rs("quantidade_quinquenio")
			strSimouNao					= rs("modular")
		else
			%>
			<script>
				alert("Matrícula não Localizada. Verifique!")
			</script>
			<%
		end if
		rs.close
	end if
	if trim(intCodigo) <> "" and Trim(Request.Form("LocalizarMatricula")) <> "S" then
	
		sql = "SELECT  * "
		sql = sql & " FROM SRH_COLABORADOR "
		sql = sql & " Where Codigo = " & intCodigo
		'sql = sql & " And Cod_empresa = " & session("codEmpresa")
		rs.open sql, cnn
		if rs.eof = false then
			IF strCarregado = "" THEN
				strUsuarioPortal	= Trim(Rs("codigo_SEG_USUARIOS_SISTEMA"))
					
				intCodigo	 		= rs("Codigo")
				intCodEmp           = rs("Cod_Empresa")
				strnome 			= Trim(Rs("nome"))
				strdata_admissao  	= formatadataAP(Trim(Rs("data_admissao")))
				
				' Endereco
				strLogradouro 		= TRIM(rs("Logradouro"))
				strNumero_endereco 	= TRIM(rs("numero_logradouro"))
				strComp_endereco 	= TRIM(rs("Comp_endereco"))
				strBairro 		    = TRIM(rs("Bairro"))
				strCidade	        = TRIM(rs("Cidade"))
				strUfresidencia 	= TRIM(rs("UF"))
				strCep 	            = TRIM(rs("Cep"))
				
				intCodFuncao 	      = TRIM(rs("codFuncao"))
				intCodCargo 	      = TRIM(rs("codCargo"))
				intCodTurno= TRIM(rs("codTurno"))
				intcodLotacao 	      = TRIM(rs("codLotacao"))
				intcodLotacaoAnterior = TRIM(rs("codLotacao"))
				intcodRemocao 	      = TRIM(rs("CodRemocao"))
				strCNH 	           	  = TRIM(rs("CNH"))
				strCategoriaCNH 	  = TRIM(rs("CategoriaCNH"))
				intCodFormaNomeacao	  = TRIM(rs("codFormaNomeacao"))
			
				intCodRegencia		  = TRIM(rs("Cod_Regencia"))
	
				strSenha 			= ""
				if strUsuarioPortal <> "" then
					sql = " SELECT Usua_Info_senha,Usua_Stat, USUA_CODG "
					sql = sql & " FROM SEG_USUARIOS_SISTEMA"
					sql = sql & " WHERE USUA_CODG = '" &  strUsuarioPortal & "'"
					rsAux.open sql, cnn
					if not rsAux.eof then
						strBloqUsu = " readonly "
						strUsuarioPortal			= Trim(rsAux("USUA_CODG"))
						strStatus 					= Trim(rsAux("Usua_Stat"))
						strSenha 					= Trim(rsAux("Usua_Info_senha"))
						' Descriptografica Senha
						'if strSenha <> "" then 
						'	strSenha = FormatCripto(strSenha,false)
						'end if
					end if
					rsAux.close
				end if
													
				strFoneResidencial  = Trim(Rs("FoneResidencial"))
				strFoneComercial    = Trim(Rs("FoneComercial"))
				strFoneCelular      = Trim(Rs("FoneCelular"))
				carteira_reservista	= Trim(Rs("carteira_reservista"))
				stremail  			= Trim(Rs("email"))
				strEmailCoorporativo= Trim(Rs("email_coorporativo"))
				strpai  			= Trim(Rs("pai"))
				strmae  			= Trim(Rs("mae"))
				strdata_nascimento  = formataDataAP(Trim(Rs("Data_Nascimento")))
				strnaturalidade  	= Trim(Rs("naturalidade"))
				strUFNaturalidade 	= Trim(Rs("UFNaturalidade")) 
				strnacionalidade  	= Trim(Rs("nacionalidade"))
				strestado_civil  	= Trim(Rs("estado_civil"))
				strconjuge  		= Trim(Rs("conjuge"))
				strnumero_filhos  	= Trim(Rs("numero_filhos"))
				strrg  				= Trim(Rs("rg"))
				strorgao_expedidor  = Trim(Rs("orgaoExp"))
				strtitulo_eleitor  	= Trim(Rs("titulo_eleitor"))
				strcarteira_trabalho= Trim(Rs("carteira_trabalho"))
				strpis  			= Trim(Rs("pis"))
				strSexo 			= Trim(Rs("Sexo"))
				strSituacao			= Trim(Rs("Situacao"))	
				strDatafastamento	= Trim(Rs("Datafastamento"))
				intCodCategoria		= Trim(Rs("CodCategoria"))	
				intCodGrauInstrucao	= Trim(Rs("CodGrauInstrucao"))
				strCargo			= Trim(Rs("Cargo"))
				strFuncao			= Trim(Rs("Funcao"))
				intCodFuncional		= Trim(Rs("CodFuncional"))
				intCodigoFuncionalAnterior = Trim(Rs("CodFuncional"))
				intCodDepartamento	= Trim(Rs("CodDepartamento"))
				strObs				= Trim(Rs("Obs"))
				strCPF  			= formataCPFap(Trim(Rs("CPF")))
				strLattes			= Trim(Rs("Lattes"))
				strDataLotacao 		= formataDataAP(Rs("DataLotacao"))
		   		intCodNivel 		= rs("Cod_nivel")
				
				'if trim(Request.Form("cmbNivel")) <> trim(rs("Cod_nivel")) then
				
				if isnull(rs("salario_base")) or rs("salario_base") = "" then 
				   strSalarioBase				= "0"
				   strSalarioBase 				= formatNumber(strSalarioBase,2) 
				else   
				   strSalarioBase 				= formatNumber(rs("salario_base"),2) 
				end if   
				strCargaHorariaTotal 		= rs("carga_horario_contratada")
				strTotalAulas		 		= rs("total_aulas")
				strTotalAulasCumprida 		= rs("total_aulas_Cumprida")
				strFatorExtraClasse	 		= rs("Fator_Extra_Classe")
				strPercentualRepousoSemanal	= rs("percentual_repouso_Semanal")
				strPercentualQuinquenio		= rs("percentual_quinquenio")
				strQuantidadeQuinquenio		= rs("quantidade_quinquenio")
				strSimouNao					= rs("modular")
				
				
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
				strCarregado		= "JACARREGOUDOBANCO"
			ELSE
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			END IF
		end if 
		rs.close
		
		strFoto = "Foto"

		sql = "SELECT arquivo "
		sql = sql & " FROM 	SRH_COLABORADOR_FOTO"
		sql = sql & " Where COD_EMPRESA = " & intCodEmp
		sql = sql & " And 	codColaborador = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			strCaminhoFoto = session("strCaminhoRaiz") & "/fotoColaborador/" & session("codEmpresa") & "/" & rs("arquivo")
			strFoto =  "<img src='" & strCaminhoFoto & "' width='120' height='130'>"
			strNomeBotaoFoto	= "Alterar Foto"
		end if
		rs.close	
		
		sql = " SELECT Top 1 DataLotacao "
		sql = sql & " FROM 	SRH_LOTACAOHISTORICO"
		sql = sql & " Where cod_Colaborador = " & intCodigo
		sql = sql & " ORDER BY DataLotacao DESC "
		rsAux.open sql, cnn
		if rsAux.eof = false then
			'strDataLotacao 		= formataDataAP(rsAux("DataLotacao"))
		end if
		rsAux.close	
			
	else
		
		'busca pelo cpf
		bolColaborador		=  false
		sql = "SELECT  * "
		sql = sql & " FROM SRH_COLABORADOR "
		sql = sql & " Where cpf = '" & strCPF & "'"
		sql = sql & " And Cod_empresa = " & intCodEmp
		rs.open sql, cnn
		
		if rs.eof = false then
			IF strCarregado = "" THEN
			bolColaborador		=  true
			strUsuarioPortal	= Trim(Rs("codigo_SEG_USUARIOS_SISTEMA"))
			intCodigo	 		= rs("Codigo")
			strnome 			= Trim(Rs("nome"))
			strdata_admissao  	= formatadataAP(Trim(Rs("data_admissao")))
			
			' Endereco
			strLogradouro 		= TRIM(rs("Logradouro"))
			strNumero_endereco 	= TRIM(rs("numero_logradouro"))
			strComp_endereco 	= TRIM(rs("Comp_endereco"))
			strBairro 		    = TRIM(rs("Bairro"))
			strCidade	        = TRIM(rs("Cidade"))
			strUfresidencia 	= TRIM(rs("UF"))
			strCep 	            = TRIM(rs("Cep"))
			
			intCodFuncao 	   		= TRIM(rs("codFuncao"))
			intCodCargo 	    	= TRIM(rs("codCargo"))
			intCodTurno 	        = TRIM(rs("codTurno"))
			intcodLotacao 	    	= TRIM(rs("codLotacao"))
			intcodLotacaoAnterior 	= TRIM(rs("codLotacao"))
			strDataLotacao			= formataDataAP(TRIM(rs("DataLotacao")))
			intcodRemocao 	    	= TRIM(rs("CodRemocao"))
			strCNH 	           		= TRIM(rs("CNH"))
			strCategoriaCNH 		= TRIM(rs("CategoriaCNH"))
			intCodFormaNomeacao 	= TRIM(rs("codFormaNomeacao"))

			strSenha 			= ""
			if strUsuarioPortal <> "" then
				sql = " SELECT Usua_Info_senha,Usua_Stat "
				sql = sql & " FROM SEG_USUARIOS_SISTEMA"
				sql = sql & " WHERE USUA_CODG = '" &  strUsuarioPortal & "'"
				rsAux.open sql, cnn
				if not rsAux.eof then
					strBloqUsu = " readonly "
					strStatus 					= Trim(rsAux("Usua_Stat"))
					strSenha 					= Trim(rsAux("Usua_Info_senha"))
				end if
				rsAux.close
			end if
												
			strFoneResidencial  = Trim(Rs("FoneResidencial"))
			strFoneComercial    = Trim(Rs("FoneComercial"))
			strFoneCelular      = Trim(Rs("FoneCelular"))
			carteira_reservista	= Trim(Rs("carteira_reservista"))
			stremail  			= Trim(Rs("email"))
			strpai  			= Trim(Rs("pai"))
			strmae  			= Trim(Rs("mae"))
			strdata_nascimento  = formataDataAP(Trim(Rs("Data_Nascimento")))
			strnaturalidade  	= Trim(Rs("naturalidade"))
			strUFNaturalidade 	= Trim(Rs("UFNaturalidade")) 
			strnacionalidade  	= Trim(Rs("nacionalidade"))
			strestado_civil  	= Trim(Rs("estado_civil"))
			strconjuge  		= Trim(Rs("conjuge"))
			strnumero_filhos  	= Trim(Rs("numero_filhos"))
			
			strrg  				= Trim(Rs("rg"))
			strorgao_expedidor  = Trim(Rs("orgaoExp"))
			strtitulo_eleitor  	= Trim(Rs("titulo_eleitor"))
			strcarteira_trabalho= Trim(Rs("carteira_trabalho"))
			strpis  			= Trim(Rs("pis"))
			strSexo 			= Trim(Rs("Sexo"))
			strSituacao			= Trim(Rs("Situacao"))	
			strDatafastamento	= Trim(Rs("Datafastamento"))
			intCodCategoria		= Trim(Rs("CodCategoria"))	
			intCodGrauInstrucao	= Trim(Rs("CodGrauInstrucao"))
			strCargo			= Trim(Rs("Cargo"))
			strFuncao			= Trim(Rs("Funcao"))
     		intCodFuncional		= Trim(Rs("CodFuncional"))
			intCodigoFuncionalAnterior = Trim(Rs("CodFuncional"))
			intCodDepartamento	= Trim(Rs("CodDepartamento"))
			strObs				= Trim(Rs("Obs"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

			strFoto = "Foto"

			sql = "SELECT arquivo "
			sql = sql & " FROM 	SRH_COLABORADOR_FOTO"
			sql = sql & " Where COD_EMPRESA = " & intCodEmp
			sql = sql & " And 	codColaborador = " & intCodigo
			rsAux.open sql, cnn
			if rsAux.eof = false then
				strCaminhoFoto 		= session("strCaminhoRaiz") & "/fotoColaborador/" & session("codEmpresa") & "/" & rsAux("arquivo")
				strFoto 			=  "<img src='" & strCaminhoFoto & "' width='120' height='130'>"
				strNomeBotaoFoto	= "Alterar Foto"
			end if
			rsAux.close	
			
			
			sql = " SELECT Top 1 DataLotacao "
			sql = sql & " FROM 	SRH_LOTACAOHISTORICO"
			sql = sql & " Where cod_Colaborador = " & intCodigo
			sql = sql & " ORDER BY DataLotacao DESC "
			rsAux.open sql, cnn
			if rsAux.eof = false then
				'strDataLotacao 		= formataDataAP(rsAux("DataLotacao"))
			end if
			rsAux.close	
		
				strCarregado		= "JACARREGOUDOBANCO"

			END IF

		else
		
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			strFoto = "Foto"
			
		end if 
		rs.close
		
		if bolColaborador =  false then
			'busca em todas empresas do grupo
			if strCPF <> "" and Trim(Request.Form("LocalizarMatricula")) <> "S"  then
				sql = "SELECT  codigo "
				sql = sql & " FROM SRH_COLABORADOR "
				sql = sql & " Where cpf = '" & strCPF & "'"
				sql = sql & " And Cod_empresa in (" & Session("CodTodasEmpresaGrupo") & ")"
				rs.open sql, cnn
				if rs.eof = false then
					cd_func = rs("codigo")
					
					'importa colaborador
					if trim(Session("NivelPermissao")) <> "A" then
						%>
						<script>
							alert("Existe dados para o CPF informado em outra unidade, caso deseje importar esse cadastro, favor entrar em contato com o Gestor do Sistema.")
						</script>
						<%
					elseif trim(Session("NivelPermissao")) = "A" then
						%>
                        <form method="post" id="frm1" name="frm1">	
						<script>
							if(confirm("Existe dados com esse mesmo CPF em outra unidade. Deseja importar cadastro?")) {
								frm1.action= "Colaborador_cod.asp?acao=P&cd_func=<%=cd_func%>";
								frm1.submit();
							}
						</script>
                        </form>	
						<%
					end if
		
				end if 
				rs.close	
			end if	
		end if
				
	end if 
	
	if trim(strCPF) <> "" then
		bolUsuarioMaster = "N"
		sql = " SELECT USUA_CODG, Usua_Info_senha,Usua_Stat "
		sql = sql & " FROM SEG_USUARIOS_SISTEMA"
		sql = sql & " WHERE USUA_CPF = '" &  strCPF & "'"
		sql = sql & " AND USUARIO_MASTER = 'S'"
		rsAux.open sql, cnn
		if not rsAux.eof then
			bolUsuarioMaster = "S"
			strUsuarioPortal = ""
			strStatus  		 = ""
			strSenha 		 = ""
			if Session("NivelPermissao") = "A" then
    		   bolUsuarioMaster = "S"
  		    end if   
		end if
		rsAux.close
		
		if bolUsuarioMaster = "N" then
			sql = " SELECT USUA_CODG, Usua_Info_senha,Usua_Stat "
			sql = sql & " FROM SEG_USUARIOS_SISTEMA"
			sql = sql & " WHERE USUA_CPF = '" &  strCPF & "'"
			'sql = sql & " and COD_EMPRESA = " & intCodEmp
			rsAux.open sql, cnn
			if not rsAux.eof then
				strBloqUsu = " readonly "
				strUsuarioPortal			= Trim(rsAux("USUA_CODG"))
				strStatus 					= Trim(rsAux("Usua_Stat"))
				strSenha 					= Trim(rsAux("Usua_Info_senha"))
			end if
			rsAux.close
		end if
	end if
	
	if intCodNivel <> "0" then
	
    	sql = "SELECT Codigo, Cod_grupo, Salario_Base, total_aulas, "
		sql = sql & " carga_horario_contratada, carga_horario_Cumprida, FatorExtraClasse, PercentualRepousoSemanal"
		sql = sql & " FROM SRH_NIVEL"
		sql = sql & " Where Codigo = " & intCodNivel
		rsAux.open sql, cnn
		if not rsAux.eof then
			
		     if isnull(rsAux("Salario_Base")) or rsAux("Salario_Base") = "" then
				 strSalarioBase = ""
			 else
			    strSalarioBase 				= formatNumber(rsAux("Salario_Base"),2) 
			 end if	
			 
		    strCargaHorariaTotal			= rsAux("carga_horario_contratada")
		    strTotalAulas					= rsAux("total_aulas")
			strFatorExtraClasse	 			= rsAux("FatorExtraClasse")
			strPercentualRepousoSemanal		= rsAux("PercentualRepousoSemanal")

		end if	
		rsAux.close
	end if 
	thenstrDesabilitaBotaoPatrimonioColaborador = " " 
	if trim(intCodigo) = "" then strDesabilitaBotaoPatrimonioColaborador = " Disabled "
	
	if request("Prov")="S" and intCodFuncional = "" then
		sql = "select isnull(max(codFuncional),0)+1 as proximo"
		sql = sql & " from srh_colaborador"
		sql = sql & " where len(codFuncional) = 7"
		sql = sql & " and left(codFuncional,2) = 99"
		rs.open sql, cnn
		if not rs.eof then
			intCodFuncional = rs("proximo")
			if len(intCodFuncional) < 7 then
				mascara 		= "99"
				intCodFuncional = mascara & string(5-len(rs("proximo")),"0") & intCodFuncional
			end if
		end if
		rs.close

	end if
	if intCodFuncional <> "" then
		strDesabilitaGerarMatriculaProvisoria = "disabled"
	end if
	
	if strnacionalidade = "" then strnacionalidade = "Brasileira"
	
	%>
    
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Colaborador</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form --> 
             	<form method="post" id="frm">	
                <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >
				<!--#include file="../includes/inc_ListaHistoricoLotacao.asp" -->
                <!--#include file="../includes/inc_ListaOcorrenciasColaborador.asp" -->
                 
            	<div class="panel-body">                                                        
                      	<!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                      	Informe corretamente os campos obrigat&oacute;rios ( * )   
                      
						<%if trim(session("voltarPaginaParaColaboradorModulacao"))<>"" then%>
                        <br />
                        <input type="button" name="cmdPrincipal"  value="   Voltar para Modulação  "  class="btn btn-u btn-u-brown float-shadow" onclick="window.location='<%=session("voltarPaginaParaColaboradorModulacao")%>'">
                        <br /><br />
                        <%end if%>   

                     <div class="form-group">
                     
                        <table class="table table-bordered">
                            
                            	<!-- Dados Pessoais -->
                                <thead>
                                <tr>
                                    <td width="33"><a href="javascript:showTr(1)">[+]</a></td>
                                    <td width="997">Dados do Colaborador</td>
                                </tr>
                                </thead>
                                <tr id="tr1">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Conteudo -->
                                    
                                    <table class="table table-bordered">
                                                <tr>
                                                  <td>CPF:</td>
                                                  <td width="27%"><input name="txtcpf" type="text" class="form-control" id="txtcpf" size="15" maxlength="70" value="<%=strCPF%>" onkeypress="return formataCampo(this,5,14)" onblur="return validaCPFColaborador(this)">&nbsp;<strong>*</strong><%if session("CodGrupo") = "7" then%><input name="btnProvisorio" type="button"  class="btn-u float-shadow" id="btnProvisorio" style="cursor:hand" onclick="gerarMatriculaProvisoria()"   value="Matr&iacute;cula Provis&oacute;ria" <%=strDesabilitaGerarMatriculaProvisoria%> /><%end if%></td>
                                                  <td width="15%">Matrícula Funcional:</td>
                                                  <td width="26%">
                                                  <input name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">&nbsp;<strong>*</strong><input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>Localizar?                                                  
                                                  <input name="txtCodigoFuncionalAnterior" type="hidden" class="text" id="txtCodigoFuncionalAnterior" size="2" maxlength="8" value="<%=intCodigoFuncionalAnterior%>"  onKeyPress="return formataCampo(this, 2, 8)">
                                                  </td>
                                                  <td width="21%" rowspan="4" align="center"><table width="80%" class="table table-bordered">
                                                    <tr>
                                                      <td align="center"><table width="120" height="130" border="1" cellpadding="0" cellspacing="0">
                                                          <tr>
                                                            <td bgcolor="#FFFFFF" align="center" class="text"><%=strFoto%></td>
                                                          </tr>
                                                      </table></td>
                                                    </tr>
                                                    <tr>
                                                      <td align="center"><input type="button" name="cmdIncluir2" style="cursor:hand"   value="<%=strNomeBotaoFoto%>" class="btn btn-success" <%=strDesabilitaAlterar%> onclick="foto('<%=intCodAluno%>')" /></td>
                                                    </tr>
                                                  </table></td>
                                                </tr>
                                              <tr>
                                                <td width="11%">Nome:</td>
                                                <td colspan="3">
                                                <input name="txtCodFuncionario" value="<%=intCodigo%>" type="hidden" id="txtCodFuncionario" >
                                                <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                                                <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                                                <input name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">&nbsp;<strong>*</strong>
                                                <button class="btn btn-success" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=colaborador_cad')" type="button"><i class="fa fa-search"></i></button>                                                </td>
                                              </tr>
                                              <tr>
                                                <td>Data Nasc.:</td>
                                                <td colspan="3"><input name="txtdata_nascimento" type="text" class="form-control" id="txtdata_nascimento" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strdata_nascimento%>">&nbsp;<strong>*</strong></td>
                                       	      </tr>
                                              <tr>
                                                <td>Sexo:</td>
                                                <td>
                                                <select name="cboSexo" class="form-control" id="cboSexo">
                                                    <option value="0">Selecione...</option>
                                                    <option value="M" <%if strSexo = "M" then response.Write("selected") %>>Masculino</option>
                                                    <option value="F" <%if strSexo = "F" then response.Write("selected") %>>Feminino</option>
                                                </select>                                      			</td>
                                          	    <td>Estado Civil:</td>
                                          	    <td>
                                                <select name="txtestado_civil" class="form-control" id="txtestado_civil">
                                                  <option value="0">Selecione...</option>
                                                  <option value="S" <%if strestado_civil = "S" then response.Write("selected") %>>Solteiro</option>
                                                  <option value="C" <%if strestado_civil = "C" then response.Write("selected") %>>Casado</option>
                                                  <option value="V" <%if strestado_civil = "V" then response.Write("selected") %>>Vi&uacute;vo</option>
                                                  <option value="D" <%if strestado_civil = "D" then response.Write("selected") %>>Desquitado</option>
                                                  <option value="I" <%if strestado_civil = "I" then response.Write("selected") %>>Divorciado</option>
                                                  <option value="U" <%if strestado_civil = "U" then response.Write("selected") %>>União Estável</option>
                                                  <option value="O" <%if strestado_civil = "O" then response.Write("selected") %>>Outros</option>
                                              </select>&nbsp;<strong>*</strong>                                                </td>
                                              </tr>
                                              <tr>
                                                <td>Fone (Res):</td>
                                                <td><input name="txtFoneResidencial" type="text" class="form-control" id="txtFoneResidencial" onkeypress="mascara(this,telefone)" value="<%=strFoneResidencial%>" size="20" maxlength="14"></td>
                                          	    <td>Celular:</td>
                                          	    <td colspan="2"><input name="txtFoneCelular" type="text" class="form-control" id="txtFoneCelular" onkeypress="mascara(this,telefone)" value="<%=strFoneCelular%>" size="20" maxlength="14">&nbsp;<strong>*</strong></td>
                                              </tr>
                                              <tr>
                                                <td>Fone (Com):</td>
                                                <td><input name="txtFoneComercial" type="text" class="form-control" id="txtFoneComercial" onkeypress="mascara(this,telefone)" value="<%=strFoneComercial%>" size="20" maxlength="14"></td>
                                                <td>Dt. Admiss&atilde;o</td>
                                                <td colspan="2"><input name="txtdata_admissao" type="text" class="form-control" id="txtdata_admissao" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strdata_admissao%>">&nbsp;<strong>*</strong></td>
                                          </tr>
                                              <tr>
                                                <td>Naturalidade:</td>
                                                <td><input name="txtnaturalidade" type="text" class="form-control" id="txtnaturalidade" size="15" maxlength="50" value="<%=strnaturalidade%>">&nbsp;*UF:
                                                  <!--#include file="../includes/inc_cmdUFNaturalidade.asp" -->
                                                &nbsp;*</strong></td>
                                                <td>Nacionalidade:</td>
                                                <td colspan="2"><input name="txtnacionalidade" type="text" class="form-control" id="txtnacionalidade" size="15" maxlength="50" value="<%=strnacionalidade%>">*</td>
                                          </tr>
                                              <tr>
                                                <td>E-mail:</td>
                                                <td><input name="txtemail" type="text" class="form-control" id="txtemail" size="40" maxlength="70" value="<%=stremail%>" /></td>
                                                <td>Email Coorporativo:</td>
                                                <td colspan="2"><input name="txtEmailCoorporativo" type="text" class="form-control" id="txtEmailCoorporativo" size="40" maxlength="70" value="<%=strEmailCoorporativo%>" /></td>
                                              </tr>
                                              <tr>
                                                <td>Turno:&nbsp;</td>
                                                <td><!--#include file="../includes/inc_cmbTurno.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                                <td>Reg&ecirc;ncia</td>
                                                <td colspan="2"><!--#include file="../includes/inc_cmbRegencia.asp" --></td>
                                              </tr>
                                              <tr>
                                                <td>Cargo</td>
                                                <td>
                                                  <input name="txtCargoAtual" type="hidden" value="<%=intCodCargo%>" />
                                                  <input name="txtFuncaoAtual" type="hidden" value="<%=intCodFuncao%>" />
                                                  <input name="txtSituacaoAtual" type="hidden" value="<%=strSituacao%>" />
                                                  <input name="txtNivelAtual" type="hidden" value="<%=intCodNivel%>" />
                                                  <!--#include file="../includes/inc_cmbCargo.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                                <td>Fun&ccedil;&atilde;o:</td>
                                                <td colspan="2">
                                                  <!--#include file="../includes/inc_cmbFuncao.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFD2"><strong>Categoria:</strong></td>
                                                <td bgcolor="#FFFFD2">
                                                  <%if Session("NivelPermissao") = "A" then%>
                                                  <!--#include file="../includes/inc_cmdCategoriaNivelPermissao.asp" -->
                                                  <%else%>
                                                  <!--#include file="../includes/inc_cmdCategoria.asp" -->
                                                  <%end if%>
                                                &nbsp;<strong>*</strong></td>
                                                <td>Situa&ccedil;&atilde;o:</td>
                                                <td colspan="2">
                                                  <!--#include file="../includes/inc_cmdSituacao.asp" -->
                                                &nbsp;</td>
                                              </tr>
                                              <tr>
                                                <td>Grau Instru&ccedil;&atilde;o:</td>
                                                <td>
                                                  <!--#include file="../includes/inc_cmdGrauInstrucaoColaborador.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                                <td>Data Afastamento:</td>
                                                <td colspan="2">
                                                  <input name="txtDatafastamento" type="text" class="form-control" id="txtDatafastamento" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatafastamento%>" title="Click aqui para visualizar o calend&aacute;rio" />                                                </td>
                                              </tr>
                                              <tr>
                                                <td>Departamento:</td>
                                                <td>
                                                  <!--#include file="../includes/inc_cmdDepartamento.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                                <td>Lota&ccedil;&atilde;o:</td>
                                                <td colspan="2">
                                                  <!--#include file="../includes/inc_cmbLotacao.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                              </tr>
                                              <tr>
                                                <td>Data Lota&ccedil;&atilde;o:</td>
                                                <td>
                                                  <input name="txtDataLotacao" type="text" class="form-control" id="txtDataLotacao" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLotacao%>" title="Click aqui para visualizar o calend&aacute;rio" />
                                                &nbsp;<strong>*</strong></td>
                                                <td>Nomea&ccedil;&atilde;o:</td>
                                                <td colspan="2">
                                                  <!--#include file="../includes/inc_cmbFormaNomeacao.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                              </tr>
                                                          
                                              <tr> 
                                                
                                                <td>Obs:</td>
                                                <td colspan="4">
                                                  <textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtObs" cols="70" rows="4" class="text" id="txtObs"><%=strObs%></textarea>
                                                  <br /><font color="#FF0000">(caracteres restantes: <span id="cont">300</span>)</font></span></td>
                                          </tr>
                                              <tr>
                                                <td>&nbsp;</td>
                                                <td colspan="4">&nbsp;</td>
                                          </tr>
                                            </table>
                                    <!-- Fim Conteudo -->
                                    
                                    </td>
                                </tr>
                                <!-- Fim Dados Escolares -->
                                
                                <!-- Dados Escolares -->
                                <thead>
                                <tr>
                                    <td width="33"><a href="javascript:showTr(2)">[+]</a></td>
                                    <td width="997">Dados Endere&ccedil;o</td>
                                </tr>
                                </thead>
                                <tr id="tr2">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Conteudo -->
                                    <table class="table table-bordered">
                                      <tr>
                                        <td width="11%">Logradouro: </td>
                                        <td>
                                          <input name="txtLogradouro" type="text" class="form-control" id="txtLogradouro" size="40" maxlength="60" value="<%=strLogradouro%>" />
                                        </td>
                                        <td>N&uacute;mero:</td>
                                        <td colspan="3">
                                          <input name="txtNumero_endereco" type="text" class="form-control" id="txtNumero_endereco" size="20" maxlength="5" value="<%=strNumero_endereco%>" />
                                        </td>
                                      </tr>
                                      <tr>
                                        <td >Complemento:</td>
                                        <td width="27%">
                                        <input name="txtComp_endereco" type="text" class="form-control" id="txtComp_endereco" size="40" maxlength="20" value="<%=strComp_endereco%>" />
                                        </td>
                                        <td width="15%">CEP:</td>
                                  <td colspan="3">
                            <input name="txtCep" type="text" class="form-control" id="txtCep" size="20" maxlength="8" value="<%=strCep%>" onkeypress="return formataCampo(this, 2, 8)" />
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>Bairro:</td>
                                        <td>
                                          <input name="txtBairro" type="text" class="form-control" id="txtBairro" size="40" maxlength="40" value="<%=strBairro%>" onkeypress="return formataCampo(this, 1, 40)" />
                                        </td>
                                        <td>Cidade:</td>
                                        <td width="23%">
                                          <input name="txtCidade" type="text" class="form-control" id="txtCidade" size="40" maxlength="40" value="<%=strCidade%>" onkeypress="return formataCampo(this, 1, 40)" />
                                        </td>
                                        <td width="5%">UF:</td>
                                        <td width="19%">
                                          <!--#include file="../includes/inc_cmdUFResidencia.asp" -->
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>Lattes:</td>
                                        <td colspan="5">
                                          <input name="txtLattes" type="text" class="form-control" id="txtLattes" size="100" maxlength="100" value="<%=strLattes%>" />
                                        </td>
                                      </tr>
                                    </table>
                                    <!-- Fim Conteudo -->
                                    </td>
                                </tr>
                                <!-- Fim Dados Escolares -->
                                
                                <!-- Endereço -->
                                <thead>
                                <tr>
                                    <td width="33"><a href="javascript:showTr(3)">[+]</a></td>
                                    <td width="997">Dados Filia&ccedil;&atilde;o</td>
                                </tr>
                                </thead>
                                <tr id="tr3">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Conteudo -->
                                    <table class="table table-bordered">
                                          <tr>
                                            <td width="10%">Pai:</td>
                                            <td width="90%">
                                              <input name="txtpai" type="text" class="form-control" id="txtpai" size="40" maxlength="50" value="<%=strpai%>" />
                                            </td>
                                          </tr>
                                          <tr>
                                            <td>M&atilde;e:</td>
                                            <td>
                                              <input name="txtmae" type="text" class="form-control" id="txtmae" size="40" maxlength="50" value="<%=strmae%>" />
                                            </td>
                                          </tr>
                                        </table>
                                    <!-- Fim Conteudo --></td>
                                </tr>
                                <!-- Fim Endereço -->
                                
                                <!-- Dados Familiares -->
                                <thead>
                                <tr>
                                    <td width="33"><a href="javascript:showTr(4)">[+]</a></td>
                                    <td width="997">Dados Familiar</td>
                                </tr>
                                </thead>
                                <tr id="tr4">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Conteudo -->
                                    
                                    <table class="table table-bordered">
                                          <tr>
                                            <td width="10%">C&ocirc;njuge:</td>
                                            <td width="90%">
                                              <input name="txtconjuge" type="text" class="form-control" id="txtconjuge" size="50" maxlength="70" value="<%=strconjuge%>" />
                                            </td>
                                          </tr>
                                        </table>
                                        
                                    <!-- Fim Conteudo --></td>
                                </tr>
                                <!-- Fim Dados Familiares -->
                                
                                <!-- Dados Responsável -->
                                <thead>
                                <tr>
                                    <td width="33"><a href="javascript:showTr(5)">[+]</a></td>
                                    <td width="997">Patrim&ocirc;nio</td>
                                </tr>
                                </thead>
                                <tr id="tr5">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Conteudo -->
                                              <table class="table table-bordered">
                                          		<tr>
                                            	<td width="15%" height="57"><input name="cmdPatrimonioColaborador" type="button"  class="btn btn-u float-shadow" id="cmdPatrimonioColaborador" style="cursor:hand" onclick="PatrimonioColaborador()"   value="Registrar Patrim&ocirc;nio" <%=strDesabilitaBotaoPatrimonioColaborador%>/></td>
                                            	<td width="85%">
                                                <% if trim(intCodigo) <> "" then
                                      
												sql = "SELECT Codigo, Cod_Colaborador, Cod_Patrimonial, Descricao_Patrimonio, Data_Recebimento, Data_Devolucao, obs"
												sql = sql & " FROM SRH_PATRIMONIO_COLABORADOR"
												sql = sql & " where Cod_Colaborador = " & intCodigo	
												rs.open sql, cnn
												if rs.eof = false then
													%>
                                        			<table>
                                                    <tr bgcolor="#E5E5E5" class="celula">
                                                      <td class="celula">C&oacute;digo Patrimonial</td>
                                                      <td class="celula">Descric&atilde;o</td>
                                                      <td width="146" height="21" class="celula">Data do Recebimento</td>
                                                      <td width="97" class="celula">Devolu&ccedil;&atilde;o</td>
                                                      <td width="78" class="celula">Situa&ccedil;&atilde;o</td>
                                                    </tr>
                                                    <%
													while not rs.eof
													   cont = cont + 1	
													   if isnull(rs("Data_Devolucao")) or rs("Data_Devolucao") = "" then
															msgStatus = "NA GUARDA"
													   else
															msgStatus = "DEVOLVIDO"
													   end if
													   %>
														<tr bgcolor="#FFFFFF" class="celula"  style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"  onClick="return resultadoConsulta('<%=rs("codigo")%>')">
														<td width="156" class="celula9">&nbsp;<%=trim(rs("Cod_Patrimonial"))%>&nbsp;</td>
														<td width="283" class="celula9">&nbsp;<%=trim(rs("Descricao_Patrimonio"))%>&nbsp;</td>
														<td height="26" class="celula9">&nbsp;<%=trim(rs("Data_Recebimento"))%>&nbsp;</td>
														<td height="26" class="celula9"><%=trim(rs("Data_Devolucao"))%>&nbsp;</td>
														<td height="26" class="celula9"><%=trim(msgStatus)%>&nbsp;</td>
														</tr>
														<%
													   rs.movenext
													wend
												%>
                                                	</table>
                                         		<%
                                            end if
                                            rs.close
											end if
                                         %>
                                         
                                                
                                                </td>
                                                </tr>
                                           	   </table>
                                       
                                                </td>
                                            </tr>	
                                  
                                    
                                    <!-- Fim Conteudo -->
                                    
                                    </td>
                                </tr>
                                <!-- Fim Dados Responsável -->
                                
                                <!-- Documentação -->
                                <%if Session("NivelPermissao") = "A" then%>
                                <thead>
                                <tr>
                                    <td width="33"><a href="javascript:showTr(6)">[+]</a></td>
                                    <td width="997">Cargas Horárias/Salários</td>
                                </tr>
                                </thead>
                                <%end if%>
                                <tr id="tr6">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Conteudo -->
                                    
                                    <table class="table table-bordered">
									  <% if strNivelEnsinoSigla <> "EB" then%>
                                                  <tr>
                                                    <td width="23%">N&iacute;vel :</td>
                                                    <td width="30%">
                                                      <!--#include file="../includes/inc_cmbNivel.asp" -->
                                                    </td>
                                                    <td width="21%">Modular?(S/N</td>
                                                    <td width="26%">
                                                      <!--#include file="../includes/inc_cmbSimouNao.asp"-->
                                                    </td>
                                      </tr>
                                                  
                                                  <tr>
                                                    <td>Sal&aacute;rio Base:</td>
                                                    <td>**N&atilde;o Dispon&iacute;vel**
                                                        <input readonly="readonly" name="txtSalarioBase" type="hidden" class="form-control" id="txtSalarioBase" onkeypress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=strSalarioBase%>" />
                                                    </td>
                                                    <td>Horas Semanais Contratada></td>
                                                    <td>
                                                      <input readonly="readonly" name="txtCargaHorariaTotal" type="text" class="form-control" id="txtCargaHorariaTotal" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strCargaHorariaTotal%>" />
hs</td>
                                      </tr>
                                                  <tr>
                                                    <td>Repouso Semanal Remunerado:</td>
                                                    <td>
                                                      <input readonly="readonly" name="txtPercentualRepousoSemanal" type="text" class="form-control" id="txtPercentualRepousoSemanal" onkeypress="return currencyFormat(this,event)"  size="5" maxlength="5" value="<%=strPercentualRepousoSemanal%>" />
% </td>
                                                    <td>Aulas Semanais Contratada:</td>
                                                    <td>
                                                      <input readonly="readonly" name="txtTotalAulas" type="text" class="form-control" id="txtTotalAulas" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strTotalAulas%>" />
                                                    </td>
                                                  </tr>
                                                  <tr>
                                                    <td>C&aacute;lculo Extra Classe:</td>
                                                    <td>
                                                      <input readonly="readonly" name="txtFatorExtraClasse" type="text" class="form-control" id="txtFatorExtraClasse" onkeypress="return currencyFormat(this,event)"  size="5" maxlength="5" value="<%=strFatorExtraClasse%>" />
                                                    </td>
                                                    <td>Aulas Cumprida:</td>
                                                    <td>
                                                      <input name="txtTotalAulasCumprida" type="text" class="form-control" id="txtTotalAulasCumprida" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strTotalAulasCumprida%>" />
                                                    </td>
                                                  </tr>
                                                  <tr>
                                                    <td>Percentual do Quinqu&ecirc;nio:</td>
                                                    <td>
                                                      <input name="txtPercentualQuinquenio" type="text" class="form-control" id="txtPercentualQuinquenio" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strPercentualQuinquenio%>" />
%</td>
                                                    <td>Total de  Quinqu&ecirc;nio:</td>
                                                    <td>
                                                      <input name="txtQuantidadeQuinquenio" type="text" class="form-control" id="txtQuantidadeQuinquenio" size="5" maxlength="5" value="<%=strQuantidadeQuinquenio%>" />
                                                    </td>
                                                  </tr>
                                                  <tr>
                                                    <td colspan="4" align="center">
                                                    <%if intCodigo <> "" then%>
                                              <table class="table table-bordered">
                                                  <tr>
                                                    <td width="64%" bgcolor="#CCCCCC" class="celula"><strong>Unidade</strong></td>
                                                    <td width="36%" bgcolor="#CCCCCC" class="celula"><strong>Distribuição de Aulas pelo Hor&aacute;rio</strong></td>
                                                  </tr>
                                                    <%
                                                    sql = " select upper(_e.RAZAOSOCIAL) as empresa, count(_a.codigo) as lancamento"
                                                    sql = sql & " from SCA_HORARIO_AULA _a"
                                                    sql = sql & " inner join seg_empresa _e on _e.codigo = _a.cod_empresa"
                                                    sql = sql & " where _a.cod_Colaborador = " & intCodigo
                                                    sql = sql & " and _a.anoLetivo = " & strAnoLetivo
                                                    sql = sql & " and _a.semestre = " & strSemestre
                                                    sql = sql & " group by  _e.RAZAOSOCIAL"
                                                    rsAux.open sql, cnn
                                                    if not rsAux.eof then
                                                        while not rsAux.eof
                                                            %>
                                                              <tr>
                                                                <td class="celula"><%=rsAux("empresa")%></td>
                                                                <td class="celula"><%=rsAux("lancamento")%></td>
                                                              </tr>
                                                            <%
                                                            rsAux.movenext
                                                        wend
                                                    end if
                                                    rsAux.close
                                                    %>
                                                </table>
                                            <%end if%>
                                          
                                                    </td>
                                                  </tr>
                                       <% end if %>
                                                </table>
                                    <!-- Fim Conteudo -->
                                    
                                    </td>
                                </tr>
                                <!-- Fim Documentação -->
                                
                                
                                 <!-- Dados da Documentos -->
                                <thead>
                                <tr>
                                    <td width="33"><a href="javascript:showTr(7)">[+]</a></td>
                                    <td width="997">Documentos</td>
                                </tr>
                                </thead>
                                <tr id="tr7">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Documentos -->
                                    <table class="table table-bordered">
                                        <tr>
                                        <td width="10%">Titulo:</td>
                                        <td width="29%">
                                          <input name="txttitulo_eleitor" type="text" class="form-control" id="txttitulo_eleitor" size="15" maxlength="20" value="<%=strtitulo_eleitor%>" />
                                        </td>
                                        <td width="14%">Cart. Reservista: </td>
                                        <td width="47%">
                                          <input name="carteira_reservista" type="text" class="form-control" id="carteira_reservista" size="12" maxlength="20" value="<%=carteira_reservista%>" />
                                       </td>
                                        </tr>
                                        <tr>
                                          <td>Identidade:</td>
                                          <td>
                                            <input name="txtrg" type="text" class="form-control" id="txtrg" size="15" maxlength="20" value="<%=strrg%>" />
                                          </td>
                                          <td>Org&atilde;o Exp.:</td>
                                          <td>
                                            <input name="txtorgao_expedidor" type="text" class="form-control" id="txtorgao_expedidor" size="15" maxlength="15" value="<%=strorgao_expedidor%>" />
                                          </td>
                                        </tr>
                                        <tr>
                                          <td>CNH:</td>
                                          <td>
                                            <input name="txtCNH" type="text" class="form-control" id="txtCNH" size="20" maxlength="20" value="<%=strCNH%>" />
                                         </td>
                                          <td>Categoria CNH:</td>
                                          <td>
                                            <input name="txtCategoriaCNH" type="text" class="form-control" id="txtCategoriaCNH" size="5" maxlength="5" value="<%=strCategoriaCNH%>" />
                                          </td>
                                        </tr>
                                        <tr>
                                          <td>PIS</td>
                                          <td>
                                            <input name="txtpis" type="text" class="form-control" id="txtpis" size="15" maxlength="20" value="<%=strpis%>" />
                                          </td>
                                          <td>Cart. Trabalho</td>
                                          <td>
                                            <input name="txtcarteira_trabalho" type="text" class="form-control" id="txtcarteira_trabalho" size="15" maxlength="20" value="<%=strcarteira_trabalho%>" />
                                          </td>
                                        </tr>
                                        </table>
                                    <!-- Fim Documentos -->
                                    </td>
                                </tr>
                                <!-- Fim Dados da Documentos -->
                                 <!-- Dados da Acesso ao Sistema -->
                                 <%if Session("NivelPermissao") = "A" then%>
                                <thead>
                                    <tr>
                                        <td width="33"><a href="javascript:showTr(8)">[+]</a></td>
                                        <td width="997">Acesso ao Sistema</td>
                                    </tr>
                                </thead>
                                <%end if%>
                                <tr id="tr8">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Acesso ao Sistema -->
                                    
                                    <table class="table table-bordered">
                                    <%if Session("NivelPermissao") = "A" then%>
                                        <tr id="L1">
                                        <td width="10%">Login</span></td>
                                        <td width="29%"><input <%=strBloqUsu%> name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30" /></td>
                                        <td>Exemplo de cria&ccedil;&atilde;o do login: 
                                        MARIA.SILVA (primeiro nome e o &uacute;ltimo sobrenome)</td>
                                        </tr>
                                        <tr id="L2">
                                        <td>Senha</td>
                                        <td colspan="2">
                                        <input name="txtSenha" type="password" class="form-control" id="txtSenha" value="<%=strSenha%>" size="15" maxlength="15" />
                                        </td>
                                        </tr>
                                        <tr id="L3">
                                        <td>Conf. Senha</td>
                                        <td colspan="2">
                                        <input name="txtSenhaC" type="password" class="form-control" id="txtSenhaC" value="<%=strSenha%>" size="15" maxlength="15" />
                                        </td>
                                        </tr>
                                         <tr id="L5_funcionarios">
                                            <td><strong>Perfil</strong></td>
                                            <td colspan="2">
                                            <%
											intCodGrupo = 0
                                            sql = "select SEG_EMPRESA.COD_GRUPO, SEG_GRUPO.DESCRICAO AS GRUPO"
                                            sql = sql & " FROM SEG_USUARIOS_EMPRESA"
                                            sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
                                            sql = sql & " INNER JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
                                            sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & session("UsuarioWeb") & "' "
                                            sql = sql & " AND SEG_USUARIOS_EMPRESA.COD_EMPRESA = " & intCodEmp
                                            RsAux.Open SQL, cnn,3 ,1
                                            if not RsAux.EOF then
                                            	intCodGrupo = rsAux("cod_grupo")
                                            end if
                                            RsAux.close
                                            %>
                                            <!--#include file="../includes/inc_cmdPerfilGrupo.asp" -->
                                            </td>
                                           
                                         </tr>
                                        <tr id="L5_professores">
                                        
                                        	<td>Perfil</td>
                                        	<td colspan="2"><!--#include file="../includes/inc_cmdPerfilGrupoProfessores.asp" --></td>
                                       
                                         </tr>
                                        <tr id="L6">
                                        <td>Situa&ccedil;&atilde;o</td>
                                        <td colspan="2">
                                        <input name="optStatus" type="radio" value="A" <%if strStatus ="A" then response.Write("checked")%> />
                                        Ativo 
                                        &nbsp;&nbsp;
                                        <input type="radio" name="optStatus" value="I"  <%if strStatus ="I" then response.Write("checked")%> />
                                        Inativo 
                                        &nbsp;&nbsp;
                                        <input type="radio" name="optStatus" value="B"  <%if strStatus ="B" then response.Write("checked")%> />
                                        Bloqueado </td>
                                        </tr>
                                    </table>
                                    <%end if%>

                                    
                                 
                                    <!-- Fim Conteudo -->   
                                    </td>
                                </tr>
                                <!-- Fim Dados Acesso ao Sistema  -->
                        
                            </table>
    
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                
            	</div>
                
                <%
				'response.write intCodigo
				if intCodigo <> "" then 
					strExisteModulacao = "N"
					sql = " select codigo"
					sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
					sql = sql & " where cod_colaborador = " & intCodigo
					sql = sql & " and 	status = 'A'"
					rsAux.open sql, cnn
					if not rsAux.eof then
						strExisteModulacao = "S"
					end if
					rsAux.close
				  %>
				  <input type="hidden" name="txtExisteModulacao" id="txtExisteModulacao" value="<%=strExisteModulacao%>">
                  
                  <%
					'ATUALIZA PONTO - FAIXA 
					if session("codGrupo") = "7" then
					
						sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & session("strAnoLetivo") & "," & session("CodGrupo") & "," & intCodigo
						cnn.execute sql
						
						'ATUALIZA PONTO - LOTACAO
						sql = "EXECUTE SP_APO_Atualiza_Lotacao_Ponto " & session("strAnoLetivo") & "," & session("CodGrupo") & "," & intCodigo
						'response.write sql
						cnn.execute sql
					end if
				  %>
                  
			  <%end if%>
                </form>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script src="../../js/js_funcoes_gerais.js"></script>
        <%	
	if trim(intCodigo) = "" then %>
		<script>
			tr1.style.display="";
			tr2.style.display="none";
			tr3.style.display="none";
			tr4.style.display="none";
			tr5.style.display="none";
			tr6.style.display="none";
			tr7.style.display="none";
			tr8.style.display="none";
		</script>
	<%else
		%>		
		<script>
			tr1.style.display="";
			tr2.style.display="none";
			tr3.style.display="none";
			tr4.style.display="none";
			tr5.style.display="none";
			tr6.style.display="none";
			tr7.style.display="none";
			tr8.style.display="none";
		</script>
	<%	end if	%>
    
    <script>
			
		function showTr(id){
			var elemento = document.getElementById("tr" + id);
			if(elemento.style.display == ''){
				elemento.style.display = 'none';
			}else{
				elemento.style.display = '';
			}
		}
		
		function abreConsultaColaborador(caminho){
            window.open(caminho,"abreColoborador","top=5,left=5,height=510,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
		
		function blocTexto(valor, id)
        {
            quant = 300;
            total = valor.length;
            if(total <= quant)
            {
                resto = quant - total;
                document.getElementById('cont').innerHTML = resto;
            }
            else
            {
                document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
            }
        }
		
		function validaCPFColaborador(campo) {
            var pcpf=campo.value;
            
            pcpf = pcpf.replace(".","");
            pcpf = pcpf.replace(".","");
            pcpf = pcpf.replace("-","");
            
            if (pcpf != "") {
            
                if (pcpf.length != 11){
                    sim=false;
                }
                else{
                    sim=true;
                }
                
                if ( (pcpf==11111111111) || (pcpf==22222222222) ||
                    (pcpf==33333333333) || (pcpf==44444444444) || (pcpf==55555555555) ||
                    (pcpf==66666666666) || (pcpf==77777777777) || (pcpf==88888888888) ||
                    (pcpf==99999999999) || (pcpf==00000000000) ){
                        sim=false;
                }
                
                if(sim){
                    for (i=0; i<=(pcpf.length-1) && sim; i++){
                        val = pcpf.charAt(i);
                        if((val!="9")&&(val!="0")&&(val!="1")&&(val!="2")&&(val!="3")&&(val!="4")&&( val!="5")&&(val!="6")&&(val!="7")&&(val!="8")){
                            sim=false;
                        }
                    }
                
                    if(sim){
                        soma=0;
                        for (i=0;i<=8;i++){
                            val = eval(pcpf.charAt(i));
                            soma = soma + (val*(i+1));
                        }
                    
                        resto = soma % 11;
                        
                        if (resto>9)
                            dig = resto -10;
                        else
                            dig = resto;
                        
                    
                        if (dig != eval(pcpf.charAt(9))){
                            sim=false
                        }else{
                            soma = 0
                            for (i=0;i<=7;i++){
                                val = eval(pcpf.charAt(i+1))
                                soma = soma +	(val*(i+1))
                            }
                            soma = soma + (dig * 9)
                            resto = soma % 11
                            if (resto>9){
                                dig = resto -10
                            }else{
                                dig = resto
                            }
                    
                            if (dig != eval(pcpf.charAt(10))){
                                sim = false
                            }else{
                                sim = true
                            }
                        }
                    }
                }
                
                if (!sim){
                    alert("CPF inválido!");
                    campo.focus();
                    campo.select();
                }else{
                    if (campo.value!="")
                        frm.submit();				
                        
                }
                        
            }
        }
		
		function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if ((acao=="I") || (acao=="A")){
			if(frm.cmbSituacao.value == "0"){
				alert("A SITUAÇÃO deve ser informada!");
				frm.cmbSituacao.focus();
				return false		
			}		
			if(frm.cmbSituacao.value == "A"){
	
				if(frm.txtcpf.value == ""){
					alert("O CPF deve ser informado!");
					frm.txtcpf.focus();
					return false		
				}
			
				if(frm.txtCodigoFuncional.value == ""){
					alert("A MATRÍCULA Funcional deve ser informada!");
					frm.txtCodigoFuncional.focus();
					return false		
				}
				if(frm.txtNomeFuncionario.value == ""){
					alert("O NOME do Colaborador deve ser informado!");
					frm.txtNomeFuncionario.focus();
					return false		
				}
				if(frm.txtdata_nascimento.value == ""){
					alert("O DATA DE NASCIMENTO deve ser informada!");
					frm.txtdata_nascimento.focus();
					return false		
				}
				
				if(frm.cboSexo.value == "0"){
					alert("O SEXO deve ser informado!");
					frm.cboSexo.focus();
					return false		
				}
		
				if(frm.txtestado_civil.value == "0"){
					alert("O ESTADO CIVIL deve ser informado!");
					frm.txtestado_civil.focus()
					return false		
				}
		
				if(frm.txtFoneCelular.value == ""){
					alert("O CELULAR deve ser informado!");
					frm.txtFoneCelular.focus();
					return false		
				}
				if(frm.txtdata_admissao.value == ""){
					alert("O DATA DE ADMISSÃO deve ser informada!");
					frm.txtdata_admissao.focus();
					return false		
				}
				if(frm.txtnaturalidade.value == ""){
					alert("O NATURALIDADE deve ser informada!");
					frm.txtnaturalidade.focus();
					return false		
				}
				if(frm.cmbUFNaturalidade.value == "0"){
					alert("A UF da NATURALIDADE deve ser informada!");
					frm.cmbUFNaturalidade.focus();
					return false		
				}
				if(frm.txtnacionalidade.value == ""){
					alert("A NACIONALIDADE deve ser informada!");
					frm.txtnacionalidade.focus();
					return false		
				}
				if(frm.cmbTurnoRH.value == "0"){
					alert("O TURNO deve ser informado!");
					frm.cmbTurnoRH.focus();
					return false		
				}
				if(frm.cmbCargo.value == "0"){
					alert("O CARGO deve ser informado!");
					frm.cmbCargo.focus();
					return false		
				}
		
				if(frm.cmbFuncao.value == "0"){
					alert("A FUNÇÃO deve ser informada!");
					frm.cmbFuncao.focus();
					return false		
				}
		
				if(frm.cmbCategoria.value == "0"){
					alert("A CATEGORIA do colaborador deve ser informada!");
					frm.cmbFuncao.focus();
					return false		
				}
		
				if(frm.cmbSituacao.value == "0"){
					alert("A SITUAÇÃO deve ser informada!");
					frm.cmbSituacao.focus();
					return false		
				}
		
				if(frm.cmbGrauInstrucao.value == "0"){
					alert("O GRAU DE INSTRUÇÃO deve ser informado!");
					frm.cmbGrauInstrucao.focus();
					return false		
				}
		
				if(frm.cmbSituacao.value == "A"){
					if(frm.txtDatafastamento.value != ""){
						alert("A Data informada não confere com a Situação de Vínculo do Colaborador!");
						frm.cmbDepartamento.focus();
						return false		
					}
				}
				if(frm.cmbSituacao.value == "I"){
					if(frm.txtDatafastamento.value == ""){
						alert("A DATA DE AFASTAMENTO deve ser informada!");
						frm.cmbDepartamento.focus();
						return false		
					}
				}
		
		
				if(frm.cmbDepartamento.value == "0"){
					alert("O DEPARTAMENTO deve ser informado!");
					frm.cmbDepartamento.focus();
					return false		
				}
		
				if(frm.cmbLotacao.value == "0"){
					alert("A LOTAÇÃO deve ser informada!");
					frm.cmbLotacao.focus();
					return false		
				}
		
				if(frm.txtDataLotacao.value == ""){
					alert("A DATA DE LOTAÇÃO deve ser informada!");
					frm.txtDataLotacao.focus();
					return false		
				}
		
				if(frm.cmbFormaNomeacao.value == "0"){
					alert("A FORMA DE NOMEAÇÃO deve ser informada!");
					frm.cmbFormaNomeacao.focus();
					return false		
				}
		
		
		
				<%if Session("NivelPermissao") = "A" then%>

				if (frm.txtSenha.value != "") {
					if (frm.txtSenha.value.length < 6 ) {
						alert("A senha deve ter pelo menos 6 dígitos!");
						frm.txtSenha.value = "";
						frm.txtSenhaC.value = "";
						frm.txtSenha.focus();
						return false;
					}
					
					if (frm.txtSenha.value != frm.txtSenhaC.value) {
						alert("As senhas não conferem, tente novamente!");
						frm.txtSenha.value = "";
						frm.txtSenhaC.value = "";
						frm.txtSenha.focus();
						return false;
					}
				} 
				<%end if%>
				frm.action= "Colaborador_cod.asp?acao="+acao;
				frm.submit();
				return true;
				
			} else {	
				if(frm.cmbSituacao.value == "I"){
					if(frm.txtDatafastamento.value == ""){
						alert("A DATA DE AFASTAMENTO deve ser informada!");
						frm.cmbDepartamento.focus();
						return false		
					}
					if(frm.txtExisteModulacao.value == "S"){
						var men = 'Existe uma modulação ativa para este funcionário deseja realmente inativa-lo?'
						if (confirm(men)) {
							frm.action= "Colaborador_cod.asp?acao="+acao;
							frm.submit();
						} else {
							return false;
						}						
					}else{
						frm.action= "Colaborador_cod.asp?acao="+acao;
						frm.submit();
					}
				}
			
			}
		}
		
		if (acao=="E"){
			
			var frm = document.getElementById("frm");
			var men = 'ATENÇÃO: Deseja realmente excluir este colaborador'
			if (confirm(men)) {
				frm.action= "Colaborador_cod.asp?acao="+acao;
				frm.submit();
			} else {
				return false;
			}
		
		}
	
	}
	
	function gerarMatriculaProvisoria(){
		var frm = document.getElementById("frm");
		frm.action = "Colaborador_cad.asp?Prov=S"
		frm.submit();
	}
	
	function LimpaMarcacoes(){
		var frm = document.getElementById("frm");
		//limpa todas marcações
		for (var i = 0; i < frm.elements.length; i++) {
				if (frm.elements[i].type == "checkbox" && frm.elements[i].name == "cmbPerfilGrupo"){				
					frm.elements[i].checked = false;				
				}
			}

	}
	function mostraLogin(){
		
		var frm = document.getElementById("frm");
		if (frm.cmbCategoria.value == "1"){//professor
			document.all["L1"].style.display = "table-row";
			document.all["L2"].style.display = "table-row";
			document.all["L3"].style.display = "table-row";
			//document.all["L4"].style.display = "table-row";
			document.all["L5_funcionarios"].style.display = "none";
			document.all["L5_professores"].style.display = "table-row";
			
			document.all["L6"].style.display = "table-row";
		}
		else if (frm.cmbCategoria.value == "2" || frm.cmbCategoria.value == "8" || frm.cmbCategoria.value == "3" ){//funcionario
			document.all["L1"].style.display = "table-row";
			document.all["L2"].style.display = "table-row";
			document.all["L3"].style.display = "table-row";
			//document.all["L4"].style.display = "table-row";
			document.all["L5_funcionarios"].style.display = "table-row";
			document.all["L5_professores"].style.display = "none";
			document.all["L6"].style.display = "table-row";
		}
		else{
			document.all["L1"].style.display = "none";
			document.all["L2"].style.display = "none";
			document.all["L3"].style.display = "none";
			//document.all["L4"].style.display = "none";
			document.all["L5_funcionarios"].style.display = "none";
			document.all["L5_professores"].style.display = "none";
			document.all["L6"].style.display = "none";
		}
	}
    
	mostraLogin("S");
	
   </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 