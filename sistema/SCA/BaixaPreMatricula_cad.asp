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

		frm.action="BaixaPreMatricula_cod.asp?acao=" + acao;
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
	strPaginaTitulo 	= "BaixaPreMatricula_cad.asp"

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	if trim(request.Form("txtData")) = "" then
	   strData 			= formatadataAP(date)
	else
	   strData				= formatadataAP(request.Form("txtData"))   
	end if
	
	if trim(strMatricula) <> "" then
	
		sql = "Select sca_aluno.Codigo, sca_aluno.NomeAluno, sca_aluno.matricula, sca_aluno.DATAFASTAMENTO, sca_aluno.DATAMATRICULA, sca_situacaoaluno.Desc_SituacaoAluno "
		sql = sql & " from sca_aluno"
		sql = sql & " left join sca_situacaoaluno on sca_situacaoaluno.Cod_SituacaoAluno = sca_aluno.cod_situacaoaluno and sca_situacaoaluno.cod_empresa = sca_aluno.cod_empresa"
		sql = sql & " where sca_aluno.cod_empresa = " & session("CodEmpresa")
		sql = sql & " and sca_aluno.matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then  
			intCodAluno			= Trim(rs("codigo"))
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		else
		    intCodAluno         = "0"
			strCodAluno			= 0
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close	

		strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	
	else
		strCodAluno			= "0"
	    intCodAluno         = "0"
		strMatricula 		= ""
		strNomealuno 		= ""
		
		strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		
	end if

%>

<form method="post" id="frm" action="BaixaPreMatricula_cad.asp">
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
      <td class="texto1">Ano:</td>
      <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr>
      <td width="14%" class="texto1">Matr&iacute;cula: </td>
      <td width="86%"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td height="18" colspan="2" class="texto1">&nbsp;</td>
      </tr>
    <tr>
      <td height="18" colspan="2" class="texto1"><!--#include file="../includes/inc_sqlDadosAluno.asp"--></td>
      </tr>
    <tr>
      <td height="18" class="texto1">Data da Baixa:</td>
      <td height="18" class="texto1"><input name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
    </tr>
    <tr>
      <%
	  
	  	if trim(strMatricula) <> "" then
	
		   'regra ano / semestre destino
			
			sql = " SELECT Data_Baixa, USUARIO_BAIXA FROM SCA_PROTOCOLOPORTAL "
			sql = sql & " WHERE Cod_Empresa = " & Session("CodEmpresa")
			sql = sql & " AND Cod_Aluno = " &  intCodAluno
			sql = sql & " AND Ano = " &  strAnoLetivo 
			sql = sql & " AND Semestre = " & intSemestre
			sql = sql & " AND Tipo_Protocolo = 1 "	
			rs.open sql, cnn
			if not rs.eof then	
			   if isnull(rs("Data_Baixa")) or rs("Data_Baixa") = ""  then
				   strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
				   strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
				   strDesabilitaExcluir = "" 'Desabilita o botão Excluir
				   strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			   else
				   %>
				   <script>
					   alert("Protocolo já Baixado. Verifique!");
				   </script>
				   <%

				   strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
				   strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
				   strDesabilitaExcluir = "" 'Desabilita o botão Excluir
				   strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			   end if
			else
			   strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			   strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
			   strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			   strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			   %>
			   <script>
				   alert("Pré-Matrícula ainda não impressa. Verifique!");
			   </script>
			   <%
			end if
		    rs.close	

		end if	
	  %>   
     </tr>
    <tr> 
      <td class="texto1" colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>    
        <tr>
          <td class="texto1" colspan="2">&nbsp;</td>
        </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>