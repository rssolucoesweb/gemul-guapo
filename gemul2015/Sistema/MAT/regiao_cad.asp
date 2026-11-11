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
	
	function vinculaSetor(intCodigo, txtRegiao){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.txtRegiao.value=txtRegiao;
		frm.action="regiaoSetor_cad.asp";
		frm.submit();
	}

	function vinculaUnidade(intCodigo, txtRegiao){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.txtRegiao.value=txtRegiao;
		frm.action="regiaoUnidade_cad.asp";
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("O descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="regiao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 	= "regiao_cad.asp"
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodigo) <> "" then
		sql = "SELECT Codigo, Descricao"
		sql = sql & " FROM MAT_REGIAO"
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
              <td width="700" align="center" class="tituloSistema">Região </td>
            </tr>
          </table>
		  <br>
            <input name="txtCodigo" type="hidden" id="txtCodigo"  value="<%=intCodigo%>">
            <input name="txtRegiao" type="hidden" id="txtRegiao"  value="<%=strRegiao%>">
		  <table width="703" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="77" class="texto1">Descri&ccedil;&atilde;o:</td>
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
          <tr>
            <td colspan="2"><%
			cont =0
			sql = "SELECT m.Codigo, m.Descricao, (select isnull(count(*),0) from MAT_regiao_setores where cod_regiao = m.codigo) as setor_vinculado, (select isnull(count(*),0) from MAT_regiao_empresa where cod_regiao = m.codigo) as unidade_vinculada"
			sql = sql & " FROM MAT_REGIAO m"
			sql = sql & " where m.Cod_grupo = " & Session("CodGrupo")			
			sql = sql & " Order by m.Descricao"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="63%" height="21" rowspan="2" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o (Regi&atilde;o)</span></strong></td>
                    <td height="21" colspan="2" align="center" class="celula"><strong>Vinculado</strong><strong></strong></td>
                    <td colspan="2" align="center" class="celula"><strong>A&ccedil;&atilde;o</strong></td>
                    </tr>
                  <tr bgcolor="#E5E5E5">
                    <td width="6%" align="center" class="celula"><strong>Setor</strong></td>
                    <td width="6%" height="21" align="center" class="celula"><strong>Escola</strong></td>
                    <td width="6%" align="center" class="celula"><strong>Setor</strong></td>
                    <td width="8%" align="center" class="celula"><strong>Escola</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" >
                    <td onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" height="20" class="celula" onClick="return resultadoConsulta('<%=rs("Codigo")%>')"><%=trim(rs("Descricao"))%></td>
                    <td onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" align="center" class="celula" onClick="return abreConsulta('regiaoSetor_con.asp?txtCodRegiao=<%=rs("codigo")%>&txtRegiao=<%=rs("descricao")%>')">&nbsp;<%=trim(rs("setor_vinculado"))%></td>
                    <td onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" align="center" class="celula" onClick="return abreConsulta('regiaoUnidade_con.asp?txtCodRegiao=<%=rs("codigo")%>&txtRegiao=<%=rs("descricao")%>')">&nbsp;<%=trim(rs("unidade_vinculada"))%></td>
                    <td align="center" class="celula"  onClick="return vinculaSetor('<%=rs("Codigo")%>','<%=rs("Descricao")%>')"><img src="../../../images/botao_azul_normal.gif" width="26" height="26"></td>
                    <td height="20" align="center" class="celula"  onClick="return vinculaUnidade('<%=rs("Codigo")%>','<%=rs("Descricao")%>')"><img src="../../../images/botao_azul_normal.gif" width="26" height="26"></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="5" class="celula">Total Registros: <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
          </tr>
        </table>
        <br>
        <input name="bntSetor" type="button" class="botao" id="bntSetor" style="cursor:hand" onClick="window.location='setorSemVinculo_con.asp'"  value=" Setor sem vinculo ">
        &nbsp;&nbsp;&nbsp;
        <input name="bntUnidade" type="button" class="botao" id="bntUnidade" style="cursor:hand" onClick="window.location='unidadeSemVinculo_con.asp'"  value=" Unidade sem vinculo ">
        <br>
        <br>
        <br>
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