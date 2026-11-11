<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
vemDaMatricula				= Trim(Request("mat"))
if vemDaMatricula="s" then
	strPaginaDestino = "window.location.href='" & session("urlRaizLocalSistema") & "/gemul2015/Sistema/MAT/EfetivacaoAluno_con.asp'"
else
	strPaginaDestino = ""
end if
%>
<%
strAnoCab = Trim(Request.QueryString("AnoLetivo"))
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
<br>
<%
	dim intPagina

	
	strCod_empresa 			= Session("CodEmpresa")
	if request("txtCodEmpresa") <> "" then
		strCod_empresa			=	request("txtCodEmpresa")
	end if
	intAnoLetivoAtual	 		= Trim(Request("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request("cmbSemestre"))
	
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	

	strPromoverAnoLetivo = request.form("cmbPromoverAnoLetivo")
	if strPromoverAnoLetivo = "S" then
		strAnoLetivoPromovido = intAnoLetivoAtual + 1
		intAnoLetivoAtual = strAnoLetivoPromovido
	else
		strAnoLetivoPromovido = intAnoLetivoAtual
		intAnoLetivoAtual = strAnoLetivoPromovido
	end if
	
	intCodTurma 			= Trim(Request("cmbTurma"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	
	mostraNotas 			= Trim(Request.Form("mostraNotas"))
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	strTituloRelatorio  	= "Ficha Individual do Aluno<br>Renovação de Matrícula"
	if vemDaMatricula = "s" then
		sql = "	SELECT "
		sql = sql & " AT.CODIGO,"
		sql = sql & " AT.COD_EMPRESA,"
		sql = sql & " AT.ANO_LETIVO,"
		sql = sql & " AT.COD_TURMA,"
		sql = sql & " T.COD_SEMESTRE"
		sql = sql & " FROM SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_TURMA T ON AT.COD_TURMA = T.COD_TURMA "
		sql = sql & " WHERE "
		sql = sql & "     AT.cod_aluno = " & strCodAluno
		sql = sql & " 	and AT.situacao = 'A'"
		sql = sql & " order by 1 desc"
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			strCod_empresa 	= rs("COD_EMPRESA")
			intAnoLetivoAtual 	= rs("ANO_LETIVO")
			intCodTurma 	= rs("COD_TURMA")
			intSemestreAtual= rs("COD_SEMESTRE")
		END IF
		rs.close
		mostraNotas = "S"
		strTituloRelatorio  	= "Ficha Individual do Aluno<br>Comprovante de Matrícula"
	end if
	
	
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
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
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & strCod_empresa
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

	criterioEspecial = "N"
	sql = "select cod_aluno from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO"
	sql = sql & " 				where cod_aluno in (" & strCodAluno & ")"
	sql = sql & " 				and ano_letivo = " & intAnoLetivoAtual
	rs.open sql, cnn
	if not rs.eof then
		criterioEspecial = "S"
	end if
	rs.close
	
	if criterioEspecial = "S" then
	
		sql="select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
		sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
		sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
		sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
		sql=sql & " inner join SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI on c.cod_tipo_calculo =  TAI.cod_tipo_calculo"
		sql=sql & " WHERE TAI.cod_aluno = " &  strCodAluno
		sql=sql & " AND		CA.COD_EMPRESA = " & strCod_empresa
		sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
		sql=sql & " AND		TA.BIMESTRE<>8"
		sql=sql & " ORDER BY TA.POSICAO"
		
		vetCampo = null
		rs.open sql, cnn
		if not rs.eof then
			strTipoCalculo 				= rs("TIPO_CALCULO")
			media_aprovacao 			= rs("media_aprovacao")
			media_aprovacao_final		= rs("media_aprovacao_final")
			intQtdeDisciplinaRecuperacao= rs("num_disciplina_recuperacao")
			intQtdeDisciplinaDependencia= rs("num_disciplina_prog_parcial")
			strTipoFormulaFinal 		= rs("tipoFormulaFinal")
			frequencia_minima_percentual= rs("frequencia_minima_percentual")
			
			vetCampo = rs.getRows
		end if
		rs.close
	else
	
		sql="select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
		sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
		sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
		sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
		sql=sql & " where ca.ano_letivo = " & intAnoLetivoAtual
		sql=sql & " and ca.cod_curso = " & intCodCurso
		sql=sql & " order by c.posicao"
		vetCampo = null
		rs.open sql, cnn
		if not rs.eof then
			strTipoCalculo 				= rs("TIPO_CALCULO")
			media_aprovacao 			= rs("media_aprovacao")
			media_aprovacao_final		= rs("media_aprovacao_final")
			intQtdeDisciplinaRecuperacao= rs("num_disciplina_recuperacao")
			intQtdeDisciplinaDependencia= rs("num_disciplina_prog_parcial")
			strTipoFormulaFinal 		= rs("tipoFormulaFinal")
			frequencia_minima_percentual= rs("frequencia_minima_percentual")
			
			vetCampo = rs.getRows
		else
			rs.close
			%>
			<script>
				alert("O critério de avaliação não foi criado para esse curso.");
				window.history.back();
			</script>
			<%
			response.end
		end if
		rs.close

	end if
		
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
		sql = sql & " O.DESCRICAO AS FORMAINGRESSO, ETN.DESCRICAO AS ETNIA,"
		sql = sql & " A.*, TC.descricao as TENIS_TAMANHO, TR.descricao as UNIFORME_TAMANHO "
		sql = sql & " FROM SCA_ALUNO A "
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
		sql = sql & " LEFT JOIN SCA_FORMAINGRESSO O		ON O.CODIGO = A.COD_FORMAINGRESSO "
		sql = sql & " LEFT JOIN SCA_ETNIAS ETN ON ETN.CODIGO = A.COD_ETNIA"
		sql = sql & " LEFT JOIN SCA_TAMANHO_CALCADO TC ON TC.CODIGO = A.cod_tamanho_calcado"
		sql = sql & " LEFT JOIN SCA_TAMANHO_ROUPA TR ON TC.CODIGO = A.cod_tamanho_roupa"
		sql = sql & " Where A.codigo in (" & strCodAluno & ")"
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
				strEtnia			= TRIM(rs("ETNIA"))
				ID_CENSO			= TRIM(rs("ID_CENSO"))
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
				if not isnull(strUfnascimento) and strUfnascimento<>"" then strCidadenascimento = strCidadenascimento & "/" & strUfnascimento
				
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
				if not isnull(strUfresidencia) and strUfresidencia<>"" then strCidaderesidencia = strCidaderesidencia & "/" & strUfresidencia
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
				strCpfaluno 		= formataCPFap(TRIM(rs("CPF")))
				
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
				strFoto =  ""
				
				RESPONSAVEL_QUEM = RS("RESPONSAVEL_QUEM")	
				RESPONSAVEL_GRAU_PARESTESCO = RS("RESPONSAVEL_GRAU_PARESTESCO")	
				RESPOSAVEL_POSSUI_DOCUMENTACAO = RS("RESPOSAVEL_POSSUI_DOCUMENTACAO")	
				MEDICAMENTO_CONTROLADO = RS("MEDICAMENTO_CONTROLADO")	
				IF MEDICAMENTO_CONTROLADO = "N" then MEDICAMENTO_CONTROLADO = "Não"
				IF MEDICAMENTO_CONTROLADO = "S" then MEDICAMENTO_CONTROLADO = "Sim"
				MEDICAMENTO_CONTROLADO_QUAL  = RS("MEDICAMENTO_CONTROLADO_QUAL")	
				TRANSPORTE_ESCOLAR 	 = RS("TRANSPORTE_ESCOLAR")	
				IF TRANSPORTE_ESCOLAR = "N" then TRANSPORTE_ESCOLAR = "Não"
				IF TRANSPORTE_ESCOLAR = "S" then TRANSPORTE_ESCOLAR = "Sim"				
				AUTORIZA_USO_IMAGEM  = RS("AUTORIZA_USO_IMAGEM")
				IF AUTORIZA_USO_IMAGEM = "N" then AUTORIZA_USO_IMAGEM = "Não"
				IF AUTORIZA_USO_IMAGEM = "S" then AUTORIZA_USO_IMAGEM = "Sim"				
				RESTRICAO_ALIMENTAR  = RS("RESTRICAO_ALIMENTAR")	
				IF RESTRICAO_ALIMENTAR = "N" then RESTRICAO_ALIMENTAR = "Não"
				IF RESTRICAO_ALIMENTAR = "S" then RESTRICAO_ALIMENTAR = "Sim"						
				RESTRICAO_ALIMENTAR_QUAL  = RS("RESTRICAO_ALIMENTAR_QUAL")		
				ALERGIA  				= RS("ALERGIA")	
				IF ALERGIA = "N" then ALERGIA = "Não"
				IF ALERGIA = "S" then ALERGIA = "Sim"					
				ALERGIA_QUAL  			= RS("ALERGIA_QUAL")	
				
				UNIFORME_TAMANHO  		= RS("UNIFORME_TAMANHO")
				TENIS_TAMANHO  			= RS("TENIS_TAMANHO")
				
				sql = "SELECT base64 "
				sql = sql & " FROM 	SCA_ALUNO_FOTO"
				sql = sql & " Where cod_Aluno = " & strCodigo
				rsAux.open sql, cnn
				if rsAux.eof = false then
					'strCaminhoFoto = 'session("strCaminhoRaiz") & "/fotoAluno/" & strCod_empresa & "/" & rsAux("arquivo")
					strCaminhoFoto = rsAux("base64")
					strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
					'strNomeBotaoFoto	= "Alterar Foto"
				end if				

				rsAux.close
				
				strTurma = ""
				'aluno na turma
				sql = "select AT.COD_TURMA, T.NomeTurma, T.Turmaaluno, C.DESCRICAO AS CURSO, p.Descricao as periodo, p.cod_periodo "
				sql = sql & " from SCA_ALUNO_TURMA AT"
				sql = sql & " INNER JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma  AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = T.COD_PERIODO"
				sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO"
				sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
				sql = sql & " and 	AT.COD_ALUNO = " &  strCodigo
				sql = sql & " and 	AT.situacao = 'A'"
				sql = sql & " and 	AT.ANO_LETIVO = " & intAnoLetivoAtual
				sql = sql & " and 	AT.Semestre = " & intSemestreAtual
				rsAux.open sql, cnn
				if not rsAux.eof then
					strTurma = rsAux("Turmaaluno") & " " & rsAux("NomeTurma")
					strCurso = rsAux("curso")
					strPeriodo = rsAux("periodo")
					intCodPeriodo = rsAux("cod_periodo")
				end if
				rsAux.close
				
				
				if strPromoverAnoLetivo = "S" and intCodTurma<>"" then
					'pega uma turma do proxim periodo
					if intCodPeriodo = "14" then 'ed. inf final passa para 1º ano
						sql = "SET NOCOUNT ON select top 1 Cod_Periodo, Cod_Curso, Descricao as periodo"
						sql = sql & " into #periodo_promovido"
						sql = sql & " from sca_periodo"
						sql = sql & " where situacao = 'A'"
						sql = sql & " and Cod_Periodo = 1 " '1º ano
						sql = sql & " select top 1 t.NomeTurma, t.TurmaAluno, p.periodo, c.descricao as curso, pp.Descricao as periodo"
						sql = sql & " from sca_turma t"
						sql = sql & " inner join #periodo_promovido p on p.Cod_Periodo = t.Cod_periodo "
						sql = sql & " INNER JOIN SCA_PERIODO PP ON PP.COD_PERIODO = P.COD_PERIODO"
						sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
						sql = sql & " where t.AnoLetivo = " & strAnoLetivoPromovido
						sql = sql & " and t.Cod_Empresa = " & session("CodEmpresa")
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strTurma = rsAux("Turmaaluno") & " " & rsAux("NomeTurma")
							strCurso = rsAux("curso")
							strPeriodo = rsAux("periodo")
						end if
						rsaux.close
					else
						sql = "SET NOCOUNT ON select top 1 Cod_Periodo, Cod_Curso, Descricao as periodo"
						sql = sql & " into #periodo_promovido"
						sql = sql & " from sca_periodo"
						sql = sql & " where situacao = 'A'"
						sql = sql & " and Sequencia > "
						sql = sql & " 	("
						sql = sql & " 		select p.Sequencia"
						sql = sql & " 		from sca_turma t"
						sql = sql & " 		inner join SCA_PERIODO p on p.Cod_Periodo = t.Cod_periodo"
						sql = sql & " 		where t.Cod_Turma = " & intCodTurma
						sql = sql & " 	)"
						sql = sql & " order by Sequencia"
						sql = sql & " select top 1 t.NomeTurma, t.TurmaAluno, p.periodo, c.descricao as curso, pp.Descricao as periodo"
						sql = sql & " from sca_turma t"
						sql = sql & " inner join #periodo_promovido p on p.Cod_Periodo = t.Cod_periodo "
						sql = sql & " INNER JOIN SCA_PERIODO PP ON PP.COD_PERIODO = P.COD_PERIODO"
						sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
						sql = sql & " where t.AnoLetivo = " & strAnoLetivoPromovido
						sql = sql & " and t.Cod_Empresa = " & session("CodEmpresa")
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strTurma = rsAux("Turmaaluno") & " " & rsAux("NomeTurma")
							strCurso = rsAux("curso")
							strPeriodo = rsAux("periodo")
						end if
						rsaux.close
					end if
				end if
				
				strNecessidadeEspecial=""
				if strCodigo<>"" then
					sql = "select distinct n.Desc_NecEspecialNova"
					sql = sql & " from SCA_ALUNO_NECESSIDADEESPECIAL a"
					sql = sql & " inner join SCA_NECESSIDADEESPECIAL n on n.Cod_NecEspecial = a.COD_NECESSIDADEESPECIAL"
					sql = sql & " where a.COD_ALUNO = " & strCodigo
					'response.write sql
					rsaux.open sql, cnn
					if not rsaux.eof then
						while not rsaux.eof
							if necessidades="" then
								strNecessidadeEspecial = rsaux("Desc_NecEspecialNova")
							else
								strNecessidadeEspecial = strNecessidadeEspecial & ", " & rsaux("Desc_NecEspecialNova")
							end if
							rsaux.movenext
						wend
					end if
					rsaux.close
				end if
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
									<td colspan="2" rowspan="8" class="texto1" align="center">
									<%if strFoto<>"" then%>
									<table width="120" height="130" border="0" cellpadding="0" cellspacing="0">
                                      <tr>
                                        <td bgcolor="#FFFFFF" align="center" class="text"><%=strFoto%></td>
                                      </tr>
                                    </table>
									<%end if%>
									</td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;CPF: </td>
									<td class="texto1"><strong><%=strCpfaluno%></strong></td>
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
									<td class="texto1">&nbsp;Etnia: </td>
									<td class="texto1"><strong><%=strEtnia %></strong></td>
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
									<td class="texto1">&nbsp;Munic&iacute;pio:</td>
									<td class="texto1"><strong><%=strCidaderesidencia%></strong></td>
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
									<td width="16%" class="texto1"></td>
									<td width="19%" class="texto1"></td>
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
							<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1"><li><strong>Dados Escolares <%=strAnoLetivoPromovido%></strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS ESCOLARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Curso:</td>
									<td width="47%" class="texto1"><strong><%=strCurso%></strong></td>
									<td width="16%" class="texto1">&nbsp;Período:</td>
									<td width="19%" class="texto1"><strong><%=strPeriodo%></strong></td>
								  </tr>
								  <tr>
									<td width="18%" class="texto1">&nbsp;Turma:</td>
									<td width="47%" class="texto1"><strong><%=strTurma%></strong></td>
									<td width="16%" class="texto1">&nbsp;ID Censo:</td>
									<td width="19%" class="texto1"><strong><%=ID_CENSO%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Forma Ingresso: </td>
									<td class="texto1"><strong><%=strFormaIngresso%></strong></td>
									<td class="texto1">&nbsp;Data Ingresso: </td>
									<td class="texto1"><strong><%=strDataingresso%></strong></td>
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
							<td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" ><li><strong>Dados Adicionais</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" class="texto1" >
								<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%" class="texto1">&nbsp;Faz uso de medicamento controlado?</td>
									<td width="47%" class="texto1"><strong><%=MEDICAMENTO_CONTROLADO%>&nbsp; <%=MEDICAMENTO_CONTROLADO_QUAL%></strong></td>
									<td width="16%" class="texto1">&nbsp;Utiliza transporte escolar municipal?</td>
									<td width="19%" class="texto1"><strong><%=TRANSPORTE_ESCOLAR%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1" colspan="2">&nbsp;Autoriza o uso da imagem do filho(a) em eventos da SEMEC/ESCOLA?<strong><%=AUTORIZA_USO_IMAGEM%></strong></td>
									<td class="texto1">&nbsp;Possui restrição alimentar?</td>
									<td class="texto1"><strong><%=RESTRICAO_ALIMENTAR%>&nbsp; <%=RESTRICAO_ALIMENTAR_QUAL%></strong></td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Possui alergia?</td>
									<td class="texto1"><strong><%=ALERGIA%>&nbsp; <%=ALERGIA_QUAL%></strong></td>
									<td class="texto1">&nbsp;</td>
									<td class="texto1">&nbsp;</td>
								  </tr>
								  <tr>
									<td class="texto1">&nbsp;Tamanho do Uniforme:</td>
									<td class="texto1"><strong><%=UNIFORME_TAMANHO%></strong></td>
									<td class="texto1">&nbsp;Número do tênis:</td>
									<td class="texto1"><strong><%=TENIS_TAMANHO%></strong></td>
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
						if mostraNotas = "S" then
							intCodAluno = strCodigo
							sql = " SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, "
							sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, SCA_TURMA.NOMETURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_NOTAS_FALTAS.MEDIA, "
							for i=0 to ubound(vetCampo,2)
								strPos = vetCampo(0,i)
								if cInt(strPos)<10 then strPos = "0" & strPos
								sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
								sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
							next
							sql = sql & " SCA_DISCIPLINA.DESC_DISCIPLINA, SCA_TURNO.DESC_TURNO, SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,SCA_SITUACAOALUNO.DESC_SITUACAOALUNO,"
							sql = sql & " SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA,sca_turma.DesvincularCriterioAvaliacao,"
							sql = sql & " SCA_NOTAS_FALTAS.situacao, SCA_PERIODO.Descricao AS PERIODO, SCA_CURSO.Descricao AS CURSO, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual"
							sql = sql & " FROM SCA_ALUNO_TURMA "
							sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.SITUACAO = 'A'"
							sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
							sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_TURMA.Cod_periodo"
							sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso"
							sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO "
							sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.COD_SITUACAOALUNO = SCA_ALUNO.COD_SITUACAOALUNO "
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
							sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
							sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
							sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
							sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
							sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
							sql = sql & " AND SCA_ALUNO.CODIGO = " &  intCodAluno
							sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO, SCA_DISCIPLINA.DESC_DISCIPLINA"
							rsAux.open sql, cnn
							if rsAux.eof = false then
								strNomeAluno 	 = rsAux("NOMEALUNO")
								strMatricula 	 = rsAux("MATRICULA")
								strNomeTurma 	 = rsAux("NOMETURMA")
								strDescricaoTurno= rsAux("DESC_TURNO")
								strDescricaoCurso= rsAux("CURSO")
								strDescricaoPeriodo= rsAux("PERIODO")
								strDesvincularCriterioAvaliacao = rsAux("DesvincularCriterioAvaliacao")
								strSituacaoaluno = rsAux("DESC_SITUACAOALUNO")
								%>
								<br>
								<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
								  <tr>
									<td width="8%" class="celula"><div align="center"><strong>Disciplinas </strong></div></td>
									<%
									for i=0 to ubound(vetCampo,2)
									%>
										<td width="5%" class="celula"><div align="center"><strong><%=vetCampo(1,i)%></strong></div></td>
										<% if left(vetCampo(1,i),1) = "1" or left(vetCampo(1,i),1) = "2" or left(vetCampo(1,i),1) = "3" or left(vetCampo(1,i),1) = "4" then%>
										<td width="5%" class="celula"><div align="center"><strong>Falta</strong></div></td>
										<% end if%>
									<%
									next
									%>
									<%if mostra_ch = "S" then%>
									<td width="8%" class="celula"><div align="center"><strong>Carga Horária</strong></div></td>
									<%end if%>
									<%if mostra_percentual_falta = "S" then%>
									<td width="8%" class="celula"><div align="center"><strong>% Faltas</strong></div></td>
									<%end if%>
								  </tr>
									<%
									strQtdeDiscRep = 0
									strTotalFaltas = 0
									while not rsAux.eof	
										strDisciplina 	= rsAux("DESC_DISCIPLINA")
										strCHDisciplina	= rsAux("Ch_Anual")
										strOmitir_Criterio	= rsAux("Omitir_Criterio")
										strMedia		= "---"
										strResultadoFinal 		= ""
										
										if strOmitir_Criterio = "S" then
											strResultadoFinal = "<font color='#0000FF'>AP</font>"
										else
											if not isnull(rsAux("MEDIA")) and rsAux("MEDIA")<>"" then
												strMedia = FORMATNUMBER(rsAux("MEDIA"),1)
												
												if rsAux("situacao")="AP" then
													strResultadoFinal = "<font color='#0000FF'>" & rsAux("situacao") & "</font>"
												elseif rsAux("situacao")="RN" then
													strResultadoFinal = "<font color='#FF0000'>" & rsAux("situacao") & "</font>"
												else
													strResultadoFinal = "---"
												end if

												if cCur(strMedia) < cCur(media_aprovacao_final) then
													strQtdeDiscRep = strQtdeDiscRep + 1
												end if
											end if
										end if
											%>
											<td width="16%" align="left" class="celula">&nbsp;<%=strDisciplina%></td>
											<%					
											for i=0 to ubound(vetCampo,2)
												strPos = vetCampo(0,i)
												if cInt(strPos)<10 then strPos = "0" & strPos
												
												strNota = "---"
												
												if not isnull(rsAux("NOTA" & strPos)) and rsAux("NOTA" &strPos)<>"" then
													strNota = FORMATNUMBER(rsAux("NOTA" & strPos),1)
												end if
												strFalta = ""
												if not isnull(rsAux("FALTA" & strPos)) and rsAux("FALTA" &strPos)<>"" then
													strFalta = rsAux("FALTA" & strPos)
													strTotalFaltas = strTotalFaltas + strFalta
												end if
												%>
												<td width="5%" align="center" class="celula">&nbsp;<%=strNota%>&nbsp;</td>
												<% if left(vetCampo(1,i),1) = "1" or left(vetCampo(1,i),1) = "2" or left(vetCampo(1,i),1) = "3" or left(vetCampo(1,i),1) = "4" then%>
												<td width="5%" align="center" class="celula">&nbsp;<%=strFalta%>&nbsp;</td>
												<% end if%>
												
												<%
											next
											
											if isnull(strCHDisciplina) then
												strPercFaltas = 0
											else
												if strTotalFaltas <> "" then
													strPercFaltas = FORMATNUMBER((strTotalFaltas * 100)/strCHDisciplina,1)
													if cCur(strPercFaltas) > cCur(frequencia_minima_percentual) then
														strResultadoFinal = "<font color='#FF0000'>RF</font>"
													end if
												end if
											end if
											
											%>
											<%if mostra_ch = "S" then%>
											<td width="5%" align="center" class="celula">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
											<%end if%>
											<%if mostra_percentual_falta = "S" then%>
											<td width="5%" align="center" class="celula">&nbsp;<%=strPercFaltas%>&nbsp;</td>
											<%end if%>
										</tr>
										<%
										strTotalFaltas = 0
										rsAux.movenext
										
									wend
									%>
									</table>
									<%
							end if
							rsAux.close
						
						end if
						%>	
                        <!-- fim notas -->
<br>
<br>
						  <!--#include file="includes/inc_RepresentantesLegais.asp"-->
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