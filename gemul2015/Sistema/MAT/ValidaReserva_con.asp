<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: valida inscrição do processo seletivo
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
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
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
	function salvar(acao){
				
		var frm = document.getElementById("frm");
	
		if (frm.txtInscricao.value == "") {
			alert("A inscrição deve ser informada !");
			frm.txtInscricao.focus();
			return false;
		}
		
		if (frm.cmbTurma.value == "0") {
			alert("A turma deve ser informada !");
			frm.cmbTurma.focus();
			return false;
		}

		if (frm.cmbCurso.value == "0") {
			alert("Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}

		frm.action="ValidaReserva_cod.asp";
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo = "ValidaReserva_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitSemestre = "S"

	strSemestre 	= session("strSemestre")
	strAnoLetivo 	= session("strAnoLetivo")
	strAnoLetivo 	= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 	= Trim(Request.Form("cmbSemestre"))
	if intSemestre 	= "" then 	intSemestre  = session("strSemestre")
	intCodCurso 	= Trim(Request.Form("cmbCurso"))
	strInscricao 	= Trim(Request("txtInscricao"))
	strNomealuno	= Trim(Request("txtNomealuno"))
	
	if strInscricao <> "" then
		sql = "SELECT CODIGO, NOME, PERIODO, INSCRICAO,  Contato, Celular, FonePai, FoneMae, ISNULL(ATUALIZADO,'N') as ATUALIZADO "
		sql = sql & " FROM MAT_RESERVA"
		sql = sql & " WHERE  codigo = " & strInscricao
		rs.open sql, cnn
		if rs.eof = false then
			strInscricaoReserva 			= Trim(rs("INSCRICAO"))
			strNomealuno 			= Trim(rs("Nome"))
		    strPeriodo 				= Trim(rs("PERIODO"))
			strContato 				= Trim(rs("Contato")) & "    " & Trim(rs("Celular")) 
			strFonePai 				= Trim(rs("FonePai"))
			strFoneMae 				= Trim(rs("FoneMae"))
			strAtualizado			= Trim(rs("ATUALIZADO"))

			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		else	
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if
		rs.close
		
		if strAtualizado = "S" then
			strParametro = "ValidaReserva_con.asp"
			%>
			<script>
				alert("Incrição já Efetivada!");
				window.location='<%=strParametro%>';
			</script>
			<%
			response.end
		end if
	else
		strInscricao = ""
		strNomealuno = ""
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if

	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	

%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td width="17%" class="texto1">Ano Letivo:</td>
      <td width="83%" colspan="2"><span class="texto1">
        <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr>
      <td class="texto1">Inscri&ccedil;&atilde;o: </td>
      <td colspan="2">
        <input name="txtInscricaoReserva" type="text" disabled class="text" id="txtInscricaoReserva" size="20" maxlength="20" value="<%=strInscricaoReserva%>"  onKeyPress="return formataCampo(this, 2, 10)">
        <input name="txtInscricao" type="hidden" class="text" id="txtInscricao" size="20" maxlength="20" value="<%=strInscricao%>">
        <a  href="#" onClick="return abreConsulta('Inscricao_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
     <% if strInscricao <> "" then %> 
        <tr>
          <td class="texto1">Reserva Realizada para:</td>
          <td class="texto1"><strong><%=strPeriodo%></strong>&nbsp;</td>
        </tr>
        <tr>
          <td class="texto1">Contato - Telefone(s):</td>
          <td class="texto1">Contato:&nbsp;&nbsp;<%=strContato%>&nbsp;-&nbsp;Celular M&atilde;e:&nbsp;&nbsp;<%=strFoneMae%>&nbsp;&nbsp;&nbsp;-&nbsp;Celular Pai:&nbsp;&nbsp;<%=strFonePai%>&nbsp;</td>
        </tr>
     <% end if %>    
    <tr>
      <td class="texto1">&nbsp;</td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Curso : </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Turno : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurno.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Turma : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>