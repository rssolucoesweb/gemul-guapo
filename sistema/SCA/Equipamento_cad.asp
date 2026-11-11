<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 24/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Equipamento 
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
		
		if (frm.txtResponsavel.value == "") {
			alert("O Responsável deve ser informada !");
			frm.txtResponsavel.focus();
			return false;
		}
		if (frm.cmbStatus.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbStatus.focus();
			return false;
		}		
		
		frm.action="Equipamento_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "Equipamento_cad.asp"

	intCodEquipamento 		= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strResponsavel 			= Trim(Request.Form("txtResponsavel"))
	strStatus				= Trim(Request.Form("cmbStatus"))
		
	if trim(intCodEquipamento) <> "" then
	
		sql = "SELECT COD_EQUIPAMENTO, DESC_EQUIPAMENTO, RESPONSAVEL, situacao"
		sql = sql & " FROM SCA_EQUIPAMENTO"
		sql = sql & " Where COD_EQUIPAMENTO = " & intCodEquipamento
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodEquipamento	 	= rs("COD_EQUIPAMENTO")
			strDescricao			= rs("DESC_EQUIPAMENTO")
			strResponsavel			= rs("RESPONSAVEL")
			strStatus				= trim(rs("situacao"))
			
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
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="26" class="texto1">Equipamento:</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodEquipamento%>" maxlength="10">
              <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td class="texto1">Respons&aacute;vel:</td>
            <td><input name="txtResponsavel" type="text" class="text" id="txtResponsavel" size="40" maxlength="40" value="<%=strResponsavel%>"></td>
          </tr>
          <tr>
            <td class="texto1">Situa&ccedil;&atilde;o:</td>
            <td><!--#include file="../includes/inc_cmdStatus.asp" --></td>
          </tr>
          <tr>
            <td width="109" class="texto1">&nbsp;</td>
            <td width="594">&nbsp;</td>
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
				
			sql = "SELECT COD_EQUIPAMENTO, DESC_EQUIPAMENTO, RESPONSAVEL, situacao"
			sql = sql & " FROM SCA_EQUIPAMENTO"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by DESC_EQUIPAMENTO"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "95%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="9%" align="center" class="celula"><strong>C&oacute;d. Equip. </strong></td>
                    <td width="42%" align="center" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    <td width="24%" height="21" align="center" class="celula"><strong>Respons&aacute;vel<span class="TextoForm"></span></strong></td>
                    <td width="25%" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					if trim(rs("situacao")) = "A" then strSit = "Ativo"
					if trim(rs("situacao")) = "I" then strSit = "Inativo"
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("COD_EQUIPAMENTO")%>')">
                    <td class="celula"><%=rs("COD_EQUIPAMENTO")%></td>
                    <td class="celula"><%=trim(rs("DESC_EQUIPAMENTO"))%>&nbsp;</td>
                    <td height="20" class="celula"><%=trim(rs("RESPONSAVEL"))%></td>
                    <td class="celula"><%=trim(strSit)%></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
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