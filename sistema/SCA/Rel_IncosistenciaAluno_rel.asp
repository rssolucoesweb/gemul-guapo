<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/08/2012
	::	Desenvolvedores...: Sergio Borges - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio de Incosistecia de Alunos
-->
<html>
<head>
<title><%=session("Titulo")%> - Declara&ccedil;&atilde;o de Nada Consta</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina

	strTituloRelatorio  			= "Inconsistencia de Aluno"
	strCod_empresa 					= Session("CodEmpresa")
	intCodSituacaoAluno	 			= Trim(Request.Form("cmbSituacaoAluno"))
	intTotalAluno					= 0
	
	if trim(strCod_empresa) <> "" then
	
		sql = "SELECT S.Desc_SituacaoAluno, A.* "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
		sql = sql & " Where A.COD_EMPRESA = " & session("codEmpresa")
				
		if triM(intCodSituacaoAluno) <> "0" then
			sql = sql & " And A.COD_SITUACAOALUNO = " & intCodSituacaoAluno
		end if
		
		rs.open sql, cnn
		
		if rs.eof = false then
			
			While not rs.eof 
			
			intTotalAluno = intTotalAluno + 1
			
			'dados pessoais
			strSituacaoAluno				= TRIM(rs("Desc_SituacaoAluno"))
			intCodAluno						= TRIM(rs("Codigo"))
			strMatricula 					= TRIM(rs("Matricula"))
			strNomealuno 					= TRIM(rs("Nomealuno"))
			strDatamatricula 				= formataDataAP(TRIM(rs("Datamatricula")))
			strNumeroRegistroNascimento  	= TRIM(rs("NUMREGISTRONASC"))
			strFolha						= TRIM(rs("Folha"))
			strLivro						= TRIM(rs("Livro"))
			strTermo						= TRIM(rs("Termo"))
			strNomeCartorio					= TRIM(rs("NomeCartorio"))
			strSexo		 					= TRIM(rs("SexoAluno"))
			strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
			strDataEmissaoCertidaoNasc 		= formataDataAP(TRIM(rs("DataEmissaoCertidaoNascimento")))
			strCidadenascimento 			= TRIM(rs("Cidadenascimento"))
			strUfnascimento 				= TRIM(rs("Ufnascimento"))
			strNacionalidade 				= TRIM(rs("Nacionalidade"))
			strTipoNacionalidade			= TRIM(rs("cod_TipoNacionalidade"))
			intCodEstadocivil 				= TRIM(rs("cod_EstadoCivil"))
			intCodProfissao 				= TRIM(rs("cod_Profissao"))
			intCodEtnia 					= TRIM(rs("cod_Etnia"))
			intCodReligiao 					= TRIM(rs("cod_Religiao"))
			intCodNecessidadeEspecial 		= TRIM(rs("Cod_necespecial"))
			strAtendimentoespecial 			= TRIM(rs("Atendimentoespecial"))
			strFoneResidencial 				= TRIM(rs("FoneResidencial"))
			strFonecomercial 				= TRIM(rs("Fonecomercial"))
			strFoneCelular	 				= TRIM(rs("Fonecelular"))
			strEmail 						= TRIM(rs("Email"))
			
			'endereço
			strLogradouro 					= TRIM(rs("Logradouro"))
			strNumero_endereco 				= TRIM(rs("Numero_endereco"))
			strComp_endereco 				= TRIM(rs("Comp_endereco"))
			strBairroaluno 					= TRIM(rs("Bairroaluno"))
			strCidaderesidencia				= TRIM(rs("Cidaderesidencia"))
			strUfresidencia 				= TRIM(rs("Ufresidencia"))
			strCepresidencia 				= TRIM(rs("Cepresidencia"))
			
			'dados familiares
			strPai 							= TRIM(rs("Pai"))
			strPaifalecido 					= TRIM(rs("Paifalecido"))
			strPaifone 						= TRIM(rs("Paifone"))
			strPaidatanascimento			= formataDataAP(TRIM(rs("Paidatanascimento")))
			intCodProfissaoPai				= TRIM(rs("Pai_cod_profissao"))
			intCodGrauInstrucaoPai			= TRIM(rs("Pai_cod_grauinstrucao"))
			strMae 							= TRIM(rs("Mae"))
			strMaefalecida 					= TRIM(rs("Maefalecida"))
			strMaefone 						= TRIM(rs("Maefone"))
			strMaedatanascimento			= formataDataAP(TRIM(rs("Maedatanascimento")))
			intCodProfissaoMae				= TRIM(rs("Mae_cod_profissao"))
			intCodGrauInstrucaoMae			= TRIM(rs("Mae_cod_grauinstrucao"))
			strResponsavel 					= TRIM(rs("Responsavel"))
			strCPFResponsavel				= TRIM(rs("CPFResponsavel"))
			strResponsavelfone 				= TRIM(rs("Responsavelfone"))
			strResponsaveldatanascimento	= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
			intCodProfissaoResponsavel		= TRIM(rs("Responsavel_cod_profissao"))
			intCodGrauInstrucaoResponsavel	= TRIM(rs("Responsavel_cod_grauinstrucao"))
			intQtdeIrmao 					= TRIM(rs("Qtde_irmao"))
			intQtdeIrmaoEscola				= TRIM(rs("Qtde_irmao_escola"))

			'documentos
			strIdentidade 					= TRIM(rs("Identidade"))
			strIdentidadeOrgao				= TRIM(rs("IdentidadeOrgao"))
			strIdentidadeUF					= TRIM(rs("IdentidadeUF"))
			strTituloNumero 				= TRIM(rs("TituloEleitor"))
			strTituloZona	 				= TRIM(rs("TituloZona"))
			strTituloSecao	 				= TRIM(rs("TituloSecao"))
			
			strRegmilitar 					= TRIM(rs("Regmilitar"))
			strCpfaluno 					= TRIM(rs("Cpfaluno"))
			
			'dados escolares
			intCodGradeCompleta				= TRIM(rs("Cod_gradevestibular"))
			strMesanovestibular 			= TRIM(rs("Mesanovestibular"))
		
			intCodFormaIngresso 			= TRIM(rs("cod_FormaIngresso"))
			strDataingresso 				= formataDataAP(TRIM(rs("Dataingresso")))
			intCodSituacaoAluno				= TRIM(rs("cod_SituacaoAluno"))
		
			strDatafastamento 				= formataDataAP(TRIM(rs("Datafastamento")))
			intCodMotivoAfastamento			= TRIM(rs("Cod_motivoafastamento"))
			strObsafastamento 				= TRIM(rs("Obsafastamento"))
		
			strDatacolacao 					= formataDataAP(TRIM(rs("Datacolacao")))
			strAnoconclusao 				= TRIM(rs("Anoconclusao"))
			strSemconclusao 				= TRIM(rs("Semconclusao"))
			strDataConclusao 				= TRIM(rs("DataConclusao"))
			strDatacertificado 				= formataDataAP(TRIM(rs("Datacertificado")))
			intCodDisciplinaVestibular		= TRIM(rs("Disciplina_Processo_Seletivo"))
			intViaCarterinha 				= TRIM(rs("Ctrviace"))
			strSetransp 					= TRIM(rs("Setransp"))
		
			'dados finaceiro
			intCodPlanoPagamento 			= TRIM(rs("cod_PlanoTurma"))
			strLogradouro_cobranca 			= TRIM(rs("Logradouro_cobranca"))
			strNumero_endereco_cobranca		= TRIM(rs("Numero_endereco_cobranca"))
			strComp_endereco_cobranca 		= TRIM(rs("Comp_endereco_cobranca"))
			strEscola						= Trim(RS("Escola_ensinomedio"))
			strEscolaOrigem					= Trim(RS("Escola_origem"))
			strCodigoInep					= Trim(RS("CodigoInep"))
			strCidade			 			= Trim(RS("Cidade_ensinomedio"))
			strAnoconclusaoEnsinoMedio 		= Trim(RS("ano_ensinomedio"))
			strSemestreconclusaoEnsinoMedio	= Trim(RS("semestre_ensinomedio"))
			strUfEnsinoMedio				= Trim(RS("uf_ensinomedio"))		

			rs.movenext
			if rs.eof = false then %>
				<!--include file="../../includes/inc_cabecalhoRelatorio.asp"-->	
			<%
			end if
			wend
		end if 
		rs.close
		end if 
		%>
			<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
            <br>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="12%" align="justify" class="texto">Total de Alunos:</td>
			    <td width="88%" align="justify" class="texto"><%=intTotalAluno%></td>
		      </tr>
			  <tr>
			    <td colspan="2" align="justify" class="texto">&nbsp;</td>
		      </tr>
			</table>
			
	        <script>
		aguarde.style.display="none";
	</script>
</body>
</html>