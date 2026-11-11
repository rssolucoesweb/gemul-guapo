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

	intCodAluno	 			= 100869'Trim(Request.form("txtCodAluno"))
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
	sql = sql & " and a.codigo = " & intCodAluno
	rs.open sql, cnn
	if rs.eof = false then
		strCodAluno			= Trim(rs("codigo"))
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
		sql = sql & " and a.codigo = " & intCodAluno
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
	END IF
	rs.close
	
	if trim(strChecarPosicaoFinanceira) = "S" then
		'REGRA PARA VERIFICAR DEBITO DO ALUNO
		sql = "select cod_aluno from SCF_DEBITOALUNO"
		sql = sql & " where	cod_situacao_pagamento = 1"
		sql = sql & " and cod_aluno = " & intCodAluno
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
		sql = sql & " and codigo = " & intCodAluno
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

	
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<br>
	<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td class="texto2" align="justify"><%=strTextoDocumento%></td>
      </tr>
    </table>	
	<%
	if strTodosOsCampos <> "" then
		%>
		<script>
			function mostraDocumento(){
		<%
		vetCampos = split(strTodosOsCampos,",")
		for i=0 to ubound(vetCampos)
			if trim(vetCampos(i)) = "NOMEALUNO" then 
				vet1 = split(strTextoDocumento,"<a id=NOMEALUNO></a>")
				if ubound(vet1)>1 then
					for j=0 to ubound(vet1)-1
						%>
						NOMEALUNO[<%=j%>].innerHTML = '<%=strNomeAluno%>'
						<%
					next
				else
					%>
					NOMEALUNO.innerHTML = '<%=strNomeAluno%>'
					<%
				end if				
			end if
			if trim(vetCampos(i)) = "MATRICULA" then 
				vet2 = split(strTextoDocumento,"<a id=MATRICULA></a>")
				if ubound(vet2)>1 then
					for j=0 to ubound(vet2)-1
						%>
						MATRICULA[<%=j%>].innerHTML = '<%=strMatricula%>'
						<%
					next
				else
					%>
					MATRICULA.innerHTML = '<%=strMatricula%>'
					<%
				end if				
			end if
			if trim(vetCampos(i)) = "DATANASCIMENTO" then 
				vet3 = split(strTextoDocumento,"<a id=DATANASCIMENTO></a>")
				if ubound(vet3)>1 then
					for j=0 to ubound(vet3)-1
						%>
						DATANASCIMENTO[<%=j%>].innerHTML = '<%=strDataNascimento%>'
						<%
					next
				else
					%>
					DATANASCIMENTO.innerHTML = '<%=strDataNascimento%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "CIDADENASCIMENTO" then 
				vet4 = split(strTextoDocumento,"<a id=CIDADENASCIMENTO></a>")
				if ubound(vet4)>1 then
					for j=0 to ubound(vet4)-1
						%>
						CIDADENASCIMENTO[<%=j%>].innerHTML = '<%=strCidadeNascimento%>'
						<%
					next
				else
					%>
					CIDADENASCIMENTO.innerHTML = '<%=strCidadeNascimento%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "UFNASCIMENTO" then 
				vet5 = split(strTextoDocumento,"<a id=UFNASCIMENTO></a>")
				if ubound(vet5)>1 then
					for j=0 to ubound(vet5)-1
						%>
						UFNASCIMENTO[<%=j%>].innerHTML = '<%=strUfNascimento%>'
						<%
					next
				else
					%>
					UFNASCIMENTO.innerHTML = '<%=strUfNascimento%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "ANOLETIVO" then 
				vet6 = split(strTextoDocumento,"<a id=ANOLETIVO></a>")
				if ubound(vet6)>1 then
					for j=0 to ubound(vet6)-1
						%>
						ANOLETIVO[<%=j%>].innerHTML = '<%=strAnoLetivo%>'
						<%
					next
				else
					%>
					ANOLETIVO.innerHTML = '<%=strAnoLetivo%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "PAI" then 
				vet7 = split(strTextoDocumento,"<a id=PAI></a>")
				if ubound(vet7)>1 then
					for j=0 to ubound(vet7)-1
						%>
						PAI[<%=j%>].innerHTML = '<%=strPai%>'
						<%
					next
				else
					%>
					PAI.innerHTML = '<%=strPai%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "MAE" then 
				vet8 = split(strTextoDocumento,"<a id=MAE></a>")
				if ubound(vet8)>1 then
					for j=0 to ubound(vet8)-1
						%>
						MAE[<%=j%>].innerHTML = '<%=strMae%>'
						<%
					next
				else
					%>
					MAE.innerHTML = '<%=strMae%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "PERIODOATUAL" then 
				vet9 = split(strTextoDocumento,"<a id=PERIODOATUAL></a>")
				if ubound(vet9)>1 then
					for j=0 to ubound(vet9)-1
						%>
						PERIODOATUAL[<%=j%>].innerHTML = '<%=strPeriodoAtual%>'
						<%
					next
				else
					%>
					PERIODOATUAL.innerHTML = '<%=strPeriodoAtual%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "CURSOATUAL" then 
				vet10 = split(strTextoDocumento,"<a id=CURSOATUAL></a>")
				if ubound(vet10)>1 then
					for j=0 to ubound(vet10)-1
						%>
						CURSOATUAL[<%=j%>].innerHTML = '<%=strCursoAtual%>'
						<%
					next
				else
					%>
					CURSOATUAL.innerHTML = '<%=strCursoAtual%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "TURNOATUAL" then 
				vet11 = split(strTextoDocumento,"<a id=TURNOATUAL></a>")
				if ubound(vet11)>1 then
					for j=0 to ubound(vet11)-1
						%>
						TURNOATUAL[<%=j%>].innerHTML = '<%=strTurnoAtual%>'
						<%
					next
				else
					%>
					TURNOATUAL.innerHTML = '<%=strTurnoAtual%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "CIDADE" then 

				vet12 = split(strTextoDocumento,"<a id=CIDADE></a>")
				if ubound(vet12)>1 then
					for j=0 to ubound(vet12)-1
						%>
						CIDADE[<%=j%>].innerHTML = '<%=strCidade%>'
						<%
					next
				else
					%>
					CIDADE.innerHTML = '<%=strCidade%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "DIA" then 
				
				vet13 = split(strTextoDocumento,"<a id=DIA></a>")
				if ubound(vet13)>1 then
					for j=0 to ubound(vet13)-1
						%>
						DIA[<%=j%>].innerHTML = '<%=strDia%>'
						<%
					next
				else
					%>
					DIA.innerHTML = '<%=strDia%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "MES" then 
				vet14 = split(strTextoDocumento,"<a id=MES></a>")
				if ubound(vet14)>1 then
					for j=0 to ubound(vet14)-1
						%>
						MES[<%=j%>].innerHTML = '<%=strMes%>'
						<%
					next
				else
					%>
					MES.innerHTML = '<%=strMes%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "ANO" then 
				vet15 = split(strTextoDocumento,"<a id=ANO></a>")
				if ubound(vet15)>1 then
					for j=0 to ubound(vet15)-1
						%>
						ANO[<%=j%>].innerHTML = '<%=strAno%>'
						<%
					next
				else
					%>
					ANO.innerHTML = '<%=strAno%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "SECRETARIO" then 
				vet16 = split(strTextoDocumento,"<a id=SECRETARIO></a>")
				if ubound(vet16)>1 then
					for j=0 to ubound(vet16)-1
						%>
						SECRETARIO[<%=j%>].innerHTML = '<%=strSecretario%>'
						<%
					next
				else
					%>
					SECRETARIO.innerHTML = '<%=strSecretario%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "DIRETOR" then 
				vet17 = split(strTextoDocumento,"<a id=DIRETOR></a>")
				if ubound(vet17)>1 then
					for j=0 to ubound(vet17)-1
						%>
						DIRETOR[<%=j%>].innerHTML = '<%=strDiretor%>'
						<%
					next
				else
					%>
					DIRETOR.innerHTML = '<%=strDiretor%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "IDENTIDADE" then 
				vet18 = split(strTextoDocumento,"<a id=IDENTIDADE></a>")
				if ubound(vet18)>1 then
					for j=0 to ubound(vet18)-1
						%>
						IDENTIDADE[<%=j%>].innerHTML = '<%=strIdentidade%>'
						<%
					next
				else
					%>
					IDENTIDADE.innerHTML = '<%=strIdentidade%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "CPF" then 
				vet19 = split(strTextoDocumento,"<a id=CPF></a>")
				if ubound(vet19)>1 then
					for j=0 to ubound(vet19)-1
						%>
						CPF[<%=j%>].innerHTML = '<%=strCpf%>'
						<%
					next
				else
					%>
					CPF.innerHTML = '<%=strCpf%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "TITULO" then 
				vet20 = split(strTextoDocumento,"<a id=TITULO></a>")
				if ubound(vet20)>1 then
					for j=0 to ubound(vet20)-1
						%>
						TITULO[<%=j%>].innerHTML = '<%=strTitulo%>'
						<%
					next
				else
					%>
					TITULO.innerHTML = '<%=strTitulo%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "ESTADOCIVIL" then 
				vet21 = split(strTextoDocumento,"<a id=ESTADOCIVIL></a>")
				if ubound(vet21)>1 then
					for j=0 to ubound(vet21)-1
						%>
						ESTADOCIVIL[<%=j%>].innerHTML = '<%=strEstadoCivil%>'
						<%
					next
				else
					%>
					ESTADOCIVIL.innerHTML = '<%=strEstadoCivil%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "TURMAALUNO" then 
				vet22 = split(strTextoDocumento,"<a id=TURMAALUNO></a>")
				if ubound(vet22)>1 then
					for j=0 to ubound(vet22)-1
						%>
						TURMAALUNO[<%=j%>].innerHTML = '<%=strTurmaAluno%>'
						<%
					next
				else
					%>
					TURMAALUNO.innerHTML = '<%=strTurmaAluno%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "SITUACAOALUNO" then 
				vet23 = split(strTextoDocumento,"<a id=SITUACAOALUNO></a>")
				if ubound(vet23)>1 then
					for j=0 to ubound(vet23)-1
						%>
						SITUACAOALUNO[<%=j%>].innerHTML = '<%=strSituacaoAluno%>'
						<%
					next
				else
					%>
					SITUACAOALUNO.innerHTML = '<%=strSituacaoAluno%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "FORMAINGRESSO" then 
				vet24 = split(strTextoDocumento,"<a id=FORMAINGRESSO></a>")
				if ubound(vet24)>1 then
					for j=0 to ubound(vet24)-1
						%>
						FORMAINGRESSO[<%=j%>].innerHTML = '<%=strFormaIngresso%>'
						<%
					next
				else
					%>
					FORMAINGRESSO.innerHTML = '<%=strFormaIngresso%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "DATAMATRICULA" then 
				vet25 = split(strTextoDocumento,"<a id=DATAMATRICULA></a>")
				if ubound(vet25)>1 then
					for j=0 to ubound(vet25)-1
						%>
						DATAMATRICULA[<%=j%>].innerHTML = '<%=strDataMatricula%>'
						<%
					next
				else
					%>
					DATAMATRICULA.innerHTML = '<%=strDataMatricula%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "NACIONALIDADE" then 
				vet26 = split(strTextoDocumento,"<a id=NACIONALIDADE></a>")
				if ubound(vet26)>1 then
					for j=0 to ubound(vet26)-1
						%>
						NACIONALIDADE[<%=j%>].innerHTML = '<%=strNacionalidade%>'
						<%
					next
				else
					%>
					NACIONALIDADE.innerHTML = '<%=strNacionalidade%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "DATACOLACAO" then 
				vet27 = split(strTextoDocumento,"<a id=DATACOLACAO></a>")
				if ubound(vet27)>1 then
					for j=0 to ubound(vet27)-1
						%>
						DATACOLACAO[<%=j%>].innerHTML = '<%=strDataColacao%>'
						<%
					next
				else
					%>
					DATACOLACAO.innerHTML = '<%=strDataColacao%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "DATACERTIFICADO" then 
				vet28 = split(strTextoDocumento,"<a id=DATACERTIFICADO></a>")
				if ubound(vet28)>1 then
					for j=0 to ubound(vet28)-1
						%>
						DATACERTIFICADO[<%=j%>].innerHTML = '<%=strDataCertificado%>'
						<%
					next
				else
					%>
					DATACERTIFICADO.innerHTML = '<%=strDataCertificado%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "ANOCONCLUSAO" then 
				vet29 = split(strTextoDocumento,"<a id=ANOCONCLUSAO></a>")
				if ubound(vet29)>1 then
					for j=0 to ubound(vet29)-1
						%>
						ANOCONCLUSAO[<%=j%>].innerHTML = '<%=strAnoConclusao%>'
						<%
					next
				else
					%>
					ANOCONCLUSAO.innerHTML = '<%=strAnoConclusao%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "SEMESTRE" then 
				vet33 = split(strTextoDocumento,"<a id=SEMESTRE></a>")
				if ubound(vet33)>1 then
					for j=0 to ubound(vet29)-1
						%>
						SEMESTRE[<%=j%>].innerHTML = '<%=strSemestre%>'
						<%
					next
				else
					%>
					SEMESTRE.innerHTML = '<%=strSemestre%>'
					<%
				end if
			end if			
			if trim(vetCampos(i)) = "AUTORIZACAO" then 
				vet30 = split(strTextoDocumento,"<a id=AUTORIZACAO></a>")
				if ubound(vet30)>1 then
					for j=0 to ubound(vet30)-1
						%>
						AUTORIZACAO[<%=j%>].innerHTML = '<%=strAutorizacao%>'
						<%
					next
				else
					%>
					AUTORIZACAO.innerHTML = '<%=strAutorizacao%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "DATAAUTORIZACAO" then 
				vet31 = split(strTextoDocumento,"<a id=DATAAUTORIZACAO></a>")
				if ubound(vet31)>1 then
					for j=0 to ubound(vet31)-1
						%>
						DATAAUTORIZACAO[<%=j%>].innerHTML = '<%=strDataAutorizacao%>'
						<%
					next
				else
					%>
					DATAAUTORIZACAO.innerHTML = '<%=strDataAutorizacao%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "DATARECONHECIMENTO" then 
				vet32 = split(strTextoDocumento,"<a id=DATARECONHECIMENTO></a>")
				if ubound(vet32)>1 then
					for j=0 to ubound(vet32)-1
						%>
						DATARECONHECIMENTO[<%=j%>].innerHTML = '<%=strDataReconhecimento%>'
						<%
					next
				else
					%>
					DATARECONHECIMENTO.innerHTML = '<%=strDataReconhecimento%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "RECONHECIMENTO" then 
				vet24 = split(strTextoDocumento,"<a id=RECONHECIMENTO></a>")
				if ubound(vet24)>1 then
					for j=0 to ubound(vet24)-1
						%>
						RECONHECIMENTO[<%=j%>].innerHTML = '<%=strReconhecimento%>'
						<%
					next
				else
					%>
					RECONHECIMENTO.innerHTML = '<%=strReconhecimento%>'
					<%
				end if
			end if
			if trim(vetCampos(i)) = "CH_EXIGIDA" then 
				vet25 = split(strTextoDocumento,"<a id=CH_EXIGIDA></a>")
				if ubound(vet25)>1 then
					for j=0 to ubound(vet25)-1
						%>
						CH_EXIGIDA[<%=j%>].innerHTML = '<%=strCH_Exigida%>'
						<%
					next
				else
					%>
					CH_EXIGIDA.innerHTML = '<%=strCH_Exigida%>'
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
	mostraDocumento();
</script>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
