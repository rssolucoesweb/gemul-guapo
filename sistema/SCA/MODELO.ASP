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
<title><%=session("Titulo")%> - Histórico Escolar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style>

.celulaSemColunaEsquerdaDireita
{ 
	border-top: 1 solid #FFFFFF; 
	border-left: 1 solid #FFFFFF; 
	border-bottom: 1 solid #FFFFFF; 
	border-right: 1 solid #FFFFFF 
}

</style>
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

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" class="tabela" cellspacing="0" cellpadding="0">
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub	


	strCod_empresa 					= Session("CodEmpresa")
	strCodAluno						= Trim(Request("txtCodAluno"))
	strTipoHistorico 				= Trim(Request("cmbTipoHistorico"))
	strObservacao		   	 		= Trim(Request.Form("txtObservacao"))
	strclasse                       = Trim(Request.Form("cmbTamanhoFonteArial"))
	
	
	if strCodAluno = "" then
		strCodAluno					=	Trim(Request.form("chkAluno"))
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
		sql = sql & " UFEM.Sigla AS descUfMEDIO,"
		sql = sql & " O.DESCRICAO AS FORMAINGRESSO,"
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
		sql = sql & " LEFT JOIN SCF_UF UFEM				ON UFEM.CODIGO = A.UF_ENSINOMEDIO "
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
	
		   strFormaIngresso	= TRIM(rs("FORMAINGRESSO"))
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
	
		   strLogradouro_cobranca 		= TRIM(rs("Logradouro_cobranca"))
		   strNumero_endereco_cobranca	= TRIM(rs("Numero_endereco_cobranca"))
		   strComp_endereco_cobranca 	= TRIM(rs("Comp_endereco_cobranca"))
	
	
			strEscolaMedio	= TRIM(rs("ESCOLA_ENSINOMEDIO"))
			strCidadeMedio	= TRIM(rs("CIDADE_ENSINOMEDIO"))
			strUFMedio	= TRIM(rs("descUfMEDIO"))
			strAnoMedio	= TRIM(rs("ANO_ENSINOMEDIO"))
			
		   strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		   strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		   strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		   mostraCabecalho
		else
		   %>
		   <script>
		      alert("Aluno não foi encontrato, verifique.");
			  window.history.back();
		   </script>
		   <%
		end if
	    rs.close
		'   
   		%>
             
    <td colspan="8" class="<%=strclasse%>" > 
      <!-- INICIO CAMPO - DADOS PESSOAIS-->
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td colspan="6" bgcolor="#EEEEEE" class="celula"><li><strong>DADOS PESSOAIS </strong></li></td>
			</tr>
			<tr>    
              <td class="<%=strclasse%>">&nbsp;MATRICULA: <strong><%=strMatricula%></strong></td>
              <td width="51%" class="<%=strclasse%>">&nbsp;SEXO: <strong><%=strSexo%></strong></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>">&nbsp;NOME: <strong><%=strNomealuno%></strong></td>
              <td class="<%=strclasse%>">&nbsp;DATA NASCIMENTO: <strong><%=strDatanascimento%></strong></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>">&nbsp;NATURALIDADE: <strong><%=strCidadenascimento%></strong></td>
              <td class="<%=strclasse%>">&nbsp;NACIONALIDADE:&nbsp;<strong><%=strNacionalidade%></strong></td>
            </tr>
          </table>
          <!-- FIM CAMPO - DADOS PESSOAIS-->
			<%
		if strTipoHistorico = "3" then
		   %>
          <!-- INICIO CAMPO - DADOS DE DOCUMENTAÇÃO-->
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td height="20" colspan="2" bgcolor="#EEEEEE" class="<%=strclasse%>"><li><strong>DOCUMENTAÇÃO</strong></li></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>" >&nbsp;INDENTIDADE / &Oacute;RG&Atilde;O: <strong><%=strIdentidade%> /<%=strIdentidadeOrgao%></strong> - <%=strIdentidadeUF%><strong>&nbsp;</strong></td>
              <td width="26%" class="<%=strclasse%>" >CPF:<strong><%=strCpfaluno%></strong></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>" >&nbsp;TÍTULO ELEITOR:<strong><%=strTituloNumero%></strong></td>
              <td class="<%=strclasse%>" >DOCUMENTO MILITAR: <strong><%=strRegmilitar%></strong></td>
            </tr>
          </table>
          <!-- FIM CAMPO - DADOS DE DOCUMENTAÇÃO-->
          <!-- INICIO CAMPO - DADOS DE CONCLUSÃO DO ENSINO MÉDIO-->
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td height="20" colspan="5" bgcolor="#EEEEEE" class="<%=strclasse%>" ><li><strong>CONCLUSÃO DO ENSINO MÉDIO</strong></li></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>">&nbsp;<strong><%=strEscolaMedio%> - <%=strCidadeMedio%>-<%=strUfMedio%> - <%=strAnoMedio%></strong></td>
            </tr>
          </table>
          <!-- FIM CAMPO - DADOS DE CONCLUSÃO DO ENSINO MÉDIO-->
