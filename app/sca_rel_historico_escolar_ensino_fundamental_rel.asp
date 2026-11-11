<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
strPaginaDestino = ""
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">

</head>
<body>
<script src="js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="js/js_dragdrop.js"></script>

<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file=includes/inc_aguarde.asp-->



<%
	dim intPagina
	intPagina = 1
	
	strCod_empresa 					= Session("CodEmpresa")
	strCodAluno						= Trim(Request("txtCodAluno"))
	strclasse                       = Trim(Request.Form("cmbTamanhoFonteArial"))
	strCabecalho					= Trim(Request.form("cmbCabecalho"))

		
	if strCabecalho = "S" or strCabecalho = "0" then
		%>
		<!--#include file="includes/inc_cabecalhoRelatorioHistorico.asp"-->
        <%
	else
		%>
		<!--#include file="includes/inc_cabecalhoRelatorioHistoricoSimples.asp"-->
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
		sql = sql & " A.*, aa.datafastamento as datafastamento_ano_letivo, aa.datamatricula as datamatricula_ano_letivo "
		sql = sql & " FROM SCA_ALUNO A "
		sql = sql & " LEFT JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.Cod_ALUNO = A.CODIGO and AA.ANO_LETIVO = " & SESSION("strAnoLetivo") & " AND AA.COD_EMPRESA = " & SESSION("codEmpresa")
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S	ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO"
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
		sql = sql & " LEFT JOIN SCA_FORMAINGRESSO O		ON O.CODIGO = A.COD_FORMAINGRESSO "
		sql = sql & " Where A.codigo in (" & strCodAluno & ")"

    	rs.open sql, cnn
		if rs.eof = false then
		
		   strSituacaoAluno	= TRIM(rs("Desc_SituacaoAluno"))
		
		   'dados pessoais
		   strCodigo					= TRIM(rs("Codigo"))
		   strMatricula 				= TRIM(rs("Matricula"))
		   strNomealuno 				= TRIM(rs("Nomealuno"))
		   strDatamatricula 			= formataDataAP(TRIM(rs("Datamatricula_ano_letivo")))
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
	  
		   strDatafastamento 	= formataDataAP(TRIM(rs("Datafastamento_ano_letivo")))
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
		   
		else
		   %>
		   <script>
		      alert("Aluno não foi encontrato, verifique.");
			  window.history.back();
		   </script>
		   <%
		end if
	    rs.close
		
		
		sql="SELECT TOP 1 C.COD_CURSO"
		sql=sql & " FROM SCA_ALUNO A"
		sql=sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO  "
		sql=sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql=sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO "
		sql=sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR "
		sql=sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = G.COD_PERIODO "
		sql=sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO "
		sql=sql & " WHERE A.codigo in (" & strCodAluno & ")"
		sql=sql & " AND AT.COD_EMPRESA = " & strCod_empresa
		sql = sql & " order by AT.CODIGO DESC "
		'if session("usuarioWeb") = "sergio" or session("usuarioWeb") = "SERGIO" then
		'	response.write sql
		'end if
		
   		rsAux.open sql, cnn
		if rsAux.eof = false then
		   'DADOS DO HISTORICO 
		   intCodigoCurso 		= Trim(rsAux("COD_CURSO"))
		else
		   buscarNoHistoricoCurso = "S"
	    end if
		rsAUX.close
		
		'atos
		codigo_atos_legalizacao=""
		sql="select descricao, codigo"
		sql=sql & " from SCA_ATOS_LEGALIZACAO"
		sql=sql & " where cod_atos = 1" 'autorizacao
		sql=sql & " and cod_empresa = " & strCod_empresa
		sql=sql & " and cod_curso = " & intCodigoCurso
   		rsAux.open sql, cnn
		if rsAux.eof = false then
		   strAutorizacao 		= Trim(rsAux("descricao"))
		   codigo_atos_legalizacao = Trim(rsAux("codigo"))
	    end if
		rsAUX.close
		
		if codigo_atos_legalizacao<>"" then
			sql="select r.descricao"
			sql=sql & " from SCA_ATOS_LEGALIZACAO a"
			sql=sql & " inner join SCA_ATOS_LEGALIZACAO_RENOVACAO r on r.cod_atos_legalizacao = a.codigo"
			sql=sql & " where a.cod_atos = 1" 'autorizacao
			sql=sql & " and a.cod_empresa = " & strCod_empresa
			sql=sql & " and a.cod_curso = " & intCodigoCurso
			sql=sql & " and r.cod_atos_legalizacao = " & codigo_atos_legalizacao
			rsAux.open sql, cnn
			if rsAux.eof = false then
			   strRenovacaoAutorizacao 		= Trim(rsAux("descricao"))
			end if
			rsAUX.close
		end if
		codigo_atos_legalizacao=""
		sql="select descricao, codigo"
		sql=sql & " from SCA_ATOS_LEGALIZACAO"
		sql=sql & " where cod_atos = 2" 'credenciamento
		sql=sql & " and cod_empresa = " & strCod_empresa
		sql=sql & " and cod_curso = " & intCodigoCurso
   		rsAux.open sql, cnn
		if rsAux.eof = false then
		   strCredenciamento 		= Trim(rsAux("descricao"))
		   codigo_atos_legalizacao = Trim(rsAux("codigo"))
	    end if
		rsAUX.close
		
		if codigo_atos_legalizacao<>"" then
			sql="select r.descricao"
			sql=sql & " from SCA_ATOS_LEGALIZACAO a"
			sql=sql & " inner join SCA_ATOS_LEGALIZACAO_RENOVACAO r on r.cod_atos_legalizacao = a.codigo"
			sql=sql & " where a.cod_atos = 2" 'credenciamento
			sql=sql & " and a.cod_empresa = " & strCod_empresa
			sql=sql & " and a.cod_curso = " & intCodigoCurso
			sql=sql & " and r.cod_atos_legalizacao = " & codigo_atos_legalizacao
			rsAux.open sql, cnn
			if rsAux.eof = false then
			   strRecredenciamento 		= Trim(rsAux("descricao"))
			end if
			rsAUX.close
		end if
		if buscarNoHistoricoCurso = "S" then
		
			sql="select Cod_Curso from SCA_HISTORICO_ESCOLAR"
			sql = sql & " where cod_aluno = (" & strCodAluno & ") and cod_empresa = " & strCod_empresa
			rsAux.open sql, cnn
			if rsAux.eof = false then
			   'DADOS DO HISTORICO 
			   intCodigoCurso 		= Trim(rsAux("COD_CURSO"))
			else
				%>
				<script>
				alert("ATENÇÃO: Não foi encontrado dados para geração do histório, verifique no cadastro de historico escolar dessa unidade!");
				window.history.back();
				</script>
				<%
				response.end
			end if
			rsAUX.close

		end if

		if intCodigoCurso = "" then intCodigoCurso = "" 
			
	End if
 %>    
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" class="textoRelatorio"><strong>Hist&oacute;rico Escolar Ensino Fundamental</strong></td>
  </tr>
