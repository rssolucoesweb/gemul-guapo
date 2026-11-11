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
              <td width="700" align="center" class="tituloSistema">Setor sem vinculo </td>
            </tr>
          </table>
		  <br>
            <input name="txtCodigo" type="hidden" id="txtCodigo"  value="<%=intCodigo%>">
            <input name="txtRegiao" type="hidden" id="txtRegiao"  value="<%=strRegiao%>">
		  <table width="703" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="703">&nbsp;</td>
          </tr>
          <tr>
            <td><%
			cont =0
			sql = "select descricao from mat_setores "
			sql = sql & " where cod_grupo= " & Session("CodGrupo")
			sql = sql & " and codigo not in (select cod_setores from MAT_regiao_setores)"
			sql = sql & " order by 1"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="63%" height="21" class="celula"><strong>Setores<span class="TextoForm"></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>

                  <tr >
                    <td height="20" class="celula" ><%=trim(rs("Descricao"))%></td>
                    </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" class="celula">Total Registros: <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
          </tr>
        </table>
          <input name="bntSetor" type="button" class="botao" id="bntSetor" style="cursor:hand" onClick="window.location='regiao_cad.asp'"  value="<<  Voltar " >
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