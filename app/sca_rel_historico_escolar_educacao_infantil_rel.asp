<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
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
    
	sql = "select Mantenedora, Autorizacao, CodTipoEmpresa "
	sql = sql & " from seg_empresa "
	sql = sql & " where codigo = " & Session("CodEmpresa")
	rs.open sql, cnn
	if not rs.eof then
		strMantenedora = rs("Mantenedora")
		strAutorizacao = rs("Autorizacao")	
		strCodTipoEmpresa = rs("CodTipoEmpresa")
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
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S	ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
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
		   strDatamatricula 			= formataDataAP(TRIM(rs("Datamatricula")))	'Guapó: data do cadastro do aluno
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
	  
		   strDatafastamento 	= formataDataAP(TRIM(rs("Datafastamento")))	'Guapó: data do cadastro do aluno
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
		
		
		'busca os anos de estudo do aluno
		strAnos = "0"
		strCodCursos = "0"
		strPeriodoAluno = ""
		strCHcurso = ""
		sql = "select DISTINCT H.ano_letivo, H.cod_curso, pe.DESCRICAO AS PERIODO, cu.ch_exigida"
		sql = sql & " FROM SCA_HISTORICO_ESCOLAR H "
		sql = sql & " LEFT JOIN SCA_periodo pe ON pe.COD_periodo = H.COD_periodo"
		sql = sql & " LEFT JOIN SCA_curso cu ON cu.cod_curso = pe.cod_curso"
		sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = H.UF "
		sql = sql & " WHERE	H.COD_ALUNO = "& strCodAluno
		sql = sql & " AND H.COD_EMPRESA = "& strCod_empresa
		sql = sql & " AND	H.curso = 'EDUCAÇÃO INFANTIL'"
		sql = sql & " and isnull(h.mostrar_historico_rel,'S') = 'S'"
		sql = sql & " order by H.ano_letivo"
		rs.open sql, cnn
		if not rs.eof then
			while not rs.eof
				strAnos = strAnos & "," & rs("ano_letivo")
				strCodCursos = strCodCursos & "," & rs("cod_curso")
				strPeriodoAluno = rs("PERIODO")
				strCHcurso = rs("ch_exigida")
				rs.movenext
			wend
		end if
		rs.close
		
		
		if strAnos="0" then
		%>
			<script>
				alert("Não foi encontrado historico para esse aluno!");
				window.history.back();
			</script>
		<%
			response.end
		end if
		
		sql = "select distinct d.Cod_Disciplina, d.Desc_Disciplina"
		sql = sql & " from SCA_DISCIPLINA d"
		sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA dd on dd.Cod_Disciplina = d.Cod_Disciplina"
		sql = sql & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = dd.Cod_GradeCurricular"
		sql = sql & " inner join SCA_PERIODO p on p.Cod_Periodo = g.Cod_Periodo"
		sql = sql & " where p.Cod_Curso in (" & strCodCursos & ")"
		sql = sql & " order by 2"
		vetDisciplinas = null
		existeDisciplina = "N"
		rs.open sql, cnn
		if not rs.eof then
			vetDisciplinas = rs.getRows
			existeDisciplina = "S"
		end if
		rs.close
		
		if trim(existeDisciplina) = "N" then
			%>
			<script>
				alert("Não foi encontrado disciplinas para gerar o historico do aluno!");
				window.history.back();
			</script>
			<%
			response.end
		end if
		
		
		'se for ano atual for igual ao ultimo sem o fechamento sim sai isso 
		'se for ano menor ou se ja tem fechamento não sai
		strAnoFechamento=""
		sql = "select isnull(max(ANO_LETIVO),0) as ano_letivo"
		sql = sql & " from SCA_FECHAMENTO_AGENDAMENTO"
		sql = sql & " where cod_aluno = " & strCodAluno
		rs.open sql, cnn
		if not rs.eof then
			strAnoFechamento = rs("ano_letivo")
		end if
		rs.close
			
	End if
 %>    
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="52%" height="89" align="center" class="textoRelatorio"><strong>HISTÓRICO ESCOLAR DA EDUCAÇÃO INFANTIL</strong></td>
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
        <td  colspan="2"><strong>Estabelecimento:</strong>&nbsp;<%=session("EmpresaWeb")%></td>
      </tr>
      <tr>
        <td width="50%"><strong>Endere&ccedil;o:</strong>&nbsp;<%=session("EnderecoEmpresaWeb")%></td>
        <td width="50%"><strong>Telefone:</strong>&nbsp;<%=session("TelefoneEmpresaWeb")%></td>
      </tr>
      <tr>
        <td><strong>Bairro:</strong>&nbsp;<%=session("BairroEmpresaWeb")%><strong>&nbsp;&nbsp;CEP:</strong>&nbsp;<%=session("CepEmpresaWeb")%></td>
        <td><strong>Cidade:</strong>&nbsp;<%=session("CidadeEmpresaWeb")%>&nbsp;<strong>UF:</strong>&nbsp;<%=session("UFEmpresaWeb")%></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Atos de Legaliza&ccedil;&atilde;o do Estab.</strong>&nbsp;<%=strAutorizacao%></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Entidade Mantenedora:</strong>&nbsp;<%=strMantenedora%></td>
      </tr>
    </table></td>
  </tr>
