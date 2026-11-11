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
<title><%=session("Titulo")%> - Alunos Por Turma</title>
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
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%

	dim intPagina

	strMes						= Trim(Request.Form("cmbMes"))
	strIdadeInformada   		= Trim(Request.Form("cmbIdade"))
	strOpcaoRelatorio			= Trim(Request.Form("optOpcao"))
	intCodModeloEtiqueta		= Trim(Request.Form("cmbModeloEtiqueta"))
	strSituacao					= Trim(Request.Form("cmbSituacao"))	
	intCodCategoria				= Trim(Request.Form("cmbCategoria"))	
	intCodDepartamento			= Trim(Request.Form("cmbDepartamento"))
	strClassificacao			= request.Form("cmbClassificacao")
	intCodCargo 	    		= TRIM(Request.Form("cmbCargo"))
	intCodFuncao 	   		 	= TRIM(Request.Form("cmbFuncao"))
	intCodGrauInstrucao			= Trim(Request.Form("cmbGrauInstrucao"))	
	intcodLotacao 	    		= TRIM(Request.Form("cmbLotacao"))
	intCodFormaNomeacao 		= TRIM(Request.Form("cmbFormaNomeacao"))
	intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
	
	campo1			= Trim(Request.Form("cmbCampo1"))
	campo2			= Trim(Request.Form("cmbCampo2"))
	campo3			= Trim(Request.Form("cmbCampo3"))
	campo4			= Trim(Request.Form("cmbCampo4"))
	campo5			= Trim(Request.Form("cmbCampo5"))
	campo6			= Trim(Request.Form("cmbCampo6"))

	strModeloEtiqueta			= Trim(Request.Form("cmbModeloEtiqueta"))
	if trim(strModeloEtiqueta) <> "0" then
		sql = "SELECT coluna, linha, tamanhoHorizontal, tamanhoVertical, espaco"
		sql = sql & " FROM SCA_MODELO_ETIQUETA "
		SQL = SQL & " WHERE	cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND 	codigo= " & strModeloEtiqueta
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			linhaPorPagina 		= rs("linha")
			colunaPorPagina 	= rs("coluna")
			tamanhoHorizontal 	= rs("tamanhoHorizontal")
			tamanhoVertical 	= rs("tamanhoVertical")
			espaco 				= rs("espaco")
		END IF
		rs.close
	end if

	tamanho_espaco=""
	for i=1 to espaco
	   tamanho_espaco = tamanho_espaco & "&nbsp;"
    next
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	cont = 0
	sql = ""
	if strOpcaoRelatorio = "1" then
		sql = " SET NOCOUNT ON "
		sql = sql & " SELECT DISTINCT CODIGO AS COD_COLABORADOR, "
		sql = sql & " CASE WHEN DATEPART(MONTH,DATA_NASCIMENTO)<= DATEPART(MONTH,GETDATE()) AND DATEPART(DAY,DATA_NASCIMENTO)<= DATEPART(DAY,GETDATE()) "
		sql = sql & "    THEN (DATEDIFF(YEAR,DATA_NASCIMENTO,GETDATE())) "
		sql = sql & "    ELSE (DATEDIFF(YEAR,DATA_NASCIMENTO,GETDATE()))- 1 "
		sql = sql & " END AS IDADEATUAL "
		sql = sql & " INTO #TEMP "
		sql = sql & " FROM SRH_COLABORADOR "
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		if strMes <> "0" then
		   sql = sql & " AND MONTH(DATA_NASCIMENTO) = " & strMes
		end if  
		if strIdadeInformada <> "0" then 
			sql = sql & " AND CASE WHEN DATEPART(MONTH,DATA_NASCIMENTO)<= DATEPART(MONTH,GETDATE()) AND DATEPART(DAY,DATA_NASCIMENTO)<= DATEPART(DAY,GETDATE()) "
			sql = sql & "        THEN (DATEDIFF(YEAR,DATA_NASCIMENTO,GETDATE())) "
			sql = sql & "        ELSE (DATEDIFF(YEAR,DATA_NASCIMENTO,GETDATE()))- 1 "
		    sql = sql & "     END  >= " & strIdadeInformada
		end if	
	end if	

    if strOpcaoRelatorio = "2" then       'Para Filtrar somente os alunos que devem documentos
	   	sql = " SET NOCOUNT ON "
	   	sql = sql & " SELECT DISTINCT CODIGO AS COD_COLABORADOR "
	   	sql = sql & " INTO #TEMP "
	   	sql = sql & " FROM SRH_COLABORADOR_DOCUMENTACOES "
       	sql = sql & " WHERE (SITUACAO = 'I' OR SITUACAO IS NULL) "
	end if  
	
	sql = sql & " SELECT SRH_COLABORADOR.CODIGO, "'0
	sql = sql & " 'CÓDIGO FUNCIONAL: ' + cast(SRH_COLABORADOR.CODFUNCIONAL as varchar), "'1
	sql = sql & " SRH_COLABORADOR.NOME, "'2
	sql = sql & " SRH_COLABORADOR.FONERESIDENCIAL, "'3
	sql = sql & " SRH_COLABORADOR.FONECOMERCIAL , "'4
	sql = sql & " SRH_COLABORADOR.DATA_ADMISSAO, "'5
	sql = sql & " SRH_COLABORADOR.DATAFASTAMENTO, "'6
	sql = sql & " 'EMAIL: ' + SRH_COLABORADOR.EMAIL, "'7
	sql = sql & " SRH_COLABORADOR.NATURALIDADE, "'8
	sql = sql & " ISNULL(SRH_COLABORADOR.LOGRADOURO, '') + ', ' + ISNULL(SRH_COLABORADOR.COMP_ENDERECO, '') +' '+ ISNULL(SRH_COLABORADOR.NUMERO_LOGRADOURO,'') as logradouro, "'9
	sql = sql & " cast(SRH_COLABORADOR.BAIRRO as varchar) + ' - CEP:' + cast(SRH_COLABORADOR.CEP as varchar) as cepBairro, "'10
	sql = sql & " cast(CIDADE as varchar) + ' - ' + cast(SCF_UF.SIGLA as varchar) as cidadeUF "'11
	sql = sql & " FROM SRH_COLABORADOR "
	sql = sql & " INNER JOIN SCF_UF ON SCF_UF.CODIGO = SRH_COLABORADOR.UF"
	if (strOpcaoRelatorio = "1" or strOpcaoRelatorio = "2") then    'Para Filtrar somente os alunos conforme condição acima
	   sql = sql & " INNER JOIN #TEMP TMP ON TMP.COD_COLABORADOR = SRH_COLABORADOR.CODIGO  "
	end if   
	sql = sql & " where SRH_COLABORADOR.cod_empresa = " & session("CodEmpresa")
	if strSituacao <> "" and strSituacao <> "0" then
	   sql = sql & " AND SRH_COLABORADOR.SITUACAO	= '" & strSituacao & "'"
	end if 
	if intCodCategoria <> "" and intCodCategoria <> "0" then
	   sql = sql & " AND SRH_COLABORADOR.CODCATEGORIA	= " & intCodCategoria
	end if 
	if intCodDepartamento <> "" and intCodDepartamento <> "0" then
	   sql = sql & " AND SRH_COLABORADOR.CODDEPARTAMENTO	= " & intCodDepartamento
	end if
	if intCodCargo <> "" and intCodCargo <> "0" then
	   sql = sql & " AND SRH_COLABORADOR.CODCARGO	= " & intCodCargo
	end if
	if intCodFuncao <> "" and intCodFuncao <> "0" then
	   sql = sql & " AND SRH_COLABORADOR.CODFUNCAO= " & intCodFuncao
	end if
	if intCodGrauInstrucao <> "" and intCodGrauInstrucao <> "0" then
	   sql = sql & " AND SRH_COLABORADOR.CODGRAUINSTRUCAO= " & intCodGrauInstrucao
	end if
	if intcodLotacao <> "" and intcodLotacao <> "0" then
	   sql = sql & " AND SRH_COLABORADOR.CODLOTACAO= " & intcodLotacao
	end if
	if intCodFormaNomeacao <> "" and intCodFormaNomeacao <> "0" then
	   sql = sql & " AND SRH_COLABORADOR.CODFORMANOMEACAO= " & intCodFormaNomeacao
	end if
	'ordem de classificação do relatorio
	if strClassificacao = "COD" then
	  sql = sql & " Order By SRH_COLABORADOR.CODIGO"
	elseif strClassificacao = "MAT" then
	  sql = sql & " Order By SRH_COLABORADOR.CODFUNCIONAL"
	elseif strClassificacao = "NOM" then
	  sql = sql & " Order By SRH_COLABORADOR.NOME"
	elseif strClassificacao = "BAI" then
	  sql = sql & " Order By SRH_COLABORADOR.BAIRRO"
	elseif strClassificacao = "CID" then
	  sql = sql & " Order By SRH_COLABORADOR.CIDADE"
	end if
  	vetAlunos = null
	rs.open sql, cnn
	if not rs.eof then
		vetAlunos = rs.getRows
	end if
	rs.close

	if isArray(vetAlunos) then
		intPosicao = 0
		intPosicaoQuebra = 0
		registros = ubound(vetAlunos,2) 
		if registros = 0 then
		   registros = registros + 1
		end if  
		if registros = 1 then
		   colunaPorPagina = 1
		end if   
		totalLinhas = registros/colunaPorPagina
		if totalLinhas = 0 then 
		   totalLinhas = 1
		end if   
		if totalLinhas - int(totalLinhas) <> 0 then
		   totalLinhas = int(totalLinhas) + 1
		end if   
		
		%><table border="0" cellspacing="0" cellpadding="0"><%
		for linha=0 to totalLinhas-1
			%>
            <tr>
                <!-- inicio espaço -->
                <td height="<%=tamanhoVertical%>" width="8"></td>
                <!-- fim espaço -->
            <%
			for coluna=0 to colunaPorPagina -1

			    if coluna = 0 then
				   EspacoEntreEtiquetas = ""
				else
				   EspacoEntreEtiquetas = tamanho_espaco
				end if   
				   

				strCampo1 = ""
				strCampo2 = ""
				strCampo3 = ""	
				strCampo4 = ""	
				strCampo5 = ""
				strCampo6 = ""
				
				if campo1 <> "" then strCampo1 = vetAlunos(campo1,intPosicao)
				if campo2 <> "" then strCampo2 = vetAlunos(campo2,intPosicao)
				if campo3 <> "" then strCampo3 = vetAlunos(campo3,intPosicao)	
				if campo4 <> "" then strCampo4 = vetAlunos(campo4,intPosicao)	
				if campo5 <> "" then strCampo5 = vetAlunos(campo5,intPosicao)
				if campo6 <> "" then strCampo6 = vetAlunos(campo6,intPosicao)
				%>
                 <!-- inicio etiqueta -->
                <td height="<%=tamanhoVertical%>" width="<%=tamanhoHorizontal%>">
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo1%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo2%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo3%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo4%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo5%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=EspacoEntreEtiquetas%><%=strCampo6%>&nbsp;</NOBR></DIV>
                </td>
                <!-- fim etiqueta -->
                <!-- inicio espaço -->
                <td height="<%=tamanhoVertical%>" width="<%=espaco%>" ><img width="<%=espaco%>" src="../../images/espacoEtiqueta.jpg"></td>
                <!-- fim espaço -->
			<%
				intPosicao = intPosicao + 1
			next
			%></tr><%
				
			intPosicaoQuebra = intPosicaoQuebra + 1
			if cInt(linhaPorPagina) = cInt(intPosicaoQuebra) then
				intPosicaoQuebra = 0
				response.Write("</table><pre>&nbsp;</pre><table border='0' cellspacing='0' cellpadding='0'>")
			end if

		next
		%></table><% 
	else
		%>
		<script>
			alert("Nenhum registro foi encontrado para esse relatório!");
			window.navigate('Rel_Etiquetas_con.asp');
		</script>
		<%
	end if
	%>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
