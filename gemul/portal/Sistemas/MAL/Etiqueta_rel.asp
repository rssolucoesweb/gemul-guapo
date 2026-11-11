<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/09/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Etiquetas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_Botoes_Relatorio.asp"-->
<%
	dim intPagina
	
	intCodModeloEtiqueta		= 1
	
	intCodTipoContato		 	= Trim(Request("cmbTipoContato"))
	strCidade1			 	= Trim(Request("cmbCidade1"))
	strBairro1				= Trim(Request("cmbBairro1"))
	
	strCidade2			 	= Trim(Request("cmbCidade2"))
	strBairro2				= Trim(Request("cmbBairro2"))
	
	if trim(intCodModeloEtiqueta) <> "0" then
	
		sql = "SELECT Codigo, linha, coluna, tamanhoHorizontal, tamanhoVertical, espaco"
		sql = sql & " FROM MAL_MODELO_ETIQUETA "
		SQL = SQL & " WHERE	Codigo= " & intCodModeloEtiqueta
		RS.OPEN SQL, CNN
	
		IF not RS.EOF THEN
			linhaPorPagina 		= rs("linha")
			colunaPorPagina 	= rs("coluna")
			tamanhoHorizontal 	= rs("tamanhoHorizontal")
			tamanhoVertical 	= rs("tamanhoVertical")
			espaco 				= rs("espaco")
		End if
		rs.close
	end if
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	cont = 0
	vetEtiquetas = null
   	
	sql = "SELECT Nome, Endereco1, Bairro1, Cidade1, CEP1, Bairro2, Cidade2, CEP2"
	sql = sql & " FROM MAL_Cliente "
	sql = sql & " Where CodTipoContato =  " & intCodTipoContato

	if strCidade1 <> "0" then
		sql = sql & " and Cidade1 = '" & strCidade1 & "'"
	end if

	if strBairro1 <> "0" then
		sql = sql & " and Bairro1 = '" & strBairro1 & "'"
	end if
	
	if trim(strCidade2) <> "0" then
		sql = sql & " and Cidade2 = '" & strCidade2 & "'"
	end if

	if trim(strBairro2) <> "0" then
		sql = sql & " and Bairro2 = '" & strBairro2 & "'"
	end if
	
	sql = sql & " Order by Nome"
	rs.open sql, cnn
	
	if not rs.eof then
		vetEtiquetas = rs.getRows
	end if
	rs.close
	
	if isArray(vetEtiquetas) then
		posicao = 0
		registros = ubound(vetEtiquetas,2)
		totalLinhas = registros/colunaPorPagina
		%>
        <table border="0" cellspacing="0" cellpadding="0" class="tabela"><%
		
			for linha=0 to totalLinhas-1
	
				%>
				<tr>
				<%
				
				cont = cont + 1 
				
				for coluna=0 to colunaPorPagina-1
					
					strNome		 		= vetEtiquetas(0,posicao)
					strEndereco			= vetEtiquetas(1,posicao)
					strBairro			= vetEtiquetas(2,posicao)
					strCidade			= vetEtiquetas(3,posicao)
					strUF				= vetEtiquetas(4,posicao)
					strCEP				= vetEtiquetas(5,posicao)
					%>
					<td height="<%=tamanhoVertical%>" width="<%=tamanhoHorizontal%>" class="celula">
					<DIV align="left" STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=strNome%></NOBR></DIV>
					<DIV align="left" STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=strEndereco%></NOBR></DIV>
					<DIV align="left" STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=strBairro%></NOBR></DIV>
					<DIV align="left" STYLE="left: 0px; color: black; width: <%=tamanhoHorizontal-5%>px; overflow: hidden; text-overflow:ellipsis"><NOBR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=strCidade%> - <%=strUF%> - <%=strCEP%></NOBR></DIV>
					</td>
					<%
					posicao = posicao + 1
				next
			%></tr><%
			if cInt(cont) = cInt(linhaPorPagina) then 
				%>
				</table>
                <pre> </pre>
				<table border="0" cellspacing="0" cellpadding="0" class="tabela">				
				<%	
				cont = 0	
			end if
			
		next
		%></table><% 
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