</table>
<br>
<table width="98%" height="66" border="0" align="center">
  <tr>
    <td height="62" class="celulaTopo" >
    
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td width="14%"><strong>&nbsp;Estabelecimento:</strong></td>
        <td colspan="7"><%=session("EmpresaWeb")%>&nbsp;</td>
      </tr>
      <tr>
        <td><strong>&nbsp;Endere&ccedil;o:</strong></td>
        <td><%=session("EnderecoEmpresaWeb")%></td>
        <td><strong>&nbsp;Telefone:</strong></td>
        <td colspan="5"><%=session("TelefoneEmpresaWeb")%></td>
      </tr>
      <tr>
        <td><strong>&nbsp;Bairro:</strong></td>
        <td width="28%"><%=session("BairroEmpresaWeb")%></td>
        <td width="8%"><strong>&nbsp;CEP:</strong></td>
        <td width="10%"><%=session("CepEmpresaWeb")%></td>
        <td width="8%"><strong>&nbsp;Cidade:</strong></td>
        <td width="18%"><%=session("CidadeEmpresaWeb")%></td>
        <td width="5%"><strong>&nbsp;UF:</strong></td>
        <td width="9%"><%=session("UFEmpresaWeb")%></td>
      </tr>
	  <tr>
        <td><strong>&nbsp;Autorização:</strong></td>
        <td><%=strAutorizacao%></td>
        <td width="22%"><strong>&nbsp;Renovação da Autorização:</strong></td>
        <td colspan="5"><%=strRenovacaoAutorizacao%></td>
      </tr>
	  <tr>
        <td><strong>&nbsp;Credenciamento:</strong></td>
        <td><%=strCredenciamento%></td>
        <td width="22%"><strong>&nbsp;Recredenciamento:</strong></td>
        <td colspan="5"><%=strRecredenciamento%></td>
      </tr>
    </table></td>
  </tr>
</table>
<table width="98%" height="70" border="0" align="center">
  <tr>
    <td height="66" class="celulaTopo" >
    
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

        <td width="14%"><strong>&nbsp;Nome do(a) Aluno(a):</strong></td>
        <td colspan="3"><%=strMatricula%> - <%=strNomealuno%></td>
        <td width="5%"><strong>&nbsp;Sexo:</strong></td>
        <td width="9%"><%=strSexo%></td>
      </tr>
      <tr>
        <td><strong>&nbsp;Nacionalidade:</strong></td>
        <td width="28%"><%=strNacionalidade%></td>
        <td width="8%"><strong>&nbsp;RG:</strong></td>
        <td colspan="3"><%=strIdentidade%></td>
      </tr>

      <tr>
        <td><strong>&nbsp;Pai:</strong></td>
        <td colspan="5"><%=strPai%></td>
      </tr>
      <tr>
        <td><strong>&nbsp;M&atilde;e:</strong></td>
        <td colspan="5"><%=strMae%></td>
      </tr>
      <tr>
        <td height="16"><strong>&nbsp;Data Nascimento:</strong></td>
        <td><%=strDatanascimento%></td>
        <td><strong>&nbsp;Naturalidade:</strong></td>
        <td><%=strCidadenascimento%></td>
        <td><strong>&nbsp;UF:</strong></td>
        <td><%=strUfnascimento%></td>
      </tr>
    </table></td>
  </tr>
</table>
<br>
<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
  <tr>
    <td height="14" colspan="20" align="center" class="celula" ><strong>Estudos Realizados</strong></td>
  </tr>
