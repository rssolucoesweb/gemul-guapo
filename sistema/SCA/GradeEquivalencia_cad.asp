<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.brs
	::	Objetivo Pagina...: Cadastro Grade Equivalencia 
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
</script></head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/Consulta_over.gif')">
<iframe name="iframeGradeCurricular" height="0" width="0"></iframe>	
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		frm.action="GradeEquivalencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;

	}
</script>
<%
	strPaginaTitulo									= "GradeEquivalencia_cad.asp"
	strPagina 										= "GradeEquivalencia_cad.asp"
	strExecutarSubmitCurso							= "S"
	strExecutarDisciplinaGrade						= "S"	
	strExecutarSubmitGradeCurricularEquivalencia 	= "S"
    strExecutarSubmitDisciplinaEquivalencia         = "S"
	
	
	intCodEmp 										= Session("CodEmpresa")
	intCodigo	 									= Trim(Request.Form("txtCodigo"))
    intCodCurso										= Trim(Request.Form("cmbCurso"))
	intCodCursoResolucao							= Trim(Request.Form("cmbCursoResolucao"))
	intCodPeriodo									= Trim(Request.Form("cmbPeriodo"))
	intSemestre 									= Trim(Request.Form("cmbSemestre"))
	strSituacao										= Trim(Request.Form("cmbSituacao"))
	intAno											= Trim(Request.Form("txtAno"))
	intCodDisciplina								= Trim(Request("txtCodDisciplina"))
	intCodAgrupamento   							= Trim(Request("txtCodAgrupamento"))
	
	' Origem
	intCodDisciplinaGrade	 						= Trim(Request("cmbDisciplinaGrade")) 
	
	' Destino
	intCodGradeEquivalente  						= Trim(Request("cmbGradeEquivalente"))
	intCodDisciplinaGradeEquivalente  				= Trim(Request("cmbDisciplinaGradeEquivalente"))  
		
			
	if trim(intCodigo) <> "" then
	
		sql = "SELECT     	SCA_GRADECURRICULAR.Cod_GradeCurricular, "
		sql = sql & " 		SCA_PERIODO.Cod_Curso, "
		sql = sql & " 		SCA_GRADECURRICULAR.CodCursoResolucao, "
		sql = sql & " 		SCA_GRADECURRICULAR.AnoReferencia, "
		sql = sql & "       SCA_GRADECURRICULAR.SemestreReferencia, "
		sql = sql & " 		SCA_GRADECURRICULAR.Situacao, "
		sql = sql & " 		SCA_GRADECURRICULAR.Cod_Periodo, "
		sql = sql & "       SCA_GRADECURRICULAR.Cod_Empresa, "
		sql = sql & "       SCA_GRADECURRICULAR.dataInicioVigencia, "
		sql = sql & "       SCA_GRADECURRICULAR.dataFimVigencia, "
		sql = sql & "       SCA_GRADECURRICULAR.Cod_Agrupamento "
		sql = sql & " FROM  SCA_GRADECURRICULAR  "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " WHERE SCA_GRADECURRICULAR.Cod_Empresa = " & intCodEmp
		sql = sql & " AND 	COD_GRADECURRICULAR = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodGrade				= rs("COD_GRADECURRICULAR")
			intCodigo	 			= rs("COD_GRADECURRICULAR")
			intCodCurso				= rs("Cod_Curso")
			intCodCursoResolucao	= rs("CodCursoResolucao")
			intCodPeriodo			= rs("Cod_Periodo")
			intAno					= rs("AnoReferencia")
			intSemestre 			= rs("SemestreReferencia")
			strSituacao				= rs("Situacao")
			
			'vingecia
			strDataInicio		= rs("dataInicioVigencia")
			strDataFim			= rs("dataFimVigencia")
			intCodAgrupamento   = rs("Cod_Agrupamento")
			
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	end if 
	
	if intCodCurso = "" then intCodCurso = 0
	if intCodGrade = "" then intCodGrade = 0
	if intCodigo = "" then intCodigo = 0
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = 0
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="98%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="98%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" bgcolor="#E6E6E6" class="texto1"><strong>Dados da Grade de Origem</strong></td>
            </tr>
          <tr>
            <td height="24" class="texto1">Grade: </td>
            <td><input readonly name="txtCodigo" type="text" class="text" id="txtCodigo"  value="<%=intCodigo%>" size="10" maxlength="10" onKeyPress="return formataCampo(this,2,10)" onBlur="submit()"> <a href="#" onClick="return abreConsulta('GradeCurricular_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1312','','<%=session("strCaminhoRaiz")%>/images/Consulta_over.gif',1)"><img  src="<%=session("strCaminhoRaiz")%>/images/Consulta_normal.gif" name="Image1312" width="26" height="26" border="0" align="absmiddle" id="Image1312" /></a></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Curso: </td>
            <td><!--#include file="../includes/inc_cmdCurso.asp" --></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Resolu&ccedil;&atilde;o/habilita&ccedil;&atilde;o:</td>
            <td><!--#include file="../includes/inc_cmdCursoResolucao.asp"--></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Periodo: </td>
            <td><!--#include file="../includes/inc_cmdPeriodo.asp" --></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Codigo de Agrupamento: </td>
            <td><input  name="txtCodAgrupamento" type="text" class="text" id="txtCodAgrupamento"  value="<%=intCodAgrupamento%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,5)"></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Situa&ccedil;&atilde;o : </td>
            <td><!--#include file="../includes/inc_cmdSituacao.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="#E6E6E6" class="texto1"><strong>Dados da Disciplina de Origem</strong></td>
            </tr>
          <tr>
            <td width="146" height="24" class="texto1">Disciplina: </td>
            <td width="557"><!--#include file="../includes/inc_cmdDisciplinaGrade.asp" --></td>
          </tr>
          <tr>
            <td height="18" colspan="2" bgcolor="#E6E6E6" class="texto1"><strong>Dados da Matriz Equivalente</strong></td>
          </tr>
          <%
			sql = " SELECT Cod_GradeCurricularDisciplina_Equivalente, "
			sql = sql & " Cod_Disciplina_Equivalente "
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " WHERE	Cod_GradeCurricular = " & intCodigo
 			sql = sql & " AND Cod_Disciplina = " & intCodDisciplinaGrade
			rs.open sql, cnn
			if rs.eof = false then 
			
			    if Trim(Request("cmbGradeEquivalente")) = "" or Trim(Request("cmbGradeEquivalente")) = "0" then  intCodGradeEquivalente = rs("Cod_GradeCurricularDisciplina_Equivalente")
 				if isnull(intCodGradeEquivalente) or intCodGradeEquivalente = "" then 
				    intCodGradeEquivalente = "0"
				end if	

			    if Trim(Request("cmbDisciplinaGradeEquivalente")) = "" or Trim(Request("cmbDisciplinaGradeEquivalente")) = "0" then  intCodDisciplinaGradeEquivalente = rs("Cod_Disciplina_Equivalente")
 				if isnull(intCodDisciplinaGradeEquivalente) or intCodDisciplinaGradeEquivalente = "" then 
				    intCodDisciplinaGradeEquivalente = "0"
				end if	
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			else
				 intCodGradeEquivalente = "0"
				 intCodDisciplinaGradeEquivalente = "0"
			end if	
			rs.close
		  
		  %>
          <tr>
            <td height="23" class="texto1">Matriz:</td>
            <td><!--#include file="../includes/inc_cmdGradeCurricularEquivalente.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Disciplina:</td>
            <td><!--#include file="../includes/inc_cmdDisciplinaGradeEquivalente.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td><input  name="txtCodGradeCurricularDisciplina" type="hidden" class="text" id="txtCodGradeCurricularDisciplinas"  value="<%=strCodGradeCurricularDisciplina%>" size="10" maxlength="10" onKeyPress="return formataCampo(this,2,10)" onBlur="submit()"></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
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