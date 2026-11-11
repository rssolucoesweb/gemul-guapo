<%
response.Expires=0
RESPONSE.Buffer = false
Server.ScriptTimeOut = 5000
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/10/2012
	::	Objetivo Pagina...: Historico Escolar Ensino Fundamental
-->
<html>
<head>
<title><%=session("Titulo")%> - Histórico Escolar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
  <!--#include file="../../includes/inc_verificaSession.asp"-->
  <!--#include file="../../includes/inc_cnn.asp"-->
  <!--#include file="../../includes/inc_formatadata.asp"-->
  <!--#include file="../../includes/inc_formataCPF.asp"-->
  <!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
  <!--#include file="../../includes/inc_aguarde.asp"-->

<%
	dim intPagina
	intPagina = 1
	
	strCod_empresa 					= Session("CodEmpresa")
	strCodAluno						= Trim(Request("txtCodAluno"))
	strclasse                       = Trim(Request.Form("cmbTamanhoFonteArial"))
	strCabecalho					= Trim(Request.form("cmbCabecalho"))

		
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
		   strCodigo					= TRIM(rs("Codigo"))
		   strMatricula 				= TRIM(rs("Matricula"))
		   strNomealuno 				= TRIM(rs("Nomealuno"))
		   strDatamatricula 			= formataDataAP(TRIM(rs("Datamatricula")))
		   strNumeroRegistroNascimento  = TRIM(rs("NUMREGISTRONASC"))
		   strSexo		 				= TRIM(rs("SexoAluno"))
		   
		   if strSexo = "M" then strSexo = "MASCULINO"
		   if strSexo = "F" then strSexo = "FEMININO"
		
		   strDatanascimento 			= formataDataAP(TRIM(rs("Datanascimento")))
		   strCidadenascimento 			= TRIM(rs("Cidadenascimento"))
		   strUfnascimento 				= TRIM(rs("descUfnascimento"))
		   strNacionalidade 			= TRIM(rs("Nacionalidade"))
		   strEstadocivil 				= TRIM(rs("EstadoCivil"))
		   strProfissao 				= TRIM(rs("Profissao"))
		   strReligiao 					= TRIM(rs("Religiao"))
		   strNecessidadeEspecial 		= TRIM(rs("NececidadeEspecial"))
		   strAtendimentoespecial 		= TRIM(rs("Atendimentoespecial"))
		   
		   if strAtendimentoespecial = "S" then strAtendimentoespecial = "Sim"
		   if strAtendimentoespecial = "N" then strAtendimentoespecial = "Não"
		   
		   strFoneResidencial 			= TRIM(rs("FoneResidencial"))
		   strFonecomercial 			= TRIM(rs("Fonecomercial"))
		   strFoneCelular	 			= TRIM(rs("Fonecelular"))
		   strEmail 					= TRIM(rs("Email"))
			
		   'endereço
		   strLogradouro 		= TRIM(rs("Logradouro"))
		   strNumero_endereco 	= TRIM(rs("Numero_endereco"))
		   strComp_endereco 	= TRIM(rs("Comp_endereco"))
		   strBairroaluno 		= TRIM(rs("Bairroaluno"))
		   strCidaderesidencia	= TRIM(rs("Cidaderesidencia"))
		   strUfresidencia 		= TRIM(rs("descUfresidencia"))
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
		
		
		sql="SELECT TOP 1 A.CODIGO, C.DataAutorizacao, C.AUTORIZACAO, C.habilitacao, c.dataReconhecimento, C.reconhecimento, "
		sql=sql & " C.CH_exigida, C.COD_CURSO, T.COD_TURMA, A.ESCOLA_ORIGEM "
		sql=sql & " FROM SCA_ALUNO A"
		sql=sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
		sql=sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql=sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
		sql=sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND  T.COD_EMPRESA = G.COD_EMPRESA"
		sql=sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = G.COD_PERIODO AND  P.COD_EMPRESA = G.COD_EMPRESA"
		sql=sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND P.COD_EMPRESA = C.COD_EMPRESA"
		sql=sql & " WHERE A.codigo in (" & strCodAluno & ")"
		sql=sql & " AND AT.COD_EMPRESA = " & strCod_empresa
		sql = sql & " order by AT.CODIGO DESC "
   		rsAux.open sql, cnn
		if rsAux.eof = false then
		   'DADOS DO HISTORICO 
		   intCodigoCurso 		= Trim(rsAux("COD_CURSO"))
		else
		   %>
           <script>
		      alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
	       </script>
           <%
	    end if
		rsAUX.close

		if intCodigoCurso = "" then intCodigoCurso = "" 
			
	End if
 %>    
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="52%" height="89" align="center" class="textoRelatorio"><strong>Hist&oacute;rico Escolar Ensino Fundamental</strong></td>
    <td width="48%" align="center"><table width="100%" height="84" border="0" align="center">
      <tr valign="top">
        <td height="80" class="celulaTopo" >
          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
              <td align="center"><strong>Carimbo da Escola</strong></td>
            </tr>
          </table>
          &nbsp;
          
          </td>
      </tr>
    </table></td>
  </tr>
