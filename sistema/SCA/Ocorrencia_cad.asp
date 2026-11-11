<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 24/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Ocorrencia 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
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
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	function abreConsultaOcorrencia(){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbDepartamento.value == "0") {
			alert("O Departamento deve ser informado !");
			frm.cmbDepartamento.focus();
			return false;
		}		
		var caminho = "Ocorrencia_con.asp?cmbDepartamento=" + frm.cmbDepartamento.value;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=519,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbDepartamento.value == "0") {
			alert("O Departamento deve ser informada !");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		if (frm.txtMatricula.value == "") {
			alert("A Matricula do Aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		
		if (frm.txtDataOcorrencia.value == "") {
			alert("A Data da Ocorrência deve ser informada !");
			frm.txtDataOcorrencia.focus();
			return false;
		}
		
		if (frm.txtDataValidade.value == "") {
			alert("A Data de Validade da Ocorrência deve ser informada !");
			frm.txtDataValidade.focus();
			return false;
		}
		
		if (frm.txtOcorrencia.value == "") {
			alert("A Ocorrência deve ser informada !");
			frm.txtOcorrencia.focus();
			return false;
		}
		
		frm.action="Ocorrencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo			= "Ocorrencia_cad.asp"
	intCodOcorrencia 		= Trim(Request.Form("txtCodigo"))
	intCodDepartamento		= Session("CodDeptoUsuario")
	strCodAluno 			= Trim(Request.Form("txtCodAluno"))
	strMatricula 			= Trim(Request.Form("txtMatricula"))
	strNomealuno 			= Trim(Request.Form("txtNomealuno"))
	strDataOcorrencia 		= Trim(Request.Form("txtDataOcorrencia"))
	IF strDataOcorrencia = "" THEN strDataOcorrencia = formatadataAP(date)
	strDataValidade 		= Trim(Request.Form("txtDataValidade"))
	strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
	
	if trim(strMatricula) <> "" then
	   sql = "SELECT codigo from sca_aluno "
	   sql = sql & " Where cod_empresa = " & Session("CodEmpresa")			
	   sql = sql & " And matricula = '" & strMatricula & "'"
	   rs.open sql, cnn
  	   if rs.eof = false then
	      strCodAluno				= rs("codigo")
	   end if
	   rs.close	  
	end if   
	
	if trim(intCodDepartamento) <> "" then
	
	   sql = "SELECT CODIGO, COD_EMPRESA, DESCRICAO "
	   sql = sql & " From SEG_DEPARTAMENTO "
	   sql = sql & " Where CODIGO = " & intCodDepartamento 
	   rs.open sql, cnn

  	   if rs.eof = false then
	      Session("DescDeptoUsuario") = rs("DESCRICAO")
	   end if
	   rs.close	  
	end if   
	
	if trim(intCodOcorrencia) <> "" then
	
		sql = "SELECT O.COD_OCORRENCIA, O.COD_DEPARTAMENTO, O.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, O.DATAOCORRENCIA, O.DATAVALIDADE, O.OCORRENCIA"
		sql = sql & " FROM SCA_OCORRENCIA O"
		sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = O.COD_ALUNO"
		sql = sql & " Where O.COD_OCORRENCIA = " & intCodOcorrencia
		sql = sql & " And O.cod_empresa = " & Session("CodEmpresa")			
		
		rs.open sql, cnn
		
		if rs.eof = false then
			strCodAluno				= rs("COD_ALUNO")
			intCodOcorrencia 		= rs("COD_OCORRENCIA")
			intCodDepartamento		= rs("COD_DEPARTAMENTO")
			strMatricula 			= rs("MATRICULA")
			strNomeAluno 			= rs("NOMEALUNO")
			strDataOcorrencia 		= FORMATADATAAP(rs("DATAOCORRENCIA"))
			strDataValidade 		= FORMATADATAAP(rs("DATAVALIDADE"))
			strOcorrencia 			= rs("OCORRENCIA")

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="883" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td height="26" class="texto1">&nbsp;</td>
            <td colspan="3"><div align="center"><span class="tituloSistema">Cadastro de Ocorr&ecirc;ncias</span></div></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Consultar Ocorr&ecirc;ncias: </td>
            <td colspan="3"><a  href="#" onClick="return abreConsultaOcorrencia()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('999','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)">
              <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodOcorrencia%>" maxlength="10">
              <img alt="Visualizar ocorr&ecirc;ncias cadastradas para esse departamento " src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Aluno: </td>
            <td colspan="3"><span class="texto1">
              <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="15" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
              <input name="txtCodAluno" type="hidden" class="text" id="txtCodAluno" size="15" maxlength="20" value="<%=strCodAluno%>">
              <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('999','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a> </span>- <span class="texto1">
              <input name="txtNomealuno" type="text" class="text" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)">
              </span></td>
          </tr>
          <tr>
            <td height="22" class="texto1">Departamento:</td>
            <td colspan="3"><input name="cmbDepartamento" type="text" class="text" id="cmbDepartamento" value="<%=intCodDepartamento%>" size="5" maxlength="10" readonly="true">
-              	
  <input readonly="true" name="txtDescDepto" type="text" class="text" id="txtDescDepto" size="50" value="<%=Session("DescDeptoUsuario")%>"></td>
          </tr>
          
          <tr>
            <td height="24" class="texto1">Tipo de Ocorr&ecirc;ncia:</td>
            <td colspan="3"><select name="cmbTipoOcorrencia" id="cmbTipoOcorrencia" class="Combo">
           <option <%if strTipoOcorrencia = "D" then%> selected <%end if%> value="D">Disciplinar - ( Visualizada no portal do Aluno )</option>
           <option <%if strTipoOcorrencia = "A" then%> selected <%end if%> value="A">Administrativa - ( Controle interno )</option>
         </select></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Data Ocorr&ecirc;ncia: </td>
            <td colspan="3"><span class="texto1">
              <input name="txtDataOcorrencia" type="text" class="text" id="txtDataOcorrencia" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio" maxlength="10" value="<%=strDataOcorrencia%>">
            </span></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Validade Ocorr&ecirc;ncia: </td>
            <td colspan="3"><span class="texto1">
              <input name="txtDataValidade" type="text" class="text" id="txtDataValidade" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataValidade%>"  style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
            </span></td>
          </tr>
          <tr>
            <td class="texto1">Ocorr&ecirc;ncia: </td>
            <td colspan="3"><textarea name="txtOcorrencia" cols="60" rows="5" class="text" id="txtOcorrencia"><%=strOcorrencia%></textarea></td>
          </tr>
          <tr>
            <td width="159" class="texto1">&nbsp;</td>
            <td width="571" colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="4"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
		  <%
		  if trim(strCodAluno) <> "" then
		  	 sql = "SELECT O.COD_OCORRENCIA, O.COD_DEPARTAMENTO, O.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, O.DATAOCORRENCIA, O.DATAVALIDADE ,O.OCORRENCIA, O.USUARIO_INCL"
		  	 sql = sql & " FROM SCA_OCORRENCIA O"
		     sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = O.COD_ALUNO"
		     sql = sql & " where O.cod_empresa = " & Session("CodEmpresa")			
		     sql = sql & " and O.COD_DEPARTAMENTO = " & intCodDepartamento	
  	         sql = sql & " and O.COD_ALUNO = " & strCodAluno
 		     sql = sql & " order by O.DATAOCORRENCIA DESC"
		     rs.open sql, cnn
		     if rs.eof = false then
		        %>
				</table>
			  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	            <tr bgcolor="#E5E5E5" class="celula">
		        <td class="celula">Data</td>
		        <td height="26" class="celula">Ocorr&ecirc;ncia</td>
		        <td class="celula">Validade</td>
		        <td class="celula">Usu&aacute;rio</td>
		        </tr>
			    <%
			    while not rs.eof
				   cont = cont + 1	
				   %>
				   <tr bgcolor="#FFFFFF" class="celula"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  onClick="return resultadoConsulta('<%=rs("COD_OCORRENCIA")%>')">
				   <td width="192" class="celula">&nbsp;<%=trim(rs("DATAOCORRENCIA"))%></td>
				   <td width="490" height="26" class="celula">&nbsp;<%=trim(rs("OCORRENCIA"))%></td>
				   <td width="100" height="26" class="celula">&nbsp;<%=trim(rs("DATAVALIDADE"))%></td>
				   <td width="101" height="26" class="celula">&nbsp;<%=trim(rs("USUARIO_INCL"))%></td>
				   </tr>
				   <%				
				   rs.movenext
			    wend
			    %>
			    <tr> 
			    <td height="21" colspan="5" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
			    <%
			else
			    %>
				</table>
				<table width="883" border="0" cellpadding="0" cellspacing="0">
	            <tr bgcolor="#E5E5E5" class="celula">
				<td  height="19" class="texto1"><div align="center">Não Existe Lançamento de Ocorrência para essa Matrícula</div></td>
		        </tr>
				<%				
		    end if
		    rs.close
		 end if	
		 %>
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