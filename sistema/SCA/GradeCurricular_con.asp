<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//-->
</script>
<script>
	function resultadoConsulta(intCodigo){
		
		window.opener.document.getElementById('txtCodigo').value = intCodigo;
		window.opener.document.getElementById('frm').submit();
		window.close();
	}
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<form method="POST" id="frm" action="#">
<%
strAnoLetivo 	= request("txtAnoLetivo")
intSemestre 	= request("cmbSemestre")
if intSemestre = "" then intSemestre = 0
strSituacao 	= request("cmbSituacao")
if strSituacao = "" then strSituacao = "A"
%>
  <table width="100%" align="left" class="CorFundo" >
    <tr>
      <td width="100%" height="85" align="center">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" align="center" class="tituloPrincipal">Consulta Grade Curricular </td>
          </tr>
          <tr>
            <td><span class="texto1">Ano: </span></td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td width="84"><span class="texto1">Semestre: </span></td>
            <td width="393"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
		   <tr>
            <td width="84"><span class="texto1">Situação: </span></td>
            <td width="393">
            <select name="cmbSituacao" id="cmbSituacao" style="width:150pt" class="combo" >
                <option <% if strSituacao = "A" then response.write "selected"%> value="A">Ativo</option>
                <option <% if strSituacao = "I" then response.write "selected"%> value="I">Inativo</option>
            </select>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_consulta.asp"--></td>
          </tr>
        </table>
		<br>
		<table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		  <tr bgcolor="#E5E5E5">
			<td class="TextoForm"><strong>C&oacute;digo</strong></td>
			<td width="36%" bgcolor="#E5E5E5" class="TextoForm"><strong>Curso</strong></td>
			<td width="31%" bgcolor="#E5E5E5" class="TextoForm"><strong>Perido</strong></td>
			<td width="5%" bgcolor="#E5E5E5" class="TextoForm"><strong>Situação</strong></td>
			<td width="8%" bgcolor="#E5E5E5" class="TextoForm"><strong>Ano</strong></td>
			<td width="10%" bgcolor="#E5E5E5" class="TextoForm"><strong>Semestre </strong></td>
		  </tr>
		  <%
			cont =0

			sql = "SELECT     	SCA_GRADECURRICULAR.Cod_Empresa, SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_PERIODO.Cod_Curso, "
			sql = sql & "     	SCA_CURSO.Descricao as descCurso, SCA_GRADECURRICULAR.Cod_Periodo, SCA_PERIODO.Descricao, "
			sql = sql & " 	  	SCA_GRADECURRICULAR.AnoReferencia, SCA_GRADECURRICULAR.SemestreReferencia, SCA_GRADECURRICULAR.Situacao"
			sql = sql & " FROM  SCA_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
			sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso			"
			sql = sql & " where SCA_GRADECURRICULAR.cod_empresa = " & Session("CodEmpresa")	
			if strAnoLetivo <> "0" and strAnoLetivo <> ""  then
				sql = sql & " and SCA_GRADECURRICULAR.AnoReferencia = " & strAnoLetivo
			end if
			if intSemestre <> "0" and intSemestre <> "" then
				sql = sql & " and SCA_GRADECURRICULAR.SemestreReferencia = " & intSemestre
			end if
			if strSituacao <> "" then
				sql = sql & " and SCA_GRADECURRICULAR.situacao = '" & strSituacao & "'"
			end if
			sql = sql & " ORDER BY SCA_PERIODO.Cod_Curso, 	SCA_PERIODO.Descricao"	
			rs.open sql, cnn
				
			if rs.eof = false then

				while not rs.eof
					cont = cont + 1	
					Semestre = rs("SemestreReferencia")
					
					if Semestre = "1" then Semestre = "1º Semestre"
					if Semestre = "2" then Semestre = "2º Semestre"
					if Semestre = "3" then Semestre = "Anual"
					
					if trim(rs("Situacao")) = "A" then
						strSituacao = "Ativo"
					else
						strSituacao = "Inativo"
					end if
					%>
					  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Cod_GradeCurricular")%>')">
               			<td width="10%" height="24" class="Texto">&nbsp;<%=rs("Cod_GradeCurricular")%></td>
						<td class="Texto">&nbsp;<%=rs("descCurso")%></td>
						<td class="Texto"><%=rs("Descricao")%></td>
						<td class="Texto">&nbsp;<%=strSituacao%></td>
						<td class="Texto">&nbsp;<%=rs("AnoReferencia")%></td>
						<td class="Texto">&nbsp;<%=Semestre%></td>
					  </tr>
					<%				
				rs.movenext
				wend
				%>
				<tr> 
				<td height="21" colspan="7" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
				<%
			end if
			rs.close
			%>
	</table>
	</td> 
    </tr>
  </table>
</form>
</body>
</html>
