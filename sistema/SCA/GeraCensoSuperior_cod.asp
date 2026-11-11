<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: gerar setransp
-->
<html>
<head><
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">


<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<%
 'response.CodePage = 65001 
 'session.lcid = 1046 
 'Response.charset ="utf-8"

	'on error resume next
	'------------------
	'PASTA DO ARQUIVO
	'------------------

	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))

	strNomeArquivo		= "Censo" & strAnoLetivo & ".TXT"
	strPastaArquivos	= server.MapPath("../../ArquivoSetransp")
	strPastaArquivos 	= strPastaArquivos & "\" & Session("CodEmpresa")
	strDominiolink       = trim(Request.ServerVariables("SERVER_NAME"))
	
	Set file = Server.CreateObject("Scripting.FileSystemObject")

	'Cria a pasta de acordo com codigo do Imovel
	Pasta = Server.MapPath("../../ArquivoSetransp") & "\" & Session("CodEmpresa")
	IF Not file.FolderExists(Pasta) THEN
		file.CreateFolder(Pasta)
	END IF

	strCaminho = strPastaArquivos & "\" & strNomeArquivo
	if not file.FileExists(strCaminho) then
		Set outfile = file.CreateTextFile(strCaminho, True) 'Parâmetros: Caminho, OverWrite'
	else
		Set outfile = file.OpenTextFile(strCaminho, 2) 'Parâmetros: Caminho, Tipo de Abertura'
	end if
	
	strPaginaTitulo = "GeraCensoSuperior_con.asp"
	

	if intCodSemestre = "" then intCodSemestre = "0"
	
	intCodigoInepIES = ""
	sql = " select ISNULL(Codigo_Censo,'') as CodigoInepIES from SEG_EMPRESA "
	sql = sql & " where CODIGO = " & Session("CodEmpresa")
	rs.open sql, cnn
	if not rs.eof then 
		intCodigoInepIES = rs("CodigoInepIES")
	else
		intCodigoInepIES = ""
	end if	
	rs.close
	
	if trim(intCodigoInepIES) = "" then
		%>
		<script>
			alert("ATENÇÃO: Código do INEP ainda não informado para Instituição.");
			window.navigate('GeraCensoSuperior_con.asp');
		</script>
		<%
		response.end
	end if
	
	sql = " SELECT DISTINCT SCA_ALUNO.CODIGO as COD_ALUNO, "
	sql = sql & " ISNULL(SCA_ALUNO.CODIGOINEP,'') AS CODIGOINEP, "
	sql = sql & " ISNULL(SCA_ALUNO.MATRICULA,'') AS MATRICULA, "
	sql = sql & " ISNULL(SCA_ALUNO.NOMEALUNO_SEMACENTO,'') as NOMEALUNO, "

	'sql = sql & " (replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace "
	'sql = sql & " (replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace " 
	'sql = sql & " (SCA_ALUNO.NOMEALUNO, 'Â','A'), 'Ä','A'), 'Ã','A'), 'À','A'),'Á','A') " 
	'sql = sql & " , 'Ê','E'), 'Ë','E'), 'È','E'), 'É','E'), 'Î','I') "
	'sql = sql & " , 'Ï','I'),'Ì','I'), 'Í','I') "
	'sql = sql & " , 'Ô','O'), 'Ö','O'), 'Õ','O') "
	'sql = sql & " , 'Ò','O'), 'Ó','O') "
	'sql = sql & " , 'Û','U'), 'Ü','U'), 'Ù','U'), 'Ú','U') "
	'sql = sql & " , 'Ç','C'), 'º','o'), '`',' ')) as NOMEALUNO, "
	
	sql = sql & " SCA_ALUNO.CPFALUNO, "
	sql = sql & " '' AS DOCUMENTO_ESTRANGEIRO, "
	sql = sql & " REPLACE(CONVERT(VARCHAR(10), SCA_ALUNO.DATANASCIMENTO, 103), '/', '') as DATANASCIMENTO, "
	sql = sql & " (CASE WHEN SCA_ALUNO.SEXOALUNO = 'M' THEN 0 ELSE 1 END) AS SEXOALUNO, "
	sql = sql & " ISNULL(SCA_ALUNO.COD_ETNIA,'0') AS COD_ETNIA, "
	sql = sql & " ISNULL(SCA_ALUNO.MAE_SEMACENTO,'') as MAE, "

	'sql = sql & " (replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace "
	'sql = sql & " (replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace " 
	'sql = sql & " (UPPER(SCA_ALUNO.MAE), 'Â','A'), 'Ä','A'), 'Ã','A'), 'À','A'),'Á','A') "
	'sql = sql & " , 'Ê','E'), 'Ë','E'), 'È','E'), 'É','E'), 'Î','I') "
	'sql = sql & " , 'Ï','I'),'Ì','I'), 'Í','I') "
	'sql = sql & " , 'Ô','O'), 'Ö','O'), 'Õ','O') "
	'sql = sql & " , 'Ò','O'), 'Ó','O') "
	'sql = sql & " , 'Û','U'), 'Ü','U'), 'Ù','U'), 'Ú','U') "
	'sql = sql & " , 'Ç','C'), 'º','o'), '`',' ')) as MAE, "

	sql = sql & " ISNULL(SCA_ALUNO.COD_TIPONACIONALIDADE,'1') AS COD_TIPONACIONALIDADE, "
	sql = sql & " ISNULL(SCF_UF.COD_UFINEP,'0') AS UF_NASCIMENTO, "
	sql = sql & " ISNULL(CENSO_MUNICIPIO.CODIGOMUNICIPIO,'0') AS CODIGOMUNICIPIONASCIMENTO, "
	sql = sql & " ISNULL(SCA_ALUNO.PAIS_ORIGEM,'') AS PAIS_ORIGEM, "
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Deficiencia_Habilidades_C15,'0') AS Deficiencia_Habilidades_C15, "
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_Cegueira_C16,'') AS Tipo_Deficiencia_Cegueira_C16, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_Baixa_Visao_C17,'') AS Tipo_Deficiencia_Baixa_Visao_C17, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_Surdez_C18,'') AS Tipo_Deficiencia_Surdez_C18, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_Auditiva_C19,'') AS Tipo_Deficiencia_Auditiva_C19, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_Fisica_C20,'') AS Tipo_Deficiencia_Fisica_C20, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_SurdoCegueira_C21,'') AS Tipo_Deficiencia_SurdoCegueira_C21, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_Multipla_C22,'') AS Tipo_Deficiencia_Multipla_C22, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_Intelectual_C23,'') AS Tipo_Deficiencia_Intelectual_C23, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_AutismoInfantil_C24,'') AS Tipo_Deficiencia_AutismoInfantil_C24, "
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_SindromeAsperger_C25,'') AS Tipo_Deficiencia_SindromeAsperger_C25, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_SindromeRett_C26,'') AS Tipo_Deficiencia_SindromeRett_C26, " 
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_DesintegrativoInfancia_C27,'') AS Tipo_Deficiencia_DesintegrativoInfancia_C27, "  
	sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Deficiencia_AltasHabilidades_C28,'') AS Tipo_Deficiencia_AltasHabilidades_C28 "
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa  "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular  "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa " 
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa AND SCA_CURSO.SITUACAO='A' " 
	sql = sql & " LEFT JOIN scf_categoria_desconto on scf_categoria_desconto.codigo = SCA_ALUNO.cod_categoria_desconto and scf_categoria_desconto.cod_empresa = SCA_ALUNO.cod_empresa " 
	sql = sql & " LEFT JOIN scf_uf on scf_uf.codigo = SCA_ALUNO.UFNASCIMENTO " 
	sql = sql & " LEFT JOIN CENSO_MUNICIPIO ON SCA_ALUNO.CIDADENASCIMENTO = CENSO_MUNICIPIO.NOMEMUNICIPIO AND CENSO_MUNICIPIO.CODIGO_UF = scf_uf.COD_UFINEP " 
	sql = sql & " LEFT JOIN SCA_ALUNO_CENSOCOMPLEMENTO ON SCA_ALUNO_CENSOCOMPLEMENTO.COD_ALUNO = SCA_ALUNO.CODIGO " 
	sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
	if intCodCurso <> "0" then
		sql = sql & " and SCA_CURSO.Cod_Curso in (" & intCodCurso & ")" 
	end if	
	sql = sql & " and SCA_ALUNO.CODIGO in ( select DISTINCT COD_ALUNO from SCF_DEBITOALUNO where (PARCELA = 1 or PARCELA = 7) AND COD_TIPOPARCELA = 5 AND ANO = " & strAnoLetivo & "						AND cod_situacao_pagamento <> 1 )" 
	sql = sql & " ORDER BY NOMEALUNO "
	rs.open sql, cnn
	if not rs.eof then 
		strLinha1 = "40|" & trim(intCodigoInepIES) & "|4"
		outfile.WriteLine(strLinha1)
		While not rs.eof
		    '
            'Dados CadastraisremoveAcentos
			'01 
			strLinha1 = "41|"
			'02 
			strLinha1 = strLinha1 & TRIM(rs("CODIGOINEP")) & "|" 
			'03 
			strLinha1 = strLinha1 & TRIM(rs("MATRICULA")) & "|" 
			'04 
			strLinha1 = strLinha1 & TRIM(rs("NOMEALUNO")) & "|" 
				if TRIM(rs("NOMEALUNO")) = ""  or  len(TRIM(rs("NOMEALUNO"))) > 120 then
					%>
					<script>
						alert("ATENÇÃO: Campo NOME para a matricula n.  <%=TRIM(rs("MATRICULA"))%>  e vazio ou maior que 120 caracteres. Verifique!");
						window.navigate('GeraCensoSuperior_con.asp');
					</script>
					<%
					response.end
				end if
			'05 
			strLinha1 = strLinha1 & TRIM(rs("CPFALUNO")) & "|" 
				if TRIM(rs("CPFALUNO")) = "" then
					%>
					<script>
						alert("ATENÇÃO: Campo CPF para a matricula n.  <%=TRIM(rs("MATRICULA"))%>  e vazio. Verifique!");
						window.navigate('GeraCensoSuperior_con.asp');
					</script>
					<%
					response.end
				end if
			'06 
			strLinha1 = strLinha1 & TRIM(rs("DOCUMENTO_ESTRANGEIRO")) & "|" 
			'07 
			strLinha1 = strLinha1 & TRIM(rs("DATANASCIMENTO")) & "|" 
				if TRIM(rs("DATANASCIMENTO")) = "" or isnull(rs("DATANASCIMENTO")) then
					%>
					<script>
						alert("ATENÇÃO: Campo DATA DE NASCIMENTO para a matricula n.  <%=TRIM(rs("MATRICULA"))%>  e vazio. Verifique!");
						window.navigate('GeraCensoSuperior_con.asp');
					</script>
					<%
					response.end
				end if
			
			'08 
			strLinha1 = strLinha1 & TRIM(rs("SEXOALUNO")) & "|" 
				if TRIM(rs("SEXOALUNO")) <> "0" AND TRIM(rs("SEXOALUNO")) <> "1" then
					%>
					<script>
						alert("ATENÇÃO: Campo SEXO para a matricula n. <%=TRIM(rs("MATRICULA"))%>  e invalido. Verifique!");
						window.navigate('GeraCensoSuperior_con.asp');
					</script>
					<%
					response.end
				end if
			'09 
			strLinha1 = strLinha1 & TRIM(rs("COD_ETNIA")) & "|" 
				if TRIM(rs("COD_ETNIA")) <> "1" AND TRIM(rs("COD_ETNIA")) <> "2" AND TRIM(rs("COD_ETNIA")) <> "3" AND TRIM(rs("COD_ETNIA")) <> "4" AND TRIM(rs("COD_ETNIA")) <> "5" AND TRIM(rs("COD_ETNIA")) <> "6" then
					%>
					<script>
						alert("ATENÇÃO: Campo ETNIA para a matricula n. <%=TRIM(rs("MATRICULA"))%> e invalido. Verifique!");
						window.navigate('GeraCensoSuperior_con.asp');
					</script>
					<%
					response.end
				end if
			'10 
			strLinha1 = strLinha1 & TRIM(rs("MAE")) & "|" 
			'11 
			strLinha1 = strLinha1 & TRIM(rs("COD_TIPONACIONALIDADE")) & "|" 
				if TRIM(rs("COD_TIPONACIONALIDADE")) <> "1" AND TRIM(rs("COD_TIPONACIONALIDADE")) <> "2" AND TRIM(rs("COD_TIPONACIONALIDADE")) <> "3" then
					%>
					<script>
						alert("ATENÇÃO: Campo TIPO DE NACIONALIDADE para a matricula n. <%=TRIM(rs("MATRICULA"))%> e invalido. Verifique!");
						window.navigate('GeraCensoSuperior_con.asp');
					</script>
					<%
					response.end
				end if
			'12 
			strLinha1 = strLinha1 & TRIM(rs("UF_NASCIMENTO")) & "|" 
			'13 
			erroMunicipio = ""
			strLinha1 = strLinha1 & TRIM(rs("CODIGOMUNICIPIONASCIMENTO")) & "|" 
				if  TRIM(rs("UF_NASCIMENTO")) <> "0" then
					if  TRIM(rs("CODIGOMUNICIPIONASCIMENTO")) = "0"  then
						erroMunicipio = "erro"
						%>
						<script>
                            alert("ATENÇÃO: Campo CIDADE NASCIMENTO para a matricula n. <%=TRIM(rs("MATRICULA"))%> e invalido. Verifique!");
                            //window.navigate('GeraCensoSuperior_con.asp');
                        </script>
                        <%
                        'response.end
                    end if
				end if	
			'14 
			strLinha1 = strLinha1 & TRIM(rs("PAIS_ORIGEM")) & "|" 
					if  TRIM(rs("PAIS_ORIGEM")) = "" or isnull(rs("PAIS_ORIGEM")) then
						%>
						<script>
                            alert("ATENÇÃO: Campo PAIS DE ORIGEM para a matricula n. <%=TRIM(rs("MATRICULA"))%> e invalido. Verifique!");
                            window.navigate('GeraCensoSuperior_con.asp');
                        </script>
                        <%
                        response.end
                    end if
			'15 
			strLinha1 = strLinha1 & TRIM(rs("Deficiencia_Habilidades_C15")) & "|" 
			'16 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_Cegueira_C16")) & "|" 
			'17 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_Baixa_Visao_C17")) & "|" 
			'18 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_Surdez_C18")) & "|" 
			'19 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_Auditiva_C19")) & "|" 
			'20 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_Fisica_C20")) & "|" 
			'21 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_SurdoCegueira_C21")) & "|" 
			'22 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_Multipla_C22")) & "|" 
			'23 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_Intelectual_C23")) & "|" 
			'24 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_AutismoInfantil_C24")) & "|" 
			'25 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_SindromeAsperger_C25")) & "|" 
			'26 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_SindromeRett_C26")) & "|" 
			'27 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_DesintegrativoInfancia_C27")) & "|" 
			'28 
			strLinha1 = strLinha1 & TRIM(rs("Tipo_Deficiencia_AltasHabilidades_C28"))

			if erroMunicipio <> "erro" then
				outfile.WriteLine(strLinha1)
			end if	
			'
			'Vinculo
			'	
			sql = " SELECT TOP 1 "     
			sql = sql & " '42' AS TIPO_REGISTRO, "										 
			sql = sql & " SCA_CURSO.COD_INEP, "												 
			sql = sql & " '' COD_POLO_EAD, "												 
			sql = sql & "(CASE WHEN UPPER(SCA_TURNO.DESC_TURNO) = 'MATUTINO' THEN 1 "
			sql = sql & "	   WHEN UPPER(SCA_TURNO.DESC_TURNO) = 'VESPERTINO' THEN 2 "
      		sql = sql & "      WHEN UPPER(SCA_TURNO.DESC_TURNO) = 'NOTURNO' THEN 3 "
     		sql = sql & "	   WHEN UPPER(SCA_TURNO.DESC_TURNO) = 'INTEGRAL' THEN 4 "
			sql = sql & "END) AS Turno, "									 
			sql = sql & " SCA_SITUACAOALUNO.COD_VINCULO_INEP AS VINCULO, "						 
			sql = sql & " REPLACE(CONVERT(VARCHAR(10), SCA_ALUNO.DATAINGRESSO, 103), '/', '') as DATAINGRESSO, "							 
			sql = sql & " SCA_ALUNO.ESCOLA_PUBLICA, "										 
			sql = sql & " (CASE WHEN SCA_FORMAINGRESSO.Cod_Campo_Inep = 8 THEN 1 ELSE 0 END) AS VESTIBULAR, "
			sql = sql & " (CASE WHEN SCA_FORMAINGRESSO.Cod_Campo_Inep = 9 THEN 1 ELSE 0 END) AS ENEM, "
			sql = sql & " (CASE WHEN SCA_FORMAINGRESSO.Cod_Campo_Inep = 10 THEN 1 ELSE 0 END) AS Forma_ingresso_OutrasSelecoes_VC10, "
			sql = sql & " (CASE WHEN SCA_FORMAINGRESSO.Cod_Campo_Inep = 11 THEN 1 ELSE 0 END) AS Forma_ingresso_PECG_VC11, " 
			sql = sql & " (CASE WHEN SCA_FORMAINGRESSO.Cod_Campo_Inep = 12 THEN 1 ELSE 0 END) AS Forma_ingresso_OutrasFormas_VC12, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Programa_ReservaVagas_VC13,'0') AS Programa_ReservaVagas_VC13, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Programa_ReservaVagas_Etnico_VC14,'') AS Programa_ReservaVagas_Etnico_VC14, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Programa_ReservaVagas_Deficientes_VC15,'') AS Programa_ReservaVagas_Deficientes_VC15, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Programa_ReservaVagas_EnsinoPublico_VC16,'') AS Programa_ReservaVagas_EnsinoPublico_VC16, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Programas_ReservaVagas_Social_VC17,'') AS Programas_ReservaVagas_Social_VC17, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Programas_ReservaVagas_Outros_VC18,'') AS Programas_ReservaVagas_Outros_VC18, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Financiamento_Estud_VC19,'0') AS Financiamento_Estud_VC19, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Finan_Estud_Fies_VC20,'') AS Finan_Estud_Fies_VC20, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Finan_Estud_GovEstadual_VC21,'') AS Finan_Estud_GovEstadual_VC21, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Finan_Estud_GovMunicipall_VC22,'') AS Finan_Estud_GovMunicipall_VC22, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Finan_Estud_ReembolsavelIES_VC23,'') AS Finan_Estud_ReembolsavelIES_VC23, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Finan_Estud_ReembolsavelEntidades_VC24,'') AS Finan_Estud_ReembolsavelEntidades_VC24, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Finan_Estud_ReembolsavelOutros_VC25,'') AS Finan_Estud_ReembolsavelOutros_VC25, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_finan_ProUniIntegral_VC26,'') AS Tipo_finan_ProUniIntegral_VC26, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_finan_ProUniParcial_VC27,'') AS Tipo_finan_ProUniParcial_VC27, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_finan_EntidadesExternas_VC28,'') AS Tipo_finan_EntidadesExternas_VC28, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_finan_NaoReembolsaveGovEstadual_VC29,'') AS Tipo_finan_NaoReembolsaveGovEstadual_VC29, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_finan_NaoReembolsavelIES_VC30,'') AS Tipo_finan_NaoReembolsavelIES_VC30, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_finan_NaoReembolsavelGovMunicipal_VC31,'') AS Tipo_finan_NaoReembolsavelGovMunicipal_VC31, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_finan_NaoReembolsaveOutrosl_VC32,'') AS Tipo_finan_NaoReembolsaveOutrosl_VC32, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Apoio_Social_VC33,'0') AS Apoio_Social_VC33, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Apoio_Social_Alimentacao_VC34,'') AS Tipo_Apoio_Social_Alimentacao_VC34, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Apoio_Social_Moradia_VC35,'') AS Tipo_Apoio_Social_Moradia_VC35, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Apoio_Social_Transporte_VC36,'') AS Tipo_Apoio_Social_Transporte_VC36, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Apoio_Social_MaterialDidatico_VC37,'') AS Tipo_Apoio_Social_MaterialDidatico_VC37, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Apoio_Social_BolsaTrabalho_VC38,'') AS Tipo_Apoio_Social_BolsaTrabalho_VC38, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Tipo_Apoio_Social_BolsaPermanencia_VC39,'') AS Tipo_Apoio_Social_BolsaPermanencia_VC39, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Ativ_FormacaoComplementar_VC40,'0') AS Ativ_FormacaoComplementar_VC40, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Ativ_FormacaoComplementar_Pesquisa_VC41,'') AS Ativ_FormacaoComplementar_Pesquisa_VC41, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.BR_FormacaoComplementar_Pesquisa_VC42,'') AS BR_FormacaoComplementar_Pesquisa_VC42, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Ativ_FormacaoComplementar_Extensao_VC43,'') AS Ativ_FormacaoComplementar_Extensao_VC43, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.BR_FormacaoComplementar_Extensao_VC44,'') AS BR_FormacaoComplementar_Extensao_VC44, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Ativ_FormacaoComplementar_Monitoria_VC45,'') AS Ativ_FormacaoComplementar_Monitoria_VC45, "
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.BR_FormacaoComplementar_Monitoria_VC46,'') AS BR_FormacaoComplementar_Monitoria_VC46, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.Ativ_FormacaoComplementar_Estagio_VC47,'') AS Ativ_FormacaoComplementar_Estagio_VC47, " 
			sql = sql & " ISNULL(SCA_ALUNO_CENSOCOMPLEMENTO.BR_FormacaoComplementar_Estagio_VC48,'') AS BR_FormacaoComplementar_Estagio_VC48, "
					
			'Localizando Bolsa OVG
			sql = sql & " (select DISTINCT TOP 1 cod_categoria_desconto "
			sql = sql & " from SCF_DEBITOALUNO DA "
			sql = sql & " INNER JOIN SCF_CATEGORIA_DESCONTO CD ON DA.cod_categoria_desconto = CD.codigo "
			sql = sql & " where (PARCELA = 1 or PARCELA = 7) "
			sql = sql & " AND COD_TIPOPARCELA = 5 "
			sql = sql & " AND ANO = " & strAnoLetivo
			sql = sql & " AND Cod_Aluno = " & rs("COD_ALUNO")
			sql = sql & " AND ISNULL(cod_categoria_desconto,'0') <> 0 ) AS BolsaOVG "

			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa " 
			sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_Turno = SCA_TURMA.Cod_Turno "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
			sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
			sql = sql & " LEFT JOIN SCA_VINCULOALUNO_CENSO ON SCA_VINCULOALUNO_CENSO.CODIGO = SCA_SITUACAOALUNO.Cod_SituacaoAluno "
			sql = sql & " LEFT JOIN SCA_FORMAINGRESSO ON SCA_FORMAINGRESSO.CODIGO = SCA_ALUNO.COD_FORMAINGRESSO "

			sql = sql & " LEFT JOIN SCA_ALUNO_CENSOCOMPLEMENTO ON SCA_ALUNO_CENSOCOMPLEMENTO.COD_ALUNO = SCA_ALUNO.CODIGO "
			sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
			sql = sql & " and SCA_ALUNO.CODIGO = " & rs("COD_ALUNO")
			sql = sql & " AND	SCA_TURMA.ANOLETIVO = " & strAnoLetivo
			sql = sql & " order by SCA_ALUNO_TURMA.CODIGO DESC "
			rsaux.open sql, cnn
			if not rsaux.eof then 
				'01 Tipo do registro
				strLinha1 = "42|"
				'02 ID do curso
				strLinha1 = strLinha1 & TRIM(rsaux("COD_INEP")) & "|" 
				'03 Código do pólo EAD no INEP
				strLinha1 = strLinha1 & TRIM(rsaux("COD_POLO_EAD")) & "|" 
				'04 Turno do aluno 
				strLinha1 = strLinha1 & TRIM(rsaux("TURNO")) & "|" 
				'05 Situação do vínculo 
				strLinha1 = strLinha1 & TRIM(rsaux("VINCULO")) & "|" 
				'06 Data de ingresso
				strLinha1 = strLinha1 & TRIM(rsaux("DATAINGRESSO")) & "|" 
				'07 Aluno procedente de escola pública
				strLinha1 = strLinha1 & TRIM(rsaux("ESCOLA_PUBLICA")) & "|" 
				'08 Forma de ingresso/seleção - Vestibular
				strLinha1 = strLinha1 & TRIM(rsaux("VESTIBULAR")) & "|" 
				'09 Forma de ingresso/seleção - Enem
				strLinha1 = strLinha1 & TRIM(rsaux("ENEM")) & "|" 
				'10 Forma de ingresso/seleção - Outros tipos de seleção
				strLinha1 = strLinha1 & TRIM(rsaux("Forma_ingresso_OutrasSelecoes_VC10")) & "|" 
				'11 Forma de ingresso/seleção - PEC-G
				strLinha1 = strLinha1 & TRIM(rsaux("Forma_ingresso_PECG_VC11")) & "|" 
				'12 Forma de ingresso - Outras formas de ingresso
				strLinha1 = strLinha1 & TRIM(rsaux("Forma_ingresso_OutrasFormas_VC12")) & "|" 
				'13 Programa de reserva de vagas
				strLinha1 = strLinha1 & TRIM(rsaux("Programa_ReservaVagas_VC13")) & "|" 
				'14 Programa de reserva de vagas - Étnico
				strLinha1 = strLinha1 & TRIM(rsaux("Programa_ReservaVagas_Etnico_VC14")) & "|" 
				'15 Programa de reserva de vagas - Pessoa com deficiência
				strLinha1 = strLinha1 & TRIM(rsaux("Programa_ReservaVagas_Deficientes_VC15")) & "|" 
				'16 Programa de reserva de vagas- Estudante procedente de ensino público
				strLinha1 = strLinha1 & TRIM(rsaux("Programa_ReservaVagas_EnsinoPublico_VC16")) & "|" 
				'17 Programa de reserva de vagas - Social/renda familiar
				strLinha1 = strLinha1 & TRIM(rsaux("Programas_ReservaVagas_Social_VC17")) & "|" 
				'18 Programa de reserva de vagas - Outros
				strLinha1 = strLinha1 & TRIM(rsaux("Programas_ReservaVagas_Outros_VC18")) & "|" 
				if isnull(rsaux("BolsaOVG")) then
					'19 Financiamento Estudantil
					strLinha1 = strLinha1 & TRIM(rsaux("Financiamento_Estud_VC19")) & "|" 
					'20 Financiamento Estudantil Reembolsável - FIES
					strLinha1 = strLinha1 & TRIM(rsaux("Finan_Estud_Fies_VC20")) & "|" 
					'21 Financiamento Estudantil Reembolsável - Governo Estadual
					strLinha1 = strLinha1 & TRIM(rsaux("Finan_Estud_GovEstadual_VC21")) & "|" 
					'22 Financiamento Estudantil Reembolsável - Governo Municipal
					strLinha1 = strLinha1 & TRIM(rsaux("Finan_Estud_GovMunicipall_VC22")) & "|" 
					'23 Financiamento Estudantil Reembolsável - IES
					strLinha1 = strLinha1 & TRIM(rsaux("Finan_Estud_ReembolsavelIES_VC23")) & "|" 
					'24 Financiamento Estudantil Reembolsável - Entidades externas
					strLinha1 = strLinha1 & TRIM(rsaux("Finan_Estud_ReembolsavelEntidades_VC24")) & "|" 
					'25 Financiamento Estudantil Reembolsável - Outros
					strLinha1 = strLinha1 & TRIM(rsaux("Finan_Estud_ReembolsavelOutros_VC25")) & "|" 
					'26 Tipo de financiamento não reembolsável- ProUni integral
					strLinha1 = strLinha1 & TRIM(rsaux("Tipo_finan_ProUniIntegral_VC26")) & "|" 
					'27 Tipo de financiamento não reembolsável - ProUni parcial
					strLinha1 = strLinha1 & TRIM(rsaux("Tipo_finan_ProUniParcial_VC27")) & "|" 
					'28 Tipo de financiamento não reembolsável - Entidades externas
					strLinha1 = strLinha1 & TRIM(rsaux("Tipo_finan_EntidadesExternas_VC28")) & "|" 
				else
					'19 Financiamento Estudantil
				    strLinha1 = strLinha1 & "1" & "|"
					'20 Financiamento Estudantil Reembolsável - FIES
					strLinha1 = strLinha1 & "0" & "|" 
					'21 Financiamento Estudantil Reembolsável - Governo Estadual
					strLinha1 = strLinha1 & "0" & "|" 
					'22 Financiamento Estudantil Reembolsável - Governo Municipal
					strLinha1 = strLinha1 & "0" & "|" 
					'23 Financiamento Estudantil Reembolsável - IES
					strLinha1 = strLinha1 & "0" & "|" 
					'24 Financiamento Estudantil Reembolsável - Entidades externas
					strLinha1 = strLinha1 & "0" & "|" 
					'25 Financiamento Estudantil Reembolsável - Outros
					strLinha1 = strLinha1 & "0" & "|" 
					'26 Tipo de financiamento não reembolsável- ProUni integral
					strLinha1 = strLinha1 & "0" & "|" 
					'27 Tipo de financiamento não reembolsável - ProUni parcial
					strLinha1 = strLinha1 & "0" & "|" 
					'28 Tipo de financiamento não reembolsável - Entidades externas
					strLinha1 = strLinha1 & "0" & "|" 
				end if	 	
				
			    if isnull(rsaux("BolsaOVG")) then
					'29 Tipo de financiamento não reembolsável - Governo estadual
					strLinha1 = strLinha1 & TRIM(rsaux("Tipo_finan_NaoReembolsaveGovEstadual_VC29")) & "|" 
					'30 Tipo de financiamento não reembolsável - IES
					strLinha1 = strLinha1 & TRIM(rsaux("Tipo_finan_NaoReembolsavelIES_VC30")) & "|" 
					'31 Tipo de financiamento não reembolsável - Governo municipal
					strLinha1 = strLinha1 & TRIM(rsaux("Tipo_finan_NaoReembolsavelGovMunicipal_VC31")) & "|" 
					'32 Tipo de financiamento não reembolsável - Outros
					strLinha1 = strLinha1 & TRIM(rsaux("Tipo_finan_NaoReembolsaveOutrosl_VC32")) & "|" 
				else	
					'29 Tipo de financiamento não reembolsável - Governo estadual
					strLinha1 = strLinha1 & "1" &  "|" 
					'30 Tipo de financiamento não reembolsável - IES
					strLinha1 = strLinha1 & "0" &  "|" 
					'31 Tipo de financiamento não reembolsável - Governo municipal
					strLinha1 = strLinha1 & "0" &  "|" 
					'32 Tipo de financiamento não reembolsável - Outros
					strLinha1 = strLinha1 & "0" &  "|" 
				end if	
				'33 Apoio Social
				strLinha1 = strLinha1 & TRIM(rsaux("Apoio_Social_VC33")) & "|" 
				'34 Tipo de apoio social - Alimentação
				strLinha1 = strLinha1 & TRIM(rsaux("Tipo_Apoio_Social_Alimentacao_VC34")) & "|" 
				'35 Tipo de apoio social - Moradia
				strLinha1 = strLinha1 & TRIM(rsaux("Tipo_Apoio_Social_Moradia_VC35")) & "|" 
				'36 Tipo de apoio social - Transporte
				strLinha1 = strLinha1 & TRIM(rsaux("Tipo_Apoio_Social_Transporte_VC36")) & "|" 
				'37 Tipo de apoio social- Material didático
				strLinha1 = strLinha1 & TRIM(rsaux("Tipo_Apoio_Social_MaterialDidatico_VC37")) & "|" 
				'38 Tipo de apoio social - Bolsa trabalho
				strLinha1 = strLinha1 & TRIM(rsaux("Tipo_Apoio_Social_BolsaTrabalho_VC38")) & "|" 
				'39 Tipo de apoio social - Bolsa permanência
				strLinha1 = strLinha1 & TRIM(rsaux("Tipo_Apoio_Social_BolsaPermanencia_VC39")) & "|" 
				'40 Atividade de formação complementar
				strLinha1 = strLinha1 & TRIM(rsaux("Ativ_FormacaoComplementar_VC40")) & "|" 
				'41 Atividade de formação complementar - Pesquisa
				strLinha1 = strLinha1 & TRIM(rsaux("Ativ_FormacaoComplementar_Pesquisa_VC41")) & "|" 
				'42 Bolsa/remuneração referente à atividade de formação complementar - Pesquisa
				strLinha1 = strLinha1 & TRIM(rsaux("BR_FormacaoComplementar_Pesquisa_VC42")) & "|" 
				'43 Atividade de formação complementar - Extensão
				strLinha1 = strLinha1 & TRIM(rsaux("Ativ_FormacaoComplementar_Extensao_VC43")) & "|" 
				'44 Bolsa/remuneração referente à atividade de formação complementar - Extensão
				strLinha1 = strLinha1 & TRIM(rsaux("BR_FormacaoComplementar_Extensao_VC44")) & "|" 
				'45 Atividade de formação complementar - Monitoria
				strLinha1 = strLinha1 & TRIM(rsaux("Ativ_FormacaoComplementar_Monitoria_VC45")) & "|" 
				'46 Bolsa/remuneração referente à atividade de formação complementar - Monitoria
				strLinha1 = strLinha1 & TRIM(rsaux("BR_FormacaoComplementar_Monitoria_VC46")) & "|" 
				'47 Atividade de formação complementar - Estágio não obrigatório
				strLinha1 = strLinha1 & TRIM(rsaux("Ativ_FormacaoComplementar_Estagio_VC47")) & "|" 
				'48 Bolsa/remuneração referente à atividade de formação complementar - Estágio não obrigatório
				strLinha1 = strLinha1 & TRIM(rsaux("BR_FormacaoComplementar_Estagio_VC48")) 
				
				if erroMunicipio <> "erro" then
					outfile.WriteLine(strLinha1)
				end if	
				
			end if
			rsaux.close
			'
			rs.movenext
            '
		wend	
	end if
	rs.close
	
	'Response.Charset="iso-8859-1"

%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
  <table width="100%" height="300" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td align="center"><strong><font color="#000099" size="2" face="Arial, Helvetica, sans-serif">Clique 
				  com o bot&atilde;o direito do mouse no &iacute;cone abaixo<br /> 
			    e escolha a op&ccedil;&atilde;o 
				  &quot;salvar destino como...&quot; </font></strong> <br />
				  <br />
				  <a href="http://<%=strDominiolink%>/ArquivoSetransp/<%=Session("CodEmpresa")%>/<%=strNomeArquivo%>" target="_blank"><img src="../../images/salvar.gif"><br><strong><%=strNomeArquivo%></strong></a> </td>
			  </tr>
			  <tr>
				<td align="CENTER"><input type="button" name="cmdPrincipal"  value="Principal"  class="botao" <%=strDesabilitaPrincipal%> onClick="window.location='default.asp'"></td>
			  </tr>
			</table>
<br>
<script>
	aguarde.style.display="none";
</script>
<!--#include file="../rodape.asp"-->
</body>
</html>
