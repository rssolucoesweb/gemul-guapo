<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 24/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Ocorrencia 
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
//-->
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function resultadoConsulta(intCodigo){
	
		window.opener.document.getElementById('txtCodigo').value = intCodigo;
		window.opener.document.getElementById('frm').submit();
		window.close();
	}
</script>
<%
    strExecutarSubmitSemestre    = "S"
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	strDepartamento		= Trim(Request("cmbDepartamento"))
	strAluno			= Trim(Request("txtAluno"))
%>
<form method="POST" id="frm" action="#">
<input name="cmbDepartamento" type="hidden" id="cmbDepartamento"  value="<%=strDepartamento%>" />
  <table width="100%" align="left" class="CorFundo" >
    <tr>
      <td width="486" height="85" align="center">
	  <table width="477" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" align="center" class="tituloPrincipal">Consulta de Ocorr&ecirc;ncia </td>
          </tr>
          <tr>
            <td><span class="texto1">Ano Letivo:</span></td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td width="125"><span class="texto1">Semestre:</span></td>
            <td width="352"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Nome do Aluno:   </span></td>
            <td><input name="txtAluno" type="text" class="text" id="txtAluno" size="50" maxlength="50" value="<%=strAluno%>" /></td>
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
		<table width = "484" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		  <tr bgcolor="#E5E5E5">
		    <td class="TextoForm"><strong>C&oacute;d. Ocorr&ecirc;ncia </strong></td>
			<td class="TextoForm"><strong>Matr&iacute;cula</strong></td>
			<td class="TextoForm"><strong>Aluno</strong></td>
			<td bgcolor="#E5E5E5" class="TextoForm"><strong>Data Ocorr&ecirc;ncia </strong><strong></strong></td>
		  </tr>
		  <%
			cont =0
			
			sql = "SELECT O.COD_OCORRENCIA, O.COD_DEPARTAMENTO, O.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, O.DATAOCORRENCIA"
			sql = sql & " FROM SCA_OCORRENCIA O"
			sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = O.COD_ALUNO"
			sql = sql & " where O.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and O.COD_DEPARTAMENTO = " & strDepartamento	
			sql = sql & " and O.ano_letivo = " & strAnoLetivo
			sql = sql & " and O.semestre in (" & intSemestre & ")"
			IF trim(strAluno) <> "" then
				sql = sql & " AND A.NOMEALUNO LIKE '" & strAluno & "%'"
			END IF
			sql = sql & " order by O.DATAOCORRENCIA DESC"
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
					cont = cont + 1	
					%>
					  <tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  onClick="return resultadoConsulta('<%=rs("COD_OCORRENCIA")%>')">
					    <td width="23%" class="Texto">&nbsp;<%=trim(rs("COD_OCORRENCIA"))%></td>
						<td width="19%" height="26" class="Texto">&nbsp;<%=trim(rs("MATRICULA"))%></td>
						<td width="19%" height="26" class="Texto">&nbsp;<%=trim(rs("NOMEALUNO"))%></td>
						<td class="Texto">&nbsp;<%=formatadataap(trim(rs("DATAOCORRENCIA")))%></td>
					  </tr>
					<%				
				rs.movenext
				wend
				%>
				<tr> 
				<td height="21" colspan="5" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
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