<tr>
    		<td width="250" rowspan="2" class="celula"><strong>Disciplina</strong></td>
				<% 
				' Periodo de 1 ao 9 ano
				for i=1 to 9
                    %>
                       <td colspan="2" class="celula" align="center"><%=i%>º ANO</td>
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
			sql = sql & " AND	COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	SUBSTRING(serie, 1, 1) = '" & i & "'"
			sql = sql & " and isnull(mostrar_historico_rel,'S') = 'S'"

			sql = sql & " order by ano_letivo, semestre"
			'response.write sql
			rs.open sql, cnn
			if not rs.eof then
				ano_letivo 	= rs("ano_letivo")
				%>
			  <td  align="center" class="celula"><%=ano_letivo%></td>
					<td  align="center" class="celula">C.H</td>
				<%
			else
				ano_letivo 	= 0
				%>
					<td  align="center" class="celula">---</td>
					<td  align="center" class="celula">---</td>
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
			
			sql = " SELECT DISTINCT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.DESC_Disciplina, '' as disciplina_digitadas, SCA_DISCIPLINA.ordem  "
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina" 
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular and SCA_GRADECURRICULAR.Situacao='A'"
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_GRADECURRICULAR.COD_PERIODO "
			sql = sql & " WHERE SCA_GRADECURRICULAR.diferenciada <> 'S'  AND SCA_DISCIPLINA.documento_oficial = 'S' AND SCA_PERIODO.COD_CURSO = "& intCodigoCurso
			sql = sql & " UNION "
			
			sql = sql & " SELECT DISTINCT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.DESC_Disciplina, '' as disciplina_digitadas, SCA_DISCIPLINA.ordem "
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular and SCA_GRADECURRICULAR.Situacao='A' "
			sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA = SCA_DISCIPLINA.COD_Disciplina AND  SCA_ALUNO_DISCIPLINA.COD_GRADECURRICULARDISCIPLINA = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_GRADECURRICULAR.COD_PERIODO "
			sql = sql & " WHERE SCA_PERIODO.COD_CURSO = "& intCodigoCurso & " and SCA_GRADECURRICULAR.diferenciada = 'S'  AND SCA_DISCIPLINA.documento_oficial = 'S' "
			sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_ALUNO = " & strCodAluno
			sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " UNION "
			
			sql = sql & " select hed.Cod_Disciplina, d.DESC_Disciplina, 'Ampl. da Aprendizagem/Núcleo Diversificado' as disciplina_digitadas, d.ordem "
			sql = sql & " from sca_historico_escolar_disciplina hed "
			sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar and isnull(he.mostrar_historico_rel,'S') = 'S' " 
			sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina " 
			sql = sql & " where COD_ALUNO = " & strCodAluno
			sql = sql & " AND	he.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND hed.Cod_Disciplina NOT IN ( "
			
			
			sql = sql & " SELECT DISTINCT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina" 
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular and SCA_GRADECURRICULAR.Situacao='A'"
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_GRADECURRICULAR.COD_PERIODO "
			sql = sql & " WHERE SCA_GRADECURRICULAR.diferenciada <> 'S'  AND SCA_DISCIPLINA.documento_oficial = 'S' AND SCA_PERIODO.COD_CURSO = "& intCodigoCurso
			sql = sql & " UNION "
			sql = sql & " SELECT DISTINCT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular and SCA_GRADECURRICULAR.Situacao='A' "
			sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA = SCA_DISCIPLINA.COD_Disciplina AND  SCA_ALUNO_DISCIPLINA.COD_GRADECURRICULARDISCIPLINA = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_GRADECURRICULAR.COD_PERIODO "
			sql = sql & " WHERE SCA_PERIODO.COD_CURSO = "& intCodigoCurso & " and SCA_GRADECURRICULAR.diferenciada = 'S'  AND SCA_DISCIPLINA.documento_oficial = 'S' "
			sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_ALUNO = " & strCodAluno
			sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " )"
			
			'sql = sql & " SELECT DISTINCT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina "
			'sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA " 
			'sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina " 
			'sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular and SCA_GRADECURRICULAR.Situacao='A' "
 			'sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_GRADECURRICULAR.COD_PERIODO "
			'sql = sql & " WHERE SCA_GRADECURRICULAR.diferenciada <> 'S'  AND  SCA_PERIODO.COD_CURSO = " & intCodigoCurso & ")"
			
			
			
			sql = sql & " Order by disciplina_digitadas, ordem, Desc_Disciplina "
			if ucase(session("usuarioweb")) = "SERGIO" then 
				'response.write sql
				'response.end
			end if
			rsAux.open sql, cnn
			if not rsAux.eof then
				foi_impresso = "" 
				while not rsAux.eof 
					
					disciplina_digitadas = rsAux("disciplina_digitadas")
					intCodDisciplina = rsAux("Cod_Disciplina")
					%>
					<tr>
					<%
					IF disciplina_digitadas<>"" and foi_impresso = "" then
					%>
					<td width="230" height="20" class="celula" colspan="19"><strong><%=rsAux("disciplina_digitadas")%></strong></td>
					</tr>
					<tr>
					<%
						foi_impresso = "S"
					END IF
					%>
					<td width="230" height="20" class="celula"><%=rsAux("DESC_Disciplina")%>&nbsp;</td>
                    <%
					
					  	 ' Busca a carga horaria e media pela disciplina
						for j=1 to 9

							
							sql = "select DISTINCT ano_letivo, serie, cod_periodo, semestre "
							sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
							sql = sql & " WHERE	COD_ALUNO = "& strCodAluno
							sql = sql & " AND	COD_EMPRESA = " & Session("CodEmpresa") 
							sql = sql & " AND	SUBSTRING(serie, 1, 1) = '" & j & "' "
							sql = sql & " and isnull(mostrar_historico_rel,'S') = 'S'"
							sql = sql & " order by ano_letivo, semestre"
							
							if session("usuarioWeb") = "SERGIO" and j=5 then
								'response.write sql & "<hr>"
							end if
							
								
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
							
								sql = " select d.Cod_Disciplina, d.desc_Historico, hed.carga_horaria, isnull(cast(hed.media as varchar),'---') as media , he.COD_ALUNO, hed.situacao, isnull(hed.mostraNota,'S') as mostraNota, he.ch_total, he.total_faltas"
								sql = sql & " from sca_historico_escolar_disciplina hed "
								sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar  and isnull(he.mostrar_historico_rel,'S') = 'S'"
								sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina "
								sql = sql & " WHERE he.COD_ALUNO = "& strCodAluno
								sql = sql & " And hed.ano_letivo = "& ano_letivo
								sql = sql & " And he.COD_EMPRESA = " & strCod_empresa
								if isnull(cod_periodo) then
									sql = sql & " And he.serie = '" & serie & "'"
								else
									sql = sql & " And he.cod_periodo = " & cod_periodo
								end if
								sql = sql & " And hed.semestre = "& semestre
								sql = sql & " And D.Cod_Disciplina = "& intCodDisciplina
								'if session("usuarioWeb") = "SERGIO" and j=5 then
								'	response.write j & " - " & sql & "<hr>"
								'end if
								rsAux1.open sql, cnn
								if not rsAux1.eof then
									
									if j=1 then
										if isnull(rsAux1("ch_total")) then
											intCh1 = intCh1 + rsAux1("carga_horaria")
										else
											intCh1 = rsAux1("ch_total")
										end if
										if strSituacao1 <> "RN" then
											strSituacao1 = rsAux1("situacao")
										end if
										
										total_faltas1 = rsAux1("total_faltas")
										
									end if
									
									if j=2 then
										if isnull(rsAux1("ch_total")) then
											intCh2 = intCh2 + rsAux1("carga_horaria")
										else
											intCh2 = rsAux1("ch_total")
										end if
										if strSituacao2 <> "RN" then
											strSituacao2 = rsAux1("situacao")
										end if
										
										total_faltas2 = rsAux1("total_faltas")
										
									end if
									if j=3 then
										if isnull(rsAux1("ch_total")) then
											intCh3 = intCh3 + rsAux1("carga_horaria")
										else
											intCh3 = rsAux1("ch_total")
										end if
										if strSituacao3 <> "RN" then
											strSituacao3 = rsAux1("situacao")
										end if
										
										total_faltas3 = rsAux1("total_faltas")
										
									end if
									if j=4 then
										if isnull(rsAux1("ch_total")) then
											intCh4 = intCh4 + rsAux1("carga_horaria")
										else
											intCh4 = rsAux1("ch_total")
										end if
										if strSituacao4 <> "RN" then
											strSituacao4 = rsAux1("situacao")
										end if
										
										total_faltas4 = rsAux1("total_faltas")
										
									end if
									if j=5 then
										if isnull(rsAux1("ch_total")) then
											intCh5 = intCh5 + rsAux1("carga_horaria")
										else
											intCh5 = rsAux1("ch_total")
										end if
										if strSituacao5 <> "RN" then
											strSituacao5 = rsAux1("situacao")
										end if
										
										total_faltas5 = rsAux1("total_faltas")
										
									end if
									if j=6 then
										if isnull(rsAux1("ch_total")) then
											intCh6 = intCh6 + rsAux1("carga_horaria")
										else
											intCh6 = rsAux1("ch_total")
										end if
										if strSituacao6 <> "RN" then
											strSituacao6 = rsAux1("situacao")
										end if
										if trim(rsAux1("situacao")) = "RN" then
											strContSituacaoRN6 = strContSituacaoRN6 + 1
										end if
										
										total_faltas6 = rsAux1("total_faltas")
										
									end if
									if j=7 then
										if isnull(rsAux1("ch_total")) then
											intCh7 = intCh7 + rsAux1("carga_horaria")
										else
											intCh7 = rsAux1("ch_total")
										end if
										if strSituacao7 <> "RN" then
											strSituacao7 = rsAux1("situacao")
										end if
										if trim(rsAux1("situacao")) = "RN" then
											strContSituacaoRN7 = strContSituacaoRN7 + 1
										end if
										
										total_faltas7 = rsAux1("total_faltas")
										
									end if
									if j=8 then
										if isnull(rsAux1("ch_total")) then
											intCh8 = intCh8 + rsAux1("carga_horaria")
										else
											intCh8 = rsAux1("ch_total")
										end if
										if strSituacao8 <> "RN" then
											strSituacao8 = rsAux1("situacao")
										end if
										if trim(rsAux1("situacao")) = "RN" then
											strContSituacaoRN8 = strContSituacaoRN8 + 1
										end if
										
										total_faltas8 = rsAux1("total_faltas")
										
									end if
									if j=9 then
										if isnull(rsAux1("ch_total")) then
											intCh9 = intCh9 + rsAux1("carga_horaria")
										else
											intCh9 = rsAux1("ch_total")
										end if
										if strSituacao9 <> "RN" then
											strSituacao9 = rsAux1("situacao")
										end if
										if trim(rsAux1("situacao")) = "RN" then
											strContSituacaoRN9 = strContSituacaoRN9 + 1
										end if
										
										total_faltas9 = rsAux1("total_faltas")
										
									end if
									
									if j <=5 then
										strCargaHoraria = "---"
									else
										strCargaHoraria = rsAux1("carga_horaria")
                                    end if
									
								    if trim(rsAux1("mostraNota")) = "N" then%>  
 										<td class="celula" align="center"><div align="center">&nbsp;---</div></td>
                                    <% else %>    
 										<td class="celula" align="center">&nbsp;<%=rsAux1("Media")%></td>
                                    <% end if %>   
                                    <%if isnull(rsAux1("ch_total")) then%> 
										<td class="celula" align="center"><%=strCargaHoraria%></td>
                                    <%else 
										response.write "<td class='celula' align='center'>---</td>"
                                      end if%> 
								<%
								else
								%>
									<td class="celula" align="center">---</td>
									<td class="celula" align="center">---</td>
								<%
								end if 
								rsAux1.close 
							
							else
							%>
					 			<td class="celula" align="center">---</td>
                                <td class="celula" align="center">---</td>
							<%
							end if	
						
						next
					rsAux.movenext
					
				wend
			end if 
			rsAux.close 
			
		%>
		<tr bgcolor="#CCCCCC">
			<td width="230" height="20" class="celula"><strong>Carga Hor&aacute;ria:</strong></td>    

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh1) and intCh1 <> "" then
				if cInt(intCh1) > 0 then 
					response.write intCh1 
				end if 
			end if
			%>
			</td>

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh2) and intCh2 <> "" then
				if cInt(intCh2) > 0 then 
					response.write intCh2 
				end if 
			end if
			%>
			</td>

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh3) and intCh3 <> "" then
				if cInt(intCh3) > 0 then 
					response.write intCh3 
				end if 
			end if
			%>
			</td>

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh4) and intCh4 <> "" then
				if cInt(intCh4) > 0 then 
					response.write intCh4 
				end if 
			end if
			%>
			</td>

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh5) and intCh5 <> "" then
				if cInt(intCh5) > 0 then 
					response.write intCh5 
				end if 
			end if
			%>
			</td>

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh6) and intCh6 <> "" then
				if cInt(intCh6) > 0 then 
					response.write intCh6 
				end if 
			end if
			%>
			</td>

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh7) and intCh7 <> "" then
				if cInt(intCh7) > 0 then 
					response.write intCh7 
				end if 
			end if
			%>
			</td>

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh8) and intCh8 <> "" then
				if cInt(intCh8) > 0 then 
					response.write intCh8 
				end if 
			end if
			%>
			</td>

			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;
			<%
			if not isNull(intCh9) and intCh9 <> "" then
				if cInt(intCh9) > 0 then 
					response.write intCh9 
				end if 
			end if
			%>
			</td>
		</tr>
		
		<%
		
		if total_faltas1 = 0 then 
			intFreqObtida1 = intCh1
		else
			if not isNull(intCh1) and intCh1 <> "" then
				if cInt(intCh1) > 0 then
					intFreqObtida1 = cInt(intCh1) - (total_faltas1 * 4)
				end if
			end if
		end if

		if total_faltas2 = 0 then 
			intFreqObtida2 = intCh2
		else
			if not isNull(intCh2) and intCh2 <> "" then
				if cInt(intCh2) > 0 then
					intFreqObtida2 = cInt(intCh2) - (total_faltas2 * 4)
				end if
			end if
		end if

		if total_faltas3 = 0 then 
			intFreqObtida3 = intCh3
		else
			if not isNull(intCh3) and intCh3 <> "" then
				if cInt(intCh3) > 0 then
					intFreqObtida3 = cInt(intCh3) - (total_faltas3 * 4)
				end if
			end if
		end if

		if total_faltas4 = 0 then 
			intFreqObtida4 = intCh4
		else
			if not isNull(intCh4) and intCh4 <> "" then
				if cInt(intCh4) > 0 then
					intFreqObtida4 = cInt(intCh4) - (total_faltas4 * 4)
				end if
			end if
		end if

		if total_faltas5 = 0 then 
			intFreqObtida5 = intCh5
		else
			if not isNull(intCh5) and intCh5 <> "" then
				if cInt(intCh5) > 0 then
					intFreqObtida5 = cInt(intCh5) - (total_faltas5 * 4)
				end if
			end if
		end if

		if total_faltas6 = 0 then 
			intFreqObtida6 = intCh6
		else
			if not isNull(intCh6) and intCh6 <> "" then
				if cInt(intCh6) > 0 then
					intFreqObtida6 = cInt(intCh6) - (total_faltas6 * 4)
				end if
			end if
		end if

		if total_faltas7 = 0 then 
			intFreqObtida7 = intCh7
		else
			if not isNull(intCh7) and intCh7 <> "" then
				if cInt(intCh7) > 0 then
					intFreqObtida7 = cInt(intCh7) - (total_faltas7 * 4)
				end if
			end if
		end if

		if total_faltas8 = 0 then 
			intFreqObtida8 = intCh8
		else
			if not isNull(intCh8) and intCh8 <> "" then
				if cInt(intCh8) > 0 then
					intFreqObtida8 = cInt(intCh8) - (total_faltas8 * 4)
				end if
			end if
		end if

		if total_faltas9 = 0 then 
			intFreqObtida9 = intCh9
		else
			if not isNull(intCh9) and intCh9 <> "" then
				if cInt(intCh9) > 0 then
					intFreqObtida9 = cInt(intCh9) - (total_faltas9 * 4)
				end if
			end if
		end if
		
		'percentual
		if total_faltas1 = 0 then 
			intPercFreq1 = "100"
		else
			if isNull(intCh1) then intCh1 = 0
			if cInt(intCh1) > 0 then
				intPercFreq1 = FormatNumber((intFreqObtida1 * 100) / cInt(intCh1),0)
			else
				intPercFreq1 = ""
			end if
		end if

		if total_faltas2 = 0 then 
			intPercFreq2 = "100"
		else
			if isNull(intCh2) then intCh2 = 0
			if cInt(intCh2) > 0 then
				intPercFreq2 = FormatNumber((intFreqObtida2 * 100) / cInt(intCh2),0)
			else
				intPercFreq2 = ""
			end if
		end if

		if total_faltas3 = 0 then 
			intPercFreq3 = "100"
		else
			if isNull(intCh3) then intCh3 = 0
			if cInt(intCh3) > 0 then
				intPercFreq3 = FormatNumber((intFreqObtida3 * 100) / cInt(intCh3),0)
			else
				intPercFreq3 = ""
			end if
		end if

		if total_faltas4 = 0 then 
			intPercFreq4 = "100"
		else
			if isNull(intCh4) then intCh4 = 0
			if cInt(intCh4) > 0 then
				intPercFreq4 = FormatNumber((intFreqObtida4 * 100) / cInt(intCh4),0)
			else
				intPercFreq4 = ""
			end if
		end if

		if total_faltas5 = 0 then 
			intPercFreq5 = "100"
		else
			if isNull(intCh5) then intCh5 = 0
			if cInt(intCh5) > 0 then
				intPercFreq5 = FormatNumber((intFreqObtida5 * 100) / cInt(intCh5),0)
			else
				intPercFreq5 = ""
			end if
		end if

		if total_faltas6 = 0 then 
			intPercFreq6 = "100"
		else
			if isNull(intCh6) then intCh6 = 0
			if cInt(intCh6) > 0 then
				intPercFreq6 = FormatNumber((intFreqObtida6 * 100) / cInt(intCh6),0)
			else
				intPercFreq6 = ""
			end if
		end if

		if total_faltas7 = 0 then 
			intPercFreq7 = "100"
		else
			if isNull(intCh7) then intCh7 = 0
			if cInt(intCh7) > 0 then
				intPercFreq7 = FormatNumber((intFreqObtida7 * 100) / cInt(intCh7),0)
			else
				intPercFreq7 = ""
			end if
		end if

		if total_faltas8 = 0 then 
			intPercFreq8 = "100"
		else
			if isNull(intCh8) then intCh8 = 0
			if cInt(intCh8) > 0 then
				intPercFreq8 = FormatNumber((intFreqObtida8 * 100) / cInt(intCh8),0)
			else
				intPercFreq8 = ""
			end if
		end if

		if total_faltas9 = 0 then 
			intPercFreq9 = "100"
		else
			if isNull(intCh9) then intCh9 = 0
			if cInt(intCh9) > 0 then
				intPercFreq9 = FormatNumber((intFreqObtida9 * 100) / cInt(intCh9),0)
			else
				intPercFreq9 = ""
			end if
		end if


		if not isNull(intFreqObtida1) and intFreqObtida1 <> "" and isNumeric(intFreqObtida1) then
			if intFreqObtida1 = 0 then intFreqObtida1 = ""
		end if

		if not isNull(intFreqObtida2) and intFreqObtida2 <> "" and isNumeric(intFreqObtida2) then
			if intFreqObtida2 = 0 then intFreqObtida2 = ""
		end if

		if not isNull(intFreqObtida3) and intFreqObtida3 <> "" and isNumeric(intFreqObtida3) then
			if intFreqObtida3 = 0 then intFreqObtida3 = ""
		end if

		if not isNull(intFreqObtida4) and intFreqObtida4 <> "" and isNumeric(intFreqObtida4) then
			if intFreqObtida4 = 0 then intFreqObtida4 = ""
		end if

		if not isNull(intFreqObtida5) and intFreqObtida5 <> "" and isNumeric(intFreqObtida5) then
			if intFreqObtida5 = 0 then intFreqObtida5 = ""
		end if

		if not isNull(intFreqObtida6) and intFreqObtida6 <> "" and isNumeric(intFreqObtida6) then
			if intFreqObtida6 = 0 then intFreqObtida6 = ""
		end if

		if not isNull(intFreqObtida7) and intFreqObtida7 <> "" and isNumeric(intFreqObtida7) then
			if intFreqObtida7 = 0 then intFreqObtida7 = ""
		end if

		if not isNull(intFreqObtida8) and intFreqObtida8 <> "" and isNumeric(intFreqObtida8) then
			if intFreqObtida8 = 0 then intFreqObtida8 = ""
		end if

		if not isNull(intFreqObtida9) and intFreqObtida9 <> "" and isNumeric(intFreqObtida9) then
			if intFreqObtida9 = 0 then intFreqObtida9 = ""
		end if
		
		if not isNull(intCh1) and intCh1 <> "" then
			if cInt(intCh1) = 0 then 
				intFreqObtida1 = ""
				intPercFreq1 = ""
			end if
		else
			intFreqObtida1 = ""
			intPercFreq1 = ""
		end if

		if not isNull(intCh2) and intCh2 <> "" then
			if cInt(intCh2) = 0 then 
				intFreqObtida2 = ""
				intPercFreq2 = ""
			end if
		else
			intFreqObtida2 = ""
			intPercFreq2 = ""
		end if

		if not isNull(intCh3) and intCh3 <> "" then
			if cInt(intCh3) = 0 then 
				intFreqObtida3 = ""
				intPercFreq3 = ""
			end if
		else
			intFreqObtida3 = ""
			intPercFreq3 = ""
		end if

		if not isNull(intCh4) and intCh4 <> "" then
			if cInt(intCh4) = 0 then 
				intFreqObtida4 = ""
				intPercFreq4 = ""
			end if
		else
			intFreqObtida4 = ""
			intPercFreq4 = ""
		end if

		if not isNull(intCh5) and intCh5 <> "" then
			if cInt(intCh5) = 0 then 
				intFreqObtida5 = ""
				intPercFreq5 = ""
			end if
		else
			intFreqObtida5 = ""
			intPercFreq5 = ""
		end if

		if not isNull(intCh6) and intCh6 <> "" then
			if cInt(intCh6) = 0 then 
				intFreqObtida6 = ""
				intPercFreq6 = ""
			end if
		else
			intFreqObtida6 = ""
			intPercFreq6 = ""
		end if

		if not isNull(intCh7) and intCh7 <> "" then
			if cInt(intCh7) = 0 then 
				intFreqObtida7 = ""
				intPercFreq7 = ""
			end if
		else
			intFreqObtida7 = ""
			intPercFreq7 = ""
		end if

		if not isNull(intCh8) and intCh8 <> "" then
			if cInt(intCh8) = 0 then 
				intFreqObtida8 = ""
				intPercFreq8 = ""
			end if
		else
			intFreqObtida8 = ""
			intPercFreq8 = ""
		end if

		if not isNull(intCh9) and intCh9 <> "" then
			if cInt(intCh9) = 0 then 
				intFreqObtida9 = ""
				intPercFreq9 = ""
			end if
		else
			intFreqObtida9 = ""
			intPercFreq9 = ""
		end if
		%>
		
		<tr bgcolor="#CCCCCC">
			<td width="230" height="20" class="celula"><strong>Frequência obtida:</strong></td>	
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida1%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida2%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida3%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida4%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida5%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida6%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida7%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida8%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intFreqObtida9%></td>
        </tr>
		<tr bgcolor="#CCCCCC">
			<td width="230" height="20" class="celula"><strong>% Frequência:</strong></td>	
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq1%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq2%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq3%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq4%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq5%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq6%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq7%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq8%></td>
			<td class="celula" align="center">&nbsp;</td>
			<td class="celula" align="center">&nbsp;<%=intPercFreq9%></td>
        </tr>
       
