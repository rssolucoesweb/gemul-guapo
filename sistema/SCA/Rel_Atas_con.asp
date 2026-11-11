<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/06/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio - Atas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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
		
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';
		
		//*****verifica se um aluno foi selecionado
		intContMarcado=0;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				if (form.elements[i].name == "chkAta"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}	
		if (intContMarcado==0){
			alert("Pelo menos Uma Ata deve ser informada ou selecionada!");
			return false;
		}
		frm.action = "Rel_Atas_rel.asp";
		frm.submit();
		
		return true;	
	}
</script>
<%
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	strPaginaTitulo 		= "Rel_Atas_con.asp"
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
		
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
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1">
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td width="36" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
            <td width="133" class="celula"><strong>C&oacute;digo</strong></td>
            <td width="470" class="celula"><strong>Assunto</strong></td>
            <td width="300" class="celula"><strong>Data</strong></td>
          </tr>
          <%					
			sql = "SELECT Codigo, Cod_empresa, Assunto, descricao, data, TextoAta"
			sql = sql & " FROM SCA_ATA"
			sql = sql & " Where Cod_empresa = " & session("codEmpresa")
			sql = sql & " Order by codigo"
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
					%>
				  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
					<td class="celula" align="center"><input type="checkbox" id="chkAta" name="chkAta" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
					<td class="celula"><%=rs("Codigo")%></td>
					<td class="celula"><%=rs("Assunto")%>&nbsp;</td>
					<td class="celula"><%=FORMATADATAAP(rs("data"))%>&nbsp;</td>
				  </tr>
          		  <%
					rs.movenext
					wend
				else
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td colspan="4" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
					  </tr>
					  <%
					end if
					rs.close
			%>
        </table><br></td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" class="texto1"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"--></td>
    </tr>
  </table>
  </td>
  </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>