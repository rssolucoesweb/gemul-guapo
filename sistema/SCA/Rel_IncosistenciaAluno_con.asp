<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/08/2012
	::	Desenvolvedores...: Sergio Borges - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio de Incosistecia de Alunos
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
		
		var caminho;
		var frm = document.getElementById("frm");
		caminho = "Rel_IncosistenciaAluno_rel.asp"
	
		frm.action = caminho;
		frm.submit();
		return true;	
	}
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo 		= "Rel_IncosistenciaAluno_con.asp"
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="328" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td height="22" align="center" class="tituloSistema">Inconsistencia de Aluno</td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td width="7%" class="texto1">Situa&ccedil;&atilde;o:</td>
      <td width="93%"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    
    <tr>
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
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
