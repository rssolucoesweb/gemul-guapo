<!--
	::	DESENVOLVIDO POR..: RS SOLUÇÕES WEB - www.rssolucoesweb.com.br
	::	Data de Criação...: 09/12/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Configurações gerais
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
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		frm.action="configurarTransferencia_cod.asp?acao="+acao;
		frm.submit();
		return true;
 	}
	
</script>
<%
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

	strPaginaTitulo = "configurarTransferencia_cad.asp"
	parecer_integral_sim = ""
	parecer_integral_nao = ""
	travar_regiao_sim = ""
	travar_regiao_nao = ""
	ano_letivo = ""
	sql = "SELECT *"
	sql = sql & " FROM MAT_configura_transferencia"
	rs.open sql, cnn
	
	if rs.eof = false then
		ano_letivo = rs("ano_letivo")
		parecer_integral = rs("parecer_integral")
		if parecer_integral = "S" then parecer_integral_sim = "checked"
		if parecer_integral = "N" then parecer_integral_nao = "checked"

		travar_regiao = rs("travar_regiao")
		if travar_regiao = "S" then travar_regiao_sim = "checked"
		if travar_regiao = "N" then travar_regiao_nao = "checked"
		
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	rs.close
	
		
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="1259"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td width="1259" colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
          <!--#include file="../includes/inc_ListaHistoricoMatriculaTransferencia.asp" -->
		  <table width="90%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="142" class="texto1">&nbsp;</td>
            <td colspan="2"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="19" colspan="3" class="texto1"><strong>Configurar Transfer&ecirc;ncia</strong></td>
            </tr>

              <tr>
                <td height="40" class="texto1">Parecer turno integral</td>
                <td colspan="2"><span class="texto1"><input name="parecer_integral" type="radio" value="S" <%=parecer_integral_sim%>>&nbsp;Sim&nbsp;&nbsp;&nbsp;&nbsp;<input name="parecer_integral" type="radio" value="N"  <%=parecer_integral_nao%>>&nbsp;Não</span></td>
              </tr>
              <tr>
                <td height="40" class="texto1">Travar por regi&atilde;o</td>
                <td colspan="2"><span class="texto1"><input name="travar_regiao" type="radio" value="S" <%=travar_regiao_sim%>>&nbsp;Sim&nbsp;&nbsp;&nbsp;&nbsp;<input name="travar_regiao" type="radio" value="N"  <%=travar_regiao_nao%>>&nbsp;Não</span></td>
              </tr>
			  <tr>
                <td height="40" class="texto1">Ano letivo</td>
                <td colspan="2"><input name="ano_letivo" type="text" class="text" id="ano_letivo" size="5" maxlength="4" value="<%=ano_letivo%>"  onKeyPress="return formataCampo(this, 2, 4)"></td>
              </tr>
          <tr>
            <td colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="3"> <!--#include file="../../includes/inc_botoes_cadastro.asp"--> </td>
          </tr>
          <tr>
            <td colspan="3">&nbsp;</td>
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