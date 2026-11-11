<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br" 
	::	Data de Criação...: 10/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Excluir de Material de Aula 
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
	
	function marcaTodos(valor){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				form.elements[i].checked=valor;
			}
		}
	}
	
	function gerar(){
	
		var frm = document.getElementById("frm");	
		var intContMarcado =0;
		var intCodAluno = "0";
		
		for (var i = 0; i < frm.elements.length; i++) 
		{
			//verifica todos os checkbox
			if (frm.elements[i].name.substring(0,19) == "chkCodigo"){				
				if (frm.elements[i].checked) {
					intContMarcado = intContMarcado + 1;
					intCodAluno = intCodAluno + "," + frm.elements[i].value;
				}
			}
		}
		
		if (intContMarcado==0){
			alert("ATENCAO: Pelo menos um Materail deve ser selecionado, Verifique!");
			return false;
		}
	
		frm.action = "MaterialAulaExcluir_cod.asp";
		frm.submit();
		return true;	
	
}	
</script>
<%
	strPaginaTitulo 			= "MaterialAulaExcluir_con.asp"
	strTextoBotaoRel			= "Excluir Material"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir	
%>
<form name="frm" method="post" id="frm" action="MaterialAulaExcluir_con.asp">
  <table width="100%"  border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
    <tr valign="top">
      <td  height="18" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
    </tr>
    <tr>
      <td  height="18" align="center" class="tituloSistema">
      
      <table width="98%" border="0">
        <tr>
          <td width="100%">&nbsp;</td>
        </tr>
        <tr>
          <td>
		  <%
   			cont =0
			intTotal = 0
			
			cont =0
			sql = " SELECT Codigo, CodTurma, CodDisciplinaTurma, Data, Descricao, NomeArquivo"
			sql = sql & " FROM SCA_MaterialAluno"
			sql = sql & " where Cod_empresa = " & Session("CodEmpresa")	
			sql = sql & " And DATEDIFF(DAY,Data,GETDATE()) >= -7 "
			sql = sql & " ORDER BY Codigo"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" class="tabela" bordercolor="#CCCCCC">
                  <tr bgcolor="#CCCCCC">
                    <td width="4%" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
                    <td width="11%" class="celula"><strong>C&oacute;digo</strong></td>
                    <td width="69%" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
                    <td width="16%" height="21" class="celula"><strong>Data</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                      <tr>
                        <td align="center" class="celula"><input type="checkbox" id="chkCodigo" name="chkCodigo" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
                        <td class="celula"><%=rs("Codigo")%></td>
                        <td class="celula"><%=trim(rs("Descricao"))%>&nbsp;</td>
                        <td height="20" class="celula"><%=formatadataAP(trim(rs("Data")))%>&nbsp;</td>
                      </tr>
                      <%				
					rs.movenext
					wend
					%>
                      <tr bgcolor="#CCCCCC">
                        <td height="21" colspan="4" class="celula"><strong>Total Registros: </strong><%=cont%></td>
                    </table>
            		<%
			  end if
			  rs.close%>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"--></td>
        </tr>
      </table>
      <p>&nbsp;</p></td>
    </tr>
	  <tr valign="top">
	    <td>
	    </td>
	  </tr>
	  <tr valign="top">
	    <td>
        </td>
    </tr>
	  <tr valign="top">
	    <td></td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>