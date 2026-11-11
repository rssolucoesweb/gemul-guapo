<%SESSION.Timeout = 1200%>
<%Server.ScriptTimeOut = 60%>
<%strNomeDaPaginaPortal = "Cadastro do Menu"%>
<link type="text/css" rel="stylesheet" href="css/treeView.css">
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="js/Seg_PerfilMenu_cad.js"></script>
<script type="text/javascript" src="js/jquery.treeview.js"></script>
<script type="text/javascript" src="js/treeview.js"></script>
<%  
'codigo fonte em ASP

		
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">
         <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
   
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->

    <table width="98%" align="center" class="formulario">
    <tr>
    <td class="TextoForm">

    <%
    dim intCodModulo
    StrReloadSistema = "S"
    StrReloadModulo = "S"
    intCodSistema	= request.form("cmbCodSistema")
    if intCodSistema = "" then intCodSistema = 0
    intCodModulo	= request.form("cmbCodModulo")
    if intCodModulo = "" then intCodModulo = 0
	'MODULO
	'	1	Segurança
	'	2	Site
	'	3	Financeiro
	'	4	Administrativo
	'	5	Clube
	'MENU
	'2	Segurança
	'3	Clube
	'4	Financeiro
	'5	Administrativo
	'8	Site
	codMenu = ""
    if intCodModulo = 1 then
        codMenu = 2
    elseif intCodModulo = 2 then
        codMenu = 8
    elseif intCodModulo = 3 then
        codMenu = 4
    elseif intCodModulo = 4 then
        codMenu = 5
    elseif intCodModulo = 5 then
        codMenu = 3
	 elseif intCodModulo = 10 then
        codMenu = 74	
    end if
    
    %>
    <br>
    Sistema:&nbsp;<!--#include file="../../../includes/inc_cmbSistema.asp"--><br>
    Modulo:&nbsp;&nbsp;<!--#include file="../../../includes/inc_cmbModulo.asp"--><br>
    <br>
    <%if intCodModulo<>"0" then%>
    <a href="#" onClick="return abreConsulta('seg_menu_cad.asp?acao=I&codMenu=<%=codMenu%>&CodModulo=<%=intCodModulo%>')"><img align="middle" src="../../../images/incluir.gif" alt="Clique para incluir um item no menu abaixo desse nível" border="0"></a>
    <%end if
    intCodUsuario 	= Trim(request.Form("cmbUsuario"))		
    IntCodPermissao	= session("intPermissao") ' Recebe a permissão do usuário: 1 - administrador
        
    'MONTA menu imob
    dim codigo
    if codMenu <> "" then
        intCodigomenu = codMenu
    else
        intCodigomenu = 1
    end if
    
    function menu(codigo)
        
        set rs1 = server.CreateObject("adodb.recordset")  
        sql="select codigo, descricao, link, imagem, script "
        sql=sql & " from SEG_menu "
        sql=sql & " where codigo_SEG_menu=" & codigo
        sql=sql & " and codigo_seg_modulo=" & intCodModulo
        sql=sql & " order by ordem, codigo"
        
        vetMenu = null
        rs1.open sql, cnn
        if not rs1.eof then
            vetMenu = rs1.getRows
        end if
        rs1.close
        
        if isArray(vetMenu) then
            if codigo <> 1 then
                response.write "<ul>" & vbcrlf
            end if	
            controle = 0
            'while not rs.eof
            for i=0 to ubound(vetMenu,2)
    
                codigoRSMenu  	= vetMenu(0,i)  'rsMenuImob("codigo")
                imagemRSMenu  	= vetMenu(3,i)  'rsMenuImob("imagem")
                linkRSMenu 	 	= vetMenu(2,i)  'rsMenuImob("link")
                descricaoRSMenu	= vetMenu(1,i)  'rsMenuImob("descricao")
    
                strFontMaiorInicial = ""
                strFontMaiorFinal = ""
                strImagem = ""
                if codigoRSMenu=23 then'administrador
                    strImagem = "S"
                end if
                if codigoRSMenu=14 then'lapis
                    strImagem = "S"
                end if
                if codigoRSMenu=11 then'lapis
                    strImagem = "S"
                end if
                if codigoRSMenu=8 then'lapis
                    strImagem = "S"
                end if
                if codigoRSMenu=5 then'lapis
                    strImagem = "S"
                end if
                if codigoRSMenu=2 then'lapis
                    strImagem = "S"
                end if
                
                'if cInt(codigoRSMenu)>cInt(codigo) then
    
    
                    strImagem = ""
                    strLink   = "#"
                    strComentario = ""
                    strScript = vetMenu(4,i) 'rsMenuImob("script")
                    if isnull(imagemRSMenu) = false then
                        strImagem = "itemIcon='" & imagemRSMenu & "'"
                    end if
                    
                    if not isnull(linkRSMenu) then
                        if trim(linkRSMenu) <> "" then strLink = linkRSMenu
                    end if				
                    if strImagem = "" then
                    %>
                    <li id="<%=codigoRSMenu%>"><%=descricaoRSMenu%>&nbsp;<a href="#"  onClick="return abreConsulta('seg_menu_cad.asp?acao=A&codMenu=<%=codigoRSMenu%>&CodModulo=<%=intCodModulo%>')"><img align="middle" src="../../../images/adcionar.gif" alt="Clique para alterar esse item do menu" border="0"></a>&nbsp;<a href="#" onClick="return abreConsulta('seg_menu_cad.asp?acao=I&codMenu=<%=codigoRSMenu%>&CodModulo=<%=intCodModulo%>')"><img align="middle" src="../../../images/incluir.gif" alt="Clique para incluir um item no menu abaixo desse nível" border="0"></a>
                    <%
                    else
                    %>
                    <li id="<%=codigoRSMenu%>"><%=descricaoRSMenu%>&nbsp;<a href="#" onClick="return abreConsulta('seg_menu_cad.asp?acao=I&codMenu=<%=codigoRSMenu%>&CodModulo=<%=intCodModulo%>')"><img align="middle" src="../../../images/incluir.gif" alt="Clique para incluir um item no menu abaixo desse nível" border="0"></a>
                    <%
                    end if
                    menu(codigoRSMenu)
                    %>	
                    </li>
                    <%
                'end if
                'rs1.movenext
            next
            'wend
            %>
            </ul>
            <%
        end if
        vetMenu = null
        'rs1.close	
    end function
    if intCodModulo<>"0" then
    response.write "<ul id='red' class='treeview-red'>" & vbcrlf
    menu(intCodigomenu)
    response.write "</ul>" & vbcrlf
    end if
    %>
    </td>
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