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
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="FormaIngresso_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "FormaIngresso_cad.asp"

	intCodFormaIngresso		 	= Trim(Request.Form("txtCodigo"))
	strDescricao 				= Trim(Request.Form("txtDescricao"))
	strFormaIngressoVinculoInep = Trim(Request.Form("cmbFormaIngressoVinculoInep"))
		
	if trim(intCodFormaIngresso) <> "" then
	
		sql = "SELECT * "
		sql = sql & " FROM SCA_FormaIngresso"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodFormaIngresso
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strDescricao				= rs("descricao")
			strFormaIngressoVinculoInep = rs("Cod_Campo_Inep")
			
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
		  <table width="703" border="0" cellspacing="0" cellpadding="0"><tr><td width="626"><table width="703" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="177" class="texto1">Descri&ccedil;&atilde;o :</td>
              <td width="406"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodFormaIngresso%>" maxlength="10">
                  <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
            </tr>
            <tr>
              <td class="texto1">Forma de Ingresso V&iacute;nculo Inep:</td>
              <td width="406"><!--#include file="../includes/inc_cmbFormaIngressoVinculoInep.asp"--></td>
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
			sql = "SELECT codigo, descricao"
			sql = sql & " FROM SCA_FormaIngresso"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by codigo"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                  <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                    <tr bgcolor="#E5E5E5">
                      <td width="14%" class="celula"><strong>C&oacute;digo </strong></td>
                      <td width="86%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    </tr>
                    <%
				while not rs.eof
					cont = cont + 1	
					%>
                    <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                      <td class="celula"><%=rs("codigo")%></td>
                      <td height="20" class="celula"><%=trim(rs("descricao"))%></td>
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
          </table></td>
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