</table>
<br>
<table width="98%" height="66" border="0" align="center">
  <tr>
    <td height="62" class="celulaTopo" >
    
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td width="14%"><strong>Estabelecimento:</strong></td>
        <td colspan="7"><%=session("EmpresaWeb")%>&nbsp;</td>
      </tr>
      <tr>
        <td><strong>Endere&ccedil;o:</strong></td>
        <td><%=session("EnderecoEmpresaWeb")%></td>
        <td><strong>Telefone:</strong></td>
        <td colspan="5"><%=session("TelefoneEmpresaWeb")%></td>
      </tr>
      <tr>
        <td><strong>Bairro:</strong></td>
        <td width="28%"><%=session("BairroEmpresaWeb")%></td>
        <td width="8%"><strong>CEP:</strong></td>
        <td width="10%"><%=session("CepEmpresaWeb")%></td>
        <td width="8%"><strong>Cidade:</strong></td>
        <td width="18%"><%=session("CidadeEmpresaWeb")%></td>
        <td width="5%"><strong>UF:</strong></td>
        <td width="9%"><%=session("UFEmpresaWeb")%></td>
      </tr>
      <tr>
        <td><strong>Atos de Legaliza&ccedil;&atilde;o do Estab.</strong></td>
        <td colspan="7"><%=strAutorizacao%></td>
      </tr>
      <tr>
        <td><strong>Entidade Mantenedora:</strong></td>
        <td colspan="7"><%=strMantenedora%></td>
      </tr>
    </table></td>
  </tr>
</table>
<table width="98%" height="70" border="0" align="center">
  <tr>
    <td height="66" class="celulaTopo" >
    
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

        <td width="14%"><strong>Nome do(a) Aluno(a):</strong></td>
        <td colspan="3"><%=strMatricula%> - <%=strNomealuno%></td>
        <td width="5%"><strong>Sexo:</strong></td>
        <td width="9%"><%=strSexo%></td>
      </tr>
      <tr>
        <td><strong>Nacionalidade:</strong></td>
        <td width="28%"><%=strNacionalidade%></td>
        <td width="8%"><strong>RG:</strong></td>
        <td colspan="3"><%=strIdentidade%></td>
      </tr>

      <tr>
        <td><strong>Pai:</strong></td>
        <td colspan="5"><%=strPai%></td>
      </tr>
      <tr>
        <td><strong>M&atilde;e:</strong></td>
        <td colspan="5"><%=strMae%></td>
      </tr>
      <tr>
        <td height="16"><strong>Data Nascimento:</strong></td>
        <td><%=strDatanascimento%></td>
        <td><strong>Naturalidade:</strong></td>
        <td><%=strCidadenascimento%></td>
        <td><strong>UF:</strong></td>
        <td><%=strUfnascimento%></td>
      </tr>
    </table></td>
  </tr>
</table>
<br>
<table width="98%" height="18" border="0" align="center">
  <tr>
    <td height="14" align="center" class="celulaTopo" ><strong>Estudos Realizados</strong></td>
  </tr>
