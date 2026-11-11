<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_cnn.asp"-->
<script>

	function SalvarLogoMarca(acao){
			
			var frm = document.getElementById("frm");
			
			if (acao=="I") {
				
				if (editar.Foto.value == "") {
					alert("A Foto deve ser informada !");
					editar.Foto.focus();  
					return false;
				}	
			
				if((editar.Foto.value.lastIndexOf(".JPG")==-1) && (editar.Foto.value.lastIndexOf(".jpg")==-1) && (editar.Foto.value.lastIndexOf(".GIF")==-1) && (editar.Foto.value.lastIndexOf(".gif")==-1) && (editar.Foto.value.lastIndexOf(".PNG")==-1) && (editar.Foto.value.lastIndexOf(".png")==-1)){  
					alert("Só é permitido fazer Upload de JPG, GIF ou PNG!"); 
					frm.Arq1.focus();  
					return false  
				} 
				
				editar.action="EmpresaLogoMarca_cod.asp?CodEmpresa="+editar.txtCodEmpresa.value + "&CodGrupo=" +editar.txtCodGrupo.value;
				editar.submit();
				return true;
			}
			
			if (acao=="E"){
			
				var men = 'ATENÇÃO: Deseja realmente excluir esta Foto?\n '
				if (confirm(men)) {
					editar.action="EmpresaLogoMarca_cod_e.asp?CodEmpresa="+editar.txtCodEmpresa.value + "&CodGrupo=" +editar.txtCodGrupo.value +"&NomeArquivo="+editar.txtNomeArquivo.value;
					editar.submit();
				} else {
					return false;
				}
			
			}
	}
</script>
<%	
	intCodEmpresa		= Trim(Request.QueryString("CodEmpresa"))
	intCodGrupo			= Trim(Request.QueryString("CodGrupo"))
	
	if intCodEmpresa <> "" and  intCodGrupo <> "" then 
		
		sql = "SELECT CODIGO, COD_GRUPO, RAZAOSOCIAL "
		sql = sql & " FROM SEG_EMPRESA "
		sql = sql & " Where CODIGO = " & intCodEmpresa
		sql = sql & " And COD_GRUPO = " & intCodGrupo
		rs.open sql, cnn
		
		if rs.eof = false then
			strRazaoSocial	= TRIM(rs("RAZAOSOCIAL"))
		end if
		rs.close
	end if

%>
<table width="500" height="398" cellpadding="0" cellspacing="0" class="CorFundo" bgcolor="#FFFFFF">
  <tr  valign="top">
    <td width="500" height="365" align="center"  class="celula">
	<form name="editar" action="" method="POST" enctype="multipart/form-data">
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal"><span class="tituloPrincipal style2">Logo Marca</span></td>
        </tr>
        <tr valign="top">
          <td align="left" >
		 </td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><table width="557" border="0">
            <tr>
              <td width="581"><input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa" class="text" size="10" readonly=false value="<%=intCodEmpresa%>" maxlength="10">
                      <input name="txtCodGrupo" type="hidden" id="txtCodGrupo" class="text" size="10" readonly=false value="<%=intCodGrupo%>" maxlength="10"></td>
            </tr>
            <tr>
              <td align="center" class="texto"><table border="0" cellpadding="3" cellspacing="0" width="534">
                  <tr>
                    <td width="120" class="texto">Selecione a Logo:</td>
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
              <td align="center"><input type="button" name="botao" class="botao" onClick="SalvarLogoMarca('I')" value="Enviar Foto"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
            <td height="148" align="center"><%
			
			PastaFotos = Server.MapPath("../../LogoMarcas") & "/" & intCodEmpresa
			
			Set objFSO = CreateObject("Scripting.FileSystemObject")
			
			sql = "SELECT LOGOMARCA "
			sql = sql & " FROM SEG_EMPRESA "
			sql = sql & " Where CODIGO = " & intCodEmpresa
			sql = sql & " And COD_GRUPO = " & intCodGrupo
			rs.open sql, cnn
		
			if rs.eof = false then
		
				strCaminhoFoto 	= PastaFotos & "\" & trim(rs("LOGOMARCA")) 
				strLogoMarca = trim(rs("LOGOMARCA")) 
				
				IF objFSO.FileExists(strCaminhoFoto) = True THEN
				%>
			  	<table border="0" width="410" cellpadding="0" cellspacing="0" style="margin-left:15px;margin-right:15px;margin-top:0px;border-collapse: collapse" bordercolor="#111111">
					<tr>
					<td height="110" align="center" title="Foto Destaque"><img src="../../LogoMarcas/<%=intCodEmpresa%>/<%=strLogoMarca%>"></td>
					</tr>
					<tr>
					<td height="24" align="center" class="menu3" title="Foto Destaque"><a href="#" onClick="SalvarLogoMarca('E')" title="Excluir"><img border="0" src="../../images/icone_excluir.gif" width="13" height="13"> Excluir Logo Marca</a>                          </td>
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
                <input name="txtNomeArquivo" type="hidden" class="text" id="txtNomeArquivo" size="40" maxlength="40" value="<%=strLogoMarca%>" />
              </span></td>
            </tr>
          </table></td>
        </tr>
      </table>
	  </form>
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