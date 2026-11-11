<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Criterio de Avaliação
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

		if (frm.txtNomealuno.value==""){
			alert("Atenção: Aluno não foi encontrado, verifique a matrícula digitada.")
			return false
		}
		frm.action="HistoricoEscolar_cad.asp";
		frm.submit();
		return true;
 	}
	
	function resultadoConsulta(intCodigo, strMatricula){
		
		
		var frm = document.getElementById("frm");

		frm.action="HistoricoEscolar_cad.asp?codhistoricoEscolar=" + intCodigo + "&txtMatricula=" + strMatricula;
		frm.submit();
	}
	
	function limpaHistorico(intCodHit, intCodAluno, strMatricula){
		
		
		var frm = document.getElementById("frm");
		var men = 'ATENÇÃO: \nDeseja realmente excluír os dados do histório neste ano e semestre?';
		
		if (confirm(men)) {
			frm.action="HistoricoEscolar_exc.asp?codAluno=" + intCodAluno + "&intCodHit=" + intCodHit + "&matricula=" + strMatricula;
			frm.submit();
		} else {
			return false;
		}

	}	
	function importar(){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value==""){
			alert("Atenção: A matrícula do aluno deve ser informada.")
			frm.txtMatricula.focus();
			return false
		}
		
		frm.action="HistoricoEscolar_importar.asp";
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "HistoricoEscolar_con.asp"


	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strSemestre 		= session("strSemestre")
	strAnoLetivo 		= session("strAnoLetivo")
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	if strMatricula <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		end if
		rs.close	
	else
			strCodAluno			= ""
			strMatricula 		= ""
			strNomealuno 		= ""
	end if

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir


%>
<form method="post" id="frm" action="HistoricoEscolar_con.asp">
<table width="100%" height=355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td height="90" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center" valign="top">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">Matr&iacute;cula : </td>
      <td colspan="2"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span><input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" >
        <%if strMatricula<>"" and session("codEmpresa")="8" then%>
          <input class="botao" type="button" name="button" id="button" value="Importar Dados Sistema Anterior" onClick="importar()">
        <%end if%>
        </td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
        </table>
		
			<%
			if strCodAluno <> "" then
				sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
				sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
				sql = sql & " AND	COD_ALUNO = " & strCodAluno
			  	sql = sql & " order by ano_letivo, semestre, serie "
				rs.open sql, cnn
				if not rs.eof then	%>
				<br>
				 <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
				<tr bgcolor="#EEEEEE">
				  <td height="20" colspan="6" class="celula"><div align="center"><strong>Estudos Realizados </strong></div></td>
				  </tr>
				<tr bgcolor="#EEEEEE">
				  <td width="6%" class="celula"><strong>&nbsp;Ano</strong></td>
				  <td width="9%" class="celula"><strong>&nbsp;Semestre</strong></td>
				  <td width="31%" class="celula"><strong>&nbsp;Escola</strong></td>
				  <td width="27%" class="celula">&nbsp;<strong>Curso</strong></td>
				  <td width="20%" height="20" class="celula">&nbsp;<strong>Per&iacute;odo/S&eacute;rie&nbsp;</strong></td>
				  <td width="7%" class="celula" align="center"><strong>Excluir</strong></td>
				</tr>
				<%
					while not rs.eof 
					%>	  
					<tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  >
					  <td class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>','<%=strMatricula%>')">&nbsp;<%=rs("ano_letivo")%></td>
						<td class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>','<%=strMatricula%>')">&nbsp;<%=rs("semestre")%></td>
						<td class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>','<%=strMatricula%>')">&nbsp;<%=rs("escola")%></td>
						<td class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=rs("curso")%></td>
						<td height="20" class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>','<%=strMatricula%>')">&nbsp;<%=rs("serie")%></td>
					    <td align="center" class="celula" onClick="return limpaHistorico('<%=rs("CODIGO")%>','<%=strCodAluno%>','<%=strMatricula%>')"><img alt="Clique para excluir os dados do histórico." align="absmiddle" src="../../images/botao_vermelho_normal.gif" name="Imagem" width="26" height="26" border="0"></td>
					</tr>				
					<%
						rs.movenext
					wend
					%>
				  </table>
					<%
				end if
				rs.close
			end if
			%>
		
		
		</td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>