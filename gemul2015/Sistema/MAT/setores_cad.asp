<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/12/2017
	::	Desenvolvedores...: Sergio sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de setores 
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
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function vinculaUnidade(intCodigo, strSetor){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.txtSetor.value=strSetor;
		frm.action="setoresUnidade_cad.asp";
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("O descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="setores_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 	= "setores_cad.asp"
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Descricao"
		sql = sql & " FROM MAT_SETORES"
		sql = sql & " where Cod_grupo = " & Session("CodGrupo")			
		sql = sql & " and Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("CODIGO")
			strDescricao			= rs("DESCRICAO")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
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
              <td width="700" align="center" class="tituloSistema">Setores </td>
            </tr>
          </table>
		  <br>
            <input name="txtCodigo" type="hidden" id="txtCodigo"  value="<%=intCodigo%>">
            <input name="txtSetor" type="hidden" id="txtSetor"  value="<%=strSetor%>">
		  <table width="703" border="0" cellspacing="0" cellpadding="0">
		<%if Session("UsuarioMaster") = "S" then%>
          <tr>
            <td width="77" class="texto1">Descri&ccedil;&atilde;o  :</td>
            <td width="626">
            <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="100" value="<%=strDescricao%>">
            </td>
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
		<%end if%>
          <tr>
            <td colspan="2"><%
			cont =0
			sql = "SELECT m.Codigo, m.Descricao"
			sql = sql & " FROM MAT_SETORES m"
			sql = sql & " where m.Cod_grupo = " & Session("CodGrupo")			
			sql = sql & " Order by m.Descricao"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="8%" class="celula"><strong>Codigo </strong></td>
                    <td width="72%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>

                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" >
                    <td class="celula" onClick="return resultadoConsulta('<%=rs("Codigo")%>')"><%=rs("Codigo")%></td>
                    <td height="20" class="celula" onClick="return resultadoConsulta('<%=rs("Codigo")%>')"><%=trim(rs("Descricao"))%></td>
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