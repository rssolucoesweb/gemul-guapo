<%strNomeDaPaginaPortal = "Cadastro de Album"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	
	function FotoAlbum(codigo){
		
		var frm = document.getElementById("frm");
		
		frm.action="AlbumFoto_cad.asp?CodAlbum="+ codigo; 
		frm.submit();
		return true;
 	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTipoAlbum.value == "0") {
			alert("O Tipo Album deve ser informado !");
			frm.cmbTipoAlbum.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição do Album deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtData.value == "") {
			alert("A Data deve ser informada!");
			frm.txtData.focus();
			return false;
		}
		
		frm.action="Album_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	
	function Excluir(codigo){
		
		var frm = document.getElementById("frm");
		
		var men = 'ATENÇÃO: Deseja realmente excluir este Album?\n '
		if (confirm(men)) {
			frm.action="Album_cod.asp?acao=E"+ "&txtCodigo=" + codigo; 
			frm.submit();
		} else {
			return false;
		}
		
 	}
</script>
<%
	principal			= "principal.asp"
	strPagina			= "Cadastro de Album"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo	 		= Request.Form("txtCodigo")
	intCodTipoAlbum		= Request.Form("cmbTipoAlbum")	
	strDescricao		= Trim(Request.Form("txtDescricao"))
	strData				= Trim(Request.Form("txtData"))					
	
	if strData = "" then
		strData = formataDataAP(date)
	end if
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT CodAlbum, CodTipoAlbum, Descricao, Data"
		sql = sql & " FROM Album"
		sql = sql & " Where CodAlbum = " & intCodigo
		sql = sql & " and codEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("CodAlbum")
			intCodTipoAlbum		= rs("CodTipoAlbum")
			strDescricao		= rs("Descricao")
			strData				= formataDataAP(rs("Data"))		
		
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoFoto				= ""
			BotaoAlbum				= ""

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoFoto   			= "disabled"
		BotaoAlbum				= "disabled"
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
    
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->
	
    <table width="99%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td height="28" class="TextoForm">Tipo Album:</td>
			    <td colspan="-1" class="TextoForm"><!--#include file="../../../includes/inc_cmbTipoAlbum.asp"-->&nbsp;</td>
			    </tr>
			  <tr>
			    <td width="14%" height="20" class="TextoForm">Descri&ccedil;&atilde;o: </td>
			    <td width="86%" colspan="-1" class="TextoForm"><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="69" maxlength="80" value="<%=strDescricao%>">
			      <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
			      <a href="#" onClick="return abreConsulta('Noticia_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1311','','<%=session("strCaminhoRaiz")%>/images/Consulta_over.gif',1)"></a></td>
			    </tr>
			  <tr>
			    <td height="26" class="TextoForm">Data : </td>
			    <td colspan="-1" class="TextoForm"><input name="txtData" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="14" maxlength="11"></td>
			    </tr>
			  <tr>
			    <td height="23" colspan="2" class="TextoForm">&nbsp;</td>
			    </tr>
			  <tr>
			    <td height="23" colspan="2" class="TextoForm"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
			    </tr>
			  <tr>
			    <td height="23" colspan="2" class="TextoForm">&nbsp;</td>
			    </tr>
			  <tr>
			    <td height="23" colspan="2" align="center" class="TextoForm"><%
			'****Pagina&ccedil;&atilde;o****
			regs = 9 'DEFININDO A QUANTIDADE DE RESULTADOS POR P&Aacute;GINA
			
			pag = request.querystring("pagina") 'ESTA &Eacute; A QUERYSTRING QUE APRESENTAR&Aacute; A P&Aacute;GINA ATUAL, E AS DEMAIS...
			if pag = "" Then
				pag = 1
			end if
			
			strPesquisa 	= Trim(Request.Form("txtPesquisa"))
			
			rs.cursortype = 3 		'DEFININDO O CURSOR A SER UTILIZADO
			rs.pagesize   = regs 	'PEGANDO A QUANTIDADE DE RESULTADO POR P&Aacute;GINA DEFINIDO ANTERIORMENTE
			
			Sub Links
				
				for i = 1 to rs.pagecount
					if i = cint(pag) then
						' VERIFICANDO SE i &Eacute; IGUAL A P&Aacute;GINA ATUAL
						response.write "<b>" & i & "</b>"
					else

						Caminho = "Album_cad.asp?CodAlbum=" & strTipoImovel &"&pagina=" & i
						
						if strAssunto <> "" then
							Caminho = Caminho & "&Pesquisa= " & strPesquisa
						end if
						
						response.write "<strong class='menu3'> <a href='" & Caminho & "'>" & i & "</a> </strong>"
					end if
					'MOVENDO OS NUMEROS DE i PARA CONTINUA A CONSULTA (i SER&Aacute; UM LINK)
				next
				
			end Sub
				
				cnn.beginTrans
										
				sql = " Select CodAlbum, Descricao, Data, fotoDestaque"
				sql = sql & " From SIT_Album"
				sql = sql & " Where CodEmpresa = " & intCodEmpresa
				sql = sql & " Order by CodAlbum desc "
				rs.open sql, cnn
				
				if rs.eof = false then
					
					rs.absolutepage = pag	  
					contador = 0
				%>
			      <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
			        <tr bgcolor="#E5E5E5">
			          <td width="11%" align="center" class="celula"><strong>Foto</strong></td>
			          <td width="6%" align="center" class="celula"><strong>C&oacute;d.</strong></td>
			          <td width="52%" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
			          <td width="11%" class="celula"><strong>Data</strong></td>
			          <td width="8%" align="center" class="celula"><strong>Q. Ftos</strong></td>
			          <td height="21" colspan="3" align="center" class="celula"><strong>A&ccedil;&atilde;o</strong></td>
			          </tr>
			        <%
					
			 	 do while not rs.eof and contador < rs.pagesize
			  
			    ' Verifica a Qtde de Foto que o Imovel tem
			  	sql = " Select count(CodAlbum) as Qtde "
				sql = sql & " From SIT_AlbumFoto"
				sql = sql & " Where CodAlbum = " & rs("CodAlbum")
				rsAux.open sql, cnn
				
				if rsAux.eof = false then
					QtdeFoto = rsAux("Qtde")
				end if
				rsAux.close
				
			  	strDescricao = mid(rs("Descricao"),1,25) & "..."
				
				strData		 = formataDataAP(rs("Data"))	
				
				
				strNomeFoto  = trim(rs("fotoDestaque")) & "_p.jpg"
				strCaminhoFoto	= "FotoAlbum/" &  intCodEmpresa  & "/" & trim(rs("CodAlbum")) & "/" & strNomeFoto 
			  	%>
			        <tr>
			          <td align="center" bgcolor="<%=strCor%>" class="celula"><img src="../../../<%=strCaminhoFoto%>" width="100" height="75"></td>
			          <td align="center" bgcolor="<%=strCor%>" class="celula"><%=rs("CodAlbum")%></td>
			          <td bgcolor="<%=strCor%>" class="celula"><%=rs("Descricao")%></td>
			          <td bgcolor="<%=strCor%>" class="celula"><%=strData%></td>
			          <td align="center" bgcolor="<%=strCor%>" class="celula"><%=QtdeFoto%></td>
			          <td width="4%" height="27" align="center" bgcolor="<%=strCor%>"  class="celula" style="cursor:hand" onClick="FotoAlbum('<%=rs("CodAlbum")%>')"><img src="../../../images/logo_camera.gif" width="22" alt="Fotos" height="18"></td>
			          <td width="3%" align="center" bgcolor="<%=strCor%>" class="celula" style="cursor:hand" onClick="resultadoConsulta('<%=rs("CodAlbum")%>')" ><img src="../../../images/icone_editar.gif" width="13" alt="Alterar" height="13"></td>
			          <td width="5%" align="center" bgcolor="<%=strCor%>" class="celula"  style="cursor:hand" onClick="Excluir('<%=rs("CodAlbum")%>')"><img src="../../../images/icone_excluir.gif" width="13" height="13" alt="Excluir"></td>
			          </tr>
			        <%				
						rs.movenext
						contador = contador +1
						loop
					End if 
					
					%>
			        </table>
			      <br>
			      <%
					if rs.recordcount > rs.pagesize then
										
					%>
			      <strong class="menu3">Mostrando P&aacute;gina <%=Pag%> de </strong><strong class="texto1"><%=rs.pagecount%></strong> <br>
			      <%
					end if
					
					if rs.recordcount > rs.pagesize then
					%>
			      <%Links%>
			      <%
					end if
					
					if err.number = 0 then
						cnn.commitTrans
					else
						cnn.rollbacktrans
					end if
					rs.close
				%>
			      </p></td>
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
