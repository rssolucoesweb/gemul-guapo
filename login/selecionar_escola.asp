<%@ Language="VBScript" CodePage="65001" %>
<% Response.CodePage = 65001 %>
<% Response.Charset  = "UTF-8" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel de Seleção de Escola e Módulos</title>
    <link rel="stylesheet" href="css/selecionar_escola.css"> <!-- Se tiver CSS global -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-…" crossorigin="anonymous" referrerpolicy="no-referrer" />
	<style>
		/* Estilo base do alerta */
		.alerta {
			padding: 15px 20px;
			border-radius: 5px;
			margin: 20px 0;
			font-family: Arial, sans-serif;
			font-size: 1.1em;
			font-weight: bold;
			display: flex;
			align-items: center;
			border-left: 6px solid #f0ad4e; /* barra de destaque */
			background-color: #fff3cd;       /* fundo amarelo */
			color: #856404;                  /* texto escuro */
			box-shadow: 0 2px 6px rgba(0,0,0,0.1);
		}

		/* Ícone opcional */
		.alerta .icone {
			margin-right: 10px;
			font-size: 1.5em;
		}

		/* Cores alternativas */
		.alerta.sucesso {
			background-color: #d4edda;
			color: #155724;
			border-left-color: #28a745;
		}

		.alerta.erro {
			background-color: #f8d7da;
			color: #721c24;
			border-left-color: #dc3545;
		}

		.alerta.info {
			background-color: #d1ecf1;
			color: #0c5460;
			border-left-color: #17a2b8;
		}

		/* Animação de fade-in */
		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(-10px); }
			to { opacity: 1; transform: translateY(0); }
		}

		.alerta {
			animation: fadeIn 0.5s ease-in-out;
		}
		</style>
