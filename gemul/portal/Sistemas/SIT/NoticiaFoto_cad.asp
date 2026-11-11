<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../../includes/inc_cnn.asp"-->
<script>

	function SalvarFoto(acao){
			
			if (acao=="I") {
				
				if (editar.Foto.value == "") {
					alert("A Foto deve ser informada !");
					editar.Foto.focus();  
					return false;
				}	
			
				if((editar.Foto.value.lastIndexOf(".JPG")==-1) && (editar.Foto.value.lastIndexOf(".jpg")==-1) && (editar.Foto.value.lastIndexOf(".GIF")==-1) && (editar.Foto.value.lastIndexOf(".gif")==-1)){  
					alert("Só é permitido fazer Upload de JPG, GIF, BMP ou PNG!"); 
					frm.Arq1.focus();  
					return false  
				} 
				
				editar.action="NoticiaFoto_cod.asp?CodNoticia="+editar.txtCodNoticia.value;
				editar.submit();
				return true;
			}
			
			if (acao=="E"){
			
				var men = 'ATENÇÃO: Deseja realmente excluir esta Foto?\n '
				if (confirm(men)) {
					editar.action="NoticiaFoto_cod_e.asp?CodNoticia="+editar.txtCodNoticia.value+"&NomeArquivo="+editar.txtNomeArquivo.value;
					editar.submit();
				} else {
					return false;
				}
			
			}
			
	}
</script>
<%	
	intCodNoticia		= Trim(Request.QueryString("CodNoticia"))
		
	if intCodNoticia <> 0 then 
		
		sql = "SELECT Codigo, Retranca, Titulo"
		sql = sql & " FROM SIT_Noticias"
		sql = sql & " Where Codigo = " & intCodNoticia
		sql = sql & " ORDER BY Titulo"
		
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodNoticia 		= rs("Codigo")
			strRetranca			= rs("Retranca")
			strTitulo			= rs("Titulo")
		end if
		rs.close
	end if

%>
<table width="500" height="398" cellpadding="0" cellspacing="0" class="CorFundo" bgcolor="#FFFFFF">
  <tr  valign="top">
    <td width="500" height="365" align="center"  class="celula">
    <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
        <tr>
            <td width="97%" class="CelulaDoCadastro" align="center" valign="top">

	<form name="editar" action="" method="POST" enctype="multipart/form-data">


	  <table width="100%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal"><span class="tituloPrincipal style2">Foto Da Not&iacute;cia </span></td>
        </tr>
        <tr valign="top">
          <td align="left" >
		 </td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><table width="557" border="0">
            <tr>
              <td width="581"><span class="texto">
                <input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="5" maxlength="5" value="<%=intCodNoticia%>" />
              </span></td>
            </tr>
            <tr>
              <td align="center" class="texto"><table border="0" cellpadding="3" cellspacing="0" width="534">

                  <tr>
                    <td class="texto">C&oacute;digo:</td>
                    <td><input name="txtCodNoticia" type="text" id="txtCodNoticia" class="text" size="10" readonly=false value="<%=intCodNoticia%>" maxlength="10"></td>
                  </tr>
                  <tr>
                    <td class="texto">Matr&iacute;cula:</td>
                    <td><span class="texto1">
                      <input name="txtRetranca" type="text" class="text" id="txtRetranca" size="50" readonly=false maxlength="9" value="<%=strRetranca%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="carregaAluno()">
                    </span></td>
                  </tr>
                  <tr>
                    <td class="texto">Nome Aluno</td>
                    <td><span class="texto1">
                      <input name="txtTitulo" type="text" class="text" id="txtTitulo"  readonly=false size="50" maxlength="50" value="<%=strTitulo%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </span></td>
                  </tr>
                  <tr>
                    <td width="120" class="texto">Selecione a Foto:</td>
                    <td width="402"><input type="file" name="Foto" id="Foto" class="text" value="" style="width:400px;"></td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto">Para enviar fotos, selecione-a em seu computador clicando nos bot&otilde;es
          &quot;Procurar&quot;.</td>
                    </tr>
                  <tr>
                    <td colspan="2" class="texto">Aviso: Envie apenas arquivo JPG, GIF, BMP ou PNG.</td>
                    </tr>
              </table></td>
            </tr>
            <tr>
              <td align="center"><input type="button" name="botao" class="botao" onClick="SalvarFoto('I')" value="Enviar Foto"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
            <td height="148" align="center"><%
			
			PastaFotos = Server.MapPath("../../../FotoNoticia") 
			
			Set objFSO = CreateObject("Scripting.FileSystemObject")
			
			sql = "SELECT id, CodNoticia, Arquivo"
			sql = sql & " FROM SIT_NoticiaFoto"
			sql = sql & " Where CodNoticia = " & intCodNoticia
			rs.open sql, cnn
			
			if rs.eof = false then
				
				strCaminhoFoto 	= PastaFotos & "/" & session("codEmpresa") & "/" & trim(rs("CodNoticia")) & "/" & trim(rs("Arquivo"))
				strNomeArquivo  = trim(rs("Arquivo"))
								
				IF objFSO.FileExists(strCaminhoFoto) = True THEN
				%>
			  	<table border="0" width="410" cellpadding="0" cellspacing="0" style="margin-left:15px;margin-right:15px;margin-top:0px;border-collapse: collapse" bordercolor="#111111">
					<tr>
					<td height="110" align="center" title="Foto Destaque"><img src="../../FotoNoticia/<%=intCodNoticia%>/<%=trim(rs("Arquivo"))%>"></td>
					</tr>
					<tr>
					<td height="24" align="center" class="menu3" title="Foto Destaque"><a href="#" onClick="SalvarFoto('E')" title="Excluir"><img border="0" src="../../images/icone_excluir.gif" width="13" height="13"> excluir foto</a>                          </td>
					</tr>
			 	</table>
				<%
				end if
			else
				Response.Write "<center class='texto'>Nenhuma Foto</center><br>"
			end if
			rs.close		
			%></td>
            </tr>
            <tr>
              <td height="19" align="center"><span class="titulo1">
                <input name="txtNomeArquivo" type="hidden" class="text" id="txtNomeArquivo" size="40" maxlength="40" value="<%=strNomeArquivo%>" />
              </span></td>
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
  <tr >
  <td height="31" align="center"  class="celula"><span class="textSite">
  <input name="cmdFechar" type="button"  class="botao" id="cmdFechar" style="cursor:hand" onClick="window.close()"   value="Fechar" <%=strDesabilitaPrincipal%>>
  </span></td>
  </tr>
</table>
</body>
</html>