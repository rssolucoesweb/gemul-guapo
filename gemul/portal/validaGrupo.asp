<head>
<title><%=session("Titulo")%></title>
<link href="../estilo/css.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script src="../js/js_funcoes_gerais.js"></script>
<script>
function validarAcessoEmpresa(codGrupo){
	frm.codigo_SEG_grupo.value = codGrupo;
	frm.action="validaEmpresa.asp";
	frm.submit();
}
function sairDoSistema(){
	frm.action="SairDoSistema.asp";
	frm.submit();
}
function validarAcesso(destino){
	frm.action=destino;
	frm.submit();
}
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>
</head>
<%
	if trim(Session("dataUltimoAcessoWeb")) = "" or isnull(Session("dataUltimoAcessoWeb")) then
		strNomeDaPaginaPortal = "Primeiro acesso ao sistema"
	else
		strNomeDaPaginaPortal = "Ãšltimo acesso: " & trim(Session("dataUltimoAcessoWeb"))
	end if
	'se precisar retirar o menu em alguma pagina colocar o variavel strRetiraMenu = "S"
	strRetiraMenu = "S"
	bolPaginaAnoLetivo 	= "N"
	
	'acesso usuario
	intCpfUsuario = session("strUsuario")
	
	if intCpfUsuario = "" then
		%>
		<script>
		  alert("ATENÇÃO: Usuário de acesso não foi informado!");
		  window.location="../default.asp";
		</script>
		<%
		response.end()
	end if		
%>
<!--#include file="topoGrupo.asp"-->
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_formataData.asp"-->
<table width="900"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="370" align="center" bgcolor="#FFFFFF">
 
        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    
   	<form action="validaGrupo.asp" method="post" name="frm" id="frm">
        <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" height="330">
	  <%
	  'verifica quais grupos o usuario vai ter acesso dentro do portal
		sql = "SELECT distinct emp.codgrupo, g.descricao as grupo, g.arquivo,g.arquivo_on"
		sql = sql & " FROM 	SEG_usuarios_acesso ace"
		sql = sql & " inner join SEG_EMPRESA emp on ace.codEmpresa = emp.codigo"
		sql = sql & " inner join SEG_grupo G ON G.codigo = emp.codgrupo "
		sql = sql & " WHERE ace.cpf_SEG_usuarios=" & intCpfUsuario
		rsAux.open sql, cnn
		if not rsAux.eof then
			while not rsAux.eof 
				'listando os grupos
				%>
                    <tr>	
                    	<td height="21" align="center">
                        <a href="#"  onclick="validarAcessoEmpresa('<%=rsAux("codgrupo")%>')" >
                        
						
			<%			
			if trim(request.ServerVariables("SERVER_NAME")) = "www.gemul-canedo.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "gemul-canedo.com.br" then
			%>
				  <img src="../images/grupo/canedo.png" alt="Clique para Acesso o Grupo <%=rsAux("Grupo")%>" name="<%=rsAux("arquivo")%>" width="180" height="78" border="0" id="<%=rsAux("arquivo")%>" />
			<%
			else
			%>
				  <img src="../images/grupo/<%=rsAux("codgrupo")%>/<%=rsAux("codgrupo")%>.png" alt="Clique para Acesso o Grupo <%=rsAux("Grupo")%>" name="<%=rsAux("arquivo")%>" width="180" height="78" border="0" id="<%=rsAux("arquivo")%>" />
			<%
			end if
			%>
								
						
                        </a></td>
                    </tr>
				<%
				rsAux.movenext
			wend
		end if
		rsAux.close
		
		
		
		 
		session("bolUsuarioAcessaTodasRequisicoes") = ""
		sql = "select cpf_SEG_usuarios from SEG_usuarios_acesso_requisicoes"
		sql = sql & " WHERE cpf_SEG_usuarios = " & intCpfUsuario
		rsAux.open sql, cnn
		if not rsAux.eof then
			session("bolUsuarioAcessaTodasRequisicoes") = "S"
		end if
		rsAux.close	
		
		bolUsuarioMaster = false
		sql = "select cpf_SEG_usuarios from SEG_usuarios_acesso_master"
		sql = sql & " WHERE cpf_SEG_usuarios = " & intCpfUsuario
		rsAux.open sql, cnn
		if not rsAux.eof then
			bolUsuarioMaster = true
		end if
		rsAux.close		
		session("UsuarioMaster") = ""
		if bolUsuarioMaster then
			'2 -	Segurança
			codMenu = 2
			session("UsuarioMaster") = "S"
			session("strUsuarioMaster") = "SIM"
			Session("codPerfil") 	 = "0"
			session("codGrupo") 	 = "0"
			session("codEmpresa")	 = "0"
			session("logomarcaEmpresa") = "SEG_on.png"
			strLinkAcesso = "carregaModuloMenu.asp?d=/gemul/portal/sistemas/seg/&M=0&Mn=" & codMenu
			%>
			<tr>
			  <td height="21" align="center"><a href="#"  onclick="validarAcesso('<%=strLinkAcesso%>')"><img src="../images/IconesModulos/SEG.png" alt="Clique para acessar o M&oacute;dulo Controle de Seguran&ccedil;a" name="ControleSeguranca" width="180" height="78" border="0" id="ControleSeguranca" /></a></td>
			  <td align="center">&nbsp;</td>
			</tr>
			<%
		end if		
		%>
        <tr>
          <td height="21" align="center"><a href="#"  onclick="sairDoSistema()" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('SairDoSistema','','../images/IconesModulos/SairSistema_on.png',1)"><img src="../images/IconesModulos/SairSistema.png" alt="Clique para sair do sistema" name="SairDoSistema" width="180" height="78" border="0" id="SairDoSistema" /></a></td>
          <td align="center">&nbsp;</td>
        </tr>
      </table>    
      <input name="codigo_SEG_grupo" id="codigo_SEG_grupo" type="hidden" />
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