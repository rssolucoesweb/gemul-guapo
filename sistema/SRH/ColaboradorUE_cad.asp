<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"--> 
<!--include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->

<style>
    .div-amarela {
      width: 250px;
      height: 30px; /* altura opcional, pode ajustar conforme necessário */
      background-color: #FFFFD2;
    }
  </style>

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

	
	'cnn.execute sql
	
	'*************************************
	
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
	
    strPaginaTitulo = "ColaboradorUE_cad.asp"
	strValidaAlteracaoLotacao 		= "S"
	strCompartilharDados 			= "S"
    strModulacaoDiscipinarDocente 	= "S"
	strSubmitNivel      			= "" 
	strPagina						= "ColaboradorUE_cad.asp"
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
	
	intCodigoFuncionalAnterior 		= Trim(Request.Form("txtCodigoFuncionalAnterior"))					
	strnome 						= Trim(Request.Form("txtNomeFuncionario"))
	strdata_admissao  				= Trim(Request.Form("txtdata_admissao"))
	intCodFuncao 	    			= TRIM(Request.Form("cmbFuncao"))
	intCodCargo 	    			= TRIM(Request.Form("cmbCargo"))
	intCodTurno 					= TRIM(Request.Form("cmbTurno"))
	intcodLotacao 	    			= TRIM(Request.Form("cmbLotacao"))
	intcodLotacaoAnterior 			= Trim(Request("txtcodLotacaoAnterior"))
	intcodRemocao    				= TRIM(Request.Form("cmbRemocao"))
	
	
	intCodCorRaca 	    			= TRIM(Request.Form("cmbCorRaca"))
	intCodRegimeTrabalho 	    	= TRIM(Request.Form("cmbRegimeTrabalho"))
	intCodTipoCursoSuperior	    	= TRIM(Request.Form("cmbTipoCursoSuperior"))
	intCodCursoFormacao	  		  	= TRIM(Request.Form("cmbCursoFormacao"))
	intCodModalidadeEnsino	    	= TRIM(Request.Form("cmbModalidadeEnsino"))
	intCodNivelEnsino	    		= TRIM(Request.Form("cmbNivelEnsino"))
	strPossuiFormacaoEspecifica	    = TRIM(Request.Form("cmbPossuiFormacaoEspecifica"))
	strCursandoNivelEscolaridade	= TRIM(Request.Form("cmbCursandoNivelEscolaridade"))
	strNomeCursandoNivelEscolaridade	= TRIM(Request.Form("txtNomeCursandoNivelEscolaridade"))

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
	if strSituacao = "" or strSituacao = "0" then strSituacao = "A"
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
	if intCodNivel = "" then intCodNivel = "0"
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
	strDataLotacaoAnterior		= Trim(Request.Form("txtDataLotacaoAnterior"))
	intCodRegencia				= Trim(Request.Form("cmbRegencia"))
	strCarregado				= Trim(Request.Form("txtCarregado"))
	
	if intCodEmp = "" then intCodEmp = session("codEmpresa")

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

	if Trim(Request("BuscarPorFuncional")) = "S" then
	'response.Write "<br>BuscarPorFuncional"
	'response.Write "<br>strCarregado:" & strCarregado
		sql = "SELECT c.*, e.razaosocial as unidade_atual "
		sql = sql & " FROM 	SRH_COLABORADOR C "
		sql = sql & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " Where c.CodFuncional = " & intCodFuncional
		sql = sql & " and E.COD_GRUPO = " & session("codGrupo")
		'response.Write(sql)
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	 		= rs("Codigo")
			unidade_atual	 	= rs("unidade_atual")
			intCodEmp           = rs("Cod_Empresa")
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			
			intCodCursoFormacao 	    	= TRIM(Rs("cod_curso_formacao"))
			strPossuiFormacaoEspecifica 	= TRIM(Rs("SN_PossuiFormacaoEspecifica"))
			strCursandoNivelEscolaridade 	= TRIM(Rs("SN_CursandoNivelEscolaridade"))
			strNomeCursandoNivelEscolaridade 		= TRIM(Rs("nome_CursandoNivelEscolaridade"))
			
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
				intCodigoFuncionalAnterior = Trim(Rs("CodFuncional"))
				intCodDepartamento	= Trim(Rs("CodDepartamento"))
				strObs				= Trim(Rs("Obs"))
				strLattes			= Trim(Rs("Lattes"))
				strDataLotacao 		= formataDataAP(Rs("DataLotacao"))
				strDataLotacaoAnterior = formataDataAP(Rs("DataLotacao"))
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
				strCarregado		= "JACARREGOUDOBANCO"

				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			end if
		else
			%>
			<script>
				alert("Matrícula não Localizada. Verifique!")
			</script>
			<%
		end if
		rs.close
	elseif (request("porCPF")="S")  then

	'response.Write "<br>passou por CPF"
	'response.Write "<br>" & strCarregado
		
		if request("cd_func")<>"" then
			sql = "SELECT  c.*, e.razaosocial as unidade_atual"
			sql = sql & " FROM SRH_COLABORADOR C "
			sql = sql & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
			sql = sql & " Where C.codigo = " & request("cd_func")
		end if
		if strcpf<>"" then
			sql = "SELECT  c.*, e.razaosocial as unidade_atual"
			sql = sql & " FROM SRH_COLABORADOR C "
			sql = sql & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
			sql = sql & " Where C.cpf = '" & strcpf & "'"
		end if
		'response.write sql
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	 		= rs("Codigo")
			unidade_atual	 	= rs("unidade_atual")
			intCodEmp           = rs("Cod_Empresa")
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			intCodCorRaca 	    			= TRIM(Rs("cod_cor_raca"))
			intCodRegimeTrabalho 	    	= TRIM(Rs("cod_regime_trabalho"))
			intCodTipoCursoSuperior 	    	= TRIM(Rs("cod_Tipo_Curso_Superior"))
			intCodCursoFormacao 	    	= TRIM(Rs("cod_curso_formacao"))
			intCodModalidadeEnsino 	    	= TRIM(Rs("cod_Modalidade_Ensino"))
			intCodNivelEnsino 	    		= TRIM(Rs("cod_nivel_Ensino"))
			strPossuiFormacaoEspecifica 	= TRIM(Rs("SN_PossuiFormacaoEspecifica"))
			strCursandoNivelEscolaridade 	= TRIM(Rs("SN_CursandoNivelEscolaridade"))
			strNomeCursandoNivelEscolaridade 	    		= TRIM(Rs("nome_CursandoNivelEscolaridade"))
			
			
			IF strCarregado = "" THEN
				strUsuarioPortal	= Trim(Rs("codigo_SEG_USUARIOS_SISTEMA"))
					
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
				intCodTurno			  = TRIM(rs("codTurno"))
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
				strDataLotacaoAnterior 		= formataDataAP(Rs("DataLotacao"))
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
				rs.close
				
				sql = "SELECT arquivo "
				sql = sql & " FROM 	SRH_COLABORADOR_FOTO"
				sql = sql & " Where COD_EMPRESA = " & intCodEmp
				sql = sql & " And 	codColaborador = " & intCodigo
				rsAux.open sql, cnn
				if rsAux.eof = false then
					strCaminhoFoto = session("strCaminhoRaiz") & "/fotoColaborador/" & session("codEmpresa") & "/" & rsAux("arquivo")
					strFoto =  "<img src='" & strCaminhoFoto & "' width='120' height='130'>"
					strNomeBotaoFoto	= "Alterar Foto"
				end if
				rsAux.close	
			ELSE
				rs.close
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			END IF
		ELSE
			rs.close
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if 
		
		
		strFoto = "Foto"

	elseif request("cd_func")<>"" then	
	'response.Write "<br>cd_func"
	'response.Write "<br>" & strCarregado
		
		sql = "SELECT  c.*, e.razaosocial as unidade_atual"
		sql = sql & " FROM SRH_COLABORADOR C "
		sql = sql & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " Where C.Codigo = " & request("cd_func") 
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	 		= rs("Codigo")
			unidade_atual	 	= rs("unidade_atual")
			intCodEmp           = rs("Cod_Empresa")
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			intCodCorRaca 	    			= TRIM(Rs("cod_cor_raca"))
			intCodRegimeTrabalho 	    	= TRIM(Rs("cod_regime_trabalho"))
			intCodTipoCursoSuperior 	    	= TRIM(Rs("cod_Tipo_Curso_Superior"))
			intCodCursoFormacao 	    	= TRIM(Rs("cod_curso_formacao"))
			intCodModalidadeEnsino 	    	= TRIM(Rs("cod_Modalidade_Ensino"))
			intCodNivelEnsino 	    		= TRIM(Rs("cod_nivel_Ensino"))
			strPossuiFormacaoEspecifica 	= TRIM(Rs("SN_PossuiFormacaoEspecifica"))
			strCursandoNivelEscolaridade 	= TRIM(Rs("SN_CursandoNivelEscolaridade"))
			strNomeCursandoNivelEscolaridade 	    		= TRIM(Rs("nome_CursandoNivelEscolaridade"))
			
			
			IF trim(strCarregado) = "" THEN
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
				strDataLotacaoAnterior 		= formataDataAP(Rs("DataLotacao"))
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
				
				
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
				strCarregado		= "JACARREGOUDOBANCO"
			ELSE
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
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
		
	elseif intCodigo<>"" then
	'response.Write "<br>por codigo"
	'response.Write "<br>strCarregado:" & strCarregado
		bolColaborador		=  false
		sql = "SELECT  c.*, e.razaosocial as unidade_atual"
		sql = sql & " FROM SRH_COLABORADOR C "
		sql = sql & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " Where C.codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodigo	 		= rs("Codigo")
			unidade_atual	 	= rs("unidade_atual")
			intCodEmp           = rs("Cod_Empresa")
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional		= Trim(Rs("CodFuncional"))
	
			IF strCarregado = "" THEN
				bolColaborador		=  true
				strUsuarioPortal	= Trim(Rs("codigo_SEG_USUARIOS_SISTEMA"))
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
				strDataLotacaoAnterior			= formataDataAP(TRIM(rs("DataLotacao")))
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
		   		intCodNivel 		= rs("Cod_nivel")
				
				
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
		
				strCarregado		= "JACARREGOUDOBANCO"

			END IF
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		else
		
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			strFoto = "Foto"
			
		end if 
		rs.close
				
	end if 
	if REQUEST("porCPF") = "S" then
		'busca em todas empresas do grupo
		if strCPF <> "" and Trim(Request.Form("LocalizarMatricula")) <> "S"  then
			sql = "SELECT  c.codigo "
			sql = sql & " FROM SRH_COLABORADOR C "
			sql = sql & " inner join SEG_EMPRESA E ON C.CodLotacao = e.codigo"
			sql = sql & " Where c.cpf = '" & strCPF & "'"
			sql = sql & " And e.cod_Grupo = " & Session("CodGrupo")
			
			rs.open sql, cnn
			if rs.eof = false then
				cd_func = rs("codigo")
			end if 
			rs.close	
		end if	
	end if
	
	if request("AproveitarDados") = "S" or request("cd_func")<>"" then
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		bolColaborador 			= true
		intCodFuncional			= ""
		
		'response.Write("passou 1")
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
			strCargaHorariaTotalCarregada = strCargaHorariaTotal
		    strCargaHorariaTotal			= rsAux("carga_horario_contratada")
		    strTotalAulas					= rsAux("total_aulas")
			strFatorExtraClasse	 			= rsAux("FatorExtraClasse")
			strPercentualRepousoSemanal		= rsAux("PercentualRepousoSemanal")

		end if	
		rsAux.close
		
		'ATUALIZA A CH CONFORME NIVEL
		if strCargaHorariaTotal<>strCargaHorariaTotalCarregada and strDesabilitaAlterar="" then
			IF strCargaHorariaTotal<> "" THEN
				sql = " update srh_colaborador set carga_horario_contratada = " & strCargaHorariaTotal
				sql = sql & " where codigo = " & intCodigo
				CNN.EXECUTE SQL
			END IF
		end if
		
	end if 
	strDesabilitaBotaoPatrimonioColaborador = " " 
	if trim(intCodigo) = "" then strDesabilitaBotaoPatrimonioColaborador = " Disabled "
	
	if request("Prov")="S" then
		SQL = "SET NoCount ON INSERT INTO SRH_COLABORADOR_MATRICULA_PROVISORIA (usuario_incl, DATA) VALUES('" & session("UsuarioWeb") &"',GETDATE()) ;SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		intCodFuncionalProvisorio = rs(0)
		rs.close
		
		intCodFuncional = intCodFuncionalProvisorio
		if request("aproveitamentoDeCadastro") <> "" then
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if
	end if
	
	strDesabilitaGerarMatriculaProvisoria = ""
	if intCodFuncional <> "" and intCodFuncionalProvisorio="" then
		strDesabilitaGerarMatriculaProvisoria = "disabled"
	end if
	
	if strnacionalidade = "" then strnacionalidade = "Brasileira"
	linhasAtivas=1
	situacaoReadaptacaoNoneBlock = "none"
	strReadaptacao = "N"
	if intCodigo <> "" then
		
		sql = "SELECT codigo"
		sql = sql & " FROM SRH_COLABORADOR_READAPTACAO"
		sql = sql & " WHERE situacao = 'A' and cod_Colaborador=" & intCodigo
		RS.OPEN SQL, CNN
		if not RS.eof then
			situacaoReadaptacaoNoneBlock = "block"
			strReadaptacao = "S"
		end if
		rs.close
		
		'--verifica se tem mais de um ativo em periodo diferentes
		sql = "select distinct data_inicio, data_final from SRH_COLABORADOR_READAPTACAO"
		sql = sql & " where cod_colaborador=" & intCodigo
		sql = sql & " and situacao='A'"
		RS.OPEN SQL, CNN, 3, 1
		if not RS.eof then
			linhasAtivas = rs.recordCount
		end if
		rs.close
	end if
	
	situacaoProcessoLicencaNoneBlock = "none"
	strProcessoLicenca = "N"
	if intCodigo <> "" then
		sql = "SELECT codigo"
		sql = sql & " FROM SRH_COLABORADOR_PROCESSO_LICENCA"
		sql = sql & " WHERE cod_Colaborador=" & intCodigo
		RS.OPEN SQL, CNN
		if not RS.eof then
			situacaoProcessoLicencaNoneBlock = "block"
			strProcessoLicenca = "S"
		end if
		rs.close
	end if
	
	if intCodTurno <> "" then 
		turno_atual = ""
		sql = " SELECT desc_turno as turno "
		sql = sql & " FROM srh_turno"
		sql = sql & " WHERE cod_turno = " & intCodTurno
		rsAux.open sql, cnn
		if not rsAux.eof then
			turno_atual			= Trim(rsAux("turno"))
		end if
		rsAux.close
	end if 
	
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	%>
    
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Colaborador <%=linhasAtivas%></h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form --> 
             	<form method="post" id="frm" name="frm" action="">	
                <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >
				<input type="hidden" name="linhasAtivas" id="linhasAtivas" value="<%=linhasAtivas%>">
                <input name="txtMatriculaNovaProvisoria" id="txtMatriculaNovaProvisoria" value="<%=intCodFuncionalProvisorio%>" type="hidden" >
                <input name="aproveitamentoDeCadastro" id="aproveitamentoDeCadastro" value="<%=request("AproveitarDados")%>" type="hidden" >
            	<div class="panel-body">                                                        
                      	<!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                      	Informe corretamente os campos obrigat&oacute;rios ( * )   
				     <div class="div-amarela"><strong> * Não liberado para alteração. </strong></div>
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
												  <td bgcolor="#FFFFD2">CPF:</td>
												  <td bgcolor="#FFFFD2" width="13%" ><input name="txtcpf" type="text" class="form-control" id="txtcpf" size="12" maxlength="15" value="<%=strCPF%>" onkeypress="return formataCampo(this,5,14)" onblur="return validaCPFColaborador(this)">&nbsp;<strong>*</strong>
												  
												  <%if session("CodGrupo") = "7" and strCPF<>"" and request("porCPF")="S" and intCodFuncional="" or (request("AproveitarDados")="S") then%>
													<input name="btnProvisorio" type="button"  class="btn-u float-shadow" id="btnProvisorio" style="cursor:hand" onclick="gerarMatriculaProvisoria()"   value="Matr&iacute;cula Provis&oacute;ria" <%=strDesabilitaGerarMatriculaProvisoria%> />
												  <%end if%>
												  </td>
												  <td width="15%">Matrícula Funcional:</td>
												  <td width="26%" >
													<input name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">&nbsp;<strong>*</strong><input type="checkbox" name="LocalizarMatricula" value="S" onClick='localizarPorCodFuncional()'>Localizar?                                                  
													<input name="txtCodigoFuncionalAnterior" type="hidden" class="text" id="txtCodigoFuncionalAnterior" size="2" maxlength="8" value="<%=intCodigoFuncionalAnterior%>">
												  </td>
												</tr>
                                              <tr>
                                                <td width="11%">Nome:</td>
                                                <td colspan="3">
													<input name="situacaoAnteriorDoColaborador" value="<%=strSituacao%>" type="hidden" id="situacaoAnteriorDoColaborador" >
													<input name="txtCodFuncionario" value="<%=intCodigo%>" type="hidden" id="txtCodFuncionario" >
													<input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
													<input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
													<input name="txtDataLotacaoAnterior" type="hidden" id="txtDataLotacaoAnterior" value="<%=strDataLotacaoAnterior%>" />
													<input name="txtNomeFuncionarioAnterior" type="hidden" class="form-control" id="txtNomeFuncionarioAnterior" size="70" maxlength="70" value="<%=strNome%>">
													<input name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="70" maxlength="70" value="<%=strNome%>">&nbsp;<strong>*</strong>
													<button class="btn btn-success" onclick="Consulta('ColaboradorUE_con.asp?PaginaOrigem=ColaboradorUE_cad')" type="button"><i class="fa fa-search"></i></button>                                                
												</td>
                                              </tr>
                                              <tr>
                                                <td>Data Nasc.:</td>
                                                <td><input name="txtdata_nascimento" type="text" class="form-control" id="txtdata_nascimento" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strdata_nascimento%>">&nbsp;<strong>*</strong></td>
                                                <td>Estado Civil:</td>
                                                <td><select name="txtestado_civil" class="form-control" id="txtestado_civil">
                                                  <option value="0">Selecione...</option>
                                                  <option value="S" <%if strestado_civil = "S" then response.Write("selected") %>>Solteiro</option>
                                                  <option value="C" <%if strestado_civil = "C" then response.Write("selected") %>>Casado</option>
                                                  <option value="V" <%if strestado_civil = "V" then response.Write("selected") %>>Vi&uacute;vo</option>
                                                  <option value="D" <%if strestado_civil = "D" then response.Write("selected") %>>Desquitado</option>
                                                  <option value="I" <%if strestado_civil = "I" then response.Write("selected") %>>Divorciado</option>
                                                  <option value="U" <%if strestado_civil = "U" then response.Write("selected") %>>União Estável</option>
                                                  <option value="O" <%if strestado_civil = "O" then response.Write("selected") %>>Outros</option>
                                                </select>
                                                  &nbsp;<strong>*</strong></td>
                                              </tr>
                                              <tr>
                                                <td>Sexo:</td>
                                                <td>
                                                <select name="cboSexo" class="form-control" id="cboSexo">
                                                    <option value="0">Selecione...</option>
                                                    <option value="M" <%if strSexo = "M" then response.Write("selected") %>>Masculino</option>
                                                    <option value="F" <%if strSexo = "F" then response.Write("selected") %>>Feminino</option>
                                                </select> <strong>*</strong>                                     			</td>
                                          	    <td>Celular:</td>
                                          	    <td><input name="txtFoneCelular" type="text" class="form-control" id="txtFoneCelular" onkeypress="mascara(this,telefone)" value="<%=strFoneCelular%>" size="20" maxlength="15">&nbsp;<strong>*</strong></td>
                                              </tr>
                                              <tr>
                                                <td>Fone (Res):</td>
                                                <td><input name="txtFoneResidencial" type="text" class="form-control" id="txtFoneResidencial" onkeypress="mascara(this,telefone)" value="<%=strFoneResidencial%>" size="20" maxlength="15"></td>
                                                <td>Dt. Admiss&atilde;o</td>
                                                <td><input name="txtdata_admissao" type="text" class="form-control" id="txtdata_admissao" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strdata_admissao%>">&nbsp;<strong>*</strong></td>
                                              </tr>
                                              <tr>
                                                <td>Fone (Com):</td>
                                                <td><input name="txtFoneComercial" type="text" class="form-control" id="txtFoneComercial" onkeypress="mascara(this,telefone)" value="<%=strFoneComercial%>" size="20" maxlength="15"></td>
                                                <td>Nacionalidade:</td>
                                                <td><input name="txtnacionalidade" type="text" class="form-control" id="txtnacionalidade" size="15" maxlength="50" value="<%=strnacionalidade%>">*</td>
											</tr>
                                              <tr>
                                                <td>Naturalidade:</td>
                                                <td><input name="txtnaturalidade" type="text" class="form-control" id="txtnaturalidade" size="15" maxlength="50" value="<%=strnaturalidade%>">&nbsp;*UF:
                                                  <!--#include file="../includes/inc_cmdUFNaturalidade.asp" -->
                                                &nbsp;*</strong></td>
                                                <td></td>
                                                <td></td>
											</tr>
                                              <tr>
                                                <td>E-mail:</td>
                                                <td><input name="txtemail" type="text" class="form-control" id="txtemail" size="40" maxlength="70" value="<%=stremail%>" /></td>
                                                <td>Turno:&nbsp;												
												</td>
                                                <td><!--#include file="../includes/inc_cmbTurnoRH.asp" -->
												</td>
                                              </tr>
                                              <tr>
                                                <td>Cargo</td>
                                                <td>
                                                  <input name="txtCargoAtual" type="hidden" value="<%=intCodCargo%>" />
                                                  <input name="txtFuncaoAtual" type="hidden" value="<%=intCodFuncao%>" />
                                                  <input name="txtSituacaoAtual" type="hidden" value="<%=strSituacao%>" />
                                                  <input name="txtNivelAtual" type="hidden" value="<%=intCodNivel%>" />
                                                  <input name="txtTurnoAtual" type="hidden" value="<%=intCodTurno%>" />
                                                  <!--#include file="../includes/inc_cmbCargo.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                                <td>Fun&ccedil;&atilde;o:</td>
                                                <td>
                                                  <!--#include file="../includes/inc_cmbFuncao.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                              </tr>
                                              <tr>
                                                <td  >Grau Instru&ccedil;&atilde;o:<br>
												<span style="font-style: italic; font-size: 9px;">(Maior nível de escolaridade concluído)</span>

												</td>
                                                <td  >
                                                  <!--#include file="../includes/inc_cmdGrauInstrucaoColaborador.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                                <td ></td>
                                                <td ></td>
                                              
											  
                                              <tr>
                                                <td>Lota&ccedil;&atilde;o:</td>
                                                <td>
													<%IF strDesabilitaAlterar<>"" THEN%>
														<!--#include file="../includes/inc_cmbLotacao.asp" -->
													<%ELSE%>
														
														<input name="cmbLotacao" type="HIDDEN" id="cmbLotacao" value="<%=intcodLotacao%>"/>
														<strong><%=unidade_atual%></strong>
													<%END IF%>
												</td>
                                                <td>
                                                <div id="linha_depto1">
												</td>
                                                </div>                                           
                                                <td>
                                                <div id="linha_depto2">
                                                  
                                                <strong>*</strong>
                                                &nbsp;     
                                                </div>                                           
													
                                                </td>
                                              </tr>
                                              <tr>
                                                <td>Data Lota&ccedil;&atilde;o:</td>
                                                <td>
                                                  <input name="txtDataLotacao" type="text" class="form-control" id="txtDataLotacao" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLotacao%>" title="Click aqui para visualizar o calend&aacute;rio" />
                                                &nbsp;<strong>*</strong></td>
                                                <td>Vinculo:</td>
                                                <td>
                                                  <!--#include file="../includes/inc_cmbFormaNomeacao.asp" -->
                                                &nbsp;<strong>*</strong></td>
                                              </tr>
                                                          
                                              <tr> 
                                                
                                                <td>Observação:</td>
                                                <td colspan="3">
                                                  <textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtObs" cols="90" rows="4" class="text" id="txtObs"><%=strObs%></textarea>
                                                  <br /><font color="#0066FF">(caracteres restantes: <span id="cont">300</span>)</font></span></td>
                                          	  </tr>
                                              
                                              <tr> 
                                                
                                                <td>Ocorrência:</td>
                                                <td colspan="3">
                                                  <textarea  onkeyup="blocTextoOcorrencia(this.value,'<%=cont%>')"  name="txtOcorrencia" cols="90" rows="4" class="text" id="txtOcorrencia"></textarea>
                                                  <br /><font color="#0066FF">(caracteres restantes: <span id="contOcorrencia">300</span>)</font></span>
                                                  <br>
                                                  <br>
												  <!--#include file="../includes/inc_ListaOcorrenciasColaboradorFicha.asp" -->
                                                  </td>
                                          	  </tr>
                                              
                                              
                                          <tr>
                                                <td>Readaptação</td>
                                                <td colspan="3">
                                                	<select name="cmbReadaptacao" class="form-control" id="cmbReadaptacao"  onChange="mostraReadaptacao()">
                                                  		<option value="N" <%if strReadaptacao = "N" then response.Write("selected") %>>Não</option>
                                                  		<option value="S" <%if strReadaptacao = "S" then response.Write("selected") %>>Sim</option>
                                                	</select>
                                                </td>
                                          	</tr>
                                            <tr>
                                                <td colspan="4">
                                                    
													<div class="form-group" id="linhaReadaptacao" style="display:<%=situacaoReadaptacaoNoneBlock%>">
                                                            <table width="100%" border="1" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><strong>Função</strong></td>
                                                                <td align="center"><strong>Tipo</strong></td>
																<td align="center"><strong>Processo</strong></td>
                                                                <td align="center"><strong>Início</strong></td>
                                                                <td align="center"><strong>Fim</strong></td>
                                                                <td align="center"><strong>Observação</strong></td>
                                                                <td align="center"><strong>Inclusão</strong></td>
																<td align="center"><strong>Inativar</strong></td>
																<td align="center"><strong>Remover</strong></td>
                                                              </tr>
                                                              <%
															  if intCodigo<>"" then
															  	controleInicio = 0
																linhareadaptacao = 0
																data_final_ultima_readaptacao_ativa=""
															  	sql = "SELECT max(data_final) as data"
																sql = sql & " FROM SRH_COLABORADOR_READAPTACAO "
																sql = sql & " WHERE cod_Colaborador=" & intCodigo
																sql = sql & " and situacao='A'"
																RS.OPEN SQL, CNN
																if not RS.eof then
																	data_final_ultima_readaptacao_ativa = rs("data")
																end if
																RS.close
																
																sql = "SELECT r.*, fc.desc_funcao"
																sql = sql & " FROM SRH_COLABORADOR_READAPTACAO r inner join SRH_FUNCAOCOLABORADOR fc on fc.cod_funcao = r.cod_funcao"
																sql = sql & " WHERE cod_Colaborador=" & intCodigo

																RS.OPEN SQL, CNN
																if not RS.eof then
																	while not rs.eof
																		strDataSituacao = ""
																		controleInicio = controleInicio + 1
																		linhareadaptacao = linhareadaptacao + 1
																		
																		intCodigoReadaptacao = rs("codigo")
																		
																		intCodFuncaoReadaptacao = rs("cod_funcao")
																		strTipoReadaptacao = rs("tipo")
																		if trim(strTipoReadaptacao) = "" or isnull(strTipoReadaptacao) and controleInicio=10 then strTipoReadaptacao = "D"
																		strProcesso = rs("processo")
																		strDataInicio = formatadataAP(rs("data_inicio"))
																		strDataFim = formatadataAP(rs("data_final"))
																		strObservacao = rs("observacao")
																		strTipoReadaptacaoTela = ""
																		if strTipoReadaptacao = "P" then strTipoReadaptacaoTela = "Provisório"
																		if strTipoReadaptacao = "D" then strTipoReadaptacaoTela = "Definitivo"
																		cor_fundo = ""
																		strSituacaoReadap = ""
																		
																		if trim(rs("situacao")) = "I" then
																			strDataSituacao = rs("data_situacao")
																			if strDataSituacao<>"" then strDataSituacao = "&nbsp;em " & formatadataAP(strDataSituacao) & " por " & rs("usuario_altr")
																			strSituacaoReadap = "<br><strong><i><font size='-1' color='red'>(inativo" & strDataSituacao & ")</font></i></strong>"
																			cor_fundo		  = " bgcolor='#ffc9c3' "
																		end if
															  			%>
                                                                          <tr height="80" <%=cor_fundo%>>
                                                                            <td><strong><%=rs("desc_funcao")%><%=strSituacaoReadap%></strong>
																			<input name="cmbFuncaoReadaptacao_<%=controleInicio%>" type="hidden" id="cmbFuncaoReadaptacao_<%=controleInicio%>" value="<%=intCodFuncaoReadaptacao%>"/>
                                                                            </td>
                                                                            <td align="center"><strong><%=strTipoReadaptacaoTela%></strong>
																			<input name="cmbTipoReadaptacao_<%=controleInicio%>" type="hidden" id="cmbTipoReadaptacao_<%=controleInicio%>" value="<%=strTipoReadaptacao%>"/>
                                                                            </td>
																			<td align="center"><strong><%=strProcesso%></strong>
																			<input name="txtProcesso_<%=controleInicio%>" type="hidden" id="txtProcesso_<%=controleInicio%>" value="<%=strProcesso%>"/>
                                                                            </td>
                                                                            <td align="center"><strong><%=strDataInicio%></strong>
                                                                            <input name="txtDataInicio_<%=controleInicio%>" type="hidden" id="txtDataInicio_<%=controleInicio%>" value="<%=strDataInicio%>"/>
                                                                            </td>
                                                                            <td align="center"><strong><%=strDataFim%></strong>
                                                                            <input name="txtDataFim_<%=controleInicio%>" type="hidden" id="txtDataFim_<%=controleInicio%>"  value="<%=strDataFim%>"/>
                                                                            </td>
                                                                            <td ><strong><%=strObservacao%></strong>
                                                                            <input name="txtObs_<%=controleInicio%>" type="hidden" id="txtObs_<%=controleInicio%>"  value="<%=strObservacao%>"/>
																			</td>
                                                                            <td ><strong><%=rs("usuario_incl")%><br><%=formatadataap(rs("data_incl"))%></strong>&nbsp;</td>
																			<td align="center" >
																				<%if rs("situacao") <> "I" then%>
																					<button class="btn-u btn-u-orange" onclick="removeReadaptacao('I','<%=intCodigoReadaptacao%>','<%=controleInicio%>')" type="button"><i class="fa fa-remove"></i>&nbsp;Inativar </button>  
																					<input name="txtDataSituacao_<%=controleInicio%>" type="text" class="form-control" id="txtDataSituacao_<%=controleInicio%>" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="7" placeholder="digite data" maxlength="10" value="<%=strDataSituacao%>"/>
																					<br>
																				<%end if%>
																			</td> 
																			<td align="center" >
																			<%if trim(rs("situacao_exclusao"))="I" then%>
																				<button class="btn-u btn-u-red" onclick="removeReadaptacao('E','<%=intCodigoReadaptacao%>','<%=controleInicio%>')" type="button"><i class="fa fa-remove"></i>&nbsp;Remover</button><input name="txtMotivo_<%=controleInicio%>" type="text" placeholder="digite motivo" size="7" maxlength="50" id="txtMotivo_<%=controleInicio%>" class="form-control" value="<%=strMotivo%>"/>                         
																			<%elseif trim(rs("situacao_exclusao"))="A" then%>
																				<strong><font size='-1' color='red'>Aguardando exclusão</font></strong>
																			<%elseif trim(rs("situacao_exclusao"))="N" then%>
																				<strong><font size='-1' color='green'>Não autorizado</font></strong>
																			<%end if%>
																			</td> 
                                                                          </tr>
																		<% 		
															  			rs.movenext
															  		wend
															  	end if
																rs.close
																intCodFuncaoReadaptacao = ""
																strTipoReadaptacao = ""
																strProcesso = ""
																strDataInicio = ""
																strDataFim = ""
																strObservacao = ""
																if controleInicio < 10 then
																	controleInicioReadaptacao = controleInicio + 1
																	if LinhaInicioDigitacaoReadaptacao = "" then LinhaInicioDigitacaoReadaptacao = controleInicioReadaptacao
																	%>
	                                                              <%for controleInicio=controleInicioReadaptacao to 10
																  		strTipoReadaptacao = "P"
																		if controleInicio=10 then strTipoReadaptacao = "D"
																		linhareadaptacao = linhareadaptacao + 1
																  %>
                                                                  <tr>
                                                                    <td class="form-control"><!--#include file="../includes/inc_cmbFuncaoReadaptacao.asp" --></td>
                                                                    <td class="form-control">
                                                                    <select name="cmbTipoReadaptacao_<%=controleInicio%>" class="form-control" id="cmbTipoReadaptacao<%=controleInicio%>" >
                                                                        <option value="P" <%if strTipoReadaptacao = "P" then response.Write("selected") %>>Provisório</option>
                                                                        <option value="D" <%if strTipoReadaptacao = "D" then response.Write("selected") %>>Definitivo</option>
                                                                    </select>
                                                                    </td>
																	<td class="form-control"><input name="txtProcesso_<%=controleInicio%>" type="text" class="form-control" id="txtProcesso_<%=controleInicio%>" size="5" maxlength="50" value="<%=strProcesso%>" /></td>
                                                                    <td class="form-control"><input name="txtDataInicio_<%=controleInicio%>" type="text" class="form-control" id="txtDataInicio_<%=controleInicio%>" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="5" maxlength="10" value="<%=strDataInicio%>" title="Click aqui para visualizar o calend&aacute;rio" /></td>
                                                                    <td class="form-control"><input name="txtDataFim_<%=controleInicio%>" type="text" class="form-control" id="txtDataFim_<%=controleInicio%>" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="5 maxlength="10" value="<%=strDataFim%>" title="Click aqui para visualizar o calend&aacute;rio" /></td>
                                                                    <td class="form-control"><textarea rows="2" cols="10" name="txtObs_<%=controleInicio%>" id="txtObs_<%=controleInicio%>"><%=strObservacao%></textarea></td>
                                                                  </tr>
                                                                  <%next%>	
                                                                 
																 <%		
																 else
																	linhareadaptacao = linhareadaptacao + 1
																	controleInicio = linhareadaptacao
																	%>
																	 <tr>
																		<td class="form-control"><!--#include file="../includes/inc_cmbFuncaoReadaptacao.asp" --></td>
																		<td class="form-control">
																		<select name="cmbTipoReadaptacao_<%=controleInicio%>" class="form-control" id="cmbTipoReadaptacao<%=controleInicio%>" >
																			<option value="P" <%if strTipoReadaptacao = "P" then response.Write("selected") %>>Provisório</option>
																			<option value="D" <%if strTipoReadaptacao = "D" then response.Write("selected") %>>Definitivo</option>
																		</select>
																		</td>
																		<td class="form-control"><input name="txtProcesso_<%=controleInicio%>" type="text" class="form-control" id="txtProcesso_<%=controleInicio%>" size="5" maxlength="50" value="<%=strProcesso%>" /></td>
																		<td class="form-control"><input name="txtDataInicio_<%=controleInicio%>" type="text" class="form-control" id="txtDataInicio_<%=controleInicio%>" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="5" maxlength="10" value="<%=strDataInicio%>" title="Click aqui para visualizar o calend&aacute;rio" /></td>
																		<td class="form-control"><input name="txtDataFim_<%=controleInicio%>" type="text" class="form-control" id="txtDataFim_<%=controleInicio%>" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="5 maxlength="10" value="<%=strDataFim%>" title="Click aqui para visualizar o calend&aacute;rio" /></td>
																		<td class="form-control"><textarea rows="2" cols="10" name="txtObs_<%=controleInicio%>" id="txtObs_<%=controleInicio%>"><%=strObservacao%></textarea></td>
																	  </tr>
																<%
																end if
															  else
															  %>
																  <%for controle=1 to 10
																	linhareadaptacao = linhareadaptacao + 1
																	controleInicio = linhareadaptacao
																  %>
                                                                  <tr>
                                                                    <td><!--#include file="../includes/inc_cmbFuncaoReadaptacao.asp" --></td>
                                                                    <td>
                                                                    <select name="cmbTipoReadaptacao_<%=controle%>" class="form-control" id="cmbTipoReadaptacao_<%=controle%>" >
                                                                        <option value="P" <%if strTipoReadaptacao = "P" then response.Write("selected") %>>Provisório</option>
                                                                        <option value="D" <%if strTipoReadaptacao = "D" then response.Write("selected") %>>Definitivo</option>
                                                                    </select>
                                                                    </td>
																	<td class="form-control"><input name="txtProcesso_<%=controle%>" type="text" class="form-control" id="txtProcesso_<%=controle%>" size="10" maxlength="10" value="<%=strProcesso%>" /></td>
                                                                    <td><input name="txtDataInicio_<%=controle%>" type="text" class="form-control" id="txtDataInicio_<%=controle%>" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="7" maxlength="10" value="<%=strDataInicio%>" title="Click aqui para visualizar o calend&aacute;rio" /></td>
                                                                    <td><input name="txtDataFim_<%=controle%>" type="text" class="form-control" id="txtDataFim_<%=controle%>" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="7" maxlength="10" value="<%=strDataFim%>" title="Click aqui para visualizar o calend&aacute;rio" /></td>
                                                                    <td><textarea rows="2" cols="30" name="txtObs_<%=controle%>" id="txtObs_<%=controle%>"><%=strObservacao%></textarea></td>
                                                                    <td>&nbsp;</td>
																	<td>&nbsp;</td>
                                                                  </tr>
                                                                  <%next%>
                                                             <% end if%>
                                                            </table>
															<input name="txtQtdeLinhaReadaptacao" id="txtQtdeLinhaReadaptacao" value="<%=linhareadaptacao%>" type="hidden" >
                                                    </div>
													
                                                </td>
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
<tr id="tr5"></tr>
                                </thead>
                                <tr id="tr2">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Conteudo -->
                                    <table class="table table-bordered">
                                      <tr>
                                        <td width="11%">CEP: </td>
                                        <td colspan="4">
                                          <input name="txtCep" type="text" class="form-control" id="txtCep" size="20" maxlength="8" value="<%=strCep%>" onkeypress="return formataCampo(this, 2, 8)" />
                                        </td>
                                      </tr>
									  <tr>
                                        <td width="11%">Logradouro: </td>
                                        <td>
                                          <input name="txtLogradouro" type="text" class="form-control" id="txtLogradouro" size="40" maxlength="60" value="<%=strLogradouro%>" />
                                        </td>
                                        <td></td>
                                        <td colspan="3">
                                          
                                        </td>
                                      </tr>
                                      <tr>
                                        <td >Complemento:</td>
                                        <td width="27%">
                                        <input name="txtComp_endereco" type="text" class="form-control" id="txtComp_endereco" size="40" maxlength="20" value="<%=strComp_endereco%>" />
                                        </td>
                                        <td width="15%">N&uacute;mero:</td>
                                  <td colspan="3">
								  <input name="txtNumero_endereco" type="text" class="form-control" id="txtNumero_endereco" size="20" maxlength="5" value="<%=strNumero_endereco%>" />
                            
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
                                
                                <!-- Documentação -->
                                
                                <tr id="tr6">
                                    <td colspan="2" bgcolor="#FFFFFF">
                                    <!-- Inicio Conteudo -->
                                    
                                    <table class="table table-bordered">
									  <% if strNivelEnsinoSigla <> "EB" then%>
                                                  <tr>
                                                    <td width="23%">N&iacute;vel :</td>
                                                    <td colspan="3">
                                                      <!--#include file="../includes/inc_cmbNivel.asp" -->
                                                    </td>
                                      </tr>
                                                  
                                                  <tr>
                                                    <td>Sal&aacute;rio Base:</td>
                                                    <td width="30%">**N&atilde;o Dispon&iacute;vel**
                                                        <input readonly name="txtSalarioBase" type="hidden" class="form-control" id="txtSalarioBase" size="11" maxlength="10" value="<%=strSalarioBase%>" />
                                                    </td>
                                                    <td width="21%">Horas Semanais Contratada></td>
                                                    <td width="26%">
                                                      <input readonly name="txtCargaHorariaTotal" type="text" class="form-control" id="txtCargaHorariaTotal" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strCargaHorariaTotal%>" />hs</td>
                                      </tr>
                                                  <tr>
                                                    <td>Repouso Semanal Remunerado:</td>
                                                    <td>
                                                      <input readonly name="txtPercentualRepousoSemanal" type="text" class="form-control" id="txtPercentualRepousoSemanal" onkeypress="return currencyFormat(this,event)"  size="5" maxlength="5" value="<%=strPercentualRepousoSemanal%>" />% </td>
                                                    <td>Aulas Semanais Contratada:</td>
                                                    <td>
                                                      <input readonly name="txtTotalAulas" type="text" class="form-control" id="txtTotalAulas" onkeypress="return formataCampo(this, 2, 5)"  size="5" maxlength="5" value="<%=strTotalAulas%>" />
                                                    </td>
                                                  </tr>
                                                  <tr>
                                                    <td>C&aacute;lculo Extra Classe:</td>
                                                    <td>
                                                      <input readonly name="txtFatorExtraClasse" type="text" class="form-control" id="txtFatorExtraClasse" onkeypress="return currencyFormat(this,event)"  size="5" maxlength="5" value="<%=strFatorExtraClasse%>" />
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
					if 		LinhaInicioDigitacaoReadaptacao = "" then LinhaInicioDigitacaoReadaptacao = 1			

				  %>
				  <input type="hidden" name="txtExisteModulacao" id="txtExisteModulacao" value="<%=strExisteModulacao%>">
				  <input type="hidden" name="LinhaInicioDigitacaoReadaptacao" id="LinhaInicioDigitacaoReadaptacao" value="<%=LinhaInicioDigitacaoReadaptacao%>">
                  <input type="hidden" name="data_final_ultima_readaptacao_ativa" id="data_final_ultima_readaptacao_ativa" value="<%=formatadataAP(data_final_ultima_readaptacao_ativa)%>">
                  <%
					'ATUALIZA PONTO - FAIXA 
					if session("codGrupo") = "7" then
					
						sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & session("strAnoLetivo") & "," & session("CodGrupo") & "," & intCodigo
						'cnn.execute sql
						
						'ATUALIZA PONTO - LOTACAO
						sql = "EXECUTE SP_APO_Atualiza_Lotacao_Ponto " & session("strAnoLetivo") & "," & session("CodGrupo") & "," & intCodigo
						'response.write sql
						'cnn.execute sql
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
    <script src="json/jquery-1.7.1/jquery-1.7.1.min.js"></script>
    <script>
    	$(document).ready(function(){
			
			$('#txtUsuarioPortal').blur(function () {
				if ($(this).val()) {
					$.getJSON('json/carregar.asp?tipoAcao=VALIDA_LOGIN', { login: $(this).val(), ajax: 'true' }, function (j) {
						for (var i = 0; i < j.length; i++) {
							alert(j[i].nome);
							$('#txtUsuarioPortal').val("");
							return false
						}
					});
				}
			});			
		});

    </script>
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
		
		function abreConsultaFuncionario(caminho){
            window.open(caminho,"abreColoborador","top=5,left=5,height=510,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
		
		function blocTexto(valor, id)
        {
			resto = 0
			quant = 300;
            total = valor.length;
            if(total <= quant)
            {
                resto = quant - total;
                document.getElementById('cont').innerHTML = resto;
            }
            else
            {
                document.getElementById('txtObs').value = valor.substr(0,quant);
            }
        }
		function blocTextoOcorrencia(valor, id)
        {
			resto = 0
            quant = 300;
            total = valor.length;
            if(total <= quant)
            {
                resto = quant - total;
                document.getElementById('contOcorrencia').innerHTML = resto;
            }
            else
            {
                document.getElementById('txtOcorrencia').value = valor.substr(0,quant);
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
					campo.value="";
                    campo.focus();
                    campo.select();
                }else{
                    if (campo.value!=""){
						frm.txtCarregado.value="";
						frm.LocalizarMatricula.value="";
						frm.action="ColaboradorUE_cad.asp?porCPF=S"
                        frm.submit();	
					}
                        
                }
                        
            }
        }
	
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if ((acao=="I") || (acao=="A")){
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
				if(frm.cmbTurno.value == "0"){
					alert("O TURNO deve ser informado!");
					frm.cmbTurno.focus();
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
		
			
		
				
		
				if(frm.cmbGrauInstrucao.value == "0"){
					alert("O GRAU DE INSTRUÇÃO deve ser informado!");
					frm.cmbGrauInstrucao.focus();
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
		
					
				if(frm.cmbReadaptacao.value == "S"){
					//validação Readaptacao
					for (var i = 1; i < 11; i++) {
						 if(document.all("cmbFuncaoReadaptacao_"+i).value != "0"){
							if(document.all("txtDataInicio_"+i).value == ""){
								alert("A data do inicio da readaptação da linha "+ i +" deve ser informada!");
								document.all("txtDataInicio_"+i).focus();
								return false
							}
						}
					}
					
					var linhaDigitando = frm.LinhaInicioDigitacaoReadaptacao.value;
					
					if (linhaDigitando>1) {
					
						if(document.all("cmbFuncaoReadaptacao_"+linhaDigitando).value != "0"){
							if(document.all("txtDataInicio_"+linhaDigitando).value == ""){
								alert("A data do inicio da readaptação da linha "+linhaDigitando+" deve ser informada!");
								document.all("txtDataInicio_"+linhaDigitando).focus();
								return false
							}
							
							var dtini = document.all("txtDataInicio_"+linhaDigitando).value;
							var dtfim = frm.data_final_ultima_readaptacao_ativa.value;
							
							
							datInicio = new Date(dtini.substring(6,10),
												dtini.substring(3,5),
												dtini.substring(0,2));
							datInicio.setMonth(datInicio.getMonth() - 1);
						   
						   
							datFim = new Date(dtfim.substring(6,10),
												dtfim.substring(3,5),
												dtfim.substring(0,2));
											 
							datFim.setMonth(datFim.getMonth() - 1);
							
							if ( frm.data_final_ultima_readaptacao_ativa.value != "" ){
								if(datInicio < datFim ) {
									alert("A data do inicio da readaptação da linha " + linhaDigitando + " deve ser maior ou igual o final da última readaptação ativa!");
									document.all("txtDataInicio_"+linhaDigitando).focus();
									return false
								}
							}
						}
					}
					
					
				}
				if(frm.linhasAtivas.value != "1"){
					alert("Verificamos que a readaptação tem mais de uma ATIVA com períodos diferentes. Você deverá deixar somente uma!");
					return false		
				}
				
				
				frm.action= "ColaboradorUE_cod.asp?acao="+acao;
				frm.submit();
				return true;
				
			
		}
		
		if (acao=="E"){
			
			var frm = document.getElementById("frm");
			var men = 'ATENÇÃO: Deseja realmente excluir este colaborador'
			if (confirm(men)) {
				frm.action= "ColaboradorUE_cod.asp?acao="+acao;
				frm.submit();
			} else {
				return false;
			}
		
		}
	
	}
	
	function gerarMatriculaProvisoria(){
		var frm = document.getElementById("frm");
		frm.txtCarregado.value="";
		frm.action = "ColaboradorUE_cad.asp?prov=S"
		frm.submit();
	}
	function localizarPorCodFuncional(){
		var frm = document.getElementById("frm");
		frm.txtCarregado.value="";
		frm.action = "ColaboradorUE_cad.asp?BuscarPorFuncional=S"
		frm.submit();
	}

	
	function removeReadaptacao(acao, codigo, controle){
		var frm = document.getElementById("frm");
		frm.txtCarregado.value="";
		var data_inativacao = "";
		var motivo = "";
		
		if (acao=="I"){
			data_inativacao = document.getElementById("txtDataSituacao_"+controle).value;
			if (document.getElementById("txtDataSituacao_"+controle).value ==""){
				alert("A data da inativação deve ser informada!");
				document.getElementById("txtDataSituacao_"+controle).focus();
				return false
			}
			var men = 'ATENÇÃO: Deseja realmente INATIVAR essa readaptação?';
		}
		if (acao=="E"){
			motivo = document.getElementById("txtMotivo_"+controle).value;
			if (document.getElementById("txtMotivo_"+controle).value ==""){
				alert("O motivo da remoção deve ser informado!");
				document.getElementById("txtMotivo_"+controle).focus();
				return false
			}
			var men = 'ATENÇÃO: Deseja realmente REMOVER essa readaptação, se sim ela será enviada para autorização?';
		}
		if (confirm(men)) {
			frm.action = "ColaboradorReadaptacao_cod.asp?controle="+controle+"&cod=" + codigo + "&acao="+acao+"&data="+data_inativacao+"&motivo="+motivo;
			frm.submit();
		} else {
			return false;
		}
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
	
	function mostraMotivos(){
		var frm = document.getElementById("frm");
		document.all["linhaMotivoDaTrocaLotacao"].style.display = "none";
		if (frm.txtcodLotacaoAnterior.value!="" && frm.txtcodLotacaoAnterior.value!="0"){
			if (frm.cmbLotacao.value != frm.txtcodLotacaoAnterior.value){
				document.all["linhaMotivoDaTrocaLotacao"].style.display = "table-row";
			}
		}
		if (frm.cmbLotacao.value=="164" || frm.cmbLotacao.value=="108" ){
			document.all["linha_depto1"].style.display = "table-row";
			document.all["linha_depto2"].style.display = "table-row";
		}else{
			document.all["linha_depto1"].style.display = "none";
			document.all["linha_depto2"].style.display = "none";
		}
	}
	function mostraMotivoTrocaSituacao(){
		var frm = document.getElementById("frm");
		document.all["linhaMotivoTrocaSituacao"].style.display = "none";
		if (frm.cmbSituacao.value=="I"){
			document.all["linhaMotivoTrocaSituacao"].style.display = "table-row";
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
	
	
		
	function mostraReadaptacao(){
		var frm = document.getElementById("frm");
		
		if (frm.cmbReadaptacao.value == "S"){
			document.getElementById("linhaReadaptacao").style.display = "block";
		}
		if (frm.cmbReadaptacao.value == "N"){
			document.getElementById("linhaReadaptacao").style.display = "none";
		}
	}

    
	
		$(document).ready(function () {
			 $("#txtCep").on("blur", function () {
				var cep = $(this).val();
				if (cep != ""){
					obterEndercoPorCEP(cep);			
				}
			});
		});
		
		var obterEndercoPorCEP = function (numeroCEP) {
			$("#txtLogradouro").val("");
			$("#txtBairro").val("");
			$("#cmbUFResidencia").val("9");
			$("#txtCidade").val("");
			$("#txtComp_endereco").val("");

			var cep = numeroCEP.replace("-", "");
			var url = "https://viacep.com.br/ws/" + cep + "/json/";

			$.getJSON(url, cep)
			 .done(function (endereco) {
				 if (endereco != null) {
					 $("#txtLogradouro").val($.trim(endereco.logradouro));
					 $("#txtBairro").val(endereco.bairro);
					 //$("#cmbUFResidencia").val(endereco.uf);
					 $("#txtComp_endereco").val(endereco.complemento);
					 $("#txtCidade").val(endereco.localidade);
				 }
			 });;
		};
		
		
		
		
		
		function adicionarLinha() {
		  const tabela = document.getElementById("tabelaCursos").getElementsByTagName("tbody")[0];
		  const novaLinha = tabela.rows[0].cloneNode(true);

		  // Limpa os valores
		  novaLinha.querySelectorAll("input").forEach(input => input.value = "");

		  // Adiciona a nova linha
		  tabela.appendChild(novaLinha);

		  // Atualiza todos os names dos inputs e o botão final
		  atualizarIndices();
		}

		function removerLinha(botao) {
		  const linha = botao.parentNode.parentNode;
		  const tabela = document.getElementById("tabelaCursos").getElementsByTagName("tbody")[0];

		  // Só remove se houver mais de uma linha
		  if (tabela.rows.length > 1) {
			linha.remove();
			atualizarIndices();
		  }
		}

		function atualizarIndices() {
		  const tabela = document.getElementById("tabelaCursos").getElementsByTagName("tbody")[0];
		  const linhas = tabela.rows;

		  for (let i = 0; i < linhas.length; i++) {
			const inputs = linhas[i].querySelectorAll("input");

			inputs[0].name = "instituicao" + i;
			inputs[1].name = "curso" + i;
			inputs[2].name = "carga_horaria" + i;
			inputs[3].name = "data_conclusao" + i;

			// Botões
			const btn = linhas[i].querySelector("button");
			if (i === linhas.length - 1) {
			  btn.innerText = "Adicionar";
			  btn.setAttribute("onclick", "adicionarLinha()");
			} else {
			  btn.innerText = "Remover";
			  btn.setAttribute("onclick", "removerLinha(this)");
			}
		  }

		  // Atualiza o hidden que informa o total de cursos
		  document.getElementById("totalCursos").value = linhas.length;
		}
	</script>
   
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 