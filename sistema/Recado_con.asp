<!--
	::	Data de Criação...: 09/01/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
	::	Objetivo Pagina...: Mostra os Recados
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_formatadata.asp"-->
<script src="js/js_funcoes_gerais.js"></script>
<script>
function salvar(acao){
	
	var frm = document.getElementById("frm");
	
	frm.action= "Recado_cod.asp?acao="+acao;
	frm.submit();
	return true;
}
</script>
<%
	intCodRecado	= Trim(Request("intCodRecado"))
	
	sql = "Select CodRecado, De, Para, Assunto, recado, data, hora "
	sql = sql & " From SEG_Recados"
	sql = sql & " Where CodRecado = " & intCodRecado
	rs.open sql, cnn

	if rs.eof = false then
		intCodRecado 			= Trim(Rs("CodRecado"))
		strDe					= Trim(Rs("De"))
		strAssunto 				= Trim(Rs("Assunto"))
		strData					= formataDataAP(Trim(Rs("data")))
		strHora 				= Trim(Rs("Hora"))
		strRecado 				= Trim(Rs("recado"))
	end if
	rs.close

%>
<form method="POST" id="frm">
<input value="<%=intCodRecado%>" name="intCodRecado" type="hidden">
  <table height="393" width="562" align="left"  class="CorFundo">
    <tr>
      <td width="100%" height="387" align="center" valign="top">
	  <table width="99%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="TextoForm" colspan="3" align="center"><STRONG>Detalhe do Recado</STRONG></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">&nbsp;</td>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">De:</td>
            <td colspan="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong><span class="TextoForm">
              <input name="txtDe" type="text" readonly="false" class="text" id="txtDe" size="49" maxlength="50" value="<%=strDe%>">
            </span></strong></font></td>
          </tr>
          <tr>
            <td width="67" height="23" class="TextoForm">Data:</td>
            <td width="107"><input name="txtCodRecado" readonly="readonly" type="hidden" class="text" id="txtCodRecado" value="<%=intCodRecado%>" size="10" maxlength="10">
            <input name="txtData" readonly="readonly" type="text" class="text" id="txtData" value="<%=strData%>" size="11" maxlength="10"></td>
            <td width="375" class="TextoForm">Hor&aacute;rio: 
            <input name="txtData2" readonly="readonly" type="text" class="text" id="txtData2" value="<%=strHora%>" size="11" maxlength="10"></td>
          </tr>
          <tr>
            <td height="27" class="TextoForm">Assunto:</td>
            <td colspan="2" class="TextoForm"><input name="txtTitulo" readonly="readonly" type="text" class="text" id="txtTitulo" value="<%=strAssunto%>" size="50" maxlength="100" tabindex="0"></td>
          </tr>
          <tr>
            <td height="22" class="TextoForm">Recado :</td>
            <td colspan="2"><span align="justify" class="texto"><%=strRecado%></span>&nbsp;</td>
          </tr>
          <tr>
            <td class="TextoForm">&nbsp;</td>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td class="TextoForm">&nbsp;</td>
            <td colspan="2"><input  name="cmdOK" type="button" id="cmdOK" class=botao onClick="salvar('A')" value=":: OK :: " <%=strBotao%> >
            <input  name="cmdFechar" type="button" id="cmdFechar" class=botao value="Fechar" onClick="window.close()"></td>
          </tr>
        </table>
	  </td>
    </tr>
  </table>
</form>
</body>
</html>