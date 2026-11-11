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
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->

<%
	dim intPagina
	intPagina = 1
	sub mostraCabecalho()
	
	if strCabecalho = "S" or strCabecalho = "0" then
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorioHistorico.asp"-->
        <%
	else
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorioHistoricoSimples.asp"-->
        <%
    end if 
    
	sql = "select Mantenedora, Autorizacao "
	sql = sql & " from seg_empresa "
	sql = sql & " where codigo = " & Session("CodEmpresa")
	rs.open sql, cnn
	if not rs.eof then
		strMantenedora = rs("Mantenedora")
		strAutorizacao = rs("Autorizacao")	
	end if
	rs.close	 
 %>    
    
      
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td class="texto1"><div align="center"><strong>HIST&Oacute;RICO ESCOLAR DO ENSINO FUNDAMENTAL</strong></div></td>
      </tr>
      <tr>    
        <td class="texto1"><div align="center">Mantenedora:&nbsp;&nbsp;<strong><%=strMantenedora%></strong></div></td>
        </tr>
        <tr>
          <td class="texto1"><table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
            <tr>
              <td colspan="5" bgcolor="#FFFFFF" class="<%=strclasse%>"><div align="center"><strong><%=strAutorizacao%></strong></div></td>
            </tr>
            

          </table></td>
        </tr>
        <tr> 
        <td class="texto1"><div align="center">&nbsp;&nbsp;</div></td>
      </tr>
    </table>

    
<!-- INICIO CAMPO - DADOS PESSOAIS-->
    <%if intPagina > 1 then %>
    	<br>
<table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
        <tr> 
        <td colspan="6" bgcolor="#999999" class="<%=strclasse%>"><li><strong>DADOS PESSOAIS </strong></li></td>
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
        <td class="<%=strclasse%>">&nbsp;NATURALIDADE: <strong><%=strCidadenascimento%> - <%=strUfnascimento%></strong></td>
        <td class="<%=strclasse%>">&nbsp;NACIONALIDADE:&nbsp;<strong><%=strNacionalidade%></strong></td>
        </tr>
    </table>
    
     <%end if%>
	<table width="100%" border="0" class="tabela" cellspacing="0" cellpadding="0">
	<BR>
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
	strCabecalho					= Trim(Request.form("cmbCabecalho"))
	strClassificacao				= Trim(Request.form("cmbClassificacao"))
	strFrequencia					= Trim(Request.form("txtFrequencia"))
	strMostraProfessor				= Trim(Request.form("txtMostraProfessor"))
	strOmiteRepresentanteLegais		= Trim(Request.form("txtOmiteRepresentanteLegais"))
	
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
		sql = sql & " VD.DESC_HISTORICO AS DISCIPLINA_PS,"
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
		sql = sql & " LEFT JOIN SCA_VESTIBULAR_DISCIPLINA VD		ON VD.CODIGO = A.Disciplina_Processo_Seletivo "
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
		   if strSexo = "M" then strSexo = "MASCULINO"
		   if strSexo = "F" then strSexo = "FEMININO"
		
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
		   strCpfaluno 			= formataCpfAP(TRIM(rs("Cpfaluno")))
		
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
		   strDisciplinaProcessoSeletivo	= TRIM(rs("DISCIPLINA_PS"))
		
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
		   
		else
		   %>
		   <script>
		      alert("Aluno não foi encontrato, verifique.");
			  window.history.back();
		   </script>
		   <%
		end if
	    rs.close
		
				
		sql = "select sum(hed.carga_horaria) as carga_horaria_cumprida "
		sql = sql & " from sca_historico_escolar_disciplina hed "
		sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar "
		sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina AND d.cod_empresa = he.cod_empresa "
		sql = sql & " where cod_historico_escolar IN (SELECT CODIGO FROM SCA_HISTORICO_ESCOLAR WHERE COD_ALUNO = " & strCodigo & "AND COD_EMPRESA = " & strCod_empresa & ")"
		sql = sql & " and isnull(hed.situacao,'0') <> '0'"
		sql = sql & " and hed.situacao <> 'TR' "
		sql = sql & " and hed.situacao <> 'TM' "
		sql = sql & " and hed.situacao <> 'RP' "
		sql = sql & " and hed.situacao <> 'RN' "
		sql = sql & " and hed.situacao <> 'CR' "
		sql = sql & " and hed.situacao <> 'RF' "
		rsAux.open sql, cnn
		if not rsAux.eof then
		   strCHCumprida  = Trim(rsAux("carga_horaria_cumprida"))
		   if isnull(strCHCumprida) then strCHCumprida = "0"
		end if
		rsAux.close	
		
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
		sql = sql & " order by Desc_Historico desc "
		rsAux.open sql, cnn
		if not rsAux.eof then
			strCursoHab=rsAux("Desc_Historico")
			strHab=rsAux("habilitacao")	
		end if
		rsAux.close	 
		
     	sql="SELECT TOP 1 A.CODIGO, C.DataAutorizacao, C.AUTORIZACAO, C.habilitacao, c.dataReconhecimento, C.reconhecimento, "
		sql=sql & " C.CH_exigida, C.COD_CURSO, T.COD_TURMA, A.ESCOLA_ORIGEM "
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
		   strDataReconhecimento= formatadataAP(Trim(rsAux("DataReconhecimento")))
		   strCHExigida			= Trim(rsAux("CH_Exigida"))
		   intCodigoCurso 		= Trim(rsAux("COD_CURSO"))
		   intCodigoTurma 		= Trim(rsAux("COD_TURMA"))
		   if isnull(strCHExigida) then strCHExigida = "0"
		   strEscolaOrigem		= Trim(rsAux("ESCOLA_ORIGEM"))
		else
		   %>
           <script>
		      alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
	       </script>
           <%
	    end if
		rsAUX.close

        if strTipoHistorico = "3" then          
			if clng(strCHCumprida) >= clng(strCHExigida) then 
				strTituloRelatorio = "H I S T Ó R I C O&nbsp;&nbsp;I N T E G R A L I Z A D O"
			else
				strTituloRelatorio = "H I S T Ó R I C O&nbsp;&nbsp;N Ã O&nbsp;&nbsp;I N T E G R A L I Z A D O"	
			end if
		else	
			strTituloRelatorio = "H I S T Ó R I C O"	
		end if	
		mostraCabecalho() 
   
   		%>
