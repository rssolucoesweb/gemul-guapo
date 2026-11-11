<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de horario 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnndocumento.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../fckeditor/fckeditor.asp" -->

<script>

	function reload(){
		
		var frm = document.getElementById("frm");
		frm.submit();
	}
	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function blocTexto(valor, id)
	{
		quant = 500;
		total = valor.length;
		if(total <= quant)
		{
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}
		else
		{
			document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
		}
	}
	
	
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if (frm.cmbCurso.value == "0") {
			alert("O Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}
	
		if (frm.cmbPeriodo.value == "0") {
			alert("O Periodo deve ser informado !");
			frm.cmbPeriodo.focus();
			return false;
		}
	
		if (frm.cmbGrade.value == "0") {
			alert("A Grade deve ser informada !");
			frm.cmbGrade.focus();
			return false;
		}
	
		if (frm.cmbDisciplinaGrade.value == "0") {
			alert("A Disciplina deve ser informada !");
			frm.cmbDisciplinaGrade.focus();
			return false;
		}
	
		frm.action="PlanoEnsino_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strExecutarSubmitCurso	         = "S"
	strExecutarSubmitPeriodo         = "S"
	strExecutarSubmitGradeCurricular = "S"   
	strExecutarDisciplinaGrade       = "S"
	strPlanoEnsino_submit 			 = "S"

	strPaginaTitulo        					 	= "PlanoEnsino_cad.asp"

	intCodigo 				= Trim(Request.Form("txtCodigo"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	intCodDisciplinaGrade   = Trim(Request.Form("cmbDisciplinaGrade"))
	strPlanoEnsino          = Trim(Request.Form("cmbPlanoEnsino"))
	strTexto 				= Trim(Request.Form("txttexto"))
 
	'if Trim(Request.QueryString("cmbCurso")) <> "" then
	'	intCodCurso	 			= Trim(Request.QueryString("cmbCurso"))
	'end if		
 	'if Trim(Request.QueryString("cmbPeriodo")) <> "" then
	'	intCodPeriodo	 			= Trim(Request.QueryString("cmbPeriodo"))
	'end if		
 	'if Trim(Request.QueryString("cmbGrade")) <> "" then
	'	intCodGrade	 			= Trim(Request.QueryString("cmbGrade"))
	'end if		
	'if Trim(Request.QueryString("cmbDisciplinaGrade")) <> "" then
	'	intCodDisciplinaGrade	= Trim(Request.QueryString("cmbDisciplinaGrade"))
	'end if		
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intCodGrade = "" then intCodGrade = "0"
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = "0"
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM SCA_PLANOENSINO "
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if not rs.eof then
		
		   intCodigo							= rs("Codigo")
		   AnoLetivo							= rs("AnoLetivo")
		   intSemestre							= rs("Semestre")
		   intCodCurso							= rs("Cod_Curso")
		   intCodPeriodo						= rs("Cod_Periodo")
		   if Trim(Request.Form("cmbGrade"))="" or  Trim(Request.Form("cmbGrade")) = "0" then
		      intCodGrade						= rs("Cod_GradeCurricular")
		   end if
		   if Trim(Request.Form("cmbDisciplinaGrade"))="" or  Trim(Request.Form("cmbDisciplinaGrade")) = "0" then
		      intCodDisciplinaGrade				= rs("Cod_GradeCurricularDisciplina")
		   end if
		   strObjetivos							= rs("Objetivos")
		   strEmenta							= rs("Ementa")
		   strConteudoProgramatico				= rs("Conteudo_Programatico")
		   strMetodologia						= rs("Metodologia")
		   strBibliografiaBasica				= rs("Bibliografia_Basica")
		   strBibliografiaComplementar			= rs("Bibliografia_Complementar")
		   strCriterioAvaliacao					= rs("Criterio_Avaliacao")

		   strDesabilitaIncluir					= "disabled" 'Desabilita o botão Incluir
		   strDesabilitaAlterar 				= "" 'Desabilita o botão Excluir
		   strDesabilitaExcluir					= "" 'Desabilita o botão Excluir

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
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="PlanoEnsino_cad.asp">
		<input name="txtCodigo" value="<%=intCodigo%>" type="hidden">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="130" height="25" class="texto1">Curso:</td>
				<td width="832"><!--#include file="../includes/inc_cmdCurso.asp" --></td>
			  </tr>
			  <tr>
				<td height="26" class="texto1">Per&iacute;odo:</td>
				<td><!--#include file="../includes/inc_cmdPeriodo.asp" --></td>
			  </tr>
			  <tr>
				<td height="24" class="texto1">Grade:</td>
				<td><!--#include file="../includes/inc_cmdGradeCurricular.asp" --></td>
			  </tr>
			  <tr>
				<td height="27" class="texto1">Disciplinas:</td>
				<td><!--#include file="../includes/inc_cmdDisciplinaGrade.asp" --></td>
			  </tr>
			  <tr>
				<td class="texto1">Ementa:</td>
				<td class="texto1"><!--#include file="../includes/inc_cmbPlanoEnsino.asp" --></td>
			  </tr>
			  <tr>
            	<td colspan="2" class="texto1">&nbsp;</td>
         	 </tr>
          	<% 
		    if strPlanoEnsino = "0" then strPlanoEnsino = "OBJ"

		 	if strPlanoEnsino = "OBJ" then
                msgPlanoEnsino 	= "OBJETIVOS"
				strTexto 		= strObjetivos
		 	elseif strPlanoEnsino = "EME" then	
				msgPlanoEnsino = "EMENTA"
				strTexto 		= strEmenta
		 	elseif strPlanoEnsino = "CON" then	
				msgPlanoEnsino = "CONTEÚDO PROGRAMÁTICO"
				strTexto 		= strConteudoProgramatico
			elseif strPlanoEnsino = "MET" then	
				msgPlanoEnsino = "METODOLOGIA DE AVALIAÇÃO"
				strTexto 		= strMetodologia
		 	elseif strPlanoEnsino = "BIB" then	
				msgPlanoEnsino = "BIBLIOGRAFIA BÁSICA"
				strTexto 		= strBibliografiaBasica
		 	elseif strPlanoEnsino = "BIC" then	
				msgPlanoEnsino = "BIBLIOGRAFIA COMPLEMENTAR"
				strTexto 		= strBibliografiaComplementar
		 	elseif strPlanoEnsino = "CRI" then	
				msgCriterioAvalicao = "CRITÉRIO DE AVALIAÇÃO"
				strTexto 		= strCriterioAvaliacao
		 	end if	
		  %>
           <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
         <tr>
 			<td colspan="2" class="tituloSistema"><div align="left"><strong><%=msgPlanoEnsino%></strong></div></td>
          </tr>
          <tr>
          <td colspan="2">
		  <%
           Dim oFCKeditor
           Set oFCKeditor = New FCKeditor
           oFCKeditor.BasePath	="../../Sistema/fckeditor/"
           oFCKeditor.Config("DefaultLanguage") = "pt-br"
           oFCKeditor.Value = strTexto
           oFCKeditor.Width = 1000
           oFCKeditor.Height = 300
           oFCKeditor.Create "txtTexto"
          %>
          </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><br>
		</table>
            <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr bgcolor="#E5E5E5">
            <td width="18%" height="21" class="celula"><strong>Grade - Curso</strong></td>
            <td width="6%" class="celula"><strong><strong>Per&iacute;odo</strong></strong></td>
            <td width="21%" class="celula"><strong>Disciplina</strong></td>
            <td width="6%" class="celula"><strong>Objetivo</strong></td>
            <td width="6%" class="celula"><strong>Ementa</strong></td>
            <td width="7%" class="celula"><strong>Conte&uacute;do</strong></td>
            <td width="9%" class="celula"><strong>Metodologia</strong></td>
            <td width="9%" class="celula"><strong>Bibliografia B&aacute;sica </strong></td>
            <td width="9%" class="celula"><strong>Bibliografia Complem.</strong></td>
            <td width="9%" class="celula"><strong>Crit&eacute;rio de Avalia&ccedil;&atilde;o</strong></td>
            </tr>
            <%
			sql = "SELECT con.codigo, cur.descricao as Curso, per.descricao as periodo, dis.desc_disciplina, Cod_Agrupamento, Objetivos, Ementa, Conteudo_Programatico, Metodologia, Bibliografia_Basica, Bibliografia_Complementar, Criterio_Avaliacao " 
			sql = sql & " FROM sca_planoensino con "
			sql = sql & " inner join sca_curso cur on cur.cod_curso = con.cod_curso "
			sql = sql & " inner join sca_periodo per on per.cod_periodo = con.cod_periodo "
 			sql = sql & " inner join sca_disciplina dis on dis.cod_disciplina = con.cod_gradecurricularDisciplina "
			sql = sql & " inner join SCA_GRADECURRICULAR gc on gc.Cod_GradeCurricular = con.Cod_GradeCurricular "
			sql = sql & " where con.cod_empresa = " & Session("CodEmpresa")
			sql = sql & " and con.cod_curso = " & intCodCurso
			sql = sql & " order by cur.descricao, per.descricao, dis.desc_disciplina " 	
			rs.open sql, cnn
			while not rs.eof
			   cont = cont + 1

			   msgObjetivos = "OK"
			   msgEmenta = "OK"
			   msgConteudo_Programatico = "OK"
			   msgMetodologia = "OK"
			   msgBibliografia_Basicas = "OK"
			   msgBibliografia_Complementar = "OK"
			   msgCriterio_Avalicao = "OK"

			   
			   if isnull(rs("Objetivos")) or rs("Objetivos") = "" then msgObjetivos = "----"
			   if isnull(rs("Ementa")) or rs("Ementa") = "" then msgEmenta = "----"
			   if isnull(rs("Conteudo_Programatico")) or rs("Conteudo_Programatico") = "" then msgConteudo_Programatico = "----"
			   if isnull(rs("Metodologia")) or rs("Metodologia") = "" then msgMetodologia = "----"
			   if isnull(rs("Bibliografia_Basica")) or rs("Bibliografia_Basica") = "" then msgBibliografia_Basicas = "----"
			   if isnull(rs("Bibliografia_Complementar")) or rs("Bibliografia_Complementar") = "" then msgBibliografia_Complementar = "----"
			   if isnull(rs("Criterio_Avaliacao")) or rs("Criterio_Avaliacao") = "" then msgCriterio_Avalicao = "----"
			   
			   %>
			   <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
			   <td class="celula"><%=rs("Cod_Agrupamento")%>&nbsp;-&nbsp;<%=rs("Curso")%></td>
			   <td class="celula"&nbsp;>&nbsp;<%=rs("periodo")%></td>
			   <td height="20" class="celula">&nbsp;<%=trim(rs("desc_disciplina"))%></td>
			   <td height="20" class="celula"><div align="center"><%=msgObjetivos%></div></td>
			   <td height="20" class="celula"><div align="center"><%=msgEmenta%></div></td>
			   <td height="20" class="celula"><div align="center"><%=msgConteudo_Programatico%></div></td>
			   <td height="20" class="celula"><div align="center"><%=msgMetodologia%></div></td>
			   <td height="20" class="celula"><div align="center"><%=msgBibliografia_Basicas%></div></td>
			   <td height="20" class="celula"><div align="center"><%=msgBibliografia_Complementar%></div></td>
			   <td height="20" class="celula"><div align="center"><%=msgCriterio_Avalicao%></div></td>
			   <%
			   rs.movenext
			wend
			%>
            <tr>
            <td height="21" colspan="9" class="celula">Total Registros : <%=cont%></td>
            </tr>
        <tr>
        <td>&nbsp;</td>
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