<%
		end if  
		 codHistoricoEscolar = 0
		sql = "select distinct SCA_HISTORICO_ESCOLAR.codigo"
		sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
		sql = sql & " INNER JOIN SCF_UF ON SCF_UF.CODIGO = SCA_HISTORICO_ESCOLAR.UF "
		sql = sql & " WHERE	COD_ALUNO = "& strCodigo
		sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
		rsAux.open sql, cnn
		if not rsAux.eof then
		     codHistoricoEscolar	= Trim(rsAux("codigo"))
		end if
		rsAux.close	
		
		strCursoHab=""
		strHab=""
		sql = "select distinct c.Desc_Historico, c.habilitacao"
		sql = sql & " from sca_historico_escolar_disciplina hed inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar "
		sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina AND d.cod_empresa = he.cod_empresa "
		sql = sql & " inner JOIN sca_periodo p ON p.cod_periodo = hed.cod_periodo AND p.cod_empresa = he.cod_empresa "
		sql = sql & " inner JOIN sca_curso c ON c.cod_curso = p.cod_curso AND p.cod_empresa = c.cod_empresa "
		sql = sql & " where hed.cod_historico_escolar = " & codHistoricoEscolar
		rsAux.open sql, cnn
		if not rsAux.eof then
			strCursoHab=rsAux("Desc_Historico")
			strHab=rsAux("habilitacao")	
		end if
		rsAux.close	 
        %>
          <!-- INICIO CAMPO - DADOS CURSO-->
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td height="20" colspan="5" bgcolor="#EEEEEE" class="<%=strclasse%>" ><li><strong>CURSO / HABILITAÇÃO </strong></li></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>">&nbsp;<strong><%=strCursoHab%>, <%=strHab%></strong></td>
            </tr>
          </table>
          <!-- FIM CAMPO - DADOS CURSO-->
          <%
		if strTipoHistorico = "3" then
		   %>
      <tr>
        <td height="20" colspan="8" bgcolor="#EEEEEE" class="<%=strclasse%>" ><li><strong>FORMA DE INGRESSO</strong></td>
      </tr>
      <tr>
        <td height="20" colspan="8" >
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td class="<%=strclasse%>">&nbsp;<strong><%=strFormaIngresso%> - <%=strMesanovestibular%></strong></td>
          </tr>
        </table>
        <BR>
        </td>
      </tr>
      <tr> 
        <td height="20" colspan="8" bgcolor="#EEEEEE" class="<%=strclasse%>" ><li><strong>RECONHECIMENTO 
        / PUBLICAÇÃO / CARGA HORÁRIA </strong></li></td>
      </tr>
      <tr> 
        <td colspan="8" class="<%=strclasse%>" > 
          <!-- INICIO CAMPO - DADOS RECONHECIMENTO-->
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="18%" class="<%=strclasse%>">&nbsp;RECONHECIMENTO: <strong><%=strReconhecimento%></strong></td>
              <td width="16%" class="<%=strclasse%>">&nbsp;PUBLICAÇÃO: 
                <strong><%=strDataReconhecimento%></strong></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>">&nbsp;C.H. EXIGIDA: <strong><%=strCHExigida%></strong></td>
              <td class="<%=strclasse%>">&nbsp;C.H. CUMPRIDA:<strong><%=strCHCumprida%></strong></td>
            </tr>
          </table>
          <!-- FIM CAMPO - DADOS DOCUMENTOS-->
        </td>
      </tr>
      <tr>
        <td height="8" colspan="8" >&nbsp;</td>
      </tr>
      <tr> 
        <td height="20" colspan="8" bgcolor="#EEEEEE" class="<%=strclasse%>" ><li><strong>DADOS 
        DA CONCLUSÃO</strong></li></td>
      </tr>
      <tr> 
        <td colspan="8" class="<%=strclasse%>" > 
          <!-- INICIO CAMPO - DADOS DOCUMENTOS-->
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="30%" class="<%=strclasse%>">CONCLUS&Atilde;O: 
              <strong><%=strDatacolacao%></strong></td>
              <td width="38%" class="<%=strclasse%>">&nbsp;COLAÇÃO DE GRAU:<strong><%=strDatacertificado%></strong><strong>&nbsp;</strong></td>
              <td width="32%" class="<%=strclasse%>">&nbsp;EXPEDIÇÃO DO DIPLOMA: 
              <strong><%=strAnoconclusao%></strong></td>
            </tr>
            </table>
          <!-- FIM CAMPO - DADOS DOCUMENTOS-->
        </td>
      </tr>
    </table>
    <BR>
