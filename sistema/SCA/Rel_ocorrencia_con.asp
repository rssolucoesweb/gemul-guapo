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
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function gerar(){
	
		var frm = document.getElementById("frm");
		
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}

		if (frm.txtCodAluno.value == "") {
			alert("O aluno deve ser informado!");
			frm.txtCodAluno.focus();
			return false;
		}
		if (frm.txtDataInicial.value == "") {
			alert("Período inicial deve ser informado!");
			frm.txtDataInicial.focus();
			return false;
		}
		if (frm.txtDataFinal.value == "") {
			alert("Período final deve ser informado!");
			frm.txtDataFinal.focus();
			return false;
		}

		frm.action = "Rel_Ocorrencia_rel.asp";
		frm.submit();
		return true;	
	}

</script>
<%
	strPaginaTitulo 		= "Rel_Ocorrencia_con.asp"
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	dataInicial				= Trim(Request.Form("txtDataInicial"))
	dataFinal				= Trim(Request.Form("txtDataFinal"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strMatricula 			= Trim(Request("txtMatricula"))
	strNomealuno 			= Trim(Request("txtNomealuno"))
	intCodModeloDocumento	= Trim(Request.form("cmbModeloDocumento"))

	if strMatricula <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula, dataNascimento from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			strDataNascimento	= Trim(rs("dataNascimento"))
		end if
		rs.close	
		'VERIFICAÇÃO DE BLOQUEIO
		intCodAluno = strCodAluno
		%>
		<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
		<%			
	else
		strCodAluno		= ""
		strMatricula 	= ""
		strNomealuno 	= ""
	end if

%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td height="15" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
<br>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">Ano Letivo:</td>
      <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr>
      <td class="texto1">Matr&iacute;cula: </td>
      <td colspan="2"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="15" value="<%=strCodAluno%>" maxlength="20"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span><input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo: </td>
      <td colspan="2"><span class="TextoForm">
        <input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=dataInicial%>" title="Click aqui para visualizar o calend&aacute;rio">
a
<input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=DataFinal%>" title="Click aqui para visualizar o calend&aacute;rio">
      </span></td>
    </tr>
    <tr> 
      <td class="texto1"></td>
      <td colspan="2">&nbsp;</td>
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