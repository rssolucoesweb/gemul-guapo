<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Curricular 
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
<iframe name="iframeGradeCurricularHistorico" height="0" width="0"></iframe>	
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>

	function AlteraDisciplina(obj,id,idnt) {
		var valor = document.all["txtDisc_" + id].value;
		iframeGradeCurricularHistorico.location.href='GradeCurricularAjusteHistorico_cod.asp?idnt='+idnt+'&ValorCampo='+obj.value; //ou pra dar um refresh --> 
		return true;
	}
	
</script>
<%
	strPaginaTitulo = "GradeCurricularAjusteHistorico_cad.asp"
	strExecutarSubmitCurso		                 = "S"

	intCodEmp = Session("CodEmpresa")

	strPagina = "GradeCurricular_cad.asp"
	
	
	if trim(request.querystring("nCodigo")) <> "" then
		intCodigo 		= trim(request.querystring("nCodigo"))
	else
		intCodigo	 	= Trim(Request.Form("txtCodigo"))
	end if
	
	intCodCurso			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo		= Trim(Request.Form("cmbPeriodo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	intAno				= Trim(Request.Form("txtAno"))
	intCodDisciplina	= Trim(Request("txtCodDisciplina"))
	intCodAgrupamento   = Trim(Request("txtCodAgrupamento"))

	
	'intCodGradeEquivalente 		= Trim(Request.Form("cmbGradeEquivalente"))
				
	if trim(intCodigo) <> "" then
	
		bolAcaoGrade = "A"			
		sql = "SELECT  *"   	
		sql = sql & " FROM  SCA_GradeCurricularDisciplinaHistorico "
		sql = sql & " INNER JOIN 	SCA_GradeCurricularDisciplina ON SCA_GradeCurricularDisciplina.Cod_GradeCurricularDisciplina = SCA_GradeCurricularDisciplinaHistorico.Cod_GradeCurricularDisciplina"
		sql = sql & " where 	SCA_GradeCurricularDisciplina.COD_GRADECURRICULAR = " & intCodigo
		rs.open sql, cnn
		if rs.eof then
			bolAcaoGrade = "I"			
		end if 
		rs.close
		
	end if 
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
            <td colspan="2" bgcolor="#E6E6E6" class="texto1"><strong>Dados da Grade </strong></td>
            </tr>
          <tr>
            <td width="69" height="24" class="texto1">Grade : </td>
            <td width="1279"><input  name="txtCodigo" type="text" class="text" id="txtCodigo"  value="<%=intCodigo%>" size="10" maxlength="10" onKeyPress="return formataCampo(this,2,10)" onBlur="submit()"> <a href="#" onClick="return abreConsulta('GradeCurricular_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1312','','<%=session("strCaminhoRaiz")%>/images/Consulta_over.gif',1)"><img  src="<%=session("strCaminhoRaiz")%>/images/Consulta_normal.gif" name="Image1312" width="26" height="26" border="0" align="absmiddle" id="Image1312" /></a></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">
			<% if trim(intCodigo) <> "" then %>
			
              <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="tabela" >
                <tr bgcolor="#D3D3D3">
                  <td width="53%" align="center" class="celula"><strong>Disciplina</strong></td>
                  <td width="47%" align="center" class="celula"><strong>C&oacute;digo Disciplina Historico</strong></td>
                  </tr>
                <%
				
				sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
				sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina_Equivalente, "
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular_Equivalente,"
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina_Equivalente, "
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual "
				sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA INNER JOIN SCA_DISCIPLINA "
				sql = sql & " ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
				sql = sql & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodigo
				sql = sql & " order by SCA_DISCIPLINA.DESC_Disciplina"
				rs.open sql, cnn		
				if not rs.eof then
				id = 0
				while not rs.eof 
					intDisc = ""
					if 	bolAcaoGrade = "I"	then
					
						sql = "Insert into SCA_GradeCurricularDisciplinaHistorico (Cod_disciplina_hsitorico, "
						sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr) values ("
						sql = sql & "null,"
						sql = sql & "null,"
						sql = sql & "null,"
						sql = sql & "null,"
						sql = sql & "null)"
						'cnn.execute sql
						
					else
						sql = "SELECT  Cod_disciplina_hsitorico "   	
						sql = sql & " FROM  SCA_GradeCurricularDisciplinaHistorico "
						sql = sql & " where Cod_GradeCurricularDisciplina = " & rs("Cod_GradeCurricularDisciplina")
						rsAux.open sql, cnn
						if not rsAux.eof then
							intDisc = rsAux("Cod_disciplina_hsitorico")
						end if 
						rsAux.close
						
					end if
					%>
					<tr bgcolor="#F3F3F3">
						<td class="celula"><strong><%=rs("DESC_Disciplina")%>&nbsp;</strong></td>
						<td class="celula" align="center"><input onBlur="AlteraDisciplina(this,'<%=id%>','<%=rs("Cod_GradeCurricularDisciplina")%>')" name="txtDisc_<%=id%>" type="text" class="text" id="txtDisc_<%=id%>" onKeyPress="return formataCampo(this,2,5)"  value="<%=intDisc%>" size="15" maxlength="15"></td>
					  </tr>
                <%
					id = id + 1
					rs.movenext
				wend 
				%>

                <%
			end if			
			rs.close
		%>
              </table>
              <%end if%></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
		</form>
		<div align="left">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdLimpar" type="button" id="cmdLimpar" class=botao value="Limpar" onClick="window.navigate('GradeCurricularAjusteHistorico_cad.asp')">
            <input name="cmdMenu" type="button" id="cmdMenu" class=botao value="Principal" onClick="window.navigate('default.asp')">
        </div>
        </td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>