</table>
<table width="98%" height="70" border="0" align="center">
  <tr>
    <td height="66" class="celulaTopo" >
    
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

        <td width="50%"><strong>Nome do(a) Aluno(a):</strong>&nbsp;<%=strMatricula%> - <%=strNomealuno%></td>
        <td width="50%"><strong>Sexo:</strong>&nbsp;<%=strSexo%></td>
      </tr>
      <tr>
        <td><strong>Nacionalidade:</strong>&nbsp;<%=strNacionalidade%></td>
        <td><strong>RG:</strong>&nbsp;<%=strIdentidade%></td>
      </tr>

      <tr>
        <td><strong>Pai:</strong>&nbsp;<%=strPai%></td>
        <td><strong>M&atilde;e:</strong>&nbsp;<%=strMae%></td>
      </tr>
      <tr>
        <td height="16"><strong>Data Nascimento:</strong>&nbsp;<%=strDatanascimento%></td>
        <td><strong>Naturalidade:</strong>&nbsp;<%=strCidadenascimento%>&nbsp;&nbsp;<strong>UF:</strong><%=strUfnascimento%></td>
      </tr>
    </table></td>
  </tr>
</table>

<table width="98%" height="34" border="0" align="center">

  <tr>
    <td height="14" align="center" rowspan="2"  class="celulaTopo"><strong>Campos e Experiências</strong></td>
<%for i=1 to 5
	if i=1 then periodo = "INFANTIL I"
	if i=2 then periodo = "INFANTIL II"
	if i=3 then periodo = "INFANTIL III"
	if i=4 then periodo = "INFANTIL IV"
	if i=5 then periodo = "INFANTIL V"
	ano_letivo = "---"
	sql = "select DISTINCT H.ano_letivo, H.serie, H.semestre, H.escola, H.Cidade, UF.SIGLA "
	sql = sql & " FROM SCA_HISTORICO_ESCOLAR H "
	sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = H.UF "
	sql = sql & " WHERE	H.COD_ALUNO = "& strCodAluno
	sql = sql & " AND	H.COD_EMPRESA = "& strCod_empresa
	sql = sql & " and h.serie = '" & periodo & "'  and isnull(h.mostrar_historico_rel,'S') = 'S'"
	sql = sql & " order by H.ano_letivo, H.semestre"
	rs.open sql, cnn
	if not rs.eof then
		ano_letivo 	= rs("ano_letivo")
		
	end if
	rs.close
%>
	<td align="center" class="celulaTopo" ><strong><%=ano_letivo%></strong></td>
<%next%>  
  </tr>
  <tr>
<%for i=1 to 5
			if i=1 then periodo = "INFANTIL I"
			if i=2 then periodo = "INFANTIL II"
			if i=3 then periodo = "INFANTIL III"
			if i=4 then periodo = "INFANTIL IV"
			if i=5 then periodo = "INFANTIL V"
%>
	<td align="center" class="celulaTopo"><strong><%=periodo%></strong></td>