<tr bgcolor="#CCCCCC">
        <td width="230" height="20" class="celula"><strong>Resultado Final</strong></td>	
        <td class="celula" align="center">&nbsp;<%=strSituacao1%></td>
		<td class="celula" align="center">&nbsp;</td>
        <td class="celula" align="center">&nbsp;<%=strSituacao2%></td>
        <td class="celula" align="center">&nbsp;</td>
        <td class="celula" align="center">&nbsp;<%=strSituacao3%></td>
        <td class="celula" align="center">&nbsp;</td>
        <td class="celula" align="center">&nbsp;<%=strSituacao4%></td>
        <td class="celula" align="center">&nbsp;</td>
        <td class="celula" align="center">&nbsp;<%=strSituacao5%></td>
        <td class="celula" align="center">&nbsp;</td>
        <td class="celula" align="center">&nbsp;<% if strContSituacaoRN6 < 3 and strSituacao6="RN" then%>AP<%else%><%=strSituacao6%><%end if%></td>
        <td class="celula" align="center">&nbsp;</td>
        <td class="celula" align="center">&nbsp;<% if strContSituacaoRN7 < 3 and strSituacao7="RN" then%>AP<%else%><%=strSituacao7%><%end if%></td>
        <td class="celula" align="center">&nbsp;</td>
        <td class="celula" align="center">&nbsp;<% if strContSituacaoRN8 < 3 and strSituacao8="RN" then%>AP<%else%><%=strSituacao8%><%end if%></td>
        <td class="celula" align="center">&nbsp;</td>
        <td class="celula" align="center">&nbsp;<% if strContSituacaoRN9 < 3 and strSituacao9="RN" then%>AP<%else%><%=strSituacao9%><%end if%></td>
        <td class="celula" align="center">&nbsp;</td>
  </tr>