</table>
      <!-- INICIO CAMPO - DADOS PESSOAIS-->
      <table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
            <tr> 
              <td colspan="6" bgcolor="#999999" class="<%=strclasse%>"><li><strong>DADOS PESSOAIS </strong></li></td>
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
              <td class="<%=strclasse%>">&nbsp;NATURALIDADE: <strong><%=strCidadenascimento%> - <%=strUfnascimento%></strong></td>
              <td class="<%=strclasse%>">&nbsp;NACIONALIDADE:&nbsp;<strong><%=strNacionalidade%></strong></td>
            </tr>
<%
			if strTipoHistorico <> "3" then
		   %>
            <tr>
              <td class="<%=strclasse%>">&nbsp;NOME PAI: <%=strPai%> </td>
              <td class="<%=strclasse%>">&nbsp;NOME MÃE: <%=strMae%></td>
            </tr>
            <%
			end if  
        	%>
</table>
		<BR>
          <!-- FIM CAMPO - DADOS PESSOAIS-->
			<%
		if strTipoHistorico = "3" then
		   %>
          <!-- INICIO CAMPO - DADOS DE DOCUMENTAÇÃO-->
          <table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
            <tr> 
              <td colspan="2" bgcolor="#999999" class="<%=strclasse%>"><li><strong>DOCUMENTAÇÃO</strong></li></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>" >&nbsp;IDENTIDADE / &Oacute;RG&Atilde;O: <strong><%=strIdentidade%>&nbsp;<%=strIdentidadeOrgao%></strong>&nbsp;<%=strIdentidadeUF%><strong>&nbsp;</strong></td>
              <td width="26%" class="<%=strclasse%>" >CPF: <strong><%=strCpfaluno%></strong></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>" >&nbsp;TÍTULO ELEITOR: <strong><%=strTituloNumero%></strong></td>
              <td class="<%=strclasse%>" >DOCUMENTO MILITAR: <strong><%=strRegmilitar%></strong></td>
            </tr>
          </table>
		 <BR>

          <!-- FIM CAMPO - DADOS DE DOCUMENTAÇÃO-->
          <!-- INICIO CAMPO - DADOS DE CONCLUSÃO DO ENSINO MÉDIO-->
          <table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
            <tr> 
              <td colspan="5" bgcolor="#999999" class="<%=strclasse%>" ><li><strong>CONCLUSÃO DO ENSINO MÉDIO</strong></li></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>">&nbsp;<strong><%=strEscolaMedio%> - <%=strCidadeMedio%>-<%=strUfMedio%> - <%=strAnoMedio%></strong></td>
            </tr>
          </table>
          <BR>
          <!-- FIM CAMPO - DADOS DE CONCLUSÃO DO ENSINO MÉDIO-->
			<%
		end if  
        %>
          <!-- INICIO CAMPO - DADOS CURSO-->
          	<%
			if strTipoHistorico = "3" then
		   %>
          <table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
            <tr> 
              <td colspan="5" bgcolor="#999999" class="<%=strclasse%>" ><li><strong>CURSO / HABILITAÇÃO </strong></li></td>
            </tr>
            <tr> 
              <td class="<%=strclasse%>">&nbsp;<strong><%=strCursoHab%></strong></td>
            </tr>
          </table>
