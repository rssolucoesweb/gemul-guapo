<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/04/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Modelo de Carteirinhas 
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
	function Excluir(Codigo){
		
		var frm = document.getElementById("frm");
		var men = 'ATENÇÃO: Deseja realmente excluir este Modelo?\n '
		
		if (confirm(men)) {
			frm.action="ModeloCarteirinhas_alt.asp?Codigo="+ Codigo;
			frm.submit();
		} else {
			return false;
		}
	
	}
	
	function Destaque(acao,Codigo){
		
		var frm = document.getElementById("frm");
		frm.action="ModeloCarteirinhas_alt.asp?acao="+acao + "&Codigo="+ Codigo;
		frm.submit();
		return true;
 	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		
		if((frm.Arq1.value.lastIndexOf(".jpg")==-1) && (frm.Arq1.value.lastIndexOf(".JPG")==-1)){  
			alert("Só é permitido fazer Upload de JPG!"); 
			frm.Arq1.focus();  
			return false  
		} 
				
		frm.action="ModeloCarteirinhas_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 			= "ModeloCarteirinhas_cad.asp"
	intCodEmp  					= Session("CodEmpresa")
	intCodigo			 		= Trim(Request.Form("txtCodigo"))
	strDescricao 				= Trim(Request.Form("txtDescricao"))
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form name="frm" action="" method="POST" enctype="multipart/form-data">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="703" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">&nbsp;</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Descri&ccedil;&atilde;o :</td>
            <td><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td width="77" class="texto1">Modelo :</td>
            <td width="626"><span class="TextoForm">
              <input class="text" name="Arq1" type="file" id="Arq1" size="25">
            </span></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" align="center"><input type="button" name="botao" class="botao" onClick="salvar('I')" value="Enviar Modelo"></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			
				strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFotoAtivo.gif"
				
				PastaFotos = Server.MapPath("../../ModeloCarteirinhas") & "\" & intCodEmp
				Set objFSO = CreateObject("Scripting.FileSystemObject")
				
				sql = "SELECT Codigo, cod_empresa, Descricao, Destaque, Modelo"
				sql = sql & " FROM SCA_ModeloCarteirinhas"
				sql = sql & " Where cod_empresa = " & intCodEmp
				sql = sql & " Order by Codigo"
				rs.open sql, cnn
			
				if rs.eof = false then
		
				Do While Not Rs.EOF
				
					strCaminhoFoto 	= PastaFotos & "\" & rs("Modelo") 
					intCodigo		= rs("Codigo")
					strDescricao	= rs("descricao")
					strModelo		= rs("Modelo")
					
					
					IF objFSO.FileExists(strCaminhoFoto) = True THEN
					%>
              		<table border="0" width="100%" cellpadding="0" cellspacing="0" style="margin-left:15px;margin-right:15px;margin-top:0px;border-collapse: collapse" bordercolor="#111111">
                	<tr>
                  		<td width="229" height="110" align="center" <% if rs("Destaque") = "S" then %> bgcolor="#FED71C" <%end if%>><img src=../../ModeloCarteirinhas/<%=intCodEmp%>/<%=rs("Modelo")%> width="200" height="68"> </td>
                 		<td width="104" align="center" class="texto"><a href="#" onClick="Excluir('<%=intCodigo%>')" title="Excluir"><img border="0" src="../../images/icone_excluir.gif" width="13" height="13">&nbsp;Excluir foto</a></td>
                  		<td width="187" class="texto"><%=strDescricao%>&nbsp;</td>
                  		<td width="153" align="center" class="texto">&nbsp;
                      	<% if trim(Rs("Destaque")) = "N" then %>
                      		<a href="#" onClick="Destaque('A','<%=intCodigo%>')"><img border="0" src="../../images/icone_destaque.gif" width="13" height="13">&nbsp;Tornar Modelo Destaque</a>
                      	    <%else%>
                    		Modelo em Destaque
                    	    <%end if%>						</td>
                  </tr>
              </table>
              <%
				end if
				 rs.Movenext
				loop
			else
				Response.Write "<center class='texto'>Nenhuma Modelo</center><br>"
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
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>