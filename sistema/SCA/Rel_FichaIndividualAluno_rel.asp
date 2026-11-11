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
<title><%=session("Titulo")%> - Ficha Individual do Aluno</title>
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

	strTituloRelatorio  	= "Ficha Individual do Aluno<br>"
	
	strCod_empresa 			= Session("CodEmpresa")

	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	


	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	
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

	
	if intCodTurma <> "" then 
	
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo 	= rs("cod_periodo")
			intCodTurno 	= rs("cod_turno")
			intSemestre 	= rs("cod_Semestre")
		END IF
		rs.close
	
	end if

	'BUSCA A AVALIACOES
	sql="SELECT TA.POSICAO, TA.DESCRICAO, TA.SIGLA, TA.BIMESTRE, CA.media_aprovacao"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO "
	sql=sql & " WHERE	CA.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		TA.BIMESTRE<>8"
	sql=sql & " ORDER BY TA.POSICAO"
	rsAux.open sql, cnn, 3, 1
	if not rsAux.eof then
		intMediaAprovacao = rsAux("media_aprovacao")
		intCont = 1
		redim vetTipoNota(rsAux.recordCount,2)
		strDescTipoNotaTitulo = ""
		while not rsAux.eof
			if strDescTipoNotaTitulo = "" then
				strDescTipoNotaTitulo = rsAux("BIMESTRE")
			else
				strDescTipoNotaTitulo = strDescTipoNotaTitulo & "," & rsAux("BIMESTRE")
			end if
			
			vetTipoNota(intCont,1) = ZeroLeft(rsAux("POSICAO"),2) & "_" & rsAux("BIMESTRE")
			vetTipoNota(intCont,2) = rsAux("SIGLA")
			intCont = intCont + 1
			rsAux.movenext
		wend
	end if
	rsAux.close
		
	if trim(strCodAluno) <> "" then

		'VERIFICAÇÃO DE BLOQUEIO
		intCodAluno = strCodAluno
		%>
		<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
		<%			
	
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
		sql = sql & " O.DESCRICAO AS FORMAINGRESSO,"
		sql = sql & " DE.descricao AS DESCONTO,"
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
		sql = sql & " LEFT JOIN SCF_CATEGORIA_DESCONTO DE			ON DE.CODIGO = A.cod_categoria_desconto AND DE.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " Where A.COD_EMPRESA = " & strCod_empresa
		sql = sql & " And 	A.codigo in (" & strCodAluno & ")"
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
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
			
				strFormaIngresso 		= TRIM(rs("FormaIngresso"))
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
			
				
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	
				strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFotoAtivo.gif"
				strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
		
				sql = "SELECT arquivo "
				sql = sql & " FROM 	SCA_ALUNO_FOTO"
				sql = sql & " Where COD_EMPRESA = " & strCod_empresa
				sql = sql & " And 	codAluno = " & strCodigo
				rsAux.open sql, cnn
				if rsAux.eof = false then
					strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/" & strCod_empresa & "/" & rsAux("arquivo")
					strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
					strNomeBotaoFoto	= "Alterar Foto"
				end if
				rsAux.close
				strTurma = ""
				'aluno na turma
				sql = "select AT.COD_TURMA, T.NomeTurma"
				sql = sql & " from SCA_ALUNO_TURMA AT"
				sql = sql & " INNER JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma  AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
				sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
				sql = sql & " and 	AT.COD_ALUNO = " &  strCodigo
				sql = sql & " and 	AT.situacao = 'A'"
				sql = sql & " and 	AT.ANO_LETIVO = " & intAnoLetivoAtual
				sql = sql & " and 	AT.Semestre = " & intSemestreAtual
				rsAux.open sql, cnn
				if not rsAux.eof then
					strTurma = rsAux("NomeTurma")
				end if
				rsAux.close
	
				mostraCabecalho
				
				%>
				  <tr valign="top">
					<td>
					<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
					  <tr valign="top">
						<td colspan="2" align="center">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodigo%>" maxlength="10"></td>
						  </tr>
						  <tr>
							<td width="457" height="20" bgcolor="#EEEEEE" class="texto1"><li><strong>Dados Pessoais</strong></li></td>
							<td width="246" height="20" bgcolor="#EEEEEE" class="texto1" align="right">Situa&ccedil;&atilde;o: <strong><%=strSituacaoAluno%></strong>&nbsp;&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS PESSOAIS-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Matr&iacute;cula: </td>
									<td width="47%" class="texto1"><strong><%=strMatricula%></strong></td>
									<td colspan="2" rowspan="8" class="texto1" align="center"><table width="120" height="130" border="0" cellpadding="0" cellspacing="0">
                                      <tr>
                                        <td bgcolor="#FFFFFF" align="center" class="text"><%=strFoto%></td>
                                      </tr>
                                    </table></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Nome Completo: </td>
									<td class="texto1"><strong><%=strNomealuno%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Data Nascimento: </td>
									<td class="texto1"><strong><%=strDatanascimento%></strong></td>
								  </tr>
								  <tr>
								    <td class="texto1">&nbsp;Data Matr&iacute;cula: </td>
								    <td class="texto1"><strong><%=strDatamatricula%></strong></td>
							      </tr>
								  <tr>
								    <td class="texto1">&nbsp;Sexo: </td>
								    <td class="texto1"><strong><%=strSexo%></strong></td>
							      </tr>
								  <tr>
								    <td class="texto1">&nbsp;N. Reg. Nasc.: </td>
								    <td class="texto1"><strong><%=strNumeroRegistroNascimento%></strong></td>
							      </tr>
								  <tr>
									<td class="texto1">&nbsp;Naturalidade: </td>
									<td class="texto1"><strong><%=strCidadenascimento%></strong></td>
								  </tr>
								  <tr>
								    <td class="texto1">&nbsp;Nacionalidade:</td>
								    <td class="texto1"><strong><%=strNacionalidade%></strong></td>
							      </tr>
								  <tr>
									<td class="texto1">&nbsp;Profiss&atilde;o: </td>
									<td class="texto1"><strong><%=strProfissao%></strong></td>
									<td class="texto1">&nbsp;UF: </td>
									<td class="texto1"><strong><%=strUF%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Est. Civil:</td>
									<td class="texto1"><strong><%=strEstadoCivil%></strong></td>
									<td class="texto1">&nbsp;Religi&atilde;o: </td>
									<td class="texto1"><strong><%=strReligiao%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Fone Residencial: </td>
									<td class="texto1"><strong><%=strFoneResidencial%></strong></td>
									<td class="texto1">&nbsp;Celular: </td>
									<td class="texto1"><strong><%=strFonecelular%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;e-mail: </td>
									<td class="texto1"><strong><%=strEmail%></strong></td>
									<td class="texto1">&nbsp;Fone Comercial : </td>
									<td class="texto1"><strong><%=strFoneComercial%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Nec. Especiais: </td>
									<td class="texto1"><strong><%=strNecessidadeEspecial%></strong></td>
									<td class="texto1">&nbsp;Atend. Especial : </td>
									<td class="texto1"><strong><%=strAtendimentoespecial%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS PESSOAIS-->			</td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Endereço</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS ENDEREÇO-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosEndereco">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Logradouro: </td>
									<td width="47%" class="texto1"><strong><%=strLogradouro%></strong></td>
									<td width="16%" class="texto1">&nbsp;N&uacute;mero:</td>
									<td width="19%" class="texto1"><strong><%=strNumero_endereco%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1"> &nbsp;Complemento:</td>
									<td class="texto1"><strong><%=strComp_endereco%></strong></td>
									<td class="texto1">&nbsp;CEP:</td>
									<td class="texto1"><strong><%=strCepresidencia%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Bairro:</td>
									<td class="texto1"><strong><%=strBairroaluno%></strong></td>
									<td class="texto1">&nbsp;</td>
									<td class="texto1">&nbsp;</td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Munic&iacute;pio:</td>
									<td class="texto1"><strong><%=strCidaderesidencia%></strong></td>
									<td class="texto1">&nbsp;UF:</td>
									<td class="texto1"><strong><%=strUFResidencia%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS ENDEREÇO-->			</td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Dados Familiares</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS FAMILIARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosFamiliares">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Pai: </td>
									<td width="46%" class="texto1"><strong><%=strPai%></strong></td>
									<td width="17%" class="texto1">&nbsp;Falecido:</td>
									<td width="19%" class="texto1"><strong><%=strPaifalecido%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Data Nascimento: </td>
									<td class="texto1"><strong><%=strPaidatanascimento%></strong></td>
									<td class="texto1">&nbsp;Telefone:</td>
									<td class="texto1"><strong><%=strPaifone%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Profiss&atilde;o: </td>
									<td class="texto1"><strong><%=strProfissaoPai%></strong></td>
									<td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
									<td class="texto1"><strong><%=strGrauInstrucaoPai%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;M&atilde;e: </td>
									<td class="texto1"><strong><%=strMae%></strong></td>
									<td class="texto1">&nbsp;Falecida:</td>
									<td class="texto1"><strong><%=strMaefalecida%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Data Nascimento:</td>
									<td class="texto1"><strong><%=strMaedatanascimento%></strong></td>
									<td class="texto1">&nbsp;Telefone:</td>
									<td class="texto1"><strong><%=strMaefone%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Profiss&atilde;o: </td>
									<td class="texto1"><strong><%=strProfissaoMae%></strong></td>
									<td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
									<td class="texto1"><strong><%=strGrauInstrucaoMae%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Respons&aacute;vel: </td>
									<td class="texto1"><strong><%=strResponsavel%></strong></td>
									<td class="texto1">&nbsp;Telefone:</td>
									<td class="texto1"><strong><%=strResponsavelfone%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Data Nascimento:</td>
									<td class="texto1"><strong><%=strResponsaveldatanascimento%></strong></td>
									<td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
									<td class="texto1"><strong><%=strGrauInstrucaoResponsavel%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Profiss&atilde;o: </td>
									<td class="texto1"><strong><%=strProfissaoResponsavel%></strong></td>
									<td class="texto1">&nbsp;</td>
									<td class="texto1">&nbsp;</td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Qtde. Irm&atilde;os: </td>
									<td class="texto1"><strong><%=strQtdeIrmao%></strong></td>
									<td class="texto1">&nbsp;Na mesma Escola:</td>
									<td class="texto1"><strong><%=strQtdeIrmaoEscola%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS FAMILIARES-->			</td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
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
									<td width="47%" class="texto1"><strong><%=strIdentidade%>&nbsp;</strong>&Oacute;rg&atilde;o :<strong> <%=strIdentidadeOrgao%>&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;UF :<strong> <%=strUFIdentidade%></strong></td>
									<td width="16%" class="texto1">&nbsp;CPF:</td>
									<td width="19%" class="texto1"><strong><%=strCpfaluno%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Registro Militar  : </td>
									<td class="texto1"><strong><%=strRegmilitar%></strong></td>
									<td class="texto1">&nbsp;</td>
									<td class="texto1">&nbsp;</td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;T&iacute;tulo:</td>
								<td colspan="2" class="texto1">Num&eacute;ro :<strong><%=strTituloNumero%>&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Zona :<strong><%=strTituloZona%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>Se&ccedil;&atilde;o :<strong><%=strTituloSecao%></strong></td>
									<td class="texto1">&nbsp;</td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1"><li><strong>Dados Escolares</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS ESCOLARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Turma:</td>
									<td width="47%" class="texto1"><strong><%=strTurma%></strong></td>
									<td width="16%" class="texto1">&nbsp;M&ecirc;s/Ano Entrevista.:</td>
									<td width="19%" class="texto1"><strong><%=strMesanovestibular%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Forma Ingresso: </td>
									<td class="texto1"><strong><%=strFormaIngresso%></strong></td>
									<td class="texto1">&nbsp;Data Ingresso: </td>
									<td class="texto1"><strong><%=strDataingresso%></strong></td>
								  </tr>
								  <tr>
									<td colspan="4" class="texto1"><hr size="2" color="#FFFFFF" ></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Situa&ccedil;&atilde;o:</td>
									<td class="texto1"><strong><%=strSituacaoAluno%></strong></td>
									<td class="texto1">&nbsp;Dt. Afastamento: </td>
									<td class="texto1"><strong><%=strDatafastamento%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Obs:</td>
									<td class="texto1"><strong><%=strObsafastamento%></strong></td>
									<td class="texto1">&nbsp;Cod. Motivo:</td>
									<td class="texto1"><strong><%=strCod_motivoafastamento%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Via Carteirinha:</td>
									<td class="texto1"><strong><%=strViaCarterinha%></strong></td>
									<td class="texto1">&nbsp;Setransp:</td>
									<td class="texto1"><strong><%=strSetransp%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS ESCOLARES-->			</td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Dados da Conclus&atilde;o</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Data Cola&ccedil;&atilde;o: </td>
									<td width="47%" class="texto1"><strong><%=strDatacolacao%></strong></td>
									<td width="16%" class="texto1">&nbsp;Ano Conclus&atilde;o: </td>
									<td width="19%" class="texto1"><strong><%=strAnoconclusao%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Data Certificado: </td>
									<td class="texto1"><strong><%=strDatacertificado%></strong></td>
									<td class="texto1">&nbsp;Sem Conclus&atilde;o: </td>
									<td class="texto1"><strong><%=strSemconclusao%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						</table>
						
                        <!-- inicio notas -->
                        <%
						

						sql = " SELECT SCA_ALUNO.CODIGO, "
						sql = sql & " 	SCA_ALUNO.MATRICULA, "
						sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
						sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Anual,"
						sql = sql & " 	SCA_ALUNO_TURMA.SEQUENCIA, "
						sql = sql & " 	SCA_ALUNO_TURMA.COD_TURMA, "
						sql = sql & " 	SCA_TURMA.NOMETURMA, "
						sql = sql & " 	SCA_GRADECURRICULAR.Cod_Periodo, "
						sql = sql & " 	SCA_NOTAS_FALTAS.MEDIA, "
						for i=1 to ubound(vetTipoNota)
							strPos = left(vetTipoNota(i,1),2)
							sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
							sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
						next
						sql = sql & " 	SCA_DISCIPLINA.DESC_DISCIPLINA,"
						sql = sql & " 	SCA_TURNO.DESC_TURNO,"
						sql = sql & " 	SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
						sql = sql & " 	SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA, "
						sql = sql & " 	SCA_NOTAS_FALTAS.SITUACAO "
						sql = sql & " FROM SCA_ALUNO_TURMA "
						sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
						sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
						sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
						sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_TURMA.COD_EMPRESA = SCA_GRADECURRICULAR.COD_EMPRESA "
						sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
						sql = sql & " INNER JOIN SCA_DISCIPLINA		ON SCA_DISCIPLINA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA"
						sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = SCA_ALUNO_DISCIPLINA.Cod_GradeCurricularDisciplina AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_ALUNO_DISCIPLINA.Cod_Disciplina"
						sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
						sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
						sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
						sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
						sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual
						sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestreAtual
						
						sql = sql & " AND SCA_ALUNO.CODIGO = " & strCodigo
						sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO"
						
						rsAux.open sql, cnn
						if rsAux.eof = false then
							%>
                        <table width="90%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
							  <tr>
								<td width="16%" rowspan="2" align="center" class="celulaextrato">Disciplinas</td>
								<%
								strTipoNotaAprentadaAnterior = ""
								FOR I=1 TO UBOUND(vetTipoNota) 
									if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) then
										strColspan = ""
										vet = split(strDescTipoNotaTitulo,right(vetTipoNota(I,1),1))
										if ubound(vet)>=1 then	
											if cInt(right(vetTipoNota(I,1),1)) > 4  then	
												strColspan = "colspan='" & ubound(vet) & "'" 'quat de notas * 2 + 1 da coluna da falta
											else
												strColspan = "colspan='" & ubound(vet)+1 & "'" 'quat de notas * 2 + 1 da coluna da falta
											end if
										end if
										strBim = right(vetTipoNota(I,1),1) & "ºBimestre" 
										'5	Média Provisória 
										'6	Exame
										'7	Conselho de Classe
										'8	Media Final							
										if cInt(right(vetTipoNota(I,1),1)) > 4 then strBim = vetTipoNota(I,2)
										if cInt(right(vetTipoNota(I,1),1)) = 5 then strBim = "Média Provisória"
										if cInt(right(vetTipoNota(I,1),1)) = 6 then strBim = "Exame"
										if cInt(right(vetTipoNota(I,1),1)) = 7 then strBim = "Conselho de Classe"
										%>
										<td            align="center" class="celulaextrato" <%=strColspan%>><%=strBim%></td>
										<%
									end if
									strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
								NEXT %>
								<td align="center" class="celulaextrato" >Média</td>
								<%if strMostraResultadoFinal = "S" then%>
								<td align="center" class="celulaextrato" >Resultado</td>
								<%end if%>
								<%if strMostraCH = "S" then%>
								<td align="center" class="celulaextrato" >Carga</td>
								<%end if%>
								<%if strMostraPercFaltas = "S" then%>
								<td align="center" class="celulaextrato" >Faltas</td>
								<%end if%>
								</tr>
							  <tr>
								<%	strTipoNotaAprentadaAnterior = ""
									FOR I=1 TO UBOUND(vetTipoNota) 
										if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6"  and trim(right(vetTipoNota(I,1),1)) <> "7"  and trim(right(vetTipoNota(I,1),1)) <> "8"  then
										%>
										<td align="center" class="celulaextrato">Faltas</td>	
										<%
										end if
										%>
										<td align="center" class="celulaextrato"><%=vetTipoNota(I,2)%></td>
										<%
										strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
									NEXT %>
								<td align="center" class="celulaextrato" >Final</td>
								<%if strMostraResultadoFinal = "S" then%>
								<td align="center" class="celulaextrato" >Final</td>
								<%end if%>
								<%if strMostraCH = "S" then%>
								<td align="center" class="celulaextrato" >Horaria</td>
								<%end if%>
								<%if strMostraPercFaltas = "S" then%>
								<td align="center" class="celulaextrato" >(%)</td>
								<%end if%>
								</tr>
							  <tr>
							<%
							strTotalFaltas = 0
							while not rsAux.eof	
								strTotalFalta 	= 0
								strDisciplina 	= rsAux("DESC_DISCIPLINA")
								strMedia		= "---"
								strResultadoFinal 	= ""
								strCHDisciplina		= rsAux("Ch_Anual")
								
								bolMostraLinha = true
								strFalta = 0
									
								'utilizado somente quando for utilizado o filtro de percentual de faltas
								if intIntervaloPercFaltaInicial <> "" and intIntervaloPercFaltaFinal <> "" then
								   FOR I=1 TO UBOUND(vetTipoNota) 
										strPos = left(vetTipoNota(i,1),2)
										if not isnull(rsAux("NOTA" & strPos)) and rsAux("NOTA" &strPos)<>"" then
											strNota = FORMATNUMBER(rsAux("NOTA" & strPos),1)
										end if
										if not isnull(rsAux("FALTA" & strPos)) and rsAux("FALTA" &strPos)<>"" then
											if trim(strTipoNotaAprentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaAprentadaAnterior = "" then
												strFalta = strFalta  + rsAux("FALTA" & strPos)
											end if
										end if
										if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6" and trim(right(vetTipoNota(I,1),1)) <> "7" and trim(right(vetTipoNota(I,1),1)) <> "8"  then
											if not isnull(strFalta) then strTotalFaltas = strTotalFaltas + strFalta
											strFalta = rsAux("FALTA" & strPos)
										end if
										strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
								   NEXT 
								
								   if isnull(strCHDisciplina) then
										strPercFaltas = 0
										bolMostraLinha = false
								   else
										strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
										if strPercFaltas >= intIntervaloPercFaltaInicial and strPercFaltas <= intIntervaloPercFaltaFinal then
										   bolMostraLinha = true
										else
										   bolMostraLinha = false
										end if					
								   end if
									
								end if
								
								if not isnull(rsAux("MEDIA")) and rsAux("MEDIA")<>"" then
								
									strMedia = FORMATNUMBER(rsAux("MEDIA"),1)
									if cCur(strMedia) < cCur(intMediaAprovacao) then
										strResultadoFinal = "<font color='#FF0000'>RN</font>"
									else
										strResultadoFinal = "<font color='#0000FF'>AP</font>"
									end if
									if intIntervaloMediaInicial <> "" and intIntervaloMediaFinal <> "" then
										if rsAux("MEDIA") >= intIntervaloMediaInicial and rsAux("MEDIA") <= intIntervaloMediaFinal then
										   bolMostraLinha = true
										else
										   bolMostraLinha = false
										end if
									end if
								else
								
									if intIntervaloMediaInicial <> "" and intIntervaloMediaFinal <> "" then
										bolMostraLinha = false
									end if                    
								end if
								
								if bolMostraLinha then
								
									
									IF TRIM(rsAux("SITUACAO"))="RN" THEN
										strResultadoFinal = "<font color='#FF0000'>RN</font>"
									ELSEIF TRIM(rsAux("SITUACAO"))="AP" THEN
										strResultadoFinal = "<font color='#0000FF'>AP</font>"
									END IF
										%>
										<td width="16%" align="left" class="celulaextrato">&nbsp;<%=strDisciplina%></td>
										<%	
										strTipoNotaAprentadaAnterior = ""
										strFalta = 0
										
										FOR I=1 TO UBOUND(vetTipoNota) 
											strPos = left(vetTipoNota(i,1),2)
											strNota = "---"
											if not isnull(rsAux("NOTA" & strPos)) and rsAux("NOTA" &strPos)<>"" then
												strNota = FORMATNUMBER(rsAux("NOTA" & strPos),1)
											end if
											if not isnull(rsAux("FALTA" & strPos)) and rsAux("FALTA" &strPos)<>"" then
												if trim(strTipoNotaAprentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaAprentadaAnterior = "" then
													strFalta = strFalta  + rsAux("FALTA" & strPos)
												end if
											end if
											if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6"  and trim(right(vetTipoNota(I,1),1)) <> "7"  then
												%>
												<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strFalta%>&nbsp;</td>
												<%
												if not isnull(strFalta) then strTotalFaltas = strTotalFaltas + strFalta
												strFalta = rsAux("FALTA" & strPos)
											end if
											%>
											<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strNota%>&nbsp;</td>
											<%
											strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
										NEXT 
										
										
										if isnull(strCHDisciplina) then
											strPercFaltas = 0
										else
											strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
										end if
										%>
										<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strMedia%>&nbsp;</td>
										<%if strMostraResultadoFinal = "S" then%>
										<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
										<%end if%>
										<%if strMostraCH = "S" then%>
										<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
										<%end if%>
										<%if strMostraPercFaltas = "S" then%>
										<td width="5%" align="center" class="celulaextrato">&nbsp;<%if strPercFaltas<>0 then response.Write formatNumber(strPercFaltas,1) %>&nbsp;</td>
										<%end if%>
									  </tr>
										<%
									end if 
									strTotalFaltas = 0
								rsAux.movenext
							wend 
							%></table>
						<%end if
						rsAux.close
						%>	
                        <!-- fim notas -->
<br>
<br>
						  <!--#include file="../includes/inc_RepresentantesLegais.asp"-->
<br>
						<br>
				<%
				rs.movenext
				if not rs.eof then
					fimTabela
					%>
					<pre></pre>				
					<%			
				end if
			wend
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