<%   
		end if   
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
   		rsAux.open sql, cnn
		if rsAux.eof = false then
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
		'
		%>						
		
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
      <tr> 
        <td width="44%" height="20" bgcolor="#EEEEEE" class="<%=strclasse%>" ><div align="center"><strong>DISCIPLINAS</strong></div></td>
        <td width="23%" height="20" bgcolor="#EEEEEE" class="<%=strclasse%>" ><div align="center"><strong>SÉRIE/PERÍODO</strong></div></td>
        <td width="9%" height="20" bgcolor="#EEEEEE" class="<%=strclasse%>" ><div align="center"><strong>ANO/SEM.</strong></div></td>
        <td width="9%" height="20" bgcolor="#EEEEEE" class="<%=strclasse%>" ><div align="center"><strong>C.H.</strong></div></td>
        <td width="7%" height="20" bgcolor="#EEEEEE" class="<%=strclasse%>" ><div align="center"><strong>MÉDIA</strong></div></td>
        <td width="8%" height="20" bgcolor="#EEEEEE" class="<%=strclasse%>" ><div align="center"><strong>SITUAÇÃO</strong></div></td>
      </tr>
      <%
	  			 strAnoLetivoAnt=""
			 strPrimeiro = "N"

	    codHistoricoEscolar = 0
		sql = "select SCA_HISTORICO_ESCOLAR.codigo, cod_aluno, cod_empresa, ano_letivo, semestre, escola, cidade, SCF_UF.sigla as uf,curso, serie, observacao "
		sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
		sql = sql & " INNER JOIN SCF_UF ON SCF_UF.CODIGO = SCA_HISTORICO_ESCOLAR.UF "
		sql = sql & " WHERE	COD_ALUNO = "& strCodigo
		sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
		sql = sql & " order by ano_letivo, semestre, serie"
		rs.open sql, cnn
		if not rs.eof then
		   while not rs.eof 
   		     'DADOS DO HISTORICO 
		     codHistoricoEscolar	= Trim(rs("codigo"))
	   	     strEscola			    = Trim(rs("escola"))
		     strCidade			    = Trim(rs("cidade"))
		     strUf	   			    = Trim(rs("uf"))
		     strAno	    			= Trim(rs("ano_letivo"))
		     strCurso	    		= Trim(rs("curso"))
		     strSemestre	 		= Trim(rs("semestre"))
			 if not isnull(Rs("observacao")) then
				 if trim(strObservacao) = "" then
					 strObservacao   		= "<li>" & Trim(Rs("observacao"))
				 else
					strObservacao   		= strObservacao & "<br><li>" & Trim(Rs("observacao"))
				 end if
			 end if
			 '
		     'historico disciplinas
             sql = "select d.desc_disciplina, hed.cod_periodo, hed.mostraNota,  hed.ano_letivo,  hed.semestre,  hed.carga_horaria, hed.media,  hed.situacao, he.serie, p.descricao "
			 sql = sql & "from sca_historico_escolar_disciplina hed "
             sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar "
             sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina AND d.cod_empresa = he.cod_empresa "
             sql = sql & " inner JOIN sca_periodo p ON p.cod_periodo = hed.cod_periodo AND p.cod_empresa = he.cod_empresa "
             sql = sql & " where hed.cod_historico_escolar = " & codHistoricoEscolar
             sql = sql & " order by hed.ano_letivo, hed.semestre, he.serie, hed.situacao"
             rsAux.open sql, cnn
	         if not rsAux.eof then
			    while not rsAux.eof  
				  
				 ' response.Write "<hr>strAnoLetivoAnt" & strAnoLetivoAnt
				  'response.Write "<hr>rsAux(ANO_LETIVO)" & rsAux("ANO_LETIVO")
				  if trim(strAnoLetivoAnt) <> trim(rsAux("ANO_LETIVO")) and strPrimeiro = "S" then
					 	%> 
					   <tr>
                       		<td colspan="6" height="5" class="<%=strclasse%>">&nbsp;</td>
                       </tr>
