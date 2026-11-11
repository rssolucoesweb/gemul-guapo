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
<iframe name="iframeGradeCurricular" height="0" width="0"></iframe>	
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>

	//function AlteraDisciplina(obj,nomeCampo,id,idnt) {
	//	var acao ="AD";
	//	iframeGradeCurricular.location.href='GradeCurricular_cod.asp?acao='+acao+'&NomeCampo='+nomeCampo+'&idnt='+idnt+'&ValorCampo='+obj.value; //ou pra dar um refresh --> 
	//	return true;
	//}
	
	function AlteraDisciplina(CodGrade, CodGradeCurricularDisciplina){
		window.open("GradeCurricularDisciplina_cad.asp?CodGrade="+CodGrade + "&GradeCurricularDisciplina=" + CodGradeCurricularDisciplina,"consulta", "top=0,left=0,height=570,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	
	function ExcluirDisciplina(CodGrade, CodGradeCurricularDisciplina){
		var acao ="ED";
		var frm = document.getElementById("frm");
		
		frm.action = "GradeCurricular_cod.asp?acao=" + acao + "&CodGrade=" + CodGrade + "&CodCurricularDisciplina=" + CodGradeCurricularDisciplina;
		frm.submit()
	}
	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if ((acao == "I") || (acao == "A")) {	
			
			if (frm.cmbCurso.value == "0") {
				alert("O Curso deve ser informado !");
				frm.cmbCurso.focus();
				return false;
			}

			if (frm.cmbPeriodo.value == "0") {
				alert("O Período deve ser informado !");
				frm.cmbPeriodo.focus();
				return false;
			}
				
			if (frm.cmbSemestre.value == "0") {
				alert("O Semestre deve ser informado !");
				frm.cmbSemestre.focus();
				return false;
			}
						
			if (frm.cmbSituacao.value == "0") {
				alert("A Situação deve ser informada !");
				frm.cmbSituacao.focus();
				return false;
			}
			
			if (frm.txtAno.value == "") {
				alert("O Ano deve ser informado !");
				frm.txtAno.focus();
				return false;
			}

			var form = window.document.forms[0];
			var intContMarcado=0;
			
			for (var i = 0; i < form.elements.length; i++) {
				//verifica todos os checkbox
				if (form.elements[i].type == "checkbox"){
					if (form.elements[i].name == "txtCodDisciplina"){
						//verifica se o checkbox está marcado
						if (form.elements[i].checked){
							intContMarcado = intContMarcado + 1;
						}
					}
				}
			}	
			if (intContMarcado==0){
				alert("A(s) disciplina(s) deve(m) ser informada!");
				return false;
			}			
			
			frm.action="GradeCurricular_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		
		}
		
		if (acao == "E") {
			
			var men = 'ATENÇÃO: Deseja realmente Excluir essa Grade Curricular?\n'
			if (confirm(men)) {
				frm.action="GradeCurricular_cod.asp?acao=" + acao;
				frm.submit();
			} 
			else {
				return false;
			}
		} 
		
 	}
</script>
<%
	strPaginaTitulo = "GradeCurricular_cad.asp"
	strExecutarSubmitCurso		                 = "S"

	intCodEmp = Session("CodEmpresa")

	strPagina = "GradeCurricular_cad.asp"
	
	
	if trim(request.querystring("nCodigo")) <> "" then
		intCodigo 		= trim(request.querystring("nCodigo"))
	else
		intCodigo	 	= Trim(Request.Form("txtCodigo"))
	end if
    if Trim(Request.Form("txtCodigo")) <> "" then BloqueiaCampo = " readonly "

	intCodCurso				= Trim(Request.Form("cmbCurso"))
	intCodCursoResolucao	= Trim(Request.Form("cmbCursoResolucao"))
	intCodPeriodo			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	intAno					= Trim(Request.Form("txtAno"))
	intCodDisciplina		= Trim(Request("txtCodDisciplina"))
	intCodAgrupamento   	= Trim(Request("txtCodAgrupamento"))
	
	'intCodGradeEquivalente 		= Trim(Request.Form("cmbGradeEquivalente"))
				
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
		sql = sql & " FROM  SCA_GRADECURRICULAR INNER "
		sql = sql & " JOIN 	SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " WHERE SCA_GRADECURRICULAR.Cod_Empresa = " & intCodEmp
		sql = sql & " AND 	COD_GRADECURRICULAR = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
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

			strDesabilitaIncluir= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir= "" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if intCodCurso = "" then intCodCurso = 0
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
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Grade : </td>
            <td><input <%=BloqueiaCampo%> name="txtCodigo" type="text" class="text" id="txtCodigo"  value="<%=intCodigo%>" size="10" maxlength="10" onKeyPress="return formataCampo(this,2,10)" onBlur="submit()"> <a href="#" onClick="return abreConsulta('GradeCurricular_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1312','','<%=session("strCaminhoRaiz")%>/images/Consulta_over.gif',1)"><img  src="<%=session("strCaminhoRaiz")%>/images/Consulta_normal.gif" name="Image1312" width="26" height="26" border="0" align="absmiddle" id="Image1312" /></a></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Curso : </td>
            <td><!--#include file="../includes/inc_cmdCurso.asp" --></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Resolu&ccedil;&atilde;o/habilita&ccedil;&atilde;o:</td>
            <td><!--#include file="../includes/inc_cmdCursoResolucao.asp"--></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Periodo : </td>
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
            <td class="texto1" valign="top">Disciplinas : </td>
            <td>
            	<!-- disc -->
                
				<%
				if intCodigo="" then
					sql = "	SELECT "
					SQL = SQL & " NULL as Cod_disciplina_grade, "
					SQL = SQL & " SCA_DISCIPLINA.COD_Disciplina,"
					SQL = SQL & " SCA_DISCIPLINA.DESC_Disciplina"
					SQL = SQL & " FROM SCA_DISCIPLINA "
					SQL = SQL & " WHERE SCA_DISCIPLINA.Cod_Empresa = " & intCodEmp
					SQL = SQL & " Order by SCA_DISCIPLINA.DESC_Disciplina"
				else
					sql = "	SELECT DISTINCT "
					SQL = SQL & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina as Cod_disciplina_grade, "
					SQL = SQL & " SCA_DISCIPLINA.COD_Disciplina,"
					SQL = SQL & " SCA_DISCIPLINA.DESC_Disciplina"
					SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA "
					SQL = SQL & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina"
					SQL = SQL & " WHERE 1=1"
					SQL = SQL & " AND SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodigo
					SQL = SQL & " AND SCA_DISCIPLINA.Cod_Empresa = " & intCodEmp

					sql = SQL & " UNION SELECT "
					SQL = SQL & " NULL as Cod_disciplina_grade, "
					SQL = SQL & " SCA_DISCIPLINA.COD_Disciplina,"
					SQL = SQL & " SCA_DISCIPLINA.DESC_Disciplina"
					SQL = SQL & " FROM SCA_DISCIPLINA "
					SQL = SQL & " WHERE 1=1"
					SQL = SQL & " AND SCA_DISCIPLINA.COD_Disciplina NOT IN ("
					
					SQL = SQL & " 		SELECT DISTINCT "
					SQL = SQL & " 		SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina"
					SQL = SQL & " 		FROM SCA_GRADECURRICULARDISCIPLINA "
					SQL = SQL & " 		INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina"
					SQL = SQL & " 		WHERE 1=1"
					SQL = SQL & " 		AND SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodigo
					SQL = SQL & " 		AND SCA_DISCIPLINA.Cod_Empresa = " & intCodEmp
					SQL = SQL & " 										)"
					SQL = SQL & " AND SCA_DISCIPLINA.Cod_Empresa = " & intCodEmp

					SQL = SQL & " Order by 3"
				end if
				rs.open sql, cnn
				if not rs.eof then  
				%>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<%	
					cont = 0
					while not rs.eof
						if cint(cont) = 2 then 
							%>
							<tr>
							<%
						end if

						selecionaDisciplina = ""
						if not isnull(rs("Cod_disciplina_grade")) then selecionaDisciplina = " checked "
						%>
						<td width="33%" class="texto1"><input <%=selecionaDisciplina%> name="txtCodDisciplina" id="txtCodDisciplina" type="checkbox" value="<%=rs("COD_Disciplina")%>">
						<%=trim(ucase(rs("DESC_Disciplina")))%></td>
						<%
						cont = cont + 1
						if cint(cont) = 2 then 
							%>
                            </tr>
                                    <tr>
							<%
							cont  = 0
						end if
						
						rs.movenext
					wend
					%>
					</tr>
				</table>
				<%
				end if
				rs.close				  
				%>                
                
                <!-- disc -->            </td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="#E6E6E6" class="texto1"><strong>Dados da Cria&ccedil;&atilde;o </strong></td>
            </tr>
          <tr>
            <td width="146" height="24" class="texto1">Ano Refer&ecirc;ncia   : </td>
            <td width="557"><input  name="txtAno" type="text" class="text" id="txtAno"  value="<%=intAno%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Semestre Refer&ecirc;ncia  : </td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Ving&ecirc;ncia:</td>
            <td><span class="texto1">
              <input name="txtDataInicio" type="text" class="text" id="txtDataInicio" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicio%>"  style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
            a
            <input name="txtDataFim" type="text" class="text" id="txtDataFim" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFim%>"  style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
            </span></td>
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
            <td colspan="2">
			<% if trim(intCodigo) <> "" then %>
			
              <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="tabela" >
                <tr bgcolor="#D3D3D3">
                  <td width="4%" rowspan="2" class="celula">&nbsp;</td>
                  <td width="36%" rowspan="2" align="center" class="celula"><strong>Disciplina</strong></td>
                  <td width="13%" rowspan="2" align="center" class="celula"><strong>C.H. Semanal </strong></td>
                  <td width="11%" rowspan="2" align="center" class="celula"><strong>C.H. Mensal </strong></td>
                  <td width="10%" rowspan="2" align="center" class="celula"><strong>C.H. Total</strong></td>
                  <td colspan="2" align="center" class="celula"><strong>Opcional</strong></td>
                  </tr>
                <tr bgcolor="#D3D3D3">
                  <td width="13%" align="center" class="celula"><strong>C.H. Pr&aacute;tica</strong></td>
                  <td width="13%" align="center" class="celula"><strong>C.H. Te&oacute;rica</strong></td>
                </tr>
                <%
				
				sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
				sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, SCA_GRADECURRICULARDISCIPLINA.Ch_Pratica, SCA_GRADECURRICULARDISCIPLINA.Ch_Teorica, "
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina_Equivalente, "
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
					
					intCodGradeEquivalente = rs("Cod_GradeCurricular_Equivalente")
					intCodDisciplinaGradeEquivalente = rs("Cod_GradeCurricularDisciplina_Equivalente")
					intCodDisciplinaEquivalente = rs("Cod_Disciplina_Equivalente")

					%>
                      	<tr bgcolor="#F3F3F3">
						<td height="24" align="center" class="celula"><a href="#" <%if trim(strBotaoAlterar) = "" then%> onClick="ExcluirDisciplina('<%=intCodigo%>','<%=rs("Cod_GradeCurricularDisciplina")%>')" <%end if%>  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('999','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para excluir o servi&ccedil;o." align="absmiddle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image2" width="15" height="15" border="0"></a></td>
						<td class="celula" style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return AlteraDisciplina('<%=intCodigo%>','<%=rs("Cod_GradeCurricularDisciplina")%>')"><strong><%=rs("DESC_Disciplina")%>&nbsp;</strong></td>
						<td class="celula" align="center"><%=rs("Ch_Semanal")%>&nbsp;</td>
						<td class="celula" align="center"><%=rs("Ch_Mensal")%>&nbsp;</td>
						<td align="center" class="celula"><%=rs("Ch_Anual")%>&nbsp;</td>
						<td align="center" class="celula"><%=rs("Ch_Pratica")%>&nbsp;</td>
						<td align="center" class="celula"><%=rs("Ch_Teorica")%>&nbsp;</td>
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
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>