</table>
<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">

  <tr>
    <td height="14" align="center" class="celula" ><strong>S&eacute;rie</strong></td>
    <td align="center" class="celula" ><strong>Ano</strong></td>
    <td align="center" class="celula" ><strong>Estabelecimento</strong></td>
    <td align="center" class="celula" ><strong>Municipio</strong></td>
    <td align="center" class="celula" ><strong>UF</strong></td>
  </tr>
  
  <%
	' Busca Serie, anno, Estabelicimnento e Municipio
	for i=1 to 9
			
			%>
              <tr>
			   <td height="14" align="center" class="celula"><%=i%>º ANO</td>
			  
			   <%
			sql = "select DISTINCT H.ano_letivo, H.serie, H.semestre, H.escola, H.Cidade, UF.SIGLA "
			sql = sql & " FROM SCA_HISTORICO_ESCOLAR H "
			sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = H.UF "
			sql = sql & " WHERE	H.COD_ALUNO = "& strCodAluno
			sql = sql & " AND	H.COD_EMPRESA = "& strCod_empresa
			sql = sql & " AND	SUBSTRING(H.serie, 1, 1) = '" & i & "'  and isnull(h.mostrar_historico_rel,'S') = 'S'"
			sql = sql & " order by H.ano_letivo, H.semestre"
			rs.open sql, cnn
			if not rs.eof then
				ano_letivo 	= rs("ano_letivo")
				%>
                <td align="center" class="celula" ><%=ano_letivo%></td>
                <td align="left" class="celula" ><%=ucase(rs("escola"))%></td>
                <td align="center" class="celula" ><%=ucase(rs("Cidade"))%></td>
                <td align="center" class="celula" ><%=ucase(rs("SIGLA"))%></td>
                <%
			else
				%>
                <td align="center" class="celula" >---</td>
                <td align="center" class="celula" >---</td>
                <td align="center" class="celula" >--</td>
                <td align="center" class="celula" >--</td>
                <%
			end if 
			rs.close 
  	next
  %>
  </tr>
