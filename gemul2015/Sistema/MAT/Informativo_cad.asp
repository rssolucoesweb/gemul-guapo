<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 2/04/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Ata
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>
<script>

	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTipoEmpresa.value == "0") {
			alert("O  Tipo Empresa deve ser informado !");
			frm.cmbTipoEmpresa.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="Informativo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 		= "Informativo_cad.asp"
	strPagina				= "Informativo_cad.asp"

	intCodGrupo	 			= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodTipoEmpresa		= Trim(Request("cmbTipoEmpresa"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDados 				= Trim(Request.Form("txtDados"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_grupo, CodTipoEmpresa, Descricao, Dados"
		sql = sql & " FROM MAT_Dados"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & Session("CodGrupo")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			intCodTipoEmpresa 		= rs("CodTipoEmpresa")
			strDescricao	 		= rs("Descricao")
			strDados	 			= rs("Dados")

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			
		else
				
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		
		end if 
		rs.close
	else
	
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
<table width="100%" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr>
    <td>
    <form id="frm" method="post">
    	
		<table width="98%" border="0"  align="center" class="CorFundo" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="2" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%>&nbsp;</td>
            </tr>
          <tr>
            <td width="12%" class="texto1">&nbsp;</td>
            <td width="88%"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td class="texto1">Tipo Empresa:</td>
            <td><span class="titulo1">
              <!--#include file="../includes/inc_cmbTipoEmpresa.asp"-->
            </span></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Descri&ccedil;&atilde;o:</td>
            <td><input name="txtDescricao" type="text" class="text" id="txtDescricao" value="<%=strDescricao%>" size="50"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#CCCCCC" class="texto1"><strong>Dados:</strong></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">
			 <Textarea class="ckeditor" cols="80" id="txtDados" name="txtDados"><%=strDados%></textarea>
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
            <td colspan="2">
			<%
			
			cont =0
			
			sql = "SELECT Codigo, Cod_grupo, CodTipoEmpresa, Descricao, Dados"
			sql = sql & " FROM MAT_Dados"
			sql = sql & " Where Cod_grupo = " & session("CodGrupo")
			sql = sql & " Order by codigo"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width="98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="8%" class="celula"><strong>C&oacute;digo </strong></td>
                    <td height="21" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                    <td class="celula"><%=rs("Codigo")%></td>
                    <td height="20" class="celula"><%=trim(rs("Descricao"))%></td>
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
			  rs.close
			  
			  %></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
    
    </form>
    </td>
  </tr>
</table>

<!--#include file="../rodape.asp"-->
</body>
</html>