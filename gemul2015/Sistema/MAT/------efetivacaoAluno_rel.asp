<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/11/2020
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: ficha de matricula
-->
<html>
<head>
<title><%=session("Titulo")%> - Ficha de matricula</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<script>
	function gerarComprovante(intCodAluno){
		var caminho
		caminho = "efetivacaoAluno_rel.asp?btn=N&chkAluno=" + intCodAluno
		window.open(caminho ,"","toolbar=no,status=no,location=no,scrollbars=yes,menubar=no,resizable=no,width=750,height=500,top=0,lef=0");
	}
	
	function voltar(intCodAluno){
		window.location='../MAT/EfetivacaoAluno_con.asp';
	}
</script>

<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%

	vetCodAluno			=	split(Trim(Request("chkAluno")),",")
	btn			=	Trim(Request("btn"))
	
	'VERIFICAÇÃO DE BLOQUEIO
	%>
	<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
	<%	
	codEmpresa	 			= session("CodEmpresa")
	intCodModeloDocumento	= "0"
	
	sql = "select codigo from SCA_DOCUMENTO where cod_empresa = " & codEmpresa & " and titulo = 'FICHA DE MATRICULA'"
	rs.open sql, cnn
	if rs.eof = false then
		intCodModeloDocumento	= rs("codigo")
	end if
	rs.close

	strAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= session("strSemestre")	
	
	strDia					= day(date)
	strMes					= ucase(monthname(month(date)))
	strAno					= year(date)
	strCidade				= ucase(session("CidadeEmpresaWeb"))
	strSecretario			= ucase(session("NomeSecretariaEmpresaWeb"))
	strDiretor				= ucase(session("NomeDiretorEmpresaWeb"))
	strCabecalho			= "S"
	strCompatibilidade		= ""
	

	for r=0 to ubound(vetCodAluno)
		sql = "Select a.Codigo, a.NomeAluno, a.matricula, a.dataNascimento, a.CIDADENASCIMENTO, UF.SIGLA as UF, a.CIDADERESIDENCIA, UFR.SIGLA as UFR, a.DATACOLACAO, a.DATACERTIFICADO, A.EMAIL, 'Fone(s) - Residencial: '+isnull(A.FONERESIDENCIAL,'(00)0000-0000')+' - Celular: '+ isnull(A.FONECELULAR,'(00)0000-0000') as FONE, "
		sql = sql & " 	a.TITULOELEITOR, a.TITULOZONA, a.TITULOSECAO,	a.NACIONALIDADE, a.DATAMATRICULA, a.CPFALUNO, "
		sql = sql & " 	a.pai, a.mae, a.ANOCONCLUSAO, a.CPFALUNO, sa.Desc_SituacaoAluno as SITUACAOALUNO, fi.descricao as FORMAINGRESSO,"
		sql = sql & " 	ufRG.sigla, CONVERT(VARCHAR,A.IDENTIDADE) + '-' + RTRIM(CONVERT(VARCHAR,IdentidadeOrgao)) + '/' + ufRG.sigla AS IDENTIDADE, ec.Desc_EstadoCivil as ESTADOCIVIL , a.LOGRADOURO, a.NUMERO_ENDERECO, a.COMP_ENDERECO, a.BAIRROALUNO"
		sql = sql & " 	from sca_aluno a"
		sql = sql & " 	left join scf_uf uf on uf.codigo = a.ufnascimento"
		sql = sql & " 	left join scf_uf ufR on ufr.codigo = a.ufresidencia"
		sql = sql & " 	left join scf_uf ufRG on ufRG.codigo = a.IdentidadeUF "
		sql = sql & " 	left join sca_situacaoaluno sa on sa.Cod_SituacaoAluno = a.Cod_SituacaoAluno and sa.Cod_Empresa = a.Cod_Empresa"
		sql = sql & " 	left join sca_formaingresso fi on fi.codigo = a.COD_FORMAINGRESSO and fi.Cod_Empresa = a.Cod_Empresa"
		sql = sql & " 	left join sca_estadocivil ec on ec.Cod_EstadoCivil = a.Cod_EstadoCivil"
		sql = sql & " where a.cod_empresa = " & session("CodEmpresa")
		sql = sql & " and a.codigo in (" & vetCodAluno(r) & ")"
		rs.open sql, cnn
		if rs.eof = false then
			intCodSCAAluno		= Trim(rs("codigo"))
			
			strEndereco 			= ucase(Trim(rs("LOGRADOURO")))
			IF isnull(rs("LOGRADOURO")) then
				strEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strNumeroEndereco 		= Trim(rs("NUMERO_ENDERECO"))
			IF isnull(rs("NUMERO_ENDERECO")) then
				strNumeroEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strCompEndereco 		= Trim(rs("COMP_ENDERECO"))
			IF isnull(rs("COMP_ENDERECO")) then
				strCompEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strBairroEndereco 		= ucase(Trim(rs("BAIRROALUNO")))
			IF isnull(rs("BAIRROALUNO")) then
				strBairroEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= ucase(Trim(rs("Nomealuno")))
			strDataNascimento	= formatadataAP(Trim(rs("dataNascimento")))
			IF isnull(rs("dataNascimento")) then
				strDataNascimento		= "XX/XX/XXXX"
			end if
			strCidadeNascimento	= ucase(Trim(rs("CIDADENASCIMENTO")))
			IF isnull(rs("CIDADENASCIMENTO")) then
				strCidadeNascimento		= "XXXXXXXXXXXXXX"
			end if
			strUfNascimento		= ucase(Trim(rs("UF")))
			IF isnull(rs("uf")) then
				strUfNascimento		= "XX"
			end if

			strCidadeResidencia	= ucase(Trim(rs("CIDADERESIDENCIA")))
			IF isnull(rs("CIDADERESIDENCIA")) then
				strCidadeResidencia		= "XXXXXXXXXXXXXX"
			end if
			strUfResidencia		= ucase(Trim(rs("UFR")))
			IF isnull(rs("ufR")) then
				strUfResidencia		= "XX"
			end if

			strFone		= Trim(rs("FONE"))
			IF isnull(rs("FONE")) then
				strFone		= ""
			end if
			strEmail		= Trim(rs("EMAIL"))
			IF isnull(rs("EMAIL")) then
				strEmail		= ""
			end if

			strPai				= ucase(Trim(rs("PAI")))
			IF isnull(rs("pai")) or Trim(rs("PAI")) = "" then
				strPai		= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strMae				= ucase(Trim(rs("MAE")))
			IF isnull(rs("mae")) or Trim(rs("mae")) = "" then
				strMae		= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strIdentidade		= Trim(rs("IDENTIDADE"))
			IF isnull(rs("IDENTIDADE")) or Trim(rs("IDENTIDADE")) = "" then
				strIdentidade		= "XXXXXXXXXX"
			end if		
			strCpf				= Trim(rs("CPFALUNO"))
			IF isnull(rs("CPFALUNO")) or Trim(rs("CPFALUNO")) = "" then
				strCpf		= "XXXXXXXXXX"
			end if		
			strTitulo			= Trim(rs("TITULOELEITOR")) & " - " & Trim(rs("TITULOZONA")) & " - " & Trim(rs("TITULOSECAO"))
			IF isnull(rs("TITULOELEITOR")) or Trim(rs("TITULOELEITOR")) = "" then
				strTitulo		= "XXXXXXXXXX"
			end if		
			strEstadoCivil		= ucase(Trim(rs("ESTADOCIVIL")))
			IF isnull(rs("ESTADOCIVIL")) or Trim(rs("ESTADOCIVIL")) = "" then
				strEstadoCivil		= "XXXXXXXXXXXXXXXXX"
			end if		
			strSitAluno	= ucase(Trim(rs("SITUACAOALUNO")))
			IF isnull(rs("SITUACAOALUNO")) or Trim(rs("SITUACAOALUNO")) = "" then
				strSitAluno		= "XXXXXXXXXXXXXXXXXX"
			end if		
			strFormaIngresso	= ucase(Trim(rs("FORMAINGRESSO")))
			IF isnull(rs("FORMAINGRESSO")) or Trim(rs("FORMAINGRESSO")) = "" then
				strFormaIngresso		= "XXXXXXXXXXXXXXXXXXX"
			end if		
			strDataMatricula	= formatadataAP(Trim(rs("DATAMATRICULA")))
			IF isnull(rs("DATAMATRICULA")) or Trim(rs("DATAMATRICULA")) = "" then
				strDataMatricula		= "XX/XX/XXXXX"
			end if		
			strNacionalidade	= ucase(Trim(rs("NACIONALIDADE")))
			IF isnull(rs("NACIONALIDADE")) or Trim(rs("NACIONALIDADE")) = "" then
				strNacionalidade		= "XXXXXXXXXXXXXXXXXXXXXXXX"
			end if		
			strDataColacao		= formatadataAP(Trim(rs("DATACOLACAO")))
			IF isnull(rs("DATACOLACAO")) or Trim(rs("DATACOLACAO")) = "" then
				strDataColacao		= "XX/XX/XXXXX"
			end if		
			strDataCertificado	= formatadataAP(Trim(rs("DATACERTIFICADO")))
			IF isnull(rs("DATACERTIFICADO")) or Trim(rs("DATACERTIFICADO")) = "" then
				strDataCertificado		= "XX/XX/XXXXX"
			end if		
			strAnoConclusao		= Trim(rs("ANOCONCLUSAO"))
			IF isnull(rs("ANOCONCLUSAO")) or Trim(rs("ANOCONCLUSAO")) = "" then
				strAnoConclusao		= "XXXX"
			end if		
	
			strPeriodoAtual		= "XXXXXXXXXXXXXX"
			strCursoAtual		= "XXXXXXXXXXXXXX"
			strTurnoAtual		= "XXXXXXXXXXXXXX"
			strTurmaAluno		= "XXXXXXX"
			strAutorizacao		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			strDataReconhecimento = "XX/XX/XXXX"
			strDataAutorizacao	= "XX/XX/XXXX"
			strReconhecimento	= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			strCH_Exigida		= "XXX"
			
			sql = "Select p.descricao as periodo, c.descricao as curso, tur.desc_turno as turno, t.nomeTURMA as turma, "
			sql = sql & " c.habilitacao, c.reconhecimento, ISNULL(c.autorizacao,'XXXXXXXXXXXXXXX')AS autorizacao, c.dataReconhecimento, c.DataAutorizacao, c.CH_Exigida "
			sql = sql & " from sca_aluno a"
			sql = sql & " left join scf_uf uf on uf.codigo = a.ufnascimento"
			sql = sql & " left join SCA_TURMA t ON t.cod_turma = (SELECT TOP 1 COD_TURMA FROM SCA_ALUNO_TURMA WHERE COD_ALUNO = a.CODIGO AND t.AnoLetivo = " & strAnoLetivo & " and SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ") ORDER BY CODIGO DESC) "
			sql = sql & " left join sca_turno tur on tur.cod_empresa = t.cod_empresa and tur.Cod_turno = t.Cod_turno"
			sql = sql & " left join sca_GradeCurricular g on g.cod_empresa = t.cod_empresa and g.Cod_GradeCurricular = t.Cod_GradeCurricular"
			sql = sql & " left join sca_periodo p on p.cod_empresa = g.cod_empresa and p.Cod_periodo = g.Cod_periodo"
			sql = sql & " left join sca_curso c on c.cod_empresa = p.cod_empresa and c.cod_curso = p.cod_curso"
			sql = sql & " where t.anoLetivo = " & strAnoLetivo
			sql = sql & " and a.cod_empresa = " & session("CodEmpresa")
			sql = sql & " and a.codigo = " & intCodSCAAluno
			rsaux.open sql, cnn
			if rsaux.eof = false then
				strPeriodoAtual		= ucase(Trim(rsaux("periodo")))
				strCursoAtual		= ucase(Trim(rsaux("curso")))
				strTurnoAtual		= ucase(Trim(rsaux("turno")))
				strTurmaAluno		= ucase(Trim(rsaux("turma")))
				strAutorizacao		= ucase(Trim(rsaux("autorizacao")))
				IF isnull(rsaux("autorizacao")) or Trim(rsaux("autorizacao")) = "" then
					strAutorizacao		= "XXXXXX"
				end if
				strCH_Exigida		= Trim(rsaux("CH_Exigida"))
				strDataReconhecimento = Trim(rsaux("dataReconhecimento"))
				strDataAutorizacao	= Trim(rsaux("DataAutorizacao"))
				strReconhecimento	= Trim(rsaux("reconhecimento"))	
				IF isnull(rsaux("reconhecimento")) or Trim(rsaux("reconhecimento")) = "" then
					strReconhecimento		= "XXXXXX"
				end if
			else
				%>
				<script>
					alert("ATENÇÃO: Verifique o período Letivo da Alocação.");
					window.location = 'Rel_Documentos_rel.asp';
				</script>
				<%
				response.End()			
			end if
			rsaux.close
		end if
		rs.close

		if TRIM(strDataReconhecimento)="" then strDataReconhecimento = "XX/XX/XXXX"
		
		strTodosOsCampos = ""
		sql = "SELECT codigo, titulo, documento, campos, posicaoFinanceira, situacaoAluno"
		sql = sql & " FROM SCA_DOCUMENTO"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " and codigo = " & intCodModeloDocumento
		sql = sql & " Order by titulo"
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strChecarPosicaoFinanceira = trim(rs("posicaoFinanceira"))
			strSituacaoAluno = trim(rs("situacaoAluno"))
			strTodosOsCampos = trim(rs("campos"))
	
			strTodosOsCampos = trim(rs("campos"))
			strTituloRelatorio = trim(rs("titulo"))
			
			if strCompatibilidade = "S" then
				strTextoDocumento = REPLACE(REPLACE(rs("documento"),"&lt;","<"),"&gt;",">")
			else
				strTextoDocumento = REPLACE(REPLACE(rs("documento"),"[","<"),"]",">")
			end if
			strTextoDocumento = REPLACE(strTextoDocumento,"=NOMEALUNO","=XX_NOMEALUNO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=MATRICULA","=XX_MATRICULA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATANASCIMENTO","=XX_DATANASCIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=CIDADENASCIMENTO","=XX_CIDADENASCIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=UFNASCIMENTO","=XX_UFNASCIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=CIDADERESIDENCIA","=XX_CIDADERESIDENCIA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=UFRESIDENCIA","=XX_UFRESIDENCIA" & intCodSCAAluno)

			strTextoDocumento = REPLACE(strTextoDocumento,"=FONE","=XX_FONE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=EMAIL","=XX_EMAIL" & intCodSCAAluno)

			strTextoDocumento = REPLACE(strTextoDocumento,"=IDENTIDADE","=XX_IDENTIDADE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=CPF","=XX_CPF" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=TITULO","=XX_TITULO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=PAI","=XX_PAI" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=MAE","=XX_MAE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=CURSOATUAL","=XX_CURSOATUAL" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=PERIODOATUAL","=XX_PERIODOATUAL" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=TURNOATUAL","=XX_TURNOATUAL" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=TURMAALUNO","=XX_TURMAALUNO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=SITUACAOALUNO","=XX_SITUACAOALUNO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=FORMAINGRESSO","=XX_FORMAINGRESSO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=CIDADE","=XX_CIDADE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DIA","=XX_DIA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=MES","=XX_MES" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=SECRETARIO","=XX_SECRETARIO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DIRETOR","=XX_DIRETOR" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATAMATRICULA","=XX_DATAMATRICULA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=NACIONALIDADE","=XX_NACIONALIDADE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=ESTADOCIVIL","=XX_ESTADOCIVIL" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATACERTIFICADO","=XX_DATACERTIFICADO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATACOLACAO","=XX_DATACOLACAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATARECONHECIMENTO","=XX_DATARECONHECIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=RECONHECIMENTO","=XX_RECONHECIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATAAUTORIZACAO","=XX_DATAAUTORIZACAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=AUTORIZACAO","=XX_AUTORIZACAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=ANOCONCLUSAO","=XX_ANOCONCLUSAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=CH_EXIGIDA","=XX_CH_EXIGIDA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=ANOCONCLUSAO","=XX_ANOCONCLUSAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=SEMESTRE","=XX_SEMESTRE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=ANOLETIVO","=XX_ANOLETIVO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=ANO","=XX_ANO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=LOGRADOURO","=XX_LOGRADOURO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=NUMERO_ENDERECO","=XX_NUMERO_ENDERECO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=COMP_ENDERECO","=XX_COMP_ENDERECO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"=BAIRROALUNO","=XX_BAIRROALUNO" & intCodSCAAluno)
			
		END IF
		rs.close
		
		if trim(strChecarPosicaoFinanceira) = "S" then
			'REGRA PARA VERIFICAR DEBITO DO ALUNO
			sql = "select cod_aluno from SCF_DEBITOALUNO"
			sql = sql & " where	cod_situacao_pagamento = 1"
			sql = sql & " and cod_aluno = " & intCodSCAAluno
			sql = sql & " AND COD_EMPRESA = " & Session("CodEmpresa")
			rs.open sql, cnn
			if not RS.EOF then
				rs.close	
				%>
				<script>
					alert("ATENÇÃO: Documento não pode ser gerado, existe débito para esse aluno, procure tesouraria.");
					window.location = 'Rel_Documentos_rel.asp';
				</script>
				<%
				response.End()			
			else
				rs.close	
			end if	
		end if
		if trim(strSituacaoAluno) <> "" and not isnull(strSituacaoAluno) then
			'REGRA PARA VERIFICAR SITUACAO DO ALUNO
			sql = "select codigo from SCA_ALUNO"
			sql = sql & " where	cod_situacaoaluno in (" & strSituacaoAluno & ")"
			sql = sql & " and codigo = " & intCodSCAAluno
			sql = sql & " AND COD_EMPRESA = " & Session("CodEmpresa")
			rs.open sql, cnn
			if not RS.EOF then
				rs.close	
				%>
				<script>
					alert("ATENÇÃO: Documento não pode ser gerando, aluno com situação cadastral irregular para geração desse documento, procure secretaria.");
					window.location = 'Rel_Documentos_rel.asp';
				</script>
				<%
				response.End()			
			else
				rs.close	
			end if	
		end if
		
		IF r>0 then
			response.Write("<pre>&nbsp;</pre>")
		end if
		' So imprime o cabeçalho se a opcao for SIM
		if strCabecalho = "S" then
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorioSemAnoSemestre.asp"-->
		<br>
		<br>
		<%end if%>
		<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="texto2" align="justify"><%=strTextoDocumento%></td>
		  </tr>
		</table>	
		<%
		if strTodosOsCampos <> "" then
		%>
			<script>
				function mostraDocumento<%=intCodSCAAluno%>(){
			<%
			vetCampos = split(strTodosOsCampos,",")
			for i=0 to ubound(vetCampos)
				if trim(vetCampos(i)) = "NOMEALUNO" then 
					vet1 = split(strTextoDocumento,"<a id=XX_NOMEALUNO" & intCodSCAAluno & "></a>")
					if ubound(vet1)>1 then
						for j=0 to ubound(vet1)-1
							%>
							XX_NOMEALUNO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strNomeAluno%>'
							<%
						next
					else
						%>
						XX_NOMEALUNO<%=intCodSCAAluno%>.innerHTML = '<%=strNomeAluno%>'
						<%
					end if				
				end if
				if trim(vetCampos(i)) = "MATRICULA" then 
					vet2 = split(strTextoDocumento,"<a id=XX_MATRICULA" & intCodSCAAluno & "></a>")
					if ubound(vet2)>1 then
						for j=0 to ubound(vet2)-1
							%>
							XX_MATRICULA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strMatricula%>'
							<%
						next
					else
						%>
						XX_MATRICULA<%=intCodSCAAluno%>.innerHTML = '<%=strMatricula%>'
						<%
					end if				
				end if
				if trim(vetCampos(i)) = "DATANASCIMENTO" then 
					vet3 = split(strTextoDocumento,"<a id=XX_DATANASCIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet3)>1 then
						for j=0 to ubound(vet3)-1
							%>
							XX_DATANASCIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataNascimento%>'
							<%
						next
					else
						%>
						XX_DATANASCIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strDataNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CIDADENASCIMENTO" then 
					vet4 = split(strTextoDocumento,"<a id=XX_CIDADENASCIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet4)>1 then
						for j=0 to ubound(vet4)-1
							%>
							XX_CIDADENASCIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCidadeNascimento%>'
							<%
						next
					else
						%>
						XX_CIDADENASCIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strCidadeNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "UFNASCIMENTO" then 
					vet4 = split(strTextoDocumento,"<a id=XX_UFNASCIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet4)>1 then
						for j=0 to ubound(vet4)-1
							%>
							XX_UFNASCIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strUfNascimento%>'
							<%
						next
					else
						%>
						XX_UFNASCIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strUfNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CIDADERESIDENCIA" then 
					vet4 = split(strTextoDocumento,"<a id=CIDADERESIDENCIA" & intCodSCAAluno & "></a>")
					if ubound(vet4)>1 then
						for j=0 to ubound(vet4)-1
							%>
							XX_CIDADERESIDENCIA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCidadeResidencia%>'
							<%
						next
					else
						%>
						XX_CIDADERESIDENCIA<%=intCodSCAAluno%>.innerHTML = '<%=strCidadeResidencia%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "UFRESIDENCIA" then 
					vet5 = split(strTextoDocumento,"<a id=XX_UFRESIDENCIA" & intCodSCAAluno & "></a>")
					if ubound(vet5)>1 then
						for j=0 to ubound(vet5)-1
							%>
							XX_UFRESIDENCIA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strUfResidencia%>'
							<%
						next
					else
						%>
						XX_UFRESIDENCIA<%=intCodSCAAluno%>.innerHTML = '<%=strUfResidencia%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "FONE" then 
					vet5 = split(strTextoDocumento,"<a id=XX_FONE" & intCodSCAAluno & "></a>")
					if ubound(vet5)>1 then
						for j=0 to ubound(vet5)-1
							%>
							XX_FONE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strFone%>'
							<%
						next
					else
						%>
						XX_FONE<%=intCodSCAAluno%>.innerHTML = '<%=strFone%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "EMAIL" then 
					vet5 = split(strTextoDocumento,"<a id=XX_EMAIL" & intCodSCAAluno & "></a>")
					if ubound(vet5)>1 then
						for j=0 to ubound(vet5)-1
							%>
							XX_EMAIL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strEmail%>'
							<%
						next
					else
						%>
						XX_EMAIL<%=intCodSCAAluno%>.innerHTML = '<%=strEmail%>'
						<%
					end if
				end if

				if trim(vetCampos(i)) = "ANOLETIVO" then 
					vet6 = split(strTextoDocumento,"<a id=XX_ANOLETIVO" & intCodSCAAluno & "></a>")
					if ubound(vet6)>1 then
						for j=0 to ubound(vet6)-1
							%>
							XX_ANOLETIVO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strAnoLetivo%>'
							<%
						next
					else
						%>
						XX_ANOLETIVO<%=intCodSCAAluno%>.innerHTML = '<%=strAnoLetivo%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "PAI" then 
					vet7 = split(strTextoDocumento,"<a id=XX_PAI" & intCodSCAAluno & "></a>")
					if ubound(vet7)>1 then
						for j=0 to ubound(vet7)-1
							%>
							XX_PAI<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strPai%>'
							<%
						next
					else
						%>
						XX_PAI<%=intCodSCAAluno%>.innerHTML = '<%=strPai%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "MAE" then 
					vet8 = split(strTextoDocumento,"<a id=XX_MAE" & intCodSCAAluno & "></a>")
					if ubound(vet8)>1 then
						for j=0 to ubound(vet8)-1
							%>
							XX_MAE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strMae%>'
							<%
						next
					else
						%>
						XX_MAE<%=intCodSCAAluno%>.innerHTML = '<%=strMae%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "PERIODOATUAL" then 
					vet9 = split(strTextoDocumento,"<a id=XX_PERIODOATUAL" & intCodSCAAluno & "></a>")
					if ubound(vet9)>1 then
						for j=0 to ubound(vet9)-1
							%>
							XX_PERIODOATUAL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strPeriodoAtual%>'
							<%
						next
					else
						%>
						XX_PERIODOATUAL<%=intCodSCAAluno%>.innerHTML = '<%=strPeriodoAtual%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CURSOATUAL" then 
					vet10 = split(strTextoDocumento,"<a id=XX_CURSOATUAL" & intCodSCAAluno & "></a>")
					if ubound(vet10)>1 then
						for j=0 to ubound(vet10)-1
							%>
							XX_CURSOATUAL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCursoAtual%>'
							<%
						next
					else
						%>
						XX_CURSOATUAL<%=intCodSCAAluno%>.innerHTML = '<%=strCursoAtual%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "TURNOATUAL" then 
					vet11 = split(strTextoDocumento,"<a id=XX_TURNOATUAL" & intCodSCAAluno & "></a>")
					if ubound(vet11)>1 then
						for j=0 to ubound(vet11)-1
							%>
							XX_TURNOATUAL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strTurnoAtual%>'
							<%
						next
					else
						%>
						XX_TURNOATUAL<%=intCodSCAAluno%>.innerHTML = '<%=strTurnoAtual%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CIDADE" then 
	
					vet12 = split(strTextoDocumento,"<a id=XX_CIDADE" & intCodSCAAluno & "></a>")
					if ubound(vet12)>1 then
						for j=0 to ubound(vet12)-1
							%>
							XX_CIDADE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCidade%>'
							<%
						next
					else
						%>
						XX_CIDADE<%=intCodSCAAluno%>.innerHTML = '<%=strCidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DIA" then 
					
					vet13 = split(strTextoDocumento,"<a id=XX_DIA" & intCodSCAAluno & "></a>")
					if ubound(vet13)>1 then
						for j=0 to ubound(vet13)-1
							%>
							XX_DIA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDia%>'
							<%
						next
					else
						%>
						XX_DIA<%=intCodSCAAluno%>.innerHTML = '<%=strDia%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "MES" then 
					vet14 = split(strTextoDocumento,"<a id=XX_MES" & intCodSCAAluno & "></a>")
					if ubound(vet14)>1 then
						for j=0 to ubound(vet14)-1
							%>
							XX_MES<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strMes%>'
							<%
						next
					else
						%>
						XX_MES<%=intCodSCAAluno%>.innerHTML = '<%=strMes%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ANO" then 
					vet15 = split(strTextoDocumento,"<a id=XX_ANO" & intCodSCAAluno & "></a>")
					if ubound(vet15)>1 then
						for j=0 to ubound(vet15)-1
							%>
							XX_ANO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strAno%>'
							<%
						next
					else
						%>
						XX_ANO<%=intCodSCAAluno%>.innerHTML = '<%=strAno%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SECRETARIO" then 
					vet16 = split(strTextoDocumento,"<a id=XX_SECRETARIO" & intCodSCAAluno & "></a>")
					if ubound(vet16)>1 then
						for j=0 to ubound(vet16)-1
							%>
							XX_SECRETARI<%=intCodSCAAluno%>O[<%=j%>].innerHTML = '<%=strSecretario%>'
							<%
						next
					else
						%>
						XX_SECRETARIO<%=intCodSCAAluno%>.innerHTML = '<%=strSecretario%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DIRETOR" then 
					vet17 = split(strTextoDocumento,"<a id=XX_DIRETOR" & intCodSCAAluno & "></a>")
					if ubound(vet17)>1 then
						for j=0 to ubound(vet17)-1
							%>
							XX_DIRETOR<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDiretor%>'
							<%
						next
					else
						%>
						XX_DIRETOR<%=intCodSCAAluno%>.innerHTML = '<%=strDiretor%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "IDENTIDADE" then 
					vet18 = split(strTextoDocumento,"<a id=XX_IDENTIDADE" & intCodSCAAluno & "></a>")
					if ubound(vet18)>1 then
						for j=0 to ubound(vet18)-1
							%>
							XX_IDENTIDADE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strIdentidade%>'
							<%
						next
					else
						%>
						XX_IDENTIDADE<%=intCodSCAAluno%>.innerHTML = '<%=strIdentidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CPF" then 
					vet19 = split(strTextoDocumento,"<a id=XX_CPF" & intCodSCAAluno & "></a>")
					if ubound(vet19)>1 then
						for j=0 to ubound(vet19)-1
							%>
							XX_CPF<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCpf%>'
							<%
						next
					else
						%>
						XX_CPF<%=intCodSCAAluno%>.innerHTML = '<%=strCpf%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "TITULO" then 
					vet20 = split(strTextoDocumento,"<a id=XX_TITULO" & intCodSCAAluno & "></a>")
					if ubound(vet20)>1 then
						for j=0 to ubound(vet20)-1
							%>
							XX_TITULO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strTitulo%>'
							<%
						next
					else
						%>
						XX_TITULO<%=intCodSCAAluno%>.innerHTML = '<%=strTitulo%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ESTADOCIVIL" then 
					vet21 = split(strTextoDocumento,"<a id=XX_ESTADOCIVIL" & intCodSCAAluno & "></a>")
					if ubound(vet21)>1 then
						for j=0 to ubound(vet21)-1
							%>
							XX_ESTADOCIVIL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strEstadoCivil%>'
							<%
						next
					else
						%>
						XX_ESTADOCIVIL<%=intCodSCAAluno%>.innerHTML = '<%=strEstadoCivil%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "TURMAALUNO" then 
					vet22 = split(strTextoDocumento,"<a id=XX_TURMAALUNO" & intCodSCAAluno & "></a>")
					if ubound(vet22)>1 then
						for j=0 to ubound(vet22)-1
							%>
							XX_TURMAALUNO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strTurmaAluno%>'
							<%
						next
					else
						%>
						XX_TURMAALUNO<%=intCodSCAAluno%>.innerHTML = '<%=strTurmaAluno%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SITUACAOALUNO" then 
					vet23 = split(strTextoDocumento,"<a id=XX_SITUACAOALUNO" & intCodSCAAluno & "></a>")
					if ubound(vet23)>1 then
						for j=0 to ubound(vet23)-1
							%>
							XX_SITUACAOALUNO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strSitAluno%>'
							<%
						next
					else
						%>
						XX_SITUACAOALUNO<%=intCodSCAAluno%>.innerHTML = '<%=strSitAluno%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "FORMAINGRESSO" then 
					vet24 = split(strTextoDocumento,"<a id=XX_FORMAINGRESSO" & intCodSCAAluno & "></a>")
					if ubound(vet24)>1 then
						for j=0 to ubound(vet24)-1
							%>
							XX_FORMAINGRESSO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strFormaIngresso%>'
							<%
						next
					else
						%>
						XX_FORMAINGRESSO<%=intCodSCAAluno%>.innerHTML = '<%=strFormaIngresso%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATAMATRICULA" then 
					vet25 = split(strTextoDocumento,"<a id=XX_DATAMATRICULA" & intCodSCAAluno & "></a>")
					if ubound(vet25)>1 then
						for j=0 to ubound(vet25)-1
							%>
							XX_DATAMATRICULA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataMatricula%>'
							<%
						next
					else
						%>
						XX_DATAMATRICULA<%=intCodSCAAluno%>.innerHTML = '<%=strDataMatricula%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "NACIONALIDADE" then 
					vet26 = split(strTextoDocumento,"<a id=XX_NACIONALIDADE" & intCodSCAAluno & "></a>")
					if ubound(vet26)>1 then
						for j=0 to ubound(vet26)-1
							%>
							XX_NACIONALIDADE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strNacionalidade%>'
							<%
						next
					else
						%>
						XX_NACIONALIDADE<%=intCodSCAAluno%>.innerHTML = '<%=strNacionalidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATACOLACAO" then 
					vet27 = split(strTextoDocumento,"<a id=XX_DATACOLACAO" & intCodSCAAluno & "></a>")
					if ubound(vet27)>1 then
						for j=0 to ubound(vet27)-1
							%>
							XX_DATACOLACAO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataColacao%>'
							<%
						next
					else
						%>
						XX_DATACOLACAO<%=intCodSCAAluno%>.innerHTML = '<%=strDataColacao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATACERTIFICADO" then 
					vet28 = split(strTextoDocumento,"<a id=XX_DATACERTIFICADO" & intCodSCAAluno & "></a>")
					if ubound(vet28)>1 then
						for j=0 to ubound(vet28)-1
							%>
							XX_DATACERTIFICADO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataCertificado%>'
							<%
						next
					else
						%>
						XX_DATACERTIFICADO<%=intCodSCAAluno%>.innerHTML = '<%=strDataCertificado%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ANOCONCLUSAO" then 
					vet29 = split(strTextoDocumento,"<a id=XX_ANOCONCLUSAO" & intCodSCAAluno & "></a>")
					if ubound(vet29)>1 then
						for j=0 to ubound(vet29)-1
							%>
							XX_ANOCONCLUSAO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strAnoConclusao%>'
							<%
						next
					else
						%>
						XX_ANOCONCLUSAO<%=intCodSCAAluno%>.innerHTML = '<%=strAnoConclusao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SEMESTRE" then 
					vet33 = split(strTextoDocumento,"<a id=XX_SEMESTRE" & intCodSCAAluno & "></a>")
					if ubound(vet33)>1 then
						for j=0 to ubound(vet33)-1
							%>
							XX_SEMESTRE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=intSemestre%>'
							<%
						next
					else
						%>
						XX_SEMESTRE<%=intCodSCAAluno%>.innerHTML = '<%=intSemestre%>'
						<%
					end if
				end if			
				if trim(vetCampos(i)) = "AUTORIZACAO" then 
					vet30 = split(strTextoDocumento,"<a id=XX_AUTORIZACAO" & intCodSCAAluno & "></a>")
					if ubound(vet30)>1 then
						for j=0 to ubound(vet30)-1
							%>
							XX_AUTORIZACAO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strAutorizacao%>'
							<%
						next
					else
						%>
						XX_AUTORIZACAO<%=intCodSCAAluno%>.innerHTML = '<%=strAutorizacao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATAAUTORIZACAO" then 
					vet31 = split(strTextoDocumento,"<a id=XX_DATAAUTORIZACAO" & intCodSCAAluno & "></a>")
					if ubound(vet31)>1 then
						for j=0 to ubound(vet31)-1
							%>
							XX_DATAAUTORIZACAO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataAutorizacao%>'
							<%
						next
					else
						%>
						XX_DATAAUTORIZACAO<%=intCodSCAAluno%>.innerHTML = '<%=strDataAutorizacao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATARECONHECIMENTO" then 
					vet32 = split(strTextoDocumento,"<a id=XX_DATARECONHECIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet32)>1 then
						for j=0 to ubound(vet32)-1
							%>
							XX_DATARECONHECIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataReconhecimento%>'
							<%
						next
					else
						%>
						XX_DATARECONHECIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strDataReconhecimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "RECONHECIMENTO" then 
					vet24 = split(strTextoDocumento,"<a id=XX_RECONHECIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet24)>1 then
						for j=0 to ubound(vet24)-1
							%>
							XX_RECONHECIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strReconhecimento%>'
							<%
						next
					else
						%>
						XX_RECONHECIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strReconhecimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CH_EXIGIDA" then 
					vet25 = split(strTextoDocumento,"<a id=XX_CH_EXIGIDA" & intCodSCAAluno & "></a>")
					if ubound(vet25)>1 then
						for j=0 to ubound(vet25)-1
							%>
							XX_CH_EXIGIDA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCH_Exigida%>'
							<%
						next
					else
						%>
						XX_CH_EXIGIDA<%=intCodSCAAluno%>.innerHTML = '<%=strCH_Exigida%>'
						<%
					end if
				end if
				
				if trim(vetCampos(i)) = "LOGRADOURO" then 
					vet33 = split(strTextoDocumento,"<a id=XX_LOGRADOURO" & intCodSCAAluno & "></a>")
					if ubound(vet33)>1 then
						for j=0 to ubound(vet33)-1
							%>
							XX_LOGRADOURO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strEndereco%>'
							<%
						next
					else
						%>
						XX_LOGRADOURO<%=intCodSCAAluno%>.innerHTML = '<%=strEndereco%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "NUMERO_ENDERECO" then 
					vet34 = split(strTextoDocumento,"<a id=XX_NUMERO_ENDERECO" & intCodSCAAluno & "></a>")
					if ubound(vet34)>1 then
						for j=0 to ubound(vet34)-1
							%>
							XX_NUMERO_ENDERECO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strNumeroEndereco%>'
							<%
						next
					else
						%>
						XX_NUMERO_ENDERECO<%=intCodSCAAluno%>.innerHTML = '<%=strNumeroEndereco%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "COMP_ENDERECO" then 
					vet35 = split(strTextoDocumento,"<a id=XX_COMP_ENDERECO" & intCodSCAAluno & "></a>")
					if ubound(vet35)>1 then
						for j=0 to ubound(vet35)-1
							%>
							XX_COMP_ENDERECO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCompEndereco%>'
							<%
						next
					else
						%>
						XX_COMP_ENDERECO<%=intCodSCAAluno%>.innerHTML = '<%=strCompEndereco%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "BAIRROALUNO" then 
					vet36 = split(strTextoDocumento,"<a id=XX_COMP_ENDERECO" & intCodSCAAluno & "></a>")
					if ubound(vet36)>1 then
						for j=0 to ubound(vet36)-1
							%>
							XX_BAIRROALUNO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strBairroEndereco%>'
							<%
						next
					else
						%>
						XX_BAIRROALUNO<%=intCodSCAAluno%>.innerHTML = '<%=strBairroEndereco%>'
						<%
					end if
				end if

			next
			%>
				}	
			</script>
			<%
		end if
		
		%>	
		<script>
			mostraDocumento<%=intCodSCAAluno%>();
		</script>
		<%
			strChecarPosicaoFinanceira = ""
			strSitAluno 	= ""
			strTodosOsCampos 	= ""
			strTituloRelatorio 	= ""
			strTextoDocumento 	= ""
			strPeriodoAtual		= ""
			strCursoAtual		= ""
			strTurnoAtual		= ""
			strTurmaAluno		= ""
			strCH_Exigida		= ""
			strDataReconhecimento = ""
			strDataAutorizacao	= ""
			strReconhecimento	= ""
			intCodSCAAluno		= ""
			strMatricula 		= ""
			strNomealuno 		= ""
			strDataNascimento	= "XX/XX/XXXX"
			strCidadeNascimento	= "XXXXXXXXXXXXXX"
			strUfNascimento		= "XX"
			strCidadeResidencia	= "XXXXXXXXXXXXXX"
			strUfResidencia		= "XX"
			strPai				= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			strMae				= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			strIdentidade		= "XXXXXXXXXX"
			str					= "XXXXXXXXXX"
			strTitulo			= "XXXXXXXXXX"
			strEstadoCivil		= "XXXXXXXXXXXXXXXXX"
			strSitAluno	= "XXXXXXXXXXXXXXXXXX"
			strFormaIngresso	= "XXXXXXXXXXXXXXXXXXX"
			strDataMatricula	= "XX/XX/XXXXX"
			strNacionalidade	= "XXXXXXXXXXXXXXXXXXXXXXXX"
			strDataColacao		= "XX/XX/XXXXX"
			strDataCertificado	= "XX/XX/XXXXX"
			strAnoConclusao		= "XXXX"
			strPeriodoAtual		= "XXXXXXXXXXXXXX"
			strCursoAtual		= "XXXXXXXXXXXXXX"
			strTurnoAtual		= "XXXXXXXXXXXXXX"
			strTurmaAluno		= "XXXXXXX"
			strAutorizacao		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			strDataReconhecimento = "XX/XX/XXXX"
			strDataAutorizacao	= "XX/XX/XXXX"
			strReconhecimento	= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			strCH_Exigida		= "XXX"
			strEndereco			= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			strNumeroEndereco	= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			strCompEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			strBairroEndereco	= "XXXXXXXXXXXXXXXXXXXXXXXXXX"

	next
	%>
    <script>
        aguarde.style.display="none";
    </script>
	<%
	if btn = "" then
	%>
	<br>
	<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr >
			<td width="278" align="center"><a href="#"><img src="../../images/ImpressaoBoleto.jpg" width="206" height="49" border="0" onClick="gerarComprovante('<%=intCodAluno%>')"></a></td>
			<td width="276" align="center"><a href="#"><img src="../../images/voltar.jpg" width="206" height="49" border="0" onClick="voltar(<%=intCodAluno%>)" /></a></td>
		</tr>
	</table>
	<%
	end if
	%>
</body>
</html>