<%next%> 
  </tr>
  
  <%qtde_disc = 6%>
	<tr>
			<td height="14" align="left" class="celulaTopo">O Eu, o outro e o nós</td>
			<td align="center" rowspan="<%=qtde_disc%>" class="celulaTopo">Ficha descritiva</td>
			<td align="center" rowspan="<%=qtde_disc%>" class="celulaTopo">Ficha descritiva</td>
			<td align="center" rowspan="<%=qtde_disc%>" class="celulaTopo">Ficha descritiva</td>
			<td align="center" rowspan="<%=qtde_disc%>" class="celulaTopo">Ficha descritiva</td>
			<td align="center" rowspan="<%=qtde_disc%>" class="celulaTopo">Ficha descritiva</td>
	</tr>
	<tr>
			<td height="14" align="left" class="celulaTopo">Corpo, gestos e movimentos</td>
	</tr>
	<tr>
			<td height="14" align="left" class="celulaTopo">Escuta, fala, pensamento e imaginação</td>
	</tr>
	<tr>
			<td height="14" align="left" class="celulaTopo">Traços, sons, cores e formas</td>
	</tr>
	<tr>
			<td height="14" align="left" class="celulaTopo">Espaços, tempos, quantidades, relações e transformações</td>
	</tr>
	<tr>
			<td height="14" align="left" class="celulaTopo">Formação Pessoal e Social</td>
	</tr>
	<tr>
		<td height="14" align="left" class="celulaTopo"><strong>Carga Horária</strong></td>
		<%
		for i=1 to 5
			if i=1 then periodo = "INFANTIL I"
			if i=2 then periodo = "INFANTIL II"
			if i=3 then periodo = "INFANTIL III"
			if i=4 then periodo = "INFANTIL IV"
			if i=5 then periodo = "INFANTIL V"
			strCHcursoImp = "---"
			sql = "select DISTINCT H.ano_letivo, H.serie, H.semestre, H.escola, H.Cidade, UF.SIGLA, H.ch_total "
			sql = sql & " FROM SCA_HISTORICO_ESCOLAR H "
			sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = H.UF "
			sql = sql & " WHERE	H.COD_ALUNO = "& strCodAluno
			sql = sql & " AND	H.COD_EMPRESA = "& strCod_empresa
			sql = sql & " and h.serie = '" & periodo & "'  and isnull(h.mostrar_historico_rel,'S') = 'S'"
			sql = sql & " order by H.ano_letivo, H.semestre"
			rs.open sql, cnn
			if not rs.eof then
				strCHcursoImp = strCHcurso
				if not isnull(rs("ch_total")) then
					strCHcursoImp = rs("ch_total")
				end if
			end if
			rs.close
			%>
			<td align="center" class="celulaTopo"><strong><%=strCHcursoImp%></strong></td>
			<%
		next
		%>
	</tr>
	
	<tr>
			<td height="14" align="left" class="celulaTopo"><strong>Resultado Final</strong></td>
				<%
				for i=1 to 5
					if i=1 then periodo = "INFANTIL I"
					if i=2 then periodo = "INFANTIL II"
					if i=3 then periodo = "INFANTIL III"
					if i=4 then periodo = "INFANTIL IV"
					if i=5 then periodo = "INFANTIL V"
					resultadoAluno = "---"
					
					sql = " select DISTINCT HD.SITUACAO"
					sql = sql & " FROM SCA_HISTORICO_ESCOLAR H LEFT JOIN SCF_UF UF ON UF.CODIGO = H.UF "
					sql = sql & " inner join SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
					sql = sql & " WHERE H.COD_ALUNO = "& strCodAluno 
					sql = sql & " AND H.COD_EMPRESA = "& strCod_empresa 
					sql = sql & " and h.serie = '" &periodo & "'  and isnull(h.mostrar_historico_rel,'S') = 'S'"
					rs.open sql, cnn
					if not rs.eof then
						IF RS("SITUACAO") = "AP" then
							resultadoAluno = "Aprovado"
						elseIF RS("SITUACAO") = "CR" then
							resultadoAluno = "Cursando"
						end if
					end if
					rs.close
					%>
					<td align="center" class="celulaTopo"><strong><%=resultadoAluno%></strong></td>
					<%
				next
				%>
	</tr>

</table>


<br>
<table width="98%" height="18" border="0" align="center">
  <tr>
    <td height="14" align="center" class="celulaTopo" ><strong>Estudos Realizados</strong></td>
  </tr>
</table>

