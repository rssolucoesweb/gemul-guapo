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
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	intCodModeloDocumento	= Trim(Request.form("cmbModeloDocumento"))
    vetCodColaborador			=	split(Trim(Request.form("chkColaborador")),",")
	

	codEmpresa	 			= session("CodEmpresa")
	strDia					= day(date)
	strMes					= monthname(month(date))
	strAno					= year(date)
	strCidade				= session("CidadeEmpresaWeb")
	strSecretario			= session("NomeSecretariaEmpresaWeb")
	strDiretor				= session("NomeDiretorEmpresaWeb")
	strCabecalho			= Trim(Request.form("cmbCabecalho"))

	for r=0 to ubound(vetCodColaborador)
	
		sql = " SELECT " 
		sql = sql & " C.codigo, " 
		sql = sql & " C.nome, " 
		sql = sql & " C.codFuncional as matricula, " 
		sql = sql & " C.data_nascimento AS datanascimento, " 
		sql = sql & " C.naturalidade AS cidadenascimento, " 
		sql = sql & " UF.SIGLA AS ufnascimento, " 
		sql = sql & " C.rg as Identidade, " 
		sql = sql & " C.cpf, " 
		sql = sql & " C.titulo_eleitor as Titulo, " 
		sql = sql & " C.estado_civil as EstadoCivil, " 
		sql = sql & " C.pai, " 
		sql = sql & " C.mae, " 
		sql = sql & " C.nacionalidade, " 
		sql = sql & " C.logradouro, " 
		sql = sql & " C.numero_logradouro as Numero_Endereco, " 
		sql = sql & " C.Comp_Endereco, " 
		sql = sql & " C.bairro, " 
		
		sql = sql & " CC.DESC_CARGO AS CARGO, " 
		sql = sql & " FC.DESC_FUNCAO AS FUNCAO, " 
		sql = sql & " c.data_admissao as DataAdimissao, " 
		sql = sql & " c.Datafastamento, " 
		sql = sql & " FN.DESC_FORMANOMEACAO AS FormaNomeacao, " 
		sql = sql & " N.Descricao AS Nivel, " 
		sql = sql & " T.Desc_Turno AS Turno, " 
		sql = sql & " C.carga_horario_contratada AS HorasContratada, " 
		sql = sql & " C.total_aulas AS AulasContratada, " 
		sql = sql & " C.DataLotacao, " 
		sql = sql & " RE.Descricao as Regencia, " 
		sql = sql & " C.Obs AS Observacoes, " 
		sql = sql & " C.situacao as SituacaoCadastral, " 
		sql = sql & " (select top 1 anoLetivo from SCA_HORARIO_AULA aulas  " 
		sql = sql & " where Cod_Colaborador=c.codigo order by AnoLetivo desc ) as AnoLetivo, "    
		sql = sql & " (select top 1 Semestre from SCA_HORARIO_AULA aulas  " 
		sql = sql & " where Cod_Colaborador=c.codigo order by Codigo desc ) as semestre, " 
		sql = sql & " C.quantidade_quinquenio as Quinquenio, " 
		sql = sql & " C.total_aulas_Cumprida as AulasCumprida " 
		
		sql = sql & " FROM SRH_COLABORADOR C " 
		sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = C.UF  "  
		sql = sql & " LEFT JOIN SRH_CATEGORIA CA ON CA.COD_CATEGORIA = C.CODCATEGORIA " 
		sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GI ON GI.CODIGO = C.CodGrauInstrucao  " 
		sql = sql & " LEFT JOIN SEG_DEPARTAMENTO DP ON DP.CODIGO = C.CodDepartamento " 
		sql = sql & " LEFT JOIN SRH_CARGOCOLABORADOR CC ON CC.COD_CARGO = C.CODCARGO " 
		sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR FC ON FC.COD_FUNCAO = C.CODFUNCAO "  
		sql = sql & " LEFT JOIN SRH_FORMANOMEACAOCOLABORADOR FN ON FN.COD_FORMANOMEACAO = C.CODFORMANOMEACAO "   
		sql = sql & " LEFT JOIN SRH_NIVEL N ON N.Codigo = C.Cod_nivel  "  
		sql = sql & " LEFT JOIN SRH_TURNO T ON T.Cod_Turno = C.CodTurno "   
		sql = sql & " LEFT JOIN SRH_REGENCIACOLABORADOR RE ON RE.Codigo = C.Cod_Regencia  "  
		sql = sql & " where c.codigo in (" & vetCodColaborador(r) & ")"
		rs.open sql, cnn
		if rs.eof = false then
			intCodSCAColaborador		= Trim(rs("codigo"))
			strNomealuno 				= Trim(rs("Nome"))

			if trim(rs("EstadoCivil")) = "S" then strestado_civil = "Solteiro"
			if trim(rs("EstadoCivil")) = "C" then strestado_civil = "Casado"
			if trim(rs("EstadoCivil")) = "V" then strestado_civil = "Vi&uacute;vo"
			if trim(rs("EstadoCivil")) = "D" then strestado_civil = "Desquitado"
			if trim(rs("EstadoCivil")) = "I" then strestado_civil = "Divorciado"
			if trim(rs("EstadoCivil")) = "U" then strestado_civil = "União Estável"
			if trim(rs("EstadoCivil")) = "O" then strestado_civil = "Outros"

			strMatricula 				= Trim(rs("Matricula"))
			IF isnull(rs("Matricula")) then
				strMatricula		= "XXXXXXXXX"
			end if
			strDataNascimento	= formatadataAP(Trim(rs("dataNascimento")))
			IF isnull(rs("dataNascimento")) then
				strDataNascimento		= "XX/XX/XXXX"
			end if
			strCidadeNascimento	= Trim(rs("CIDADENASCIMENTO"))
			IF isnull(rs("CIDADENASCIMENTO")) then
				strCidadeNascimento		= "XXXXXXXXXXXXXX"
			end if
			strUfNascimento		= Trim(rs("ufnascimento"))
			IF isnull(rs("ufnascimento")) then
				strUfNascimento		= "XX"
			end if
			strIdentidade		= Trim(rs("IDENTIDADE"))
			IF isnull(rs("IDENTIDADE")) or Trim(rs("IDENTIDADE")) = "" then
				strIdentidade		= "XXXXXXXXXX"
			end if		
			strCpf				= Trim(rs("CPF"))
			IF isnull(rs("CPF")) or Trim(rs("CPF")) = "" then
				strCpf		= "XXXXXXXXXX"
			end if		
			strTitulo			= Trim(rs("Titulo"))
			IF isnull(rs("Titulo")) or Trim(rs("Titulo")) = "" then
				strTitulo		= "XXXXXXXXXX"
			end if		
			strEstadoCivil		= strestado_civil
			IF isnull(strestado_civil) or Trim(strestado_civil) = "" then
				strEstadoCivil		= "XXXXXXXXXXXXXXXXX"
			end if		
			strPai				= Trim(rs("PAI"))
			IF isnull(rs("pai")) or Trim(rs("PAI")) = "" then
				strPai		= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strMae				= Trim(rs("MAE"))
			IF isnull(rs("mae")) or Trim(rs("mae")) = "" then
				strMae		= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			strNacionalidade	= Trim(rs("NACIONALIDADE"))
			IF isnull(rs("NACIONALIDADE")) or Trim(rs("NACIONALIDADE")) = "" then
				strNacionalidade		= "XXXXXXXXXXXXXXXXXXXXXXXX"
			end if		
			strEndereco 			= Trim(rs("LOGRADOURO"))
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
			strBairroEndereco 		= Trim(rs("BAIRRO"))
			IF isnull(rs("BAIRRO")) then
				strBairroEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if
			'---
			strCargo	= Trim(rs("CARGO"))
			IF isnull(rs("CARGO")) or Trim(rs("CARGO")) = "" then
				strCargo		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if		
			strFuncao	= Trim(rs("FUNCAO"))
			IF isnull(rs("FUNCAO")) or Trim(rs("FUNCAO")) = "" then
				strFuncao		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if		
			strDataAdimissao	= formatadataAP(Trim(rs("DataAdimissao")))
			IF isnull(rs("DataAdimissao")) or Trim(rs("DataAdimissao")) = "" then
				strDataAdimissao		= "XX/XX/XXXXX"
			end if		
			strDatafastamento		= formatadataAP(Trim(rs("Datafastamento")))
			IF isnull(rs("Datafastamento")) or Trim(rs("Datafastamento")) = "" then
				strDatafastamento		= "XX/XX/XXXXX"
			end if		
			strFormaNomeacao	= Trim(rs("FormaNomeacao"))
			IF isnull(rs("FormaNomeacao")) or Trim(rs("FormaNomeacao")) = "" then
				strFormaNomeacao		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if		
			strNivel		= Trim(rs("Nivel"))
			IF isnull(rs("Nivel")) or Trim(rs("Nivel")) = "" then
				strNivel		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if		
			strTurno		= Trim(rs("Turno"))
			IF isnull(rs("Turno")) or Trim(rs("Turno")) = "" then
				strTurno		= "XXXXXXXXXXXXXXXXXX"
			end if		
			strHorasContratada		= Trim(rs("HorasContratada"))
			IF isnull(rs("HorasContratada")) or Trim(rs("HorasContratada")) = "" then
				strHorasContratada		= "XXXX"
			end if		
			strAulasContratada		= Trim(rs("AulasContratada"))
			IF isnull(rs("AulasContratada")) or Trim(rs("AulasContratada")) = "" then
				strAulasContratada		= "XXXX"
			end if		
			strDataLotacao		= Trim(rs("DataLotacao"))
			IF isnull(rs("DataLotacao")) or Trim(rs("DataLotacao")) = "" then
				strDataLotacao		= "XX/XX/XXXXX"
			end if		
			strRegencia		= Trim(rs("Regencia"))
			IF isnull(rs("Regencia")) or Trim(rs("Regencia")) = "" then
				strRegencia		= "XXXXXXXXXXXXXXXXXX"
			end if		
			strObservacoes		= Trim(rs("Observacoes"))
			IF isnull(rs("Observacoes")) or Trim(rs("Observacoes")) = "" then
				strObservacoes		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
			end if		
			strSituacaoCadastral		= Trim(rs("SituacaoCadastral"))
			IF Trim(rs("SituacaoCadastral")) = "A" then 
				strSituacaoCadastral = "ATIVO"
			elseif Trim(rs("SituacaoCadastral")) = "I" then 
				strSituacaoCadastral = "INATIVO"
			else
				strSituacaoCadastral = "** SITUAÇÃO INDEFINIDA **"
			end if	

			strPERIODOLETIVO		= Trim(rs("AnoLetivo"))
			IF isnull(rs("AnoLetivo")) or Trim(rs("AnoLetivo")) = "" then
				strPERIODOLETIVO		= session("strAnoLetivo")
			end if	
			strPERIODOLETIVO		= session("strAnoLetivo")	
			strSemestre		= Trim(rs("semestre"))
			IF isnull(rs("semestre")) or Trim(rs("semestre")) = "" then
				strSemestre		= session("strSemestre")
			end if	
			strSemestre		= session("strSemestre")
			if strSemestre = "1" then strSemestre = "1º SEMESTRE"
			if strSemestre = "2" then strSemestre = "2º SEMESTRE"
			if strSemestre = "3" then strSemestre = "ANUAL"
			strQuinquenio		= Trim(rs("Quinquenio"))
			IF isnull(rs("Quinquenio")) or Trim(rs("Quinquenio")) = "" then
				strQuinquenio		= "XXXXXXXXXXXXXXXX"
			end if	
			strAulasCumprida		= Trim(rs("AulasCumprida"))
			IF isnull(rs("AulasCumprida")) or Trim(rs("AulasCumprida")) = "" then
				strAulasCumprida	= "XXXX"
			end if		
		end if
		rs.close

		strTodosOsCampos = ""
		sql = "SELECT codigo, titulo, documento, campos, situacao"
		sql = sql & " FROM SRH_DOCUMENTO"
		SQL = SQL & " WHERE codigo = " & intCodModeloDocumento
		sql = sql & " Order by titulo"
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strSituacao = trim(rs("situacao"))
			strTodosOsCampos = trim(rs("campos"))
	
			strTodosOsCampos = trim(rs("campos"))
			strTituloRelatorio = trim(rs("titulo"))
			strTextoDocumento = REPLACE(REPLACE(rs("documento"),"&lt;","<"),"&gt;",">")
			strTextoDocumento = REPLACE(strTextoDocumento,"=NOME","=XX_NOME" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=MATRICULA","=XX_MATRICULA" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATANASCIMENTO","=XX_DATANASCIMENTO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=CIDADENASCIMENTO","=XX_CIDADENASCIMENTO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=UFNASCIMENTO","=XX_UFNASCIMENTO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=IDENTIDADE","=XX_IDENTIDADE" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=CPF","=XX_CPF" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=TITULO","=XX_TITULO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=ESTADOCIVIL","=XX_ESTADOCIVIL" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=PAI","=XX_PAI" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=MAE","=XX_MAE" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=NACIONALIDADE","=XX_NACIONALIDADE" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=LOGRADOURO","=XX_LOGRADOURO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=NUMERO_ENDERECO","=XX_NUMERO_ENDERECO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=COMP_ENDERECO","=XX_COMP_ENDERECO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=BAIRRO","=XX_BAIRRO" & intCodSCAColaborador)
			'
			strTextoDocumento = REPLACE(strTextoDocumento,"=CARGO","=XX_CARGO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=FUNCAO","=XX_FUNCAO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATAADIMISSAO","=XX_DATAADIMISSAO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATAAFASTAMENTO","=XX_DATAAFASTAMENTO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=FORMANOMEACAO","=XX_FORMANOMEACAO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=NIVEL","=XX_NIVEL" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=TURNO","=XX_TURNO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=HORASCONTRATADA","=XX_HORASCONTRATADA" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=AULASCONTRATADA","=XX_AULASCONTRATADA" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DATALOTACAO","=XX_DATALOTACAO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=REGENCIA","=XX_REGENCIA" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=OBSERVACOES","=XX_OBSERVACOES" & intCodSCAColaborador)
			'
			strTextoDocumento = REPLACE(strTextoDocumento,"=CIDADE","=XX_CIDADE" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DIA","=XX_DIA" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=MES","=XX_MES" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=ANO","=XX_ANO" & intCodSCAColaborador)
			'
			strTextoDocumento = REPLACE(strTextoDocumento,"=SECRETARIO","=XX_SECRETARIO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=DIRETOR","=XX_DIRETOR" & intCodSCAColaborador)
			'
			strTextoDocumento = REPLACE(strTextoDocumento,"=SITUACAO","=XX_SITUACAO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=PERIODOLETIVO","=XX_PERIODOLETIVO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=SEMESTRE","=XX_SEMESTRE" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=QUINQUENIO","=XX_QUINQUENIO" & intCodSCAColaborador)
			strTextoDocumento = REPLACE(strTextoDocumento,"=AULASCUMPRIDA","=XX_AULASCUMPRIDA" & intCodSCAColaborador)
			
		END IF
		rs.close
		
		if trim(strSituacao) <> "" and not isnull(strSituacao) then
			'REGRA PARA VERIFICAR SITUACAO DO ALUNO
			sql = "select codigo from SRH_COLABORADOR"
			sql = sql & " where	situacao not in ('" & strSituacao & "')"
			sql = sql & " and codigo = " & intCodSCAColaborador
			sql = sql & " AND COD_EMPRESA = " & Session("CodEmpresa")
			rs.open sql, cnn
			if not RS.EOF then
				rs.close	
				%>
				<script>
					alert("ATENÇÃO: Documento não pode ser gerando, Colaborador com situação cadastral irregular para geração desse documento.");
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
				function mostraDocumento<%=intCodSCAColaborador%>(){
			<%
			vetCampos = split(strTodosOsCampos,",")
			for i=0 to ubound(vetCampos)
				if trim(vetCampos(i)) = "NOME" then 
					vet1 = split(strTextoDocumento,"<a id=XX_NOME" & intCodSCAColaborador & "></a>")
					if ubound(vet1)>1 then
						for j=0 to ubound(vet1)-1
							%>
							XX_NOME<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strNomeAluno%>'
							<%
						next
					else
						%>
						XX_NOME<%=intCodSCAColaborador%>.innerHTML = '<%=strNomeAluno%>'
						<%
					end if				
				end if
				if trim(vetCampos(i)) = "MATRICULA" then 
					vet2 = split(strTextoDocumento,"<a id=XX_MATRICULA" & intCodSCAColaborador & "></a>")
					if ubound(vet2)>1 then
						for j=0 to ubound(vet2)-1
							%>
							XX_MATRICULA<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strMatricula%>'
							<%
						next
					else
						%>
						XX_MATRICULA<%=intCodSCAColaborador%>.innerHTML = '<%=strMatricula%>'
						<%
					end if				
				end if
				if trim(vetCampos(i)) = "DATANASCIMENTO" then 
					vet3 = split(strTextoDocumento,"<a id=XX_DATANASCIMENTO" & intCodSCAColaborador & "></a>")
					if ubound(vet3)>1 then
						for j=0 to ubound(vet3)-1
							%>
							XX_DATANASCIMENTO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strDataNascimento%>'
							<%
						next
					else
						%>
						XX_DATANASCIMENTO<%=intCodSCAColaborador%>.innerHTML = '<%=strDataNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CIDADENASCIMENTO" then 
					vet4 = split(strTextoDocumento,"<a id=XX_CIDADENASCIMENTO" & intCodSCAColaborador & "></a>")
					if ubound(vet4)>1 then
						for j=0 to ubound(vet4)-1
							%>
							XX_CIDADENASCIMENTO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strCidadeNascimento%>'
							<%
						next
					else
						%>
						XX_CIDADENASCIMENTO<%=intCodSCAColaborador%>.innerHTML = '<%=strCidadeNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "UFNASCIMENTO" then 
					vet5 = split(strTextoDocumento,"<a id=XX_UFNASCIMENTO" & intCodSCAColaborador & "></a>")
					if ubound(vet5)>1 then
						for j=0 to ubound(vet5)-1
							%>
							XX_UFNASCIMENTO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strUfNascimento%>'
							<%
						next
					else
						%>
						XX_UFNASCIMENTO<%=intCodSCAColaborador%>.innerHTML = '<%=strUfNascimento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "IDENTIDADE" then 
					vet18 = split(strTextoDocumento,"<a id=XX_IDENTIDADE" & intCodSCAColaborador & "></a>")
					if ubound(vet18)>1 then
						for j=0 to ubound(vet18)-1
							%>
							XX_IDENTIDADE<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strIdentidade%>'
							<%
						next
					else
						%>
						XX_IDENTIDADE<%=intCodSCAColaborador%>.innerHTML = '<%=strIdentidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CPF" then 
					vet19 = split(strTextoDocumento,"<a id=XX_CPF" & intCodSCAColaborador & "></a>")
					if ubound(vet19)>1 then
						for j=0 to ubound(vet19)-1
							%>
							XX_CPF<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strCpf%>'
							<%
						next
					else
						%>
						XX_CPF<%=intCodSCAColaborador%>.innerHTML = '<%=strCpf%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "TITULO" then 
					vet20 = split(strTextoDocumento,"<a id=XX_TITULO" & intCodSCAColaborador & "></a>")
					if ubound(vet20)>1 then
						for j=0 to ubound(vet20)-1
							%>
							XX_TITULO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strTitulo%>'
							<%
						next
					else
						%>
						XX_TITULO<%=intCodSCAColaborador%>.innerHTML = '<%=strTitulo%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ESTADOCIVIL" then 
					vet21 = split(strTextoDocumento,"<a id=XX_ESTADOCIVIL" & intCodSCAColaborador & "></a>")
					if ubound(vet21)>1 then
						for j=0 to ubound(vet21)-1
							%>
							XX_ESTADOCIVIL<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strEstadoCivil%>'
							<%
						next
					else
						%>
						XX_ESTADOCIVIL<%=intCodSCAColaborador%>.innerHTML = '<%=strEstadoCivil%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "PAI" then 
					vet7 = split(strTextoDocumento,"<a id=XX_PAI" & intCodSCAColaborador & "></a>")
					if ubound(vet7)>1 then
						for j=0 to ubound(vet7)-1
							%>
							XX_PAI<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strPai%>'
							<%
						next
					else
						%>
						XX_PAI<%=intCodSCAColaborador%>.innerHTML = '<%=strPai%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "MAE" then 
					vet8 = split(strTextoDocumento,"<a id=XX_MAE" & intCodSCAColaborador & "></a>")
					if ubound(vet8)>1 then
						for j=0 to ubound(vet8)-1
							%>
							XX_MAE<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strMae%>'
							<%
						next
					else
						%>
						XX_MAE<%=intCodSCAColaborador%>.innerHTML = '<%=strMae%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "NACIONALIDADE" then 
					vet26 = split(strTextoDocumento,"<a id=XX_NACIONALIDADE" & intCodSCAColaborador & "></a>")
					if ubound(vet26)>1 then
						for j=0 to ubound(vet26)-1
							%>
							XX_NACIONALIDADE<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strNacionalidade%>'
							<%
						next
					else
						%>
						XX_NACIONALIDADE<%=intCodSCAColaborador%>.innerHTML = '<%=strNacionalidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "LOGRADOURO" then 
					vet33 = split(strTextoDocumento,"<a id=XX_LOGRADOURO" & intCodSCAColaborador & "></a>")
					if ubound(vet33)>1 then
						for j=0 to ubound(vet33)-1
							%>
							XX_LOGRADOURO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strEndereco%>'
							<%
						next
					else
						%>
						XX_LOGRADOURO<%=intCodSCAColaborador%>.innerHTML = '<%=strEndereco%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "NUMERO_ENDERECO" then 
					vet34 = split(strTextoDocumento,"<a id=XX_NUMERO_ENDERECO" & intCodSCAColaborador & "></a>")
					if ubound(vet34)>1 then
						for j=0 to ubound(vet34)-1
							%>
							XX_NUMERO_ENDERECO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strNumeroEndereco%>'
							<%
						next
					else
						%>
						XX_NUMERO_ENDERECO<%=intCodSCAColaborador%>.innerHTML = '<%=strNumeroEndereco%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "COMP_ENDERECO" then 
					vet35 = split(strTextoDocumento,"<a id=XX_COMP_ENDERECO" & intCodSCAColaborador & "></a>")
					if ubound(vet35)>1 then
						for j=0 to ubound(vet35)-1
							%>
							XX_COMP_ENDERECO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strCompEndereco%>'
							<%
						next
					else
						%>
						XX_COMP_ENDERECO<%=intCodSCAColaborador%>.innerHTML = '<%=strCompEndereco%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "BAIRRO" then 
					vet36 = split(strTextoDocumento,"<a id=XX_BAIRRO" & intCodSCAColaborador & "></a>")
					if ubound(vet36)>1 then
						for j=0 to ubound(vet36)-1
							%>
							XX_BAIRRO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strBairroEndereco%>'
							<%
						next
					else
						%>
						XX_BAIRRO<%=intCodSCAColaborador%>.innerHTML = '<%=strBairroEndereco%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "CARGO" then 
					vet6 = split(strTextoDocumento,"<a id=XX_CARGO" & intCodSCAColaborador & "></a>")
					if ubound(vet6)>1 then
						for j=0 to ubound(vet6)-1
							%>
							XX_CARGO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strCargo%>'
							<%
						next
					else
						%>
						XX_CARGO<%=intCodSCAColaborador%>.innerHTML = '<%=strCargo%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "FUNCAO" then 
					vet9 = split(strTextoDocumento,"<a id=XX_FUNCAO" & intCodSCAColaborador & "></a>")
					if ubound(vet9)>1 then
						for j=0 to ubound(vet9)-1
							%>
							XX_FUNCAO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strFuncao%>'
							<%
						next
					else
						%>
						XX_FUNCAO<%=intCodSCAColaborador%>.innerHTML = '<%=strFuncao%>'
						<%
					end if
				end if

				if trim(vetCampos(i)) = "DATAADIMISSAO" then 
					vet10 = split(strTextoDocumento,"<a id=XX_DATAADIMISSAO" & intCodSCAColaborador & "></a>")
					if ubound(vet10)>1 then
						for j=0 to ubound(vet10)-1
							%>
							XX_DATAADIMISSAO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strDataAdimissao%>'
							<%
						next
					else
						%>
						XX_DATAADIMISSAO<%=intCodSCAColaborador%>.innerHTML = '<%=strDataAdimissao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATAAFASTAMENTO" then 
					vet11 = split(strTextoDocumento,"<a id=DATAAFASTAMENTO" & intCodSCAColaborador & "></a>")
					if ubound(vet11)>1 then
						for j=0 to ubound(vet11)-1
							%>
							XX_DATAAFASTAMENTO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strDatafastamento%>'
							<%
						next
					else
						%>
						XX_DATAAFASTAMENTO<%=intCodSCAColaborador%>.innerHTML = '<%=strDatafastamento%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "FORMANOMEACAO" then 
					vet22 = split(strTextoDocumento,"<a id=XX_FORMANOMEACAO" & intCodSCAColaborador & "></a>")
					if ubound(vet22)>1 then
						for j=0 to ubound(vet22)-1
							%>
							XX_FORMANOMEACAO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strFormaNomeacao%>'
							<%
						next
					else
						%>
						XX_FORMANOMEACAO<%=intCodSCAColaborador%>.innerHTML = '<%=strFormaNomeacao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "NIVEL" then 
					vet22 = split(strTextoDocumento,"<a id=XX_NIVEL" & intCodSCAColaborador & "></a>")
					if ubound(vet22)>1 then
						for j=0 to ubound(vet22)-1
							%>
							XX_NIVEL<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strNivel%>'
							<%
						next
					else
						%>
						XX_NIVEL<%=intCodSCAColaborador%>.innerHTML = '<%=strNivel%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "TURNO" then 
					vet23 = split(strTextoDocumento,"<a id=XX_TURNO" & intCodSCAColaborador & "></a>")
					if ubound(vet23)>1 then
						for j=0 to ubound(vet23)-1
							%>
							XX_TURNO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strTurno%>'
							<%
						next
					else
						%>
						XX_TURNO<%=intCodSCAColaborador%>.innerHTML = '<%=strTurno%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "HORASCONTRATADA" then 
					vet24 = split(strTextoDocumento,"<a id=XX_HORASCONTRATADA" & intCodSCAColaborador & "></a>")
					if ubound(vet24)>1 then
						for j=0 to ubound(vet24)-1
							%>
							XX_HORASCONTRATADA<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strHorasContratada%>'
							<%
						next
					else
						%>
						XX_HORASCONTRATADA<%=intCodSCAColaborador%>.innerHTML = '<%=strHorasContratada%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "AULASCONTRATADA" then 
					vet25 = split(strTextoDocumento,"<a id=XX_AULASCONTRATADA" & intCodSCAColaborador & "></a>")
					if ubound(vet25)>1 then
						for j=0 to ubound(vet25)-1
							%>
							XX_AULASCONTRATADA<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strAulasContratada%>'
							<%
						next
					else
						%>
						XX_AULASCONTRATADA<%=intCodSCAColaborador%>.innerHTML = '<%=strAulasContratada%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DATALOTACAO" then 
					vet27 = split(strTextoDocumento,"<a id=XX_DATALOTACAO" & intCodSCAColaborador & "></a>")
					if ubound(vet27)>1 then
						for j=0 to ubound(vet27)-1
							%>
							XX_DATALOTACAO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strDataLotacao%>'
							<%
						next
					else
						%>
						XX_DATALOTACAO<%=intCodSCAColaborador%>.innerHTML = '<%=strDataLotacao%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "REGENCIA" then 
					vet27 = split(strTextoDocumento,"<a id=XX_REGENCIA" & intCodSCAColaborador & "></a>")
					if ubound(vet27)>1 then
						for j=0 to ubound(vet27)-1
							%>
							XX_REGENCIA<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strRegencia%>'
							<%
						next
					else
						%>
						XX_REGENCIA<%=intCodSCAColaborador%>.innerHTML = '<%=strRegencia%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "OBSERVACOES" then 
					vet27 = split(strTextoDocumento,"<a id=XX_OBSERVACOES" & intCodSCAColaborador & "></a>")
					if ubound(vet27)>1 then
						for j=0 to ubound(vet27)-1
							%>
							XX_OBSERVACOES<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strObservacoes%>'
							<%
						next
					else
						%>
						XX_OBSERVACOES<%=intCodSCAColaborador%>.innerHTML = '<%=strObservacoes%>'
						<%
					end if
				end if

				if trim(vetCampos(i)) = "CIDADE" then 
	
					vet12 = split(strTextoDocumento,"<a id=XX_CIDADE" & intCodSCAColaborador & "></a>")
					if ubound(vet12)>1 then
						for j=0 to ubound(vet12)-1
							%>
							XX_CIDADE<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strCidade%>'
							<%
						next
					else
						%>
						XX_CIDADE<%=intCodSCAColaborador%>.innerHTML = '<%=strCidade%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DIA" then 
					
					vet13 = split(strTextoDocumento,"<a id=XX_DIA" & intCodSCAColaborador & "></a>")
					if ubound(vet13)>1 then
						for j=0 to ubound(vet13)-1
							%>
							XX_DIA<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strDia%>'
							<%
						next
					else
						%>
						XX_DIA<%=intCodSCAColaborador%>.innerHTML = '<%=strDia%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "MES" then 
					vet14 = split(strTextoDocumento,"<a id=XX_MES" & intCodSCAColaborador & "></a>")
					if ubound(vet14)>1 then
						for j=0 to ubound(vet14)-1
							%>
							XX_MES<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strMes%>'
							<%
						next
					else
						%>
						XX_MES<%=intCodSCAColaborador%>.innerHTML = '<%=strMes%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "ANO" then 
					vet15 = split(strTextoDocumento,"<a id=XX_ANO" & intCodSCAColaborador & "></a>")
					if ubound(vet15)>1 then
						for j=0 to ubound(vet15)-1
							%>
							XX_ANO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strAno%>'
							<%
						next
					else
						%>
						XX_ANO<%=intCodSCAColaborador%>.innerHTML = '<%=strAno%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "DIRETOR" then 
					vet17 = split(strTextoDocumento,"<a id=XX_DIRETOR" & intCodSCAColaborador & "></a>")
					if ubound(vet17)>1 then
						for j=0 to ubound(vet17)-1
							%>
							XX_DIRETOR<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strDiretor%>'
							<%
						next
					else
						%>
						XX_DIRETOR<%=intCodSCAColaborador%>.innerHTML = '<%=strDiretor%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SECRETARIO" then 
					vet16 = split(strTextoDocumento,"<a id=XX_SECRETARIO" & intCodSCAColaborador & "></a>")
					if ubound(vet16)>1 then
						for j=0 to ubound(vet16)-1
							%>
							XX_SECRETARIO<%=intCodSCAColaborador%>O[<%=j%>].innerHTML = '<%=strSecretario%>'
							<%
						next
					else
						%>
						XX_SECRETARIO<%=intCodSCAColaborador%>.innerHTML = '<%=strSecretario%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SITUACAO" then 
					vet17 = split(strTextoDocumento,"<a id=XX_SITUACAO" & intCodSCAColaborador & "></a>")
					if ubound(vet17)>1 then
						for j=0 to ubound(vet17)-1
							%>
							XX_SITUACAO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strSituacaoCadastral%>'
							<%
						next
					else
						%>
						XX_SITUACAO<%=intCodSCAColaborador%>.innerHTML = '<%=strSituacaoCadastral%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "PERIODOLETIVO" then 
					vet28 = split(strTextoDocumento,"<a id=XX_PERIODOLETIVO" & intCodSCAColaborador & "></a>")
					if ubound(vet28)>1 then
						for j=0 to ubound(vet28)-1
							%>
							XX_PERIODOLETIVO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strPERIODOLETIVO%>'
							<%
						next
					else
						%>
						XX_PERIODOLETIVO<%=intCodSCAColaborador%>.innerHTML = '<%=strPERIODOLETIVO%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "SEMESTRE" then 
					vet28 = split(strTextoDocumento,"<a id=XX_SEMESTRE" & intCodSCAColaborador & "></a>")
					if ubound(vet28)>1 then
						for j=0 to ubound(vet28)-1
							%>
							XX_SEMESTRE<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strSemestre%>'
							<%
						next
					else
						%>
						XX_SEMESTRE<%=intCodSCAColaborador%>.innerHTML = '<%=strSemestre%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "QUINQUENIO" then 
					vet28 = split(strTextoDocumento,"<a id=XX_QUINQUENIO" & intCodSCAColaborador & "></a>")
					if ubound(vet28)>1 then
						for j=0 to ubound(vet28)-1
							%>
							XX_QUINQUENIO<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strQuinquenio%>'
							<%
						next
					else
						%>
						XX_QUINQUENIO<%=intCodSCAColaborador%>.innerHTML = '<%=strQuinquenio%>'
						<%
					end if
				end if
				if trim(vetCampos(i)) = "AULASCUMPRIDA" then 
					vet28 = split(strTextoDocumento,"<a id=XX_AULASCUMPRIDA" & intCodSCAColaborador & "></a>")
					if ubound(vet28)>1 then
						for j=0 to ubound(vet28)-1
							%>
							XX_AULASCUMPRIDA<%=intCodSCAColaborador%>[<%=j%>].innerHTML = '<%=strAulasCumprida%>'
							<%
						next
					else
						%>
						XX_AULASCUMPRIDA<%=intCodSCAColaborador%>.innerHTML = '<%=strAulasCumprida%>'
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
			mostraDocumento<%=intCodSCAColaborador%>();
		</script>
		<%
		strTodosOsCampos 	= ""
		strTituloRelatorio 	= ""
		strTextoDocumento 	= ""

		strMatricula		= "XXXXXXXXX"
		strDataNascimento		= "XX/XX/XXXX"
		strCidadeNascimento		= "XXXXXXXXXXXXXX"
		strUfNascimento		= "XX"
		strIdentidade		= "XXXXXXXXXX"
		strCpf		= "XXXXXXXXXX"
		strTitulo		= "XXXXXXXXXX"
		strEstadoCivil		= "XXXXXXXXXXXXXXXXX"
		strPai		= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		strMae		= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		strNacionalidade		= "XXXXXXXXXXXXXXXXXXXXXXXX"
		strEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
		strNumeroEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
		strCompEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
		strBairroEndereco		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
	'---
		strCargo		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
		strFuncao		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
		strDataAdimissao		= "XX/XX/XXXXX"
		strDatafastamento		= "XX/XX/XXXXX"
		strFormaNomeacao		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
		strNivel		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
		strTurno		= "XXXXXXXXXXXXXXXXXX"
		strHorasContratada		= "XXXX"
		strAulasContratada		= "XXXX"
		strDataLotacao		= "XX/XX/XXXXX"
		strRegencia		= "XXXXXXXXXXXXXXXXXX"
		strObservacoes		= "XXXXXXXXXXXXXXXXXXXXXXXXXX"
		strSituacaoCadastral	= "XXXXXXXX"
		strPERIODOLETIVO	= "XXXX"
		strSemestre		= "X"
		strQuinquenio		= "XXXX"
		strAulasCumprida	= "XXXX"


	next
	%>
    <script>
        aguarde.style.display="none";
    </script>
</body>
</html>
