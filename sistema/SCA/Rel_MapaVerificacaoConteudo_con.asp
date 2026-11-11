<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 12/08/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolcueosweb.com.br
	::	Objetivo Pagina...: Rel Mapa Verificacao Conteudo
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function gerar(){
		
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}

		if (frm.cmbSemestre.value=="0") {
			alert("O Semestre deve ser informado.");
			frm.cmbSemestre.focus();
			return false
		}
		
		if (frm.cmbCurso.value=="0") {
			alert("O Curso deve ser informado.");
			frm.cmbCurso.focus();
			return false
		}
		
		frm.action = "Rel_MapaVerificacaoConteudo_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>

<%
	strPaginaTitulo = "Rel_MapaVerificacaoConteudo_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitTurma	  = "S"
 	strExecutarSubmitTurnoRH  = "S"
	
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")
	strOpcaoRelatorio 		= Trim(Request.Form("optOpcao"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurnoRH 			= Trim(Request.Form("cmbTurnoRH"))
	
	strTurnoNomeTurma = ""
	if intCodTurma <> "" and intCodTurma <> "0" then
		sql = "SELECT SCA_TURMA.NomeTurma " 
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " WHERE Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			strTurnoNomeTurma 	= mid(rs("NomeTurma"),6,1)
		END IF
		rs.close
	end if

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
	  <tr>
        <td width="152" class="texto1">Ano Letivo: </td>
	    <td width="1136"><input name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
	    </tr>
	  <tr>
        <td class="texto1">Semestre:</td>
	    <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
	    </tr>
	  <tr>
	    <td class="texto1">Curso:</td>
	    <td class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
	    </tr>
	  <tr>
	    <td class="texto1">Turma:</td>
	    <td class="texto1"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
	  </tr>
      <% if strTurnoNomeTurma = "I" then %>
          <tr>
            <td class="texto1">Turno:</td>
            <td class="texto1"><!--#include file="../includes/inc_cmbTurnoRHPadrao.asp"--></td>
          </tr>
      <% end if %>
	  <tr>
	    <td class="texto1"><strong>Op&ccedil;&otilde;es:</strong></td>
	    <td class="texto1">
        <input <% if strOpcaoRelatorio = "E" then response.Write("checked")%> name="optOpcao" type="radio" value="E" onClick='submit()'>
        Enviado &nbsp;&nbsp;&nbsp;&nbsp;
        <br>
        <input <% if strOpcaoRelatorio = "N" then response.Write("checked")%> name="optOpcao" type="radio" value="N" onClick='submit()'> 
        N&atilde;o Enviado
        <br>
        <input <% if strOpcaoRelatorio = "T" then response.Write("checked")%> name="optOpcao" type="radio" value="T" onClick='submit()'> 
        Todos</td>
	    </tr>
      <% if strOpcaoRelatorio = "E" then %>
          <tr>
            <td class="texto1">Notificar Professores:</td>
            <td class="texto1"><input type="checkbox" name="txtNotificarProfessores" value="S">
            - Enviar email notificando o conte&uacute;do ainda n&atilde;o entregue do m&ecirc;s:&nbsp;<!--#include file="../includes/inc_cmbMes.asp"--></td>
            </tr>
          <tr>
            <td class="texto1">Texto:</td>
            <td class="texto1"><Textarea class="ckeditor" cols="80" id="txtNotificacao" name="txtNotificacao"><%=strNotificacao%></textarea></td>
          </tr>
      <% end if %>
	  <tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>    <tr>
      <td colspan="2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
<br>
<br>		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