</table>
<table width="98%" height="68" border="0" align="center">
<tr>
    		<td width="250" rowspan="2" class="celulaTopo"><strong>Disciplina</strong></td>
				<% 
				' Periodo de 1 ao 9 ano
				for i=1 to 9
                    %>
                       <td colspan="2" class="celulaTopo" align="center"><%=i%>º ANO</td>
                    <%
                next
                %>
      		</tr>
  			<tr>
  		<% 
		
		' Busca ano letivo pelo periodo 
		for i=1 to 9
		
			sql = "select DISTINCT ano_letivo, serie, semestre "
			sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
			sql = sql & " WHERE	COD_ALUNO = "& strCodAluno
			sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
			sql = sql & " and SUBSTRING(serie, 1, 1) = '" & i & "'"
			sql = sql & " and isnull(mostrar_historico_rel,'S') = 'S'"
			sql = sql & " order by ano_letivo, semestre"
			rs.open sql, cnn
			if not rs.eof then
				ano_letivo 	= rs("ano_letivo")
				%>
			  <td  align="center" class="celulaTopo"><%=ano_letivo%></td>
					<td  align="center" class="celulaTopo">C.H</td>
				<%
			else
				%>
					<td  align="center" class="celulaTopo">---</td>
					<td  align="center" class="celulaTopo">---</td>
				<%
			end if 
			rs.close 

		next
		%>
	  </tr>
	  <%
			intCh1 = 0
			intCh2 = 0
			intCh3 = 0
			intCh4 = 0
			intCh5 = 0
			intCh6 = 0
			intCh7 = 0
			intCh8 = 0
			intCh9 = 0
			
	  		' Busca as disciplinas pela grada curricular 9ano
			
			sql = " SELECT DISTINCT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.DESC_Disciplina "
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina" 
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular and Situacao='A'"
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_GRADECURRICULAR.COD_PERIODO "
			sql = sql & " WHERE SCA_DISCIPLINA.cod_empresa = "& strCod_empresa
			sql = sql & " AND SCA_PERIODO.COD_CURSO = "& intCodigoCurso
			sql = sql & " UNION "
			sql = sql & " select hed.Cod_Disciplina, d.DESC_Disciplina "
			sql = sql & " from sca_historico_escolar_disciplina hed "
			sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar and isnull(he.mostrar_historico_rel,'S') = 'S' " 
			sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina AND d.cod_empresa = he.cod_empresa " 
			sql = sql & " where HE.COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND COD_ALUNO = " & strCodAluno
			sql = sql & " AND hed.Cod_Disciplina NOT IN ( "
			sql = sql & " SELECT DISTINCT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina "
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA " 
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular and Situacao='A' "
 			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_GRADECURRICULAR.COD_PERIODO "
			sql = sql & " WHERE SCA_DISCIPLINA.cod_empresa = " & strCod_empresa
			sql = sql & " AND SCA_PERIODO.COD_CURSO = " & intCodigoCurso & ")"
			sql = sql & " Order by Desc_Disciplina "
			rsAux.open sql, cnn
			if not rsAux.eof then
				while not rsAux.eof 
					
					
					intCodDisciplina = rsAux("Cod_Disciplina")
					%>
					<tr>
					<td width="230" height="20" class="celulaTopo"><%=rsAux("DESC_Disciplina")%>&nbsp;</td>
                        
                    <%
					  	 ' Busca a carga horaria e media pela disciplina
                       	 for j=1 to 9
							
							sql = "select DISTINCT ano_letivo, serie, cod_periodo, semestre "
							sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
							sql = sql & " WHERE	COD_ALUNO = "& strCodAluno
							sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
							sql = sql & " and SUBSTRING(serie, 1, 1) = '" & j & "' "
							sql = sql & " and isnull(mostrar_historico_rel,'S') = 'S'"
							sql = sql & " order by ano_letivo, semestre"
							rs.open sql, cnn
							if not rs.eof then
								ano_letivo 	= rs("ano_letivo")
								serie 		= rs("serie")
								cod_periodo	= rs("cod_periodo")
								semestre 	= rs("semestre")
							else
								ano_letivo  = ""
								serie = ""
								semestre = ""
								cod_periodo = 0
							end if 
							rs.close 
							
							if ano_letivo <> "" then 
							
								sql = " select d.Cod_Disciplina, d.desc_Historico, hed.carga_horaria, isnull(cast(hed.media as varchar),'---') as media , he.COD_ALUNO, hed.situacao, hed.mostraNota"
								sql = sql & " from sca_historico_escolar_disciplina hed "
								sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar  and isnull(he.mostrar_historico_rel,'S') = 'S'"
								sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina "
								sql = sql & " WHERE he.COD_ALUNO = "& strCodAluno
								sql = sql & " And hed.ano_letivo = "& ano_letivo
								if isnull(cod_periodo) then
									sql = sql & " And he.serie = '" & serie & "'"
								else
									sql = sql & " And he.cod_periodo = " & cod_periodo
								end if
								sql = sql & " And hed.semestre = "& semestre
								sql = sql & " And D.Cod_Disciplina = "& intCodDisciplina
								'if session("usuarioWeb") = "SERGIO" then
								'	response.write sql
								'end if
								rsAux1.open sql, cnn
								if not rsAux1.eof then
									
									if j=1 then
										intCh1 = intCh1 + rsAux1("carga_horaria")
										strSituacao1 = rsAux1("situacao")
									end if
									if j=2 then
										intCh2 = intCh2 + rsAux1("carga_horaria")
										strSituacao2 = rsAux1("situacao")
									end if
									if j=3 then
										intCh3 = intCh3 + rsAux1("carga_horaria")
										strSituacao3 = rsAux1("situacao")
									end if
									if j=4 then
										intCh4 = intCh4 + rsAux1("carga_horaria")
										strSituacao4 = rsAux1("situacao")
									end if
									if j=5 then
										intCh5 = intCh5 + rsAux1("carga_horaria")
										strSituacao5 = rsAux1("situacao")
									end if
									if j=6 then
										intCh6 = intCh6 + rsAux1("carga_horaria")
										strSituacao6 = rsAux1("situacao")
									end if
									if j=7 then
										intCh7 = intCh7 + rsAux1("carga_horaria")
										strSituacao7 = rsAux1("situacao")
									end if
									if j=8 then
										intCh8 = intCh8 + rsAux1("carga_horaria")
										strSituacao8 = rsAux1("situacao")
									end if
									if j=9 then
										intCh9 = intCh9 + rsAux1("carga_horaria")
										strSituacao9 = rsAux1("situacao")
									end if
									
									if j <=5 then
										strCargaHoraria = "---"
									else
										strCargaHoraria = rsAux1("carga_horaria")
                                    end if
									
								    if trim(rsAux1("mostraNota")) = "N" then%>  
 										<td class="celulaTopo" align="center"><div align="center">&nbsp;---</div></td>
                                    <% else %>    
 										<td class="celulaTopo" align="center">&nbsp;<%=rsAux1("Media")%></td>
                                    <% end if %>    
									<td class="celulaTopo" align="center"><%=strCargaHoraria%></td>
								<%
								else
								%>
									<td class="celulaTopo" align="center">---</td>
									<td class="celulaTopo" align="center">---</td>
								<%
								end if 
								rsAux1.close 
							
							else
							%>
					 			<td class="celulaTopo" align="center">---</td>
                                <td class="celulaTopo" align="center">---</td>
							<%
							end if	
						
						next
					rsAux.movenext
					
				wend
			end if 
			rsAux.close 
			
		%>
        <tr bgcolor="#CCCCCC">
        <td width="230" height="20" class="celulaTopo"><strong>Carga Hor&aacute;ria:</strong></td>	
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh1%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh2%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh3%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh4%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh5%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh6%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh7%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh8%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=intCh9%></td>
        </tr>
       
