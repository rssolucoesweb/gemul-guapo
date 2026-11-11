<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha Descritiva - Pergunta
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="I") {
			
			if (frm.cmbFichaDescritiva.value == ""){
				alert("A Ficha descritiva deve ser informada.");
				frm.cmbFichaDescritiva.focus();
				return false;
			}
	
			if (frm.txtDescricao.value == "") {
				alert("A Pergunta deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
		
		}
		
		if (acao=="E"){
			
			var intContMarcado =0;
			var intCodPergunta = "0";
			
			for (var i = 0; i < frm.elements.length; i++) 
			{
				//verifica todos os checkbox
				if (frm.elements[i].name.substring(0,19) == "chkPergunta"){				
					if (frm.elements[i].checked) {
						intContMarcado = intContMarcado + 1;
						intCodPergunta = intCodPergunta + "," + frm.elements[i].value;
					}
				}
			}
			
			if (intContMarcado==0){
				alert("ATENCAO: Pelo menos uma Pergunta deve ser selecionado, Verifique!");
				return false;
			}

		}
	
		frm.action="FichaDescritivaPergunta_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strExecutarSubmit				= "S"
	strPaginaTitulo 				= "FichaDescritivaPergunta_cad.asp"
	intCodigo						= Trim(Request.Form("txtCodigo"))
	
	if request.QueryString("CodFichaDescritivao") <> "" then
		intCodFichaDescritiva	= Trim(Request.QueryString("CodFichaDescritivao"))
	else
		intCodFichaDescritiva			= Trim(Request.Form("cmbFichaDescritiva"))
	end if
	
	strSubtitulo 					= Trim(Request.Form("txtSubtitulo"))
	strDescricao 					= Trim(Request.Form("txtDescricao"))
	if intCodFichaDescritiva = "" then intCodFichaDescritiva = "0"
	
	
	' Consulta Ficha Descritiva
	if trim(intCodFichaDescritiva) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Situacao, observacoes, rodape, Publicar"
		sql = sql & " FROM SCA_FICHA_DESCRITIVA"
		sql = sql & " Where Codigo = " & intCodFichaDescritiva
		rs.open sql, cnn
		if rs.eof = false then
			strDescricaoFichaDescritiva			= rs("Descricao")
		end if 
		rs.close

	end if 
	
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, cod_ficha_descritiva, Subtitulo, Descricao "
		sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA"
		sql = sql & " Where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo								= rs("Codigo")
			intCodFichaDescritiva	 				= rs("Cod_ficha_descritiva")
			strSubtitulo							= trim(rs("Subtitulo"))
			strDescricao							= trim(rs("Descricao"))

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	end if 
	
	if intCodAvaliacaoInstitucional = "" then intCodAvaliacaoInstitucional = 0
%>
<form id="frm" method="post">
<table align="center" width="98%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr valign="top">
  <td align="center" class="tituloSistema">Ficha Descritiva - Perguntas</td>
</tr>
</table>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
          <tr>
            <td height="28" class="texto1">&nbsp;</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td width="119" height="28" class="texto1">Ficha Descritiva:</td>
            <td width="721"><!--#include file="../includes/inc_cmdFichaDescritiva.asp" --></td>
    </tr>
          <tr>
            <td height="27" class="texto1">Subt&iacute;tulo:</td>
            <td class="texto1"><input name="txtSubtitulo" type="text" class="text" id="txtSubtitulo" size="100" maxlength="300" value="<%=strSubtitulo%>">
            - M&aacute;ximo 300 caracteres</td>
          </tr>
          <tr>
            <td height="27" class="texto1">Pergunta : </td>
            <td class="texto1"><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="100" maxlength="300" value="<%=strDescricao%>">
- M&aacute;ximo 300 caracteres</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">Obs: Informar o subt&iacute;tulo somente quando houver a necessidade de quebrar um determinado assunto dentro do question&aacute;rio. </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastroPopap.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			cont =0
			
			if intCodFichaDescritiva <> "0" then
			
				sql = "SELECT Codigo, cod_ficha_descritiva, Subtitulo, Descricao "
				sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA"
				if strCompartilharDados = "S" then
					sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
				else   
					sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
				end if   
				sql = sql & " And cod_ficha_descritiva = " & intCodFichaDescritiva
				sql = sql & " Order by Codigo"
								
				rs.open sql, cnn
				
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="5%" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
                    <td width="9%" class="celula"><strong>Ordem</strong></td>
                    <td width="11%" class="celula"><strong>Cod.Quest&atilde;o</strong></td>
                    <td width="75%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                  </tr>
                  <%
					while not rs.eof
						cont = cont + 1	
						if trim(rs("Subtitulo")) <> "" then
						   %>
						   <tr bgcolor="#E5E5E5">
						   <td height="21" colspan="4" class="celula"><%=trim(rs("Subtitulo"))%></td>
					       </tr>
						   <%
						end if   
						%>
						<tr>
						<td align="center" class="celula"><input type="checkbox" id="chkPergunta" name="chkPergunta" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
						<td class="celula"><%=cont%></td>
						<td style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')" align="center" class="celula"><%=trim(rs("Codigo"))%></td>
						<td style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')" height="21" class="celula"><%=trim(rs("Descricao"))%></td>
						</tr>
						<%				
						rs.movenext
					wend
				  %>
                  <tr>
                  <td height="21" colspan="4" class="celula">Total de Quest&otilde;es : <%=cont%></td>
                  </table>
            <%
			  end if
			  rs.close
			  end if
			  %>			  </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
</form>
</body>
</html>