<tr>
    <td height="24" colspan="5" align="center" class="celula" ><strong>Legenda de Situação do Aluno:</strong> AP - APROVADO | CR - CURSANDO | PP - PROGRESSÃO PARCIAL | AV - AVANÇO | RC - RECLASSIFICADO</td>
  </tr>
<%
	strObservacao=""
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
	
	strObservacaoGeral = ""
	' Busca a observação do aluno
	sql = "select observacoes "
	sql = sql & " FROM SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL "
	sql = sql & " WHERE	COD_ALUNO = "& strCodAluno
	rs.open sql, cnn
	if not rs.eof then
		if trim(rs("observacoes"))<>"" then
			strObservacaoGeral =  trim(rs("observacoes")) & "<br><br>"
		end if
	end if
	rs.close
%>
	<% if strObservacao <> "" then %>
	<tr>
	  <td align="left" colspan="5" class="celula">
	
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td height="21" align="center" class="texto"><strong>Transfer&ecirc;ncia do Aluno Durante o Ano Letivo</strong></td>
          <tr>
            <!--tr>
              <td align="left"><strong>Observa&ccedil;&atilde;o:</strong></td>
            </tr-->
            <tr>
              <td align="left"><%=strObservacao%></td>
            </tr>
        </table>
    <% end if %>
	
	
	<% if trim(strObservacaoGeral) <> "" then %>
		<% if strObservacao = "" then %>
		<tr>
		  <td align="left" colspan="5" class="celula">
		<% end if%>
	
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
              <td align="left"><strong>Observa&ccedil;&atilde;o Geral:</strong></td>
            </tr>
            <tr>
              <td align="left"><%=strObservacaoGeral%></td>
            </tr>
        </table>
    <% end if %>
	
	<% if strObservacao <> "" or trim(strObservacaoGeral) <> "" then %>
		</td>
	</tr>
	<% end if %>
	</table>	
	
	
	
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
		  <td align="left"><BR><strong><%=session("CidadeEmpresaWeb")%>,&nbsp;<%=day(date)%> de <%=monthname(month(date))%> de <%=year(date)%></strong><BR></td>
		</tr>
    </table>


<%
	sql = "select USUA_NOME_COMPLETO as nome from SEG_USUARIOS_SISTEMA where USUA_CODG = '" & session("usuarioWeb") & "'"
	strUsuarioLogado = ""
	rs.open sql, cnn
	if not rs.eof then
			strUsuarioLogado =  ucase(rs("nome"))
	end if
	rs.close
%>
<br><br><br><br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="21" align="center" class="textoRelatorio">__________________________________</td>
    <td align="center" class="textoRelatorio">__________________________________</td>
    <td align="center" class="textoRelatorio">__________________________________</td>
  </tr>
  <tr>
    <td height="21" align="center" class="texto"><%=strUsuarioLogado%>&nbsp;</td>
    <td align="center" class="texto"><%=session("NomeSecretariaEmpresaWeb")%></td>
    <td align="center" class="texto"><%=session("NomeDiretorEmpresaWeb")%></td>
  </tr>
  <tr>
    <td height="21" align="center" class="texto">Usu&aacute;rio que confeccionou</td>
    <td align="center" class="texto">Secretario(a) Geral</td>
    <td align="center" class="texto">Diretor(a)</td>
  </tr>
</table>
<br>
<script>
		aguarde.style.display="none";
	</script>
</body>
</html>