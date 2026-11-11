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


    strPaginaTitulo = "ColaboradorEscola_cad.asp"
	strValidaAlteracaoLotacao 		= "S"
	strCompartilharDados 			= "S"
    strModulacaoDiscipinarDocente 	= "S"
	strSubmitNivel      			= "" 
	strPagina						= "ColaboradorEscola_cad.asp"
	intCodigo	 					= Trim(Request("txtCodFuncionario"))
	strNomeBotaoFoto				= "Incluir Foto"
	strBloqUsu 						= ""
	strAnoLetivo 					= session("strAnoLetivo")
	strSemestre 					= session("strSemestre")
	intCodEmp          				= Trim(Request.Form("txtCodEmpresa"))
	strUsuarioPortal 				= Trim(Request.Form("txtUsuarioPortal"))
	strStatus						= Trim(Request.Form("optStatus"))
	bloqCampo			= " readonly "
	
	if Trim(Request.form("txtCodFuncionario")) = "" then
		intCodigo 						= Trim(Request("txtCodFuncionario"))
	else
		intCodigo 						= Trim(Request.form("txtCodFuncionario"))
	end if	
	
	intCodigoFuncionalAnterior 		= Trim(Request.Form("txtCodigoFuncionalAnterior"))					
	strnome 						= Trim(Request.Form("txtNomeFuncionario"))
		
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
	strCarregado				= Trim(Request.Form("txtCarregado"))
	
	if intCodEmp = "" then intCodEmp = session("codEmpresa")

	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

	if Trim(Request("BuscarPorFuncional")) = "S" then
	'response.Write "<br>BuscarPorFuncional"
	'response.Write "<br>strCarregado:" & strCarregado
		sql = "SELECT c.* "
		sql = sql & " FROM 	SRH_COLABORADOR C "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " Where CodFuncional = " & intCodFuncional
		sql = sql & " and E.COD_GRUPO = " & session("codGrupo")
		'response.Write(sql)
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	 		= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			IF strCarregado = "" THEN
				intCodigo	 		= rs("Codigo")
				intCodEmp           = rs("Cod_Empresa")
				strnome 			= Trim(Rs("nome"))
				
				' Endereco
				strLogradouro 		= TRIM(rs("Logradouro"))
				strNumero_endereco 	= TRIM(rs("numero_logradouro"))
				strComp_endereco 	= TRIM(rs("Comp_endereco"))
				strBairro 		    = TRIM(rs("Bairro"))
				strCidade	        = TRIM(rs("Cidade"))
				strUfresidencia 	= TRIM(rs("UF"))
				strCep 	            = TRIM(rs("Cep"))
				
				strFoneResidencial  = Trim(Rs("FoneResidencial"))
				strFoneComercial    = Trim(Rs("FoneComercial"))
				strFoneCelular      = Trim(Rs("FoneCelular"))
				carteira_reservista	= Trim(Rs("carteira_reservista"))
				stremail  			= Trim(Rs("email"))
				strEmailCoorporativo= Trim(Rs("email_coorporativo"))
				strpai  			= Trim(Rs("pai"))
				strmae  			= Trim(Rs("mae"))
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
			sql = "SELECT  * "
			sql = sql & " FROM SRH_COLABORADOR "
			sql = sql & " Where codigo = " & request("cd_func")
		end if
		if strcpf<>"" then
			sql = "SELECT  * "
			sql = sql & " FROM SRH_COLABORADOR "
			sql = sql & " Where cpf = '" & strcpf & "'"
		end if
		'response.write sql
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	 		= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional		= Trim(Rs("CodFuncional"))
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
													
				strFoneResidencial  = Trim(Rs("FoneResidencial"))
				strFoneComercial    = Trim(Rs("FoneComercial"))
				strFoneCelular      = Trim(Rs("FoneCelular"))
				carteira_reservista	= Trim(Rs("carteira_reservista"))
				stremail  			= Trim(Rs("email"))
				strpai  			= Trim(Rs("pai"))
				strmae  			= Trim(Rs("mae"))
				strdata_nascimento  = formataDataAP(Trim(Rs("Data_Nascimento")))
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
				intCodFuncional		= Trim(Rs("CodFuncional"))
				strCPF  			= formataCPFap(Trim(Rs("CPF")))
				
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
		
		sql = "SELECT  * "
		sql = sql & " FROM SRH_COLABORADOR "
		if request("cd_func")<>"" then
			sql = sql & " Where Codigo = " & request("cd_func") 
		end if
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	 		= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			IF trim(strCarregado) = "" THEN
					
				intCodigo	 		= rs("Codigo")
				intCodEmp           = rs("Cod_Empresa")
				strnome 			= Trim(Rs("nome"))
				
				' Endereco
				strLogradouro 		= TRIM(rs("Logradouro"))
				strNumero_endereco 	= TRIM(rs("numero_logradouro"))
				strComp_endereco 	= TRIM(rs("Comp_endereco"))
				strBairro 		    = TRIM(rs("Bairro"))
				strCidade	        = TRIM(rs("Cidade"))
				strUfresidencia 	= TRIM(rs("UF"))
				strCep 	            = TRIM(rs("Cep"))
				
				strCNH 	           	  = TRIM(rs("CNH"))
				strCategoriaCNH 	  = TRIM(rs("CategoriaCNH"))
				strFoneResidencial  = Trim(Rs("FoneResidencial"))
				strFoneComercial    = Trim(Rs("FoneComercial"))
				strFoneCelular      = Trim(Rs("FoneCelular"))
				carteira_reservista	= Trim(Rs("carteira_reservista"))
				stremail  			= Trim(Rs("email"))
				strEmailCoorporativo= Trim(Rs("email_coorporativo"))
				strpai  			= Trim(Rs("pai"))
				strmae  			= Trim(Rs("mae"))
				strdata_nascimento  = formataDataAP(Trim(Rs("Data_Nascimento")))
				strestado_civil  	= Trim(Rs("estado_civil"))
				strconjuge  		= Trim(Rs("conjuge"))
				strnumero_filhos  	= Trim(Rs("numero_filhos"))
				strrg  				= Trim(Rs("rg"))
				strorgao_expedidor  = Trim(Rs("orgaoExp"))
				strtitulo_eleitor  	= Trim(Rs("titulo_eleitor"))
				strcarteira_trabalho= Trim(Rs("carteira_trabalho"))
				strpis  			= Trim(Rs("pis"))
				strSexo 			= Trim(Rs("Sexo"))
				intCodFuncional		= Trim(Rs("CodFuncional"))
				strCPF  			= formataCPFap(Trim(Rs("CPF")))
				
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
				strCarregado		= "JACARREGOUDOBANCO"
			ELSE
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
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
		sql = "SELECT  * "
		sql = sql & " FROM SRH_COLABORADOR "
		sql = sql & " Where codigo = " & intCodigo
		'response.write sql
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			
			IF strCarregado = "" THEN
				bolColaborador		=  true
				strUsuarioPortal	= Trim(Rs("codigo_SEG_USUARIOS_SISTEMA"))
				strnome 			= Trim(Rs("nome"))
				
				' Endereco
				strLogradouro 		= TRIM(rs("Logradouro"))
				strNumero_endereco 	= TRIM(rs("numero_logradouro"))
				strComp_endereco 	= TRIM(rs("Comp_endereco"))
				strBairro 		    = TRIM(rs("Bairro"))
				strCidade	        = TRIM(rs("Cidade"))
				strUfresidencia 	= TRIM(rs("UF"))
				strCep 	            = TRIM(rs("Cep"))
				
				strCNH 	           	= TRIM(rs("CNH"))
				strCategoriaCNH 	= TRIM(rs("CategoriaCNH"))
				strFoneResidencial  = Trim(Rs("FoneResidencial"))
				strFoneComercial    = Trim(Rs("FoneComercial"))
				strFoneCelular      = Trim(Rs("FoneCelular"))
				carteira_reservista	= Trim(Rs("carteira_reservista"))
				stremail  			= Trim(Rs("email"))
				strpai  			= Trim(Rs("pai"))
				strmae  			= Trim(Rs("mae"))
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
				intCodFuncional		= Trim(Rs("CodFuncional"))
				
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
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
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		else
		
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			strFoto = "Foto"
			
		end if 
		rs.close
				
	end if 

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
             	<form method="post" id="frm" name="frm" action="ColaboradorEscola_cad.asp">	
                <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >
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
                                                  <td><input name="txtcpf" type="text" <%=bloqCampo%> class="form-control" id="txtcpf" size="10" maxlength="14" value="<%=strCPF%>" onkeypress="return formataCampo(this,5,14)">&nbsp;<strong>*</strong>
                                                                                                   
                                                  </td>
                                                  <td width="15%">Matrícula Funcional:</td>
                                                  <td width="26%">
                                                  <input <%=bloqCampo%> name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">&nbsp;<strong>*</strong>
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
                                                      <td align="center"><!--input type="button" name="cmdIncluir2" style="cursor:hand"   value="<%'=strNomeBotaoFoto%>" class="btn btn-success" <%'=strDesabilitaAlterar%> onclick="foto('<%'=intCodAluno%>')" /--></td>
                                                    </tr>
                                                  </table></td>
                                                </tr>
                                              <tr>
                                                <td width="9%">Nome:</td>
                                                <td colspan="3">
                                                <input name="txtCodFuncionario" value="<%=intCodigo%>" type="hidden" id="txtCodFuncionario" >
                                                <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >

                                                <input <%=bloqCampo%>  name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="70" maxlength="70" value="<%=strNome%>">&nbsp;<strong>*</strong>
                                                <button class="btn btn-success" onclick="Consulta('ColaboradorEscola_con.asp?PaginaOrigem=colaboradorEscola_cad')" type="button"><i class="fa fa-search"></i></button>                                                </td>
                                              </tr>
                                              <tr>
                                                <td>Sexo:</td>
                                                <td><select name="cboSexo" class="form-control" id="cboSexo">
                                                  <option value="0">Selecione...</option>
                                                  <option value="M" <%if strSexo = "M" then response.Write("selected") %>>Masculino</option>
                                                  <option value="F" <%if strSexo = "F" then response.Write("selected") %>>Feminino</option>
                                                </select></td>
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
                                                <td>Fone (Res):</td>
                                                <td><input name="txtFoneResidencial" type="text" class="form-control" id="txtFoneResidencial" onkeypress="mascara(this,telefone)" value="<%=strFoneResidencial%>" size="20" maxlength="14"></td>
                                                <td>Celular:</td>
                                                <td><input name="txtFoneCelular" type="text" class="form-control" id="txtFoneCelular" onkeypress="mascara(this,telefone)" value="<%=strFoneCelular%>" size="20" maxlength="14">&nbsp;<strong>*</strong></td>
                                              </tr>
                                              <tr>
                                                <td>Fone (Com):</td>
                                                <td><input name="txtFoneComercial" type="text" class="form-control" id="txtFoneComercial" onkeypress="mascara(this,telefone)" value="<%=strFoneComercial%>" size="20" maxlength="14"></td>
                                                <td>E-mail:</td>
                                                <td colspan="2"><input name="txtemail" type="text" class="form-control" id="txtemail" size="40" maxlength="70" value="<%=stremail%>" /></td>
                                              </tr>
                                        </table>
									<!-- fim Conteudo -->
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
                                            <td width="9%">Logradouro: </td>
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
                                            <td width="28%">
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
                                            <td width="24%">
                                              <input name="txtCidade" type="text" class="form-control" id="txtCidade" size="40" maxlength="40" value="<%=strCidade%>" onkeypress="return formataCampo(this, 1, 40)" />
                                            </td>
                                            <td width="5%">UF:</td>
                                            <td width="19%">
                                              <!--#include file="../includes/inc_cmdUFResidencia.asp" -->
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
                                
                                 <!-- Dados da Documentos -->
                                <thead>
                                <tr>
                                    <td width="33"><a href="javascript:showTr(5)">[+]</a></td>
                                    <td width="997">Documentos</td>
                                </tr>
                                </thead>
                                <tr id="tr5">
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
                
                </form>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script src="../../js/js_funcoes_gerais.js"></script>
    <script src="json/jquery-1.7.1/jquery-1.7.1.min.js"></script>
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
                    if (campo.value!=""){
						frm.txtCarregado.value="";
						frm.LocalizarMatricula.value="";
						frm.action="ColaboradorEscola_cad.asp?porCPF=S"
                        frm.submit();	
					}
                        
                }
                        
            }
        }
	
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if (acao=="A"){
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
	
			frm.action= "ColaboradorEscola_cod.asp?acao="+acao;
			frm.submit();
			return true;

		}
		
	}
	
	function localizarPorCodFuncional(){
		var frm = document.getElementById("frm");
		frm.txtCarregado.value="";
		frm.action = "ColaboradorEscola_cad.asp?BuscarPorFuncional=S"
		frm.submit();
	}
	
   </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 