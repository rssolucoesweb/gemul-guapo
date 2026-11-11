<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Disciplina
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
			alert("A Descrição (Uso interno) deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDescAbreviada.value == "") {
			alert("A Descrição (Horário) deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		if (frm.txtDescHistorico.value == "") {
			alert("A Descrição (Histórico) Abreviada deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		
		frm.action="Disciplina_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo 	= "Disciplina_cad.asp"
	intCodDisciplina	= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strDescHistorico	= Trim(Request.Form("txtDescHistorico"))
		
	if trim(intCodDisciplina) <> "" then
	
		sql = "SELECT COD_Disciplina, DESC_Disciplina, Desc_Abreviada, Desc_historico"
		sql = sql & " FROM SCA_DISCIPLINA"
		sql = sql & " Where COD_Disciplina = " & intCodDisciplina
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodTurno	 			= rs("COD_Disciplina")
			strDescricao			= rs("DESC_Disciplina")
			strDescAbreviada		= rs("Desc_Abreviada")
			strDescHistorico		= rs("Desc_Historico")
			
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
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="23" class="texto1">Descri&ccedil;&atilde;o (Uso Interno):</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurno%>" maxlength="10">
              <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="50" maxlength="50" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td height="23" width="190" class="texto1">Descri&ccedil;&atilde;o Abreviada (Hor&aacute;rio): </td>
            <td width="782"><input name="txtDescAbreviada" type="text" class="text" id="txtDescAbreviada" size="20" maxlength="20" value="<%=strDescAbreviada%>"></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Descri&ccedil;&atilde;o (Hist&oacute;rico) </td>
            <td><input name="txtDescHistorico" type="text" class="text" id="txtDescHistorico" size="100" maxlength="120" value="<%=strDescHistorico%>"></td>
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
			
			sql = "SELECT COD_Disciplina, DESC_Disciplina, Desc_Abreviada, Desc_Historico"
			sql = sql & " FROM SCA_DISCIPLINA"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by DESC_Disciplina"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="4%" class="celula"><strong><span class="TextoForm">C&oacute;digo</span></strong></td>
                    <td width="42%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o (Uso Interno) </span></strong></td>
                    <td width="13%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o (Hor&aacute;rio) </span></strong></td>
                    <td width="41%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o (Hist&oacute;rico) </span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("COD_Disciplina")%>')">
                    <td class="celula"><div align="center"><%=trim(rs("COD_Disciplina"))%></div></td>
                    <td class="celula"><%=trim(rs("DESC_Disciplina"))%></td>
                    <td class="celula"><%=trim(rs("Desc_Abreviada"))%></td>
                    <td height="20" class="celula"><%=trim(rs("Desc_Historico"))%>&nbsp;</td>
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