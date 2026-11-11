<%strNomeDaPaginaPortal = "Foto Empresa"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>

<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function SalvarFoto(acao){
			
			if (acao=="I") {
					
				if(document.getElementById("Foto").value == ""){
					alert("A Foto deve ser informada !");
					document.getElementById("Foto").focus();
					return false		
				}
			
				if((document.getElementById("Foto").value.lastIndexOf(".JPG")==-1) && (document.getElementById("Foto").value.lastIndexOf(".jpg")==-1) && (document.getElementById("Foto").value.lastIndexOf(".GIF")==-1) && (document.getElementById("Foto").value.lastIndexOf(".gif")==-1) && (document.getElementById("Foto").value.lastIndexOf(".PNG")==-1) && (document.getElementById("Foto").value.lastIndexOf(".png")==-1)){  
					alert("Só é permitido fazer Upload de JPG, GIF ou PNG!"); 
					document.getElementById("Arq1").focus();
					return false  
				} 
				
				editar.action="Empresa_ViculaFoto_cod.asp?CodEmpresa="+document.getElementById("txtCodEmpresa").value+"&CodGrupo="+document.getElementById("txtCodGrupo").value;
				editar.submit();
				return true;
			}
			
			if (acao=="E"){
			
				var men = 'ATENÇÃO: Deseja realmente excluir esta Foto?\n '
				if (confirm(men)) {
					editar.action="Colaborador_ViculaFoto_cod_e.asp?CodEmpresa="+document.getElementById("txtCodEmpresa").value +"&NomeArquivo="+editar.txtNomeArquivo.value;
					editar.submit();
				} else {
					return false;
				}
			
			}
	}
</script>


<%  
'codigo fonte em ASP

	intCodGrupo			= Trim(Request.QueryString("CodGrupo"))
	intCodEmpresa		= Trim(Request.QueryString("CodEmpresa"))
	orientacao			= request("orientacao")
	
	if intCodEmpresa <> "0" then 
		
		sql = "SELECT Codigo, CodGrupo, RazaoSocial, NomeFantazia "
		sql = sql & " FROM SEG_empresa "
		sql = sql & " Where Codigo = " & intCodEmpresa
		sql = sql & " And CodGrupo = " & intCodGrupo
		rs.open sql, cnn
		
		if rs.eof = false then
			strRazaoSocial	= TRIM(rs("RazaoSocial"))
			strNomeFantazia	= TRIM(rs("NomeFantazia"))
		end if
		rs.close
	end if	
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">

    
   <form name="editar" action="" method="POST" enctype="multipart/form-data">
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">
          
          <table width="557" border="0">
            <tr>
              <td width="581">&nbsp;</td>
            </tr>
            <tr>
              <td align="center" class="texto"><table border="0" cellpadding="3" cellspacing="0" width="534">
                  <tr>
                    <td class="texto">Razão Social:
                      <input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa" class="text" size="10" readonly="false" value="<%=intCodEmpresa%>" maxlength="10" />
                      <input name="txtCodGrupo" type="hidden" id="intCodGrupo" class="text" size="10" readonly="false" value="<%=intCodGrupo%>" maxlength="10" /></td>
                    <td><input name="txtRazaoSocial" type="text" class="textDesabilitado" id="txtRazaoSocial"  readonly="false" size="50" maxlength="50" value="<%=strRazaoSocial%>"  onkeypress="return formataCampo(this, 1, 50)" /></td>
                  </tr>
                  <tr>
                    <td class="texto">Nome Fantasia:</td>
                    <td><input name="txtNomeFantasia" type="text" class="textDesabilitado" id="txtNomeFantasia"  readonly=false size="50" maxlength="50" value="<%=strNomeFantazia%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </td>
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
              <td align="center"><input type="button" name="botao" class="botao" onClick="SalvarFoto('I')" value="Enviar Foto">
                &nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" name="botao2" class="botao" onClick="window.location='empresa_cad.asp'" value="Voltar ao Cadastro" /></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
            <td height="148" align="center"><%
			
			PastaFotos = Server.MapPath("../../../Images/Grupo/" & intCodGrupo & "/Empresa/" & Session("CodEmpresa") )

			Set objFSO = CreateObject("Scripting.FileSystemObject")
			
			sql = "SELECT Arquivo "
			sql = sql & " FROM 	SEG_EMPRESA_FOTO"
			sql = sql & " Where CodEmpresa = " & intCodEmpresa
			rs.open sql, cnn
		
			if rs.eof = false then
		
				strCaminhoFoto 	= PastaFotos & "\" & trim(rs("Arquivo")) 
				
				intCodColaborador		= trim(rs("Arquivo")) 
				strNomeArquivo 		 	= trim(rs("Arquivo")) 
				
				IF objFSO.FileExists(strCaminhoFoto) = True THEN
				%>
			  	<table border="0" width="410" cellpadding="0" cellspacing="0" style="margin-left:15px;margin-right:15px;margin-top:0px;border-collapse: collapse" bordercolor="#111111">
					<tr>
					<td height="110" align="center" title="Foto Destaque"><img src="../../../Images/Grupo/<%=intCodGrupo%>/Empresa/<%=intCodEmpresa%>"></td>
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
        <hr size="1" color="#FFFFFF">

    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>