<%
				  else				  
					  if trim(strSemestreAnt) <> trim(rsAux("SEMESTRE")) and strPrimeiro = "S" then
							%> 
						   <tr>
								<td colspan="6" height="5"  class="<%=strclasse%>">&nbsp;</td>
						   </tr>
						   <%
					  end if
				  end if
				  'response.Write "<hr>rsAux(ANO_LETIVO)" & rsAux("ANO_LETIVO")
				 
				  strPrimeiro="S"
				  %>
				  <tr> 
					<td height="15" class="<%=strclasse%>" ><div align="left">&nbsp;<%=rsAux("DESC_DISCIPLINA")%></div>
					  </td>
					<td class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("DESCRICAO")%></div></td>
					<%
							  if trim(rsAux("SEMESTRE")) <> 3  then
								 %>
					<td class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("ANO_LETIVO")%>/<%=rsAux("SEMESTRE")%></div></td>
					<%
							  else
								 %>
					<td class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("ANO_LETIVO")%></div></td>
					<%
				  end if
				  %>
				<td class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("CARGA_HORARIA")%></div></td>
				<%
				  if isnull(rsAux("MEDIA")) then
 				     %>
					<td class="<%=strclasse%>" ><div align="center">&nbsp;----</div></td>
					<%
				  else
							  		if trim(rsAux("mostraNota")) = "N" then
								 %>
					<td class="<%=strclasse%>" ><div align="center">&nbsp;----</div></td>
					<%
									else
								 %>
					<td class="<%=strclasse%>" ><div align="center">&nbsp;<%=round(rsAux("MEDIA"),1)%></div></td>
					<%
									end if
				 end if 
							 %>
					<td class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("SITUACAO")%></div></td>
	  				</tr>
				<%
				strPeriodoAnt = rsAux("COD_PERIODO")
				strAnoLetivoAnt = rsAux("ANO_LETIVO")
				strSemestreAnt = rsAux("SEMESTRE")
				rsAux.movenext
			
			     if not RsAux.eof then
					
			        if trim(strPeriodoAnt) <> trim(rsAux("COD_PERIODO")) then
					   if strCod_empresa <> 8 then
					   %> 
					   <tr>
                       		<td colspan="6" class="<%=strclasse%>"><li><strong><%=rs("ano_letivo")%> - <%=rs("escola")%> - <%=rs("curso")%></strong></li></td>
                       </tr>