<%
		else
		   %>
          <!-- INICIO CAMPO - DADOS CURSO-->
<table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
            <tr> 
              <td colspan="6" bgcolor="#999999" class="<%=strclasse%>" ><li><strong>CURSO / HABILITAÇÃO </strong></li></td>
            </tr>
            <tr> 
              <td width="49%" class="<%=strclasse%>">&nbsp;<strong><%=strCursoHab%></strong></td>
              <td width="51%" class="<%=strclasse%>">CARGA HOR&Aacute;RIA CUMPRIDA: <strong><%=strCHCumprida%></strong></td>
            </tr>
</table>
<%
		end if
		   %>
           <BR>
          <!-- FIM CAMPO - DADOS CURSO-->
          <%
		if strTipoHistorico = "3" then
		   %>
		   	<table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
		      <tr>
		 	   <td colspan="9" bgcolor="#999999" class="<%=strclasse%>" ><li><strong>FORMA DE INGRESSO</strong></li></td>
		      </tr>
			  <tr>
				<td width="42%" class="<%=strclasse%>">&nbsp;<strong><%=strFormaIngresso%>&nbsp;<%=strMesanovestibular%>  </strong></td>
				<% if strDisciplinaProcessoSeletivo <> "0" and strFormaIngresso = "PROCESSO SELETIVO"  then %>
			        <td width="58%" class="<%=strclasse%>"><strong>DISCIPLINA(S): <%=strDisciplinaProcessoSeletivo%> </strong></td>
                <% end if %>
<% if strFormaIngresso = "TRANSFERÊNCIA EXTERNA"  then %>
			        <td width="58%" class="<%=strclasse%>"><strong>INSTITUI&Ccedil;&Atilde;O DE ORIGEM : <%=strEscolaOrigem%> </strong></td>
                <% end if %>
			  </tr>
			</table>
			 <BR>
         	 <!-- INICIO CAMPO - DADOS RECONHECIMENTO-->
          	<table width="100%" bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
			   <tr> 
				<td colspan="8" bgcolor="#999999" class="<%=strclasse%>" ><li><strong>RECONHECIMENTO / PUBLICAÇÃO / CARGA HORÁRIA </strong></li></td>
		      <tr> 
                <% if isnull(strReconhecimento) or strReconhecimento = "" then  %>
                    <td width="18%" class="<%=strclasse%>">&nbsp;AUTORIZAÇÃO: <strong><%=strAutorizacao%></strong></td>
                    <td width="16%" class="<%=strclasse%>">&nbsp;PUBLICAÇÃO D.O.U.: <strong><%=strDataAutorizacao%></strong></td>
                <% else %>    
                    <td width="18%" class="<%=strclasse%>">&nbsp;RECONHECIMENTO: <strong><%=strReconhecimento%></strong></td>
                    <td width="16%" class="<%=strclasse%>">&nbsp;PUBLICAÇÃO D.O.U.: <strong><%=strDataReconhecimento%></strong></td>
                <% end if %>    
              </tr>
              <tr> 
                <td class="<%=strclasse%>">&nbsp;CARGA HORÁRIA EXIGIDA: <strong><%=strCHExigida%></strong></td>
                <td class="<%=strclasse%>">&nbsp;CARGA HORÁRIA CUMPRIDA: <strong><%=strCHCumprida%></strong></td>
              </tr>
            </table>
		   <BR>
          <!-- FIM CAMPO - DADOS DOCUMENTOS-->
          <!-- INICIO CAMPO - DADOS DOCUMENTOS-->
		  <% if clng(strCHCumprida) >= clng(strCHExigida) then %>
			  <table width="100%"bordercolor="#000000" border="1" cellpadding="0" cellspacing="0">
			  <tr> 
				<td colspan="8" bgcolor="#999999" class="<%=strclasse%>" ><li><strong>DADOS DA CONCLUSÃO</strong></li></td>
			  </tr>
			  <tr> 
				<td width="30%" class="<%=strclasse%>">CONCLUS&Atilde;O: <strong><%=strAnoconclusao%> / <%=strSemconclusao%></strong>&nbsp;</td>
				<td width="38%" class="<%=strclasse%>">&nbsp;COLAÇÃO DE GRAU: <strong><%=strDatacolacao%></strong><strong>&nbsp;</strong></td>
				<td width="32%" class="<%=strclasse%>">&nbsp;EXPEDIÇÃO DO DIPLOMA: <strong><%=strDatacertificado%></strong>&nbsp;</td>
				</tr>
			  </table>
			  <!-- FIM CAMPO - DADOS CONCLUSÃO-->
		  <% end if %>	  
		  <BR>
    </table>