<tr bgcolor="#CCCCCC">
        <td width="230" height="20" class="celulaTopo"><strong>Resultado Final</strong></td>	
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao1%></td>
    <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao2%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao3%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao4%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao5%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao6%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao7%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao8%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
        <td class="celulaTopo" align="center">&nbsp;<%=strSituacao9%></td>
        <td class="celulaTopo" align="center">&nbsp;</td>
  </tr>
</table>
<table width="98%" height="34" border="0" align="center">

  <tr>
    <td height="14" align="center" class="celulaTopo" ><strong>S&eacute;rie</strong></td>
    <td align="center" class="celulaTopo" ><strong>Ano</strong></td>
    <td align="center" class="celulaTopo" ><strong>Estabelecimento</strong></td>
    <td align="center" class="celulaTopo" ><strong>Municipio</strong></td>
    <td align="center" class="celulaTopo" ><strong>UF</strong></td>
  </tr>
  
  <%
	' Busca Serie, anno, Estabelicimnento e Municipio
	for i=1 to 9
			
			%>
              <tr>
			   <td height="14" align="center" class="celulaTopo"><%=i%>º ANO</td>
			  
			   <%
			sql = "select DISTINCT H.ano_letivo, H.serie, H.semestre, H.escola, H.Cidade, UF.SIGLA "
			sql = sql & " FROM SCA_HISTORICO_ESCOLAR H "
			sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = H.UF "
			sql = sql & " WHERE	H.COD_ALUNO = "& strCodAluno
			sql = sql & " AND	H.COD_EMPRESA = "& strCod_empresa
			sql = sql & " and SUBSTRING(H.serie, 1, 1) = '" & i & "'  and isnull(h.mostrar_historico_rel,'S') = 'S'"
			sql = sql & " order by H.ano_letivo, H.semestre"
			rs.open sql, cnn
			if not rs.eof then
				ano_letivo 	= rs("ano_letivo")
				%>
                <td align="center" class="celulaTopo" ><%=ano_letivo%></td>
                <td align="center" class="celulaTopo" ><%=ucase(rs("escola"))%></td>
                <td align="center" class="celulaTopo" ><%=ucase(rs("Cidade"))%></td>
                <td align="center" class="celulaTopo" ><%=ucase(rs("SIGLA"))%></td>
                <%
			else
				%>
                <td align="center" class="celulaTopo" >---</td>
                <td align="center" class="celulaTopo" >---</td>
                <td align="center" class="celulaTopo" >--</td>
                <td align="center" class="celulaTopo" >--</td>
                <%
			end if 
			rs.close 
  	next
  %>
  </tr>
