<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 16/09/2007
	::	Desenvolvedores...: Sérgio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Cadastro de Empresa
-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_formataData.asp"-->
	<%
	intCodigo 			= Request.QueryString("txtCodEmpresa")

	'dados da empresa
	Session("CodEmpresa") 				= request.Form("codEmpresa")

	sql = "SELECT * "
	sql = sql & " FROM SEG_EMPRESA"
	sql = sql & " WHERE CODIGO = " & Session("CodEmpresa") 
	RsAux.Open SQL, cnn
	if RsAux.EOF = false then
		if isnull(RsAux("logomarca")) or RsAux("logomarca") = "" then
			'local
			Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/SISGE/logomarcas/LogoEmpresa.gif"
			'web
			Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/logomarcas/LogoEmpresa.gif"
		else
			'local
			Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/SISGE/logomarcas/" & RsAux("CODIGO") & "/" & RsAux("logomarca")
			'web
			Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/logomarcas/" & RsAux("CODIGO") & "/" & RsAux("logomarca")
		end if
		session("EmpresaWeb")				= RsAux("RAZAOSOCIAL")
		session("EnderecoEmpresaWeb")		= RsAux("ENDERECO")
		session("CidadeEmpresaWeb")			= RsAux("MUNICIPIO")
		session("BairroEmpresaWeb")			= RsAux("BAIRRO")
		session("UFEmpresaWeb")				= RsAux("UF")
		session("CepEmpresaWeb")			= RsAux("CEP")
		session("TelefoneEmpresaWeb")		= RsAux("TELEFONE")

		sql = " select TOP 1 SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO, SEG_DEPARTAMENTO.DESCRICAO"
		sql = sql & " from SEG_USUARIOS_SISTEMA"
		sql = sql & " INNER JOIN SEG_DEPARTAMENTO ON SEG_DEPARTAMENTO.CODIGO = SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO AND SEG_DEPARTAMENTO.COD_EMPRESA = SEG_USUARIOS_SISTEMA.COD_EMPRESA"
		sql = sql & " where SEG_USUARIOS_SISTEMA.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and SEG_USUARIOS_SISTEMA.usua_stat = 'A'"
		RS1.Open SQL, cnn
		if RS1.EOF = false then								
			Session("CodDeptoUsuario")			= RS1("CODIGO_DEPARTAMENTO")
			Session("DescDeptoUsuario")			= RS1("DESCRICAO")		
		end if
		RS1.close
		
		'busca informações ano e semestre letivo
		sql = " SELECT top 1 ano_letivo, semestre "
		sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
		sql = sql & " Where cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " order by ano_letivo desc"
		RS1.Open SQL, cnn
		if RS1.EOF = false then								
			Session("strAnoLetivo")			= RS1("ano_letivo")
			Session("strSemestre")			= RS1("semestre")
			strSemestre 					= Session("strSemestre")
			
		else
			'insere registro
			if month(date)<7 then 
				strSemestre = 1
			else
				strSemestre = 2
			end if
				
			sql = "Insert Into SEG_ENCERRAMENTOATIVIDADES(COD_EMPRESA, Ano_letivo, Semestre, data_encerramento)"
			sql = sql & " Values ("
			sql = sql & "" & Session("CodEmpresa") & ","
			sql = sql & "" & year(date) & ","
			sql = sql & "" & strSemestre & ","									
			sql = sql & "'" & formataDataBD(date) & " " & time & "')"									
			cnn.execute sql
			GravarLog sql
		end if
		RS1.close
		Session("strSemestre") = strSemestre
		Session("strDescSemestre") = "Não Informado"
		'busca regime da escola
		sql = " SELECT tipo_seriacao "
		sql = sql & " FROM sca_regime "
		sql = sql & " Where cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " order by Cod_Regime desc"
		RS1.Open SQL, cnn
		if RS1.EOF = false then		
			strTipoSeriacao	= trim(rs1("tipo_seriacao"))
			if strTipoSeriacao	= "A" then 
				Session("strSemestre") = "3"
				Session("strDescSemestre") = "Anual"
				Session("strTodosSemestre") = "3"
			elseif strTipoSeriacao	= "S" then 
				if strSemestre = 1 then Session("strSemestre") = "1"
				if strSemestre = 2 then Session("strSemestre") = "2"
				Session("strDescSemestre") = strSemestre & "º Semestre"
				Session("strTodosSemestre") = "1,2"
			elseif strTipoSeriacao	= "AS" then 
				if strSemestre = 1 then Session("strSemestre") = "1,3"
				if strSemestre = 2 then Session("strSemestre") = "2,3"
				Session("strTodosSemestre") = "1,2,3"
				Session("strDescSemestre") = "Anual/" & strSemestre & "º Semestre"
			end if
		end if
		RS1.close


		'configurações gerais do sistema
		Session("strChecarFinanceiro") = "N"
		sql = " SELECT * "
		sql = sql & " FROM SEG_CONFIGURACOESGERAIS "
		sql = sql & " Where cod_empresa = " & Session("CodEmpresa") 
		RS1.Open SQL, cnn
		if RS1.EOF = false then								
			Session("strMesEncerramentoPrimeiroSemestre")	= RS1("Mes_Encerra_Primeiro_Semestre")
			Session("strMesEncerramentoSegundoSemestre")	= RS1("Mes_Encerra_Segundo_Semestre")
			Session("strChecarFinanceiro")					= RS1("checar_financeiro")
			RS1.close			
		else
			RS1.close			
			sql = "Insert Into SEG_CONFIGURACOESGERAIS(COD_EMPRESA, Mes_Encerra_Primeiro_Semestre, Mes_Encerra_Segundo_Semestre, checar_financeiro)"
			sql = sql & " Values ("
			sql = sql & "" & Session("CodEmpresa") & ","
			sql = sql & "6,"
			sql = sql & "8,'N')"									
			cnn.execute sql
			GravarLog sql
		end if

		
		strMensagem = "Troca de empresa efetuada com sucesso..."
	end if
	RsAux.close
		
	if err.number = 0 then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='trocaEmpresa_cad.asp';
		</script>
		<%
	else
		if err.number = -2147217900 then
			%>
			<script>
				alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
				window.history.back();
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
			</script>
			<%
		end  if 	
	end if
%>