<%
					   end if
					end if
				 else
				 	if strCod_empresa <> 8 then
				   %> 
				   <tr>
				   		<td height="20" colspan="6" class="<%=strclasse%>"><li><strong><%=rs("ano_letivo")%> - <%=rs("escola")%> - </strong><strong><%=rs("curso")%></strong></li></td>
				   </tr>
    				<%
					end if
				end if
				 '
				 wend
				 '  
		     end if
		     rsAux.close 
		     rs.movenext
		     if not rs.eof then
			   'fimTabela
		  	 ' <pre		  	 ' <pre></pre>  %>
 <%			
	        end if
		  wend 
	if trim(strObservacao) <> "" then
	   %>
	  <tr> 
		<td colspan="6" bgcolor="#EEEEEE" class="<%=strclasse%>">&nbsp;</td>
	  </tr>
	  <tr> 
		<td colspan="6" class="<%=strclasse%>">OBSERVAÇÕES:</td>
	  </tr>
	  <tr> 
		<td colspan="6" class="<%=strclasse%>" >&nbsp;<%=strObservacao%>&nbsp;</td>
	  </tr>
	  <%
	end if   
%>          
    </table>
          <%
 		  rs.close
	   end if 
	   %>
       <br>
		<table width="100%" border="1" cellspacing="0" cellpadding="0" class="tabela">

		    <td width="90%" colspan="4" class="celula"><strong>LEGENDA</strong></td>
     <%
			sql = "select desc_abreviada as sigla, descricao"
			sql = sql & " from sca_situacao_promocao"
			sql = sql & " where cod_empresa = " & strCod_empresa
			rsAux.open sql, cnn
	        if not rsAux.eof then
			    while not rsAux.eof  
					strSigla1 = ""
					strDescricao1 = ""				
					strSigla2 = ""
					strDescricao2 = ""				
					strSigla3 = ""
					strDescricao3 = ""				
					strSigla4 = ""
					strDescricao4 = ""				
				
					strSigla1 = rsAux("sigla")
					strDescricao1 = rsAux("descricao")
					if not rsaux.eof then
						rsaux.movenext
					end if
					if not rsaux.eof then
						strSigla2 = rsAux("sigla")
						strDescricao2 = rsAux("descricao")
						rsaux.movenext
						if not rsaux.eof then
							strSigla3 = rsAux("sigla")
							strDescricao3 = rsAux("descricao")
							rsaux.movenext
							if not rsaux.eof then
								strSigla4 = rsAux("sigla")
								strDescricao4 = rsAux("descricao")
								rsaux.movenext
							end if
						end if
					end if
					
					 %>
					  <tr>
						<td width="25%" class="celula"><%=strSigla1%> - <%=strDescricao1%>&nbsp;</td>
						<td width="25%" class="celula"><%=strSigla2%> - <%=strDescricao2%>&nbsp;</td>
						<td width="25%" class="celula"><%=strSigla3%> - <%=strDescricao3%>&nbsp;</td>
						<td width="25%" class="celula"><%=strSigla4%> - <%=strDescricao4%>&nbsp;</td>
  <%			
		 			
		 		wend
		 	end if
			rsaux.close
		 %>
		</table>
       <br>
	   <!--#include file="../includes/inc_RepresentantesLegais.asp"-->
	   <%
 	 else
		%>
		<script>
			alert("Aluno não foi encontrato, verifique.");
			window.history.back();
		</script>
		<%
	 end if 
	 %>
	 <script>
		aguarde.style.display="none";
	</script>
</body>
</html>