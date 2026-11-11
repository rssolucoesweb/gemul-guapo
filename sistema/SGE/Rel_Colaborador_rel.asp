<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> - Ficha Individual do Aluno</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina
	
	strTituloRelatorio  	= "Ficha Individual Colaborador"
	intCodEmpresaUsuario    = request.Form("cmdEmpresaUsuario")
	intEmpresasDoGrupo		= Trim(Request("txtEmpresasDoGrupo"))
	strCodFunc				= Trim(Request("txtCodFunc"))
	
	if strCodFunc = "" then
		strCodFunc	=	Trim(Request.form("chkFunc"))
	end if

	if trim(strCodFunc) <> "" then

		sql = "SELECT SRH_COLABORADOR.codigo, SRH_COLABORADOR.cod_empresa, SRH_COLABORADOR.nome, data_admissao, "
		sql = sql & " Logradouro, numero_logradouro, Comp_Endereco, "
 		sql = sql & " Bairro, Cidade, cep, "
		sql = sql & " FoneResidencial, FoneComercial, FoneCelular, carteira_reservista, "
		sql = sql & " email, pai, mae, data_nascimento, naturalidade, nacionalidade, "
		sql = sql & " estado_civil, conjuge, numero_filhos, cpf, rg, orgaoexp, "
		sql = sql & " titulo_eleitor, carteira_trabalho, pis, sexo, SRH_COLABORADOR.Situacao, Datafastamento, "
		sql = sql & " Cargo, Funcao, Obs, "
		sql = sql & " codigo_SEG_USUARIOS_SISTEMA, CodFuncional, Cat.Desc_Categoria, GRA.DESCRICAO as GrauInstrucao, "
		sql = sql & " DEP.DESCRICAO as Departameto, SCF_UF.Sigla as UF"
		sql = sql & " From SRH_COLABORADOR "
		sql = sql & " inner JOIN SRH_CATEGORIA Cat ON Cat.Cod_Categoria = SRH_COLABORADOR.CodCategoria "
		sql = sql & " inner JOIN SCA_GRAUINSTRUCAO GRA ON GRA.CODIGO = SRH_COLABORADOR.CodGrauInstrucao "
		sql = sql & " inner JOIN SEG_DEPARTAMENTO DEP ON DEP.CODIGO = SRH_COLABORADOR.CodDepartamento "
		sql = sql & " inner JOIN SCF_UF ON SCF_UF.CODIGO = SRH_COLABORADOR.uf "
		sql = sql & " Where 1=1"
		
		if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
			sql = sql & " And SRH_COLABORADOR.Cod_empresa in (" & intCodEmpresaUsuario & ")"
		else
			sql = sql & " And SRH_COLABORADOR.Cod_empresa in (" & intEmpresasDoGrupo & ")"
		end if   
			
		sql = sql & " And SRH_COLABORADOR.codigo in (" & strCodFunc & ")"
		sql = sql & " Order by SRH_COLABORADOR.nome"
		rs.open sql, cnn
		if rs.eof = false then
		
			while not rs.eof
			
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
	
				strFoneResidencial  = Trim(Rs("FoneResidencial"))
				strFoneComercial    = Trim(Rs("FoneComercial"))
				strFoneCelular      = Trim(Rs("FoneCelular"))
				carteira_reservista	= Trim(Rs("carteira_reservista"))
				stremail  			= Trim(Rs("email"))
				strpai  			= Trim(Rs("pai"))
				strmae  			= Trim(Rs("mae"))
				strdata_nascimento  = formataDataAP(Trim(Rs("Data_Nascimento")))
				strnaturalidade  	= Trim(Rs("naturalidade"))
				strnacionalidade  	= Trim(Rs("nacionalidade"))
				strestado_civil  	= Trim(Rs("estado_civil"))
				strconjuge  		= Trim(Rs("conjuge"))
				strnumero_filhos  	= Trim(Rs("numero_filhos"))
				strcpf  			= Trim(Rs("cpf"))
				strrg  				= Trim(Rs("rg"))
				strorgao_expedidor  = Trim(Rs("orgaoExp"))
				strtitulo_eleitor  	= Trim(Rs("titulo_eleitor"))
				strcarteira_trabalho= Trim(Rs("carteira_trabalho"))
				strpis  			= Trim(Rs("pis"))
				strSexo 			= Trim(Rs("Sexo"))
				strSituacao			= Trim(Rs("Situacao"))	
				strDatafastamento	= Trim(Rs("Datafastamento"))
				intCodCategoria		= Trim(Rs("Desc_Categoria"))	
				intCodGrauInstrucao	= Trim(Rs("GrauInstrucao"))
				strCargo			= Trim(Rs("Cargo"))
				strFuncao			= Trim(Rs("Funcao"))
				intCodFuncional		= Trim(Rs("CodFuncional"))
				intCodDepartamento	= Trim(Rs("Departameto"))
				strObs				= Trim(Rs("Obs"))
				
				if strSexo = "M" then strSexo = "Masculino"
				if strSexo = "F" then strSexo = "Feminino"
				
				if strestado_civil = "S" then strestado_civil = "Solteiro" 
				if strestado_civil = "C" then strestado_civil = "Casado" 
				if strestado_civil = "V" then strestado_civil = "Vi&uacute;vo"
				if strestado_civil = "D" then strestado_civil = "Desquitado"
				if strestado_civil = "O" then strestado_civil = "Outros"
				
				if strSituacao = "A" then strSituacao = "Ativo"
  				if strSituacao = "I" then strSituacao = "Inativo"
				
				strFoto = "Foto"

				sql = "SELECT arquivo "
				sql = sql & " FROM 	SRH_COLABORADOR_FOTO"
				sql = sql & " Where COD_EMPRESA = " & session("codEmpresa")
				sql = sql & " And 	codColaborador = " & intCodigo
				rsAux.open sql, cnn
				if rsAux.eof = false then
					strCaminhoFoto = session("strCaminhoRaiz") & "/fotoColaborador/" & session("codEmpresa") & "/" & rsAux("arquivo")
					strFoto =  "<img src='" & strCaminhoFoto & "' width='120' height='130'>"
					strNomeBotaoFoto	= "Alterar Foto"
				end if
				rsAux.close		
				
				%>
				<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="2"><hr size="1" color="#999999"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodigo%>" maxlength="10"></td>
				  </tr>
				  <tr>
					<td width="457" height="20" bgcolor="#EEEEEE" class="texto1"><li><strong>Dados do Colaborador </strong></li></td>
					<td width="246" height="20" bgcolor="#EEEEEE" class="texto1" align="right">Situa&ccedil;&atilde;o:<strong>&nbsp;<%=strSituacao%></strong>&nbsp;&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="2" class="texto1" >
						<!-- INICIO CAMPO - DADOS PESSOAIS-->
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						  <tr>
							<td width="18%" class="texto1"><span class="TextoForm">Nome:</span></td>
							<td width="46%" class="texto1"><strong><%=strnome%></strong></td>
							<td colspan="2" rowspan="8" class="texto1" align="center"><table width="120" height="130" border="0" cellpadding="0" cellspacing="0">
							  <tr>
								<td bgcolor="#FFFFFF" align="center" class="text"><%=strFoto%></td>
							  </tr>
							</table></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Data Nasc.:</span></td>
							<td class="texto1"><strong><%=strdata_nascimento%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Sexo:</span></td>
							<td class="texto1"><strong><%=strSexo%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Estado Civil:</span></td>
							<td class="texto1"><strong><%=strestado_civil%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Telefone:</span></td>
							<td class="texto1"><strong><%=strFoneResidencial%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Dt. Admiss&atilde;o</span></td>
							<td class="texto1"><strong><%=strdata_admissao%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Comercial:</span></td>
							<td class="texto1"><strong><%=strFoneComercial%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Celular:</span></td>
							<td class="texto1"><strong><%=strFoneCelular%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Naturalidade:</span></td>
							<td class="texto1"><strong><%=strnaturalidade%></strong></td>
							<td width="17%" class="texto1"><span class="TextoForm">Nacionalidade:</span></td>
							<td width="19%" class="texto1"><strong><%=strnacionalidade%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">E-mail:</span></td>
							<td class="texto1"><strong><%=stremail%></strong></td>
							<td class="texto1">&nbsp;</td>
							<td class="texto1">&nbsp;</td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Dt. Afastamento:</span></td>
							<td class="texto1"><strong><%=strDatafastamento%></strong></td>
							<td class="texto1"><span class="TextoForm">Categoria:</span></td>
							<td class="texto1"><strong><%=intCodCategoria%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Grau Instru&ccedil;&atilde;o: </span></td>
							<td class="texto1"><strong><%=intCodGrauInstrucao%></strong></td>
							<td class="texto1"><span class="TextoForm">Cargo</span></td>
							<td class="texto1"><strong><%=strCargo%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Fun&ccedil;&atilde;o:</span></td>
							<td class="texto1"><strong><%=strFuncao%></strong></td>
							<td class="texto1"><span class="TextoForm">Departamento:</span></td>
							<td class="texto1"><strong><%=intCodDepartamento%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">C&oacute;digo Funcional </span></td>
							<td class="texto1"><strong><%=intCodFuncional%></strong></td>
							<td class="texto1"><span class="TextoForm">Obs:</span></td>
							<td class="texto1"><strong><%=strObs%></strong></td>
						  </tr>
						</table>
						<!-- FIM CAMPO - DADOS PESSOAIS-->			</td>
				  </tr>
				  <tr>
					<td colspan="2"><hr size="1" color="#999999"></td>
				  </tr>
				  <tr>
					<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Endere&ccedil;o</strong></li></td>
					</tr>
				  <tr>
					<td colspan="2" class="texto1" >
						<!-- INICIO CAMPO - DADOS ENDEREÇO-->
						<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosEndereco">
						  <tr>
							<td width="18%" class="texto1">&nbsp;Logradouro: </td>
							<td width="46%" class="texto1"><strong><%=strLogradouro%></strong></td>
							<td width="17%" class="texto1">&nbsp;N&uacute;mero:</td>
							<td width="19%" class="texto1"><strong><%=strNumero_endereco%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"> &nbsp;Complemento:</td>
							<td class="texto1"><strong><%=strComp_endereco%></strong></td>
							<td class="texto1">&nbsp;CEP:</td>
							<td class="texto1"><strong><%=strCep%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1">&nbsp;Bairro:</td>
							<td class="texto1"><strong><%=strBairro%></strong></td>
							<td class="texto1">&nbsp;</td>
							<td class="texto1">&nbsp;</td>
						  </tr>
						  <tr>
							<td class="texto1">&nbsp;Cidade:</td>
							<td class="texto1"><strong><%=strCidade%></strong></td>
							<td class="texto1">&nbsp;UF:</td>
							<td class="texto1"><strong><%=strUfresidencia%></strong></td>
						  </tr>
						</table>
						<!-- FIM CAMPO - DADOS ENDEREÇO-->			</td>
				  </tr>
				  <tr>
					<td colspan="2"><hr size="1" color="#999999"></td>
				  </tr>
				  <tr>
					<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Filia&ccedil;&atilde;o</strong></li></td>
					</tr>
				  <tr>
					<td colspan="2" class="texto1" >
						<!-- INICIO CAMPO - DADOS FAMILIARES-->
						<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosFamiliares">
						  <tr>
							<td width="18%" class="texto1">&nbsp;Pai: </td>
							<td width="46%" class="texto1"><strong><%=strpai%></strong></td>
							<td width="17%" class="texto1">&nbsp;</td>
							<td width="19%" class="texto1">&nbsp;</td>
						  </tr>
						  <tr>
							<td class="texto1">&nbsp;M&atilde;e: </td>
							<td class="texto1"><strong><%=strmae%></strong></td>
							<td class="texto1">&nbsp;</td>
							<td class="texto1">&nbsp;</td>
						  </tr>
						</table>
						<!-- FIM CAMPO - DADOS FAMILIARES-->			</td>
				  </tr>
				  <tr>
					<td colspan="2"><hr size="1" color="#999999"></td>
				  </tr>
				  <tr>
					<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1"  onClick="return dadosDocumentos()"><li><strong>Dados Familiar</strong></li></td>
					</tr>
				  <tr>
					<td colspan="2" class="texto1" >
						<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
						<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosDocumentos">
						  <tr>
							<td width="18%" class="texto1">&nbsp;<span class="TextoForm">C&ocirc;njuge:</span>: </td>
							<td width="47%" class="texto1"><strong><%=strconjuge%></strong></td>
							<td width="16%" class="texto1">&nbsp;<span class="TextoForm">N&ordm;. Filhos: </span>:</td>
							<td width="19%" class="texto1"><strong><%=strnumero_filhos%></strong></td>
						  </tr>
						</table>
						<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
				  </tr>
				  <tr>
					<td colspan="2"><hr size="1" color="#999999"></td>
				  </tr>
				  <tr>
					<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1"><li><span class="TextoForm"><strong>Documentos</strong></span></li></td>
					</tr>
				  <tr>
					<td colspan="2" class="texto1" >
						<!-- INICIO CAMPO - DADOS ESCOLARES-->
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						  <tr>
							<td width="18%" class="texto1">&nbsp;<span class="TextoForm">CPF:</span></td>
							<td width="47%" class="texto1"><strong><%=strcpf%></strong></td>
							<td width="16%" class="texto1"><span class="TextoForm">Titulo:</span></td>
				
							<td width="19%" class="texto1"><strong><%=strtitulo_eleitor%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Cart. Reservista: </span></td>
							<td class="texto1"><strong><%=carteira_reservista%></strong></td>
							<td class="texto1"><span class="TextoForm">Identidade:</span></td>
							<td class="texto1"><strong><%=strrg%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Org&atilde;o Exp.:</span></td>
							<td class="texto1"><strong><%=strorgao_expedidor%></strong></td>
							<td class="texto1"><span class="TextoForm">PIS</span></td>
							<td class="texto1"><strong><%=strpis%></strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><span class="TextoForm">Cart. Trabalho</span></td>
							<td class="texto1"><strong><%=strcarteira_trabalho%></strong></td>
							<td class="texto1">&nbsp;</td>
							<td class="texto1">&nbsp;</td>
						  </tr>
						</table>
						<!-- FIM CAMPO - DADOS ESCOLARES-->			</td>
				  </tr>
				  <tr>
					<td colspan="2"><hr size="1" color="#999999"></td>
				  </tr>
				  <tr>
					<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Acesso ao Sistema para lan&ccedil;amentos de notas</strong></li></td>
					</tr>
				  <tr>
					<td colspan="2" class="texto1" >
						<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						  <tr>
							<td width="18%" class="texto1"><span class="TextoForm">Login</span>: </td>
							<td width="47%" class="texto1"><strong><%=strUsuarioPortal%></strong></td>
							<td width="16%" class="texto1">&nbsp;</td>
							<td width="19%" class="texto1">&nbsp;</td>
						  </tr>
						</table>
						<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
				  </tr>
				  <tr>
					<td colspan="2"><hr size="1" color="#999999"></td>
				  </tr>
				</table>
				<%
				rs.movenext
				if not rs.eof then
					%>
					<pre></pre>				
					<%			
				end if
			
			wend
		end if 
		rs.close
	else
		%>
		<script>
			alert("Colaborador não foi encontrato, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	%>
	<script>
		aguarde.style.display="none";
	</script>
</body>
</html>