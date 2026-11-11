<head>
<title><%=session("Titulo")%></title>
<link href="../estilo/css.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script src="../js/js_funcoes_gerais.js"></script>
<script>
function validarAcessoModulo(codGrupo,CodEmpresa){
	frm.codigo_SEG_grupo.value = codGrupo;
	frm.codigo_empresa.value = CodEmpresa;
	frm.action="validaModulo.asp";
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
	codigo_SEG_grupo 	= trim(request.Form("codigo_SEG_grupo"))
	intCpfUsuario 		= trim(session("strUsuario"))
	
	if codigo_SEG_grupo = "" or codigo_SEG_grupo = "0" then
		%>
		<script>
		  alert("ATENÇÃO: Grupo de acesso não foi informado!");
		  window.location="../default.asp";
		</script>
		<%
		response.end()
	end if	
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
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_formataData.asp"-->
<%
	'verifica quais as  empresa do grupo selecionado o usuario vai ter acesso dentro do portal
	sql = " SELECT distinct UA.codEmpresa, emp.razaoSocial, emp.codgrupo, emp.NomeFantazia as empresa, G.descricao as grupo, _ef.Arquivo, G.Arquivo_on as Arquivo_GRUPO, _ef.Arquivo_on "
	sql = sql & "  from  SEG_EMPRESA emp"
	sql = sql & "  inner join SEG_usuarios_acesso UA ON emp.codigo = UA.codEmpresa"
	sql = sql & "  inner join SEG_perfil P ON P.codigo = UA.codigo_SEG_perfil "
	sql = sql & "  inner join SEG_grupo G ON G.codigo = emp.codgrupo "
	sql = sql & "  left join SEG_empresa_Foto _EF ON _ef.CodEmpresa = emp.codigo"
	sql = sql & "  WHERE UA.cpf_SEG_usuarios="& intCpfUsuario
	sql = sql & "  AND emp.codgrupo="& codigo_SEG_grupo		
	sql = sql & "  order by G.descricao, emp.razaoSocial"
	rsAux.open sql, cnn
	if rsAux.eof then
		session("strNomeGrupo") 	= ""
		session("codGrupo") 		= ""
		session("logomarcaGrupo") 	= ""
		rsAux.close
		%>
		<script>
		  alert("Usuário não esta vinculado a nenhuma Unidade, favor verificar o seu perfil de acesso!");
		  window.location="../default.asp";
		</script>
		<%
		response.end()			
	else
		session("codGrupo") = ucase(rsAux("codgrupo"))
		session("logomarcaGrupo") = ucase(rsAux("Arquivo_GRUPO"))
		session("strNomeGrupo") = ucase(rsAux("Grupo"))
	end if	
%>
<!--#include file="topoEmpresa.asp"-->
<table width="900"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td width="209" height="370" align="center" bgcolor="#003366"><!--#include file="MenuEmpresa.asp"--></td>
    <td width="691" align="center" bgcolor="#FFFFFF">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5" height="350">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">

        <form action="validaGrupo.asp" method="post" name="frm" id="frm">
        <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
	  <%
		intControle = "Inicio_linha"
		cont = 0
		while not rsAux.eof 
			cont = cont + 1
			'listando os grupos
			
			if intControle = "Inicio_linha" then
				%>
				<tr>
				<%
				intControle = ""
			end if
			if (ucase(trim(request.ServerVariables("SERVER_NAME"))) = "WWW.GEMUL-CANEDO.COM.BR" or UCASE(trim(request.ServerVariables("SERVER_NAME"))) = "GEMUL-CANEDO.COM.BR") and rsAux("codEmpresa")=9 then
			%>
				  <td height="21" align="center"><a href="#"  onclick="validarAcessoModulo('<%=codigo_SEG_grupo%>','<%=rsAux("codEmpresa")%>')"><img src="../images/grupo/canedo.png" alt="Clique para acessa a Unidade" name="<%=rsAux("arquivo")%>" width="180" height="78" border="0" id="<%=rsAux("arquivo")%>" /></a></td>
			<%
			else
			%>
				  <td height="21" align="center"><a href="#"  onclick="validarAcessoModulo('<%=codigo_SEG_grupo%>','<%=rsAux("codEmpresa")%>')"><img src="../images/grupo/<%=rsAux("codgrupo")%>/empresa/<%=rsAux("codEmpresa")%>/<%=rsAux("codEmpresa")%>.png" alt="Clique para acessa a Unidade" name="<%=rsAux("arquivo")%>" width="180" height="78" border="0" id="<%=rsAux("arquivo")%>" /></a></td>
			<%
			end if
			if cont = 3 then  intControle = "Fim_linha"

			if intControle = "Fim_linha" then
				%>
				</tr>
				<%
				intControle = "Inicio_linha"
				cont = 0
			end if
			
			rsAux.movenext
		wend
		rsAux.close
		
%>		
      </table>    
      <input name="codigo_SEG_grupo" id="codigo_SEG_grupo" type="hidden" />
      <input name="codigo_empresa" id="codigo_empresa" type="hidden" />
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