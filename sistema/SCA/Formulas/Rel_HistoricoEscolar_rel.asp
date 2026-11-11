<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Ficha Individual do Aluno
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
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
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina

	strTituloRelatorio  	= "HISTÓRICO&nbsp;&nbsp;<br>"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub	


	strCod_empresa 		= Session("CodEmpresa")
	strCodAluno			= Trim(Request("txtCodAluno"))
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if

	if trim(strCodAluno) <> "" then
	
		sql = "SELECT S.Desc_SituacaoAluno, "
		sql = sql & " P.Desc_Profissao AS profissao,"
		sql = sql & " EC.Desc_EstadoCivil AS EstadoCivil,"
		sql = sql & " R.Desc_Religiao	AS Religiao,"
		sql = sql & " NE.Desc_NecEspecial AS NececidadeEspecial,"
		sql = sql & " PP.Desc_Profissao AS profissaoPai,"
		sql = sql & " PM.Desc_Profissao AS profissaoMae,"
		sql = sql & " GIP.Descricao AS GrauInstrucaoPai,"
		sql = sql & " GIM.Descricao AS GrauInstrucaoMae,"
		sql = sql & " PR.Desc_Profissao AS profissaoResp,"
		sql = sql & " GIR.Descricao AS GrauInstrucaoResp,"
		sql = sql & " UFI.Sigla AS descUFIDENTIDADE,"
		sql = sql & " UFN.Sigla AS descUFNASCIMENTO,"
		sql = sql & " UFR.Sigla AS descUfresidencia,"
		sql = sql & " O.DESCRICAO AS ORIGEM,"
		sql = sql & " DE.DESCRICAO AS DESCONTO,"
		sql = sql & " A.* "
		sql = sql & " FROM SCA_ALUNO A "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S	ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " LEFT JOIN SCA_PROFISSAO P		ON P.COD_PROFISSAO = A.COD_PROFISSAO "
		sql = sql & " LEFT JOIN SCA_ESTADOCIVIL EC	ON EC.COD_EstadoCivil = A.COD_EstadoCivil"
		sql = sql & " LEFT JOIN SCA_RELIGIAO R		ON R.COD_RELIGIAO = A.COD_RELIGIAO"
		sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL NE ON NE.COD_NECESPECIAL = A.COD_NECESPECIAL"
		sql = sql & " LEFT JOIN SCA_PROFISSAO PP		ON PP.COD_PROFISSAO = A.PAI_COD_PROFISSAO "
		sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIP ON GIP.CODIGO = A.PAI_COD_GRAUINSTRUCAO "
		sql = sql & " LEFT JOIN SCA_PROFISSAO PM		ON PM.COD_PROFISSAO = A.MAE_COD_PROFISSAO "
		sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIM ON GIM.CODIGO = A.MAE_COD_GRAUINSTRUCAO "
		sql = sql & " LEFT JOIN SCA_PROFISSAO PR		ON PR.COD_PROFISSAO = A.RESPONSAVEL_COD_PROFISSAO "
		sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIR ON GIR.CODIGO = A.RESPONSAVEL_COD_GRAUINSTRUCAO "
		sql = sql & " LEFT JOIN SCF_UF UFI				ON UFI.CODIGO = A.IdentidadeUF "
		sql = sql & " LEFT JOIN SCF_UF UFN				ON UFN.CODIGO = A.UFNASCIMENTO "
		sql = sql & " LEFT JOIN SCF_UF UFR				ON UFR.CODIGO = A.UFRESIDENCIA "
		sql = sql & " LEFT JOIN SCA_FORMAINGRESSO O		ON O.CODIGO = A.COD_FORMAINGRESSO AND O.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " LEFT JOIN SCF_categoria_desconto DE			ON DE.CODIGO = A.cod_categoria_desconto AND DE.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " Where A.COD_EMPRESA = " & strCod_empresa
		sql = sql & " And 	A.codigo in (" & strCodAluno & ")"
    	rs.open sql, cnn
		if rs.eof = false then
			strSituacaoAluno	= TRIM(rs("Desc_SituacaoAluno"))
			'dados pessoais
			strCodigo			= TRIM(rs("Codigo"))
			strMatricula 		= TRIM(rs("Matricula"))
			strNomealuno 		= TRIM(rs("Nomealuno"))
			strDatamatricula 	= formataDataAP(TRIM(rs("Datamatricula")))
			strNumeroRegistroNascimento  = TRIM(rs("NUMREGISTRONASC"))
			strSexo		 		= TRIM(rs("SexoAluno"))
			if strSexo = "M" then strSexo = "Masculino"
			if strSexo = "F" then strSexo = "Feminino"
			
			strDatanascimento 	= formataDataAP(TRIM(rs("Datanascimento")))
			strCidadenascimento = TRIM(rs("Cidadenascimento"))
			strUfnascimento 	= TRIM(rs("descUfnascimento"))
			strNacionalidade 	= TRIM(rs("Nacionalidade"))
			strEstadocivil 		= TRIM(rs("EstadoCivil"))
			strProfissao 		= TRIM(rs("Profissao"))
			strReligiao 		= TRIM(rs("Religiao"))
			strNecessidadeEspecial 	= TRIM(rs("NececidadeEspecial"))
			strAtendimentoespecial 	= TRIM(rs("Atendimentoespecial"))
			if strAtendimentoespecial = "S" then strAtendimentoespecial = "Sim"
			if strAtendimentoespecial = "N" then strAtendimentoespecial = "Não"
			strFoneResidencial 	= TRIM(rs("FoneResidencial"))
			strFonecomercial 	= TRIM(rs("Fonecomercial"))
			strFoneCelular	 	= TRIM(rs("Fonecelular"))
			strEmail 			= TRIM(rs("Email"))
			
			'endereço
			strLogradouro 		= TRIM(rs("Logradouro"))
			strNumero_endereco 	= TRIM(rs("Numero_endereco"))
			strComp_endereco 	= TRIM(rs("Comp_endereco"))
			strBairroaluno 		= TRIM(rs("Bairroaluno"))
			strCidaderesidencia	= TRIM(rs("Cidaderesidencia"))
			strUfresidencia 	= TRIM(rs("descUfresidencia"))
			strCepresidencia 	= TRIM(rs("Cepresidencia"))
			
			'dados familiares
			strPai 				= TRIM(rs("Pai"))
			strPaifalecido 		= TRIM(rs("Paifalecido"))
			if strPaifalecido = "S" then strPaifalecido = "Sim"
			if strPaifalecido = "N" then strPaifalecido = "Não"
			
			
			strPaifone 			= TRIM(rs("Paifone"))
			strPaidatanascimento= formataDataAP(TRIM(rs("Paidatanascimento")))
			strProfissaoPai= TRIM(rs("profissaoPai"))
			strGrauInstrucaoPai= TRIM(rs("grauinstrucaoPai"))
	
			strMae 				= TRIM(rs("Mae"))
			strMaefalecida 		= TRIM(rs("Maefalecida"))
			if strMaefalecida = "S" then strMaefalecida = "Sim"
			if strMaefalecida = "N" then strMaefalecida = "Não"
			
			
			strMaefone 			= TRIM(rs("Maefone"))
			strMaedatanascimento= formataDataAP(TRIM(rs("Maedatanascimento")))
			strProfissaoMae= TRIM(rs("profissaoMae"))
			strGrauInstrucaoMae= TRIM(rs("grauinstrucaoMae"))
	
			strResponsavel 				= TRIM(rs("Responsavel"))
			strResponsavelfone 			= TRIM(rs("Responsavelfone"))
			strResponsaveldatanascimento= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
			strProfissaoResponsavel= TRIM(rs("profissaoResp"))
			strGrauInstrucaoResponsavel= TRIM(rs("grauinstrucaoResp"))
	
			intQtdeIrmao 		= TRIM(rs("Qtde_irmao"))
			intQtdeIrmaoEscola	= TRIM(rs("Qtde_irmao_escola"))
	
			'documentos
			strIdentidade 		= TRIM(rs("Identidade"))
			strIdentidadeOrgao	= TRIM(rs("IdentidadeOrgao"))
			strIdentidadeUF		= TRIM(rs("descUFIDENTIDADE"))
			
			strTituloNumero 	= TRIM(rs("TituloEleitor"))
			strTituloZona	 	= TRIM(rs("TituloZona"))
			strTituloSecao	 	= TRIM(rs("TituloSecao"))
			
			strRegmilitar 		= TRIM(rs("Regmilitar"))
			strCpfaluno 		= TRIM(rs("Cpfaluno"))
			
			'dados escolares
			'intCodGradeCompleta	= TRIM(rs("Cod_gradevestibular"))
			strMesanovestibular = TRIM(rs("Mesanovestibular"))
		
			strOrigem 		= TRIM(rs("Origem"))
			strDataingresso 	= formataDataAP(TRIM(rs("Dataingresso")))
			strSituacaoAluno	= TRIM(rs("Desc_SituacaoAluno"))
		
			strDatafastamento 	= formataDataAP(TRIM(rs("Datafastamento")))
			strCod_motivoafastamento	= TRIM(rs("Cod_motivoafastamento"))
			strObsafastamento 	= TRIM(rs("Obsafastamento"))
		
			strDatacolacao 		= formataDataAP(TRIM(rs("Datacolacao")))
			strAnoconclusao 	= TRIM(rs("Anoconclusao"))
			strSemconclusao 	= TRIM(rs("Semconclusao"))
			strDatacertificado 	= formataDataAP(TRIM(rs("Datacertificado")))
		
			intViaCarterinha 	= TRIM(rs("Ctrviace"))
			strSetransp 		= TRIM(rs("Setransp"))
		
			'dados finaceiro
			'intCodPlanoPagamento 	= TRIM(rs("cod_PlanoTurma"))
			strDesconto 		= TRIM(rs("Desconto"))
			strBloqueio 		= TRIM(rs("Bloqueio"))
			strOrigbloq 		= TRIM(rs("Origbloq"))
		
			strLogradouro_cobranca 		= TRIM(rs("Logradouro_cobranca"))
			strNumero_endereco_cobranca	= TRIM(rs("Numero_endereco_cobranca"))
			strComp_endereco_cobranca 	= TRIM(rs("Comp_endereco_cobranca"))
		
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			mostraCabecalho
			
			%>
			<tr valign="top">
			<td>
			<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
			<td colspan="2" align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr> 
            <td colspan="2">
            <input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodigo%>" maxlength="10"></td>
            </tr>
            <tr> 
            <td width="457" height="20" bgcolor="#EEEEEE" class="texto1"><li><strong>Dados do Pessoais </strong></li></td>
            <td width="246" height="20" bgcolor="#EEEEEE" class="texto1" align="right">&nbsp;</td>
            </tr>
            <tr> 
            <td colspan="2" class="texto1" > 
            <!-- INICIO CAMPO - DADOS PESSOAIS-->
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
            <td width="18%" class="texto1">&nbsp;Matr&iacute;cula: </td>
            <td width="47%" class="texto1"><strong><%=strMatricula%></strong></td>
            <td width="16%" class="texto1">&nbsp;Sexo: </td>
            <td width="19%" class="texto1"><strong><%=strSexo%></strong></td>
            </tr>
            <tr> 
            <td class="texto1">&nbsp;Nome Completo: </td>
            <td class="texto1"><strong><%=strNomealuno%></strong></td>
            <td class="texto1">&nbsp;Data Nascimento: </td>
            <td class="texto1"><strong><%=strDatanascimento%></strong></td>
            </tr>
            <tr> 
            <td class="texto1">&nbsp;Naturalidade: </td>
            <td class="texto1"><strong><%=strCidadenascimento%></strong></td>
            <td class="texto1">&nbsp;Nacionalidade:</td>
            <td class="texto1"><strong><%=strNacionalidade%></strong></td>
            </tr>
            </table>
            <!-- FIM CAMPO - DADOS PESSOAIS-->
            </td>
            </tr>
            <tr> 
            <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1"  onClick="return dadosDocumentos()"><li><strong>Documentação</strong></li></td>
            </tr>
            <tr> 
            <td colspan="2" class="texto1" > 
            <!-- INICIO CAMPO - DADOS DOCUMENTOS-->
            <table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosDocumentos">
            <tr> 
            <td width="18%" class="texto1">&nbsp;Identidade: </td>
            <td width="47%" class="texto1"><strong><%=strIdentidade%>&nbsp;</strong>&nbsp;&nbsp;&nbsp;&Oacute;rg&atilde;o:<strong> <%=strIdentidadeOrgao%>&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;UF:<strong><%=strUFIdentidade%></strong></td>
            <td width="16%" class="texto1">&nbsp;CPF:</td>
            <td width="19%" class="texto1"><strong><%=strCpfaluno%></strong></td>
            </tr>
            <tr> 
            <td class="texto1">&nbsp;T&iacute;tulo:</td>
            <td class="texto1">Num&eacute;ro :<strong><%=strTituloNumero%>&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Zona:<strong><%=strTituloZona%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>Se&ccedil;&atilde;o:<strong><%=strTituloSecao%></strong></td>
            <td class="texto1">&nbsp;Registro Militar: </td>
            <td class="texto1"><strong><%=strRegmilitar%></strong></td>
            </tr>
            </table>
            <!-- FIM CAMPO - DADOS DOCUMENTOS-->
            </td>
            </tr>
            <%
	    	codHistoricoEscolar = 0
			sql = "select SCA_HISTORICO_ESCOLAR.codigo, cod_aluno, cod_empresa, ano_letivo, semestre, escola, cidade, SCF_UF.sigla as uf,curso, serie "
		    sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
			sql = sql & " INNER JOIN SCF_UF ON SCF_UF.CODIGO = SCA_HISTORICO_ESCOLAR.UF "
			sql = sql & " WHERE	COD_ALUNO = "& strCodigo
			sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
			sql = sql & " order by ano_letivo, semestre, serie"
			rsAux.open sql, cnn
			if not rsAux.eof then
			  'DADOS DO HISTORICO 
			  codHistoricoEscolar	= Trim(rsAux("codigo"))
	   		  strEscola			    = Trim(rsAux("escola"))
			  strCidade			    = Trim(rsAux("cidade"))
			  strUf	   			    = Trim(rsAux("uf"))
			  strAno				= Trim(rsAux("ano_letivo"))
			  strCurso	    		= Trim(rsAux("curso"))
			  strSemestre	 		= Trim(rsAux("semestre"))
		    end if
			rsAux.close
    		sql="SELECT TOP 1 A.CODIGO, C.DataAutorizacao, C.AUTORIZACAO, C.habilitacao, c.dataReconhecimento, C.reconhecimento, C.CH_exigida"
		    sql=sql & " FROM SCA_ALUNO A"
			sql=sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
			sql=sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
			sql=sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
			sql=sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND  T.COD_EMPRESA = G.COD_EMPRESA"
			sql=sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = G.COD_PERIODO AND  P.COD_EMPRESA = G.COD_EMPRESA"
			sql=sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND P.COD_EMPRESA = C.COD_EMPRESA"
			sql=sql & " WHERE AT.COD_ALUNO = " & strCodigo
			sql=sql & " AND AT.COD_EMPRESA = " & strCod_empresa
			sql = sql & " order by AT.CODIGO DESC "
			response.write sql
			response.end
   		    rsAUX.open sql, cnn
			if rsAUX.eof = false then
			   'DADOS DO HISTORICO 
			   strAutorizacao		= Trim(rsAux("autorizacao"))
			   strDataAutorizacao	= formatadataAP(Trim(rsAux("DataAutorizacao")))
			   strReconhecimento	= Trim(rsAux("reconhecimento"))
			   strDataAutorizacao	= formatadataAP(Trim(rsAux("DataReconhecimento")))
			   'strIngresso			= Trim(rsAux("Ingresso"))
			   'strCHCumprida		= Trim(rsAux("CH_Cumprida"))
			   strCHExigida		= Trim(rsAux("CH_Exigida"))
		    else
			%>
            <script>
			   alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
			</script>
            <%
		end if
		rsAUX.close
	    %>
        <tr> 
        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Conclus&atilde;o do Ensino M&eacute;dio </strong></li></td>
        </tr>
        <tr> 
        <td colspan="2" class="texto1" > 
        <!-- INICIO CAMPO - DADOS DOCUMENTOS-->
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
        <td width="18%" class="texto1">&nbsp;Unidade de Ensino: </td>
        <td width="47%" class="texto1"><strong><%=strEscola%></strong></td>
        <td width="16%" class="texto1">&nbsp;Munic&iacute;pio: </td>
        <td width="19%" class="texto1"><strong><%=strCidade%></strong></td>
        </tr>
        <tr> 
        <td class="texto1">&nbsp;Ano Conclus&atilde;o: </td>
        <td class="texto1"><strong><%=strAno%></strong></td>
        <td class="texto1">&nbsp;UF: </td>
        <td class="texto1"><strong><%=strUf%></strong></td>
        </tr>
        </table>
        <!-- FIM CAMPO - DADOS DOCUMENTOS-->
        </td>
        </tr>
        <tr> 
        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Curso / Habilita&ccedil;&atilde;o </strong></li></td>
        </tr>
        <tr> 
        <td colspan="2" class="texto1" > 
        <!-- INICIO CAMPO - DADOS DOCUMENTOS-->
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
        <td width="18%" class="texto1">Curso: </td>
        <td width="47%" class="texto1"><strong><%=strCurso%></strong></td>
        <td width="16%" class="texto1">&nbsp;Habilita&ccedil;&atilde;o: 
        </td>
        <td width="19%" class="texto1"><strong><%=strHabilitacao%></strong></td>
        </tr>
        </table>
        <!-- FIM CAMPO - DADOS DOCUMENTOS-->
        </td>
        </tr>
        <tr> 
        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Reconhecimento  / Publica&ccedil;&atilde;o / Carga Hor&aacute;ria </strong></li></td>
        </tr>
        <tr> 
        <td colspan="2" class="texto1" > 
        <!-- INICIO CAMPO - DADOS DOCUMENTOS-->
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
        <td width="18%" class="texto1">&nbsp;Reconhecimento: </td>
        <td width="47%" class="texto1"><strong><%=strReconhecimento%></strong></td>
        <td width="16%" class="texto1">&nbsp;Publica&ccedil;&atilde;o: 
        </td>
        <td width="19%" class="texto1"><strong><%=strDataReconhecimento%></strong></td>
        </tr>
        <tr> 
        <td class="texto1">&nbsp;Autoriza&ccedil;&atilde;o: </td>
        <td class="texto1"><strong><%=strAutorizacao%></strong></td>
        <td class="texto1">&nbsp;Publica&ccedil;&atilde;o: </td>
        <td class="texto1"><strong><%=strDataAutorizacao%></strong></td>
        </tr>
        <tr> 
        <td class="texto1">&nbsp;C.H. Exigida: </td>
        <td class="texto1"><strong><%=strCHExigida%></strong></td>
        <td class="texto1">&nbsp;C.H. Cumprida:</td>
        <td class="texto1"><strong><%=strCHCumprida%></strong></td>
        </tr>
        </table>
        <!-- FIM CAMPO - DADOS DOCUMENTOS-->
        </td>
        </tr>
        <tr> 
        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Dados da Conclus&atilde;o</strong></li></td>
        </tr>
        <tr> 
        <td colspan="2" class="texto1" > 
        <!-- INICIO CAMPO - DADOS DOCUMENTOS-->
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
        <td width="18%" class="texto1">&nbsp;Data Cola&ccedil;&atilde;o: 
        </td>
        <td width="47%" class="texto1"><strong><%=strDatacolacao%></strong></td>
        <td width="16%" class="texto1">&nbsp;Ano Conclus&atilde;o: </td>
        <td width="19%" class="texto1"><strong><%=strAnoconclusao%></strong></td>
        </tr>
        <tr> 
        <td class="texto1">&nbsp;Data Certificado: </td>
        <td class="texto1"><strong><%=strDatacertificado%></strong></td>
        <td class="texto1">&nbsp;</td>
        <td class="texto1">&nbsp;</td>
        </tr>
        </table>
        <!-- FIM CAMPO - DADOS DOCUMENTOS-->
        </td>
        </tr>
        </table>
		<%
		'historico disciplinas
        sql = "select *, d.desc_disciplina, he.serie  from sca_historico_escolar_disciplina hed "
        sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar "
        sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina AND d.cod_empresa = he.cod_empresa "
        sql = sql & " where hed.cod_historico_escolar = " & codHistoricoEscolar
        sql = sql & " order by hed.ano_letivo, hed.semestre, he.serie"
		response.write sql
		response.end
					'sql = "SELECT H.*, D.DESC_DISCIPLINA, P.DESCRICAO AS PERIODO, H.SITUACAO AS SITUACAOPROMOCAO"
						'sql = sql & " FROM SCA_HISTORICO_ESCOLAR E"
						'sql = sql & " inner JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA H ON H.cod_historico_escolar = E.CODIGO"
						'sql = sql & " inner JOIN SCA_PERIODO P ON P.COD_PERIODO = H.COD_PERIODO AND P.COD_EMPRESA = E.COD_EMPRESA"
						'sql = sql & " inner JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = H.COD_DISCIPLINA AND D.COD_EMPRESA = E.COD_EMPRESA"
						'sql = sql & " WHERE H.cod_historico_escolar  = " & codHistoricoEscolar
						
        rsAux.open sql, cnn
		if not rsAux.eof then	
		   %>						
		   <table width="100%" border="0" cellpadding="0" cellspacing="0">
		   <tr> 
		   <td width="44%" height="20" bgcolor="#EEEEEE" class="texto1" ><li><strong>Disciplinas</strong></li></td>
		   <td width="23%" height="20" bgcolor="#EEEEEE" class="texto1" ><div align="left"><strong>Per&iacute;odo</strong></div></td>
		   <td width="9%" height="20" bgcolor="#EEEEEE" class="texto1" ><div align="left"><strong>Ano/Sem.</strong></div></td>
		   <td width="9%" height="20" bgcolor="#EEEEEE" class="texto1" ><div align="left"><strong>C.H.</strong></div></td>
		   <td width="7%" height="20" bgcolor="#EEEEEE" class="texto1" ><div align="left"><strong>M&eacute;dia</strong></div></td>
		   <td width="8%" height="20" bgcolor="#EEEEEE" class="texto1" ><div align="left"><strong>Situa&ccedil;&atilde;o</strong></div></td>
		   </tr>
	       <%
	       while not rsAux.eof 
		      %>
		      <tr> 
	          <td height="15" class="texto1" >&nbsp;<%=rsAux("DESC_DISCIPLINA")%></td>
		      <td class="texto1" >&nbsp;<%=rsAux("PERIODO")%></td>
		      <td class="texto1" >&nbsp;<%=rsAux("ANO_LETIVO")%>/<%=rsAux("SEMESTRE")%></td>
		      <td class="texto1" >&nbsp;<%=rsAux("CARGA_HORARIA")%></td>
		      <td class="texto1" >&nbsp;<%=round(rsAux("MEDIA"),1)%></td>
		      <td class="texto1" >&nbsp;<%=rsAux("SITUACAO")%></td>
	          </tr>
		      <%
		      strPeriodoAnt = rsAux("PERIODO")
		      rsAux.movenext
		      if not RsAux.eof then
			     if trim(strPeriodoAnt) <> trim(rsAux("PERIODO")) then %>
				    <tr> 
				    <td colspan="6"><hr size="1" color="#999999"></td>
				    </tr>
				    <%
			     end if
	          end if
		   wend  
		   %>
           </table>
		   <%
		   end if
		   rsAux.close 
		   %>
		   <br>
		   <br>
		   <!--#include file="../includes/inc_RepresentantesLegais.asp"-->
		   <br>
		   <%
		   rs.movenext
		   if not rs.eof then
			  fimTabela
		  	  %>
			  <pre></pre>				
		      <%			
	       end if
		end if 
		rs.close
	else
		%>
		<script>
			alert("Aluno não foi encontrato, verifique.");
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