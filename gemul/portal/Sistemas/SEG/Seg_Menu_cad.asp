<!--
	::	IMOB
	::	Data de Criação...: 11/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Inclusão de Menu
	::	Desenvolvedores...: 
	::	Data Atualizacao..: 
-->
<html>
<head>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
<title>Inclusão de Itens no Menu</title>
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/Seg_Menu_cad.js"></script>
</head>
<body   topmargin="0" leftmargin="0">
<%
'as paginas do menu administrativo não vão validar o ano letivo
bolPaginaAnoLetivo 	= "N"
'as paginas do menu administrativo não vão validar a unidade de ensino
strValidaUnidadeEnsino = "N"
%>
<!--#include file="../../../includes/inc_cnn.asp"-->
<form method="POST" id="frm" action="#">
<table width="98%" align="center" class="formulario">
<tr>
<td>
<%  
	strRetornar = "S"
	mostrarBotaoPrincipal = "N"
	strBotaoPrincipal = "N"
	strMostraBotaoFechar = "S"
	intCodMenu					= request("CodMenu")
	intCodModulo				= request("CodModulo")
	strAcao						= request("acao")
	if trim(strAcao) = "I" then
	
		sql = "SELECT codigo, descricao "
		sql = sql & " from SEG_menu "
		sql = sql & " where 1=1"
		
		if intCodMenu <> "" then 
			sql = sql & " and codigo = " & intCodMenu
		end if
		
		sql = sql & " and codigo_seg_modulo = " & intCodModulo
		sql = sql & " order by ordem "	
		
		rs.open sql, cnn
		if rs.eof = false then
			strMenu = rs("descricao")
		end if
		rs.close

		strDesabilitaIncluir 	= ""
		strDesabilitaExcluir 	= "disabled"
		strDesabilitaAlterar 	= "disabled"
		strDesabilitaLimpar 	= "disabled"
				
	elseif trim(strAcao) = "A" then
		sql = "SELECT descricao, link, imagem, script, ordem, comentario,ano_inicio,  ano_termino  "
		sql = sql & " from SEG_menu "
		sql = sql & " where codigo = " & intCodMenu
		sql = sql & " and codigo_seg_modulo = " & intCodModulo
		sql = sql & " order by ordem "	
		rs.open sql, cnn
		if rs.eof = false then
			strMenu = rs("descricao")
			strDescricao = rs("descricao")
			strLink = rs("link")
			strImagem = rs("imagem")
			strScript = rs("script")
			intOrdem = rs("ordem")
			strComentario = rs("comentario")
			intAnoInicio  = rs("ano_inicio")
			intAnoTermino = rs("ano_termino")

			strDesabilitaIncluir 	= "disabled"
			strDesabilitaExcluir 	= ""
			strDesabilitaAlterar 	= ""
			strDesabilitaLimpar 	= "disabled"
		else
			strDesabilitaIncluir 	= ""
			strDesabilitaExcluir 	= "disabled"
			strDesabilitaAlterar 	= "disabled"
			strDesabilitaLimpar 	= "disabled"		
		end if
		rs.close
	end if	
	
			
%>
<div class="TituloFormulario" align="center">Inclução de Itens - Menu&nbsp;<%=strMenu%></div>
<input value="<%=intCodMenu%>" name="CodMenu" id="CodMenu" type="hidden">
<input value="<%=intCodModulo%>" name="CodModulo" id="CodModulo" type="hidden">
<input value="<%=strAcao%>" name="acao" id="acao" type="hidden">
	<br>
<table width="100%" border="0">
		<tr>
		  <td width="77">Descri&ccedil;&atilde;o</td>
		  <td colspan="3"><input name="txtDescricao" type="text" class="caixaTexto" id="txtDescricao" size="70" maxlength="50" value="<%=strDescricao%>"></td>
		  </tr>
		<tr>
		  <td>Link</td>
		  <td colspan="3"><input name="txtLink" type="text" class="caixaTexto" id="txtLink" size="70" maxlength="200" value="<%=strLink%>"></td>
		  </tr>
		<tr>
		  <td>Imagem</td>
		  <td colspan="3"><input name="txtImagem" type="text" class="caixaTexto" id="txtImagem" size="70" maxlength="80" value="<%=strImagem%>"></td>
		  </tr>
		<tr>
		  <td>Script</td>
		  <td colspan="3"><input name="txtScript" type="text" class="caixaTexto" id="txtScript" size="70" maxlength="80" value="<%=strScript%>"></td>
		  </tr>
		<tr>
		  <td>Ordem</td>
		  <td colspan="3"><input name="txtOrdem" type="text" class="caixaTexto" id="txtOrdem" onKeyPress="return formataCampo(this, 2, 5)" size="5" maxlength="5" value="<%=intOrdem%>"></td>
		  </tr>
		<tr>
		  <td>Coment&aacute;rio</td>
		  <td colspan="3"><input name="txtComentario" type="text" class="caixaTexto" id="txtComentario" size="70" maxlength="80" value="<%=strComentario%>"></td>
		  </tr>
		<tr>
		  <td>Ano In&iacute;cio</td>
		  <td width="238"><input name="txtAnoInicio" type="text" class="caixaTexto" id="txtAnoInicio" onKeyPress="return formataCampo(this, 2, 4)" size="5" maxlength="4" value="<%=intAnoInicio%>"></td>
		  <td width="86">Ano T&eacute;rmino</td>
		  <td width="545"><input name="txtAnoTermino" type="text" class="caixaTexto" id="txtAnoTermino" onKeyPress="return formataCampo(this, 2, 4)" size="5" maxlength="4" value="<%=intAnoTermino%>"></td>
		</tr>
          <tr> 
          	<td colspan="6"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
          	<td colspan="6"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
        </table>
		<%	
			' Seleciona todos os grupos cadastrados
			sql = "Select codigo, descricao, ordem"
			sql = sql & " FROM SEG_menu"
			sql = sql & " WHERE 1 = 1"
			
			if intCodMenu <> "" then 
				sql = sql & " and codigo = " & intCodMenu
			end if
			
			sql = sql & " and codigo_seg_modulo = " & intCodModulo
			sql = sql & " order by ordem, codigo"
			rs.open sql, cnn
			if rs.eof = false then
			%>
<br>
			<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td colspan="3" class="celula" align="center"><span class="CabecalhoConsulta"><%=strMenu%></span></td>
	    </tr>
	  <tr class="CabecalhoConsulta"> 
				<td width="12%" class="celula"><div align="center">C&oacute;digo</div></td>
			<td width="61%"class="celula">Descrição</td>
			<td width="27%"class="celula">Ordem</td>
	  </tr>
     	 	<%
			cont = 0
			while not rs.eof
				cont = cont + 1
				%>
        		<tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return selMenu('<%=rs("codigo")%>','<%=intCodModulo%>')"> 
					<td class="celula" align="center"><%=rs("codigo")%></td>
					<td align="center" class="celula"><div align="left">&nbsp;<%=rs("Descricao")%></div></td>
			 	    <td align="center" class="celula"><div align="left">&nbsp;<%=rs("ordem")%></div></td>
        		</tr>
				<%
				rs.movenext
			wend
		rs.close
		%>
			<tr> 
			<td class="celula" colspan="3">Total de itens: <%=cont%>&nbsp;</td>
		</tr>
	</table> 
<%
end if
%>
</td>
</tr>
</table>
<input name="txtHiddenContador" type="hidden" value="<%=cont%>">
</form>
</body>
</html>