<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Ordem Alfabtica</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%

	intCodAluno	 			= Trim(Request.form("txtCodAluno"))
	
	if intCodAluno = "" then
		vetCodAluno			=	split(Trim(Request.form("chkAluno")),",")
	else
		vetCodAluno			=	split(Trim(Request.form("txtCodAluno")),",")
	end if	
	
	'VERIFICAÇÃO DE BLOQUEIO
	%>
	<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
	<%			

	intCodModeloDocumento	= Trim(Request.form("cmbModeloDocumento"))
	
	codEmpresa	 			= session("CodEmpresa")
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
	
	strDia					= day(date)
	strMes					= monthname(month(date))
	strAno					= year(date)
	strCidade				= session("CidadeEmpresaWeb")
	strSecretario			= session("NomeSecretariaEmpresaWeb")
	strDiretor				= session("NomeDiretorEmpresaWeb")
	strCabecalho			= Trim(Request.form("cmbCabecalho"))

	for r=0 to ubound(vetCodAluno)
		sql = "Select a.Codigo, a.NomeAluno, a.matricula, a.dataNascimento, a.CIDADENASCIMENTO, UF.nome as UF, a.DATACOLACAO, a.DATACERTIFICADO, "
		sql = sql & " 	a.TITULOELEITOR, a.TITULOZONA, a.TITULOSECAO,	a.NACIONALIDADE, a.DATAMATRICULA, a.CPFALUNO, "
		sql = sql & " 	a.pai, a.mae, a.ANOCONCLUSAO, a.CPFALUNO, sa.Desc_SituacaoAluno as SITUACAOALUNO, fi.descricao as FORMAINGRESSO,"
		sql = sql & " 	a.IDENTIDADE, ec.Desc_EstadoCivil as ESTADOCIVIL "
		sql = sql & " 	from sca_aluno a"
		sql = sql & " 	left join scf_uf uf on uf.codigo = a.ufnascimento"
		sql = sql & " 	left join sca_situacaoaluno sa on sa.Cod_SituacaoAluno = a.Cod_SituacaoAluno and sa.Cod_Empresa = a.Cod_Empresa"
		sql = sql & " 	left join sca_formaingresso fi on fi.codigo = a.COD_FORMAINGRESSO and fi.Cod_Empresa = a.Cod_Empresa"
		sql = sql & " 	left join sca_estadocivil ec on ec.Cod_EstadoCivil = a.Cod_EstadoCivil"
		sql = sql & " where a.cod_empresa = " & session("CodEmpresa")
		sql = sql & " and a.codigo in (" & vetCodAluno(r) & ")"
		rs.open sql, cnn
		if rs.eof = false then
			intCodSCAAluno		= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			strDataNascimento	= formatadataAP(Trim(rs("dataNascimento")))
			IF isnull(rs("dataNascimento")) then
				strDataNascimento		= "XX/XX/XXXX"
			end if
			strCidadeNascimento	= Trim(rs("CIDADENASCIMENTO"))
			IF isnull(rs("CIDADENASCIMENTO")) then
				strCidadeNascimento		= "XXXXXXXXXXXXXX"
			end if
			strUfNascimento		= Trim(rs("UF"))
			IF isnull(rs("uf")) then
				strUfNascimento		= "XX"
			end if
			strPai				= Trim(rs("PAI"))
			IF isnull(rs("pai")) or Trim(rs("PAI")) = "" then
				strPai		= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strMae				= Trim(rs("MAE"))
			IF isnull(rs("mae")) or Trim(rs("mae")) = "" then
				strMae		= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strIdentidade		= Trim(rs("IDENTIDADE"))
			IF isnull(rs("IDENTIDADE")) or Trim(rs("IDENTIDADE")) = "" then
				strIdentidade		= "XXXXXXXXXX"
			end if		
			strCpf				= Trim(rs("CPFALUNO"))
			IF isnull(rs("CPFALUNO")) or Trim(rs("CPFALUNO")) = "" then
				str		= "XXXXXXXXXX"
			end if		
			strTitulo			= Trim(rs("TITULOELEITOR")) & " - " & Trim(rs("TITULOZONA")) & " - " & Trim(rs("TITULOSECAO"))
			IF isnull(rs("TITULOELEITOR")) or Trim(rs("TITULOELEITOR")) = "" then
				strTitulo		= "XXXXXXXXXX"
			end if		
			strEstadoCivil		= Trim(rs("ESTADOCIVIL"))
			IF isnull(rs("ESTADOCIVIL")) or Trim(rs("ESTADOCIVIL")) = "" then
				strEstadoCivil		= "XXXXXXXXXXXXXXXXX"
			end if		
			strSituacaoAluno	= Trim(rs("SITUACAOALUNO"))
			IF isnull(rs("SITUACAOALUNO")) or Trim(rs("SITUACAOALUNO")) = "" then
				strSituacaoAluno		= "XXXXXXXXXXXXXXXXXX"
			end if		
			strFormaIngresso	= Trim(rs("FORMAINGRESSO"))
			IF isnull(rs("FORMAINGRESSO")) or Trim(rs("FORMAINGRESSO")) = "" then
				strFormaIngresso		= "XXXXXXXXXXXXXXXXXXX"
			end if		
			strDataMatricula	= formatadataAP(Trim(rs("DATAMATRICULA")))
			IF isnull(rs("DATAMATRICULA")) or Trim(rs("DATAMATRICULA")) = "" then
				strDataMatricula		= "XX/XX/XXXXX"
			end if		
			strNacionalidade	= Trim(rs("NACIONALIDADE"))
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
			sql = sql & " c.habilitacao, c.reconhecimento, c.autorizacao, c.dataReconhecimento, c.DataAutorizacao, c.CH_Exigida "
			sql = sql & " from sca_aluno a"
			sql = sql & " left join scf_uf uf on uf.codigo = a.ufnascimento"
			sql = sql & " left join SCA_ALUNO_TURMA at on at.cod_empresa = a.cod_empresa and at.cod_aluno = a.codigo"
			sql = sql & " left join SCA_TURMA t on t.cod_empresa = at.cod_empresa and t.cod_turma = at.cod_turma"
			sql = sql & " left join sca_turno tur on tur.cod_empresa = t.cod_empresa and tur.Cod_turno = t.Cod_turno"
			sql = sql & " left join sca_GradeCurricular g on g.cod_empresa = t.cod_empresa and g.Cod_GradeCurricular = t.Cod_GradeCurricular"
			sql = sql & " left join sca_periodo p on p.cod_empresa = g.cod_empresa and p.Cod_periodo = g.Cod_periodo"
			sql = sql & " left join sca_curso c on c.cod_empresa = p.cod_empresa and c.cod_curso = p.cod_curso"
			sql = sql & " where t.anoLetivo = " & strAnoLetivo
			sql = sql & " and a.cod_empresa = " & session("CodEmpresa")
			sql = sql & " and a.codigo = " & intCodSCAAluno
			sql = sql & " and at.SITUACAO = 'A'"'ATIVA
			rsaux.open sql, cnn
			if rsaux.eof = false then
				strPeriodoAtual		= Trim(rsaux("periodo"))
				strCursoAtual		= Trim(rsaux("curso"))
				strTurnoAtual		= Trim(rsaux("turno"))
				strTurmaAluno		= Trim(rsaux("turma"))
				strAutorizacao		= Trim(rsaux("autorizacao"))
				strCH_Exigida		= Trim(rsaux("CH_Exigida"))
				strDataReconhecimento = Trim(rsaux("dataReconhecimento"))
				strDataAutorizacao	= Trim(rsaux("DataAutorizacao"))
				strReconhecimento	= Trim(rsaux("reconhecimento"))	
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
			strTextoDocumento = REPLACE(REPLACE(rs("documento"),"&lt;","<"),"&gt;",">")
			
			strTextoDocumento = REPLACE(strTextoDocumento,"NOMEALUNO","NOMEALUNO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"MATRICULA","MATRICULA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DATANASCIMENTO","DATANASCIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"CIDADENASCIMENTO","CIDA@@@@@CIMENTO")
			strTextoDocumento = REPLACE(strTextoDocumento,"UFNASCIMENTO","UFNASCIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"IDENTIDADE","IDENTIDADE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"CPF","CPF" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"TITULO","TITULO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"PAI","PAI" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"MAE","MAE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"CURSOATUAL","CURSOATUAL" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"PERIODOATUAL","PERIODOATUAL" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"TURNOATUAL","TURNOATUAL" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"TURMAALUNO","TURMAALUNO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"SITUACAOALUNO","SITUACAOALUNO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"FORMAINGRESSO","FORMAINGRESSO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"CIDADE","CIDADE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DIA","DIA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"MES","MES" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"SECRETARIO","SECRETARIO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DIRETOR","DIRETOR" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DATAMATRICULA","DATAMATRICULA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"NACIONALIDADE","NACIONALIDADE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"ESTADOCIVIL","ESTADOCIVIL" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DATACERTIFICADO","DATACERTIFICADO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DATACOLACAO","DATACOLACAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DATARECONHECIMENTO","DATARECO@@@CIMENTO")
			strTextoDocumento = REPLACE(strTextoDocumento,"RECONHECIMENTO","RECONHECIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DATAAUTORIZACAO","DATAAUTO@@@ACAO")
			strTextoDocumento = REPLACE(strTextoDocumento,"AUTORIZACAO","AUTORIZACAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"CH_EXIGIDA","CH_EXIGIDA" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"ANOCONCLUSAO","AN@@@NCLU@@@")
			strTextoDocumento = REPLACE(strTextoDocumento,"SEMESTRE","SEMESTRE" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"ANOLETIVO","AN@@@TIVO")
			strTextoDocumento = REPLACE(strTextoDocumento,"ANO","ANO" & intCodSCAAluno)
			
			strTextoDocumento = REPLACE(strTextoDocumento,"DATARECO@@@CIMENTO","DATARECONHECIMENTO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"DATAAUTO@@@ACAO","DATAAUTORIZACAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"AN@@@NCLU@@@","ANOCONCLUCAO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"AN@@@TIVO","ANOLETIVO" & intCodSCAAluno)
			strTextoDocumento = REPLACE(strTextoDocumento,"CIDA@@@@@CIMENTO","CIDADENASCIMENTO" & intCodSCAAluno)
			
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
					window.history.back();
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
					window.history.back();
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
					vet1 = split(strTextoDocumento,"<a id=NOMEALUNO" & intCodSCAAluno & "></a>")
					if ubound(vet1)>1 then
						for j=0 to ubound(vet1)-1
							%>
							NOMEALUNO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strNomeAluno%>'
							<%
						next
					else
						%>
						NOMEALUNO<%=intCodSCAAluno%>.innerHTML = '<%=strNomeAluno%>'
						<%
					end if				
				end if
				if trim(vetCampos(i)) = "MATRICULA" then 
					vet2 = split(strTextoDocumento,"<a id=MATRICULA" & intCodSCAAluno & "></a>")
					if ubound(vet2)>1 then
						for j=0 to ubound(vet2)-1
							%>
							MATRICULA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strMatricula%>'
							<%
						next
					else
						%>
						MATRICULA<%=intCodSCAAluno%>.innerHTML = '<%=strMatricula%>'
						<%
					end if				
				end if
				if trim(vetCampos(i)) = "DATANASCIMENTO" then 
					vet3 = split(strTextoDocumento,"<a id=DATANASCIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet3)>1 then
						for j=0 to ubound(vet3)-1
							%>
							DATANASCIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataNascimento%>'
							<%
						next
					else
						%>
						DATANASCIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strDataNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CIDADENASCIMENTO" then 
					vet4 = split(strTextoDocumento,"<a id=CIDADENASCIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet4)>1 then
						for j=0 to ubound(vet4)-1
							%>
							CIDADENASCIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCidadeNascimento%>'
							<%
						next
					else
						%>
						CIDADENASCIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strCidadeNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "UFNASCIMENTO" then 
					vet5 = split(strTextoDocumento,"<a id=UFNASCIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet5)>1 then
						for j=0 to ubound(vet5)-1
							%>
							UFNASCIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strUfNascimento%>'
							<%
						next
					else
						%>
						UFNASCIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strUfNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ANOLETIVO" then 
					vet6 = split(strTextoDocumento,"<a id=ANOLETIVO" & intCodSCAAluno & "></a>")
					if ubound(vet6)>1 then
						for j=0 to ubound(vet6)-1
							%>
							ANOLETIVO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strAnoLetivo%>'
							<%
						next
					else
						%>
						ANOLETIVO<%=intCodSCAAluno%>.innerHTML = '<%=strAnoLetivo%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "PAI" then 
					vet7 = split(strTextoDocumento,"<a id=PAI" & intCodSCAAluno & "></a>")
					if ubound(vet7)>1 then
						for j=0 to ubound(vet7)-1
							%>
							PAI<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strPai%>'
							<%
						next
					else
						%>
						PAI<%=intCodSCAAluno%>.innerHTML = '<%=strPai%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "MAE" then 
					vet8 = split(strTextoDocumento,"<a id=MAE" & intCodSCAAluno & "></a>")
					if ubound(vet8)>1 then
						for j=0 to ubound(vet8)-1
							%>
							MAE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strMae%>'
							<%
						next
					else
						%>
						MAE<%=intCodSCAAluno%>.innerHTML = '<%=strMae%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "PERIODOATUAL" then 
					vet9 = split(strTextoDocumento,"<a id=PERIODOATUAL" & intCodSCAAluno & "></a>")
					if ubound(vet9)>1 then
						for j=0 to ubound(vet9)-1
							%>
							PERIODOATUAL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strPeriodoAtual%>'
							<%
						next
					else
						%>
						PERIODOATUAL<%=intCodSCAAluno%>.innerHTML = '<%=strPeriodoAtual%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CURSOATUAL" then 
					vet10 = split(strTextoDocumento,"<a id=CURSOATUAL" & intCodSCAAluno & "></a>")
					if ubound(vet10)>1 then
						for j=0 to ubound(vet10)-1
							%>
							CURSOATUAL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCursoAtual%>'
							<%
						next
					else
						%>
						CURSOATUAL<%=intCodSCAAluno%>.innerHTML = '<%=strCursoAtual%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "TURNOATUAL" then 
					vet11 = split(strTextoDocumento,"<a id=TURNOATUAL" & intCodSCAAluno & "></a>")
					if ubound(vet11)>1 then
						for j=0 to ubound(vet11)-1
							%>
							TURNOATUAL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strTurnoAtual%>'
							<%
						next
					else
						%>
						TURNOATUAL<%=intCodSCAAluno%>.innerHTML = '<%=strTurnoAtual%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CIDADE" then 
	
					vet12 = split(strTextoDocumento,"<a id=CIDADE" & intCodSCAAluno & "></a>")
					if ubound(vet12)>1 then
						for j=0 to ubound(vet12)-1
							%>
							CIDADE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCidade%>'
							<%
						next
					else
						%>
						CIDADE<%=intCodSCAAluno%>.innerHTML = '<%=strCidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DIA" then 
					
					vet13 = split(strTextoDocumento,"<a id=DIA" & intCodSCAAluno & "></a>")
					if ubound(vet13)>1 then
						for j=0 to ubound(vet13)-1
							%>
							DIA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDia%>'
							<%
						next
					else
						%>
						DIA<%=intCodSCAAluno%>.innerHTML = '<%=strDia%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "MES" then 
					vet14 = split(strTextoDocumento,"<a id=MES" & intCodSCAAluno & "></a>")
					if ubound(vet14)>1 then
						for j=0 to ubound(vet14)-1
							%>
							MES<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strMes%>'
							<%
						next
					else
						%>
						MES<%=intCodSCAAluno%>.innerHTML = '<%=strMes%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ANO" then 
					vet15 = split(strTextoDocumento,"<a id=ANO" & intCodSCAAluno & "></a>")
					if ubound(vet15)>1 then
						for j=0 to ubound(vet15)-1
							%>
							ANO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strAno%>'
							<%
						next
					else
						%>
						ANO<%=intCodSCAAluno%>.innerHTML = '<%=strAno%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SECRETARIO" then 
					vet16 = split(strTextoDocumento,"<a id=SECRETARIO" & intCodSCAAluno & "></a>")
					if ubound(vet16)>1 then
						for j=0 to ubound(vet16)-1
							%>
							SECRETARI<%=intCodSCAAluno%>O[<%=j%>].innerHTML = '<%=strSecretario%>'
							<%
						next
					else
						%>
						SECRETARIO<%=intCodSCAAluno%>.innerHTML = '<%=strSecretario%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DIRETOR" then 
					vet17 = split(strTextoDocumento,"<a id=DIRETOR" & intCodSCAAluno & "></a>")
					if ubound(vet17)>1 then
						for j=0 to ubound(vet17)-1
							%>
							DIRETOR<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDiretor%>'
							<%
						next
					else
						%>
						DIRETOR<%=intCodSCAAluno%>.innerHTML = '<%=strDiretor%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "IDENTIDADE" then 
					vet18 = split(strTextoDocumento,"<a id=IDENTIDADE" & intCodSCAAluno & "></a>")
					if ubound(vet18)>1 then
						for j=0 to ubound(vet18)-1
							%>
							IDENTIDADE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strIdentidade%>'
							<%
						next
					else
						%>
						IDENTIDADE<%=intCodSCAAluno%>.innerHTML = '<%=strIdentidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CPF" then 
					vet19 = split(strTextoDocumento,"<a id=CPF" & intCodSCAAluno & "></a>")
					if ubound(vet19)>1 then
						for j=0 to ubound(vet19)-1
							%>
							CPF<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCpf%>'
							<%
						next
					else
						%>
						CPF<%=intCodSCAAluno%>.innerHTML = '<%=strCpf%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "TITULO" then 
					vet20 = split(strTextoDocumento,"<a id=TITULO" & intCodSCAAluno & "></a>")
					if ubound(vet20)>1 then
						for j=0 to ubound(vet20)-1
							%>
							TITULO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strTitulo%>'
							<%
						next
					else
						%>
						TITULO<%=intCodSCAAluno%>.innerHTML = '<%=strTitulo%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ESTADOCIVIL" then 
					vet21 = split(strTextoDocumento,"<a id=ESTADOCIVIL" & intCodSCAAluno & "></a>")
					if ubound(vet21)>1 then
						for j=0 to ubound(vet21)-1
							%>
							ESTADOCIVIL<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strEstadoCivil%>'
							<%
						next
					else
						%>
						ESTADOCIVIL<%=intCodSCAAluno%>.innerHTML = '<%=strEstadoCivil%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "TURMAALUNO" then 
					vet22 = split(strTextoDocumento,"<a id=TURMAALUNO" & intCodSCAAluno & "></a>")
					if ubound(vet22)>1 then
						for j=0 to ubound(vet22)-1
							%>
							TURMAALUNO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strTurmaAluno%>'
							<%
						next
					else
						%>
						TURMAALUNO<%=intCodSCAAluno%>.innerHTML = '<%=strTurmaAluno%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SITUACAOALUNO" then 
					vet23 = split(strTextoDocumento,"<a id=SITUACAOALUNO" & intCodSCAAluno & "></a>")
					if ubound(vet23)>1 then
						for j=0 to ubound(vet23)-1
							%>
							SITUACAOALUNO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strSituacaoAluno%>'
							<%
						next
					else
						%>
						SITUACAOALUNO<%=intCodSCAAluno%>.innerHTML = '<%=strSituacaoAluno%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "FORMAINGRESSO" then 
					vet24 = split(strTextoDocumento,"<a id=FORMAINGRESSO" & intCodSCAAluno & "></a>")
					if ubound(vet24)>1 then
						for j=0 to ubound(vet24)-1
							%>
							FORMAINGRESSO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strFormaIngresso%>'
							<%
						next
					else
						%>
						FORMAINGRESSO<%=intCodSCAAluno%>.innerHTML = '<%=strFormaIngresso%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATAMATRICULA" then 
					vet25 = split(strTextoDocumento,"<a id=DATAMATRICULA" & intCodSCAAluno & "></a>")
					if ubound(vet25)>1 then
						for j=0 to ubound(vet25)-1
							%>
							DATAMATRICULA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataMatricula%>'
							<%
						next
					else
						%>
						DATAMATRICULA<%=intCodSCAAluno%>.innerHTML = '<%=strDataMatricula%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "NACIONALIDADE" then 
					vet26 = split(strTextoDocumento,"<a id=NACIONALIDADE" & intCodSCAAluno & "></a>")
					if ubound(vet26)>1 then
						for j=0 to ubound(vet26)-1
							%>
							NACIONALIDADE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strNacionalidade%>'
							<%
						next
					else
						%>
						NACIONALIDADE<%=intCodSCAAluno%>.innerHTML = '<%=strNacionalidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATACOLACAO" then 
					vet27 = split(strTextoDocumento,"<a id=DATACOLACAO" & intCodSCAAluno & "></a>")
					if ubound(vet27)>1 then
						for j=0 to ubound(vet27)-1
							%>
							DATACOLACAO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataColacao%>'
							<%
						next
					else
						%>
						DATACOLACAO<%=intCodSCAAluno%>.innerHTML = '<%=strDataColacao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATACERTIFICADO" then 
					vet28 = split(strTextoDocumento,"<a id=DATACERTIFICADO" & intCodSCAAluno & "></a>")
					if ubound(vet28)>1 then
						for j=0 to ubound(vet28)-1
							%>
							DATACERTIFICADO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataCertificado%>'
							<%
						next
					else
						%>
						DATACERTIFICADO<%=intCodSCAAluno%>.innerHTML = '<%=strDataCertificado%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ANOCONCLUSAO" then 
					vet29 = split(strTextoDocumento,"<a id=ANOCONCLUSAO" & intCodSCAAluno & "></a>")
					if ubound(vet29)>1 then
						for j=0 to ubound(vet29)-1
							%>
							ANOCONCLUSAO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strAnoConclusao%>'
							<%
						next
					else
						%>
						ANOCONCLUSAO<%=intCodSCAAluno%>.innerHTML = '<%=strAnoConclusao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SEMESTRE" then 
					vet33 = split(strTextoDocumento,"<a id=SEMESTRE" & intCodSCAAluno & "></a>")
					if ubound(vet33)>1 then
						for j=0 to ubound(vet29)-1
							%>
							SEMESTRE<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strSemestre%>'
							<%
						next
					else
						%>
						SEMESTRE<%=intCodSCAAluno%>.innerHTML = '<%=strSemestre%>'
						<%
					end if
				end if			
				if trim(vetCampos(i)) = "AUTORIZACAO" then 
					vet30 = split(strTextoDocumento,"<a id=AUTORIZACAO" & intCodSCAAluno & "></a>")
					if ubound(vet30)>1 then
						for j=0 to ubound(vet30)-1
							%>
							AUTORIZACAO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strAutorizacao%>'
							<%
						next
					else
						%>
						AUTORIZACAO<%=intCodSCAAluno%>.innerHTML = '<%=strAutorizacao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATAAUTORIZACAO" then 
					vet31 = split(strTextoDocumento,"<a id=DATAAUTORIZACAO" & intCodSCAAluno & "></a>")
					if ubound(vet31)>1 then
						for j=0 to ubound(vet31)-1
							%>
							DATAAUTORIZACAO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataAutorizacao%>'
							<%
						next
					else
						%>
						DATAAUTORIZACAO<%=intCodSCAAluno%>.innerHTML = '<%=strDataAutorizacao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATARECONHECIMENTO" then 
					vet32 = split(strTextoDocumento,"<a id=DATARECONHECIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet32)>1 then
						for j=0 to ubound(vet32)-1
							%>
							DATARECONHECIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strDataReconhecimento%>'
							<%
						next
					else
						%>
						DATARECONHECIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strDataReconhecimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "RECONHECIMENTO" then 
					vet24 = split(strTextoDocumento,"<a id=RECONHECIMENTO" & intCodSCAAluno & "></a>")
					if ubound(vet24)>1 then
						for j=0 to ubound(vet24)-1
							%>
							RECONHECIMENTO<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strReconhecimento%>'
							<%
						next
					else
						%>
						RECONHECIMENTO<%=intCodSCAAluno%>.innerHTML = '<%=strReconhecimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CH_EXIGIDA" then 
					vet25 = split(strTextoDocumento,"<a id=CH_EXIGIDA" & intCodSCAAluno & "></a>")
					if ubound(vet25)>1 then
						for j=0 to ubound(vet25)-1
							%>
							CH_EXIGIDA<%=intCodSCAAluno%>[<%=j%>].innerHTML = '<%=strCH_Exigida%>'
							<%
						next
					else
						%>
						CH_EXIGIDA<%=intCodSCAAluno%>.innerHTML = '<%=strCH_Exigida%>'
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
			strSituacaoAluno 	= ""
			strTodosOsCampos 	= ""
			strTituloRelatorio 	= ""
			strTextoDocumento 	= ""
			strPeriodoAtual		= ""
			strCursoAtual		= ""
			strTurnoAtual		= ""
			strTurmaAluno		= ""
			strAutorizacao		= ""
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
			strPai				= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			strMae				= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			strIdentidade		= "XXXXXXXXXX"
			str					= "XXXXXXXXXX"
			strTitulo			= "XXXXXXXXXX"
			strEstadoCivil		= "XXXXXXXXXXXXXXXXX"
			strSituacaoAluno	= "XXXXXXXXXXXXXXXXXX"
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

	next
	%>
    <script>
        aguarde.style.display="none";
    </script>
</body>
</html>
