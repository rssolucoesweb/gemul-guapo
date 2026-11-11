<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Vestibular 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 						= Trim(Request.QueryString("acao"))
	intCodEmp					= Session("CodEmpresa")
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	intCodCursoPrimeiraOpcao	= Trim(Request.Form("cmbCursoPrimeiraOpcao"))
	intCodCursoSegundaOpcao		= Trim(Request.Form("cmbCursoSegundaOpcao"))
	intCodTurnoPrimeiraOpcao	= Trim(Request("cmbTurnoPrimeiraOpcao"))
	intCodTurnoSegundaOpcao		= Trim(Request("cmbTurnoSegundaOpcao"))
	strOpcao	 				= Trim(Request.Form("cmbOpcao"))
	strCpf                      = Replace(Replace(Trim(Request("txtCpf")),".",""),"-","")
	strNomealuno		 		= ucase(Trim(Request.Form("txtNomealuno")))
	strIdentidade				= ucase(Trim(Request.Form("txtIdentidade")))
	strOrgaoExpedidor			= ucase(Trim(Request.Form("txtOrgaoExpedidor")))
	strUFExpedidor		 		= ucase(Trim(Request.Form("txtUFExpedidor")))
	strDataNascimento 			= FORMATADATABD(Trim(Request.Form("txtDataNascimento")))
	strCidadeNascimento 		= ucase(Trim(Request.Form("txtCidadeNascimento")))
	strUFNascimento 			= ucase(Trim(Request.Form("txtUFNascimento")))
	strNacionalidade 			= ucase(Trim(Request.Form("txtNacionalidade")))
	strCodVestibular			= Trim(Request.Form("cmbVestibular"))
	strSexo						= Trim(Request.Form("cmbSexo"))
	txtFone 					= Trim(Request.Form("txtFone"))
	
	'endereço
	strLogradouro 				= ucase(Trim(Request.Form("txtLogradouro")))
	strNumero_endereco 			= ucase(Trim(Request.Form("txtNumero_endereco")))
	strComp_endereco 			= ucase(Trim(Request.Form("txtComp_endereco")))
	strBairro 					= ucase(Trim(Request.Form("txtBairro")))
	strCidade					= ucase(Trim(Request.Form("txtCidade")))
	strUfResidencia				= ucase(Trim(Request.Form("cmbUFResidencia")))
	strCep		 				= Trim(Request.Form("txtCep"))
	strCep		 				= Trim(Request.Form("txtCep"))
	strDataInscricao	 		= formatadataBD(Trim(Request.Form("txtDataInscricao"))) & " " & time

	strDataVencimento	 		= formatadataBD(Trim(Request.Form("txtVencimento")))
	strValorVestibular          = Replace(Replace(Trim(Request("txtValorVestibular")),".",""),",",".")
	intNumeroImpressao			= 0
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_VESTIBULAR_DADOS(Cod_Empresa, Cod_Vestibular, Cod_CursoPrimeiraOpcao, Cod_CursoSegundaOpcao, Cod_TurnoPrimeiraOpcao, Cod_TurnoSegundaOpcao, OptanteEnem, "
		sql = sql & " Cpf, NomeAluno, Identidade, OrgaoExpedidor, UFExpedidor, DataNascimento, "
		sql = sql & " CidadeNascimento, UFNascimento, Nacionalidade , Sexo, Fone, "
		sql = sql & " LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, "
 		sql = sql & " BAIRRO, CIDADE, UF, CEP, DataInscricao, valor, datavencimento, COD_SITUACAO_PAGAMENTO, NumeroImpressao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & "," 
		sql = sql & "" & strCodVestibular & "," 
		
		if 	intCodCursoPrimeiraOpcao 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodCursoPrimeiraOpcao & "," 
		end if
		
		if 	intCodCursoSegundaOpcao 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodCursoSegundaOpcao & ","
		end if

		if 	intCodTurnoPrimeiraOpcao 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodTurnoPrimeiraOpcao & "," 
		end if
		
		if 	intCodTurnoSegundaOpcao 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodTurnoSegundaOpcao & ","
		end if

		if 	strOpcao 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strOpcao & "'," 
		end if
		
		sql = sql & "'" & strCPF & "',"
		
		sql = sql & "'" & strNomealuno & "',"
		
		if 	strIdentidade 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strIdentidade & "'," 
		end if
		
		if 	strOrgaoExpedidor 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strOrgaoExpedidor & "'," 
		end if
		
		if 	strUFExpedidor 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strUFExpedidor & "',"  
		end if
		
		if 	strDataNascimento 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strDataNascimento & "'," 
		end if
		
		if 	strCidadeNascimento 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strCidadeNascimento & "'," 
		end if
		if 	strUFNascimento 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strUFNascimento & "'," 
		end if
		
		if 	strNacionalidade 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strNacionalidade & "'," 
		end if
		if 	strSexo 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strSexo & "'," 
		end if
		
		if 	txtFone 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & txtFone & "'," 
		end if
		
		if 	strLogradouro 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strLogradouro & "'," 
		end if
		
		if 	strNumero_endereco 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & strNumero_endereco & "," 
		end if

		if 	strComp_endereco 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strComp_endereco & "'," 
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

		if 	strUfResidencia 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strUfResidencia & "',"
		end if
		
		if strCep 	 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strCep & "'," 
		end if
		
		sql = sql & "'" & strDataInscricao & "',"
		sql = sql & "" & strValorVestibular & "," 
		sql = sql & "'" & strDataVencimento & "',1," 
		sql = sql & "" & intNumeroImpressao & ")" 
		cnn.execute sql
		GravarLog sql	

		sql = "SELECT MAX(CODIGO) AS COD "
		sql = sql & " FROM SCA_VESTIBULAR_DADOS"
		sql = sql & " WHERE  COD_EMPRESA = " & intCodEmp
		sql = sql & " AND DataInscricao = '" & strDataInscricao & "'"
		rs.open sql, cnn
		if NOT rs.eof then
			intCodigo = Trim(rs("COD"))
		end if
		rs.close	
				
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
			
		sql = "Update SCA_VESTIBULAR_DADOS Set"
		
		if 	intCodCursoPrimeiraOpcao  = "" then
		    sql = sql & " Cod_CursoPrimeiraOpcao = null,"
		else	
		    sql = sql & " Cod_CursoPrimeiraOpcao = " & intCodCursoPrimeiraOpcao & ","
		end if	

		if 	intCodCursoSegundaOpcao  = "" then
		    sql = sql & " Cod_CursoSegundaOpcao = null,"
		else	
		    sql = sql & " Cod_CursoSegundaOpcao = " & intCodCursoSegundaOpcao & ","
		end if	

		if 	intCodTurnoPrimeiraOpcao  = "" then
		    sql = sql & " Cod_TurnoPrimeiraOpcao = null,"
		else	
		    sql = sql & " Cod_TurnoPrimeiraOpcao = " & intCodTurnoPrimeiraOpcao & ","
		end if	

		if 	intCodTurnoSegundaOpcao  = "" then
		    sql = sql & " Cod_TurnoSegundaOpcao = null,"
		else	
		    sql = sql & " Cod_TurnoSegundaOpcao = " & intCodTurnoSegundaOpcao & ","
		end if	

		if 	strOpcao  = "" then
		    sql = sql & " OptanteEnem = null,"
		else	
		    sql = sql & " OptanteEnem = '" & strOpcao & "',"
		end if	
		
		sql = sql & " CPF = '" & strCPF & "',"
		
		sql = sql & " NomeAluno = '" & strNomealuno & "',"
		
		if 	strIdentidade  = "" then
		    sql = sql & " Identidade = null,"
		else	
		   sql = sql & " Identidade = '" & strIdentidade & "',"
		end if	
		
		if 	strOrgaoExpedidor  = "" then
		    sql = sql & " OrgaoExpedidor = null,"
		else	
		    sql = sql & " OrgaoExpedidor = '" & strOrgaoExpedidor & "',"
		end if	
		if 	strUFExpedidor  = "" then
		    sql = sql & " UFExpedidor = null,"
		else	
		    sql = sql & " UFExpedidor = '" & strUFExpedidor & "',"
		end if	
		if 	strDataNascimento  = "" then
		    sql = sql & " DataNascimento = null,"
		else	
		   sql = sql & " DataNascimento = '" & strDataNascimento & "',"
		end if	
		if 	strCidadeNascimento  = "" then
		    sql = sql & " CidadeNascimento = null,"
		else	
		    sql = sql & " CidadeNascimento = '" & strCidadeNascimento & "',"
		end if	
		if 	strUFNascimento  = "" then
		    sql = sql & " UFNascimento = null,"
		else	
		  	sql = sql & " UFNascimento = '" & strUFNascimento & "',"
		end if	
		if 	strNacionalidade  = "" then
		    sql = sql & " Nacionalidade = null,"
		else	
		  	sql = sql & " Nacionalidade = '" & strNacionalidade & "',"
		end if	
		if 	strSexo  = "" then
		    sql = sql & " Sexo = null,"
		else	
		  	sql = sql & " Sexo = '" & strSexo & "',"
		end if	
		if 	txtFone  = "" then
		    sql = sql & " Fone = null,"
		else	
		    sql = sql & " Fone = '" & txtFone & "',"
		end if	
		if 	strLogradouro  = "" then
			sql = sql & "LOGRADOURO = null,"
		else
			sql = sql & "LOGRADOURO = '" & strLogradouro & "',"
		end if

		if 	strNumero_endereco  = "" then
			sql = sql & "NUMERO_ENDERECO = null,"
		else
			sql = sql & "NUMERO_ENDERECO = " & strNumero_endereco & ","
		end if

		if 	strComp_endereco  = "" then
			sql = sql & "COMP_ENDERECO = null,"
		else
			sql = sql & "COMP_ENDERECO = '" & strComp_endereco & "',"
		end if
	
		if 	strBairro  = "" then
			sql = sql & "BAIRRO = null,"
		else
			sql = sql & "BAIRRO = '" & strBairro & "',"
		end if
	
		if 	strCidade  = "" then
			sql = sql & "CIDADE = null,"
		else
			sql = sql & "CIDADE = '" & strCidade & "',"
		end if

		if 	strUfResidencia  = "" then
			sql = sql & "UF = null,"
		else
			sql = sql & "UF = '" & strUfResidencia & "',"
		end if
		if 	strCep  = "" then
			sql = sql & "CEP = null,"
		else
			sql = sql & "CEP = '" & strCep & "',"
		end if
		sql = sql & " DataInscricao = '" & strDataInscricao & "',"
		sql = sql & " valor = " & strValorVestibular & ","
  	    sql = sql & " dataVencimento = '" & strDataVencimento & "'"
				
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And codigo = " & intCodigo
		
		cnn.execute sql
		GravarLog sql
	else

		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_VESTIBULAR_DADOS "
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
	end if
		
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if trim(intCodigo) = "" then
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='vestibularDados_cad.asp';
			</script>
			<%
		else
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='vestibularDados_cad.asp?txtCodigo=<%=intCodigo%>';
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