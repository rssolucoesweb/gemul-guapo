<%strNomeDaPaginaPortal = "Cadastro de Fotos"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	
	function Voltar(){
		
		var editar = document.getElementById("editar");
		
		editar.action="Album_cad.asp"
		editar.submit();
		return true;
 	}
	
	function SalvarFoto(){
		
		var editar = document.getElementById("editar");
		var orientacao;
		
		if (editar.Foto.value == "") {
			alert("A foto deve ser informada !");
			editar.Foto.focus();  
			return false;
		}	
		
		if (editar.orientacao[0].checked==true){
			orientacao = "H";		
		}
		if (editar.orientacao[1].checked==true){
			orientacao = "V";
		}
		
		editar.action="AlbumFoto_cod.asp?CodAlbum="+editar.txtCodigo.value+"&orientacao="+orientacao;
		editar.submit();
		return true;

 	}
	
	function Excluir(id, intCodAlbum){
		
		var editar = document.getElementById("editar");
		
		var men = 'ATENÇÃO: Deseja realmente excluir esta Foto?\n '
		if (confirm(men)) {
			editar.action="AlbumFoto_alt.asp?id="+ id + "&CodAlbum="+intCodAlbum;
			editar.submit();
		} else {
			return false;
		}
	
	}
	
	function Destaque(acao,id,intCodAlbum){
		
		var editar = document.getElementById("editar");
		
		editar.action="AlbumFoto_alt.asp?acao="+acao + "&id="+ id + "&CodAlbum="+intCodAlbum;
		editar.submit();
		return true;
 	}
	
	function TrocaPosicao(id,CodAlbum){
		
		var editar = document.getElementById("editar");
		
		window.open("AlbumFotoPosicao_cad.asp?CodFoto="+id + "&CodAlbum="+CodAlbum,"","toolbar=no,status=no,location=no,scrollbars=no,menubar=no,resizable=no, width=500 height=170,top=0,lef=0");
		return true;
 	}
	
	function AlteraDescricao(id,Descricao){
		
		var editar = document.getElementById("editar");
		
		window.open("AlbumFotoDescricao_cad.asp?CodFoto="+id + "&Descricao="+Descricao,"","toolbar=no,status=no,location=no,scrollbars=no,menubar=no,resizable=no, width=500 height=170,top=0,lef=0");
		return true;
 	}
	
</script>
<%
	principal		= "principal.asp"
	intCodEmpresa	= session("codEmpresa")	
	intCodAlbum		= Trim(Request("CodAlbum"))
	orientacao		= request("orientacao")
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
   	<!-- inicio do formulario da pagina-->

<table width="98%" border="0">
            <tr>
              <td align="right"><input name="cmdVoltar" type="button" class="botao" id="cmdVoltar" style="cursor:hand" onClick="return Voltar()"   value="Voltar" ></td>
            </tr>
            <tr>
              <td><span class="texto">
                <input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="5" maxlength="5" value="<%=intCodAlbum%>" />
              </span></td>
            </tr>
            <tr>
              <td align="center">
              <table border="0" cellpadding="3" cellspacing="0" width="98%">
                  <tr>
                    <td width="138" height="38" class="texto"><strong>Descri&ccedil;&atilde;o:</strong></td>
                    <td width="656" ><input name="Descricao" type="text" class="text" style="width:400px;" value="" size="50" maxlength="60"></td>
                  </tr>
                  <tr>
                    <td width="138" class="texto"><strong>Selecione a Foto:</strong></td>
                    <td width="656"><input type="file" name="Foto" id="Foto" class="text" value="" style="width:400px;"></td>
                  </tr>
                  <tr>
                    <td class="texto"><strong>Orienta&ccedil;&atilde;o:</strong></td>
                    <td class="texto">
                      <input name="orientacao" type="radio" value="H" checked >
                      <strong>Foto Horizontal</strong>&nbsp;&nbsp;					  
					  <input name="orientacao" type="radio" value="V" >
					  <strong>Foto Vertical</strong>
					  </td>
                  </tr>
                  <tr>
                    <td width="138">&nbsp;</td>
                    <td width="656" class="texto">Aviso: Envie apenas arquivo JPG, GIF, BMP ou PNG.</td>
                  </tr>
              </table>
              </td>
            </tr>
            <tr>
              <td align="center"><input type="button" name="botao" class="botao" onClick="SalvarFoto()" value="Enviar Foto"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td align="center">
			  <%
			
			PastaFotos = Server.MapPath("../../../FotoAlbum") & "\" & intCodEmpresa & "\" & intCodAlbum
			Set objFSO = CreateObject("Scripting.FileSystemObject")
			
		  	sql = "SELECT id, CodAlbum, Descricao, Destaque, ordem"
			sql = sql & " FROM SIT_AlbumFoto"
			sql = sql & " Where CodAlbum = " & intCodAlbum
			sql = sql & " Order by ordem, id"
			rs.open sql, cnn
			
			if rs.eof = false then
		
				Do While Not Rs.EOF
				
					strCaminhoFoto 	= PastaFotos & "\" & rs("id") & "_p.jpg"
					intID			= rs("id")
					strDescricao	= rs("descricao")
					
					IF objFSO.FileExists(strCaminhoFoto) = True THEN
					%>
			  		<table border="0" width="100%" cellpadding="0" cellspacing="0" style="margin-left:15px;margin-right:15px;margin-top:0px;border-collapse: collapse" bordercolor="#111111">
                	<tr>
                  	<td width="63" align="center" class="texto"><%=Rs("ordem")%></td>
                  	<td width="154" height="110" align="center" <% if Rs("Destaque") = true then %> bgcolor="#FED71C" <%end if%>><img src=../../../FotoAlbum/<%=intCodEmpresa%>/<%=intCodAlbum%>/<%=rs("id") & "_p.jpg"%>> </td>
                  	<td width="124" align="center" class="menu3"><a href="#" onClick="Excluir('<%=intID%>','<%=intCodAlbum%>')" title="Excluir"><img border="0" src="../../../images/icone_excluir.gif" width="13" height="13">&nbsp;Excluir foto</a></td>
                  	<td width="161" align="center" class="menu3">&nbsp;
                    <% if trim(Rs("Destaque")) = "Falso" or trim(Rs("Destaque")) = "False" then %>
                    	<a href="#" onClick="Destaque('A','<%=intID%>','<%=intCodAlbum%>')"><img border="0" src="../../../images/icone_destaque.gif" width="13" height="13">&nbsp;Tornar Foto Destaque</a>
                    <%else%>
                    	Foto em Destaque
                    <%end if%>
                  </td>
                  <td width="152" align="center" class="menu3"><a href="#" onClick="TrocaPosicao('<%=intID%>','<%=intCodAlbum%>')" title="Troca Foto Posi&ccedil;&atilde;o"><img border="0" src="../../../images/foto.gif" width="13" height="13">&nbsp;Troca Posi&ccedil;&atilde;o Foto</a></td>
                  <td width="192" align="center" class="menu3"><a href="#" onClick="AlteraDescricao('<%=intID%>','<%=strDescricao%>')" title="Altera Descri&ccedil;&atilde;o"><img border="0" src="../../../images/foto.gif" width="13" height="13">&nbsp;Altera Descri&ccedil;&atilde;o Foto</a></td>
                </tr>
              </table>
			  <%
				end if
				 Rs.Movenext
				Loop
			ELSE
				Response.Write "<center class='texto'>Nenhuma Foto</center><br>"
			END IF
			rs.close		
			%></td>
            </tr>
          </table>
   	<!-- fim do formulario da pagina-->
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
