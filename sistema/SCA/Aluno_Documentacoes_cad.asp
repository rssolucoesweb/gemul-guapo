<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Aluno documentações
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
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
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value == "") {
			alert("A Matricula do Aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.txtNomealuno.value == "") {
			alert("Aluno deve ser informado!");
			frm.txtMatricula.focus();
			return false;
		}

		frm.action="Aluno_Documentacoes_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
	function validaDocumentoData(valor, cod){
		
		if (valor==true){
			document.all["txtDataProrrogacao"+cod].value="";
			document.all["txtDataProrrogacao"+cod].disabled=true;
		}else{
			document.all["txtDataProrrogacao"+cod].value="";
			document.all["txtDataProrrogacao"+cod].disabled=false;
		}
		
	}
</script>
<%
	strPaginaTitulo 	= "Aluno_Documentacoes_cad.asp"
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
		    intCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		else
			strCodAluno			= 0
		    intCodAluno			= ""
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close	
	
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if

	strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'

%>
<form method="post" id="frm" action="Aluno_Documentacoes_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center" valign="top">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="11%" class="texto1">Matr&iacute;cula : </td>
      <td width="89%"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td height="18" class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
	<tr bgcolor="#D3D3D3">
	  <td height="19" colspan="7" class="texto1"><!--#include file="../includes/inc_sqlDadosEscolaresAluno.asp" --></td>
	</tr>
    <tr> 
      <td height="18" class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td height="18" class="texto1" colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>    
	<tr> 
      <td colspan="2" class="texto1"><%
		if strMatricula <> "" and strCodAluno <> "" and strCodAluno <> "0" then	%> 
			<br>
			<br>
			<table class="tabela" width="100%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta">
            <td colspan="4" align="center" bgcolor="#CCCCCC" class="celula"><strong>Documentos Exigidos ao Aluno </strong></td>
            </tr>
          <tr class="CabecalhoConsulta"> 
            <td width="36" align="center" bgcolor="#CCCCCC" class="celula">&nbsp;</td>
            <td width="133" bgcolor="#CCCCCC" class="celula"><strong>C&oacute;digo</strong></td>
            <td width="470" bgcolor="#CCCCCC" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
            <td width="300" bgcolor="#CCCCCC" class="celula"><strong>Data de Prorroga&ccedil;&atilde;o </strong></td>
          </tr>
          <%
				sql = "SELECT Cod_Empresa, Codigo, Descricao"
				sql = sql & " FROM SCA_DOCUMENTACOES"
				sql = sql & " where Cod_Empresa = " & Session("CodEmpresa")			
				sql = sql & " Order by Codigo"
				rs.open sql, cnn
		
				if rs.eof = false then
					
					while not rs.eof
						
						sql = "Select Cod_aluno, Cod_documentacoes, data_prorrogacao, situacao "
						sql = sql & " From SCA_ALUNO_DOCUMENTACOES "
						sql = sql & " Where Cod_documentacoes = " & trim(rs("Codigo"))
						sql = sql & " and Cod_aluno = " & strCodAluno
						rsAux.open sql, cnn
						if rsAux.eof = false then
							if trim(rsAux("situacao")) = "R" then
								strChecked			= "checked"
								strBloqData			= "disabled"
							else
								strChecked			= ""
								strBloqData			= ""
							end if
							strDataProrrogacao 	= formatadataAP(rsAux("data_prorrogacao"))
						else
							strBloqData			= ""
							strChecked  		= ""
							strDataProrrogacao 	= ""
						end if
						rsAux.close	
						
						%>
						  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
							<td class="celula" align="center"><input name="chkDocumentacoes<%=rs("Codigo")%>" type="checkbox" id="chkDocumentacoes<%=rs("Codigo")%>" value="S" <%=strChecked%> onClick="return validaDocumentoData(this.checked,'<%=rs("Codigo")%>')"></td>
							<td class="celula"><input name="txtCodDocumento<%=rs("Codigo")%>" type="hidden" id="txtCodDocumento<%=rs("Codigo")%>" value="<%=rs("Codigo")%>"><%=rs("Codigo")%></td>
							<td class="celula"><%=rs("Descricao")%>&nbsp;</td>
								<td class="celula"><input <%=strBloqData%> name="txtDataProrrogacao<%=rs("Codigo")%>" type="text" class="text" id="txtDataProrrogacao<%=rs("Codigo")%>" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataProrrogacao%>"></td>
						  </tr>
							<%
							rs.movenext
						wend
					else
						%>
						  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
							<td colspan="4" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
						  </tr>
						  <%
					end if
					rs.close
			end if
		%>
        </table>
		<br><br>
		<%if strMatricula <> "" and strCodAluno <> "" and strCodAluno <> "0" then	%> 
		<table width="40%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
		  <tr>
			<td class="celula" align="center" bgcolor="#E4E4E4"><strong>Legenda</strong></td>
		  </tr>
		  <tr>
			<td class="celula">
			  <input disabled="disabled" type="checkbox" name="chk" checked="checked">
			  Documenta&ccedil;&atilde;o Regular.			</td>
		  </tr>
		  <tr>
		    <td class="celula">
		      <input disabled="disabled" type="checkbox" name="chk2">
Documenta&ccedil;&atilde;o Irregular. </td>
		    </tr>
		</table>
<br>
<br>
		<%end if%>		</td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>