</table>
<%
	' Busca a observação do aluno
	sql = "select ano_letivo, semestre, serie, isnull(observacao,'') as observacao, escola, cidade "
	sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
	sql = sql & " WHERE	COD_ALUNO = "& strCodAluno
	sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
	sql = sql & " AND	isnull(observacao, '') <> '' "
	sql = sql & " order by ano_letivo, semestre, serie"
	rs.open sql, cnn
	if not rs.eof then
		while not rs.eof 

			strObservacao =  strObservacao & trim(rs("serie"))  & " - " & trim(rs("observacao")) & "<br>"
			rs.movenext
					
		wend
	end if
	rs.close
%>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <td height="18" align="center" class="textoRelatorio">
	<% if strObservacao <> "" then %>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td height="21" align="center" class="texto"><strong>Transfer&ecirc;ncia do Aluno Durante o Ano Letivo</strong></td>
          <tr>
            <tr>
              <td align="left"><strong>Observa&ccedil;&atilde;o:</strong></td>
            </tr>
            <tr>
              <td align="left"><%=strObservacao%></td>
            </tr>
        </table>
    <% end if %>
      <tr valign="top">
        <td height="20" align="center" class="celulaTopo" ><strong><%=session("CidadeEmpresaWeb")%>&nbsp;, <%=day(date)%> de <%=monthname(month(date))%> de <%=year(date)%></strong></td>
      </tr>
    </td>
  </tr>
</table>
<br><br><br><br><br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="21" align="center" class="textoRelatorio">__________________________________</td>
    <td align="center" class="textoRelatorio">__________________________________</td>
    <td align="center" class="textoRelatorio">__________________________________</td>
  </tr>
  <tr>
    <td height="21" align="center" class="texto"><%=session("UsuarioWeb")%>&nbsp;</td>
    <td align="center" class="texto"><%=session("NomeSecretariaEmpresaWeb")%></td>
    <td align="center" class="texto"><%=session("NomeDiretorEmpresaWeb")%></td>
  </tr>
  <tr>
    <td height="21" align="center" class="texto">Usu&aacute;rio que confeccionou</td>
    <td align="center" class="texto">Secret&aacute;rio(a)</td>
    <td align="center" class="texto">Diretor(a)</td>
  </tr>
</table>
<br>
<script>
		aguarde.style.display="none";
	</script>
</body>
</html>