<% end if %>						
		
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
      <tr> 
        <td width="30%" height="20" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>DISCIPLINAS</strong></div></td>
        <% if strMostraProfessor = "S" then %>
        	<td width="18%" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>PROFESSOR(A)</strong></div></td>
        <% end if %>
<% if strTipoHistorico = "3" then %>
        	<td width="10%" height="20" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>PER&Iacute;ODO/M&Oacute;DULO</strong></div></td>
        <% else %>
        	<td width="10%" height="20" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>S&Eacute;RIE/M&Oacute;DULO</strong></div></td>
        <% end if %>
        <td width="6%" height="20" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>ANO/SEM.</strong></div></td>
        <td width="5%" height="20" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>C.H.</strong></div></td>
        <td width="5%" height="20" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>MÉDIA</strong></div></td><br>
		<% if strFrequencia = "S" then %>
        	<td width="4%" height="20" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>FREQ.</strong></div></td>
        <% end if %>    
        <td width="7%" height="20" bgcolor="#999999" class="<%=strclasse%>" ><div align="center"><strong>SITUAÇÃO</strong></div></td>
      </tr>
      <%
		strAnoLetivoAnt=""
		strPrimeiro = "N"

	    codHistoricoEscolar = 0
		cont = 0
		'historico disciplinas
		sql = "select d.desc_Historico, hed.cod_periodo, hed.mostraNota,  hed.ano_letivo,  hed.semestre,  hed.carga_horaria, hed.media,  hed.situacao, "
		sql = sql & " he.serie, p.descricao, he.codigo, he.escola, he.cidade, u.sigla as uf, he.curso, he.observacao, "
		sql = sql & " dop.desc_Historico as Optativa, isnull(hed.cod_disciplina,'0') as cod_disciplina, isnull(hed.cod_turma,'0') as cod_turma, "
		sql = sql & " round((100-((Isnull(hed.falta01,'0') + Isnull(hed.falta02,'0') + Isnull(hed.falta03,'0') + Isnull(hed.falta04,'0') + "
		sql = sql & " Isnull(hed.falta05,'0') + Isnull(hed.falta06,'0') + Isnull(hed.falta07,'0') + Isnull(hed.falta08,'0') + Isnull(hed.falta09,'0') + "
		sql = sql & " Isnull(hed.falta10,'0') + Isnull(hed.falta11,'0') + Isnull(hed.falta12,'0') + Isnull(hed.falta13,'0') + Isnull(hed.falta14,'0') + "
		sql = sql & " Isnull(hed.falta15,'0'))*100/(case when hed.carga_horaria = 0 then 1 else hed.carga_horaria end ))),0) as FREQUENCIA "
		sql = sql & "from sca_historico_escolar_disciplina hed "
		sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar "
		sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina AND d.cod_empresa = he.cod_empresa "
		sql = sql & " left JOIN sca_periodo p ON p.cod_periodo = hed.cod_periodo AND p.cod_empresa = he.cod_empresa "
		sql = sql & " left JOIN SCF_UF u ON u.codigo = he.uf "
		sql = sql & " left JOIN SCA_OPTATIVAS op ON op.cod_empresa = he.cod_empresa and op.Ano_Letivo = hed.ano_letivo and op.Semestre_Letivo = hed.semestre and op.cod_curso = p.cod_curso and op.cod_periodo = p.cod_periodo"
		sql = sql & " left JOIN sca_disciplina dop ON dop.cod_disciplina = op.cod_disciplina AND dop.cod_empresa = op.cod_empresa "
		sql = sql & " WHERE	HE.COD_ALUNO = "& strCodigo
		
		if strClassificacao = "1" then
			sql = sql & " order by hed.ano_letivo, hed.semestre, p.descricao"
		else 	
			sql = sql & " order by he.serie, hed.ano_letivo, hed.semestre, p.descricao"
		end if	
	
		
		rsAux.open sql, cnn
		if not rsAux.eof then
			while not rsAux.eof 
			  	
				if trim(rsAux("CARGA_HORARIA")) <> "" then 
					strCargaHorario = trim(rsAux("CARGA_HORARIA"))
				else
					strCargaHorario = trim(rsAux("CARGA_HORARIA"))
				end if
				
				cont = cont + 1
				if trim(strAnoLetivoAnt) <> trim(rsAux("ANO_LETIVO")) and strPrimeiro = "S" and strClassificacao = "1" then
					%> 
				   <tr>
						<td colspan="8" height="5" class="<%=strclasse%>">&nbsp;</td>
				   </tr>
				<%
			  	else				  
				  	if trim(strSemestreAnt) <> trim(rsAux("SEMESTRE")) and strPrimeiro = "S" and strClassificacao = "1" then
						%> 
					   <tr>
							<td colspan="8" height="5"  class="<%=strclasse%>">&nbsp;</td>
					   </tr>
					   <%
				  	end if
			  	end if
			 
			  	strPrimeiro="S"
				
				if cont = 1 then 
					if trim(strPeriodoAnt) <> trim(rsAux("COD_PERIODO")) then
	
						if strTipoHistorico <> "3" then
							%> 
							<tr>
								<td colspan="8" class="<%=strclasse%>"><li><strong><%=rsAux("ano_letivo")%> - <%=rsAux("escola")%> - <%=rsAux("curso")%> - <%=rsAux("Cidade")%> - <%=rsAux("uf")%></strong></li></td>
							</tr>
