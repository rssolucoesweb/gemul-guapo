<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 01/06/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Situação Promoção do Aluno
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDescAbreviada.value == "") {
			alert("A Descrição Abreviada deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		
		frm.action="SituacaoPromocao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "SituacaoPromocao_cad.asp"

	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT codigo, descricao, Desc_Abreviada, criterio"
		sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
		sql = sql & " Where codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			strDescricao			= rs("descricao")
			strDescAbreviada		= rs("Desc_Abreviada")
			strCriterio				= rs("Criterio")
			
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
            <td height="23" class="texto1">Descri&ccedil;&atilde;o  :</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td width="113" class="texto1">Desc. Abreviada : </td>
            <td width="590"><input name="txtDescAbreviada" type="text" class="text" id="txtDescAbreviada" size="40" maxlength="40" value="<%=strDescAbreviada%>"></td>
          </tr>
          <tr>
            <td><span class="texto1">Crit&eacute;rio  :</span></td>
            <td><label>
              <select name="cmbCriterio" class="Combo">
                <option <%if strCriterio = "SC" or isnull(strCriterio) then response.Write("selected")%> value="SC">Sem Critério</option>
				<option <%if strCriterio = "AP" then response.Write("selected")%> value="AP">Aprovação</option>
                <option <%if strCriterio = "RP" then response.Write("selected")%> value="RP">Reprovação Por Nota</option>
                <option <%if strCriterio = "RF" then response.Write("selected")%> value="RF">Reprovação Por Falta</option>
                <option <%if strCriterio = "DI" then response.Write("selected")%> value="DI">Dispensado</option>
              </select>
            </label></td>
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
			
			sql = "SELECT codigo, descricao, desc_Abreviada, Criterio"
			sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by descricao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="6%" class="celula"><strong>C&oacute;digo</strong></td>
                    <td width="47%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    <td width="16%" height="21" class="celula"><strong><span class="TextoForm">Abreviada </span></strong></td>
                    <td width="31%" class="celula"><strong>Crit&eacute;rio</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					Criterio = ""
					if trim(rs("Criterio")) = "SC" then Criterio = "Sem Critério"
					if trim(rs("Criterio")) = "AP" then Criterio = "Aprovação"
					if trim(rs("Criterio")) = "RP" then Criterio = "Reprovação Por Nota"
					if trim(rs("Criterio")) = "RF" then Criterio = "Reprovação Por Falta"
					if trim(rs("Criterio")) = "DI" then Criterio = "Dispensado"
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                    <td class="celula"><%=rs("codigo")%></td>
                    <td class="celula"><%=trim(rs("descricao"))%></td>
                    <td height="20" class="celula"><%=trim(rs("Desc_Abreviada"))%></td>
                    <td class="celula"><%=trim(Criterio)%>&nbsp;</td>
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