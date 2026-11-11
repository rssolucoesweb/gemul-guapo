<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Eventos 
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
<script>
	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "0"){
			alert("O Modelo deve ser informado.");
			frm.txtDescricao.focus();
			return false;
		}	
		
		if (frm.cmbSituacao.value == "0"){
			alert("A Situação deve ser informada.");
			frm.cmbSituacao.focus();
			return false;
		}	
		
		frm.action= "ModeloEtiquetas_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
 	}
</script>
<%
	strExecutarSubmitCurso	  = "S"
	strPaginaTitulo 		= "ModeloEtiquetas_cad.asp"
	intCodEmp			= Session("CodEmpresa")
	intCodigo	    	= Trim(Request.Form("txtCodigo")) 
	strDescricao		= Trim(Request.Form("txtDescricao"))
	intColuna			= Trim(Request.Form("txtColuna"))
	intLinha 			= Trim(Request.Form("txtLinha"))
	intTamanhoHorizontal			= Trim(Request.Form("txtTamanhoHorizontal"))
	intTamanhoVertical			= Trim(Request.Form("txtTamanhoVertical"))
	intEspaco			= Trim(Request.Form("txtEspaco"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	
	if strSituacao 			= "" then strSituacao 		= "0" 
	
	if intCodigo <> "" then
	
		sql = "SELECT Codigo, Cod_Empresa, Descricao, coluna, linha, tamanhoVertical, tamanhoHorizontal, espaco, Situacao"
		sql = sql & " FROM SCA_MODELO_ETIQUETA"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and Codigo = " & intCodigo
		rs.open sql, cnn

		if rs.eof = false then
		
			intCodigo		    = rs("Codigo")
			strDescricao		= Trim(rs("Descricao"))
			intColuna			= Trim(rs("Coluna"))
			intLinha 			= Trim(rs("Linha"))
			intTamanhoVertical	= Trim(rs("tamanhoVertical"))
			intTamanhoHorizontal	= Trim(rs("tamanhoHorizontal"))
			intEspaco			= Trim(rs("Espaco"))
			strSituacao			= rs("Situacao")
		
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		
		end if
		rs.close
	
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="703" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="230" class="texto1">&nbsp;</td>
            <td width="473" class="texto1"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Modelo: </td>
            <td class="texto1"><input name="txtDescricao" value="<%=strDescricao%>" type="text" class="text" id="txtDescricao" size="50" maxlength="100"></td>
          </tr>
          <tr>
            <td class="texto1">Colunas por folha: </td>
            <td class="texto1"><input name="txtColuna" value="<%=intColuna%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtColuna" size="5" maxlength="5">
              ( Col )</td>
          </tr>
          <tr>
            <td class="texto1">Linhas por folha:</td>
            <td class="texto1"><input name="txtLinha" value="<%=intLinha%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtLinha" size="5" maxlength="5">
( Lin )</td>
          </tr>
          <tr>
            <td class="texto1">Tamanho das etiquetas (horizontal):</td>
            <td><span class="texto1"> 
              <input name="txtTamanhoHorizontal" value="<%=intTamanhoHorizontal%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtTamanhoHorizontal" size="5" maxlength="5">
              ( pixel ) - 1 cm equivale a 37,79 pixel</span></td>
          </tr>
          <tr>
            <td class="texto1">Tamanho das etiquetas (vertical):</td>
            <td><span class="texto1">
              <input name="txtTamanhoVertical" value="<%=intTamanhoVertical%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtTamanhoVertical" size="5" maxlength="5">
              ( pixel )</span></td>
          </tr>
          <tr>
            <td class="texto1">Margem esquerda:</td>
            <td><span class="texto1">
              <input name="txtEspaco" value="<%=intEspaco%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtEspaco" size="5" maxlength="5">
              ( pixel )</span></td>
          </tr>
          <tr>
            <td class="texto1">Situa&ccedil;&atilde;o:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdSituacao.asp"-->
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
			
			sql = "SELECT Codigo, Cod_Empresa, descricao, situacao"
			sql = sql & " FROM SCA_MODELO_ETIQUETA"
			sql = sql & " Where Cod_empresa = " & Session("CodEmpresa")	
			sql = sql & " Order by 	Descricao"	
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
              <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td width="9%" class="celula"><strong>C&oacute;digo</strong></td>
                  <td width="73%" class="celula"><strong><span class="TextoForm">Modelo</span></strong></td>
                  <td width="18%" height="21" align="center" class="celula"><strong><span class="TextoForm">Situa&ccedil;&atilde;o</span></strong></td>
                  </tr>
                <%
					while not rs.eof
						cont = cont + 1	
						%>
						<tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
							<td class="celula"><%=rs("Codigo")%></td>
							<td class="celula"><%=trim(rs("Descricao"))%></td>
							<td height="20" align="center" class="celula"><%=trim(rs("situacao"))%></td>
						</tr>
						<%				
						rs.movenext
					wend
				  %>
                <tr>
                  <td height="21" colspan="3" class="celula">Total Registros : <%=cont%></td>
                </table>
              <%
			  end if
			  rs.close
			  %>
			 </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>