<%
						end if
						
					end if
				end if
				
				sql = "SELECT DISTINCT SRH_COLABORADOR.NOME AS COLABORADOR"
				sql = sql & " FROM SCA_HORARIO_AULA"
				sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
				sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO = " & trim(rsAux("ano_letivo"))
				sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE = " & trim(rsAux("semestre"))
				sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA = " & trim(rsAux("cod_turma"))
				sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA = " & trim(rsAux("cod_disciplina"))
				rs1.open sql, cnn
				if not rs1.eof then 
					strProfessorResponsavel = rs1("COLABORADOR")
				else
					strProfessorResponsavel = " ** Professor não Informado no Horário ** "
				end if
				rs1.close
					
			  	%>
			  	<tr> 
				<td  width="30%" height="15" class="<%=strclasse%>" ><div align="left">&nbsp;<%=rsAux("DESC_HISTORICO")%>&nbsp;<%=rsAux("Optativa")%> </div></td>
                <% if strMostraProfessor = "S" then %>
				  <td class="<%=strclasse%>" >&nbsp;<%=strProfessorResponsavel%></td>
                <% end if %>
				<td  width="10%" class="<%=strclasse%>" ><div align="center">&nbsp;<%=mid(rsAux("SERIE"),1,2)%></div></td>
				<%
				if trim(rsAux("SEMESTRE")) <> 3  then
					%>
					<td  width="6%" class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("ANO_LETIVO")%>/<%=rsAux("SEMESTRE")%></div></td>
					<%
			  	else
					%>
					<td  width="5%" class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("ANO_LETIVO")%></div></td>
					<%
			  	end if
			  	%>
				<td width="5%" class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("CARGA_HORARIA")%></div></td>
				<%
			  	if isnull(rsAux("MEDIA")) then
				 	%>
					<td class="<%=strclasse%>" ><div align="center">&nbsp;----</div></td>
					<%
			  	else
					if trim(rsAux("mostraNota")) = "N" then
					 	%>
				  		<td  width="7%" class="<%=strclasse%>" ><div align="center">&nbsp;----</div></td>
						<%
					else
					 	%>
				  		<td  width="2%" class="<%=strclasse%>" ><div align="center">&nbsp;<%=round(rsAux("MEDIA"),1)%></div></td>
