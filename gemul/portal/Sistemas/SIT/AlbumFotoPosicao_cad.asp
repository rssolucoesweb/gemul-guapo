<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<script>
		function salvar(acao){
		
			if (frm.cboPosicaoFoto.value == "0") {
				alert("A Nova Posição da Foto deve ser informada !");
				frm.cboPosicaoFoto.focus();
				return false;
			}
		
			frm.action="AlbumlFotoPosicao_cod.asp?acao=" + acao;
			frm.submit();
			return true;
 	}
</script>
<%	
	intCodId 				= Trim(Request.QueryString("CodFoto"))
	intCodAlbum 			= Trim(Request.QueryString("CodAlbum"))
	
	if trim(intCodId) <> "" then
	
		sql = "SELECT id, CodAlbum, Ordem"
		sql = sql & " FROM SIT_AlbumFoto"
		sql = sql & " Where id = " & intCodId
		sql = sql & " and CodAlbum = " & intCodAlbum
		rs.open sql, cnn
		
		if rs.eof = false then
			strFoto	 				= rs("Ordem")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
		end if 
		rs.close
	
	end if 
%>
<table width="98%" height="195" border="0" cellpadding="0" cellspacing="0" class="CorFundo" bgcolor="#FFFFFF">
  <tr  valign="top">
    <td width="428" height="193" align="center">
	<form method="post" id="frm">
	  <table width="436" height="20" border="0" cellpadding="0" cellspacing="0">
        <tr valign="top">
          <td width="436" align="center" class="tituloPrincipal style2">Altera Posi&ccedil;&atilde;o da Foto </td>
        </tr>
      </table>
	  <table width="100%" border="0">
        <tr>
          <td colspan="2"><input name="txtCodId" type="hidden" id="txtCodId" class="text" size="10" value="<%=intCodId%>" maxlength="10" />          </td>
        </tr>
        <tr>
          <td class="TextoForm">Foto Posi&ccedil;&atilde;o Atual : </td>
          <td><input name="txtFoto" type="text" class="text" id="txtFoto" size="10" maxlength="10" value="<%=strFoto%>" /></td>
        </tr>
        <tr>
          <td  width="37%" class="TextoForm">Alterar para Posi&ccedil;&atilde;o  :</td>
          <td width="63%"><span class="texto">
            <%
		  	sql = "SELECT id, CodAlbum, Ordem"
			sql = sql & " FROM SIT_AlbumFoto"
			sql = sql & " Where CodAlbum = " & intCodAlbum
			RS.OPEN SQL, CNN
		%>
            <select name="cboPosicaoFoto" id="cboPosicaoFoto" style="width:60pt" class="combo">
              <option value="0">Selecione...</option>
              <%
			IF RS.EOF = FALSE THEN
				while not rs.eof
					
					intOrdem = intOrdem + 1
					response.write "<option value=" & intOrdem & " " & strSelecionado &">" & ucase(intOrdem) & "</option> "  & vbcrlf
					rs.movenext
				wend
			END IF
			rs.close
			%>
            </select>
          </span></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2"><!--#include file="../../../includes/inc_botoes_cadastroPopap.asp"--></td>
        </tr>

        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
      </table>
	</form>
	</td>
  </tr>
</table>
</body>
</html>