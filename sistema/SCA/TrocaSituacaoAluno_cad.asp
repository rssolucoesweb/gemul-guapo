<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/08/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: troca situacao aluno
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
<!--#include file="../../js/Calendario/Calendario.asp"-->
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
		if (frm.cmbSituacaoAluno.value == "0") {
			alert("Selecione a situação na qual será alterada!");
			frm.txtMatrcmbSituacaoAlunoicula.focus();
			return false;
		}		

		frm.action="TrocaSituacaoAluno_cod.asp?acao=" + acao;
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
	strPaginaTitulo 	= "TrocaSituacaoAluno_cad.asp"
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	if trim(strMatricula) <> "" then
	
		sql = "Select sca_aluno.Codigo, sca_aluno.NomeAluno, sca_aluno.matricula, sca_aluno.DATAFASTAMENTO, sca_aluno.DATAMATRICULA, sca_situacaoaluno.Desc_SituacaoAluno "
		sql = sql & " from sca_aluno"
		sql = sql & " left join sca_situacaoaluno on sca_situacaoaluno.Cod_SituacaoAluno = sca_aluno.cod_situacaoaluno and sca_situacaoaluno.cod_empresa = sca_aluno.cod_empresa"
		sql = sql & " where sca_aluno.cod_empresa = " & session("CodEmpresa")
		sql = sql & " and sca_aluno.matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			strDatafastamento 	= FORMATADATAap(Trim(rs("DATAFASTAMENTO")))
			strDatamatricula 	= FORMATADATAap(Trim(rs("DATAMATRICULA")))
			strSituacaoAtual	= ucase(Trim(rs("Desc_SituacaoAluno")))
		else
			strCodAluno			= 0
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
	
	if strCodAluno <> "" then
		corLinha 			  = " "
		sql = "select efetivacao, codigo as codInscricao from mat_inscricao where cod_aluno = " & strCodAluno
		rsAux.open sql, cnn
		if not rsAux.eof then
			strEfetivacao		  = rsAux("EFETIVACAO")
			if not isnull(rsAux("codInscricao")) then
				if strEfetivacao = "S" then
					strBloqAltrExcl = ""
					corLinha = " "
				else
					strBloqAltrExcl = "disabled"
					strMensagemEfetivacao = "<br><table class='tabela' width='50%' border='0' cellspacing='0' cellpadding='0'><tr  bgcolor='#9BCDFF'><td class='celula'><strong>Aluno não está efetivado!<br>Ele deverá ser efetivado no módulo da Matrícula!</strong></td></tr></table><br><br>"
					corLinha = " bgcolor='#9BCDFF' "
				end if
			end if			
		end if
		rsAux.close
	end if
%>
<form method="post" id="frm" action="TrocaSituacaoAluno_cad.asp">
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
      <td width="14%" class="texto1">Matr&iacute;cula : </td>
      <td width="86%"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td height="18" colspan="2" class="texto1">&nbsp;</td>
      </tr>
    <tr>
      <td height="18" class="texto1">Situa&ccedil;&atilde;o Atual: </td>
      <td class="texto1"><strong><%=strSituacaoAtual%></strong>&nbsp;</td>
    </tr>
<% if strBloqAltrExcl = "" then %>
    <tr>
      <td height="18" class="texto1">Trocar Situa&ccedil;&atilde;o para:</td>
      <td><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr>
      <td height="18" class="texto1">Dt. Matr&iacute;cula:</td>
      <td><span class="texto1">
        <input name="txtDatamatricula" type="text" class="text" id="txtDatamatricula" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatamatricula%>" title="Click aqui para visualizar o calend&aacute;rio">
      </span></td>
    </tr>
    <tr>
      <td height="18" class="texto1">Dt. Afastamento:</td>
      <td><span class="texto1">
        <input name="txtDatafastamento" type="text" class="text" id="txtDatafastamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatafastamento%>" title="Click aqui para visualizar o calend&aacute;rio">
      </span></td>
    </tr>
    <tr> 
      <td height="18" class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td height="18" class="texto1" colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>   
<% end if %>
     
  </table>
  <%=strMensagemEfetivacao%>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>