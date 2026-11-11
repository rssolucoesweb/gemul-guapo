<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
'server.ScriptTimeout = 5000
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->

<br>
<%
	dim intPagina
	dim strInfoTurma
	
	strFiltro01	 			= Trim(Request.Form("filtro01"))
	strFiltro02	 			= Trim(Request.Form("filtro02"))
	strFiltro03	 			= Trim(Request.Form("filtro03"))
	strFiltro04	 			= Trim(Request.Form("filtro04"))
	strFiltro05	 			= Trim(Request.Form("filtro05"))
	strFiltro06	 			= Trim(Request.Form("filtro06"))
	strFiltro07	 			= Trim(Request.Form("filtro07"))
	strFiltro08	 			= Trim(Request.Form("filtro08"))
	strFiltro09	 			= Trim(Request.Form("filtro09"))
	strFiltro10	 			= Trim(Request.Form("filtro10"))
	strFiltro11	 			= Trim(Request.Form("filtro11"))
	strFiltro12	 			= Trim(Request.Form("filtro12"))
	strFiltro13	 			= Trim(Request.Form("filtro13"))
	strFiltro14	 			= Trim(Request.Form("filtro14"))
	strFiltro15	 			= Trim(Request.Form("filtro15"))
	strFiltro16	 			= Trim(Request.Form("filtro16"))
	strFiltro17	 			= Trim(Request.Form("filtro17"))
	strFiltro18	 			= Trim(Request.Form("filtro18"))
	strFiltro19	 			= Trim(Request.Form("filtro19"))
	strFiltro20	 			= Trim(Request.Form("filtro20"))
	strFiltro21	 			= Trim(Request.Form("filtro21"))
	strFiltro22	 			= Trim(Request.Form("filtro22"))
	strFiltro23	 			= Trim(Request.Form("filtro23"))
	strFiltro24	 			= Trim(Request.Form("filtro24"))
	strFiltro25	 			= Trim(Request.Form("filtro25"))
	strFiltro26	 			= Trim(Request.Form("filtro26"))
	strFiltro27	 			= Trim(Request.Form("filtro27"))
	strFiltro28	 			= Trim(Request.Form("filtro28"))
	strFiltro29	 			= Trim(Request.Form("filtro29"))
	strFiltro30	 			= Trim(Request.Form("filtro30"))
	strFiltro31	 			= Trim(Request.Form("filtro31"))
	
	
	intCodLocalizacaoGeografica = Trim(Request.Form("cmbLocalizacaoGeografica"))	
	intCodAutoria			= Trim(Request.Form("cmbAutoria"))
	strAutor				= Trim(Request.Form("txtAutor"))
	strPalavraChave			= Trim(Request.Form("txtPalavraChave"))
	strTitulo				= Trim(Request.Form("txtTitulo"))
	strCdu					= Trim(Request.Form("txtCodCDU"))
	intCodTipoPublicacao	= Trim(Request.Form("cmbTipoPublicacao"))
	intCodCursoPrimeiraOpcao= Trim(Request.Form("cmbCursoPrimeiraOpcao"))
	strClassificacaoCurso 	= Trim(Request.Form("cmbClassificacaoCurso"))
	intCodAreaConhecimento 	= Trim(Request.Form("cmbAreaConhecimento"))
	strTipoRelatorio		= Trim(Request.Form("cmbTipoRelatorio"))
	if strTipoRelatorio = "" then strTipoRelatorio = "1"
	strClassificacao		= Trim(Request.Form("cmbClassificacao"))
	
	if intCodAreaConhecimento <> "0" then
		sql = "SELECT Nome_Conhecimento"
		sql = sql & " FROM SCB_AreaConhecimento"
		SQL = SQL & " WHERE Cod_Conhecimento=" & intCodAreaConhecimento
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strNomeAreaConhecimento  = "<BR> Área do Conhecimento: " & rs("Nome_Conhecimento")
		END IF
		rs.close
	end if	
	
	sql="SELECT C.DESCRICAO, G.DATAINICIOVIGENCIA, G.DATAFIMVIGENCIA"
	sql=sql & " FROM SCA_CURSO C"
	sql=sql & " INNER JOIN SCA_PERIODO P ON P.COD_CURSO = C.COD_CURSO AND P.COD_EMPRESA = C.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_PERIODO = P.COD_PERIODO AND G.COD_EMPRESA = P.COD_EMPRESA"
	sql=sql & " WHERE G.COD_EMPRESA = " & session("CodEmpresa")
	sql=sql & " AND C.COD_CURSO = " & intCodCursoPrimeiraOpcao
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoCurso 	 = trim(rs("DESCRICAO"))
	end if
	rs.close

    if strClassificacaoCurso = "B" then msgClassificacaoCurso = " B&aacute;sicas "
    if strClassificacaoCurso = "C" then msgClassificacaoCurso = " Complementares "
	
	strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Publica&ccedil;&otilde;es <br>" & msgClassificacaoCurso & strDescricaoCurso & strNomeAreaConhecimento

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  	<tr width="100%" bgcolor="#CCCCCC">
      	<td class="celula"><strong>Registro</strong></td>
        <%if trim(strTipoRelatorio) = "1" then %> 
      		<td class="celula"><strong>Exemplar</strong></td>
 		<%end if%>  
      	<td class="celula"><strong>T&iacute;tulo</strong></td>
        
		<%if trim(strFiltro01) = "S" then %> 
	         <td class="celula"><strong>Tipo de Publica&ccedil;&atilde;o </strong></td>
		<%end if%>  
	    <%if trim(strFiltro02) = "S" then %> 
	  		<td  class="celula"><strong>Autoria</strong></td>
		<%end if%>  
	    <%if trim(strFiltro03) = "S" then %> 
			<td class="celula"><strong>Editora </strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro04) = "S" then %> 
			<td class="celula"><strong>C.D.U</strong></td>
		<%end if%>  
	    <%if trim(strFiltro05) = "S" then %> 
			<td class="celula"><strong>Periodicidade</strong></td>
		<%end if%>  
	    <%if trim(strFiltro06) = "S" then %> 
			<td class="celula"><strong>Autores</strong></td>
		<%end if%>  
	    <%if trim(strFiltro07) = "S" then %> 
			<td class="celula"><strong>Palavras Chaves </strong></td>
		<%end if%>  
	    <%if trim(strFiltro08) = "S" then %> 
			<td class="celula"><strong>Sub-T&iacute;tulo</strong></td>
		<%end if%>  
	    <%if trim(strFiltro09) = "S" then %> 
			<td class="celula"><strong>Local de Pub.</strong></td>
		    <%end if%>  
	    <%if trim(strFiltro10) = "S" then %> 
			<td class="celula"><strong>Ano de Pub. </strong></td>
		<%end if%>  
	    <%if trim(strFiltro11) = "S" then %> 
			<td class="celula"><strong>Edição </strong></td>
		<%end if%>  
	    <%if trim(strFiltro12) = "S" then %> 
			<td class="celula"><strong>Volume</strong></td>
		<%end if%>  
	    <%if trim(strFiltro13) = "S" then %> 
		<td class="celula"><strong>ISBN</strong></td>
		<%end if%>  
        <%if trim(strFiltro14) = "S" then %> 
			<td class="celula"><strong>Data de Inclusão </strong></td>
		<%end if%>  
	    <%if trim(strFiltro15) = "S" then %> 
			<td class="celula"><strong>Gerar Etiquetas</strong></td>
		<%end if%>  
	    <%if trim(strFiltro16) = "S" then %> 
			<td class="celula"><strong>Páginas</strong></td>
		<%end if%>  
	    <%if trim(strFiltro17) = "S" then %> 
            <td class="celula"><strong>Origem </strong></td>
		<%end if%>  
	    <%if trim(strFiltro18) = "S" then %> 
			<td class="celula"><strong>Destino</strong></td>
		<%end if%>  
	    <%if trim(strFiltro19) = "S" then %> 
			<td class="celula"><strong>Resumo</strong></td>
		<%end if%>  
	    <%if trim(strFiltro20) = "S" then %> 
			<td class="celula"><strong>Bloquear Exemplar</strong></td>
		<%end if%>  
	    <%if trim(strFiltro22) = "S" then %> 
			<td class="celula"><strong>Data do Contrato</strong></td>
		<%end if%>  
	    <%if trim(strFiltro23) = "S" then %> 
			<td class="celula"><strong>Contato</strong></td>
		<%end if%>  
	    <%if trim(strFiltro24) = "S" then %> 
			<td class="celula"><strong>Endereço</strong></td>
		<%end if%>  
	    <%if trim(strFiltro25) = "S" then %> 
			<td class="celula"><strong>Bairro</strong></td>
		<%end if%>  
	    <%if trim(strFiltro26) = "S" then %> 
			<td class="celula"><strong>Cidade</strong></td>
		<%end if%>  
	    <%if trim(strFiltro27) = "S" then %> 
			<td class="celula"><strong>UF</strong></td>
		<%end if%>  
	    <%if trim(strFiltro28) = "S" then %> 
			<td class="celula"><strong>CEP</strong></td>
		<%end if%>  
	    <%if trim(strFiltro29) = "S" then %> 
			<td class="celula"><strong>Número</strong></td>
		<%end if%>  
	    <%if trim(strFiltro30) = "S" then %> 
			<td class="celula"><strong>Email</strong></td>
		<%end if%>  
        <td class="celula">Total</td> 
 	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	TotalGeral = 0
    TotalExemplares	= 0
	intQtdeRegistroPorPagina = 0
	
	if strTipoRelatorio = "1" then 

		sql = "SELECT " 
		sql = sql & " P.COD_PUBLICACAO, "
		sql = sql & " PE.Cod_Publicacaoexemplares, "  
		sql = sql & " P.Titulo, " 
		if trim(strFiltro01) = "S" then 
			sql = sql & " TP.Nome_TipoPublicacao, "  
		end if	
		if trim(strFiltro02) = "S" then 
			sql = sql & " AU.Nome_autoria, " 
		end if	 
		if trim(strFiltro03) = "S" then 
			sql = sql & " EDI.Nome_Editora, "
		end if	  
		if trim(strFiltro04) = "S" then 
			sql = sql & " P.Cod_CDU, "
		end if	
		if trim(strFiltro05) = "S" then 
			sql = sql & " PER.Nome_Periodicidade,"  
		end if
		'Autor 6
		'Palavra Chave 7
		if trim(strFiltro08) = "S" then 
			sql = sql & " P.SubTitulo, "  
		end if	
		if trim(strFiltro09) = "S" then 
			sql = sql & " P.LocalPublicacao, " 
		end if
		if trim(strFiltro10) = "S" then 
			sql = sql & " P.AnoPublicacao, "  
		end if	
		if trim(strFiltro11) = "S" then 
			sql = sql & " P.EdicaoPublicacao, "  
		end if	
		if trim(strFiltro12) = "S" then 
			sql = sql & " P.VolumePublicacao, " 
		end if	
		if trim(strFiltro13) = "S" then 
			sql = sql & " P.ISBN, "  
		end if	
		if trim(strFiltro14) = "S" then 
			sql = sql & " P.DataInclusao, "  
		end if	
		if trim(strFiltro15) = "S" then 
			sql = sql & " P.Etiqueta, "  
		end if	
		if trim(strFiltro16) = "S" then 
			sql = sql & " P.NumPaginas, " 
		end if	 
		if trim(strFiltro17) = "S" then 
			sql = sql & " P.Origem, " 
		end if	
		if trim(strFiltro18) = "S" then 
			sql = sql & " P.Destino, "  
		end if	
		if trim(strFiltro19) = "S" then 
			sql = sql & " P.Resumo, " 
		end if	
		if trim(strFiltro20) = "S" then 
			sql = sql & " P.BloqueiaUltimoExemplar, " 
		end if	
		if trim(strFiltro22) = "S" then 
			sql = sql & " P.DataContrato, "
		end if	  
		if trim(strFiltro23) = "S" then 
			sql = sql & " P.Contato, "
		end if	  
		if trim(strFiltro24) = "S" then 
			sql = sql & " P.Endereco, "
		end if	  
		if trim(strFiltro25) = "S" then 
			sql = sql & " P.Bairro, " 
		end if	 
		if trim(strFiltro26) = "S" then 
			sql = sql & " P.Cidade, "  
		end if	
		if trim(strFiltro27) = "S" then 
			sql = sql & " P.UF, "  
		end if	
		if trim(strFiltro28) = "S" then 
			sql = sql & " P.CEP, " 
		end if	 
		if trim(strFiltro29) = "S" then 
			sql = sql & " P.Numero, "  
		end if	
		if trim(strFiltro06) = "S" then 
			sql = sql & " (SELECT TOP 1 AU.NOME_AUTOR FROM SCB_PUBLICACAOAUTORES PB INNER JOIN SCB_AUTORES AU ON AU.COD_AUTOR = PB.COD_AUTOR WHERE PB.COD_PUBLICACAO = P.COD_PUBLICACAO ) AS Autor , " 
		end if	
		sql = sql & " P.Email "
		
	elseif strTipoRelatorio = 2 then 
		
		sql = "SELECT " 
		sql = sql & " P.COD_PUBLICACAO, "
		sql = sql & " P.Titulo, " 
		if trim(strFiltro01) = "S" then 
			sql = sql & " TP.Nome_TipoPublicacao, "  
		end if	
		if trim(strFiltro02) = "S" then 
			sql = sql & " AU.Nome_autoria, " 
		end if	 
		if trim(strFiltro03) = "S" then 
			sql = sql & " EDI.Nome_Editora, "
		end if	  
		if trim(strFiltro04) = "S" then 
			sql = sql & " P.Cod_CDU, "
		end if	
		if trim(strFiltro05) = "S" then 
			sql = sql & " PER.Nome_Periodicidade, "  
		end if
		'Autor 6
		'Palavra Chave 7
		if trim(strFiltro08) = "S" then 
			sql = sql & " P.SubTitulo, "  
		end if	
		if trim(strFiltro09) = "S" then 
			sql = sql & " P.LocalPublicacao, " 
		end if
		if trim(strFiltro10) = "S" then 
			sql = sql & " P.AnoPublicacao, "  
		end if	
		if trim(strFiltro11) = "S" then 
			sql = sql & " P.EdicaoPublicacao, "  
		end if	
		if trim(strFiltro12) = "S" then 
			sql = sql & " P.VolumePublicacao, " 
		end if	
		if trim(strFiltro13) = "S" then 
			sql = sql & " P.ISBN, "  
		end if	
		if trim(strFiltro14) = "S" then 
			sql = sql & " P.DataInclusao, "  
		end if	
		if trim(strFiltro15) = "S" then 
			sql = sql & " P.Etiqueta, "  
		end if	
		if trim(strFiltro16) = "S" then 
			sql = sql & " P.NumPaginas, " 
		end if	 
		if trim(strFiltro17) = "S" then 
			sql = sql & " P.Origem, " 
		end if	
		if trim(strFiltro18) = "S" then 
			sql = sql & " P.Destino, "  
		end if	
		if trim(strFiltro19) = "S" then 
			sql = sql & " P.Resumo, " 
		end if	
		if trim(strFiltro20) = "S" then 
			sql = sql & " P.BloqueiaUltimoExemplar, " 
		end if	
		if trim(strFiltro22) = "S" then 
			sql = sql & " P.DataContrato, "
		end if	  
		if trim(strFiltro23) = "S" then 
			sql = sql & " P.Contato, "
		end if	  
		if trim(strFiltro24) = "S" then 
			sql = sql & " P.Endereco, "
		end if	  
		if trim(strFiltro25) = "S" then 
			sql = sql & " P.Bairro, " 
		end if	 
		if trim(strFiltro26) = "S" then 
			sql = sql & " P.Cidade, "  
		end if	
		if trim(strFiltro27) = "S" then 
			sql = sql & " P.UF, "  
		end if	
		if trim(strFiltro28) = "S" then 
			sql = sql & " P.CEP, " 
		end if	 
		if trim(strFiltro29) = "S" then 
			sql = sql & " P.Numero, "  
		end if	
		if trim(strFiltro30) = "S" then 
			sql = sql & " P.Email "
		end if	 
		if trim(strFiltro06) = "S" then 
			sql = sql & " (SELECT TOP 1 AU.NOME_AUTOR FROM SCB_PUBLICACAOAUTORES PB INNER JOIN SCB_AUTORES AU ON AU.COD_AUTOR = PB.COD_AUTOR WHERE PB.COD_PUBLICACAO = P.COD_PUBLICACAO ) AS Autor , " 
		end if	
		sql = sql & " COUNT(P.COD_PUBLICACAO) as Total "
	
	end if
	
	sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES PE " 
	sql = sql & " INNER JOIN SCB_PUBLICACAO P ON P.COD_PUBLICACAO = PE.COD_PUBLICACAO " 
	sql = sql & " LEFT JOIN SCB_AUTORIA AU ON AU.COD_AUTORIA =  P.COD_AUTORIA " 
	sql = sql & " LEFT JOIN SCB_PERIODICIDADE PER ON PER.COD_PERIODICIDADE =  P.COD_PERIODICIDADE " 
	sql = sql & " LEFT JOIN SCB_TIPOPUBLICACAO TP ON TP.Cod_TipoPublicacao =  P.Cod_TipoPublicacao " 
	sql = sql & " LEFT JOIN SCB_Editoras EDI ON EDI.Cod_Editora =  P.Cod_Editora " 
	sql = sql & " LEFT JOIN SCB_CDU CDU ON CDU.Cod_cdu = P.Cod_CDU "

    if intCodCursoPrimeiraOpcao <> "0" then ' Filtro do curso 
		sql = sql & " INNER JOIN SCB_PUBLICACAOCURSO PCUR ON PCUR.COD_PUBLICACAO = P.COD_PUBLICACAO AND P.COD_EMPRESA = PCUR.COD_EMPRESA and PCUR.COD_CURSO = " & intCodCursoPrimeiraOpcao & " AND PCUR.Classificacao <> '' "
    end if

	sql = sql & " WHERE P.COD_EMPRESA = " & session("CodEmpresa") 
	if intCodAutoria <> 0 then
		sql = sql & " and  P.Cod_Autoria = " & intCodAutoria
	end if
	
	if strTitulo <> "" then
		sql = sql & " and P.Titulo LIKE '%" & strTitulo & "%'"
	end if
	
	if intCodLocalizacaoGeografica <> "0" then
		sql = sql & " and P.Cod_LocalizacaoGeografica = " & intCodLocalizacaoGeografica & ""
	end if

	if intCodAreaConhecimento <> "0" then
		sql = sql & " and CDU.Cod_AreaConhecimento = " & intCodAreaConhecimento & ""
	end if

	if intCodTipoPublicacao <> "0" then
		sql = sql & " and P.Cod_TipoPublicacao = " & intCodTipoPublicacao & ""
	end if
	
	if strCdu <> "" then
		sql = sql & " AND SUBSTRING(P.Cod_Cdu,1," & len(strCdu) & " ) = '" & strCdu & "'" 
	end if
    if intCodCursoPrimeiraOpcao <> "0" then ' Filtro do curso
	   sql = sql & " and PCUR.Classificacao = '" & strClassificacaoCurso & "'"
    end if

	if trim(strAutor) <> "" or trim(strPalavraChave) <> "" then
	
		sql = sql & " and PE.Cod_PublicacaoExemplares in "
		sql = sql & " ("
		sql = sql & " 	select	distinct E.Cod_PublicacaoExemplares "
		sql = sql & " 	from	SCB_PUBLICACAO PP"
		sql = sql & " 	inner	join SCB_PUBLICACAOAUTORES PA		on P.cod_publicacao		= PA.cod_publicacao"
		sql = sql & " 	inner	join SCB_Autores A					on A.Cod_Autor			= PA.Cod_Autor and A.cod_empresa = PP.cod_empresa"
		sql = sql & " 	inner	join SCB_PUBLICACAOEXEMPLARES E		on PP.Cod_Publicacao		= E.Cod_Publicacao"
		sql = sql & " 	inner	join SCB_PUBLICACAOPALAVRACHAVE PPC on PPC.Cod_Publicacao	= PP.Cod_Publicacao "
		sql = sql & " 	inner	join SCB_PALAVRACHAVE PC			on PC.Cod_Palavra		= PPC.Cod_PalavraChave and PC.cod_empresa = P.cod_empresa"
		sql = sql & " 	where	1=1"
		sql = sql & " 	and		PP.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " 	and		E.Cod_TipoUsuario is null "
		
		if strAutor <> "" then
			sql = sql & " and A.Nome_Autor LIKE '%" & strAutor & "%'"
		end if
		
		if strPalavraChave <> "" then
			sql = sql & " and PC.Nome_Palavra LIKE '%" & strPalavraChave & "%'"
		end if
		
		sql = sql & " )"
	
	end if
	
	if strTipoRelatorio = 2 then 
	
		sql = sql & " Group by "
		sql = sql & " P.COD_PUBLICACAO, "
		sql = sql & " P.Titulo, " 
		sql = sql & " TP.Nome_TipoPublicacao, "  
		sql = sql & " AU.Nome_autoria, "  
		sql = sql & " EDI.Nome_Editora, "  
		sql = sql & " P.Cod_CDU, "  
		sql = sql & " PER.Nome_Periodicidade, "  
		sql = sql & " P.SubTitulo, "  
		sql = sql & " P.LocalPublicacao, " 
		sql = sql & " P.AnoPublicacao, "  
		sql = sql & " P.EdicaoPublicacao, "  
		sql = sql & " P.VolumePublicacao, " 
		sql = sql & " P.ISBN, "  
		sql = sql & " P.DataInclusao, "  
		sql = sql & " P.Etiqueta, "  
		sql = sql & " P.NumPaginas, "  
		sql = sql & " P.Origem, " 
		sql = sql & " P.Destino, "  
		sql = sql & " P.Resumo, " 
		sql = sql & " P.BloqueiaUltimoExemplar, " 
		sql = sql & " P.DataContrato, "  
		sql = sql & " P.Contato, "  
		sql = sql & " P.Endereco, "  
		sql = sql & " P.Bairro, "  
		sql = sql & " P.Cidade, "  
		sql = sql & " P.UF, "  
		sql = sql & " P.CEP, "  
		sql = sql & " P.Numero, "  
		sql = sql & " P.Email, " 
		sql = sql & " P.COD_PUBLICACAO "
	
	end if
	if strClassificacao = "TIT" then
	   sql = sql & " order by P.Titulo "
	elseif strClassificacao = "CDU" then
	   sql = sql & " order by P.Cod_CDU "
	elseif strClassificacao = "TITCDU" then
	   sql = sql & " order by P.Titulo, P.Cod_CDU "
	end if
	rs.open sql, cnn
	if not rs.eof then 
	
	   	While not rs.eof 

			strDescAutor	 = ""  
			strDescPalavra	 = ""  
			%> 
			<tr>
			<td class="celula">&nbsp;<%=TRIM(rs("Cod_Publicacao"))%></td>
			<%if trim(strTipoRelatorio) = 1 then %> 
			<td class="celula">&nbsp;<%=TRIM(rs("Cod_Publicacaoexemplares"))%></td>
			<%end if%>  
			<td class="celula"><%=TRIM(rs("Titulo"))%></td>
			<%
			if trim(strFiltro01) = "S" then %> 
			<td class="celula">&nbsp;<%=TRIM(rs("Nome_TipoPublicacao"))%></td>
			<%end if%>  
			<%if trim(strFiltro02) = "S" then %> 
			<td class="celula">&nbsp;<%=rs("Nome_Autoria")%></td>
			<%end if%>  
			<%if trim(strFiltro03) = "S" then %> 
			<td class="celula">&nbsp;<%=rs("Nome_Editora")%></td>
			<%end if%>  
			<%if trim(strFiltro04) = "S" then %> 
			<td class="celula">&nbsp;<%=rs("Cod_CDU")%></td>
			<%end if%>  
			<%if trim(strFiltro05) = "S" then %> 
			<td class="celula">&nbsp;<%=rs("Nome_Periodicidade")%></td>
			<%end if%>  
			<%if trim(strFiltro06) = "S" then %> 
			<td class="celula">&nbsp;<%=rs("Autor")%></td>
			<%end if%>  
			<%if trim(strFiltro07) = "S" then %> 
			<td class="celula">&nbsp;<%=strDescPalavra%></td>
			<%end if%>  
			<%if trim(strFiltro08) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("SubTitulo")%></td>
			<%end if%>  
			<%if trim(strFiltro09) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("LocalPublicacao")%></td>
			<%end if%>  
			<%if trim(strFiltro10) = "S" then %> 
			<td class="celula"><div align="center">&nbsp;<%=rs("AnoPublicacao")%></div></td>
			<%end if%>  
			<%if trim(strFiltro11) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("EdicaoPublicacao")%></td>
			<%end if%>
			<%if trim(strFiltro12) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("VolumePublicacao")%></td>
			<%end if%>  
			<%if trim(strFiltro13) = "S" then %> 
			<td  class="celula"><div align="center">&nbsp;<%=rs("ISBN")%></div></td>
			<%end if%>  
			<%if trim(strFiltro14) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("DataInclusao")%></td>
			<%end if%>  
			<%if trim(strFiltro15) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("Etiqueta")%></td>
			<%end if%>
			<%if trim(strFiltro16) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("NumPaginas")%></td>
			<%end if%>  
			<%if trim(strFiltro17) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("Origem")%></td>
			<%end if%>  
			<%if trim(strFiltro18) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("Destino")%></td>
			<%end if%>  
			<%if trim(strFiltro19) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("Resumo")%></td>
			<%end if%>  
			<%if trim(strFiltro20) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("BloqueiaUltimoExemplar")%></td>
			<%end if%>  
			<%if trim(strFiltro22) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("DataContrato")%></td>
			<%end if%>  
			<%if trim(strFiltro23) = "S" then %> 
			<td class="celula">&nbsp;<%=rs("Contato")%></td>
			<%end if%>  
			<%if trim(strFiltro24) = "S" then %> 
			<td class="celula">&nbsp;<%=rs("Endereco")%></td>
			<%end if%>  
			<%if trim(strFiltro25) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("Bairro")%></td>
			<%end if%>  
			<%if trim(strFiltro26) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("Cidade")%></td>
			<%end if%>  
			<%if trim(strFiltro27) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("UF")%></td>
			<%end if%>  
			<%if trim(strFiltro28) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("CEP")%></td>
			<%end if%>  
			<%if trim(strFiltro29) = "S" then %> 
			<td  class="celula">&nbsp;<%=rs("Numero")%></td>
			<%end if%>  
			<%if trim(strFiltro30) = "S" then %> 
			<td class="celula">&nbsp;<%=rs("Email")%></td>
			<%end if  
			TotalGeral = TotalGeral + 1 
			if trim(strTipoRelatorio) = 2 then  
				TotalExemplares = TotalExemplares + rs("Total") 
				%>
				<td class="celula"><%=rs("Total")%></td>
				<%
			else
				TotalExemplares = TotalExemplares + 1
				%>
				<td class="celula">&nbsp;1</td>
				<%
			end if
			 
			%>  
			</tr> 
			<%	
			rs.movenext

		wend
	end if
	
	rs.close
	%>
	<tr width="100%" bgcolor="#CCCCCC">
	<td colspan="37" class="celula"><strong>Total de Registros: <%=TotalGeral%></strong></td>
    </tr>
	<tr width="100%" bgcolor="#CCCCCC">
	<td colspan="37" class="celula"><strong>Total de Exemplares: <%=TotalExemplares%></strong></td>
    </tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