<%
					end if
			 	end if 
           		if strFrequencia = "S" then
					%>
					<td width="1%" class="<%=strclasse%>" ><div align="center"><%=rsAux("FREQUENCIA")%>%</div></td>
                    <%
				end if %>	    
				<td width="12%" class="<%=strclasse%>" ><div align="center">&nbsp;<%=rsAux("SITUACAO")%></div></td>
	  </tr>
				<%
				
				if intPagina = 1 then
				   ControleLinhaPorPagina = 36
				else   
				   ControleLinhaPorPagina = 55
				end if   
				   
				if intQtdeRegistroPorPagina >= ControleLinhaPorPagina then
			 		intPagina = intPagina + 1
				 	intQtdeRegistroPorPagina = 1
				 	fimTabela
					%>
					<pre></pre>
                    <tr>
					<td colspan="8" height="5"  class="<%=strclasse%>">&nbsp;</td>
					</tr>
				
					<%			
					mostraCabecalho
				end if	
				intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
				
			 	strEscola			    = Trim(rsAux("escola"))
			 	strCidade			    = Trim(rsAux("cidade"))
			 	strUf	   			    = Trim(rsAux("uf"))
			 	strAno	    			= Trim(rsAux("ano_letivo"))
			 	strCurso	    		= Trim(rsAux("curso"))
			 	strSemestre	 			= Trim(rsAux("semestre"))

				strPeriodoAnt = rsAux("COD_PERIODO")
				strAnoLetivoAnt = rsAux("ANO_LETIVO")
				strSemestreAnt = rsAux("SEMESTRE")
				rsAux.movenext
		
			 	if not RsAux.eof then
				
					if trim(strPeriodoAnt) <> trim(rsAux("COD_PERIODO")) then

				   		if strTipoHistorico <> "3" then
				   			%> 
							<tr>
								<td colspan="8" class="<%=strclasse%>"><li><strong><%=rsAux("ano_letivo")%> - <%=rsAux("escola")%> - <%=rsAux("curso")%> - <%=rsAux("Cidade")%> - <%=rsAux("uf")%></strong></li></td>
				   			</tr>
<%
				   		end if
					end if
			    end if
			 '
			wend
		 	 %>
			  <tr>
				<td colspan="8" bgcolor="#999999" class="celula"><div align="center"><strong><%=strTituloRelatorio%>&nbsp;</strong></div></td>
			  </tr>
