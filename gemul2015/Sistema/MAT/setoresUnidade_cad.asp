<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/12/2017
	::	Desenvolvedores...: Sergio sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de setores / unidade
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
<script>
	function salvar(acao){
		
			var intContMarcado=0;
			var frm = document.getElementById("frm");
	
			frm.action="setoresUnidade_cod.asp?acao=" + acao;
			frm.submit();
			return true;	 
	}
	
	function marcaTodos(){
		
		var frm = document.getElementById("frm");
		
		if(frm.chkTodos.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
		}else{
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
		}
		return true;
	}
</script>
<%
	strPaginaTitulo 	= "setoresUnidade_cad.asp"
	intCodSetor		= Trim(Request.Form("txtCodigo"))
	strSetor 		= Trim(Request.Form("txtSetor"))
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
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
              <td width="700" align="center" class="tituloSistema">Vincular Unidade ao Setor </td>
            </tr>
          </table>
		  <br>
		  <table width="703" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="77" class="texto1">Setor  :</td>
            <td width="626">
            <input name="txtCodigo" type="hidden" id="txtCodigo"  value="<%=intCodSetor%>">
            <input name="txtSetor" type="hidden" id="txtSetor"  value="<%=strSetor%>">
            <font size="+1"><strong><%=strSetor%></strong></font></td>
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
			sql = " SELECT distinct E.RAZAOSOCIAL, R.CODIGO_seg_empresa, r.codigo_MAT_setores, E.CODIGO AS COD_EMPRESA "
			sql = sql & " FROM SEG_EMPRESA E "
			sql = sql & " LEFT JOIN MAT_setores_empresa R ON R.CODIGO_seg_empresa = E.codigo and r.codigo_MAT_setores =" & intCodSetor
			sql = sql & " WHERE E.BLOQUEIO='N' "
			sql = sql & " AND E.COD_GRUPO = " & Session("CodGrupo")
			sql = sql & " Order by E.RAZAOSOCIAL	"	
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="5%" align="center" class="celula"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></td>
                    <td width="72%" height="21" align="center" class="celula"><strong>Unidade Escolar<span class="TextoForm"></span></strong></td>
                    </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					strMarca 	= ""
					if trim(intCodSetor) = trim(rs("codigo_MAT_setores")) then
						strMarca = "checked"
					end if
					%>

                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" >
                    <td align="center" class="celula" ><input name="chkEmp"  type="checkbox"  value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                    <td height="20" class="celula" ><%=trim(rs("RAZAOSOCIAL"))%></td>
                    </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="2" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
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