<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	
	'Dados da Publicação
	intCodigo					= Trim(Request.Form("txtCodigo"))
	intCodLocalizacaoGeografica = Trim(Request.Form("cmbLocalizacaoGeografica"))
	intCodTipoPublicacao		= Trim(Request.Form("cmbTipoPublicacao"))
	intCodAutoria				= Trim(Request.Form("cmbAutoria"))
	intCodEditora				= Trim(Request.Form("cmbEditora"))
	intCodCDU 					= Trim(Request.Form("cmbCDU"))
	strCodCutter				= Trim(Request.Form("txtCodCutter"))
	
	intCodPeriodicidade			= Trim(Request.Form("cmbPeriodicidade"))
	strInstituicao				= Trim(Request.Form("txtInstituicao"))
	strOrientador				= Trim(Request.Form("txtOrientador"))
	strCurso					= Trim(Request.Form("txtCurso"))

	strMesReferencia			= Trim(Request.Form("txtMesReferencia"))
	strSerie					= Trim(Request.Form("txtSerie"))
	strNota						= Trim(Request.Form("txtNota"))
	intCodTipoAquisicao			= Trim(Request.Form("cmbTipoAquisicao"))
	strNumeroNotaFiscal			= Trim(Request.Form("txtNumeroNotaFiscal"))
	strFornecedor				= Trim(Request.Form("txtFornecedor"))


	intCodGenero				= Trim(Request.Form("cmbGenero"))
	strTitulo 					= Trim(Request.Form("txtTitulo"))
	strSubTitulo 				= Trim(Request.Form("txtSubTitulo"))
	strLocalPublicacao			= Trim(Request.Form("txtLocalPublicacao"))
	intAno						= Trim(Request.Form("txtAno"))
	intCodEdicao				= Trim(Request.Form("cmbEdicao"))
	strVolume					= Trim(Request.Form("txtVolume"))
	strISBN						= Trim(Request.Form("txtISBN"))
	strISSN						= Trim(Request.Form("txtISSN"))
	strDataInclusao				= FORMATADATABD(Trim(Request.Form("txtDataInclusao")))
	strEtiqueta					= Trim(Request.Form("cmbEtiqueta"))
	intPaginas					= Trim(Request.Form("txtPaginas"))
	strOrigem					= Trim(Request.Form("txtOrigem"))
	strDestino					= Trim(Request.Form("txtDestino"))
	srtResumo					= Trim(Request.Form("txtResumo"))

	'Dados Complementares
	strDataContrato				= FORMATADATABD(Trim(Request.Form("txtDataContrato")))
	strContato					= Trim(Request.Form("txtContato"))
	strEndereco					= Trim(Request.Form("txtEndereco"))
	strBairro					= Trim(Request.Form("txtBairro"))
	strCidade					= Trim(Request.Form("txtCidade"))
	strUF						= Trim(Request.Form("txtUF"))
	strCep						= Trim(Request.Form("txtCep"))
	strNumero					= Trim(Request.Form("txtNumero"))
	strEmail					= Trim(Request.Form("txtEmail"))
	strBloqueiaUltimoExemplar 	= Trim(Request.Form("cmbBloqueiaUltimoExemplar"))
	
	
	'Dados Exemplares
	intQtdeExemplares		= Trim(Request.Form("txtQtdeExemplares"))

	
	intCodAutor				= Trim(Request.Form("txtCodAutor"))
	intCodPalavra			= Trim(Request.Form("txtCodPalavra"))
	
	if intCodAutor <> "" then
		vetAutores	= split(intCodAutor,",")
	end if
		
	if intCodPalavra <> "" then
		vetPalavraChave	= split(intCodPalavra,",")
	end if
			
	if acao="I" then
		
	
	strMensagem = "Registro Salvo com sucesso..."

	    	MesmoCodigoPublicacao = False
		sql = " SELECT COD_PUBLICACAO FROM SCB_PUBLICACAO "
		sql = sql & " WHERE COD_PUBLICACAO = " & intCodigo
		sql = sql & " and cod_empresa = " & intCodEmp
		rs.open sql, cnn
		if not RS.EOF then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Registro já cadastrado. Verifique!");
				window.location="Publicacao_cad.asp?CodPublicacao=<%=intCodPublicacao%>";
			</script>
			<%
			response.end
	    else
	        MesmoCodigoPublicacao = true				
		end if
		rs.close
	
		if MesmoCodigoPublicacao = true then
		    if strVolume = "" then strVolume = "0"
		    if intCodEdicao = "" then intCodEdicao = "0"
		    if intAno = "" then intAno = "0"
		    if strSubTitulo = "" then strSubTitulo = "0"
			sql = " SELECT COD_PUBLICACAO FROM SCB_PUBLICACAO "
			sql = sql & " WHERE TITULO = '" & strSubTitulo & "'"
			sql = sql & " AND ANOPUBLICACAO = '" & intAno & "'"
			sql = sql & " AND EDICAOPUBLICACAO = '" & intCodEdicao & "'"
			sql = sql & " AND VOLUMEPUBLICACAO = '" & strVolume & "'"
			rs.open sql, cnn
			if not RS.EOF then
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: Publicação já Cadastrada! Verifique.");
					window.location="Publicacao_cad.asp?CodPublicacao=<%=intCodPublicacao%>";
				</script>
				<%
				response.end
			end if
			rs.close
		end if
		intCodigo = ""
		if intCodigo = ""  then

			sql = "SELECT Max(Cod_Publicacao) as MaiorCodigo" 
			sql = sql & " FROM SCB_PUBLICACAO"
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
								
			sql = "Insert Into SCB_PUBLICACAO( Cod_Empresa,  Cod_Publicacao, Cod_LocalizacaoGeografica, Cod_TipoPublicacao, Cod_Autoria, Cod_Editora, Cod_CDU, Cod_cutter, Cod_Periodicidade, "
			sql = sql & " Instituicao, Orientador, Curso, MesReferencia, Serie, Nota, CodTipoAquisicao, NumeroNotaFiscal, Fornecedor, CodGenero, "
			sql = sql & " Titulo, SubTitulo, LocalPublicacao, AnoPublicacao, EdicaoPublicacao, VolumePublicacao, ISBN, ISSN, DataInclusao, Etiqueta, "
			sql = sql & " NumPaginas, Origem, Destino, Resumo, DataContrato, Contato, Endereco, Bairro, CIDADE, UF, CEP, Numero, Email, BloqueiaUltimoExemplar)"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & intCodLocalizacaoGeografica & ","
			sql = sql & "" & intCodTipoPublicacao & ","
			sql = sql & "" & intCodAutoria & ","
			sql = sql & "" & intCodEditora & ","
			sql = sql & "'" & intCodCDU & "',"

			if 	strCodCutter  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strCodCutter & "',"
			end if

			if 	intCodPeriodicidade  = "0" then
				sql = sql & "null,"
			else
				sql = sql & "" & intCodPeriodicidade & ","
			end if
				
			if 	strInstituicao  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strInstituicao & "',"
			end if
			
			if 	strOrientador  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strOrientador & "',"
			end if
			
			if 	strCurso  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strCurso & "',"
			end if

			if 	strMesReferencia  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strMesReferencia & "',"
			end if
			
			if 	strSerie  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strSerie & "',"
			end if
			
			if 	strNota  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strNota & "',"
			end if
			
			if 	intCodTipoAquisicao  = "0" then
				sql = sql & "null,"
			else
				sql = sql & "" & intCodTipoAquisicao & ","
			end if
			
			if 	strNumeroNotaFiscal  = "" then
				sql = sql & "null,"
			else
				sql = sql & "" & strNumeroNotaFiscal & ","
			end if
			
			if 	strFornecedor  = "" then
				sql = sql & "null,"
			else
				sql = sql & "" & strFornecedor & ","
			end if
			
			if 	intCodGenero  = "0" then
				sql = sql & "null,"
			else
				sql = sql & "" & intCodGenero & ","
			end if
			
			if 	strTitulo  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strTitulo & "',"
			end if
			
			if 	strSubTitulo  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strSubTitulo & "',"
			end if
			
			if 	strLocalPublicacao  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strLocalPublicacao & "',"
			end if
			
			if 	intAno  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & intAno & "',"
			end if
			
			if 	intCodEdicao  = "" then
				sql = sql & "null,"
			else
				sql = sql & "" & intCodEdicao & ","
			end if
		
			if 	strVolume  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strVolume & "',"
			end if
			
			if 	strISBN  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strISBN & "',"
			end if
			
			if 	strISSN 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strISSN & "',"
			end if
		
			if 	strDataInclusao 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strDataInclusao & "',"
			end if
			
			if 	strEtiqueta 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strEtiqueta & "',"
			end if
			
			if 	intPaginas 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & intPaginas & "',"
			end if
			
			if 	strOrigem 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strOrigem & "',"
			end if
			
			if 	strDestino  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strDestino & "',"
			end if
			
			if 	srtResumo  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & srtResumo & "',"
			end if
			
			if 	strDataContrato  = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strDataContrato & "',"
			end if
			
			if 	strContato 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strContato & "',"
			end if
			
			if 	strEndereco 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strEndereco & "',"
			end if
			
			if 	strBairro 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strBairro & "',"
			end if
			
			if 	strCidade 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strCidade & "',"
			end if
			
			if 	strUF 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strUF & "',"
			end if
			
			if 	strCep 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "" & strCep & ","
			end if
			
			if 	strNumero 	 = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strNumero & "',"
			end if
			
			if 	strEmail 	 = "" then
				sql = sql & "null, "
			else
				sql = sql & "'" & strEmail & "',"
			end if
			
			if 	strBloqueiaUltimoExemplar 	 = "" then
				sql = sql & "null)"
			else
				sql = sql & "'" & strBloqueiaUltimoExemplar & "')"
			end if
			cnn.execute sql
			GravarLog sql
			
			'Grava os Autores
			for i=0 to ubound(vetAutores)
			
				sql = "SELECT Max(Codigo) as MaiorCodigo" 
				sql = sql & " FROM SCB_PUBLICACAOAUTORES"
				rs.open sql, cnn
				
				if not RS.EOF then
				
					if rs("MaiorCodigo") <> "" then
						intCodNovo = cstr(rs("MaiorCodigo")) + 1
						intCodPublicacaoAutor = intCodNovo
					else
						intCodPublicacaoAutor = 1	
					end if
				
				end if
				rs.close
			
				sql = "INSERT INTO SCB_PUBLICACAOAUTORES (Codigo, Cod_Publicacao, Cod_Autor)"
				sql = sql & " Values (" 
				sql = sql & "" & intCodPublicacaoAutor & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "" & vetAutores(i) & ")"
				cnn.execute sql
			GravarLog sql
			next
			
			'Grava Palvra Chave
			for i=0 to ubound(vetPalavraChave)
			
				sql = "SELECT Max(Codigo) as MaiorCodigo" 
				sql = sql & " FROM SCB_PUBLICACAOPALAVRACHAVE"
				rs.open sql, cnn
				
				if not RS.EOF then
				
					if rs("MaiorCodigo") <> "" then
						intCodNovo = cstr(rs("MaiorCodigo")) + 1
						intCodPalavra = intCodNovo
					else
						intCodPalavra = 1	
					end if
				
				end if
				rs.close
			
				sql = "INSERT INTO SCB_PUBLICACAOPALAVRACHAVE (codigo, Cod_Publicacao, Cod_PalavraChave)"
				sql = sql & " Values (" 
				sql = sql & "" & intCodPalavra & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "" & vetPalavraChave(i) & ")"
				cnn.execute sql
			GravarLog sql
			next
		end if
				
		'Grava Exemplares
		if intQtdeExemplares = "" then intQtdeExemplares = 1

		intNumExemplar = 0
		'busca o numero de exemplar
		sql = "SELECT Max(numero_exemplar) as MaiorNumeroExemplar" 
		sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES"
		sql = sql & " WHERE COD_PUBLICACAO = " & intCodigo
		rs.open sql, cnn
		if not RS.EOF then
			if rs("MaiorNumeroExemplar") <> "" then
				intNumExemplar = cInt(rs("MaiorNumeroExemplar"))
			end if
		end if
		rs.close	

		
		for i=1 to intQtdeExemplares
			sql = "SELECT Max(Cod_PublicacaoExemplares) as MaiorCodigo" 
			sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES"
			rs.open sql, cnn
			if not RS.EOF then
			
				if rs("MaiorCodigo") <> "" then
					intCodNovo = cstr(rs("MaiorCodigo")) + 1
					intCodPublicacaoExemplares = intCodNovo
				else
					intCodPublicacaoExemplares = 1	
				end if
			
			end if
			rs.close		
		
			intNumExemplar = cInt(intNumExemplar) + 1
			
			sql = "INSERT INTO SCB_PUBLICACAOEXEMPLARES (Cod_Publicacao, Cod_PublicacaoExemplares, Cod_LocalizacaoGeografica, numero_exemplar, Cod_SituacaoExemplar)"
			sql = sql & " Values (" 
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & intCodPublicacaoExemplares & ","
			sql = sql & "" & intCodLocalizacaoGeografica & ","
			sql = sql & "" & intNumExemplar & ","
			sql = sql & "1)"
			cnn.execute sql
			GravarLog sql
		next

			
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCB_PUBLICACAO Set"
		sql = sql & " Cod_LocalizacaoGeografica = " & intCodLocalizacaoGeografica & ","
		sql = sql & " Cod_TipoPublicacao = " & intCodTipoPublicacao & ","
		sql = sql & " Cod_Autoria = " & intCodAutoria & ","
		sql = sql & " Cod_Editora = " & intCodEditora & ","
		sql = sql & " Cod_CDU = '" & intCodCDU & "',"

		if 	strCodCutter  = "" then
			sql = sql & " Cod_Cutter = null,"
		else
			sql = sql & " Cod_Cutter = '" & strCodCutter & "',"
		end if
		
		if 	intCodPeriodicidade  = "" then
			sql = sql & " Cod_Periodicidade = null,"
		else
			sql = sql & " Cod_Periodicidade = " & intCodPeriodicidade & ","
		end if
			
		if 	strInstituicao  = "" then
			sql = sql & " Instituicao = null,"
		else
			sql = sql & " Instituicao = '" & strInstituicao & "',"
		end if
		
		if 	strOrientador  = "" then
			sql = sql & " Orientador = null,"
		else
			sql = sql & " Orientador = '" & strOrientador & "',"
		end if
		
		if 	strCurso  = "" then
			sql = sql & " Curso = null,"
		else
			sql = sql & " Curso = '" & strCurso & "',"
		end if

		if 	strMesReferencia  = "" then
			sql = sql & " MesReferencia = null,"
		else
			sql = sql & " MesReferencia = '" & strMesReferencia & "',"
		end if
		
		if 	strSerie  = "" then
			sql = sql & " Serie = null,"
		else
			sql = sql & " Serie = '" & strSerie & "',"
		end if
		
		if 	strNota  = "" then
			sql = sql & " Nota = null,"
		else
			sql = sql & " Nota = '" & strNota & "',"
		end if
		
		if 	intCodTipoAquisicao  = "" then
			sql = sql & " CodTipoAquisicao = null,"
		else
			sql = sql & " CodTipoAquisicao = " & intCodTipoAquisicao & ","
		end if
		
		if 	strNumeroNotaFiscal  = "" then
			sql = sql & " NumeroNotaFiscal = null,"
		else
			sql = sql & " NumeroNotaFiscal = '" & strNumeroNotaFiscal & "',"
		end if
		
		if 	strFornecedor  = "" then
			sql = sql & " Fornecedor = null,"
		else
			sql = sql & " Fornecedor = '" & strFornecedor & "',"
		end if
		
		if 	intCodGenero  = "" then
			sql = sql & " CodGenero = null,"
		else
			sql = sql & " CodGenero = " & intCodGenero & ","
		end if
		
		sql = sql & " Titulo = '" & strTitulo & "',"
		sql = sql & " SubTitulo = '" & strSubTitulo & "',"
		sql = sql & " LocalPublicacao = '" & strLocalPublicacao & "',"
		sql = sql & " AnoPublicacao = '" & intAno & "',"
		sql = sql & " EdicaoPublicacao = " & intCodEdicao & ","
		sql = sql & " VolumePublicacao = '" & strVolume & "',"
		sql = sql & " ISBN = '" & strISBN & "',"
		
		if 	strISSN 	 = "" then
			sql = sql & " ISSN = null,"
		else
			sql = sql & " ISSN = '" & strISSN & "',"
		end if

		if 	strDataInclusao 	 = "" then
			sql = sql & " DataInclusao = null,"
		else
			sql = sql & " DataInclusao = '" & strDataInclusao & "',"
		end if
		
		if 	strEtiqueta  = "" then
			sql = sql & " Etiqueta = null,"
		else
			sql = sql & " Etiqueta = '" & strEtiqueta & "',"
		end if
		
		if 	intPaginas  = "" then
			sql = sql & " NumPaginas = null,"
		else
			sql = sql & " NumPaginas = " & intPaginas & ","
		end if
		
		if 	strOrigem  = "" then
			sql = sql & " Origem = null,"
		else
			sql = sql & " Origem = '" & strOrigem & "',"
		end if
		
		if 	strDestino  = "" then
			sql = sql & " Destino = null,"
		else
			sql = sql & " Destino = '" & strDestino & "',"
		end if
		
		if 	srtResumo  = "" then
			sql = sql & " Resumo = null,"
		else
			sql = sql & " Resumo = '" & srtResumo & "',"
		end if
		
		if 	strDataContrato  = "" then
			sql = sql & " DataContrato = null,"
		else
			sql = sql & " DataContrato = '" & strDataContrato & "',"
		end if
		
		if 	strContato  = "" then
			sql = sql & " Contato = null,"
		else
			sql = sql & " Contato = '" & strContato & "',"
		end if
		
		if 	strEndereco  = "" then
			sql = sql & " Endereco = null,"
		else
			sql = sql & " Endereco = '" & strEndereco & "',"
		end if
		
		if 	strBairro  = "" then
			sql = sql & " Bairro = null,"
		else
			sql = sql & " Bairro = '" & strBairro & "',"
		end if
		
		if 	strCidade  = "" then
			sql = sql & " CIDADE = null,"
		else
			sql = sql & " CIDADE = '" & strCidade & "',"
		end if
		
		if 	strUF  = "" then
			sql = sql & " UF = null,"
		else
			sql = sql & " UF = '" & strUF & "',"
		end if
		
		if 	strCep  = "" then
			sql = sql & " CEP = null,"
		else
			sql = sql & " CEP = " & strCep & ","
		end if
		
		if 	strNumero  = "" then
			sql = sql & " Numero = null,"
		else
			sql = sql & " Numero = '" & strNumero & "',"
		end if
		
		if 	strEmail  = "" then
			sql = sql & " Email = null, "
		else
			sql = sql & " Email = '" & strEmail & "', "
		end if
		
		if 	strBloqueiaUltimoExemplar  = "" then
			sql = sql & " BloqueiaUltimoExemplar = null "
		else
			sql = sql & " BloqueiaUltimoExemplar = '" & strBloqueiaUltimoExemplar & "'"
		end if
		
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And Cod_Publicacao = " & intCodigo
response.write sql
response.end
		cnn.execute sql
		GravarLog sql
		
		'Grava Exemplares
		if intQtdeExemplares = "" then intQtdeExemplares = "0"
		
		intNumExemplar = 0
		'busca o numero de exemplar
		sql = "SELECT Max(numero_exemplar) as MaiorNumeroExemplar" 
		sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES"
		sql = sql & " WHERE COD_PUBLICACAO = " & intCodigo
		rs.open sql, cnn
		if not RS.EOF then
			if rs("MaiorNumeroExemplar") <> "" then
				intNumExemplar = cInt(rs("MaiorNumeroExemplar"))
			end if
		end if
		rs.close		
		
		for i=1 to intQtdeExemplares
			sql = "SELECT Max(Cod_PublicacaoExemplares) as MaiorCodigo" 
			sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES"
			rs.open sql, cnn
			if not RS.EOF then
			
				if rs("MaiorCodigo") <> "" then
					intCodNovo = cstr(rs("MaiorCodigo")) + 1
					intCodPublicacaoExemplares = intCodNovo
				else
					intCodPublicacaoExemplares = 1	
				end if
			
			end if
			rs.close		
			
			intNumExemplar = cInt(intNumExemplar) + 1
			
			sql = "INSERT INTO SCB_PUBLICACAOEXEMPLARES (Cod_Publicacao, Cod_PublicacaoExemplares, numero_exemplar, Cod_SituacaoExemplar)"
			sql = sql & " Values (" 
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & intCodPublicacaoExemplares & ","
			sql = sql & "" & intNumExemplar & ","
			sql = sql & "1)"
			cnn.execute sql
			GravarLog sql
		next		
					
		if intCodAutor <> "" then 
			sql = "Delete from SCB_PUBLICACAOAUTORES "
			sql = sql & " where Cod_Publicacao = " & intCodigo
			cnn.execute sql
			GravarLog sql
		end if 
		
		'Grava Autores
		for i=0 to ubound(vetAutores)
					
			sql = "SELECT Cod_Autor" 
			sql = sql & " FROM SCB_PUBLICACAOAUTORES"
			sql = sql & " where Cod_Publicacao = " & intCodigo
			sql = sql & " And Cod_Autor = " &  vetAutores(i)
			rs.open sql, cnn
			
			if RS.EOF then
						
				sql = "SELECT Max(Codigo) as MaiorCodigo" 
				sql = sql & " FROM SCB_PUBLICACAOAUTORES"
				rsAux.open sql, cnn
				
				if not rsAux.EOF then
				
					if rsAux("MaiorCodigo") <> "" then
						intCodNovo = cstr(rsAux("MaiorCodigo")) + 1
						intCodPublicacaoAutor = intCodNovo
					else
						intCodPublicacaoAutor = 1	
					end if
				
				end if
				rsAux.close
			
				sql = "INSERT INTO SCB_PUBLICACAOAUTORES ( Codigo, Cod_Publicacao, Cod_Autor)"
				sql = sql & " Values (" 
				sql = sql & "" & intCodPublicacaoAutor & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "" & vetAutores(i) & ")"
				cnn.execute sql
				GravarLog sql
			end if
			rs.close
						
		next
		
		
		if intCodPalavra <> "" then 
			sql = "Delete from SCB_PUBLICACAOPALAVRACHAVE "
			sql = sql & " where Cod_Publicacao = " & intCodigo
			cnn.execute sql
			GravarLog sql
		end if 
		
		'Grava Palavra Chave
		for i=0 to ubound(vetPalavraChave)
					
			sql = "SELECT Cod_PalavraChave" 
			sql = sql & " FROM SCB_PUBLICACAOPALAVRACHAVE"
			sql = sql & " where Cod_Publicacao = " & intCodigo
			sql = sql & " And Cod_PalavraChave = " &  vetPalavraChave(i)
			rs.open sql, cnn
			
			if RS.EOF then
						
				sql = "SELECT Max(Codigo) as MaiorCodigo" 
				sql = sql & " FROM SCB_PUBLICACAOPALAVRACHAVE"
				rsAux.open sql, cnn
				
				if not rsAux.EOF then
				
					if rsAux("MaiorCodigo") <> "" then
						intCodNovo = cstr(rsAux("MaiorCodigo")) + 1
						intCodPalavra = intCodNovo
					else
						intCodPalavra = 1	
					end if
				
				end if
				rsAux.close
			
				sql = "INSERT INTO SCB_PUBLICACAOPALAVRACHAVE (Codigo, Cod_Publicacao, Cod_PalavraChave)"
				sql = sql & " Values (" 
				sql = sql & "" & intCodPalavra & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "" & vetPalavraChave(i) & ")"
				cnn.execute sql
				GravarLog sql
			end if
			rs.close
						
		next
				
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCB_PUBLICACAOPALAVRACHAVE "
		sql = sql & " where Cod_Publicacao = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete from SCB_PUBLICACAOAUTORES "
		sql = sql & " where Cod_Publicacao = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete from SCB_PUBLICACAOEXEMPLARES "
		sql = sql & " where Cod_Publicacao = " & intCodigo
		cnn.execute sql
		GravarLog sql

		sql = "Delete from SCB_PUBLICACAO "
		sql = sql & " where Cod_Publicacao = " & intCodigo
		cnn.execute sql
		GravarLog sql
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if intCodPeriodicidade = 0 then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Publicacao_cad.asp';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Publicacao_cad.asp?CodPublicacao=<%=intCodigo%>';
		</script>
		<%
		end if		
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