</table>
		<% end if 
 		rsAux.close 
        
		rotulaObs = ""
   		sql = "select ano_letivo, semestre, serie, isnull(observacao,'') as observacao, escola, cidade "
		sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
		sql = sql & " WHERE	COD_ALUNO = "& strCodigo
		sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
		sql = sql & " AND	isnull(observacao, '') <> '' "
		sql = sql & " order by ano_letivo, semestre, serie"
		rs.open sql, cnn
		if not rs.eof then
		   rotulaObs = "S"
		   %>
		   <tr> 
		   	<td colspan="6" bgcolor="#999999" class="<%=strclasse%>">&nbsp;<strong>OBSERVAÇÕES:</strong></td>
	       </tr>
           <br>
		   <%
		   while not rs.eof 
		   
				if strTipoHistorico <> "3" then
				   %>
				   <tr> 
					 <td colspan="6" bgcolor="#999999" class="<%=strclasse%>" >&nbsp;<li> <%=Trim(Rs("serie"))%> &nbsp;<%=Trim(Rs("observacao"))%>&nbsp;</td>
				   </tr>
				   <%
 				else   
				   %>
				   <tr> 
					 <td colspan="6" bgcolor="#999999" class="<%=strclasse%>" align="justify">&nbsp;<li>&nbsp;<%=Trim(Rs("observacao"))%>&nbsp;</td>
				   </tr>
					<%
				end if 
				%>  
				<tr> 
					<td colspan="6" height="10" >&nbsp;</td>
				</tr>
				<%
				rs.movenext
			wend
		end if
		rs.close
		
   		sql = "select DISTINCT ano_letivo, semestre "
		sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
		sql = sql & " WHERE	COD_ALUNO = "& strCodigo
		sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
		sql = sql & " order by ano_letivo, semestre"
		rs.open sql, cnn
		if not rs.eof then
		
		   if rotulaObs = "" then
			   %>
			   <tr> 
				<td colspan="6" bgcolor="#999999" class="<%=strclasse%>">&nbsp;<strong>OBSERVAÇÕES:</strong></td>
			   </tr>
			   <br>
			   <%
		   end if  
		    
		   while not rs.eof 
		   
				sql = " select OBSERVACOES from SCA_HISTORICO_OBSERVACOES "
				sql = sql & " where Cod_empresa = " & strCod_empresa
				sql = sql & " and ano = " & rs("ano_letivo")
				sql = sql & " and semestre = " & rs("semestre")
				sql = sql & " and ISNULL(cod_curso,'0') = '0' "
				sql = sql & " and ISNULL(cod_turma,'0') = '0' "
				sql = sql & " and ISNULL(cod_aluno,'0') = '0' "
			
				rsaux.open sql, cnn
				if not rsaux.eof then
					while not rsaux.eof 
					   %>
					   <tr> 
						 <td colspan="6" bgcolor="#999999" class="<%=strclasse%>">&nbsp;<li>
						   <div align="justify">&nbsp;<%=Trim(rsaux("OBSERVACOES"))%>&nbsp;</div>
						 </td>
					   </tr>
					   <%
						rsaux.movenext
					wend
				end if	
				rsaux.close
		
				sql = " select OBSERVACOES from SCA_HISTORICO_OBSERVACOES "
				sql = sql & " where Cod_empresa = " & strCod_empresa
				sql = sql & " and ano = " & rs("ano_letivo")
				sql = sql & " and semestre = " & rs("semestre")
				sql = sql & " and cod_curso = " & intCodigoCurso
				sql = sql & " and ISNULL(cod_turma,'0') = '0' "
				sql = sql & " and ISNULL(cod_aluno,'0') = '0' "
				rsaux.open sql, cnn
				if not rsaux.eof then
					while not rsaux.eof 
					   %>
					   <tr> 
						 <td colspan="6" bgcolor="#999999" class="<%=strclasse%>">&nbsp;<li>
						   <div align="justify">&nbsp;<%=Trim(rsaux("OBSERVACOES"))%>&nbsp;</div>
						 </td>
					   </tr>
					   <%
						rsaux.movenext
					wend
				end if	
				rsaux.close
				sql = " select OBSERVACOES from SCA_HISTORICO_OBSERVACOES "
				sql = sql & " where Cod_empresa = " & strCod_empresa
				sql = sql & " and ano = " & rs("ano_letivo")
				sql = sql & " and semestre = " & rs("semestre")
				sql = sql & " and cod_curso = " & intCodigoCurso
				sql = sql & " and cod_turma = " & intCodigoTurma
				sql = sql & " and ISNULL(cod_aluno,'0') = '0' "
				rsaux.open sql, cnn
				if not rsaux.eof then
					while not rsaux.eof 
					   %>
					   <tr> 
						 <td colspan="6" bgcolor="#999999" class="<%=strclasse%>">&nbsp;<li>
						   <div align="justify">&nbsp;<%=Trim(rsaux("OBSERVACOES"))%>&nbsp;</div>
						 </td>
					   </tr>
					   <%
						rsaux.movenext
					wend
				end if	
				rsaux.close

				%>  
				<tr> 
					<td colspan="6" height="10" >&nbsp;</td>
				</tr>
<%
				rs.movenext
			wend
		end if
		rs.close
		
      %>
   
       <br>
		<table width="100%" border="1" cellspacing="0" cellpadding="0" class="tabela">

		    <td width="90%"  bgcolor="#999999" colspan="4" class="celulamenor"><strong>LEGENDA:</strong></td>
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
						<td width="25%" class="celulamenor"><%=strSigla1%> - <%=strDescricao1%>&nbsp;</td>
						<td width="25%" class="celulamenor"><%=strSigla2%> - <%=strDescricao2%>&nbsp;</td>
						<td width="25%" class="celulamenor"><%=strSigla3%> - <%=strDescricao3%>&nbsp;</td>
						<td width="25%" class="celulamenor"><%=strSigla4%> - <%=strDescricao4%>&nbsp;</td>
					  </tr>
  				<%			
		 			
		 		wend
		 	end if
			rsaux.close
		 %>
		</table>
       <br>
       <% if strOmiteRepresentanteLegais <> "S" then %>
	   		<!--#include file="../includes/inc_RepresentantesLegais.asp"-->
	   <% end if
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