<table width="98%" height="34" border="0" align="center">

  <tr>
    <td height="14" align="center" class="celulaTopo" ><strong>Período</strong></td>
    <td align="center" class="celulaTopo" ><strong>Ano</strong></td>
    <td align="center" class="celulaTopo" ><strong>Estabelecimento</strong></td>
    <td align="center" class="celulaTopo" ><strong>Municipio</strong></td>
    <td align="center" class="celulaTopo" ><strong>UF</strong></td>
  </tr>
  
  <%
	' Busca Serie, anno, Estabelicimnento e Municipio
	for i=1 to 5
			if i=1 then periodo = "INFANTIL I"
			if i=2 then periodo = "INFANTIL II"
			if i=3 then periodo = "INFANTIL III"
			if i=4 then periodo = "INFANTIL IV"
			if i=5 then periodo = "INFANTIL V"
			%>
              <tr>
			   <td height="14" align="center" class="celulaTopo"><%=periodo%></td>
			  
			   <%
			sql = "select DISTINCT H.ano_letivo, H.serie, H.semestre, H.escola, H.Cidade, UF.SIGLA "
			sql = sql & " FROM SCA_HISTORICO_ESCOLAR H "
			sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = H.UF "
			sql = sql & " WHERE	H.COD_ALUNO = "& strCodAluno
			sql = sql & " AND	H.COD_EMPRESA = "& strCod_empresa
			sql = sql & " and h.serie = '" & periodo & "'  and isnull(h.mostrar_historico_rel,'S') = 'S'"
			sql = sql & " order by H.ano_letivo, H.semestre"
			'response.write sql
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
	strObservacao = ""
	sql = "select ano_letivo, semestre, serie, isnull(observacao,'') as observacao, escola, cidade "
	sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
	sql = sql & " WHERE	COD_ALUNO = "& strCodAluno
	sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
	sql = sql & " AND	curso = 'EDUCAÇÃO INFANTIL'"
	sql = sql & " AND	isnull(observacao, '') <> '' "
	sql = sql & " order by ano_letivo, semestre, serie"
	'response.write sql
	rs.open sql, cnn
	if not rs.eof then
		while not rs.eof 

			strObservacao =  strObservacao & trim(rs("serie"))  & " - " & trim(rs("observacao")) & "<br>"
			rs.movenext
					
		wend
	end if
	rs.close
	observacao2 = ""
	' Busca a observação do aluno
	'sql = "select ano_letivo, semestre, serie, isnull(observacao2,'') as observacao2, escola, cidade "
	'sql = sql & " FROM SCA_HISTORICO_ESCOLAR "
	'sql = sql & " WHERE	COD_ALUNO = "& strCodAluno
	'sql = sql & " AND	COD_EMPRESA = "& strCod_empresa
	'sql = sql & " AND	curso = 'EDUCAÇÃO INFANTIL'"
	'sql = sql & " AND	isnull(observacao2, '') <> '' "
	'sql = sql & " order by ano_letivo, semestre, serie"
	'
	'rs.open sql, cnn
	'if not rs.eof then
	'	while not rs.eof 
	'
	'		observacao2 =  observacao2 & trim(rs("serie"))  & " - " & trim(rs("observacao2")) & "<br>"
	'		rs.movenext
	'				
	'	wend
	'end if
	'rs.close
%>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <td height="18" align="center" class="textoRelatorio">
	<% if strObservacao <> "" then %>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
          <%if cint(strAnoFechamento)<>cint(year(date)) and trim(ano_letivo)=trim(year(date)) then%>
		  <tr>
            <td height="21" align="center" class="texto"><strong>Transfer&ecirc;ncia do Aluno Durante o Ano Letivo</strong></td>
          <tr>
		  <%end if%>
            <tr>
              <td align="left"><strong>Observa&ccedil;&atilde;o:</strong></td>
            </tr>
            <tr>
              <td align="left"><%=strObservacao%></td>
            </tr>
        </table>
    <% end if %>
	<% if observacao2 <> "" then %>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<%if strObservacao = "" then %>
          <%if cint(strAnoFechamento)<>cint(year(date)) and trim(ano_letivo)=trim(year(date)) then%>
		  <tr>
            <td height="21" align="center" class="texto"><strong>Transfer&ecirc;ncia do Aluno Durante o Ano Letivo</strong></td>
          <tr>
		  <%end if%>
            <tr>
              <td align="left"><strong>Observa&ccedil;&atilde;o:</strong></td>
            </tr>
		<%end if%>
            <tr>
              <td align="left"><%=observacao2%></td>
            </tr>
        </table>
    <% end if %>
	
      <tr>
        <td height="20" align="center"  class="texto" ><strong><%=session("CidadeEmpresaWeb")%>&nbsp;, <%=day(date)%> de <%=monthname(month(date))%> de <%=year(date)%></strong></td>
      </tr>
    </td>
  </tr>
</table>
<br><br>
<%if strCodTipoEmpresa = "1" then%>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center" class="textoRelatorio">__________________________________</td>
			<td align="center" class="textoRelatorio">__________________________________</td>
		</tr>
		<tr>
			<td align="center" class="texto"><%=session("UsuarioWeb")%></td>
			<td align="center" class="texto"><%=session("NomeDiretorEmpresaWeb")%></td>
		</tr>
		<tr>
			<td align="center" class="texto">Usu&aacute;rio que confeccionou</td>
			<td align="center" class="texto">Diretor(a)</td>
		</tr>
	</table>
<%else%>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center" class="textoRelatorio">__________________________________</td>
			<td align="center" class="textoRelatorio">__________________________________</td>
		</tr>
		<tr>
			<td align="center" class="texto"><%=session("NomeSecretariaEmpresaWeb")%></td>
			<td align="center" class="texto"><%=session("NomeDiretorEmpresaWeb")%></td>
		</tr>
		<tr>
			<td align="center" class="texto">Coordenador(a) Geral</td>
			<td align="center" class="texto">Diretor(a)</td>
		</tr>
		<tr>
			<td colspan="2" align="center" class="textoRelatorio">__________________________________</td>
		</tr>

		<tr>
			<td colspan="2" align="center" class="texto"><%=session("UsuarioWeb")%>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center" class="texto">Usu&aacute;rio que confeccionou</td>
		</tr>
	</table>
<%end if%>
<br>
<script>
		aguarde.style.display="none";
	</script>
</body>
</html>