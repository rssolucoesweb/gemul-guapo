<head>
<title><%=session("Titulo")%></title>
<link href="../estilo/css.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script src="../js/js_funcoes_gerais.js"></script>
<script>
function validarAcesso(destino){
	frm.action=destino;
	frm.submit();
}
function validaEmpresa(codGrupo){
	frm.codigo_SEG_grupo.value = codGrupo;
	frm.action="validaEmpresa.asp";
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
	Session("strMontraMenuPortal") = ""
	codEmpresa 			= trim(request.Form("codigo_empresa"))
	if codEmpresa = "" then codEmpresa = session("codEmpresa")
	codigo_SEG_grupo	= trim(request.Form("codigo_SEG_grupo"))
	if codigo_SEG_grupo = "" then codigo_SEG_grupo = session("codGrupo")
	
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
		Session("codPerfil") = 0
		sql = " SELECT DISTINCT seg_perfil_menu.codigo_SEG_perfil"
		sql = sql & " FROM seg_usuarios_acesso "
		sql = sql & " INNER JOIN seg_perfil_menu ON seg_perfil_menu.codigo_seg_perfil = seg_usuarios_acesso.codigo_seg_perfil "
		sql = sql & " INNER JOIN seg_perfil ON seg_perfil.codigo = seg_usuarios_acesso.codigo_seg_perfil "
		sql = sql & " INNER JOIN seg_menu ON seg_perfil_menu.codigo_seg_menu = seg_menu.codigo "
		sql = sql & " INNER JOIN seg_modulo ON seg_menu.codigo_seg_modulo = seg_modulo.codigo "
		sql = sql & " INNER JOIN seg_empresa ON seg_empresa.codigo = seg_usuarios_acesso.codempresa "
		sql = sql & " left JOIN seg_empresa_foto ON seg_empresa.codigo = seg_empresa_foto.codempresa "
		sql = sql & " WHERE seg_usuarios_acesso.cpf_seg_usuarios = " & intCpfUsuario 
		sql = sql & " AND seg_usuarios_acesso.codempresa = " & codEmpresa  
 		rsAux.open sql, cnn
		if not rsAux.eof then
			controle = 0
			while not rsAux.eof
				if controle = 0 then
					Session("codPerfil") = rsAux("codigo_SEG_perfil")
				else
					Session("codPerfil") = rsAux("codigo_SEG_perfil") & "," & Session("codPerfil")
				end if
				controle = controle + 1
				rsAux.movenext
			wend
		end if
		rsAux.close
		
		'Acesso ao Modulo por usuario
		sql = " SELECT DISTINCT seg_modulo.ordem, seg_perfil.codigo_SEG_tipo_acesso, seg_modulo.codigo, seg_modulo.descricao, seg_modulo.sigla, seg_menu.codigo_seg_modulo, seg_empresa_foto.arquivo_on, seg_empresa.nomeFantazia as fantasia "
		sql = sql & " FROM seg_usuarios_acesso "
		sql = sql & " INNER JOIN seg_perfil_menu ON seg_perfil_menu.codigo_seg_perfil = seg_usuarios_acesso.codigo_seg_perfil "
		sql = sql & " INNER JOIN seg_perfil ON seg_perfil.codigo = seg_usuarios_acesso.codigo_seg_perfil "
		sql = sql & " INNER JOIN seg_menu ON seg_perfil_menu.codigo_seg_menu = seg_menu.codigo "
		sql = sql & " INNER JOIN seg_modulo ON seg_menu.codigo_seg_modulo = seg_modulo.codigo "
		sql = sql & " INNER JOIN seg_empresa ON seg_empresa.codigo = seg_usuarios_acesso.codempresa "
		sql = sql & " left JOIN seg_empresa_foto ON seg_empresa.codigo = seg_empresa_foto.codempresa "
		sql = sql & " WHERE seg_usuarios_acesso.cpf_seg_usuarios = " & intCpfUsuario 
		sql = sql & " AND seg_usuarios_acesso.codempresa = " & codEmpresa  
		sql = sql & " and seg_modulo.sigla not in ('SCA','SCF','SCB','SRH','SGC')"
		sql = sql & " union "
		sql = sql & " select top 1 999, 0,999999, 'Voltar' as descricao, '' as sigla, 999, '','' from seg_empresa"
		sql = sql & " ORDER BY 1 "
 		rsAux.open sql, cnn
		if rsAux.eof then
			rsAux.close
			%>
			<script>
			  alert("Usuário não esta vinculado a nenhum modulo, favor verificar o seu perfil de acesso!");
			  window.history.back();
			</script>
			<%
			response.end()			
		end if
		Session("codTipoPerfil") = rsAux("codigo_SEG_tipo_acesso")
		'dados da logomarca
		session("codGrupo")	= codigo_SEG_grupo
		session("codEmpresa") = codEmpresa
		session("strNomeEmpresa") = ucase(rsAux("fantasia"))
		session("strSiglaModulo") = ucase(rsAux("sigla"))
		session("logomarcaEmpresa") = rsAux("arquivo_on")
		
%>
<!--#include file="topoModulo.asp"-->
<table width="900"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td width="209" height="370" align="center" bgcolor="#003366"><!--#include file="MenuModulo.asp"--></td>
    <td width="691" align="center" bgcolor="#FFFFFF">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">


        <form action="validaModulo.asp" method="post" name="frm" id="frm">
        <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" height="340">
	   	<%
		intControle = "Inicio_linha"
		cont = 0
		while not rsAux.eof 
			cont = cont + 1
			'2 -	Segurança
			'3 -	Clube
			'4 -	Financeiro
			'5 -	Administrativo
			'8 -	Site
			codMenu = ""
			strSigla = rsAux("sigla")
			if 	   ucase(trim(rsAux("sigla"))) = "SAV" 	then
				codMenu = 99999
			elseif ucase(trim(rsAux("sigla"))) = "SCA" 	then
				codMenu = 8
			elseif ucase(trim(rsAux("sigla"))) = "SCB" 	then
				codMenu = 3
			elseif ucase(trim(rsAux("sigla"))) = "SCF" 	then
				codMenu = 4
			elseif ucase(trim(rsAux("sigla"))) = "SGE" 	then
				codMenu = 99999
			elseif ucase(trim(rsAux("sigla"))) = "SRH" 	then
				codMenu = 5
			elseif ucase(trim(rsAux("sigla"))) = "SEG" 	then
				codMenu = 2
			elseif ucase(trim(rsAux("sigla"))) = "SCC" 	then
				codMenu = 74
			elseif ucase(trim(rsAux("sigla"))) = "EST" 	then
				codMenu = 89
			elseif ucase(trim(rsAux("sigla"))) = "MAL" 	then
				codMenu = 117
			elseif ucase(trim(rsAux("sigla"))) = "PRO" 	then
				codMenu = 129
			elseif ucase(trim(rsAux("sigla"))) = "MER" 	then
				codMenu = 147
			end if
			strLinkAcesso = "carregaModuloMenu.asp?d=/gemul/portal/sistemas/" & strSigla & "/&M=" & rsAux("codigo_SEG_modulo") & "&Mn=" & codMenu
			if intControle = "Inicio_linha" then
				%>
				<tr>
				<%
				intControle = ""
			end if
			if rsAux("codigo")="999999" then 'voltar
			%>
			  <td height="21" align="center"><a href="#"  onclick="validaEmpresa('<%=codigo_SEG_grupo%>')" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('voltar','','../images/IconesModulos/voltar_on.png',1)"><img src="../images/IconesModulos/voltar.png" alt="Clique para voltar as unidades" name="voltar" width="180" height="78" border="0" id="voltar" /></a></td>			
			<%
			else
			%>
			  <td height="21" align="center"><a href="#" onclick="validarAcesso('<%=strLinkAcesso%>')"><img src="../images/IconesModulos/<%=ucase(trim(strSigla))%>.png" alt="Clique para acessar o M&oacute;dulo <%=rsAux("descricao")%>" name="<%=ucase(trim(rsAux("sigla")))%>" width="180" height="78" border="0" id="<%=ucase(trim(rsAux("sigla")))%>" /></a></td>			
			<%
			end if
			
			if cont = 2 then  intControle = "Fim_linha"
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