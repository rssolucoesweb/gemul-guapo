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
	function resultadoConsulta(intCodNacionalidade){
		frm.txtCodigo.value=intCodNacionalidade;
		frm.submit();
	}
	
	function salvar(acao){
		
		if (frm.txtDescricao.value == "") {
			alert("A Nacionalidade deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="Nacionalidade_cod.asp?acao=A";
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "Nacionalidade_cad.asp"

	intCodNacionalidade		 	= Trim(Request.Form("txtCodigo"))
	strDescricao 				= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodNacionalidade) <> "" then
		strDescricaoPais = ""
		sql = "SELECT upper(codigo) as codigo, upper(nome) as nome, upper(nacionalidade) as nacionalidade "
		sql = sql & " FROM CENSO_PAIS"
		sql = sql & " where codigo = '" & intCodNacionalidade & "'"
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strDescricao				= rs("nacionalidade")
			strDescricaoPais			= rs("nome")
			intCodNacionalidade			= rs("codigo")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
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
              <td height="28" colspan="2" class="texto1"><div align="center"><strong><%=strDescricaoPais%></strong></div></td>
              </tr>
            <tr>
              <td width="119" class="texto1">Nacionalidade:</td>
              <td width="584"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodNacionalidade%>" maxlength="10">
                  <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
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
			sql = "SELECT upper(codigo) as codigo, upper(nome) as nome, upper(nacionalidade) as nacionalidade"
			sql = sql & " FROM CENSO_PAIS"
			sql = sql & " Order by nome "
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                  <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                    <tr bgcolor="#E5E5E5">
                      <td width="14%" class="celula"><strong>Sigla </strong></td>
                      <td width="43%" height="21" class="celula"><strong>Pa&iacute;s<span class="TextoForm"></span></strong></td>
                      <td width="43%" class="celula"><strong>Nacionalidade</strong></td>
                    </tr>
                    <%
				while not rs.eof
					cont = cont + 1	
					%>
                    <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                      <td class="celula"><%=rs("codigo")%></td>
                      <td height="20" class="celula"><%=trim(rs("nome"))%>&nbsp;</td>
                      <td height="20" class="celula"><%=trim(rs("nacionalidade"))%>&nbsp;</td>
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