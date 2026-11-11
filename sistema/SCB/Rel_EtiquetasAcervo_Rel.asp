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
<!--#include file="../../includes/inc_barcodeAcervo.asp"-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	
	intCodModeloEtiqueta	= Trim(Request.Form("cmbModeloEtiqueta"))
	intCodCdu				= Trim(Request.Form("txtCdu"))
	strValidar				= Trim(Request.Form("cmbValidar"))
	strCutter				= Trim(Request.Form("cmbCutter"))
	'intCodExemplares		= Trim(Request.Form("chkExemplares"))
	intCodExemplares		= session("strCodPublicacaoExemplares")
	
	if intCodExemplares = "" then
		%>
		<script>
			alert("ATENÇÃO: \n\nDeve ser selecionado exemplares para emissão.");
			window.history.back();
		</script>
		<%	
		response.End()
	end if	

	
	if trim(intCodModeloEtiqueta) <> "0" then
		sql = "SELECT coluna, linha, tamanhoHorizontal, tamanhoVertical, espaco"
		sql = sql & " FROM SCA_MODELO_ETIQUETA "
		SQL = SQL & " WHERE	cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND 	codigo= " & intCodModeloEtiqueta
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
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	cont = 0
	
	campo0			= "0"
	campo1			= "2"
	campo2			= "3"
	campo3			= "4"
	campo4			= "1"
	campo5			= "1"
	
	
	sql = " SELECT COUNT(COD_PUBLICACAOEXEMPLARES) AS TOTALREGISTROS FROM SCB_PUBLICACAOEXEMPLARES "
    sql = sql & " WHERE COD_PUBLICACAOEXEMPLARES in ( " & intCodExemplares & ")"
	rs.open sql, cnn
	if not rs.eof then
		registros = rs("TOTALREGISTROS")
	else
	   	registros = 0
	end if
	rs.close

   	sql = "SELECT "
   	sql = sql & " P.COD_PUBLICACAO, "
   	sql = sql & " PE.COD_PUBLICACAOEXEMPLARES, "
    if strCutter = "S" then
    	sql = sql & "' ' + P.COD_CDU + '   -   Cutter: ' + P.COD_CUTTER, "
	else	
	   	sql = sql & "' ' + P.COD_CDU, "
	end if	
  	sql = sql & "' / ' + LOWER(SUBSTRING(P.TITULO, 1,3)) AS REFERENCIA, "
   	sql = sql & "' ' + CONVERT(VARCHAR, P.EDICAOPUBLICACAO) + ' ed. - v. ' + CONVERT(VARCHAR, P.VOLUMEPUBLICACAO) + ' - ex. ' + CONVERT(VARCHAR, PE.NUMERO_EXEMPLAR) as Edicao, "
  	sql = sql & " E.RAZAOSOCIAL "
   	sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES PE "
   	sql = sql & " INNER JOIN SCB_PUBLICACAO P ON P.COD_PUBLICACAO = PE.COD_PUBLICACAO "
   	sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = P.COD_EMPRESA "
   	sql = sql & " WHERE P.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " AND ETIQUETA = 'N' "
  	sql = sql & " AND PE.COD_PUBLICACAOEXEMPLARES in ( " & intCodExemplares & ")"
   	sql = sql & " ORDER BY P.COD_CDU, PE.COD_PUBLICACAOEXEMPLARES "
	vetExemplares = null
	rs.open sql, cnn
	if not rs.eof then
		vetExemplares = rs.getRows
	end if
	rs.close

	
	if isArray(vetExemplares) then
		intPosicao = 0
		intPosicaoQuebra = 0
		'registros = ubound(vetExemplares,2)
		if registros = 0 then
		   registros = registros + 1
		end if   
		totalLinhas = registros/colunaPorPagina
		if totalLinhas = 0 then 
		   totalLinhas = 1
		end if   
		if totalLinhas - int(totalLinhas) <> 0 then
		   totalLinhas = int(totalLinhas) + 1
		end if   
		%> 
		<table border="0" cellspacing="0" cellpadding="0"> 
		<%
		for linha=0 to totalLinhas - 1
			%>
            <tr>
                <!-- inicio espaço -->
                <td height="<%=tamanhoVertical%>" width="8"></td>
                <!-- fim espaço -->
            <%
			for coluna=0 to colunaPorPagina -1
				
				strCampo0 = ""
				strCampo1 = ""
				strCampo2 = ""	
				strCampo3 = ""	
				strCampo4 = ""
				strCampo5 = ""

				if campo0 <> "" then strCampo0 = vetExemplares(campo0,intPosicao)
				if campo1 <> "" then strCampo1 = vetExemplares(campo1,intPosicao)
				if campo2 <> "" then strCampo2 = vetExemplares(campo2,intPosicao)	
				if campo3 <> "" then strCampo3 = vetExemplares(campo3,intPosicao)	
				if campo4 <> "" then strCampo4 = vetExemplares(campo4,intPosicao)
				if campo5 <> "" then strCampo5 = vetExemplares(campo5,intPosicao)

				sql = " SELECT DISTINCT "
				sql = sql & " PA.COD_AUTOR, A.NOME_AUTOR "
				sql = sql & " FROM  SCB_PUBLICACAOAUTORES PA "
				sql = sql & " INNER JOIN SCB_AUTORES A ON A.COD_AUTOR = PA.COD_AUTOR "
				sql = sql & " WHERE PA.COD_PUBLICACAO = " & strCampo0
				rsaux.OPEN SQL, CNN
				IF not rsaux.EOF THEN
					strCampo2 		= " " & mid(rsaux("NOME_AUTOR"),1,3) & strCampo2
				END IF
				rsaux.close

                TotalZeros = 10 - len(strcampo4)
				if TotalZeros < 0 then
				   TotalZeros = 0
                end if
				if TotalZeros = 1 then
				   	zeros = "0"
				elseif  TotalZeros = 2 then
				   	zeros = "00"
				elseif  TotalZeros = 3 then
				   	zeros = "000"
				elseif  TotalZeros = 4 then
				   	zeros = "0000"
				elseif  TotalZeros = 5 then
				   	zeros = "00000"
				elseif  TotalZeros = 6 then
				   	zeros = "000000"
				elseif  TotalZeros = 7 then
				   	zeros = "0000000"
				elseif  TotalZeros = 8 then
				   	zeros = "00000000"
				elseif  TotalZeros = 9 then
				   	zeros = "000000000"
				elseif  TotalZeros = 10 then
				   	zeros = "0000000000"
                end if
                 STRCAMPO4 = zeros & STRCAMPO4
                 STRCAMPO5 = zeros & STRCAMPO5
				 
				 if coluna = 0  then
				   	nbsp = "&nbsp;"
				 else	
				 	nbsp = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
				 end if 
				%>
                 <!-- inicio etiqueta -->
                <td height="<%=tamanhoVertical%>" width="<%=tamanhoHorizontal%>">
 
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=nbsp%><%=strCampo1%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=nbsp%><%=strCampo2%>&nbsp;</NOBR></DIV>
                    <DIV STYLE="left: color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR><%=nbsp%><%=strCampo3%>&nbsp;</NOBR></DIV>
                    <DIV align="center" STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=getCodigoBarras(strCampo4)%>&nbsp;</NOBR></DIV>
                    <DIV align="center" STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=strCampo5%>&nbsp;</NOBR></DIV>
                    <DIV align="center" STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR>&nbsp;&nbsp;&nbsp;</NOBR></DIV>
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
		       	response.Write("</table><pre>&nbsp;</pre><br><table border='0' cellspacing='0' cellpadding='0'>")	
			end if

		next
		%></table><% 
		
		if strValidar = "S" then
			sql = "UPDATE SCB_PUBLICACAOEXEMPLARES SET CONTROLE_ETIQUETAS = 'S' "
			sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES PE "
			sql = sql & " INNER JOIN SCB_PUBLICACAO P ON P.COD_PUBLICACAO = PE.COD_PUBLICACAO "
			sql = sql & " WHERE P.COD_EMPRESA = " & session("CodEmpresa")
			sql = sql & " AND ETIQUETA = 'N' "
			sql = sql & " AND PE.COD_PUBLICACAOEXEMPLARES in ( " & intCodExemplares & ")"
			cnn.execute sql
	    	GravarLog sql
			%>
			<script>
        		alert("Etiquetas Emitidas Validada com Sucesso!")
				window.history.back();
        	</script>
	   	 	<%
		end if	
	else
	%>
		<script>
        	alert("Nenhum registro foi encontrado para esse relatório!")
			window.history.back();
        </script>
	<%
	end if
	%>
	
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
