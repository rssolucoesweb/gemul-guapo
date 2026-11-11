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
<title><%=session("Titulo")%> - Ficha de Matrícula - Renovação</title>
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

	strTituloRelatorio  	= "Ficha de Matrícula - Renovação<br>"
	
	strCod_empresa 			= Session("CodEmpresa")

	intAnoLetivoAtual	 		= Trim(Request("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request("cmbSemestre"))
	if intSemestreAtual = "" then intSemestreAtual = 3
	
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	


	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))

	strCodAluno			=	Trim(Request("chkAluno"))
	
	
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

	
	if trim(strCodAluno) <> "" then

		'VERIFICAÇÃO DE BLOQUEIO
		intCodAluno = strCodAluno
	
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
		sql = sql & " ETN.DESCRICAO AS ETNIA, "
		sql = sql & " A.* "
		sql = sql & " FROM SCA_ALUNO A "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S	ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO  "
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
		sql = sql & " LEFT JOIN SCA_FORMAINGRESSO O		ON O.CODIGO = A.COD_FORMAINGRESSO "
		sql = sql & " LEFT JOIN SCA_ETNIAS ETN 			ON A.COD_ETNIA = ETN.CODIGO"
		sql = sql & " Where A.codigo in (" & strCodAluno & ")"
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
			
				RESPONSAVEL_QUEM 				= Trim(rs("RESPONSAVEL_QUEM"))
				RESPOSAVEL_POSSUI_DOCUMENTACAO 	= Trim(rs("RESPOSAVEL_POSSUI_DOCUMENTACAO"))
				if RESPOSAVEL_POSSUI_DOCUMENTACAO = "S" then RESPOSAVEL_POSSUI_DOCUMENTACAO = "Sim"
				if RESPOSAVEL_POSSUI_DOCUMENTACAO = "N" then RESPOSAVEL_POSSUI_DOCUMENTACAO = "Não"
				RESPONSAVEL_GRAU_PARESTESCO= Trim(rs("RESPONSAVEL_GRAU_PARESTESCO"))
				MEDICAMENTO_CONTROLADO 		= Trim(rs("MEDICAMENTO_CONTROLADO"))
				MEDICAMENTO_CONTROLADO_QUAL = Trim(rs("MEDICAMENTO_CONTROLADO_QUAL"))
				TRANSPORTE_ESCOLAR 			= Trim(rs("TRANSPORTE_ESCOLAR"))
				AUTORIZA_USO_IMAGEM 		= Trim(rs("AUTORIZA_USO_IMAGEM"))
				RESTRICAO_ALIMENTAR 		= Trim(rs("RESTRICAO_ALIMENTAR"))
				RESTRICAO_ALIMENTAR_QUAL 	= Trim(rs("RESTRICAO_ALIMENTAR_QUAL"))
				ETNIA 	= Trim(rs("ETNIA"))
				
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	
				strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFotoAtivo.gif"
				strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
		
				sql = "SELECT base64 as arquivo "
				sql = sql & " FROM SCA_ALUNO_FOTO "
				sql = sql & " WHERE cod_Aluno = " & strCodigo

				rsAux.open sql, cnn

				if rsAux.eof = false then

					strFoto = "<img src='data:image/jpeg;base64," & rsAux("arquivo") & "' width='100' height='110'>"

					strNomeBotaoFoto = "Alterar Foto"

				end if

				rsAux.close

				strTurma = ""
				
				'aluno na turma
				sql = "select AT.COD_TURMA, T.NomeTurma, T.TurmaAluno "
				sql = sql & " from SCA_ALUNO_TURMA AT"
				sql = sql & " INNER JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma  AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
				sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
				sql = sql & " and 	AT.COD_ALUNO = " &  strCodigo
				sql = sql & " and 	AT.situacao = 'A'"
				sql = sql & " and 	AT.ANO_LETIVO = " & intAnoLetivoAtual
				sql = sql & " and 	AT.Semestre = " & intSemestreAtual
				rsAux.open sql, cnn
				if not rsAux.eof then
					strTurma = rsAux("TurmaAluno") & " " & rsAux("NomeTurma")
				end if
				rsAux.close
	
	
				curso 	= ""
				periodo = ""
				turno 	= ""
				turma 	= ""
				quem 	= ""
				
				sql = "select r.codigo, c.descricao as curso, p.descricao as periodo, t.desc_turno as turno, NomeTurma + ' - ' + TurmaAluno as turma, r.usuario_incl, r.data_hora_incl "
				sql = sql & " from SCA_ALUNO_RENOVACAO r "
				sql = sql & " inner join sca_curso c on c.cod_curso = r.cod_curso"
				sql = sql & " inner join sca_periodo p on p.cod_periodo = r.cod_periodo"
				sql = sql & " inner join sca_turno t on t.cod_turno = r.cod_turno"
				sql = sql & " inner join sca_turma tu on tu.cod_turma = r.COD_TURMA_RENOVACAO"
				sql = sql & " where ano_letivo = " & intAnoLetivoAtual & " and cod_aluno = " & strCodigo
				rsAux1.open sql, cnn
				if not rsAux1.eof then
					quem 	= rsAux1("usuario_incl") & " - " & rsAux1("data_hora_incl")
					curso 	= rsAux1("curso")
					periodo = rsAux1("periodo")
					turno 	= rsAux1("turno")
					turma 	= rsAux1("turma")
				end if
				rsAux1.close
	
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
									<td class="texto1">&nbsp;Etnia: </td>
									<td class="texto1"><strong><%=ETNIA%></strong></td>
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
									<td class="texto1">&nbsp;Respons&aacute;vel é: </td>
									<td class="texto1"><strong><%=RESPONSAVEL_QUEM%> <%if RESPONSAVEL_QUEM = "OUTRO" then%>(<%=RESPONSAVEL_GRAU_PARESTESCO%>)<%end if%></strong></td>
									<td class="texto1">&nbsp;Possui documento legal que atesta a tutela (guarda):</td>
									<td class="texto1"><strong><%=RESPOSAVEL_POSSUI_DOCUMENTACAO%></strong></td>
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
							<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1"><li><strong>Dados Escolares Renovação</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS ESCOLARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Curso:</td>
									<td width="47%" class="texto1"><strong><%=curso%></strong></td>
									<td width="18%" class="texto1">&nbsp;Periodo:</td>
									<td width="47%" class="texto1"><strong><%=periodo%></strong></td>
								  </tr>
								  <tr>
									<td width="18%" class="texto1">&nbsp;Turno:</td>
									<td width="47%" class="texto1"><strong><%=turno%></strong></td>
									<td width="18%" class="texto1">&nbsp;Turma:</td>
									<td width="47%" class="texto1"><strong><%=turma%></strong></td>
								  </tr>
								   <tr>
									<td width="18%" class="texto1">&nbsp;Renovador por:</td>
									<td width="47%" colspan="3" class="texto1"><strong><%=quem%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS ESCOLARES-->			
							</td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1"><li><strong>Informações Adicionais</strong></li></td>
							</tr>
						  <tr>
							<%
							MEDICAMENTO_CONTROLADO_resultado = ""
							if MEDICAMENTO_CONTROLADO = "N" then MEDICAMENTO_CONTROLADO_resultado = "Não"
							if MEDICAMENTO_CONTROLADO = "S" then MEDICAMENTO_CONTROLADO_resultado = "Sim"
							
							RESTRICAO_ALIMENTAR_resultado = ""
							if RESTRICAO_ALIMENTAR = "N" then RESTRICAO_ALIMENTAR_resultado = "Não"
							if RESTRICAO_ALIMENTAR = "S" then RESTRICAO_ALIMENTAR_resultado = "Sim"
							
							AUTORIZA_USO_IMAGEM_resultado = ""
							if AUTORIZA_USO_IMAGEM = "N" then AUTORIZA_USO_IMAGEM_resultado = "Não"
							if AUTORIZA_USO_IMAGEM = "S" then AUTORIZA_USO_IMAGEM_resultado = "Sim"
							
							TRANSPORTE_ESCOLAR_resultado = ""
							if TRANSPORTE_ESCOLAR = "N" then TRANSPORTE_ESCOLAR_resultado = "Não"
							if TRANSPORTE_ESCOLAR = "S" then TRANSPORTE_ESCOLAR_resultado = "Sim"
							%>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS ESCOLARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Faz uso de medicamento controlado:</td>
									<td width="47%" class="texto1"><strong><%=MEDICAMENTO_CONTROLADO_resultado%> <%if MEDICAMENTO_CONTROLADO = "S" then%>&nbsp;(<%=MEDICAMENTO_CONTROLADO_QUAL%>)<%end if%></strong></td>
									<td width="16%" class="texto1">&nbsp;Transporte escolar municipal:</td>
									<td width="19%" class="texto1"><strong><%=TRANSPORTE_ESCOLAR_resultado%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Autoriza o uso da imagem do filho(a) em eventos da SEMEC/ESCOLA: </td>
									<td class="texto1"><strong><%=AUTORIZA_USO_IMAGEM_resultado%></strong></td>
									<td class="texto1">&nbsp;Possui restrição alimentar: </td>
									<td class="texto1"><strong><%=RESTRICAO_ALIMENTAR_resultado%> <%if RESTRICAO_ALIMENTAR = "S" then%>&nbsp;(<%=RESTRICAO_ALIMENTAR_QUAL%>)<%end if%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS ESCOLARES-->			</td>
						  </tr>
						  
						  <tr>
							<td colspan="2" class="texto1" ><!-- INICIO CAMPO - DADOS DOCUMENTOS-->
                                <!-- FIM CAMPO - DADOS DOCUMENTOS-->                            </td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						</table>
						
                        <%
						if strResponsavel="" then strResponsavel= strMae
						
						%>
<br>
<br>
						  <!--#include file="../includes/inc_RepresentantesLegaiseResponsavel.asp"-->
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