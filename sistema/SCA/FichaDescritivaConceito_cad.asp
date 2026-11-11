<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha Descritiva - Conceito 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		
		
		var frm = document.getElementById("frm");

		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descricao deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtValorInicial.value == "") {
			alert("O Valor Inicial deve ser informado !");
			frm.txtValorInicial.focus();
			return false;
		}
		
		if (frm.txtValorFinal.value == "") {
			alert("O Valor Final deve ser informado !");
			frm.txtValorFinal.focus();
			return false;
		}

		if (frm.cmbFichaDescritiva.value == "0"){
			alert("A Ficha Descritiva deve ser informada.");
			frm.cmbFichaDescritiva.focus();
			return false;
		}

		frm.action="FichaDescritivaConceito_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo 	= "FichaDescritivaConceito_cad.asp"
	
    strExecutarSubmit 		= "S"	
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strSigla	 			= Trim(Request.Form("txtSigla"))
	intCodFichaDescritiva	= Trim(Request.form("cmbFichaDescritiva"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strValorInicial 		= Trim(Request.Form("txtValorInicial"))
	strValorFinal 			= Trim(Request.Form("txtValorFinal"))
    if intCodFichaDescritiva = "" then intCodFichaDescritiva = "0"
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Sigla, Cod_Ficha_Descritiva, Descricao, ValorInicial, ValorFinal"
		sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO"
		sql = sql & " where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 				= rs("Codigo")
			intCodFichaDescritiva		= rs("Cod_Ficha_Descritiva")
			strSigla				    = rs("Sigla")
			
			strDescricao			    = rs("Descricao")
			strValorInicial			    = rs("ValorInicial")
			strValorFinal			    = rs("ValorFinal")
			
			strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 		= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
<form id="frm" method="post">
	  <table width="98%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  
<table width="98%" border="0" align="center" cellspacing="0" bgcolor="#FFFFFF" cellpadding="0">
          <tr>
            <td class="texto1">&nbsp;</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Ficha Descritiva:</td>
            <td> <!--#include file="../includes/inc_cmdFichaDescritiva.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Sigla:</td>
            <td><input name="txtSigla" type="text" class="text" id="txtSigla" size="5" maxlength="5" value="<%=strSigla%>"></td>
          </tr>
          
          <tr>
            <td class="texto1">Descri&ccedil;&atilde;o: </td>
            <td><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="30" maxlength="30" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Valor Inicial:</td>
            <td><span class="TextoForm">
              <input name="txtValorInicial" type="text" class="text" id="txtValorInicial" onKeyPress="return formataCampo(this,6,4)"  size="11" maxlength="5" value="<%=strValorInicial%>">
            </span></td>
          </tr>
          <tr>
            <td width="182" class="texto1">Valor Final:</td>
            <td width="1027"><span class="TextoForm">
              <input name="txtValorFinal" type="text" class="text" id="txtValorFinal" onKeyPress="return formataCampo(this, 6, 5)"  size="11" maxlength="5" value="<%=strValorFinal%>">
            </span></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			cont =0
			sql = "SELECT Codigo, Sigla, Descricao, ValorInicial, ValorFinal"
			sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO"
			if strCompartilharDados = "S" then
				sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
			else   
				sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
			end if   
			sql = sql & " and Cod_Ficha_Descritiva = " & intCodFichaDescritiva			
			sql = sql & " Order by Codigo"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="4%" class="celula"><strong>C&oacute;d.  </strong></td>
                    <td width="11%" class="celula"><strong>Sigla<span class="TextoForm"></span></strong></td>
                    <td width="32%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    <td width="15%" class="celula"><strong>Valor Inicial<span class="TextoForm"></span></strong></td>
                    <td width="38%" height="21" class="celula"><strong>Valor Final<span class="TextoForm"></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                    <td class="celula"><%=rs("Codigo")%></td>
                    <td class="celula"><%=rs("Sigla")%>&nbsp;</td>
                    <td class="celula"><%=rs("Descricao")%>&nbsp;</td>
                    <td class="celula"><%=rs("ValorInicial")%>&nbsp;</td>
                    <td height="20" class="celula"><%=trim(rs("ValorFinal"))%></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				%>
                  <tr>
                    <td height="21" colspan="5" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
          </tr>
        </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>