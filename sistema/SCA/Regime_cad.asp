<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
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
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
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
		
		if (frm.txtDescricao.value == "") {
			alert("O Regime deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="Regime_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "Regime_cad.asp"

	intCodRegime 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
		
	sql = "SELECT COD_REGIME, DESC_REGIME, Tipo_Seriacao"
	sql = sql & " FROM SCA_REGIME"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
'		sql = sql & " and COD_REGIME = " & intCodRegime
	rs.open sql, cnn
	if rs.eof = false then
		
		intCodTurno	 			= rs("COD_REGIME")
		strDescricao			= rs("DESC_REGIME")
		strTipoSeriacao			= TRIM(rs("Tipo_Seriacao"))
		strTipoSeriacaoAnual	= ""
		if strTipoSeriacao		= "A" then strTipoSeriacaoAnual = "S"
		if strTipoSeriacao		= "AS" then 
			strTipoSeriacaoAnual = "S"
			strTipoSeriacaoSemestral = "S"
		end if
		if strTipoSeriacao		= "S" then strTipoSeriacaoSemestral = "S"

		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	rs.close
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
            <td width="77" class="texto1">Regime:</td>
            <td width="626"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurno%>" maxlength="10">
                <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td class="texto1">Tipo:</td>
            <td class="texto1"><input name="optTipo" type="checkbox" value="A" <%if strTipoSeriacaoAnual ="S" then response.Write("checked")%>>
Anual 
              &nbsp;&nbsp;
              <input type="checkbox" name="optTipo" value="S"  <%if strTipoSeriacaoSemestral ="S" then response.Write("checked")%>>
Semestral</td>
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
			sql = "SELECT COD_REGIME, DESC_REGIME"
			sql = sql & " FROM SCA_REGIME"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by COD_REGIME"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="14%" class="celula"><strong>C&oacute;d. Regime </strong></td>
                    <td width="86%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("COD_REGIME")%>')">
                    <td class="celula"><%=rs("COD_REGIME")%></td>
                    <td height="20" class="celula"><%=trim(rs("DESC_REGIME"))%></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="2" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
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