</head>
<body>

    <!-- Top-bar -->
    <div class="top-bar">
        <div class="logos">
			<img src="/matricula/img/logomarca-topo-guapo.png" alt="Prefeitura de Guapó">
        </div>
        <div class="actions">
			<img class="logo-cabecario" src="img/logo-login.png" alt="GEMUL">
			<a class="whatsapp-float" href="https://api.whatsapp.com/send?1=pt_BR&amp;phone=556235872362" rel="noopener" title="Falar no WhatsApp do Suporte GEMUL" target="_blank">
			<svg width="25" height="25" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
			<circle cx="32" cy="32" r="32" fill="#25D366"></circle>
			<path d="M11.375 52.625L14.2745 42.0323C12.4853 38.9317 11.5452 35.4169 11.5469
			31.8127C11.552 20.5445 20.7216 11.375 31.988 11.375C37.4553 11.3767 42.5875 13.5062 46.4478 17.37C50.3064
			21.2337 52.4308 26.3694 52.4291 31.8316C52.4239 43.1014 43.2544 52.2709 31.988 52.2709C28.5677 52.2692 25.1972
			51.4116 22.2117 49.7822L11.375 52.625ZM22.7136 46.0817C25.5942 47.7919 28.3442 48.8162 31.9811 48.818C41.3448 48.818
			48.9727 41.197 48.9778 31.8281C48.9813 22.4403 41.3895 14.8297 31.9948 14.8262C22.6242 14.8262 15.0016 22.4472 14.9981
			31.8144C14.9964 35.6386 16.117 38.502 17.9991 41.4978L16.282 47.7678L22.7136 46.0817ZM42.285 36.6905C42.1578 36.4773
			 41.8175 36.3502 41.3053 36.0941C40.7948 35.838 38.2837 34.6022 37.8145 34.432C37.347 34.2619 37.0067 34.1759 36.6647
			 34.6881C36.3244 35.1986 35.3447 36.3502 35.0473 36.6905C34.75 37.0308 34.4509 37.0738 33.9405 36.8177C33.43 36.5616 31.7834
			 36.0236 29.8327 34.2825C28.315 32.9281 27.2889 31.2558 26.9916 30.7436C26.6942 30.2331 26.9606 29.9564 27.215
			 29.702C27.4453 29.4734 27.7255 29.1056 27.9816 28.8066C28.2411 28.5109 28.3253 28.2978 28.4972 27.9558C28.6673
			 27.6155 28.5831 27.3164 28.4542 27.0603C28.3253 26.8059 27.3044 24.2914 26.8798 23.2688C26.4639 22.2736 26.0428
			 22.4077 25.73 22.3922L24.7503 22.375C24.41 22.375 23.8566 22.5022 23.3891 23.0144C22.9216 23.5266 21.6016 24.7606
			 21.6016 27.2752C21.6016 29.7897 23.432 32.2183 23.6864 32.5586C23.9425 32.8989 27.2872 38.0586 32.4108 40.2706C33.6294
			 40.7966 34.5816 41.1111 35.3223 41.3466C36.5461 41.735 37.6598 41.68 38.5398 41.5494C39.5212 41.4033 41.5614 40.3136
			 41.9877 39.1208C42.4139 37.9262 42.4139 36.9036 42.285 36.6905Z" fill="white"></path></svg><span class="topo-suporte">Suporte</span></a>
			
			<div class="user-menu">
				<i class="fa-solid fa-user-circle user-icon"></i>
				<span class="user-name">Usuário</span>

				<div class="dropdown">
					<a href="alterar-senha.asp"><i class="fa-solid fa-key"></i> Alterar Senha</a>
					<a href="index.asp"><i class="fa-solid fa-right-from-bracket"></i> Sair</a>
				</div>
			</div>
        </div>
    </div>


	<!--#include file="../includes/inc_cnn.asp"-->
    <!--#include file="../includes/inc_formatadata.asp"-->
    <!--#include file="../includes/inc_verificaSession.asp"-->
    <!--#include file="../includes/inc_EnviarEmail.asp"-->
    <%
	
	intCodGrupo 			= request.Form("cmdGrupo")
	intCodEmpresaUsuario 	= request.Form("cmdEmpresaUsuario")
	Session("MatriculaInformatizada")=""
	sql = "select cod_empresa "
	sql = sql & " from SEG_USUARIOS_EMPRESA "
	sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
	RsAux.Open SQL, cnn,3 ,1
	if not RsAux.EOF then
		Session("QtdeUsuarioEmpresaAcessa") = RsAux.recordCount
		intCodEmpTemp = RsAux("cod_empresa")
	end if
	RsAux.close
	
	if cInt(Session("QtdeUsuarioEmpresaAcessa")) < 2 then
		intCodEmpresaUsuario = intCodEmpTemp
		Session("CodEmpresaTemp") = ""
	end if
	
    if trim(Session("Aluno")) <> "S" then
		if trim(intCodEmpresaUsuario) = "" then intCodEmpresaUsuario = "0"
		if trim(intCodEmpresaUsuario) = "0" and trim(Session("CodEmpresa"))<>"" then intCodEmpresaUsuario = Session("CodEmpresa")
		if trim(intCodGrupo) = "0" and trim(Session("CodGrupo"))<>"" then intCodGrupo = Session("CodGrupo")
    else
		if trim(intCodEmpresaUsuario) = "" then intCodEmpresaUsuario = "0"
		if trim(intCodEmpresaUsuario) = "0" and trim(Session("CodEmpresaAluno"))<>"" then intCodEmpresaUsuario = Session("CodEmpresaAluno")
		if trim(intCodGrupo) = "0" and trim(Session("CodGrupo"))<>"" then intCodGrupo = Session("CodGrupo")
    end if
	
	' Dados Combo Substituicao
	intCodSubstituicao 	= request.Form("cmbSubstituicaoAcesso")
	intContratoAcesso 	= request.Form("cmbContratoAcesso")

	if intCodSubstituicao = "" then intCodSubstituicao = "0"
	if intContratoAcesso = "" then intContratoAcesso = "0"
	
	'limpa sessions
	Session("caminhoLogomarcaEmpresa")  = ""
	session("EmpresaWeb")				= ""
	session("MantenedoraWeb")			= ""
	session("EmpresaWebCNPJ")			= ""
	session("EnderecoEmpresaWeb")		= ""
	session("CidadeEmpresaWeb")			= ""
	session("BairroEmpresaWeb")			= ""
	session("UFEmpresaWeb")				= ""
	session("CepEmpresaWeb")			= ""
	session("TelefoneEmpresaWeb")		= ""
	session("NomeDiretorEmpresaWeb")	= ""
	session("NomeSecretariaEmpresaWeb")	= ""
	Session("UsuarioSenha")				= ""
	Session("CodDeptoUsuario")			= ""
	Session("DescDeptoUsuario")			= ""
	Session("strAnoLetivo")				= ""
	Session("strSemestre")				= ""
	Session("strTodosSemestre") 		= ""
	Session("strDescSemestre") 			= ""
	Session("strMesEncerramentoPrimeiroSemestre")	= ""
	Session("strMesEncerramentoSegundoSemestre")	= ""
	Session("strChecarFinanceiro")					= ""
	Session("strNomeGrupo") = ""
	Session("CodTodasEmpresaGrupo") = ""
	strnotificacao                  	= ""
	strBloqueio                         = ""
    strExecutarSubmitGrupo				= "S"
	Session("CFP") = ""
	Session("cpfColaborador") = ""	
	Session("CodColaborador") = ""
	
	' Pegao o Codigo do Coloborador Ativo do tipo professor
	sql = " Select Codigo, codFuncional"
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb")  & "'"
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs1.open sql, cnn
	if rs1.eof = false then
		Session("CodColaborador")			= rs1("codigo")
		Session("codFuncional")				= rs1("codFuncional")
		Session("Seg_CodCategoria")			= 1
		Session("Seg_CodColaborador")  		= rs1("codigo")
	end if
	rs1.close
	
	' Consulta o CPF do Colaborador
	sql = " select codigo, CPF, nome, CodCategoria"
	sql = sql & " From SRH_COLABORADOR "
	sql = sql & " where SRH_COLABORADOR.codigo_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb")  & "'"
	rs1.open sql, cnn
	if rs1.eof = false then
		Session("CFP") = rs1("CPF") 
		Session("nomeColaboradorLocado") = rs1("nome") 
		Session("cpfColaborador") 		 = rs1("CPF") 
		Session("Seg_CodCategoria")		 = rs1("CodCategoria") 
		Session("Seg_CodColaborador")  	 = rs1("codigo")
		if Session("CodColaborador") 	 = "" then Session("CodColaborador")= rs1("codigo") 
	else
		Session("nomeColaboradorLocado") = Session("UsuarioWeb")
	end if
	rs1.close

	Session("CodColaboradorSubstituicao") = ""

	' Consulta para ver se exite professor substituto no usuario Logado
	sql = " select m.Cod_ColaboradorSubstituido "
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE m"
	sql = sql & " inner join SRH_Colaborador c on c.codigo = m.Cod_Colaborador"
	sql = sql & " where c.codigo_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb")  & "'"
	sql = sql & " and m.Cod_ColaboradorSubstituido is not null and c.situacao='A'"
	sql = sql & " and m.status='A'"
	existeSubstituicao = "N"
	rs1.open sql, cnn
	if not rs1.eof then
		while not rs1.eof
			IF trim(Session("CodColaboradorSubstituicao")) = "" then
				Session("CodColaboradorSubstituicao") = rs1("Cod_ColaboradorSubstituido") 
			else
				Session("CodColaboradorSubstituicao") = Session("CodColaboradorSubstituicao") & "," & rs1("Cod_ColaboradorSubstituido") 
			end if
			
			existeSubstituicao = "S"
			rs1.movenext
		wend
	end if
	rs1.close	
	
	if existeSubstituicao = "S" then
	
		if trim(intCodSubstituicao) <> "0" then
			
			' Pega o Professor selecionado para fazer a substituicao
			sql = " Select C.codigo, C.cod_empresa, C.cpf, C.nome, C.codigo_SEG_USUARIOS_SISTEMA, C.codLotacao, A.ACES_PERF_CODG, C.CodCategoria, C.codFuncional, FC.Desc_Funcao AS Funcao, C.CodTurno, TU.Desc_Turno  "
			sql = sql & " From SRH_MODULACAO_DISCIPLINAR_DOCENTE CS"
			sql = sql & " inner join SRH_COLABORADOR C on C.codigo = CS.Cod_ColaboradorSubstituido"
			sql = sql & " inner join SEG_ACESSOS_USUARIO A on A.ACES_USUA_CODG = c.codigo_SEG_USUARIOS_SISTEMA "
			sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = C.codFuncao "
			sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "  
			sql = sql & " where C.codigo = " & intCodSubstituicao
			
			rs1.open sql, cnn
			
			if rs1.eof = false then
				Session("UsuarioWeb")				= rs1("codigo_SEG_USUARIOS_SISTEMA")		
				Session("CodEmpresa")				= rs1("codLotacao")
				Session("CodColaborador")			= rs1("codigo")
				Session("cpfColaborador") 			= rs1("CPF") 
				Session("codLotacao")				= rs1("codLotacao")
				Session("PerfilUsuario")			= rs1("ACES_PERF_CODG")
				intCodEmpresaUsuario				= rs1("codLotacao")
				Session("nomeColaboradorLocado")	= rs1("nome")

				' Variaveis de sessao usado no gerenciar perfil... 
				Session("Seg_CodColaborador")  	= rs1("codigo")
				Session("Seg_CodFuncional")	 	= rs1("codFuncional")
				Session("Seg_CodCategoria")		= rs1("CodCategoria") 
				Session("Seg_Funcao")			= rs1("Funcao")	 
				Session("Seg_CodLotacao")	 	= rs1("codLotacao")	
				Session("Seg_Turno")		 	= rs1("Desc_Turno")
				Session("Seg_Perfil")			= rs1("ACES_PERF_CODG")
				
			end if
			rs1.close

		end if
		
	end if
	
	sql = "SELECT  * "
	sql = sql & " FROM SCC_ParametroSistema "
	RsAux.open sql, cnn
	
	if RsAux.eof = false then

		strCnpj 						= RsAux("cnpj")
		strInscricaoEstadual 			= RsAux("InscricaoEstadual")
		strRazaoSocial 					= RsAux("razaoSocial")
		session("strRazaoSocial") 		= RsAux("razaoSocial")
		strEndereco 					= RsAux("EnderecoEmpresa")
		session("strEndereco") 			= RsAux("razaoSocial")
		strBairro 						= RsAux("BairroEmpresa")
		strCidade 						= RsAux("CidadeEmpresa")
		strUF 							= RsAux("UFEmpresa")
		strCep 							= RsAux("CepEmpresa")
		strImagemRecibo 				= RsAux("ImagemRecibo")
		session("strImagemRecibo") 		= RsAux("razaoSocial")
		strImagemRelatorio 				= RsAux("ImagemRelatorio")
		session("strImagemRelatorio") 	= RsAux("razaoSocial")
		strFone						 	= RsAux("FoneEmpresa")
		strFax 							= RsAux("FaxEmpresa")
		strEmail 						= RsAux("EmailEmpresa")
		strWebsite 						= RsAux("WebsiteEmpresa")
		strAssinatura 					= RsAux("Assinatura")
		strCPF 							= RsAux("CPF")
		intMulta 						= RsAux("Multa")
		intMora 						= RsAux("Mora")
		
		session("strCnpjParamento") = RsAux("cnpj")
		session("strRazaoSocialParamento") = RsAux("razaoSocial")
		session("strEnderecoParamento") = RsAux("enderecoEmpresa")
		session("strCEPEmpresaParamento") = RsAux("CepEmpresa")
		session("strBairroParamento") = RsAux("BairroEmpresa")
		session("strCidadeParamento") = RsAux("CidadeEmpresa")
		session("strUFParamento") = RsAux("UFEmpresa")
		session("strImagemReciboParamento") = RsAux("ImagemRecibo")
		session("strImagemRelatorioParamento") = RsAux("ImagemRelatorio")
		session("strFoneParamento") = RsAux("FoneEmpresa")
		session("strAssinaturaParamento") = RsAux("Assinatura")
		session("strCPFAssinaturaParamento") = RsAux("CPF")
		session("strTxMultaParamento") = RsAux("Multa")
		session("strTxMoraParamento") = RsAux("Mora")
		session("strMultaParamento") = "Após o vencimento multa de " & RsAux("Multa") & "%"
		session("strMoraParamento")  = "Após o vencimento mora dia " & RsAux("Mora") & "%"
		session("strEmailEmpresaParamento")  = RsAux("EmailEmpresa")
		session("strWebsiteEmpresaParamento") = RsAux("WebsiteEmpresa")
		
	end if 
	RsAux.close

	if intCodEmpresaUsuario <> "0" then

	    if Session("Aluno") <> "S" then 
		
			sql = " SELECT  SEG_EMPRESA.DIRETOR,SEG_EMPRESA.bloqueia_fechamento,SEG_EMPRESA.SECRETARIA, SEG_EMPRESA.UF, SEG_EMPRESA.ENDERECO, SEG_EMPRESA.MUNICIPIO, SEG_EMPRESA.BAIRRO, SEG_EMPRESA.CODIGO_CENSO, SEG_EMPRESA.CEP, SEG_EMPRESA.NOTIFICACAO, SEG_EMPRESA.BLOQUEIO, SEG_EMPRESA.COD_GRUPO, SEG_USUARIOS_SISTEMA.GESTOR_FINANCEIRO, "
			sql = sql & " SEG_EMPRESA.TELEFONE, SEG_EMPRESA.logomarca, SEG_EMPRESA.RAZAOSOCIAL AS EMPRESA, SEG_EMPRESA.MANTENEDORA, SEG_USUARIOS_SISTEMA.Usua_data_alteracao_senha, SEG_USUARIOS_SISTEMA.Usua_data_hora_ult_logon_web, SEG_USUARIOS_SISTEMA.USUA_CODG,"
			sql = sql & " SEG_USUARIOS_SISTEMA.USUA_NOME_COMPLETO, SEG_USUARIOS_EMPRESA.COD_EMPRESA,"
			sql = sql & " SEG_DEPARTAMENTO.DESCRICAO AS descDepto, SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO, SEG_USUARIOS_EMPRESA.NIVEL_PERMISSAO, SEG_USUARIOS_SISTEMA.USUARIO_MASTER, SEG_EMPRESA.CNPJ "
			sql = sql & " FROM SEG_EMPRESA"
			sql = sql & " INNER JOIN SEG_USUARIOS_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA "
			sql = sql & " INNER JOIN SEG_USUARIOS_SISTEMA ON SEG_USUARIOS_SISTEMA.USUA_CODG = SEG_USUARIOS_EMPRESA.CODIGO_SEG_USUARIOS_SISTEMA "
			sql = sql & " LEFT JOIN SEG_DEPARTAMENTO		ON SEG_USUARIOS_EMPRESA.COD_EMPRESA = SEG_DEPARTAMENTO.COD_EMPRESA AND SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO = SEG_DEPARTAMENTO.CODIGO"
			sql = sql & " WHERE SEG_USUARIOS_SISTEMA.USUA_CODG = '" & Session("UsuarioWeb") & "'"
			sql = sql & " AND SEG_USUARIOS_EMPRESA.COD_EMPRESA = " & intCodEmpresaUsuario
			
		else
		
			sql = " SELECT "
			sql = sql & " SEG_EMPRESA.DIRETOR, SEG_EMPRESA.bloqueia_fechamento,"
			sql = sql & " SEG_EMPRESA.SECRETARIA, "
			sql = sql & " SEG_EMPRESA.UF, " 
			sql = sql & " SEG_EMPRESA.ENDERECO, " 
			sql = sql & " SEG_EMPRESA.MUNICIPIO, " 
			sql = sql & " SEG_EMPRESA.BAIRRO, " 
			sql = sql & " SEG_EMPRESA.CODIGO_CENSO, " 
			sql = sql & " SEG_EMPRESA.CEP, " 
			sql = sql & " SEG_EMPRESA.NOTIFICACAO, " 
			sql = sql & " SEG_EMPRESA.BLOQUEIO, " 
			sql = sql & " SEG_EMPRESA.COD_GRUPO, " 
			sql = sql & " '' AS GESTOR_FINANCEIRO, " 
			sql = sql & " SEG_EMPRESA.TELEFONE, " 
			sql = sql & " SEG_EMPRESA.logomarca, " 
			sql = sql & " SEG_EMPRESA.RAZAOSOCIAL AS EMPRESA, " 
			sql = sql & " SEG_EMPRESA.MANTENEDORA, " 
			sql = sql & " NULL AS Usua_data_alteracao_senha, " 
			sql = sql & " NULL AS Usua_data_hora_ult_logon_web, " 
			sql = sql & " SCA_ALUNO.MATRICULA AS USUA_CODG, "
			sql = sql & " SCA_ALUNO.NOMEALUNO AS USUA_NOME_COMPLETO, " 
			sql = sql & " SCA_ALUNO.COD_EMPRESA, "
			sql = sql & " 'Consulta Acadêmica' AS descDepto, " 
			sql = sql & " 0 AS CODIGO_DEPARTAMENTO, " 
			sql = sql & " NULL AS NIVEL_PERMISSAO, " 
			sql = sql & " NULL AS USUARIO_MASTER, " 
			sql = sql & " SEG_EMPRESA.CNPJ " 
			sql = sql & " FROM SCA_ALUNO " 
			sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO=SCA_ALUNO.COD_EMPRESA "
			sql = sql & " WHERE SCA_ALUNO.MATRICULA = '" & Session("LoginAluno") & "'"
			sql = sql & " AND SCA_ALUNO.COD_EMPRESA = " & Session("CodEmpresaAluno")
	
		end if
