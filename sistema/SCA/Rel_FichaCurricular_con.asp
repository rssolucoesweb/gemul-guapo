<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Criterio de Avaliação
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function gerar(){
	
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value=="" && frm.cmbCurso.value=="0" && frm.cmbGradeagrupamento.value=="0" ){
			alert("O aluno ou o Curso, deve ser informado!");
			frm.txtMatricula.focus();
			return false;
		}
		frm.action = "Rel_FichaCurricular_rel.asp";
		frm.submit();
		return true;	
	}
</script>
<%

	strExecutarSubmitGradeCurricularGrupos     = "S"
	strExecutarSubmitCurso                     = "S"


	strPaginaTitulo = "Rel_FichaCurricular_con.asp"
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
	
	strCodAluno			    = Trim(Request("txtCodAluno"))
	strMatricula 		    = Trim(Request("txtMatricula"))
	strNomealuno 		    = Trim(Request("txtNomealuno"))
	intCodCurso 		    = Trim(Request("cmbCurso"))
    intCodGradeagrupamento  = Trim(Request.Form("cmbGradeagrupamento"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))

	if strMatricula <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		end if
		rs.close	
	else
			strCodAluno			= ""
			strMatricula 		= ""
			strNomealuno 		= ""
	end if


%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Matr&iacute;cula : </td>
      <td colspan="2"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span><input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td class="texto1">Curso:</td>
      <td class="texto1" colspan="2"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Grupo:</td>
      <td class="texto1" colspan="2"><!--#include file="../includes/inc_cmdGradeCurricularGrupos.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Registros por P&aacute;gina: </td>
      <td class="texto1" colspan="2"><!--#include file="../includes/inc_cmbLinhaPorPagina.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Tamanho da Fonte:</td>
      <td class="texto1" colspan="2"><!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">Opcional:</td>
      <td class="texto1" colspan="2">
        <input type="checkbox" name="opcional" value="S">
        Disciplinas / C.H. / M&eacute;dia / Observa&ccedil;&otilde;es  </td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"--></td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>