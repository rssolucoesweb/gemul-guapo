<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/05/2008
	::	Desenvolvedores...: Sérgio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Documentos
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {
	color: #009900;
	font-weight: bold;
}
-->
</style>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../fckeditor/fckeditor.asp" -->
<script>

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtTitulo.value == "") {
			alert("Titulo deve ser informado!");
			frm.txtTitulo.focus();
			return false;
		}
		
		if (frm.cmbDepartamento.value == "0") {
			alert("O departamento deve ser informado!");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		frm.action="MensagensModelo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<script src="../../js/js_funcoes_gerais.js"></script>
<%
strPaginaTitulo 	= "MensagensModelo_cad.asp"
strPagina			= "MensagensModelo_cad.asp"
intCodMensagem		= Trim(Request.Form("txtCodigo"))
strTitulo	 		= Trim(Request.Form("txtTitulo"))
strDescricao 		= Trim(Request.Form("txtDescricao"))

if TRIM(Session("NivelPermissao")) = "A" then
   strMostraSomenteDeptoAtual = "" 'mostra todos os deptos
else   
   strMostraSomenteDeptoAtual = "S" 'mostra somente o depto atual
end if	
if trim(intCodMensagem) <> "" then

	sql = "SELECT codigo, titulo, cod_departamento, mensagem"
	sql = sql & " FROM SCA_MENSAGENSMODELO"
	sql = sql & " Where codigo = " & intCodMensagem
	sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
	rs.open sql, cnn
	
	if rs.eof = false then
		
		strTitulo 				= rs("Titulo")
		strDescricao			= rs("mensagem")
		intCodDepartamento		= rs("cod_departamento")

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
	<table width="877"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td width="913" colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		<table width="705" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="705" height="80" class="texto1"><table width="876" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="178" height="23" class="texto1"><strong>T&iacute;tulo : </strong></td>
					<td width="715"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodMensagem%>" maxlength="10">
					  <input name="txtTitulo" type="text" class="text" id="txtTitulo" size="50" maxlength="50" value="<%=strTitulo%>"></td>
				  </tr>
				  <tr>
				    <td height="23" class="texto1"><strong>Departamento : </strong></td>
				    <td><!--#include file="../includes/inc_cmdDepartamento.asp" --></td>
				    </tr><br>
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
					<td height="19" colspan="2" align="center" bgcolor="#EFEFDE"><span class="texto1"><strong>Texto da Mensagem </strong></span></td>
				  </tr>
				  <tr>
					<td colspan="2"><span class="TextoForm">
					  <%
								Dim oFCKeditor
								Set oFCKeditor = New FCKeditor
								oFCKeditor.BasePath	="../../Sistema/fckeditor/"
								oFCKeditor.Config("DefaultLanguage") = "pt-br"
								oFCKeditor.Value = strDescricao
								'oFCKeditor.Width = 540
								oFCKeditor.Height = 200
								oFCKeditor.Create "txtDescricao"
								%>
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
				  <tr>
					<td colspan="2">
		<%
					cont =0
					
					sql = "SELECT CODIGO, TITULO"
					sql = sql & " FROM SCA_MENSAGENSMODELO"
					sql = sql & " where cod_empresa = " & Session("CodEmpresa")	
					if strMostraSomenteDeptoAtual = "S" then
					   SQL = SQL & " AND (cod_departamento=" & Session("CodDeptoUsuario") & " or cod_departamento is null)"
					end if   
					sql = sql & " Order by TITULO"
					rs.open sql, cnn
									
					if rs.eof = false then
					%>
						<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
						  <tr bgcolor="#E5E5E5">
						    <td height="21" colspan="2" bgcolor="#E5E5E5" class="celula" align="center"><strong>Mensagens Cadastradas </strong></td>
						    </tr>
						  <tr bgcolor="#E5E5E5">
							<td width="10%" height="21" class="celula"><strong>C&oacute;digo</strong></td>
							<td width="90%" class="celula"><strong>T&iacute;tulo<span class="TextoForm"></span></strong></td>
							</tr>
						  <%
						while not rs.eof
							cont = cont + 1	
							%>
						  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
							<td height="20" class="celula"><%=rs("codigo")%></td>
							<td class="celula"><%=trim(rs("titulo"))%></td>
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
					  rs.close%>			</td>
				  </tr>
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>
				</table></td>
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