'if ucase(trim(session("usuarioWeb"))) = "03210691100" then
'response.write sql
'response.end
'end if			
		RsAux.Open SQL, cnn
		
		if RsAux.EOF = false then
	
			'dados da empresa
			Session("CodEmpresa") 				= RsAux("COD_EMPRESA")
			Session("CodGrupo")                 = RsAux("COD_GRUPO")
			Session("strFone")                  = RsAux("TELEFONE")
			Session("strBloqueiaFechamento")    = RsAux("bloqueia_fechamento")
			
			if trim(intCodGrupo) = "0" or trim(intCodGrupo) = ""  then intCodGrupo = RsAux("COD_GRUPO")
			
			if isnull(RsAux("logomarca")) or RsAux("logomarca") = "" then
				'local
				Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/SISGE/logomarcas/LogoEmpresa.gif"
				'web
				Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/logomarcas/LogoEmpresa.gif"
			else
				'local
				Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/SISGE/logomarcas/" & RsAux("COD_EMPRESA") & "/" & RsAux("logomarca")
				'web
				Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/logomarcas/" & RsAux("COD_EMPRESA") & "/" & RsAux("logomarca")
			end if

			session("EmpresaWeb")				= RsAux("EMPRESA")
			IF NOT ISNULL(RsAux("CODIGO_CENSO")) THEN session("EmpresaWeb") = RsAux("CODIGO_CENSO") & " - " & RsAux("EMPRESA")
			session("MantenedoraWeb")			= RsAux("MANTENEDORA")
			session("EmpresaWebCNPJ")			= RsAux("CNPJ")
			session("EnderecoEmpresaWeb")		= RsAux("ENDERECO")
			session("CidadeEmpresaWeb")			= RsAux("MUNICIPIO")
			session("BairroEmpresaWeb")			= RsAux("BAIRRO")
			session("UFEmpresaWeb")				= RsAux("UF")
			session("CepEmpresaWeb")			= RsAux("CEP")
			session("TelefoneEmpresaWeb")		= RsAux("TELEFONE")
			session("NomeDiretorEmpresaWeb")	= RsAux("DIRETOR")
			session("NomeSecretariaEmpresaWeb")	= RsAux("SECRETARIA")
			
			'dados do usuario
			Session("UsuarioWeb") 				= RsAux("Usua_Codg")	
			Session("NomeUsuarioWeb")			= RsAux("USUA_NOME_COMPLETO")
			Session("NivelPermissao")			= RsAux("NIVEL_PERMISSAO")
			Session("UsuarioMaster")			= RsAux("USUARIO_MASTER")
			Session("GestorFinanceiro")			= RsAux("GESTOR_FINANCEIRO")
			
			Session("UsuarioSenha")				= RsAux("Usua_Codg")
			Session("CodDeptoUsuario")			= RsAux("CODIGO_DEPARTAMENTO")
			Session("DescDeptoUsuario")			= RsAux("descDepto")
			
			'USADO SOMENTE PARA DEMONSTRAÇÃO
			if Session("UsuarioWeb") = "USUARIO.TESTE" then
				session("EmpresaWeb")				= "ESCOLA MUNICIPAL WALTER F. DE CARVALHO"
				session("MantenedoraWeb")			= "ESCOLA MUNICIPAL WALTER F. DE CARVALHO"
				session("EmpresaWebCNPJ")			= "00.000.000/0000-00"
				session("EnderecoEmpresaWeb")		= "RUA JB-11 APM-4 "
				session("CidadeEmpresaWeb")			= "SENADOR CANEDO"
				session("BairroEmpresaWeb")			= "JARDIM BOUGANVILLE"
				session("UFEmpresaWeb")				= "GO"
				session("CepEmpresaWeb")			= "00.000-000"
				session("TelefoneEmpresaWeb")		= "(62)-32753084"
				session("NomeDiretorEmpresaWeb")	= "NOME DO DIRETOR"
				session("NomeSecretariaEmpresaWeb")	= "NOME DA SECRETARIA"
				Session("caminhoLogomarcaEmpresa")  = "http://" & Request.ServerVariables("SERVER_NAME") & "/logomarcas/" & "999" & "/" & "logoDemo.jpg"
			end if
			     
			 'Notificação do Sistema
			strnotificacao                  	= RsAux("NOTIFICACAO")
			strBloqueio                         = RsAux("BLOQUEIO")
			
			'busca informações ano e semestre letivo
			sql = " SELECT top 1 ano_letivo, semestre, notificacao1, notificacao2 "
			sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
			sql = sql & " Where cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " order by ano_letivo desc"
			
			RS1.Open SQL, cnn
			if RS1.EOF = false then								
				Session("strAnoLetivo")			= RS1("ano_letivo")
				Session("strSemestre")			= RS1("semestre")
				strSemestre 					= Session("strSemestre")
				strNotificacao1                 =  RS1("notificacao1")
				strNotificacao2                 =  RS1("notificacao2")
			else
				'insere registro
				if month(date) < 7 then 
					strSemestre = 1
				else
					strSemestre = 2
				end if
				sql = "Insert Into SEG_ENCERRAMENTOATIVIDADES(COD_EMPRESA, Ano_letivo, Semestre, data_encerramento, Bloqueia_NotasDocente, Bloqueia_NotasSecretaria)"
				sql = sql & " Values ("
				sql = sql & "" & Session("CodEmpresa") & ","
				sql = sql & "" & year(date) & ","
				sql = sql & "" & strSemestre & ","									
				sql = sql & "'" & formataDataBD(date) & " " & time & "',"	
				sql = sql & "'N',"
				sql = sql & "'N')"	
				cnn.execute sql
			end if
			RS1.close
			Session("strSemestre") = strSemestre
			Session("strTodosSemestre") = strSemestre
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
					Session("strTodosSemestre") = "1,2"
					Session("strDescSemestre") = strSemestre & "º Semestre"
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
				sql = "Insert Into SEG_CONFIGURACOESGERAIS(COD_EMPRESA, Mes_Encerra_Primeiro_Semestre, Mes_Encerra_Segundo_Semestre, checar_financeiro, perc_multa, perc_mora, Cod_TipoparcelaMensalidade)"
				sql = sql & " Values ("
				sql = sql & "" & Session("CodEmpresa") & ","
				sql = sql & "6,"
				sql = sql & "8,'N',2,NULL,NULL)"									
				cnn.execute sql
			end if	
			
			
			'--------------------------------------------------------------------------
			'------INICIO - BLOQUEIO SOMENTE PARA A EPOCA DA MATRÍCULA
			'--------------------------------------------------------------------------
			if trim(Session("NivelPermissao")) = "A" or Session("UsuarioMaster") = "S" then                   
				'liberado do bloqueio temporário
			else
				%>
				<!--script>
					//alert("Sistema em manutenção!");
					//window.location='index.asp';
				</script -->
				<%
				'response.end
			end if	
			
			'--------------------------------------------------------------------------
			'------FIM - BLOQUEIO SOMENTE PARA A EPOCA DA MATRÍCULA
			'--------------------------------------------------------------------------
	

		end if	
		rsAux.close
		
	    ' INICIO - Dados Para Envio de E-mail
		strEmail = ""	
		strEmailOrigem = ""	
		sql=" SELECT EMAIL_LOGINS, RAZAOSOCIAL, EMAIL_DOMINIO FROM SEG_EMPRESA "
		sql=sql & " WHERE CODIGO = " & Session("CodEmpresa")  
		rs1.open sql, cnn
		if not rs1.eof then
		   strEmail				= rs1("EMAIL_LOGINS")
		   unidadeEscolar       = rs1("RAZAOSOCIAL")
		   strEmailOrigem		= rs1("EMAIL_DOMINIO")	
		   if isnull(strEmail) then strEmail = "" 
		   if isnull(strEmailOrigem) then strEmailOrigem = ""
		end if
		rs1.close	

		nomeresponsavel = ""	
		sql=" SELECT NOME, EMAIL, FONERESIDENCIAL, FONECOMERCIAL, FONECELULAR FROM SRH_COLABORADOR "
		sql=sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA =  '" & Session("UsuarioWeb") & "'"
		rs1.open sql, cnn
		if not rs1.eof then
		   nomeresponsavel		= rs1("nome")	
		   email				= rs1("email")	
		   FoneResidencial   	= rs1("FoneResidencial")	
		   FoneComercial		= rs1("FoneComercial")	
		   FoneCelular			= rs1("FoneCelular")	
		end if
		rs1.close	
		
		strAssuntoEmail	 = "Acompanhamento de Login - Sistema"  
		strMensagemEmail = "<br> Acesso realizado por: " & nomeresponsavel & "<br>"
		strMensagemEmail = strMensagemEmail & "Email: " & email & "<br>"
		strMensagemEmail = strMensagemEmail & "Unidade Escolar: " & unidadeEscolar & "<br>"
		strMensagemEmail = strMensagemEmail & "Telefone Residencial: " & FoneResidencial & "<br>"
		strMensagemEmail = strMensagemEmail & "Telefone Celular: " & FoneCelular & "<br>"
		strMensagemEmail = strMensagemEmail & "Telefone Comercial: " & FoneComercial & "<br>"

		if strEmail <> "" and strEmailOrigem <> "" then 
		   EnviarEmail strEmailOrigem, strEmail, strAssuntoEmail, strMensagemEmail
		end if
		
		' FIM - Dados Para Envio de E-mail		
	end if
	
	if trim(strnotificacao) <> "" then
		%>
		<script>
			alert("<%=trim(strnotificacao)%>");
		</script>
		<%
    end if		
		
	if strBloqueio = "S" then                     
		%>
		<script>
			alert("Sistema Bloqueado, procure o Administrador");
			window.close();
		</script>
		<%
		response.end
    end if	
	
	%>
    <form name="frm" method="post" id="frm" action="selecionar_escola.asp">	

    <!-- Corpo -->
    <div class="main-content">
        
		
		<%if strNotificacao1 <> "" then%>
		<div class="alerta info">
			<span class="icone">ℹ️</span>
			<span><strong><%=strNotificacao1%></strong></span>
		</div>
		<%end if%>
		<%if strNotificacao2 <> "" then%>
		<div class="alerta info">
			<span class="icone">ℹ️</span>
			<span><strong><%=strNotificacao2%></strong></span>
		</div>
		<%end if%>
		<!-- Outros tipos de alerta -->
		<!--div class="alerta">
			<span class="icone">⚠️</span>
			<span>Sistema está em manutenção!</span>
		</div>

		
		<div class="alerta sucesso">
			<span class="icone">✅</span>
			<span>Operação realizada com sucesso!</span>
		</div>

		<div class="alerta erro">
			<span class="icone">❌</span>
			<span>Ocorreu um erro ao processar.</span>
		</div>

		<div class="alerta info">
			<span class="icone">ℹ️</span>
			<span>Informação importante para o usuário.</span>
		</div-->
		
		<%if Session("UsuarioMaster") = "S" then     %>
		<%else%>
			<% if trim(intCodEmpresaUsuario)<>"0" and trim(intCodEmpresaUsuario) <> "" then%>
			<div class="form-group">
				<!--#include file="includes/inc_cmdContratoAcesso.asp" -->
			</div>
			<% end if %>
			
			<% if trim(existeSubstituicao) = "S" then%>
			<div class="form-group">
				<!--#include file="includes/inc_cmdSubstituicaoAcesso.asp"-->
			</div>
			<% end if %>
		<%end if %>	

		<!--#include file="includes/inc_cmdEmpresaUsuarioAcesso.asp"-->
		
		<%
		strBloqueiaModulos = ""
		
		%>

        <!-- Painel Modulos -->
		<% 
		if intCodEmpresaUsuario <> "0" and cInt(Session("QtdeUsuarioEmpresaAcessa")) >= 1 then%>
					<h3><i class="fa fa-tasks"></i> Acesso ao Modulos </h3>
					<div class="panel-body"><!--#include file="includes/modulos.asp"--></div>
		<% end if%>

    </div>
	
	</form>
	
	<!-- Painel Notificação 1 -->
    <% if trim(strnotificacao1)<> "" then %>
    	<!--include file="includes/Notificacao1.asp"-->
    <% end if %>
    
     <!-- Painel Notificação 2 --> 
    <% if trim(strnotificacao2)<> "" then %>
    	<!--include file="includes/Notificacao2.asp"-->
    <% end if %>
	
	<!-- Rodapé fixo -->
	<footer class="footer-fixed" role="contentinfo">
		<div class="footer-left">
			<span>© App GEMUL | Usuário: <%=Session("NomeUsuarioWeb")%> <%if intCodEmpresaUsuario<>"" and intCodEmpresaUsuario<>"0" then%> | Id: <%=intCodEmpresaUsuario%><%end if%></span>
		</div>

		<div class="footer-right">
			<ul>
				<li class="rodape-ajuda"><a href="https://api.whatsapp.com/send?1=pt_BR&amp;phone=556235872362" target="_blank">Ajuda</a></li>
				<li><a href="https://api.whatsapp.com/send?1=pt_BR&amp;phone=556235872362" target="_blank"><i class="fa-regular fa-circle-question"></i></a></li>
			</ul>
		</div>
	</footer>


    <!-- Script para combobox pesquisável -->
    <script>
        const select = document.getElementById('school');
        select.addEventListener('input', function() {
            const filter = this.value.toLowerCase();
            Array.from(this.options).forEach(option => {
                option.style.display = option.text.toLowerCase().includes(filter) ? '' : 'none';
            });
        });
    </script>

</body>
</html>
