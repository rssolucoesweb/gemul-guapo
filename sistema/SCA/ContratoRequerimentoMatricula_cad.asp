<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Disciplina
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
<!--include file="../fckeditor/fckeditor.asp" -->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>
<script>

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		frm.action="ContratoRequerimentoMatricula_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "ContratoRequerimentoMatricula_cad.asp"
    strTexto 		= Trim(Request.Form("txtTexto"))
	
	sql = "SELECT texto"
	sql = sql & " FROM SCA_CONTRATOREQUERIMENTO"
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")			
	
	rs.open sql, cnn
	
	if rs.eof = false then
		
		strTexto	 			= rs("Texto")
		
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	rs.close

%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="4"><span class="TextoForm">
					    <%
						''Dim oFCKeditor
						''Set oFCKeditor = New FCKeditor
						''oFCKeditor.BasePath	="../../Sistema/fckeditor/"
						''oFCKeditor.Config("DefaultLanguage") = "pt-br"
						''oFCKeditor.Value = strTexto
						''oFCKeditor.Width = 800
						''oFCKeditor.Height = 400
						''oFCKeditor.Create "txtTexto"
						%>
                        <Textarea class="ckeditor" cols="80" rows="20" id="txtTexto" name="txtTexto"><%=strTexto%></textarea> 
					</span></td>
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